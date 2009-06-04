Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZFDUav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZFDUav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZFDUam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:30:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48621 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZFDUam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:30:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] USB: Avoid PM error messages during resume if a device was disconnected
Date: Thu, 4 Jun 2009 22:30:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Frans Pop <elendil@planet.nl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906042230.49825.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

Currently if a laptop is suspended e.g. while docked and then resumed after
undocking it, the following errors get generated because the USB hub in the
docking station and the devices connected to it are no longer available:
pm_op(): usb_dev_resume+0x0/0x10 returns -19
PM: Device 1-2 failed to resume: error -19
pm_op(): usb_dev_resume+0x0/0x10 returns -19
PM: Device 1-2.2 failed to resume: error -19
pm_op(): usb_dev_resume+0x0/0x10 returns -19
PM: Device 1-2.3 failed to resume: error -19

As the removal of USB devices while a system is suspended is a relatively
common use case and in most cases not an error, just return success on
-ENODEV. The user gets informed anyway as the USB subsystem generates
regular disconnect messages for the devices shortly afterwards:
usb 1-2: USB disconnect, address 3
usb 1-2.2: USB disconnect, address 4
usblp0: removed
usb 1-2.3: USB disconnect, address 5

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
Hi Greg,

I can take this patch to the suspend tree, but if you think it should go
through USB, please consider including it into the 2.6.31 push.

Best,
Rafael
---
 drivers/usb/core/driver.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/usb/core/driver.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/driver.c
+++ linux-2.6/drivers/usb/core/driver.c
@@ -1762,6 +1762,7 @@ int usb_suspend(struct device *dev, pm_m
 int usb_resume(struct device *dev, pm_message_t msg)
 {
 	struct usb_device	*udev;
+	int			status;
 
 	udev = to_usb_device(dev);
 
@@ -1771,7 +1772,14 @@ int usb_resume(struct device *dev, pm_me
 	 */
 	if (udev->skip_sys_resume)
 		return 0;
-	return usb_external_resume_device(udev, msg);
+	status = usb_external_resume_device(udev, msg);
+
+	/* Avoid PM error messages for devices disconnected while suspended
+	 * as we'll display regular disconnect messages just a bit later.
+	 */
+	if (status == -ENODEV)
+		return 0;
+	return status;
 }
 
 #endif /* CONFIG_PM */
