Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbYE1HqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbYE1HqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 03:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYE1HqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 03:46:13 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:38252 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYE1HqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 03:46:12 -0400
Date: Wed, 28 May 2008 09:44:57 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com, david-b@pacbell.net
Subject: Re: [RFC][PATCH 1/2] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080528094457.6687e0dd@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080527234115.GA13110@doriath.ww600.siemens.net>
References: <20080522211942.GA11271@doriath.ww600.siemens.net>
	<20080522212142.GA11850@doriath.ww600.siemens.net>
	<20080527150919.8d5a3e1c.akpm@linux-foundation.org>
	<20080527234115.GA13110@doriath.ww600.siemens.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 07:44:48.0572 (UTC) FILETIME=[B47C1FC0:01C8C096]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> Hi,
> 
> On Tue, May 27, 2008 at 03:09:19PM -0700, Andrew Morton wrote:
> > On Fri, 23 May 2008 01:21:42 +0400
> > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > 
> > > Provide a generic framework that platform may choose
> > > to support clocks api. In particular this provides
> > > platform-independant struct clk definition, a full
> > > implementation of clocks api and a set of functions
> > > for registering and unregistering clocks in a safe way.
> > > 
> > 
> > Nobody interested in this?

Sorry. I am...or at least I used to be until struct clk went all porky
and got hidden away in a .c file...

Like I've said before, I think the size of this thing is a real problem
and will prevent most arch maintainers from even considering it. The
previous version looked very good in that respect, but now the
porkiness of struct clk is back with a vengeance.

While I actually liked the previous version, there's no way I'm going
to use this version on avr32 with its 50+ clocks, and I expect the omap
people to be even more unhappy.

> > > +struct clk_ops {
> > > +	int (*can_get)(struct clk *clk, void *data, struct device *dev);
> > > +	int (*set_parent)(struct clk *clk, void *data, struct clk *parent);
> > > +	int (*set_mode)(struct clk *clk, void *data, bool enable);
> > 
> > `set_mode' seems to be misnamed?
> > 
> > We prefer to avoid functions which take a `heres-what-to-do' argument
> > like this.  I'd have thought that it would be cleaner to have separate
> > `enable' and `disable' operations?
> 
> This was suggested before by Haavard. Probably the reason was space
> reduction.

Yeah, that's true, but it was before struct clk_ops was split out from
struct clk. The size of struct clk_ops is far less important than the
size of struct clk, so feel free to reintroduce separate enable/disable
hooks.

> > The documentation should perhaps explain that set_mode() is called
> > under spin_lock_irqsave() and hence cannot do much.
> 
> All functions from clk_ops are run with spinlock held.

Why is that necessary?

I've been thinking a bit lately about starting up oscillators through
the clk framework, and that may take up to several seconds. Doing that
under an irqsafe spinlock would be madness...

> > > +EXPORT_SYMBOL(clks_register);
> > 
> > The patch generally has nice documentation, but these two major
> > interface functions were omitted.
> 
> Oops...

Where's the interface to register a single clock btw?

I have to say I really hate this "struct clk_table" thing. Another
reason why struct clk should be in a header file, not a .c file.

> > 
> > > +
> > > +struct clk *clk_get(struct device *dev, const char *name)
> > > +{
> > > +	struct clk *clk = ERR_PTR(-ENOENT);
> > > +	struct clk *p;
> > > +	unsigned long flags;
> > > +	struct kobject *k;
> > > +
> > > +	/* Take both clocks_lock and kset lock */
> > > +	spin_lock_irqsave(&clocks_lock, flags);
> > > +	spin_lock(&clks_kset->list_lock);
> > > +
> > > +	list_for_each_entry(k, &clks_kset->list, entry) {
> > > +		if (kobject_name(k) && !strcmp(kobject_name(k), name)
> > > +				) {
> > > +			p = container_of(kobject_get(k), struct clk, kobj);
> > > +			if (p->ops && p->ops->can_get &&
> > > +					p->ops->can_get(p, p->data, dev)) {
> > > +				clk = p;
> > > +				break;
> > > +			}
> > > +			kobject_put(k);
> > > +		}
> > > +	}
> > > +
> > > +	list_for_each_entry(k, &clks_kset->list, entry) {
> > > +		if (kobject_name(k) && !strcmp(kobject_name(k), name)
> > > +				) {
> > > +			p = container_of(kobject_get(k), struct clk, kobj);
> > > +			if (!p->ops || !p->ops->can_get) {
> > > +				clk = p;
> > > +				break;
> > > +			}
> > > +			kobject_put(k);
> > > +			break;
> > > +		}
> > > +	}

Why do you have to iterate over clks_kset->list twice?

> > > +	spin_lock_irqsave(&clocks_lock, flags);
> > > +
> > > +	if (!clk->ops || !clk->ops->get_rate)
> > > +		goto out;
> > 
> > Did we really need to hold the lock to perform this check?
> > 
> > Is it really valid for a clock to have no ->ops and no -ops->get_rate? 
> > Please consider mandating that these fields must be provided, then
> > remove this check.
> 
> With this patch clocks can be registered and unregistered at any time.
> When the clock in unregistered I drop the reference to the clk_ops (so
> the module can be unregistered, but if the clock is still referenced,
> those functions still can be called. That's why I have to check for the
> presense of ->ops. On the other hand ->ops->get_rate can be made mandatory.

So...how does the user know that the clock disappeared? Is it really a
good idea to allow clocks to be unregistered while someone is using it?

> > > +static unsigned long clk_get_rate_parent(struct clk *clk, void *data)
> > > +{
> > > +	struct clk *parent = __clk_get_parent(clk);
> > > +	unsigned long rate = 0;
> > > +
> > > +	BUG_ON(!parent);
> > > +
> > > +	if (!parent->ops || !parent->ops->get_rate)
> > > +		WARN_ON(1);
> > > +	else
> > > +		rate = parent->ops->get_rate(parent, parent->data);
> > > +
> > > +	clk_put(parent);
> > > +
> > > +	return rate;
> > > +}
> > 
> > Can we avoid the (mysterious) void* here?  Do something which will
> > allow the C type system to check our stuff?
> 
> I don't know how we can avoid it. Each clock can have "private" data
> bound to it. Previously the proposed way was to embed struct clk. However
> since struct clk is dynamic now, it's not directly possible. And all
> solutions I can think upon are more or less hacky.

Can't you just add some sort of additional_size parameter to the alloc
function to make it possible for clock drivers to extend it?

Removing the kobject would of course solve this too. I forgot why we
wanted a kobject in there in the first place (I think I actually said
that I _didn't_ want it.)

Haavard
