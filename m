Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYCHHgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYCHHgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 02:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYCHHgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 02:36:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41656 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYCHHg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 02:36:29 -0500
Date: Fri, 7 Mar 2008 23:41:16 -0800
From: Greg KH <greg@kroah.com>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
Message-ID: <20080308074116.GA20652@kroah.com>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main> <20080307161012.GC28439@kroah.com> <1204928391.13653.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204928391.13653.27.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 10:19:51PM +0000, Liam Girdwood wrote:
> On Fri, 2008-03-07 at 08:10 -0800, Greg KH wrote:
> > On Thu, Mar 06, 2008 at 06:11:54PM +0000, Liam Girdwood wrote:
> 
> > > +/**
> > > + * struct regulator_cdev
> > > + *
> > > + * Voltage / Current regulator class device. One for each regulator.
> > > + */
> > > +struct regulator_cdev {
> > > +	struct regulator_desc *desc;
> > > +	int use_count;
> > > +
> > > +	struct list_head list;
> > > +	struct list_head consumer_list;
> > > +	struct blocking_notifier_head notifier;
> > > +	struct mutex mutex; /* consumer lock */
> > > +	struct module *owner;
> > > +	struct class_device cdev;
> > 
> > Can you change this to use a "struct device" instead?  We are trying to
> > get rid of class_device, and there are only 3 users of it in the kernel
> > today (memorystick, infiniband, and scsi), and I have patches pending to
> > fix all of these.  For 2.6.26 I would like to be rid of it finally.
> > 
> > If you want, I would be glad to fix this up for you, it should be a
> > pretty simple replacement.
> > 
> 
> Yes please. Much appreciated :)

Ok, it's below, on top of your patch series.  If you want me to merge it
in, I can do that as well.  It's a bit big, as I renamed "cdev" to "dev"
in your structure names and variable names as it isn't a class device
anymore.

> > > +	struct regulation_constraints *constraints;
> > > +	struct regulator_cdev *parent;	/* for tree */
> > 
> > And if when you convert, you can get rid of this pointer, it would not
> > be needed.
> 
> Fwiw, the regulator-parent relationship is established by the platform
> code after the regulator driver has registered all the regulator
> devices. I assume we can just device_move() to re-parent. 

Ick, no, just pass the parent into the regulator_register() function.
Otherwise you will get some wierd uevents spit out (run udevmonitor to
see what I mean.)  You should set up the parent linkage before you
register the device with the driver core.

> It may also be nice to have a link like /sys/power/regulator
> -> /sys/devices/.../regulator 

why?  You should be able to get there from the /sys/class/regulator/
links now, right?

> > 
> > > +	void *reg_data;		/* regulator_cdev data */
> > 
> > Nor would this one.  Actually I don't think you need this one today
> > anyway...
> > 
> 
> Agreed, this is just driver_data for the regulator driver.

I didn't change that in this patch, I'll let you do that :)

If you have any questions about this patch, or need anything else,
please let me know.

thanks,

greg k-h

---------------

Subject: regulator: convert class_device to device

We also rename the functions and variables as "cdev" no longer makes any
sense.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/regulator/reg-core.c            |  575 ++++++++++++++++----------------
 include/linux/regulator/regulator-drv.h |   32 -
 2 files changed, 307 insertions(+), 300 deletions(-)

--- a/drivers/regulator/reg-core.c
+++ b/drivers/regulator/reg-core.c
@@ -27,11 +27,11 @@ static DEFINE_MUTEX(regulator_list_mutex
 static LIST_HEAD(regulator_list);
 
 /**
- * struct regulator_cdev
+ * struct regulator_dev
  *
  * Voltage / Current regulator class device. One for each regulator.
  */
-struct regulator_cdev {
+struct regulator_dev {
 	struct regulator_desc *desc;
 	int use_count;
 
@@ -40,16 +40,16 @@ struct regulator_cdev {
 	struct blocking_notifier_head notifier;
 	struct mutex mutex; /* consumer lock */
 	struct module *owner;
-	struct class_device cdev;
+	struct device dev;
 	struct regulation_constraints *constraints;
-	struct regulator_cdev *parent;	/* for tree */
+	struct regulator_dev *parent;	/* for tree */
 
-	void *reg_data;		/* regulator_cdev data */
+	void *reg_data;		/* regulator_dev data */
 };
 
-static inline struct regulator_cdev *to_rcdev(struct class_device *cd)
+static inline struct regulator_dev *to_rdev(struct device *d)
 {
-	return container_of(cd, struct regulator_cdev, cdev);
+	return container_of(d, struct regulator_dev, dev);
 }
 
 /*
@@ -64,112 +64,112 @@ struct regulator {
 	int uV_required;
 	int enabled; /* client has called enabled */
 	struct device_attribute dev_attr;
-	struct regulator_cdev *rcdev;
+	struct regulator_dev *rdev;
 };
 
-static int _regulator_is_enabled(struct regulator_cdev *rcdev);
-static int _regulator_disable(struct regulator_cdev *rcdev);
-static int _regulator_get_voltage(struct regulator_cdev *rcdev);
-static int _regulator_get_current(struct regulator_cdev *rcdev);
-static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev);
+static int _regulator_is_enabled(struct regulator_dev *rdev);
+static int _regulator_disable(struct regulator_dev *rdev);
+static int _regulator_get_voltage(struct regulator_dev *rdev);
+static int _regulator_get_current(struct regulator_dev *rdev);
+static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
 
 /* gets the regulator for a given consumer device */
 static struct regulator *get_device_regulator(struct device *dev)
 {
 	struct regulator *regulator = NULL;
-	struct regulator_cdev *rcdev;
+	struct regulator_dev *rdev;
 
 	mutex_lock(&regulator_list_mutex);
-	list_for_each_entry(rcdev, &regulator_list, list) {
-		mutex_lock(&rcdev->mutex);
-		list_for_each_entry(regulator, &rcdev->consumer_list, list) {
+	list_for_each_entry(rdev, &regulator_list, list) {
+		mutex_lock(&rdev->mutex);
+		list_for_each_entry(regulator, &rdev->consumer_list, list) {
 			if (regulator->dev == dev) {
-				mutex_unlock(&rcdev->mutex);
+				mutex_unlock(&rdev->mutex);
 				return regulator;
 			}
 		}
-		mutex_unlock(&rcdev->mutex);
+		mutex_unlock(&rdev->mutex);
 	}
 	mutex_unlock(&regulator_list_mutex);
 	return NULL;
 }
 
 /* voltage constraint check */
-static int regulator_check_voltage(struct regulator_cdev *rcdev, int uV)
+static int regulator_check_voltage(struct regulator_dev *rdev, int uV)
 {
-	if (!rcdev->constraints) {
+	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rcdev->desc->name);
+		       rdev->desc->name);
 		return -ENODEV;
 	}
-	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
+	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rcdev->desc->name);
+		       __func__, rdev->desc->name);
 		return -EPERM;
 	}
