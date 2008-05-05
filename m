Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYEEUzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYEEUzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYEEUzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:55:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33284 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYEEUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:55:30 -0400
Date: Mon, 5 May 2008 22:56:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: w35und: fixed nasty stack overflow, I can actually ssh over this
Message-ID: <20080505205617.GD7273@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed nasty stack overflow, and got transmit of big packets to
work. I can now actually do ssh over softmac-based driver.

Unindent code to make it more readable.

---
commit 0cfb0fd5cde408c154de69fa1c5521d5288ca506
tree 2814afd5b2b385bd3885c2095e94f03ca7dd8e20
parent 5b251c6315097d5f9ab5d30c43813fe74c1db4e4
author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:40:29 +0200
committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:40:29 +0200

 arch/x86/kernel/traps_32.c                         |    5 +
 .../wireless/winbond/winbondport/linux/wb35tx.c    |   19 +-
 .../net/wireless/winbond/winbondport/linux/wbusb.c |    8 +
 drivers/net/wireless/winbond/winbondport/mds.c     |  192 ++++++++++----------
 .../net/wireless/winbond/winbondport/mlmetxrx.c    |   12 +
 5 files changed, 118 insertions(+), 118 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index b22c01e..c3e9949 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -146,11 +146,16 @@ static inline unsigned long print_contex
 				unsigned long *stack, unsigned long bp,
 				const struct stacktrace_ops *ops, void *data)
 {
+	int max = 5;
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
 		unsigned long addr;
 
+		if (!max)
+			return;
+		max--;
+
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
 			if ((unsigned long) stack == bp + 4) {
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
index 9211206..6ce7905 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
@@ -67,15 +67,13 @@ void Wb35Tx(phw_data_t pHwData)
 	pWb35Tx->EP4vm_state = VM_RUNNING;
 	retv = wb_usb_submit_urb( pUrb );
 	if (retv<0) {
-#ifdef _PE_TX_DUMP_
-		WBDEBUG(("EP4 Tx Irp sending error\n"));
-#endif
+		printk("EP4 Tx Irp sending error\n");
 		goto cleanup;
 	}
 
 	// Check if driver needs issue Irp for EP2
 	pWb35Tx->TxFillCount += pMds->TxCountInBuffer[SendIndex];
-	if( pWb35Tx->TxFillCount > 12 ) // Fixed to 12. 20060928
+	if (pWb35Tx->TxFillCount > 12)
 		Wb35Tx_EP2VM_start( pHwData );
 
 	pWb35Tx->ByteTransfer += pMds->TxBufferSize[SendIndex];
@@ -96,13 +94,12 @@ void Wb35Tx_complete(struct urb * pUrb)
 
 	// Variable setting
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
-	pWb35Tx->EP4VM_status = pUrb->status;//Store the last result of Irp
+	pWb35Tx->EP4VM_status = pUrb->status; //Store the last result of Irp
 	pMds->TxOwner[ pWb35Tx->TxSendIndex ] = 0;// Set the owner. Free the owner bit always.
 	pWb35Tx->TxSendIndex++;
 	pWb35Tx->TxSendIndex %= MAX_USB_TX_BUFFER_NUMBER;
 	
-	do
-	{
+	do {
 		if (pHwData->SurpriseRemove || pHwData->HwStop) // Let WbWlanHalt to handle surprise remove
 			break;
 
@@ -111,15 +108,11 @@ void Wb35Tx_complete(struct urb * pUrb)
 
 		// The URB is completed, check the result
 		if (pWb35Tx->EP4VM_status != 0) {
-			#ifdef _PE_USB_STATE_DUMP_
-			WBDEBUG(("EP4 IoCompleteRoutine return error\n"));
-			DebugUsbdStatusInformation( pWb35Tx->EP4VM_status );
-			#endif
+			printk("URB submission failed\n");
 			pWb35Tx->EP4vm_state = VM_STOP;
 			break; // Exit while(FALSE);
 		}
 
-		// Do the next send
 		Mds_Tx(Adapter);
 		Wb35Tx(pHwData);
 		return;
@@ -131,7 +124,7 @@ void Wb35Tx_complete(struct urb * pUrb)
 
 void Wb35Tx_reset_descriptor(  phw_data_t pHwData )
 {
-	PWB35TX		pWb35Tx = &pHwData->Wb35Tx;
+	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	pWb35Tx->TxSendIndex = 0;
 	pWb35Tx->tx_halt = 0;
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 8c9451a..6d08071 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -113,7 +113,9 @@ static void wbsoft_configure_filter(stru
 static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		      struct ieee80211_tx_control *control)
 {
-	if (1 == MLMESendFrame(my_adapter, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT))
+	char *buffer = kmalloc(skb->len, GFP_ATOMIC);
+	memcpy(buffer, skb->data, skb->len);
+	if (1 == MLMESendFrame(my_adapter, buffer, skb->len, FRAME_TYPE_802_11_MANAGEMENT))
 		printk("frame sent ok?\n");
 	return NETDEV_TX_OK;
 }
@@ -330,8 +332,10 @@ void packet_came(char *pRxBufferAddress,
 		return;
 
 	skb = dev_alloc_skb(PacketSize);
-	if (!skb)
+	if (!skb) {
 		printk("Not enough memory for packet, FIXME\n");
+		return;
+	}
 
 	memcpy(skb_put(skb, PacketSize),
 	       pRxBufferAddress,
diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index 44f3b61..91b60f1 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -52,126 +52,126 @@ Mds_Tx(PADAPTER Adapter)
 		return;
 
 	//Only one thread can be run here
-	if (OS_ATOMIC_INC( Adapter, &pMds->TxThreadCount) == 1)	{
-		// Start to fill the data
+	if (!OS_ATOMIC_INC( Adapter, &pMds->TxThreadCount) == 1)
+		goto cleanup;
+
+	// Start to fill the data
+	do {
+		FillIndex = pMds->TxFillIndex;
+		if (pMds->TxOwner[FillIndex]) { // Is owned by software 0:Yes 1:No
+#ifdef _PE_TX_DUMP_
+			WBDEBUG(("[Mds_Tx] Tx Owner is H/W.\n"));
+#endif
+			break;
+		}
+
+		XmitBufAddress = pMds->pTxBuffer + (MAX_USB_TX_BUFFER * FillIndex); //Get buffer
+		XmitBufSize = 0;
+		FillCount = 0;
 		do {
-			FillIndex = pMds->TxFillIndex;
-			if (pMds->TxOwner[FillIndex]) { // Is owned by software 0:Yes 1:No
-				#ifdef _PE_TX_DUMP_
-				WBDEBUG(("[Mds_Tx] Tx Owner is H/W.\n"));
-				#endif
+			PacketSize = Adapter->sMlmeFrame.len;
+			if (!PacketSize)
 				break;
+
+			//For Check the buffer resource
+			FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
+			//931130.5.b
+			FragmentCount = PacketSize/FragmentThreshold + 1;
+			stmp = PacketSize + FragmentCount*32 + 8;//931130.5.c 8:MIC
+			if ((XmitBufSize + stmp) >= MAX_USB_TX_BUFFER) {
+				printk("[Mds_Tx] Excess max tx buffer.\n");
+				break; // buffer is not enough
 			}
 
-			XmitBufAddress = pMds->pTxBuffer + (MAX_USB_TX_BUFFER * FillIndex); //Get buffer
-			XmitBufSize = 0;
-			FillCount = 0;
-			do {
-				PacketSize = Adapter->sMlmeFrame.len;
-				if (!PacketSize)
-					break;
-
-				//For Check the buffer resource
-				FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
-				//931130.5.b
-				FragmentCount = PacketSize/FragmentThreshold + 1;
-				stmp = PacketSize + FragmentCount*32 + 8;//931130.5.c 8:MIC
-				if ((XmitBufSize + stmp) >= MAX_USB_TX_BUFFER) {
-					#ifdef _PE_TX_DUMP_
-					WBDEBUG(("[Mds_Tx] Excess max tx buffer.\n"));
-					#endif
-					break; // buffer is not enough
-				}
-
-
-				//
-				// Start transmitting
-				//
-				BufferFilled = TRUE;
-
-				/* Leaves first u8 intact */
-				memset((PUCHAR)pTxDes + 1, 0, sizeof(DESCRIPTOR) - 1);
+
+			//
+			// Start transmitting
+			//
+			BufferFilled = TRUE;
+
+			/* Leaves first u8 intact */
+			memset((PUCHAR)pTxDes + 1, 0, sizeof(DESCRIPTOR) - 1);
 				
-				TxDesIndex = pMds->TxDesIndex;//Get the current ID
-				pTxDes->Descriptor_ID = TxDesIndex;
-				pMds->TxDesFrom[ TxDesIndex ] = 2;//Storing the information of source comming from
-				pMds->TxDesIndex++;
-				pMds->TxDesIndex %= MAX_USB_TX_DESCRIPTOR;
+			TxDesIndex = pMds->TxDesIndex;//Get the current ID
+			pTxDes->Descriptor_ID = TxDesIndex;
+			pMds->TxDesFrom[ TxDesIndex ] = 2;//Storing the information of source comming from
+			pMds->TxDesIndex++;
+			pMds->TxDesIndex %= MAX_USB_TX_DESCRIPTOR;
 				
-				MLME_GetNextPacket( Adapter, pTxDes );
+			MLME_GetNextPacket( Adapter, pTxDes );
 
-				// Copy header. 8byte USB + 24byte 802.11Hdr. Set TxRate, Preamble type
-				Mds_HeaderCopy( Adapter, pTxDes, XmitBufAddress );
+			// Copy header. 8byte USB + 24byte 802.11Hdr. Set TxRate, Preamble type
+			Mds_HeaderCopy( Adapter, pTxDes, XmitBufAddress );
 
-				// For speed up Key setting
-				if (pTxDes->EapFix) {
-					#ifdef _PE_TX_DUMP_
-					WBDEBUG(("35: EPA 4th frame detected. Size = %d\n", PacketSize));
-					#endif
-					pHwData->IsKeyPreSet = 1;
-				}
+			// For speed up Key setting
+			if (pTxDes->EapFix) {
+#ifdef _PE_TX_DUMP_
+				WBDEBUG(("35: EPA 4th frame detected. Size = %d\n", PacketSize));
+#endif
+				pHwData->IsKeyPreSet = 1;
+			}
 
-				// Copy (fragment) frame body, and set USB, 802.11 hdr flag
-				CurrentSize = Mds_BodyCopy(Adapter, pTxDes, XmitBufAddress);
+			// Copy (fragment) frame body, and set USB, 802.11 hdr flag
+			CurrentSize = Mds_BodyCopy(Adapter, pTxDes, XmitBufAddress);
 
-				// Set RTS/CTS and Normal duration field into buffer
-				Mds_DurationSet(Adapter, pTxDes, XmitBufAddress);
+			// Set RTS/CTS and Normal duration field into buffer
+			Mds_DurationSet(Adapter, pTxDes, XmitBufAddress);
 
-				//
-				// Calculation MIC from buffer which maybe fragment, then fill into temporary address 8 byte
-				// 931130.5.e
-				if (MICAdd)
-					Mds_MicFill( Adapter, pTxDes, XmitBufAddress );
+			//
+			// Calculation MIC from buffer which maybe fragment, then fill into temporary address 8 byte
+			// 931130.5.e
+			if (MICAdd)
+				Mds_MicFill( Adapter, pTxDes, XmitBufAddress );
 
-				//Shift to the next address
-				XmitBufSize += CurrentSize;
-				XmitBufAddress += CurrentSize;
+			//Shift to the next address
+			XmitBufSize += CurrentSize;
+			XmitBufAddress += CurrentSize;
 
-				#ifdef _IBSS_BEACON_SEQ_STICK_
-				if ((XmitBufAddress[ DOT_11_DA_OFFSET+8 ] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) // +8 for USB hdr
-				#endif
-					pMds->TxToggle = TRUE;
+#ifdef _IBSS_BEACON_SEQ_STICK_
+			if ((XmitBufAddress[ DOT_11_DA_OFFSET+8 ] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) // +8 for USB hdr
+#endif
+				pMds->TxToggle = TRUE;
 
-				// Get packet to transmit completed, 1:TESTSTA 2:MLME 3: Ndis data
-				MLME_SendComplete(Adapter, 0, TRUE);
+			// Get packet to transmit completed, 1:TESTSTA 2:MLME 3: Ndis data
+			MLME_SendComplete(Adapter, 0, TRUE);
 
-				// Software TSC count 20060214
-				pMds->TxTsc++;
-				if (pMds->TxTsc == 0)
-					pMds->TxTsc_2++;
+			// Software TSC count 20060214
+			pMds->TxTsc++;
+			if (pMds->TxTsc == 0)
+				pMds->TxTsc_2++;
 
-				FillCount++; // 20060928
-			} while (HAL_USB_MODE_BURST(pHwData)); // End of multiple MSDU copy loop. FALSE = single TRUE = multiple sending
+			FillCount++; // 20060928
+		} while (HAL_USB_MODE_BURST(pHwData)); // End of multiple MSDU copy loop. FALSE = single TRUE = multiple sending
 
-			// Move to the next one, if necessary
-			if (BufferFilled) {
-				// size setting
-				pMds->TxBufferSize[ FillIndex ] = XmitBufSize;
+		// Move to the next one, if necessary
+		if (BufferFilled) {
+			// size setting
+			pMds->TxBufferSize[ FillIndex ] = XmitBufSize;
 
-				// 20060928 set Tx count
-				pMds->TxCountInBuffer[FillIndex] = FillCount;
+			// 20060928 set Tx count
+			pMds->TxCountInBuffer[FillIndex] = FillCount;
 
-				// Set owner flag
-				pMds->TxOwner[FillIndex] = 1;
+			// Set owner flag
+			pMds->TxOwner[FillIndex] = 1;
 
-				pMds->TxFillIndex++;
-				pMds->TxFillIndex %= MAX_USB_TX_BUFFER_NUMBER;
-				BufferFilled = FALSE;
-			} else
-				break;
+			pMds->TxFillIndex++;
+			pMds->TxFillIndex %= MAX_USB_TX_BUFFER_NUMBER;
+			BufferFilled = FALSE;
+		} else
+			break;
 
-			if (!PacketSize) // No more pk for transmitting
-				break;
+		if (!PacketSize) // No more pk for transmitting
+			break;
 
-		} while(TRUE);
+	} while(TRUE);
 
-		//
-		// Start to send by lower module
-		//
-		if (!pHwData->IsKeyPreSet)
-			Wb35Tx_start(pHwData);
-	}
+	//
+	// Start to send by lower module
+	//
+	if (!pHwData->IsKeyPreSet)
+		Wb35Tx_start(pHwData);
 
+ cleanup:
 	OS_ATOMIC_DEC( Adapter, &pMds->TxThreadCount );
 }
 
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
index 04bcbaa..bff42c7 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
@@ -75,8 +75,8 @@ u8 MLMESendFrame(PWB32_ADAPTER Adapter, 
 /*	DataType : FRAME_TYPE_802_11_MANAGEMENT, FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
 				FRAME_TYPE_802_11_DATA */
 {
-	if( Adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE ) {
-		Adapter->sMlmeFrame.wNumTxMMPDUDiscarded ++;
+	if (Adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
+		Adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
 		return FALSE;
 	}
 	Adapter->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
@@ -84,17 +84,15 @@ u8 MLMESendFrame(PWB32_ADAPTER Adapter, 
 	// Keep information for sending
 	Adapter->sMlmeFrame.pMMPDU = pMMPDU;
 	Adapter->sMlmeFrame.DataType = DataType;
-	Adapter->sMlmeFrame.len = len; // It must be the last setting due to QUERY_SIZE_SECOND of Mds
+	// len must be the last setting due to QUERY_SIZE_SECOND of Mds
+	Adapter->sMlmeFrame.len = len;
 	Adapter->sMlmeFrame.wNumTxMMPDU++;
 
 	// H/W will enter power save by set the register. S/W don't send null frame
 	//with PWRMgt bit enbled to enter power save now.
 
 	// Transmit NDIS packet
-	Mds_Tx( Adapter );
-#ifdef _PE_TX_DUMP_
-	WBDEBUG(("MLMESendFrame->mds_tx_ok\n"));
-#endif
+	Mds_Tx(Adapter);
 	return TRUE;
 }
 



!-------------------------------------------------------------flip-


Removed nasty stack overflow, and got transmit of big packets to
work. I can now actually do ssh over softmac-based driver.

---
commit 78b9049df56fbd5fc785b4e7e9c93dbfb8390d2a
tree 2290532e477ee36bd33a7e6e91c6f3207420c9e2
parent 0cfb0fd5cde408c154de69fa1c5521d5288ca506
author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:54:25 +0200
committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:54:25 +0200

 .../wireless/winbond/winbondport/linux/wb35tx.c    |    1 +
 .../net/wireless/winbond/winbondport/linux/wbusb.c |    3 ++-
 drivers/net/wireless/winbond/winbondport/mlme_s.h  |    2 +-
 .../net/wireless/winbond/winbondport/mlmetxrx.c    |   11 +----------
 4 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
index 6ce7905..be877fd 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
@@ -92,6 +92,7 @@ void Wb35Tx_complete(struct urb * pUrb)
 	PWB35TX		pWb35Tx = &pHwData->Wb35Tx;
 	PMDS		pMds = &Adapter->Mds;
 
+	printk("wb35: tx complete\n");
 	// Variable setting
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
 	pWb35Tx->EP4VM_status = pUrb->status; //Store the last result of Irp
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 6d08071..cc48892 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -114,9 +114,10 @@ static int wbsoft_tx(struct ieee80211_hw
 		      struct ieee80211_tx_control *control)
 {
 	char *buffer = kmalloc(skb->len, GFP_ATOMIC);
+	printk("Sending frame %d bytes\n", skb->len);
 	memcpy(buffer, skb->data, skb->len);
 	if (1 == MLMESendFrame(my_adapter, buffer, skb->len, FRAME_TYPE_802_11_MANAGEMENT))
-		printk("frame sent ok?\n");
+		printk("frame sent ok (%d bytes)?\n", skb->len);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_s.h b/drivers/net/wireless/winbond/winbondport/mlme_s.h
index ade89e4..29ca71b 100644
--- a/drivers/net/wireless/winbond/winbondport/mlme_s.h
+++ b/drivers/net/wireless/winbond/winbondport/mlme_s.h
@@ -112,7 +112,7 @@ #define MLMEMSG_TIMEOUT					0x50
 ///////////////////////////////////////////////////////////////////////////
 //Global data structures
 #define MAX_NUM_TX_MMPDU	2
-#define MAX_MMPDU_SIZE		512
+#define MAX_MMPDU_SIZE		1512
 #define MAX_NUM_RX_MMPDU	6
 
 
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
index bff42c7..ce70d3f 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
@@ -134,22 +134,13 @@ void
 MLME_SendComplete(PADAPTER Adapter, u8 PacketID, unsigned char SendOK)
 {
 	MLME_TXCALLBACK	TxCallback;
-	u8		DataTmp[200];
-
-	memcpy(DataTmp, Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len);
 
     // Reclaim the data buffer
 	Adapter->sMlmeFrame.len = 0;
 	MLMEfreeMMPDUBuffer( Adapter, Adapter->sMlmeFrame.pMMPDU );
 
 
-	//TODO : ?? The pData has been returned, but we still use it to know what kind
-	//			of mlme frame it is. Will it be dangerous??
-	TxCallback.psFramePtr = DataTmp;
-	if (SendOK)
-		TxCallback.bResult = MLME_SUCCESS;
-	else
-		TxCallback.bResult = TRANSMIT_FRAME_FAIL;
+	TxCallback.bResult = MLME_SUCCESS;
 
 	// Return resource
 	Adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;



!-------------------------------------------------------------flip-




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
