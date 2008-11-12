Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYKLBkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYKLBkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYKLBkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:40:03 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:31358 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751876AbYKLBkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:40:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=k9B5bZ3b/9wvAitfVVkneSLxcnCKhnjUHc99HLQg7C66nwVj1ista47p0+ANanVGErNZQLLQ0OW1ipqxJBf85hRet0gmfweqwAa8XQ43UsqVpGaFxJaxp+kXk10nqXWEdAmf0Wh0oockCU6V80ZieQFGUXewe0PsnarswoSftfI=  ;
X-YMail-OSG: 7ciqlCEVM1lFz1k4m3MLxMCGguZ0F7K36MNIvrR9nG7i5Ay4o3q0UckrzNO8hreuBbskaerTIxew7z9GpA10QT1LJwfqbb.njvV_2XRszBafm7UoBl3vZ6XF3vST3KKIfGNU0e1N5mbbp8bK0x3tt28q
X-Yahoo-Newman-Property: ymail-3
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc4 2/3] regulator: sysfs attribute reduction (v2)
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Tue, 11 Nov 2008 17:39:02 -0800
MIME-Version: 1.0
Message-Id: <200811111739.02745.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Clean up the sysfs interface to regulators by only exposing the
attributes that can be properly displayed.  For example: when a
particular regulator method is needed to display the value, only
create that attribute when that method exists.

This cleaned-up interface is much more comprehensible.  Most
regulators only support a subset of the possible methods, so
often more than half the attributes would be meaningless.  Many
"not defined" values are no longer necessary.  (But handling
of out-of-range values still looks a bit iffy.)

Documentation is updated to reflect that few of the attributes
are *always* present, and to briefly explain why a regulator may
not have a given attribute.

This adds object code, about a dozen bytes more than was removed
by the preceding patch, but saves a bunch of per-regulator data
associated with the now-removed attributes.  So there's a net
reduction in memory footprint.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Difference from V1: update the sysfs ABI/testing docs to match.

 Documentation/ABI/testing/sysfs-class-regulator |  136 ++++++---------
 drivers/regulator/core.c                        |  196 ++++++++++++++++------
 2 files changed, 208 insertions(+), 124 deletions(-)

--- a/Documentation/ABI/testing/sysfs-class-regulator
+++ b/Documentation/ABI/testing/sysfs-class-regulator
@@ -3,8 +3,9 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
-		state. This holds the regulator output state.
+		Some regulator directories will contain a field called
+		state. This reports the regulator enable status, for
+		regulators which can report that value.
 
 		This will be one of the following strings:
 
@@ -18,7 +19,8 @@ Description:
 		'disabled' means the regulator output is OFF and is not
 		supplying power to the system..
 
-		'unknown' means software cannot determine the state.
+		'unknown' means software cannot determine the state, or
+		the reported state is invalid.
 
 		NOTE: this field can be used in conjunction with microvolts
 		and microamps to determine regulator output levels.
@@ -53,9 +55,10 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		microvolts. This holds the regulator output voltage setting
-		measured in microvolts (i.e. E-6 Volts).
+		measured in microvolts (i.e. E-6 Volts), for regulators
+		which can report that voltage.
 
 		NOTE: This value should not be used to determine the regulator
 		output voltage level as this value is the same regardless of
@@ -67,9 +70,10 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		microamps. This holds the regulator output current limit
-		setting measured in microamps (i.e. E-6 Amps).
+		setting measured in microamps (i.e. E-6 Amps), for regulators
+		which can report that current.
 
 		NOTE: This value should not be used to determine the regulator
 		output current level as this value is the same regardless of
@@ -81,8 +85,9 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
-		opmode. This holds the regulator operating mode setting.
+		Some regulator directories will contain a field called
+		opmode. This holds the current regulator operating mode,
+		for regulators which can report it.
 
 		The opmode value can be one of the following strings:
 
@@ -92,7 +97,7 @@ Description:
 		'standby'
 		'unknown'
 
