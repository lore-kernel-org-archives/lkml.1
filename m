Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZAHJci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZAHJci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbZAHJcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:32:06 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60826 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483AbZAHJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:32:00 -0500
Date: Thu, 8 Jan 2009 11:31:59 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] w35und: kill WBDEBUG and remove common.h header file
Message-ID: <Pine.LNX.4.64.0901081131290.15334@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The only remaining thing in common.h header file is the WBDEBUG() macro which
is unconditionally defined as printk(). Kill the macro and remove the header
file.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/common.h  |   23 -----------------------
 drivers/staging/winbond/mds.c     |    8 ++++----
 drivers/staging/winbond/mto.c     |    1 -
 drivers/staging/winbond/reg.c     |   18 +++++++++---------
 drivers/staging/winbond/wb35reg.c |   10 +++++-----
 drivers/staging/winbond/wb35rx.c  |   10 +++++-----
 drivers/staging/winbond/wb35tx.c  |   10 +++++-----
 drivers/staging/winbond/wbhal.c   |    2 +-
 drivers/staging/winbond/wbhal_s.h |    2 --
 drivers/staging/winbond/wbusb.c   |    4 ++--
 10 files changed, 31 insertions(+), 57 deletions(-)
 delete mode 100644 drivers/staging/winbond/common.h

diff --git a/drivers/staging/winbond/common.h b/drivers/staging/winbond/common.h
deleted file mode 100644
index 4409edd..0000000
--- a/drivers/staging/winbond/common.h
+++ /dev/null
@@ -1,23 +0,0 @@
-//
-// common.h
-//
-// This file contains the OS dependant definition and function.
-// Every OS has this file individual.
-//
-#ifndef COMMON_DEF
-#define COMMON_DEF
-
-//#define DEBUG_ENABLED  1
-
-//==================================================================================================
-// Common function definition
-//==================================================================================================
-#define DEBUG_ENABLED
-#ifdef DEBUG_ENABLED
-#define WBDEBUG( _M )	printk _M
-#else
-#define WBDEBUG( _M )	0
-#endif
-
-#endif // COMMON_DEF
-
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index a9d1945..9a14836 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -374,7 +374,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv * adapter, PDESCRIPTOR pDes, u8 *T
 
 	pDes->TxRate = ctmp1;
 	#ifdef _PE_TX_DUMP_
-	WBDEBUG(("Tx rate =%x\n", ctmp1));
+	printk("Tx rate =%x\n", ctmp1);
 	#endif
 
 	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
@@ -442,7 +442,7 @@ Mds_Tx(struct wbsoft_priv * adapter)
 		FillIndex = pMds->TxFillIndex;
 		if (pMds->TxOwner[FillIndex]) { // Is owned by software 0:Yes 1:No
 #ifdef _PE_TX_DUMP_
-			WBDEBUG(("[Mds_Tx] Tx Owner is H/W.\n"));
+			printk("[Mds_Tx] Tx Owner is H/W.\n");
 #endif
 			break;
 		}
@@ -488,7 +488,7 @@ Mds_Tx(struct wbsoft_priv * adapter)
 			// For speed up Key setting
 			if (pTxDes->EapFix) {
 #ifdef _PE_TX_DUMP_
-				WBDEBUG(("35: EPA 4th frame detected. Size = %d\n", PacketSize));
+				printk("35: EPA 4th frame detected. Size = %d\n", PacketSize);
 #endif
 				pHwData->IsKeyPreSet = 1;
 			}
@@ -585,7 +585,7 @@ Mds_SendComplete(struct wbsoft_priv * adapter, PT02_DESCRIPTOR pT02)
 				else
 					pHwData->tx_retry_count[7] += RetryCount;
 				#ifdef _PE_STATE_DUMP_
