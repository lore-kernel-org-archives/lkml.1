Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbYDYSLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbYDYSLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765954AbYDYSJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:09:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42525 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765920AbYDYSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:09:12 -0400
Date: Fri, 25 Apr 2008 20:09:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: w35und: transmit optimalization is not neccessary for now
Message-ID: <20080425180950.GA28558@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove unused code.

More junk removal.

---
commit 225d43f2a1a29a12295c5b9b9c390e7a481b116c
tree 6bdd83b69ad3036451be59c8be85bfe82c1f53be
parent 8a641ec6e230af50cb72311a49a69d76f56c4acd
author Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 20:08:44 +0200
committer Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 20:08:44 +0200

 .../net/wireless/winbond/winbondport/mlmetxrx.c    |   53 +----
 drivers/net/wireless/winbond/winbondport/mto.c     |  262 --------------------
 drivers/net/wireless/winbond/winbondport/wbhal_s.h |   60 +----
 3 files changed, 19 insertions(+), 356 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
index 7dea640..04bcbaa 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
@@ -101,8 +101,18 @@ #endif
 void
 MLME_GetNextPacket(PADAPTER Adapter, PDESCRIPTOR pDes)
 {
+#define DESCRIPTOR_ADD_BUFFER( _D, _A, _S ) \
+{\
+	_D->InternalUsed = _D->buffer_start_index + _D->buffer_number; \
+	_D->InternalUsed %= MAX_DESCRIPTOR_BUFFER_INDEX; \
+	_D->buffer_address[ _D->InternalUsed ] = _A; \
+	_D->buffer_size[ _D->InternalUsed ] = _S; \
+	_D->buffer_total_size += _S; \
+	_D->buffer_number++;\
+}
+
 	DESCRIPTOR_ADD_BUFFER( pDes, Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len );
-	DESCRIPTOR_SET_TYPE( pDes, Adapter->sMlmeFrame.DataType );
+	pDes->Type = Adapter->sMlmeFrame.DataType;
 }
 
 void MLMEfreeMMPDUBuffer(PWB32_ADAPTER Adapter, PCHAR pData)
@@ -129,62 +139,23 @@ MLME_SendComplete(PADAPTER Adapter, u8 P
 	u8		DataTmp[200];
 
 	memcpy(DataTmp, Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len);
-    #ifdef _PE_TX_DUMP_
-	WBDEBUG(( "dump tx callback, len=%d\n", Adapter->sMlmeFrame.len ));
-	DataDmp( Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len, 0 );
-    #endif
 
     // Reclaim the data buffer
 	Adapter->sMlmeFrame.len = 0;
 	MLMEfreeMMPDUBuffer( Adapter, Adapter->sMlmeFrame.pMMPDU );
 
 
-	//TxCallback.wFrameType = pData[0];  //&0xf0;
 	//TODO : ?? The pData has been returned, but we still use it to know what kind
 	//			of mlme frame it is. Will it be dangerous??
-	//TxCallback.psFramePtr = pData;
 	TxCallback.psFramePtr = DataTmp;
-	if( SendOK )
+	if (SendOK)
 		TxCallback.bResult = MLME_SUCCESS;
 	else
 		TxCallback.bResult = TRANSMIT_FRAME_FAIL;
 
 	// Return resource
 	Adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;
-	#ifdef _PE_TX_DUMP_
-	WBDEBUG(("!!Return MLME tx packet\n"));
-	#endif
 }
 
