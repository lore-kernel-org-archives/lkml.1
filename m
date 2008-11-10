Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYKJD1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYKJD1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYKJD0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:26:52 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:46608 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752681AbYKJD0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:26:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=FyHXoHrIEk6A+fmb9uNHwnD4yvaZTf7MV3ZnkgACuN6mtxPU8Q7gY5JaNUA5lrlK6Aes2s+nrrcKqBSl+/78zAhxjYcjPi/FqFzCMcAWHlb32TWtE0oHAQKtjqh/iJRkQoXAbUjf4JuikRikx5gjJRm6LDXxCMEysBJZvSsLghg=  ;
X-YMail-OSG: CDaCpYgVM1kBE_MKti9ueibZiBkC0AcMbMrYsS4stlmu0veCO1.08iypEGMQ.qSKbDsiiIqGk5M84.6aSa7my.I7R.0NZD3T42WW4bYHH5GBH5LYQavWhXf4Of0Vmh4NOf1YfpHx6.CI3M4_lWmGFI0ONkBac8RQxZNBA_XIbzl8H0hsDMhi33Y3V63jMdvufpKgUeu1n5WQYl7tRNon964C0PZv9S2BkE76UOB7Kw--
X-Yahoo-Newman-Property: ymail-3
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc4 1/2] regulator: code shrink
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Sun, 9 Nov 2008 19:20:06 -0800
MIME-Version: 1.0
Message-Id: <200811091920.06174.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Shrink regulator core by removing duplication in attribute printing
and probe() cleanup paths.  Saves about 340 bytes (object) on ARM.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Goes on top of the previous REGULATOR_MODE_OFF patch, but that
only affects one obvious chunk of code.

 drivers/regulator/core.c |  113 +++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 69 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -257,12 +257,8 @@ static ssize_t regulator_name_show(struc
 	return sprintf(buf, "%s\n", name);
 }
 
-static ssize_t regulator_opmode_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+static ssize_t regulator_print_opmode(char *buf, int mode)
 {
-	struct regulator_dev *rdev = dev_get_drvdata(dev);
-	int mode = _regulator_get_mode(rdev);
-
 	switch (mode) {
 	case REGULATOR_MODE_FAST:
 		return sprintf(buf, "fast\n");
@@ -278,12 +274,16 @@ static ssize_t regulator_opmode_show(str
 	return sprintf(buf, "unknown\n");
 }
 
-static ssize_t regulator_state_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t regulator_opmode_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
-	int state = _regulator_is_enabled(rdev);
 
+	return regulator_print_opmode(buf, _regulator_get_mode(rdev));
+}
+
+static ssize_t regulator_print_state(char *buf, int state)
+{
 	if (state > 0)
 		return sprintf(buf, "enabled\n");
 	else if (state == 0)
@@ -292,6 +292,14 @@ static ssize_t regulator_state_show(stru
 		return sprintf(buf, "unknown\n");
 }
 
+static ssize_t regulator_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
+
+	return regulator_print_state(buf, _regulator_is_enabled(rdev));
+}
+
 static ssize_t regulator_min_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -401,24 +409,6 @@ static ssize_t regulator_suspend_standby
 	return sprintf(buf, "%d\n", rdev->constraints->state_standby.uV);
 }
 
-static ssize_t suspend_opmode_show(struct regulator_dev *rdev,
-	unsigned int mode, char *buf)
-{
-	switch (mode) {
-	case REGULATOR_MODE_FAST:
-		return sprintf(buf, "fast\n");
-	case REGULATOR_MODE_NORMAL:
-		return sprintf(buf, "normal\n");
-	case REGULATOR_MODE_IDLE:
-		return sprintf(buf, "idle\n");
-	case REGULATOR_MODE_STANDBY:
-		return sprintf(buf, "standby\n");
-	case REGULATOR_MODE_OFF:
-		return sprintf(buf, "off\n");
-	}
-	return sprintf(buf, "unknown\n");
-}
-
 static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -426,8 +416,8 @@ static ssize_t regulator_suspend_mem_mod
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
-	return suspend_opmode_show(rdev,
-		rdev->constraints->state_mem.mode, buf);
+	return regulator_print_opmode(buf,
+		rdev->constraints->state_mem.mode);
 }
 
 static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
