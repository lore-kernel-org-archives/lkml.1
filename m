Return-Path: <linux-kernel-owner+w=401wt.eu-S934577AbYBWIOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577AbYBWIOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbYBWIIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:54 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933000AbYBWIIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:52 -0500
Date: Sat, 23 Feb 2008 00:05:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/6] regulator: regulator core.
Message-Id: <20080223000538.e1f086e1.akpm@linux-foundation.org>
In-Reply-To: <1203527351.4071.92.camel@localhost.localdomain>
References: <1203527351.4071.92.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 17:09:11 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> This patch provides the regulator framework core. The core also provides a
> sysfs interface for userspace information.
> 
> ...
>
> +
> +/* We need to undef the current macro (from include/asm/current.h) otherwise
> + * our "current" sysfs entry becomes "(get_current())".
> + */
> +#undef current

err, no ;)  Please rename your stuff.

> +static DEFINE_MUTEX(list_mutex);
> +static LIST_HEAD(regulator_cdevs);
> +
> +/**
> + * struct regulator_cdev
> + *
> + * Voltage / Current regulator class device. One for each regulator.
> + */
> +struct regulator_cdev {
> +	struct regulator_desc *desc;
> +	int use_count;
> +
> +	struct list_head list;
> +	struct list_head consumer_list;
> +	struct blocking_notifier_head notifier;
> +	struct mutex mutex;
> +	struct module *owner;
> +	struct class_device cdev;
> +	struct regulation_constraints *constraints;
> +	struct regulator_cdev *parent; /* for tree */
> +
> +	void *reg_data; /* regulator_cdev data */
> +	void *vendor; /* regulator_cdev vendor extensions */
> +};
> +#define to_rcdev(cd) \
> +	container_of(cd, struct regulator_cdev, cdev)

This could be a C function?

> +/*
> + * struct regulator
> + *
> + * One for each consumer device.
> + */
> +struct regulator {
> +	struct device *dev;
> +	struct list_head list;
> +	int uA_load;
> +	int uV_required;
> +	int enabled;
> +	struct device_attribute dev_attr;
> +	struct regulator_cdev *rcdev;
> +};
> +
> +static int _regulator_is_enabled(struct regulator_cdev *rcdev);
> +static int _regulator_disable(struct regulator_cdev *rcdev);
> +static int _regulator_get_voltage(struct regulator_cdev *rcdev);
> +static int _regulator_get_current(struct regulator_cdev *rcdev);
> +static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev);
> +
> +static struct regulator *get_regulator_load(struct device *dev)
> +{
> +	struct regulator *regulator = NULL;
> +	struct regulator_cdev *rcdev;
> +
> +	list_for_each_entry(rcdev, &regulator_cdevs, list) {
> +		list_for_each_entry(regulator, &rcdev->consumer_list, list) {
> +			if (regulator->dev == dev)
> +				return regulator;
> +		}
> +	}
> +	return NULL;
> +}

afacit list_mutex is not held here.

> +static int regulator_check_voltage(struct regulator_cdev *rcdev, int uV)
> +{
> +	if (!rcdev->constraints) {
> +		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> +			rcdev->desc->name);
> +		return -ENODEV;
> +	}
> +	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE) {
> +		printk(KERN_ERR "%s: operation not allowed for %s\n",
> +			__func__, rcdev->desc->name);
> +		return -EPERM;
> +	}
> +	if (uV > rcdev->constraints->max_uV ||
> +		uV < rcdev->constraints->min_uV) {
> +		printk(KERN_ERR "%s: invalid voltage %duV for %s\n",
> +			__func__, uV, rcdev->desc->name);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int regulator_check_current(struct regulator_cdev *rcdev, int uA)
> +{
> +	if (!rcdev->constraints) {
> +		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> +			rcdev->desc->name);
> +		return -ENODEV;
> +	}
> +	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT) {

Spot the bug.

> +		printk(KERN_ERR "%s: operation not allowed for %s\n",
> +			__func__, rcdev->desc->name);
> +		return -EPERM;
> +	}
> +	if (uA > rcdev->constraints->max_uA ||
> +		uA < rcdev->constraints->min_uA) {
> +		printk(KERN_ERR "%s: invalid current %duA for %s\n",
> +			__func__, uA, rcdev->desc->name);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int regulator_check_mode(struct regulator_cdev *rcdev, int mode)
> +{
> +	if (!rcdev->constraints) {
> +		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> +			rcdev->desc->name);
> +		return -ENODEV;
> +	}
> +	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE) {

Here too.

> +		printk(KERN_ERR "%s: operation not allowed for %s\n",
> +			__func__, rcdev->desc->name);
> +		return -EPERM;
> +	}
> +	if (!rcdev->constraints->valid_modes_mask & mode) {

And again.

> +		printk(KERN_ERR "%s: invalid mode %x for %s\n",
> +			__func__, mode, rcdev->desc->name);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int regulator_check_drms(struct regulator_cdev *rcdev)
> +{
> +	if (!rcdev->constraints) {
> +		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> +			rcdev->desc->name);
> +		return -ENODEV;
> +	}
> +	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS) {

And again.

> +		printk(KERN_ERR "%s: operation not allowed for %s\n",
> +			__func__, rcdev->desc->name);
> +		return -EPERM;
> +	}
> +	return 0;
> +}
> +
>
> ...
>
> +static ssize_t regulator_constraint_uA_show(struct class_device *cdev,
> +	char *buf)
> +{
> +	struct regulator_cdev *rcdev = to_rcdev(cdev);
> +
> +	if (!rcdev->constraints)
> +		return sprintf(buf, "constraints not defined\n");
> +
> +	return sprintf (buf, "%d %d\n", rcdev->constraints->min_uA,
> +		rcdev->constraints->max_uA);
> +}

