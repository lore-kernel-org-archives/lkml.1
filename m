Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYKJD1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYKJD1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYKJD0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:26:54 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:46618 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753035AbYKJD0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:26:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=nUGNsWj5uVu7Eh4c8oEGRGSDeuoj5rVQcM1/S3j8KtUjH8OVezisPxq5v3J6Iipr7iAwUQ0BFOCIBVDfOSYkqCcQ+NyqlZ83mwld+yCbiXJeIlFhLMKrGZDQuXKqHy3sD3fCsQ/8+kE2j2c0wJ/ycTHPeRLH+yQXx3jJdCcjKp0=  ;
X-YMail-OSG: Qlv2AUcVM1ltedHxmPdHLAXDNBNsk2yPaRm4m1FcchDNMqm0LMvwJhkC6WMMltQksxP.JYpx.AoIRhvGL1MDQ9IXR5SI5ws.074EAXhSdyqJ84U2vo.L_nuSNf5AC1RiC0Au9HdB1EHFQelmMfwEOvYHEgNUEC_9FPdxmAlRFj3tYqmiEe4Ogp9RsDuR
X-Yahoo-Newman-Property: ymail-3
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc4 2/2] regulator: sysfs attribute reduction
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Sun, 9 Nov 2008 19:26:48 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811091926.48889.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Clean up the sysfs interface to regulators by only exposing
the attributes that can be properly displayed.  For example:
when displaying a value requires a particular method, only
create that attribute when that method exists.  (Instead of
consing up a garbage/"undefined" value.)

This cleaned-up interface is much more comprehensible.  Most
regulators only support a subset of the possible methods, so
more than half the attributes were often meaningless.

This adds object code, about a dozen bytes more than was removed
by the preceding patch, but saves a bunch of per-regulator data
associated with the now-removed attributes.  So there's a net
reduction in memory footprint.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c |  196 +++++++++++++++++++++++++++++++++------------
 1 file changed, 148 insertions(+), 48 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -232,6 +232,7 @@ static ssize_t regulator_uV_show(struct 
 
 	return ret;
 }
+static DEVICE_ATTR(microvolts, 0444, regulator_uV_show, NULL);
 
 static ssize_t regulator_uA_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -240,6 +241,7 @@ static ssize_t regulator_uA_show(struct 
 
 	return sprintf(buf, "%d\n", _regulator_get_current_limit(rdev));
 }
+static DEVICE_ATTR(microamps, 0444, regulator_uA_show, NULL);
 
 static ssize_t regulator_name_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
@@ -281,6 +283,7 @@ static ssize_t regulator_opmode_show(str
 
 	return regulator_print_opmode(buf, _regulator_get_mode(rdev));
 }
+static DEVICE_ATTR(opmode, 0444, regulator_opmode_show, NULL);
 
 static ssize_t regulator_print_state(char *buf, int state)
 {
@@ -299,6 +302,7 @@ static ssize_t regulator_state_show(stru
 
 	return regulator_print_state(buf, _regulator_is_enabled(rdev));
 }
+static DEVICE_ATTR(state, 0444, regulator_state_show, NULL);
 
 static ssize_t regulator_min_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -310,6 +314,7 @@ static ssize_t regulator_min_uA_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->min_uA);
 }
+static DEVICE_ATTR(min_microamps, 0444, regulator_min_uA_show, NULL);
 
 static ssize_t regulator_max_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -321,6 +326,7 @@ static ssize_t regulator_max_uA_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->max_uA);
 }
+static DEVICE_ATTR(max_microamps, 0444, regulator_max_uA_show, NULL);
 
 static ssize_t regulator_min_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -332,6 +338,7 @@ static ssize_t regulator_min_uV_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->min_uV);
 }
+static DEVICE_ATTR(min_microvolts, 0444, regulator_min_uV_show, NULL);
 
 static ssize_t regulator_max_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -343,6 +350,7 @@ static ssize_t regulator_max_uV_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->max_uV);
 }
+static DEVICE_ATTR(max_microvolts, 0444, regulator_max_uV_show, NULL);
 
 static ssize_t regulator_total_uA_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -357,6 +365,7 @@ static ssize_t regulator_total_uA_show(s
 	mutex_unlock(&rdev->mutex);
 	return sprintf(buf, "%d\n", uA);
 }
