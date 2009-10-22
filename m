Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZJVPbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZJVPbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbZJVPbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:31:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41215 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756524AbZJVPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/6] regulator: Factor out regulator name pretty printing
Date: Thu, 22 Oct 2009 16:31:32 +0100
Message-Id: <1256225495-15379-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the regulator API functions have code to allow the machine
constraints to override the device supplied name for the regulator
in the constraints in order to help tie logging to supplies on the
board and disambiguate when there is more than one regulator chip
in the system. Factor this code out into a new rdev_get_name()
function and use it throughout the regulator API so that we always
use the same name.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   83 +++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 45 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d3be67e..7d0c0d7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -66,6 +66,16 @@ static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
 static void _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data);
 
+static const char *rdev_get_name(struct regulator_dev *rdev)
+{
+	if (rdev->constraints && rdev->constraints->name)
+		return rdev->constraints->name;
+	else if (rdev->desc->name)
+		return rdev->desc->name;
+	else
+		return "";
+}
+
 /* gets the regulator for a given consumer device */
 static struct regulator *get_device_regulator(struct device *dev)
 {
@@ -96,12 +106,12 @@ static int regulator_check_voltage(struct regulator_dev *rdev,
 
 	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev->desc->name);
+		       rdev_get_name(rdev));
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev->desc->name);
+		       __func__, rdev_get_name(rdev));
 		return -EPERM;
 	}
 
@@ -124,12 +134,12 @@ static int regulator_check_current_limit(struct regulator_dev *rdev,
 
 	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev->desc->name);
+		       rdev_get_name(rdev));
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev->desc->name);
+		       __func__, rdev_get_name(rdev));
 		return -EPERM;
 	}
 
@@ -159,17 +169,17 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 
 	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev->desc->name);
+		       rdev_get_name(rdev));
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev->desc->name);
+		       __func__, rdev_get_name(rdev));
 		return -EPERM;
 	}
 	if (!(rdev->constraints->valid_modes_mask & mode)) {
 		printk(KERN_ERR "%s: invalid mode %x for %s\n",
-		       __func__, mode, rdev->desc->name);
+		       __func__, mode, rdev_get_name(rdev));
 		return -EINVAL;
 	}
 	return 0;
@@ -180,12 +190,12 @@ static int regulator_check_drms(struct regulator_dev *rdev)
 {
 	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rdev->desc->name);
+		       rdev_get_name(rdev));
 		return -ENODEV;
 	}
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rdev->desc->name);
+		       __func__, rdev_get_name(rdev));
 		return -EPERM;
 	}
 	return 0;
@@ -230,16 +240,8 @@ static ssize_t regulator_name_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
-	const char *name;
 
-	if (rdev->constraints && rdev->constraints->name)
-		name = rdev->constraints->name;
-	else if (rdev->desc->name)
-		name = rdev->desc->name;
-	else
-		name = "";
-
-	return sprintf(buf, "%s\n", name);
+	return sprintf(buf, "%s\n", rdev_get_name(rdev));
 }
 
 static ssize_t regulator_print_opmode(char *buf, int mode)
@@ -687,13 +689,14 @@ static void print_constraints(struct regulator_dev *rdev)
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
 		count += sprintf(buf + count, "standby");
 
-	printk(KERN_INFO "regulator: %s: %s\n", rdev->desc->name, buf);
+	printk(KERN_INFO "regulator: %s: %s\n", rdev_get_name(rdev), buf);
 }
 
 static int machine_constraints_voltage(struct regulator_dev *rdev,
-	const char *name, struct regulation_constraints *constraints)
+	struct regulation_constraints *constraints)
 {
 	struct regulator_ops *ops = rdev->desc->ops;
+	const char *name = rdev_get_name(rdev);
 	int ret;
 
 	/* do we need to apply the constraint voltage */
@@ -800,16 +803,11 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	const char *name;
 	struct regulator_ops *ops = rdev->desc->ops;
 
-	if (constraints->name)
-		name = constraints->name;
-	else if (rdev->desc->name)
-		name = rdev->desc->name;
-	else
-		name = "regulator";
-
 	rdev->constraints = constraints;
 
-	ret = machine_constraints_voltage(rdev, name, constraints);
+	name = rdev_get_name(rdev);
+
+	ret = machine_constraints_voltage(rdev, constraints);
 	if (ret != 0)
 		goto out;
 
@@ -932,7 +930,7 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
 				dev_name(&node->regulator->dev),
 				node->regulator->desc->name,
 				supply,
-				dev_name(&rdev->dev), rdev->desc->name);
+				dev_name(&rdev->dev), rdev_get_name(rdev));
 		return -EBUSY;
 	}
 
