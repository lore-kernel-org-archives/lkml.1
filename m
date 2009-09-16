Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZIPSUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZIPSUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZIPSUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:20:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49956 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZIPSU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:20:29 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH v3] input/keyboard: add ADP5588 QWERTY I2C Keyboard Input device driver
Date: Wed, 16 Sep 2009 14:20:31 -0400
Message-Id: <1253125231-17902-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <20090916050236.GF2756@core.coreip.homeip.net>
References: <20090916050236.GF2756@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v3
	- cache delay workaround calculation
	- rebase on latest mainline

 drivers/input/keyboard/Kconfig        |    9 +
 drivers/input/keyboard/Makefile       |    1 +
 drivers/input/keyboard/adp5588-keys.c |  361 +++++++++++++++++++++++++++++++++
 include/linux/i2c/adp5588.h           |   92 +++++++++
 4 files changed, 463 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/adp5588-keys.c
 create mode 100644 include/linux/i2c/adp5588.h

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 3525c19..e0bfcd7 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -383,4 +383,13 @@ config KEYBOARD_W90P910
 	  To compile this driver as a module, choose M here: the
 	  module will be called w90p910_keypad.
 
+config KEYBOARD_ADP5588
+	tristate "ADP5588 I2C QWERTY Keypad and IO Expander"
+	depends on I2C
+	help
+	  Say Y here if you want to use a ADP5588 attached to your system I2C bus
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adp5588-keys.
+
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 8a7a22b..72082a4 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -5,6 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_KEYBOARD_AAED2000)		+= aaed2000_kbd.o
+obj-$(CONFIG_KEYBOARD_ADP5588)		+= adp5588-keys.o
 obj-$(CONFIG_KEYBOARD_AMIGA)		+= amikbd.o
 obj-$(CONFIG_KEYBOARD_ATARI)		+= atakbd.o
 obj-$(CONFIG_KEYBOARD_ATKBD)		+= atkbd.o
diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
new file mode 100644
index 0000000..d48c808
--- /dev/null
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -0,0 +1,361 @@
+/*
+ * File: drivers/input/keyboard/adp5588_keys.c
+ * Description:  keypad driver for ADP5588 I2C QWERTY Keypad and IO Expander
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Copyright (C) 2008-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/workqueue.h>
+#include <linux/errno.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/i2c.h>
+
+#include <linux/i2c/adp5588.h>
+
+ /* Configuration Register1 */
+#define AUTO_INC	(1 << 7)
+#define GPIEM_CFG	(1 << 6)
+#define OVR_FLOW_M	(1 << 5)
+#define INT_CFG		(1 << 4)
+#define OVR_FLOW_IEN	(1 << 3)
+#define K_LCK_IM	(1 << 2)
+#define GPI_IEN		(1 << 1)
+#define KE_IEN		(1 << 0)
+
+/* Interrupt Status Register */
+#define CMP2_INT	(1 << 5)
+#define CMP1_INT	(1 << 4)
+#define OVR_FLOW_INT	(1 << 3)
+#define K_LCK_INT	(1 << 2)
+#define GPI_INT		(1 << 1)
+#define KE_INT		(1 << 0)
+
+/* Key Lock and Event Counter Register */
+#define K_LCK_EN	(1 << 6)
+#define LCK21		0x30
+#define KEC		0xF
+
+/* Key Event Register xy */
+#define KEY_EV_PRESSED		(1 << 7)
+#define KEY_EV_MASK		(0x7F)
+
+#define KP_SEL(x)		(0xFFFF >> (16 - x))	/* 2^x-1 */
+
+#define KEYP_MAX_EVENT		10
+
+/*
+ * Early pre 4.0 Silicon required to delay readout by at least 25ms,
+ * since the Event Counter Register updated 25ms after the interrupt
+ * asserted.
+ */
+#define WA_DELAYED_READOUT_REVID(rev)		((rev) < 4)
+
+struct adp5588_kpad {
+	struct i2c_client *client;
+	struct input_dev *input;
+	struct delayed_work work;
+	unsigned long delay;
+	unsigned short keycode[ADP5588_KEYMAPSIZE];
+};
+
+static int adp5588_read(struct i2c_client *client, u8 reg)
+{
+	int ret = i2c_smbus_read_byte_data(client, reg);
+
+	if (ret < 0)
+		dev_err(&client->dev, "Read Error\n");
+
+	return ret;
+}
+
+static int adp5588_write(struct i2c_client *client, u8 reg, u8 val)
+{
+	return i2c_smbus_write_byte_data(client, reg, val);
+}
+
+static void adp5588_work(struct work_struct *work)
+{
+	struct adp5588_kpad *kpad = container_of(work,
+						struct adp5588_kpad, work.work);
+	struct i2c_client *client = kpad->client;
+	int i, key, status, ev_cnt;
+
+	status = adp5588_read(client, INT_STAT);
+
+	if (status & OVR_FLOW_INT)	/* Unlikely and should never happen */
+		dev_err(&client->dev, "Event Overflow Error\n");
+
+	if (status & KE_INT) {
+		ev_cnt = adp5588_read(client, KEY_LCK_EC_STAT) & KEC;
+		if (ev_cnt) {
+			for (i = 0; i < ev_cnt; i++) {
+				key = adp5588_read(client, Key_EVENTA + i);
+				input_report_key(kpad->input,
+					kpad->keycode[(key & KEY_EV_MASK) - 1],
+					key & KEY_EV_PRESSED);
+			}
+			input_sync(kpad->input);
+		}
+	}
+	adp5588_write(client, INT_STAT, status); /* Status is W1C */
+}
+
+static irqreturn_t adp5588_irq(int irq, void *handle)
+{
+	struct adp5588_kpad *kpad = handle;
+
+	/*
+	 * use keventd context to read the event fifo registers
+	 * Schedule readout at least 25ms after notification for
+	 * REVID < 4
+	 */
+
+	schedule_delayed_work(&kpad->work, kpad->delay);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit adp5588_setup(struct i2c_client *client)
+{
+	struct adp5588_kpad_platform_data *pdata = client->dev.platform_data;
+	int i, ret;
+
+	ret = adp5588_write(client, KP_GPIO1, KP_SEL(pdata->rows));
+	ret |= adp5588_write(client, KP_GPIO2, KP_SEL(pdata->cols) & 0xFF);
+	ret |= adp5588_write(client, KP_GPIO3, KP_SEL(pdata->cols) >> 8);
+
+	if (pdata->en_keylock) {
+		ret |= adp5588_write(client, UNLOCK1, pdata->unlock_key1);
+		ret |= adp5588_write(client, UNLOCK2, pdata->unlock_key2);
+		ret |= adp5588_write(client, KEY_LCK_EC_STAT, K_LCK_EN);
+	}
+
+	for (i = 0; i < KEYP_MAX_EVENT; i++)
+		ret |= adp5588_read(client, Key_EVENTA);
+
+	ret |= adp5588_write(client, INT_STAT, CMP2_INT | CMP1_INT |
+					OVR_FLOW_INT | K_LCK_INT |
+					GPI_INT | KE_INT); /* Status is W1C */
+
+	ret |= adp5588_write(client, CFG, INT_CFG | OVR_FLOW_IEN | KE_IEN);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "Write Error\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devinit adp5588_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct adp5588_kpad *kpad;
+	struct adp5588_kpad_platform_data *pdata = client->dev.platform_data;
+	struct input_dev *input;
+	unsigned int revid;
+	int ret, i;
+	int error;
+
+	if (!i2c_check_functionality(client->adapter,
+					I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "SMBUS Byte Data not Supported\n");
+		return -EIO;
+	}
+
+	if (!pdata) {
+		dev_err(&client->dev, "no platform data?\n");
+		return -EINVAL;
+	}
+
+	if (!pdata->rows || !pdata->cols || !pdata->keymap) {
+		dev_err(&client->dev, "no rows, cols or keymap from pdata\n");
+		return -EINVAL;
+	}
+
+	if (pdata->keymapsize != ADP5588_KEYMAPSIZE) {
+		dev_err(&client->dev, "invalid keymapsize\n");
+		return -EINVAL;
+	}
+
+	if (!client->irq) {
+		dev_err(&client->dev, "no IRQ?\n");
+		return -EINVAL;
+	}
+
+	kpad = kzalloc(sizeof(*kpad), GFP_KERNEL);
+	input = input_allocate_device();
+	if (!kpad || !input) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	kpad->client = client;
+	kpad->input = input;
+	INIT_DELAYED_WORK(&kpad->work, adp5588_work);
+
+	ret = adp5588_read(client, DEV_ID);
+	if (ret < 0) {
+		error = ret;
+		goto err_free_mem;
+	}
+
+	revid = (u8) ret & ADP5588_DEVICE_ID_MASK;
+	if (WA_DELAYED_READOUT_REVID(revid))
+		kpad->delay = msecs_to_jiffies(30);
+
+	input->name = client->name;
+	input->phys = "adp5588-keys/input0";
+	input->dev.parent = &client->dev;
+
+	input_set_drvdata(input, kpad);
+
+	input->id.bustype = BUS_I2C;
+	input->id.vendor = 0x0001;
+	input->id.product = 0x0001;
+	input->id.version = revid;
+
+	input->keycodesize = sizeof(kpad->keycode[0]);
+	input->keycodemax = pdata->keymapsize;
+	input->keycode = kpad->keycode;
+
+	memcpy(kpad->keycode, pdata->keymap,
+		pdata->keymapsize * input->keycodesize);
+
+	/* setup input device */
+	__set_bit(EV_KEY, input->evbit);
+
+	if (pdata->repeat)
+		__set_bit(EV_REP, input->evbit);
+
+	for (i = 0; i < input->keycodemax; i++)
+		__set_bit(kpad->keycode[i] & KEY_MAX, input->keybit);
+	__clear_bit(KEY_RESERVED, input->keybit);
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&client->dev, "unable to register input device\n");
+		goto err_free_mem;
+	}
+
+	error = request_irq(client->irq, adp5588_irq,
+			    IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			    client->dev.driver->name, kpad);
+	if (error) {
+		dev_err(&client->dev, "irq %d busy?\n", client->irq);
+		goto err_unreg_dev;
+	}
+
+	error = adp5588_setup(client);
+	if (error)
+		goto err_free_irq;
+
+	device_init_wakeup(&client->dev, 1);
+	i2c_set_clientdata(client, kpad);
+
+	dev_info(&client->dev, "Rev.%d keypad, irq %d\n", revid, client->irq);
+	return 0;
+
+ err_free_irq:
+	free_irq(client->irq, kpad);
+ err_unreg_dev:
+	input_unregister_device(input);
+	input = NULL;
+ err_free_mem:
+	input_free_device(input);
+	kfree(kpad);
+
+	return error;
+}
+
+static int __devexit adp5588_remove(struct i2c_client *client)
+{
+	struct adp5588_kpad *kpad = i2c_get_clientdata(client);
+
+	adp5588_write(client, CFG, 0);
+	free_irq(client->irq, kpad);
+	cancel_delayed_work_sync(&kpad->work);
+	input_unregister_device(kpad->input);
+	i2c_set_clientdata(client, NULL);
+	kfree(kpad);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int adp5588_suspend(struct device *dev)
+{
+	struct adp5588_kpad *kpad = dev_get_drvdata(dev);
+	struct i2c_client *client = kpad->client;
+
+	disable_irq(client->irq);
+	cancel_delayed_work_sync(&kpad->work);
+
+	if (device_may_wakeup(&client->dev))
+		enable_irq_wake(client->irq);
+
+	return 0;
+}
+
+static int adp5588_resume(struct device *dev)
+{
+	struct adp5588_kpad *kpad = dev_get_drvdata(dev);
+	struct i2c_client *client = kpad->client;
+
+	if (device_may_wakeup(&client->dev))
+		disable_irq_wake(client->irq);
+
+	enable_irq(client->irq);
+
+	return 0;
+}
+
+static struct dev_pm_ops adp5588_dev_pm_ops = {
+	.suspend = adp5588_suspend,
+	.resume  = adp5588_resume,
+};
+#endif
+
+static const struct i2c_device_id adp5588_id[] = {
+	{ KBUILD_MODNAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adp5588_id);
+
+static struct i2c_driver adp5588_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+#ifdef CONFIG_PM
+		.pm   = &adp5588_dev_pm_ops,
+#endif
+	},
+	.probe    = adp5588_probe,
+	.remove   = __devexit_p(adp5588_remove),
+	.id_table = adp5588_id,
+};
+
+static int __init adp5588_init(void)
+{
+	return i2c_add_driver(&adp5588_driver);
+}
+module_init(adp5588_init);
+
+static void __exit adp5588_exit(void)
+{
+	i2c_del_driver(&adp5588_driver);
+}
+module_exit(adp5588_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("ADP5588 Keypad driver");
+MODULE_ALIAS("platform:adp5588-keys");
diff --git a/include/linux/i2c/adp5588.h b/include/linux/i2c/adp5588.h
new file mode 100644
index 0000000..fc5db82
--- /dev/null
+++ b/include/linux/i2c/adp5588.h
@@ -0,0 +1,92 @@
+/*
+ * Analog Devices ADP5588 I/O Expander and QWERTY Keypad Controller
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef _ADP5588_H
+#define _ADP5588_H
+
+#define DEV_ID 0x00		/* Device ID */
+#define CFG 0x01		/* Configuration Register1 */
+#define INT_STAT 0x02		/* Interrupt Status Register */
+#define KEY_LCK_EC_STAT 0x03	/* Key Lock and Event Counter Register */
+#define Key_EVENTA 0x04		/* Key Event Register A */
+#define Key_EVENTB 0x05		/* Key Event Register B */
+#define Key_EVENTC 0x06		/* Key Event Register C */
+#define Key_EVENTD 0x07		/* Key Event Register D */
+#define Key_EVENTE 0x08		/* Key Event Register E */
+#define Key_EVENTF 0x09		/* Key Event Register F */
+#define Key_EVENTG 0x0A		/* Key Event Register G */
+#define Key_EVENTH 0x0B		/* Key Event Register H */
+#define Key_EVENTI 0x0C		/* Key Event Register I */
+#define Key_EVENTJ 0x0D		/* Key Event Register J */
+#define KP_LCK_TMR 0x0E		/* Keypad Lock1 to Lock2 Timer */
+#define UNLOCK1 0x0F		/* Unlock Key1 */
+#define UNLOCK2 0x10		/* Unlock Key2 */
+#define GPIO_INT_STAT1 0x11	/* GPIO Interrupt Status */
+#define GPIO_INT_STAT2 0x12	/* GPIO Interrupt Status */
+#define GPIO_INT_STAT3 0x13	/* GPIO Interrupt Status */
+#define GPIO_DAT_STAT1 0x14	/* GPIO Data Status, Read twice to clear */
+#define GPIO_DAT_STAT2 0x15	/* GPIO Data Status, Read twice to clear */
+#define GPIO_DAT_STAT3 0x16	/* GPIO Data Status, Read twice to clear */
+#define GPIO_DAT_OUT1 0x17	/* GPIO DATA OUT */
+#define GPIO_DAT_OUT2 0x18	/* GPIO DATA OUT */
+#define GPIO_DAT_OUT3 0x19	/* GPIO DATA OUT */
+#define GPIO_INT_EN1 0x1A	/* GPIO Interrupt Enable */
+#define GPIO_INT_EN2 0x1B	/* GPIO Interrupt Enable */
+#define GPIO_INT_EN3 0x1C	/* GPIO Interrupt Enable */
+#define KP_GPIO1 0x1D		/* Keypad or GPIO Selection */
+#define KP_GPIO2 0x1E		/* Keypad or GPIO Selection */
+#define KP_GPIO3 0x1F		/* Keypad or GPIO Selection */
+#define GPI_EM1 0x20		/* GPI Event Mode 1 */
+#define GPI_EM2 0x21		/* GPI Event Mode 2 */
+#define GPI_EM3 0x22		/* GPI Event Mode 3 */
+#define GPIO_DIR1 0x23		/* GPIO Data Direction */
+#define GPIO_DIR2 0x24		/* GPIO Data Direction */
+#define GPIO_DIR3 0x25		/* GPIO Data Direction */
+#define GPIO_INT_LVL1 0x26	/* GPIO Edge/Level Detect */
+#define GPIO_INT_LVL2 0x27	/* GPIO Edge/Level Detect */
+#define GPIO_INT_LVL3 0x28	/* GPIO Edge/Level Detect */
+#define Debounce_DIS1 0x29	/* Debounce Disable */
+#define Debounce_DIS2 0x2A	/* Debounce Disable */
+#define Debounce_DIS3 0x2B	/* Debounce Disable */
+#define GPIO_PULL1 0x2C		/* GPIO Pull Disable */
+#define GPIO_PULL2 0x2D		/* GPIO Pull Disable */
+#define GPIO_PULL3 0x2E		/* GPIO Pull Disable */
+#define CMP_CFG_STAT 0x30	/* Comparator Configuration and Status Register */
+#define CMP_CONFG_SENS1 0x31	/* Sensor1 Comparator Configuration Register */
+#define CMP_CONFG_SENS2 0x32	/* L2 Light Sensor Reference Level, Output Falling for Sensor 1 */
+#define CMP1_LVL2_TRIP 0x33	/* L2 Light Sensor Hysteresis (Active when Output Rising) for Sensor 1 */
+#define CMP1_LVL2_HYS 0x34	/* L3 Light Sensor Reference Level, Output Falling For Sensor 1 */
+#define CMP1_LVL3_TRIP 0x35	/* L3 Light Sensor Hysteresis (Active when Output Rising) For Sensor 1 */
+#define CMP1_LVL3_HYS 0x36	/* Sensor 2 Comparator Configuration Register */
+#define CMP2_LVL2_TRIP 0x37	/* L2 Light Sensor Reference Level, Output Falling for Sensor 2 */
+#define CMP2_LVL2_HYS 0x38	/* L2 Light Sensor Hysteresis (Active when Output Rising) for Sensor 2 */
+#define CMP2_LVL3_TRIP 0x39	/* L3 Light Sensor Reference Level, Output Falling For Sensor 2 */
+#define CMP2_LVL3_HYS 0x3A	/* L3 Light Sensor Hysteresis (Active when Output Rising) For Sensor 2 */
+#define CMP1_ADC_DAT_R1 0x3B	/* Comparator 1 ADC data Register1 */
+#define CMP1_ADC_DAT_R2 0x3C	/* Comparator 1 ADC data Register2 */
+#define CMP2_ADC_DAT_R1 0x3D	/* Comparator 2 ADC data Register1 */
+#define CMP2_ADC_DAT_R2 0x3E	/* Comparator 2 ADC data Register2 */
+
+#define ADP5588_DEVICE_ID_MASK	0xF
+
+/* Put one of these structures in i2c_board_info platform_data */
+
+#define ADP5588_KEYMAPSIZE	80
+
+struct adp5588_kpad_platform_data {
+	int rows;			/* Number of rows */
+	int cols;			/* Number of columns */
+	const unsigned short *keymap;	/* Pointer to keymap */
+	unsigned short keymapsize;	/* Keymap size */
+	unsigned repeat:1;		/* Enable key repeat */
+	unsigned en_keylock:1;		/* Enable Key Lock feature */
+	unsigned short unlock_key1;	/* Unlock Key 1 */
+	unsigned short unlock_key2;	/* Unlock Key 2 */
+};
+
+#endif
-- 
1.6.5.rc1

