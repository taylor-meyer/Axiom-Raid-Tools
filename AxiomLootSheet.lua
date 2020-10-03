------------------------------------------------------------------------------------------
-- AxiomLootSheet --
--------------------
-- Author: Lypidius <Axiom> @ US-MoonGuard
------------------------------------------------------------------------------------------

NameBoxes = {}
MainSpecBoxes = {}
OffSpecBoxes = {}
TransmogBoxes = {}

RowsShowing = 0

LootRows = {}
LootRowsUsed = 0

LootNames = {}
LootItemFrames = {}
LootItemStrings = {}
LootCheckButtons = {}
LootItemLinks = {}

CountdownTimer = 5

print("Running AxiomLootSheet v1.4.1")
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Saved Variables --
------------------------------------------------------------------------------------------
local SavedVariablesFrame = CreateFrame("Frame")
SavedVariablesFrame:RegisterEvent("ADDON_LOADED")
SavedVariablesFrame:RegisterEvent("PLAYER_LOGOUT")
SavedVariablesFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "AxiomLootSheet" then
		-- Our saved variables have been loaded
		if NameStrings == nil then
			-- This is the first time this addon is loaded; set SVs to default values
			NameStrings = {}
			MainSpecCount = {}
			OffSpecCount = {}
			TransmogCount = {}
			for i=1, 20 do
				NameStrings[i] = ""
				MainSpecCount[i] = ""
				OffSpecCount[i] = ""
				TransmogCount[i] = ""
			end
		else
			LoadSavedStrings()
		end
	elseif event == "PLAYER_LOGOUT" then
            -- Save the values when player logout/reload
			LoadSavedStrings()
			SaveStrings()
	end
end)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Slash Commands --
------------------------------------------------------------------------------------------
SLASH_SPREADSHEET1 = "/axiom"
SlashCmdList["SPREADSHEET"] = function(msg, editBox)
	if msg == "loots" then
		print("called loots")
		if LootResults:IsVisible() then
			LootResults:Hide()
		else
			LootResults:Show()
		end
	else
		if LootSheet:IsVisible() then
			LootSheet:Hide()
		else
			print("Here is your loot sheet, sir Punk.")
			LootSheet:Show()
		end
	end
end
------------------------------------------------------------------------------------------

function CreateLootSheet()
	local f = CreateFrame("Frame", "LootSheet", UIParent)
			f:SetPoint("TOP", 0, -25)
			f:SetSize(270, 70)
			f:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
				})
			f:SetBackdropBorderColor(1, 0, 0, .5)
			f:SetMovable(true)
			f:SetClampedToScreen(true)
			f:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" then
					self:StartMoving()
				end
			end)
			f:SetScript("OnMouseUp", f.StopMovingOrSizing)
			
			CreateNewRowButton()
			CreateRemoveRowButton()
			CreateNameBoxes()
			CreateMainSpecBoxes()
			CreateOffSpecBoxes()
			CreateTransmogBoxes()
			CreateCloseButton()
			CreateClearButton()
			
			local title_name = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_name:SetPoint("TOP", NameBoxes[1], "TOP", 0, 10)
			title_name:SetText("Name")
			
			local title_mainspec = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_mainspec:SetPoint("TOP", MainSpecBoxes[1], "TOP", 0, 10)
			title_mainspec:SetText("MS")
			
			local title_offspec = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_offspec:SetPoint("TOP", OffSpecBoxes[1], "TOP", 0, 10)
			title_offspec:SetText("OS")
	
			local title_tmog = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_tmog:SetPoint("TOP", TransmogBoxes[1], "TOP", 0, 10)
			title_tmog:SetText("TMOG")
			
			f:Hide()
end

