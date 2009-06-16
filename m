Return-Path: <linux-kernel-owner+w=401wt.eu-S936567AbZFPF5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936567AbZFPF5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935628AbZFPFvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:18 -0400
Received: from kroah.org ([198.145.64.141]:48373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934783AbZFPFvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/64] Driver Core: usb: add nodename support for usb drivers.
Date: Mon, 15 Jun 2009 22:46:16 -0700
Message-Id: <1245131213-24168-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support for USB drivers to report their requested nodename to
userspace.  It also updates a number of USB drivers to provide the
needed subdirectory and device name to be used for them.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hid/usbhid/hiddev.c     |    7 ++++++-
 drivers/media/video/dabusb.c    |    6 ++++++
 drivers/usb/class/usblp.c       |    6 ++++++
 drivers/usb/core/file.c         |   13 ++++++++++++-
 drivers/usb/core/usb.c          |   11 +++++++++++
 drivers/usb/misc/iowarrior.c    |    6 ++++++
 drivers/usb/misc/legousbtower.c |    6 ++++++
 include/linux/usb.h             |    3 +++
 8 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index e9b436d..9e94215 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -850,8 +850,14 @@ static const struct file_operations hiddev_fops = {
 #endif
 };
 
+static char *hiddev_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
+}
+
 static struct usb_class_driver hiddev_class = {
 	.name =		"hiddev%d",
+	.nodename =	hiddev_nodename,
 	.fops =		&hiddev_fops,
 	.minor_base =	HIDDEV_MINOR_BASE,
 };
@@ -955,7 +961,6 @@ static int hiddev_usbd_probe(struct usb_interface *intf,
 	return -ENODEV;
 }
 
-
 static /* const */ struct usb_driver hiddev_driver = {
 	.name =		"hiddev",
 	.probe =	hiddev_usbd_probe,
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index ba3709b..ec2f45d 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -747,8 +747,14 @@ static const struct file_operations dabusb_fops =
 	.release =	dabusb_release,
 };
 
+static char *dabusb_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
+}
+
 static struct usb_class_driver dabusb_class = {
 	.name =		"dabusb%d",
+	.nodename =	dabusb_nodename,
 	.fops =		&dabusb_fops,
 	.minor_base =	DABUSB_MINOR,
 };
diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index d2747a4..26c09f0 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1057,8 +1057,14 @@ static const struct file_operations usblp_fops = {
 	.release =	usblp_release,
 };
 
+static char *usblp_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
+}
+
 static struct usb_class_driver usblp_class = {
 	.name =		"lp%d",
+	.nodename =	usblp_nodename,
 	.fops =		&usblp_fops,
 	.minor_base =	USBLP_MINOR_BASE,
 };
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 997e659..5cef889 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -67,6 +67,16 @@ static struct usb_class {
 	struct class *class;
 } *usb_class;
 
+static char *usb_nodename(struct device *dev)
+{
+	struct usb_class_driver *drv;
+
+	drv = dev_get_drvdata(dev);
+	if (!drv || !drv->nodename)
+		return NULL;
+	return drv->nodename(dev);
+}
+
 static int init_usb_class(void)
 {
 	int result = 0;
@@ -90,6 +100,7 @@ static int init_usb_class(void)
 		kfree(usb_class);
 		usb_class = NULL;
 	}
+	usb_class->class->nodename = usb_nodename;
 
 exit:
 	return result;
@@ -198,7 +209,7 @@ int usb_register_dev(struct usb_interface *intf,
 	else
 		temp = name;
 	intf->usb_dev = device_create(usb_class->class, &intf->dev,
-				      MKDEV(USB_MAJOR, minor), NULL,
+				      MKDEV(USB_MAJOR, minor), class_driver,
 				      "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
 		down_write(&minor_rwsem);
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 7eee400..927a27d 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -305,10 +305,21 @@ static struct dev_pm_ops usb_device_pm_ops = {
 
 #endif	/* CONFIG_PM */
 
+
+static char *usb_nodename(struct device *dev)
+{
+	struct usb_device *usb_dev;
+
+	usb_dev = to_usb_device(dev);
+	return kasprintf(GFP_KERNEL, "bus/usb/%03d/%03d",
+			 usb_dev->bus->busnum, usb_dev->devnum);
+}
+
 struct device_type usb_device_type = {
 	.name =		"usb_device",
 	.release =	usb_release_dev,
 	.uevent =	usb_dev_uevent,
+	.nodename = 	usb_nodename,
 	.pm =		&usb_device_pm_ops,
 };
 
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index a4ef77e..3c5fe5c 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -726,12 +726,18 @@ static const struct file_operations iowarrior_fops = {
 	.poll = iowarrior_poll,
 };
 
+static char *iowarrior_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
+}
+
 /*
  * usb class driver info in order to get a minor number from the usb core,
  * and to have the device registered with devfs and the driver core
  */
 static struct usb_class_driver iowarrior_class = {
 	.name = "iowarrior%d",
+	.nodename = iowarrior_nodename,
 	.fops = &iowarrior_fops,
 	.minor_base = IOWARRIOR_MINOR_BASE,
 };
diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index ab0f322..c1e2433 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -266,12 +266,18 @@ static const struct file_operations tower_fops = {
 	.llseek =	tower_llseek,
 };
 
+static char *legousbtower_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "usb/%s", dev_name(dev));
+}
+
 /*
  * usb class driver info in order to get a minor number from the usb core,
  * and to have the device registered with the driver core
  */
 static struct usb_class_driver tower_class = {
 	.name =		"legousbtower%d",
+	.nodename = 	legousbtower_nodename,
 	.fops =		&tower_fops,
 	.minor_base =	LEGO_USB_TOWER_MINOR_BASE,
 };
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 3aa2cd1..34cdfca 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -869,6 +869,8 @@ struct usb_driver {
  * struct usb_device_driver - identifies USB device driver to usbcore
  * @name: The driver name should be unique among USB drivers,
  *	and should normally be the same as the module name.
+ * @nodename: Callback to provide a naming hint for a possible
+ *	device node to create.
  * @probe: Called to see if the driver is willing to manage a particular
  *	device.  If it is, probe returns zero and uses dev_set_drvdata()
  *	to associate driver-specific data with the device.  If unwilling
@@ -912,6 +914,7 @@ extern struct bus_type usb_bus_type;
  */
 struct usb_class_driver {
 	char *name;
+	char *(*nodename)(struct device *dev);
 	const struct file_operations *fops;
 	int minor_base;
 };
-- 
1.6.3.2