+static DEVICE_ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL);
 
 static ssize_t regulator_num_users_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -384,131 +393,106 @@ static ssize_t regulator_suspend_mem_uV_
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
 	return sprintf(buf, "%d\n", rdev->constraints->state_mem.uV);
 }
+static DEVICE_ATTR(suspend_mem_microvolts, 0444,
+		regulator_suspend_mem_uV_show, NULL);
 
 static ssize_t regulator_suspend_disk_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
 	return sprintf(buf, "%d\n", rdev->constraints->state_disk.uV);
 }
+static DEVICE_ATTR(suspend_disk_microvolts, 0444,
+		regulator_suspend_disk_uV_show, NULL);
 
 static ssize_t regulator_suspend_standby_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
 	return sprintf(buf, "%d\n", rdev->constraints->state_standby.uV);
 }
+static DEVICE_ATTR(suspend_standby_microvolts, 0444,
+		regulator_suspend_standby_uV_show, NULL);
 
 static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
 	return regulator_print_opmode(buf,
 		rdev->constraints->state_mem.mode);
 }
+static DEVICE_ATTR(suspend_mem_mode, 0444,
+		regulator_suspend_mem_mode_show, NULL);
 
 static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
 	return regulator_print_opmode(buf,
 		rdev->constraints->state_disk.mode);
 }
+static DEVICE_ATTR(suspend_disk_mode, 0444,
+		regulator_suspend_disk_mode_show, NULL);
 
 static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
 	return regulator_print_opmode(buf,
 		rdev->constraints->state_standby.mode);
 }
+static DEVICE_ATTR(suspend_standby_mode, 0444,
+		regulator_suspend_standby_mode_show, NULL);
 
 static ssize_t regulator_suspend_mem_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
-
 	return regulator_print_state(buf,
 			rdev->constraints->state_mem.enabled);
 }
+static DEVICE_ATTR(suspend_mem_state, 0444,
+		regulator_suspend_mem_state_show, NULL);
 
 static ssize_t regulator_suspend_disk_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
-
 	return regulator_print_state(buf,
 			rdev->constraints->state_disk.enabled);
 }
+static DEVICE_ATTR(suspend_disk_state, 0444,
+		regulator_suspend_disk_state_show, NULL);
 
 static ssize_t regulator_suspend_standby_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
-	if (!rdev->constraints)
-		return sprintf(buf, "not defined\n");
-
 	return regulator_print_state(buf,
 			rdev->constraints->state_standby.enabled);
 }
+static DEVICE_ATTR(suspend_standby_state, 0444,
+		regulator_suspend_standby_state_show, NULL);
+
 
+/*
+ * These are the only attributes are present for all regulators.
+ * Other attributes are a function of regulator functionality.
+ */
 static struct device_attribute regulator_dev_attrs[] = {
 	__ATTR(name, 0444, regulator_name_show, NULL),
-	__ATTR(microvolts, 0444, regulator_uV_show, NULL),
-	__ATTR(microamps, 0444, regulator_uA_show, NULL),
-	__ATTR(opmode, 0444, regulator_opmode_show, NULL),
-	__ATTR(state, 0444, regulator_state_show, NULL),
-	__ATTR(min_microvolts, 0444, regulator_min_uV_show, NULL),
-	__ATTR(min_microamps, 0444, regulator_min_uA_show, NULL),
-	__ATTR(max_microvolts, 0444, regulator_max_uV_show, NULL),
-	__ATTR(max_microamps, 0444, regulator_max_uA_show, NULL),
-	__ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL),
 	__ATTR(num_users, 0444, regulator_num_users_show, NULL),
 	__ATTR(type, 0444, regulator_type_show, NULL),
-	__ATTR(suspend_mem_microvolts, 0444,
-		regulator_suspend_mem_uV_show, NULL),
-	__ATTR(suspend_disk_microvolts, 0444,
-		regulator_suspend_disk_uV_show, NULL),
-	__ATTR(suspend_standby_microvolts, 0444,
-		regulator_suspend_standby_uV_show, NULL),
-	__ATTR(suspend_mem_mode, 0444,
-		regulator_suspend_mem_mode_show, NULL),
-	__ATTR(suspend_disk_mode, 0444,
-		regulator_suspend_disk_mode_show, NULL),
-	__ATTR(suspend_standby_mode, 0444,
-		regulator_suspend_standby_mode_show, NULL),
-	__ATTR(suspend_mem_state, 0444,
-		regulator_suspend_mem_state_show, NULL),
-	__ATTR(suspend_disk_state, 0444,
-		regulator_suspend_disk_state_show, NULL),
-	__ATTR(suspend_standby_state, 0444,
-		regulator_suspend_standby_state_show, NULL),
 	__ATTR_NULL,
 };
 
