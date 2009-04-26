Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZDZNuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZDZNuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZDZNub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:50:31 -0400
Received: from cathcart.site5.com ([74.54.107.137]:50800 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZDZNua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:50:30 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] regulator: add userspace-consumer driver
Date: Sun, 26 Apr 2009 16:49:39 +0300
Message-Id: <1240753779-28189-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20090426120036.GA10900@opensource.wolfsonmicro.com>
References: <20090426120036.GA10900@opensource.wolfsonmicro.com>
In-Reply-To: <20090426120036.GA10900@opensource.wolfsonmicro.com>
References: <20090426120036.GA10900@opensource.wolfsonmicro.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace-consumer driver allows control of voltage and current
regulator state from userspace. This is required for fine-grained
power management of devices that are completely controller by userspace
applications, e.g. a GPS transciever connected to a serial port.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/Kconfig                    |   10 ++
 drivers/regulator/Makefile                   |    1 +
 drivers/regulator/userspace-consumer.c       |  200 ++++++++++++++++++++++++++
 include/linux/regulator/userspace-consumer.h |   25 ++++
 4 files changed, 236 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/userspace-consumer.c
 create mode 100644 include/linux/regulator/userspace-consumer.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index e58c0ce..d736e61 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -47,6 +47,16 @@ config REGULATOR_VIRTUAL_CONSUMER
 
           If unsure, say no.
 
+config REGULATOR_USERSPACE_CONSUMER
+	tristate "Userspace regulator consumer support"
+	default n
+	help
+	  There are some classes of devices that are controlled entirely
+	  from user space. Usersapce consumer driver provides ability to
+	  control power supplies for such devices.
+
+          If unsure, say no.
+
 config REGULATOR_BQ24022
 	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
 	default n
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index bac133a..b8d4290 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -6,6 +6,7 @@
 obj-$(CONFIG_REGULATOR) += core.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
+obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
new file mode 100644
index 0000000..71fcf9d
--- /dev/null
+++ b/drivers/regulator/userspace-consumer.c
@@ -0,0 +1,200 @@
+/*
+ * userspace-consumer.c
+ *
+ * Copyright 2009 CompuLab, Ltd.
+ *
+ * Author: Mike Rapoport <mike@compulab.co.il>
+ *
+ * Based of virtual consumer driver:
+ *   Copyright 2008 Wolfson Microelectronics PLC.
+ *   Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/userspace-consumer.h>
+
+struct userspace_consumer_data {
+	const char *name;
+
+	struct mutex lock;
+	bool enabled;
+
+	int num_supplies;
+	struct regulator_bulk_data *supplies;
+};
+
+static ssize_t show_name(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct userspace_consumer_data *data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", data->name);
+}
+
+static ssize_t show_state(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct userspace_consumer_data *data = dev_get_drvdata(dev);
+
+	if (data->enabled)
+		return sprintf(buf, "enabled\n");
+
+	return sprintf(buf, "disabled\n");
+}
+
+static ssize_t set_state(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct userspace_consumer_data *data = dev_get_drvdata(dev);
+	bool enabled;
+	int ret;
+
+	/*
+	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
+	 * will be shared with show_state(), above.
+	 */
+	if (sysfs_streq(buf, "enabled\n") || sysfs_streq(buf, "1"))
+		enabled = true;
+	else if (sysfs_streq(buf, "disabled\n") || sysfs_streq(buf, "0"))
+		enabled = false;
+	else {
+		dev_err(dev, "Configuring invalid mode\n");
+		return count;
+	}
+
+	mutex_lock(&data->lock);
+	if (enabled != data->enabled) {
+		if (enabled)
+			ret = regulator_bulk_enable(data->num_supplies,
+						    data->supplies);
+		else
+			ret = regulator_bulk_disable(data->num_supplies,
+						     data->supplies);
+
+		if (ret == 0)
+			data->enabled = enabled;
+		else
+			dev_err(dev, "Failed to configure state: %d\n", ret);
+	}
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(name, 0444, show_name, NULL);
+static DEVICE_ATTR(state, 0644, show_state, set_state);
+
+static struct device_attribute *attributes[] = {
+	&dev_attr_name,
+	&dev_attr_state,
+};
+
+static int regulator_userspace_consumer_probe(struct platform_device *pdev)
+{
+	struct regulator_userspace_consumer_data *pdata;
+	struct userspace_consumer_data *drvdata;
+	int ret, i;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -EINVAL;
+
+	drvdata = kzalloc(sizeof(struct userspace_consumer_data), GFP_KERNEL);
+	if (drvdata == NULL)
+		return -ENOMEM;
+
+	drvdata->name = pdata->name;
+	drvdata->num_supplies = pdata->num_supplies;
+	drvdata->supplies = pdata->supplies;
+
+	mutex_init(&drvdata->lock);
+
+	ret = regulator_bulk_get(&pdev->dev, drvdata->num_supplies,
+				 drvdata->supplies);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to get supplies: %d\n", ret);
+		goto err_alloc_supplies;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(attributes); i++) {
+		ret = device_create_file(&pdev->dev, attributes[i]);
+		if (ret != 0)
+			goto err_create_attrs;
+	}
+
+	if (pdata->init_on)
+		ret = regulator_bulk_enable(drvdata->num_supplies,
+					    drvdata->supplies);
+
+	drvdata->enabled = pdata->init_on;
+
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to set initial state: %d\n", ret);
+		goto err_create_attrs;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+
+	return 0;
+
+err_create_attrs:
+	for (i = 0; i < ARRAY_SIZE(attributes); i++)
+		device_remove_file(&pdev->dev, attributes[i]);
+
+	regulator_bulk_free(drvdata->num_supplies, drvdata->supplies);
+
+err_alloc_supplies:
+	kfree(drvdata);
+	return ret;
+}
+
+static int regulator_userspace_consumer_remove(struct platform_device *pdev)
+{
+	struct userspace_consumer_data *data = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(attributes); i++)
+		device_remove_file(&pdev->dev, attributes[i]);
+
+	if (data->enabled)
+		regulator_bulk_disable(data->num_supplies, data->supplies);
+
+	regulator_bulk_free(data->num_supplies, data->supplies);
+	kfree(data);
+
+	return 0;
+}
+
+static struct platform_driver regulator_userspace_consumer_driver = {
+	.probe		= regulator_userspace_consumer_probe,
+	.remove		= regulator_userspace_consumer_remove,
+	.driver		= {
+		.name		= "reg-userspace-consumer",
+	},
+};
+
+
+static int __init regulator_userspace_consumer_init(void)
+{
+	return platform_driver_register(&regulator_userspace_consumer_driver);
+}
+module_init(regulator_userspace_consumer_init);
+
+static void __exit regulator_userspace_consumer_exit(void)
+{
+	platform_driver_unregister(&regulator_userspace_consumer_driver);
+}
+module_exit(regulator_userspace_consumer_exit);
+
+MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
+MODULE_DESCRIPTION("Userspace consumer for voltage and current regulators");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/userspace-consumer.h b/include/linux/regulator/userspace-consumer.h
new file mode 100644
index 0000000..b4554ce
--- /dev/null
+++ b/include/linux/regulator/userspace-consumer.h
@@ -0,0 +1,25 @@
+#ifndef __REGULATOR_PLATFORM_CONSUMER_H_
+#define __REGULATOR_PLATFORM_CONSUMER_H_
+
+struct regulator_consumer_supply;
+
+/**
+ * struct regulator_userspace_consumer_data - line consumer
+ * initialisation data.
+ *
+ * @name: Name for the consumer line
+ * @num_supplies: Number of supplies feeding the line
+ * @supplies: Supplies configuration.
+ * @init_on: Set if the regulators supplying the line should be
+ *           enabled during initialisation
+ */
+struct regulator_userspace_consumer_data {
+	const char *name;
+
+	int num_supplies;
+	struct regulator_bulk_data *supplies;
+
+	bool init_on;
+};
+
+#endif /* __REGULATOR_PLATFORM_CONSUMER_H_ */
-- 
1.5.6.4

