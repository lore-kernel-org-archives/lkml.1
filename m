Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbYE0Xlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbYE0Xlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYE0Xlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:41:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:39427 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYE0Xla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=vujHDayjQ+xVl8ggJKTuQCGFqmaaV7v3V/PFnaZDeVZlhOeZtUr9u7QoDei8mqS442pu/+6YszB5uur5Mt15CxSjmeZZ+4ZWhfwrLL++A/LuLKtcwc5yH6fw49LamJcEMRZYDzpcXQsusndozvqF2LcSBm/z44cu1sEqCuwWyWE=
Date: Wed, 28 May 2008 03:41:15 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com, david-b@pacbell.net
Subject: Re: [RFC][PATCH 1/2] Clocklib: add generic framework for managing
	clocks.
Message-ID: <20080527234115.GA13110@doriath.ww600.siemens.net>
References: <20080522211942.GA11271@doriath.ww600.siemens.net> <20080522212142.GA11850@doriath.ww600.siemens.net> <20080527150919.8d5a3e1c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527150919.8d5a3e1c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 27, 2008 at 03:09:19PM -0700, Andrew Morton wrote:
> On Fri, 23 May 2008 01:21:42 +0400
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > Provide a generic framework that platform may choose
> > to support clocks api. In particular this provides
> > platform-independant struct clk definition, a full
> > implementation of clocks api and a set of functions
> > for registering and unregistering clocks in a safe way.
> > 
> 
> Nobody interested in this?
> 
> Please feed the patches through scripts/checkpatch.pl sometime, have a
> think about the things which it detects?

OK, I'll try not to forget it before next round :)

> 
> > 
> > diff --git a/include/linux/clocklib.h b/include/linux/clocklib.h
> > new file mode 100644
> > index 0000000..31ca048
> > --- /dev/null
> > +++ b/include/linux/clocklib.h
> > @@ -0,0 +1,64 @@
> > +/*
> > + * Copyright (C) 2008 Dmitry Baryshkov
> > + *
> > + * This file is released under the GPL v2.
> > + */
> > +#ifndef CLOCKLIB_H
> > +#define CLOCKLIB_H
> > +
> > +struct device;
> > +struct clk;
> > +
> > +/**
> > + * struct clk_ops - generic clock management operations
> > + * @can_get: checks whether passed device can get this clock
> > + * @set_parent: reconfigures the clock to use specified parent
> > + * @set_mode: enable or disable specified clock.
> > + * @get_rate: obtain the current clock rate of a specified clock
> > + * @round_rate: adjust a reate to the exact rate a clock can provide and possibly apply it
> > + * @format: output any additional information for a clock
> > + *
> > + * This structure specifies clock operations that are used to configure
> > + * specific clock.
> > + */
> > +struct clk_ops {
> > +	int (*can_get)(struct clk *clk, void *data, struct device *dev);
> > +	int (*set_parent)(struct clk *clk, void *data, struct clk *parent);
> > +	int (*set_mode)(struct clk *clk, void *data, bool enable);
> 
> `set_mode' seems to be misnamed?
> 
> We prefer to avoid functions which take a `heres-what-to-do' argument
> like this.  I'd have thought that it would be cleaner to have separate
> `enable' and `disable' operations?

This was suggested before by Haavard. Probably the reason was space
reduction.

> The documentation should perhaps explain that set_mode() is called
> under spin_lock_irqsave() and hence cannot do much.

All functions from clk_ops are run with spinlock held.

> > +	unsigned long (*get_rate)(struct clk *clk, void *data);
> > +	long int (*round_rate)(struct clk *clk, void *data, unsigned long rate, bool apply);
> > +};
> > +
> > +

[skipped]

