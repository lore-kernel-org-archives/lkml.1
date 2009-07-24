Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZGXUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZGXUA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZGXUA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:00:56 -0400
Received: from www84.your-server.de ([213.133.104.84]:52718 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZGXUA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:00:56 -0400
Subject: [PATCH]: fsl usb gadget driver pullup fix
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel@vger.kernel.org, leoli@freescale.com,
       tanya.jiang@freescale.com
Content-Type: text/plain
Date: Fri, 24 Jul 2009 22:00:23 +0200
Message-Id: <1248465623.30437.24.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is a small fix for the fsl usb gadget driver. This fix the
driver in a way that the usb device will be only "pulled up" on request,
like other usb gadget drivers do. 

This is necessary, because the device information is not always
available until an application is up and running which provides this
datas.

Hope you like it.

 fsl_udc_core.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)
Signed-off-by: Stefani Seibold <stefani@seibold.net>

--- linux-2.6.31-rc4.orig/drivers/usb/gadget/fsl_udc_core.c	2009-07-24
20:35:29.000000000 +0200
+++ linux-2.6.31-rc4/drivers/usb/gadget/fsl_udc_core.c	2009-07-24
21:44:10.000000000 +0200
@@ -171,6 +171,21 @@
 	}
 }
 
+static int can_pullup(struct fsl_udc *udc)
+{
+	return udc->driver && udc->softconnect && udc->vbus_active;
+}
+
+static void set_pullup(struct fsl_udc *udc)
+{
+	if (can_pullup(udc))
+		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
+				&dr_regs->usbcmd);
+	else
+		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
+				&dr_regs->usbcmd);
+}
+
 /*------------------------------------------------------------------
 	Internal Hardware related function
  ------------------------------------------------------------------*/
@@ -283,10 +298,7 @@
 	temp |= USB_MODE_CTRL_MODE_DEVICE;
 	fsl_writel(temp, &dr_regs->usbmode);
 
-	/* Set controller to Run */
-	temp = fsl_readl(&dr_regs->usbcmd);
-	temp |= USB_CMD_RUN_STOP;
-	fsl_writel(temp, &dr_regs->usbcmd);
+	set_pullup(udc);
 
 	return;
 }
@@ -1059,11 +1071,6 @@
 	return 0;
 }
 
-static int can_pullup(struct fsl_udc *udc)
-{
-	return udc->driver && udc->softconnect && udc->vbus_active;
-}
-
 /* Notify controller that VBUS is powered, Called by whatever
    detects VBUS sessions */
 static int fsl_vbus_session(struct usb_gadget *gadget, int is_active)
@@ -1075,12 +1082,7 @@
 	spin_lock_irqsave(&udc->lock, flags);
 	VDBG("VBUS %s", is_active ? "on" : "off");
 	udc->vbus_active = (is_active != 0);
-	if (can_pullup(udc))
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
-	else
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
+	set_pullup(udc);
 	spin_unlock_irqrestore(&udc->lock, flags);
 	return 0;
 }
@@ -1111,12 +1113,7 @@
 
 	udc = container_of(gadget, struct fsl_udc, gadget);
 	udc->softconnect = (is_on != 0);
-	if (can_pullup(udc))
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
-	else
-		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
-				&dr_regs->usbcmd);
+	set_pullup(udc);
 
 	return 0;
 }
@@ -2194,6 +2191,8 @@
 
 	udc->resume_state = USB_STATE_NOTATTACHED;
 	udc->usb_state = USB_STATE_POWERED;
+	udc->vbus_active = 1;
+	udc->softconnect = 1;
 	udc->ep0_dir = 0;
 	udc->remote_wakeup = 0;	/* default to 0 on reset */
 