function CreateNameBoxes()
	for i=1, 20 do
		if i == 1 then
			NameBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			NameBoxes[i]:SetPoint("TOPLEFT", LootSheet, "TOPLEFT", 15, -25)
		else
			NameBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			NameBoxes[i]:SetPoint("TOP", NameBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		NameBoxes[i]:SetSize(100, 40)
		NameBoxes[i]:SetMultiLine(false)
		NameBoxes[i]:SetAutoFocus(false)
		NameBoxes[i]:SetFontObject("ChatFontNormal")
		NameBoxes[i]:SetMaxLetters(12)
		NameBoxes[i]:SetTextInsets(12, 0, 0, 0)
		NameBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		NameBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		NameBoxes[i]:Hide()
		
		NameBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			MainSpecBoxes[i]:SetFocus()
		end)
	end
end

function CreateMainSpecBoxes()
	for i=1, 20 do
		if i == 1 then
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			MainSpecBoxes[i]:SetPoint("LEFT", NameBoxes[i], "RIGHT", 5, 0)
		else
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			MainSpecBoxes[i]:SetPoint("TOP", MainSpecBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		MainSpecBoxes[i]:SetSize(40, 40)
		MainSpecBoxes[i]:SetTextInsets(20, 0, 0, 0)
		MainSpecBoxes[i]:SetMultiLine(false)
		MainSpecBoxes[i]:SetAutoFocus(false)
		MainSpecBoxes[i]:SetFontObject("ChatFontNormal")
		MainSpecBoxes[i]:SetMaxLetters(2)
		MainSpecBoxes[i]:SetTextInsets(14, 0, 0, 0)
		MainSpecBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		MainSpecBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		MainSpecBoxes[i]:Hide()
		
		MainSpecBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			OffSpecBoxes[i]:SetFocus()
		end)
	end
end

function CreateOffSpecBoxes()
	for i=1, 20 do
		if i == 1 then
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			OffSpecBoxes[i]:SetPoint("LEFT", MainSpecBoxes[i], "RIGHT", 5, 0)
		else
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			OffSpecBoxes[i]:SetPoint("TOP", OffSpecBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		OffSpecBoxes[i]:SetSize(40, 40)
		OffSpecBoxes[i]:SetMultiLine(false)
		OffSpecBoxes[i]:SetAutoFocus(false)
		OffSpecBoxes[i]:SetFontObject("ChatFontNormal")
		OffSpecBoxes[i]:SetMaxLetters(2)
		OffSpecBoxes[i]:SetTextInsets(14, 0, 0, 0)
		OffSpecBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		OffSpecBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		OffSpecBoxes[i]:Hide()
		
		OffSpecBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			TransmogBoxes[i]:SetFocus()
		end)
	end
end