@@ -437,8 +427,8 @@ static ssize_t regulator_suspend_disk_mo
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
-	return suspend_opmode_show(rdev,
-		rdev->constraints->state_disk.mode, buf);
+	return regulator_print_opmode(buf,
+		rdev->constraints->state_disk.mode);
 }
 
 static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
@@ -448,8 +438,8 @@ static ssize_t regulator_suspend_standby
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
-	return suspend_opmode_show(rdev,
-		rdev->constraints->state_standby.mode, buf);
+	return regulator_print_opmode(buf,
+		rdev->constraints->state_standby.mode);
 }
 
 static ssize_t regulator_suspend_mem_state_show(struct device *dev,
@@ -460,10 +450,8 @@ static ssize_t regulator_suspend_mem_sta
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
 
-	if (rdev->constraints->state_mem.enabled)
-		return sprintf(buf, "enabled\n");
-	else
-		return sprintf(buf, "disabled\n");
+	return regulator_print_state(buf,
+			rdev->constraints->state_mem.enabled);
 }
 
 static ssize_t regulator_suspend_disk_state_show(struct device *dev,
@@ -474,10 +462,8 @@ static ssize_t regulator_suspend_disk_st
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
 
-	if (rdev->constraints->state_disk.enabled)
-		return sprintf(buf, "enabled\n");
-	else
-		return sprintf(buf, "disabled\n");
+	return regulator_print_state(buf,
+			rdev->constraints->state_disk.enabled);
 }
 
 static ssize_t regulator_suspend_standby_state_show(struct device *dev,
@@ -488,10 +474,8 @@ static ssize_t regulator_suspend_standby
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
 
-	if (rdev->constraints->state_standby.enabled)
-		return sprintf(buf, "enabled\n");
-	else
-		return sprintf(buf, "disabled\n");
+	return regulator_print_state(buf,
+			rdev->constraints->state_standby.enabled);
 }
 
 static struct device_attribute regulator_dev_attrs[] = {
@@ -1771,20 +1755,14 @@ struct regulator_dev *regulator_register
 	/* preform any regulator specific init */
 	if (init_data->regulator_init) {
 		ret = init_data->regulator_init(rdev->reg_data);
-		if (ret < 0) {
-			kfree(rdev);
-			rdev = ERR_PTR(ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto clean;
 	}
 
 	/* set regulator constraints */
 	ret = set_machine_constraints(rdev, &init_data->constraints);
-	if (ret < 0) {
-		kfree(rdev);
-		rdev = ERR_PTR(ret);
-		goto out;
-	}
+	if (ret < 0)
+		goto clean;
 
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
@@ -1792,11 +1770,8 @@ struct regulator_dev *regulator_register
 	snprintf(rdev->dev.bus_id, sizeof(rdev->dev.bus_id),
 		 "regulator.%d", atomic_inc_return(&regulator_no) - 1);
 	ret = device_register(&rdev->dev);
-	if (ret != 0) {
-		kfree(rdev);
-		rdev = ERR_PTR(ret);
-		goto out;
-	}
+	if (ret != 0)
+		goto clean;
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
@@ -1804,12 +1779,8 @@ struct regulator_dev *regulator_register
 	if (init_data->supply_regulator_dev) {
 		ret = set_supply(rdev,
 			dev_get_drvdata(init_data->supply_regulator_dev));
-		if (ret < 0) {
-			device_unregister(&rdev->dev);
-			kfree(rdev);
-			rdev = ERR_PTR(ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto scrub;
 	}
 
 	/* add consumers devices */
@@ -1821,10 +1792,7 @@ struct regulator_dev *regulator_register
 			for (--i; i >= 0; i--)
 				unset_consumer_device_supply(rdev,
 					init_data->consumer_supplies[i].dev);
-			device_unregister(&rdev->dev);
-			kfree(rdev);
-			rdev = ERR_PTR(ret);
-			goto out;
+			goto scrub;
 		}
 	}
 
@@ -1832,6 +1800,13 @@ struct regulator_dev *regulator_register
 out:
 	mutex_unlock(&regulator_list_mutex);
 	return rdev;
+
+scrub:
+	device_unregister(&rdev->dev);
+clean:
+	kfree(rdev);
+	rdev = ERR_PTR(ret);
+	goto out;
 }
 EXPORT_SYMBOL_GPL(regulator_register);
 
