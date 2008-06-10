Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbYFJS7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYFJS7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFJS7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:59:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55597 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753254AbYFJS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:59:44 -0400
Date: Tue, 10 Jun 2008 14:59:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] USB: don't use reset-resume if drivers don't support it
In-Reply-To: <alpine.LFD.1.10.0806100933060.3101@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0806101454480.3658-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

This patch tries to identify which devices are able to accept
reset-resume handling, by checking that there is at least one
interface driver bound and that all of the drivers have a reset_resume
method defined.  If these conditions don't hold then during resume
processing, the device is logicall disconnected.

This is only a temporary fix.  Later on we will explicitly unbind
drivers that can't handle reset-resumes.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Greg:

This patch really is a temporary fix meant only for 2.6.26.  There
already are changes in the gregkh development tree which clash with
this, and I intend to submit separately a real fix for the problem
(i.e., unbind drivers that don't have suspend, resume, reset_resume,
pre_reset, or post_reset methods, as needed).

Is there any way this can be added to 2.6.26-rc while leaving it out of 
the gregkh tree?

Alan Stern



Index: 2.6.26-rc5/drivers/usb/core/hub.c
===================================================================
--- 2.6.26-rc5.orig/drivers/usb/core/hub.c
+++ 2.6.26-rc5/drivers/usb/core/hub.c
@@ -644,6 +644,48 @@ static void hub_stop(struct usb_hub *hub
 
 #ifdef CONFIG_PM
 
+/* Try to identify which devices need USB-PERSIST handling */
+static int persistent_device(struct usb_device *udev)
+{
+	int i;
+	int retval;
+	struct usb_host_config *actconfig;
+
+	/* Explicitly not marked persistent? */
+	if (!udev->persist_enabled)
+		return 0;
+
+	/* No active config? */
+	actconfig = udev->actconfig;
+	if (!actconfig)
+		return 0;
+
+	/* FIXME! We should check whether it's open here or not! */
+
+	/*
+	 * Check that all the interface drivers have a
+	 * 'reset_resume' entrypoint
+	 */
+	retval = 0;
+	for (i = 0; i < actconfig->desc.bNumInterfaces; i++) {
+		struct usb_interface *intf;
+		struct usb_driver *driver;
+
+		intf = actconfig->interface[i];
+		if (!intf->dev.driver)
+			continue;
+		driver = to_usb_driver(intf->dev.driver);
+		if (!driver->reset_resume)
+			return 0;
+		/*
+		 * We have at least one driver, and that one
+		 * has a reset_resume method.
+		 */
+		retval = 1;
+	}
+	return retval;
+}
+
 static void hub_restart(struct usb_hub *hub, int type)
 {
 	struct usb_device *hdev = hub->hdev;
@@ -689,8 +731,8 @@ static void hub_restart(struct usb_hub *
 		 * turn off the various status changes to prevent
 		 * khubd from disconnecting it later.
 		 */
-		if (udev->persist_enabled && status == 0 &&
-				!(portstatus & USB_PORT_STAT_ENABLE)) {
+		if (status == 0 && !(portstatus & USB_PORT_STAT_ENABLE) &&
+				persistent_device(udev)) {
 			if (portchange & USB_PORT_STAT_C_ENABLE)
 				clear_port_feature(hub->hdev, port1,
 						USB_PORT_FEAT_C_ENABLE);

