Return-Path: <linux-kernel-owner+w=401wt.eu-S1762490AbYGJTGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490AbYGJTGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbYGJTGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:06:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:57073 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770AbYGJTGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AxCpUSKl4KawYKuiYMbQ/cC4cRk9HCZtlFhAzwjAJcKsg0/UnlLIZANN0BnqajxzjV
         bk0SfZ/w2/y7UjLx3YTwTimM/5ab8k5f9hnqNJbEUUqV4DyswokJ8s9B5n4pZ2MZQYKk
         1OrJ4CcXGwWlrXLvRDVXFle6c2Nq7rpTaDqsQ=
Subject: [PATCH 2/2] regulator: virtual consumer current limit support
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 21:04:46 +0200
Message-Id: <1215716686.17490.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This expands the virtual consumer driver to handle current limit control
via the min_microamps and max_microamps sysfs files.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/regulator/virtual.c |   99 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 7018f1c..5ddb464 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -22,10 +22,12 @@ struct virtual_consumer_data {
 	int enabled;
 	int min_uV;
 	int max_uV;
+	int min_uA;
+	int max_uA;
 	unsigned int mode;
 };
 
-static void update_constraints(struct virtual_consumer_data *data)
+static void update_voltage_constraints(struct virtual_consumer_data *data)
 {
 	int ret;
 
@@ -59,6 +61,41 @@ static void update_constraints(struct virtual_consumer_data *data)
 	}
 }
 
+static void update_current_limit_constraints(struct virtual_consumer_data
+						*data)
+{
+	int ret;
+
+	if (data->max_uA
+	    && data->min_uA <= data->max_uA) {
+		ret = regulator_set_current_limit(data->regulator,
+					data->min_uA, data->max_uA);
+		if (ret != 0) {
+			pr_err("regulator_set_current_limit() failed: %d\n",
+			       ret);
+			return;
+		}
+	}
+
+	if (data->max_uA && !data->enabled) {
+		ret = regulator_enable(data->regulator);
+		if (ret == 0)
+			data->enabled = 1;
+		else
+			printk(KERN_ERR "regulator_enable() failed: %d\n",
+				ret);
+	}
+
+	if (!(data->min_uA && data->max_uA) && data->enabled) {
+		ret = regulator_disable(data->regulator);
+		if (ret == 0)
+			data->enabled = 0;
+		else
+			printk(KERN_ERR "regulator_disable() failed: %d\n",
+				ret);
+	}
+}
+
 static ssize_t show_min_uV(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -78,7 +115,7 @@ static ssize_t set_min_uV(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->lock);
 
 	data->min_uV = val;
-	update_constraints(data);
+	update_voltage_constraints(data);
 
 	mutex_unlock(&data->lock);
 
@@ -104,7 +141,59 @@ static ssize_t set_max_uV(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->lock);
 
 	data->max_uV = val;
-	update_constraints(data);
+	update_voltage_constraints(data);
+
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t show_min_uA(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", data->min_uA);
+}
+
+static ssize_t set_min_uA(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	long val;
+
+	if (strict_strtol(buf, 10, &val) != 0)
+		return count;
+
+	mutex_lock(&data->lock);
+
+	data->min_uA = val;
+	update_current_limit_constraints(data);
+
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t show_max_uA(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", data->max_uA);
+}
+
+static ssize_t set_max_uA(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	long val;
+
+	if (strict_strtol(buf, 10, &val) != 0)
+		return count;
+
+	mutex_lock(&data->lock);
+
+	data->max_uA = val;
+	update_current_limit_constraints(data);
 
 	mutex_unlock(&data->lock);
 
@@ -163,11 +252,15 @@ static ssize_t set_mode(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(min_microvolts, 0666, show_min_uV, set_min_uV);
 static DEVICE_ATTR(max_microvolts, 0666, show_max_uV, set_max_uV);
+static DEVICE_ATTR(min_microamps, 0666, show_min_uA, set_min_uA);
+static DEVICE_ATTR(max_microamps, 0666, show_max_uA, set_max_uA);
 static DEVICE_ATTR(mode, 0666, show_mode, set_mode);
 
 struct device_attribute *attributes[] = {
 	&dev_attr_min_microvolts,
 	&dev_attr_max_microvolts,
+	&dev_attr_min_microamps,
+	&dev_attr_max_microamps,
 	&dev_attr_mode,
 };
 
-- 
1.5.6.2


