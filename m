Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbYDNWr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbYDNWr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYDNWrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:47:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36599 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYDNWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:47:13 -0400
Date: Tue, 15 Apr 2008 00:47:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: add softmac interface
Message-ID: <20080414224740.GA31431@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This adds softmac interface to w35und driver... so it becomes monster
driver with _two_ interfaces.

If you initialize hardmac interface, then softmac starts to
works... it associates to AP, and can even ping.

(Or at least I hope so... it was somewhat too easy.)

								Pavel

diff --git a/drivers/net/wireless/winbond/winbondport/adapter.h b/drivers/net/wireless/winbond/winbondport/adapter.h
index 64585c5..81e7bd8 100644
--- a/drivers/net/wireless/winbond/winbondport/adapter.h
+++ b/drivers/net/wireless/winbond/winbondport/adapter.h
@@ -19,7 +19,7 @@ typedef struct WB32_ADAPTER
 	TESTSTA				sTestSta; // For test station
 
 	WBLINUX		WbLinux;
-	WB_STA_WPA_DESCRIPTION Global_STA_Wpa;//For WB_WPA
+	WB_STA_WPA_DESCRIPTION Global_STA_Wpa;
         struct iw_statistics iw_stats;
 
 	u8	LinkName[MAX_ANSI_STRING];
diff --git a/drivers/net/wireless/winbond/winbondport/gl_80211.h b/drivers/net/wireless/winbond/winbondport/gl_80211.h
index 8cda514..7828573 100644
--- a/drivers/net/wireless/winbond/winbondport/gl_80211.h
+++ b/drivers/net/wireless/winbond/winbondport/gl_80211.h
@@ -5,8 +5,7 @@ #define __GL_80211_H__
 /****************** CONSTANT AND MACRO SECTION ******************************/
 
 /* BSS Type */
