Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbYE0WKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbYE0WKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbYE0WKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:10:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755811AbYE0WKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:10:36 -0400
Date: Tue, 27 May 2008 15:09:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com, david-b@pacbell.net
Subject: Re: [RFC][PATCH 1/2] Clocklib: add generic framework for managing
 clocks.
Message-Id: <20080527150919.8d5a3e1c.akpm@linux-foundation.org>
In-Reply-To: <20080522212142.GA11850@doriath.ww600.siemens.net>
References: <20080522211942.GA11271@doriath.ww600.siemens.net>
	<20080522212142.GA11850@doriath.ww600.siemens.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 01:21:42 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Provide a generic framework that platform may choose
> to support clocks api. In particular this provides
> platform-independant struct clk definition, a full
> implementation of clocks api and a set of functions
> for registering and unregistering clocks in a safe way.
> 

Nobody interested in this?

Please feed the patches through scripts/checkpatch.pl sometime, have a
think about the things which it detects?

> 
> diff --git a/include/linux/clocklib.h b/include/linux/clocklib.h
> new file mode 100644
> index 0000000..31ca048
> --- /dev/null
> +++ b/include/linux/clocklib.h
> @@ -0,0 +1,64 @@
> +/*
> + * Copyright (C) 2008 Dmitry Baryshkov
> + *
> + * This file is released under the GPL v2.
> + */
> +#ifndef CLOCKLIB_H
> +#define CLOCKLIB_H
> +
> +struct device;
> +struct clk;
> +
> +/**
> + * struct clk_ops - generic clock management operations
> + * @can_get: checks whether passed device can get this clock
> + * @set_parent: reconfigures the clock to use specified parent
> + * @set_mode: enable or disable specified clock.
> + * @get_rate: obtain the current clock rate of a specified clock
> + * @round_rate: adjust a reate to the exact rate a clock can provide and possibly apply it
> + * @format: output any additional information for a clock
> + *
> + * This structure specifies clock operations that are used to configure
> + * specific clock.
> + */
> +struct clk_ops {
> +	int (*can_get)(struct clk *clk, void *data, struct device *dev);
> +	int (*set_parent)(struct clk *clk, void *data, struct clk *parent);
> +	int (*set_mode)(struct clk *clk, void *data, bool enable);

`set_mode' seems to be misnamed?

We prefer to avoid functions which take a `heres-what-to-do' argument
like this.  I'd have thought that it would be cleaner to have separate
`enable' and `disable' operations?

The documentation should perhaps explain that set_mode() is called
under spin_lock_irqsave() and hence cannot do much.

> +	unsigned long (*get_rate)(struct clk *clk, void *data);
> +	long int (*round_rate)(struct clk *clk, void *data, unsigned long rate, bool apply);
> +};
> +
> +
> +struct clk *clk_alloc(struct clk *parent, const struct clk_ops *ops,
> +		void * data, const char *fmt, ...)
> +		__attribute__((format(printf, 4, 5)));
> +void clk_free(struct clk *clk);
> +
> +/*
> + * struct clk_table - a helper struct to list clocks and their parents in the table
> + * @parent_name - the name of parent clock if you'd like to find it at the registration time
> + * @parent_dev - the device corresponding to the parent clock
> + * @name - the name of the clock
> + * @ops - operations corresponding to the clock
> + * @data - clock-specific data
> + * @clk - this receives the new clock
> + */
> +struct clk_table {
> +	const char *parent_name;
> +	struct device *parent_dev;
> +
> +	const char *name;
> +	const struct clk_ops *ops;
> +	void *data;
> +
> +	struct clk *clk;
> +};
> +
> +int clks_register(struct clk_table *clks, int size);
> +
> +extern const struct clk_ops clk_dev_ops;
> +
> +#endif
> +
> +
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 8cc8e87..f50b04a 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -13,6 +13,9 @@ config GENERIC_FIND_FIRST_BIT
>  config GENERIC_FIND_NEXT_BIT
>  	def_bool n
>  
> +config CLOCKLIB
> +	tristate
> +
>  config CRC_CCITT
>  	tristate "CRC-CCITT functions"
>  	help
> diff --git a/lib/Makefile b/lib/Makefile
> index 74b0cfb..c5b4cc3 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_PLIST) += plist.o
>  obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
>  obj-$(CONFIG_DEBUG_LIST) += list_debug.o
>  obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
> +lib-$(CONFIG_CLOCKLIB) += clocklib.o
>  
>  ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
>    lib-y += dec_and_lock.o
> diff --git a/lib/clocklib.c b/lib/clocklib.c
> new file mode 100644
> index 0000000..9fda0cd
> --- /dev/null
> +++ b/lib/clocklib.c
> @@ -0,0 +1,432 @@
> +/*
> + * lib/clocklib.c
> + *
> + * Copyright (C) 2008 Dmitry Baryshkov
> + *
> + * Generic clocks API implementation
> + *
> + * This file is released under the GPL v2.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/clocklib.h>
> +#include <linux/kobject.h>
> +#include <linux/err.h>
> +#include <linux/spinlock.h>
> +#include <linux/clk.h>
> +
> +struct clk {
> +	struct kobject kobj;
> +
> +	int usage;
> +
> +	const struct clk_ops *ops;
> +	void *data;
> +};
> +
> +
> +static DEFINE_SPINLOCK(clocks_lock);
> +
> +static void clk_release(struct kobject *kobj)
> +{
> +	struct clk *clk = container_of(kobj, struct clk, kobj);
> +
> +	kfree(clk);
> +}
> +
> +static ssize_t clk_usage_show(struct kobject *kobj,
> +				struct kobj_attribute *attr,
> +				char *buf)
> +{
> +	struct clk *clk = container_of(kobj, struct clk, kobj);
> +	unsigned long flags;
> +	int val;
> +
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	val = clk->usage;
> +
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d", val);
> +}
> +
> +static struct kobj_attribute clk_usage_attr =
> +	__ATTR(usage, 0444, clk_usage_show, NULL);
> +
> +static ssize_t clk_rate_show(struct kobject *kobj,
> +				struct kobj_attribute *attr,
> +				char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%lu",
> +		clk_get_rate(container_of(kobj, struct clk, kobj)));
> +}
> +
> +static struct kobj_attribute clk_rate_attr =
> +	__ATTR(rate, 0444, clk_rate_show, NULL);
> +
> +
> +static struct attribute *clk_attrs[] = {
> +	&clk_usage_attr.attr,
> +	&clk_rate_attr.attr,
> +	NULL,
> +};
> +
> +static struct kobj_type clk_ktype = {
> +	.release = clk_release,
> +	.sysfs_ops = &kobj_sysfs_ops,
> +	.default_attrs = clk_attrs,
> +};
> +
> +static struct kset *clks_kset;
> +
> +static int clk_sysfs_init(void)
> +{
> +	clks_kset = kset_create_and_add("clocks", NULL, kernel_kobj);
> +
> +	if (!clks_kset)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +core_initcall(clk_sysfs_init);
> +
> +static inline struct clk *__clk_get_parent(struct clk *clk)
> +{
> +	return clk->kobj.parent == &clks_kset->kobj ?
> +		NULL :
> +		container_of(kobject_get(clk->kobj.parent), struct clk, kobj);
> +}
> +
> +struct clk *clk_get_parent(struct clk *clk)
> +{
> +	unsigned long flags;
> +	struct clk *parent;
> +
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	parent = __clk_get_parent(clk);
> +
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +	return parent;
> +}
> +
> +
> +struct clk *clk_alloc(struct clk *parent, const struct clk_ops *ops,
> +		void * data, const char *fmt, ...)
> +{
> +	struct clk *clk = kzalloc(sizeof(*clk), GFP_ATOMIC);

This could-and-should be GFP_KERNEL.

> +	char *name;
> +	va_list args;
> +	int rc;
> +
> +	if (!clk)
> +		return ERR_PTR(-ENOMEM);
> +
> +	clk->kobj.kset = clks_kset;
> +
> +	clk->ops = ops;
> +	clk->data = data;
> +
> +	va_start(args, fmt);
> +	name = kvasprintf(GFP_KERNEL, fmt, args);
> +	va_end(args);
> +	if (!name) {
> +		kfree(clk);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	rc = kobject_init_and_add(&clk->kobj, &clk_ktype,
> +			parent? &parent->kobj : NULL,
> +			"%s", name);
> +
> +	kfree(name);
> +
> +	if (rc) {
> +		kfree(clk);
> +		clk = ERR_PTR(rc);
> +	}
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(clk_alloc);
> +
> +void clk_free(struct clk *clk)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	clk->ops = NULL;
> +	clk->data = NULL;
> +
> +	kobject_put(&clk->kobj);
> +
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +EXPORT_SYMBOL(clk_free);
> +
> +int clks_register(struct clk_table *clks, int size)
> +{
> +	int i;
> +	int rc = 0;
> +	for (i = 0; i < size; i++) {
> +		struct clk *parent = NULL;
> +		struct clk *clk;
> +		if (clks[i].parent_name) {
> +			parent = clk_get(clks[i].parent_dev, clks[i].parent_name);
> +			if (!parent) {
> +				rc = -ENOENT;
> +				i--;
> +				break;
> +			}
> +		}
> +		clk = clk_alloc(parent, clks[i].ops,
> +				clks[i].data, "%s", clks[i].name);
> +		if (parent)
> +			clk_put(parent);
> +		if (IS_ERR(clk)) {
> +			rc = PTR_ERR(clk);
> +			i --;
> +			break;
> +		}
> +
> +		clks[i].clk = clk;
> +	}
> +
> +	if (rc) {
> +		for ( ; i >= 0; i--) {
> +			clk_free(clks[i].clk);
> +			clks[i].clk = NULL;
> +		}
> +	}
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(clks_register);

The patch generally has nice documentation, but these two major
interface functions were omitted.

> +
> +struct clk *clk_get(struct device *dev, const char *name)
> +{
> +	struct clk *clk = ERR_PTR(-ENOENT);
> +	struct clk *p;
> +	unsigned long flags;
> +	struct kobject *k;
> +
> +	/* Take both clocks_lock and kset lock */
> +	spin_lock_irqsave(&clocks_lock, flags);
> +	spin_lock(&clks_kset->list_lock);
> +
> +	list_for_each_entry(k, &clks_kset->list, entry) {
> +		if (kobject_name(k) && !strcmp(kobject_name(k), name)
> +				) {
> +			p = container_of(kobject_get(k), struct clk, kobj);
> +			if (p->ops && p->ops->can_get &&
> +					p->ops->can_get(p, p->data, dev)) {
> +				clk = p;
> +				break;
> +			}
> +			kobject_put(k);
> +		}
> +	}
> +
> +	list_for_each_entry(k, &clks_kset->list, entry) {
> +		if (kobject_name(k) && !strcmp(kobject_name(k), name)
> +				) {
> +			p = container_of(kobject_get(k), struct clk, kobj);
> +			if (!p->ops || !p->ops->can_get) {
> +				clk = p;
> +				break;
> +			}
> +			kobject_put(k);
> +			break;
> +		}
> +	}
> +
> +	spin_unlock(&clks_kset->list_lock);
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(clk_get);
> +
> +void clk_put(struct clk *clk)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	kobject_put(&clk->kobj);
> +
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +EXPORT_SYMBOL(clk_put);