Did we just break the one-value-per-sysfs-file rule?

This is one of the reasons why we like to see the full proposed ABI in the
changelog or in the added documentation.

> +static ssize_t regulator_constraint_uV_show(struct class_device *cdev,
> +	char *buf)
> +{
> +	struct regulator_cdev *rcdev = to_rcdev(cdev);
> +
> +	if (!rcdev->constraints)
> +		return sprintf(buf, "constraints not defined\n");
> +
> +	return sprintf (buf, "%d %d\n", rcdev->constraints->min_uV,
> +		rcdev->constraints->max_uV);
> +}

Ditto.

> +static ssize_t regulator_constraint_modes_show(struct class_device *cdev,
> +	char *buf)
> +{
> +	struct regulator_cdev *rcdev = to_rcdev(cdev);
> +	int count = 0;
> +
> +	if (!rcdev->constraints)
> +		return sprintf(buf, "constraints not defined\n");
> +
> +	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_FAST)
> +		count = sprintf (buf, "fast ");
> +	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_NORMAL)
> +		count += sprintf (buf + count, "normal ");
> +	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_IDLE)
> +		count += sprintf (buf + count, "idle ");
> +	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
> +		count += sprintf (buf + count, "standby");
> +	count += sprintf(buf + count, "\n");
> +	return count;
> +}

etc.

> +static ssize_t regulator_total_dev_load(struct class_device *cdev, char *buf)
> +{
> +	struct regulator_cdev *rcdev = to_rcdev(cdev);
> +	struct regulator *regulator;
> +	int uA = 0;
> +
> +	list_for_each_entry(regulator, &rcdev->consumer_list, list)
> +		uA =+ regulator->uA_load;
> +	return sprintf(buf, "%d\n", uA);
> +}

locking for that list?

> +static void regulator_dev_release(struct class_device *class_dev) {}

No, an empty ->release is a sign that something is wrong.  Please ask Greg
KH for details - I always forget..

> +struct class regulator_class = {
> +	.name			= "regulator",
> +	.release		= regulator_dev_release,
> +	.class_dev_attrs	= regulator_dev_attrs,
> +};
> +
> +/* find the lowest stable voltage that all enabled clients can operate at */
> +static int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
> +{
> +	struct regulator *regulator;
> +	int highest_uV = 0;
> +
> +	list_for_each_entry(regulator, &rcdev->consumer_list, list) {
> +		if (regulator->enabled && regulator->uV_required > highest_uV)
> +			highest_uV = regulator->uV_required;
> +	}
> +	return highest_uV;
> +}

list locking?

> +/* set the regulator voltage to the lowest possible value that can safely
> + * support all the client devices */
> +static int regulator_set_stable_voltage(struct regulator_cdev *rcdev)
> +{
> +	int ret = 0, uV;
> +
> +	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
> +		uV = get_lowest_stable_voltage(rcdev);
> +		if (uV && rcdev->desc->ops->set_voltage)
> +			ret = rcdev->desc->ops->set_voltage(rcdev, uV);
> +	}
> +	return ret;
> +}
> +
> +static void regulator_load_change (struct regulator_cdev *rcdev)

