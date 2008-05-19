Return-Path: <linux-kernel-owner+w=401wt.eu-S1763993AbYESXJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763993AbYESXJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYESXI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:08:56 -0400
Received: from 81.184.114.62.dyn.user.ono.com ([81.184.114.62]:59207 "EHLO
	pof.eslack.org." rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org
	with ESMTP id S1752902AbYESXIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:08:55 -0400
Message-ID: <4832087C.6060009@eslack.org>
Date: Tue, 20 May 2008 01:08:44 +0200
From: Pau Oliva Fora <pau@eslack.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Add support for HTC Shift Touchscreen
References: <482ED31E.2000009@eslack.org> <483198F8.3000201@eslack.org> <20080519112104.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080519112104.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pau Oliva Fora <pau@eslack.org>

The patch below adds support for HTC Shift UMPC touchscreen.

Signed-off-by: Pau Oliva Fora <pau@eslack.org>

---

Patch against linux-2.6.25.4, should apply clean on other versions too.
Includes all the suggestions from Sam Ravnborg, Pekka Enberg,
Marcin Slusarz and Dmitry Torokhov. Thank you all for your help.

diff -uprN linux-2.6.25.4/drivers/input/touchscreen/htcpen.c linux/drivers/input/touchscreen/htcpen.c
--- linux-2.6.25.4/drivers/input/touchscreen/htcpen.c	1970-01-01 01:00:00.000000000 +0100
+++ linux/drivers/input/touchscreen/htcpen.c	2008-05-20 00:55:42.000000000 +0200
@@ -0,0 +1,196 @@
+/*
+ * HTC Shift touchscreen driver
+ *
+ * Copyright (C) 2008 Pau Oliva Fora <pof@eslack.org>
+ *
+ * Thanks to:
+ * 	Heikki Linnakangas - Penmount LPC touchscreen driver
+ * 	Wacom / Ping Cheng - Help on linuxwacom-devel
+ * 	Esteve Espuna      - Ideas, tips, moral support :)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/isa.h>
+
+MODULE_AUTHOR("Pau Oliva Fora <pau@eslack.org>");
+MODULE_DESCRIPTION("HTC Shift touchscreen driver");
+MODULE_LICENSE("GPL");
+
+#define HTCPEN_PORT_IRQ_CLEAR 0x068
+#define HTCPEN_PORT_INIT 0x06c
+#define HTCPEN_PORT_INDEX 0x0250
+#define HTCPEN_PORT_DATA 0x0251
+#define HTCPEN_IRQ 3
+
+#define X_INDEX 3
+#define Y_INDEX 5
+#define TOUCH_INDEX 0xb
+#define LSB_XY_INDEX 0xc
+#define X_AXIS_MAX 2040
+#define Y_AXIS_MAX 2040
+#define DEVICE_ENABLE 0xa2
+
+static int invert_x;
+module_param(invert_x, bool, 0644);
+MODULE_PARM_DESC(invert_x, "If set, X axis is inverted");
+static int invert_y;
+module_param(invert_y, bool, 0644);
+MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
+
+static irqreturn_t htcpen_interrupt(int irq, void *handle)
+{
+	struct input_dev *htcpen_dev = handle;
+	unsigned short x, y, xy;
+
+	/* 0=press ; 1=release */
+	outb_p(TOUCH_INDEX, HTCPEN_PORT_INDEX);
+
+	/* only update X/Y when screen is being touched */
+	if (inb_p(HTCPEN_PORT_DATA)) {
+		input_report_key(htcpen_dev, BTN_TOUCH, 0);
+	} else {
+		outb_p(X_INDEX, HTCPEN_PORT_INDEX);
+		x = inb_p(HTCPEN_PORT_DATA);
+
+		outb_p(Y_INDEX, HTCPEN_PORT_INDEX);
+		y = inb_p(HTCPEN_PORT_DATA);
+
+		outb_p(LSB_XY_INDEX, HTCPEN_PORT_INDEX);
+		xy = inb_p(HTCPEN_PORT_DATA);
+
+		/* get high resolution value of X and Y using LSB */
+		x = X_AXIS_MAX - ((x * 8) + ((xy >> 4) & 0xf));
+		y = (y * 8) + (xy & 0xf);
+		if (invert_x)
+			x = X_AXIS_MAX - x;
+		if (invert_y)
+			y = Y_AXIS_MAX - y;
+
+		input_report_key(htcpen_dev, BTN_TOUCH, 1);
+		input_report_abs(htcpen_dev, ABS_X, x);
+		input_report_abs(htcpen_dev, ABS_Y, y);
+	}
+
+	input_sync(htcpen_dev);
+
+	inb_p(HTCPEN_PORT_IRQ_CLEAR);
+
+	return IRQ_HANDLED;
+}
+
+static int htcpen_open(struct input_dev *dev)
+{
+	outb_p(DEVICE_ENABLE, HTCPEN_PORT_INIT);
+	return 0;
+}
+
+static void htcpen_close(struct input_dev *dev)
+{
+	free_irq(HTCPEN_IRQ, dev);
+}
+
+static int __devinit htcpen_isa_probe(struct device *dev, unsigned int id)
+{
+	int err;
+	struct input_dev *htcpen_dev;
+
+	printk(KERN_ERR "principi del prove\n");
+
+	inb_p(HTCPEN_PORT_IRQ_CLEAR);
+
+	htcpen_dev = input_allocate_device();
+	if (!htcpen_dev) {
+		printk(KERN_ERR "htcpen: can't allocate device\n");
+		err = -ENOMEM;
+		goto input_alloc_failed;
+	}
+
+	htcpen_dev->name = "HTC Pen TouchScreen";
+	htcpen_dev->id.bustype = BUS_ISA;
+
+	input_set_abs_params(htcpen_dev, ABS_X, 0, X_AXIS_MAX, 0, 0);
+	input_set_abs_params(htcpen_dev, ABS_Y, 0, Y_AXIS_MAX, 0, 0);
+
+	htcpen_dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
+	htcpen_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+	htcpen_dev->open = htcpen_open;
+	htcpen_dev->close = htcpen_close;
+
+	err = request_irq(HTCPEN_IRQ, htcpen_interrupt, 0, "htcpen",
+		htcpen_dev);
+	if (err) {
+		printk(KERN_ERR "htcpen: irq busy\n");
+		goto request_irq_failed;
+	}
+
+	err = input_register_device(htcpen_dev);
+	if (err)
+		goto input_register_failed;
+
+	dev_set_drvdata(dev, htcpen_dev);
+	return 0;
+
+ input_register_failed:
+	free_irq(HTCPEN_IRQ, htcpen_dev);
+ request_irq_failed:
+	input_free_device(htcpen_dev);
+ input_alloc_failed:
+	return err;
+}
+
+static int __devinit htcpen_isa_match(struct device *dev, unsigned int id)
+{
+	unsigned short val1, val2;
+
+	/* device detection */
+	outb_p(0x8, HTCPEN_PORT_INIT);
+	val1 = inb_p(HTCPEN_PORT_INIT);
+	val2 = inb_p(HTCPEN_PORT_IRQ_CLEAR);
+	if ((val1 > 0xc) || (val2 != 0x55)) {
+		printk(KERN_DEBUG "htcpen: no such device (%x|%x)\n",
+			val1, val2);
+		return 0;
+	}
+	return 1;
+}
+
+static int __devexit htcpen_isa_remove(struct device *dev, unsigned int id)
+{
+	input_unregister_device(dev_get_drvdata(dev));
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct isa_driver htcpen_isa_driver = {
+	.match		= htcpen_isa_match,
+	.probe		= htcpen_isa_probe,
+	.remove		= __devexit_p(htcpen_isa_remove),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "htcpen",
+	}
+};
+
+static int __init htcpen_isa_init(void)
+{
+	return isa_register_driver(&htcpen_isa_driver, 1);
+}
+
+static void __exit htcpen_isa_exit(void)
+{
+	isa_unregister_driver(&htcpen_isa_driver);
+}
+
+module_init(htcpen_isa_init);
+module_exit(htcpen_isa_exit);
diff -uprN linux-2.6.25.4/drivers/input/touchscreen/Kconfig linux/drivers/input/touchscreen/Kconfig
--- linux-2.6.25.4/drivers/input/touchscreen/Kconfig	2008-05-15 17:00:12.000000000 +0200
+++ linux/drivers/input/touchscreen/Kconfig	2008-05-19 15:48:52.000000000 +0200
@@ -134,6 +134,18 @@ config TOUCHSCREEN_HP7XX
  	  To compile this driver as a module, choose M here: the
  	  module will be called jornada720_ts.

