Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYERTTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYERTTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYERTTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 15:19:19 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:37927 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbYERTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 15:19:17 -0400
X-Trace: 13500791/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.86.247
X-SBRS: None
X-RemoteIP: 81.1.86.247
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsFAE8dMEhRAVb3/2dsb2JhbACBVaoS
Subject: [PATCH] input: add support for SEGA Dreamcast controller as
	joystick
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Sun, 18 May 2008 20:18:42 +0100
Message-Id: <1211138322.6354.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a Maple controller as a joystick device.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
diff -ruN a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
--- a/drivers/input/joystick/Kconfig	2008-05-18 20:04:42.000000000 +0100
+++ b/drivers/input/joystick/Kconfig	2008-05-18 19:53:42.000000000 +0100
@@ -294,4 +294,17 @@
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
diff -ruN a/drivers/input/joystick/Makefile b/drivers/input/joystick/Makefile
--- a/drivers/input/joystick/Makefile	2008-05-18 20:04:42.000000000 +0100
+++ b/drivers/input/joystick/Makefile	2008-05-18 19:53:42.000000000 +0100
@@ -19,6 +19,7 @@
 obj-$(CONFIG_JOYSTICK_INTERACT)		+= interact.o
 obj-$(CONFIG_JOYSTICK_JOYDUMP)		+= joydump.o
 obj-$(CONFIG_JOYSTICK_MAGELLAN)		+= magellan.o
+obj-$(CONFIG_JOYSTICK_MAPLE)		+= maplecontrol.o
 obj-$(CONFIG_JOYSTICK_SIDEWINDER)	+= sidewinder.o
 obj-$(CONFIG_JOYSTICK_SPACEBALL)	+= spaceball.o
 obj-$(CONFIG_JOYSTICK_SPACEORB)		+= spaceorb.o
diff -ruN a/drivers/input/joystick/maplecontrol.c b/drivers/input/joystick/maplecontrol.c
--- a/drivers/input/joystick/maplecontrol.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/input/joystick/maplecontrol.c	2008-05-18 19:53:42.000000000 +0100
@@ -0,0 +1,217 @@
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
+static void dc_pad_disconnect(struct maple_device *mdev)
+{
+	struct dc_pad *pad = mdev->private_data;
+
+	mdev->callback = NULL;
+	input_unregister_device(pad->dev);
+	kfree(pad);
+}
+
+static int dc_pad_open(struct input_dev *dev)
+{
+	struct dc_pad *pad;
+
+	pad = dev->dev.platform_data;
+	maple_getcond_callback(pad->mdev, dc_pad_callback, HZ/20,
+		MAPLE_FUNC_CONTROLLER);
+	return 0;
+}
+
+static void dc_pad_close(struct input_dev *dev)
+{
+	struct dc_pad *pad;
+	
+	pad = dev->dev.platform_data;
+	maple_getcond_callback(pad->mdev, dc_pad_callback, 0,
+		MAPLE_FUNC_CONTROLLER);
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
+	dev->open = dc_pad_open;
+	dev->close = dc_pad_close;
+
+	for (i = 0; i < 32; i++)
+		if (data & (1<<i) && btn_bit[i] >= 0)
+			dev->keybit[BIT_WORD(BTN_JOYSTICK)] |= BIT_MASK(btn_bit[i]);
+
+	if (dev->keybit[BTN_JOYSTICK/32])
+		dev->evbit[0] |= BIT_MASK(EV_KEY);
+
+	for (i = 0; i < 32; i++)
+		if (data & (1<<i) && abs_bit[i] >= 0)
+			dev->absbit[0] |= BIT_MASK(abs_bit[i]);
+
+	if (dev->absbit[0])
+		dev->evbit[0] |= BIT_MASK(EV_ABS);
+
+	for (i = ABS_X; i <= ABS_BRAKE; i++)
+		input_set_abs_params(dev, i, 0, 255, 0, 0);
+
+	for (i = ABS_HAT0X; i <= ABS_HAT3Y; i++)
+		input_set_abs_params(dev, i, 1, -1, 0, 0);
+
+	dev->dev.platform_data = pad;
+	dev->event = NULL;
+	dev->dev.parent = &mdev->dev;
+	dev->name = mdev->product_name;
+	dev->id.bustype = BUS_HOST;
+	input_set_drvdata(dev, pad);
+
+	error = input_register_device(dev);
+	if (error)
+		goto fail_register;
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
+static int __init dc_pad_init(void)
+{
+	return 	maple_driver_register(&dc_pad_driver.drv);
+}
+
+static void __exit dc_pad_exit(void)
+{
+	driver_unregister(&dc_pad_driver.drv);
+}
+
+module_init(dc_pad_init);
+module_exit(dc_pad_exit);