-	if (uV > rcdev->constraints->max_uV ||
-		uV < rcdev->constraints->min_uV) {
+	if (uV > rdev->constraints->max_uV ||
+		uV < rdev->constraints->min_uV) {
 		printk(KERN_ERR "%s: invalid voltage %duV for %s\n",
-		       __func__, uV, rcdev->desc->name);
+		       __func__, uV, rdev->desc->name);
 		return -EINVAL;
 	}
 	return 0;
 }
 
 /* current constraint check */
-static int regulator_check_current(struct regulator_cdev *rcdev, int uA)
+static int regulator_check_current(struct regulator_dev *rdev, int uA)
 {
-	if (!rcdev->constraints) {
+	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rcdev->desc->name);
+		       rdev->desc->name);
 		return -ENODEV;
 	}
-	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
+	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rcdev->desc->name);
+		       __func__, rdev->desc->name);
 		return -EPERM;
 	}
-	if (uA > rcdev->constraints->max_uA ||
-		uA < rcdev->constraints->min_uA) {
+	if (uA > rdev->constraints->max_uA ||
+		uA < rdev->constraints->min_uA) {
 		printk(KERN_ERR "%s: invalid current %duA for %s\n",
-		       __func__, uA, rcdev->desc->name);
+		       __func__, uA, rdev->desc->name);
 		return -EINVAL;
 	}
 	return 0;
 }
 
 /* operating mode constraint check */
-static int regulator_check_mode(struct regulator_cdev *rcdev, int mode)
+static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 {
-	if (!rcdev->constraints) {
+	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rcdev->desc->name);
+		       rdev->desc->name);
 		return -ENODEV;
 	}
-	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE)) {
+	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rcdev->desc->name);
+		       __func__, rdev->desc->name);
 		return -EPERM;
 	}
-	if (!(rcdev->constraints->valid_modes_mask & mode)) {
+	if (!(rdev->constraints->valid_modes_mask & mode)) {
 		printk(KERN_ERR "%s: invalid mode %x for %s\n",
-		       __func__, mode, rcdev->desc->name);
+		       __func__, mode, rdev->desc->name);
 		return -EINVAL;
 	}
 	return 0;
 }
 
 /* dynamic regulator mode switching constraint check */
-static int regulator_check_drms(struct regulator_cdev *rcdev)
+static int regulator_check_drms(struct regulator_dev *rdev)
 {
-	if (!rcdev->constraints) {
+	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
-		       rcdev->desc->name);
+		       rdev->desc->name);
 		return -ENODEV;
 	}
-	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS)) {
+	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS)) {
 		printk(KERN_ERR "%s: operation not allowed for %s\n",
-		       __func__, rcdev->desc->name);
+		       __func__, rdev->desc->name);
 		return -EPERM;
 	}
 	return 0;
@@ -187,24 +187,27 @@ static ssize_t device_requested_uA_show(
 	return sprintf(buf, "%d\n", regulator->uA_load);
 }
 
-static ssize_t regulator_uV_show(struct class_device *cdev, char *buf)
+static ssize_t regulator_uV_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 
-	return sprintf(buf, "%d\n", _regulator_get_voltage(rcdev));
+	return sprintf(buf, "%d\n", _regulator_get_voltage(rdev));
 }
 
-static ssize_t regulator_uA_show(struct class_device *cdev, char *buf)
+static ssize_t regulator_uA_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 
-	return sprintf(buf, "%d\n", _regulator_get_current(rcdev));
+	return sprintf(buf, "%d\n", _regulator_get_current(rdev));
 }
 
-static ssize_t regulator_opmode_show(struct class_device *cdev, char *buf)
+static ssize_t regulator_opmode_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
-	int mode = _regulator_get_mode(rcdev);
+	struct regulator_dev *rdev = to_rdev(dev);
+	int mode = _regulator_get_mode(rdev);
 
 	switch (mode) {
 	case REGULATOR_MODE_FAST:
@@ -219,10 +222,11 @@ static ssize_t regulator_opmode_show(str
 	return sprintf(buf, "unknown\n");
 }
 
-static ssize_t regulator_state_show(struct class_device *cdev, char *buf)
+static ssize_t regulator_state_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
-	int state = _regulator_is_enabled(rcdev);
+	struct regulator_dev *rdev = to_rdev(dev);
+	int state = _regulator_is_enabled(rdev);
 
 	if (state > 0)
 		return sprintf(buf, "enabled\n");
@@ -232,74 +236,77 @@ static ssize_t regulator_state_show(stru
 		return sprintf(buf, "unknown\n");
 }
 
-static ssize_t regulator_min_uA_show(struct class_device *cdev,
-					    char *buf)
+static ssize_t regulator_min_uA_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 
-	if (!rcdev->constraints)
+	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
 
-	return sprintf(buf, "%d\n", rcdev->constraints->min_uA);
+	return sprintf(buf, "%d\n", rdev->constraints->min_uA);
 }
 
-static ssize_t regulator_max_uA_show(struct class_device *cdev,
-					    char *buf)
+static ssize_t regulator_max_uA_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 
-	if (!rcdev->constraints)
+	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
 
-	return sprintf(buf, "%d\n", rcdev->constraints->max_uA);
+	return sprintf(buf, "%d\n", rdev->constraints->max_uA);
 }
 
-static ssize_t regulator_min_uV_show(struct class_device *cdev,
-					    char *buf)
+static ssize_t regulator_min_uV_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 
-	if (!rcdev->constraints)
+	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
 
