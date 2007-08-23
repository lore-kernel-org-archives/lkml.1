Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbXHWWql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbXHWWql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHWWq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:46:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42603 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538AbXHWWqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:46:25 -0400
Date: Thu, 23 Aug 2007 15:45:14 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Cc: Matt Colyer <matt@colyer.name>, jeffm@suse.de
Subject: [RFC] USB: driver for iphone charging
Message-ID: <20070823224514.GA25830@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


my berry_charge code that adds support for charging the iphone when it
is plugged into a Linux machine.

As I don't have an iphone, can someone who does please test this out and
let me know if it works properly or not?

Matt, I fixed up the formatting of your original driver, fixed a sparse
warning, and the memory leak (which happens to also be in the
berry_charge driver, I'll go fix that too...)

Cc: Matt Colyer <matt@colyer.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/Makefile      |    1 
 drivers/usb/misc/Kconfig  |   11 ++++
 drivers/usb/misc/Makefile |    1 
 drivers/usb/misc/iphone.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 120 insertions(+)

--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_USB_FTDI_ELAN)	+= misc/
 obj-$(CONFIG_USB_GOTEMP)	+= misc/
 obj-$(CONFIG_USB_IDMOUSE)	+= misc/
 obj-$(CONFIG_USB_IOWARRIOR)	+= misc/
+obj-$(CONFIG_USB_IPHONE)	+= misc/
 obj-$(CONFIG_USB_LCD)		+= misc/
 obj-$(CONFIG_USB_LD)		+= misc/
 obj-$(CONFIG_USB_LED)		+= misc/
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -99,6 +99,17 @@ config USB_BERRY_CHARGE
 	  To compile this driver as a module, choose M here: the
 	  module will be called berry_charge.
 
+config USB_IPHONE
+	tristate "USB iPhone recharge support"
+	depends on USB
+	help
+	  Say Y here if you want to connect a iPhone device to your
+	  computer's USB port and have it automatically switch to "recharge"
+	  mode.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called iphone.
+
 config USB_LED
 	tristate "USB LED driver support"
 	depends on USB
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_USB_FTDI_ELAN)	+= ftdi-elan
 obj-$(CONFIG_USB_GOTEMP)	+= gotemp.o
 obj-$(CONFIG_USB_IDMOUSE)	+= idmouse.o
 obj-$(CONFIG_USB_IOWARRIOR)	+= iowarrior.o
+obj-$(CONFIG_USB_IPHONE)	+= iphone.o
 obj-$(CONFIG_USB_LCD)		+= usblcd.o
 obj-$(CONFIG_USB_LD)		+= ldusb.o
 obj-$(CONFIG_USB_LED)		+= usbled.o
--- /dev/null
+++ b/drivers/usb/misc/iphone.c
@@ -0,0 +1,107 @@
+/*
+ * USB iPhone module
+ *
+ * Copyright (C) 2007 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (C) 2007 Matt Colyer <matt@colyer.name>
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License as
+ *   published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+
+#define APPLE_VENDOR	0x05ac
+#define IPHONE		0x1290
+
+static int debug;
+
+#ifdef dbg
+#undef dbg
+#endif
+#define dbg(dev, format, arg...)				\
+	if (debug)						\
+		dev_printk(KERN_DEBUG , dev , format , ## arg)
+
+static struct usb_device_id id_table [] = {
+	{ USB_DEVICE(APPLE_VENDOR, IPHONE) },
+	{ },	/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(usb, id_table);
+
+static int select_configuration(struct usb_device *udev)
+{
+	char *dummy_buffer = kzalloc(2, GFP_KERNEL);
+	int retval;
+
+	if (!dummy_buffer)
+		return -ENOMEM;
+
+	dbg(&udev->dev, "Calling set_configuration\n");
+	retval = usb_driver_set_configuration(udev, 3);
+	if (retval) {
+		dev_err(&udev->dev, "Set Configuration failed :%d.\n", retval);
+		goto exit;
+	}
+
+	dbg(&udev->dev, "Sending first magic command\n");
+	retval = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x40, 0x40,
+				 0x6400, 0, dummy_buffer, 0, 100);
+
+exit:
+	kfree(dummy_buffer);
+	return retval;
+}
+
+static int iphone_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	if (udev->actconfig->desc.bConfigurationValue == 3) {
+		dbg(&udev->dev, "Configuration changed");
+		return -ENODEV;
+	}
+
+	/* turn the power on */
+	select_configuration(udev);
+
+	/* we don't really want to bind to the device, userspace programs can
+	 * handle the syncing just fine, so get outta here. */
+	return -ENODEV;
+}
+
+static void iphone_disconnect(struct usb_interface *intf)
+{
+}
+
+static struct usb_driver iphone_driver = {
+	.name =		"iphone",
+	.probe =	iphone_probe,
+	.disconnect =	iphone_disconnect,
+	.id_table =	id_table,
+};
+
+static int __init iphone_init(void)
+{
+	return usb_register(&iphone_driver);
+}
+
+static void __exit iphone_exit(void)
+{
+	usb_deregister(&iphone_driver);
+}
+
+module_init(iphone_init);
+module_exit(iphone_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Matt Colyer <matt@colyer.name>");
+module_param(debug, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Debug enabled or not");
