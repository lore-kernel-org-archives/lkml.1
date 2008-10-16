Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbYJPRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbYJPRT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYJPROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:20 -0400
Received: from kroah.org ([198.145.64.141]:46949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756129AbYJPROS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/46] device create: usb: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:13 -0700
Message-Id: <1224177047-11859-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/devio.c               |    6 +++---
 drivers/usb/core/file.c                |    6 +++---
 drivers/usb/core/hcd.c                 |    5 ++---
 drivers/usb/gadget/printer.c           |    4 ++--
 drivers/usb/misc/phidgetkit.c          |    5 ++---
 drivers/usb/misc/phidgetmotorcontrol.c |    5 ++---
 drivers/usb/misc/phidgetservo.c        |    5 ++---
 drivers/usb/mon/mon_bin.c              |    6 +++---
 8 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 20290c5..7a4fa79 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1729,9 +1729,9 @@ static int usb_classdev_add(struct usb_device *dev)
 {
 	struct device *cldev;
 
-	cldev = device_create_drvdata(usb_classdev_class, &dev->dev,
-				      dev->dev.devt, NULL, "usbdev%d.%d",
-				      dev->bus->busnum, dev->devnum);
+	cldev = device_create(usb_classdev_class, &dev->dev, dev->dev.devt,
+			      NULL, "usbdev%d.%d", dev->bus->busnum,
+			      dev->devnum);
 	if (IS_ERR(cldev))
 		return PTR_ERR(cldev);
 	dev->usb_classdev = cldev;
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 6b1b229..55f7f31 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -196,9 +196,9 @@ int usb_register_dev(struct usb_interface *intf,
 		++temp;
 	else
 		temp = name;
-	intf->usb_dev = device_create_drvdata(usb_class->class, &intf->dev,
-					      MKDEV(USB_MAJOR, minor), NULL,
-					      "%s", temp);
+	intf->usb_dev = device_create(usb_class->class, &intf->dev,
+				      MKDEV(USB_MAJOR, minor), NULL,
+				      "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
 		down_write(&minor_rwsem);
 		usb_minors[intf->minor] = NULL;
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 8ab389d..c8035a8 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -818,9 +818,8 @@ static int usb_register_bus(struct usb_bus *bus)
 	set_bit (busnum, busmap.busmap);
 	bus->busnum = busnum;
 
-	bus->dev = device_create_drvdata(usb_host_class, bus->controller,
-					 MKDEV(0, 0), bus,
-					 "usb_host%d", busnum);
+	bus->dev = device_create(usb_host_class, bus->controller, MKDEV(0, 0),
+				 bus, "usb_host%d", busnum);
 	result = PTR_ERR(bus->dev);
 	if (IS_ERR(bus->dev))
 		goto error_create_class_dev;
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index e009008..7a8d4a1 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1360,8 +1360,8 @@ printer_bind(struct usb_gadget *gadget)
 
 
 	/* Setup the sysfs files for the printer gadget. */
-	dev->pdev = device_create_drvdata(usb_gadget_class, NULL,
-					  g_printer_devno, NULL, "g_printer");
+	dev->pdev = device_create(usb_gadget_class, NULL, g_printer_devno,
+				  NULL, "g_printer");
 	if (IS_ERR(dev->pdev)) {
 		ERROR(dev, "Failed to create device: g_printer\n");
 		goto fail;
diff --git a/drivers/usb/misc/phidgetkit.c b/drivers/usb/misc/phidgetkit.c
index 4cfa25b..cc8e0a9 100644
--- a/drivers/usb/misc/phidgetkit.c
+++ b/drivers/usb/misc/phidgetkit.c
@@ -595,9 +595,8 @@ static int interfacekit_probe(struct usb_interface *intf, const struct usb_devic
         } while(value);
         kit->dev_no = bit;
 
-	kit->dev = device_create_drvdata(phidget_class, &kit->udev->dev,
-					MKDEV(0, 0), kit,
-					"interfacekit%d", kit->dev_no);
+	kit->dev = device_create(phidget_class, &kit->udev->dev, MKDEV(0, 0),
+				 kit, "interfacekit%d", kit->dev_no);
         if (IS_ERR(kit->dev)) {
                 rc = PTR_ERR(kit->dev);
                 kit->dev = NULL;
diff --git a/drivers/usb/misc/phidgetmotorcontrol.c b/drivers/usb/misc/phidgetmotorcontrol.c
index 9b4696f..38088b4 100644
--- a/drivers/usb/misc/phidgetmotorcontrol.c
+++ b/drivers/usb/misc/phidgetmotorcontrol.c
@@ -365,9 +365,8 @@ static int motorcontrol_probe(struct usb_interface *intf, const struct usb_devic
 	} while(value);
 	mc->dev_no = bit;
 
-	mc->dev = device_create_drvdata(phidget_class, &mc->udev->dev,
-					MKDEV(0, 0), mc,
-					"motorcontrol%d", mc->dev_no);
+	mc->dev = device_create(phidget_class, &mc->udev->dev, MKDEV(0, 0), mc,
+				"motorcontrol%d", mc->dev_no);
 	if (IS_ERR(mc->dev)) {
 		rc = PTR_ERR(mc->dev);
 		mc->dev = NULL;
diff --git a/drivers/usb/misc/phidgetservo.c b/drivers/usb/misc/phidgetservo.c
index 1ca7ddb..bef6fe1 100644
--- a/drivers/usb/misc/phidgetservo.c
+++ b/drivers/usb/misc/phidgetservo.c
@@ -275,9 +275,8 @@ servo_probe(struct usb_interface *interface, const struct usb_device_id *id)
         } while (value);
 	dev->dev_no = bit;
 
-	dev->dev = device_create_drvdata(phidget_class, &dev->udev->dev,
-					 MKDEV(0, 0), dev,
-					 "servo%d", dev->dev_no);
+	dev->dev = device_create(phidget_class, &dev->udev->dev, MKDEV(0, 0),
+				 dev, "servo%d", dev->dev_no);
 	if (IS_ERR(dev->dev)) {
 		rc = PTR_ERR(dev->dev);
 		dev->dev = NULL;
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 6566fc0..c9de3f0 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1162,9 +1162,9 @@ int mon_bin_add(struct mon_bus *mbus, const struct usb_bus *ubus)
 	if (minor >= MON_BIN_MAX_MINOR)
 		return 0;
 
-	dev = device_create_drvdata(mon_bin_class, ubus? ubus->controller: NULL,
-				    MKDEV(MAJOR(mon_bin_dev0), minor), NULL,
-				    "usbmon%d", minor);
+	dev = device_create(mon_bin_class, ubus ? ubus->controller : NULL,
+			    MKDEV(MAJOR(mon_bin_dev0), minor), NULL,
+			    "usbmon%d", minor);
 	if (IS_ERR(dev))
 		return 0;
 
-- 
1.6.0.2

