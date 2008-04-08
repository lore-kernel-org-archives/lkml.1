Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYDHKNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYDHKNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYDHKNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:13:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54556 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYDHKNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:13:30 -0400
Date: Tue, 8 Apr 2008 12:14:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: more windows-specific code removal
Message-ID: <20080408101412.GA30063@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove more windows-specific code. Still untested, but very easy.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 05affe25840089b2e8c3ea4033b38efb933ddbc1
tree 147eb636c8f1066d10f3d4719d5035212b14e35d
parent 294c54c23b3317222ab524827b9c40c02e01112f
author Pavel <pavel@amd.ucw.cz> Tue, 08 Apr 2008 12:13:29 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 08 Apr 2008 12:13:29 +0200

 drivers/net/wireless/winbond/winbondport/adapter.h |   14 
 .../net/wireless/winbond/winbondport/bssdbase.c    |   82 -
 drivers/net/wireless/winbond/winbondport/mto.h     |  116 -
 drivers/net/wireless/winbond/winbondport/smetask.c |    6 
 drivers/net/wireless/winbond/winbondport/wbhal.c   |   72 -
 drivers/net/wireless/winbond/winbondport/wbndis.c  |  590 -----
 .../net/wireless/winbond/winbondport/wbndis51.c    | 2311 -----------------------
 .../net/wireless/winbond/winbondport/wbndis51_f.h  |   27 
 .../net/wireless/winbond/winbondport/wbndis51_s.h  |   27 
 .../net/wireless/winbond/winbondport/wbndis_f.h    |   42 
 .../net/wireless/winbond/winbondport/wbndis_s.h    |  158 --
 11 files changed, 108 insertions(+), 3337 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/adapter.h b/drivers/net/wireless/winbond/winbondport/adapter.h
index c5caaab..64585c5 100644
--- a/drivers/net/wireless/winbond/winbondport/adapter.h
+++ b/drivers/net/wireless/winbond/winbondport/adapter.h
@@ -5,32 +5,22 @@
 #define MAX_ANSI_STRING		40
 typedef struct WB32_ADAPTER
 {
-	u32				AdapterIndex; // 20060703.4 Add for using pAdapterContext global Adapter point
+	u32 AdapterIndex; // 20060703.4 Add for using pAdapterContext global Adapter point
 
 	WB_LOCALDESCRIPT	sLocalPara;		// Myself connected parameters
 	PWB_BSSDESCRIPTION	asBSSDescriptElement;
 	SME_PARAMETERS		sSmePara;		// GUI desired/WEP parameters
 	SCAN_PARAMETERS 	sScanPara;		// Myself scan parameters
-	MLME_FRAME			sMlmeFrame;		// connect to peerSTA parameters
+	MLME_FRAME		sMlmeFrame;		// connect to peerSTA parameters
 	ROAM_PARAMETERS		sRoamPara;			// Roaming Module
 	MTO_PARAMETERS		sMtoPara; // MTO_struct ...
 	hw_data_t			sHwData; //For HAL
 	MDS					Mds;
 	TESTSTA				sTestSta; // For test station
 
-	#ifdef NDIS_MINIPORT_DRIVER
-	WBNDIS						WbNdis;
-	NDIS51_DESIRED_PARAMETER	DesiredNdis51Parameter;
-	#endif
-
-	#ifdef WB_LINUX
 	WBLINUX		WbLinux;
 	WB_STA_WPA_DESCRIPTION Global_STA_Wpa;//For WB_WPA
         struct iw_statistics iw_stats;
-       #endif
 
-   
-	// 20060704.1 Add for recognize
 	u8	LinkName[MAX_ANSI_STRING];
-
 } WB32_ADAPTER, ADAPTER, *PWB32_ADAPTER, *PADAPTER;