-//===========================================================================
-//	Function:
-//		MLMERcvFrame()
-//
-//	Description:
-//      To receive and ready to process the MLME frame, excluding the FCS
-//      field.
-//      MDS usually passes the MMPDU, which may be segmented and stored into
-//      several Rx data buffers, to this function with a pointer to an array
-//      of the RXBUFFER structure and the number of entries in the array.
-//
-//  Arguments:
-//      Adapter         - Pointer to the Miniport Adatper Context.
-//      pRxBufferArray  - Pointer to the first RXBUFFER for the Rx frame.
-//      NumOfBuffer     - Number of the buffer segment.
-//      ReturnSlotIndex - Reserved for Rx handler
-//
-//	Return value:
-//      None.
-//===========================================================================
-void
-MLMERcvFrame(
-     PWB32_ADAPTER    Adapter,
-     PRXBUFFER        pRxBufferArray,
-     u8             NumOfBuffer,
-     u8            SlotIndex)
-{
-	BUG();
-    return;
-}
 
 
diff --git a/drivers/net/wireless/winbond/winbondport/mto.c b/drivers/net/wireless/winbond/winbondport/mto.c
index d81e06a..5bc04d2 100644
--- a/drivers/net/wireless/winbond/winbondport/mto.c
+++ b/drivers/net/wireless/winbond/winbondport/mto.c
@@ -196,7 +196,6 @@ #define RSSI2RATE_SIZE 9
 static TXRETRY_REC TxRateRec={MTO_MAX_DATA_RATE_LEVELS - 1, 0};   //new record=>TxRateRec
 static int TxRetryRate;
 //static int SQ3, BSS_PK_CNT, NIDLESLOT, SLOT_CNT, INTERF_CNT, GAP_CNT, DS_EVM;
-static int RXRATE=1;// RxBytes, TxBytes;
 static s32 RSSIBuf[RSSIBUF_NUM]={-70, -70, -70, -70, -70, -70, -70, -70, -70, -70};
 static s32 RSSISmoothed=-700;
 static int RSSIBufIndex=0;
@@ -215,10 +214,6 @@ static int retryrate_rec[MTO_MAX_DATA_RA
 
 static int PeriodTotalTxPkt = 0;
 static int PeriodTotalTxPktRetry = 0;
-static u8 TxCheckCycle = 0;
-
-static int inc_tx_retry_count = 0;
-static int inc_tx_frag_count = 0;
 
 typedef struct
 {
@@ -244,7 +239,6 @@ static u8 last_rate_ant; //this is used 
 u8	boSparseTxTraffic = FALSE;
 
 void MTO_Init(MTO_FUNC_INPUT);
-void MTO_PeriodicTimerExpired(MTO_FUNC_INPUT);
 void AntennaToggleInitiator(MTO_FUNC_INPUT);
 void AntennaToggleState(MTO_FUNC_INPUT);
 void TxPwrControl(MTO_FUNC_INPUT);
@@ -254,15 +248,12 @@ void TxRateReductionCtrl(MTO_FUNC_INPUT)
 //void MTO_SetDTORateRange(int type);
 void MTO_SetDTORateRange(MTO_FUNC_INPUT, u8 *pRateArray, u8 ArraySize);
 void MTO_SetTxCount(MTO_FUNC_INPUT, u8 t0, u8 index);
-void MTO_GetRxRate(int rate_index);
 void MTO_TxFailed(MTO_FUNC_INPUT);
 void SmoothRSSI(s32 new_rssi);
 void hal_get_dto_para(MTO_FUNC_INPUT, char *buffer);
 u8 CalcNewRate(MTO_FUNC_INPUT, u8 old_rate, u32 retry_cnt, u32 tx_frag_cnt);
 u8 GetMaxRateLevelFromRSSI(void);
-u8 MTO_GetTxRate(MTO_FUNC_INPUT, u32 fpdu_len);
 u8 MTO_GetTxFallbackRate(MTO_FUNC_INPUT);
-void MTO_CalFallbackRate(MTO_FUNC_INPUT);
 int Divide(int a, int b);
 void multiagc(MTO_FUNC_INPUT, u8 high_gain_mode);
 
@@ -479,84 +470,6 @@ void MTO_Init(MTO_FUNC_INPUT)
 	MTO_DATA().RSSI_low = -60;
 }
 
-//===========================================================================
-//  MTO_PeriodicTimerExpired --
-//
-//  Description:
-//    In HW-MAC architecture, MTO adjusts performance affecting parameters
-//    periodically. This is accomplished by starting a periodic timer and
-//    invoking this function when the timer expires.
-//
-//  Arguments:
-//    Adapter      - The pointer to the Miniport Adapter Context
-//
-//  Return Value:
-//    None
-//============================================================================
-void MTO_PeriodicTimerExpired(MTO_FUNC_INPUT)
-{
-	MTO_TMR_CNT()++;
-
-	if (LOCAL_IS_CONNECTED() == FALSE)//when AP disconnected
-	{
-		
-		u8      x;
-		x = hal_get_antenna_number(MTO_HAL());
-		
-		old_antenna[0] = x;
-		old_antenna[2] = x;
-		x = (~x) & 0x01;
-		old_antenna[1] = x;
-		old_antenna[3] = x;
-		MTO_RATE_LEVEL()= 0;//MTO_DataRateAvailableLevel - 8;
-		MTO_FALLBACK_RATE_LEVEL()	= MTO_RATE_LEVEL();
-		untogglecount=0;
-		multiagc(MTO_FUNC_INPUT_DATA, 1);
-	}
-	else
-	{
-		switch(MTO_TMR_CNT() % 50)
-		{
-			case 1:
-				AntennaToggleState(MTO_FUNC_INPUT_DATA);
-				break;
-			case 2:
-			case 3:
-			case 4:
-			case 5:
-			case 6:
-				AntennaToggleState(MTO_FUNC_INPUT_DATA);
-				break;
-			case 7:
-				TxPwrControl(MTO_FUNC_INPUT_DATA);
-				break;
-			case 0:
-				GetFreshAntennaData(MTO_FUNC_INPUT_DATA);
-				TxCheckCycle = 0;
-
-				//Check the tx traffic
-				{
-					if (MTO_TXFLOWCOUNT() < 30)
-					{
-						boSparseTxTraffic = TRUE;
-						#ifdef _PE_DTO_DUMP_
-						WBDEBUG(("***** sparse traffic\n"));
-						#endif
-					}
-					else
-						boSparseTxTraffic = FALSE;
-					MTO_TXFLOWCOUNT() = 0;
-				}
-				break;
-			default:
-				break;
-		}
-		if ((MTO_TMR_CNT() % 50)>6)  //stop at 0~6
-			TxRateReductionCtrl(MTO_FUNC_INPUT_DATA);
-		return;
-	}
-}
-
 //---------------------------------------------------------------------------//
 static u32 DTO_Rx_Info[13][3];
 static u32 DTO_RxCRCFail_Info[13][3];
@@ -1028,137 +941,6 @@ void TxPwrControl(MTO_FUNC_INPUT)
 	}
 }
 
