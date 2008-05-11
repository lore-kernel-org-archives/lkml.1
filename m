Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYEKOjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYEKOjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYEKOj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:39:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40242 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752785AbYEKOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:39:25 -0400
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <1210362244.20475.125.camel@odin>
References: <1209742841.12502.40.camel@odin>
	 <20080508063538.GC6105@prithivi.gnumonks.org>
	 <1210279887.20475.79.camel@odin>
	 <20080509043708.GG4961@prithivi.gnumonks.org>
	 <1210362244.20475.125.camel@odin>
Content-Type: text/plain; charset=utf-8
Date: Sun, 11 May 2008 15:39:23 +0100
Message-Id: <1210516763.20475.173.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 20:44 +0100, Liam Girdwood wrote:
> On Fri, 2008-05-09 at 06:37 +0200, Harald Welte wrote:
> > On Thu, May 08, 2008 at 09:51:27PM +0100, Liam Girdwood wrote:
> > > > Do you think it would be worth to export something like this in the
> > > > generic API, too?  It's probably quite hard, since there are devices
> > > > that actually use the PCF506xx STANDBY state during suspend-to-ram, but
> > > > other devices leave the PCF506xx in the ON state and just disable the
> > > > individual regulators using I2C register writes.
> > > 

I've now finished the first draft of the system wide suspend state
changes. This fits in well for WM8350 suspend configuration, could you
give it a quick look over wrt pcf506xx family. 

 Changes :-

 o ﻿regulator_suspend_prepare() added to set all the PMIC regulator
states before the system enters suspend. This would be called by your
platform/machine specific suspend code.
 o added sysfs entries for mem, disk and standby regulator config.
 o added fields for each suspend state in struct ﻿regulation_constraints
to define each regulator suspend state.
 o added operations to struct ﻿regulator_ops to support regulator
suspend state configuration in regulator drivers.

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f698f84..db259e8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -17,11 +17,12 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/suspend.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 
-#define REGULATOR_VERSION "0.4"
+#define REGULATOR_VERSION "0.5"
 
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
@@ -358,6 +359,126 @@ static ssize_t regulator_type_show(struct device *dev,
 	return sprintf(buf, "unknown\n");
 }
 
+static ssize_t regulator_suspend_mem_uV_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return sprintf(buf, "%d\n", rdev->constraints->state_mem.uV);
+}
+
+static ssize_t regulator_suspend_disk_uV_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return sprintf(buf, "%d\n", rdev->constraints->state_disk.uV);
+}
+
+static ssize_t regulator_suspend_standby_uV_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return sprintf(buf, "%d\n", rdev->constraints->state_standby.uV);
+}
+
+static ssize_t suspend_opmode_show(struct regulator_dev *rdev,
+	unsigned int mode, char *buf)
+{
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		return sprintf(buf, "fast\n");
+	case REGULATOR_MODE_NORMAL:
+		return sprintf(buf, "normal\n");
+	case REGULATOR_MODE_IDLE:
+		return sprintf(buf, "idle\n");
+	case REGULATOR_MODE_STANDBY:
+		return sprintf(buf, "standby\n");
+	}
+	return sprintf(buf, "unknown\n");
+}
+
+static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return suspend_opmode_show(rdev,
+		rdev->constraints->state_mem.mode, buf);
+}
+
+static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return suspend_opmode_show(rdev,
+		rdev->constraints->state_disk.mode, buf);
+}
+
+static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return suspend_opmode_show(rdev,
+		rdev->constraints->state_standby.mode, buf);
+}
+
+static ssize_t regulator_suspend_mem_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+
+	if (rdev->constraints->state_mem.enabled)
+		return sprintf(buf, "enabled\n");
+	else
+		return sprintf(buf, "disabled\n");
+}
+
+static ssize_t regulator_suspend_disk_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+
+	if (rdev->constraints->state_disk.enabled)
+		return sprintf(buf, "enabled\n");
+	else
+		return sprintf(buf, "disabled\n");
+}
+
+static ssize_t regulator_suspend_standby_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+
+	if (rdev->constraints->state_standby.enabled)
+		return sprintf(buf, "enabled\n");
+	else
+		return sprintf(buf, "disabled\n");
+}
 static struct device_attribute regulator_dev_attrs[] = {
 	__ATTR(microvolts, 0444, regulator_uV_show, NULL),
 	__ATTR(microamps, 0444, regulator_uA_show, NULL),
@@ -370,6 +491,24 @@ static struct device_attribute regulator_dev_attrs[] = {
 	__ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL),
 	__ATTR(num_users, 0444, regulator_num_users_show, NULL),
 	__ATTR(type, 0444, regulator_type_show, NULL),
+	__ATTR(suspend_mem_microvolts, 0444,
+		regulator_suspend_mem_uV_show, NULL),
+	__ATTR(suspend_disk_microvolts, 0444,
+		regulator_suspend_disk_uV_show, NULL),
+	__ATTR(suspend_standby_microvolts, 0444,
+		regulator_suspend_standby_uV_show, NULL),
+	__ATTR(suspend_mem_mode, 0444,
+		regulator_suspend_mem_mode_show, NULL),
+	__ATTR(suspend_disk_mode, 0444,
+		regulator_suspend_disk_mode_show, NULL),
+	__ATTR(suspend_standby_mode, 0444,
+		regulator_suspend_standby_mode_show, NULL),
+	__ATTR(suspend_mem_state, 0444,
+		regulator_suspend_mem_state_show, NULL),
+	__ATTR(suspend_disk_state, 0444,
+		regulator_suspend_disk_state_show, NULL),
+	__ATTR(suspend_standby_state, 0444,
+		regulator_suspend_standby_state_show, NULL),
 	__ATTR_NULL,
 };
 
