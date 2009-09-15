Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZIOFwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZIOFwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 01:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZIOFw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 01:52:28 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:21558 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZIOFw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 01:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U25SrDbZFDzgF35ZsSR1ZsUTLPaqcx+fNRHaytOWb69IYwyKVdWMYJemh8XDm3VxwA
         hLFI525MB8hdzsagkdNUAzMNfjNMC4ZGgbZ+nSDCrdD0vKSqSP/fHwmz5ABsEmzEspPs
         UnKyOTJJkxICoYFKQIPxhRTVeKLE1zbA4cSA8=
Date: Mon, 14 Sep 2009 22:52:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Javier Herrero <jherrero@hvsistemas.es>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] input/keyboard: new OpenCores Keyboard Controller
	driver
Message-ID: <20090915055224.GD1132@core.coreip.homeip.net>
References: <1252911864-19233-1-git-send-email-vapier@gentoo.org> <1252950003-9451-1-git-send-email-vapier@gentoo.org> <200909141049.50705.dmitry.torokhov@gmail.com> <8bd0f97a0909141102l5fa309f4ua1bedd0f1ac99295@mail.gmail.com> <4AAE8908.1000104@hvsistemas.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAE8908.1000104@hvsistemas.es>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 08:18:48PM +0200, Javier Herrero wrote:
> Hello,
>
> It has a bit long since last time I touched the driver, so I should also  
> try to refresh my memory about it :). I suppose that you're right in the  
> double allocation issue (I took another keyboard driver as a starting  
> point and probably the double allocation was already there...), so feel  
> free to introduce the change and I will test it as soon as I can.
>
> About the exact scancode - key mapping, the reason is that since the  
> FPGA opencores device already implements a translation table, I found  
> that another translation table sounded a bit redundant.
>

OK, below is what I have now... One concern though - don't we need to do
request_mem_region/ioremap for the addr_res?

-- 
Dmitry

Input: add driver for OpenCores Keyboard Controller

From: Javier Herrero <jherrero@hvsistemas.es>

Driver for the keyboard hardware documented here:
	http://www.opencores.org/project,keyboardcontroller

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/Kconfig         |    9 ++
 drivers/input/keyboard/Makefile        |    1 
 drivers/input/keyboard/opencores-kbd.c |  162 ++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+), 0 deletions(-)
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
index 0000000..1bff086
--- /dev/null
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -0,0 +1,162 @@
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
+#define NUM_KEYS 128
+
+struct opencores_kbd {
+	struct input_dev *input;
+	void __iomem *addr;
+	int irq;
+	struct resource *irq_res;
+	unsigned short keycodes[NUM_KEYS];
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
+	struct resource *addr_res;
+	int irq;
+	int i, error;
+
+	addr_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!addr_res) {
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
+	opencores_kbd->input = input;
+	opencores_kbd->addr = (void __force __iomem *)addr_res->start;
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
+		goto err_free_mem;
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
+		.name = KBUILD_MODNAME,
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