-				WBDEBUG(("dto_tx_retry_count =%d\n", pHwData->dto_tx_retry_count));
+				printk("dto_tx_retry_count =%d\n", pHwData->dto_tx_retry_count);
 				#endif
 				MTO_SetTxCount(adapter, TxRate, RetryCount);
 			}
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 7718423..8c4107b 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -83,7 +83,6 @@ void hal_get_dto_para(MTO_FUNC_INPUT, char *buffer);
 void MTO_Init(MTO_FUNC_INPUT)
 {
     int i;
-	//WBDEBUG(("[MTO] -> MTO_Init()\n"));
 	//[WKCHEN]pMTOcore_data = pcore_data;
 // 20040510 Turbo add for global variable
     MTO_TMR_CNT()       = 0;
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index c365c5d..55b05d5 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1115,7 +1115,7 @@ RFSynthesizer_initial(phw_data_t pHwData)
 		//Start to fill RF parameters, PLL_ON should be pulled low.
 		Wb35Reg_WriteSync( pHwData, 0x03dc, 0x00000000 );
 #ifdef _PE_STATE_DUMP_
-		WBDEBUG(("* PLL_ON    low\n"));
+		printk("* PLL_ON    low\n");
 #endif
 
 		number = sizeof(al7230_rf_data_24)/sizeof(al7230_rf_data_24[0]);
@@ -1224,7 +1224,7 @@ RFSynthesizer_initial(phw_data_t pHwData)
 			//pulled high
 			Wb35Reg_WriteSync( pHwData, 0x03dc, 0x00000080 );
 			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("* PLL_ON    high\n"));
+			printk("* PLL_ON    high\n");
 			#endif
 
 			//2.4GHz
@@ -1244,7 +1244,7 @@ RFSynthesizer_initial(phw_data_t pHwData)
 			//5GHz
 			Wb35Reg_WriteSync( pHwData, 0x03dc, 0x00000000 );
 			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("* PLL_ON    low\n"));
+			printk("* PLL_ON    low\n");
 			#endif
 
 			number = sizeof(al7230_rf_data_50)/sizeof(al7230_rf_data_50[0]);
@@ -1256,7 +1256,7 @@ RFSynthesizer_initial(phw_data_t pHwData)
 
 			Wb35Reg_WriteSync( pHwData, 0x03dc, 0x00000080 );
 			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("* PLL_ON    high\n"));
+			printk("* PLL_ON    high\n");
 			#endif
 
 			//ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x12BACF;
@@ -1272,7 +1272,7 @@ RFSynthesizer_initial(phw_data_t pHwData)
 			msleep(5);
 
 			//Wb35Reg_WriteSync( pHwData, 0x03dc, 0x00000080 );
-			//WBDEBUG(("* PLL_ON    high\n"));
+			//printk("* PLL_ON    high\n");
 			break;
 
 		case RF_WB_242:
@@ -2012,7 +2012,7 @@ RFSynthesizer_SwitchingChannel(  phw_data_t pHwData,  ChanInfo Channel )
 
 			//Start to fill RF parameters, PLL_ON should be pulled low.
 			//Wb35Reg_Write( pHwData, 0x03dc, 0x00000000 );
-			//WBDEBUG(("* PLL_ON    low\n"));
+			//printk("* PLL_ON    low\n");
 
 			//Channel independent registers
 			if( Channel.band != pHwData->band)
@@ -2037,7 +2037,7 @@ RFSynthesizer_SwitchingChannel(  phw_data_t pHwData,  ChanInfo Channel )
 				// Write to register. number must less and equal than 16
 				Wb35Reg_BurstWrite( pHwData, 0x0864, pltmp, number, NO_INCREMENT );
 				#ifdef _PE_STATE_DUMP_
-				WBDEBUG(("Band changed\n"));
+				printk("Band changed\n");
 				#endif
 			}
 
@@ -2612,9 +2612,9 @@ void EEPROMTxVgaAdjust(  phw_data_t pHwData ) // 20060619.5 Add
 	}
 
 	#ifdef _PE_STATE_DUMP_
-	WBDEBUG((" TxVgaFor24 : \n"));
+	printk(" TxVgaFor24 : \n");
 	DataDmp((u8 *)pHwData->TxVgaFor24, 14 ,0);