+config TOUCHSCREEN_HTCPEN
+	tristate "HTC Shift X9500 touchscreen"
+	depends on ISA
+	help
+	  Say Y here if you have an HTC Shift UMPC also known as HTC X9500
+	  Clio / Shangrila and want to support the built-in touchscreen.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called htcpen.
+
  config TOUCHSCREEN_PENMOUNT
  	tristate "Penmount serial touchscreen"
  	select SERIO
diff -uprN linux-2.6.25.4/drivers/input/touchscreen/Makefile linux/drivers/input/touchscreen/Makefile
--- linux-2.6.25.4/drivers/input/touchscreen/Makefile	2008-05-15 17:00:12.000000000 +0200
+++ linux/drivers/input/touchscreen/Makefile	2008-05-17 03:10:12.000000000 +0200
@@ -14,6 +14,7 @@ obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtou
  obj-$(CONFIG_TOUCHSCREEN_MK712)		+= mk712.o
  obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
  obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
+obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+= htcpen.o
  obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
  obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
--- linux-2.6.25.4/MAINTAINERS	2008-05-15 17:00:12.000000000 +0200
+++ linux/MAINTAINERS	2008-05-19 15:40:11.000000000 +0200
@@ -1875,6 +1875,12 @@ M:	mikulas@artax.karlin.mff.cuni.cz
  W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
  S:	Maintained

+HTCPEN TOUCHSCREEN DRIVER
+P:	Pau Oliva Fora
+M:	pof@eslack.org
+L:	linux-input@vger.kernel.org
+S:	Maintained
+
  HUGETLB FILESYSTEM
  P:	William Irwin
  M:	wli@holomorphy.com