@@ -1241,7 +1239,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 		ret = _regulator_enable(rdev->supply);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: failed to enable %s: %d\n",
-			       __func__, rdev->desc->name, ret);
+			       __func__, rdev_get_name(rdev), ret);
 			return ret;
 		}
 	}
@@ -1267,7 +1265,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			}
 		} else if (ret < 0) {
 			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
-			       __func__, rdev->desc->name, ret);
+			       __func__, rdev_get_name(rdev), ret);
 			return ret;
 		}
 		/* Fallthrough on positive return values - already enabled */
@@ -1308,7 +1306,7 @@ static int _regulator_disable(struct regulator_dev *rdev)
 
 	if (WARN(rdev->use_count <= 0,
 			"unbalanced disables for %s\n",
-			rdev->desc->name))
+			rdev_get_name(rdev)))
 		return -EIO;
 
 	/* are we the last user and permitted to disable ? */
@@ -1321,7 +1319,7 @@ static int _regulator_disable(struct regulator_dev *rdev)
 			ret = rdev->desc->ops->disable(rdev);
 			if (ret < 0) {
 				printk(KERN_ERR "%s: failed to disable %s\n",
-				       __func__, rdev->desc->name);
+				       __func__, rdev_get_name(rdev));
 				return ret;
 			}
 		}
@@ -1378,7 +1376,7 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
 		ret = rdev->desc->ops->disable(rdev);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: failed to force disable %s\n",
-			       __func__, rdev->desc->name);
+			       __func__, rdev_get_name(rdev));
 			return ret;
 		}
 		/* notify other consumers that power has been forced off */
@@ -1795,7 +1793,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	output_uV = rdev->desc->ops->get_voltage(rdev);
 	if (output_uV <= 0) {
 		printk(KERN_ERR "%s: invalid output voltage found for %s\n",
-			__func__, rdev->desc->name);
+			__func__, rdev_get_name(rdev));
 		goto out;
 	}
 
@@ -1806,7 +1804,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 		input_uV = rdev->constraints->input_uV;
 	if (input_uV <= 0) {
 		printk(KERN_ERR "%s: invalid input voltage found for %s\n",
-			__func__, rdev->desc->name);
+			__func__, rdev_get_name(rdev));
 		goto out;
 	}
 
@@ -1820,7 +1818,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	ret = regulator_check_mode(rdev, mode);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: failed to get optimum mode for %s @"
-			" %d uA %d -> %d uV\n", __func__, rdev->desc->name,
+			" %d uA %d -> %d uV\n", __func__, rdev_get_name(rdev),
 			total_uA_load, input_uV, output_uV);
 		goto out;
 	}
@@ -1828,7 +1826,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	ret = rdev->desc->ops->set_mode(rdev, mode);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: failed to set optimum mode %x for %s\n",
-			__func__, mode, rdev->desc->name);
+			__func__, mode, rdev_get_name(rdev));
 		goto out;
 	}
 	ret = mode;
@@ -2346,7 +2344,7 @@ int regulator_suspend_prepare(suspend_state_t state)
 
 		if (ret < 0) {
 			printk(KERN_ERR "%s: failed to prepare %s\n",
-				__func__, rdev->desc->name);
+				__func__, rdev_get_name(rdev));
 			goto out;
 		}
 	}
@@ -2459,12 +2457,7 @@ static int __init regulator_init_complete(void)
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		if (c && c->name)
-			name = c->name;
-		else if (rdev->desc->name)
-			name = rdev->desc->name;
-		else
-			name = "regulator";
+		name = rdev_get_name(rdev);
 
 		if (!ops->disable || (c && c->always_on))
 			continue;
-- 
1.6.5

