Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZDUMAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZDUMAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZDUMAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:00:45 -0400
Received: from cathcart.site5.com ([74.54.107.137]:45559 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZDUMAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:00:44 -0400
Message-ID: <49EDB569.2060701@compulab.co.il>
Date: Tue, 21 Apr 2009 15:00:41 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <49EC8775.8060609@compulab.co.il> <20090420145627.GA5281@rakim.wolfsonmicro.main>
In-Reply-To: <20090420145627.GA5281@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Mark Brown wrote:
> On Mon, Apr 20, 2009 at 05:32:21PM +0300, Mike Rapoport wrote:
> 
>> It is the most simple and straight forward solution. However, I have several
>> questions and I cannot answer them myself:
> 
> Some initial thoughts:
> 
>>   Should the driver handle single or several supplies at once?
> 
> I'd expect that it should be able to cope with that - a lot of hardware
> takes multiple supplies.
> 
>>   If the driver handles several supplies how to define attributes per-supply?
>>   What attributes will be exposed? Would it be simple 'state' that can be
>> enabled or disabled? Or the entire set of micorvolts/microamps etc?
> 
> I'd expect that if you're getting into much more than a simple enable
> for the entire device it'd be getting to the point where it's worth
> considering writing an actual driver for the device.  That said, it's a
> fairly natural extension to support more fine grained stuff if someone
> does actually end up wanting it.

I've managed to create some preliminary "line-consumer" driver. I don't really
like the name, but I couldn't think of something better and "virtual" is
already taken :)
Feedback is appreciated.


diff --git a/drivers/regulator/line-consumer.c b/drivers/regulator/line-consumer.c
new file mode 100644
index 0000000..e7cba4b
--- /dev/null
+++ b/drivers/regulator/line-consumer.c
@@ -0,0 +1,211 @@
+/*
+ * line-consumer.c
+ *
+ * Copyright 2009 CompuLab, Ltd..
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
+#include <linux/regulator/line-consumer.h>
+
+struct line_consumer_data {
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
+	struct line_consumer_data *data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", data->name);
+}
+
+static ssize_t show_state(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct line_consumer_data *data = dev_get_drvdata(dev);
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
+	struct line_consumer_data *data = dev_get_drvdata(dev);
+	bool enabled;
+	int ret;
+
+	/*
+	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
+	 * will be shared with show_state(), above.
+	 */
+	if (sysfs_streq(buf, "enabled\n") == 0)
+		enabled = true;
+	else if (sysfs_streq(buf, "disabled\n") == 0)
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
+static DEVICE_ATTR(state, 0666, show_state, set_state);
+
+static struct device_attribute *attributes[] = {
+	&dev_attr_name,
+	&dev_attr_state,
+};
+
+static int regulator_line_consumer_probe(struct platform_device *pdev)
+{
+	struct regulator_line_consumer_data *pdata;
+	struct line_consumer_data *drvdata;
+	int ret, i;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -EINVAL;
+
+	drvdata = kzalloc(sizeof(struct line_consumer_data), GFP_KERNEL);
+	if (drvdata == NULL)
+		return -ENOMEM;
+
+	drvdata->name = pdata->name;
+	drvdata->num_supplies = pdata->num_supplies;
+
+	drvdata->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
+				    drvdata->num_supplies,
+				    GFP_KERNEL);
+	if (drvdata->supplies == NULL) {
+		ret = -ENOMEM;
+		goto err_alloc_supplies;
+	}
+
+	mutex_init(&drvdata->lock);
+
+	for (i = 0; i < drvdata->num_supplies; i++)
+		drvdata->supplies[i].supply = pdata->supplies[i].supply;
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
+	else
+		ret = regulator_bulk_disable(drvdata->num_supplies,
+					     drvdata->supplies);
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
+static int regulator_line_consumer_remove(struct platform_device *pdev)
+{
+	struct line_consumer_data *drvdata = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(attributes); i++)
+		device_remove_file(&pdev->dev, attributes[i]);
+
+	regulator_bulk_free(drvdata->num_supplies, drvdata->supplies);
+	kfree(drvdata->supplies);
+	kfree(drvdata);
+
+	return 0;
+}
+
+static struct platform_driver regulator_line_consumer_driver = {
+	.probe		= regulator_line_consumer_probe,
+	.remove		= regulator_line_consumer_remove,
+	.driver		= {
+		.name		= "reg-line-consumer",
+	},
+};
+
+
+static int __init regulator_line_consumer_init(void)
+{
+	return platform_driver_register(&regulator_line_consumer_driver);
+}
+module_init(regulator_line_consumer_init);
+
+static void __exit regulator_line_consumer_exit(void)
+{
+	platform_driver_unregister(&regulator_line_consumer_driver);
+}
+module_exit(regulator_line_consumer_exit);
+
+MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
+MODULE_DESCRIPTION("Line consumer for voltage and current regulators");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/line-consumer.h b/include/linux/regulator/line-consumer.h
new file mode 100644
index 0000000..df978dd
--- /dev/null
+++ b/include/linux/regulator/line-consumer.h
@@ -0,0 +1,25 @@
+#ifndef __REGULATOR_PLATFORM_CONSUMER_H_
+#define __REGULATOR_PLATFORM_CONSUMER_H_
+
+struct regulator_consumer_supply;
+
+/**
+ * struct regulator_line_consumer_data - line consumer
+ * initialisation data.
+ *
+ * @name: Name for the consumer line
+ * @num_supplies: Number of supplies feeding the line
+ * @supplies: Supplies configuration.
+ * @init_on: Set if the regulators supplying the line should be
+ *           enabled during initialisation
+ */
+struct regulator_line_consumer_data {
+	const char *name;
+
+	int num_supplies;
+	struct regulator_consumer_supply *supplies;
+
+	bool init_on;
+};
+
+#endif /* __REGULATOR_PLATFORM_CONSUMER_H_ */


-- 
Sincerely yours,
Mike.