-void TxRateReductionCtrl(MTO_FUNC_INPUT)
-{
-    static u8      rate_level[3];
-	s32		rssi;
-	int i;
-	u32 retry_rate;
-	int	SuccessRate;
-
-	TxCheckCycle++;
-	TxCheckCycle %= 5;
-	if (TxCheckCycle == 0)
-	{
-		SuccessRate = Divide(PeriodTotalTxPkt*100,PeriodTotalTxPktRetry);
-		#ifdef _PE_DTO_DUMP_
-		WBDEBUG(("PeriodTotalTxPkt =%d, PeriodTotalTxPktRetry =%d, Rate = %d\n",
-						PeriodTotalTxPkt, PeriodTotalTxPktRetry, SuccessRate));
-		#endif
-		//if (PeriodTotalTxPktRetry > 100)
-		if (PeriodTotalTxPktRetry > 70)
-		{
-			if (SuccessRate < 40)
-			{
-				#ifdef _PE_DTO_DUMP_
-				WBDEBUG(("The Current antenna may not work fine, change antenna.\n"));
-				#endif
-				ResetDTO_RxInfo(MTO_ANT_MAC(), MTO_FUNC_INPUT_DATA);
-				MTO_TOGGLE_STATE() = TOGGLE_STATE_WAIT0;
-				MTO_TMR_CNT() = 3;
-				MTO_BACKOFF_TMR() = 0;
-			}
-		}
-	}
-
-	sme_get_rssi(MTO_FUNC_INPUT_DATA, &rssi);
-	SmoothRSSI(rssi);
-	switch(MTO_TX_RATE_REDUCTION_STATE())
-	{
-	case RATE_CHGSTATE_IDLE:
-		MTO_HAL()->dto_tx_retry_count = 0;
-		MTO_HAL()->dto_tx_frag_count = 0;
-		#ifdef _PE_DTO_DUMP_
-		WBDEBUG(("dto_tx_retry_count clear 1\n"));
-		#endif
-		MTO_TX_RATE_REDUCTION_STATE() = RATE_CHGSTATE_CALCULATE;
-		break;
-	case RATE_CHGSTATE_CALCULATE:
-		//PDEBUG(("[HHDTODATARATE]:rate calculate start===\n"));
-		if(MTO_RATE_CHANGE_ENABLE()==1)
-		{
-			rate_level[2] = rate_level[1];
-			rate_level[1] = rate_level[0];
-		}
-		rate_level[0] = CalcNewRate(MTO_FUNC_INPUT_DATA, MTO_RATE_LEVEL(),
-						MTO_HAL()->dto_tx_retry_count, MTO_HAL()->dto_tx_frag_count);
-		if(rate_level[0] == 0xff) //means that too few packets received
-		{
-		//	PDEBUG(("[HHDTODATARATE]:too few packets,rate=%d total packets=%d\n",MTO_DATA_RATE(),MTO_HAL()->dto_tx_frag_count));
-			#ifdef _PE_DTO_DUMP_
-			WBDEBUG(("Too few packets, retry count=%d , total count=%d\n",
-					MTO_HAL()->dto_tx_retry_count,
-					MTO_HAL()->dto_tx_frag_count));
-			#endif
-		}
-		else if(rate_level[0] != MTO_RATE_LEVEL())
-		{
-			MTO_RATE_LEVEL() = rate_level[0];
-			hal_rate_change( &Adapter->sHwData ); // 20060613.1 Add
-			#ifdef _USE_FALLBACK_RATE_
-			MTO_CalFallbackRate(MTO_FUNC_INPUT_DATA);
-			#endif
-			#ifdef _PE_DTO_DUMP_
-			WBDEBUG(("New calculated tx level =%x, Rate =%dM\n", rate_level[0], MTO_DATA_RATE()>>1));
-			#endif
-			//MTO_PREAMBLE_TYPE() = MTO_PREAMBLE_SHORT;
-			//MTO_SET_PREAMBLE_TYPE(MTO_PREAMBLE_TYPE());
-			MTO_HAL()->dto_tx_retry_count = 0;
-			MTO_HAL()->dto_tx_frag_count = 0;
-		}
-		else if(rate_level[1] == rate_level[2])
-		{
-			MTO_BACKOFF_TMR() = (MTOPARA_TXRATE_BACKOFF()<<MTO_CO_EFFICENT());
-			MTO_TX_RATE_REDUCTION_STATE() = RATE_CHGSTATE_BACKOFF;
-			MTO_HAL()->dto_tx_retry_count = 0;
-			MTO_HAL()->dto_tx_frag_count = 0;
-			inc_tx_retry_count = 0;
-			inc_tx_frag_count = 0;
-		}
-		#ifdef _PE_DTO_DUMP_
-		WBDEBUG(("[HHDTODATARATE]:MTO_RATE_LEVEL=%d",MTO_RATE_LEVEL()));
-		#endif
-		break;
-	case RATE_CHGSTATE_BACKOFF:
-		//following is check the retry rate change reset the backoff timer
-		retry_rate = Divide(MTO_HAL()->dto_tx_retry_count * 100, MTO_HAL()->dto_tx_frag_count);
-		inc_tx_retry_count = MTO_HAL()->dto_tx_retry_count;
-		inc_tx_frag_count = MTO_HAL()->dto_tx_frag_count;
-		#ifdef _PE_DTO_DUMP_
-		WBDEBUG(("[HHDTODATARATE]:tx_retry_count =%d, tx_frag_count =%d\n",
-					MTO_HAL()->dto_tx_retry_count, MTO_HAL()->dto_tx_frag_count));
-		WBDEBUG(("[HHDTODATARATE]:retry rate at mem is %d and the now retry rate %d\n",TxRateRec.tx_retry_rate,retry_rate));
-		WBDEBUG(("[HHDTODATARATE]:data rate=%d,Backoff Timer=%d",MTO_Data_Rate_Tbl[MTO_RATE_LEVEL()]>>1,MTO_BACKOFF_TMR()));
-		#endif
-		if (abs(retry_rate-TxRateRec.tx_retry_rate)>10)//retry rate different th
-			MTO_BACKOFF_TMR()=0;
-
-		if(MTO_BACKOFF_TMR()==0)
-		{
-			if(MTO_LAST_RATE() == MTO_RATE_LEVEL())
-			{
-				MTO_CO_EFFICENT() = (MTO_CO_EFFICENT() + 1) % 3;
-			}
-			else
-			{
-				MTO_CO_EFFICENT() = 0;
-			}
-			MTO_LAST_RATE() = MTO_RATE_LEVEL();
-			MTO_TX_RATE_REDUCTION_STATE() = RATE_CHGSTATE_IDLE;
-			for (i=0;i<MTO_MAX_DATA_RATE_LEVELS;i++)
-				retryrate_rec[i]=3;
-		}
-		else
-			MTO_BACKOFF_TMR()--;
-		break;
-	}
-
-	if (TxCheckCycle == 0)
-	{
-		PeriodTotalTxPkt = 0;
-		PeriodTotalTxPktRetry = 0;
-	}
-}
 
 u8 CalcNewRate(MTO_FUNC_INPUT, u8 old_rate, u32 retry_cnt, u32 tx_frag_cnt)
 {
@@ -1413,55 +1195,11 @@ void MTO_SetTxCount(MTO_FUNC_INPUT, u8 t
 	PeriodTotalTxPktRetry += (index+1);
 }
 
-u8 MTO_GetTxRate(MTO_FUNC_INPUT, u32 fpdu_len)
-{
-	//added by JOHN, short packet less than 120 bytes will use 24Mpbs
-	if(fpdu_len > 120)
-		return MTO_DATA_RATE();
-	else
-	{
-		if(MTO_DATA_RATE() >= 48 )
-			return 48;   //24M
-		else
-			return MTO_DATA_RATE();
-	}
-}
-
-//get the fallback rate from current tx rate
-void MTO_CalFallbackRate(MTO_FUNC_INPUT)
-{
-	u8	RateIdx, OfdmRateIdx, FallbackRateIdx;
-
-	RateIdx = MTO_RATE_LEVEL();
-	OfdmRateIdx = MTO_OFDM_RATE_LEVEL();
-	if (RateIdx >= OfdmRateIdx)
-	{
-		//Current tx rate belongs to OFDM rates
-		if (RateIdx != OfdmRateIdx)
-			FallbackRateIdx = RateIdx-1;
-		else
-			FallbackRateIdx = RateIdx;
-	}
-	else
-	{
-		//Current tx rate belongs to DSSS rates
-		if (RateIdx > 0)
-			FallbackRateIdx = RateIdx-1;
-		else
-			FallbackRateIdx = RateIdx;
-	}
-	MTO_FALLBACK_RATE_LEVEL() = FallbackRateIdx;
-}
 u8 MTO_GetTxFallbackRate(MTO_FUNC_INPUT)
 {
 	return MTO_DATA_FALLBACK_RATE();
 }
 
-void MTO_GetRxRate(int rate_index)
-{
-	RXRATE = rate_index;
-}
-
 
 //===========================================================================
 //  MTO_TxFailed --
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal_s.h b/drivers/net/wireless/winbond/winbondport/wbhal_s.h
index 7e98669..104f081 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wbhal_s.h
@@ -20,15 +20,6 @@ #define RF_DECIDE_BY_INF	255
 // The follow define connect to upper layer
 //	User must modify for connection between HAL and upper layer
 //----------------------------------------------------------------
-#define hal_join_OK( _H ) BUG()
-
-
-// Notifying upper module for BSSID read completed
-#define hal_get_bssid_complete( _A )			BUG()
-// Notifying upper module for power mode read completed
-#define hal_get_power_save_mode_complete( _A )		BUG()
-// Notify upper module channel setting had been completed
-#define hal_set_chan_complete( _A, _B )			BUG()
 
 
 
@@ -409,44 +400,12 @@ typedef struct _DESCRIPTOR {		// Skip le
 } DESCRIPTOR, *PDESCRIPTOR;
 
 
-//=======================================================
-// Common operation for DESCRIPTOR
-//=======================================================
-#define DESCRIPTOR_ADD_BUFFER( _D, _A, _S ) \
-{\
-	_D->InternalUsed = _D->buffer_start_index + _D->buffer_number; \
-	_D->InternalUsed %= MAX_DESCRIPTOR_BUFFER_INDEX; \
-	_D->buffer_address[ _D->InternalUsed ] = _A; \
-	_D->buffer_size[ _D->InternalUsed ] = _S; \
-	_D->buffer_total_size += _S; \
-	_D->buffer_number++;\
-}
-#define DESCRIPTOR_GET_TYPE( _D ) _D->Type
-#define DESCRIPTOR_SET_TYPE( _D, _T ) _D->Type = _T
-#define DESCRIPTOR_GET_ID( _D ) _D->Descriptor_ID
-#define DESCRIPTOR_GET_FRAGMENT_COUNT( _D ) _D->FragmentCount
-#define DESCRIPTOR_SET_FRAGMENT_COUNT( _D, _T ) _D->FragmentCount = _T
-#define DESCRIPTOR_GET_FRAGMENT_THRESHOLD( _D ) _D->FragmentThreshold
-#define DESCRIPTOR_SET_FRAGMENT_THRESHOLD( _D, _T ) _D->FragmentThreshold = _T
-#define DESCRIPTOR_GET_TX_RATE( _D ) _D->TxRate
-#define DESCRIPTOR_SET_TX_RATE( _D, _T ) _D->TxRate = _T
-#define DESCRIPTOR_GET_PREAMBLE_MODE( _D ) _D->PreambleMode
-#define DESCRIPTOR_SET_PREAMBLE_MODE( _D, _T ) _D->PreambleMode = _T
-
-#define DESCRIPTOR_STATUS_RESOURCES( _D )	(_D->Descriptor_ID==(MAX_USB_RX_BUFFER_NUMBER-1))
-#define DESCRIPTOR_RX_STATUS_ERROR( _D )	(_D->R01.value & FLAG_ERROR_RX_MASK)
-#define DESCRIPTOR_TX_STATUS_ERROR( _D )	(_D->T02.value & FLAG_ERROR_TX_MASK)
-#define DESCRIPTOR_RX_DECRYPTION_METHOD( _D ) ((u8)_D->R01.R01_decryption_method)
-#define DESCRIPTOR_RX_RECEIVE_TIME( _D )	((u16)_D->R00.R00_receive_time_index)
-#define DESCRIPTOR_RX_STATUS_BAND( _D )		(_D->R01.value & FLAG_BAND_RX_MASK)
-
 #define DEFAULT_NULL_PACKET_COUNT		180000	//20060828.1 Add. 180 seconds
 
 #define MAX_TXVGA_EEPROM	9	//How many word(u16) of EEPROM will be used for TxVGA
 #define MAX_RF_PARAMETER	32
 
-typedef struct _TXVGA_FOR_50
-{
+typedef struct _TXVGA_FOR_50 {
 	u8	ChanNo;
 	u8	TxVgaValue;
 } TXVGA_FOR_50;
@@ -455,17 +414,12 @@ typedef struct _TXVGA_FOR_50
 //=====================================================================
 // Device related include
 //=====================================================================
-#ifdef WB_LINUX
-	#include "linux/wbusb_s.h"
-	#include "linux/wb35reg_s.h"
-	#include "linux/wb35tx_s.h"
-	#include "linux/wb35rx_s.h"
-#else
-	#include "wbusb_s.h"
-	#include "wb35reg_s.h"
-	#include "wb35tx_s.h"
-	#include "wb35rx_s.h"
-#endif
+
+#include "linux/wbusb_s.h"
+#include "linux/wb35reg_s.h"
+#include "linux/wb35tx_s.h"
+#include "linux/wb35rx_s.h"
+
 
 // For Hal using ==================================================================
 typedef struct _HW_DATA_T

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
