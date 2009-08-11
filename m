Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZHKQdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZHKQdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZHKQdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:33:03 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:48455 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZHKQdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:33:00 -0400
Message-ID: <4A819D39.2040006@qi-hardware.com>
Date: Wed, 12 Aug 2009 00:32:57 +0800
From: Xiangfu Liu <xiangfu@qi-hardware.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Hard- and Software Development, Kernel, Distribution, Roadmap" 
	<developer@lists.qi-hardware.com>
CC: linux-kernel@vger.kernel.org
Subject: qi_lb60_keypad driver question?
Content-Type: multipart/mixed;
 boundary="------------060807070705000703020706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060807070705000703020706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi there
I have try to write the keypad driver,
but I don't know if this is the right direction.
attach is the patch for the openwrt[1] .25 kernel.


any advice will appreciate.
thanks.


[1] http://github.com/lindnermarek/openwrt-x-burst/commits/x-burst

--------------060807070705000703020706
Content-Type: text/x-patch;
 name="qi_lb60_keypad.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="qi_lb60_keypad.patch"

diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 127fad8..33c00ac 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -56,7 +56,7 @@ static void __init board_cpm_setup(void)
 	 */
 }
 
-static void __init board_gpio_setup(void)
+static int __init board_gpio_setup(void)
 {
 	/*
 	 * Most of the GPIO pins should have been initialized by the boot-loader
@@ -65,22 +65,22 @@ static void __init board_gpio_setup(void)
 	/*
 	 * Initialize MSC pins
 	 */
-	/* __gpio_as_msc(); */
+	__gpio_as_msc();
 
 	/*
 	 * Initialize LCD pins
 	 */
-	/* __gpio_as_lcd_18bit(); */
+	__gpio_as_lcd_18bit();
 
 	/*
 	 * Initialize SSI pins
 	 */
-	/* __gpio_as_ssi(); */
+	__gpio_as_ssi();
 
 	/*
 	 * Initialize I2C pins
 	 */
-	/* __gpio_as_i2c(); */
+	__gpio_as_i2c();
 
 	/*
 	 * Initialize Other pins
@@ -97,6 +97,20 @@ static void __init board_gpio_setup(void)
 
 	__gpio_as_input(GPIO_DC_DETE_N);
 	__gpio_as_input(GPIO_CHARG_STAT_N);
+
+        unsigned int i;
+        for (i = 0; i < 8; i++) {
+                __gpio_as_output(GPIO_KEYOUT_BASE + i);
+                __gpio_set_pin(GPIO_KEYOUT_BASE + i);
+        }
+
+        for (i = 0; i < 7; i++){
+                __gpio_as_input(GPIO_KEYIN_BASE + i);
+                __gpio_enable_pull(GPIO_KEYIN_BASE + i);
+        }
+
+        __gpio_as_input(GPIO_KEYIN_8);
+        __gpio_enable_pull(GPIO_KEYIN_8);
 }
 
 void __init jz_board_setup(void)
@@ -108,3 +122,4 @@ void __init jz_board_setup(void)
 
 	jz_timer_callback = pi_timer_callback;
 }
+
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 72bb407..4544df2 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -199,6 +199,15 @@ config KEYBOARD_ATARI
 	  To compile this driver as a module, choose M here: the
 	  module will be called atakbd.
 
+config KEYBOARD_MATRIX
+       tristate "GPIO driven matrix keypad support"
+	depends on JZSOC
+       help
+         Enable support for GPIO driven matrix keypad.
+
+         To compile this driver as a module, choose M here: the
+         module will be called matrix_keypad.
+
 config KEYBOARD_HIL_OLD
 	tristate "HP HIL keyboard support (simple driver)"
 	depends on GSC || HP300
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 9b4b67b..1fb7635 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keypad.o
 obj-$(CONFIG_KEYBOARD_JZ)      += jz_keypad.o
 obj-$(CONFIG_5x5_KEYBOARD_JZ)      += jz_keypad_5x5.o
+obj-$(CONFIG_KEYBOARD_MATRIX)		+= matrix_keypad.o qi_lb60_keypad.o
 obj-$(CONFIG_KEYBOARD_AAED2000)		+= aaed2000_kbd.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
 obj-$(CONFIG_KEYBOARD_HP6XX)		+= jornada680_kbd.o
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
new file mode 100644
index 0000000..a51273e
--- /dev/null
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -0,0 +1,347 @@
+/*
+ * drivers/input/keyboard/matrix_keypad.c
+ *
+ *  GPIO driven matrix keyboard driver
+ *
+ *  Copyright (c) 2008 Marek Vasut <marek.vasut@xxxxxxxxx>
+ *
+ *  Based on corgikbd.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/input/matrix_keypad.h>
+
+struct matrix_keypad {
+	struct matrix_keypad_platform_data *pdata;
+	struct input_dev *input_dev;
+
+	uint32_t last_key_state[MATRIX_MAX_COLS];
+	uint32_t *keycodes;
+	struct delayed_work work;
+};
+
+static void build_keycodes(struct matrix_keypad *keypad)
+{
+	struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	struct input_dev *input_dev = keypad->input_dev;
+	uint32_t *key;
+	int i;
+
+	keypad->keycodes = kzalloc(MATRIX_MAX_KEYS * sizeof(int), GFP_KERNEL);
+
+	key = &pdata->key_map[0];
+	for (i = 0; i < pdata->key_map_size; i++, key++) {
+		keypad->keycodes[KEY_ROWCOL(*key)] = KEY_VAL(*key);
+		set_bit(KEY_VAL(*key), input_dev->keybit);
+	}
+}
+
+static unsigned int lookup_keycode(struct matrix_keypad *keypad,
+				   int row, int col)
+{
+	return keypad->keycodes[(row << 4) + col];
+}
+
+static void activate_all_cols(struct matrix_keypad_platform_data *pdata,
+			      int on)
+{
+	int i;
+	
+	for (i = 0; i < pdata->num_col_gpios; i++)
+		gpio_set_value(pdata->col_gpios[i],
+			(on) ? !pdata->active_low : pdata->active_low);
+}
+
+static void activate_col(struct matrix_keypad_platform_data *pdata,
+			 int col, int on)
+{
+	gpio_set_value(pdata->col_gpios[col],
+			(on) ? !pdata->active_low : pdata->active_low);
+
+	if (on && pdata->col_scan_delay_us)
+		udelay(pdata->col_scan_delay_us);
+}
+
+static int row_asserted(struct matrix_keypad_platform_data *pdata, int row)
+{
+	return gpio_get_value(pdata->row_gpios[row]) ?
+			!pdata->active_low : pdata->active_low;
+}
+
+static void enable_row_irqs(struct matrix_keypad *keypad)
+{
+	struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	int i;
+
+	for (i = 0; i < pdata->num_row_gpios; i++)
+		enable_irq(gpio_to_irq(pdata->row_gpios[i]));
+}
+
+static void disable_row_irqs(struct matrix_keypad *keypad)
+{
+	struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	int i;
+
+	for (i = 0; i < pdata->num_row_gpios; i++)
+		disable_irq_nosync(gpio_to_irq(pdata->row_gpios[i]));
+}
+
+/*
+ * This gets the keys from keyboard and reports it to input subsystem
+ */
+static void matrix_keypad_scan(struct work_struct *work)
+{
+	struct matrix_keypad *keypad =
+	       	container_of(work, struct matrix_keypad, work.work);
+	struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	uint32_t new_state[MATRIX_MAX_COLS];
+	int row, col;
+
+	/* de-activate all columns for scanning */
+	activate_all_cols(pdata, 0);
+
+	memset(new_state, 0, sizeof(new_state));
+
+	/* assert each column and read the row status out */
+	for (col = 0; col < pdata->num_col_gpios; col++) {
+
+		activate_col(pdata, col, 1);
+
+		for (row = 0; row < pdata->num_row_gpios; row++)
+			new_state[col] |= row_asserted(pdata, row) ?
+						(1 << row) : 0;
+		activate_col(pdata, col, 0);
+	}
+
+	for (col = 0; col < pdata->num_col_gpios; col++) {
+		uint32_t bits_changed;
+		
+		bits_changed = keypad->last_key_state[col] ^ new_state[col];
+		if (bits_changed == 0)
+			continue;
+
+		for (row = 0; row < pdata->num_row_gpios; row++) {
+			if ((bits_changed & (1 << row)) == 0)
+				continue;
+
+			input_report_key(keypad->input_dev,
+					lookup_keycode(keypad, row, col),
+					new_state[col] & (1 << row));
+		}
+	}
+	input_sync(keypad->input_dev);
+	memcpy(keypad->last_key_state, new_state, sizeof(new_state));
+
+	activate_all_cols(pdata, 1);
+	enable_row_irqs(keypad);
+}
+
+static irqreturn_t matrix_keypad_interrupt(int irq, void *id)
+{
+	struct matrix_keypad *keypad = id;
+
+	disable_row_irqs(keypad);
+	schedule_delayed_work(&keypad->work,
+			msecs_to_jiffies(keypad->pdata->debounce_ms));
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_PM
+static int matrix_keypad_suspend(struct platform_device *pdev,
+pm_message_t state)
+{
+	struct matrix_keypad *keypad = platform_get_drvdata(pdev);
+	struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	int i;
+
+	if (device_may_wakeup(&pdev->dev))
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			enable_irq_wake(gpio_to_irq(pdata->row_gpios[i]));
+
+	return 0;
+}
+
+static int matrix_keypad_resume(struct platform_device *pdev)
+{
+	struct matrix_keypad *keypad = platform_get_drvdata(pdev);
+	struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	int i;
+
+	if (device_may_wakeup(&pdev->dev))
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			disable_irq_wake(gpio_to_irq(pdata->row_gpios[i]));
+
+	return 0;
+}
+#else
+#define matrix_keypad_suspend	NULL
+#define matrix_keypad_resume	NULL
+#endif
+
+static int __devinit init_matrix_gpio(struct matrix_keypad *keypad)
+{
+	struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	int i, err = -EINVAL;
+
+	/* initialized strobe lines as outputs, activated */
+	for (i = 0; i < pdata->num_col_gpios; i++) {
+		err = gpio_request(pdata->col_gpios[i], "matrix_kbd_col");
+		if (err) {
+			pr_err("failed to request GPIO%d for COL%d\n",
+					pdata->col_gpios[i], i);
+			goto err_free_cols;
+		}
+
+		gpio_direction_output(pdata->col_gpios[i], !pdata->active_low);
+	}
+
+	for (i = 0; i < pdata->num_row_gpios; i++) {
+		err = gpio_request(pdata->row_gpios[i], "matrix_kbd_row");
+		if (err) {
+			pr_err("failed to request GPIO%d for ROW%d\n",
+					pdata->row_gpios[i], i);
+			goto err_free_rows;
+		}
+
+		gpio_direction_input(pdata->row_gpios[i]);
+	}
+
+	for (i = 0; i < pdata->num_row_gpios; i++) {
+		err = request_irq(gpio_to_irq(pdata->row_gpios[i]),
+				matrix_keypad_interrupt, IRQF_DISABLED |
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"matrix-keypad", keypad);
+		if (err) {
+			pr_err("Unable to acquire interrupt for GPIO line %i\n",
+				pdata->row_gpios[i]);
+			goto err_free_irqs;
+		}
+	}
+	return 0;
+
+err_free_irqs:
+	for (i = i - 1; i >= 0; i--)
+		free_irq(gpio_to_irq(pdata->row_gpios[i]), keypad);
+
+err_free_rows:
+	for (i = i - 1; i >= 0; i--)
+		gpio_free(pdata->row_gpios[i]);
+
+err_free_cols:
+	for (i = i - 1; i >= 0; i--)
+		gpio_free(pdata->col_gpios[i]);
+
+	return err;
+}
+
+static int __devinit matrix_keypad_probe(struct platform_device *pdev)
+{
+	struct matrix_keypad_platform_data *pdata;
+	struct matrix_keypad *keypad;
+	struct input_dev *input_dev;
+	int err = -ENOMEM;
+
+	if ((pdata = pdev->dev.platform_data) == NULL) {
+		dev_err(&pdev->dev, "no platform data defined\n");
+		return -EINVAL;
+	}
+
+	keypad = kzalloc(sizeof(struct matrix_keypad), GFP_KERNEL);
+	if (keypad == NULL)
+		return -ENOMEM;
+
+	input_dev = input_allocate_device();
+	if (!input_dev)
+		goto err_free_keypad;
+
+	platform_set_drvdata(pdev, keypad);
+
+	keypad->input_dev = input_dev;
+	keypad->pdata = pdata;
+	INIT_DELAYED_WORK(&keypad->work, matrix_keypad_scan);
+
+	input_dev->name		= pdev->name;
+	input_dev->id.bustype	= BUS_HOST;
+	input_dev->dev.parent	= &pdev->dev;
+	input_dev->evbit[0]	= BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+
+	build_keycodes(keypad);
+
+	err = input_register_device(keypad->input_dev);
+	if (err)
+		goto err_free_input;
+
+	err = init_matrix_gpio(keypad);
+	if (err)
+		goto err_unregister;
+
+	return 0;
+
+err_unregister:
+	input_unregister_device(input_dev);
+err_free_input:
+	input_free_device(input_dev);
+err_free_keypad:
+	kfree(keypad);
+	return err;
+}
+
+static int matrix_keypad_remove(struct platform_device *pdev)
+{
+	struct matrix_keypad *keypad = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < keypad->pdata->num_row_gpios; i++) {
+		free_irq(gpio_to_irq(keypad->pdata->row_gpios[i]), keypad);
+		gpio_free(keypad->pdata->row_gpios[i]);
+	}
+
+	for (i = 0; i < keypad->pdata->num_col_gpios; i++)
+		gpio_free(keypad->pdata->col_gpios[i]);
+
+	input_unregister_device(keypad->input_dev);
+	kfree(keypad);
+	return 0;
+}
+
+static struct platform_driver matrix_keypad_driver = {
+	.probe		= matrix_keypad_probe,
+	.remove		= matrix_keypad_remove,
+	.suspend	= matrix_keypad_suspend,
+	.resume		= matrix_keypad_resume,
+	.driver		= {
+		.name	= "matrix-keypad",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __devinit matrix_keypad_init(void)
+{
+	return platform_driver_register(&matrix_keypad_driver);
+}
+
+static void __exit matrix_keypad_exit(void)
+{
+	platform_driver_unregister(&matrix_keypad_driver);
+}
+
+module_init(matrix_keypad_init);
+module_exit(matrix_keypad_exit);
+
+MODULE_AUTHOR("Marek Vasut <marek.vasut@xxxxxxxxx>");
+MODULE_DESCRIPTION("GPIO Driven Matrix Keypad Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:matrix-keypad");
diff --git a/drivers/input/keyboard/qi_lb60_keypad.c b/drivers/input/keyboard/qi_lb60_keypad.c
new file mode 100644
index 0000000..0b2e548
--- /dev/null
+++ b/drivers/input/keyboard/qi_lb60_keypad.c
@@ -0,0 +1,128 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
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
+#include <linux/input/matrix_keypad.h>
+
+#include <asm/gpio.h>
+
+#include <asm/jzsoc.h>
+
+static const uint32_t qi_lb60_keymap[] = {
+	KEY(0, 0, KEY_ENTER),
+	KEY(0, 1, KEY_ENTER),
+	KEY(0, 2, KEY_3),
+	KEY(0, 3, KEY_5),
+	KEY(0, 4, KEY_6),
+	KEY(0, 5, KEY_7),
+	KEY(0, 6, KEY_9),
+	KEY(0, 7, KEY_0),
+	KEY(1, 1, KEY_2),
+	KEY(1, 2, KEY_4),
+	KEY(1, 3, KEY_R),
+	KEY(1, 4, KEY_Y),
+	KEY(1, 5, KEY_8),
+	KEY(1, 6, KEY_I),
+	KEY(1, 7, KEY_O),
+	KEY(2, 0, KEY_TAB),
+	KEY(2, 1, KEY_Q),
+	KEY(2, 2, KEY_E),
+	KEY(2, 3, KEY_T),
+	KEY(2, 4, KEY_G),
+	KEY(2, 5, KEY_U),
+	KEY(2, 6, KEY_J),
+	KEY(2, 7, KEY_K),
+	KEY(3, 0, KEY_F1),
+	KEY(3, 1, KEY_W),
+	KEY(3, 2, KEY_S),
+	KEY(3, 3, KEY_F),
+	KEY(3, 4, KEY_V),
+	KEY(3, 5, KEY_H),
+	KEY(3, 6, KEY_M),
+	KEY(3, 7, KEY_L),
+	KEY(4, 0, KEY_F2),
+	KEY(4, 1, KEY_A),
+	KEY(4, 2, KEY_D),
+	KEY(4, 3, KEY_C),
+	KEY(4, 4, KEY_B),
+	KEY(4, 5, KEY_N),
+	KEY(4, 6, KEY_DOT),
+	KEY(5, 0, KEY_F3),
+	KEY(5, 1, KEY_Z),
+	KEY(5, 2, KEY_X),
+	KEY(5, 3, KEY_MINUS),
+	KEY(5, 4, KEY_SPACE),
+	KEY(5, 5, KEY_COMMA),
+	KEY(5, 7, KEY_UP),
+	KEY(6, 0, KEY_F4),
+	KEY(6, 1, KEY_F5),
+	KEY(6, 2, KEY_F6),
+	KEY(6, 3, KEY_F7),
+	KEY(6, 4, KEY_F8),
+	KEY(6, 5, KEY_MENU),
+	KEY(6, 6, KEY_LEFT),
+	KEY(6, 7, KEY_DOWN),
+        KEY(7, 0, KEY_4),
+        KEY(7, 1, KEY_5),
+        KEY(7, 2, KEY_6),
+        KEY(7, 3, KEY_7),
+        KEY(7, 4, KEY_8),
+        KEY(7, 5, KEY_9),
+        KEY(7, 6, KEY_LEFT),
+        KEY(7, 7, KEY_DOWN),
+};
+
+static struct matrix_keypad_platform_data qi_lb60_pdata = {
+	.key_map		= qi_lb60_keymap,
+	.key_map_size	= ARRAY_SIZE(qi_lb60_keymap),
+	.col_gpios	= {114, 115, 116, 117, 118, 119, 120, 122, -1},
+	.row_gpios	= {74, 75, 76, 77, 78, 79, 80, 81, -1},
+	.num_col_gpios	= 8,
+	.num_row_gpios	= 8,
+	.col_scan_delay_us	= 10,
+	.debounce_ms		= 10,
+	.active_low		= 1,
+};
+
+static struct platform_device qi_lb60_device = {
+	.name		= "qi_lb60-keyboard",
+	.name		= "matrix-keypad",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &qi_lb60_pdata,
+	},
+};
+
+static int __init qi_kbd_init(void)
+{
+	return platform_device_register(&qi_lb60_device);
+}
+
+static void __exit qi_kbd_exit(void)
+{
+	platform_device_unregister(&qi_lb60_device);
+}
+
+module_init(qi_kbd_init);
+module_exit(qi_kbd_exit);
+
+MODULE_AUTHOR("Xiangfu");
+MODULE_DESCRIPTION("Qi keypad driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
new file mode 100644
index 0000000..8b661cb
--- /dev/null
+++ b/include/linux/input/matrix_keypad.h
@@ -0,0 +1,34 @@
+#ifndef _MATRIX_KEYPAD_H
+#define _MATRIX_KEYPAD_H
+
+#include <linux/input.h>
+
+#define MATRIX_MAX_ROWS		16
+#define MATRIX_MAX_COLS		16
+#define MATRIX_MAX_KEYS		(MATRIX_MAX_ROWS * MATRIX_MAX_COLS)
+
+struct matrix_keypad_platform_data {
+	/* scancode map for the matrix keys */
+	uint32_t	*key_map;
+	int		key_map_size;
+
+	unsigned	row_gpios[MATRIX_MAX_ROWS];
+	unsigned	col_gpios[MATRIX_MAX_COLS];
+	int		num_row_gpios;
+	int		num_col_gpios;
+
+	unsigned int	active_low;
+	unsigned int	col_scan_delay_us;
+
+	/* key debounce interval in milli-second */
+	unsigned int	debounce_ms;
+};
+
+#define KEY(row, col, val)	((((row) & (MATRIX_MAX_ROWS - 1)) << 28) |\
+				 (((col) & (MATRIX_MAX_COLS - 1)) << 24) |\
+				 (val & 0xffffff))
+
+#define KEY_ROWCOL(k)		(((k) >> 24) & 0xff)
+#define KEY_VAL(k)		((k) & 0xffffff)
+
+#endif /* _MATRIX_KEYPAD_H */

--------------060807070705000703020706--