Hopefully this function will not be called at a high frequency.  If it
is, scalability will be poor.

Why does clocks_lock need to be taken in an irq-safe manner?

> +static int __clk_enable(struct clk *clk)
> +{
> +	int rc;
> +
> +	if (clk->usage ++ != 0)
> +		return 0;
> +
> +	if (!clk->ops || !clk->ops->set_mode)
> +		return 0;
> +
> +	rc = clk->ops->set_mode(clk, clk->data, true);
> +	if (rc) {
> +		clk->ops->set_mode(clk, clk->data, false);
> +		clk->usage --;
> +	}
> +
> +	return rc;
> +}
> +
> +int clk_enable(struct clk *clk)
> +{
> +	unsigned long flags;
> +	int rc = 0;
> +
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	rc = __clk_enable(clk);
> +
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +	return rc;
> +}
> +EXPORT_SYMBOL(clk_enable);
> +
> +static int __clk_disable(struct clk *clk)
> +{
> +	clk->usage --;
> +
> +	WARN_ON(clk->usage < 0);
> +
> +	if (clk->usage != 0)
> +		return 0;
> +
> +	if (!clk->ops || !clk->ops->set_mode)
> +		return 0;
> +
> +	return clk->ops->set_mode(clk, clk->data, false);
> +}
> +
> +void clk_disable(struct clk *clk)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	__clk_disable(clk);
> +
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +}
> +EXPORT_SYMBOL(clk_disable);
> +
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +	unsigned long flags;
> +
> +	unsigned long rate = 0;