> > +
> > +struct clk *clk_alloc(struct clk *parent, const struct clk_ops *ops,
> > +		void * data, const char *fmt, ...)
> > +{
> > +	struct clk *clk = kzalloc(sizeof(*clk), GFP_ATOMIC);
> 
> This could-and-should be GFP_KERNEL.

ACK.

> 
> > +	char *name;
> > +	va_list args;
> > +	int rc;
> > +
> > +	if (!clk)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	clk->kobj.kset = clks_kset;
> > +
> > +	clk->ops = ops;
> > +	clk->data = data;
> > +
> > +	va_start(args, fmt);
> > +	name = kvasprintf(GFP_KERNEL, fmt, args);
> > +	va_end(args);
> > +	if (!name) {
> > +		kfree(clk);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	rc = kobject_init_and_add(&clk->kobj, &clk_ktype,
> > +			parent? &parent->kobj : NULL,
> > +			"%s", name);
> > +
> > +	kfree(name);
> > +
> > +	if (rc) {
> > +		kfree(clk);
> > +		clk = ERR_PTR(rc);
> > +	}
> > +
> > +	return clk;
> > +}
> > +EXPORT_SYMBOL(clk_alloc);
> > +
> > +void clk_free(struct clk *clk)
> > +{
> > +	unsigned long flags;
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +
> > +	clk->ops = NULL;
> > +	clk->data = NULL;
> > +
> > +	kobject_put(&clk->kobj);
> > +
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +}
> > +EXPORT_SYMBOL(clk_free);
> > +
> > +int clks_register(struct clk_table *clks, int size)
> > +{
> > +	int i;
> > +	int rc = 0;
> > +	for (i = 0; i < size; i++) {
> > +		struct clk *parent = NULL;
> > +		struct clk *clk;
> > +		if (clks[i].parent_name) {
> > +			parent = clk_get(clks[i].parent_dev, clks[i].parent_name);
> > +			if (!parent) {
> > +				rc = -ENOENT;
> > +				i--;
> > +				break;
> > +			}
> > +		}
> > +		clk = clk_alloc(parent, clks[i].ops,
> > +				clks[i].data, "%s", clks[i].name);
> > +		if (parent)
> > +			clk_put(parent);
> > +		if (IS_ERR(clk)) {
> > +			rc = PTR_ERR(clk);
> > +			i --;
> > +			break;
> > +		}
> > +
> > +		clks[i].clk = clk;
> > +	}
> > +
> > +	if (rc) {
> > +		for ( ; i >= 0; i--) {
> > +			clk_free(clks[i].clk);
> > +			clks[i].clk = NULL;
> > +		}
> > +	}
> > +
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL(clks_register);
> 
> The patch generally has nice documentation, but these two major
> interface functions were omitted.

Oops...

> 
> > +
> > +struct clk *clk_get(struct device *dev, const char *name)
> > +{
> > +	struct clk *clk = ERR_PTR(-ENOENT);
> > +	struct clk *p;
> > +	unsigned long flags;
> > +	struct kobject *k;
> > +
> > +	/* Take both clocks_lock and kset lock */
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +	spin_lock(&clks_kset->list_lock);
> > +
> > +	list_for_each_entry(k, &clks_kset->list, entry) {
> > +		if (kobject_name(k) && !strcmp(kobject_name(k), name)
> > +				) {
> > +			p = container_of(kobject_get(k), struct clk, kobj);
> > +			if (p->ops && p->ops->can_get &&
> > +					p->ops->can_get(p, p->data, dev)) {
> > +				clk = p;
> > +				break;
> > +			}
> > +			kobject_put(k);
> > +		}
> > +	}
> > +
> > +	list_for_each_entry(k, &clks_kset->list, entry) {
> > +		if (kobject_name(k) && !strcmp(kobject_name(k), name)
> > +				) {
> > +			p = container_of(kobject_get(k), struct clk, kobj);
> > +			if (!p->ops || !p->ops->can_get) {
> > +				clk = p;
> > +				break;
> > +			}
> > +			kobject_put(k);
> > +			break;
> > +		}
> > +	}
> > +
> > +	spin_unlock(&clks_kset->list_lock);
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +
> > +	return clk;
> > +}
> > +EXPORT_SYMBOL(clk_get);
> > +
> > +void clk_put(struct clk *clk)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +
> > +	kobject_put(&clk->kobj);
> > +
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +}
> > +EXPORT_SYMBOL(clk_put);
> 
> Hopefully this function will not be called at a high frequency.  If it
> is, scalability will be poor.

Usually clk_get/clk_put are called only during probes/remove of the
device/driver.

> 
> Why does clocks_lock need to be taken in an irq-safe manner?

I just wanted to be sure that most functions will be irq-safe.
Probably clk_get/_put can use plain spin_lock/_unlock, but I'm
not sure if this is justifable.

> 
> > +static int __clk_enable(struct clk *clk)
> > +{
> > +	int rc;
> > +
> > +	if (clk->usage ++ != 0)
> > +		return 0;
> > +
> > +	if (!clk->ops || !clk->ops->set_mode)
> > +		return 0;
> > +
> > +	rc = clk->ops->set_mode(clk, clk->data, true);
> > +	if (rc) {
> > +		clk->ops->set_mode(clk, clk->data, false);
> > +		clk->usage --;
> > +	}
> > +
> > +	return rc;
> > +}
> > +
> > +int clk_enable(struct clk *clk)
> > +{
> > +	unsigned long flags;
> > +	int rc = 0;
> > +
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +
> > +	rc = __clk_enable(clk);
> > +
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL(clk_enable);
> > +
> > +static int __clk_disable(struct clk *clk)
> > +{
> > +	clk->usage --;
> > +
> > +	WARN_ON(clk->usage < 0);
> > +
> > +	if (clk->usage != 0)
> > +		return 0;
> > +
> > +	if (!clk->ops || !clk->ops->set_mode)
> > +		return 0;
> > +
> > +	return clk->ops->set_mode(clk, clk->data, false);
> > +}
> > +
> > +void clk_disable(struct clk *clk)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +
> > +	__clk_disable(clk);
> > +
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +}
> > +EXPORT_SYMBOL(clk_disable);
> > +
> > +unsigned long clk_get_rate(struct clk *clk)
> > +{
> > +	unsigned long flags;
> > +
> > +	unsigned long rate = 0;
> 
> Unneeded newline.

ack

> 
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +
> > +	if (!clk->ops || !clk->ops->get_rate)
> > +		goto out;
> 
> Did we really need to hold the lock to perform this check?
> 
> Is it really valid for a clock to have no ->ops and no -ops->get_rate? 
> Please consider mandating that these fields must be provided, then
> remove this check.

With this patch clocks can be registered and unregistered at any time.
When the clock in unregistered I drop the reference to the clk_ops (so
the module can be unregistered, but if the clock is still referenced,
those functions still can be called. That's why I have to check for the
presense of ->ops. On the other hand ->ops->get_rate can be made mandatory.

> 
> > +	rate = clk->ops->get_rate(clk, clk->data);
> > +
> > +out:
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +
> > +	return rate;
> > +}
> > +EXPORT_SYMBOL(clk_get_rate);
> > +
> > +int clk_set_rate(struct clk *clk, unsigned long rate)
> > +{
> > +	unsigned long flags;
> > +	long rc = -EINVAL;
> > +
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +
> > +	if (!clk->ops || !clk->ops->round_rate)
> > +		goto out;
> > +
> > +	rc = clk->ops->round_rate(clk, clk->data, rate, true);
> > +
> > +out:
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +
> > +	return rc < 0 ? rc : 0;
> > +}
> > +EXPORT_SYMBOL(clk_set_rate);
> 
> I look at this and wonder what unit `rate' is in.  Some interface
> documentation would clear that up, but even better would be to use a
> more specific identifier - one which describes the quantity's units. 
> For example, "hz".

It's documented in the <linux/clk.h>. However I can change it in both
files if you like.

> 
> > +long clk_round_rate(struct clk *clk, unsigned long rate)
> 
> ditto everywhere
> 
> > +{
> > +	unsigned long flags;
> > +	long rc = -EINVAL;
> > +
> > +	spin_lock_irqsave(&clocks_lock, flags);
> > +
> > +	if (!clk->ops || !clk->ops->round_rate)
> > +		goto out;
> > +
> > +	rc = clk->ops->round_rate(clk, clk->data, rate, false);
> > +
> > +out:
> > +	spin_unlock_irqrestore(&clocks_lock, flags);
> > +
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL(clk_round_rate);
> 
> Was `long' an appropriate type here?  I'd have expected `unsigned long'.
> 
> Perhaps this can really retrun negative values.  Aditional
> documentation would clear that up.

See <linux/clk.h>.

> 
> > +
> > +static int clk_dev_can_get(struct clk *clk, void *data, struct device *dev)
> > +{
> > +	return data == dev;
> > +}
> 
> This can_get operation is a bit mysterious and unusual-looking.  Why
> would one not be able to get a clock device?

Maybe it's misnamed. It checks whether this particular "struct clk" is
suitable for passed device. E.g. for the uniformity of the driver the
PXA names all clocks "UARTCLK" and binds each of them to the particular
UART device in the system. Some other platforms would like to compare
the id of the device on the platform_bus with the value stored in the
clock. To make this check generic, I've provided the possibility for
each particular clock to define it's own way to be bound to devices.

> 
> Again, additional changelogging and/or code commenting is needed,
> because if I was wondering this now, we can expect that others will
> wonder the same thing in the future.

I'll add the text above as a comment.

> 
> > +static int clk_set_mode_parent(struct clk *clk, void *data, bool enable)
> > +{
> > +	struct clk *parent = __clk_get_parent(clk);
> > +	int rc;
> > +
> > +	printk("!!! %sable: %s (%s)\n", enable? "en": "dis",
> > +				kobject_name(&clk->kobj),
> > +				kobject_name(&parent->kobj));
> 
> I guess that printk is temporary?

Of course :)

> 
> > +	BUG_ON(!parent);
> > +
> > +	if (enable)
> > +		rc = __clk_enable(parent);
> > +	else
> > +		rc = __clk_disable(parent);
> > +
> > +	clk_put(parent);
> > +
> > +	return rc;
> > +}
> > +
> > +static unsigned long clk_get_rate_parent(struct clk *clk, void *data)
> > +{
> > +	struct clk *parent = __clk_get_parent(clk);
> > +	unsigned long rate = 0;
> > +
> > +	BUG_ON(!parent);
> > +
> > +	if (!parent->ops || !parent->ops->get_rate)
> > +		WARN_ON(1);
> > +	else
> > +		rate = parent->ops->get_rate(parent, parent->data);
> > +
> > +	clk_put(parent);
> > +
> > +	return rate;
> > +}
> 
> Can we avoid the (mysterious) void* here?  Do something which will
> allow the C type system to check our stuff?

I don't know how we can avoid it. Each clock can have "private" data
bound to it. Previously the proposed way was to embed struct clk. However
since struct clk is dynamic now, it's not directly possible. And all
solutions I can think upon are more or less hacky.

-- 
With best wishes
Dmitry

