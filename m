Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZEIOno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZEIOno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZEIOmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:55 -0400
Received: from kroah.org ([198.145.64.141]:54171 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZEIOmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:54 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:32 2009
Message-Id: <20090509143632.207105067@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:04 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 03/13] Driver Core: usb: add nodename support for usb drivers.
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-usb-add-nodename-support-for-usb-drivers.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
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

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -850,8 +850,14 @@ static const struct file_operations hidd
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
@@ -955,7 +961,6 @@ static int hiddev_usbd_probe(struct usb_
 	return -ENODEV;
 }
 
-
 static /* const */ struct usb_driver hiddev_driver = {
 	.name =		"hiddev",
 	.probe =	hiddev_usbd_probe,
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -747,8 +747,14 @@ static const struct file_operations dabu
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
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1057,8 +1057,14 @@ static const struct file_operations usbl
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
@@ -198,7 +209,7 @@ int usb_register_dev(struct usb_interfac
 	else
 		temp = name;
 	intf->usb_dev = device_create(usb_class->class, &intf->dev,
-				      MKDEV(USB_MAJOR, minor), NULL,
+				      MKDEV(USB_MAJOR, minor), class_driver,
 				      "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
 		down_write(&minor_rwsem);
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -305,10 +305,21 @@ static struct dev_pm_ops usb_device_pm_o
 
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
 
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -726,12 +726,18 @@ static const struct file_operations iowa
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
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -266,12 +266,18 @@ static const struct file_operations towe
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