@@ -425,6 +564,65 @@ static void drms_uA_update(struct regulator_dev *rdev)
 		rdev->desc->ops->set_mode(rdev, mode);
 }
 
+static int suspend_set_state(struct regulator_dev *rdev,
+	struct regulator_state *rstate)
+{
+	int ret = 0;
+
+	/* enable & disable are mandatory for suspend control */
+	if (!rdev->desc->ops->set_suspend_enable ||
+		!rdev->desc->ops->set_suspend_disable)
+		return -EINVAL;
+
+	if (rstate->enabled)
+		ret = rdev->desc->ops->set_suspend_enable(rdev);
+	else
+		ret = rdev->desc->ops->set_suspend_disable(rdev);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: failed to enabled/disable\n", __func__);
+		return ret;
+	}
+
+	if (rdev->desc->ops->set_suspend_voltage && rstate->uV > 0) {
+		ret = rdev->desc->ops->set_suspend_voltage(rdev, rstate->uV);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to set voltage\n",
+				__func__);
+			return ret;
+		}
+	}
+
+	if (rdev->desc->ops->set_suspend_mode && rstate->mode > 0) {
+		ret = rdev->desc->ops->set_suspend_mode(rdev, rstate->mode);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to set mode\n", __func__);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/* locks held by caller */
+static int suspend_prepare(struct regulator_dev *rdev, suspend_state_t state)
+{
+	if (!rdev->constraints)
+		return -EINVAL;
+
+	switch (state) {
+	case PM_SUSPEND_STANDBY:
+		return suspend_set_state(rdev,
+			&rdev->constraints->state_standby);
+	case PM_SUSPEND_MEM:
+		return suspend_set_state(rdev,
+			&rdev->constraints->state_mem);
+	case PM_SUSPEND_MAX:
+		return suspend_set_state(rdev,
+			&rdev->constraints->state_disk);
+	default:
+		return -EINVAL;
+	}
+}
+
 static void print_constraints(struct regulator_dev *rdev)
 {
 	struct regulation_constraints *constraints = rdev->constraints;
@@ -923,7 +1121,7 @@ int regulator_get_voltage(struct regulator *regulator)
 EXPORT_SYMBOL_GPL(regulator_get_voltage);
 
 /**
- * regulator_set_current_limit - set regulator output current for a current sink
+ * regulator_set_current_limit - set regulator output current limit
  * @regulator: regulator source
  * @min_uA: Minimuum supported current in uA
  * @max_uA: Maximum supported current in uA
@@ -1567,6 +1765,10 @@ found:
 	if (rdev->constraints->boot_on)
 		rdev->use_count = 1;
 
+	/* do we need to setup our suspend state */
+	if (constraints->initial_state)
+		ret = suspend_prepare(rdev, constraints->initial_state);
+
 	print_constraints(rdev);
 	mutex_unlock(&rdev->mutex);
 
@@ -1612,6 +1814,41 @@ int regulator_set_device_supply(const char *regulator, struct device *dev,
 EXPORT_SYMBOL_GPL(regulator_set_device_supply);
 
 /**
+ * regulator_suspend_prepare: prepare regulators for system wide suspend
+ * @state: system suspend state
+ *
+ * Configure each regulator with it's suspend operating parameters for state.
+ * This will usually be called by machine suspend code prior to supending.
+ */
+int regulator_suspend_prepare(suspend_state_t state)
+{
+	struct regulator_dev *rdev;
+	int ret = 0;
+
+	/* ON is handled by regulator active state */
+	if (state == PM_SUSPEND_ON)
+		return -EINVAL;
+
+	mutex_lock(&regulator_list_mutex);
+	list_for_each_entry(rdev, &regulator_list, list) {
+
+		mutex_lock(&rdev->mutex);
+		ret = suspend_prepare(rdev, state);
+		mutex_unlock(&rdev->mutex);
+
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to prepare %s\n",
+				__func__, rdev->desc->name);
+			goto out;
+		}
+	}
+out:
+	mutex_unlock(&regulator_list_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_suspend_prepare);
+
+/**
  * rdev_get_drvdata - get rdev regulator driver data
  * @regulator: regulator
  *
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 1c02362..1d712c7 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -49,6 +49,19 @@ struct regulator_ops {
 	/* get most efficient regulator operating mode for load */
 	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
 					  int output_uV, int load_uA);
+
+	/* the operations below are for configuration of regulator state when
+	 * it's parent PMIC enters a global STANBY/HIBERNATE state */
+
+	/* set regulator suspend voltage */
+	int (*set_suspend_voltage) (struct regulator_dev *, int uV);
+
+	/* enable/disable regulator in suspend state */
+	int (*set_suspend_enable) (struct regulator_dev *);
+	int (*set_suspend_disable) (struct regulator_dev *);
+
+	/* set regulator suspend operating mode (defined in regulator.h) */
+	int (*set_suspend_mode) (struct regulator_dev *, unsigned int mode);
 };
 
 /*
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 69b492c..d3479a8 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -39,6 +39,18 @@ struct regulator;
 #define REGULATOR_CHANGE_STATUS		0x8
 #define REGULATOR_CHANGE_DRMS		0x10
 
+
+/**
+ * struct regulator_state - regulator state during low power syatem states
+ *
+ * This describes a regulators state during a system wide low power state.
+ */
+struct regulator_state {
+	int uV;	/* suspend voltage */
+	unsigned int mode; /* suspend regulator operating mode */
+	int enabled; /* is regulator enabled in this suspend state */
+};
+
 /**
  * struct regulation_constraints - regulator operating constraints.
  *
@@ -65,6 +77,12 @@ struct regulation_constraints {
 	/* regulator input voltage - only if supply is another regulator */
 	int input_uV;
 
