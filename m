Return-Path: <linux-kernel-owner+w=401wt.eu-S2992554AbXCBQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992554AbXCBQFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992559AbXCBQFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:05:38 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:44469 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992554AbXCBQFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:05:36 -0500
Date: Fri, 2 Mar 2007 17:05:41 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, Nicolas Pitre <nico@cam.org>
Message-ID: <20070302160540.GA5001@enneenne.com>
References: <20061120155518.GA6910@enneenne.com> <20061120160516.GC6910@enneenne.com> <200611240109.22900.dtor@insightbb.com> <20070222224701.GB6179@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20070222224701.GB6179@enneenne.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] INPUT/keyboard: PXA27x keyboard support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello, here my last patch for the PXA27x keyboard support updated to
linux-2.6.21-rc2.

I added power management support (suspend/resume code).

Machines should call the driver with the following code:

static struct pxa27x_keyboard_platform_data wwpc1100_kbd = {
        .nr_rows = 4,
        .nr_cols = 4,
        .keycodes = {
                {
                        /* row 0 */
                        KEY_ESC,
                        KEY_ENTER,
                        KEY_F1,
                        -1,
                }, {    /* row 1 */
                        KEY_F2,
                        KEY_F3,
                        KEY_F4,
                        -1,
                }, {    /* row 2 */
                        KEY_UP,
                        KEY_LEFT,
                        KEY_RIGHT,
                        -1,
                }, {    /* row 3 */
                        KEY_DOWN,
                        -1,
                        -1,
                        -1,
                },
        },
        .gpio_modes = {
                 GPIO100_KP_MKIN0,
                 GPIO101_KP_MKIN1,
                 GPIO102_KP_MKIN2,
                 GPIO97_KP_MKIN3,
                 GPIO103_KP_MKOUT0,
                 GPIO104_KP_MKOUT1,
                 GPIO105_KP_MKOUT2,
                 GPIO106_KP_MKOUT3,
         },
};

static struct platform_device wwpc1100_keyboard = {
        .name   = "pxa27x-keyboard",
        .id     = -1,
        .dev    =  {
                .platform_data  = &wwpc1100_kbd,
        },
};

static struct platform_device *platform_devices[] __initdata = {
        &wwpc1100_audio_device,
        &wwpc1100_keyboard,
        &wwpc1100_lcd_bl_device,
        &wwpc1100_keyb_bl_device,
};


Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>

---
--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=pxa27x-keyboard-support

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 6450968..18ce7b1 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -203,6 +203,12 @@ config KEYBOARD_OMAP
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap-keypad.
 
+config KEYBOARD_PXA27x
+	tristate "PXA27x keyboard support"
+	depends on PXA27x
+	help
+	  Enable support for PXA27x matrix keyboard controller
+
 config KEYBOARD_AAED2000
 	tristate "AAED-2000 keyboard"
 	depends on MACH_AAED2000
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 586a0fe..fc1d1f2 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_KEYBOARD_SPITZ)		+= spitzkbd.o
 obj-$(CONFIG_KEYBOARD_HIL)		+= hil_kbd.o
 obj-$(CONFIG_KEYBOARD_HIL_OLD)		+= hilkbd.o
 obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
+obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keyboard.o
 obj-$(CONFIG_KEYBOARD_AAED2000)		+= aaed2000_kbd.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
 
