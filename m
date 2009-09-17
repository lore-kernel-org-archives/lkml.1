Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZIQSYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZIQSYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZIQSYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:24:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34708 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZIQSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:24:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] input/keyboard: new driver for ADP5520 MFD PMICs
Date: Thu, 17 Sep 2009 14:24:10 -0400
Message-Id: <1253211850-29309-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/input/keyboard/Kconfig        |   10 ++
 drivers/input/keyboard/Makefile       |    1 +
 drivers/input/keyboard/adp5520-keys.c |  219 +++++++++++++++++++++++++++++++++
 3 files changed, 230 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/keyboard/adp5520-keys.c

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index e0bfcd7..53c9561 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -392,4 +392,14 @@ config KEYBOARD_ADP5588
 	  To compile this driver as a module, choose M here: the
 	  module will be called adp5588-keys.
 
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
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 72082a4..c541489 100644
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
index 0000000..cc2e1ed
--- /dev/null
+++ b/drivers/input/keyboard/adp5520-keys.c
@@ -0,0 +1,219 @@
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
+	uint8_t reg_val_low, reg_val_high;
+	unsigned short keymask;
+
+	dev = container_of(nb, struct adp5520_keys, notifier);
+
+	if (event & KP_INT) {
+		adp5520_read(dev->master, KP_INT_STAT_1, &reg_val_low);
+		adp5520_read(dev->master, KP_INT_STAT_2, &reg_val_high);
+
+		keymask = (reg_val_high << 8) | reg_val_low;
+		/* Read twice to clear */
+		adp5520_read(dev->master, KP_INT_STAT_1, &reg_val_low);
+		adp5520_read(dev->master, KP_INT_STAT_2, &reg_val_high);
+		keymask |= (reg_val_high << 8) | reg_val_low;
+		adp5520_keys_report_event(dev, keymask, 1);
+	}
+
+	if (event & KR_INT) {
+		adp5520_read(dev->master, KR_INT_STAT_1, &reg_val_low);
+		adp5520_read(dev->master, KR_INT_STAT_2, &reg_val_high);
+
+		keymask = (reg_val_high << 8) | reg_val_low;
+		/* Read twice to clear */
+		adp5520_read(dev->master, KR_INT_STAT_1, &reg_val_low);
+		adp5520_read(dev->master, KR_INT_STAT_2, &reg_val_high);
+		keymask |= (reg_val_high << 8) | reg_val_low;
+		adp5520_keys_report_event(dev, keymask, 0);
+	}
+
+	return 0;
+}
+
+static int __devinit adp5520_keys_probe(struct platform_device *pdev)
+{
+	struct adp5520_keys_platfrom_data *pdata = pdev->dev.platform_data;
+	struct input_dev *input;
+	struct adp5520_keys *dev;
+	int ret, i;
+	unsigned char en_mask, ctl_mask = 0;
+
+	if (pdev->id != ID_ADP5520) {
+		dev_err(&pdev->dev, "only ADP5520 supports Keypad\n");
+		return -EFAULT;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	if (!(pdata->rows_en_mask && pdata->cols_en_mask))
+		return -ENODEV;
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
+	input->keycodesize = sizeof(unsigned short);
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
+		__set_bit(dev->keycode[i] & KEY_MAX, input->keybit);
+	__clear_bit(KEY_RESERVED, input->keybit);
+
+	ret = input_register_device(input);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to register input device\n");
+		input_free_device(input);
+		goto err;
+	}
+
+	en_mask = pdata->rows_en_mask | pdata->cols_en_mask;
+
+	ret = adp5520_set_bits(dev->master, GPIO_CFG_1, en_mask);
+
+	if (en_mask & COL_C3)
+		ctl_mask |= C3_MODE;
+
+	if (en_mask & ROW_R3)
+		ctl_mask |= R3_MODE;
+
+	if (ctl_mask)
+		ret |= adp5520_set_bits(dev->master, LED_CONTROL,
+			ctl_mask);
+
+	ret |= adp5520_set_bits(dev->master, GPIO_PULLUP,
+		pdata->rows_en_mask);
+
+	if (ret) {
+		dev_err(&pdev->dev, "failed to write\n");
+		goto err1;
+	}
+
+	dev->notifier.notifier_call = adp5520_keys_notifier;
+	ret = adp5520_register_notifier(dev->master, &dev->notifier,
+			KP_IEN | KR_IEN);
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
+err:
+	kfree(dev);
+	return ret;
+}
+
+static int __devexit adp5520_keys_remove(struct platform_device *pdev)
+{
+	struct adp5520_keys *dev;
+	dev = platform_get_drvdata(pdev);
+
+	adp5520_unregister_notifier(dev->master, &dev->notifier,
+				KP_IEN | KR_IEN);
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
1.6.5.rc1