+	/* regulator suspend states for global PMIC STANDBY/HIBERNATE */
+	struct regulator_state state_disk;
+	struct regulator_state state_mem;
+	struct regulator_state state_standby;
+	suspend_state_t initial_state; /* suspend state to set at init */
+
 	/* constriant flags */
 	u32 always_on:1;	/* regulator never off when system is on */
 	u32 boot_on:1;		/* bootloader/firmware enabled regulator */
@@ -81,4 +99,6 @@ int regulator_set_machine_constraints(const char *regulator,
 int regulator_set_device_supply(const char *regulator, struct device *dev,
 				const char *supply);
 
+int regulator_suspend_prepare(suspend_state_t state);
+
 #endif
diff --git a/Documentation/ABI/testing/sysfs-class-regulator b/Documentation/ABI/testing/sysfs-class-regulator
index 4655927..79a4a75 100644
--- a/Documentation/ABI/testing/sysfs-class-regulator
+++ b/Documentation/ABI/testing/sysfs-class-regulator
@@ -185,3 +185,131 @@ Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
 Description:
 		Some regulator directories will contain a link called parent.
 		This points to the parent or supply regulator if one exists.
+
+What:		/sys/class/regulator/.../suspend_mem_microvolts
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_mem_microvolts. This holds the regulator output
+		voltage setting for this domain measured in microvolts when
+		the system is suspended to memory.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to memory voltage defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_disk_microvolts
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_disk_microvolts. This holds the regulator output
+		voltage setting for this domain measured in microvolts when
+		the system is suspended to disk.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to disk voltage defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_standby_microvolts
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_standby_microvolts. This holds the regulator output
+		voltage setting for this domain measured in microvolts when
+		the system is suspended to standby.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to standby voltage defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_mem_mode
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_mem_mode. This holds the regulator operating mode
+		setting for this domain when the system is suspended to
+		memory.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to memory mode defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_disk_mode
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_disk_mode. This holds the regulator operating mode
+		setting for this domain when the system is suspended to disk.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to disk mode defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_standby_mode
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_standby_mode. This holds the regulator operating mode
+		setting for this domain when the system is suspended to
+		standby.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to standby mode defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_mem_state
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_mem_state. This holds the regulator operating state
+		when suspended to memory.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'not defined'
+
+What:		/sys/class/regulator/.../suspend_disk_state
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_disk_state. This holds the regulator operating state
+		when suspended to disk.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'not defined'
+
+What:		/sys/class/regulator/.../suspend_standby_state
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_standby_state. This holds the regulator operating
+		state when suspended to standby.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'not defined'


