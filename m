Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYHLOkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYHLOkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYHLOj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:27 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19247 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYHLOjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:22 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@imgtec.com>
Subject: [PATCH 03/11] fsl_usb2_udc: Fix some sparse warnings and remove redundant code.
Date: Tue, 12 Aug 2008 15:39:09 +0100
Message-Id: <1218551957-17091-4-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:17.0962 (UTC) FILETIME=[3330E2A0:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some sparse "integer used as NULL pointer" warnings.
Remove some unnecessary volatiles and static initialization.
Remove some unused struct members and reorder to improve packing.
Remove a few unneeded includes.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   28 +++++++++-------------------
 drivers/usb/gadget/fsl_usb2_udc.h |   21 ++-------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 47d6c92..27a2ec7 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -23,11 +23,8 @@
 #include <linux/ioport.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/delay.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/timer.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
@@ -44,11 +41,9 @@
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/system.h>
 #include <asm/unaligned.h>
 #include <asm/dma.h>
-#include <asm/cacheflush.h>
 
 #include "fsl_usb2_udc.h"
 
@@ -61,8 +56,8 @@
 static const char driver_name[] = "fsl-usb2-udc";
 static const char driver_desc[] = DRIVER_DESC;
 
-volatile static struct usb_dr_device *dr_regs = NULL;
-volatile static struct usb_sys_interface *usb_sys_regs = NULL;
+static struct usb_dr_device *dr_regs;
+static struct usb_sys_interface *usb_sys_regs;
 
 /* it is initialized in probe()  */
 static struct fsl_udc *udc_controller = NULL;
@@ -560,7 +555,7 @@ static int fsl_ep_disable(struct usb_ep *_ep)
 	/* nuke all pending requests (does flush) */
 	nuke(ep, -ESHUTDOWN);
 
-	ep->desc = 0;
+	ep->desc = NULL;
 	ep->stopped = 1;
 	spin_unlock_irqrestore(&udc->lock, flags);
 
@@ -1565,9 +1560,6 @@ static void port_change_irq(struct fsl_udc *udc)
 {
 	u32 speed;
 
-	if (udc->bus_reset)
-		udc->bus_reset = 0;
-
 	/* Bus resetting is finished */
 	if (!(fsl_readl(&dr_regs->portsc1) & PORTSCX_PORT_RESET)) {
 		/* Get the speed */
@@ -1675,8 +1667,6 @@ static void reset_irq(struct fsl_udc *udc)
 
 	if (fsl_readl(&dr_regs->portsc1) & PORTSCX_PORT_RESET) {
 		VDBG("Bus reset");
-		/* Bus is reseting */
-		udc->bus_reset = 1;
 		/* Reset all the queues, include XD, dTD, EP queue
 		 * head and TR Queue */
 		reset_queues(udc);
@@ -1796,7 +1786,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	/* lock is needed but whether should use this lock or another */
 	spin_lock_irqsave(&udc_controller->lock, flags);
 
-	driver->driver.bus = 0;
+	driver->driver.bus = NULL;
 	/* hook up the driver */
 	udc_controller->driver = driver;
 	udc_controller->gadget.dev.driver = &driver->driver;
@@ -1806,8 +1796,8 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	retval = driver->bind(&udc_controller->gadget);
 	if (retval) {
 		VDBG("bind to %s --> %d", driver->driver.name, retval);
-		udc_controller->gadget.dev.driver = 0;
-		udc_controller->driver = 0;
+		udc_controller->gadget.dev.driver = NULL;
+		udc_controller->driver = NULL;
 		goto out;
 	}
 
@@ -1839,7 +1829,7 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 		return -EINVAL;
 
 	if (udc_controller->transceiver)
-		(void)otg_set_peripheral(udc_controller->transceiver, 0);
+		otg_set_peripheral(udc_controller->transceiver, NULL);
 
 	/* stop DR, disable intr */
 	dr_controller_stop(udc_controller);
@@ -1860,8 +1850,8 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 
 	/* unbind gadget and unhook driver. */
 	driver->unbind(&udc_controller->gadget);
-	udc_controller->gadget.dev.driver = 0;
-	udc_controller->driver = 0;
+	udc_controller->gadget.dev.driver = NULL;
+	udc_controller->driver = NULL;
 
 	printk("unregistered gadget driver '%s'\r\n", driver->driver.name);
 	return 0;
diff --git a/drivers/usb/gadget/fsl_usb2_udc.h b/drivers/usb/gadget/fsl_usb2_udc.h
index 6131752..e63ef12 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.h
+++ b/drivers/usb/gadget/fsl_usb2_udc.h
@@ -424,16 +424,6 @@ struct ep_td_struct {
 /* Controller dma boundary */
 #define UDC_DMA_BOUNDARY			0x1000
 
-/* -----------------------------------------------------------------------*/
-/* ##### enum data
-*/
-typedef enum {
-	e_ULPI,
-	e_UTMI_8BIT,
-	e_UTMI_16BIT,
-	e_SERIAL
-} e_PhyInterface;
-
 /*-------------------------------------------------------------------------*/
 
 /* ### driver private data
@@ -469,9 +459,9 @@ struct fsl_ep {
 #define EP_DIR_OUT	0
 
 struct fsl_udc {
-
 	struct usb_gadget gadget;
 	struct usb_gadget_driver *driver;
+	struct completion *done;	/* to make sure release() is done */
 	struct fsl_ep *eps;
 	unsigned int max_ep;
 	unsigned int irq;
@@ -492,20 +482,13 @@ struct fsl_udc {
 	size_t ep_qh_size;		/* size after alignment adjustment*/
 	dma_addr_t ep_qh_dma;		/* dma address of QH */
 
-	u32 max_pipes;		/* Device max pipes */
-	u32 max_use_endpts;	/* Max endpointes to be used */
-	u32 bus_reset;		/* Device is bus reseting */
+	u32 max_pipes;          /* Device max pipes */
 	u32 resume_state;	/* USB state to resume */
 	u32 usb_state;		/* USB current state */
-	u32 usb_next_state;	/* USB next state */
 	u32 ep0_state;		/* Endpoint zero state */
 	u32 ep0_dir;		/* Endpoint zero direction: can be
 				   USB_DIR_IN or USB_DIR_OUT */
-	u32 usb_sof_count;	/* SOF count */
-	u32 errors;		/* USB ERRORs count */
 	u8 device_address;	/* Device USB address */
-
-	struct completion *done;	/* to make sure release() is done */
 };
 
 /*-------------------------------------------------------------------------*/
-- 
1.5.5.2

