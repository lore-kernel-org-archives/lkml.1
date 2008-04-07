Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYDGWlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYDGWlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYDGWlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:41:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38670 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYDGWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:40:59 -0400
Date: Tue, 8 Apr 2008 00:41:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: some more cleanups
Message-ID: <20080407224133.GA22853@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more cleanups for today. I took a look at transmit/receive paths,
and they seem to be reasonably simple, maybe softmac conversion will
not be that hard to do...?

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c b/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
index 3fa841f..9809139 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
@@ -10,7 +10,7 @@ extern void phy_calibration_winbond(hw_d
 // Flag : AUTO_INCREMENT - RegisterNo will auto increment 4
 //		  NO_INCREMENT - Function will write data into the same register
 unsigned char
-Wb35Reg_BurstWrite(  phw_data_t pHwData,  u16 RegisterNo,  PULONG pRegisterData,  u8 NumberOfData,  u8 Flag )
+Wb35Reg_BurstWrite(phw_data_t pHwData, u16 RegisterNo, PULONG pRegisterData, u8 NumberOfData, u8 Flag)
 {
 	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
 	PURB		pUrb = NULL;
@@ -70,7 +70,7 @@ Wb35Reg_BurstWrite(  phw_data_t pHwData,
 }
 
 void
-Wb35Reg_Update(  phw_data_t pHwData,  u16 RegisterNo,  u32 RegisterValue )
+Wb35Reg_Update(phw_data_t pHwData,  u16 RegisterNo,  u32 RegisterValue)
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	switch (RegisterNo) {
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
index ea70d84..f9d2b82 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
@@ -26,11 +26,11 @@ void Wb35Rx_start(phw_data_t pHwData)
 // This function cannot reentrain
 void Wb35Rx(  phw_data_t pHwData )
 {
-	PWB35RX		pWb35Rx = &pHwData->Wb35Rx;
-	PUCHAR		pRxBufferAddress;
-	PURB		pUrb = (PURB)pWb35Rx->RxUrb;
-	int		retv;
-	u32		RxBufferId;
+	PWB35RX	pWb35Rx = &pHwData->Wb35Rx;
+	PUCHAR	pRxBufferAddress;
+	PURB	pUrb = (PURB)pWb35Rx->RxUrb;
+	int	retv;
+	u32	RxBufferId;
 
 	//
 	// Issuing URB
@@ -183,14 +183,14 @@ void Wb35Rx_stop(phw_data_t pHwData)
 
 	// Canceling the Irp if already sends it out.
 	if (pWb35Rx->EP3vm_state == VM_RUNNING) {
-		usb_unlink_urb( pWb35Rx->RxUrb ); // Only use unlink, let Wb35Rx_destrot to free them
+		usb_unlink_urb( pWb35Rx->RxUrb ); // Only use unlink, let Wb35Rx_destroy to free them
 		#ifdef _PE_RX_DUMP_
 		WBDEBUG(("EP3 Rx stop\n"));
 		#endif
 	}
 }
 
-// Only can be run in passive-level
+// Needs process context
 void Wb35Rx_destroy(phw_data_t pHwData)
 {
 	PWB35RX pWb35Rx = &pHwData->Wb35Rx;
@@ -200,7 +200,7 @@ void Wb35Rx_destroy(phw_data_t pHwData)
 	} while (pWb35Rx->EP3vm_state != VM_STOP);
 	OS_SLEEP(10000); // Delay for waiting function exit 940623.1.b
 
-	if( pWb35Rx->RxUrb )
+	if (pWb35Rx->RxUrb)
 		usb_free_urb( pWb35Rx->RxUrb );
 	#ifdef _PE_RX_DUMP_
 	WBDEBUG(("Wb35Rx_destroy OK\n"));
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
index 401ddbf..a5b26ec 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
@@ -25,9 +25,9 @@ void Wb35Tx_start(phw_data_t pHwData)
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	// Allow only one thread to run into function
-	if( OS_ATOMIC_INC( pHwData->Adapter, &pWb35Tx->TxFireCounter ) == 1 ) {
+	if (OS_ATOMIC_INC(pHwData->Adapter, &pWb35Tx->TxFireCounter) == 1) {
 		pWb35Tx->EP4vm_state = VM_RUNNING;
-		Wb35Tx( pHwData );
+		Wb35Tx(pHwData);
 	} else
 		OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Tx->TxFireCounter );
 }
@@ -39,56 +39,55 @@ void Wb35Tx(phw_data_t pHwData)
 	PADAPTER	Adapter = pHwData->Adapter;
 	PUCHAR		pTxBufferAddress;
 	PMDS		pMds = &Adapter->Mds;
-	PURB		pUrb = (PURB)pWb35Tx->Tx4Urb;
+	struct urb *		pUrb = (struct urb *)pWb35Tx->Tx4Urb;
 	int         retv;
 	u32		SendIndex;
 
 
-	do {
-		if (pHwData->SurpriseRemove || pHwData->HwStop)
-			break;
-
-		if (pWb35Tx->tx_halt)
-			break;
-
-		// Ownership checking
-		SendIndex = pWb35Tx->TxSendIndex;
-		if (!pMds->TxOwner[SendIndex]) //No more data need to be sent, return immediately
-			break;
-
-		pTxBufferAddress = pWb35Tx->TxBuffer[SendIndex];
-		//
-		// Issuing URB
-		//
-		usb_fill_bulk_urb(pUrb, pHwData->WbUsb.udev,
-				  usb_sndbulkpipe(pHwData->WbUsb.udev, 4),
-				  pTxBufferAddress, pMds->TxBufferSize[ SendIndex ],
-				  Wb35Tx_complete, pHwData);
-
-		pWb35Tx->EP4vm_state = VM_RUNNING;
-		retv = wb_usb_submit_urb( pUrb );
-		if (retv<0) {
-			#ifdef _PE_TX_DUMP_
-			WBDEBUG(("EP4 Tx Irp sending error\n"));
-			#endif
-			break;
-		}
+	if (pHwData->SurpriseRemove || pHwData->HwStop)
+		goto cleanup;
+
+	if (pWb35Tx->tx_halt)
+		goto cleanup;
+
+	// Ownership checking
+	SendIndex = pWb35Tx->TxSendIndex;
+	if (!pMds->TxOwner[SendIndex]) //No more data need to be sent, return immediately
+		goto cleanup;
+
+	pTxBufferAddress = pWb35Tx->TxBuffer[SendIndex];
+	//
+	// Issuing URB
+	//
+	usb_fill_bulk_urb(pUrb, pHwData->WbUsb.udev,
+			  usb_sndbulkpipe(pHwData->WbUsb.udev, 4),
+			  pTxBufferAddress, pMds->TxBufferSize[ SendIndex ],
+			  Wb35Tx_complete, pHwData);
+
+	pWb35Tx->EP4vm_state = VM_RUNNING;
+	retv = wb_usb_submit_urb( pUrb );
+	if (retv<0) {
+#ifdef _PE_TX_DUMP_
+		WBDEBUG(("EP4 Tx Irp sending error\n"));
+#endif
+		goto cleanup;
+	}
 
-		// Check if driver needs issue Irp for EP2
-		pWb35Tx->TxFillCount += pMds->TxCountInBuffer[SendIndex];
-		if( pWb35Tx->TxFillCount > 12 ) // Fixed to 12. 20060928
-			Wb35Tx_EP2VM_start( pHwData );
+	// Check if driver needs issue Irp for EP2
+	pWb35Tx->TxFillCount += pMds->TxCountInBuffer[SendIndex];
+	if( pWb35Tx->TxFillCount > 12 ) // Fixed to 12. 20060928
+		Wb35Tx_EP2VM_start( pHwData );
 
-		pWb35Tx->ByteTransfer += pMds->TxBufferSize[SendIndex];
-		return;
-	} while(FALSE);
+	pWb35Tx->ByteTransfer += pMds->TxBufferSize[SendIndex];
+	return;
 
+ cleanup:
 	pWb35Tx->EP4vm_state = VM_STOP;
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Tx->TxFireCounter );
 }
 
 