diff --git a/drivers/input/keyboard/pxa27x_keyboard.c b/drivers/input/keyboard/pxa27x_keyboard.c
new file mode 100644
index 0000000..c01089a
--- /dev/null
+++ b/drivers/input/keyboard/pxa27x_keyboard.c
@@ -0,0 +1,257 @@
+/*
+ * linux/drivers/input/keyboard/pxa27x_keyboard.c
+ *
+ * Driver for the pxa27x matrix keyboard controller.
+ *
+ * Created:	Feb 22, 2007 
+ * Author:	Rodolfo Giometti <giometti@linux.it>
+ *
+ * Based on a previous implementations by Kevin O'Connor
+ * <kevin_at_koconnor.net> and Alex Osborne <bobofdoom@gmail.com> and
+ * on some suggestions by Nicolas Pitre <nico@cam.org>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include <asm/arch/hardware.h>
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/irqs.h>
+#include <asm/arch/pxa27x_keyboard.h>
+
+#define DRIVER_NAME		"pxa27x-keyboard"
+
+#define KPASMKP(col)		(col/2 == 0 ? KPASMKP0 : \
+				 col/2 == 1 ? KPASMKP1 : \
+				 col/2 == 2 ? KPASMKP2 : KPASMKP3)
+#define KPASMKPx_MKC(row, col)	(1<<(row+16*(col%2)))
+
+static irqreturn_t pxakbd_irq_handler(int irq, void *dev_id)
+{
+	struct device *dev = dev_id;
+	struct pxa27x_keyboard_platform_data *pdev = dev->platform_data;
+	struct input_dev *button_dev = dev->driver_data;
+	unsigned long kpc = KPC;
+	int p, row, col, rel;
+
+	if (kpc & KPC_DI) {
+		unsigned long kpdk = KPDK;
+
+		if (!(kpdk & KPDK_DKP)) {
+			/* better luck next time */
+		} else if (kpc & KPC_REE0) {
+			unsigned long kprec = KPREC;
+			KPREC = 0x7f;
+
+			if (kprec & KPREC_OF0)
+				rel = (kprec & 0xff) + 0x7f;
+			else if (kprec & KPREC_UF0)
+				rel = (kprec & 0xff) - 0x7f - 0xff;
+			else
+				rel = (kprec & 0xff) - 0x7f;
+
+			if (rel)
+				input_report_rel(button_dev, REL_WHEEL, rel);
+		}
+	}
+
+	if (kpc & KPC_MI) {
+		/* report the status of every button */
+		for (row = 0; row < pdev->nr_rows; row++) {
+			for (col = 0; col < pdev->nr_cols; col++) {
+				p = KPASMKP(col) & KPASMKPx_MKC(row, col) ?
+					1 : 0;
+				pr_debug("keycode %x - pressed %x\n",
+						pdev->keycodes[row][col], p);
+				input_report_key(button_dev,
+						pdev->keycodes[row][col], p);
+			}
+		}
+		input_sync(button_dev);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int pxakbd_open(struct input_dev *dev)
+{
+	/* Set keypad control register */
+	KPC |= (KPC_ASACT |
+		KPC_MS_ALL |
+		(2<<6) | KPC_REE0 | KPC_DK_DEB_SEL |
+		KPC_ME | KPC_MIE | KPC_DE | KPC_DIE);
+
+	KPC &= ~KPC_AS;         /* disable automatic scan */
+	KPC &= ~KPC_IMKP;       /* do not ignore multiple keypresses */
+
+	/* Set rotary count to mid-point value */
+	KPREC = 0x7F;
+
+	/* Enable unit clock */
+	pxa_set_cken(CKEN19_KEYPAD, 1);
+
+	return 0;
+}
+
+static void pxakbd_close(struct input_dev *dev)
+{
+	/* Disable clock unit */
+	pxa_set_cken(CKEN19_KEYPAD, 0);
+}
+
+#ifdef CONFIG_PM
+static int pxakbd_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct pxa27x_keyboard_platform_data *pdata = pdev->dev.platform_data;
+
+	/* Save controller status */
+	pdata->reg_kpc = KPC;
+	pdata->reg_kprec = KPREC;
+
+	return 0;
+}
+
+static int pxakbd_resume(struct platform_device *pdev)
+{
+	struct pxa27x_keyboard_platform_data *pdata = pdev->dev.platform_data;
+
+	/* Restore controller status */
+	KPC = pdata->reg_kpc;
+	KPREC = pdata->reg_kprec;
+		
+	/* Enable unit clock */
+	pxa_set_cken(CKEN19_KEYPAD, 1);
+
+	return 0;
+}
+#else
+#define pxakbd_suspend	NULL
+#define pxakbd_resume	NULL
+#endif
+
+static int pxakbd_probe(struct platform_device *pdev)
+{
+	struct pxa27x_keyboard_platform_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct input_dev *button_dev;
+	int i, row, col, err;
+
+	/* Create and register the input driver. */
+	button_dev = input_allocate_device();
+	if (!button_dev) {
+		printk(KERN_ERR "Cannot request keypad device\n");
+		return -1;
+	}
+
+	set_bit(EV_KEY, button_dev->evbit);
+	set_bit(EV_REP, button_dev->evbit);
+	set_bit(EV_REL, button_dev->evbit);
+	set_bit(REL_WHEEL, button_dev->evbit);
+	for (row = 0; row < pdata->nr_rows; row++) {
+		for (col = 0; col < pdata->nr_cols; col++) {
+			int code = pdata->keycodes[row][col];
+			if (code <= 0)
+				continue;
+			set_bit(code, button_dev->keybit);
+		}
+	}
+
+        err = request_irq(IRQ_KEYPAD, pxakbd_irq_handler, SA_INTERRUPT,
+			  DRIVER_NAME, dev);
+	if (err) {
+		printk(KERN_ERR "Cannot request keypad IRQ\n");
+		pxa_set_cken(CKEN19_KEYPAD, 0);
+		return -1;
+	}
+
+	/* Register the input device */
+	button_dev->name = DRIVER_NAME;
+	button_dev->id.bustype = BUS_HOST;
+	button_dev->open = pxakbd_open;
+	button_dev->close = pxakbd_close;
+
+	err = input_register_device(button_dev);
+	if (err)
+		goto input_register_device_error;
+
+	platform_set_drvdata(pdev, button_dev);
+
+	/* Setup GPIOs. */
+	for (i = 0; i < pdata->nr_rows + pdata->nr_cols; i++)
+		pxa_gpio_mode(pdata->gpio_modes[i]);
+
+	/*
+	 * Store rows/cols info into keyboard registers.
+	 */
+
+	KPC |= (pdata->nr_rows-1) << 26;
+	KPC |= (pdata->nr_cols-1) << 23;
+
+	for (col = 0; col < pdata->nr_cols; col++)
+		KPC |= KPC_MS0<<col;
+
+	printk(KERN_INFO "PXA27x keyboard controller enabled\n");
+
+	return 0;
+
+input_register_device_error :
+	free_irq(IRQ_KEYPAD, button_dev);
+	input_free_device(button_dev);
+
+	return -ENOMEM;
+}
+
+static int __devexit pxakbd_remove(struct platform_device *pdev)
+{
+	struct input_dev *button_dev = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+
+	free_irq(IRQ_KEYPAD, dev);
+
+	input_unregister_device(button_dev);
+	input_free_device(button_dev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver pxakbd_driver = {
+	.probe  = pxakbd_probe,
+	.remove = __devexit_p(pxakbd_remove),
+	.suspend = pxakbd_suspend,
+	.resume = pxakbd_resume,
+	.driver	= {
+		.name	= DRIVER_NAME,
+	},
+};
+
+static int __init pxakbd_init(void)
+{
+	return platform_driver_register(&pxakbd_driver);
+}
+
+static void __exit pxakbd_exit(void)
+{
+	platform_driver_unregister(&pxakbd_driver);
+}
+
+module_init(pxakbd_init);
+module_exit(pxakbd_exit);
+
+MODULE_DESCRIPTION("PXA27x Matrix Keyboard Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/asm-arm/arch-pxa/pxa27x_keyboard.h b/include/asm-arm/arch-pxa/pxa27x_keyboard.h
new file mode 100644
index 0000000..3aaff92
--- /dev/null
+++ b/include/asm-arm/arch-pxa/pxa27x_keyboard.h
@@ -0,0 +1,13 @@
+#define PXAKBD_MAXROW		8
+#define PXAKBD_MAXCOL		8
+
+struct pxa27x_keyboard_platform_data {
+	int nr_rows, nr_cols;
+	int keycodes[PXAKBD_MAXROW][PXAKBD_MAXCOL];
+	int gpio_modes[PXAKBD_MAXROW + PXAKBD_MAXCOL];
+
+#ifdef CONFIG_PM
+	u32 reg_kpc;
+	u32 reg_kprec;
+#endif
+};

--VbJkn9YxBvnuCH5J--