function CreateTransmogBoxes()
	for i=1, 20 do
		if i == 1 then
			TransmogBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			TransmogBoxes[i]:SetPoint("LEFT", OffSpecBoxes[i], "RIGHT", 5, 0)
		else
			TransmogBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			TransmogBoxes[i]:SetPoint("TOP", TransmogBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		TransmogBoxes[i]:SetSize(40, 40)
		TransmogBoxes[i]:SetMultiLine(false)
		TransmogBoxes[i]:SetAutoFocus(false)
		TransmogBoxes[i]:SetFontObject("ChatFontNormal")
		TransmogBoxes[i]:SetMaxLetters(2)
		TransmogBoxes[i]:SetTextInsets(14, 0, 0, 0)
		TransmogBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		TransmogBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		TransmogBoxes[i]:Hide()
		
		if i < 20 then
			TransmogBoxes[i]:SetScript("OnTabPressed", function(self)
				-- tab over
				NameBoxes[i+1]:SetFocus()
			end)
		end
	end
end

function CreateNewRowButton()
	local button = CreateFrame("Button", "AddRowButton", LootSheet, "UIPanelButtonTemplate")
			button:SetPoint("RIGHT", LootSheet, "TOPLEFT", 5, -17)
			button:SetSize(25, 25)
			button:SetText("+")
			button:SetScript('OnClick', function()
				ShowRow(RowsShowing+1)
			end)
end

function CreateRemoveRowButton()
	local button = CreateFrame("Button", "RemoveRowButton", LootSheet, "UIPanelButtonTemplate")
			button:SetPoint("TOP", AddRowButton, "BOTTOM", 0, 0)
			button:SetSize(25, 25)
			button:SetText("-")
			button:SetScript('OnClick', function()
				HideRow(RowsShowing)
			end)
end

function ShowRow(i)
	if i < 21 then
		LootSheet:SetHeight(LootSheet:GetHeight() + 40);
		NameBoxes[i]:Show()
		MainSpecBoxes[i]:Show()
		OffSpecBoxes[i]:Show()
		TransmogBoxes[i]:Show()
		RowsShowing = RowsShowing + 1
	end
end

function HideRow(i)
	if i > 0 then
		LootSheet:SetHeight(LootSheet:GetHeight() - 40);
		NameBoxes[i]:Hide()
		MainSpecBoxes[i]:Hide()
		OffSpecBoxes[i]:Hide()
		TransmogBoxes[i]:Hide()
		RowsShowing = RowsShowing - 1
	end
end

function CreateCloseButton()
	local button = CreateFrame("Button", "CloseButton", LootSheet, "UIPanelButtonTemplate")
	button:SetPoint("BOTTOM", LootSheet, "BOTTOM", -70, 10)
	button:SetSize(50, 30)
	button:SetText("Close")
	button:SetScript("OnClick", function()
		SaveStrings()
		LootSheet:Hide()
	end)
end

function CreateClearButton()
	local button = CreateFrame("Button", "ClearButton", LootSheet, "UIPanelButtonTemplate")
	button:SetPoint("LEFT", CloseButton, "RIGHT", 75, 0)
	button:SetSize(50, 30)
	button:SetText("Clear")
	button:SetScript("OnClick", function()
		StaticPopupDialogs["CLEAR_SHEET"] = {
			text = "Wipe loot sheet (all data will enter The Maw)?",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				ClearAllRows()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		StaticPopup_Show ("CLEAR_SHEET")
	end)
end

function SaveStrings()
	for i=1, 20 do
		NameStrings[i] = NameBoxes[i]:GetText()
		MainSpecCount[i] = MainSpecBoxes[i]:GetText()
		OffSpecCount[i] = OffSpecBoxes[i]:GetText()
		TransmogCount[i] = TransmogBoxes[i]:GetText()
	end
end

function LoadSavedStrings()
	for i=1,20 do
		NameBoxes[i]:SetText(NameStrings[i])
		MainSpecBoxes[i]:SetText(MainSpecCount[i])
		OffSpecBoxes[i]:SetText(OffSpecCount[i])
		TransmogBoxes[i]:SetText(TransmogCount[i])
	end
end

function ClearAllRows()
	for i=1,20 do
		NameBoxes[i]:SetText("")
		MainSpecBoxes[i]:SetText("")
		OffSpecBoxes[i]:SetText("")
		TransmogBoxes[i]:SetText("")
	end
end

------------------------------------------------------------------------------------------

function CreateLootResultsFrame()
	local f = CreateFrame("Frame", "LootResults", UIParent)
	f:SetPoint("CENTER")
	f:SetSize(450, 875)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
		edgeSize = 16,
		insets = { left = 8, right = 6, top = 8, bottom = 8 },
	})
	f:SetBackdropBorderColor(1, 0, 0, .5)
	
	-- Close button
	local button = CreateFrame("Button", "LootResultsCloseButton", f)
	button:SetHeight(25)
	button:SetWidth(25)
	button:SetPoint("TOPRIGHT", -10, -10)
	button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
	button:SetScript("OnClick", function(self) self:GetParent():Hide() end)
	
	-- Title text
	local text = LootResults:CreateFontString(LootResultsTitleText, "OVERLAY", "GameFontNormal")
	text:SetPoint("TOP", 0, -25)
	text:SetText("ENCOUNTER LOOT!")
	
	-- Moveable
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			self:StartMoving()
		end
	end)
	f:SetScript("OnMouseUp", LootResults.StopMovingOrSizing)
	
	-- Events
	f:RegisterEvent("BOSS_KILL")
	f:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
	
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "BOSS_KILL" then
			ClearLootRows()
			f:Show()
		elseif event == "ENCOUNTER_LOOT_RECEIVED" then
			local encounterID, itemID, itemLink, quantity, itemName, fileName = ...
			local i = LootRowsUsed + 1
			LootRowsUsed = LootRowsUsed + 1
			--print("i: " .. i)
			--print("LRU: " .. LootRowsUsed)
			LootItemLinks[i] = itemLink
			if i < 25 then
				s = strsub(itemName, 1, 12)
				print("Player that got loot: " .. itemName .. " SubStr: " .. s)
				LootNames[i]:SetText(s)
				LootItemStrings[i]:SetText(itemLink)
				LootItemFrames[i]:HookScript("OnEnter", function()
					if (itemLink) then
						GameTooltip:SetOwner(f, "ANCHOR_TOP")
						GameTooltip:SetHyperlink(itemLink)
						GameTooltip:Show()
					end
				end)
				LootItemFrames[i]:HookScript("OnLeave", function()
					GameTooltip:Hide()
				end)
			end
		end
	end)
	
	CreateRows()
	CreateLootAnnounceButton()
	CreateRollMainSpecButton()
	CreateRollOffSpecButton()
	CreateRollTransmogSpecButton()
	CreateCountdownButton()
	
	f:Hide()
