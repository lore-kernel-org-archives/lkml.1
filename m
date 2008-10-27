Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYJ0VfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYJ0VfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJ0Vev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:34:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49243 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYJ0Veu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:34:50 -0400
Date: Mon, 27 Oct 2008 23:34:49 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] w35und: remove dead code from wbusb_f.h
In-Reply-To: <20081027211452.GA19762@kroah.com>
Message-ID: <Pine.LNX.4.64.0810272334150.9093@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI>
 <20081027183707.GA13737@kroah.com> <Pine.LNX.4.64.0810272241520.7338@melkki.cs.Helsinki.FI>
 <20081027211452.GA19762@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Greg KH wrote:
> This seems to be because wb_usb_submit_urb() and alloc_urb() are in the
> drivers/staging/winbond/linux/wbusb_f.h file when it is removed.
> 
> I'll go fix this up by adding another patch removing these entries.
> Don't know how they got in here, odd.

That's because I forgot to send the following patch. Sorry about that.

		Pekka

>From 564d8ad6fd7b72ac7b5c10ebc56b5c3180cd9cc0 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 22 Oct 2008 18:29:13 +0300
Subject: [PATCH] w35und: usb urb wrapper removal

This patch removes the useless wb_usb_{submit|alloc}_urb() wrappers from driver
code.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/wb35reg.c |   10 +++++-----
 drivers/staging/winbond/linux/wb35rx.c  |    4 ++--
 drivers/staging/winbond/linux/wb35tx.c  |    8 ++++----
 drivers/staging/winbond/linux/wbusb_f.h |    3 ---
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/winbond/linux/wb35reg.c b/drivers/staging/winbond/linux/wb35reg.c
index d716c19..4467c7a 100644
--- a/drivers/staging/winbond/linux/wb35reg.c
+++ b/drivers/staging/winbond/linux/wb35reg.c
@@ -26,7 +26,7 @@ Wb35Reg_BurstWrite(phw_data_t pHwData, u16 RegisterNo, u32 * pRegisterData, u8 N
 	// Trying to use burst write function if use new hardware
 	UrbSize = sizeof(struct wb35_reg_queue) + DataSize + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if( urb && reg_queue ) {
 		reg_queue->DIRECT = 2;// burst write register
 		reg_queue->INDEX = RegisterNo;
@@ -175,7 +175,7 @@ Wb35Reg_Write(  phw_data_t pHwData,  u16 RegisterNo,  u32 RegisterValue )
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
 		reg_queue->DIRECT = 1;// burst write register
 		reg_queue->INDEX = RegisterNo;
@@ -235,7 +235,7 @@ Wb35Reg_WriteWithCallbackValue( phw_data_t pHwData, u16 RegisterNo, u32 Register
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC((void* *) &reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
 		reg_queue->DIRECT = 1;// burst write register
 		reg_queue->INDEX = RegisterNo;
@@ -342,7 +342,7 @@ Wb35Reg_Read(phw_data_t pHwData, u16 RegisterNo,  u32 * pRegisterValue )
 	// update the variable by send Urb to read register ------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
-	urb = wb_usb_alloc_urb(0);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if( urb && reg_queue )
 	{
 		reg_queue->DIRECT = 0;// read register
@@ -434,7 +434,7 @@ Wb35Reg_EP0VM(phw_data_t pHwData )
 
 	reg->EP0vm_state = VM_RUNNING;
 
-	ret = wb_usb_submit_urb( urb );
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (ret < 0) {
 #ifdef _PE_REG_DUMP_
diff --git a/drivers/staging/winbond/linux/wb35rx.c b/drivers/staging/winbond/linux/wb35rx.c
index 4fee835..e5ec29c 100644
--- a/drivers/staging/winbond/linux/wb35rx.c
+++ b/drivers/staging/winbond/linux/wb35rx.c
@@ -70,7 +70,7 @@ void Wb35Rx(  phw_data_t pHwData )
 
 	pWb35Rx->EP3vm_state = VM_RUNNING;
 
-	retv = wb_usb_submit_urb(urb);
+	retv = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (retv != 0) {
 		printk("Rx URB sending error\n");
@@ -168,7 +168,7 @@ unsigned char Wb35Rx_initial(phw_data_t pHwData)
 	// Initial the Buffer Queue
 	Wb35Rx_reset_descriptor( pHwData );
 
-	pWb35Rx->RxUrb = wb_usb_alloc_urb(0);
+	pWb35Rx->RxUrb = usb_alloc_urb(0, GFP_ATOMIC);
 	return (!!pWb35Rx->RxUrb);
 }
 
diff --git a/drivers/staging/winbond/linux/wb35tx.c b/drivers/staging/winbond/linux/wb35tx.c
index 8de0783..0a51d39 100644
--- a/drivers/staging/winbond/linux/wb35tx.c
+++ b/drivers/staging/winbond/linux/wb35tx.c
@@ -65,7 +65,7 @@ void Wb35Tx(phw_data_t pHwData)
 			  Wb35Tx_complete, pHwData);
 
 	pWb35Tx->EP4vm_state = VM_RUNNING;
-	retv = wb_usb_submit_urb( pUrb );
+	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 	if (retv<0) {
 		printk("EP4 Tx Irp sending error\n");
 		goto cleanup;
@@ -134,11 +134,11 @@ unsigned char Wb35Tx_initial(phw_data_t pHwData)
 {
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
-	pWb35Tx->Tx4Urb = wb_usb_alloc_urb(0);
+	pWb35Tx->Tx4Urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!pWb35Tx->Tx4Urb)
 		return FALSE;
 
-	pWb35Tx->Tx2Urb = wb_usb_alloc_urb(0);
+	pWb35Tx->Tx2Urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!pWb35Tx->Tx2Urb)
 	{
 		usb_free_urb( pWb35Tx->Tx4Urb );
@@ -240,7 +240,7 @@ void Wb35Tx_EP2VM(phw_data_t pHwData)
 			  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, pHwData, 32);
 
 	pWb35Tx->EP2vm_state = VM_RUNNING;
-	retv = wb_usb_submit_urb( pUrb );
+	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 
 	if (retv < 0) {
 		#ifdef _PE_TX_DUMP_
diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
index 0392707..5225fa4 100644
--- a/drivers/staging/winbond/linux/wbusb_f.h
+++ b/drivers/staging/winbond/linux/wbusb_f.h
@@ -22,9 +22,6 @@ int wb35_probe(struct usb_interface *intf,const struct usb_device_id *id_table);
 void wb35_disconnect(struct usb_interface *intf);
 
 
-#define wb_usb_submit_urb(_A) usb_submit_urb(_A, GFP_ATOMIC)
-#define wb_usb_alloc_urb(_A) usb_alloc_urb(_A, GFP_ATOMIC)
-
 #define WbUsb_CheckForHang( _P )
 #define WbUsb_DetectStart( _P, _I )
 
-- 
1.5.3.7