-	return sprintf(buf, "%d\n", rcdev->constraints->min_uV);
+	return sprintf(buf, "%d\n", rdev->constraints->min_uV);
 }
 
-static ssize_t regulator_max_uV_show(struct class_device *cdev,
-					    char *buf)
+static ssize_t regulator_max_uV_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 
-	if (!rcdev->constraints)
+	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
 
-	return sprintf(buf, "%d\n", rcdev->constraints->max_uV);
+	return sprintf(buf, "%d\n", rdev->constraints->max_uV);
 }
 
-static ssize_t regulator_total_uA_show(struct class_device *cdev, char *buf)
+static ssize_t regulator_total_uA_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 	struct regulator *regulator;
 	int uA = 0;
 
-	mutex_lock(&rcdev->mutex);
-	list_for_each_entry(regulator, &rcdev->consumer_list, list)
+	mutex_lock(&rdev->mutex);
+	list_for_each_entry(regulator, &rdev->consumer_list, list)
 	    uA += regulator->uA_load;
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return sprintf(buf, "%d\n", uA);
 }
 
-static ssize_t regulator_num_users_show(struct class_device *cdev, char *buf)
+static ssize_t regulator_num_users_show(struct device *dev,
+					struct device_attribute *att, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
-	return sprintf(buf, "%d\n", rcdev->use_count);
+	struct regulator_dev *rdev = to_rdev(dev);
+	return sprintf(buf, "%d\n", rdev->use_count);
 }
 
-static ssize_t regulator_type_show(struct class_device *cdev, char *buf)
+static ssize_t regulator_type_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator_dev *rdev = to_rdev(dev);
 