end

function CreateRows()

	--local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
	--local _, itemLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)

	for i=1,25 do
	
		local row = CreateFrame("Frame", "Row " .. i, LootResults)
		row:SetPoint("TOPLEFT", 10, -5 - (30 * i))
		row:SetSize(415, 40)
		row:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		row:SetBackdropBorderColor(1, 0, 0, 0)
		-----------------------------------------------------------------------------------------
		
		local name = row:CreateFontString("NameFontString" .. i, "OVERLAY", "GameFontNormal")
		name:SetPoint("LEFT", 10, 0)
		--name:SetText()
		-----------------------------------------------------------------------------------------
		
		-- Item frame size is big enough to encompass: "Merciless Gladiator's Crossbow of the Phoenix"
		--	(the longest item name in the game)
		local f = CreateFrame("Frame", "ItemFrame" .. i, row)
		f:SetPoint("LEFT", name, "RIGHT", 0, 0)
		f:SetSize(300,40)
		--[[
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		f:SetBackdropBorderColor(1, .6, 0, 1)
		--]]
		-----------------------------------------------------------------------------------------
		
		local s = f:CreateFontString("ItemString" .. i, "OVERLAY", "GameFontNormal")
		s:SetPoint("LEFT", 10, 0)
		--s:SetText(itemLink)
		--s:SetText("[Merciless Gladiator's Crossbow of the Phoenix]")
		
		-- Mouse over script
		-- TODO: change this such that mouse over only works on the text itself,
		--			not the entire background frame "ItemFrame" above
		--[[
		f:HookScript("OnEnter", function()
			if (itemLink) then
				GameTooltip:SetOwner(f, "ANCHOR_TOP")
				GameTooltip:SetHyperlink(itemLink)
				GameTooltip:Show()
			end
		end)
		 
		f:HookScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		--]]
		-----------------------------------------------------------------------------------------
		
		
		local c = CreateFrame("CheckButton", "LootCheckButton"  .. i, row, "ChatConfigCheckButtonTemplate")
		c:SetPoint("RIGHT", 17, 0)
		c.tooltip = "Up for roll"
		c:SetChecked(false)
		c:HookScript("OnClick", function()
			-- do stuff
			--print("CheckButton clicked")
		end)
		
		LootNames[i] = name
		LootItemFrames[i] = f
		LootItemStrings[i] = s
		LootCheckButtons[i] = c
		LootRows[i] = row
	end
