Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYKLBkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYKLBkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYKLBj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:39:59 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:31349 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751689AbYKLBj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:39:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=td+FYi/nrqi6phYrzOKmDmEGe3+SaDlOEwZZlmVQxXPHVx0OgTGEBvVYUrXxTJpKn8TAM+s6RVA6CIu2xyAaljjHJjdowIGo+n+lO8b3oI5kiKKx75J3m7mVet1PZI0W/iKwTJkwG4PLBE7MDhxTOBFuXWlzf5BPwt8XGgJAwPI=  ;
X-YMail-OSG: JyoII00VM1lJbaCSH7uqrFAI2dcQ2MXysR6hXwkL0M2gcBIah9NwiynCTxhDCXaEeeVGLPxlTqJ_r8vHf1GCkdA5fXXINS14k6KEtjfKySDOvbL7G.iL2WFoIFAQ6MssQh5i1nkttdLBAl96SPAvmQdHJgJf795eBrIt0LHCAVufOlzoJYIxQ6nFjQcYhqO1y2iER0flg42LaPmEa7640EX.qXaAbsDdTHJjq5407Q--
X-Yahoo-Newman-Property: ymail-3
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc4 1/3] regulator: code shrink (v2)
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Tue, 11 Nov 2008 17:38:53 -0800
MIME-Version: 1.0
Message-Id: <200811111738.53276.david-b@pacbell.net>
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
Difference from V1: applies without the REGULATOR_MODE_OFF patch.

 drivers/regulator/core.c |  111 +++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 67 deletions(-)

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
@@ -276,12 +272,16 @@ static ssize_t regulator_opmode_show(str
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
@@ -290,6 +290,14 @@ static ssize_t regulator_state_show(stru
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
@@ -399,22 +407,6 @@ static ssize_t regulator_suspend_standby
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
-	}
-	return sprintf(buf, "unknown\n");
-}
-
 static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -422,8 +414,8 @@ static ssize_t regulator_suspend_mem_mod
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
-	return suspend_opmode_show(rdev,
-		rdev->constraints->state_mem.mode, buf);
+	return regulator_print_opmode(buf,
+		rdev->constraints->state_mem.mode);
 }
 
 static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
@@ -433,8 +425,8 @@ static ssize_t regulator_suspend_disk_mo
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
-	return suspend_opmode_show(rdev,
-		rdev->constraints->state_disk.mode, buf);
+	return regulator_print_opmode(buf,
+		rdev->constraints->state_disk.mode);
 }
 
 static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
@@ -444,8 +436,8 @@ static ssize_t regulator_suspend_standby
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
-	return suspend_opmode_show(rdev,
-		rdev->constraints->state_standby.mode, buf);
+	return regulator_print_opmode(buf,
+		rdev->constraints->state_standby.mode);
 }
 
 static ssize_t regulator_suspend_mem_state_show(struct device *dev,
@@ -456,10 +448,8 @@ static ssize_t regulator_suspend_mem_sta
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
@@ -470,10 +460,8 @@ static ssize_t regulator_suspend_disk_st
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
@@ -484,10 +472,8 @@ static ssize_t regulator_suspend_standby
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
@@ -1761,20 +1747,14 @@ struct regulator_dev *regulator_register
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
@@ -1782,11 +1762,8 @@ struct regulator_dev *regulator_register
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
 
@@ -1794,12 +1771,8 @@ struct regulator_dev *regulator_register
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
@@ -1811,10 +1784,7 @@ struct regulator_dev *regulator_register
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
 
@@ -1822,6 +1792,13 @@ struct regulator_dev *regulator_register
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
 