-enum
-{
+enum {
     WLAN_BSSTYPE_INFRASTRUCTURE         = 0,
     WLAN_BSSTYPE_INDEPENDENT,
     WLAN_BSSTYPE_ANY_BSS,
@@ -15,29 +14,25 @@ enum
 
 
 /* Preamble_Type, see <SFS-802.11G-MIB-203> */
-typedef enum preamble_type
-{
+typedef enum preamble_type {
     WLAN_PREAMBLE_TYPE_SHORT,
     WLAN_PREAMBLE_TYPE_LONG,
 }    preamble_type_e;
 
 
 /* Slot_Time_Type, see <SFS-802.11G-MIB-208> */
-typedef enum slot_time_type
-{
-    WLAN_SLOT_TIME_TYPE_LONG,   // TODO: 0627 kevin
+typedef enum slot_time_type {
+    WLAN_SLOT_TIME_TYPE_LONG,
     WLAN_SLOT_TIME_TYPE_SHORT,
 }    slot_time_type_e;
 
 /*--------------------------------------------------------------------------*/
 /* Encryption Mode */
-typedef enum
-{
+typedef enum {
     WEP_DISABLE                                         = 0,
     WEP_64,
     WEP_128,
 
-        // TODO: for _WPA_SUPPORTED_ (0627 kevin)
     ENCRYPT_DISABLE,
     ENCRYPT_WEP,
     ENCRYPT_WEP_NOKEY,
@@ -45,24 +40,17 @@ typedef enum
     ENCRYPT_TKIP_NOKEY,
     ENCRYPT_CCMP,
     ENCRYPT_CCMP_NOKEY,
-
-        //#ifdef _WPA_SUPPORTED_
-    //    RSN_TKIP,
-    //    RSN_CCMP,
-    //#endif // _WPA_SUPPORTED_
 }    encryption_mode_e;
 
-typedef enum _WLAN_RADIO
-{
+typedef enum _WLAN_RADIO {
     WLAN_RADIO_ON,
     WLAN_RADIO_OFF,
     WLAN_RADIO_MAX, // not a real type, defined as an upper bound
 } WLAN_RADIO;
 
-typedef struct _WLAN_RADIO_STATUS
-{
+typedef struct _WLAN_RADIO_STATUS {
 	WLAN_RADIO HWStatus;
-    WLAN_RADIO SWStatus;
+	WLAN_RADIO SWStatus;
 } WLAN_RADIO_STATUS;
 
 //----------------------------------------------------------------------------
@@ -93,11 +81,9 @@ typedef enum _WLAN_REGION_CODE
 	WLAN_REGION_FRANCE,
 	WLAN_REGION_SPAIN,
 	WLAN_REGION_ISRAEL,
-	//WLAN_REGION_CANADA,
 	WLAN_REGION_MAX, // not a real type, defined as an upper bound
 } WLAN_REGION_CODE;
 
-//#define REGION_NAME_MAX_LENGTH   32
 #define REGION_NAME_MAX_LENGTH   256
 
 typedef struct _WLAN_REGION_CHANNELS
@@ -115,7 +101,6 @@ typedef struct _WLAN_REGION_CAPABILITIES
 	WLAN_REGION_CHANNELS Region[1];
 } WLAN_REGION_CAPABILITIES;
 
-// 20041103 1.1.91.1000 ybjiang
 typedef struct _region_name_map {
 	WLAN_REGION_CODE region;
 	u8 *name;
diff --git a/drivers/net/wireless/winbond/winbondport/gui_structures.h b/drivers/net/wireless/winbond/winbondport/gui_structures.h
index 1b83adb..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/gui_structures.h
+++ b/drivers/net/wireless/winbond/winbondport/gui_structures.h
@@ -1,315 +0,0 @@
-////////////////////////////////////////////////////////////////////////////
-//
-// GUI_Structures.h
-//
-// This file contains the definitions and data structures used by GUI
-//
-// 10/31/02' initial version
-// 7/15/03' modified by PD50(version wb32mmi_0611)  
-////////////////////////////////////////////////////////////////////////////
-
-#ifndef _GUI_Structures_H_
-#define _GUI_Structures_H_
-
-// Some miscellaneous definitions
-#define   MAC_ADDR_LENGTH               6
-#define   MAX_CHANNELS                  30
-#define   GUI_MAX_BSS_DESCRIPTIONS      24
-
-// Define BSSType
-#define   GUI_INFRASTRUCTURE            0
-#define   GUI_INDEPENDENT               1
-#define   GUI_ANY_BSS                   2
-
-#ifdef _OLD_SW_MAC_
-// Define STAState
-#define  GUI_BSS_STATE_NOSCAN           0
-#define  GUI_BSS_STATE_SCANNING         1
-#define  GUI_BSS_STATE_IN_JOIN          2
-#define  GUI_BSS_STATE_BSS              3
-#define  GUI_BSS_STATE_AUTHEN           4
-#define  GUI_BSS_STATE_ASSOC            5
-#define  GUI_BSS_STATE_IBSS             6
-
-#else
-//state of SME module
-#define DISABLED						0
-#define INIT_SCAN						1
-#define SCAN_READY						2
-#define START_IBSS						3
-#define JOIN_PENDING					4
-#define JOIN_CFM						5
-#define AUTHENTICATE_PENDING			6
-#define AUTHENTICATED					7
-#define CONNECTED						8
-//#define EAP_STARTING					9
-//#define EAPOL_AUTHEN_PENDING			10
-//#define SECURE_CONNECTED				11
-
-#endif
-
-// Define scan type
-#define  GUI_ST_ACTIVE                  0
-#define  GUI_ST_PASSIVE                 1
-
-// Define TxRate
-#define  GUI_TXRATE_1M                  0
-//#define  GUI_TXRATE_0M                1
-#define  GUI_TXRATE_2MLONG              2
-#define  GUI_TXRATE_2MSHORT             3
-#define  GUI_TXRATE_55MLONG             4
-#define  GUI_TXRATE_55MSHORT            5
-#define  GUI_TXRATE_11MLONG             6
-#define  GUI_TXRATE_11MSHORT            7
-#define  GUI_TXRATE_AUTO                255
-
-// Define Basic Tx Rate Set
-#define  GUI_BASIC_TXRATE_1M                0x82
-#define  GUI_BASIC_TXRATE_2M                0x84
-#define  GUI_BASIC_TXRATE_5_5M              0x8b
-#define  GUI_BASIC_TXRATE_11M               0X96
-
-#define  GUI_OPERATION_TXRATE_1M                0x2
-#define  GUI_OPERATION_TXRATE_2M                0x4
-#define  GUI_OPERATION_TXRATE_5_5M              0xb
-#define  GUI_OPERATION_TXRATE_11M               0x16
-
-// Define Extended supported rates Set for 802.11g
-#define  GUI_EXTENDED_TXRATE_22M             0x2c
-#define  GUI_EXTENDED_TXRATE_33M             0x42
-#define  GUI_EXTENDED_TXRATE_6M              0x0c
-#define  GUI_EXTENDED_TXRATE_9M              0x12
-#define  GUI_EXTENDED_TXRATE_12M             0x18
-#define  GUI_EXTENDED_TXRATE_18M             0x24
-#define  GUI_EXTENDED_TXRATE_24M             0x30
-#define  GUI_EXTENDED_TXRATE_36M             0x48
-#define  GUI_EXTENDED_TXRATE_48M             0x60
-#define  GUI_EXTENDED_TXRATE_54M             0x6c
-
-// select tx rate automatically
-#define GUI_ALL_TXRATE                     0x00
-
-
-//New added for b+g
-#define GUI_MODE_802_11_BG			0
-#define GUI_MODE_802_11_A			1
-#define GUI_MODE_802_11_ABG			2
-#define GUI_MODE_802_11_BG_IBSS		3
-
-typedef struct _GUIScanPara
-{
-  BYTE       BSSType;
-  BYTE       BSSID[MAC_ADDR_LENGTH];
-  BYTE       SSID[33];                  // 0x00 as terminated
-  BYTE       ScanType;
-  WORD       ProbeDelay;
-  BYTE       ChannelList[MAX_CHANNELS];
-  WORD       MinChannelTime;
-  WORD       MaxChannelTime;
-  unsigned char      boUseFastScanOption;
-
-} GUIScanPara, *psGUIScanPara;
-
-typedef struct _GUIBssDescriptElement
-{
-   BYTE      Timestamp[8];              // 8 octets
-   WORD      Beacon_Period;             // 2 octets
-   WORD      CapabilityInformation;     // 2 octets
-   BYTE      BSSID[MAC_ADDR_LENGTH];
-   BYTE      SSID[33];                  // 0x00 as terminated
-   BYTE      BSSType;
-   BYTE      DTIM_Period;               // 1 octet
-   BYTE      Local_Time[8];             // 8 octets
-   WORD      CFP_MaxDuration;           // in Time Units
-   WORD      ATIM_Window;               // IBSS_Parameter_Set_Element
-   BYTE      BSSBasicRateSet[9];        // end with zero
-   BYTE      Current_Channel;           // DS_Parameter_Set_Element
-   DWORD	 Rssi;						// RSSI information. -10(Good) ~ -200(Bad)
-} GUIBssDescriptElement, *psGUIBssDescriptElement;
-
-typedef struct _GUIBssList
-{
-   WORD      NumberOfItems;
-   GUIBssDescriptElement BSS[GUI_MAX_BSS_DESCRIPTIONS];
-
-} GUIBssList, *psGUIBssList;
-
-/*
-typedef struct _GUIStartPara
-{
-  BYTE       SSID[33];                  // 0x00 as terminated
-  WORD       BeaconPeriod;
-  BYTE       Current_Channel;           // DS_Parameter_Set_Element
-  WORD       ATIM_Window;               // IBSS_Parameter_Set_Element
-  BYTE       BSSBasicRateSet[9];        // end with \x00
-  BYTE       OperationalRateSet[9];     // End with \x00
-
-} GUIStartPara, *psGUIStartPara;
-*/
-
-// Expend rate set for 802.11g
-#define MAX_BASIC_RATE_SET          15
-#define MAX_OPT_RATE_SET            MAX_BASIC_RATE_SET
-typedef struct _GUIStartPara
-{
-  BYTE       SSID[33];                  // 0x00 as terminated
-  WORD       BeaconPeriod;
-  BYTE       Current_Channel;           // DS_Parameter_Set_Element
-  WORD       ATIM_Window;               // IBSS_Parameter_Set_Element
-  BYTE       BSSBasicRateSet   [MAX_BASIC_RATE_SET];   // end with \x00
-  BYTE       OperationalRateSet[MAX_OPT_RATE_SET];     
-
-} GUIStartPara, *psGUIStartPara;
-
-
-struct Reason_Code
-{
-  BYTE       PeerSTAAddr[MAC_ADDR_LENGTH];
-  WORD       ReasonCode;
-};
-
-typedef struct AuthenReq_Parameter
-{
-  BYTE       PeerSTAAddr[MAC_ADDR_LENGTH];
-  BYTE       AuthenType;
-  DWORD      AuthenFailTimeOut;         // TU
-
-} GUIAuthenReqPara, *psGUIAuthenReqPara;
-
-// AuthenType
-#define AUTH_OPEN_SYSTEM		0
-#define AUTH_SHARED_KEY			1
-
-typedef struct Reason_Code GUIDeAuthenReqPara, *psGUIDeAuthenReqPara;
-
-/*
-typedef struct AssocReq_Parameter
-{
-  BYTE       PeerSTAAddr[MAC_ADDR_LENGTH];
-  WORD       AssocFailTimeOut;              // TU
-  WORD       CapabilityInfo;
-  WORD       ListenInterval;                // no. of beacon intervals
-
-} GUIAssocReqPara, *psGUIAssocReqPara;
-*/
-
-
-// PD500611 chequer add
-typedef struct AssocReq_Parameter
-{
-  BYTE       PeerSTAAddr[MAC_ADDR_LENGTH];
-  WORD       AssocFailTimeOut;              // TU
-  WORD       CapabilityInfo;
-  WORD       ListenInterval;                // no. of beacon intervals
-  BYTE       BasicRateSet      [MAX_BASIC_RATE_SET];   // end with \x00
-  BYTE       OperationalRateSet[MAX_OPT_RATE_SET];
-
-} GUIAssocReqPara, *psGUIAssocReqPara;
-
-/*
-typedef struct ReAssocReq_Parameter
-{
-  BYTE       NewAPAddr[MAC_ADDR_LENGTH];
-  WORD       ReAssocFailTimeOut;            // TU
-  WORD       CapabilityInfo;
-  WORD       ListenInterval;                // no. of beacon intervals
-
-} GUIReAssocReqPara, *psGUIReAssocReqPara;
-*/
-
-typedef struct ReAssocReq_Parameter
-{
-  BYTE       NewAPAddr[MAC_ADDR_LENGTH];
-  WORD       ReAssocFailTimeOut;            // TU
-  WORD       CapabilityInfo;
-  WORD       ListenInterval;                // no. of beacon intervals
-  BYTE       BasicRateSet      [MAX_BASIC_RATE_SET];   // end with \x00
-  BYTE       OperationalRateSet[MAX_OPT_RATE_SET];
-
-} GUIReAssocReqPara, *psGUIReAssocReqPara;
-
-
-typedef struct Reason_Code GUIDisAssocReqPara, *psGUIDisAssocReqPara;
-
-typedef WORD GUI_FRAG_THRSHLD,GUI_RTS_THRSHLD;
-
-typedef BYTE GUIWEPMode;                    // disable/64 bits/128 bits
-#define WEP_DISABLE     0                   // Default
-#define WEP_KEY_64		1
-#define	WEP_KEY_128		2
-
-typedef struct _GUIWEPPara
-{
-  BYTE        KeyIndex;             // 0,1,2,3 for shared-key, 0x80 for map-key
-  BYTE        KeyValue[13];         // length depend on KEY_64 or KEY_128
-  BYTE        MACAddr[MAC_ADDR_LENGTH]; // = NULL if KeyIndex!=0x80
-
-} GUIWEPPara, *psGUIWEPPara;
-
-typedef struct _GUIStatistics
-{
-  DWORD         NumTxMMPDU;
-  DWORD         NumTxMMPDUDiscarded;
-  DWORD         NumRxMMPDU;
-  DWORD         NumRxMMPDUDiscarded;
-  DWORD         NumTxMSDU;
-  DWORD         NumRxMSDU;
-  DWORD         NumFrameDuplicate;
-  DWORD			NumTxTBTTstart;
-  DWORD			NumTxETR;
-  DWORD			NumTxWepOnFalse;
-  DWORD			NumTxNullKey;
-  DWORD			NumTxRetry[8];
-} GUIStatistics, *psGUIStatistics;
-
-typedef struct _GUIRegAccess
-{
-  BYTE          RegNo;
-  DWORD         dwValue;
-} GUIRegAccess, *psGUIRegAccess;
-
-#define WEP_MAP_KEY		0x80
-
-typedef BYTE GUIRoamingMode;
-#define ROAMING_DISABLED    0
-#define ROAMING_ENABLED     1
-
-//-----------  06/28/04'  ----------------
-typedef struct _AdvanceStatus
-{
-	BYTE		OperationMode;
-	BYTE		ProtectionMode;	//unsigned char
-	BYTE		PreambleType;	//unsigned char: 1(short), 0(long)
-	BYTE		SlotTimeType;	//unsigned char: 1(short), 0(long)
-	BYTE		CWMinValue;
-	//12/06/04' added
-	BYTE		AntennaType;	//0 or 1
-	WORD		CWMaxValue;
-}GUIAdvanceStatus, *psGUIAdvanceStatus;
-
-
-//--------- DTO threshold parameters -------------
-typedef struct _DTOPara
-{
-	WORD	DTO_PeriodicCheckCycle;
-	WORD	DTO_RssiThForAntDiv;
-	WORD	DTO_TxCountThForCalcNewRate;
-	WORD 	DTO_TxRateIncThreshold;
-	WORD 	DTO_TxRateDecThreshold;
-	WORD 	DTO_TxRateEqThreshold;
-	WORD	DTO_TxRateBackoff;
-	WORD	DTO_TxRetryRateReduce;
-	WORD	DTO_TxPowerIndex;
-}GUIDtoPara, *psGUIDtoPara;
-
-typedef struct _EVENT_LOG
-{
-	WORD		Count;			//Total count from start
-	WORD		index;			//Buffer index, 0 ~ 63
-	DWORD		EventValue[64];	//BYTE 3~2 : count, BYTE 1 : Event, BYTE 0 : reason
-} GUIEvent_Log, *psGUIEvent_Log;
-
-
-#endif // GUI_structures
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c b/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
index 9809139..f119247 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
@@ -614,7 +614,7 @@ Wb35Reg_destroy(phw_data_t pHwData)
 //====================================================================================
 // The function can be run in passive-level only.
 //====================================================================================
-unsigned char Wb35Reg_initial(  phw_data_t pHwData )
+unsigned char Wb35Reg_initial(phw_data_t pHwData)
 {
 	PWB35REG pWb35Reg=&pHwData->Wb35Reg;
 	u32 ltmp;
@@ -672,20 +672,6 @@ unsigned char Wb35Reg_initial(  phw_data
 	// Update Ethernet address
 	memcpy( pHwData->CurrentMacAddress, pHwData->PermanentMacAddress, ETH_LENGTH_OF_ADDRESS );
 
-	#ifdef _PE_REG_DUMP_
-	{
-		int i;
-		WBDEBUG(("EthAddr = "));//Debug information
-		for( i=0; i<ETH_LENGTH_OF_ADDRESS; i++ )
-		{
-			WBDEBUG(("%02x ",pHwData->PermanentMacAddress[i] ));
-			if( i==5 ) break;
-			WBDEBUG(("-"));
-		}
-		WBDEBUG(("\n"));
-	}
-	#endif
-
 	// Update software variable
 	pHwData->SoftwareSet = (u16)(SoftwareSet & 0xffff);
 	TxVga &= 0x000000ff;
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
index f9d2b82..7858030 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
@@ -106,20 +106,20 @@ void Wb35Rx_Complete(PURB pUrb)
 		pRxBufferAddress = pWb35Rx->pDRx;
 		BulkLength = (u16)pUrb->actual_length;
 
-		//The IRP is completed
+		// The IRP is completed
 		pWb35Rx->EP3vm_state = VM_COMPLETED;
 
 		if (pHwData->SurpriseRemove || pHwData->HwStop) // Must be here, or RxBufferId is invalid
 			break;
 
-		if( pWb35Rx->rx_halt )
+		if (pWb35Rx->rx_halt)
 			break;
 
 		// Start to process the data only in successful condition
 		pWb35Rx->RxOwner[ RxBufferId ] = 0; // Set the owner to driver
 		R00.value = le32_to_cpu(*(PULONG)pRxBufferAddress);
 
-		//The URB is completed, check the result
+		// The URB is completed, check the result
 		if (pWb35Rx->EP3VM_status != 0) {
 			#ifdef _PE_USB_STATE_DUMP_
 			WBDEBUG(("EP3 IoCompleteRoutine return error\n"));
@@ -136,22 +136,21 @@ void Wb35Rx_Complete(PURB pUrb)
 				SizeCheck -= 4;
 			SizeCheck = (SizeCheck + 3) & ~0x03;
 			SizeCheck += 12; // 8 + 4 badbeef
-			if( (BulkLength > 1600) || 
+			if ((BulkLength > 1600) || 
 				(SizeCheck > 1600) ||
 				(BulkLength != SizeCheck) || 
-				(BulkLength == 0) ) // Add for fail Urb
-			{
+				(BulkLength == 0)) { // Add for fail Urb
 				pWb35Rx->EP3vm_state = VM_STOP;
 				pWb35Rx->Ep3ErrorCount2++;
 			}
 		}
 
-		//Indicating the receiving data
+		// Indicating the receiving data
 		pWb35Rx->ByteReceived += BulkLength;
 		pWb35Rx->RxBufferSize[ RxBufferId ] = BulkLength;
 
 		if (!pWb35Rx->RxOwner[ RxBufferId ])
-			Wb35Rx_indicate( pHwData );
+			Wb35Rx_indicate(pHwData);
 		
 		kfree(pWb35Rx->pDRx);
 		// Do the next receive
@@ -259,7 +258,9 @@ void Wb35Rx_adjust(PDESCRIPTOR pRxDes)
 	pRxDes->buffer_size[0] = BufferSize;
 }
 
-//931130.4.b
+extern void packet_came(char *pRxBufferAddress, int PacketSize);
+
+
 u16 Wb35Rx_indicate(phw_data_t pHwData)
 {
 	DESCRIPTOR	RxDes;
@@ -269,29 +270,27 @@ u16 Wb35Rx_indicate(phw_data_t pHwData)
 	u16		stmp, BufferSize, stmp2 = 0;
 	u32		RxBufferId;
 
-	// Only one thread be allowed to run into the follow
+	// Only one thread be allowed to run into the following
 	do {
 		RxBufferId = pWb35Rx->RxProcessIndex;
-		if( pWb35Rx->RxOwner[ RxBufferId ] )//Owner by VM
+		if (pWb35Rx->RxOwner[ RxBufferId ]) //Owner by VM
 			break;
 
 		pWb35Rx->RxProcessIndex++;
 		pWb35Rx->RxProcessIndex %= MAX_USB_RX_BUFFER_NUMBER;
 
-		//pRxBufferAddress = pWb35Rx->RxBuffer[ RxBufferId ];
 		pRxBufferAddress = pWb35Rx->pDRx;
 		BufferSize = pWb35Rx->RxBufferSize[ RxBufferId ];
 
 		// Parse the bulkin buffer
-		while( BufferSize >= 4 )
-		{
+		while (BufferSize >= 4) {
 			if ((cpu_to_le32(*(PULONG)pRxBufferAddress) & 0x0fffffff) == RX_END_TAG) //Is ending? 921002.9.a
 				break;
 
 			// Get the R00 R01 first
-			RxDes.R00.value = le32_to_cpu(*(PULONG)pRxBufferAddress); //20060926 add by anson's endian
+			RxDes.R00.value = le32_to_cpu(*(PULONG)pRxBufferAddress);
 			PacketSize = (u16)RxDes.R00.R00_receive_byte_count;
-			RxDes.R01.value = le32_to_cpu(*((PULONG)(pRxBufferAddress+4))); //20060926 anson's ednian
+			RxDes.R01.value = le32_to_cpu(*((PULONG)(pRxBufferAddress+4)));
 			// For new DMA 4k
 			if ((PacketSize & 0x03) > 0)
 				PacketSize -= 4;
@@ -309,7 +308,7 @@ u16 Wb35Rx_indicate(phw_data_t pHwData)
 
 			// Start to process Rx buffer
 //			RxDes.Descriptor_ID = RxBufferId; // Due to synchronous indicate, the field doesn't necessary to use.
-			BufferSize -= 8;//subtract 8 byte for 35's USB header length
+			BufferSize -= 8; //subtract 8 byte for 35's USB header length
 			pRxBufferAddress += 8;
 
 			RxDes.buffer_address[0] = pRxBufferAddress;
@@ -317,7 +316,9 @@ u16 Wb35Rx_indicate(phw_data_t pHwData)
 			RxDes.buffer_number = 1;
 			RxDes.buffer_start_index = 0;
 			RxDes.buffer_total_size = RxDes.buffer_size[0];
-			Wb35Rx_adjust( &RxDes );
+			Wb35Rx_adjust(&RxDes);
+
+			packet_came(pRxBufferAddress, PacketSize);
 
 			// Indicating to upper module
 			hal_descriptor_indicate( pHwData, &RxDes );
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
index a5b26ec..80fed46 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
@@ -39,8 +39,8 @@ void Wb35Tx(phw_data_t pHwData)
 	PADAPTER	Adapter = pHwData->Adapter;
 	PUCHAR		pTxBufferAddress;
 	PMDS		pMds = &Adapter->Mds;
-	struct urb *		pUrb = (struct urb *)pWb35Tx->Tx4Urb;
-	int         retv;
+	struct urb *	pUrb = (struct urb *)pWb35Tx->Tx4Urb;
+	int         	retv;
 	u32		SendIndex;
 
 
@@ -110,8 +110,7 @@ void Wb35Tx_complete(struct urb * pUrb)
 			break;
 
 		// The URB is completed, check the result
-		if( pWb35Tx->EP4VM_status != 0 )
-		{
+		if (pWb35Tx->EP4VM_status != 0) {
 			#ifdef _PE_USB_STATE_DUMP_
 			WBDEBUG(("EP4 IoCompleteRoutine return error\n"));
 			DebugUsbdStatusInformation( pWb35Tx->EP4VM_status );
@@ -121,8 +120,8 @@ void Wb35Tx_complete(struct urb * pUrb)
 		}
 
 		// Do the next send
-		Mds_Tx( Adapter );
-		Wb35Tx( pHwData );
+		Mds_Tx(Adapter);
+		Wb35Tx(pHwData);
 		return;
 	} while(FALSE);
 
@@ -157,7 +156,7 @@ unsigned char Wb35Tx_initial(phw_data_t 
 }
 
 //======================================================
-void Wb35Tx_stop(  phw_data_t pHwData )
+void Wb35Tx_stop(phw_data_t pHwData)
 {
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
@@ -198,7 +197,7 @@ void Wb35Tx_destroy(phw_data_t pHwData)
 	#endif
 }
 
-void Wb35Tx_CurrentTime(  phw_data_t pHwData,  u32 TimeCount )
+void Wb35Tx_CurrentTime(phw_data_t pHwData, u32 TimeCount)
 {
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 	unsigned char Trigger = FALSE;
@@ -214,13 +213,12 @@ void Wb35Tx_CurrentTime(  phw_data_t pHw
 	}
 }
 
-void Wb35Tx_EP2VM_start(  phw_data_t pHwData )
+void Wb35Tx_EP2VM_start(phw_data_t pHwData)
 {
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	// Allow only one thread to run into function
-	if( OS_ATOMIC_INC( pHwData->Adapter, &pWb35Tx->TxResultCount ) == 1 )
-	{
+	if (OS_ATOMIC_INC( pHwData->Adapter, &pWb35Tx->TxResultCount ) == 1) {
 		pWb35Tx->EP2vm_state = VM_RUNNING;
 		Wb35Tx_EP2VM( pHwData );
 	}
@@ -237,28 +235,22 @@ void Wb35Tx_EP2VM(phw_data_t pHwData)
 	int		retv;
 
 	do {
-		if( pHwData->SurpriseRemove || pHwData->HwStop )
+		if (pHwData->SurpriseRemove || pHwData->HwStop)
 			break;
 
-		if( pWb35Tx->tx_halt )
+		if (pWb35Tx->tx_halt)
 			break;
 
 		//
 		// Issuing URB
 		//
-		usb_fill_int_urb( pUrb,
-						  pHwData->WbUsb.udev,
-						  usb_rcvintpipe(pHwData->WbUsb.udev,2),
-						  pltmp,
-						  MAX_INTERRUPT_LENGTH,
-						  Wb35Tx_EP2VM_complete,
-						  pHwData,32);
+		usb_fill_int_urb( pUrb, pHwData->WbUsb.udev, usb_rcvintpipe(pHwData->WbUsb.udev,2),
+				  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, pHwData, 32);
 
 		pWb35Tx->EP2vm_state = VM_RUNNING;
 		retv = wb_usb_submit_urb( pUrb );
 
-		if(retv < 0)
-		{
+		if(retv < 0) {
 			#ifdef _PE_TX_DUMP_
 			WBDEBUG(("EP2 Tx Irp sending error\n"));
 			#endif
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 9727477..de30a56 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -1,8 +1,6 @@
 
 #include "sysdef.h"
-
-
-
+#include <net/mac80211.h>
 
 
 MODULE_AUTHOR( DRIVER_AUTHOR );   
@@ -35,6 +33,134 @@ static struct usb_driver wb35_driver = {
 	.id_table = Id_Table,
 };
 
+static const struct ieee80211_rate wbsoft_rates[] = {
+	{ .rate = 10,
+	  .val = 10,
+	  .val2 = -10,
+	  .flags = IEEE80211_RATE_CCK_2 },
+};
+
+static const struct ieee80211_channel wbsoft_channels[] = {
+	{ .chan = 1,
+	  .freq = 2412},
+};
+
+static struct ieee80211_hw_mode wbsoft_modes[1];
+int wbsoft_enabled;
+struct ieee80211_hw *my_dev;
+PADAPTER my_adapter;
+
+static int wbsoft_add_interface(struct ieee80211_hw *dev,
+				 struct ieee80211_if_init_conf *conf)
+{
+	printk("wbsoft_add interface called\n");
+	return 0;
+}
+
+static void wbsoft_remove_interface(struct ieee80211_hw *dev,
+				     struct ieee80211_if_init_conf *conf)
+{
+	printk("wbsoft_remove interface called\n");
+}
+
+static int wbsoft_nop(void)
+{
+	printk("wbsoft_nop called\n");
+	return 0;
+}
+
+static void wbsoft_configure_filter(struct ieee80211_hw *dev,
+				     unsigned int changed_flags,
+				     unsigned int *total_flags,
+				     int mc_count, struct dev_mc_list *mclist)
+{
+	static const u8 bcast[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+	unsigned int bit_nr, new_flags;
+	u32 mc_filter[2];
+	int i;
+
+	new_flags = 0;
+
+	if (*total_flags & FIF_PROMISC_IN_BSS) {
+		new_flags |= FIF_PROMISC_IN_BSS;
+		mc_filter[1] = mc_filter[0] = ~0;
+	} else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32)) {
+		new_flags |= FIF_ALLMULTI;
+		mc_filter[1] = mc_filter[0] = ~0;
+	} else {
+		mc_filter[1] = mc_filter[0] = 0;
+		for (i = 0; i < mc_count; i++) {
+			if (!mclist)
+				break;
+			printk("Should call ether_crc here\n");
+			//bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
+			bit_nr = 0;
+
+			bit_nr &= 0x3F;
+			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
+			mclist = mclist->next;
+		}
+	}
+
+	dev->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+
+	*total_flags = new_flags;
+}
+
+static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
+		      struct ieee80211_tx_control *control)
+{
+	if (1 == MLMESendFrame(my_adapter, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT))
+		printk("frame sent ok?\n");
+	return NETDEV_TX_OK;
+}
+
+
+static int wbsoft_start(struct ieee80211_hw *dev)
+{
+	wbsoft_enabled = 1;
+	printk("wbsoft_start called\n");
+	return 0;
+}
+
+static int wbsoft_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
+{
+	printk("wbsoft_config called\n");
+	return 0;
+}
+
+static int wbsoft_config_interface(struct ieee80211_hw *dev,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_if_conf *conf)
+{
+	printk("wbsoft_config_interface called\n");
+	return 0;
+}
+
+static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
+{
+	printk("wbsoft_get_tsf called\n");
+	return 0;
+}
+
+static const struct ieee80211_ops wbsoft_ops = {
+	.tx			= wbsoft_tx,
+	.start			= wbsoft_start,		/* Start can be pretty much empty as we do WbWLanInitialize() during probe? */
+	.stop			= wbsoft_nop,
+	.add_interface		= wbsoft_add_interface,
+	.remove_interface	= wbsoft_remove_interface,
+	.config			= wbsoft_config,
+	.config_interface	= wbsoft_config_interface,
+	.configure_filter	= wbsoft_configure_filter,
+	.get_stats		= wbsoft_nop,
+	.get_tx_stats		= wbsoft_nop,
+	.get_tsf		= wbsoft_get_tsf,
+};
+
+struct wbsoft_priv {
+};
+
+
 int __init wb35_init(void)
 {
 	printk("[w35und]driver init\n");
@@ -51,7 +177,7 @@ module_init(wb35_init);
 module_exit(wb35_exit);
 
 // Usb kernel subsystem will call this function when a new device is plugged into.
-int wb35_probe( struct usb_interface *intf,const struct usb_device_id *id_table )
+int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
 {
 	PADAPTER	Adapter;
 	PWBLINUX	pWbLinux;
@@ -105,6 +231,7 @@ int wb35_probe( struct usb_interface *in
 		Adapter = netdev_priv(netdev);
 
 		memset(Adapter, 0, sizeof(ADAPTER));
+		my_adapter = Adapter;
 		pWbLinux = &Adapter->WbLinux;
 		pWbLinux->netdev = netdev;
 		pWbUsb = &Adapter->sHwData.WbUsb;
@@ -140,6 +267,45 @@ int wb35_probe( struct usb_interface *in
 			printk("w35und: couldn't register the netdev!\n");
 			break;
 		}
+
+		{
+			struct wbsoft_priv *priv;
+			struct ieee80211_hw *dev;
+			int res;
+
+			dev = ieee80211_alloc_hw(sizeof(*priv), &wbsoft_ops);
+
+			if (!dev) {
+				printk("w35und: ieee80211 alloc failed\n" );
+				BUG();
+			}
+
+			my_dev = dev;
+
+			SET_IEEE80211_DEV(dev, &udev->dev);
+			SET_IEEE80211_PERM_ADDR(dev, netdev->dev_addr);
+
+			dev->extra_tx_headroom = 12;	/* FIXME */
+			dev->flags = IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
+
+			dev->channel_change_time = 1000;
+			dev->max_rssi = 100;
+
+			dev->queues = 1; /* ADM8211C supports more, maybe ADM8211B too */
+
+			wbsoft_modes[0].num_channels = 1;
+			wbsoft_modes[0].channels = wbsoft_channels;
+			wbsoft_modes[0].mode = MODE_IEEE80211B;
+			wbsoft_modes[0].num_rates = ARRAY_SIZE(wbsoft_rates);
+			wbsoft_modes[0].rates = wbsoft_rates;
+
+			res = ieee80211_register_hwmode(dev, &wbsoft_modes[0]);
+			BUG_ON(res);
+
+			res = ieee80211_register_hw(dev);
+			BUG_ON(res);
+		}
+
 		usb_set_intfdata( intf, Adapter );
 
 		printk("[w35und] _probe OK\n");
@@ -152,15 +318,41 @@ int wb35_probe( struct usb_interface *in
 	return -ENOMEM;
 }
 
+void packet_came(char *pRxBufferAddress, int PacketSize)
+{
+	struct sk_buff *skb;
+	struct ieee80211_rx_status rx_status = {0};
+
+	if (!wbsoft_enabled)
+		return;
+
+	printk("packet came, device enabled\n");
+
+	skb = dev_alloc_skb(PacketSize);
+	if (!skb)
+		printk("Not enough memory for packet, FIXME\n");
+
+	memcpy(skb_put(skb, PacketSize),
+	       pRxBufferAddress,
+	       PacketSize);
+
+	rx_status.rate = 10;
+	rx_status.channel = 1;
+	rx_status.freq = 12345;
+	rx_status.phymode = MODE_IEEE80211B;
+
+	ieee80211_rx_irqsafe(my_dev, skb, &rx_status);
+}
+
 unsigned char
-WbUsb_initial(  phw_data_t pHwData )
+WbUsb_initial(phw_data_t pHwData)
 {
 	return 1;
 }
 
 
 void
-WbUsb_destroy(  phw_data_t pHwData )
+WbUsb_destroy(phw_data_t pHwData)
 {
 }
 
@@ -172,7 +364,7 @@ int wb35_open(struct net_device *netdev)
         netif_start_queue(netdev);
 
 	//TODO : put here temporarily
-	hal_set_accept_broadcast( pHwData, 1); // open accept broadcast
+	hal_set_accept_broadcast(pHwData, 1); // open accept broadcast
 
 	return 0;
 }
@@ -199,4 +391,3 @@ void wb35_disconnect(struct usb_interfac
 }
 
 
-
diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index 2d06cd9..2f5cf77 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -1,7 +1,8 @@
 #include "os_common.h"
 #include "wpa/eap.h"
+
 void
-Mds_reset_descriptor(  PADAPTER Adapter )
+Mds_reset_descriptor(PADAPTER Adapter)
 {
 	PMDS		pMds = &Adapter->Mds;
 
@@ -14,7 +15,7 @@ Mds_reset_descriptor(  PADAPTER Adapter 
 }
 
 unsigned char
-Mds_initial(  PADAPTER Adapter )
+Mds_initial(PADAPTER Adapter)
 {
 	PMDS		pMds = &Adapter->Mds;
 
@@ -28,7 +29,7 @@ Mds_initial(  PADAPTER Adapter )
 }
 
 void
-Mds_Destroy(  PADAPTER Adapter )
+Mds_Destroy(PADAPTER Adapter)
 {
 	vRxTimerStop(Adapter);
 }
@@ -73,12 +74,11 @@ Mds_Tx(PADAPTER Adapter)
 				PacketFrom = 1;
 				PacketSize = QUERY_SIZE_FIRST( Adapter );
 				if (!PacketSize) {
-					if( !TS_RUNNING_IN_TESTSTA_MODE ) // If driver doesn't run in test mode, send MLME and normal data frame
-					{
+					if (!TS_RUNNING_IN_TESTSTA_MODE) { // If driver doesn't run in test mode, send MLME and normal data frame
 						PacketFrom = 2;
 						PacketSize = QUERY_SIZE_SECOND(Adapter);
-						if( !PacketSize ) {
-							if( pMds->ScanTxPause )	//No management frames to transmit.
+						if (!PacketSize) {
+							if (pMds->ScanTxPause)	//No management frames to transmit.
 								break;				//The scanning is progressing, so stop the data
 												//frames transmission
 							PacketFrom = 3;
@@ -109,7 +109,7 @@ Mds_Tx(PADAPTER Adapter)
 				//
 				BufferFilled = TRUE;
 
-				DESCRIPTOR_RESET( pTxDes );
+				DESCRIPTOR_RESET(pTxDes);
 				TxDesIndex = pMds->TxDesIndex;//Get the current ID
 				DESCRIPTOR_SET_ID( pTxDes, TxDesIndex );
 				pMds->TxDesFrom[ TxDesIndex ] = PacketFrom;//Storing the information of source comming from
@@ -145,10 +145,10 @@ Mds_Tx(PADAPTER Adapter)
 				}
 
 				// Copy (fragment) frame body, and set USB, 802.11 hdr flag
-				CurrentSize = Mds_BodyCopy( Adapter, pTxDes, XmitBufAddress );
+				CurrentSize = Mds_BodyCopy(Adapter, pTxDes, XmitBufAddress);
 
 				// Set RTS/CTS and Normal duration field into buffer
-				Mds_DurationSet( Adapter, pTxDes, XmitBufAddress );
+				Mds_DurationSet(Adapter, pTxDes, XmitBufAddress);
 
 				//
 				// Calculation MIC from buffer which maybe fragment, then fill into temporary address 8 byte
@@ -161,20 +161,18 @@ Mds_Tx(PADAPTER Adapter)
 				XmitBufAddress += CurrentSize;
 
 				#ifdef _IBSS_BEACON_SEQ_STICK_
-				if( (XmitBufAddress[ DOT_11_DA_OFFSET+8 ] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST ) // +8 for USB hdr
+				if ((XmitBufAddress[ DOT_11_DA_OFFSET+8 ] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) // +8 for USB hdr
 				#endif
-				pMds->TxToggle = TRUE;
+					pMds->TxToggle = TRUE;
 
 				//---------------------
 				//Check Power save
 				if (psSME->bDesiredPowerSave) {
 					if ((psLOCAL->wConnectedSTAindex == 0) ||
 					    ((psLOCAL->wConnectedSTAindex != 0) &&
-					     (psBSS(psLOCAL->wConnectedSTAindex)->bBssType == ESS_NET)))
-					{
+					     (psBSS(psLOCAL->wConnectedSTAindex)->bBssType == ESS_NET))) {
 						psLOCAL->boHasTxActivity = 1;
-						if (psLOCAL->iPowerSaveMode == PWR_SAVE)
-						{
+						if (psLOCAL->iPowerSaveMode == PWR_SAVE) {
 							K_MSG	sSmeMsg;
 							u8	PsMode;
 
@@ -208,11 +206,10 @@ Mds_Tx(PADAPTER Adapter)
 
 				// Software TSC count 20060214
 				pMds->TxTsc++;
-				if( pMds->TxTsc == 0 )
+				if (pMds->TxTsc == 0)
 					pMds->TxTsc_2++;
 
 				FillCount++; // 20060928
-
 			} while (HAL_USB_MODE_BURST(pHwData)); // End of multiple MSDU copy loop. FALSE = single TRUE = multiple sending
 
 			// Move to the next one, if necessary
@@ -229,8 +226,7 @@ Mds_Tx(PADAPTER Adapter)
 				pMds->TxFillIndex++;
 				pMds->TxFillIndex %= MAX_USB_TX_BUFFER_NUMBER;
 				BufferFilled = FALSE;
-			}
-			else
+			} else
 				break;
 
 			if (!PacketSize) // No more pk for transmitting
@@ -249,7 +245,7 @@ Mds_Tx(PADAPTER Adapter)
 }
 
 void
-Mds_SendComplete(  PADAPTER Adapter,  PT02_DESCRIPTOR pT02 )
+Mds_SendComplete(PADAPTER Adapter, PT02_DESCRIPTOR pT02)
 {
 	PMDS	pMds = &Adapter->Mds;
 	phw_data_t	pHwData = &Adapter->sHwData;
@@ -258,30 +254,26 @@ Mds_SendComplete(  PADAPTER Adapter,  PT
 	unsigned char	SendOK = TRUE;
 	u8	RetryCount, TxRate;
 	K_MSG	sSmeMsg;
-	u16		wIndex, wReasonCode;
+	u16	wIndex, wReasonCode;
 
 
-	if( pT02->T02_IgnoreResult ) // Donot care the result
+	if (pT02->T02_IgnoreResult) // Don't care the result
 		return;
     #ifdef _PE_TX_DUMP_
 	WBDEBUG(("###  Tx complete, PacketId =%x, pT02->T02_Tx_PktID =%x\n",
 							PacketId, pT02->T02_Tx_PktID));
     #endif	
-	if( pT02->T02_IsLastMpdu )
-	{
+	if (pT02->T02_IsLastMpdu) {
 		//TODO: DTO -- get the retry count and fragment count
 		// Tx rate
-		//TxRate = pMds->TxRate[ PacketId ][ pT02->T02_effective_transmission_rate ];
 		TxRate = pMds->TxRate[ PacketId ][ 0 ];
 		RetryCount = (u8)pT02->T02_MPDU_Cnt;
-		if( pT02->value & FLAG_ERROR_TX_MASK )
-		{
+		if (pT02->value & FLAG_ERROR_TX_MASK) {
 			SendOK = FALSE;
 			#ifdef _PE_DTO_DUMP_
 			WBDEBUG(("Mds Tx Fail[%d] = %8x\n", PacketId, pT02->value ));
 			#endif
-			if (pT02->T02_transmit_abort || pT02->T02_out_of_MaxTxMSDULiftTime)
-			{
+			if (pT02->T02_transmit_abort || pT02->T02_out_of_MaxTxMSDULiftTime) {
 				//retry error
 				pHwData->dto_tx_retry_count += (RetryCount+1);
 				//[for tx debug]
@@ -305,9 +297,7 @@ Mds_SendComplete(  PADAPTER Adapter,  PT
 				pHwData->tx_WepOn_false_count++;
 			if (pT02->T02_discard_due_to_null_wep_key)
 				pHwData->tx_Null_key_count++;
-		}
-		else
-		{
+		} else {
 			if (pT02->T02_effective_transmission_rate)
 				pHwData->tx_ETR_count++;
 			MTO_SetTxCount(Adapter, TxRate, RetryCount);
@@ -321,29 +311,21 @@ Mds_SendComplete(  PADAPTER Adapter,  PT
 		else if( pMds->TxDesFrom[ PacketId ] == 1 )
 			{ COMPLETE_DESCRIPTOR_FIRST( Adapter, PacketId, SendOK ); }
 
-		//DataDmp( pMds->TxBuffer[PacketId], 50, 0);
 		//The next 802.1x message callback after 2 MIC error occur within 60s
 		//TODO: ?? Don't care whether the next 802.1x message is transmitted successfully??
-		//if (Adapter->Mds.boCounterMeasureBlock &&
-			//8byte USB + 24byte 802.11Hdr + 6 byte EAPOL packet type
-		//	(*((u16 *)(pMds->TxBuffer[PacketId]+38)) == 0x8e88))
-		if (pMds->TxInfo[PacketId] == 1)
-		{
-			//It needs to send disassoc. frame no matter the connection is still
-			//alive or not(AP disassoc. us).
+		if (pMds->TxInfo[PacketId] == 1) {
+			// It needs to send disassoc. frame no matter the connection is still
+			// alive or not(AP disassoc. us).
 			#ifdef _PE_STATE_DUMP_
 			WBDEBUG(("!!Countermeasure, disassoc !!\n"));
 			#endif
 			pMds->TxInfo[PacketId] = 0;
-			if (CURRENT_LINK_ON)
-			{
+			if (CURRENT_LINK_ON) {
 				wReasonCode = REASON_MIC_ERROR;
 				sSmeMsg.wMsgType = SMEMSG_DISASSOC_REQ;
 				sSmeMsg.pMsgPtr = &wReasonCode;
 				SME_Entry(Adapter, &sSmeMsg);
-			}
-			else
-			{
+			} else {
 				//Maybe AP has disassoc. us firstly, but we still need send it.
 				pTxBuffer = pMds->pTxBuffer + (MAX_USB_TX_BUFFER * PacketId); //Get buffer
 				wIndex = wBSSfindBssID( Adapter, pTxBuffer+12 );
@@ -352,20 +334,13 @@ Mds_SendComplete(  PADAPTER Adapter,  PT
 		}
 		// Clear send result buffer
 		pMds->TxResult[ PacketId ] = 0;
-	}
-	else
+	} else
 		pMds->TxResult[ PacketId ] |= ((u16)(pT02->value & 0x0ffff));
-
-
-// 20060928 Remove
-//	// Start the next send
-//	Mds_Tx( Adapter );
 }
 
 void
-Mds_HeaderCopy(  PADAPTER Adapter,  PDESCRIPTOR pDes,  PUCHAR TargetBuffer )
+Mds_HeaderCopy(PADAPTER Adapter, PDESCRIPTOR pDes, PUCHAR TargetBuffer)
 {
-//	phw_data_t pHwData = &Adapter->sHwData;
 	PMDS	pMds = &Adapter->Mds;
 	PUCHAR	src_buffer = pDes->buffer_address[0];//931130.5.g
 	PUCHAR	buffer;
@@ -401,8 +376,7 @@ Mds_HeaderCopy(  PADAPTER Adapter,  PDES
 	//
 	// Header convert from 802.3 to 802.11
 	//
-	if( DESCRIPTOR_GET_TYPE( pDes ) == FRAME_TYPE_802_3_DATA )
-	{
+	if (DESCRIPTOR_GET_TYPE( pDes ) == FRAME_TYPE_802_3_DATA) {
 		// Setting 802.11 Frame control 2 byte
 		buffer = TargetBuffer; // Reserved for USB header
 		*buffer = 0x08;// Data type
@@ -416,8 +390,7 @@ Mds_HeaderCopy(  PADAPTER Adapter,  PDES
 		if( src_buffer[0] & 0x1 )	// belong to Group address in DA field. Do not fragment.
 			FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
 
-		switch( CURRENT_BSS_TYPE )
-		{
+		switch (CURRENT_BSS_TYPE) {
 			case IBSS_NET:
 				//Copy DA-SA
 				memcpy( buffer, src_buffer, DOT_3_TYPE_OFFSET );
@@ -640,8 +613,7 @@ Mds_HeaderCopy(  PADAPTER Adapter,  PDES
 
 	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
 
-	for( i=0; i<2; i++ )
-	{
+	for( i=0; i<2; i++ ) {
 		if( i == 1 )
 			ctmp1 = ctmpf;
 
@@ -679,7 +651,7 @@ Mds_HeaderCopy(  PADAPTER Adapter,  PDES
 
 // The function return the 4n size of usb pk
 u16
-Mds_BodyCopy(  PADAPTER Adapter,  PDESCRIPTOR pDes,  PUCHAR TargetBuffer )
+Mds_BodyCopy(PADAPTER Adapter, PDESCRIPTOR pDes, PUCHAR TargetBuffer)
 {
 	PT00_DESCRIPTOR	pT00;
 	PMDS	pMds = &Adapter->Mds;
@@ -697,10 +669,6 @@ Mds_BodyCopy(  PADAPTER Adapter,  PDESCR
 	pT00 = (PT00_DESCRIPTOR)buffer;
 	while( SizeLeft )
 	{
-//950301 delete due to HW
-//		// 931130.5.l
-//		OS_ATOMIC_INC( Adapter, &pMds->TxConcurrentCount );
-
 		pT00 = (PT00_DESCRIPTOR)buffer;
 		CopySize = SizeLeft;
 		if( SizeLeft > DESCRIPTOR_GET_FRAGMENT_THRESHOLD(pDes) )
@@ -1108,10 +1076,8 @@ void MDS_SendResult(  PADAPTER Adapter, 
 void MDS_EthernetPacketReceive(  PADAPTER Adapter,  PRXLAYER1 pRxLayer1 )
 {
 #ifdef WB_LINUX_WPA_PSK
-//	PUCHAR		BufAddr, pctmp;
-//	u16		BufSize, stmp;
-     PUCHAR pctmp;
-     u16 stmp;
+	PUCHAR pctmp;
+	u16 stmp;
 	pctmp = pRxLayer1->BufferQueue[0].pBufferAddress + 12;
 	stmp = pctmp[0] << 8;
 	stmp |= pctmp[1];
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_assoc.c b/drivers/net/wireless/winbond/winbondport/mlme_assoc.c
index 41e204e..38041a2 100644
--- a/drivers/net/wireless/winbond/winbondport/mlme_assoc.c
+++ b/drivers/net/wireless/winbond/winbondport/mlme_assoc.c
@@ -30,14 +30,14 @@ #include "os_common.h"
 //============================================================================
 s8 SendAssociationRequest(PWB32_ADAPTER   Adapter,
                             u16          iMSindex,
-                            unsigned char 			Reasso)
+                            unsigned char Reasso)
 {
 	u16 	iFildOffset = 0;
 	u8	*msg;
 	struct  Management_Frame* msgHeader;
-    struct  Association_Request_Frame_Body* msgBody;
+	struct  Association_Request_Frame_Body* msgBody;
 
-    // Get the free data buffer
+	// Get the free data buffer
 	if ((msg = MLMEGetMMPDUBuffer(Adapter)) == NULL)
 	{	// No available data buffer now. Stop sending the MMPDU.
 		Adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
@@ -60,20 +60,14 @@ s8 SendAssociationRequest(PWB32_ADAPTER 
 	msgHeader->frame_control.WEP            = 0;
 	msgHeader->duration                     = 0;    // Set by the MDS
 	
-	#ifdef _PE_TX_DUMP_
-	//WBDEBUG(("addr of DA =%p\n", 		msgHeader->DA));
-	//WBDEBUG(("addr of SA =%p\n", 		msgHeader->SA));
-	//WBDEBUG(("addr of BSSID =%p\n",		msgHeader->BSSID));
-	#endif
 	memcpy( msgHeader->DA, psBSS(iMSindex)->abPeerAddress, MAC_ADDR_LENGTH );
 	memcpy( msgHeader->SA, psLOCAL->ThisMacAddress, MAC_ADDR_LENGTH );
 	memcpy( msgHeader->BSSID, psBSS(iMSindex)->abBssID, MAC_ADDR_LENGTH );
 
-    // HW-MAC automatically generates the frame sequence number
-    // MDS automatically generates the fragment number.
+	// HW-MAC automatically generates the frame sequence number
+	// MDS automatically generates the fragment number.
 
 	// now set the associtaion request information
-        //20060926 add by anson's endian
 	msgBody->capability_information = cpu_to_le16( psSME->wCapabilityInfo );
 	msgBody->listenInterval = cpu_to_le16( psLOCAL->ListenInterval );
 	if(Reasso)
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
index af043a3..85fc635 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
@@ -51,7 +51,9 @@ void MLMEResetTxRx(PWB32_ADAPTER Adapter
 //    NULL     : No available data buffer available
 //    Otherwise: Pointer to the data buffer
 //=============================================================================
-u8 *MLMEGetMMPDUBuffer( PWB32_ADAPTER Adapter)
+
+/* FIXME: Should this just be replaced with kmalloc() and kfree()? */
+u8 *MLMEGetMMPDUBuffer(PWB32_ADAPTER Adapter)
 {
 	s32 i;
 	u8 *returnVal;
@@ -69,10 +71,7 @@ u8 *MLMEGetMMPDUBuffer( PWB32_ADAPTER Ad
 }
 
 //=============================================================================
-u8 MLMESendFrame( PWB32_ADAPTER Adapter,
-				   u8 *pMMPDU,
-				   u16 len,
-				   u8 DataType)
+u8 MLMESendFrame(PWB32_ADAPTER Adapter, u8 *pMMPDU, u16 len, u8 DataType)
 /*	DataType : FRAME_TYPE_802_11_MANAGEMENT, FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
 				FRAME_TYPE_802_11_DATA */
 {
@@ -100,39 +99,37 @@ #endif
 }
 
 void
-MLME_GetNextPacket(  PADAPTER Adapter,  PDESCRIPTOR pDes )
+MLME_GetNextPacket(PADAPTER Adapter, PDESCRIPTOR pDes)
 {
 	DESCRIPTOR_ADD_BUFFER( pDes, Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len );
 	DESCRIPTOR_SET_TYPE( pDes, Adapter->sMlmeFrame.DataType );
 }
 
-void MLMEfreeMMPDUBuffer( PWB32_ADAPTER Adapter,  PCHAR pData)
+void MLMEfreeMMPDUBuffer(PWB32_ADAPTER Adapter, PCHAR pData)
 {
 	int i;
 
-    // Reclaim the data buffer
-    for (i = 0; i < MAX_NUM_TX_MMPDU; i++)
-    {
-        if (pData == (PCHAR)&(Adapter->sMlmeFrame.TxMMPDU[i]))
-            break;
-    }
-    if (Adapter->sMlmeFrame.TxMMPDUInUse[i])
-        Adapter->sMlmeFrame.TxMMPDUInUse[i] = FALSE;
-    else  {
-        // Something wrong
-        // PD43 Add debug code here???
-    }
-
+	// Reclaim the data buffer
+	for (i = 0; i < MAX_NUM_TX_MMPDU; i++) {
+		if (pData == (PCHAR)&(Adapter->sMlmeFrame.TxMMPDU[i]))
+			break;
+	}
+	if (Adapter->sMlmeFrame.TxMMPDUInUse[i])
+		Adapter->sMlmeFrame.TxMMPDUInUse[i] = FALSE;
+	else  {
+		// Something wrong
+		// PD43 Add debug code here???
+	}
 }
 
 void
-MLME_SendComplete(  PADAPTER Adapter,  u8 PacketID,  unsigned char SendOK )
+MLME_SendComplete(PADAPTER Adapter, u8 PacketID, unsigned char SendOK)
 {
-	MLME_TXCALLBACK		TxCallback;
-	K_MSG				sMlmeMsg;
-	u8				DataTmp[200];
+	MLME_TXCALLBACK	TxCallback;
+	K_MSG		sMlmeMsg;
+	u8		DataTmp[200];
 
-	memcpy( DataTmp, Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len );
+	memcpy(DataTmp, Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len);
     #ifdef _PE_TX_DUMP_
 	WBDEBUG(( "dump tx callback, len=%d\n", Adapter->sMlmeFrame.len ));
 	DataDmp( Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len, 0 );
diff --git a/drivers/net/wireless/winbond/winbondport/rxisr.c b/drivers/net/wireless/winbond/winbondport/rxisr.c
index f1397b1..e05f12f 100644
--- a/drivers/net/wireless/winbond/winbondport/rxisr.c
+++ b/drivers/net/wireless/winbond/winbondport/rxisr.c
@@ -91,47 +91,38 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 	u8	LastBufIdx;
 
 	// Is management frame??
-	if( pRxLayer1->FrameType != MAC_TYPE_DATA ) {
+	if (pRxLayer1->FrameType != MAC_TYPE_DATA) {
 		// Call MLME function
-   		MLMERcvFrame( Adapter, pRxLayer1->BufferQueue, pRxLayer1->BufferNumber, SlotIndex );//The last parameter is needed for SME.
+   		MLMERcvFrame(Adapter, pRxLayer1->BufferQueue, pRxLayer1->BufferNumber, SlotIndex); //The last parameter is needed for SME.
 		return;
 	}
 
 	// Checking this packet(802.3), if valid for Filter. Just discard the frame if the media is disconnected.
-	if  (!CURRENT_LINK_ON)
+	if (!CURRENT_LINK_ON)
 		return;
 
-	pDFrame = (struct Data_Frame*)pRxLayer1->BufferQueue[0].pBufferAddress;
-	Temp = (*(PUSHORT)pRxLayer1->BufferQueue[0].pBufferAddress); //anson's endian
-	memcpy( &frame_control, &Temp, sizeof(u16) ); // YY's endian
+	pDFrame = (struct Data_Frame*) pRxLayer1->BufferQueue[0].pBufferAddress;
+	Temp = (*(PUSHORT)pRxLayer1->BufferQueue[0].pBufferAddress);
+	memcpy( &frame_control, &Temp, sizeof(u16) );
 	WEPed = frame_control.WEP ? TRUE : FALSE;
 	if( (!WEPed && !MLMEGetExcludeUnencrypted(Adapter)) ||
-		(WEPed && Adapter->sSmePara._dot11PrivacyOptionImplemented != FALSE) ) {
-		//TODO: check if there is a MIC err
+		(WEPed && Adapter->sSmePara._dot11PrivacyOptionImplemented != FALSE)) {
+		// TODO: check if there is a MIC err
 		/**/
-		if( WEPed && (pRxLayer1->DecryptionMethod==2) ) //TKIP
-		{
-			if ((pDFrame->Addr1[0] & 1) == 0)
-			{
-				if (psSME->pairwise_key_ok)
-				{
+		if (WEPed && (pRxLayer1->DecryptionMethod==2)) { //TKIP
+			if ((pDFrame->Addr1[0] & 1) == 0) {
+				if (psSME->pairwise_key_ok) {
 					mic_key = psSME->rx_mic_key;
 				}
-			}
-			else
-			{
+			} else {
 				#ifdef _PE_RX_DUMP_
 				WBDEBUG(("Receive broadcast/multicast packet.\n"));
 				#endif
 			}
-			if (mic_key == NULL)
-			{
-				if (psSME->group_key_ok)
-				{
+			if (mic_key == NULL) {
+				if (psSME->group_key_ok) {
 					mic_key = psSME->group_rx_mic_key;
-				}
-				else
-				{
+				} else {
 					#ifdef _PE_RX_DUMP_
 					WBDEBUG(("No key available to decrypt this packet.\n"));
 					#endif
@@ -141,7 +132,6 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 
 			Mds_MicGet( Adapter, pRxLayer1, mic_key, mic );
 
-			//WBDEBUG(("mic value :\n"));
 			//DataDmp(mic, 8, 0);
 			//WBDEBUG(("MICKEY = " MICKEYSTR "\n", MICKEY2STR(psSME->rx_mic_key)));
 //			#ifdef _PE_RX_DUMP_
@@ -155,79 +145,29 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 			pframe_mic = (PUCHAR)pRxLayer1->BufferQueue[ LastBufIdx ].pBufferAddress;
 			pframe_mic += pRxLayer1->BufferQueue[LastBufIdx].BufferSize - 8;
 
-			if( memcmp( pframe_mic, mic, 8 ) == 0 )
-			{
-//				u8 *DataPtr = (u8 *)pDFrame + 24; // + 24 byte header
-//				u8 TscValue[6];
-//				int j;
-/*
-				//TKIP Replay protection
-				TscValue[0] = DataPtr[2];
-				TscValue[1] = DataPtr[0];
-				TscValue[2] = DataPtr[4];
-				TscValue[3] = DataPtr[5];
-				TscValue[4] = DataPtr[6];
-				TscValue[5] = DataPtr[7];
-				j = 5;
-				if ((pDFrame->Addr1[0] & 1) == 0)
-				{
-					while (TscValue[i] <= psBSS(SlotIndex)->PairwiseTSC[j])
-					{
-						j--;
-						if (i<0)
-							break;
-					}
-					if (i>=0)
-						memcpy(psBSS(SlotIndex)->PairwiseTSC, TscValue, 6);
-					else
-					{
-						WBDEBUG(("pairwise replay\n"));
-						return;//replay
-					}
-				}
-				else//group
-				{
-					while (TscValue[j] <= psBSS(SlotIndex)->GroupTSC[j])
-					{
-						j--;
-						if (j<0)
-							break;
-					}
-					if (j>=0)
-						memcpy(psBSS(SlotIndex)->GroupTSC, TscValue, 6);
-					else
-					{
-						WBDEBUG(("group replay\n"));
-						return;//replay
-					}
-				}
-*/
+			if (memcmp( pframe_mic, mic, 8) == 0) {
 				//exclude the MIC
 				pRxLayer1->BufferQueue[ LastBufIdx ].BufferSize -= 8;
-			}
-			else
-			{
+			} else {
 
 				WBDEBUG(("!!!!!! MIC error !!!!!!\n"));
 
 				#ifdef NDIS51_MINIPORT
 				if (mic_key == psSME->rx_mic_key)
 					{ MDS_EVENT_INDICATE( Adapter,
-										  psBSS(Adapter->sLocalPara.wConnectedSTAindex)->abBssID,
-										  AUTH_REQUEST_PAIRWISE_ERROR ); }
+							      psBSS(Adapter->sLocalPara.wConnectedSTAindex)->abBssID,
+							      AUTH_REQUEST_PAIRWISE_ERROR ); }
 				else
 					{ MDS_EVENT_INDICATE( Adapter,
-										  psBSS(Adapter->sLocalPara.wConnectedSTAindex)->abBssID,
-										  AUTH_REQUEST_GROUP_ERROR ); }
+							      psBSS(Adapter->sLocalPara.wConnectedSTAindex)->abBssID,
+							      AUTH_REQUEST_GROUP_ERROR ); }
 
 				Adapter->Mds.bMICfailCount++;
 
-				if (Adapter->Mds.bMICfailCount == 1)
-				{
-					vRxTimerStart(Adapter, 60000);//60s
+				if (Adapter->Mds.bMICfailCount == 1) {
+					vRxTimerStart(Adapter, 60000); //60s
 				}
-				if (Adapter->Mds.bMICfailCount == 2)
-				{
+				if (Adapter->Mds.bMICfailCount == 2) {
 					Adapter->Mds.boCounterMeasureBlock = 1;
 					#ifdef _PE_RX_DUMP_
 					WBDEBUG(("!!!!!! Countermeasure Block  !!!!!!\n"));
@@ -249,20 +189,19 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 		// Updating the MSDU counter 'GS_RCV_OK'
 		MIB_GS_RCV_OK_INC;
 
-		//Get the Source address
+		// Get the Source address
 		SourceAddress = pDFrame->Addr3;
-		if( !frame_control.from_ds )
+		if (!frame_control.from_ds)
 			SourceAddress = pDFrame->Addr2;
 
 		BufSize = pRxLayer1->BufferQueue[0].BufferSize;
 		BufAddr = pRxLayer1->BufferQueue[0].pBufferAddress;
 
-		//Point to the frame body
+		// Point to the frame body
 		BufAddr += (DOT_11_TYPE_OFFSET - ETH_LENGTH_OF_ADDRESS); // offset 24 is 4n alignment @@
 
 		// PD43 20021220 Added for Type/Length encapsulation adjust
-		// YY's endian
-		if( *(PULONG)BufAddr==cpu_to_le32(0x0003aaaa)      && // little endian // @@ 4n alignment here
+		if (*(PULONG)BufAddr==cpu_to_le32(0x0003aaaa)      && // little endian // @@ 4n alignment here
 			*(PULONG)(BufAddr+4)!=cpu_to_le32(0x37810000)  && //PD43 20030418 Modified for HCT 11 // @@ 4n alignment here
 			(*(PUSHORT)(BufAddr+4)==0 || *(PUSHORT)(BufAddr+4)==cpu_to_le16(0xf800)) ) // @@ 4n alignment here
 		{
@@ -270,9 +209,7 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 			// Do nothing here
 			pRxLayer1->TypeEncapsulated = TRUE;
 			pRxLayer1->BufferQueue[0].BufferSize -= 18;
-		}
-		else
-		{
+		} else {
 			// Converted to Length-encapsulated 802.3 frame.
 			// Reserved 2 bytes for length field.
 			BufAddr -= (2 + ETH_LENGTH_OF_ADDRESS);
@@ -289,11 +226,9 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 		pRxLayer1->BufferQueue[0].pBufferAddress = BufAddr;
 
 		// Is 802.3 frame format?
-		if( !pRxLayer1->TypeEncapsulated )
-		{
+		if (!pRxLayer1->TypeEncapsulated) {
 			_8023FrameSize = 0; // PD43 20021220 Added
-			for( i=0; i<pRxLayer1->BufferNumber; i++ )
-			{
+			for (i=0; i<pRxLayer1->BufferNumber; i++) {
 				BufSize = pRxLayer1->BufferQueue[i].BufferSize;
 				_8023FrameSize += BufSize;
 			}
@@ -306,12 +241,10 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 		}
 
 		// Indicate to Upper Module
-		MDS_EthernetPacketReceive( Adapter, pRxLayer1 );
-		Adapter->sLocalPara._NumRxMSDU ++;// A packet be indicated
-	}
-	else
-	{
-		if( !WEPed )
+		MDS_EthernetPacketReceive(Adapter, pRxLayer1);
+		Adapter->sLocalPara._NumRxMSDU++; // A packet be indicated
+	} else	{
+		if (!WEPed)
 			Adapter->sLocalPara._dot11WEPExcludedCount ++;
 		else
 			Adapter->sLocalPara._dot11WEPUndecryptableCount ++;
diff --git a/drivers/net/wireless/winbond/winbondport/scan_probe.c b/drivers/net/wireless/winbond/winbondport/scan_probe.c
index 1adaef5..aaf9442 100644
--- a/drivers/net/wireless/winbond/winbondport/scan_probe.c
+++ b/drivers/net/wireless/winbond/winbondport/scan_probe.c
@@ -17,41 +17,39 @@ #include "os_common.h"
 //============================================================================
 int SendProbeRequest(PWB32_ADAPTER Adapter, struct SSID_Element *SSID)
 {
+	struct Management_Frame*    msgHeader;
+	PUCHAR   msg;
+	u16      iCurrentLocation = 0;
+	u8 	 BasicRate[8], OpRate[MAX_OPT_RATE_SET], BasicRateCount, OpRateCount;
+	u8	 i, j, BitIndex;
+	u32	 BasicRateBitmap, OpRateBitmap, tmp;
 
-    struct Management_Frame*    msgHeader;
-    PUCHAR      msg;
-    u16      iCurrentLocation = 0;
-	u8 		BasicRate[8], OpRate[MAX_OPT_RATE_SET], BasicRateCount, OpRateCount;
-	u8		i, j, BitIndex;
-	u32		BasicRateBitmap, OpRateBitmap, tmp;
-
-    // Get the free data buffer
-	if ((msg = MLMEGetMMPDUBuffer(Adapter)) == NULL)
-    {
-        // No available data buffer now. Stop send the MMPDU.
+	// Get the free data buffer
+	if ((msg = MLMEGetMMPDUBuffer(Adapter)) == NULL) {
+		// No available data buffer now. Stop send the MMPDU.
 		Adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
-        return -1;
-    }
+		return -1;
+	}
 	msgHeader = (struct Management_Frame*) &msg[0];
 
 	// first setup the frame_control header
 	msgHeader->frame_control.mac_frame_info = MAC_SUBTYPE_MNGMNT_PROBE_REQUEST;
-    msgHeader->frame_control.to_ds      = 0;  // = 0 for management frame
-    msgHeader->frame_control.from_ds    = 0;  // = 0 for management frame
-    msgHeader->frame_control.more_frag  = 0;
+	msgHeader->frame_control.to_ds      = 0;  // = 0 for management frame
+	msgHeader->frame_control.from_ds    = 0;  // = 0 for management frame
+	msgHeader->frame_control.more_frag  = 0;
 	msgHeader->frame_control.retry		= 0;
-    msgHeader->frame_control.more_data  = 0;
+	msgHeader->frame_control.more_data  = 0;
 	msgHeader->frame_control.order		= 0;
-    msgHeader->frame_control.pwr_mgt    = 0;
-    msgHeader->frame_control.WEP        = 0;
-    msgHeader->duration                 = 0;  // Set by the MDS
+	msgHeader->frame_control.pwr_mgt    = 0;
+	msgHeader->frame_control.WEP        = 0;
+	msgHeader->duration                 = 0;  // Set by the MDS
 
 	// now do the addresses
-    memcpy( msgHeader->DA, "\xff\xff\xff\xff\xff\xff", MAC_ADDR_LENGTH );
+	memcpy( msgHeader->DA, "\xff\xff\xff\xff\xff\xff", MAC_ADDR_LENGTH );
 	memcpy( msgHeader->SA, Adapter->sLocalPara.ThisMacAddress, MAC_ADDR_LENGTH );
 	memcpy( msgHeader->BSSID, psSCAN->BSSID, MAC_ADDR_LENGTH );
 	
-    msgHeader->Sequence_Control         = 0;    //Will be filled by HW-MAC
+	msgHeader->Sequence_Control         = 0;    //Will be filled by HW-MAC
 	
 	iCurrentLocation = sizeof(struct Management_Frame);
 
@@ -60,27 +58,21 @@ int SendProbeRequest(PWB32_ADAPTER Adapt
 	iCurrentLocation += (SSID->Length+2);
 
 	// now do the supported rates
-	//11G TODO:
 
-	if (psLOCAL->bMacOperationMode == MODE_802_11_A)
-	{
+	if (psLOCAL->bMacOperationMode == MODE_802_11_A) {
 		BasicRateBitmap = LOCAL_11A_BASIC_RATE_BITMAP;
 		OpRateBitmap = LOCAL_11A_OPERATION_RATE_BITMAP;
 	}
-	else if (psLOCAL->bMacOperationMode == MODE_802_11_B)
-	{
+	else if (psLOCAL->bMacOperationMode == MODE_802_11_B) {
 		BasicRateBitmap = LOCAL_11B_BASIC_RATE_BITMAP;
 		OpRateBitmap = LOCAL_11B_OPERATION_RATE_BITMAP;
-	}
-	else
-	{
+	} else {
 		BasicRateBitmap = LOCAL_11G_BASIC_RATE_BITMAP;
 		OpRateBitmap = LOCAL_11G_OPERATION_RATE_BITMAP;
 	}
 
 	i = j = 0;
-	for (BitIndex=0 ; BitIndex<32; BitIndex++)
-	{
+	for (BitIndex=0 ; BitIndex<32; BitIndex++) {
 		tmp = 1<<BitIndex;
 		if (BasicRateBitmap&tmp)
 			BasicRate[i++] = 0x80 | bBitmapToRate(BitIndex);
@@ -91,22 +83,18 @@ int SendProbeRequest(PWB32_ADAPTER Adapt
 	OpRateCount = j;
 
 	DesiredRate2InfoElement(Adapter, msg, &iCurrentLocation,
-							BasicRate, BasicRateCount,
-							OpRate, OpRateCount);
+				BasicRate, BasicRateCount,
+				OpRate, OpRateCount);
 
-	// 20061108 WPS IE append if necessary
-	if( psLOCAL->IE_Append_size )
-	{
-		memcpy( &msg[iCurrentLocation], psLOCAL->IE_Append_data, psLOCAL->IE_Append_size );
+	if( psLOCAL->IE_Append_size ) {
+		memcpy(&msg[iCurrentLocation], psLOCAL->IE_Append_data, psLOCAL->IE_Append_size);
 		iCurrentLocation += psLOCAL->IE_Append_size;
 	}
 
-    // now send this message out
-	if (1 == MLMESendFrame( Adapter,
-					(u8 *)&msg[0],
-					iCurrentLocation,
-					FRAME_TYPE_802_11_MANAGEMENT))
-        return 1;                           // Has sent to the Tx handler.
+	// now send this message out
+	if (1 == MLMESendFrame(Adapter, (u8 *)&msg[0], iCurrentLocation,
+			       FRAME_TYPE_802_11_MANAGEMENT))
+		return 1;                           // Has sent to the Tx handler.
 	else
 	{
 		//return MLME buffer
diff --git a/drivers/net/wireless/winbond/winbondport/scantask.c b/drivers/net/wireless/winbond/winbondport/scantask.c
index a414c85..d64db2b 100644
--- a/drivers/net/wireless/winbond/winbondport/scantask.c
+++ b/drivers/net/wireless/winbond/winbondport/scantask.c
@@ -20,10 +20,8 @@ static void vScanProc_ActiveNextChannel(
 void vScanTimerStart(PWB32_ADAPTER Adapter, int timeout_value);
 void vScanTimerStop(PWB32_ADAPTER Adapter);
 void ScanTimerHandler_1a(	void* Data);
-void ScanTimerHandler(	void*			SystemSpecific1,
-							  PWB32_ADAPTER 	Adapter,
-							 	void*			SystemSpecific2,
-							 	void*			SystemSpecific3);
+void ScanTimerHandler(void* SystemSpecific1, PWB32_ADAPTER Adapter,
+		      void* SystemSpecific2, void* SystemSpecific3);
 u16 wRetrieveInformation(PWB32_ADAPTER Adapter, u16 index, psRXDATA psRxFrame);
 void StartIbssCheck(PWB32_ADAPTER Adapter, u16 wBssIdx);
 
@@ -39,7 +37,6 @@ static void vScanProc_StopScan(PWB32_ADA
 static void vScanProc_RcvProbeRsp(PWB32_ADAPTER Adapter, K_MSG* psMsg);
 static void vScanProc_RcvBeacon(PWB32_ADAPTER Adapter, K_MSG* psMsg);
 //Never used nowdays
-//static void vScanProc_TxProbeFail(PWB32_ADAPTER Adapter, K_MSG* psMsg);
 static void vStart_BgScanTimer(PWB32_ADAPTER Adapter, K_MSG* psMsg);
 static void vStart_BgScan(PWB32_ADAPTER Adapter, K_MSG* psMsg);
 
@@ -209,28 +206,21 @@ void vScanProc_ActiveNextChannel(PWB32_A
 		{
 			psSCAN->wState = SCAN_COMPLETE;
 			//Decide the best antenna
-			if (psLOCAL->wConnectedSTAindex == 0)
-			{
+			if (psLOCAL->wConnectedSTAindex == 0) {
 				if (psSCAN->RxNumPerAntenna[0] > psSCAN->RxNumPerAntenna[1])
 					BestAntenna = 0;
 				else
 					BestAntenna = 1;
-				//WBDEBUG(("Rx at Antenna 0 =%d, Rx at Antenna 1 =%d\n",
-				//			psSCAN->RxNumPerAntenna[0], psSCAN->RxNumPerAntenna[1]));
-				//WBDEBUG(("The best antenna is %d\n", BestAntenna));
-				if( Adapter->sLocalPara.boAntennaDiversity ) // 20060613.5 Add
-				{
-					if (psLOCAL->bAntennaNo != BestAntenna)
-					{
+
+				if (Adapter->sLocalPara.boAntennaDiversity) {
+					if (psLOCAL->bAntennaNo != BestAntenna) {
 						psLOCAL->bAntennaNo = BestAntenna;
 						hal_set_antenna_number(&Adapter->sHwData, psLOCAL->bAntennaNo);
 					}
 				}
 			}
 			//for BG-scan to return to the channel of connected STA
-			//if ((i=psLOCAL->wConnectedSTAindex) != 0)
-			if ((i=psSME->wDesiredJoinBSS) != 0)
-			{
+			if ((i=psSME->wDesiredJoinBSS) != 0) {
 				ChanInfo ChanTmp;
 
 				ChanTmp.band = psBSS(i)->band;
@@ -308,9 +298,6 @@ void vScanTimerStart(PWB32_ADAPTER Adapt
 
 void vScanTimerStop(PWB32_ADAPTER Adapter)
 {
-
-	//psSCAN->boTimerActive = FALSE;  // can be removed
-    ///NdisMCancelTimer(&psSCAN->nTimer, &boValue);
 	OS_TIMER_CANCEL( &psSCAN->nTimer, &boValue );
 	#ifdef _PE_STATE_DUMP_
 	WBDEBUG(("STATE: scan cancel timer return valule =%x\n", boValue));
@@ -323,15 +310,13 @@ void ScanTimerHandler_1a( void* Data)
 	ScanTimerHandler(NULL, (PWB32_ADAPTER)Data, NULL, NULL);
 }
 
-void ScanTimerHandler( void*			SystemSpecific1,
-					   PWB32_ADAPTER 	Adapter,
-					   void*			SystemSpecific2,
-					   void*			SystemSpecific3)
+void ScanTimerHandler(void* SystemSpecific1, PWB32_ADAPTER Adapter,
+		      void* SystemSpecific2, void* SystemSpecific3)
 {
 	K_MSG sTimerMsg;
 
 	psSCAN->boInTimerHandler = TRUE;
-    sTimerMsg.wMsgType = SCANMSG_TIMEOUT;
+	sTimerMsg.wMsgType = SCANMSG_TIMEOUT;
 	sTimerMsg.pMsgPtr = NULL;
 	Scan_Entry(Adapter, &sTimerMsg);
 	psSCAN->boInTimerHandler = FALSE;
@@ -513,24 +498,19 @@ void vScanProc_StopScan(PWB32_ADAPTER Ad
 	WBDEBUG(("-----------STATE: STOP Scan--------------\n"));
 	#endif
 
-	//hal_set_accept_beacon(&Adapter->sHwData, FALSE);
 	vScanTimerStop(Adapter);
-	//Adapter->Mds.TxPause = FALSE;  // Enable Tx frame
-	//Adapter->Mds.ScanTxPause = FALSE;
+
 	psSCAN->wState = SCAN_COMPLETE;
 	hal_scan_status_indicate(&Adapter->sHwData, 0);	// complete
-	if (psMsg->pMsgPtr != NULL)	//come from Disassoc request
-	{
+	if (psMsg->pMsgPtr != NULL) {	//come from Disassoc request
 		sSmeMsg.wMsgType = SMEMSG_SCAN_CFM;
 		sSmeMsg.wInstance = 0;
 		sSmeMsg.pMsgPtr = NULL;
 		SME_Entry(Adapter, &sSmeMsg);
-	}
-	else
-	{
+	} else {
 		Adapter->Mds.TxPause = FALSE;  // Enable Tx frame
 		Adapter->Mds.ScanTxPause = FALSE;
-		//restart HWMAC Tx frame
+		// restart HWMAC Tx frame
 		hal_start_tx0(&Adapter->sHwData);
 	}
 }
@@ -582,8 +562,6 @@ void vScanProc_RcvProbeRsp(PWB32_ADAPTER
 void vScanProc_RcvBeacon(PWB32_ADAPTER Adapter, K_MSG* psMsg)
 {
 	u16 wBssIdx;
-	//u32	dwData;
-	//u8	BSSID[MAC_ADDR_LENGTH];
 	phw_data_t	pHwData = &Adapter->sHwData;
 
 	#ifdef _PE_RX_DUMP_
@@ -696,8 +674,8 @@ void vStart_BgScan(PWB32_ADAPTER Adapter
 	if (psSME->bDesiredPowerSave)
 	{
 		if ((psLOCAL->wConnectedSTAindex == 0) ||
-				((psLOCAL->wConnectedSTAindex != 0) &&
-								 (psBSS(psLOCAL->wConnectedSTAindex)->bBssType == ESS_NET)))
+		    ((psLOCAL->wConnectedSTAindex != 0) &&
+		     (psBSS(psLOCAL->wConnectedSTAindex)->bBssType == ESS_NET)))
 		{
 			K_MSG	sSmeMsg;
 			u8		PsMode;
@@ -718,8 +696,7 @@ void vStart_BgScan(PWB32_ADAPTER Adapter
 	psSCAN->AntennaToggle = 0;
 	hal_set_current_channel(&Adapter->sHwData, psSCANREQ->sChannelList.Channel[0]);
 	psSCAN->iCurrentChannelIndex = 0;
-	if (psSCANREQ->ScanType == ACTIVE_SCAN)
-	{
+	if (psSCANREQ->ScanType == ACTIVE_SCAN) {
 		K_MSG sTimerMsg;
 
 		Adapter->Mds.ScanTxPause = TRUE;
@@ -729,29 +706,13 @@ void vStart_BgScan(PWB32_ADAPTER Adapter
 		//vScanTimerStart(Adapter, (int)(psSCAN->ProbeDelay/1000)); 
 		psSCAN->wState = WAIT_PROBE_DELAY;
 
-
-
-	    sTimerMsg.wMsgType = SCANMSG_TIMEOUT;
+		sTimerMsg.wMsgType = SCANMSG_TIMEOUT;
 		sTimerMsg.pMsgPtr = NULL;
 		Scan_Entry(Adapter, &sTimerMsg);
-
-	}
-	else //(psSCAN->bScanType == PASSIVE_SCAN)
-	{	// NOTE: complete BG-Scan, should tune Chan to CONNECTED Chan
+	} else {	// NOTE: complete BG-Scan, should tune Chan to CONNECTED Chan
 		Adapter->Mds.TxPause = TRUE; // Start BG scan,stop Tx
 		//hal_set_accept_beacon(&Adapter->sHwData, TRUE);
 		vScanTimerStart(Adapter, psSCAN->MaxChannelTime);
 		psSCAN->wState = WAIT_BEACON_MAX_PASSIVE;
 	}
 }
-
-/*
-void vScanProc_TxProbeFail(PWB32_ADAPTER Adapter, K_MSG* psMsg)
-{
-	if (psSCANREQ->ScanType == ACTIVE_SCAN)
-	{
-		vScanTimerStart(Adapter, (int)(psSCAN->ProbeDelay/1000));
-		psSCAN->wState = WAIT_PROBE_DELAY;
-	}
-}
-*/
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index f1912e0..6599538 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -2,7 +2,7 @@ #include "os_common.h"
 
 
 
-void hal_start_tx0(  phw_data_t pHwData )
+void hal_start_tx0(phw_data_t pHwData)
 {
 	if (!pHwData->SurpriseRemove)
 		Wb35Tx_start( pHwData );
@@ -85,7 +85,7 @@ unsigned char hal_set_mapping_key( phw_d
 	Wb35Reg_Write( pHwData, 0x0840, pWb35Reg->M40_MacControl );
 
 	// Set key table contain
-	OS_MEMORY_CLEAR( Key_content, sizeof(KEY_TABLE)+ 16 + 8 ); // 8 bytes for burst writing
+	memset(Key_content, 0, sizeof(KEY_TABLE)+ 16 + 8); // 8 bytes for burst writing
 	pKey = (PKEY_TABLE)(Key_content + 4 ); // Space 4 byte for burst command
 
 	pValue = (u8 *)pKey;
@@ -341,27 +341,26 @@ void hal_clear_all_key( phw_data_t pHwDa
 	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp+16, MAX_KEY_TABLE-16, NO_INCREMENT );
 	memset( pHwData->Key_slot[0], 0, MAX_KEY_TABLE*8 ); // 20060214 for recover
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_get_ethernet_address( phw_data_t pHwData, PUCHAR current_address )
 {
 	if( pHwData->SurpriseRemove ) return;
 
 	memcpy( current_address, pHwData->CurrentMacAddress, ETH_LENGTH_OF_ADDRESS );
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_set_ethernet_address( phw_data_t pHwData, PUCHAR current_address )
 {
-	u32 ltmp[2];  //20060926 add by anson's endian
+	u32 ltmp[2];
 
 	if( pHwData->SurpriseRemove ) return;
 
 	memcpy( pHwData->CurrentMacAddress, current_address, ETH_LENGTH_OF_ADDRESS );
-	//--- 20060926 add by anson's endian
+
 	ltmp[0]= cpu_to_le32( *(PULONG)pHwData->CurrentMacAddress );
 	ltmp[1]= cpu_to_le32( *(PULONG)(pHwData->CurrentMacAddress + 4) ) & 0xffff;
-	//--- end 20060926 add by anson's endia
-	//Wb35Reg_BurstWrite( pHwData,0x03e8, (PULONG)pHwData->CurrentMacAddress, 2, AUTO_INCREMENT );
-	Wb35Reg_BurstWrite( pHwData,0x03e8, ltmp, 2, AUTO_INCREMENT ); //20060926 add by anson's endian
+
+	Wb35Reg_BurstWrite( pHwData, 0x03e8, ltmp, 2, AUTO_INCREMENT );
 }
 
 void hal_get_permanent_address( phw_data_t pHwData, PUCHAR pethernet_address )
@@ -418,8 +417,8 @@ u8 hal_init_hardware(phw_data_t pHwData,
 	return FALSE;
 }
 
-//-------------------------------------------------------------------------------
-void hal_halt(  phw_data_t pHwData,  void *ppa_data )
+
+void hal_halt( phw_data_t pHwData, void *ppa_data)
 {
 	switch( pHwData->InitialResource )
 	{
@@ -433,9 +432,8 @@ void hal_halt(  phw_data_t pHwData,  voi
 	}
 }
 
-//--------------------------------------------------------------------------------
 void
-hal_set_power_save_mode(  phw_data_t pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim )
+hal_set_power_save_mode(phw_data_t pHwData, unsigned char power_save, unsigned char wakeup,  unsigned char dtim )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	u32		Value;
@@ -443,7 +441,6 @@ hal_set_power_save_mode(  phw_data_t pHw
 	if( pHwData->SurpriseRemove ) return;
 
 	// Power save setting
-	//pHwData->desired_power_save = power_save;
 	pWb35Reg->M24_MacControl &= ~0x0200c000;	//clear ps-poll and pwr active/save bits
 
 	if (power_save) {
@@ -479,7 +476,7 @@ void hal_get_power_save_mode(  phw_data_
 	Wb35Reg_Read( pHwData, 0x084c, &pWb35Reg->M4C_MacStatus );
 	pHwData->power_save_point = pin_pwr_save;
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_set_slot_time( phw_data_t pHwData,  u8 type )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
@@ -728,8 +725,8 @@ void hal_set_cap_info(  phw_data_t pHwDa
 	pWb35Reg->M38_MacControl |= tmp;
 	Wb35Reg_Write( pHwData, 0x0838, pWb35Reg->M38_MacControl );
 }
-//---------------------------------------------------------------------------------------------------
-void hal_set_ssid(  phw_data_t pHwData,  PUCHAR pssid,  u8 ssid_len )
+
+void hal_set_ssid(phw_data_t pHwData,  PUCHAR pssid,  u8 ssid_len)
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	u32		pltmp[9]; // 1 burst command + 8 DW SSID max
@@ -742,7 +739,6 @@ void hal_set_ssid(  phw_data_t pHwData, 
 	memset( (PUCHAR)pltmp, 0, 36 );
 	//NOTE [WK endian]: ssid values will be tranfered by cpu_to_le32 in Wb35Reg_BurstWrite().
 	//			 The ssid values must be tranfered first but burst cmd is not necessary.
-	//memcpy( (PUCHAR)(pltmp+1), pssid, ssid_len );
 	
 	pHwData->ssid_length = ssid_len;
 
@@ -784,7 +780,6 @@ void hal_set_current_channel_ex(  phw_da
 void hal_set_current_channel(  phw_data_t pHwData,  ChanInfo channel )
 {
 	PADAPTER	Adapter = pHwData->Adapter;
-//	PTESTSTA	pTestSta = &Adapter->sTestSta;
 
 	if( TS_RUNNING_IN_TESTSTA_MODE )
 		return; // Ignore setting if access right is not owned by NDIS
@@ -811,7 +806,7 @@ void hal_set_accept_broadcast(  phw_data
     
 	Wb35Reg_Write( pHwData, 0x0800, pWb35Reg->M00_MacControl );
 }
-//---------------------------------------------------------------------------------------------------
+
 //for wep key error detection, we need to accept broadcast packets to be received temporary.
 void hal_set_accept_promiscuous( phw_data_t pHwData,  u8 enable)
 {   
@@ -826,7 +821,7 @@ void hal_set_accept_promiscuous( phw_dat
 		Wb35Reg_Write( pHwData, 0x0800, pWb35Reg->M00_MacControl );
 	}
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_set_accept_multicast(  phw_data_t pHwData,  u8 enable )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
@@ -837,7 +832,7 @@ void hal_set_accept_multicast(  phw_data
 	if (enable)  pWb35Reg->M00_MacControl |= 0x01000000;//The HW value
 	Wb35Reg_Write( pHwData, 0x0800, pWb35Reg->M00_MacControl );
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_set_accept_beacon(  phw_data_t pHwData,  u8 enable )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
@@ -889,32 +884,30 @@ u8 hal_get_accept_beacon(  phw_data_t pH
 	else
 		return 0;
 }
-//---------------------------------------------------------------------------------------------------
+
 unsigned char hal_reset_hardware( phw_data_t pHwData, void* ppa )
 {
 	// Not implement yet
 	return TRUE;
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_stop(  phw_data_t pHwData )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 
-	pHwData->Wb35Rx.rx_halt = 1; // 20051222.3 Move here for supriseremove
+	pHwData->Wb35Rx.rx_halt = 1;
 	Wb35Rx_stop( pHwData );
 
 	pHwData->Wb35Tx.tx_halt = 1;
 	Wb35Tx_stop( pHwData );
 
-//	if( pHwData->SurpriseRemove ) return;
-
 	pWb35Reg->D00_DmaControl &= ~0xc0000000;//Tx Off, Rx Off
 	Wb35Reg_Write( pHwData, 0x0400, pWb35Reg->D00_DmaControl );
 
 	WbUsb_Stop( pHwData ); // 20051230 Add.4
 }
-//---------------------------------------------------------------------------------------------------
-unsigned char	hal_idle(  phw_data_t pHwData )
+
+unsigned char hal_idle(phw_data_t pHwData)
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	PWBUSB	pWbUsb = &pHwData->WbUsb;
@@ -948,52 +941,51 @@ void hal_set_cwmax(  phw_data_t pHwData,
 	pWb35Reg->M2C_MacControl |= pHwData->cwmax;
 	Wb35Reg_Write( pHwData, 0x082c, pWb35Reg->M2C_MacControl );
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_set_rsn_wpa(  phw_data_t pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type,  unsigned char bDesiredAuthMode)
 {
-    PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
+	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	u32		pltmp[2];
 
 	if( pHwData->SurpriseRemove ) return;
 
-	#ifdef _PE_STATE_DUMP_
-    WBDEBUG(("[WS]hal_set_rsn_wpa\n"));
-    WBDEBUG(("[WS]hal_RSN_IE_Bitmap=%x\n",*RSN_IE_Bitmap));
-    WBDEBUG(("[WS]hal_RSN_OUI_type=%x\n",*RSN_OUI_type));
-	#endif
+#ifdef _PE_STATE_DUMP_
+	WBDEBUG(("[WS]hal_set_rsn_wpa\n"));
+	WBDEBUG(("[WS]hal_RSN_IE_Bitmap=%x\n",*RSN_IE_Bitmap));
+	WBDEBUG(("[WS]hal_RSN_OUI_type=%x\n",*RSN_OUI_type));
+#endif
 
-    pWb35Reg->M24_MacControl &= ~0x500000;
-    switch (bDesiredAuthMode)
+	pWb35Reg->M24_MacControl &= ~0x500000;
+	switch (bDesiredAuthMode)
 	{
-		case OPEN_AUTH:
-		case SHARE_AUTH:break;
-
-	    case WPA_AUTH:
-		case WPAPSK_AUTH:
-		case WPANONE_AUTH:
-			pWb35Reg->M24_MacControl |= 0x500000;
-			break;
-        #ifdef _WPA2_
-	    case WPA2_AUTH:
-		case WPA2PSK_AUTH:
-			pWb35Reg->M24_MacControl |= 0x100000;
-			break;
-        #endif //_WPA2_
+	case OPEN_AUTH:
+	case SHARE_AUTH:break;
+
+	case WPA_AUTH:
+	case WPAPSK_AUTH:
+	case WPANONE_AUTH:
+		pWb35Reg->M24_MacControl |= 0x500000;
+		break;
+#ifdef _WPA2_
+	case WPA2_AUTH:
+	case WPA2PSK_AUTH:
+		pWb35Reg->M24_MacControl |= 0x100000;
+		break;
+#endif //_WPA2_
         
-		default:
-			break;
+	default:
+		break;
 	}
 	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
 
-    //pWb35Reg->M24_MacControl = 0x00140042;
+	//pWb35Reg->M24_MacControl = 0x00140042;
 	memcpy( &pltmp[0], RSN_IE_Bitmap, sizeof(u32) );
 	memcpy( &pltmp[1], RSN_OUI_type, sizeof(u32) );
 	pWb35Reg->M70_MacControl = pltmp[0];
 	pWb35Reg->M74_MacControl = pltmp[1];
 	Wb35Reg_BurstWrite( pHwData, 0x0870, pltmp, 2, AUTO_INCREMENT );
 }
-//----------------------------------------------------------------------------------------------------
-//s32 hal_get_rssi(  phw_data_t pHwData,  u32 HalRssi )
+
 s32 hal_get_rssi(  phw_data_t pHwData,  u32 *HalRssiArry,  u8 Count )
 {
 	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
@@ -1444,17 +1436,17 @@ void hal_set_radio_mode( phw_data_t pHwD
 	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
 }
 
-void hal_descriptor_indicate(  phw_data_t pHwData,  PDESCRIPTOR pRxDes )
+void hal_descriptor_indicate(phw_data_t pHwData, PDESCRIPTOR pRxDes)
 {
 	PADAPTER Adapter = pHwData->Adapter;
 
-	if( !pHwData->IsInitOK ) // 20060717.3 Add
+	if (!pHwData->IsInitOK)
 		return;
 
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-		{ TS_MpduProcess( Adapter, pRxDes ); }
+	if (TS_RUNNING_IN_TESTSTA_MODE)
+		{ TS_MpduProcess(Adapter, pRxDes); }
 	else
-		{ Mds_MpduProcess( Adapter, pRxDes ); }
+		{ Mds_MpduProcess(Adapter, pRxDes); }	/* Ouch, MpduProcess has three parameters but we only pass two?! */
 }
 
 u8 hal_get_antenna_number(  phw_data_t pHwData )
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal_s.h b/drivers/net/wireless/winbond/winbondport/wbhal_s.h
index df61e3e..345a03d 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wbhal_s.h
@@ -25,7 +25,7 @@ #define hal_join_OK( _H ) \
 	K_MSG sSmeMsg;\
 	sSmeMsg.wMsgType = SMEMSG_TSF_SYNC_IND;\
 	sSmeMsg.wInstance = 0;\
-    sSmeMsg.pMsgPtr = NULL;\
+	sSmeMsg.pMsgPtr = NULL;\
 	SME_Entry( _H->Adapter, &sSmeMsg);\
 }
 
@@ -40,31 +40,7 @@ #define hal_set_chan_complete( _A, _B )	
 
 
 
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-////////////////////////////////////////////////////////////////////////////////////////////////////////
+/////////////////////////////////////////////////////////////////////////////////////////////////////
 //================================================================================================
 // Common define
 //================================================================================================
@@ -74,12 +50,12 @@ #define HAL_USB_MODE_BURST( _H )	(_H->So
 #define SCAN_MAX_CHNL_TIME				(50)
 
 // For TxL2 Frame typr recognise
-#define FRAME_TYPE_802_3_DATA					0
-#define FRAME_TYPE_802_11_MANAGEMENT			1
+#define FRAME_TYPE_802_3_DATA			0
+#define FRAME_TYPE_802_11_MANAGEMENT		1
 #define FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE  2   
-#define FRAME_TYPE_802_11_CONTROL				3
-#define FRAME_TYPE_802_11_DATA					4
-#define FRAME_TYPE_PROMISCUOUS					5
+#define FRAME_TYPE_802_11_CONTROL		3
+#define FRAME_TYPE_802_11_DATA			4
+#define FRAME_TYPE_PROMISCUOUS			5
 
 // The follow definition is used for convert the frame--------------------
 #define DOT_11_SEQUENCE_OFFSET		22 //Sequence control offset
@@ -113,16 +89,14 @@ #define HAL_KEYTYPE_TKIP                
 #define HAL_KEYTYPE_AES_CCMP                    3 // 128 bit key
 
 // For VM state
-enum
-{
+enum {
 	VM_STOP = 0,
 	VM_RUNNING,
 	VM_COMPLETED
 };
 
 // Be used for 802.11 mac header
-typedef struct _MAC_FRAME_CONTROL
-{
+typedef struct _MAC_FRAME_CONTROL {
 	u8	mac_frame_info; // this is a combination of the protovl version, type and subtype
 	u8	to_ds:1;
 	u8	from_ds:1;
@@ -385,10 +359,9 @@ typedef struct _T02_DESCRIPTOR
 	};
 } T02_DESCRIPTOR, *PT02_DESCRIPTOR;
 
-typedef struct _DESCRIPTOR		// Skip length = 8 DWORD
-{
+typedef struct _DESCRIPTOR {		// Skip length = 8 DWORD
 	// ID for descriptor ---, The field doesn't be cleard in the operation of Descriptor definition
-	u8	Descriptor_ID;// 931130.4.p
+	u8	Descriptor_ID;
 	//----------------------The above region doesn't be cleared by DESCRIPTOR_RESET------
 	u8	RESERVED[3];
 
@@ -446,7 +419,7 @@ typedef struct _DESCRIPTOR		// Skip leng
 //=======================================================
 // Common operation for DESCRIPTOR
 //=======================================================
-#define DESCRIPTOR_RESET( _D ) OS_MEMORY_CLEAR( (PUCHAR)_D + 1, sizeof(DESCRIPTOR) - 1 )
+#define DESCRIPTOR_RESET( _D ) memset((PUCHAR)_D + 1, 0, sizeof(DESCRIPTOR) - 1)
 #define DESCRIPTOR_ADD_BUFFER( _D, _A, _S ) \
 {\
 	_D->InternalUsed = _D->buffer_start_index + _D->buffer_number; \
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index 27dcca0..0b0b200 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -22,9 +22,9 @@ WBLINUX_MemoryAlloc(void* *VirtualAddres
 }
 
 s32
-EncapAtomicInc(  PADAPTER Adapter,  void* pAtomic )
+EncapAtomicInc(PADAPTER Adapter, void* pAtomic)
 {
-	PWBLINUX	pWbLinux = &Adapter->WbLinux;
+	PWBLINUX pWbLinux = &Adapter->WbLinux;
 	u32	ltmp;
 	PULONG	pltmp = (PULONG)pAtomic;
 	OS_SPIN_LOCK_ACQUIRED( &pWbLinux->AtomicSpinLock );
@@ -35,20 +35,20 @@ EncapAtomicInc(  PADAPTER Adapter,  void
 }
 
 s32
-EncapAtomicDec(  PADAPTER Adapter,  void* pAtomic )
+EncapAtomicDec(PADAPTER Adapter, void* pAtomic)
 {
-   PWBLINUX	pWbLinux = &Adapter->WbLinux;
-   u32	ltmp;
-   PULONG	pltmp = (PULONG)pAtomic;
-   OS_SPIN_LOCK_ACQUIRED( &pWbLinux->AtomicSpinLock );
-   (*pltmp)--;
-   ltmp = (*pltmp);
-   OS_SPIN_LOCK_RELEASED( &pWbLinux->AtomicSpinLock );
-   return ltmp;
+	PWBLINUX pWbLinux = &Adapter->WbLinux;
+	u32	ltmp;
+	PULONG	pltmp = (PULONG)pAtomic;
+	OS_SPIN_LOCK_ACQUIRED( &pWbLinux->AtomicSpinLock );
+	(*pltmp)--;
+	ltmp = (*pltmp);
+	OS_SPIN_LOCK_RELEASED( &pWbLinux->AtomicSpinLock );
+	return ltmp;
 }
 
 unsigned char
-WBLINUX_Initial(  PADAPTER Adapter )
+WBLINUX_Initial(PADAPTER Adapter)
 {
 	PWBLINUX pWbLinux = &Adapter->WbLinux;
 
@@ -112,7 +112,7 @@ int wb35_start_xmit(struct sk_buff *skb,
 	PADAPTER	Adapter = netdev->priv;
 	PWBLINUX	pWbLinux = &Adapter->WbLinux;
 	PUCHAR		pBufAddress = (PUCHAR)skb->data;
-	unsigned char		IsStop = FALSE;
+	unsigned char	IsStop = FALSE;
 
 #ifdef _PE_TX_DUMP_
 	WBDEBUG(( "[w35und]wb35_start_xmit->\n" ));
@@ -163,94 +163,91 @@ #endif
 	// Calling Mds for sending packet --------------------
 	Adapter->sLocalPara._NumTxMSDU++;
 	netdev->trans_start=jiffies;
-	Mds_Tx( Adapter );
+	Mds_Tx(Adapter);
 
 	return 0;// return 1 if asking kernel retry to send sk-buffer.
 }
 
 void
-WBLINUX_GetNextPacket(  PADAPTER Adapter,  PDESCRIPTOR pDes )
+WBLINUX_GetNextPacket(PADAPTER Adapter,  PDESCRIPTOR pDes)
 {
-   PWBLINUX	pWbLinux = &Adapter->WbLinux;
-   struct sk_buff  *pSkb;
-   u8 	        *pSkbBuffer;
-   int			    buf_size;
-
-   //Get a Linux packet to transmit
-   pSkb = pWbLinux->skb_array[ pWbLinux->skb_GetIndex ];
-   pWbLinux->skb_array[ pWbLinux->skb_GetIndex ] = NULL;
-
-   // Move the point to the next
-   pWbLinux->skb_GetIndex++;
-   pWbLinux->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
-
-   //================================================================================
-   // Fill the related information into descriptor												//
-   //================================================================================
-   pWbLinux->packet_return = pSkb;
-   pSkbBuffer = pSkb->data;
-   buf_size = pSkb->len;
-   pWbLinux->stats.tx_packets++; // 20060331 move here
-   pWbLinux->stats.tx_bytes += buf_size; // 20060331 move here
-
-   //931130.5.t
-   //		+------------+
-   //		| header + 2 |  <-- DA + SA + T/L
-   //		+------------+
-   //		+-------------------------------+
-   //		| data							|
-   //		+-------------------------------+
-   //					:
-   //					:
-   //
-   DESCRIPTOR_ADD_BUFFER( pDes, pSkbBuffer, DOT_3_TYPE_OFFSET+2 );
-   buf_size -= (DOT_3_TYPE_OFFSET+2);
-   pSkbBuffer += (DOT_3_TYPE_OFFSET+2);
-
-   if( buf_size )// Add the left data 931130.5.v
-     DESCRIPTOR_ADD_BUFFER( pDes, pSkbBuffer, (u16)buf_size );
+	PWBLINUX	pWbLinux = &Adapter->WbLinux;
+	struct sk_buff  *pSkb;
+	u8 	        *pSkbBuffer;
+	int		buf_size;
+
+	//Get a Linux packet to transmit
+	pSkb = pWbLinux->skb_array[ pWbLinux->skb_GetIndex ];
+	pWbLinux->skb_array[ pWbLinux->skb_GetIndex ] = NULL;
+
+	// Move the point to the next
+	pWbLinux->skb_GetIndex++;
+	pWbLinux->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
+
+	//================================================================================
+	// Fill the related information into descriptor												//
+	//================================================================================
+	pWbLinux->packet_return = pSkb;
+	pSkbBuffer = pSkb->data;
+	buf_size = pSkb->len;
+	pWbLinux->stats.tx_packets++; // 20060331 move here
+	pWbLinux->stats.tx_bytes += buf_size; // 20060331 move here
+
+	//931130.5.t
+	//		+------------+
+	//		| header + 2 |  <-- DA + SA + T/L
+	//		+------------+
+	//		+-------------------------------+
+	//		| data							|
+	//		+-------------------------------+
+	//					:
+	//					:
+	//
+	DESCRIPTOR_ADD_BUFFER( pDes, pSkbBuffer, DOT_3_TYPE_OFFSET+2 );
+	buf_size -= (DOT_3_TYPE_OFFSET+2);
+	pSkbBuffer += (DOT_3_TYPE_OFFSET+2);
+
+	if (buf_size)
+		DESCRIPTOR_ADD_BUFFER( pDes, pSkbBuffer, (u16)buf_size );
 }
 
 void
-  WBLINUX_GetNextPacketCompleted(  PADAPTER Adapter,  PDESCRIPTOR pDes )
+WBLINUX_GetNextPacketCompleted(PADAPTER Adapter, PDESCRIPTOR pDes)
 {
-   PWBLINUX	pWbLinux = &Adapter->WbLinux;
-   s32		room_space = 0;
-   struct sk_buff *pSkb;
-   unsigned char		IsStart = FALSE;
-
-   // Return the send result to LINUX
-   pSkb = pWbLinux->packet_return;
-   pWbLinux->packet_return = NULL;
-   if( in_irq() )
-     dev_kfree_skb_irq( pSkb );
-   else
-     dev_kfree_skb( pSkb );
-   MIB_GS_XMIT_OK_INC;
-
-   // Trying to wakeup the netif if necessary
-   if( pWbLinux->netif_state_stop )
-     {
-	room_space = pWbLinux->skb_GetIndex - pWbLinux->skb_SetIndex;
-	if( room_space < 0 ) // Ex: + + G + S + + +
-	  room_space += WBLINUX_PACKET_ARRAY_SIZE;
+	PWBLINUX	pWbLinux = &Adapter->WbLinux;
+	s32		room_space = 0;
+	struct sk_buff *pSkb;
+	unsigned char		IsStart = FALSE;
+
+	// Return the send result to LINUX
+	pSkb = pWbLinux->packet_return;
+	pWbLinux->packet_return = NULL;
+	if (in_irq())
+		dev_kfree_skb_irq(pSkb);
+	else
+		dev_kfree_skb(pSkb);
+	MIB_GS_XMIT_OK_INC;
+
+	// Trying to wakeup the netif if necessary
+	if (pWbLinux->netif_state_stop)	{
+		room_space = pWbLinux->skb_GetIndex - pWbLinux->skb_SetIndex;
+		if (room_space < 0) // Ex: + + G + S + + +
+			room_space += WBLINUX_PACKET_ARRAY_SIZE;
 
-	OS_SPIN_LOCK_ACQUIRED( &pWbLinux->SpinLock );
-	if( pWbLinux->netif_state_stop )
-	  {
-	     pWbLinux->netif_state_stop = 0;
-	     IsStart = TRUE;
-	  }
-	OS_SPIN_LOCK_RELEASED( &pWbLinux->SpinLock );
+		OS_SPIN_LOCK_ACQUIRED( &pWbLinux->SpinLock );
+		if (pWbLinux->netif_state_stop) {
+			pWbLinux->netif_state_stop = 0;
+			IsStart = TRUE;
+		}
+		OS_SPIN_LOCK_RELEASED( &pWbLinux->SpinLock );
 
-	if( IsStart )
-	  {
+		if (IsStart) {
 #ifdef _PE_TX_DUMP_
-	     WBDEBUG(("[w35und] tx netif start---"));
+			WBDEBUG(("[w35und] tx netif start---"));
 #endif
-	     netif_wake_queue( pWbLinux->netdev );
-	  }
-     }
+			netif_wake_queue( pWbLinux->netdev );
+		}
+	}
 }
 
 struct net_device_stats * wb35_netdev_stats( struct net_device *netdev )
@@ -305,84 +302,77 @@ #endif
 }
 
 void
-  WBLINUX_Destroy(  PADAPTER Adapter )
+WBLINUX_Destroy(PADAPTER Adapter)
 {
-   PWBLINUX pWbLinux = &Adapter->WbLinux;
+	PWBLINUX pWbLinux = &Adapter->WbLinux;
 
-   DEBUG2("UNregistering....\n");
+	DEBUG2("UNregistering....\n");
 
-   WBLINUX_stop( Adapter );
-   OS_SPIN_LOCK_FREE( &pWbNdis->SpinLock );
-   unregister_netdev( pWbLinux->netdev );
+	WBLINUX_stop( Adapter );
+	OS_SPIN_LOCK_FREE( &pWbNdis->SpinLock );
+	unregister_netdev( pWbLinux->netdev );
 #ifdef _PE_USB_INI_DUMP_
-   WBDEBUG(("[w35und] unregister_netdev!\n"));
+	WBDEBUG(("[w35und] unregister_netdev!\n"));
 #endif
 }
 
 void
-  WBLINUX_stop(  PADAPTER Adapter )
+WBLINUX_stop(  PADAPTER Adapter )
 {
-   PWBLINUX	pWbLinux = &Adapter->WbLinux;
-   struct sk_buff *pSkb;
-
-   if( OS_ATOMIC_INC( Adapter, &pWbLinux->ThreadCount ) == 1 )
-     {
-	// Shutdown module immediately
-	pWbLinux->shutdown = 1;
+	PWBLINUX	pWbLinux = &Adapter->WbLinux;
+	struct sk_buff *pSkb;
+
+	if (OS_ATOMIC_INC( Adapter, &pWbLinux->ThreadCount ) == 1) {
+		// Shutdown module immediately
+		pWbLinux->shutdown = 1;
+
+		while (pWbLinux->skb_array[ pWbLinux->skb_GetIndex ]) {
+			// Trying to free the un-sending packet
+			pSkb = pWbLinux->skb_array[ pWbLinux->skb_GetIndex ];
+			pWbLinux->skb_array[ pWbLinux->skb_GetIndex ] = NULL;
+			if( in_irq() )
+				dev_kfree_skb_irq( pSkb );
+			else
+				dev_kfree_skb( pSkb );
 
-	while( pWbLinux->skb_array[ pWbLinux->skb_GetIndex ] )
-	  {
-	     // Trying to free the un-sending packet
-	     pSkb = pWbLinux->skb_array[ pWbLinux->skb_GetIndex ];
-	     pWbLinux->skb_array[ pWbLinux->skb_GetIndex ] = NULL;
-	     if( in_irq() )
-	       dev_kfree_skb_irq( pSkb );
-	     else
-	       dev_kfree_skb( pSkb );
-
-	     pWbLinux->skb_GetIndex++;
-	     pWbLinux->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
-	  }
+			pWbLinux->skb_GetIndex++;
+			pWbLinux->skb_GetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
+		}
 
 #ifdef _PE_STATE_DUMP_
-	WBDEBUG(( "[w35und] SKB_RELEASE OK\n" ));
+		WBDEBUG(( "[w35und] SKB_RELEASE OK\n" ));
 #endif
-     }
+	}
 
-   OS_ATOMIC_DEC( Adapter, &pWbLinux->ThreadCount );
+	OS_ATOMIC_DEC( Adapter, &pWbLinux->ThreadCount );
 }
 
 void
-  WbWlanHalt(  PADAPTER Adapter )
+WbWlanHalt(  PADAPTER Adapter )
 {
-   //netif_stop_queue(Priv.udev);
-   //---------------------
-   Adapter->sLocalPara.ShutDowned = TRUE;
-   //WbNdis51_destroy( Adapter );
-
-   Mds_Destroy( Adapter );
+	//---------------------
+	Adapter->sLocalPara.ShutDowned = TRUE;
 
-   // Halt
-   Roam_Halt(Adapter);
-   SCAN_Halt(Adapter);
-   MLME_Halt(Adapter);
-   SME_Halt(Adapter);
+	Mds_Destroy( Adapter );
 
-   // For Ts module unload
-   //TS_destroy( Adapter );
+	// Halt
+	Roam_Halt(Adapter);
+	SCAN_Halt(Adapter);
+	MLME_Halt(Adapter);
+	SME_Halt(Adapter);
 
-   // Turn off Rx and Tx hardware ability
-   hal_stop( &Adapter->sHwData );
+	// Turn off Rx and Tx hardware ability
+	hal_stop( &Adapter->sHwData );
 #ifdef _PE_USB_INI_DUMP_
-   WBDEBUG(("[w35und] Hal_stop O.K.\n"));
+	WBDEBUG(("[w35und] Hal_stop O.K.\n"));
 #endif
-   OS_SLEEP(100000);// Waiting Irp completed
+	OS_SLEEP(100000);// Waiting Irp completed
 
-   // Destroy the NDIS module
-   WBLINUX_Destroy( Adapter );
+	// Destroy the NDIS module
+	WBLINUX_Destroy( Adapter );
 
-   // Halt the HAL
-   hal_halt(&Adapter->sHwData, NULL);
+	// Halt the HAL
+	hal_halt(&Adapter->sHwData, NULL);
 }
 
 unsigned char
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 535407d..150daa7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1496,6 +1496,7 @@ static inline ieee80211_txrx_result __ie
 
 	for (handler = handlers; *handler != NULL; handler++) {
 		res = (*handler)(rx);
+		printk("handler %x result %d\n", handler, res);
 
 		switch (res) {
 		case TXRX_CONTINUE:
@@ -1730,6 +1731,11 @@ static void __ieee80211_rx_handle_packet
 	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
+	if (type == IEEE80211_FTYPE_MGMT)
+		printk("management frame\n");
+	if (type == IEEE80211_FTYPE_DATA)
+		printk("data frame\n");
+
 	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
 		local->dot11ReceivedFragmentCount++;
 
@@ -1740,6 +1746,7 @@ static void __ieee80211_rx_handle_packet
 	}
 
 	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
+		printk("mic error\n");
 		ieee80211_rx_michael_mic_report(local->mdev, hdr, sta, &rx);
 		goto end;
 	}
@@ -1752,6 +1759,7 @@ static void __ieee80211_rx_handle_packet
 		goto end;
 	skb = rx.skb;
 
+	printk("handlers did not like it\n");
 	if (sta && !(sta->flags & (WLAN_STA_WDS | WLAN_STA_ASSOC_AP)) &&
 	    !atomic_read(&local->iff_promiscs) &&
 	    !is_multicast_ether_addr(hdr->addr1)) {
@@ -1762,6 +1770,7 @@ static void __ieee80211_rx_handle_packet
 		return;
 	}
 
+	printk("searching monitors\n");
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
@@ -2020,6 +2029,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 	struct ieee80211_local *local = hw_to_local(hw);
 	u32 pkt_load;
 
+	printk("_rx\n");
 	/*
 	 * key references and virtual interfaces are protected using RCU
 	 * and this requires that we are in a read-side RCU section during
@@ -2038,12 +2048,15 @@ void __ieee80211_rx(struct ieee80211_hw 
 		rcu_read_unlock();
 		return;
 	}
+	printk("_rx_monitor passed\n");
 
 	pkt_load = ieee80211_rx_load_stats(local, skb, status);
 	local->channel_use_raw += pkt_load;
 
-	if (!ieee80211_rx_reorder_ampdu(local, skb))
+	if (!ieee80211_rx_reorder_ampdu(local, skb)) {
+		printk("_rx_reorder_ampdu passed\n");
 		__ieee80211_rx_handle_packet(hw, skb, status, pkt_load);
+	}
 
 	rcu_read_unlock();
 }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
