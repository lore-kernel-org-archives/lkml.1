Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbXJLQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbXJLQF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXJLQFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:05:14 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:32815 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbXJLQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:05:11 -0400
X-IronPort-AV: i="4.21,267,1188792000"; 
   d="scan'208"; a="53876231:sNHT55006364"
Subject: [PATCH try #4] Blackfin BF54x Input Keypad controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>, linux-input@atrey.karlin.mff.cuni.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Sat, 13 Oct 2007 00:05:02 +0800
Message-Id: <1192205102.7089.15.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 12 Oct 2007 16:05:09.0880 (UTC) FILETIME=[A9FB6F80:01C80CE9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH try #4] Blackfin BF54x Input Keypad controller driver

[try #2] Changelog:
 - Coding style issue fixes
 - using a temp variable for bf54x_kpad->input
 - Other updates according to Dmitry's review

[try #3] Changelog:
 - Coding style cleanups
 - Use local copy of keymap
 - Remove empty PM functions
 - Use input_set_drvdata() since input->private is going away

[try #4] Changelog:
 - Change keymapsize to u16
 - Copy privately used LUT behind keycodemax in keycode table.
   (this is more cache friendly when doing the tablewalk) 
 - Change Input_dev->cdev.dev to input_dev->dev.parent

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf548/boards/ezkit.c      |    2 +-
 drivers/input/keyboard/Kconfig               |    9 +
 drivers/input/keyboard/Makefile              |    2 +-
 drivers/input/keyboard/bf54x-keys.c          |  392 ++++++++++++++++++++++++++
 include/asm-blackfin/mach-bf548/bf54x_keys.h |   17 ++
 5 files changed, 420 insertions(+), 2 deletions(-)
 create mode 100644 drivers/input/keyboard/bf54x-keys.c
 create mode 100644 include/asm-blackfin/mach-bf548/bf54x_keys.h

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 2c47db4..6734b3d 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -88,7 +88,7 @@ static struct platform_device bf54x_lq043_device = {
 #endif
 
 #if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
-static int bf548_keymap[] = {
+static unsigned int bf548_keymap[] = {
 	KEYVAL(0, 0, KEY_ENTER),
 	KEYVAL(0, 1, KEY_HELP),
 	KEYVAL(0, 2, KEY_0),
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index c97d5eb..2136a9e 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -253,4 +253,13 @@ config KEYBOARD_GPIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called gpio-keys.
 
+config KEYBOARD_BFIN
+	tristate "Blackfin BF54x keypad support"
+	depends on (BF54x)
+	help
+	  Say Y here if you want to use the BF54x keypad.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bf54x-keypad.
+	  
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 28d211b..3123277 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -21,4 +21,4 @@ obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keyboard.o
 obj-$(CONFIG_KEYBOARD_AAED2000)		+= aaed2000_kbd.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
-
+obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
new file mode 100644
index 0000000..1e46289
--- /dev/null
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -0,0 +1,392 @@
+/*
+ * File:         drivers/input/keyboard/bf54x-keys.c
+ * Based on:
+ * Author:       Michael Hennerich <hennerich@blackfin.uclinux.org>
+ *
+ * Created:
+ * Description:  keypad driver for Analog Devices Blackfin BF54x Processors
+ *
+ *
+ * Modified:
+ *               Copyright 2007 Analog Devices Inc.
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
+#include <asm/portmux.h>
+#include <asm/mach/bf54x_keys.h>
+
+#define DRV_NAME 	"bf54x-keys"
+#define TIME_SCALE	100	/* 100 ns */
+#define	MAX_MULT	(0xFF * TIME_SCALE)
+#define MAX_RC		8	/* Max Row/Col */
+
+static const u16 per_rows[] = {
+	P_KEY_ROW7,
+	P_KEY_ROW6,
+	P_KEY_ROW5,
+	P_KEY_ROW4,
+	P_KEY_ROW3,
+	P_KEY_ROW2,
+	P_KEY_ROW1,
+	P_KEY_ROW0,
+	0
+};
+
+static const u16 per_cols[] = {
+	P_KEY_COL7,
+	P_KEY_COL6,
+	P_KEY_COL5,
+	P_KEY_COL4,
+	P_KEY_COL3,
+	P_KEY_COL2,
+	P_KEY_COL1,
+	P_KEY_COL0,
+	0
+};
+
+struct bf54x_kpad {
+	struct input_dev *input;
+	int irq;
+	unsigned short lastkey;
+	unsigned short *keycode;
+	struct timer_list timer;
+	unsigned int keyup_test_jiffies;
+};
+
+static inline int bfin_kpad_find_key(struct bf54x_kpad *bf54x_kpad,
+			 struct input_dev *input, u16 keyident)
+{
+	u16 i;
+
+	for (i = 0; i < input->keycodemax; i++)
+		if (bf54x_kpad->keycode[i  + input->keycodemax] == keyident)
+			return bf54x_kpad->keycode[i];
+	return -1;
+}
+
+static inline void bfin_keycodecpy(unsigned short *keycode, unsigned int *pdata_kc,
+			 struct input_dev *input)
+{
+	u16 i;
+
+	for (i = 0; i < input->keycodemax; i++) {
+		keycode[i] = pdata_kc[i] & 0xffff;
+		keycode[i + input->keycodemax] = pdata_kc[i] >> 16;
+	}
+
+}
+
+static inline u16 bfin_kpad_get_prescale(u32 timescale)
+{
+	u32 sclk = get_sclk();
+
+	return ((((sclk / 1000) * timescale) / 1024) - 1);
+}
+
+static inline u16 bfin_kpad_get_keypressed(struct bf54x_kpad *bf54x_kpad)
+{
+	return (bfin_read_KPAD_STAT() & KPAD_PRESSED);
+}
+
+static inline void bfin_kpad_clear_irq(void)
+{
+	bfin_write_KPAD_STAT(0xFFFF);
+	bfin_write_KPAD_ROWCOL(0xFFFF);
+}
+
+static void bfin_kpad_timer(unsigned long data)
+{
+	struct platform_device *pdev =  (struct platform_device *) data;
+	struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
+
+	if (bfin_kpad_get_keypressed(bf54x_kpad)) {
+		/* Try again later */
+		mod_timer(&bf54x_kpad->timer, jiffies
+				+ bf54x_kpad->keyup_test_jiffies);
+		return;
+	}
+
+	input_report_key(bf54x_kpad->input, bf54x_kpad->lastkey, 0);
+	input_sync(bf54x_kpad->input);
+
+	/* Clear IRQ Status */
+
+	bfin_kpad_clear_irq();
+	enable_irq(bf54x_kpad->irq);
+}
+
+static irqreturn_t bfin_kpad_isr(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+	struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
+	struct input_dev *input = bf54x_kpad->input;
+	int key;
+	u16 rowcol = bfin_read_KPAD_ROWCOL();
+
+	key = bfin_kpad_find_key(bf54x_kpad, input, rowcol);
+
+	input_report_key(input, key, 1);
+	input_sync(input);
+
+	if (bfin_kpad_get_keypressed(bf54x_kpad)) {
+		disable_irq(bf54x_kpad->irq);
+		bf54x_kpad->lastkey = key;
+		mod_timer(&bf54x_kpad->timer, jiffies
+				+ bf54x_kpad->keyup_test_jiffies);
+
+		return IRQ_HANDLED;
+	}
+
+	input_report_key(input, key, 0);
+	input_sync(input);
+
+	bfin_kpad_clear_irq();
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit bfin_kpad_probe(struct platform_device *pdev)
+{
+	struct bf54x_kpad *bf54x_kpad;
+	struct bfin_kpad_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input;
+	int i, error;
+
+
+	if (!pdata->rows || !pdata->cols || !pdata->keymap) {
+		printk(KERN_ERR DRV_NAME"No rows, cols or keymap from pdata\n");
+		return -EINVAL;
+	}
+
+	if (!pdata->keymapsize || pdata->keymapsize > (pdata->rows * pdata->cols)) {
+		printk(KERN_ERR DRV_NAME"Invalid keymapsize\n");
+		return -EINVAL;
+	}
+
+	bf54x_kpad = kzalloc(sizeof(struct bf54x_kpad), GFP_KERNEL);
+
+	if (!bf54x_kpad)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, bf54x_kpad);
+
+	/* Allocate memory for keymap followed by private LUT */
+
+	bf54x_kpad->keycode = kmalloc(pdata->keymapsize * sizeof(unsigned short) * 2, GFP_KERNEL);
+
+	if (!bf54x_kpad->keycode) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (!pdata->debounce_time || !pdata->debounce_time > MAX_MULT ||
+		!pdata->coldrive_time || !pdata->coldrive_time > MAX_MULT) {
+		printk(KERN_ERR DRV_NAME
+			"Invalid Debounce/Columdrive Time from pdata\n");
+		bfin_write_KPAD_MSEL(0xFF0);	/* Default MSEL	*/
+	} else {
+		bfin_write_KPAD_MSEL(((pdata->debounce_time / TIME_SCALE)
+			 & DBON_SCALE) | (((pdata->coldrive_time / TIME_SCALE) << 8)
+			  & COLDRV_SCALE));
+
+	}
+
+	if (!pdata->keyup_test_interval) {
+		bf54x_kpad->keyup_test_jiffies = msecs_to_jiffies(50);
+	} else {
+		bf54x_kpad->keyup_test_jiffies =
+			msecs_to_jiffies(pdata->keyup_test_interval);
+	}
+
+	if (peripheral_request_list((u16 *)&per_rows[MAX_RC - pdata->rows], DRV_NAME)) {
+		printk(KERN_ERR DRV_NAME
+		": Requesting Peripherals failed\n");
+		error = -EFAULT;
+		goto out0;
+	}
+
+	if (peripheral_request_list((u16 *)&per_cols[MAX_RC - pdata->cols], DRV_NAME)) {
+		printk(KERN_ERR DRV_NAME
+		": Requesting Peripherals failed\n");
+		error = -EFAULT;
+		goto out1;
+	}
+
+	bf54x_kpad->irq = platform_get_irq(pdev, 0);
+
+	if (bf54x_kpad->irq < 0) {
+		error = -ENODEV;
+		goto out2;
+	}
+
+	error = request_irq(bf54x_kpad->irq, bfin_kpad_isr,
+				 IRQF_SAMPLE_RANDOM, DRV_NAME, pdev);
+
+	if (error) {
+		printk(KERN_ERR DRV_NAME
+			": unable to claim irq %d; error %d\n",
+			bf54x_kpad->irq, error);
+		error = -EBUSY;
+		goto out2;
+	}
+
+	input = input_allocate_device();
+
+	if (!input) {
+		error = -ENOMEM;
+		goto out3;
+	}
+
+	bf54x_kpad->input = input;
+
+	input->name = pdev->name;
+	input->phys = "bf54x-keys/input0";
+
+	input->dev.parent = &pdev->dev;
+
+	input_set_drvdata(input, bf54x_kpad);
+
+	input->id.bustype = BUS_HOST;
+	input->id.vendor = 0x0001;
+	input->id.product = 0x0001;
+	input->id.version = 0x0100;
+
+	input->keycodesize = sizeof(unsigned short);
+	input->keycodemax = pdata->keymapsize;
+
+	bfin_keycodecpy(bf54x_kpad->keycode, pdata->keymap, input);
+
+	input->keycode = bf54x_kpad->keycode;
+
+	/* setup input device */
+	__set_bit(EV_KEY, input->evbit);
+
+	if (pdata->repeat)
+		__set_bit(EV_REP, input->evbit);
+
+	for (i = 0; i < input->keycodemax; i++)
+		__set_bit(bf54x_kpad->keycode[i] & KEY_MAX, input->keybit);
+
+	__clear_bit(KEY_RESERVED, input->keybit);
+
+	error = input_register_device(input);
+
+	if (error) {
+		printk(KERN_ERR DRV_NAME
+			": Unable to register input device (%d)\n", error);
+		goto out4;
+	}
+
+	/* Init Keypad Key Up/Release test timer */
+
+	setup_timer(&bf54x_kpad->timer, bfin_kpad_timer, (unsigned long) pdev);
+
+	bfin_write_KPAD_PRESCALE(bfin_kpad_get_prescale(TIME_SCALE));
+
+	bfin_write_KPAD_CTL((((pdata->cols - 1) << 13) & KPAD_COLEN) |
+				(((pdata->rows - 1) << 10) & KPAD_ROWEN) |
+				(2 & KPAD_IRQMODE));
+
+
+	bfin_write_KPAD_CTL(bfin_read_KPAD_CTL() | KPAD_EN);
+
+	printk(KERN_ERR DRV_NAME
+		": Blackfin BF54x Keypad registered IRQ %d\n", bf54x_kpad->irq);
+
+	return 0;
+
+
+out4:
+	input_free_device(input);
+out3:
+	free_irq(bf54x_kpad->irq, pdev);
+out2:
+	peripheral_free_list((u16 *)&per_cols[MAX_RC - pdata->cols]);
+out1:
+	peripheral_free_list((u16 *)&per_rows[MAX_RC - pdata->rows]);
+out0:
+	kfree(bf54x_kpad->keycode);
+out:
+	kfree(bf54x_kpad);
+	platform_set_drvdata(pdev, NULL);
+
+	return error;
+}
+
+static int __devexit bfin_kpad_remove(struct platform_device *pdev)
+{
+	struct bfin_kpad_platform_data *pdata = pdev->dev.platform_data;
+	struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
+
+
+	del_timer_sync(&bf54x_kpad->timer);
+	free_irq(bf54x_kpad->irq, pdev);
+
+	peripheral_free_list((u16 *)&per_rows[MAX_RC - pdata->rows]);
+	peripheral_free_list((u16 *)&per_cols[MAX_RC - pdata->cols]);
+
+	input_unregister_device(bf54x_kpad->input);
+
+	kfree(bf54x_kpad->keycode);
+	kfree(bf54x_kpad);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+struct platform_driver bfin_kpad_device_driver = {
+	.probe		= bfin_kpad_probe,
+	.remove		= __devexit_p(bfin_kpad_remove),
+	.driver		= {
+		.name	= DRV_NAME,
+	}
+};
+
+static int __init bfin_kpad_init(void)
+{
+	return platform_driver_register(&bfin_kpad_device_driver);
+}
+
+static void __exit bfin_kpad_exit(void)
+{
+	platform_driver_unregister(&bfin_kpad_device_driver);
+}
+
+module_init(bfin_kpad_init);
+module_exit(bfin_kpad_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("Keypad driver for BF54x Processors");
diff --git a/include/asm-blackfin/mach-bf548/bf54x_keys.h b/include/asm-blackfin/mach-bf548/bf54x_keys.h
new file mode 100644
index 0000000..8ab1f91
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/bf54x_keys.h
@@ -0,0 +1,17 @@
+#ifndef _BFIN_KPAD_H
+#define _BFIN_KPAD_H
+
+struct bfin_kpad_platform_data {
+	int rows;
+	int cols;
+	unsigned int *keymap;
+	unsigned short keymapsize;
+	unsigned short repeat;
+	u32 debounce_time;	/* in ns */
+	u32 coldrive_time;	/* in ns */
+	u32 keyup_test_interval; /* in ms */
+};
+
+#define KEYVAL(col, row, val) (((1 << col) << 24) | ((1 << row) << 16) | (val))
+
+#endif
-- 
1.5.3.4