-void Wb35Tx_complete(  PURB pUrb )
+void Wb35Tx_complete(struct urb * pUrb)
 {
 	phw_data_t	pHwData = pUrb->context;
 	PADAPTER	Adapter = (PADAPTER)pHwData->Adapter;
@@ -232,8 +231,8 @@ void Wb35Tx_EP2VM_start(  phw_data_t pHw
 
 void Wb35Tx_EP2VM(phw_data_t pHwData)
 {
-    PWB35TX pWb35Tx = &pHwData->Wb35Tx;
-    PURB	pUrb = (PURB)pWb35Tx->Tx2Urb;
+	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
+	struct urb *	pUrb = (struct urb *)pWb35Tx->Tx2Urb;
 	PULONG	pltmp = (PULONG)pWb35Tx->EP2_buf;
 	int		retv;
 
@@ -275,7 +274,7 @@ void Wb35Tx_EP2VM(phw_data_t pHwData)
 }
 
 
-void Wb35Tx_EP2VM_complete(  PURB pUrb )
+void Wb35Tx_EP2VM_complete(struct urb * pUrb)
 {
 	phw_data_t	pHwData = pUrb->context;
 	T02_DESCRIPTOR	T02, TSTATUS;
@@ -290,8 +289,7 @@ void Wb35Tx_EP2VM_complete(  PURB pUrb )
 	pWb35Tx->EP2vm_state = VM_COMPLETED;
 	pWb35Tx->EP2VM_status = pUrb->status;
 
-	do
-	{
+	do {
 		// For Linux 2.4. Interrupt will always trigger
 		if( pHwData->SurpriseRemove || pHwData->HwStop ) // Let WbWlanHalt to handle surprise remove
 			break;
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 4a980e6..62d3e49 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -130,10 +130,6 @@ int wb35_probe( struct usb_interface *in
 		pWbUsb = &Adapter->sHwData.WbUsb;
 		pWbUsb->udev = udev;
 
-		//set the interface name for this device.
-		//dev_alloc_name(	netdev, "wlan%d");
-
-
 	        //Cambiado
 	        interface = intf->cur_altsetting;
 	        endpoint = &interface->endpoint[0].desc;
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb_s.h b/drivers/net/wireless/winbond/winbondport/linux/wbusb_s.h
index 7a775c0..74d72bd 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb_s.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb_s.h
@@ -12,7 +12,7 @@
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
 #define OS_SLEEP( _MT )	{ set_current_state(TASK_INTERRUPTIBLE); \
-							  schedule_timeout( _MT*HZ/1000000 ); }
+			  schedule_timeout( _MT*HZ/1000000 ); }
 
 
 //---------------------------------------------------------------------------
@@ -22,7 +22,7 @@ #define OS_SLEEP( _MT )	{ set_current_st
 //---------------------------------------------------------------------------
 typedef struct _RW_CONTEXT
 {
-    void*			pHwData;
+	void*			pHwData;
 	PURB			pUrb;
 	void*			pCallBackFunctionParameter;
 } RW_CONTEXT, *PRW_CONTEXT;
@@ -30,27 +30,13 @@ typedef struct _RW_CONTEXT
 
 
 
-#define DRIVER_AUTHOR 			"Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>"
-#define DRIVER_DESC				"IS89C35 802.11bg WLAN USB Driver"
+#define DRIVER_AUTHOR "Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>"
+#define DRIVER_DESC   "IS89C35 802.11bg WLAN USB Driver"
 
 
 
-typedef struct _WBUSB
-{
-	// Is USB 2.0
+typedef struct _WBUSB {
 	u32	IsUsb20;
-	struct usb_device *			udev;
+	struct usb_device *udev;
 	u32	DetectCount;
-
 } WBUSB, *PWBUSB;
-
-#if 0 //some Linux don't have usb_ctrlrequest  
-struct usb_ctrlrequest {
-                __u8 bRequestType;
-                __u8 bRequest;
-                __u16 wValue;
-                __u16 wIndex;
-                __u16 wLength;
-} __attribute__ ((packed));
-#endif 
-
diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index 3cb7d4a..2d06cd9 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -43,7 +43,7 @@ Mds_Tx(PADAPTER Adapter)
 	PUCHAR		XmitBufAddress;
 	u16		XmitBufSize, PacketSize, stmp, CurrentSize, FragmentThreshold;
 	u8		FillIndex, TxDesIndex, PacketFrom, FragmentCount, FillCount;
-	unsigned char		BufferFilled = FALSE, MICAdd;
+	unsigned char	BufferFilled = FALSE, MICAdd;
 
 
 	//931130.5.a
@@ -54,14 +54,11 @@ Mds_Tx(PADAPTER Adapter)
 		return;
 
 	//Only one thread can be run here
-	if( OS_ATOMIC_INC( Adapter, &pMds->TxThreadCount ) == 1 )
-	{
+	if (OS_ATOMIC_INC( Adapter, &pMds->TxThreadCount) == 1)	{
 		// Start to fill the data
-		do
-		{
+		do {
 			FillIndex = pMds->TxFillIndex;
-			if( pMds->TxOwner[FillIndex] ) // Is owned by software 0:Yes 1:No
-			{
+			if (pMds->TxOwner[FillIndex]) { // Is owned by software 0:Yes 1:No
 				#ifdef _PE_TX_DUMP_
 				WBDEBUG(("[Mds_Tx] Tx Owner is H/W.\n"));
 				#endif
@@ -71,25 +68,22 @@ Mds_Tx(PADAPTER Adapter)
 			XmitBufAddress = pMds->pTxBuffer + (MAX_USB_TX_BUFFER * FillIndex); //Get buffer
 			XmitBufSize = 0;
 			FillCount = 0;
-			do
-			{
+			do {
 				// Sending packet path
 				PacketFrom = 1;
 				PacketSize = QUERY_SIZE_FIRST( Adapter );
-				if( !PacketSize )
-				{
+				if (!PacketSize) {
 					if( !TS_RUNNING_IN_TESTSTA_MODE ) // If driver doesn't run in test mode, send MLME and normal data frame
 					{
 						PacketFrom = 2;
-						PacketSize = QUERY_SIZE_SECOND( Adapter );
-						if( !PacketSize )
-						{
+						PacketSize = QUERY_SIZE_SECOND(Adapter);
+						if( !PacketSize ) {
 							if( pMds->ScanTxPause )	//No management frames to transmit.
 								break;				//The scanning is progressing, so stop the data
 												//frames transmission
 							PacketFrom = 3;
 							PacketSize = QUERY_SIZE_THIRD( Adapter );
-							if( !PacketSize )
+							if (!PacketSize)
 								break;
 						}
 					}
@@ -102,8 +96,7 @@ Mds_Tx(PADAPTER Adapter)
 				//931130.5.b
 				FragmentCount = PacketSize/FragmentThreshold + 1;
 				stmp = PacketSize + FragmentCount*32 + 8;//931130.5.c 8:MIC
-				if( (XmitBufSize + stmp) >= MAX_USB_TX_BUFFER )
-				{
+				if ((XmitBufSize + stmp) >= MAX_USB_TX_BUFFER) {
 					#ifdef _PE_TX_DUMP_
 					WBDEBUG(("[Mds_Tx] Excess max tx buffer.\n"));
 					#endif
@@ -124,19 +117,18 @@ Mds_Tx(PADAPTER Adapter)
 				pMds->TxDesIndex %= MAX_USB_TX_DESCRIPTOR;
 
 				// Get packet to transmit, 1:TESTSTA 2:MLME 3: Ndis data
-				if( PacketFrom == 3 )
+				if (PacketFrom == 3)
 					{ GET_DESCRIPTOR_THIRD( Adapter, pTxDes ); }
-				else if( PacketFrom == 2 )
+				else if (PacketFrom == 2)
 					{ GET_DESCRIPTOR_SECOND( Adapter, pTxDes ); }
-				else if( PacketFrom == 1 )
+				else if (PacketFrom == 1)
 					{ GET_DESCRIPTOR_FIRST( Adapter, pTxDes ); }
 
 				// Copy header. 8byte USB + 24byte 802.11Hdr. Set TxRate, Preamble type
 				Mds_HeaderCopy( Adapter, pTxDes, XmitBufAddress );
 
 				// For speed up Key setting
-				if( pTxDes->EapFix )
-				{
+				if (pTxDes->EapFix) {
 					#ifdef _PE_TX_DUMP_
 					WBDEBUG(("35: EPA 4th frame detected. Size = %d\n", PacketSize));
 					#endif
@@ -146,8 +138,7 @@ Mds_Tx(PADAPTER Adapter)
 				//
 				// Add MIC redundant 8 byte in pTxDes, assume that TKIP encryption and wep bit = 1
 				MICAdd = (CURRENT_ENCRYPT_STATUS==ENCRYPT_TKIP) && (XmitBufAddress[9]&0x40);
-				if( MICAdd )
-				{
+				if (MICAdd) {
 					pMds->MicAdd = 8;
 					pMds->MicWriteIndex = 0;
 					DESCRIPTOR_ADD_BUFFER( pTxDes, pMds->MicRedundant, 8 );
@@ -176,17 +167,16 @@ Mds_Tx(PADAPTER Adapter)
 
 				//---------------------
 				//Check Power save
-				if (psSME->bDesiredPowerSave)
-				{
+				if (psSME->bDesiredPowerSave) {
 					if ((psLOCAL->wConnectedSTAindex == 0) ||
-							((psLOCAL->wConnectedSTAindex != 0) &&
-								 (psBSS(psLOCAL->wConnectedSTAindex)->bBssType == ESS_NET)))
+					    ((psLOCAL->wConnectedSTAindex != 0) &&
+					     (psBSS(psLOCAL->wConnectedSTAindex)->bBssType == ESS_NET)))
 					{
 						psLOCAL->boHasTxActivity = 1;
 						if (psLOCAL->iPowerSaveMode == PWR_SAVE)
 						{
 							K_MSG	sSmeMsg;
-							u8		PsMode;
+							u8	PsMode;
 
 							//wake up the H/W
 							PsMode =  PWR_ACTIVE;
@@ -199,8 +189,7 @@ Mds_Tx(PADAPTER Adapter)
 
 				#ifdef _PE_TX_DUMP_
 				WBDEBUG((">>Send MSDU\n"));
-				if (XmitBufSize > 0)
-				{
+				if (XmitBufSize > 0) {
 					PUCHAR ptr;
 
 					ptr = pMds->pTxBuffer + (MAX_USB_TX_BUFFER * FillIndex);
@@ -210,11 +199,11 @@ Mds_Tx(PADAPTER Adapter)
 				#endif
 
 				// Get packet to transmit completed, 1:TESTSTA 2:MLME 3: Ndis data
-				if( PacketFrom == 3 )
+				if (PacketFrom == 3)
 					{ GET_DESCRIPTOR_THIRD_COMPLETED( Adapter, pTxDes ); }
-				else if( PacketFrom == 2 )
+				else if (PacketFrom == 2)
 					{ GET_DESCRIPTOR_SECOND_COMPLETED( Adapter, pTxDes ); }
-				else if( PacketFrom == 1 )
+				else if (PacketFrom == 1)
 					{ GET_DESCRIPTOR_FIRST_COMPLETED( Adapter, pTxDes ); }
 
 				// Software TSC count 20060214
@@ -224,11 +213,10 @@ Mds_Tx(PADAPTER Adapter)
 
 				FillCount++; // 20060928
 
-			}while( HAL_USB_MODE_BURST(pHwData) );// End of multiple MSDU copy loop. FALSE = single TRUE = multiple sending
+			} while (HAL_USB_MODE_BURST(pHwData)); // End of multiple MSDU copy loop. FALSE = single TRUE = multiple sending
 
 			// Move to the next one, if necessary
-			if( BufferFilled )
-			{
+			if (BufferFilled) {
 				// size setting
 				pMds->TxBufferSize[ FillIndex ] = XmitBufSize;
 
@@ -245,16 +233,16 @@ Mds_Tx(PADAPTER Adapter)
 			else
 				break;
 
-			if( !PacketSize )// No more pk for transmitting
+			if (!PacketSize) // No more pk for transmitting
 				break;
 
-		}while(TRUE);
+		} while(TRUE);
 
 		//
 		// Start to send by lower module
 		//
-		if( !pHwData->IsKeyPreSet )
-			Wb35Tx_start( pHwData );
+		if (!pHwData->IsKeyPreSet)
+			Wb35Tx_start(pHwData);
 	}
 
 	OS_ATOMIC_DEC( Adapter, &pMds->TxThreadCount );
diff --git a/drivers/net/wireless/winbond/winbondport/reg.c b/drivers/net/wireless/winbond/winbondport/reg.c
index 34d963a..2a30f32 100644
--- a/drivers/net/wireless/winbond/winbondport/reg.c
+++ b/drivers/net/wireless/winbond/winbondport/reg.c
@@ -1043,10 +1043,8 @@ void Set_ChanIndep_RfData_al7230_50(  ph
 // RFSynthesizer_initial --
 //=============================================================================================================
 void
-RFSynthesizer_initial(  phw_data_t pHwData )
+RFSynthesizer_initial(phw_data_t pHwData)
 {
-//	PADAPTER Adapter = pHwData->Adapter;
-//	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
 	u32	altmp[32];
 	PULONG	pltmp = altmp;
 	u32	ltmp;
diff --git a/drivers/net/wireless/winbond/winbondport/sme_api.c b/drivers/net/wireless/winbond/winbondport/sme_api.c
index b0726dd..00cb7f0 100644
--- a/drivers/net/wireless/winbond/winbondport/sme_api.c
+++ b/drivers/net/wireless/winbond/winbondport/sme_api.c
@@ -27,8 +27,7 @@ s8 sme_get_bssid(void *pcore_data, u8 *p
 {
 	PWB32_ADAPTER	Adapter = (PWB32_ADAPTER)pcore_data;
 
-	if(psLOCAL->wConnectedSTAindex)
-	{
+	if(psLOCAL->wConnectedSTAindex) {
 		memcpy( pbssid, psBSS(psLOCAL->wConnectedSTAindex)->abBssID, MAC_ADDR_LENGTH );
 		return 0;
 	}
@@ -39,7 +38,7 @@ s8 sme_get_desired_bssid(void *pcore_dat
 {
 	PWB32_ADAPTER	Adapter = (PWB32_ADAPTER)pcore_data;
 
-	memcpy( pbssid, psSME->abDesiredBSSID, MAC_ADDR_LENGTH );
+	memcpy(pbssid, psSME->abDesiredBSSID, MAC_ADDR_LENGTH);
 	return 0;
 } 
 
@@ -47,7 +46,7 @@ s8 sme_set_desired_bssid(void *pcore_dat
 {
 	PWB32_ADAPTER	Adapter = (PWB32_ADAPTER)pcore_data;
 
-	memcpy( psSME->abDesiredBSSID, pbssid, MAC_ADDR_LENGTH );
+	memcpy(psSME->abDesiredBSSID, pbssid, MAC_ADDR_LENGTH);
 	return 0;
 }
 
@@ -55,8 +54,7 @@ s8 sme_get_ssid(void *pcore_data, u8 *ps
 {
 	PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
 
-	if(psLOCAL->wConnectedSTAindex)
-	{
+	if(psLOCAL->wConnectedSTAindex)	{
 		*pssid_len = psBSS(psLOCAL->wConnectedSTAindex)->SSID.Length;
 		memcpy( pssid, psBSS(psLOCAL->wConnectedSTAindex)->SSID.SSID, *pssid_len );
 		return 0;
@@ -225,8 +223,7 @@ s8 sme_get_atim_window(void *pcore_data,
 {
 	PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
 
-	if(psLOCAL->wConnectedSTAindex)
-	{
+	if (psLOCAL->wConnectedSTAindex) {
 		*patim_window = *(u16 *)psBSS(psLOCAL->wConnectedSTAindex)->IBSS_Parameter_Set.ATIM_Window;
 		return 0;
 	}
@@ -245,8 +242,7 @@ s8 sme_get_current_channel(void *pcore_d
 {
 	PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
 
-	if(psLOCAL->wConnectedSTAindex)
-	{
+	if (psLOCAL->wConnectedSTAindex) {
 		*pcurrent_channel = psBSS(psLOCAL->wConnectedSTAindex)->DS_Parameter_Set.Current_Channel;
 		return 0;
 	}
@@ -257,8 +253,7 @@ s8 sme_get_current_band(void *pcore_data
 {
 	PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
 
-	if(psLOCAL->wConnectedSTAindex)
-	{
+	if (psLOCAL->wConnectedSTAindex) {
 		*pcurrent_band = psBSS(psLOCAL->wConnectedSTAindex)->band;
 		return 0;
 	}
@@ -267,9 +262,6 @@ s8 sme_get_current_band(void *pcore_data
 
 s8 sme_set_current_channel(void *pcore_data, u8 current_channel)
 {
-	//PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
-
-	//psSME->bCurrentChannel = current_channel;
 	return 0;
 }
 
@@ -295,8 +287,7 @@ s8 sme_get_connected_bss(void *pcore_dat
 {
 	PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
 
-	if(psLOCAL->wConnectedSTAindex)
-	{
+	if(psLOCAL->wConnectedSTAindex)	{
 		*ppbss_now = psBSS(psLOCAL->wConnectedSTAindex);
 		return 0;
 	}
@@ -319,32 +310,6 @@ s8 sme_set_auth_mode(void *pcore_data, u
 	return 0;
 }
 
-//replace by sme_get_encryption_status and sme_set_encryption_status
-/*
-s8 sme_get_wep_mode(void *pcore_data, u8 *pwep_mode)
-{
-	PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
-
-	*pwep_mode = psSME->_dot11PrivacyInvoked;
-	return 0;
-}
-
-s8 sme_set_wep_mode(void *pcore_data, u8 wep_mode)
-{
-	PWB32_ADAPTER Adapter = (PWB32_ADAPTER)pcore_data;
-
-	psSME->_dot11PrivacyInvoked           = wep_mode;
-	psSME->_dot11PrivacyOptionImplemented = wep_mode;
-	if(wep_mode)
-		psSME->_WEPKeyLength = (psSME->key_length==5) ? WEPKEY_64 : WEPKEY_128;
-	else
-		psSME->_WEPKeyLength = WEPKEY_DISABLED;
-
-	//??clear WEP table or not because WEP mode change??
-	return 0;
-}
-*/
-
 s8 sme_set_add_wep(void *pcore_data, u32 key_index, u32 key_len,
 					u8 *address, u8 *key)
 {
@@ -353,8 +318,7 @@ s8 sme_set_add_wep(void *pcore_data, u32
 	s8 ret = -1;
 	u8		key_type;
 
-	do
-	{
+	do {
 		#ifdef _PE_STATE_DUMP_
 		WBDEBUG(("OID Key idx =[%x] length = %d Content = ", key_index, key_len));
 		for(i=0; i<key_len; i++)
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index f095534..9220e80 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -12,7 +12,7 @@ #include "os_common.h"
 #include "linux/new_wireless.h"
 
 u32
-WBLINUX_MemoryAlloc(  void* *VirtualAddress,  u32 Length )
+WBLINUX_MemoryAlloc(void* *VirtualAddress, u32 Length)
 {
 	*VirtualAddress = kmalloc( Length, GFP_ATOMIC ); //GFP_KERNEL is not suitable
 
@@ -22,20 +22,20 @@ WBLINUX_MemoryAlloc(  void* *VirtualAddr
 }
 
 s32
-  EncapAtomicInc(  PADAPTER Adapter,  void* pAtomic )
+EncapAtomicInc(  PADAPTER Adapter,  void* pAtomic )
 {
-   PWBLINUX	pWbLinux = &Adapter->WbLinux;
-   u32	ltmp;
-   PULONG	pltmp = (PULONG)pAtomic;
-   OS_SPIN_LOCK_ACQUIRED( &pWbLinux->AtomicSpinLock );
-   (*pltmp)++;
-   ltmp = (*pltmp);
-   OS_SPIN_LOCK_RELEASED( &pWbLinux->AtomicSpinLock );
-   return ltmp;
+	PWBLINUX	pWbLinux = &Adapter->WbLinux;
+	u32	ltmp;
+	PULONG	pltmp = (PULONG)pAtomic;
+	OS_SPIN_LOCK_ACQUIRED( &pWbLinux->AtomicSpinLock );
+	(*pltmp)++;
+	ltmp = (*pltmp);
+	OS_SPIN_LOCK_RELEASED( &pWbLinux->AtomicSpinLock );
+	return ltmp;
 }
 
 s32
-  EncapAtomicDec(  PADAPTER Adapter,  void* pAtomic )
+EncapAtomicDec(  PADAPTER Adapter,  void* pAtomic )
 {
    PWBLINUX	pWbLinux = &Adapter->WbLinux;
    u32	ltmp;
@@ -48,137 +48,128 @@ s32
 }
 
 unsigned char
-  WBLINUX_Initial(  PADAPTER Adapter )
+WBLINUX_Initial(  PADAPTER Adapter )
 {
-   PWBLINUX pWbLinux = &Adapter->WbLinux;
+	PWBLINUX pWbLinux = &Adapter->WbLinux;
 
-   OS_SPIN_LOCK_ALLOCATE( &pWbLinux->SpinLock );
-   OS_SPIN_LOCK_ALLOCATE( &pWbLinux->AtomicSpinLock );
-   pWbLinux->netdev->open = wb35_open;
-   pWbLinux->netdev->stop = wb35_close;
-   pWbLinux->netdev->hard_start_xmit = wb35_start_xmit;
-   pWbLinux->netdev->set_multicast_list = wb35_set_multicast;
-   pWbLinux->netdev->get_stats = wb35_netdev_stats;
-   pWbLinux->netdev->wireless_handlers = (struct iw_handler_def *)&test_iw_handlers;
+	OS_SPIN_LOCK_ALLOCATE( &pWbLinux->SpinLock );
+	OS_SPIN_LOCK_ALLOCATE( &pWbLinux->AtomicSpinLock );
+	pWbLinux->netdev->open = wb35_open;
+	pWbLinux->netdev->stop = wb35_close;
+	pWbLinux->netdev->hard_start_xmit = wb35_start_xmit;
+	pWbLinux->netdev->set_multicast_list = wb35_set_multicast;
+	pWbLinux->netdev->get_stats = wb35_netdev_stats;
+	pWbLinux->netdev->wireless_handlers = (struct iw_handler_def *)&test_iw_handlers;
 
-   return TRUE;
+	return TRUE;
 }
 
 void
-  WBLinux_ReceivePacket(  PADAPTER Adapter,  PRXLAYER1 pRxLayer1 )
+WBLinux_ReceivePacket(PADAPTER Adapter, PRXLAYER1 pRxLayer1)
 {
-   PWBLINUX pWbLinux = &Adapter->WbLinux;
-   struct sk_buff *skb = NULL;
-   PUCHAR		BufAddr;
-   u32		ByteCount = 0;
-   u32		i;
-   u16		BufSize;
-
-   for( i=0; i<pRxLayer1->BufferNumber; i++ )
-     {
-	BufSize = pRxLayer1->BufferQueue[i].BufferSize;
-	ByteCount += BufSize;
-     }
+	PWBLINUX pWbLinux = &Adapter->WbLinux;
+	struct sk_buff *skb = NULL;
+	PUCHAR		BufAddr;
+	u32		ByteCount = 0;
+	u32		i;
+	u16		BufSize;
+
+	for( i=0; i<pRxLayer1->BufferNumber; i++ ) {
+		BufSize = pRxLayer1->BufferQueue[i].BufferSize;
+		ByteCount += BufSize;
+	}
 #ifdef _PE_RX_DUMP_
-   WBDEBUG(( "[w35und]---> Rx total length =%d BuffNum=%d\n", ByteCount, pRxLayer1->BufferNumber ));
+	WBDEBUG(( "[w35und]---> Rx total length =%d BuffNum=%d\n", ByteCount, pRxLayer1->BufferNumber ));
 #endif
 
-   if( (skb = dev_alloc_skb( ByteCount + 2 )) != NULL )
-     {
-        skb->dev = pWbLinux->netdev;
-        skb_reserve( skb, 2 );
+	if ((skb = dev_alloc_skb( ByteCount + 2 )) != NULL) {
+		skb->dev = pWbLinux->netdev;
+		skb_reserve( skb, 2 );
         
-	for( i=0; i<pRxLayer1->BufferNumber; i++ )
-	  {
-	     BufSize = pRxLayer1->BufferQueue[i].BufferSize;
-	     BufAddr = pRxLayer1->BufferQueue[i].pBufferAddress;
-	     // I Think this fits better - Scythe - 
-	     memcpy(skb->data,BufAddr,BufSize);
-	     skb_put( skb, BufSize );
-	  }
-
-        skb->protocol = eth_type_trans( skb, pWbLinux->netdev );
-
-        netif_rx( skb );
-        pWbLinux->netdev->last_rx = jiffies;
-	pWbLinux->stats.rx_packets ++;
-	pWbLinux->stats.rx_bytes += ByteCount;
-     }
-   else
-     {
+		for (i=0; i<pRxLayer1->BufferNumber; i++) {
+			BufSize = pRxLayer1->BufferQueue[i].BufferSize;
+			BufAddr = pRxLayer1->BufferQueue[i].pBufferAddress;
+			// I Think this fits better - Scythe - 
+			memcpy(skb->data, BufAddr, BufSize);
+			skb_put( skb, BufSize );
+		}
+
+		skb->protocol = eth_type_trans( skb, pWbLinux->netdev );
+
+		netif_rx( skb );
+		pWbLinux->netdev->last_rx = jiffies;
+		pWbLinux->stats.rx_packets ++;
+		pWbLinux->stats.rx_bytes += ByteCount;
+	} else {
 #ifdef _PE_RX_DUMP_
-	WBDEBUG(( "[w35und]RX SKB ALLOCATE IS FAILED !\n" ));
+		WBDEBUG(( "[w35und]RX SKB ALLOCATE IS FAILED !\n" ));
 #endif
-     }
+	}
 }
 
-int wb35_start_xmit( struct sk_buff *skb, struct net_device *netdev )
+int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
-   PADAPTER	Adapter = netdev->priv;
-   PWBLINUX	pWbLinux = &Adapter->WbLinux;
-   PUCHAR		pBufAddress = (PUCHAR)skb->data;
-   unsigned char		IsStop = FALSE;
+	PADAPTER	Adapter = netdev->priv;
+	PWBLINUX	pWbLinux = &Adapter->WbLinux;
+	PUCHAR		pBufAddress = (PUCHAR)skb->data;
+	unsigned char		IsStop = FALSE;
 
 #ifdef _PE_TX_DUMP_
-   WBDEBUG(( "[w35und]wb35_start_xmit->\n" ));
-   WBDEBUG(( "[w35und]skb=%x size=%d\n", skb, skb->len ));
+	WBDEBUG(( "[w35und]wb35_start_xmit->\n" ));
+	WBDEBUG(( "[w35und]skb=%x size=%d\n", skb, skb->len ));
 #endif
 
-   // Basic check ---------------------------------------------------
-   if( !skb || (skb->len<(DOT_3_TYPE_OFFSET+2)) || pWbLinux->shutdown || !CURRENT_LINK_ON ||
-       (
+	// Basic check ---------------------------------------------------
+	if (!skb || (skb->len<(DOT_3_TYPE_OFFSET+2)) || pWbLinux->shutdown || !CURRENT_LINK_ON ||
+	    (
 #ifdef _WPA2_
-	CURRENT_DESIRED_WPA2_ENABLE &&
-#endif //end def _WPA2_
-	CURRENT_DESIRED_WPA_ENABLE && CURRENT_CONTROL_PORT_BLOCK && (*(PUSHORT)(pBufAddress+12) != cpu_to_le16(0x8e88)) ) || \
-			((psLOCAL->RadioOffStatus.boHwRadioOff == TRUE) || (psLOCAL->RadioOffStatus.boSwRadioOff == TRUE)) )
-     {
+		    CURRENT_DESIRED_WPA2_ENABLE &&
+#endif
+		    CURRENT_DESIRED_WPA_ENABLE && CURRENT_CONTROL_PORT_BLOCK && (*(PUSHORT)(pBufAddress+12) != cpu_to_le16(0x8e88)) ) || \
+	    ((psLOCAL->RadioOffStatus.boHwRadioOff == TRUE) || (psLOCAL->RadioOffStatus.boSwRadioOff == TRUE))) {
 #ifdef _PE_TX_DUMP_
-	WBDEBUG(( "[w35und] wb35_start_xmit SK_BUFF IS NOT OK ! len=%d\n", skb->len ));
+		WBDEBUG(( "[w35und] wb35_start_xmit SK_BUFF IS NOT OK ! len=%d\n", skb->len ));
 #endif
-        dev_kfree_skb( skb );
-	return 0; // Ignore this packet
-     }
-
-   // Check room space ---------------------------------------------
-   if( pWbLinux->skb_array[ pWbLinux->skb_SetIndex ] )
-     return -EBUSY;
-
-   // Storing skb into skb_array and move point --------------------
-   pWbLinux->skb_array[ pWbLinux->skb_SetIndex ] = skb;
-   pWbLinux->skb_SetIndex++;
-   pWbLinux->skb_SetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
-
-   // Does driver need to stop OS sending?
-   if( (pWbLinux->skb_array[pWbLinux->skb_SetIndex]!=NULL) && !pWbLinux->netif_state_stop )
-     {
-	OS_SPIN_LOCK_ACQUIRED( &pWbLinux->SpinLock );
-	if( !pWbLinux->netif_state_stop )
-	  {
-	     pWbLinux->netif_state_stop = 1;
-	     IsStop = TRUE;
-	  }
-	OS_SPIN_LOCK_RELEASED( &pWbLinux->SpinLock );
-
-	if( IsStop )
-	  {
+		dev_kfree_skb( skb );
+		return 0; // Ignore this packet
+	}
+
+	// Check room space ---------------------------------------------
+	if (pWbLinux->skb_array[pWbLinux->skb_SetIndex])
+		return -EBUSY;
+
+	// Storing skb into skb_array and move point --------------------
+	pWbLinux->skb_array[ pWbLinux->skb_SetIndex ] = skb;
+	pWbLinux->skb_SetIndex++;
+	pWbLinux->skb_SetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
+
+	// Does driver need to stop OS sending?
+	if ((pWbLinux->skb_array[pWbLinux->skb_SetIndex]!=NULL) && !pWbLinux->netif_state_stop) {
+		OS_SPIN_LOCK_ACQUIRED( &pWbLinux->SpinLock );
+		if (!pWbLinux->netif_state_stop) {
+			pWbLinux->netif_state_stop = 1;
+			IsStop = TRUE;
+		}
+		OS_SPIN_LOCK_RELEASED( &pWbLinux->SpinLock );
+
+		if (IsStop) {
 #ifdef _PE_TX_DUMP_
-	     WBDEBUG(("[w35und] tx netif stop"));
+			WBDEBUG(("[w35und] tx netif stop"));
 #endif
-	     netif_stop_queue( netdev );
-	  }
-     }
+			netif_stop_queue( netdev );
+		}
+	}
 
-   // Calling Mds for sending packet --------------------
-   Adapter->sLocalPara._NumTxMSDU++;
-   netdev->trans_start=jiffies;
-   Mds_Tx( Adapter );
+	// Calling Mds for sending packet --------------------
+	Adapter->sLocalPara._NumTxMSDU++;
+	netdev->trans_start=jiffies;
+	Mds_Tx( Adapter );
 
-   return 0;// return 1 if asking kernel retry to send sk-buffer.
+	return 0;// return 1 if asking kernel retry to send sk-buffer.
 }
 
 void
-  WBLINUX_GetNextPacket(  PADAPTER Adapter,  PDESCRIPTOR pDes )
+WBLINUX_GetNextPacket(  PADAPTER Adapter,  PDESCRIPTOR pDes )
 {
    PWBLINUX	pWbLinux = &Adapter->WbLinux;
    struct sk_buff  *pSkb;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