end

function CreateLootAnnounceButton()
	local button = CreateFrame("Button", "AnnounceButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("BOTTOM", 0, 20)
	button:SetSize(80, 40)
	button:SetText("Announce")
	button:SetScript("OnClick", function()
		--print("Loot announce clicked")
		-- announce loop
	   for i=1,25 do
			if LootCheckButtons[i]:GetChecked() == true then
				SendChatMessage(LootItemLinks[i], "RAID_WARNING", nil, "channel")
			end
	   end
	end)
end

function CreateRollMainSpecButton()
	local button = CreateFrame("Button", "MainSpecRollButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("BOTTOMLEFT", AnnounceButton, "TOPLEFT", 0, 0)
	button:SetSize(35, 25)
	button:SetText("MS")
	button:SetScript("OnClick", function()
		--print("Roll MS clicked")
		for i=1,25 do
			if LootCheckButtons[i]:GetChecked() == true then
				SendChatMessage("ROLL FOR MS: " .. LootItemLinks[i], "RAID_WARNING", nil, "channel")
				break;
			end
		end
	end)
end

function CreateRollOffSpecButton()
	local button = CreateFrame("Button", "OffSpecRollButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("LEFT", MainSpecRollButton, "RIGHT", 0, 0)
	button:SetSize(35, 25)
	button:SetText("OS")
	button:SetScript("OnClick", function()
		--print("Roll OS clicked")
		for i=1,25 do
			if LootCheckButtons[i]:GetChecked() == true then
				SendChatMessage("ROLL FOR OS: " .. LootItemLinks[i], "RAID_WARNING", nil, "channel")
				break;
			end
		end
	end)
end

function CreateRollTransmogSpecButton()

	local button = CreateFrame("Button", "TransmogRollButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("LEFT", OffSpecRollButton, "RIGHT", 0, 0)
	button:SetSize(35, 25)
	button:SetText("TM")
	button:SetScript("OnClick", function()
		--print("Roll TM clicked")
		for i=1,25 do
			if LootCheckButtons[i]:GetChecked() == true then
				SendChatMessage("ROLL FOR TMOG: " .. LootItemLinks[i], "RAID_WARNING", nil, "channel")
				break;
			end
		end
	end)
end

function CreateCountdownButton()
	local button = CreateFrame("Button", "CountdownButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("LEFT", AnnounceButton, "RIGHT", 0, 0)
	button:SetPoint("TOPRIGHT", TransmogRollButton, "BOTTOMRIGHT", 0, 0)
	button:SetSize(35, 40)
	button:SetText("5")
	button:SetScript("OnClick", function()
		inInstance, instanceType = IsInInstance()
		--print(inInstance)
		if inInstance == false then
			print("Not in an instance!")
		elseif instanceType ~= "raid" then
			print("Not in a raid!")
		else
			Countdown()
			C_Timer.After(6, function() CountdownTimer = 5 end)
		end
	end)
end

function Countdown()
	SendChatMessage(CountdownTimer, "RAID_WARNING", nil, "channel");
	if CountdownTimer ~=1 then
		CountdownTimer = CountdownTimer - 1
		C_Timer.After(1, Countdown)
	end
end

function ClearLootRows()
	LootRowsUsed = 0
	for i=1,25 do
		LootNames[i]:SetText("")
		LootItemStrings[i]:SetText("")
		--TODO: uncheck check button
	end
end

function AnnounceLoot()

end

------------------------------------------------------------------------------------------

CreateLootSheet()
CreateLootResultsFrame()

--[=====[ 
-- Code I found online to generate an itemLink from the equipped mainhand weapon
	local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
	local _, itemLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)
-- send it to chat window to test it works and it does, you can click it in the window and see the item
	DEFAULT_CHAT_FRAME:AddMessage(itemLink)
--]=====]

-- How to get size of a table if I need it
--print("Table size: " .. (table.getn(ItemLinkTable)))