@@ -1707,6 +1691,117 @@ int regulator_notifier_call_chain(struct
 }
 EXPORT_SYMBOL_GPL(regulator_notifier_call_chain);
 
+/*
+ * To avoid cluttering sysfs (and memory) with useless state, only
+ * create attributes that can be meaningfully displayed.
+ */
+static int add_regulator_attributes(struct regulator_dev *rdev)
+{
+	struct device		*dev = &rdev->dev;
+	struct regulator_ops	*ops = rdev->desc->ops;
+	int			status = 0;
+
+	/* some attributes need specific methods to be displayed */
+	if (ops->get_voltage) {
+		status = device_create_file(dev, &dev_attr_microvolts);
+		if (status < 0)
+			return status;
+	}
+	if (ops->get_current_limit) {
+		status = device_create_file(dev, &dev_attr_microamps);
+		if (status < 0)
+			return status;
+	}
+	if (ops->get_mode) {
+		status = device_create_file(dev, &dev_attr_opmode);
+		if (status < 0)
+			return status;
+	}
+	if (ops->is_enabled) {
+		status = device_create_file(dev, &dev_attr_state);
+		if (status < 0)
+			return status;
+	}
+
+	/* some attributes are type-specific */
+	if (rdev->desc->type == REGULATOR_CURRENT) {
+		status = device_create_file(dev, &dev_attr_requested_microamps);
+		if (status < 0)
+			return status;
+	}
+
+	/* all the other attributes exist to support constraints;
+	 * don't show them if there are no constraints, or if the
+	 * relevant supporting methods are missing.
+	 */
+	if (!rdev->constraints)
+		return status;
+
+	/* constraints need specific supporting methods */
+	if (ops->set_voltage) {
+		status = device_create_file(dev, &dev_attr_min_microvolts);
+		if (status < 0)
+			return status;
+		status = device_create_file(dev, &dev_attr_max_microvolts);
+		if (status < 0)
+			return status;
+	}
+	if (ops->set_current_limit) {
+		status = device_create_file(dev, &dev_attr_min_microamps);
+		if (status < 0)
+			return status;
+		status = device_create_file(dev, &dev_attr_max_microamps);
+		if (status < 0)
+			return status;
+	}
+
+	/* suspend mode constraints need multiple supporting methods */
+	if (!(ops->set_suspend_enable && ops->set_suspend_disable))
+		return status;
+
+	status = device_create_file(dev, &dev_attr_suspend_standby_state);
+	if (status < 0)
+		return status;
+	status = device_create_file(dev, &dev_attr_suspend_mem_state);
+	if (status < 0)
+		return status;
+	status = device_create_file(dev, &dev_attr_suspend_disk_state);
+	if (status < 0)
+		return status;
+
+	if (ops->set_suspend_voltage) {
+		status = device_create_file(dev,
+				&dev_attr_suspend_standby_microvolts);
+		if (status < 0)
+			return status;
+		status = device_create_file(dev,
+				&dev_attr_suspend_mem_microvolts);
+		if (status < 0)
+			return status;
+		status = device_create_file(dev,
+				&dev_attr_suspend_disk_microvolts);
+		if (status < 0)
+			return status;
+	}
+
+	if (ops->set_suspend_mode) {
+		status = device_create_file(dev,
+				&dev_attr_suspend_standby_mode);
+		if (status < 0)
+			return status;
+		status = device_create_file(dev,
+				&dev_attr_suspend_mem_mode);
+		if (status < 0)
+			return status;
+		status = device_create_file(dev,
+				&dev_attr_suspend_disk_mode);
+		if (status < 0)
+			return status;
+	}
+
+	return status;
+}
+
 /**
  * regulator_register - register regulator
  * @regulator: regulator source
@@ -1775,6 +1870,11 @@ struct regulator_dev *regulator_register
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
+	/* add attributes supported by this regulator */
+	ret = add_regulator_attributes(rdev);
+	if (ret < 0)
+		goto scrub;
+
 	/* set supply regulator if it exists */
 	if (init_data->supply_regulator_dev) {
 		ret = set_supply(rdev,