-	switch (rcdev->desc->type) {
+	switch (rdev->desc->type) {
 	case REGULATOR_VOLTAGE:
 		return sprintf(buf, "voltage\n");
 	case REGULATOR_CURRENT:
@@ -308,7 +315,7 @@ static ssize_t regulator_type_show(struc
 	return sprintf(buf, "unknown\n");
 }
 
-static struct class_device_attribute regulator_dev_attrs[] = {
+static struct device_attribute regulator_dev_attrs[] = {
 	__ATTR(microvolts, 0444, regulator_uV_show, NULL),
 	__ATTR(microamps, 0444, regulator_uA_show, NULL),
 	__ATTR(opmode, 0444, regulator_opmode_show, NULL),
@@ -323,26 +330,26 @@ static struct class_device_attribute reg
 	__ATTR_NULL,
 };
 
-static void regulator_dev_release(struct class_device *cdev)
+static void regulator_dev_release(struct device *dev)
 {
-	struct regulator_cdev *rcdev = to_rcdev(cdev);
-	kfree(rcdev);
+	struct regulator_dev *rdev = to_rdev(dev);
+	kfree(rdev);
 }
 
 struct class regulator_class = {
 	.name = "regulator",
-	.release = regulator_dev_release,
-	.class_dev_attrs = regulator_dev_attrs,
+	.dev_release = regulator_dev_release,
+	.dev_attrs = regulator_dev_attrs,
 };
 
 /* find the lowest stable voltage that all enabled clients can operate at */
-static inline int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
+static inline int get_lowest_stable_voltage(struct regulator_dev *rdev)
 {
 	struct regulator *regulator;
 	int highest_uV = 0;
 
 	/* lock is held by caller */
-	list_for_each_entry(regulator, &rcdev->consumer_list, list) {
+	list_for_each_entry(regulator, &rdev->consumer_list, list) {
 		if (regulator->enabled && regulator->uV_required > highest_uV)
 			highest_uV = regulator->uV_required;
 	}
@@ -351,61 +358,61 @@ static inline int get_lowest_stable_volt
 
 /* Set the regulator voltage to the lowest possible value that can safely
  * support all the client devices */
-static int regulator_set_stable_voltage(struct regulator_cdev *rcdev)
+static int regulator_set_stable_voltage(struct regulator_dev *rdev)
 {
 	int ret = 0, uV;
 
-	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
-		uV = get_lowest_stable_voltage(rcdev);
-		if (uV && rcdev->desc->ops->set_voltage)
-			ret = rcdev->desc->ops->set_voltage(rcdev, uV);
+	if (rdev->desc->type == REGULATOR_VOLTAGE) {
+		uV = get_lowest_stable_voltage(rdev);
+		if (uV && rdev->desc->ops->set_voltage)
+			ret = rdev->desc->ops->set_voltage(rdev, uV);
 	}
 	return ret;
 }
 
 /* Calculate the new optimum regulator operating mode based on the new total
  * consumer load. All locks held by caller */
-static void drms_uA_update(struct regulator_cdev *rcdev)
+static void drms_uA_update(struct regulator_dev *rdev)
 {
 	struct regulator *sibling;
 	int current_uA = 0, output_uV, input_uV, err;
 	unsigned int mode;
 
-	err = regulator_check_drms(rcdev);
-	if (err < 0 || !rcdev->desc->ops->get_optimum_mode ||
-	    !rcdev->desc->ops->get_voltage || !rcdev->desc->ops->set_mode);
+	err = regulator_check_drms(rdev);
+	if (err < 0 || !rdev->desc->ops->get_optimum_mode ||
+	    !rdev->desc->ops->get_voltage || !rdev->desc->ops->set_mode);
 	return;
 
 	/* get output voltage */
-	output_uV = rcdev->desc->ops->get_voltage(rcdev);
+	output_uV = rdev->desc->ops->get_voltage(rdev);
 
 	/* get input voltage */
-	if (rcdev->parent && rcdev->parent->desc->ops->get_voltage)
-		input_uV = rcdev->parent->desc->ops->get_voltage(rcdev->parent);
+	if (rdev->parent && rdev->parent->desc->ops->get_voltage)
+		input_uV = rdev->parent->desc->ops->get_voltage(rdev->parent);
 	else
-		input_uV = rcdev->constraints->input_uV;
+		input_uV = rdev->constraints->input_uV;
 
 	/* calc total requested load */
-	list_for_each_entry(sibling, &rcdev->consumer_list, list)
+	list_for_each_entry(sibling, &rdev->consumer_list, list)
 	    current_uA += sibling->uA_load;
 
 	/* now get the optimum mode for our new total regulator load */
-	mode = rcdev->desc->ops->get_optimum_mode(rcdev, input_uV,
+	mode = rdev->desc->ops->get_optimum_mode(rdev, input_uV,
 						  output_uV, current_uA);
 
 	/* check the new mode is allowed */
-	err = regulator_check_mode(rcdev, mode);
+	err = regulator_check_mode(rdev, mode);
 	if (err == 0)
-		rcdev->desc->ops->set_mode(rcdev, mode);
+		rdev->desc->ops->set_mode(rdev, mode);
 }
 
-static void print_constraints(struct regulator_cdev *rcdev)
+static void print_constraints(struct regulator_dev *rdev)
 {
-	struct regulation_constraints *constraints = rcdev->constraints;
+	struct regulation_constraints *constraints = rdev->constraints;
 	char buf[80];
 	int count;
 
-	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
+	if (rdev->desc->type == REGULATOR_VOLTAGE) {
 		if (constraints->min_uV == constraints->max_uV)
 			count = sprintf(buf, "%d mV ",
 					uV_to_mV(constraints->min_uV));
@@ -431,12 +438,12 @@ static void print_constraints(struct reg
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
 		count += sprintf(buf + count, "standby");
 
-	printk(KERN_INFO "regulator: %s: %s\n", rcdev->desc->name, buf);
+	printk(KERN_INFO "regulator: %s: %s\n", rdev->desc->name, buf);
 }
 
 #define REG_STR_SIZE	32
 
-static struct regulator *create_regulator(struct regulator_cdev *rcdev,
+static struct regulator *create_regulator(struct regulator_dev *rdev,
 					  struct device *dev)
 {
 	struct regulator *regulator;
@@ -447,14 +454,14 @@ static struct regulator *create_regulato
 	if (regulator == NULL)
 		return NULL;
 
-	mutex_lock(&rcdev->mutex);
-	regulator->rcdev = rcdev;
-	list_add(&regulator->list, &rcdev->consumer_list);
+	mutex_lock(&rdev->mutex);
+	regulator->rdev = rdev;
+	list_add(&regulator->list, &rdev->consumer_list);
 
 	if (dev) {
 		/* create a 'requested_microamps_name' sysfs entry */
 		size = scnprintf(buf, REG_STR_SIZE, "microamps_requested_%s",
-			regulator->rcdev->desc->name);
+			regulator->rdev->desc->name);
 		if (size >= REG_STR_SIZE)
 			goto overflow_err;
 
@@ -468,13 +475,13 @@ static struct regulator *create_regulato
 		regulator->dev_attr.show = device_requested_uA_show;
 		err = device_create_file(dev, &regulator->dev_attr);
 		if (err < 0) {
-			printk(KERN_WARNING "%s: could not add regulator_cdev"
+			printk(KERN_WARNING "%s: could not add regulator_dev"
 				" load sysfs\n", __func__);
 			goto err_out;
 		}
 
 		/* also add a link to the device sysfs entry */
-		err = sysfs_create_link(&rcdev->cdev.kobj, &dev->kobj,
+		err = sysfs_create_link(&rdev->dev.kobj, &dev->kobj,
 			dev->kobj.name);
 		if (err) {
 			printk(KERN_WARNING
@@ -484,14 +491,14 @@ static struct regulator *create_regulato
 			goto err_out;
 		}
 	}
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return regulator;
 err_out:
 	kfree(regulator->dev_attr.attr.name);
 overflow_err:
 	list_del(&regulator->list);
 	kfree(regulator);
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return NULL;
 }
 
@@ -505,16 +512,16 @@ overflow_err:
  */
 struct regulator *regulator_get(struct device *dev, const char *id)
 {
-	struct regulator_cdev *rcdev;
+	struct regulator_dev *rdev;
 	struct regulator *regulator = ERR_PTR(-ENODEV);
 
 	if (id == NULL)
 		return regulator;
 
 	mutex_lock(&regulator_list_mutex);
-	list_for_each_entry(rcdev, &regulator_list, list) {
-		if (strcmp(id, rcdev->desc->name) == 0 &&
-		    try_module_get(rcdev->owner)) {
+	list_for_each_entry(rdev, &regulator_list, list) {
+		if (strcmp(id, rdev->desc->name) == 0 &&
+		    try_module_get(rdev->owner)) {
 			goto found;
 		}
 	}
@@ -524,10 +531,10 @@ struct regulator *regulator_get(struct d
 	return regulator;
 
 found:
-	regulator = create_regulator(rcdev, dev);
+	regulator = create_regulator(rdev, dev);
 	if (regulator == NULL) {
 		regulator = ERR_PTR(-ENOMEM);
-		module_put(rcdev->owner);
+		module_put(rdev->owner);
 	}
 
 	mutex_unlock(&regulator_list_mutex);
@@ -545,65 +552,65 @@ EXPORT_SYMBOL_GPL(regulator_get);
  */
 void regulator_put(struct regulator *regulator)
 {
-	struct regulator_cdev *rcdev;
+	struct regulator_dev *rdev;
 
 	if (regulator == NULL || IS_ERR(regulator))
 		return;
 
 	mutex_lock(&regulator_list_mutex);
-	rcdev = regulator->rcdev;
+	rdev = regulator->rdev;
 
 	/* remove any sysfs entries */
 	if (regulator->dev) {
-		sysfs_remove_link(&rcdev->cdev.kobj, regulator->dev->kobj.name);
+		sysfs_remove_link(&rdev->dev.kobj, regulator->dev->kobj.name);
 		device_remove_file(regulator->dev, &regulator->dev_attr);
 		kfree(regulator->dev_attr.attr.name);
 	}
 	list_del(&regulator->list);
 	kfree(regulator);
 
-	module_put(rcdev->owner);
+	module_put(rdev->owner);
 	mutex_unlock(&regulator_list_mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_put);
 
 /* locks held by regulator_enable() */
-static int _regulator_enable(struct regulator_cdev *rcdev)
+static int _regulator_enable(struct regulator_dev *rdev)
 {
 	int ret = -EINVAL;
 
 	/* do we need to enable the parent regulator first */
-	if (rcdev->parent) {
-		ret = _regulator_enable(rcdev->parent);
+	if (rdev->parent) {
+		ret = _regulator_enable(rdev->parent);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: failed to enable %s\n",
-			       __func__, rcdev->desc->name);
+			       __func__, rdev->desc->name);
 			return ret;
 		}
 	}
 
 	/* check voltage and requested load before enabling */
-	if (rcdev->desc->ops->enable) {
-		ret = regulator_set_stable_voltage(rcdev);
+	if (rdev->desc->ops->enable) {
+		ret = regulator_set_stable_voltage(rdev);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: invalid voltage for %s\n",
-			       __func__, rcdev->desc->name);
+			       __func__, rdev->desc->name);
 			return ret;
 		}
 
-		if (rcdev->constraints &&
-			(rcdev->constraints->valid_ops_mask &
+		if (rdev->constraints &&
+			(rdev->constraints->valid_ops_mask &
 			REGULATOR_CHANGE_DRMS))
-			drms_uA_update(rcdev);
+			drms_uA_update(rdev);
 
-		ret = rcdev->desc->ops->enable(rcdev);
+		ret = rdev->desc->ops->enable(rdev);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: failed to enable %s\n",
-			       __func__, rcdev->desc->name);
+			       __func__, rdev->desc->name);
 			return ret;
 		}
 
-		rcdev->use_count++;
+		rdev->use_count++;
 		return ret;
 	}
 
@@ -624,50 +631,50 @@ int regulator_enable(struct regulator *r
 {
 	int ret;
 
-	mutex_lock(&regulator->rcdev->mutex);
+	mutex_lock(&regulator->rdev->mutex);
 	regulator->enabled = 0;
-	ret = _regulator_enable(regulator->rcdev);
+	ret = _regulator_enable(regulator->rdev);
 	if (ret == 0)
 		regulator->enabled = 1;
-	mutex_unlock(&regulator->rcdev->mutex);
+	mutex_unlock(&regulator->rdev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_enable);
 
 /* locks held by regulator_disable() */
-static int _regulator_disable(struct regulator_cdev *rcdev)
+static int _regulator_disable(struct regulator_dev *rdev)
 {
 	int ret = 0;
 
 	/* are we the last user of this regulator */
-	if (rcdev->use_count == 1) {
+	if (rdev->use_count == 1) {
 
 		/* last user - then disable */
-		if (rcdev->desc->ops->disable) {
-			ret = rcdev->desc->ops->disable(rcdev);
+		if (rdev->desc->ops->disable) {
+			ret = rdev->desc->ops->disable(rdev);
 			if (ret < 0) {
 				printk(KERN_ERR "%s: failed to disable %s\n",
-				       __func__, rcdev->desc->name);
+				       __func__, rdev->desc->name);
 				return ret;
 			}
 		}
 
 		/* decrease our parents ref count and disable if required */
-		if (rcdev->parent)
-			_regulator_disable(rcdev->parent);
+		if (rdev->parent)
+			_regulator_disable(rdev->parent);
 
-		rcdev->use_count = 0;
-	} else if (rcdev->use_count > 1) {
+		rdev->use_count = 0;
+	} else if (rdev->use_count > 1) {
 		/* find the most efficient voltage and mode now that we
 		 * have one less consumer device. */
-		ret = regulator_set_stable_voltage(rcdev);
+		ret = regulator_set_stable_voltage(rdev);
 
-		if (rcdev->constraints &&
-			(rcdev->constraints->valid_ops_mask &
+		if (rdev->constraints &&
+			(rdev->constraints->valid_ops_mask &
 			REGULATOR_CHANGE_DRMS))
-			drms_uA_update(rcdev);
+			drms_uA_update(rdev);
 
-		rcdev->use_count--;
+		rdev->use_count--;
 	}
 	return ret;
 }
@@ -686,30 +693,30 @@ int regulator_disable(struct regulator *
 {
 	int ret;
 
-	mutex_lock(&regulator->rcdev->mutex);
+	mutex_lock(&regulator->rdev->mutex);
 	regulator->enabled = 0;
 	regulator->uA_load = 0;
-	ret = _regulator_disable(regulator->rcdev);
-	mutex_unlock(&regulator->rcdev->mutex);
+	ret = _regulator_disable(regulator->rdev);
+	mutex_unlock(&regulator->rdev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_disable);
 
-static int _regulator_is_enabled(struct regulator_cdev *rcdev)
+static int _regulator_is_enabled(struct regulator_dev *rdev)
 {
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->is_enabled) {
+	if (!rdev->desc->ops->is_enabled) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = rcdev->desc->ops->is_enabled(rcdev);
+	ret = rdev->desc->ops->is_enabled(rdev);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 
@@ -721,7 +728,7 @@ out:
  */
 int regulator_is_enabled(struct regulator *regulator)
 {
-	return _regulator_is_enabled(regulator->rcdev);
+	return _regulator_is_enabled(regulator->rdev);
 }
 EXPORT_SYMBOL_GPL(regulator_is_enabled);
 
@@ -744,46 +751,46 @@ EXPORT_SYMBOL_GPL(regulator_is_enabled);
  */
 int regulator_set_voltage(struct regulator *regulator, int uV)
 {
-	struct regulator_cdev *rcdev = regulator->rcdev;
+	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->set_voltage) {
+	if (!rdev->desc->ops->set_voltage) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* constraints check */
-	ret = regulator_check_voltage(rcdev, uV);
+	ret = regulator_check_voltage(rdev, uV);
 	if (ret < 0)
 		goto out;
 	regulator->uV_required = uV;
 
 	/* only set the new voltage if it's all clients can use it */
-	ret = regulator_set_stable_voltage(rcdev);
+	ret = regulator_set_stable_voltage(rdev);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_voltage);
 
-static int _regulator_get_voltage(struct regulator_cdev *rcdev)
+static int _regulator_get_voltage(struct regulator_dev *rdev)
 {
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->get_voltage) {
+	if (!rdev->desc->ops->get_voltage) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = rcdev->desc->ops->get_voltage(rcdev);
+	ret = rdev->desc->ops->get_voltage(rdev);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 
@@ -798,7 +805,7 @@ out:
  */
 int regulator_get_voltage(struct regulator *regulator)
 {
-	return _regulator_get_voltage(regulator->rcdev);
+	return _regulator_get_voltage(regulator->rdev);
 }
 EXPORT_SYMBOL_GPL(regulator_get_voltage);
 
@@ -819,44 +826,44 @@ EXPORT_SYMBOL_GPL(regulator_get_voltage)
  */
 int regulator_set_current(struct regulator *regulator, int uA)
 {
-	struct regulator_cdev *rcdev = regulator->rcdev;
+	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->set_current) {
+	if (!rdev->desc->ops->set_current) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* constraints check */
-	ret = regulator_check_current(rcdev, uA);
+	ret = regulator_check_current(rdev, uA);
 	if (ret < 0)
 		goto out;
 
-	ret = rcdev->desc->ops->set_current(rcdev, uA);
+	ret = rdev->desc->ops->set_current(rdev, uA);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_current);
 
-static int _regulator_get_current(struct regulator_cdev *rcdev)
+static int _regulator_get_current(struct regulator_dev *rdev)
 {
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->get_current) {
+	if (!rdev->desc->ops->get_current) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = rcdev->desc->ops->get_current(rcdev);
+	ret = rdev->desc->ops->get_current(rdev);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 
@@ -871,7 +878,7 @@ out:
  */
 int regulator_get_current(struct regulator *regulator)
 {
-	return _regulator_get_current(regulator->rcdev);
+	return _regulator_get_current(regulator->rdev);
 }
 EXPORT_SYMBOL_GPL(regulator_get_current);
 
@@ -888,44 +895,44 @@ EXPORT_SYMBOL_GPL(regulator_get_current)
  */
 int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 {
-	struct regulator_cdev *rcdev = regulator->rcdev;
+	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->set_mode) {
+	if (!rdev->desc->ops->set_mode) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* constraints check */
-	ret = regulator_check_mode(rcdev, mode);
+	ret = regulator_check_mode(rdev, mode);
 	if (ret < 0)
 		goto out;
 
-	ret = rcdev->desc->ops->set_mode(rcdev, mode);
+	ret = rdev->desc->ops->set_mode(rdev, mode);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_mode);
 
-static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev)
+static unsigned int _regulator_get_mode(struct regulator_dev *rdev)
 {
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->get_mode) {
+	if (!rdev->desc->ops->get_mode) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = rcdev->desc->ops->get_mode(rcdev);
+	ret = rdev->desc->ops->get_mode(rdev);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 
@@ -937,28 +944,28 @@ out:
  */
 unsigned int regulator_get_mode(struct regulator *regulator)
 {
-	return _regulator_get_mode(regulator->rcdev);
+	return _regulator_get_mode(regulator->rdev);
 }
 EXPORT_SYMBOL_GPL(regulator_get_mode);
 
-static unsigned int _regulator_get_optimum_mode(struct regulator_cdev *rcdev,
+static unsigned int _regulator_get_optimum_mode(struct regulator_dev *rdev,
 						int input_uV, int output_uV,
 						int load_uA)
 {
 	int ret;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->get_optimum_mode) {
+	if (!rdev->desc->ops->get_optimum_mode) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = rcdev->desc->ops->get_optimum_mode(rcdev,
+	ret = rdev->desc->ops->get_optimum_mode(rdev,
 						 input_uV, output_uV, load_uA);
 out:
-	mutex_unlock(&rcdev->mutex);
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 
@@ -976,7 +983,7 @@ unsigned int regulator_get_optimum_mode(
 					int input_uV, int output_uV,
 					int load_uA)
 {
-	return _regulator_get_optimum_mode(regulator->rcdev, input_uV,
+	return _regulator_get_optimum_mode(regulator->rdev, input_uV,
 					   output_uV, load_uA);
 }
 EXPORT_SYMBOL_GPL(regulator_get_optimum_mode);
@@ -991,7 +998,7 @@ EXPORT_SYMBOL_GPL(regulator_get_optimum_
 int regulator_register_client(struct regulator *regulator,
 			      struct notifier_block *nb)
 {
-	return blocking_notifier_chain_register(&regulator->rcdev->notifier,
+	return blocking_notifier_chain_register(&regulator->rdev->notifier,
 						nb);
 }
 EXPORT_SYMBOL_GPL(regulator_register_client);
@@ -1006,7 +1013,7 @@ EXPORT_SYMBOL_GPL(regulator_register_cli
 int regulator_unregister_client(struct regulator *regulator,
 				struct notifier_block *nb)
 {
-	return blocking_notifier_chain_unregister(&regulator->rcdev->notifier,
+	return blocking_notifier_chain_unregister(&regulator->rdev->notifier,
 						  nb);
 }
 EXPORT_SYMBOL_GPL(regulator_unregister_client);
@@ -1020,10 +1027,10 @@ EXPORT_SYMBOL_GPL(regulator_unregister_c
  * Called by regulator drivers to notify clients a regulator event has
  * occurred.
  */
-int regulator_notifier_call_chain(struct regulator_cdev *rcdev,
+int regulator_notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
 {
-	return blocking_notifier_call_chain(&rcdev->notifier, event, data);
+	return blocking_notifier_call_chain(&rdev->notifier, event, data);
 }
 EXPORT_SYMBOL_GPL(regulator_notifier_call_chain);
 
@@ -1035,11 +1042,11 @@ EXPORT_SYMBOL_GPL(regulator_notifier_cal
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
  */
-struct regulator_cdev *regulator_register(struct regulator_desc *regulator_desc,
+struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 					  void *reg_data)
 {
 	static atomic_t regulator_no = ATOMIC_INIT(0);
-	struct regulator_cdev *rcdev;
+	struct regulator_dev *rdev;
 	int ret;
 
 	if (regulator_desc == NULL)
@@ -1052,36 +1059,36 @@ struct regulator_cdev *regulator_registe
 	    !regulator_desc->type == REGULATOR_CURRENT)
 		return ERR_PTR(-EINVAL);
 
-	rcdev = kzalloc(sizeof(struct regulator_cdev), GFP_KERNEL);
-	if (rcdev == NULL)
+	rdev = kzalloc(sizeof(struct regulator_dev), GFP_KERNEL);
+	if (rdev == NULL)
 		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&regulator_list_mutex);
 
-	mutex_init(&rcdev->mutex);
-	rcdev->reg_data = reg_data;
-	rcdev->owner = regulator_desc->owner;
-	rcdev->desc = regulator_desc;
-	INIT_LIST_HEAD(&rcdev->consumer_list);
-	INIT_LIST_HEAD(&rcdev->list);
-	BLOCKING_INIT_NOTIFIER_HEAD(&rcdev->notifier);
-
-	rcdev->cdev.class = &regulator_class;
-	class_device_initialize(&rcdev->cdev);
-	snprintf(rcdev->cdev.class_id, sizeof(rcdev->cdev.class_id),
+	mutex_init(&rdev->mutex);
+	rdev->reg_data = reg_data;
+	rdev->owner = regulator_desc->owner;
+	rdev->desc = regulator_desc;
+	INIT_LIST_HEAD(&rdev->consumer_list);
+	INIT_LIST_HEAD(&rdev->list);
+	BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
+
+	rdev->dev.class = &regulator_class;
+	device_initialize(&rdev->dev);
+	snprintf(rdev->dev.bus_id, sizeof(rdev->dev.bus_id),
 		 "regulator_%ld_%s",
 		 (unsigned long)atomic_inc_return(&regulator_no) - 1,
 		 regulator_desc->name);
 
-	ret = class_device_add(&rcdev->cdev);
+	ret = device_add(&rdev->dev);
 	if (ret == 0)
-		list_add(&rcdev->list, &regulator_list);
+		list_add(&rdev->list, &regulator_list);
 	else {
-		kfree(rcdev);
-		rcdev = ERR_PTR(ret);
+		kfree(rdev);
+		rdev = ERR_PTR(ret);
 	}
 	mutex_unlock(&regulator_list_mutex);
-	return rcdev;
+	return rdev;
 }
 EXPORT_SYMBOL_GPL(regulator_register);
 
@@ -1091,16 +1098,16 @@ EXPORT_SYMBOL_GPL(regulator_register);
  *
  * Called by regulator drivers to unregister a regulator.
  */
-void regulator_unregister(struct regulator_cdev *rcdev)
+void regulator_unregister(struct regulator_dev *rdev)
 {
-	if (rcdev == NULL)
+	if (rdev == NULL)
 		return;
 
 	mutex_lock(&regulator_list_mutex);
-	list_del(&rcdev->list);
-	if (rcdev->parent)
-		sysfs_remove_link(&rcdev->cdev.kobj, "parent");
-	class_device_unregister(&rcdev->cdev);
+	list_del(&rdev->list);
+	if (rdev->parent)
+		sysfs_remove_link(&rdev->dev.kobj, "parent");
+	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_unregister);
@@ -1116,7 +1123,7 @@ EXPORT_SYMBOL_GPL(regulator_unregister);
  */
 int regulator_set_parent(const char *regulator, const char *parent)
 {
-	struct regulator_cdev *rcdev, *parent_rcdev;
+	struct regulator_dev *rdev, *parent_rdev;
 	int err;
 
 	if (regulator == NULL || parent == NULL)
@@ -1124,30 +1131,30 @@ int regulator_set_parent(const char *reg
 
 	mutex_lock(&regulator_list_mutex);
 
-	list_for_each_entry(rcdev, &regulator_list, list) {
-		if (!strcmp(rcdev->desc->name, regulator))
+	list_for_each_entry(rdev, &regulator_list, list) {
+		if (!strcmp(rdev->desc->name, regulator))
 			goto found_regulator;
 	}
 	mutex_unlock(&regulator_list_mutex);
 	return -ENODEV;
 
 found_regulator:
-	list_for_each_entry(parent_rcdev, &regulator_list, list) {
-		if (!strcmp(parent_rcdev->desc->name, parent))
+	list_for_each_entry(parent_rdev, &regulator_list, list) {
+		if (!strcmp(parent_rdev->desc->name, parent))
 			goto found_parent;
 	}
 	mutex_unlock(&regulator_list_mutex);
 	return -ENODEV;
 
 found_parent:
-	rcdev->parent = parent_rcdev;
-	err = sysfs_create_link(&rcdev->cdev.kobj, &parent_rcdev->cdev.kobj,
+	rdev->parent = parent_rdev;
+	err = sysfs_create_link(&rdev->dev.kobj, &parent_rdev->dev.kobj,
 				"parent");
 	if (err) {
 		printk(KERN_ERR
 		       "%s: could not add device link %s err %d\n",
-		       __func__, parent_rcdev->cdev.kobj.name, err);
-		rcdev->parent = NULL;
+		       __func__, parent_rdev->dev.kobj.name, err);
+		rdev->parent = NULL;
 	}
 	mutex_unlock(&regulator_list_mutex);
 	return err;
@@ -1163,14 +1170,14 @@ EXPORT_SYMBOL_GPL(regulator_set_parent);
  */
 const char *regulator_get_parent(const char *regulator)
 {
-	struct regulator_cdev *rcdev;
+	struct regulator_dev *rdev;
 
 	if (regulator == NULL)
 		return NULL;
 
 	mutex_lock(&regulator_list_mutex);
-	list_for_each_entry(rcdev, &regulator_list, list) {
-		if (!strcmp(rcdev->desc->name, regulator))
+	list_for_each_entry(rdev, &regulator_list, list) {
+		if (!strcmp(rdev->desc->name, regulator))
 			goto found;
 	}
 	mutex_unlock(&regulator_list_mutex);
@@ -1178,8 +1185,8 @@ const char *regulator_get_parent(const c
 
 found:
 	mutex_unlock(&regulator_list_mutex);
-	if (rcdev->parent)
-		return rcdev->parent->desc->name;
+	if (rdev->parent)
+		return rdev->parent->desc->name;
 	else
 		return NULL;
 }
@@ -1197,18 +1204,18 @@ EXPORT_SYMBOL_GPL(regulator_get_parent);
 int regulator_set_platform_constraints(const char *regulator_name,
 	struct regulation_constraints *constraints)
 {
-	struct regulator_cdev *rcdev;
+	struct regulator_dev *rdev;
 
 	if (regulator_name == NULL)
 		return -EINVAL;
 
 	mutex_lock(&regulator_list_mutex);
-	list_for_each_entry(rcdev, &regulator_list, list) {
-		if (!strcmp(regulator_name, rcdev->desc->name)) {
-			mutex_lock(&rcdev->mutex);
-			rcdev->constraints = constraints;
-			print_constraints(rcdev);
-			mutex_unlock(&rcdev->mutex);
+	list_for_each_entry(rdev, &regulator_list, list) {
+		if (!strcmp(regulator_name, rdev->desc->name)) {
+			mutex_lock(&rdev->mutex);
+			rdev->constraints = constraints;
+			print_constraints(rdev);
+			mutex_unlock(&rdev->mutex);
 			mutex_unlock(&regulator_list_mutex);
 			return 0;
 		}
@@ -1245,27 +1252,27 @@ EXPORT_SYMBOL_GPL(regulator_set_platform
  */
 void regulator_drms_notify_load(struct regulator *regulator, int uA)
 {
-	struct regulator_cdev *rcdev = regulator->rcdev;
+	struct regulator_dev *rdev = regulator->rdev;
 
-	mutex_lock(&rcdev->mutex);
+	mutex_lock(&rdev->mutex);
 	regulator->uA_load = uA;
-	drms_uA_update(rcdev);
-	mutex_unlock(&rcdev->mutex);
+	drms_uA_update(rdev);
+	mutex_unlock(&rdev->mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_drms_notify_load);
 
 /**
- * rcdev_get_drvdata - get rcdev regulator driver data
+ * rdev_get_drvdata - get rdev regulator driver data
  * @regulator: regulator
  *
- * Get rcdev regulator driver private data. This call can be used in the
+ * Get rdev regulator driver private data. This call can be used in the
  * regulator driver context.
  */
-void *rcdev_get_drvdata(struct regulator_cdev *rcdev)
+void *rdev_get_drvdata(struct regulator_dev *rdev)
 {
-	return rcdev->reg_data;
+	return rdev->reg_data;
 }
-EXPORT_SYMBOL_GPL(rcdev_get_drvdata);
+EXPORT_SYMBOL_GPL(rdev_get_drvdata);
 
 /**
  * regulator_get_drvdata - get regulator driver data
@@ -1276,7 +1283,7 @@ EXPORT_SYMBOL_GPL(rcdev_get_drvdata);
  */
 void *regulator_get_drvdata(struct regulator *regulator)
 {
-	return regulator->rcdev->reg_data;
+	return regulator->rdev->reg_data;
 }
 EXPORT_SYMBOL_GPL(regulator_get_drvdata);
 
@@ -1287,7 +1294,7 @@ EXPORT_SYMBOL_GPL(regulator_get_drvdata)
  */
 void regulator_set_drvdata(struct regulator *regulator, void *data)
 {
-	regulator->rcdev->reg_data = data;
+	regulator->rdev->reg_data = data;
 }
 EXPORT_SYMBOL_GPL(regulator_set_drvdata);
 
@@ -1295,11 +1302,11 @@ EXPORT_SYMBOL_GPL(regulator_set_drvdata)
  * regulator_get_id - get regulator ID
  * @regulator: regulator
  */
-int rcdev_get_id(struct regulator_cdev *rcdev)
+int rdev_get_id(struct regulator_dev *rdev)
 {
-	return rcdev->desc->id;
+	return rdev->desc->id;
 }
-EXPORT_SYMBOL_GPL(rcdev_get_id);
+EXPORT_SYMBOL_GPL(rdev_get_id);
 
 static int __init regulator_init(void)
 {
--- a/include/linux/regulator/regulator-drv.h
+++ b/include/linux/regulator/regulator-drv.h
@@ -19,7 +19,7 @@
 #include <linux/regulator/regulator.h>
 
 struct regulator_constraints;
-struct regulator_cdev;
+struct regulator_dev;
 
 /**
  * struct regulator_ops - regulator operations.
@@ -29,24 +29,24 @@ struct regulator_cdev;
 struct regulator_ops {
 
 	/* get/set regulator voltage */
-	int (*set_voltage) (struct regulator_cdev *, int uV);
-	int (*get_voltage) (struct regulator_cdev *);
+	int (*set_voltage) (struct regulator_dev *, int uV);
+	int (*get_voltage) (struct regulator_dev *);
 
 	/* get/set regulator current  */
-	int (*set_current) (struct regulator_cdev *, int uA);
-	int (*get_current) (struct regulator_cdev *);
+	int (*set_current) (struct regulator_dev *, int uA);
+	int (*get_current) (struct regulator_dev *);
 
 	/* enable/disable regulator */
-	int (*enable) (struct regulator_cdev *);
-	int (*disable) (struct regulator_cdev *);
-	int (*is_enabled) (struct regulator_cdev *);
+	int (*enable) (struct regulator_dev *);
+	int (*disable) (struct regulator_dev *);
+	int (*is_enabled) (struct regulator_dev *);
 
 	/* get/set regulator operating mode (defined in regulator.h) */
-	int (*set_mode) (struct regulator_cdev *, unsigned int mode);
-	unsigned int (*get_mode) (struct regulator_cdev *);
+	int (*set_mode) (struct regulator_dev *, unsigned int mode);
+	unsigned int (*get_mode) (struct regulator_dev *);
 
 	/* get most efficient regulator operating mode for load */
-	unsigned int (*get_optimum_mode) (struct regulator_cdev *, int input_uV,
+	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
 					  int output_uV, int load_uA);
 };
 
@@ -72,14 +72,14 @@ struct regulator_desc {
 };
 
 
-struct regulator_cdev *regulator_register(struct regulator_desc *regulator_desc,
+struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 					  void *reg_data);
-void regulator_unregister(struct regulator_cdev *rcdev);
+void regulator_unregister(struct regulator_dev *rdev);
 
-int regulator_notifier_call_chain(struct regulator_cdev *rcdev,
+int regulator_notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data);
 
-void *rcdev_get_drvdata(struct regulator_cdev *rcdev);
-int rcdev_get_id(struct regulator_cdev *rcdev);
+void *rdev_get_drvdata(struct regulator_dev *rdev);
+int rdev_get_id(struct regulator_dev *rdev);
 
 #endif