-	WBDEBUG((" TxVgaFor50 : \n"));
+	printk(" TxVgaFor50 : \n");
 	DataDmp((u8 *)pHwData->TxVgaFor50, 70 ,0);
 	#endif
 }
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 9d0a3aa..6a355f0 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -149,7 +149,7 @@ Wb35Reg_WriteSync(  phw_data_t pHwData,  u16 RegisterNo,  u32 RegisterValue )
 
 	if (ret < 0) {
 		#ifdef _PE_REG_DUMP_
-		WBDEBUG(("EP0 Write register usb message sending error\n"));
+		printk("EP0 Write register usb message sending error\n");
 		#endif
 
 		pHwData->SurpriseRemove = 1; // 20060704.2
@@ -316,7 +316,7 @@ Wb35Reg_ReadSync(  phw_data_t pHwData,  u16 RegisterNo,   u32 * pRegisterValue )
 
 	if (ret < 0) {
 		#ifdef _PE_REG_DUMP_
-		WBDEBUG(("EP0 Read register usb message sending error\n"));
+		printk("EP0 Read register usb message sending error\n");
 		#endif
 
 		pHwData->SurpriseRemove = 1; // 20060704.2
@@ -441,7 +441,7 @@ Wb35Reg_EP0VM(phw_data_t pHwData )
 
 	if (ret < 0) {
 #ifdef _PE_REG_DUMP_
-		WBDEBUG(("EP0 Irp sending error\n"));
+		printk("EP0 Irp sending error\n");
 #endif
 		goto cleanup;
 	}
@@ -480,7 +480,7 @@ Wb35Reg_EP0VM_complete(struct urb *urb)
 
 		if (reg->EP0VM_status) {
 #ifdef _PE_REG_DUMP_
-			WBDEBUG(("EP0 IoCompleteRoutine return error\n"));
+			printk("EP0 IoCompleteRoutine return error\n");
 #endif
 			reg->EP0vm_state = VM_STOP;
 			pHwData->SurpriseRemove = 1;
@@ -529,7 +529,7 @@ Wb35Reg_destroy(phw_data_t pHwData)
 			kfree(reg_queue);
 		} else {
 			#ifdef _PE_REG_DUMP_
-			WBDEBUG(("EP0 queue release error\n"));
+			printk("EP0 queue release error\n");
 			#endif
 		}
 		spin_lock_irq( &reg->EP0VM_spin_lock );
diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 63d5591..029d918 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -118,7 +118,7 @@ static u16 Wb35Rx_indicate(struct ieee80211_hw *hw)
 			// Basic check for Rx length. Is length valid?
 			if (PacketSize > MAX_PACKET_SIZE) {
 				#ifdef _PE_RX_DUMP_
-				WBDEBUG(("Serious ERROR : Rx data size too long, size =%d\n", PacketSize));
+				printk("Serious ERROR : Rx data size too long, size =%d\n", PacketSize);
 				#endif
 
 				pWb35Rx->EP3vm_state = VM_STOP;
@@ -194,7 +194,7 @@ static void Wb35Rx_Complete(struct urb *urb)
 	// The URB is completed, check the result
 	if (pWb35Rx->EP3VM_status != 0) {
 		#ifdef _PE_USB_STATE_DUMP_
-		WBDEBUG(("EP3 IoCompleteRoutine return error\n"));
+		printk("EP3 IoCompleteRoutine return error\n");
 		#endif
 		pWb35Rx->EP3vm_state = VM_STOP;
 		goto error;
@@ -259,7 +259,7 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 	if (!pWb35Rx->RxOwner[RxBufferId]) {
 		// It's impossible to run here.
 		#ifdef _PE_RX_DUMP_
-		WBDEBUG(("Rx driver fifo unavailable\n"));
+		printk("Rx driver fifo unavailable\n");
 		#endif
 		goto error;
 	}
@@ -348,7 +348,7 @@ void Wb35Rx_stop(phw_data_t pHwData)
 	if (pWb35Rx->EP3vm_state == VM_RUNNING) {
 		usb_unlink_urb( pWb35Rx->RxUrb ); // Only use unlink, let Wb35Rx_destroy to free them
 		#ifdef _PE_RX_DUMP_
-		WBDEBUG(("EP3 Rx stop\n"));
+		printk("EP3 Rx stop\n");
 		#endif
 	}
 }
@@ -366,7 +366,7 @@ void Wb35Rx_destroy(phw_data_t pHwData)
 	if (pWb35Rx->RxUrb)
 		usb_free_urb( pWb35Rx->RxUrb );
 	#ifdef _PE_RX_DUMP_
-	WBDEBUG(("Wb35Rx_destroy OK\n"));
+	printk("Wb35Rx_destroy OK\n");
 	#endif
 }
 
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index b9b4456..f7fe8d6 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -153,14 +153,14 @@ void Wb35Tx_stop(phw_data_t pHwData)
 	if (pWb35Tx->EP2vm_state == VM_RUNNING)
 		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
 	#ifdef _PE_TX_DUMP_
-	WBDEBUG(("EP2 Tx stop\n"));
+	printk("EP2 Tx stop\n");
 	#endif
 
 	// Trying to canceling the Irp of EP4
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
 		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
 	#ifdef _PE_TX_DUMP_
-	WBDEBUG(("EP4 Tx stop\n"));
+	printk("EP4 Tx stop\n");
 	#endif
 }
 
@@ -182,7 +182,7 @@ void Wb35Tx_destroy(phw_data_t pHwData)
 		usb_free_urb( pWb35Tx->Tx2Urb );
 
 	#ifdef _PE_TX_DUMP_
-	WBDEBUG(("Wb35Tx_destroy OK\n"));
+	printk("Wb35Tx_destroy OK\n");
 	#endif
 }
 
