Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZINHE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZINHE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZINHEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:04:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:36095 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZINHEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:04:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH v2] input/keyboard: new OpenCores Keyboard Controller driver
Date: Mon, 14 Sep 2009 03:04:24 -0400
Message-Id: <1252911864-19233-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252894678-26929-1-git-send-email-vapier@gentoo.org>
References: <1252894678-26929-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Herrero <jherrero@hvsistemas.es>

Driver for the keyboard hardware documented here:
	http://www.opencores.org/project,keyboardcontroller

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- simpler file comment block
	- trim unused headers
	- switch to pr_* funcs
	- clean up probe() based on Andrey Panin's feedback
	- add missing "static" to opencores_kbd_device_driver
	- add missing ">" to MODULE_AUTHOR

 drivers/input/keyboard/Kconfig         |    9 ++
 drivers/input/keyboard/Makefile        |    1 +
 drivers/input/keyboard/opencores-kbd.c |  166 ++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/opencores-kbd.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index a6b989a..f0f4852 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -310,6 +310,15 @@ config KEYBOARD_SUNKBD
 	  To compile this driver as a module, choose M here: the
 	  module will be called sunkbd.
 
+config KEYBOARD_OPENCORES
+	tristate "OpenCores Keyboard Controller"
+	help
+	  Say Y here if you want to use the OpenCores Keyboard Controller
+	  http://www.opencores.org/project,keyboardcontroller
+
+	  To compile this driver as a module, choose M here; the
+	  module will be called opencores-kbd.
+
 config KEYBOARD_SH_KEYSC
 	tristate "SuperH KEYSC keypad support"
 	depends on SUPERH
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index b5b5eae..d333bc6 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_MATRIX)		+= matrix_keypad.o
 obj-$(CONFIG_KEYBOARD_NEWTON)		+= newtonkbd.o
 obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
+obj-$(CONFIG_KEYBOARD_OPENCORES)	+= opencores-kbd.o
 obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keypad.o
 obj-$(CONFIG_KEYBOARD_PXA930_ROTARY)	+= pxa930_rotary.o
 obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
new file mode 100644
index 0000000..10f011a
--- /dev/null
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -0,0 +1,166 @@
+/*
+ * OpenCores Keyboard Controller Driver
+ * http://www.opencores.org/project,keyboardcontroller
+ *
+ * Copyright 2007-2009 HV Sistemas S.L.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#define DRV_NAME "opencores-kbd"
+#define pr_fmt(fmt) DRV_NAME ": " fmt
+
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#define NUM_KEYS 128
+
+struct opencores_kbd {
+	struct input_dev *input;
+	struct resource *addr_res;
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
+	c = readb((void *)opencores_kbd->addr_res->start);
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
+	struct resource *addr_res, *irq_res;
+	int i, error;
+
+	addr_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (addr_res == NULL || irq_res == NULL) {
+		pr_err("missing board resources\n");
+		return -ENOENT;
+	}
+
+	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
+	if (!opencores_kbd)
+		return -ENOMEM;
+
+	opencores_kbd->keycode = kmalloc(NUM_KEYS * sizeof(unsigned short), GFP_KERNEL);
+	if (!opencores_kbd->keycode) {
+		error = -ENOMEM;
+		goto err_mem;
+	}
+	opencores_kbd->addr_res = addr_res;
+	opencores_kbd->irq_res = irq_res;
+	platform_set_drvdata(pdev, opencores_kbd);
+
+	input = input_allocate_device();
+	if (!input) {
+		error = -ENOMEM;
+		goto err_in_alloc;
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
+	error = input_register_device(input);
+	if (error) {
+		pr_err("unable to register input device\n");
+		goto err_in_reg;
+	}
+
+	error = request_irq(irq_res->start, &opencores_kbd_isr, IRQF_TRIGGER_RISING, pdev->name, pdev);
+	if (error) {
+		pr_err("unable to claim irq %d\n", irq_res->start);
+		goto err_irq;
+	}
+
+	return 0;
+
+ err_irq:
+	input_unregister_device(input);
+ err_in_reg:
+	input_free_device(input);
+ err_in_alloc:
+	kfree(opencores_kbd->keycode);
+ err_mem:
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
+static struct platform_driver opencores_kbd_device_driver = {
+	.probe    = opencores_kbd_probe,
+	.remove   = __devexit_p(opencores_kbd_remove),
+	.driver   = {
+		.name = DRV_NAME,
+	},
+};
+
+static int __init opencores_kbd_init(void)
+{
+	return platform_driver_register(&opencores_kbd_device_driver);
+}
+module_init(opencores_kbd_init);
+
+static void __exit opencores_kbd_exit(void)
+{
+	platform_driver_unregister(&opencores_kbd_device_driver);
+}
+module_exit(opencores_kbd_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Javier Herrero <jherrero@hvsistemas.es>");
+MODULE_DESCRIPTION("Keyboard driver for OpenCores Keyboard Controller");
-- 
1.6.4.2

