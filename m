Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbYFJVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbYFJVoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYFJVoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:44:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:59190 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYFJVoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:44:01 -0400
Subject: patch usb-don-t-use-reset-resume-if-drivers-don-t-support-it.patch added to gregkh-2.6 tree
To: torvalds@linux-foundation.org, akpm@linuxfoundation.org, gregkh@suse.de,
       greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       oliver@neukum.org, pavel@suse.cz, rjw@sisk.pl,
       stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Tue, 10 Jun 2008 14:42:24 -0700
In-Reply-To: <Pine.LNX.4.44L0.0806101454480.3658-100000@iolanthe.rowland.org>
Message-ID: <12131341443712@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: don't use reset-resume if drivers don't support it

to my gregkh-2.6 tree.  Its filename is

     usb-don-t-use-reset-resume-if-drivers-don-t-support-it.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From stern@rowland.harvard.edu  Tue Jun 10 14:31:37 2008
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jun 2008 14:59:43 -0400 (EDT)
Subject: USB: don't use reset-resume if drivers don't support it
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,  Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,  USB list <linux-usb@vger.kernel.org>,  Andrew Morton <akpm@linuxfoundation.org>,  kernel list <linux-kernel@vger.kernel.org>,  "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0806101454480.3658-100000@iolanthe.rowland.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

This patch tries to identify which devices are able to accept
reset-resume handling, by checking that there is at least one
interface driver bound and that all of the drivers have a reset_resume
method defined.  If these conditions don't hold then during resume
processing, the device is logicall disconnected.

This is only a temporary fix.  Later on we will explicitly unbind
drivers that can't handle reset-resumes.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
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


Patches currently in gregkh-2.6 which might be from torvalds@linux-foundation.org are

usb.current/usb-don-t-use-reset-resume-if-drivers-don-t-support-it.patch