checkpatch has a whale of a time with this diff.

> +{
> +	struct regulator *sibling;
> +	int current_uA = 0, output_uV, input_uV, err;
> +	unsigned int mode;
> +
> +	err = regulator_check_drms(rcdev);
> +	if (err < 0 || !rcdev->desc->ops->get_optimum_mode ||
> +		!rcdev->desc->ops->get_voltage || !rcdev->desc->ops->set_mode);
> +		return;
> +
> +	/* get output voltage */
> +	output_uV = rcdev->desc->ops->get_voltage(rcdev);
> +
> +	/* get input voltage */
> +	if (rcdev->parent && rcdev->parent->desc->ops->get_voltage)
> +		input_uV =
> +			rcdev->parent->desc->ops->get_voltage(rcdev->parent);
> +	else
> +		input_uV = rcdev->constraints->input_uV;
> +
> +	/* calc total requested load */
> +	list_for_each_entry(sibling, &rcdev->consumer_list, list)
> +		current_uA += sibling->uA_load;

locking?

> +	/* now get the optimum mode for our new total regulator load */
> +	mode = rcdev->desc->ops->get_optimum_mode(rcdev, input_uV,
> +		output_uV, current_uA);
> +
> +	/* check the new mode is allowed */
> +	err = regulator_check_mode(rcdev, mode);
> +	if (err == 0)
> +		rcdev->desc->ops->set_mode(rcdev, mode);
> +}
> +
> +static void print_constraints(struct regulator_cdev *rcdev)
> +{
> +	struct regulation_constraints *constraints = rcdev->constraints;
> +	char buf[80];
> +	int count;
> +
> +	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
> +		if (constraints->min_uV == constraints->max_uV)
> +			count = sprintf(buf, "%d mV ",
> +				uV_to_mV(constraints->min_uV));
> +		else
> +			count = sprintf(buf, "%d <--> %d mV ",
> +				uV_to_mV(constraints->min_uV),
> +				uV_to_mV(constraints->max_uV));
> +	} else {
> +		if (constraints->min_uA == constraints->max_uA)
> +			count = sprintf(buf, "%d mA ",
> +				uA_to_mA(constraints->min_uA));
> +		else
> +			count = sprintf(buf, "%d <--> %d mA ",
> +				uA_to_mA(constraints->min_uA),
> +				uA_to_mA(constraints->max_uA));
> +	}
> +	if (constraints->valid_modes_mask & REGULATOR_MODE_FAST)
> +		count += sprintf (buf + count, "fast ");
> +	if (constraints->valid_modes_mask & REGULATOR_MODE_NORMAL)
> +		count += sprintf (buf + count, "normal ");
> +	if (constraints->valid_modes_mask & REGULATOR_MODE_IDLE)
> +		count += sprintf (buf + count, "idle ");
> +	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
> +		count += sprintf (buf + count, "standby");
> +
> +	printk(KERN_INFO "regulator: %s: %s\n", rcdev->desc->name, buf);
> +}

one-value-per-file?

