Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbYGOP2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbYGOP2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYGOPZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:20 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2275 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYGOPYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:55 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 03/11] fsl_usb2_udc: Fix some sparse warnings and remove redundant code.
Date: Tue, 15 Jul 2008 16:24:42 +0100
Message-Id: <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:52.0886 (UTC) FILETIME=[EDC42B60:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Fix some sparse "integer used as NULL pointer" warnings.
Remove some unnecessary volatiles and static initialization.
Remove some unused struct members and reorder to improve packing.
Remove a few unneeded includes.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   28 +++++++++-------------------
 drivers/usb/gadget/fsl_usb2_udc.h |   21 ++-------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 7257d0f..7b898a5 100644
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
index 98b1483..3ba431c 100644
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

