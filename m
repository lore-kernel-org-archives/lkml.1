Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbYGVFat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbYGVFat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbYGVFXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYGVFXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/79] device create: usb: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:51 -0700
Message-Id: <1216703983-21448-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/devio.c     |    6 +++---
 drivers/usb/core/file.c      |    5 +++--
 drivers/usb/gadget/printer.c |    4 ++--
 drivers/usb/mon/mon_bin.c    |    5 +++--
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 6fbc8f5..20290c5 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1729,9 +1729,9 @@ static int usb_classdev_add(struct usb_device *dev)
 {
 	struct device *cldev;
 
-	cldev = device_create(usb_classdev_class, &dev->dev, dev->dev.devt,
-			      "usbdev%d.%d", dev->bus->busnum,
-			      dev->devnum);
+	cldev = device_create_drvdata(usb_classdev_class, &dev->dev,
+				      dev->dev.devt, NULL, "usbdev%d.%d",
+				      dev->bus->busnum, dev->devnum);
 	if (IS_ERR(cldev))
 		return PTR_ERR(cldev);
 	dev->usb_classdev = cldev;
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 913fb86..6b1b229 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -196,8 +196,9 @@ int usb_register_dev(struct usb_interface *intf,
 		++temp;
 	else
 		temp = name;
-	intf->usb_dev = device_create(usb_class->class, &intf->dev,
-				      MKDEV(USB_MAJOR, minor), "%s", temp);
+	intf->usb_dev = device_create_drvdata(usb_class->class, &intf->dev,
+					      MKDEV(USB_MAJOR, minor), NULL,
+					      "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
 		down_write(&minor_rwsem);
 		usb_minors[intf->minor] = NULL;
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 9caaec3..49cd9e1 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1360,8 +1360,8 @@ printer_bind(struct usb_gadget *gadget)
 
 
 	/* Setup the sysfs files for the printer gadget. */
-	dev->pdev = device_create(usb_gadget_class, NULL, g_printer_devno,
-			"g_printer");
+	dev->pdev = device_create_drvdata(usb_gadget_class, NULL,
+					  g_printer_devno, NULL, "g_printer");
 	if (IS_ERR(dev->pdev)) {
 		ERROR(dev, "Failed to create device: g_printer\n");
 		goto fail;
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 293a462..6566fc0 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1162,8 +1162,9 @@ int mon_bin_add(struct mon_bus *mbus, const struct usb_bus *ubus)
 	if (minor >= MON_BIN_MAX_MINOR)
 		return 0;
 
-	dev = device_create(mon_bin_class, ubus? ubus->controller: NULL,
-			MKDEV(MAJOR(mon_bin_dev0), minor), "usbmon%d", minor);
+	dev = device_create_drvdata(mon_bin_class, ubus? ubus->controller: NULL,
+				    MKDEV(MAJOR(mon_bin_dev0), minor), NULL,
+				    "usbmon%d", minor);
 	if (IS_ERR(dev))
 		return 0;
 
-- 
1.5.6.3