-		The modes are described in include/linux/regulator/regulator.h
+		The modes are described in include/linux/regulator/consumer.h
 
 		NOTE: This value should not be used to determine the regulator
 		output operating mode as this value is the same regardless of
@@ -104,9 +109,10 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		min_microvolts. This holds the minimum safe working regulator
-		output voltage setting for this domain measured in microvolts.
+		output voltage setting for this domain measured in microvolts,
+		for regulators which support voltage constraints.
 
 		NOTE: this will return the string 'constraint not defined' if
 		the power domain has no min microvolts constraint defined by
@@ -118,9 +124,10 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		max_microvolts. This holds the maximum safe working regulator
-		output voltage setting for this domain measured in microvolts.
+		output voltage setting for this domain measured in microvolts,
+		for regulators which support voltage constraints.
 
 		NOTE: this will return the string 'constraint not defined' if
 		the power domain has no max microvolts constraint defined by
@@ -132,10 +139,10 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		min_microamps. This holds the minimum safe working regulator
 		output current limit setting for this domain measured in
-		microamps.
+		microamps, for regulators which support current constraints.
 
 		NOTE: this will return the string 'constraint not defined' if
 		the power domain has no min microamps constraint defined by
@@ -147,10 +154,10 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		max_microamps. This holds the maximum safe working regulator
 		output current limit setting for this domain measured in
-		microamps.
+		microamps, for regulators which support current constraints.
 
 		NOTE: this will return the string 'constraint not defined' if
 		the power domain has no max microamps constraint defined by
@@ -185,7 +192,7 @@ Date:		April 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		requested_microamps. This holds the total requested load
 		current in microamps for this regulator from all its consumer
 		devices.
@@ -204,125 +211,102 @@ Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_mem_microvolts. This holds the regulator output
 		voltage setting for this domain measured in microvolts when
-		the system is suspended to memory.
-
-		NOTE: this will return the string 'not defined' if
-		the power domain has no suspend to memory voltage defined by
-		platform code.
+		the system is suspended to memory, for voltage regulators
+		implementing suspend voltage configuration constraints.
 
 What:		/sys/class/regulator/.../suspend_disk_microvolts
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_disk_microvolts. This holds the regulator output
 		voltage setting for this domain measured in microvolts when
-		the system is suspended to disk.
-
-		NOTE: this will return the string 'not defined' if
-		the power domain has no suspend to disk voltage defined by
-		platform code.
+		the system is suspended to disk, for voltage regulators
+		implementing suspend voltage configuration constraints.
 
 What:		/sys/class/regulator/.../suspend_standby_microvolts
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_standby_microvolts. This holds the regulator output
 		voltage setting for this domain measured in microvolts when
-		the system is suspended to standby.
-
-		NOTE: this will return the string 'not defined' if
-		the power domain has no suspend to standby voltage defined by
-		platform code.
+		the system is suspended to standby, for voltage regulators
+		implementing suspend voltage configuration constraints.
 
 What:		/sys/class/regulator/.../suspend_mem_mode
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_mem_mode. This holds the regulator operating mode
 		setting for this domain when the system is suspended to
-		memory.
-
-		NOTE: this will return the string 'not defined' if
-		the power domain has no suspend to memory mode defined by
-		platform code.
+		memory, for regulators implementing suspend mode
+		configuration constraints.
 
 What:		/sys/class/regulator/.../suspend_disk_mode
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_disk_mode. This holds the regulator operating mode
-		setting for this domain when the system is suspended to disk.
-
-		NOTE: this will return the string 'not defined' if
-		the power domain has no suspend to disk mode defined by
-		platform code.
+		setting for this domain when the system is suspended to disk,
+		for regulators implementing suspend mode configuration
+		constraints.
 
 What:		/sys/class/regulator/.../suspend_standby_mode
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_standby_mode. This holds the regulator operating mode
 		setting for this domain when the system is suspended to
