Return-Path: <linux-kernel-owner+w=401wt.eu-S934574AbZJJRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbZJJRzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762014AbZJJRyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:54:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59673 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZJJRym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:54:42 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/5] input/keyboard: new driver for ADP5520 MFD PMICs
Date: Sat, 10 Oct 2009 13:54:02 -0400
Message-Id: <1255197244-20121-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1255197244-20121-1-git-send-email-vapier@gentoo.org>
References: <1255197244-20121-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/Kconfig        |   10 ++
 drivers/input/keyboard/Makefile       |    1 +
 drivers/input/keyboard/adp5520-keys.c |  220 +++++++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/adp5520-keys.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index ee98b1b..9337a35 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -24,6 +24,16 @@ config KEYBOARD_AAED2000
 	  To compile this driver as a module, choose M here: the
 	  module will be called aaed2000_kbd.
 
+config KEYBOARD_ADP5520
+	tristate "Keypad Support for ADP5520 PMIC"
+	depends on PMIC_ADP5520
+	help
+	  This option enables support for the keypad scan matrix
+	  on Analog Devices ADP5520 PMICs.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called adp5520-keys.
+
 config KEYBOARD_ADP5588
 	tristate "ADP5588 I2C QWERTY Keypad and IO Expander"
 	depends on I2C
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index babad5e..8fb03c9 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -5,6 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_KEYBOARD_AAED2000)		+= aaed2000_kbd.o
+obj-$(CONFIG_KEYBOARD_ADP5520)		+= adp5520-keys.o
 obj-$(CONFIG_KEYBOARD_ADP5588)		+= adp5588-keys.o
 obj-$(CONFIG_KEYBOARD_AMIGA)		+= amikbd.o
 obj-$(CONFIG_KEYBOARD_ATARI)		+= atakbd.o
