Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbYBXXNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbYBXXNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 18:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYBXXMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 18:12:51 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:60099 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751706AbYBXXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 18:12:49 -0500
X-Trace: 687592974/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAMqIwUdRAVlC/2dsb2JhbACBVagb
Subject: Re: [PATCH] input: support maple controller on SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1203862726.6474.18.camel@localhost.localdomain>
References: <1203862726.6474.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 23:10:22 +0000
Message-Id: <1203894622.6299.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Dreamcast maple controller (as a joystick).

Earlier patches caused subdevice detection headaches. Please use this one.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff -ruN ./a/drivers/input/joystick/Kconfig ./b/drivers/input/joystick/Kconfig
--- ./a/drivers/input/joystick/Kconfig	2008-02-21 20:42:07.000000000 +0000
+++ ./b/drivers/input/joystick/Kconfig	2008-02-24 13:59:04.000000000 +0000
@@ -282,4 +282,17 @@
 	  This option enables support for the LED which surrounds the Big X on
 	  XBox 360 controller.
 
+config JOYSTICK_MAPLE
+	tristate "Dreamcast control pad"
+	depends on SH_DREAMCAST
+	select MAPLE
+	help
+	  Say Y here if you have a SEGA Dreamcast and want to use your
+	  controller.
+
+	  Most Dreamcast users will say Y.
+
+	  To compile this as a module choose M here: the
+	  module will be called maplecontrol.
+
 endif
diff -ruN ./a/drivers/input/joystick/Makefile ./b/drivers/input/joystick/Makefile
--- ./a/drivers/input/joystick/Makefile	2008-02-21 20:42:07.000000000 +0000
+++ ./b/drivers/input/joystick/Makefile	2008-02-24 13:59:04.000000000 +0000
@@ -27,5 +27,6 @@
 obj-$(CONFIG_JOYSTICK_TWIDJOY)		+= twidjoy.o
 obj-$(CONFIG_JOYSTICK_WARRIOR)		+= warrior.o
 obj-$(CONFIG_JOYSTICK_XPAD)		+= xpad.o
+obj-$(CONFIG_JOYSTICK_MAPLE)		+= maplecontrol.o
 
 obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/