-		standby.
-
-		NOTE: this will return the string 'not defined' if
-		the power domain has no suspend to standby mode defined by
-		platform code.
+		standby, for regulators implementing suspend mode
+		configuration constraints.
 
 What:		/sys/class/regulator/.../suspend_mem_state
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_mem_state. This holds the regulator operating state
-		when suspended to memory.
-
-		This will be one of the following strings:
+		when suspended to memory, for regulators implementing suspend
+		configuration constraints.
 
-		'enabled'
-		'disabled'
-		'not defined'
+		This will be one of the same strings reported by
+		the "state" attribute.
 
 What:		/sys/class/regulator/.../suspend_disk_state
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_disk_state. This holds the regulator operating state
-		when suspended to disk.
-
-		This will be one of the following strings:
+		when suspended to disk, for regulators implementing
+		suspend configuration constraints.
 
-		'enabled'
-		'disabled'
-		'not defined'
+		This will be one of the same strings reported by
+		the "state" attribute.
 
 What:		/sys/class/regulator/.../suspend_standby_state
 Date:		May 2008
 KernelVersion:	2.6.26
 Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
 Description:
-		Each regulator directory will contain a field called
+		Some regulator directories will contain a field called
 		suspend_standby_state. This holds the regulator operating
-		state when suspended to standby.
-
-		This will be one of the following strings:
+		state when suspended to standby, for regulators implementing
+		suspend configuration constraints.
 
-		'enabled'
-		'disabled'
-		'not defined'
+		This will be one of the same strings reported by
+		the "state" attribute.
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
@@ -279,6 +281,7 @@ static ssize_t regulator_opmode_show(str
 
 	return regulator_print_opmode(buf, _regulator_get_mode(rdev));
 }
+static DEVICE_ATTR(opmode, 0444, regulator_opmode_show, NULL);
 
 static ssize_t regulator_print_state(char *buf, int state)
 {
@@ -297,6 +300,7 @@ static ssize_t regulator_state_show(stru
 
 	return regulator_print_state(buf, _regulator_is_enabled(rdev));
 }
+static DEVICE_ATTR(state, 0444, regulator_state_show, NULL);
 
 static ssize_t regulator_min_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -308,6 +312,7 @@ static ssize_t regulator_min_uA_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->min_uA);
 }
+static DEVICE_ATTR(min_microamps, 0444, regulator_min_uA_show, NULL);
 
 static ssize_t regulator_max_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -319,6 +324,7 @@ static ssize_t regulator_max_uA_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->max_uA);
 }
+static DEVICE_ATTR(max_microamps, 0444, regulator_max_uA_show, NULL);
 
 static ssize_t regulator_min_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -330,6 +336,7 @@ static ssize_t regulator_min_uV_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->min_uV);
 }
+static DEVICE_ATTR(min_microvolts, 0444, regulator_min_uV_show, NULL);
 
 static ssize_t regulator_max_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -341,6 +348,7 @@ static ssize_t regulator_max_uV_show(str
 
 	return sprintf(buf, "%d\n", rdev->constraints->max_uV);
 }
+static DEVICE_ATTR(max_microvolts, 0444, regulator_max_uV_show, NULL);
 
 static ssize_t regulator_total_uA_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -355,6 +363,7 @@ static ssize_t regulator_total_uA_show(s
 	mutex_unlock(&rdev->mutex);
 	return sprintf(buf, "%d\n", uA);
 }
+static DEVICE_ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL);
 
 static ssize_t regulator_num_users_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -382,131 +391,106 @@ static ssize_t regulator_suspend_mem_uV_
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
 
@@ -1699,6 +1683,117 @@ int regulator_notifier_call_chain(struct
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
@@ -1767,6 +1862,11 @@ struct regulator_dev *regulator_register
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
+	/* add attributes supported by this regulator */
+	ret = add_regulator_attributes(rdev);
+	if (ret < 0)
+		goto scrub;
+
 	/* set supply regulator if it exists */
 	if (init_data->supply_regulator_dev) {
 		ret = set_supply(rdev,