diff --git a/drivers/input/keyboard/adp5520-keys.c b/drivers/input/keyboard/adp5520-keys.c
new file mode 100644
index 0000000..a7ba27f
--- /dev/null
+++ b/drivers/input/keyboard/adp5520-keys.c
@@ -0,0 +1,220 @@
+/*
+ * Keypad driver for Analog Devices ADP5520 MFD PMICs
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/mfd/adp5520.h>
+
+struct adp5520_keys {
+	struct input_dev *input;
+	struct notifier_block notifier;
+	struct device *master;
+	unsigned short keycode[ADP5520_KEYMAPSIZE];
+};
+
+static void adp5520_keys_report_event(struct adp5520_keys *dev,
+					unsigned short keymask, int value)
+{
+	int i;
+
+	for (i = 0; i < ADP5520_MAXKEYS; i++)
+		if (keymask & (1 << i))
+			input_report_key(dev->input, dev->keycode[i], value);
+
+	input_sync(dev->input);
+}
+
+static int adp5520_keys_notifier(struct notifier_block *nb,
+				 unsigned long event, void *data)
+{
+	struct adp5520_keys *dev;
+	uint8_t reg_val_lo, reg_val_hi;
+	unsigned short keymask;
+
+	dev = container_of(nb, struct adp5520_keys, notifier);
+
+	if (event & ADP5520_KP_INT) {
+		adp5520_read(dev->master, ADP5520_KP_INT_STAT_1, &reg_val_lo);
+		adp5520_read(dev->master, ADP5520_KP_INT_STAT_2, &reg_val_hi);
+
+		keymask = (reg_val_hi << 8) | reg_val_lo;
+		/* Read twice to clear */
+		adp5520_read(dev->master, ADP5520_KP_INT_STAT_1, &reg_val_lo);
+		adp5520_read(dev->master, ADP5520_KP_INT_STAT_2, &reg_val_hi);
+		keymask |= (reg_val_hi << 8) | reg_val_lo;
+		adp5520_keys_report_event(dev, keymask, 1);
+	}
+
+	if (event & ADP5520_KR_INT) {
+		adp5520_read(dev->master, ADP5520_KR_INT_STAT_1, &reg_val_lo);
+		adp5520_read(dev->master, ADP5520_KR_INT_STAT_2, &reg_val_hi);
+
+		keymask = (reg_val_hi << 8) | reg_val_lo;
+		/* Read twice to clear */
+		adp5520_read(dev->master, ADP5520_KR_INT_STAT_1, &reg_val_lo);
+		adp5520_read(dev->master, ADP5520_KR_INT_STAT_2, &reg_val_hi);
+		keymask |= (reg_val_hi << 8) | reg_val_lo;
+		adp5520_keys_report_event(dev, keymask, 0);
+	}
+
+	return 0;
+}
+
+static int __devinit adp5520_keys_probe(struct platform_device *pdev)
+{
+	struct adp5520_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input;
+	struct adp5520_keys *dev;
+	int ret, i;
+	unsigned char en_mask, ctl_mask = 0;
+
+	if (pdev->id != ID_ADP5520) {
+		dev_err(&pdev->dev, "only ADP5520 supports Keypad\n");
+		return -EINVAL;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -EINVAL;
+	}
+
+	if (!(pdata->rows_en_mask && pdata->cols_en_mask))
+		return -EINVAL;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	input = input_allocate_device();
+	if (!input) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->master = pdev->dev.parent;
+	dev->input = input;
+
+	input->name = pdev->name;
+	input->phys = "adp5520-keys/input0";
+	input->dev.parent = &pdev->dev;
+
+	input_set_drvdata(input, dev);
+
+	input->id.bustype = BUS_I2C;
+	input->id.vendor = 0x0001;
+	input->id.product = 0x5520;
+	input->id.version = 0x0001;
+
+	input->keycodesize = sizeof(dev->keycode[0]);
+	input->keycodemax = pdata->keymapsize;
+	input->keycode = dev->keycode;
+
+	memcpy(dev->keycode, pdata->keymap,
+		pdata->keymapsize * input->keycodesize);
+
+	/* setup input device */
+	__set_bit(EV_KEY, input->evbit);
+
+	if (pdata->repeat)
+		__set_bit(EV_REP, input->evbit);
+
+	for (i = 0; i < input->keycodemax; i++)
+		__set_bit(dev->keycode[i], input->keybit);
+	__clear_bit(KEY_RESERVED, input->keybit);
+
+	ret = input_register_device(input);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to register input device\n");
+		goto err;
+	}
+
+	en_mask = pdata->rows_en_mask | pdata->cols_en_mask;
+
+	ret = adp5520_set_bits(dev->master, ADP5520_GPIO_CFG_1, en_mask);
+
+	if (en_mask & ADP5520_COL_C3)
+		ctl_mask |= ADP5520_C3_MODE;
+
+	if (en_mask & ADP5520_ROW_R3)
+		ctl_mask |= ADP5520_R3_MODE;
+
+	if (ctl_mask)
+		ret |= adp5520_set_bits(dev->master, ADP5520_LED_CONTROL,
+			ctl_mask);
+
+	ret |= adp5520_set_bits(dev->master, ADP5520_GPIO_PULLUP,
+		pdata->rows_en_mask);
+
+	if (ret) {
+		dev_err(&pdev->dev, "failed to write\n");
+		ret = -EIO;
+		goto err1;
+	}
+
+	dev->notifier.notifier_call = adp5520_keys_notifier;
+	ret = adp5520_register_notifier(dev->master, &dev->notifier,
+			ADP5520_KP_IEN | ADP5520_KR_IEN);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register notifier\n");
+		goto err1;
+	}
+
+	platform_set_drvdata(pdev, dev);
+	return 0;
+
+err1:
+	input_unregister_device(input);
+	input = NULL;
+err:
+	input_free_device(input);
+	kfree(dev);
+	return ret;
+}
+
+static int __devexit adp5520_keys_remove(struct platform_device *pdev)
+{
+	struct adp5520_keys *dev = platform_get_drvdata(pdev);
+
+	adp5520_unregister_notifier(dev->master, &dev->notifier,
+				ADP5520_KP_IEN | ADP5520_KR_IEN);
+
+	input_unregister_device(dev->input);
+	kfree(dev);
+	return 0;
+}
+
+static struct platform_driver adp5520_keys_driver = {
+	.driver	= {
+		.name	= "adp5520-keys",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= adp5520_keys_probe,
+	.remove		= __devexit_p(adp5520_keys_remove),
+};
+
+static int __init adp5520_keys_init(void)
+{
+	return platform_driver_register(&adp5520_keys_driver);
+}
+module_init(adp5520_keys_init);
+
+static void __exit adp5520_keys_exit(void)
+{
+	platform_driver_unregister(&adp5520_keys_driver);
+}
+module_exit(adp5520_keys_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("Keys ADP5520 Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:adp5520-keys");
-- 
1.6.5.rc2

