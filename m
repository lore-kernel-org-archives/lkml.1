Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbYA3RSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbYA3RSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYA3RSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:18:33 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:40641 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYA3RSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:18:32 -0500
X-IronPort-AV: E=Sophos;i="4.25,278,1199682000"; 
   d="scan'208";a="61242058"
Subject: [PATCH 1/1 try#2] [INPUT] keypad driver: Added support for
	OpenCores Keyboard Controller
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Will Newton <will.newton@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Javier Herrero <jherrero@hvsistemas.es>
In-Reply-To: <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com>
References: <1201686610-31458-1-git-send-email-bryan.wu@analog.com>
	 <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 31 Jan 2008 01:18:22 +0800
Message-Id: <1201713502.8345.1.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 30 Jan 2008 17:18:30.0504 (UTC) FILETIME=[2265DE80:01C86364]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2d1896f15eca96d887db9fff7988b7977e0b201d Mon Sep 17 00:00:00 2001
From: Javier Herrero <jherrero@hvsistemas.es>
Date: Thu, 31 Jan 2008 01:16:07 +0800
Subject: [PATCH] [INPUT] keypad driver: Added support for OpenCores Keyboard Controller

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/input/keyboard/Kconfig         |    9 ++
 drivers/input/keyboard/Makefile        |    2 +
 drivers/input/keyboard/opencores-kbd.c |  195 ++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/opencores-kbd.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 086d58c..c404cd4 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -293,4 +293,13 @@ config KEYBOARD_BFIN
 	  To compile this driver as a module, choose M here: the
 	  module will be called bf54x-keys.
 
+config KEYBOARD_OPENCORES
+	tristate "OpenCores Keyboard Controller"
+	help
+	 Say Y here if you want to use the OpenCores Keyboard Controller
+	 http://www.opencores.org/projects.cgi/web/keyboardcontroller/overview
+
+	 To compile this driver as a module, choose M here. the
+	 module will be called opencores-kbd.
+
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index e97455f..77b47fb 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -25,3 +25,5 @@ obj-$(CONFIG_KEYBOARD_HP6XX)		+= jornada680_kbd.o
 obj-$(CONFIG_KEYBOARD_HP7XX)		+= jornada720_kbd.o
 obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
+obj-$(CONFIG_KEYBOARD_OPENCORES)	+= opencores-kbd.o
+
diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
new file mode 100644
index 0000000..dfe68c6
--- /dev/null
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -0,0 +1,195 @@
+/*
+ * File:         drivers/input/keyboard/opencores-kbd.c
+ * Based on:	 bf54x-keys.c
+ * Author:       Javier Herrero <jherrero@hvsistemas.es>
+ *
+ * Created:
+ * Description:  OpenCores Keyboard Controller Driver
+ *		 http://www.opencores.org/projects.cgi/web/keyboardcontroller/overview
+ *
+ * Modified:
+ *               Copyright 2007 HV Sistemas S.L.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#include <linux/module.h>
+#include <linux/version.h>
+
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/sched.h>
+#include <linux/pm.h>
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/irq.h>
+
+#define DRV_NAME "opencores-kbd"
+#define NUM_KEYS 128
+
+struct opencores_kbd {
+	struct input_dev *input;
+	struct resource	*addr_res;
+	struct resource *irq_res;
+	unsigned short *keycode;
+};
+
+static irqreturn_t opencores_kbd_isr(int irq, void *dev_id)
+{
+	unsigned char c;
+	struct platform_device *pdev = dev_id;
+	struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
+	struct input_dev *input = opencores_kbd->input;
+
+	c = readb(opencores_kbd->addr_res->start);
+	input_report_key(input, c & 0x7f, c & 0x80 ? 0 : 1);
+	input_sync(input);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit opencores_kbd_probe(struct platform_device *pdev)
+{
+	struct input_dev *input;
+	struct opencores_kbd *opencores_kbd;
+	int i, error;
+
+	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
+	if (!opencores_kbd)
+		return -ENOMEM;
+
+	opencores_kbd->keycode = kmalloc(NUM_KEYS * sizeof(unsigned short), GFP_KERNEL);
+	if (!opencores_kbd->keycode) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	platform_set_drvdata(pdev, opencores_kbd);
+
+	opencores_kbd->addr_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	opencores_kbd->irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	if (opencores_kbd->addr_res == NULL || opencores_kbd->irq_res == NULL) {
+		printk(KERN_ERR "insufficient resources\n");
+		error = -ENOENT;
+		goto out1;
+	}
+
+	error = request_irq(opencores_kbd->irq_res->start, &opencores_kbd_isr, IRQF_TRIGGER_RISING, pdev->name, pdev);
+	if (error) {
+		printk(KERN_ERR DRV_NAME ": Unable to claim irq %d; error %d\n", opencores_kbd->irq_res->start, error);
+		goto out2;
+	}
+
+	input = input_allocate_device();
+	if (!input) {
+		error = -ENOMEM;
+		goto out3;
+	}
+
+	opencores_kbd->input = input;
+
+	input->name = pdev->name;
+	input->phys = "opencores-kbd/input0";
+	input->dev.parent = &pdev->dev;
+
+	input_set_drvdata(input, opencores_kbd);
+
+	input->id.bustype = BUS_HOST;
+	input->id.vendor = 0x0001;
+	input->id.product = 0x0001;
+	input->id.version = 0x0100;
+
+	input->keycodesize = sizeof(*opencores_kbd->keycode);
+	input->keycodemax = NUM_KEYS;
+	input->keycode = opencores_kbd->keycode;
+
+	__set_bit(EV_KEY, input->evbit);
+
+	for (i = 0; i < input->keycodemax; i++) {
+		opencores_kbd->keycode[i] = i;
+		__set_bit(opencores_kbd->keycode[i] & KEY_MAX, input->keybit);
+	}
+	__clear_bit(KEY_RESERVED, input->keybit);
+
+	error = input_register_device(opencores_kbd->input);
+	if (error) {
+		printk(KERN_ERR DRV_NAME ": Unable to register input device (%d)\n", error);
+		goto out2;
+	}
+
+	return 0;
+
+out3:
+	input_free_device(input);
+out2:
+	free_irq(opencores_kbd->irq_res->start, pdev);
+out1:
+	kfree(opencores_kbd->keycode);
+out:
+	kfree(opencores_kbd);
+	platform_set_drvdata(pdev, NULL);
+
+	return error;
+}
+
+static int __devexit opencores_kbd_remove(struct platform_device *pdev)
+{
+	struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
+
+	free_irq(opencores_kbd->irq_res->start, pdev);
+
+	input_unregister_device(opencores_kbd->input);
+
+	kfree(opencores_kbd->keycode);
+	kfree(opencores_kbd);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+struct platform_driver opencores_kbd_device_driver = {
+	.probe		= opencores_kbd_probe,
+	.remove		= __devexit_p(opencores_kbd_remove),
+	.driver		= {
+		.name	= DRV_NAME,
+	}
+};
+
+static int __init opencores_kbd_init(void)
+{
+	return platform_driver_register(&opencores_kbd_device_driver);
+}
+
+static void __exit opencores_kbd_exit(void)
+{
+	platform_driver_unregister(&opencores_kbd_device_driver);
+}
+
+module_init(opencores_kbd_init);
+module_exit(opencores_kbd_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Javier Herrero <jherrero@hvsistemas.es");
+MODULE_DESCRIPTION("Keyboard driver for OpenCores Keyboard Controller");
-- 
1.5.3.4

