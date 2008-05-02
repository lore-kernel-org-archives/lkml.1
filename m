Return-Path: <linux-kernel-owner+w=401wt.eu-S965152AbYEBPw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152AbYEBPw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934031AbYEBPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:51:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38979 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763454AbYEBPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:51:50 -0400
Subject: [PATCH 06/13] regulator: add support for fixed regulators.
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 16:42:44 +0100
Message-Id: <1209742964.12502.48.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds supports for regulators that are not software controllable. It allows
them to coexist in systems with mixed supplies.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |  129 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/fixed.c

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
new file mode 100644
index 0000000..68abafb
--- /dev/null
+++ b/drivers/regulator/fixed.c
@@ -0,0 +1,129 @@
+/*
+ * reg-fixed-voltage.c
+ *
+ * Copyright 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This is useful for systems with mixed controllable and
+ * non-controllable regulators, as well as for allowing testing on
+ * systems with no controllable regulators.
+ */
+
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/regulator-drv.h>
+#include <linux/regulator/fixed-voltage.h>
+
+struct fixed_voltage_data {
+	struct regulator_desc desc;
+	struct regulator_dev *dev;
+	int microvolts;
+};
+
+static int fixed_voltage_is_enabled(struct regulator_dev *dev)
+{
+	return 1;
+}
+
+static int fixed_voltage_enable(struct regulator_dev *dev)
+{
+	return 0;
+}
+
+static int fixed_voltage_get_voltage(struct regulator_dev *dev)
+{
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	return data->microvolts;
+}
+
+static struct regulator_ops fixed_voltage_ops = {
+	.is_enabled = fixed_voltage_is_enabled,
+	.enable = fixed_voltage_enable,
+	.get_voltage = fixed_voltage_get_voltage,
+};
+
+static int regulator_fixed_voltage_probe(struct platform_device *pdev)
+{
+	struct fixed_voltage_config *config = pdev->dev.platform_data;
+	struct fixed_voltage_data *drvdata;
+	int ret;
+
+	drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
+	if (drvdata == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
+	if (drvdata->desc.name == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	drvdata->desc.type = REGULATOR_VOLTAGE;
+	drvdata->desc.owner = THIS_MODULE;
+	drvdata->desc.ops = &fixed_voltage_ops,
+
+	drvdata->microvolts = config->microvolts;
+
+	drvdata->dev = regulator_register(&drvdata->desc, drvdata);
+	if (IS_ERR(drvdata->dev)) {
+		ret = PTR_ERR(drvdata->dev);
+		goto err_name;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+
+	dev_dbg(&pdev->dev, "%s supplying %duV\n", drvdata->desc.name,
+		drvdata->microvolts);
+
+	return 0;
+
+err_name:
+	kfree(drvdata->desc.name);
+err:
+	kfree(drvdata);
+	return ret;
+}
+
+static int regulator_fixed_voltage_remove(struct platform_device *pdev)
+{
+	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
+
+	regulator_unregister(drvdata->dev);
+	kfree(drvdata->desc.name);
+	kfree(drvdata);
+
+	return 0;
+}
+
+static struct platform_driver regulator_fixed_voltage_driver = {
+	.probe		= regulator_fixed_voltage_probe,
+	.remove		= regulator_fixed_voltage_remove,
+	.driver		= {
+		.name		= "reg-fixed-voltage",
+	},
+};
+
+static int __init regulator_fixed_voltage_init(void)
+{
+	return platform_driver_register(&regulator_fixed_voltage_driver);
+}
+module_init(regulator_fixed_voltage_init);
+
+static void __exit regulator_fixed_voltage_exit(void)
+{
+	platform_driver_unregister(&regulator_fixed_voltage_driver);
+}
+module_exit(regulator_fixed_voltage_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("Fixed voltage regulator");
+MODULE_LICENSE("GPL");
-- 
1.5.4.3


