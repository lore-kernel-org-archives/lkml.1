Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbYGJTGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbYGJTGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761981AbYGJTFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:05:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:14462 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761742AbYGJTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vm+KAk2kI4Sy2qiBinIwjGFWaI6Q6XxnK/8iiXPuBPXlZNQ8AcKOtt0Y3WeTzguK0O
         4VfbpsJwzoYnIzZqxyJGo852BTJtLXzmM/BClzs9N3qQm6RUGg1tVPWlWUqCSjahm8Og
         fBHp3OH+1SWKuhkUWgbIbuBB6b+LgfNzuUWJ0=
Subject: [PATCH 1/2] regulator: TI bq24022 Li-Ion Charger driver
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 21:04:43 +0200
Message-Id: <1215716683.17490.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a regulator driver for the TI bq24022 Single-Chip
Li-Ion Charger with its nCE and ISET2 pins connected to GPIOs.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/regulator/Kconfig         |   10 ++
 drivers/regulator/Makefile        |    2 +
 drivers/regulator/bq24022.c       |  167 +++++++++++++++++++++++++++++++++++++
 include/linux/regulator/bq24022.h |   23 +++++
 4 files changed, 202 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/bq24022.c
 create mode 100644 include/linux/regulator/bq24022.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 84f89ec..a656128 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -46,4 +46,14 @@ config REGULATOR_VIRTUAL_CONSUMER
 
           If unsure, say no.
 
+config REGULATOR_BQ24022
+	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
+	default n
+	select REGULATOR
+	help
+	  This driver controls a TI bq24022 Charger attached via
+	  GPIOs. The provided current regulator can enable/disable
+	  charging select between 100 mA and 500 mA charging current
+	  limit.
+
 endmenu
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 29528b7..ac2c64e 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -7,4 +7,6 @@ obj-$(CONFIG_REGULATOR) += core.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 
+obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
+
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
new file mode 100644
index 0000000..bdae7f7
--- /dev/null
+++ b/drivers/regulator/bq24022.c
@@ -0,0 +1,167 @@
+/*
+ * Support for TI bq24022 (bqTINY-II) Dual Input (USB/AC Adpater)
+ * 1-Cell Li-Ion Charger connected via GPIOs.
+ *
+ * Copyright (c) 2008 Philipp Zabel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/regulator/bq24022.h>
+#include <linux/regulator/driver.h>
+
+static int bq24022_set_current_limit(struct regulator_dev *rdev,
+					int min_uA, int max_uA)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	dev_dbg(&pdev->dev, "setting current limit to %s mA\n",
+		max_uA >= 500000 ? "500" : "100");
+
+	/* REVISIT: maybe return error if min_uA != 0 ? */
+	gpio_set_value(pdata->gpio_iset2, max_uA >= 500000);
+	return 0;
+}
+
+static int bq24022_get_current_limit(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	return gpio_get_value(pdata->gpio_iset2) ? 500000 : 100000;
+}
+
+static int bq24022_enable(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	dev_dbg(&pdev->dev, "enabling charger\n");
+
+	gpio_set_value(pdata->gpio_nce, 0);
+	return 0;
+}
+
+static int bq24022_disable(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	dev_dbg(&pdev->dev, "disabling charger\n");
+
+	gpio_set_value(pdata->gpio_nce, 1);
+	return 0;
+}
+
+static int bq24022_is_enabled(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	return !gpio_get_value(pdata->gpio_nce);
+}
+
+static struct regulator_ops bq24022_ops = {
+	.set_current_limit = bq24022_set_current_limit,
+	.get_current_limit = bq24022_get_current_limit,
+	.enable            = bq24022_enable,
+	.disable           = bq24022_disable,
+	.is_enabled        = bq24022_is_enabled,
+};
+
+static struct regulator_desc bq24022_desc = {
+	.name  = "bq24022",
+	.ops   = &bq24022_ops,
+	.type  = REGULATOR_CURRENT,
+};
+
+static int __init bq24022_probe(struct platform_device *pdev)
+{
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+	struct regulator_dev *bq24022;
+	int ret;
+
+	if (!pdata || !pdata->gpio_nce || !pdata->gpio_iset2)
+		return -EINVAL;
+
+	ret = gpio_request(pdata->gpio_nce, "ncharge_en");
+	if (ret) {
+		dev_dbg(&pdev->dev, "couldn't request nCE GPIO: %d\n",
+			pdata->gpio_nce);
+		goto err_ce;
+	}
+	ret = gpio_request(pdata->gpio_iset2, "charge_mode");
+	if (ret) {
+		dev_dbg(&pdev->dev, "couldn't request ISET2 GPIO: %d\n",
+			pdata->gpio_iset2);
+		goto err_iset2;
+	}
+	ret = gpio_direction_output(pdata->gpio_iset2, 0);
+	ret = gpio_direction_output(pdata->gpio_nce, 1);
+
+	bq24022 = regulator_register(&bq24022_desc, pdev);
+	if (IS_ERR(bq24022)) {
+		dev_dbg(&pdev->dev, "couldn't register regulator\n");
+		ret = PTR_ERR(bq24022);
+		goto err_reg;
+	}
+	platform_set_drvdata(pdev, bq24022);
+	dev_dbg(&pdev->dev, "registered regulator\n");
+
+	return 0;
+err_reg:
+	gpio_free(pdata->gpio_iset2);
+err_iset2:
+	gpio_free(pdata->gpio_nce);
+err_ce:
+	return ret;
+}
+
+static int __devexit bq24022_remove(struct platform_device *pdev)
+{
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+	struct regulator_dev *bq24022 = platform_get_drvdata(pdev);
+
+	regulator_unregister(bq24022);
+	gpio_free(pdata->gpio_iset2);
+	gpio_free(pdata->gpio_nce);
+
+	return 0;
+}
+
+static struct platform_driver bq24022_driver = {
+	.driver = {
+		.name = "bq24022",
+	},
+	.remove = __devexit_p(bq24022_remove),
+};
+
+static int __init bq24022_init()
+{
+	platform_driver_probe(&bq24022_driver, bq24022_probe);
+}
+
+static void __exit bq24022_exit()
+{
+	platform_driver_unregister(&bq24022_driver);
+}
+
+/*
+ * make sure this is probed before gpio_vbus and pda_power,
+ * but after asic3 or other GPIO expander drivers.
+ */
+subsys_initcall(bq24022_init);
+module_exit(bq24022_exit);
+
+MODULE_AUTHOR("Philipp Zabel");
+MODULE_DESCRIPTION("TI bq24022 Li-Ion Charger driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/bq24022.h b/include/linux/regulator/bq24022.h
new file mode 100644
index 0000000..6824a81
--- /dev/null
+++ b/include/linux/regulator/bq24022.h
@@ -0,0 +1,23 @@
+/*
+ * Support for TI bq24022 (bqTINY-II) Dual Input (USB/AC Adpater)
+ * 1-Cell Li-Ion Charger connected via GPIOs.
+ *
+ * Copyright (c) 2008 Philipp Zabel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/**
+ *bq24022_mach_info - platform data for bq24022
+ *@gpio_nce: GPIO line connected to the nCE pin,
+ *           used to enable / disable charging.
+ *@gpio_iset2: GPIO line connected to the ISET2 pin,
+ *             used to limit charging current to 100 mA / 500 mA.
+ */
+struct bq24022_mach_info {
+	int gpio_nce;
+	int gpio_iset2;
+};
-- 
1.5.6.2


