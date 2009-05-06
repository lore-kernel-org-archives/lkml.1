Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZEFGVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZEFGVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZEFGVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:21:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56697 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZEFGVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:21:33 -0400
Date: Wed, 06 May 2009 15:21:24 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: Input: add MAX7359 key switch controller driver
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4A012C64.1020101@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
X-OriginalArrivalTime: 06 May 2009 06:21:24.0875 (UTC)
 FILETIME=[E1BCCDB0:01C9CE12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Maxim MAX7359 is a I2C interfaced key switch controller which provides microprocessors with management of up to 64 key switches.
This patch adds support for the MAX7359 key switch controller.

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
---
 drivers/input/keyboard/Kconfig          |    8 +
 drivers/input/keyboard/Makefile         |    1 +
 drivers/input/keyboard/max7359_keypad.c |  300 +++++++++++++++++++++++++++++++
 include/linux/max7359_keypad.h          |   30 +++
 4 files changed, 339 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/max7359_keypad.c
 create mode 100644 include/linux/max7359_keypad.h

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index ea2638b..fb2dc08 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -332,4 +332,12 @@ config KEYBOARD_SH_KEYSC
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sh_keysc.
+
+config KEYBOARD_MAX7359
+	tristate "Maxim MAX7359 Key Switch Controller"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Maxim MAX7359 Key
+	  Switch Controller chip. This providers microprocessors with
+	  management of up to 64 key switches
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 36351e1..a9e7502 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_KEYBOARD_HP7XX)		+= jornada720_kbd.o
 obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
 obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