diff --git a/drivers/net/wireless/winbond/winbondport/bssdbase.c b/drivers/net/wireless/winbond/winbondport/bssdbase.c
index 82c5095..5c4d65a 100644
--- a/drivers/net/wireless/winbond/winbondport/bssdbase.c
+++ b/drivers/net/wireless/winbond/winbondport/bssdbase.c
@@ -2102,15 +2102,8 @@ void CreateWpaIE(PWB32_ADAPTER Adapter,
 		//							+2+pRsnWpaSubElement->AuthKeyMngtSuiteCount*(sizeof(SUITE_SELECTOR))
 		pRsnWpaElement->Length = 10 +2+PairwiseKeySuiteCount*(sizeof(SUITE_SELECTOR))
 									+2+AuthKeyMngtSuiteCount*(sizeof(SUITE_SELECTOR))
-									#ifdef NDIS_MINIPORT_DRIVER
-									+2;//include capability;
-									#else
 									;//exclude capability;
-									#endif
 		//to fill capability
-		#ifdef NDIS_MINIPORT_DRIVER
-		*(u16 *)(RSN_Element+pRsnWpaElement->Length) = 0;
-        #endif
 		memcpy( &msg[*iFildOffset], pRsnWpaElement, pRsnWpaElement->Length+2 );
 		
 		#ifdef _PE_TX_DUMP_
@@ -2143,21 +2136,15 @@ void CreateWpaIE(PWB32_ADAPTER Adapter,
 #ifdef _WPA2_
 //==========================================================================================
 //added by WS for add IE for WPA2 packet 
-void CreateRsnIE(PWB32_ADAPTER Adapter,
-                u16* iFildOffset,
-                PUCHAR msg,
+void CreateRsnIE(PWB32_ADAPTER Adapter, u16* iFildOffset, PUCHAR msg,
                 struct  Management_Frame* msgHeader,
-                struct  Association_Request_Frame_Body* msgBody,
-                u16  iMSindex)
-   {
-                
-	if ((psSME->bDesiredAuthMode==WPA2_AUTH)||(psSME->bDesiredAuthMode==WPA2PSK_AUTH))
-	{
-			
-		u8									    RSN_Element[200];
+                struct  Association_Request_Frame_Body* msgBody, u16  iMSindex)
+{
+	if ((psSME->bDesiredAuthMode==WPA2_AUTH)||(psSME->bDesiredAuthMode==WPA2PSK_AUTH)) {
+		u8 RSN_Element[200];
 		struct WPA2_RSN_Information_Element	    UNALIGNED *pRsnWpa2Element;
-        struct WPA2_RSN_Auth_Sub_Information_Element  *pRsnWpa2SubElement;
-        struct RSN_Capability_Element                 *CaPa;
+		struct WPA2_RSN_Auth_Sub_Information_Element  *pRsnWpa2SubElement;
+		struct RSN_Capability_Element                 *CaPa;
 		struct PMKID_Information_Element *            AssoReq_PMKID;
 		int index=0;
 		u32	OUItmp;
@@ -2215,44 +2202,27 @@ void CreateRsnIE(PWB32_ADAPTER Adapter,
         //Fill capability
         CaPa=(struct RSN_Capability_Element *)(RSN_Element+index);
         //CaPa->wValue=0x0010;
-		#ifdef NDIS_MINIPORT_DRIVER
-        CaPa->RSN_Capability.Pre_Auth=1;
-		#else
         CaPa->RSN_Capability.Pre_Auth=0;
-		#endif
-		CaPa->RSN_Capability.No_Pairwise=0;
-		CaPa->RSN_Capability.PTK_Replay_Counter=00;
-		CaPa->RSN_Capability.GTK_Replay_Counter=00;
+	CaPa->RSN_Capability.No_Pairwise=0;
+	CaPa->RSN_Capability.PTK_Replay_Counter=00;
+	CaPa->RSN_Capability.GTK_Replay_Counter=00;
         CaPa->RSN_Capability.Reserved1=00;
-		CaPa->RSN_Capability.Reserved2=0;
+	CaPa->RSN_Capability.Reserved2=0;
 		
         index+=sizeof(struct RSN_Capability_Element);
-		AssoReq_PMKID=(struct PMKID_Information_Element *)(RSN_Element+index);
+	AssoReq_PMKID=(struct PMKID_Information_Element *)(RSN_Element+index);
         AssoReq_PMKID->PMKID_Count=0; 
         //to find pmkid for desired bssid the NIC is roaming to  
-        if(SearchPmkid(Adapter,msgHeader,AssoReq_PMKID))
-          {
-            //if(AssoReq_PMKID->PMKID_Count >16)
-              //  break;
-			//20061011 anson's endian
-			//pRsnWpa2Element->Length = 6 +2+(pRsnWpa2Element->PairwiseKeySuiteCount* sizeof(SUITE_SELECTOR))
-			//							+2+(pRsnWpa2SubElement->AuthKeyMngtSuiteCount* sizeof(SUITE_SELECTOR))
-			pRsnWpa2Element->Length = 6 +2+(PairwiseKeySuiteCount* sizeof(SUITE_SELECTOR))
-										+2+(AuthKeyMngtSuiteCount* sizeof(SUITE_SELECTOR))
-									#ifdef NDIS_MINIPORT_DRIVER
-									+2+2+(AssoReq_PMKID->PMKID_Count*sizeof(NDIS_802_11_PMKID_VALUE));
-									#else
+        if(SearchPmkid(Adapter,msgHeader,AssoReq_PMKID)) {
+		pRsnWpa2Element->Length = 6 +2+(PairwiseKeySuiteCount* sizeof(SUITE_SELECTOR))
+			+2+(AuthKeyMngtSuiteCount* sizeof(SUITE_SELECTOR))
 									//TODO : sizeof(NDIS_802_11_PMKID_VALUE) = ??
-									+2+2+(AssoReq_PMKID->PMKID_Count*16); 
-									#endif
-          }
-        else
-			//20061011 anson's endian
-			//pRsnWpa2Element->Length = 6 +2+(pRsnWpa2Element->PairwiseKeySuiteCount* sizeof(SUITE_SELECTOR))
-			//						+2+(pRsnWpa2SubElement->AuthKeyMngtSuiteCount* sizeof(SUITE_SELECTOR))
-			pRsnWpa2Element->Length = 6 +2+(PairwiseKeySuiteCount* sizeof(SUITE_SELECTOR))
-									+2+(AuthKeyMngtSuiteCount* sizeof(SUITE_SELECTOR))
-									    +2;
+			+2+2+(AssoReq_PMKID->PMKID_Count*16); 
+	} else
+		//20061011 anson's endian
+		pRsnWpa2Element->Length = 6 +2+(PairwiseKeySuiteCount* sizeof(SUITE_SELECTOR))
+			+2+(AuthKeyMngtSuiteCount* sizeof(SUITE_SELECTOR))
+			+2;
 
 		//+2 is for Element ID and version Number
 		memcpy( &msg[*iFildOffset], pRsnWpa2Element, pRsnWpa2Element->Length+2 );
@@ -2263,14 +2233,11 @@ void CreateRsnIE(PWB32_ADAPTER Adapter,
 
 		//added the length of Rsn IE.
 		*iFildOffset +=(pRsnWpa2Element->Length+2) ;
-		if (psSME->boReassoc)
-		{
+		if (psSME->boReassoc) {
 			// fixed field length(listen interval+capability+MAC addr) = 10
 			psSME->AssocReqVarLen = *iFildOffset - sizeof(struct Management_Frame) - 10;
 			memcpy( psSME->AssocReqVarIE, msg+sizeof(struct Management_Frame)+10, psSME->AssocReqVarLen );
-		}
-		else
-		{
+		} else {
 			// "-4" is for capability field and listen interval
 			psSME->AssocReqVarLen = *iFildOffset - sizeof(struct Management_Frame) - 4;
 			memcpy( psSME->AssocReqVarIE, msg+sizeof(struct Management_Frame)+4, psSME->AssocReqVarLen );
@@ -2281,8 +2248,7 @@ void CreateRsnIE(PWB32_ADAPTER Adapter,
 		DataDmp(psSME->AssocReqVarIE, psSME->AssocReqVarLen,0);
 		#endif
 	}
-	
-  }	
+   }	
 
 u16 SearchPmkid(PWB32_ADAPTER Adapter,struct  Management_Frame* msgHeader,struct PMKID_Information_Element * AssoReq_PMKID )
 {
diff --git a/drivers/net/wireless/winbond/winbondport/mto.h b/drivers/net/wireless/winbond/winbondport/mto.h
index eb8b2fd..f47936f 100644
--- a/drivers/net/wireless/winbond/winbondport/mto.h
+++ b/drivers/net/wireless/winbond/winbondport/mto.h
@@ -11,10 +11,6 @@
 #ifndef __MTO_H__
 #define __MTO_H__
 
-// LA20040210_DTO kevin
-//#include "platform.h"
-
-//#define MTO_DEFAULT_TH_FIXANT           3
 #define MTO_DEFAULT_TH_CNT              5
 #define MTO_DEFAULT_TH_SQ3              112  //OLD IS 13 reference JohnXu
 #define MTO_DEFAULT_TH_IDLE_SLOT        15
@@ -44,6 +40,7 @@ typedef enum {
     RATE_CHGSTATE_CALCULATE    = 1,
     RATE_CHGSTATE_BACKOFF	   = 2
 } TX_RATE_REDUCTION_STATE;
+
 //============================================================================
 // struct _MTOParameters --
 //
@@ -51,14 +48,14 @@ typedef enum {
 //============================================================================
 typedef struct _MTO_PARAMETERS
 {
-    u8      Th_Fixant;
-    u8      Th_Cnt;
-    u8      Th_SQ3;
-    u8      Th_IdleSlot;
+	u8      Th_Fixant;
+	u8      Th_Cnt;
+	u8      Th_SQ3;
+	u8      Th_IdleSlot;
 
 	u16     Tmr_Aging;
-    u8      Th_PrInterf;
-    u8      Tmr_Periodic;
+	u8      Th_PrInterf;
+	u8      Tmr_Periodic;
 
 	//---------        wkchen added      -------------
 	u32		TxFlowCount;	//to judge what kind the tx flow(sparse or busy) is
@@ -81,44 +78,44 @@ typedef struct _MTO_PARAMETERS
 	u16		reserved_1;
 	//------------------------------------------------
 
-    u8      PowerChangeEnable;
-    u8      AntDiversityEnable;
-    u8      Ant_mac;
-    u8      Ant_div;
+	u8      PowerChangeEnable;
+	u8      AntDiversityEnable;
+	u8      Ant_mac;
+	u8      Ant_div;
 
-    u8      CCA_Mode;
-    u8      CCA_Mode_Setup;
-    u8      Preamble_Type;
-    u8      PreambleChangeEnable;
+	u8      CCA_Mode;
+	u8      CCA_Mode_Setup;
+	u8      Preamble_Type;
+	u8      PreambleChangeEnable;
 
-    u8      DataRateLevel;
-    u8      DataRateChangeEnable;
-    u8      FragThresholdLevel;
-    u8      FragThresholdChangeEnable;
+	u8      DataRateLevel;
+	u8      DataRateChangeEnable;
+	u8      FragThresholdLevel;
+	u8      FragThresholdChangeEnable;
 
-    u16     RTSThreshold;
-    u16     RTSThreshold_Setup;
+	u16     RTSThreshold;
+	u16     RTSThreshold_Setup;
 
-    u32     AvgIdleSlot;
-    u32     Pr_Interf;
-    u32     AvgGapBtwnInterf;
+	u32     AvgIdleSlot;
+	u32     Pr_Interf;
+	u32     AvgGapBtwnInterf;
 
-    u8	   RTSChangeEnable;
-    u8      Ant_sel;
-    u8      aging_timeout;
+	u8	   RTSChangeEnable;
+	u8      Ant_sel;
+	u8      aging_timeout;
 	u8	   reserved_2;
 
-    u32     Cnt_Ant[2];
-    u32     SQ_Ant[2];
+	u32     Cnt_Ant[2];
+	u32     SQ_Ant[2];
 
 // 20040510 remove from globe vairable
-    u32                     TmrCnt;
-    u32                     BackoffTmr;
-    TOGGLE_STATE            ToggleState;
-    TX_RATE_REDUCTION_STATE TxRateReductionState;
+	u32                     TmrCnt;
+	u32                     BackoffTmr;
+	TOGGLE_STATE            ToggleState;
+	TX_RATE_REDUCTION_STATE TxRateReductionState;
 
-    u8                      Last_Rate;
-    u8                      Co_efficent;
+	u8                      Last_Rate;
+	u8                      Co_efficent;
 	u8		FallbackRateLevel;
 	u8		OfdmRateLevel;
 
@@ -132,19 +129,11 @@ typedef struct _MTO_PARAMETERS
 } MTO_PARAMETERS, *PMTO_PARAMETERS;
 
 
-
-// LA20040210_DTO kevin
-//#define MTO_FUNC_INPUT               PWB32_ADAPTER Adapter
-//#define MTO_FUNC_INPUT_DATA         Adapter
-//#define MTO_DATA()                  (Adapter->mto_data)
-//#define MTO_HAL()                   (&Adapter->hw_data)
-//#define MTO_FUNC_INPUT              core_data_t *pcore_data
 #define MTO_FUNC_INPUT              PWB32_ADAPTER	Adapter
 #define MTO_FUNC_INPUT_DATA         Adapter
 #define MTO_DATA()                  (Adapter->sMtoPara)
 #define MTO_HAL()                   (&Adapter->sHwData)
 #define MTO_SET_PREAMBLE_TYPE(x)    // 20040511 Turbo mark LM_PREAMBLE_TYPE(&pcore_data->lm_data) = (x)
-//#define MTO_ENABLE					(Adapter->sLocalPara.MTOExecuting)	//[WKCHEN]
 #define MTO_ENABLE					(Adapter->sLocalPara.TxRateMode == RATE_AUTO)
 #define MTO_TXPOWER_FROM_EEPROM		(Adapter->sHwData.PowerIndexFromEEPROM)
 #define LOCAL_ANTENNA_NO()			(Adapter->sLocalPara.bAntennaNo)
@@ -159,7 +148,6 @@ #define MTO_BACKOFF_TMR()           MTO_
 #define MTO_LAST_RATE()             MTO_DATA().Last_Rate
 #define MTO_CO_EFFICENT()           MTO_DATA().Co_efficent
 
-//#define MTO_TH_FIXANT()           MTO_DATA().Th_Fixant
 #define MTO_TH_CNT()                MTO_DATA().Th_Cnt
 #define MTO_TH_SQ3()                MTO_DATA().Th_SQ3
 #define MTO_TH_IDLE_SLOT()          MTO_DATA().Th_IdleSlot
@@ -169,7 +157,6 @@ #define MTO_TMR_AGING()             MTO_
 #define MTO_TMR_PERIODIC()          MTO_DATA().Tmr_Periodic
 
 #define MTO_POWER_CHANGE_ENABLE()   MTO_DATA().PowerChangeEnable
-//#define MTO_ANT_DIVERSITY_ENABLE()  MTO_DATA().AntDiversityEnable
 #define MTO_ANT_DIVERSITY_ENABLE()  Adapter->sLocalPara.boAntennaDiversity
 #define MTO_ANT_MAC()               MTO_DATA().Ant_mac
 #define MTO_ANT_DIVERSITY()         MTO_DATA().Ant_div
@@ -203,37 +190,28 @@ #define MTO_TXFLOWCOUNT()			MTO_DATA().T
 #define	MTOPARA_PERIODIC_CHECK_CYCLE()		MTO_DATA().DTO_PeriodicCheckCycle
 #define	MTOPARA_RSSI_TH_FOR_ANTDIV()		MTO_DATA().DTO_RssiThForAntDiv
 #define	MTOPARA_TXCOUNT_TH_FOR_CALC_RATE()	MTO_DATA().DTO_TxCountThForCalcNewRate
-#define	MTOPARA_TXRATE_INC_TH()				MTO_DATA().DTO_TxRateIncTh
-#define	MTOPARA_TXRATE_DEC_TH()				MTO_DATA().DTO_TxRateDecTh
-#define MTOPARA_TXRATE_EQ_TH()				MTO_DATA().DTO_TxRateEqTh
-#define	MTOPARA_TXRATE_BACKOFF()			MTO_DATA().DTO_TxRateBackOff
+#define	MTOPARA_TXRATE_INC_TH()			MTO_DATA().DTO_TxRateIncTh
+#define	MTOPARA_TXRATE_DEC_TH()			MTO_DATA().DTO_TxRateDecTh
+#define MTOPARA_TXRATE_EQ_TH()			MTO_DATA().DTO_TxRateEqTh
+#define	MTOPARA_TXRATE_BACKOFF()		MTO_DATA().DTO_TxRateBackOff
 #define	MTOPARA_TXRETRYRATE_REDUCE()		MTO_DATA().DTO_TxRetryRateReduce
-#define MTOPARA_TXPOWER_INDEX()				MTO_DATA().DTO_TxPowerIndex
+#define MTOPARA_TXPOWER_INDEX()			MTO_DATA().DTO_TxPowerIndex
 //------------------------------------------------
 
 
-// LA20040210_DTO kevin
-//void MTO_Init(...);
-//void MTO_PeriodicTimerExpired(...);
-//void MTO_AgingTimerExpired(...);
-//void MTO_TxFailed(...);
-//void MTO_Interf(...);
-//void MTO_Reset(...);
-
 extern u8   MTO_Data_Rate_Tbl[];
 extern u16  MTO_Frag_Th_Tbl[];
 
-#define MTO_DATA_RATE()             MTO_Data_Rate_Tbl[MTO_RATE_LEVEL()]
-#define MTO_DATA_FALLBACK_RATE()	MTO_Data_Rate_Tbl[MTO_FALLBACK_RATE_LEVEL()]	//next level
-#define MTO_FRAG_TH()               MTO_Frag_Th_Tbl[MTO_FRAG_TH_LEVEL()]
+#define MTO_DATA_RATE()          MTO_Data_Rate_Tbl[MTO_RATE_LEVEL()]
+#define MTO_DATA_FALLBACK_RATE() MTO_Data_Rate_Tbl[MTO_FALLBACK_RATE_LEVEL()]	//next level
+#define MTO_FRAG_TH()            MTO_Frag_Th_Tbl[MTO_FRAG_TH_LEVEL()]
 
-typedef struct{
+typedef struct {
 	u8 tx_rate;
 	u8 tx_retry_rate;
-}TXRETRY_REC;
+} TXRETRY_REC;
 
-typedef struct _STATISTICS_INFO
-{
+typedef struct _STATISTICS_INFO {
 	u32   Rate54M;
 	u32   Rate48M;
 	u32   Rate36M;
@@ -280,7 +258,7 @@ typedef struct _STATISTICS_INFO
 	s32   RxBytes;
 	s32   TxBytes;
 	s32   Antenna;
-}STATISTICS_INFO, *PSTATISTICS_INFO;
+} STATISTICS_INFO, *PSTATISTICS_INFO;
 
 #endif //__MTO_H__
 
diff --git a/drivers/net/wireless/winbond/winbondport/smetask.c b/drivers/net/wireless/winbond/winbondport/smetask.c
index bb1caa9..782eca1 100644
--- a/drivers/net/wireless/winbond/winbondport/smetask.c
+++ b/drivers/net/wireless/winbond/winbondport/smetask.c
@@ -52,10 +52,8 @@ void vNetDisconnectInd(PWB32_ADAPTER Ada
 void vSmeTimerStart(PWB32_ADAPTER Adapter, u32 timeout_value);
 void vSmeTimerStop(PWB32_ADAPTER Adapter);
 void vSmeTimerHandler_1a( void*	Data);
-void vSmeTimerHandler( void*			SystemSpecific1,
-					   PWB32_ADAPTER 	Adapter,
-					   void*			SystemSpecific2,
-					   void*			SystemSpecific3);
+void vSmeTimerHandler(void* SystemSpecific1, PWB32_ADAPTER Adapter,
+		      void* SystemSpecific2, void* SystemSpecific3);
 void TxRateHandler(PWB32_ADAPTER Adapter);
 
 //=================== Action Function of SME Module
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 663f615..f1912e0 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -23,19 +23,18 @@ void hal_remove_mapping_key( phw_data_t 
 		if( OS_MEMORY_COMPARE( pmac_addr, pHwData->Key_slot[i], MAC_ADDR_LENGTH ) )
 			break;
 	}
-	if( i != MAX_KEY_TABLE ) //Find the same index
-	{
+	if (i != MAX_KEY_TABLE) { //Find the same index
 		// Clear the mac address
 		memset(pHwData->Key_slot[i], 0, MAC_ADDR_LENGTH);
 
-		//Writing into register to clear the valid bit
+		// Writing into register to clear the valid bit
 		Wb35Reg_Write( pHwData, 0x0820, 0x0 );//Value
 		i<<=4;
 		i |= 0x4000000;
 		Wb35Reg_Write( pHwData, 0x081c, i );
 	}
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_remove_default_key( phw_data_t pHwData, u32 i )
 {
 	u32	ltmp;
@@ -45,21 +44,20 @@ void hal_remove_default_key( phw_data_t 
 	WBDEBUG(("hal_remove_default_key\n"));
 	#endif
 
-	if( i < 4 ) // For default key index 0 ~ 3
-	{
+	if (i < 4) {  // For default key index 0 ~ 3
 		//Writing into register to clear the valid bit
 		Wb35Reg_Write( pHwData, 0x0820, 0x0 );//Value
 		ltmp = i<<4;
 		ltmp |= 0x4000000;
 		Wb35Reg_Write( pHwData, 0x081c, ltmp );
 
-		OS_MEMORY_CLEAR( pHwData->Key_slot[i], MAC_ADDR_LENGTH ); // 20060214 for recover
+		memset(pHwData->Key_slot[i], 0, MAC_ADDR_LENGTH);
 	}
 }
-//---------------------------------------------------------------------------------------------------
+
 unsigned char hal_set_mapping_key( phw_data_t pHwData,  PUCHAR pmac_addr,  u8 null_key,
-							  u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,
-							  u8 key_type,  u8 key_len,  PUCHAR pkey_data )
+				   u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,
+				   u8 key_type,  u8 key_len,  PUCHAR pkey_data )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	PKEY_TABLE	pKey;
@@ -100,11 +98,11 @@ unsigned char hal_set_mapping_key( phw_d
 
 	memcpy( &(pKey->DW1_Address2), pmac_addr + 2, sizeof(u32) );
 
-	if( prx_tsc ) {
+	if (prx_tsc) {
 		pValue = (u8 *)pKey +8 ;  //20060926 anson's endian
 		memcpy( pValue, prx_tsc, 6 ); //20060926 anson's endian
 	}
-	if( ptx_tsc ) {
+	if (ptx_tsc) {
 		pValue = (u8 *)pKey +16;   //20060926 anson's endian
 		memcpy( pValue, ptx_tsc, 6 ); //20060926 anson's endian
 	}
@@ -113,7 +111,7 @@ unsigned char hal_set_mapping_key( phw_d
 	memcpy( ((PUCHAR)pKey+sizeof(KEY_TABLE)), pkey_data, key_len );
 
 	j = 0xff;
-	for( i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++ ) {
+	for (i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++) {
 		pValue = (u8 *)pKey + 2;  //20060926 anson's endian
 		if (!memcpy(pValue, pHwData->Key_slot[i], 6)) {
 			pHwData->mapping_key_replace_index = i + 1;
@@ -123,7 +121,7 @@ unsigned char hal_set_mapping_key( phw_d
 		}
 
 		if (!memcpy(pHwData->Key_slot[i], "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH ))
-			if( j == 0xff )
+			if (j == 0xff)
 				j = i;//Storing the index which can be used
 	}
 
@@ -176,8 +174,8 @@ unsigned char hal_set_mapping_key( phw_d
 }
 //---------------------------------------------------------------------------------------------------
 unsigned char hal_set_default_key( phw_data_t pHwData,  u8 index,  u8 null_key,
-							  u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,
-							  u8 key_type,  u8 key_len,  PUCHAR pkey_data )
+				   u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,
+				   u8 key_type,  u8 key_len,  PUCHAR pkey_data )
 {
 	PKEY_TABLE	pKey;
 	PULONG		pltmp;
@@ -365,15 +363,15 @@ void hal_set_ethernet_address( phw_data_
 	//Wb35Reg_BurstWrite( pHwData,0x03e8, (PULONG)pHwData->CurrentMacAddress, 2, AUTO_INCREMENT );
 	Wb35Reg_BurstWrite( pHwData,0x03e8, ltmp, 2, AUTO_INCREMENT ); //20060926 add by anson's endian
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_get_permanent_address( phw_data_t pHwData, PUCHAR pethernet_address )
 {
 	if( pHwData->SurpriseRemove ) return;
 
 	memcpy( pethernet_address, pHwData->PermanentMacAddress, 6 );
 }
-//---------------------------------------------------------------------------------------------------
-u8 hal_init_hardware(  phw_data_t pHwData,  PWB32_ADAPTER Adapter )
+
+u8 hal_init_hardware(phw_data_t pHwData, PWB32_ADAPTER Adapter)
 {
 	u16 SoftwareSet;
 	pHwData->Adapter = Adapter;
@@ -448,7 +446,7 @@ hal_set_power_save_mode(  phw_data_t pHw
 	//pHwData->desired_power_save = power_save;
 	pWb35Reg->M24_MacControl &= ~0x0200c000;	//clear ps-poll and pwr active/save bits
 
-	if( power_save ) {
+	if (power_save) {
 		pWb35Reg->M24_MacControl |= 0x02004000;	//enable ps-poll and pwr save
 	} else {
 		// Force MAC active
@@ -504,7 +502,8 @@ void hal_set_slot_time( phw_data_t pHwDa
 	Wb35Reg_Write( pHwData, 0x0878, pWb35Reg->M78_ERPInformation );
 }
 //---------------------------------------------------------------------------------------------------
-void hal_set_rates(  phw_data_t pHwData,  PUCHAR pbss_rates,  u8 length,  unsigned char basic_rate_set )
+void hal_set_rates(phw_data_t pHwData, PUCHAR pbss_rates, 
+		   u8 length, unsigned char basic_rate_set )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	u32		tmp, tmp1;
@@ -514,28 +513,23 @@ void hal_set_rates(  phw_data_t pHwData,
 
 	if( pHwData->SurpriseRemove ) return;
 
-	if( basic_rate_set )
-	{
+	if (basic_rate_set) {
 		pWb35Reg->M28_MacControl &= ~0x000fff00;
 		tmp1 = 0x00000100;
-	}
-	else
-	{
+	} else {
 		pWb35Reg->M28_MacControl &= ~0xfff00000;
 		tmp1 = 0x00100000;
 	}
 
 	tmp = 0;
-	for( i=0; i<length; i++ )
-	{
+	for (i=0; i<length; i++) {
 		Byte = pbss_rates[i] & 0x7f;
-		for( j=0; j<12; j++ )
-		{
+		for (j=0; j<12; j++) {
 			if( Byte == Rate[j] )
 				break;
 		}
 
-		if( j < 12 )
+		if (j < 12)
 			tmp |= (tmp1<<j);
 	}
 
@@ -547,16 +541,14 @@ void hal_set_rates(  phw_data_t pHwData,
 	memset( SupportedRate, 0, 16 );
 	tmp = 0x00100000;
 	tmp1 = 0x00000100;
-	for( i=0; i<12; i++ ) // Get the supproted rate
-	{
-		if( tmp & pWb35Reg->M28_MacControl )
-		{
+	for (i=0; i<12; i++) { // Get the supported rate
+		if (tmp & pWb35Reg->M28_MacControl) {
 			SupportedRate[j] = Rate[i];
 
-			if( tmp1 & pWb35Reg->M28_MacControl )
+			if (tmp1 & pWb35Reg->M28_MacControl)
 				SupportedRate[j] |= 0x80;
 
-			if( k )
+			if (k)
 				Count2++;
 			else
 				Count1++;
@@ -564,8 +556,7 @@ void hal_set_rates(  phw_data_t pHwData,
 			j++;
 		}
 
-		if( i==4 && k==0 )
-		{
+		if (i==4 && k==0) {
 			if( !(pWb35Reg->M28_MacControl & 0x000ff000) ) // if basic rate in 11g domain)
 			{
 				k = 1;
@@ -580,7 +571,7 @@ void hal_set_rates(  phw_data_t pHwData,
 	// Fill data into support rate until buffer full
 	//---20060926 add by anson's endian
 	for (i=0; i<4; i++)
-	*(PULONG)(SupportedRate+(i<<2)) = cpu_to_le32( *(PULONG)(SupportedRate+(i<<2)) );
+		*(PULONG)(SupportedRate+(i<<2)) = cpu_to_le32( *(PULONG)(SupportedRate+(i<<2)) );
 	//--- end 20060926 add by anson's endian
 	Wb35Reg_BurstWrite( pHwData,0x087c, (PULONG)SupportedRate, 4, AUTO_INCREMENT );
 	pWb35Reg->M7C_MacControl = ((PULONG)SupportedRate)[0];
@@ -617,7 +608,6 @@ void hal_start_bss(  phw_data_t pHwData,
 void hal_join_request(  phw_data_t pHwData,  u8 bss_type )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-//	PWB32_ADAPTER Adapter=pHwData->Adapter;
 
 	if( pHwData->SurpriseRemove ) return;
 
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis.c b/drivers/net/wireless/winbond/winbondport/wbndis.c
index 36013b7..3bab529 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis.c
+++ b/drivers/net/wireless/winbond/winbondport/wbndis.c
@@ -1,589 +1 @@
-#include "os_common.h"
-
-#ifdef NDIS51_MINIPORT
-void
-WBNDIS_PnPNotify(  PADAPTER Adapter,  NDIS_DEVICE_PNP_EVENT PnPEvent,  void* InformationBuffer,	 u32 InformationBufferLength )
-{
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("====> MPPnPEventNotify\n"));
-	#endif
-
-	switch (PnPEvent)
-	{
-		case NdisDevicePnPEventQueryRemoved:
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Wb32PnPNotify: NdisDevicePnPEventQueryRemoved\n"));
-			#endif
-			break;
-
-		case NdisDevicePnPEventRemoved:
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Wb32PnPNotify: NdisDevicePnPEventRemoved\n"));
-			#endif
-			break;       
-
-		case NdisDevicePnPEventSurpriseRemoved:
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Wb32PnPNotify: NdisDevicePnPEventSurpriseRemoved\n"));
-			#endif
-            break;
-
-		case NdisDevicePnPEventQueryStopped:
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Wb32PnPNotify: NdisDevicePnPEventQueryStopped\n"));
-			#endif
-			break;
-
-		case NdisDevicePnPEventStopped:
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Wb32PnPNotify: NdisDevicePnPEventStopped\n"));
-			#endif
-			break;      
-            
-		case NdisDevicePnPEventPowerProfileChanged:
-//			WBDEBUG(("Wb32PnPNotify: NdisDevicePnPEventPowerProfileChanged\n"));
-			#ifdef _PE_STATE_DUMP_
-			if( *(PULONG)InformationBuffer == NdisPowerProfileAcOnLine )
-				WBDEBUG(("Wb32PnPNotify: NdisPowerProfileAcOnLine\n"));
-			if( *(PULONG)InformationBuffer == NdisPowerProfileBattery )
-				WBDEBUG(("Wb32PnPNotify: NdisPowerProfileBattery\n"));
-			#endif
-			break;      
-            
-		default:
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Wb32PnPNotify: unknown PnP event %x \n", PnPEvent));
-			#endif
-			break;         
-	}
-}
-#endif
-
-//===========================================================================
-//  WBNDIS_SendPackets  --
-//
-//  Description:
-//    The WBNDIS_SendPackets request instructs a driver to transmit packets
-//    through the adapter onto the medium.
-//
-//  Arguments:
-//    MiniportAdapterContext - Context registered with the wrapper, really
-//                             a pointer to the adapter.
-//    PacketArray            - A pointer to the packet array that is to be
-//                             transmitted.
-//    NumberOfPackets        - The number of pointers to packet descriptors
-//                             at PacketArray.
-//
-//===========================================================================
-void
-WBNDIS_SendPackets(  NDIS_HANDLE   MiniportAdapterContext,
-					 PPNDIS_PACKET PacketArray,
-					 u32          NumberOfPackets )
-{
-	PADAPTER		Adapter = (PADAPTER)MiniportAdapterContext;
-	PWBNDIS			pWbNdis = &Adapter->WbNdis;
-	PNDIS_PACKET	pNdisPacket;
-	PNDIS_BUFFER	pNdisPacketBuffer;
-	PUCHAR			pBufAddress;
-	u32			i;
-	u32			NdisPacketBufferCount, NdisPacketSize, buf_size;
-
-
-	//
-	// Fill information into reserved space
-	//
-	for( i=0; i<NumberOfPackets; i++ )
-	{
-		pNdisPacket = PacketArray[i];
-		NdisQueryPacket( pNdisPacket, NULL, &NdisPacketBufferCount, &pNdisPacketBuffer, &NdisPacketSize);
-
-		//931130.5.q
-		if( !NdisPacketSize )
-		{
-			#ifdef _PE_TX_DUMP_
-			WBDEBUG(("Ndis packet error [%d] = %d\n", NdisPacketBufferCount, NdisPacketSize ));
-			#endif
-			NDIS_SET_PACKET_STATUS( pNdisPacket, NDIS_STATUS_FAILURE );
-			NdisMSendComplete( Adapter->WbNdis.MiniportAdapterHandle, pNdisPacket, NDIS_STATUS_FAILURE);
-			#ifdef _PE_TX_DUMP_
-			WBDEBUG(("!NdisPacketSize || (NdisPacketBufferCount>(MAX_DESCRIPTOR_BUFFER_INDEX-2))\n"));
-			#endif
-		}
-		else
-		{
-			NDIS_SET_PACKET_STATUS( pNdisPacket, NDIS_STATUS_PENDING );
-
-			// Modify the follow for the number of buffer is larger than MAX_DESCRIPTOR_BUFFER_INDEX
-			// WBNDIS_GetNextPacket will copy the packet buffer into transmitting buffer directly
-			RESERVED(pNdisPacket)->pNdisPacketBuffer = NULL;
-			if( !(NdisPacketBufferCount>(MAX_DESCRIPTOR_BUFFER_INDEX-2)) )
-				RESERVED(pNdisPacket)->pNdisPacketBuffer = pNdisPacketBuffer;
-			RESERVED(pNdisPacket)->NdisPacketSize = (u16)NdisPacketSize;
-
-			// Frame type acknowledgement
-			// //931130.5.r
-			#ifdef NDIS51_MINIPORT
-			NdisQueryBufferSafe( pNdisPacketBuffer, (void* *) &pBufAddress, &buf_size, HighPagePriority );
-			#else
-			NdisQueryBuffer( pNdisPacketBuffer, (void* *) &pBufAddress, &buf_size );
-			#endif
-/*
-			//[WK DUMP]
-			WBDEBUG(("New packet =%x\n", pNdisPacket));
-			#ifdef _PE_TX_DUMP_
-			{
-				PNDIS_BUFFER	pPacketBuffer;
-				PUCHAR			pBufAddr;
-				u32			PacketSize, buf_size1;
-
-				//[WK DUMP]
-				pPacketBuffer = pNdisPacketBuffer;
-				PacketSize = NdisPacketSize;
-				WBDEBUG(("=== DUMP 802.3 TX Buff ===\n"));
-				WBDEBUG(("Size =%d\n", PacketSize));
-				while( pPacketBuffer )
-				{
-					// Get the address and length of the first buffer
-					#ifdef NDIS51_MINIPORT// PD43 20030430 920428.3
-					NdisQueryBufferSafe( pPacketBuffer, (void* *) &pBufAddr, &buf_size1, HighPagePriority );
-					#else
-					NdisQueryBuffer( pPacketBuffer, (void* *) &pBufAddr, &buf_size1 );
-					#endif
-					DataDmp( pBufAddr, buf_size1, 0);
-					NdisGetNextBuffer( pPacketBuffer, &pPacketBuffer);
-				}
-			}
-			#endif
-*/
-			//
-			// Can be sent now?
-			//
-			if( pWbNdis->shutdown || !CURRENT_LINK_ON ||
-				(
-				#ifdef _WPA2_
-				CURRENT_DESIRED_WPA2_ENABLE &&
-				#endif //end def _WPA2_
-				  CURRENT_DESIRED_WPA_ENABLE && CURRENT_CONTROL_PORT_BLOCK && (*(PUSHORT)(pBufAddress+12) != cpu_to_le16(0x8e88)) ) || \
-				((psLOCAL->RadioOffStatus.boHwRadioOff == TRUE) || (psLOCAL->RadioOffStatus.boSwRadioOff == TRUE)) )
-			{
-				NDIS_SET_PACKET_STATUS( pNdisPacket, NDIS_STATUS_FAILURE );
-				NdisMSendComplete( Adapter->WbNdis.MiniportAdapterHandle, pNdisPacket, NDIS_STATUS_FAILURE);
-				#ifdef _PE_TX_DUMP_
-				WBDEBUG(("CURRENT_LINK_OFF + Block\n"));
-				#endif
-			}
-			else
-			{
-				//
-				// Queuing the ndis packet
-				//
-				OS_SPIN_LOCK_ACQUIRED( &pWbNdis->SpinLock );
-				RESERVED(pNdisPacket)->Next = NULL;
-
-				if( pWbNdis->first_packet==NULL)
-					pWbNdis->first_packet = pNdisPacket;
-				else
-					RESERVED(pWbNdis->last_packet)->Next = pNdisPacket;
-
-				pWbNdis->last_packet = pNdisPacket;
-				Adapter->sLocalPara._NumTxMSDU++;
-				OS_SPIN_LOCK_RELEASED( &pWbNdis->SpinLock );
-			}
-		}
-	}
-
-	//
-	// Start to transmit
-	//
-	Mds_Tx( Adapter );
-}
-
-
-//931130.5.s
-void
-WBNDIS_GetNextPacket(  PADAPTER Adapter,  PDESCRIPTOR pDes )
-{
-	PWBNDIS			pWbNdis = &Adapter->WbNdis;
-	PNDIS_PACKET	pNdisPacket;
-	PNDIS_BUFFER	pNdisPacketBuffer;
-	PUCHAR			pBufAddress, pTgtBufAddress;
-	u32			NdisPacketBufferCount, NdisPacketSize, buf_size;
-	u8			first_in;
-
-
-	//Get a Ndis packet to transmit
-	OS_SPIN_LOCK_ACQUIRED(&pWbNdis->SpinLock);
-	pNdisPacket = pWbNdis->first_packet;
-	if( pNdisPacket == pWbNdis->last_packet )
-		pWbNdis->last_packet = NULL;
-	pWbNdis->first_packet = RESERVED(pWbNdis->first_packet)->Next;
-	OS_SPIN_LOCK_RELEASED(&pWbNdis->SpinLock);//Release spinlock
-
-	//================================================================================
-	// Fill the related information into descriptor												//
-	//================================================================================
-	pWbNdis->TxByteCount += RESERVED(pNdisPacket)->NdisPacketSize; // 940803 Add
-
-	pWbNdis->packet_return = pNdisPacket;
-	if( RESERVED(pNdisPacket)->pNdisPacketBuffer )
-	{
-		pNdisPacketBuffer = RESERVED(pNdisPacket)->pNdisPacketBuffer;
-
-		//Add buffer
-		first_in = 0;
-		while( pNdisPacketBuffer )
-		{
-			// Get the address and length of the first buffer
-			#ifdef NDIS51_MINIPORT// PD43 20030430 920428.3
-			NdisQueryBufferSafe( pNdisPacketBuffer, (void* *) &pBufAddress, &buf_size, HighPagePriority );
-			#else
-			NdisQueryBuffer( pNdisPacketBuffer, (void* *) &pBufAddress, &buf_size );
-			#endif
-
-			#ifdef _PE_TX_DUMP_
-			//[WK DUMP]
-			//WBDEBUG(("=== DUMP TX PACKET ===\n"));
-			//DataDmp( pBufAddress, buf_size, 0);
-			#endif
-
-			//931130.5.t
-			//		+------------+
-			//		| header + 2 |  <-- DA + SA + T/L
-			//		+------------+
-			//		+-------------------------------+
-			//		| data							|
-			//		+-------------------------------+
-			//					:
-			//					:
-			//
-			if( first_in == 0 )
-			{
-				//931130.5.u
-				if( buf_size < (DOT_3_TYPE_OFFSET+2) )
-				{
-					#ifdef _PE_RX_DUMP_
-					WBDEBUG(("First buffer of Ndis Packet too small\n"));
-					#endif
-					NDIS_SET_PACKET_STATUS( pNdisPacket, NDIS_STATUS_FAILURE );
-					NdisMSendComplete( Adapter->WbNdis.MiniportAdapterHandle, pNdisPacket, NDIS_STATUS_FAILURE);
-					pWbNdis->packet_return = NULL;
-					return;
-				}
-
-				DESCRIPTOR_ADD_BUFFER( pDes, pBufAddress, DOT_3_TYPE_OFFSET+2 );
-
-				buf_size -= (DOT_3_TYPE_OFFSET+2);
-				pBufAddress += (DOT_3_TYPE_OFFSET+2);
-				first_in = 1;
-			}
-
-			if( buf_size )// Add the left data 931130.5.v
-				DESCRIPTOR_ADD_BUFFER( pDes, pBufAddress, (u16)buf_size );
-
-			//Get the next ndis packet buffer
-			NdisGetNextBuffer( pNdisPacketBuffer, &pNdisPacketBuffer);
-		}
-	}
-	else
-	{
-		// Copy frame into temp buffer due to too many piece of buffer
-		NdisQueryPacket( pNdisPacket, NULL, &NdisPacketBufferCount, &pNdisPacketBuffer, &NdisPacketSize);
-		pTgtBufAddress = pWbNdis->NdisBufferTmp;
-
-		// Copy buffer
-		while( pNdisPacketBuffer )
-		{
-			// Get the address and length of the first buffer
-			#ifdef NDIS51_MINIPORT// PD43 20030430 920428.3
-			NdisQueryBufferSafe( pNdisPacketBuffer, (void* *) &pBufAddress, &buf_size, HighPagePriority );
-			#else
-			NdisQueryBuffer( pNdisPacketBuffer, (void* *) &pBufAddress, &buf_size );
-			#endif
-
-			memcpy( pTgtBufAddress, pBufAddress, buf_size );
-			pTgtBufAddress += buf_size;
-
-			//Get the next ndis packet buffer
-			NdisGetNextBuffer( pNdisPacketBuffer, &pNdisPacketBuffer);
-		}
-
-		// Add buffer
-		DESCRIPTOR_ADD_BUFFER( pDes, pWbNdis->NdisBufferTmp, DOT_3_TYPE_OFFSET+2 );
-		DESCRIPTOR_ADD_BUFFER( pDes, pWbNdis->NdisBufferTmp+DOT_3_TYPE_OFFSET+2, NdisPacketSize - (DOT_3_TYPE_OFFSET+2) );
-	}
-}
-
-void WBNDIS_GetNextPacketCompleted(  PADAPTER Adapter,  PDESCRIPTOR pDes )
-{
-	PWBNDIS pWbNdis = &Adapter->WbNdis;
-	PNDIS_PACKET pNdisPacket;
-
-	//
-	// Return the send result to NDIS
-	//
-	pNdisPacket = pWbNdis->packet_return;
-	if( !pNdisPacket )
-	{
-		#ifdef _PE_TX_DUMP_
-		WBDEBUG(("WBNDIS Tx null point error\n"));
-		#endif
-		return;
-	}
-
-	//In 2m_wlan_wep of HCT test, if the key is removed, the transmitting data should
-	//still return "success". Or this test item will be failed.
-	//[WK DUMP]
-	//WBDEBUG(("Packet tx completely. addr =%x\n", pNdisPacket));
-	NdisMSendComplete( Adapter->WbNdis.MiniportAdapterHandle,
-						   pNdisPacket,
-						   NDIS_STATUS_SUCCESS );
-	MIB_GS_XMIT_OK_INC;
-	pWbNdis->packet_return = NULL;
-}
-
-void
-WBNDIS_stop(  PADAPTER Adapter )
-{
-	PWBNDIS			pWbNdis = &Adapter->WbNdis;
-	PNDIS_PACKET	pNdisPacket;
-
-
-	if( OS_ATOMIC_INC( Adapter, &pWbNdis->ThreadCount ) == 1 )
-	{
-		// Shutdown module immediately
-		pWbNdis->shutdown = 1;
-
-		// Return all the ndis packet handle in sending queue
-		OS_SPIN_LOCK_ACQUIRED(&pWbNdis->SpinLock);
-		while( pWbNdis->first_packet != NULL )
-		{
-			// Update queue point before exit spin-lock protect
-			pNdisPacket = pWbNdis->first_packet;
-			pWbNdis->first_packet = RESERVED(pWbNdis->first_packet)->Next;
-			OS_SPIN_LOCK_RELEASED(&pWbNdis->SpinLock);//release spinlock
-			NdisMSendComplete( Adapter->WbNdis.MiniportAdapterHandle,
-							   pNdisPacket,
-							   NDIS_STATUS_FAILURE );
-			OS_SPIN_LOCK_ACQUIRED(&pWbNdis->SpinLock);
-		}
-		pWbNdis->last_packet = NULL;
-		OS_SPIN_LOCK_RELEASED(&pWbNdis->SpinLock);//release spinlock
-	}
-
-	OS_ATOMIC_DEC( Adapter, &pWbNdis->ThreadCount );
-}
-
-void
-WBNDIS_Destroy(  PADAPTER Adapter )
-{
-	PWBNDIS			pWbNdis = &Adapter->WbNdis;
-	u32			i;
-	unsigned char			Cancel;
-
-
-	WBNDIS_stop( Adapter );
-//	OS_SLEEP(10000);
-
-	//======================================================================
-	// Release the Rx NDIS resource
-	//======================================================================
-	if( pWbNdis->NdisBufferPoolOk )// Free NDIS buffer pool handle
-		NdisFreeBufferPool( pWbNdis->BufferPoolHandle );
-
-	for( i=0; i<pWbNdis->PacketAllocateCount; i++ ) // Free NDIS packet
-		NdisFreePacket( pWbNdis->ReceivePacket[i] );
-
-	if( pWbNdis->NdisPacketPoolOk )
-		NdisFreePacketPool( pWbNdis->PacketPoolHandle );// Free NDIS packet pool handle
-
-	OS_SPIN_LOCK_FREE( &pWbNdis->SpinLock );
-
-	OS_TIMER_CANCEL( &pWbNdis->TxRateTimer, &Cancel );
-}
-
-
-
-unsigned char
-WBNDIS_Initial(  PADAPTER Adapter,  NDIS_HANDLE MiniportAdapterHandle )
-{
-	PWBNDIS		pWbNdis = &Adapter->WbNdis;
-	NDIS_STATUS	status;
-	u8		i;
-
-	do
-	{
-		pWbNdis->MiniportAdapterHandle = MiniportAdapterHandle;// Saving the Adapter Handler
-		pWbNdis->connect_status        = NDIS_STATUS_MEDIA_DISCONNECT; // Media disconnect
-
-		OS_SPIN_LOCK_ALLOCATE( &pWbNdis->SpinLock );
-
-		// Allocate ndis packet pool handle
-		NdisAllocatePacketPool( &status, &pWbNdis->PacketPoolHandle, ETHERNET_RX_DESCRIPTORS, 16 );
-		if( status != NDIS_STATUS_SUCCESS )
-			break;
-		pWbNdis->NdisPacketPoolOk = 1;
-
-		// Allocate ndis packet
-		for( i=0; i<ETHERNET_RX_DESCRIPTORS; i++ )
-		{
-			NdisAllocatePacket(	&status, &pWbNdis->ReceivePacket[i], pWbNdis->PacketPoolHandle );
-			if( status != NDIS_STATUS_SUCCESS)
-				break;
-			NDIS_SET_PACKET_HEADER_SIZE( pWbNdis->ReceivePacket[i], 14 );
-		}
-		pWbNdis->PacketAllocateCount = i;
-		if( i != ETHERNET_RX_DESCRIPTORS )
-			break;
-
-		// Allocate ndis bufer pool
-		NdisAllocateBufferPool(	&status, &pWbNdis->BufferPoolHandle, ETHERNET_RX_DESCRIPTORS );
-		if( status != NDIS_STATUS_SUCCESS )
-			break;
-		pWbNdis->NdisBufferPoolOk = 1;
-
-		// Allocate timer for Tx rate show
-		pWbNdis->TxRateShowResult = RATE_1M;
-		OS_TIMER_INITIAL( &pWbNdis->TxRateTimer, WbNdis_TxRateShow, Adapter );
-		OS_TIMER_SET( &pWbNdis->TxRateTimer, 5000 );
-
-		return TRUE;
-
-	}while(FALSE);
-
-	return FALSE;
-}
-
-void
-WBNDIS_ReceivePacket(  PADAPTER Adapter,  PRXLAYER1 pRxLayer1 )
-{
-	PWBNDIS pWbNdis = &Adapter->WbNdis;
-	PNDIS_PACKET	pNdisPacket;
-	PNDIS_BUFFER	pBufferHandle;
-	NDIS_STATUS	BufStatus;
-	PUCHAR		BufAddr;
-	u32		ByteCount = 0;
-	u16		BufSize;
-	u8		BufIndex;
-	u8		i;
-
-/*	if( pRxLayer1->BufferNumber == 1 )
-	{
-		BufIndex = pRxLayer1->BufferQueue[0].BufferIndex;
-		BufSize = pRxLayer1->BufferQueue[0].BufferSize;
-		BufAddr = pRxLayer1->BufferQueue[0].pBufferAddress;
-
-		NdisMEthIndicateReceive( Adapter->WbNdis.MiniportAdapterHandle,
-								 NULL,
-								 BufAddr,
-								 14,
-								 BufAddr + 14,
-								 BufSize - 14,
-								 BufSize );
-		NdisMEthIndicateReceiveComplete( Adapter->WbNdis.MiniportAdapterHandle );
-	}
-	else
-	{*/
-	for( i=0; i<pRxLayer1->BufferNumber; i++ )
-	{
-		BufIndex = pRxLayer1->BufferQueue[i].BufferIndex;
-		BufSize = pRxLayer1->BufferQueue[i].BufferSize;
-		BufAddr = pRxLayer1->BufferQueue[i].pBufferAddress;
-		ByteCount += BufSize;
-
-		NdisAllocateBuffer( &BufStatus,
-							&Adapter->WbNdis.ReceiveBuffer[BufIndex],
-							Adapter->WbNdis.BufferPoolHandle,
-							(void*)BufAddr,
-							BufSize);
-
-		if( BufStatus == NDIS_STATUS_SUCCESS )
-		{
-			if( i == 0 )
-			{
-				pNdisPacket = Adapter->WbNdis.ReceivePacket[BufIndex];//Get the ndis packet handle
-			}
-			NdisChainBufferAtBack( pNdisPacket, Adapter->WbNdis.ReceiveBuffer[BufIndex] );
-		}
-	}
-
-	pWbNdis->RxByteCount += ByteCount; // 940803 Add
-
-	// Indicate to NDIS
-	NDIS_SET_PACKET_STATUS( pNdisPacket, NDIS_STATUS_RESOURCES );
-	NdisMIndicateReceivePacket( Adapter->WbNdis.MiniportAdapterHandle, &pNdisPacket, 1) ;
-
-	// DeAllocate the NDIS buffer
-	for( i=0; i<pRxLayer1->BufferNumber; i++ )
-	{
-		NdisUnchainBufferAtBack(Adapter->WbNdis.ReceivePacket[0], &pBufferHandle);
-
-		if( pBufferHandle ) NdisFreeBuffer(pBufferHandle);
-	}
-//	}
-}
-
-
-void WbNdis_TxRateShow(  void* S1,  PADAPTER Adapter,  void* S3,  void* S4 )
-{
-	PWBNDIS	pWbNdis = &Adapter->WbNdis;
-
-	if( CURRENT_LINK_ON )
-	{
-		if( ((pWbNdis->TxByteCount - pWbNdis->TxByteCount_last) == 0 ) &&
-			( Adapter->sLocalPara.TxRateMode == RATE_AUTO ) )
-			pWbNdis->TxRateShowResult = psLOCAL->SRateSet[psLOCAL->NumOfSRate - 1]; // Get the maximum of Tx rate; // No traffic
-		else
-			pWbNdis->TxRateShowResult = psLOCAL->CurrentTxRate;
-
-		pWbNdis->TxByteCount_last = pWbNdis->TxByteCount;
-	}
-	else
-		pWbNdis->TxRateShowResult = RATE_1M;
-
-		// 20060317 The variable maybe set to 0 due to Radio On/Off. Ignore the condition here
-//	if( !pWbNdis->shutdown )
-		OS_TIMER_SET( &pWbNdis->TxRateTimer, 5000 ); // 5 sec
-}
-
-void WBNDIS_ConnectStatus(  PADAPTER Adapter,  u32 flag )
-{
-	Adapter->WbNdis.connect_status = NDIS_STATUS_MEDIA_DISCONNECT;
-	if( flag == OS_CONNECTED )
-		Adapter->WbNdis.connect_status = NDIS_STATUS_MEDIA_CONNECT;
-
-	NdisMIndicateStatus( Adapter->WbNdis.MiniportAdapterHandle,
-						 Adapter->WbNdis.connect_status,
-						 NULL, 0 );
-	NdisMIndicateStatusComplete( Adapter->WbNdis.MiniportAdapterHandle );
-}
-
-#ifdef NDIS50_MINIPORT
-void WbInitializeString(   PNDIS_STRING DestinationString,  PUCHAR SourceString )
-{
-	u16 i, len;
-
-	len = (u16)strlen( SourceString );
-	if ((OS_MEMORY_ALLOC( (void* *)&DestinationString->Buffer, 100 ) != 1) || // 100 byte maximum
-		(len >= 50 ) )
-	{
-		DestinationString->MaximumLength = 0;
-		DestinationString->Length = 0;
-		return;
-	}
-
-	OS_MEMORY_CLEAR( DestinationString->Buffer, 100 );
-	DestinationString->MaximumLength = 100/2;
-	DestinationString->Length = len*2;
-	for( i=0; i<len; i++ )
-		DestinationString->Buffer[i] = SourceString[i];
-}
-
-void WbFreeString( NDIS_STRING String)
-{
-	kfree(String.Buffer);
-	String.Buffer = NULL;
-}
-#endif
-
-
-
+/* No more Window$ c0d3 */
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis51.c b/drivers/net/wireless/winbond/winbondport/wbndis51.c
index 4da4f54..db124b9 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis51.c
+++ b/drivers/net/wireless/winbond/winbondport/wbndis51.c
@@ -1,2310 +1 @@
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	wbndis51.c
-//		
-//	history :
-//
-//	Description:
-//		Implement the incremental OIDs in NIDS5.1
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-#include "os_common.h"
-
-/*-------------------- Local function definition ---------------------------*/
-void drv_translate_bss_ex(  PWB32_ADAPTER Adapter, NDIS_WLAN_BSSID_EX *pndis_bss, bss_desc_tt *pbss );
-void NetworkTypeConvert(PNDIS_802_11_NETWORK_TYPE pNetworkType, u8 band);
-void ChannelNumToFreq(u8 NetworkType, u8 ChannelNumber, u32 *freq);
-u8* get_name_of_region(WLAN_REGION_CODE region);
-//u32* get_channels_of_region(WLAN_REGION_CODE region);
-u16 ChanNo2String(u8 ChNo, u8 * Str);
-
-// 20040114.3 Add
-void WbNdis51_initial(  PWB32_ADAPTER Adapter )
-{
-	PNDIS51_DESIRED_PARAMETER pN51 = &Adapter->DesiredNdis51Parameter;
-
-	NdisMInitializeTimer( &pN51->scan_sync_timer,
-						  Adapter->WbNdis.MiniportAdapterHandle,
-                          WbNdis51_oid_sync,
-                          Adapter);
-
-	NdisMInitializeTimer( &pN51->Connect_timer,
-						  Adapter->WbNdis.MiniportAdapterHandle,
-                          WbNdis51_connect,
-                          Adapter);
-
-	// Modify to 2sec due to First disconnect event will be indicated
-	NdisMSetTimer( &pN51->scan_sync_timer, 2000 );
-
-	if( !psSCAN->BScanEnable )
-		NdisMSetTimer( &pN51->Connect_timer, 1000 );
-}
-void WbNdis51_destroy(  PWB32_ADAPTER Adapter )
-{
-	PNDIS51_DESIRED_PARAMETER pN51 = &Adapter->DesiredNdis51Parameter;
-	unsigned char	cancel;
-
-	NdisMCancelTimer( &pN51->scan_sync_timer, &cancel );
-	if( !psSCAN->BScanEnable ) NdisMCancelTimer( &pN51->Connect_timer, &cancel );
-}
-void WbNdis51_connect(  void* s1,  PWB32_ADAPTER Adapter,  void* s3,  void* s4 )
-{
-	PNDIS51_DESIRED_PARAMETER pN51 = &Adapter->DesiredNdis51Parameter;
-
-	if( pN51->ConnectCount )
-	{
-		if( CURRENT_LINK_ON )
-		{
-			pN51->ConnectCount = 0;
-			pN51->ConnectInterval = 0;
-		}
-		else
-		{
-			pN51->ConnectInterval--;
-			if( pN51->ConnectInterval <= 0 )
-			{
-				sme_set_desired_ssid( Adapter, pN51->CurrentSSID, (u8)pN51->CurrentSSIDLength );
-				pN51->ConnectCount = 0;
-			}
-		}
-	}
-
-	NdisMSetTimer( &pN51->Connect_timer, 1000 );
-}
-
-void WbNdis51_oid_sync(  void* s1,  PWB32_ADAPTER Adapter,  void* s3,  void* s4 )
-{
-	PNDIS51_DESIRED_PARAMETER pN51 = &Adapter->DesiredNdis51Parameter;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("BG scan sec = %d\n", pN51->sync_count ));
-	#endif
-
-	//Periodically query the h/w radio status
-	CheckHwRadioStatus( Adapter );
-
-	if( pN51->sync_scan_require )
-	{
-		if (((u32)Adapter->WbNdis.connect_status != (u32)NDIS_STATUS_MEDIA_CONNECT) ||
-			(Adapter->Mds.TxToggle == FALSE))
-		{
-			if ((pN51->sync_count >= 60) || (pN51->sync_count <= 66))
-				psSCAN->ScanTimeStamp++;//background scan
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Issue scanning\n"));
-			#endif
-			sme_set_bssid_list_scan(Adapter,NULL);
-            //to update pmkid table in OS
-            #ifdef _WPA2_
-            if(psSME->wpa_ok && psSME->bDesiredAuthMode==WPA2PSK_AUTH)
-               OS_PMKID_STATUS_EVENT( Adapter );
-            #endif //end def _WPA2_
-		}
-
-		pN51->sync_count = 0;
-
-		pN51->sync_scan_require = 0;
-	}
-
-	pN51->sync_count += 2;
-
-	//FUNK software won't issue scanning per 60 sec.
-	if( !TS_RUNNING_IN_TESTSTA_MODE )
-	{
-		if( (pN51->sync_count == 66) && psSCAN->BScanEnable )
-			pN51->sync_scan_require = 1;//Enfore to issue background scanning
-	}
-
-	Adapter->Mds.TxToggle = FALSE;	//move from roamtask.c to clear.
-									//2 seconds later it will be true if there is any tx activity.
-									//If it is still false, the scan is permitted. [20050706]
-
-	NdisMSetTimer( &pN51->scan_sync_timer, 2000 );
-}
-
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
-NDIS_STATUS Ndis51QueryInformation(  PWB32_ADAPTER pcore_data,
-                                     NDIS_OID Oid,
-                                     void* InformationBuffer,
-                                     u32 InformationBufferLength,
-                                     PULONG  pMoveBytes)
-{
-    u8  count,j;
-    NDIS_STATUS ret = NDIS_STATUS_SUCCESS;
-    u32        bytes_needed;
-	PWB32_ADAPTER Adapter = pcore_data;
-
-	#ifdef _PE_OID_DUMP_
-	DbgPrintfOID51(Oid, TRUE);
-	#endif
-    switch(Oid)
-    {
-	/* The follow OID must be supported ++++++++++++++++++++++++++++++++++++*/
-
-	case OID_GEN_PHYSICAL_MEDIUM:
-
-		bytes_needed = sizeof(NDIS_PHYSICAL_MEDIUM);
-
-		if(bytes_needed <= InformationBufferLength)
-		{
-			PNDIS_PHYSICAL_MEDIUM	pPhysMedia = (PNDIS_PHYSICAL_MEDIUM)InformationBuffer;
-			*pPhysMedia = NdisPhysicalMediumWirelessLan;
-		}
-		break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_BSSID:
-
-        bytes_needed = 6;
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            if (sme_get_bssid(pcore_data, InformationBuffer) < 0)
-            {
-                ret = NDIS_STATUS_ADAPTER_NOT_READY;
-            }
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_SSID:
-
-        bytes_needed = sizeof(NDIS_802_11_SSID);
-
-        if (bytes_needed <= InformationBufferLength)
-        {
-            PNDIS_802_11_SSID   p;
-
-            p = (PNDIS_802_11_SSID) InformationBuffer;
-
-			p->SsidLength = 0;
-			sme_get_ssid(pcore_data, p->Ssid, (u8 *)&(p->SsidLength));
-			#ifdef _PE_OID_DUMP_
-			{
-				u8 ssid[50];
-
-			memcpy(ssid, (u8 *)p->Ssid, (u8)p->SsidLength);
-			ssid[p->SsidLength] = '\0';
-			WBDEBUG(("GET ssid=%s\n", ssid));
-			}
-			#endif
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_NETWORK_TYPES_SUPPORTED:
-
-        bytes_needed = sizeof(NDIS_802_11_NETWORK_TYPE_LIST);
-		switch (psLOCAL->bMacOperationMode)
-		{
-			case MODE_802_11_A:
-			case MODE_802_11_B:
-				break;
-			case MODE_802_11_ABG:
-				bytes_needed += (sizeof(NDIS_802_11_NETWORK_TYPE)*2);
-				break;
-			default:
-				bytes_needed += sizeof(NDIS_802_11_NETWORK_TYPE);
-				break;
-		}
-        if(bytes_needed <= InformationBufferLength)
-        {
-            PNDIS_802_11_NETWORK_TYPE_LIST  p;
-			u32	tmpp = 0;
-
-			tmpp = sizeof(NDIS_802_11_NETWORK_TYPE);
-            p = (PNDIS_802_11_NETWORK_TYPE_LIST) InformationBuffer;
-			if (psLOCAL->bMacOperationMode == MODE_802_11_A)
-			{
-				p->NumberOfItems    = 1;
-				p->NetworkType[0]   = Ndis802_11OFDM5;
-			}
-			else if (psLOCAL->bMacOperationMode == MODE_802_11_ABG)
-			{
-				p->NumberOfItems    = 3;
-				p->NetworkType[0]   = Ndis802_11DS;
-				p->NetworkType[1]   = Ndis802_11OFDM5;
-				p->NetworkType[2]	= Ndis802_11OFDM24;
-			}
-			else if (psLOCAL->bMacOperationMode == MODE_802_11_B)
-			{
-				p->NumberOfItems    = 1;
-				p->NetworkType[0]   = Ndis802_11DS;
-			}
-			else
-			{
-				p->NumberOfItems    = 2;
-				p->NetworkType[0]   = Ndis802_11DS;
-				p->NetworkType[1]   = Ndis802_11OFDM24;
-			}
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_NETWORK_TYPE_IN_USE:
-
-		bytes_needed = sizeof(NDIS_802_11_NETWORK_TYPE);
-
-		if(bytes_needed <= InformationBufferLength)
-        {
-            PNDIS_802_11_NETWORK_TYPE   p;
-			u8						BandType;
-
-            p = (PNDIS_802_11_NETWORK_TYPE) InformationBuffer;
-
-			sme_get_network_type_in_use(pcore_data, &BandType);
-			NetworkTypeConvert(p, BandType);
-		}
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_RSSI:
-
-        bytes_needed = sizeof(NDIS_802_11_RSSI);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            NDIS_802_11_RSSI    *p;
-
-            p = (NDIS_802_11_RSSI *) InformationBuffer;
-            sme_get_rssi(pcore_data, p);
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_INFRASTRUCTURE_MODE:
-
-        bytes_needed = sizeof(NDIS_802_11_NETWORK_INFRASTRUCTURE);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            PNDIS_802_11_NETWORK_INFRASTRUCTURE p;
-            u8  bss_type;
-
-            p = (PNDIS_802_11_NETWORK_INFRASTRUCTURE) InformationBuffer;
-
-			*p = Ndis802_11AutoUnknown;// Default value setting
-            if (sme_get_bss_type(pcore_data, &bss_type) != -1)
-            {
-				if(bss_type == ESS_NET)
-	                *p = Ndis802_11Infrastructure;
-                else if(bss_type == IBSS_NET)
-	                *p = Ndis802_11IBSS;
-			}
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_FRAGMENTATION_THRESHOLD:
-
-        bytes_needed = sizeof(NDIS_802_11_FRAGMENTATION_THRESHOLD);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            NDIS_802_11_FRAGMENTATION_THRESHOLD *p;
-
-            p = (NDIS_802_11_FRAGMENTATION_THRESHOLD *) InformationBuffer;
-            sme_get_fragment_threshold(pcore_data, p);
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_RTS_THRESHOLD:
-
-        bytes_needed = sizeof(NDIS_802_11_RTS_THRESHOLD);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            NDIS_802_11_RTS_THRESHOLD   *p;
-
-            p = (NDIS_802_11_RTS_THRESHOLD *) InformationBuffer;
-            sme_get_rts_threshold(pcore_data, p);
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_SUPPORTED_RATES:
-
-        bytes_needed = 8;
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            PUCHAR  p;
-
-            //The size of NDIS_802_11_RATES is 8 bytes
-            p = (PUCHAR) InformationBuffer;
-            p[0] = 0x82;    // Basic and operating rate for   1Mbps
-            p[1] = 0x84;    // Basic and operating rate for   2Mbps
-            p[2] = 0x8b;    // Basic and operating rate for 5.5Mbps
-            p[3] = 0x96;    // Basic and operating rate for  11Mbps
-            p[4] = 0x00;    // End
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_CONFIGURATION:
-
-        bytes_needed = sizeof(NDIS_802_11_CONFIGURATION);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            PNDIS_802_11_CONFIGURATION  p;
-            u8  current_channel, current_band;
-			NDIS_802_11_NETWORK_TYPE	NetworkType;
-			u32 channel_freq = 0;
-
-            p = (PNDIS_802_11_CONFIGURATION) InformationBuffer;
-            p->Length = sizeof(NDIS_802_11_CONFIGURATION);
-			// PD43 20030530
-			p->BeaconPeriod = 0;
-            sme_get_beacon_period(pcore_data, (u16 *)&(p->BeaconPeriod));
-			// PD43 20030530
-			p->ATIMWindow = 0;
-            sme_get_atim_window(pcore_data, (u16 *)&(p->ATIMWindow));
-            sme_get_current_channel(pcore_data, &current_channel);
-			sme_get_current_band(pcore_data, &current_band);
-			NetworkTypeConvert(&NetworkType, current_band);
-			ChannelNumToFreq( (u8)NetworkType, current_channel, &channel_freq);
-			p->DSConfig = channel_freq * 1000;
-
-            p->FHConfig.Length      = sizeof(NDIS_802_11_CONFIGURATION_FH);
-            p->FHConfig.HopPattern  = 0;
-            p->FHConfig.HopSet      = 0;
-            p->FHConfig.DwellTime   = 0;
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_BSSID_LIST:
-
-		sme_get_scan_bss_count(pcore_data, &count);
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("[DRV] ** bss_count = %d\n", count));
-		#endif
-		//
-		bytes_needed = sizeof(u32);
-
-		{
-			u8	boMsRadioOff;
-			RadioOff		RadioOffData;
-
-			// 1: off, 0: on
-			sme_get_radio_mode(Adapter, &RadioOffData);
-			sme_get_ms_radio_mode(Adapter, &boMsRadioOff);
-			if (boMsRadioOff || RadioOffData.boHwRadioOff || RadioOffData.boSwRadioOff)
-			{
-				count = 0;
-				bytes_needed += sizeof(NDIS_WLAN_BSSID_EX);
-			}
-		}
-
-        for (j=0; j < count; j++)
-        {
-			bss_desc_tt		*pbss;
-
-        	bytes_needed += (sizeof(NDIS_WLAN_BSSID_EX)-4);
-            sme_get_scan_bss(pcore_data, j, &pbss);
-			Assemble_IE(pcore_data, pbss->wIndex);
-
-			// 20061108 Add for WPS
-			bytes_needed += pbss->WPS_IE_length;
-
-            bytes_needed += ((pbss->ies_len + 3) & ~0x03);
-        }
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("InformationBufferLength =%d\n", InformationBufferLength));
-		WBDEBUG(("bytes_needed =%d\n", bytes_needed));
-		#endif
-		//------------------
-        if(bytes_needed <= InformationBufferLength)
-        {
-            NDIS_802_11_BSSID_LIST_EX   *p;
-            NDIS_WLAN_BSSID_EX          *pndis_bss;
-
-            u8                      i;
-            bss_desc_tt              *pscan_bss = NULL; // important!!!
-
-            NdisZeroMemory(InformationBuffer, bytes_needed);
-            p = (NDIS_802_11_BSSID_LIST_EX *)InformationBuffer;
-
-
-            // get and translate all the BSSs found during the scan
-            pndis_bss = (NDIS_WLAN_BSSID_EX*) &(p->Bssid[0]);
-
-            for (i=0; i < count; i++)
-            {
-                sme_get_scan_bss(pcore_data, i, &pscan_bss);
-                drv_translate_bss_ex( Adapter, pndis_bss, pscan_bss );
-
-                pndis_bss = (NDIS_WLAN_BSSID_EX*) ((u8*)pndis_bss + pndis_bss->Length);
-            }
-            p->NumberOfItems = i;
-        }
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("***** OID_802_11_BSSID_LIST return value =%x\n", ret));
-		#endif
-		//------------------------------------------
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_AUTHENTICATION_MODE:
-        bytes_needed = sizeof(NDIS_802_11_AUTHENTICATION_MODE);
-        if(bytes_needed <= InformationBufferLength)
-        {
-            PNDIS_802_11_AUTHENTICATION_MODE    p;
-            u8 auth_mode;
-
-            p = (PNDIS_802_11_AUTHENTICATION_MODE) InformationBuffer;
-            if(sme_get_auth_mode(pcore_data, &auth_mode) != -1)
-			{
-				#ifdef _PE_OID_DUMP_
-				//_asm{int 3}
-				WBDEBUG(("GET Auth mode = %x\n", auth_mode));
-				#endif
-				switch(auth_mode)
-				{
-					case OPEN_AUTH:
-						*p = Ndis802_11AuthModeOpen;
-						break;
-					case SHARE_AUTH:
-						*p = Ndis802_11AuthModeShared;
-						break;
-					case ANY_AUTH:
-						*p = Ndis802_11AuthModeAutoSwitch;
-						break;
-					case WPA_AUTH:
-						*p = Ndis802_11AuthModeWPA;
-						break;
-					case WPAPSK_AUTH:
-						*p = Ndis802_11AuthModeWPAPSK;
-						break;
-					case WPANONE_AUTH:
-						*p = Ndis802_11AuthModeWPANone;
-						break;
-					#ifdef _WPA2_
-					case WPA2_AUTH:                   //for WPA2 added by WS 19/4/04
-						*p = Ndis802_11AuthModeWPA2;
-						break;
-					case WPA2PSK_AUTH:
-						*p = Ndis802_11AuthModeWPA2PSK;//for WPA2 added by WS 19/4/04
-					    break;
-					#endif //end def _WPA2_
-					default:
-						break;
-				}
-			}
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    //case OID_802_11_WEP_STATUS:
-	case OID_802_11_ENCRYPTION_STATUS: // same as OID_802_11_WEP_STATUS
-
-        bytes_needed = sizeof(NDIS_802_11_WEP_STATUS);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-			//----------------------------------------------------------
-			PNDIS_802_11_ENCRYPTION_STATUS	p = (PNDIS_802_11_ENCRYPTION_STATUS) InformationBuffer;
-			u8 EncryptStatus;
-
-			sme_get_encryption_status(pcore_data, &EncryptStatus);
-			#ifdef _PE_OID_DUMP_
-			//_asm{int 3}
-			WBDEBUG(("GET encrypt status = %x\n", EncryptStatus));
-			#endif
-			switch (EncryptStatus)
-			{
-				/*
-				case ENCRYPT_NOTSUPPORT:
-					*p = Ndis802_11EncryptionNotSupported;
-					break;
-				*/
-				case ENCRYPT_DISABLE:
-					*p = Ndis802_11EncryptionDisabled;
-					break;
-				case ENCRYPT_WEP:
-					*p = Ndis802_11Encryption1Enabled;
-					break;
-				case ENCRYPT_WEP_NOKEY:
-					*p = Ndis802_11Encryption1KeyAbsent;
-					break;
-				case ENCRYPT_TKIP:
-					*p = Ndis802_11Encryption2Enabled;
-					break;
-				case ENCRYPT_TKIP_NOKEY:
-					*p = Ndis802_11Encryption2KeyAbsent;
-					break;
-				case ENCRYPT_CCMP:
-					*p = Ndis802_11Encryption3Enabled;
-					break;
-				case ENCRYPT_CCMP_NOKEY:
-					*p = Ndis802_11Encryption3KeyAbsent;
-					break;
-				default:
-					*p = Ndis802_11EncryptionNotSupported;
-					break;
-			}
-			//----------------------------------------------------------
-        }
-        break;
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_ASSOCIATION_INFORMATION:
-        //WBDEBUG(("[DRV] OID_802_11_ASSOCIATION_INFORMATION (QUERY)\n"));
-
-		bytes_needed = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION) +
-						psSME->AssocReqVarLen + psSME->AssocRespVarLen;
-
-        //PDEBUG(("[DRV] byte_needed = %d\n", bytes_needed));
-        //PDEBUG(("[DRV] InfoBufferLength = %d\n", InfoBufferLength));
-        if (bytes_needed <= InformationBufferLength)
-        {
-            NDIS_802_11_ASSOCIATION_INFORMATION *p;
-            u8  *pie;
-            u8  conn_status;
-
-            p = (NDIS_802_11_ASSOCIATION_INFORMATION *) InformationBuffer;
-
-			//WBDEBUG(("addr of conn_status = %x\n", &conn_status));
-            sme_get_connect_status(pcore_data, &conn_status);
-
-            if (conn_status == MEDIA_STATE_CONNECTED)
-            {
-                p->Length = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
-                // Association Request
-                p->AvailableRequestFixedIEs =
-                            NDIS_802_11_AI_REQFI_CAPABILITIES |
-                            NDIS_802_11_AI_REQFI_LISTENINTERVAL;
-				if (psSME->boReassoc)
-					p->AvailableRequestFixedIEs |= NDIS_802_11_AI_REQFI_CURRENTAPADDRESS;
-
-				//p->RequestFixedIEs.Capabilities		= pcore_data->sSmePara.wCapabilityInfo;
-				p->RequestFixedIEs.Capabilities =
-						pcore_data->asBSSDescriptElement[pcore_data->sLocalPara.wConnectedSTAindex].CapabilityInformation.wValue;
-				p->RequestFixedIEs.ListenInterval	= pcore_data->sLocalPara.ListenInterval;
-				if (psSME->boReassoc)
-				memcpy( p->RequestFixedIEs.CurrentAPAddress,
-								pcore_data->asBSSDescriptElement[pcore_data->sLocalPara.wConnectedSTAindex].abBssID,
-								MAC_ADDR_LENGTH );
-
-                p->RequestIELength = psSME->AssocReqVarLen;
-                p->OffsetRequestIEs = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
-
-                // Association Response
-                p->AvailableResponseFixedIEs =
-                            NDIS_802_11_AI_RESFI_CAPABILITIES |
-                            NDIS_802_11_AI_RESFI_STATUSCODE |
-                            NDIS_802_11_AI_RESFI_ASSOCIATIONID;
-				//TODO:
-                p->ResponseFixedIEs.Capabilities    = psSME->AssocRespCapability;
-                p->ResponseFixedIEs.StatusCode      = psSME->AssocRespStatus;
-				p->ResponseFixedIEs.AssociationId	= pcore_data->sLocalPara.Association_ID&0x3fff;
-				#ifdef _PE_OID_DUMP_
-				WBDEBUG(("AID =%x\n", p->ResponseFixedIEs.AssociationId));
-				#endif
-
-                p->ResponseIELength = psSME->AssocRespVarLen;
-                p->OffsetResponseIEs =
-                            sizeof(NDIS_802_11_ASSOCIATION_INFORMATION)+
-                            psSME->AssocReqVarLen;
-
-
-                pie = ((u8*) p) + sizeof(NDIS_802_11_ASSOCIATION_INFORMATION);
-				memcpy( pie, psSME->AssocReqVarIE, psSME->AssocReqVarLen );
-
-                pie += psSME->AssocReqVarLen;
-				memcpy( pie, psSME->AssocRespVarIE, psSME->AssocRespVarLen );
-				#ifdef _PE_STATE_DUMP_
-				WBDEBUG(("ASSOCIATION INFORMATION\n"));
-                DataDmp((u8 *)p, p->Length+psSME->AssocReqVarLen+psSME->AssocRespVarLen, 0);
-				#endif
-                bytes_needed = sizeof(NDIS_802_11_ASSOCIATION_INFORMATION)+
-                               psSME->AssocReqVarLen+psSME->AssocRespVarLen;
-			//--------------------------------------------------------
-            }
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_TX_POWER_LEVEL:
-        bytes_needed = sizeof(NDIS_802_11_TX_POWER_LEVEL);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            u32   *p;
-
-            p = (NDIS_802_11_TX_POWER_LEVEL *) InformationBuffer;
-            sme_get_tx_power_level(pcore_data, p);
-        }
-		break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_NUMBER_OF_ANTENNAS:
-        bytes_needed = sizeof(u32);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            u32   *p;
-
-            p = (u32 *) InformationBuffer;
-            sme_get_antenna_count(pcore_data, p);
-        }
-		break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_RX_ANTENNA_SELECTED:
-        bytes_needed = sizeof(u32);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            u32   *p;
-
-            p = (u32 *) InformationBuffer;
-            sme_get_rx_antenna(pcore_data, p);
-        }
-		break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_TX_ANTENNA_SELECTED:
-        bytes_needed = sizeof(u32);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            u32   *p;
-
-            p = (u32 *) InformationBuffer;
-            sme_get_tx_antenna(pcore_data, p);
-        }
-		break;
-
-	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-	//added by ws 04/29/04
-	#ifdef _WPA2_
-	case OID_802_11_CAPABILITY:
-	{
-	    static NDIS_802_11_AUTHENTICATION_ENCRYPTION Suppt_AUTH_ENCR_MODE[14]=
-			   {
-			    {Ndis802_11AuthModeOpen,    Ndis802_11EncryptionDisabled},
-				{Ndis802_11AuthModeOpen,    Ndis802_11Encryption1Enabled},
-				{Ndis802_11AuthModeShared,  Ndis802_11EncryptionDisabled},
-				{Ndis802_11AuthModeShared,  Ndis802_11Encryption1Enabled},
-				{Ndis802_11AuthModeWPA,     Ndis802_11Encryption2Enabled},
-				{Ndis802_11AuthModeWPA,     Ndis802_11Encryption3Enabled},
-				{Ndis802_11AuthModeWPAPSK,  Ndis802_11Encryption2Enabled},
-				{Ndis802_11AuthModeWPAPSK,  Ndis802_11Encryption3Enabled},
-				{Ndis802_11AuthModeWPANone, Ndis802_11Encryption2Enabled},
-				{Ndis802_11AuthModeWPANone, Ndis802_11Encryption3Enabled},
-				{Ndis802_11AuthModeWPA2,    Ndis802_11Encryption2Enabled},
-				{Ndis802_11AuthModeWPA2,    Ndis802_11Encryption3Enabled},
-				{Ndis802_11AuthModeWPA2PSK, Ndis802_11Encryption2Enabled},
-				{Ndis802_11AuthModeWPA2PSK, Ndis802_11Encryption3Enabled}
-               };
-
-		//PDEBUG(("[DRV] OID_802_11_CAPABIlITY(QUERY)\n"));
-        bytes_needed = sizeof(NDIS_802_11_CAPABILITY)
-                       +sizeof(NDIS_802_11_AUTHENTICATION_ENCRYPTION)*13;
-
-		if(bytes_needed <=InformationBufferLength)
-		{
-			PNDIS_802_11_CAPABILITY p=(PNDIS_802_11_CAPABILITY) InformationBuffer;
-            p->Length=bytes_needed;
-			p->Version=2;
-			p->NoOfPMKIDs=16;
-			p->NoOfAuthEncryptPairsSupported=sizeof(Suppt_AUTH_ENCR_MODE)
-                                             /sizeof(Suppt_AUTH_ENCR_MODE[0]);
-            memcpy( p->AuthenticationEncryptionSupported, Suppt_AUTH_ENCR_MODE, sizeof(Suppt_AUTH_ENCR_MODE) );
-			
-		}
-	}
-	break;//added by ws 
-	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-	case OID_802_11_PMKID:
-          {
-           NDIS_802_11_PMKID *p=(PNDIS_802_11_PMKID)InformationBuffer;
-		   bytes_needed=sizeof(psSME->PmkIdTable);
-		   if(bytes_needed <=InformationBufferLength)
-		   {
-		     p->Length=((NDIS_802_11_PMKID *)psSME->PmkIdTable)->Length;
-		     p->BSSIDInfoCount=((NDIS_802_11_PMKID *)psSME->PmkIdTable)->BSSIDInfoCount;
-		     memcpy( p->BSSIDInfo,
-							 ((NDIS_802_11_PMKID*)psSME->PmkIdTable)->BSSIDInfo,
-							 sizeof(BSSID_Info)* p->BSSIDInfoCount );
-             }
-           }
-		break;//added by ws
-	#endif //end def _WPA2_
-	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-	case OID_802_11_DESIRED_RATES://added by ws 08/04/04 
-		{
-			//TODO : [1004]
-			NDIS_802_11_RATES *p=(NDIS_802_11_RATES *)InformationBuffer;
-
-			bytes_needed=sizeof(NDIS_802_11_RATES);
-			if(bytes_needed < InformationBufferLength)
-			{
-				//memcpy(p,&psLOCAL->CurrentTxRate,sizeof(NDIS_802_11_RATES));//??
-				*(*p+0) = (u8)Adapter->WbNdis.TxRateShowResult; //psLOCAL->CurrentTxRate;
-				*(*p+1) = 0;
-			}
-		}
-		break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_POWER_MODE:
-
-        bytes_needed = sizeof(NDIS_802_11_POWER_MODE);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            NDIS_802_11_POWER_MODE	*p;
-			u8		PowerMode;
-
-            p = (NDIS_802_11_POWER_MODE *) InformationBuffer;
-            sme_get_power_mode(pcore_data, &PowerMode);
-			*p = PowerMode;
-        }
-        break;
-
-	#if 0
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_MEDIA_STREAM_MODE:
- 
-       bytes_needed = sizeof(NDIS_802_11_MEDIA_STREAM_MODE);
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            NDIS_802_11_MEDIA_STREAM_MODE	*p;
-
-            p = (NDIS_802_11_MEDIA_STREAM_MODE *) InformationBuffer;
-			*p = Ndis802_11MediaStreamOff;
-        }
-        break;
-	#endif
-
-	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-	case OID_802_11_CUST_LINK_QUALITY://added by ws 07/26/04
-		{
-	       PULONG p = (PULONG)InformationBuffer;
-	       bytes_needed = sizeof(u32);
-
-	   		if (InformationBufferLength >= bytes_needed)
-				*p = hal_get_est_sq3( &Adapter->sHwData, 5 ); // Average filter parameter = 5( more smooth)
-		}
-		break;
-
-	case OID_802_11_CUST_HW_VERSION:
-	     {
-	       u32 *p=(u32 *)InformationBuffer;
-	       bytes_needed = sizeof(u32);
-
-		   if (InformationBufferLength >= bytes_needed)
-				*p = 0x0200; // Only support FB5886
-	      }
-	      break;
-	case OID_802_11_CUST_DRV_VERSION:
-	      {
-			//TODO : [1004]
-	        u16 * p=(u16 *)InformationBuffer;
-	        bytes_needed=sizeof(u16)*4;
-	        if(bytes_needed <=InformationBufferLength)
-	           {
-				PUCHAR	pVerStr = VER_FILEVERSION_STR;
-				u16	i, k, stmp;
-	        
-				i = 0;
-				k = 0;
-				stmp = 0;
-				while( pVerStr[i] )
-				{
-					if( pVerStr[i] == '.' )
-					{
-						p[k] = stmp;
-						k++;
-						stmp = 0;
-					}
-					else
-					{
-						stmp *= 10;
-						stmp += pVerStr[i] - 0x30;
-					}
-					i++;
-				}
-				p[k] = stmp;
-	            }
-	        }//ws
-		break;
-
-#ifdef NDIS50_MINIPORT
-	case OID_802_11_CUST_DRV_NAME://for window 98 and me only
-		if(NULL != InformationBuffer && InformationBufferLength >= g_String.Length)
-		{
-			ANSI_STRING *global_String=&g_String;
-			bytes_needed = g_String.Length;
-			NdisMoveMemory(InformationBuffer,global_String->Buffer,global_String->Length);
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("[WS]OID_802_11_CUST_DRV_NAME %s \n %x \n",InformationBuffer,bytes_needed));
-			#endif
-		}
-		else
-			ret = NDIS_STATUS_FAILURE;
-
-		break;
-#endif  
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_CUST_RADIO:
-
-        bytes_needed = sizeof(WLAN_RADIO_STATUS);
-
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("[QUERY RADIO OID]\n"));
-		#endif
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            WLAN_RADIO_STATUS   *p;
-			RadioOff		RadioOffData;
-
-            p = (WLAN_RADIO_STATUS *) InformationBuffer;
-			// 1: off, 0: on
-			sme_get_radio_mode(pcore_data, &RadioOffData);
-			p->HWStatus = RadioOffData.boHwRadioOff;	//fist cut is always on
-			p->SWStatus = RadioOffData.boSwRadioOff;
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_CUST_REGION:
-
-        bytes_needed = sizeof(u32);
-
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("[QUERY REGION OID]\n"));
-		#endif
-
-        if(bytes_needed <= InformationBufferLength)
-        {
-            u32   *p;
-
-            p = (u32 *) InformationBuffer;
-			*p = psLOCAL->region;
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	// 20041102 1.1.91.1000 ybjiang
-	case OID_802_11_CUST_REGION_CAPABILITIES:
-	    {
-			phw_data_t pHwData = &Adapter->sHwData;
-			u32 i, j, Item;
-			CHAN_LIST	ChanForRegionCap[6];	//support 6 region
-			u8 PhyType, EEPROMRegion;
-			u8	aRegion[6] = {1,2,3,4,5,6};
-
-			bytes_needed = 0;
-
-			hal_get_phy_type( pHwData, &PhyType );
-			EEPROMRegion = hal_get_region_from_EEPROM( pHwData );
-
-			if( EEPROMRegion != REGION_AUTO )
-			{
-				switch( EEPROMRegion )
-				{
-					case 2: JAPAN_ChanRange( Adapter, PhyType, ChanForRegionCap ); break;
-					case 3: USA_ChanRange( Adapter, PhyType, ChanForRegionCap ); break;
-					case 4: FRANCE_ChanRange( Adapter, PhyType, ChanForRegionCap ); break;
-					case 5: SPAIN_ChanRange( Adapter, PhyType, ChanForRegionCap ); break;
-					case 6: ISRAEL_ChanRange( Adapter, PhyType, ChanForRegionCap ); break;
-					default: EUROPE_ChanRange( Adapter, PhyType, ChanForRegionCap ); break;
-				}
-				Item = 1;
-				aRegion[0] = EEPROMRegion;
-			}
-			else
-			{
-				EUROPE_ChanRange(Adapter, PhyType, ChanForRegionCap+0);
-				JAPAN_ChanRange(Adapter, PhyType, ChanForRegionCap+1);
-				USA_ChanRange(Adapter, PhyType, ChanForRegionCap+2);
-
-				FRANCE_ChanRange(Adapter, PhyType, ChanForRegionCap+3);
-				SPAIN_ChanRange(Adapter, PhyType, ChanForRegionCap+4);
-				ISRAEL_ChanRange(Adapter, PhyType, ChanForRegionCap+5);
-
-				Item = 6;
-			}
-
-			// calculate required memory size
-			for (i = 0; i < Item; ++i)
-			{
-				bytes_needed += sizeof(WLAN_REGION_CHANNELS) - sizeof(u32);
-
-				bytes_needed += sizeof(u32) * ChanForRegionCap[i].Count;
-			}
-
-			// include WLAN_REGION_CAPABILITIES::NumberOfItems
-			bytes_needed += sizeof(u32);
-
-			if (InformationBufferLength >= bytes_needed)
-			{
-				WLAN_REGION_CAPABILITIES *Capa = (WLAN_REGION_CAPABILITIES*) InformationBuffer;
-				WLAN_REGION_CHANNELS *Channels = &Capa->Region[0];
-				u8 *name, *pntmp;
-				u32 freq;
-				u8	NetworkType;
-				u16 StrLen;
-
-				Capa->NumberOfItems = Item;	//EUROPE, JAPAN, USA
-
-				for (i=0; i<Item; ++i)
-				{
-					Channels->Code = aRegion[i];
-					
-					pntmp = get_name_of_region(aRegion[i]);
-					name = Channels->Name;
-					StrLen = (u16)strlen(pntmp);
-					NdisMoveMemory(name, pntmp, StrLen);
-					name += StrLen;
-
-					//FreqArry = get_channels_of_region(region);
-					for (j=0; j<ChanForRegionCap[i].Count; j++)
-					{
-						if (ChanForRegionCap[i].Channel[j].band == BAND_TYPE_DSSS)
-							NetworkType = Ndis802_11DS;
-						else if (ChanForRegionCap[i].Channel[j].band == BAND_TYPE_OFDM_24)
-							NetworkType = Ndis802_11OFDM24;
-						else if (ChanForRegionCap[i].Channel[j].band == BAND_TYPE_OFDM_5)
-							NetworkType = Ndis802_11OFDM5;
-						ChannelNumToFreq( NetworkType, ChanForRegionCap[i].Channel[j].ChanNo, &freq );
-						Channels->Frequency[j] = freq;
-
-						if (ChanForRegionCap[i].Channel[j].band > BAND_TYPE_OFDM_24)
-						{
-							StrLen = ChanNo2String(ChanForRegionCap[i].Channel[j].ChanNo, name);
-							name += StrLen;
-						}
-					}
-					Channels->Length = sizeof(WLAN_REGION_CHANNELS) - sizeof(u32) + j * sizeof(u32);
-					*(name-1) = '\0';	//replace last ','
-					Channels->NameLength = strlen(Channels->Name);
-
-					// move to the next structure
-					Channels = (WLAN_REGION_CHANNELS*) ((u8*) Channels + Channels->Length);
-				}
-				#ifdef _PE_STATE_DUMP_
-				WBDEBUG(("** dump Query OID_802_11_CUST_REGION_CAPABILITIES **\n"));
-				DataDmp((u8 *)Capa, bytes_needed, 0);
-				#endif
-			}
-		}
-		break;
-    //--------------------------------------------------------------------------
-      case OID_802_11_CUST_ENCRYPTION_STATUS:
-        
-		bytes_needed = sizeof(u32);
-        
-		if (InformationBufferLength >= bytes_needed)
-		{    
-		     //WBDEBUG(("[WS]the wepkey error =%d",pcore_data->sLocalPara.bWepKeyError));
-			 *(u32 *) InformationBuffer = pcore_data->sLocalPara.bWepKeyError;
-		}
-		break;
-
-	//sky added 20050803
-	//----------------------------------------------------------------------------
-	  case OID_802_11_CUST_TX_THROUGHPUT:
-			bytes_needed = sizeof(u32);
-			if (InformationBufferLength >= bytes_needed)
-			{
-				*(u32 *) InformationBuffer = pcore_data->WbNdis.TxByteCount;
-			}
-			break;
-
-	//---------------------------------------------------------------------------
-	  case OID_802_11_CUST_RX_THROUGHPUT:
-			bytes_needed = sizeof(u32);
-			if (InformationBufferLength >= bytes_needed)
-			{
-				*(u32 *) InformationBuffer = pcore_data->WbNdis.RxByteCount;
-			}
-			break;
-
-	//----------------------------------------------------------------------------
-	  //sky added 2005.0817 
-	  case OID_802_11_CUST_RF_TYPE:
-			bytes_needed = sizeof(u8);
-			if (InformationBufferLength >= bytes_needed)
-			{
-				*(u8 *) InformationBuffer = pcore_data->sHwData.phy_type;
-			}
-			break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    default:
-        ret = WB_NDIS_STATUS_NOT_SUPPORTED;
-    }
-
-    *pMoveBytes = bytes_needed;
-
-    return ret;
-}
-
-/****************************************************************************/
-/* translate bss description to NDIS_WLAN_BSSID */
-void drv_translate_bss_ex(  PWB32_ADAPTER Adapter, NDIS_WLAN_BSSID_EX *pndis_bss, bss_desc_tt *pbss )
-{
-    PNDIS_802_11_CONFIGURATION  pconfig;
-	u32 channel_freq = 0;
-
-	//TODO:
-    /* Length */
-    //pndis_bss->Length = (sizeof(NDIS_WLAN_BSSID_EX) -4 + pbss->ies_len + 3)  & ~0x03;
-	// 20061108 WPS
-	pndis_bss->Length = (sizeof(NDIS_WLAN_BSSID_EX) -4 + pbss->ies_len + pbss->WPS_IE_length + 3)  & ~0x03;
-
-    /* MacAddress */
-    NdisMoveMemory(pndis_bss->MacAddress, pbss->abBssID, 6);
-
-    /* Ssid */
-    pndis_bss->Ssid.SsidLength = pbss->SSID.Length;
-    NdisMoveMemory(pndis_bss->Ssid.Ssid, pbss->SSID.SSID, pbss->SSID.Length);
-
-    /* Privacy */
-    pndis_bss->Privacy = pbss->CapabilityInformation.Capability.CF_Privacy;
-
-    /* RSSI */
-	if( OS_RSSI_TEST_SET( Adapter ) )
-		pndis_bss->Rssi = OS_RSSI_TEST_SET( Adapter );
-	else
-		pndis_bss->Rssi = hal_get_rssi( &Adapter->sHwData, pbss->HalRssi, 1 ); // 20060329 modify for real
-
-    /* NetworkTypeInUse */
-	if (pbss->DS_Parameter_Set.Current_Channel >14)
-		pndis_bss->NetworkTypeInUse = Ndis802_11OFDM5;
-	else
-	{
-		if (pbss->boERP)
-			pndis_bss->NetworkTypeInUse = Ndis802_11OFDM24;
-		else
-			pndis_bss->NetworkTypeInUse = Ndis802_11DS;
-	}
-
-    /* Configuration */
-    pconfig = &(pndis_bss->Configuration);
-    pconfig->Length         = sizeof(NDIS_802_11_CONFIGURATION);
-    pconfig->BeaconPeriod   = pbss->Beacon_Period;
-    pconfig->ATIMWindow     = *((PUSHORT)pbss->IBSS_Parameter_Set.ATIM_Window);//Current ATIMWindow
-	ChannelNumToFreq(pndis_bss->NetworkTypeInUse,
-							pbss->DS_Parameter_Set.Current_Channel,
-							&channel_freq);
-	pconfig->DSConfig = channel_freq * 1000;
-
-    pconfig->FHConfig.Length = sizeof(NDIS_802_11_CONFIGURATION_FH);
-    pconfig->FHConfig.HopPattern    = 0;
-    pconfig->FHConfig.HopSet        = 0;
-    pconfig->FHConfig.DwellTime     = 0;
-
-    /* InfrastructureMode (BSS mode setting) */
-    pndis_bss->InfrastructureMode = pbss->CapabilityInformation.Capability.ESS ? \
-											Ndis802_11Infrastructure : Ndis802_11IBSS;
-    /* SupportRates */
-    NdisMoveMemory(pndis_bss->SupportedRates,
-                   pbss->SupportedRateSet.SupportedRates,
-                   pbss->SupportedRateSet.Length);
-	pndis_bss->SupportedRates[pbss->SupportedRateSet.Length] = 0;
-
-	//TODO:
-    //pndis_bss->IELength = 0;
-    pndis_bss->IELength = pbss->ies_len;
-    NdisMoveMemory(pndis_bss->IEs, pbss->ies, pbss->ies_len);
-
-	// 20061108 Add WPS IE
-	if( pbss->WPS_IE_length )
-	{
-		pndis_bss->IELength += pbss->WPS_IE_length;
-		NdisMoveMemory( (PUCHAR)pndis_bss->IEs + pbss->ies_len, pbss->WPS_IE_Data, pbss->WPS_IE_length );
-	}
-}
-
-NDIS_STATUS Ndis51SetInformation(  PWB32_ADAPTER pcore_data,
-								   NDIS_OID Oid,
-								   void* InformationBuffer,
-								   u32 InformationBufferLength,
-								   PULONG	pBytesNeed)
-{
-	NDIS_STATUS StatusToReturn = NDIS_STATUS_SUCCESS;
-	PWB32_ADAPTER Adapter = pcore_data;
-	PNDIS51_DESIRED_PARAMETER pN51 = &Adapter->DesiredNdis51Parameter;
-
-	#ifdef _PE_OID_DUMP_
-	DbgPrintfOID51(Oid, FALSE);
-	#endif
-
-	*pBytesNeed =0;
-
-
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-		return StatusToReturn;
-
-	switch(Oid)
-	{
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	//case OID_802_11_WEP_STATUS:
-	case OID_802_11_ENCRYPTION_STATUS: // same as OID_802_11_WEP_STATUS
-
-		if(InformationBufferLength >= sizeof(NDIS_802_11_WEP_STATUS))
-		{
-			PNDIS_802_11_ENCRYPTION_STATUS	p = (PNDIS_802_11_ENCRYPTION_STATUS)InformationBuffer;
-			u8 EncryptStatus;
-
-			switch (*p)
-			{
-				case Ndis802_11EncryptionNotSupported:
-					//EncryptStatus = ENCRYPT_NOTSUPPORT;
-					EncryptStatus = ENCRYPT_DISABLE;
-                    psSME->DesiredEncrypt=Cipher_Disabled;//added by ws 04/22/05
-					break;
-				case Ndis802_11EncryptionDisabled:
-					EncryptStatus = ENCRYPT_DISABLE;
-                    psSME->DesiredEncrypt=Cipher_Disabled;
-					break;
-				case Ndis802_11Encryption1Enabled:
-					EncryptStatus = ENCRYPT_WEP;
-                    psSME->DesiredEncrypt=Cipher_Wep;
-					break;
-				case Ndis802_11Encryption1KeyAbsent:
-					EncryptStatus = ENCRYPT_WEP_NOKEY;
-                    psSME->DesiredEncrypt=Cipher_Wep;
-					break;
-				case Ndis802_11Encryption2Enabled:
-					EncryptStatus = ENCRYPT_TKIP;
-                    psSME->DesiredEncrypt=Cipher_Tkip;
-					break;
-				case Ndis802_11Encryption2KeyAbsent:
-					EncryptStatus = ENCRYPT_TKIP_NOKEY;
-                    psSME->DesiredEncrypt=Cipher_Tkip;
-					break;
-				case Ndis802_11Encryption3Enabled:
-					EncryptStatus = ENCRYPT_CCMP;
-                    psSME->DesiredEncrypt=Cipher_Ccmp;
-					break;
-				case Ndis802_11Encryption3KeyAbsent:
-					EncryptStatus = ENCRYPT_CCMP_NOKEY;
-                    psSME->DesiredEncrypt=Cipher_Ccmp;
-					break;
-				default:
-					EncryptStatus = ENCRYPT_DISABLE;
-                    psSME->DesiredEncrypt=Cipher_Disabled;
-					break;
-			}
-			sme_set_encryption_status(pcore_data, EncryptStatus);
-			#ifdef _PE_OID_DUMP_
-			WBDEBUG(("SET Encrypt status = %x\n", EncryptStatus));
-			#endif
-		}
-		else
-			StatusToReturn = NDIS_STATUS_NOT_ACCEPTED;
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_FRAGMENTATION_THRESHOLD:
-
-		if(InformationBufferLength >= sizeof(NDIS_802_11_FRAGMENTATION_THRESHOLD))
-		{
-			NDIS_802_11_FRAGMENTATION_THRESHOLD	TxFragThres;
-
-			TxFragThres = *((NDIS_802_11_FRAGMENTATION_THRESHOLD *)InformationBuffer);
-
-			if(sme_set_fragment_threshold(pcore_data, TxFragThres) == -1)
-				StatusToReturn = NDIS_STATUS_INVALID_DATA;
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_FRAGMENTATION_THRESHOLD);
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_RTS_THRESHOLD:
-
-		if(InformationBufferLength >= sizeof(NDIS_802_11_RTS_THRESHOLD))
-		{
-			NDIS_802_11_RTS_THRESHOLD RtsThres;
-
-			RtsThres = *((NDIS_802_11_RTS_THRESHOLD *)InformationBuffer);
-
-			if(sme_set_rts_threshold(pcore_data, RtsThres) == -1)
-				StatusToReturn = NDIS_STATUS_INVALID_DATA;
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_RTS_THRESHOLD);
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_ADD_WEP:
-
-		if(InformationBufferLength >= sizeof(NDIS_802_11_WEP))
-		{
-			PNDIS_802_11_WEP pWEPdata = (PNDIS_802_11_WEP)InformationBuffer;
-			u8 bssid[MAC_ADDR_LENGTH];
-
-			//WBDEBUG(("addr of bssid = %x\n", bssid));
-			sme_get_bssid(pcore_data, bssid);
-			if(sme_set_add_wep(pcore_data,
-								 pWEPdata->KeyIndex,
-								 pWEPdata->KeyLength,
-								 bssid, //address
-								 pWEPdata->KeyMaterial)==-1)
-				StatusToReturn = NDIS_STATUS_INVALID_DATA;
-			sme_set_encryption_status(pcore_data, ENCRYPT_WEP);
-
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_WEP);
-
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_REMOVE_WEP:
-
-			if(InformationBufferLength >= sizeof(NDIS_802_11_KEY_INDEX))
-			{
-				NDIS_802_11_KEY_INDEX KeyIndex;
-
-				KeyIndex = *((NDIS_802_11_KEY_INDEX *)InformationBuffer);
-				#ifdef _PE_OID_DUMP_
-				WBDEBUG(("OID_ Removing Key[%x]\n", KeyIndex));
-				#endif
-
-				if (sme_set_remove_wep(pcore_data, KeyIndex) == -1)
-				{
-					#ifdef _PE_OID_DUMP_
-					WBDEBUG(("OID_802_11_REMOVE_WEP fail!\n"));
-					#endif
-					StatusToReturn = NDIS_STATUS_INVALID_DATA;
-				}
-			}
-			else
-				*pBytesNeed = sizeof(NDIS_802_11_KEY_INDEX);
-
-			break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_INFRASTRUCTURE_MODE:
-
-		if(InformationBufferLength >= sizeof(NDIS_802_11_NETWORK_INFRASTRUCTURE))
-		{
-			NDIS_802_11_NETWORK_INFRASTRUCTURE BSSmode;
-			u8 BssType;
-
-			//[20060824] Added to avoid the reissue of this OID even in the CONNECT state
-			sme_set_disassociate(Adapter);
-
-			BSSmode = *((NDIS_802_11_NETWORK_INFRASTRUCTURE *)InformationBuffer);
-			BssType = (BSSmode == Ndis802_11IBSS) ? IBSS_NET : ESS_NET;
-			sme_set_desired_bss_type(pcore_data, BssType);
-			#ifdef _PE_OID_DUMP_
-			WBDEBUG(("OID: set infrastructure mode=%x\n", BssType));
-			#endif
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_NETWORK_INFRASTRUCTURE);
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_CONFIGURATION:
-
-		if(InformationBufferLength >= sizeof(NDIS_802_11_CONFIGURATION))
-		{
-			PNDIS_802_11_CONFIGURATION	pConfig = (PNDIS_802_11_CONFIGURATION)InformationBuffer;
-			u32	ChanFreq;
-			ChanInfo chan;
-
-			sme_set_beacon_period(pcore_data, (u16)pConfig->BeaconPeriod);
-			sme_set_atim_window(pcore_data, (u16)pConfig->ATIMWindow);
-			ChanFreq = pConfig->DSConfig/1000;	//convert to MHz
-			if (ChanFreq >= 3000)
-				chan.band = BAND_TYPE_OFDM_5;
-			else
-				chan.band = BAND_TYPE_OFDM_24;
-			FreqToChannelNum(chan.band,
-								&chan.ChanNo,
-								ChanFreq);
-			sme_set_IBSS_chan(pcore_data, chan);
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_CONFIGURATION);
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_AUTHENTICATION_MODE:
-		if(InformationBufferLength >= sizeof(NDIS_802_11_AUTHENTICATION_MODE))
-		{
-			NDIS_802_11_AUTHENTICATION_MODE NdisAuthMode = *((PNDIS_802_11_AUTHENTICATION_MODE)InformationBuffer);
-			u8 auth_mode;
-
-			switch(NdisAuthMode)
-			{
-				case Ndis802_11AuthModeOpen:
-					auth_mode = OPEN_AUTH;
-					break;
-				case Ndis802_11AuthModeShared:
-					auth_mode = SHARE_AUTH;
-					break;
-				case Ndis802_11AuthModeAutoSwitch:
-					auth_mode = ANY_AUTH;
-					break;
-				case Ndis802_11AuthModeWPA:
-					auth_mode = WPA_AUTH;
-					break;
-				case Ndis802_11AuthModeWPAPSK:
-					auth_mode = WPAPSK_AUTH;
-					break;
-				case Ndis802_11AuthModeWPANone:
-					auth_mode = WPANONE_AUTH;
-					break;
-				#ifdef _WPA2_
-				case Ndis802_11AuthModeWPA2:
-					auth_mode = WPA2_AUTH;
-					break;
-				case Ndis802_11AuthModeWPA2PSK:
-					auth_mode = WPA2PSK_AUTH;
-                    break;
-				#endif //end def _WPA2_
-				default:
-					StatusToReturn = NDIS_STATUS_INVALID_DATA;
-					break;
-			}
-			if (StatusToReturn != NDIS_STATUS_INVALID_DATA)
-			{
-				sme_set_auth_mode(pcore_data, auth_mode);
-				#ifdef _PE_OID_DUMP_
-				WBDEBUG(("SET Auth mode = %x\n", auth_mode));
-				#endif
-			}
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_AUTHENTICATION_MODE);
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	//Real-time service with pending return if needed
-	case OID_802_11_BSSID:
-		if( InformationBufferLength >= 6 )
-		{
-			sme_set_desired_bssid(pcore_data, InformationBuffer);
-		}
-		else
-			*pBytesNeed = 6;
-
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_SSID:
-
-		if( InformationBufferLength >= sizeof(NDIS_802_11_SSID) )
-		{
-			PNDIS_802_11_SSID pSSID = (PNDIS_802_11_SSID)InformationBuffer;
-
-			#ifdef _PE_OID_DUMP_
-			u8 ssid[50];
-			memcpy( ssid, (u8 *)pSSID->Ssid, (u8)pSSID->SsidLength );
-			ssid[pSSID->SsidLength] = '\0';
-			WBDEBUG(("SET ssid=%s\n", ssid));
-			#endif
-			if (pSSID->SsidLength > 32)
-			{
-				StatusToReturn = NDIS_STATUS_INVALID_DATA;
-			}
-			else
-			{
-				PUCHAR	pctmp;
-				int	i, AcceptSsid;
-				u8 boMsRadioOff;
-
-				//Radio on : 0, Radio off : 1
-				// ** 20060828 [Anson] DDK2600 and DDK5048 are Different description **
-				sme_get_ms_radio_mode(Adapter, &boMsRadioOff);
-				if (boMsRadioOff == 1)
-					sme_set_ms_radio_mode(Adapter, 0); //Radio On
-				psSME->boDUTmode = FALSE;
-				memcpy( pN51->CurrentSSID, (u8 *)pSSID->Ssid, (u8)pSSID->SsidLength );
-				pN51->CurrentSSIDLength = pSSID->SsidLength;
-				sme_set_desired_ssid(pcore_data, (u8 *)pSSID->Ssid, (u8)pSSID->SsidLength);
-
-				pctmp = (u8 *)pSSID->Ssid;
-				AcceptSsid = 1;
-				for( i=0; i<(int)pSSID->SsidLength; i++ )
-				{
-					if( (pctmp[i]>126) || (pctmp[i]<32 ) )
-					{
-						AcceptSsid = 0;
-						break;
-					}
-				}
-				if( AcceptSsid )
-				{
-					pN51->ConnectInterval = 8;
-					pN51->ConnectCount = 1;
-				}
-				else
-					pN51->ConnectCount = 0;
-			}
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_SSID);
-
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_DISASSOCIATE:
-		sme_set_disassociate(pcore_data);
-		//Radio on : 0, Radio off : 1
-		sme_set_ms_radio_mode(Adapter, 1);
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_BSSID_LIST_SCAN:
-
-		pcore_data->DesiredNdis51Parameter.sync_scan_require = 1;
-		NdisMSetTimer( &pcore_data->DesiredNdis51Parameter.scan_sync_timer, 0 );
-		break;
-
-	case OID_802_11_RELOAD_DEFAULTS:
-
-		if(InformationBufferLength >= sizeof(NDIS_802_11_RELOAD_DEFAULTS))
-		{
-			PNDIS_802_11_RELOAD_DEFAULTS pReloadDefaultType = (PNDIS_802_11_RELOAD_DEFAULTS)InformationBuffer;
-
-			if (*pReloadDefaultType == Ndis802_11ReloadWEPKeys)
-			{
-				sme_set_reload_defaults(Adapter, ENCRYPT_WEP);
-			}
-			else
-				StatusToReturn = NDIS_STATUS_INVALID_DATA;
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_RELOAD_DEFAULTS);
-		break;
-
-   	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_ADD_KEY:
-
-        	if (InformationBufferLength >= 37) // 37 for WEP40
-    		{
-            	NDIS_802_11_KEY *p = (NDIS_802_11_KEY *)InformationBuffer;
-	            u8              *ptx_tsc = NULL;
-    	        u8              *prx_tsc = NULL;
-            	u8              key_type;
-				u8				key_len;
-				//u8				EncryptStatus;
-
-            	#ifdef _PE_OID_DUMP_
-            	WBDEBUG(("[DRV] ** Length   = %d\n", p->Length));
-            	WBDEBUG(("[DRV] ** KeyIndex = 0x%08X\n", p->KeyIndex));
-            	WBDEBUG(("[DRV] ** KeyLength = %d\n", p->KeyLength));
-            	WBDEBUG(("[DRV] ** BSSID = " MACSTR "\n", MAC2STR(p->BSSID)));
-            	WBDEBUG(("[DRV] ** KeyRSC (hi) = %d\n", p->KeyRSC >> 32));
-            	WBDEBUG(("[DRV] ** KeyRSC (lo) = %d\n", p->KeyRSC));
-            	DataDmp(p->KeyMaterial, p->KeyLength, 0);
-            	#endif
-
-	            if (p->KeyIndex == 0xC0000001)
-    	        {
-					#ifdef _PE_OID_DUMP_
-        	        WBDEBUG(("** NDIS_STATUS_INVALID_DATA\n"));
-					#endif
-            	    StatusToReturn = NDIS_STATUS_INVALID_DATA;
-            	}
-	            else
-    	        {	//TODO: ??Should it set encryption status for the some XP OID sequence??
-					switch (p->KeyLength)
-					{
-						case 5:
-							//WBDEBUG(("Key Type = WEP40\n"));
-							key_type = HAL_KEYTYPE_WEP40;
-							key_len = 5;
-							//sme_set_encryption_status(Adapter, ENCRYPT_WEP);
-							break;
-						case 13:
-							//WBDEBUG(("Key Type = WEP104\n"));
-							key_type = HAL_KEYTYPE_WEP104;
-							key_len = 13;
-							//sme_set_encryption_status(Adapter, ENCRYPT_WEP);
-							break;
-						case 16:
-							//WBDEBUG(("Key Type = CCMP\n"));
-							key_type = HAL_KEYTYPE_AES_CCMP;
-							key_len = 16;
-							//sme_set_encryption_status(Adapter, ENCRYPT_CCMP);
-							break;
-						case 32:
-							//WBDEBUG(("Key Type = TKIP\n"));
-							key_type = HAL_KEYTYPE_TKIP;
-							key_len = 16;
-							//sme_set_encryption_status(Adapter, ENCRYPT_TKIP);
-							break;
-						default:
-							//WBDEBUG(("Key Type = UNKNOWN\n"));
-							return NDIS_STATUS_INVALID_DATA;
-					}
-
-					if (p->KeyIndex & BIT(29))
-					{
-						// the KeyRSC should be used to set the initial receive
-						// SC for the key when BIT 29 is set to 1.
-
-						// If the encryption cipher needs less bytes than supplied
-						// by KeyRSC, the least significant bytes should be used.
-						prx_tsc = (u8*) &p->KeyRSC;
-					}
-
-					if (sme_add_key(Adapter,
-								p->KeyIndex,
-								key_len,
-								key_type,
-								p->BSSID,
-								ptx_tsc,
-								prx_tsc,
-								//p->KeyRSC,
-								p->KeyMaterial) == -1)
-						return NDIS_STATUS_INVALID_DATA;
-            	}
-	        }
-    	    else
-        	{
-            	*pBytesNeed = sizeof(NDIS_802_11_KEY);
-
-	            #ifdef _PE_OID_DUMP_
-    	        WBDEBUG(("[DRV] ** buffer size (%d) < %d\n", InformationBufferLength, sizeof(NDIS_802_11_KEY)));
-        	    DataDmp(InformationBuffer, InformationBufferLength, 0);
-            	#endif
-	        }
-		    break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_REMOVE_KEY:
-		//WBDEBUG(("[DRV] OID_802_11_REMOVE_KEY (SET)\n"));
-
-		//size = sizeof(NDIS_802_11_REMOVE_KEY);
-
-		if (InformationBufferLength >= sizeof(NDIS_802_11_REMOVE_KEY))
-		{
-			NDIS_802_11_REMOVE_KEY *p = (NDIS_802_11_REMOVE_KEY *)InformationBuffer;
-
-			#ifdef _PE_OID_DUMP_
-			WBDEBUG(("[DRV] ** Length   = %d\n", p->Length));
-			WBDEBUG(("[DRV] ** KeyIndex = %d\n", p->KeyIndex));
-			WBDEBUG(("[DRV] ** BSSID = " MACSTR "\n", MAC2STR(p->BSSID)));
-			#endif
-			if ((p->KeyIndex & (~BIT(30))) > 0xff)
-			{
-				StatusToReturn = NDIS_STATUS_INVALID_DATA;
-				break;
-			}
-			if (BIT(30) == (p->KeyIndex & BIT(30)))
-			{
-                //if(IS_BROADCAST_BSSID(p->BSSID))
-				if( boCmpMacAddr( p->BSSID, "\xff\xff\xff\xff\xff\xff" ) )
-                {
-                    sme_clear_all_mapping_key(pcore_data);
-                }
-                else
-                {
-                    sme_remove_mapping_key(pcore_data, p->BSSID);
-                }
-			}
-			else if (p->KeyIndex < 4)
-			{
-                sme_remove_default_key(pcore_data, p->KeyIndex & 0xff);
-			}
-			else
-			{
-				StatusToReturn = NDIS_STATUS_INVALID_DATA;
-                break;
-			}
-        }
-        else
-        {
-            *pBytesNeed = sizeof(NDIS_802_11_REMOVE_KEY);
-        }
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_ASSOCIATION_INFORMATION:
-	    //WBDEBUG(("[DRV] OID_802_11_ASSOCIATION_INFORMATION (SET)\n"));
-	    break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_TEST:
-        //WBDEBUG(("[DRV] OID_802_11_TEST (SET)\n"));
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_TX_POWER_LEVEL:
-        //WBDEBUG(("[DRV] OID_802_11_TX_POWER_LEVEL (SET)\n"));
-		if( InformationBufferLength >= sizeof(u32) )
-		{
-			NDIS_802_11_TX_POWER_LEVEL TxPower= *(NDIS_802_11_TX_POWER_LEVEL *)InformationBuffer;
-
-			sme_set_tx_power_level(Adapter, TxPower);
-		}
-		else
-			*pBytesNeed = sizeof(u32);
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_RX_ANTENNA_SELECTED:
-        //WBDEBUG(("[DRV] OID_802_11_RX_ANTENNA_SELECTED (SET)\n"));
-		if( InformationBufferLength >= sizeof(u32) )
-		{
-			u32 RxAntenna = *(u32 *)InformationBuffer;
-
-			sme_set_rx_antenna(Adapter, RxAntenna);
-		}
-		else
-			*pBytesNeed = sizeof(u32);
-        break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_TX_ANTENNA_SELECTED:
-        //WBDEBUG(("[DRV] OID_802_11_TX_ANTENNA_SELECTED (SET)\n"));
-		if( InformationBufferLength >= sizeof(u32) )
-		{
-			u32 TxAntenna = *(u32 *)InformationBuffer;
-
-			sme_set_tx_antenna(Adapter, TxAntenna);
-		}
-		else
-			*pBytesNeed = sizeof(u32);
-        break;
-
-	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-	case OID_802_11_DESIRED_RATES://added by ws 08/04/04 
-		//TODO : [1004]
-		//WBDEBUG(("[WS]OID_802_11Desired_rate,the informationBuffer=%x\n",*((NDIS_802_11_RATES *)InformationBuffer)));
-		//bytes_needed=sizeof(NDIS_802_11_RATES)*8;
-		if(InformationBufferLength >= sizeof(NDIS_802_11_RATES))
-		{
-			u8 *p=(u8 *)InformationBuffer;
-			int i;
-
-			for (i=0; i<8; ++i)
-				if (p[i] == 0)
-					break;
-			// Use auto tx rate if no rate assigned.
-			if (i==1 || i==0)
-			{
-				//WWU defines "AUTO" as 0(DTO on).
-				psLOCAL->TxRateMode = *(u8 *)InformationBuffer;
-				if (psLOCAL->TxRateMode != RATE_AUTO)
-				{
-					if (psLOCAL->TxRateMode == RATE_MAX)
-					{
-						if (psLOCAL->wConnectedSTAindex != 0)
-						{
-							SetMaxTxRate(Adapter);
-						}
-						else
-						{
-							psLOCAL->CurrentTxRate = psLOCAL->CurrentTxRateForMng;
-							psLOCAL->CurrentTxFallbackRate = psLOCAL->CurrentTxRate;
-						}
-					}
-					else
-					{
-						psLOCAL->CurrentTxRate = psLOCAL->TxRateMode;
-						psLOCAL->CurrentTxFallbackRate = psLOCAL->CurrentTxRate;
-					}
-				}
-			}
-		}
-		break;
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	#ifdef _WPA2_
-	case OID_802_11_PMKID://added by ws
-		{
-			PNDIS_802_11_PMKID p=(PNDIS_802_11_PMKID) InformationBuffer;
-            PMKID_Table *PmkIdTable=(PMKID_Table*)pcore_data->sSmePara.PmkIdTable;
-            u8 i,j;
-            unsigned char bExistPmkid=FALSE;
-            
-			for(j=0;j<p->BSSIDInfoCount;j++)
-			{
-				for(i=0;i<PmkIdTable->BSSIDInfoCount;i++)
-				{
-					//if PMKID is existing in the PMKID table, it will be stored into the same space.
-					if( boCmpMacAddr( PmkIdTable->BSSIDInfo[i].PreAuthBssID, (p->BSSIDInfo + j*sizeof(BSSID_INFO))->BSSID ) )
-					{
-						memcpy( &PmkIdTable->BSSIDInfo[i],
-										&p->BSSIDInfo+j*sizeof(BSSID_INFO), sizeof(BSSID_INFO) );
-						bExistPmkid=TRUE;
-						break;
-					}
-				}
-				//if PMKID is not existing in PMKID table,the PMKID is stored into the available space
-				if( !bExistPmkid )
-				{
-					memcpy( &PmkIdTable->BSSIDInfo[psSME->PmkidTableIndex],
-									&p->BSSIDInfo+j*sizeof(BSSID_INFO), sizeof(BSSID_INFO) );
-					PmkIdTable->Length +=sizeof(BSSID_INFO);
-					PmkIdTable->BSSIDInfoCount++;
-					if( psSME->PmkidTableIndex > 16 )
-						psSME->PmkidTableIndex=0;
-					else
-						psSME->PmkidTableIndex++;
-					bExistPmkid=FALSE;
-				}
-			}
-		}
-		break;
-	#endif // end def _WPA2_
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_NETWORK_TYPE_IN_USE:
-		if(InformationBufferLength >= sizeof(NDIS_802_11_NETWORK_TYPE))
-		{
-			NDIS_802_11_NETWORK_TYPE	NetworkType;
-			u8							OpMode;
-
-			NetworkType = *((NDIS_802_11_NETWORK_TYPE *)InformationBuffer);
-			//Check whether the data is correct
-			if (NetworkType < Ndis802_11NetworkTypeMax)
-			{
-				switch (NetworkType)
-				{
-					case Ndis802_11DS:
-						OpMode = MODE_802_11_B;
-						break;
-					case Ndis802_11OFDM24:
-						OpMode = MODE_802_11_BG;
-						break;
-					case Ndis802_11OFDM5:
-						OpMode = MODE_802_11_A;
-						break;
-					default:
-						OpMode = MODE_802_11_BG;
-						break;
-				}
-				sme_set_network_type_in_use(Adapter, OpMode);
-			}
-			else
-                StatusToReturn = NDIS_STATUS_INVALID_DATA;
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_NETWORK_TYPE);
-        break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_POWER_MODE:
-		if(InformationBufferLength >= sizeof(NDIS_802_11_POWER_MODE))
-		{
-			NDIS_802_11_POWER_MODE	pPmValue;
-			u8	PowerMode;
-
-			pPmValue = *((NDIS_802_11_POWER_MODE *)InformationBuffer);
-			PowerMode = (u8)pPmValue;
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("[Set POWER MODE OID] PowerMode = %d\n", PowerMode));
-			#endif
-			sme_set_power_mode(Adapter, PowerMode);
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_POWER_MODE);
-        break;
-
-	#if 0
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_MEDIA_STREAM_MODE:
-		if(InformationBufferLength >= sizeof(NDIS_802_11_MEDIA_STREAM_MODE))
-		{
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("[Set OID_802_11_MEDIA_STREAM_MODE] = %d\n", *(NDIS_802_11_MEDIA_STREAM_MODE *)InformationBuffer));
-			#endif
-			StatusToReturn = NDIS_STATUS_SUCCESS;
-		}
-		else
-			*pBytesNeed = sizeof(NDIS_802_11_MEDIA_STREAM_MODE);
-        break;
-	#endif
-
-	//---------------------------------------------------------------------------------------------
-	//added by ws 08/23/04
-	case OID_802_11_CUST_PREAMBLE_TYPE:
-    
-        { 
-           //TODO: [1004]
-           //WBDEBUG(("[ws]OID_802_11_CUST_PREAMBLE_TYPE\n"));
-           if(InformationBufferLength >=sizeof(u32))
-             {
-                u32 *p=(u32*)InformationBuffer;
-                if(*p&0x1)
-                   psLOCAL->boShortPreamble = 0;    //long preamble
-                else 
-                   psLOCAL->boShortPreamble = 1; //short preamble                    
-                
-              }   
-         }
-          break;   
-	//---------------------------------------------------------------------------------------------
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-  	case OID_802_11_CUST_IE_APPEND: // 20061108 WPS
-		if( sme_set_IE_append( pcore_data, (PUCHAR)InformationBuffer, (u16)InformationBufferLength) )
-			StatusToReturn = NDIS_STATUS_FAILURE;
-		break;
-
-	case OID_802_11_CUST_LED_CONTROL: // 20061108 WPS LED control
-			hal_set_LED( &Adapter->sHwData, *(PULONG)InformationBuffer );
-			break;
-
-	case OID_802_11_CUST_RADIO:
-
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("[Set RADIO OID]\n"));
-		#endif
-
-		if(InformationBufferLength >= sizeof(WLAN_RADIO_STATUS))
-		{
-			WLAN_RADIO_STATUS *p = (WLAN_RADIO_STATUS *)InformationBuffer;
-			RadioOff DesiredRadioOffData, CurrentRadioOffData;;
-
-			//Radio on : 0, Radio off : 1
-			DesiredRadioOffData.boSwRadioOff = p->SWStatus;
-			DesiredRadioOffData.boHwRadioOff = p->HWStatus;
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Set CUST RADIO h/w Radio off = %x, s/w Radio off =%x\n",
-									psLOCAL->RadioOffStatus.boHwRadioOff,
-									psLOCAL->RadioOffStatus.boSwRadioOff));
-			#endif
-			sme_get_radio_mode(Adapter, &CurrentRadioOffData);
-			CheckRadioOffForDisassoc( Adapter, DesiredRadioOffData, CurrentRadioOffData );
-			sme_set_radio_mode(Adapter, DesiredRadioOffData);
-		}
-		else
-			*pBytesNeed = sizeof(WLAN_RADIO_STATUS);
-
-		break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_CUST_REGION:
-		if( InformationBufferLength >= sizeof(u32) )
-		{
-            u32   *p;
-
-            p = (u32 *) InformationBuffer;
-			psLOCAL->region = (u8)*p;
-			//Region has been changed. Reconnect it!!
-			GetSupportChanRange(Adapter);
-			GetIbssChan(Adapter);
-			Scan_SetScanChanRange(Adapter, psSCANREQ);
-			sme_set_disassociate(Adapter);
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("[Set REGION OID] psLOCAL->region = %d\n", psLOCAL->region));
-			#endif
-		}
-		else
-			*pBytesNeed = sizeof(u32);
-        break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	case OID_802_11_CUST_RADIO_NOTIFICATION:
-
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("[Set RADIO NOTIFICATION OID]\n"));
-		#endif
-
-		if(InformationBufferLength >= sizeof(WLAN_RADIO_NOTIFICATION))
-		{
-			WLAN_RADIO_NOTIFICATION *p = (WLAN_RADIO_NOTIFICATION *)InformationBuffer;
-
-			// send a radio notification directly
-			if (p->RadioChangeHandler != 0 && p->Data != 0)
-			{
-				WLAN_RADIO_STATUS Status;
-				RadioOff		RadioOffData;
-
-				//Radio on : 0, Radio off : 1
-				sme_get_radio_mode(pcore_data, &RadioOffData);
-				Status.HWStatus = RadioOffData.boHwRadioOff;	//first cut is always on
-				Status.SWStatus = RadioOffData.boSwRadioOff;
-				(*p->RadioChangeHandler)(p->Data, &Status, sizeof(Status));
-			}
-
-		}
-		else
-			*pBytesNeed = sizeof(WLAN_RADIO_NOTIFICATION);
-		break;
-
-    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-    case OID_802_11_CUST_IBSS_FREQUENCY:
-
-		if( InformationBufferLength >= sizeof(u32) )
-		{
-            u32   frequency;
-			ChanInfo chan;
-
-            frequency = *(u32 *) InformationBuffer;
-			if (frequency > 3000)
-				chan.band = BAND_TYPE_OFDM_5;
-			else
-				chan.band = BAND_TYPE_OFDM_24;
-			FreqToChannelNum(chan.band, &chan.ChanNo, frequency);
-			sme_set_IBSS_chan(Adapter, chan);
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("[Set IBSS_FREQUENCY OID] frequency = %d\n", frequency));
-			#endif
-		}
-		else
-			*pBytesNeed = sizeof(u32);
-		break;
-
-	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-	default:
-			StatusToReturn = WB_NDIS_STATUS_NOT_SUPPORTED;
-	}
-
-	return StatusToReturn;
-}
-//=============================== NDIS 5.1 OID Set stop ===================================
-//Convert band(definition of driver) to network type(definition of NDIS)
-void NetworkTypeConvert(PNDIS_802_11_NETWORK_TYPE pNetworkType, u8 band)
-{
-	switch (band)
-	{
-		case BAND_TYPE_DSSS:
-			*pNetworkType = Ndis802_11DS;
-			break;
-		case BAND_TYPE_OFDM_24:
-			*pNetworkType = Ndis802_11OFDM24;
-			break;
-		case BAND_TYPE_OFDM_5:
-			*pNetworkType = Ndis802_11OFDM5;
-			break;
-		default:
-			*pNetworkType = Ndis802_11DS;
-			break;
-	}
-}
-
-// channel number -> channel freq.
-void ChannelNumToFreq(u8 NetworkType, u8 ChannelNumber, u32 *freq)
-{
-	//freg : MHz
-	switch ( NetworkType)
-	{
-		case Ndis802_11DS:
-		case Ndis802_11OFDM24:
-			if (ChannelNumber <=13)
-				*freq = 2407 + ChannelNumber*5;
-		else
-				*freq = 2484;
-			break;
-		case Ndis802_11OFDM5:
-			if (ChannelNumber <= 161)
-				*freq = 5000 + ChannelNumber*5;
-		else
-			*freq = 4000 + ChannelNumber*5;
-			break;
-		default:
-			break;
-	}
-}
-
-// channel freq. -> channel number
-void FreqToChannelNum(u8 Band, u8 *ChannelNumber, u32 freq)
-{
-	//freg : MHz
-	switch ( Band )
-	{
-		case BAND_TYPE_DSSS:
-		case BAND_TYPE_OFDM_24:
-			if (freq < 2484)
-				*ChannelNumber = (u8)((freq-2407)/5);
-			else
-				*ChannelNumber = 14;
-			break;
-		case BAND_TYPE_OFDM_5:
-			if (freq < 4920)
-				*ChannelNumber = (u8)((freq-5000)/5);
-			else
-				*ChannelNumber = (u8)((freq-4000)/5);
-			break;
-		default:
-			break;
-	}
-}
-
-//Suppose ChNo will not be larger than 1000
-u16 ChanNo2String(u8 ChNo, u8 * Str)
-{
-	u8 tmp1, tmp2, flag=0, i=0;
-
-	tmp1 = ChNo/100;
-	tmp2 = ChNo%100;
-	if (tmp1 != 0)
-	{
-		Str[i++]= 0x30 + tmp1;
-		flag = 1;
-	}
-
-	tmp1 = tmp2/10;
-	tmp2 = tmp2%10;
-	if (tmp1 != 0)
-	{
-		Str[i++]= 0x30 + tmp1;
-		flag = 1;
-	}
-	else if (flag == 1)
-		Str[i++] = 0x30;
-
-	if (tmp2 != 0)
-		Str[i++] = 0x30 + tmp2;
-	else
-		Str[i++] = 0x30;
-	Str[i++] = ',';
-	return (i);
-}
-
-
-//-------------------------------------------------------------------------------
-u32 USA_channel[] = 
-{
-	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, // 2.4G
-	5180, 5200, 5220, 5240, 5260, 5280, 5300, 5320, 5745, 5765, 5785, 5805, // 5G
-	0
-};
-
-u32 Europe_channel[] = 
-{
-	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, // 2.4G
-	5180, 5200, 5220, 5240, 5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, // 5G
-	5600, 5620, 5640, 5660, 5680, 5700,
-	0
-};
-
-u32 Spain_channel[] =
-{
-	2457, 2462, // 2.4G
-	0
-};
-
-u32 France_channel[] =
-{
-	2457, 2462, 2467, 2472, // 2.4G
-	0
-};
-
-u32 Japan_channel[] =
-{ 
-	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484, // 2.4G
-	5040, 5060, 5080, 5170, 5190, 5210, 5230, 4920, 4940, 4960, 4980, // 5G
-	0
-};
-
-u32 Israel_channel[] = 
-{
-	2422, 2427, 2432, 2437, 2442, 2447, 2457, // 2.4G
-	0
-};
-//The above frequency list are not used actually. [20050929]
-
-
-static region_name_map regions[] = 
-{
-	{ WLAN_REGION_EUROPE, "Channel 1-13,",	Europe_channel },
-	{ WLAN_REGION_JAPAN,  "Channel 1-14,",	Japan_channel },
-	{ WLAN_REGION_USA,    "Channel 1-11,",	USA_channel },
-	{ WLAN_REGION_FRANCE, "Channel 10-13,",	France_channel },
-	{ WLAN_REGION_SPAIN,  "Channel 10-11,",	Spain_channel },
-	{ WLAN_REGION_ISRAEL, "Channel 3-9,",	Israel_channel },
-	//{ WLAN_REGION_CANADA, "Canada-IC",	USA_channel },
-	{ WLAN_REGION_MAX,    0,        0 } // defined as a sentry
-};
-
-u8* get_name_of_region(WLAN_REGION_CODE region)
-{
-	region_name_map *p = regions;
-	
-	while (p->region != WLAN_REGION_MAX)
-	{
-		if (p->region == region)
-			return p->name;
-		++p;
-	}
-
-	//ASSERT(!"Unrecognized region code");
-	return 0;
-}
-
-/*
-u32* get_channels_of_region(WLAN_REGION_CODE region)
-{
-	region_name_map *p = regions;
-	
-	while (p->region != WLAN_REGION_MAX)
-	{
-		if (p->region == region)
-			return p->channels;
-		++p;
-	}
-
-	//ASSERT(!"Unrecognized region code!");
-	return 0;
-}
-*/
-//=====================================================================
-void DbgPrintfOID51(NDIS_OID Oid, unsigned char IsQuery)
-{
-	#ifdef _PE_OID_DUMP_
-	if(IsQuery)
-		WBDEBUG((" QUERY:"));
-	else
-		WBDEBUG((" SET:"));
-
-	//=======================
-    // Print information 
-    //=======================
-    switch (Oid) {
-
-		case OID_GEN_SUPPORTED_LIST:		WBDEBUG(("OID_GEN_SUPPORTED_LIST"));			break;
-		case OID_GEN_HARDWARE_STATUS:		WBDEBUG(("OID_GEN_HARDWARE_STATUS"));			break;
-		case OID_GEN_MEDIA_SUPPORTED:		WBDEBUG(("OID_GEN_MEDIA_SUPPORTED"));			break;
-		case OID_GEN_MEDIA_IN_USE:			WBDEBUG(("OID_GEN_MEDIA_IN_USE"));			break;
-		case OID_GEN_MAXIMUM_LOOKAHEAD:		WBDEBUG(("OID_GEN_MAXIMUM_LOOKAHEAD"));		break;
-		case OID_GEN_MAXIMUM_FRAME_SIZE:	WBDEBUG(("OID_GEN_MAXIMUM_FRAME_SIZE"));		break;
-		case OID_GEN_MAXIMUM_TOTAL_SIZE:	WBDEBUG(("OID_GEN_MAXIMUM_TOTAL_SIZE"));		break;
-		case OID_GEN_MAC_OPTIONS:			WBDEBUG(("OID_GEN_MAC_OPTIONS"));				break;
-		case OID_GEN_MEDIA_CONNECT_STATUS:	WBDEBUG(("OID_GEN_MEDIA_CONNECT_STATUS"));	break;
-		case OID_GEN_MAXIMUM_SEND_PACKETS:	WBDEBUG(("OID_GEN_MAXIMUM_SEND_PACKETS"));	break;
-		case OID_GEN_VENDOR_DRIVER_VERSION:	WBDEBUG(("OID_GEN_VENDOR_DRIVER_VERSION"));	break;
-		case OID_GEN_PROTOCOL_OPTIONS:		WBDEBUG(("OID_GEN_PROTOCOL_OPTIONS"));		break;
-		//case OID_GEN_LINK_SPEED:			WBDEBUG(("OID_GEN_LINK_SPEED"));				break;
-		case OID_GEN_TRANSMIT_BUFFER_SPACE:	WBDEBUG(("OID_GEN_TRANSMIT_BUFFER_SPACE"));	break;
-		case OID_GEN_RECEIVE_BUFFER_SPACE:	WBDEBUG(("OID_GEN_RECEIVE_BUFFER_SPACE"));	break;
-		case OID_GEN_TRANSMIT_BLOCK_SIZE:	WBDEBUG(("OID_GEN_TRANSMIT_BLOCK_SIZE"));		break;
-		case OID_GEN_RECEIVE_BLOCK_SIZE:	WBDEBUG(("OID_GEN_RECEIVE_BLOCK_SIZE"));		break;
-		case OID_GEN_VENDOR_DESCRIPTION:	WBDEBUG(("OID_GEN_VENDOR_DESCRIPTION"));		break;
-		case OID_GEN_VENDOR_ID:				WBDEBUG(("OID_GEN_VENDOR_ID"));				break;
-		case OID_GEN_DRIVER_VERSION:		WBDEBUG(("OID_GEN_DRIVER_VERSION"));			break;
-		case OID_GEN_CURRENT_PACKET_FILTER:	WBDEBUG(("OID_GEN_CURRENT_PACKET_FILTER"));	break;
-		case OID_GEN_CURRENT_LOOKAHEAD:		WBDEBUG(("OID_GEN_CURRENT_LOOKAHEAD"));		break;
-		//case OID_GEN_XMIT_OK:				WBDEBUG(("OID_GEN_XMIT_OK"));					break;
-		//case OID_GEN_RCV_OK:				WBDEBUG(("OID_GEN_RCV_OK"));					break;
-		//case OID_GEN_XMIT_ERROR:			WBDEBUG(("OID_GEN_XMIT_ERROR"));				break;
-		//case OID_GEN_RCV_ERROR:				WBDEBUG(("OID_GEN_RCV_ERROR"));				break;
-		case OID_GEN_RCV_NO_BUFFER:			WBDEBUG(("OID_GEN_RCV_NO_BUFFER"));			break;
-		case OID_802_3_PERMANENT_ADDRESS:	WBDEBUG(("OID_802_3_PERMANENT_ADDRESS"));		break;
-		case OID_802_3_CURRENT_ADDRESS:		WBDEBUG(("OID_802_3_CURRENT_ADDRESS"));		break;
-		case OID_802_3_MULTICAST_LIST:		WBDEBUG(("OID_802_3_MULTICAST_LIST"));		break;
-		case OID_802_3_MAXIMUM_LIST_SIZE:	WBDEBUG(("OID_802_3_MAXIMUM_LIST_SIZE"));		break;
-		case OID_802_3_XMIT_ONE_COLLISION:	WBDEBUG(("OID_802_3_XMIT_ONE_COLLISION"));	break;
-		case OID_802_3_XMIT_MORE_COLLISIONS:WBDEBUG(("OID_802_3_XMIT_MORE_COLLISIONS"));	break;
-		case OID_PNP_CAPABILITIES:			WBDEBUG(("OID_PNP_CAPABILITIES"));			break;
-		case OID_PNP_ENABLE_WAKE_UP:		WBDEBUG(("OID_PNP_ENABLE_WAKE_UP"));			break;
-		case OID_PNP_QUERY_POWER:			WBDEBUG(("OID_PNP_QUERY_POWER"));				break;
-		case OID_PNP_ADD_WAKE_UP_PATTERN:	WBDEBUG(("OID_PNP_ADD_WAKE_UP_PATTERN"));		break;
-		case OID_PNP_REMOVE_WAKE_UP_PATTERN:WBDEBUG(("OID_PNP_REMOVE_WAKE_UP_PATTERN"));	break;
-		case OID_PNP_SET_POWER:				WBDEBUG(("OID_PNP_SET_POWER"));				break;
-		case OID_GEN_PHYSICAL_MEDIUM:		WBDEBUG(("OID_GEN_PHYSICAL_MEDIUM"));			break;
-		case OID_802_11_BSSID:				WBDEBUG(("OID_802_11_BSSID"));					break;
-		case OID_802_11_SSID:				WBDEBUG(("OID_802_11_SSID"));					break;
-		case OID_802_11_NETWORK_TYPES_SUPPORTED:WBDEBUG(("OID_802_11_NETWORK_TYPES_SUPPORTED"));	break;
-		case OID_802_11_NETWORK_TYPE_IN_USE:WBDEBUG(("OID_802_11_NETWORK_TYPE_IN_USE"));	break;
-		//case OID_802_11_RSSI:				WBDEBUG(("OID_802_11_RSSI"));					break;
-		case OID_802_11_INFRASTRUCTURE_MODE:WBDEBUG(("OID_802_11_INFRASTRUCTURE_MODE"));	break;
-		case OID_802_11_FRAGMENTATION_THRESHOLD:WBDEBUG(("OID_802_11_FRAGMENTATION_THRESHOLD"));	break;
-		case OID_802_11_RTS_THRESHOLD:		WBDEBUG(("OID_802_11_RTS_THRESHOLD"));			break;
-		case OID_802_11_SUPPORTED_RATES:	WBDEBUG(("OID_802_11_SUPPORTED_RATES"));		break;
-		case OID_802_11_CONFIGURATION:		WBDEBUG(("OID_802_11_CONFIGURATION"));			break;
-		case OID_802_11_ADD_WEP:			WBDEBUG(("OID_802_11_ADD_WEP"));				break;
-		case OID_802_11_REMOVE_WEP:			WBDEBUG(("OID_802_11_REMOVE_WEP"));				break;
-		case OID_802_11_DISASSOCIATE:		WBDEBUG(("OID_802_11_DISASSOCIATE"));			break;
-		case OID_802_11_BSSID_LIST:			WBDEBUG(("OID_802_11_BSSID_LIST"));				break;
-		case OID_802_11_AUTHENTICATION_MODE:WBDEBUG(("OID_802_11_AUTHENTICATION_MODE"));	break;
-		case OID_802_11_BSSID_LIST_SCAN:	WBDEBUG(("OID_802_11_BSSID_LIST_SCAN"));		break;
-		//case OID_802_11_WEP_STATUS:			WBDEBUG(("OID_802_11_WEP_STATUS"));				break;
-		case OID_802_11_ENCRYPTION_STATUS:			WBDEBUG(("OID_802_11_ENCRYPTION_STATUS"));				break;
-		case OID_802_11_RELOAD_DEFAULTS:	WBDEBUG(("OID_802_11_RELOAD_DEFAULTS"));		break;
-		case OID_802_11_ADD_KEY:			WBDEBUG(("OID_802_11_ADD_KEY"));				break;
-		case OID_802_11_REMOVE_KEY:			WBDEBUG(("OID_802_11_REMOVE_KEY"));				break;
-		case OID_802_11_ASSOCIATION_INFORMATION:	WBDEBUG(("OID_802_11_ASSOCIATION_INFORMATION"));	break;
-		case OID_802_11_TEST:				WBDEBUG(("OID_802_11_TEST"));					break;
-		default:
-			//WBDEBUG(("UNKNOWN"));
-			break;
-    }
-	#endif
-}
-
-//from pd50(0209)
-void vNetAuthEventInd(PWB32_ADAPTER Adapter, u8 *bssid, u32 flag)
-{
-    struct event_t
-    {
-        NDIS_802_11_STATUS_INDICATION       indication;
-        NDIS_802_11_AUTHENTICATION_REQUEST  request;
-    } event;
-	u8		NdisFlag;
- 
-	if( flag == AUTH_REQUEST_PAIRWISE_ERROR )
-		NdisFlag = NDIS_802_11_AUTH_REQUEST_PAIRWISE_ERROR;
-	else
-		NdisFlag = NDIS_802_11_AUTH_REQUEST_GROUP_ERROR;
-
-	#ifdef _PE_RX_DUMP_
-	WBDEBUG(("!!!!!WPA countermeasure: Auth event\n"));
-	#endif
-    event.indication.StatusType = Ndis802_11StatusType_Authentication;
-    event.request.Length = sizeof(NDIS_802_11_AUTHENTICATION_REQUEST);
-    memcpy( event.request.Bssid, bssid, 6 );
-    event.request.Flags = NdisFlag; 
-    NdisMIndicateStatus(Adapter->WbNdis.MiniportAdapterHandle,
-                        NDIS_STATUS_MEDIA_SPECIFIC_INDICATION,
-                        &event,
-                        sizeof(NDIS_802_11_STATUS_INDICATION) + sizeof(NDIS_802_11_AUTHENTICATION_REQUEST));
-    NdisMIndicateStatusComplete(Adapter->WbNdis.MiniportAdapterHandle);
-}
-
-//TODO : WPA2
-///////////////////////////////////////////////////////////////////////////////////////////////
-//pre authentication request to OS 
-#ifdef _WPA2_
-void vPmkIdStatusEvent(PWB32_ADAPTER Adapter) //added by ws 05/04/04
-{
-    int i,j=0;
-	struct status_event{
-		                 NDIS_802_11_STATUS_INDICATION       indication; 
-				         NDIS_802_11_PMKID_CANDIDATE_LIST      candidatelist;
-	} *p;
-	char temp_status_event[sizeof(NDIS_802_11_STATUS_INDICATION)+sizeof(NDIS_802_11_PMKID_CANDIDATE_LIST)+sizeof(PMKID_CANDIDATE)*MAX_PMKID_CandidateList];
-	PPMKID_CANDIDATE pmkid_candidate;
-	p=(struct status_event *)temp_status_event;
-	pmkid_candidate=p->candidatelist.CandidateList;
-	p->indication.StatusType=Ndis802_11StatusType_PMKID_CandidateList;
-	p->candidatelist.Version=1;
-    
-	for(i=1;i<MAX_BSS_DESCRIPT_ELEMENT;i++)
-	{
-       if(psBSS(i)->wState >=IDLE_SCAN && boCmpSSID(&psBSS(i)->SSID,&psSME->sDesiredSSID))
-	   {
-            memcpy( pmkid_candidate->BSSID, psBSS(i)->abBssID, 6 );
-            if(psBSS(i)->pre_auth)
-			   pmkid_candidate->Flags=NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
-            else
-               pmkid_candidate->Flags=0x0; 
-			pmkid_candidate ++;
-			j++;
-            if(j>MAX_PMKID_Accunt)
-                break;
-		}
-	}
-    p->candidatelist.NumCandidates=(u32)j;
-	NdisMIndicateStatus(
-        Adapter->WbNdis.MiniportAdapterHandle,NDIS_STATUS_MEDIA_SPECIFIC_INDICATION,
-		&temp_status_event,
-		sizeof(NDIS_802_11_STATUS_INDICATION)+
-		sizeof(NDIS_802_11_PMKID_CANDIDATE_LIST)+
-		sizeof(PMKID_CANDIDATE)*j);
-    
-	NdisMIndicateStatusComplete(Adapter->WbNdis.MiniportAdapterHandle);
-
-}
-#endif //end def _WPA2_
-
-
-
+/* We don't need no windows code */
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis51_f.h b/drivers/net/wireless/winbond/winbondport/wbndis51_f.h
index 97c501a..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis51_f.h
+++ b/drivers/net/wireless/winbond/winbondport/wbndis51_f.h
@@ -1,27 +0,0 @@
-// Function definition
-extern NDIS_STATUS Ndis51QueryInformation( PWB32_ADAPTER,
-										   NDIS_OID,
-										   void*,
-										   u32,
-										   PULONG);
-
-extern NDIS_STATUS Ndis51SetInformation( PWB32_ADAPTER,
-										 NDIS_OID,
-										 void*,
-										 u32,
-										 PULONG);
-
-extern void DbgPrintfOID51(NDIS_OID, unsigned char);
-
-extern void WbNdis51_initial(  PWB32_ADAPTER Adapter );
-extern void WbNdis51_oid_sync(  void* s1,  PWB32_ADAPTER Adapter,  void* s3,  void* s4 );
-extern void WbNdis51_connect(  void* s1,  PWB32_ADAPTER Adapter,  void* s3,  void* s4 );
-extern void WbNdis51_destroy(  PWB32_ADAPTER Adapter );
-void FreqToChannelNum(u8 Band, u8 *ChannelNumber, u32 freq);
-
-void vNetAuthEventInd(  PWB32_ADAPTER Adapter, u8 *bssid, u32 flag );
-#ifdef _WPA2_
-void vPmkIdStatusEvent(  PWB32_ADAPTER Adapter );
-#endif
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis51_s.h b/drivers/net/wireless/winbond/winbondport/wbndis51_s.h
index 65cbf2d..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis51_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wbndis51_s.h
@@ -1,27 +0,0 @@
-#define OS_EVENT_INDICATE( _A, _B, _F )	vNetAuthEventInd( _A, _B, _F )
-#ifdef _WPA2_
-#define OS_PMKID_STATUS_EVENT( _A )		vPmkIdStatusEvent( _A ) //added by ws 05/05/04
-#endif
-
-typedef struct _NDIS51_DESIRED_PARAMETER
-{
-	OS_TIMER scan_sync_timer;//20040114.3 ADD
-	OS_TIMER Connect_timer;
-
-	u16	sync_count;
-	u16	sync_scan_require;
-
-	u8	CurrentSSID[36];
-	u32	CurrentSSIDLength;
-
-	u32	ConnectCount;
-	s32	ConnectInterval;
-
-}NDIS51_DESIRED_PARAMETER, *PNDIS51_DESIRED_PARAMETER;
-
-
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
-//#define bss_desc_t WB_BSSDESCRIPTION // For convert
-#define bss_desc_tt WB_BSSDESCRIPTION // For convert
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis_f.h b/drivers/net/wireless/winbond/winbondport/wbndis_f.h
index 7cc8ee9..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis_f.h
+++ b/drivers/net/wireless/winbond/winbondport/wbndis_f.h
@@ -1,42 +0,0 @@
-//=================================
-// Function definition
-//=================================
-#ifdef NDIS51_MINIPORT
-void WBNDIS_PnPNotify(  PADAPTER Adapter,  NDIS_DEVICE_PNP_EVENT PnPEvent,  void* InformationBuffer, u32 InformationBufferLength );
-#endif
-
-void WBNDIS_SendPackets(  NDIS_HANDLE MiniportAdapterContext,  PPNDIS_PACKET PacketArray,  u32 NumberOfPackets );
-void WBNDIS_stop(  PADAPTER Adapter );
-void WBNDIS_Destroy(  PADAPTER Adapter );
-unsigned char WBNDIS_Initial(  PADAPTER Adapter,  NDIS_HANDLE MiniportAdapterHandle );
-void WBNDIS_GetNextPacket(  PADAPTER Adapter,  PDESCRIPTOR pDes );
-void WBNDIS_GetNextPacketCompleted(  PADAPTER Adapter,  PDESCRIPTOR pDes );
-void WBNDIS_ReceivePacket(  PADAPTER Adapter,  PRXLAYER1 pRxLayer1 );
-void WbNdis_TxRateShow(  void* S1,  PADAPTER Adapter,  void* S3,  void* S4 );
-NDIS_STATUS WbWLanReset(  PBOOLEAN AddressingReset,  NDIS_HANDLE MiniportAdapterContext );
-NDIS_STATUS WbWLanInitialize(  PNDIS_STATUS OpenErrorStatus,  PUINT SelectedMediumIndex,
-							    PNDIS_MEDIUM MediumArray,  u32 MediumArraySize,
-							    NDIS_HANDLE  MiniportAdapterHandle,  NDIS_HANDLE ConfigurationHandle );
-NDIS_STATUS WbReadNdisConfigration(  PADAPTER	Adapter,  NDIS_HANDLE ConfigurationHandle );
-void WbWLanHalt(  NDIS_HANDLE  MiniportAdapterContext );
-NDIS_STATUS WbWLanReset(  PBOOLEAN AddressingReset,  NDIS_HANDLE MiniportAdapterContext );
-NDIS_STATUS WbWLanQueryInformation(   NDIS_HANDLE MiniportAdapterContext,  NDIS_OID Oid,
-								      void* InformationBuffer,  u32 InformationBufferLength,
-									 PULONG BytesWritten,  PULONG BytesNeeded );
-NDIS_STATUS WbWLanSetInformation(   NDIS_HANDLE MiniportAdapterContext,  NDIS_OID Oid,
-								    void* InformationBuffer,  u32 InformationBufferLength,
-								   PULONG BytesRead,  PULONG BytesNeeded );
-void WBNDIS_ConnectStatus(  PADAPTER Adapter,  u32 flag );
-#ifdef NDIS50_MINIPORT
-void WbInitializeString(   PNDIS_STRING DestinationString,  PUCHAR SourceString );
-void WbFreeString(  NDIS_STRING String );
-#else
-#define WbInitializeString( _D, _S )	NdisInitializeString( _D, _S )
-#define WbFreeString( _S )				NdisFreeString( _S )
-#endif
-
-
-
-
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis_s.h b/drivers/net/wireless/winbond/winbondport/wbndis_s.h
index c32863d..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wbndis_s.h
@@ -1,158 +0,0 @@
-//============================================================
-// WbNdis.h
-//
-
-#define	OS_PACKET_SIZE( _A )	\
-	(!Adapter->WbNdis.shutdown && Adapter->WbNdis.first_packet) ? RESERVED(Adapter->WbNdis.first_packet)->NdisPacketSize : 0
-#define OS_LINK_STATUS			(Adapter->WbNdis.connect_status==NDIS_STATUS_MEDIA_CONNECT)
-#define OS_SET_SHUTDOWN( _A )					WBNDIS_SET_SHUTDOWN( _A )
-#define OS_SET_RESUME( _A )						WBNDIS_SET_RESUME( _A )
-#define OS_CONNECT_STATUS_INDICATE( _A, _F )	WBNDIS_ConnectStatus( _A, _F )
-#define OS_CURRENT_RX_BYTE( _A )		(_A->WbNdis.RxByteCount)
-#define OS_CURRENT_TX_BYTE( _A )		(_A->WbNdis.TxByteCount)
-#define OS_RECEIVE_PACKET_INDICATE( _A, _D )	WBNDIS_ReceivePacket( _A, _D )
-#define OS_STOP( _A )			WBNDIS_stop( _A )
-#define OS_GET_PACKET( _A, _D )				WBNDIS_GetNextPacket( _A, _D )
-#define OS_GET_PACKET_COMPLETE( _A, _D )	WBNDIS_GetNextPacketCompleted( _A, _D )
-#define OS_SEND_RESULT( _A, _ID, _R )
-
-//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-#ifdef NDIS50_MINIPORT	// 20060726
-#define WB_NDIS_STATUS_NOT_SUPPORTED		NDIS_STATUS_FAILURE
-#else
-#define WB_NDIS_STATUS_NOT_SUPPORTED		NDIS_STATUS_NOT_SUPPORTED
-#endif
-
-// NDIS Version definition
-#define WB32_NDIS_MAJOR_VERSION		5
-#define WB32_NDIS_MINOR_VERSION		0
-
-//Customize OID by vender
-#define OID_802_11_CUST_LINK_QUALITY        0xFF000000
-#define OID_802_11_CUST_HW_VERSION          0xFF000001
-#define OID_802_11_CUST_DRV_VERSION			0xFF000002
-#define OID_802_11_CUST_PREAMBLE_TYPE       0xFF000003//added by ws 09/28/04
-// add for radio on/off control
-#define OID_802_11_CUST_RADIO               0xFF000004
-// add for region control
-#define OID_802_11_CUST_REGION              0xFF000005
-#define OID_802_11_CUST_DRV_NAME            0xFF000006
-
-// 20041021 1.1.81.1000 ybjiang
-// add for radio notification 
-#define OID_802_11_CUST_RADIO_NOTIFICATION  0xFF000007
-
-// 20041026 1.1.83.1000 ybjiang
-#define OID_802_11_CUST_IBSS_FREQUENCY      0xFF000008
-
-// 20041102 1.1.91.1000 ybjiang
-#define OID_802_11_CUST_REGION_CAPABILITIES 0xFF000009
-
-/** 1.1.97 Turbo add for Qcom case */
-#define OID_802_11_CUST_ENCRYPTION_STATUS   0xFF00000A
-
-//sky added 20050803
-#define OID_802_11_CUST_TX_THROUGHPUT		0xFF00000B
-#define OID_802_11_CUST_RX_THROUGHPUT		0xFF00000C
-//sky added 20050817
-#define OID_802_11_CUST_RF_TYPE				0xFF00000D
-
-// 20061108 WPS
-#define OID_802_11_CUST_IE_APPEND			0xFF00000E
-#define OID_802_11_CUST_LED_CONTROL			0xFF00000F
-
-#define WBNDIS_SET_SHUTDOWN( _A )	_A->WbNdis.shutdown=1
-#define WBNDIS_SET_RESUME( _A )		_A->WbNdis.shutdown=0
-
-#define MAX_ADAPTER_COUNT			8
-
-////////////////////////////////////////////////////////////////////////////////////////////////////////
-typedef struct _WBNDIS
-{
-	NDIS_SPIN_LOCK	SpinLock; // For Tx spinlock
-	u32	shutdown;// 931130.4.s
-
-	// For storing the 802.3 NDIS packet
-	PNDIS_PACKET	first_packet;
-	PNDIS_PACKET	last_packet;
-	PNDIS_PACKET	packet_return;
-
-	OS_ATOMIC	ThreadCount;
-
-	//==============================================
-	// For NDIS
-	//==============================================
-	NDIS_HANDLE		PacketPoolHandle;
-	NDIS_HANDLE		BufferPoolHandle;
-
-	u8			NdisPacketPoolOk;// 931130.4.t
-	u8			PacketAllocateCount;// 931130.4.t
-	u8			NdisBufferPoolOk;// 931130.4.t
-	u8			RESERVED_c;
-
-	PNDIS_PACKET	ReceivePacket[ ETHERNET_RX_DESCRIPTORS ];
-	PNDIS_BUFFER	ReceiveBuffer[ ETHERNET_RX_DESCRIPTORS ];
-
-    NDIS_HANDLE             MiniportAdapterHandle;
-    //NDIS_HANDLE             ConfigurationHandle;
-    NDIS_STATUS             connect_status;
-
-	// For collect each buffer
-	u8		NdisBufferTmp[1520];
-
-	// For counting throughput for 802.3 frame
-	u32		TxByteCount; // 802.3 frame send byte count
-	u32		RxByteCount; // 802.3 frame receive byte count
-	u32		TxByteCount_last; // 802.3 frame send byte count
-	u32		TxRateShowResult;
-	OS_TIMER	TxRateTimer;
-
-	NDIS_STRING			DeviceName; // 20060721 move here
-    NDIS_STRING			DeviceLinkUnicodeString;
-
-	u32	DisconnectIndicate;
-
-} WBNDIS, *PWBNDIS;
-
-
-//
-// Type of an interrupt.
-//--------------------------------------------
-
-/*typedef enum
-{
-	BUSERR              = 0x01,
-	RECEIVE             = 0x02,
-	TRANSMIT            = 0x04,
-	RXBUFFERUNAVAILABLE = 0x08,
-    TSFSYNCOK           = 0x10,             
-    UNKNOWN             = 0x11,             
-} INTERRUPT_TYPE;
-*/
-
-// Using this OOB for store additional information : 4+4+2+1+1=12
-typedef struct _MINIPORT_RESERVED {  
-               PNDIS_PACKET Next;               // used to link in the queues (4 bytes)
-			   union
-			   {
-					PUCHAR			MLME_DataBuffer;    //  
-					PNDIS_BUFFER	pNdisPacketBuffer;
-			   };
-
-			   union
-			   {
-					u16		MLME_Size;          //
-					u16		NdisPacketSize;
-			   };
-			   u8		Flag;               //
-			   u8		FrameType;          //
-} MINIPORT_RESERVED, *PMINIPORT_RESERVED;
-
-//
-// Retrieve the MINIPORT_RESERVED structure from a packet.
-// MiniportReservedEx = 3*4=12   
-#define RESERVED(Packet)            \
-        ((PMINIPORT_RESERVED)((Packet)->MiniportReservedEx))
-
-extern ANSI_STRING g_String;
-extern char g_NicName[100];

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