@@ -229,7 +229,7 @@ static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
 
 	//The Urb is completed, check the result
 	if (pWb35Tx->EP2VM_status != 0) {
-		WBDEBUG(("EP2 IoCompleteRoutine return error\n"));
+		printk("EP2 IoCompleteRoutine return error\n");
 		pWb35Tx->EP2vm_state= VM_STOP;
 		goto error;
 	}
@@ -279,7 +279,7 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 
 	if (retv < 0) {
 		#ifdef _PE_TX_DUMP_
-		WBDEBUG(("EP2 Tx Irp sending error\n"));
+		printk("EP2 Tx Irp sending error\n");
 		#endif
 		goto error;
 	}
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index d7bbb9a..3dfb422 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -396,7 +396,7 @@ static void hal_set_current_channel_ex(  phw_data_t pHwData,  ChanInfo channel )
 	pHwData->Channel = channel.ChanNo;
 	pHwData->band = channel.band;
 	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("Set channel is %d, band =%d\n", pHwData->Channel, pHwData->band));
+	printk("Set channel is %d, band =%d\n", pHwData->Channel, pHwData->band);
 	#endif
 	reg->M28_MacControl &= ~0xff; // Clean channel information field
 	reg->M28_MacControl |= channel.ChanNo;
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 513babb..068a327 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -3,8 +3,6 @@
 
 #include <linux/types.h>
 
-#include "common.h"
-
 //[20040722 WK]
 #define HAL_LED_SET_MASK		0x001c	//20060901 Extend
 #define HAL_LED_SET_SHIFT		2
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 008f0fb..7bb9d48 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -277,7 +277,7 @@ static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
 	//get current antenna
 	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
 #ifdef _PE_STATE_DUMP_
-	WBDEBUG(("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo));
+	printk("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo);
 #endif
 	hal_get_hw_radio_off( pHwData );
 
@@ -398,7 +398,7 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 	// Turn off Rx and Tx hardware ability
 	hal_stop( &adapter->sHwData );
 #ifdef _PE_USB_INI_DUMP_
-	WBDEBUG(("[w35und] Hal_stop O.K.\n"));
+	printk("[w35und] Hal_stop O.K.\n");
 #endif
 	msleep(100);// Waiting Irp completed
 
-- 
1.5.4.3

