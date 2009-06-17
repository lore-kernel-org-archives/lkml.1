Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZFQOpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZFQOpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZFQOpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:45:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42457 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752310AbZFQOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:45:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Make virtual consumer use dev_printk
Date: Wed, 17 Jun 2009 15:45:06 +0100
Message-Id: <1245249907-5240-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/virtual.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index e953c18..5c1d756 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -27,17 +27,18 @@ struct virtual_consumer_data {
 	unsigned int mode;
 };
 
-static void update_voltage_constraints(struct virtual_consumer_data *data)
+static void update_voltage_constraints(struct device *dev,
+				       struct virtual_consumer_data *data)
 {
 	int ret;
 
 	if (data->min_uV && data->max_uV
 	    && data->min_uV <= data->max_uV) {
 		ret = regulator_set_voltage(data->regulator,
-					    data->min_uV, data->max_uV);
+					data->min_uV, data->max_uV);
 		if (ret != 0) {
-			printk(KERN_ERR "regulator_set_voltage() failed: %d\n",
-			       ret);
+			dev_err(dev,
+				"regulator_set_voltage() failed: %d\n", ret);
 			return;
 		}
 	}
@@ -47,7 +48,7 @@ static void update_voltage_constraints(struct virtual_consumer_data *data)
 		if (ret == 0)
 			data->enabled = 1;
 		else
-			printk(KERN_ERR "regulator_enable() failed: %d\n",
+			dev_err(dev, "regulator_enable() failed: %d\n",
 				ret);
 	}
 
@@ -56,13 +57,13 @@ static void update_voltage_constraints(struct virtual_consumer_data *data)
 		if (ret == 0)
 			data->enabled = 0;
 		else
-			printk(KERN_ERR "regulator_disable() failed: %d\n",
+			dev_err(dev, "regulator_disable() failed: %d\n",
 				ret);
 	}
 }
 
-static void update_current_limit_constraints(struct virtual_consumer_data
-						*data)
+static void update_current_limit_constraints(struct device *dev,
+					  struct virtual_consumer_data *data)
 {
 	int ret;
 
@@ -71,8 +72,9 @@ static void update_current_limit_constraints(struct virtual_consumer_data
 		ret = regulator_set_current_limit(data->regulator,
 					data->min_uA, data->max_uA);
 		if (ret != 0) {
-			pr_err("regulator_set_current_limit() failed: %d\n",
-			       ret);
+			dev_err(dev,
+				"regulator_set_current_limit() failed: %d\n",
+				ret);
 			return;
 		}
 	}
@@ -82,7 +84,7 @@ static void update_current_limit_constraints(struct virtual_consumer_data
 		if (ret == 0)
 			data->enabled = 1;
 		else
-			printk(KERN_ERR "regulator_enable() failed: %d\n",
+			dev_err(dev, "regulator_enable() failed: %d\n",
 				ret);
 	}
 
@@ -91,7 +93,7 @@ static void update_current_limit_constraints(struct virtual_consumer_data
 		if (ret == 0)
 			data->enabled = 0;
 		else
-			printk(KERN_ERR "regulator_disable() failed: %d\n",
+			dev_err(dev, "regulator_disable() failed: %d\n",
 				ret);
 	}
 }
@@ -115,7 +117,7 @@ static ssize_t set_min_uV(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->lock);
 
 	data->min_uV = val;
-	update_voltage_constraints(data);
+	update_voltage_constraints(dev, data);
 
 	mutex_unlock(&data->lock);
 
@@ -141,7 +143,7 @@ static ssize_t set_max_uV(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->lock);
 
 	data->max_uV = val;
-	update_voltage_constraints(data);
+	update_voltage_constraints(dev, data);
 
 	mutex_unlock(&data->lock);
 
@@ -167,7 +169,7 @@ static ssize_t set_min_uA(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->lock);
 
 	data->min_uA = val;
-	update_current_limit_constraints(data);
+	update_current_limit_constraints(dev, data);
 
 	mutex_unlock(&data->lock);
 
@@ -193,7 +195,7 @@ static ssize_t set_max_uA(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->lock);
 
 	data->max_uA = val;
-	update_current_limit_constraints(data);
+	update_current_limit_constraints(dev, data);
 
 	mutex_unlock(&data->lock);
 
-- 
1.6.3.1

