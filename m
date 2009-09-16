Return-Path: <linux-kernel-owner+w=401wt.eu-S1751167AbZIPEKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbZIPEKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZIPEKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:10:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50693 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZIPEKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:10:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <cooloney@kernel.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v5] input/keyboard: new OpenCores Keyboard Controller driver
Date: Wed, 16 Sep 2009 00:10:03 -0400
Message-Id: <1253074203-21302-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <20090916034555.GA2756@core.coreip.homeip.net>
References: <20090916034555.GA2756@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Herrero <jherrero@hvsistemas.es>

Driver for the keyboard hardware documented here:
	http://www.opencores.org/project,keyboardcontroller

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
v5
	- add missing memory release in remove

 drivers/input/keyboard/Kconfig         |    9 ++
 drivers/input/keyboard/Makefile        |    1 +
 drivers/input/keyboard/opencores-kbd.c |  180 ++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/opencores-kbd.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 3525c19..e363077 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -311,6 +311,15 @@ config KEYBOARD_SUNKBD
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
index 8a7a22b..ab35ac3 100644
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
index 0000000..78cccdd
--- /dev/null
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -0,0 +1,180 @@
+/*
+ * OpenCores Keyboard Controller Driver
+ * http://www.opencores.org/project,keyboardcontroller
+ *
+ * Copyright 2007-2009 HV Sistemas S.L.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+struct opencores_kbd {
+	struct input_dev *input;
+	struct resource *addr_res;
+	void __iomem *addr;
+	int irq;
+	unsigned short keycodes[128];
+};
+
+static irqreturn_t opencores_kbd_isr(int irq, void *dev_id)
+{
+	struct opencores_kbd *opencores_kbd = dev_id;
+	struct input_dev *input = opencores_kbd->input;
+	unsigned char c;
+
+	c = readb(opencores_kbd->addr);
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
+	struct resource *res;
+	int irq, i, error;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "missing board memory resource\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "missing board IRQ resource\n");
+		return -EINVAL;
+	}
+
+	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!opencores_kbd || !input) {
+		dev_err(&pdev->dev, "failed to allocate device structures\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	opencores_kbd->addr_res = res;
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		error = -EBUSY;
+		goto err_free_mem;
+	}
+
+	opencores_kbd->addr = ioremap(res->start, resource_size(res));
+	if (!opencores_kbd->addr) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -ENXIO;
+		goto err_rel_mem;
+	}
+
+	opencores_kbd->input = input;
+	opencores_kbd->irq = irq;
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
+	input->keycode = opencores_kbd->keycodes;
+	input->keycodesize = sizeof(opencores_kbd->keycodes[0]);
+	input->keycodemax = ARRAY_SIZE(opencores_kbd->keycodes);
+
+	__set_bit(EV_KEY, input->evbit);
+
+	for (i = 0; i < ARRAY_SIZE(opencores_kbd->keycodes); i++) {
+		/*
+		 * OpenCores controller happens to have scancodes match
+		 * our KEY_* definitions.
+		 */
+		opencores_kbd->keycodes[i] = i;
+		__set_bit(opencores_kbd->keycodes[i], input->keybit);
+	}
+	__clear_bit(KEY_RESERVED, input->keybit);
+
+	error = request_irq(irq, &opencores_kbd_isr,
+			    IRQF_TRIGGER_RISING, pdev->name, opencores_kbd);
+	if (error) {
+		dev_err(&pdev->dev, "unable to claim irq %d\n", irq);
+		goto err_unmap_mem;
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&pdev->dev, "unable to register input device\n");
+		goto err_free_irq;
+	}
+
+	platform_set_drvdata(pdev, opencores_kbd);
+
+	return 0;
+
+ err_free_irq:
+	free_irq(irq, opencores_kbd);
+ err_unmap_mem:
+	iounmap(opencores_kbd->addr);
+ err_rel_mem:
+	release_mem_region(res->start, resource_size(res));
+ err_free_mem:
+	input_free_device(input);
+	kfree(opencores_kbd);
+
+	return error;
+}
+
+static int __devexit opencores_kbd_remove(struct platform_device *pdev)
+{
+	struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
+
+	free_irq(opencores_kbd->irq, opencores_kbd);
+
+	iounmap(opencores_kbd->addr);
+	release_mem_region(opencores_kbd->addr_res->start,
+		resource_size(opencores_kbd->addr_res));
+	input_unregister_device(opencores_kbd->input);
+	kfree(opencores_kbd);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver opencores_kbd_device_driver = {
+	.probe    = opencores_kbd_probe,
+	.remove   = __devexit_p(opencores_kbd_remove),
+	.driver   = {
+		.name = "opencores-kbd",
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
1.6.5.rc1