+obj-$(CONFIG_KEYBOARD_MAX7359)		+= max7359_keypad.o
diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
new file mode 100644
index 0000000..3c2ec01
--- /dev/null
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -0,0 +1,300 @@
+/*
+ * max7359_keypad.c - MAX7359 Key Switch Controller Driver
+ *
+ * Copyright (C) 2009 Samsung Electronics
+ * Kim Kyuwon <q1.kim@samsung.com>
+ *
+ * Based on pxa27x_keypad.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Datasheet: http://www.maxim-ic.com/quick_view2.cfm/qv_pk/5456
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/max7359_keypad.h>
+
+#define MAX_KEY_NUM			(8 * 8)
+
+/*
+ * MAX7359 registers
+ */
+#define MAX7359_REG_KEYFIFO		0x00
+#define MAX7359_REG_CONFIG		0x01
+#define MAX7359_REG_DEBOUNCE		0x02
+#define MAX7359_REG_INTERRUPT		0x03
+#define MAX7359_REG_PORTS		0x04
+#define MAX7359_REG_KEYREP		0x05
+#define MAX7359_REG_SLEEP		0x06
+
+/*
+ * Configuration register bits
+ */
+#define MAX7359_CFG_SLEEP		(1 << 7)
+#define MAX7359_CFG_INTERRUPT		(1 << 5)
+#define MAX7359_CFG_KEY_RELEASE		(1 << 3)
+#define MAX7359_CFG_WAKEUP		(1 << 1)
+#define MAX7359_CFG_TIMEOUT		(1 << 0)
+
+struct max7359_keypad {
+	/* matrix key code map */
+	u16					keycodes[MAX_KEY_NUM];
+
+	struct work_struct			work;
+
+	struct max7359_keypad_platform_data	*pdata;
+	struct input_dev			*input_dev;
+	struct i2c_client			*client;
+
+	u32					irq;
+};
+
+static int max7359_write_reg(struct i2c_client *client, u8 reg, u8 val)
+{
+	int ret = i2c_smbus_write_byte_data(client, reg, val);
+	if (ret >= 0)
+		return 0;
+
+	dev_err(&client->dev, "%s: reg 0x%x, val 0x%x, err %d\n",
+						__func__, reg, val, ret);
+
+	return ret;
+}
+
+static int max7359_read_reg(struct i2c_client *client, int reg)
+{
+	int ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0)
+		dev_err(&client->dev, "%s: reg 0x%x, err %d\n",
+						__func__, reg, ret);
+	return ret;
+}
+
+static void max7359_build_keycode(struct max7359_keypad *keypad)
+{
+	struct max7359_keypad_platform_data *pdata = keypad->pdata;
+	struct input_dev *input_dev = keypad->input_dev;
+	unsigned int *key;
+	int i;
+
+	key = pdata->key_map;
+	for (i = 0; i < pdata->key_map_size; i++, key++) {
+		int row = ((*key) >> 28) & 0xf;
+		int col = ((*key) >> 24) & 0xf;
+		short code = (*key) & 0xffff;
+
+		keypad->keycodes[(row << 3) + col] = code;
+		set_bit(code, input_dev->keybit);
+	}
+}
+
+static inline unsigned int max7359_lookup_matrix_keycode(
+			struct max7359_keypad *keypad, int row, int col)
+{
+	return keypad->keycodes[(row << 3) + col];
+}
+
+static void max7359_worker(struct work_struct *work)
+{
+	struct max7359_keypad *keypad =
+			container_of(work, struct max7359_keypad, work);
+	int val, row, col, release;
+
+	val = max7359_read_reg(keypad->client, MAX7359_REG_KEYFIFO);
+	row = val & 0x7;
+	col = (val >> 3) & 0x7;
+	release = val & 0x40;
+
+	input_report_key(keypad->input_dev,
+		max7359_lookup_matrix_keycode(keypad, row, col), !release);
+	input_sync(keypad->input_dev);
+
+	enable_irq(keypad->irq);
+
+	dev_dbg(&keypad->client->dev, "key[%d:%d] %s\n", row, col,
+					(release ? "release" : "press"));
+}
+
+static irqreturn_t max7359_interrupt(int irq, void *dev_id)
+{
+	struct max7359_keypad *keypad = (struct max7359_keypad *) dev_id;
+
+	if (!work_pending(&keypad->work)) {
+		disable_irq_nosync(keypad->irq);
+		schedule_work(&keypad->work);
+	} else {
+		dev_err(&keypad->client->dev,
+				"Another job is currently pending \n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void max7359_initialize(struct i2c_client *client)
+{
+	max7359_write_reg(client, MAX7359_REG_CONFIG,
+		MAX7359_CFG_INTERRUPT | /* Irq clears after host read */
+		MAX7359_CFG_KEY_RELEASE | /* Key release enable */
+		MAX7359_CFG_WAKEUP); /* Key press wakeup enable */
+
+	/* Full key-scan functionality */
+	max7359_write_reg(client, MAX7359_REG_DEBOUNCE, 0x1F);
+
+	/* nINT asserts every debounce cycles */
+	max7359_write_reg(client, MAX7359_REG_INTERRUPT, 0x01);
+}
+
+static int __devinit max7359_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct max7359_keypad *keypad;
+	struct max7359_keypad_platform_data *pdata;
+	struct input_dev *input_dev;
+	int ret;
+
+	keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
+	if (keypad == NULL) {
+		dev_err(&client->dev, "failed to allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	keypad->client = client;
+	pdata = keypad->pdata = client->dev.platform_data;
+	i2c_set_clientdata(client, keypad);
+
+	/* Detect MAX7359: The initial Keys FIFO value is '0x3F' */
+	ret = max7359_read_reg(client, MAX7359_REG_KEYFIFO);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to detect device\n");
+		goto failed_free;
+	} else {
+		dev_info(&client->dev, "keys FIFO is 0x%02x"
+				", succeeded in detecting device\n", ret);
+	}
+
+	/* Initialize MAX7359 */
+	max7359_initialize(client);
+
+	/* Create and register the input driver. */
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(&client->dev, "failed to allocate input device\n");
+		ret = -ENOMEM;
+		goto failed_free;
+	}
+
+	input_dev->name = client->name;
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &client->dev;
+
+	input_set_drvdata(input_dev, keypad);
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
+	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
+	input_dev->keycode = keypad->keycodes;
+
+	keypad->input_dev = input_dev;
+
+	max7359_build_keycode(keypad);
+
+	INIT_WORK(&keypad->work, max7359_worker);
+
+	keypad->irq = client->irq;
+	if (!keypad->irq) {
+		dev_err(&client->dev, "The irq number should not be zero\n");
+		goto failed_free_dev;
+	}
+
+	ret = request_irq(keypad->irq, max7359_interrupt,
+				IRQF_TRIGGER_LOW, client->name, keypad);
+	if (ret) {
+		dev_err(&client->dev, "failed to register interrupt\n");
+		goto failed_free_dev;
+	}
+
+	/* Register the input device */
+	ret = input_register_device(input_dev);
+	if (ret) {
+		dev_err(&client->dev, "failed to register input device\n");
+		goto failed_free_irq;
+	}
+
+	return 0;
+
+failed_free_irq:
+	free_irq(keypad->irq, keypad);
+failed_free_dev:
+	input_free_device(input_dev);
+failed_free:
+	i2c_set_clientdata(client, NULL);
+	kfree(keypad);
+	return ret;
+}
+
+static int __exit max7359_remove(struct i2c_client *client)
+{
+	struct max7359_keypad *keypad = i2c_get_clientdata(client);
+
+	cancel_work_sync(&keypad->work);
+	input_unregister_device(keypad->input_dev);
+	free_irq(keypad->irq, keypad);
+	i2c_set_clientdata(client, NULL);
+	kfree(keypad);
+
+	return 0;
+}
+
+static int max7359_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	/* If no keys are pressed, enter sleep mode for 8192 ms */
+	max7359_write_reg(client, MAX7359_REG_SLEEP, 0x01);
+
+	return 0;
+}
+
+static int max7359_resume(struct i2c_client *client)
+{
+	/* Restore the default setting (autosleep for 256 ms) */
+	max7359_write_reg(client, MAX7359_REG_SLEEP, 0x07);
+
+	return 0;
+}
+
+static const struct i2c_device_id max7359_ids[] = {
+	{ "max7359", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max7359_ids);
+
+static struct i2c_driver max7359_i2c_driver = {
+	.driver = {
+		.name = "max7359",
+	},
+	.probe		= max7359_probe,
+	.remove		= __exit_p(max7359_remove),
+	.suspend	= max7359_suspend,
+	.resume		= max7359_resume,
+	.id_table	= max7359_ids,
+};
+
+static int __init max7359_init(void)
+{
+	return i2c_add_driver(&max7359_i2c_driver);
+}
+module_init(max7359_init);
+
+static void __exit max7359_exit(void)
+{
+	i2c_del_driver(&max7359_i2c_driver);
+}
+module_exit(max7359_exit);
+
+MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
+MODULE_DESCRIPTION("MAX7359 Key Switch Controller Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/max7359_keypad.h b/include/linux/max7359_keypad.h
new file mode 100644
index 0000000..c9477a5
--- /dev/null
+++ b/include/linux/max7359_keypad.h
@@ -0,0 +1,30 @@
+/*
+ * max7359_keypad.h - MAX7359 Keypad Controller Driver
+ *
+ * Copyright (C) 2009 Samsung Electronics
+ * Kim Kyuwon <q1.kim@samsung.com>
+ *
+ * Based on pxa27x_keypad.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Datasheet: http://www.maxim-ic.com/quick_view2.cfm/qv_pk/5456
+ */
+
+#ifndef _MAX7359_KEYPAD_H_
+#define _MAX7359_KEYPAD_H_
+
+#define MAX_MATRIX_KEY_ROWS	8
+#define MAX_MATRIX_KEY_COLS	8
+
+struct max7359_keypad_platform_data {
+	/* code map for the keys */
+	unsigned int	*key_map;
+	unsigned int	key_map_size;
+};
+
+#define KEY(row, col, val)	(((row) << 28) | ((col) << 24) | (val))
+
+#endif /* _MAX7359_KEYPAD_H_ */
-- 
1.5.2.5
