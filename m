Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYEQMob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYEQMob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 08:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYEQMoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 08:44:22 -0400
Received: from 81.184.114.62.dyn.user.ono.com ([81.184.114.62]:40024 "EHLO
	pof.eslack.org." rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org
	with ESMTP id S1753127AbYEQMoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 08:44:20 -0400
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 08:44:20 EDT
Message-ID: <482ED31E.2000009@eslack.org>
Date: Sat, 17 May 2008 14:44:14 +0200
From: Pau Oliva Fora <pau@eslack.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for HTC Shift Touchscreen
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


diff -uprN linux-2.6.25.4/drivers/input/touchscreen/htcpen.c linux/drivers/input/touchscreen/htcpen.c
--- linux-2.6.25.4/drivers/input/touchscreen/htcpen.c	1970-01-01 01:00:00.000000000 +0100
+++ linux/drivers/input/touchscreen/htcpen.c	2008-05-17 13:48:57.000000000 +0200
@@ -0,0 +1,148 @@
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
+ * Changelog:
+ *   29980517 v0.5 - code cleanup
+ *   29980517 v0.4 - initialization works (thanks esteve!)
+ *   20080514 v0.3 - works best with TouchKit egalax xorg driver
+ *   20080511 v0.2 - little hacks to make it more usable
+ *   20080510 v0.1 - works with evtouch driver
+ *   20080428 first non-working attempt
+ */
+
+/*
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
+
+#define DRIVER_VERSION		"v0.5"
+#define DRIVER_DESC	"HTC Shift touchscreen driver"
+
+MODULE_AUTHOR("Pau Oliva Fora <pau@eslack.org>");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+
+#define HTCPEN_PORT0 0x068
+#define HTCPEN_PORT1 0x06c
+#define HTCPEN_PORT2 0x0250
+#define HTCPEN_PORT3 0x0251
+#define HTCPEN_IRQ 3
+
+static int inverse_y;
+module_param(inverse_y, bool, 0644);
+MODULE_PARM_DESC(inverse_y, "If set Y axe is inversed.");
+
+struct input_dev *htcpen_dev;
+
+static void poll_htcpen(void)
+{
+
+	unsigned short x, y, xy;
+	unsigned short touch;
+
+	/* 0=press ; 1=release */
+	outb_p(0xb, HTCPEN_PORT2);
+	touch = inb_p(HTCPEN_PORT3);
+	if (touch)
+		touch = 0;
+	else
+		touch = 1;
+
+	input_report_key(htcpen_dev, BTN_TOUCH, touch);
+
+	/* only update x/y when screen is being touched */
+	if (touch) {
+		outb_p(3, HTCPEN_PORT2);
+		x = inb_p(HTCPEN_PORT3);
+
+		outb_p(5, HTCPEN_PORT2);
+		y = inb_p(HTCPEN_PORT3);
+
+		outb_p(0xc, HTCPEN_PORT2);
+		xy = inb_p(HTCPEN_PORT3);
+
+		x = 8*255-((x*8)+((xy>>4)&0xf));
+		y = (y*8)+(xy&0xf);
+		if (inverse_y)
+			y = 8*255-y;
+
+		input_report_abs(htcpen_dev, ABS_X, x);
+		input_report_abs(htcpen_dev, ABS_Y, y);
+	}
+
+	input_sync(htcpen_dev);
+
+	inb_p(HTCPEN_PORT0);
+}
+
+static irqreturn_t htcpen_interrupt(int irq, void *handle)
+{
+	poll_htcpen();
+	return IRQ_HANDLED;
+}
+
+
+static int __init htcpen_init(void)
+{
+
+	printk(KERN_INFO "htcpen: module inserted\n");
+
+	inb_p(HTCPEN_PORT0);
+
+	htcpen_dev = input_allocate_device();
+	if (!htcpen_dev) {
+		printk(KERN_ERR "htcpen: can't allocate device\n");
+		return -ENOMEM;
+	}
+
+	if (request_irq(HTCPEN_IRQ, htcpen_interrupt, 0, "htcpen", NULL)) {
+		printk(KERN_ERR "htcpen: irq busy\n");
+		return -EBUSY;
+	}
+
+	htcpen_dev->name = "HTC Pen TouchScreen";
+	htcpen_dev->id.bustype = BUS_ISA;
+	htcpen_dev->id.vendor = 0;
+	htcpen_dev->id.product = 0;
+	htcpen_dev->id.version = 0;
+
+	input_set_abs_params(htcpen_dev, ABS_X, 0, 255*8, 0, 0);
+	input_set_abs_params(htcpen_dev, ABS_Y, 0, 255*8, 0, 0);
+
+	htcpen_dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
+	htcpen_dev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y);
+	htcpen_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+
+	input_register_device(htcpen_dev);
+
+	outb_p(0xa2, HTCPEN_PORT1);
+
+	return 0;
+}
+
+static void __exit htcpen_exit(void)
+{
+	input_unregister_device(htcpen_dev);
+	free_irq(HTCPEN_IRQ, NULL);
+	printk(KERN_INFO "htcpen: module removed\n");
+}
+
+module_init(htcpen_init);
+module_exit(htcpen_exit);
diff -uprN linux-2.6.25.4/drivers/input/touchscreen/Kconfig linux/drivers/input/touchscreen/Kconfig
--- linux-2.6.25.4/drivers/input/touchscreen/Kconfig	2008-05-15 17:00:12.000000000 +0200
+++ linux/drivers/input/touchscreen/Kconfig	2008-05-17 03:23:14.000000000 +0200
@@ -134,6 +134,17 @@ config TOUCHSCREEN_HP7XX
  	  To compile this driver as a module, choose M here: the
  	  module will be called jornada720_ts.

+config TOUCHSCREEN_HTCPEN
+	tristate "HTC Shift X9500 touchscreen"
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