Unneeded newline.

> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	if (!clk->ops || !clk->ops->get_rate)
> +		goto out;

Did we really need to hold the lock to perform this check?

Is it really valid for a clock to have no ->ops and no -ops->get_rate? 
Please consider mandating that these fields must be provided, then
remove this check.

> +	rate = clk->ops->get_rate(clk, clk->data);
> +
> +out:
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +	return rate;
> +}
> +EXPORT_SYMBOL(clk_get_rate);
> +
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	unsigned long flags;
> +	long rc = -EINVAL;
> +
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	if (!clk->ops || !clk->ops->round_rate)
> +		goto out;
> +
> +	rc = clk->ops->round_rate(clk, clk->data, rate, true);
> +
> +out:
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +	return rc < 0 ? rc : 0;
> +}
> +EXPORT_SYMBOL(clk_set_rate);

I look at this and wonder what unit `rate' is in.  Some interface
documentation would clear that up, but even better would be to use a
more specific identifier - one which describes the quantity's units. 
For example, "hz".

> +long clk_round_rate(struct clk *clk, unsigned long rate)

ditto everywhere

> +{
> +	unsigned long flags;
> +	long rc = -EINVAL;
> +
> +	spin_lock_irqsave(&clocks_lock, flags);
> +
> +	if (!clk->ops || !clk->ops->round_rate)
> +		goto out;
> +
> +	rc = clk->ops->round_rate(clk, clk->data, rate, false);
> +
> +out:
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(clk_round_rate);

Was `long' an appropriate type here?  I'd have expected `unsigned long'.

Perhaps this can really retrun negative values.  Aditional
documentation would clear that up.

> +
> +static int clk_dev_can_get(struct clk *clk, void *data, struct device *dev)
> +{
> +	return data == dev;
> +}

This can_get operation is a bit mysterious and unusual-looking.  Why
would one not be able to get a clock device?

Again, additional changelogging and/or code commenting is needed,
because if I was wondering this now, we can expect that others will
wonder the same thing in the future.

> +static int clk_set_mode_parent(struct clk *clk, void *data, bool enable)
> +{
> +	struct clk *parent = __clk_get_parent(clk);
> +	int rc;
> +
> +	printk("!!! %sable: %s (%s)\n", enable? "en": "dis",
> +				kobject_name(&clk->kobj),
> +				kobject_name(&parent->kobj));

I guess that printk is temporary?

> +	BUG_ON(!parent);
> +
> +	if (enable)
> +		rc = __clk_enable(parent);
> +	else
> +		rc = __clk_disable(parent);
> +
> +	clk_put(parent);
> +
> +	return rc;
> +}
> +
> +static unsigned long clk_get_rate_parent(struct clk *clk, void *data)
> +{
> +	struct clk *parent = __clk_get_parent(clk);
> +	unsigned long rate = 0;
> +
> +	BUG_ON(!parent);
> +
> +	if (!parent->ops || !parent->ops->get_rate)
> +		WARN_ON(1);
> +	else
> +		rate = parent->ops->get_rate(parent, parent->data);
> +
> +	clk_put(parent);
> +
> +	return rate;
> +}

Can we avoid the (mysterious) void* here?  Do something which will
allow the C type system to check our stuff?

> +const struct clk_ops clk_dev_ops = {
> +	.can_get = clk_dev_can_get,
> +	.set_mode = clk_set_mode_parent,
> +	.get_rate = clk_get_rate_parent,
> +};
> +EXPORT_SYMBOL(clk_dev_ops);

