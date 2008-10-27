Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYJ0Uri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYJ0Uri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYJ0UrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:47:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55311 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbYJ0UrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:47:13 -0400
Date: Mon, 27 Oct 2008 22:47:12 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] w35und: OS_MEMORY_ALLOC wrapper removal
Message-ID: <Pine.LNX.4.64.0810272246400.7561@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes the rather scary OS_MEMORY_ALLOC macro.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/adapter.h       |    1 -
 drivers/staging/winbond/linux/wb35reg.c |    8 ++++----
 drivers/staging/winbond/linux/wb35rx.c  |    3 ++-
 drivers/staging/winbond/wblinux.c       |   10 ----------
 drivers/staging/winbond/wblinux_f.h     |    1 -
 5 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/winbond/adapter.h b/drivers/staging/winbond/adapter.h
index fc4205d..e102dcb 100644
--- a/drivers/staging/winbond/adapter.h
+++ b/drivers/staging/winbond/adapter.h
@@ -1,4 +1,3 @@
-#define OS_MEMORY_ALLOC( _V, _S )	WBLINUX_MemoryAlloc( _V, _S )
 #define OS_LINK_STATUS			(adapter->LinkStatus == OS_CONNECTED)
 #define OS_SET_SHUTDOWN( _A )		_A->shutdown=1
 #define OS_SET_RESUME( _A )		_A->shutdown=0
diff --git a/drivers/staging/winbond/linux/wb35reg.c b/drivers/staging/winbond/linux/wb35reg.c
index bdd6bff..e9b1386 100644
--- a/drivers/staging/winbond/linux/wb35reg.c
+++ b/drivers/staging/winbond/linux/wb35reg.c
@@ -25,7 +25,7 @@ Wb35Reg_BurstWrite(phw_data_t pHwData, u16 RegisterNo, u32 * pRegisterData, u8 N
 
 	// Trying to use burst write function if use new hardware
 	UrbSize = sizeof(struct wb35_reg_queue) + DataSize + sizeof(struct usb_ctrlrequest);
-	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
+	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if( urb && reg_queue ) {
 		reg_queue->DIRECT = 2;// burst write register
@@ -174,7 +174,7 @@ Wb35Reg_Write(  phw_data_t pHwData,  u16 RegisterNo,  u32 RegisterValue )
 
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
-	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
+	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
 		reg_queue->DIRECT = 1;// burst write register
@@ -234,7 +234,7 @@ Wb35Reg_WriteWithCallbackValue( phw_data_t pHwData, u16 RegisterNo, u32 Register
 
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
-	OS_MEMORY_ALLOC((void* *) &reg_queue, UrbSize );
+	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
 		reg_queue->DIRECT = 1;// burst write register
@@ -341,7 +341,7 @@ Wb35Reg_Read(phw_data_t pHwData, u16 RegisterNo,  u32 * pRegisterValue )
 
 	// update the variable by send Urb to read register ------------------------------------
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
-	OS_MEMORY_ALLOC( (void* *)&reg_queue, UrbSize );
+	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if( urb && reg_queue )
 	{
diff --git a/drivers/staging/winbond/linux/wb35rx.c b/drivers/staging/winbond/linux/wb35rx.c
index 9593a60..e492fa5 100644
--- a/drivers/staging/winbond/linux/wb35rx.c
+++ b/drivers/staging/winbond/linux/wb35rx.c
@@ -57,7 +57,8 @@ void Wb35Rx(  phw_data_t pHwData )
 
 	pWb35Rx->CurrentRxBufferId = RxBufferId;
 
-	if (1 != OS_MEMORY_ALLOC((void* *)&pWb35Rx->pDRx, MAX_USB_RX_BUFFER)) {
+	pWb35Rx->pDRx = kzalloc(MAX_USB_RX_BUFFER, GFP_ATOMIC);
+	if (!pWb35Rx->pDRx) {
 		printk("w35und: Rx memory alloc failed\n");
 		goto error;
 	}
diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
index 93c72ac..ca507e7 100644
--- a/drivers/staging/winbond/wblinux.c
+++ b/drivers/staging/winbond/wblinux.c
@@ -10,16 +10,6 @@
 //============================================================================
 #include "os_common.h"
 
-u32
-WBLINUX_MemoryAlloc(void* *VirtualAddress, u32 Length)
-{
-	*VirtualAddress = kzalloc( Length, GFP_ATOMIC ); //GFP_KERNEL is not suitable
-
-	if (*VirtualAddress == NULL)
-		return 0;
-	return 1;
-}
-
 s32
 EncapAtomicInc(struct wb35_adapter * adapter, void* pAtomic)
 {
diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
index 1d09c65..f19c0ee 100644
--- a/drivers/staging/winbond/wblinux_f.h
+++ b/drivers/staging/winbond/wblinux_f.h
@@ -3,7 +3,6 @@
 //
 // wblinux_f.h
 //
-u32 WBLINUX_MemoryAlloc(  void* *VirtualAddress,  u32 Length );
 s32 EncapAtomicInc(  struct wb35_adapter *adapter,  void* pAtomic );
 s32 EncapAtomicDec(  struct wb35_adapter *adapter,  void* pAtomic );
 void WBLinux_ReceivePacket(  struct wb35_adapter *adapter,  PRXLAYER1 pRxLayer1 );
-- 
1.5.3.7