> +static struct regulator *create_regulator(struct regulator_cdev *rcdev,
> +	struct device *dev)
> +{
> +	struct regulator *regulator;
> +	char buf[32];
> +	int err;
> +
> +	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
> +	if (regulator == NULL)
> +		return NULL;
> +
> +	regulator->rcdev = rcdev;
> +	sprintf(buf, "current_requested-%s", regulator->rcdev->desc->name);

How are we avoiding buffer overruns here?  I'd suggest the use of
scnprintf() and checking the return value, fail the whole thing if it got
truncated.

> +	list_add(&regulator->list, &rcdev->consumer_list);

locking?

> +	if (dev == NULL)
> +		goto out;

This is odd-looking.  If dev==NULL we "succeed" but don't fill things in. 
What's happening here?

> +	regulator->dev = dev;
> +	regulator->dev_attr.attr.name = kstrdup(buf, GFP_KERNEL);
> +	if (regulator->dev_attr.attr.name == NULL)
> +		goto err_out;
> +	regulator->dev_attr.attr.owner = THIS_MODULE;
> +	regulator->dev_attr.attr.mode = 0444;
> +	regulator->dev_attr.show = dev_load_show;
> +	err = device_create_file(dev, &regulator->dev_attr);
> +	if (err < 0) {
> +		printk(KERN_WARNING "%s: could not add regulator_cdev load"
> +		" sysfs\n", __func__);
> +		goto err_out;
> +	}
> +	err = sysfs_create_link(&rcdev->cdev.kobj, &dev->kobj,
> +		dev->kobj.name);
> +	if (err) {
> +		printk(KERN_WARNING
> +			"%s: could not add device link %s err %d\n",
> +			__func__, dev->kobj.name, err);
> +		goto err_out;

Missing device_remove_file()?

> +	}
> +out:
> +	return regulator;
> +err_out:
> +	kfree(regulator->dev_attr.attr.name);
> +	list_del(&regulator->list);
> +	kfree(regulator);
> +	return NULL;
> +}
>
> ...
>
> +void regulator_put(struct regulator *regulator)
> +{
> +	struct regulator_cdev *rcdev;
> +
> +	if (regulator == NULL || IS_ERR(regulator))
> +		return;
> +
> +	rcdev = regulator->rcdev;
> +
> +	/* remove any sysfs entries */
> +	if (regulator->dev) {
> +		sysfs_remove_link(&rcdev->cdev.kobj,
> +			regulator->dev->kobj.name);
> +		device_remove_file(regulator->dev, &regulator->dev_attr);
> +	}
> +	list_del(&regulator->list);

locking?

> +	kfree(regulator->dev_attr.attr.name);
> +	kfree(regulator);
> +
> +	module_put(rcdev->owner);
> +	mutex_unlock(&list_mutex);
> +}
> +EXPORT_SYMBOL_GPL(regulator_put);
> +
> +static int _regulator_enable(struct regulator_cdev *rcdev)
> +{
> +	int ret = 0;
> +
> +	/* if the regulator is currently disabled make sure we check
> +	 * it's parent, mode and required voltage */
> +	if (rcdev->use_count == 0) {
> +		if (rcdev->parent) {
> +			ret = _regulator_enable(rcdev->parent);
> +			if (ret < 0) {
> +				printk(KERN_ERR "%s: failed to enable %s\n",
> +					__func__, rcdev->desc->name);
> +				goto out;
> +			}
> +		}
> +		if (rcdev->desc->ops->enable) {
> +			ret = regulator_set_stable_voltage(rcdev);
> +			if (ret < 0) {
> +				printk(KERN_ERR "%s: invalid voltage for %s\n",
> +					__func__, rcdev->desc->name);
> +				goto out;
> +			}
> +			regulator_load_change(rcdev);
> +			ret = rcdev->desc->ops->enable(rcdev);
> +			if (ret < 0) {
> +				printk(KERN_ERR "%s: failed to enable %s\n",
> +					__func__, rcdev->desc->name);
> +				goto out;
> +			}
> +		}
> +	} else {
> +		ret = regulator_set_stable_voltage(rcdev);
> +		if (ret < 0) {
> +			printk(KERN_ERR "%s: invalid voltage for %s\n",
> +				__func__, rcdev->desc->name);
> +			goto out;
> +		}
> +		regulator_load_change(rcdev);
> +	}
> +	rcdev->use_count++;
> +out:
> +	return ret;
> +}

Yeah, it's nicer to have the kerneldoc here, while yo're reading the code.

> +static int _regulator_disable(struct regulator_cdev *rcdev)
> +{
> +	int ret = 0;
> +
> +	/* make sure we are the last user before disabling this regulator */
> +	if (rcdev->use_count == 1) {
> +		if (rcdev->desc->ops->disable) {
> +			ret = rcdev->desc->ops->disable(rcdev);
> +			if (ret < 0) {
> +				printk(KERN_ERR "%s: failed to disable %s\n",
> +					__func__, rcdev->desc->name);
> +				goto out;
> +			}
> +		}
> +		/* decrease parent ref count and disable if required */
> +		if (rcdev->parent)
> +			_regulator_disable(rcdev->parent);
> +	} else {
> +		/* set to next best requested voltage and mode */
> +		ret = regulator_set_stable_voltage(rcdev);
> +		regulator_load_change(rcdev);
> +	}
> +	rcdev->use_count--;

locking for ->use_count?

> +out:
> +	if (rcdev->use_count < 0) {
> +		printk(KERN_ERR "%s: tried to disable too many times\n",
> +			__func__);
> +		rcdev->use_count = 0;
> +	}
> +	return ret;
> +}
> +