diff -ruN ./a/drivers/input/joystick/maplecontrol.c ./b/drivers/input/joystick/maplecontrol.c
--- ./a/drivers/input/joystick/maplecontrol.c	1970-01-01 01:00:00.000000000 +0100
+++ ./b/drivers/input/joystick/maplecontrol.c	2008-02-24 22:56:31.000000000 +0000
@@ -0,0 +1,222 @@
+/*
+ * 	SEGA Dreamcast controller driver
+ *	Based on drivers/usb/iforce.c
+ *
+ * 	Copyright Yaegashi Takeshi, 2001
+ *	Porting to 2.6 by Adrian McMenamin, copyright 2008
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/maple.h>
+#include <asm/mach/maple.h>
+
+MODULE_AUTHOR("YAEGASHI Takeshi <t@keshi.org>");
+MODULE_DESCRIPTION("SEGA Dreamcast controller driver");
+MODULE_LICENSE("GPL");
+
+struct dc_pad {
+	struct input_dev *dev;
+	struct maple_device *mdev;
+	int open;
+};
+
+static void dc_pad_callback(struct mapleq *mq)
+{
+	unsigned short buttons;
+	struct maple_device *mapledev = mq->dev;
+	struct dc_pad *pad = mapledev->private_data;
+	struct input_dev *dev = pad->dev;
+	unsigned char *res = mq->recvbuf;
+
+	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
+
+	input_report_abs(dev, ABS_HAT0Y,
+			 (buttons & 0x0010 ? -1:0) + (buttons & 0x0020 ? 1:0));
+	input_report_abs(dev, ABS_HAT0X,
+			 (buttons & 0x0040 ? -1:0) + (buttons & 0x0080 ? 1:0));
+	input_report_abs(dev, ABS_HAT1Y,
+			 (buttons & 0x1000 ? -1:0) + (buttons & 0x2000 ? 1:0));
+	input_report_abs(dev, ABS_HAT1X,
+			 (buttons & 0x4000 ? -1:0) + (buttons & 0x8000 ? 1:0));
+
+	input_report_key(dev, BTN_C,      buttons & 0x0001);
+	input_report_key(dev, BTN_B,      buttons & 0x0002);
+	input_report_key(dev, BTN_A,      buttons & 0x0004);
+	input_report_key(dev, BTN_START,  buttons & 0x0008);
+	input_report_key(dev, BTN_Z,      buttons & 0x0100);
+	input_report_key(dev, BTN_Y,      buttons & 0x0200);
+	input_report_key(dev, BTN_X,      buttons & 0x0400);
+	input_report_key(dev, BTN_SELECT, buttons & 0x0800);
+
+	input_report_abs(dev, ABS_GAS,   res[10]);
+	input_report_abs(dev, ABS_BRAKE, res[11]);
+	input_report_abs(dev, ABS_X,     res[12]);
+	input_report_abs(dev, ABS_Y,     res[13]);
+	input_report_abs(dev, ABS_RX,    res[14]);
+	input_report_abs(dev, ABS_RY,    res[15]);
+}
+
+static int dc_pad_connect(struct maple_device *mdev)
+{
+	int i, error;
+	unsigned long data = be32_to_cpu(mdev->devinfo.function_data[0]);
+	struct dc_pad *pad;
+	struct input_dev *dev;
+
+	const short btn_bit[32] = {
+		BTN_C, BTN_B, BTN_A, BTN_START, -1, -1, -1, -1,
+		BTN_Z, BTN_Y, BTN_X, BTN_SELECT, -1, -1, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+	};
+
+	const short abs_bit[32] = {
+		-1, -1, -1, -1, ABS_HAT0Y, ABS_HAT0Y, ABS_HAT0X, ABS_HAT0X,
+		-1, -1, -1, -1, ABS_HAT1Y, ABS_HAT1Y, ABS_HAT1X, ABS_HAT1X,
+		ABS_GAS, ABS_BRAKE, ABS_X, ABS_Y, ABS_RX, ABS_RY, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+	};
+
+	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
+	if (!pad){
+		error = ENOMEM;
+		goto fail_nomem_1;
+	}
+
+	dev = input_allocate_device();
+	if (!dev) {
+		error = ENOMEM;
+		goto fail_nomem_2;
+	}
+
+	pad->dev = dev;
+	pad->mdev = mdev;
+	mdev->private_data = pad;
+
+	for (i = 0; i < 32; i++)
+		if (data & (1<<i) && btn_bit[i] >= 0)
+			pad->dev->keybit[BIT_WORD(BTN_JOYSTICK)] |= BIT_MASK(btn_bit[i]);
+
+	if (pad->dev->keybit[BTN_JOYSTICK/32])
+		pad->dev->evbit[0] |= BIT_MASK(EV_KEY);
+
+	for (i = 0; i < 32; i++)
+		if (data & (1<<i) && abs_bit[i] >= 0)
+			pad->dev->absbit[0] |= BIT_MASK(abs_bit[i]);
+
+	if (pad->dev->absbit[0])
+		pad->dev->evbit[0] |= BIT_MASK(EV_ABS);
+
+	for (i = ABS_X; i <= ABS_BRAKE; i++) {
+		pad->dev->absmax[i] = 255;
+		pad->dev->absmin[i] = 0;
+		pad->dev->absfuzz[i] = 0;
+		pad->dev->absflat[i] = 0;
+	}
+
+	for (i = ABS_HAT0X; i <= ABS_HAT3Y; i++) {
+		pad->dev->absmax[i] = 1;
+		pad->dev->absmin[i] = -1;
+		pad->dev->absfuzz[i] = 0;
+		pad->dev->absflat[i] = 0;
+	}
+
+	pad->dev->private = pad;
+	pad->dev->event = NULL;
+	pad->dev->dev.parent = &mdev->dev;
+	pad->dev->name = mdev->product_name;
+	pad->dev->id.bustype = BUS_HOST;
+	input_set_drvdata(dev, pad);
+
+	error = input_register_device(pad->dev);
+	if (error)
+		goto fail_register;
+
+	maple_getcond_callback(mdev, dc_pad_callback, HZ/50,
+		MAPLE_FUNC_CONTROLLER);
+	
+	return error;
+
+fail_register:
+	input_free_device(pad->dev);
+fail_nomem_2:
+	kfree(pad);
+fail_nomem_1:
+	return -error;
+}
+
+static void dc_pad_disconnect(struct maple_device *mdev)
+{
+	struct dc_pad *pad = mdev->private_data;
+
+	mdev->callback = NULL;
+	input_unregister_device(pad->dev);
+	kfree(pad);
+}
+
+/* allow the controller to be used */
+static int probe_maple_controller(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	int error;
+
+	error = dc_pad_connect(mdev);
+	if (error)
+		return error;
+
+	mdev->driver = mdrv;
+
+	return 0;
+}
+
+static int remove_maple_controller(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+
+	dc_pad_disconnect(mdev);
+	return 0;
+}
+
+static struct maple_driver dc_pad_driver = {
+	.function =	MAPLE_FUNC_CONTROLLER,
+	.connect =	dc_pad_connect,
+	.disconnect =	dc_pad_disconnect,
+	.drv = {
+		.name = "Dreamcast_controller",
+		.probe = probe_maple_controller,
+		.remove = remove_maple_controller,
+	},
+};
+
+static int unplug_maple_control(struct device *dev, void *ignored)
+{
+	/* Please DO NOT really unplug your controller */
+	struct maple_device *mdev;
+
+	mdev = to_maple_dev(dev);
+	if ((mdev->function & MAPLE_FUNC_CONTROLLER)
+		&& (mdev->driver == &dc_pad_driver))
+		remove_maple_controller(dev);
+
+	return 0;
+}
+
+static int __init dc_pad_init(void)
+{
+	return 	maple_driver_register(&dc_pad_driver.drv);
+}
+
+static void __exit dc_pad_exit(void)
+{
+	bus_for_each_dev(&maple_bus_type, NULL, NULL, unplug_maple_control);
+	driver_unregister(&dc_pad_driver.drv);
+}
+
+module_init(dc_pad_init);
+module_exit(dc_pad_exit);

