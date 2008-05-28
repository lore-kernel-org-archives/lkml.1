Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYE1Mol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYE1Mol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 08:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYE1Mo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 08:44:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:62020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYE1MoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 08:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fw2gYyT0UJjUNQe4eGbKAS1g0L1Tl5N+J+YljxfKfQmuP2eI7HAtS4oGTbT9liYik1oFm93XwKVSAXO5koFGHkORx+4gOe501+Bec8VfFMVYShcUYtx/emN9GxpXm+zD9J0ShInwkOjYV/SUe95J43px5z14v9PbCluALaUj3bk=
Message-ID: <bc64b4640805280544o7fac1565gd7e1e09ece6c5500@mail.gmail.com>
Date: Wed, 28 May 2008 16:44:12 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [RFC][PATCH 1/2] Clocklib: add generic framework for managing clocks.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com, david-b@pacbell.net,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20080528094457.6687e0dd@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522211942.GA11271@doriath.ww600.siemens.net>
	 <20080522212142.GA11850@doriath.ww600.siemens.net>
	 <20080527150919.8d5a3e1c.akpm@linux-foundation.org>
	 <20080527234115.GA13110@doriath.ww600.siemens.net>
	 <20080528094457.6687e0dd@hskinnemo-gx745.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Haavard, few words before detailed comments. In this version of the patchset
I tried to solve the problem of dynamic unregistration of clocks.
Consider this example:
1) Module A register CLKA
2) Module B clk_gets CLKA
3) Module A is unloaded
3.1) As it's unloaded module A unregisters CLKA
4) Module B tries to clk_get_rate on CLKA

I can think of several solutions for this problem, but IMO the most clear one is
to force struct clk to be fully dynamic and to use kobjects for it's management.
This helped me:
1) to cleanup the above case
2) to cleanup that "clk_alloc_function" mess (required for clock aliasing, etc)
3) to get sysfs integration for free

Also, please, bear in mind, that I titled this version of the patchset as "RFC".
I just wanted to know your opinion on this approach. If it's less acceptable,
I'll get back to my previous patchset.

2008/5/28 Haavard Skinnemoen <haavard.skinnemoen@atmel.com>:
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>> Hi,
>>
>> On Tue, May 27, 2008 at 03:09:19PM -0700, Andrew Morton wrote:
>> > On Fri, 23 May 2008 01:21:42 +0400
>> > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>> >
>> > > Provide a generic framework that platform may choose
>> > > to support clocks api. In particular this provides
>> > > platform-independant struct clk definition, a full
>> > > implementation of clocks api and a set of functions
>> > > for registering and unregistering clocks in a safe way.
>> > >
>> >
>> > Nobody interested in this?
>
> Sorry. I am...or at least I used to be until struct clk went all porky
> and got hidden away in a .c file...

It get hidden because in this patchset it contains only private fields
not intended for public usage.

>
> Like I've said before, I think the size of this thing is a real problem
> and will prevent most arch maintainers from even considering it. The
> previous version looked very good in that respect, but now the
> porkiness of struct clk is back with a vengeance.
>
> While I actually liked the previous version, there's no way I'm going
> to use this version on avr32 with its 50+ clocks, and I expect the omap
> people to be even more unhappy.
>
>> > > +struct clk_ops {
>> > > + int (*can_get)(struct clk *clk, void *data, struct device *dev);
>> > > + int (*set_parent)(struct clk *clk, void *data, struct clk *parent);
>> > > + int (*set_mode)(struct clk *clk, void *data, bool enable);
>> >
>> > `set_mode' seems to be misnamed?
>> >
>> > We prefer to avoid functions which take a `heres-what-to-do' argument
>> > like this.  I'd have thought that it would be cleaner to have separate
>> > `enable' and `disable' operations?
>>
>> This was suggested before by Haavard. Probably the reason was space
>> reduction.
>
> Yeah, that's true, but it was before struct clk_ops was split out from
> struct clk. The size of struct clk_ops is far less important than the
> size of struct clk, so feel free to reintroduce separate enable/disable
> hooks.

ok.

>
>> > The documentation should perhaps explain that set_mode() is called
>> > under spin_lock_irqsave() and hence cannot do much.
>>
>> All functions from clk_ops are run with spinlock held.
>
> Why is that necessary?
>
> I've been thinking a bit lately about starting up oscillators through
> the clk framework, and that may take up to several seconds. Doing that
> under an irqsafe spinlock would be madness...

Consider two kernel threads trying to enable single clock...
I'm sure locking conditions can be relaxed, but I can't come up with
the solution yet. Maybe you can?

>
>> > > +EXPORT_SYMBOL(clks_register);
>> >
>> > The patch generally has nice documentation, but these two major
>> > interface functions were omitted.
>>
>> Oops...
>
> Where's the interface to register a single clock btw?
>
> I have to say I really hate this "struct clk_table" thing. Another
> reason why struct clk should be in a header file, not a .c file.

See above. The struct clk incorporates the kobject, so it should
never ever be declared.

>
>> >
>> > > +
>> > > +struct clk *clk_get(struct device *dev, const char *name)
>> > > +{
>> > > + struct clk *clk = ERR_PTR(-ENOENT);
>> > > + struct clk *p;
>> > > + unsigned long flags;
>> > > + struct kobject *k;
>> > > +
>> > > + /* Take both clocks_lock and kset lock */
>> > > + spin_lock_irqsave(&clocks_lock, flags);
>> > > + spin_lock(&clks_kset->list_lock);
>> > > +
>> > > + list_for_each_entry(k, &clks_kset->list, entry) {
>> > > +         if (kobject_name(k) && !strcmp(kobject_name(k), name)
>> > > +                         ) {
>> > > +                 p = container_of(kobject_get(k), struct clk, kobj);
>> > > +                 if (p->ops && p->ops->can_get &&
>> > > +                                 p->ops->can_get(p, p->data, dev)) {
>> > > +                         clk = p;
>> > > +                         break;
>> > > +                 }
>> > > +                 kobject_put(k);
>> > > +         }
>> > > + }
>> > > +
>> > > + list_for_each_entry(k, &clks_kset->list, entry) {
>> > > +         if (kobject_name(k) && !strcmp(kobject_name(k), name)
>> > > +                         ) {
>> > > +                 p = container_of(kobject_get(k), struct clk, kobj);
>> > > +                 if (!p->ops || !p->ops->can_get) {
>> > > +                         clk = p;
>> > > +                         break;
>> > > +                 }
>> > > +                 kobject_put(k);
>> > > +                 break;
>> > > +         }
>> > > + }
>
> Why do you have to iterate over clks_kset->list twice?

There are two types of clocks. Ones that are bound to devices
and ones that aren't. E.g. on my development board there is
a MMCCLK which is driven by the chip and is used by my driver
and there is a MMCCLK which is driven by PXA and used by
pxa2xx-mci driver. That's why first you try to find the clock from
"bound" ones (ones wich provide can_get) and then from
all other.

>> > > + spin_lock_irqsave(&clocks_lock, flags);
>> > > +
>> > > + if (!clk->ops || !clk->ops->get_rate)
>> > > +         goto out;
>> >
>> > Did we really need to hold the lock to perform this check?
>> >
>> > Is it really valid for a clock to have no ->ops and no -ops->get_rate?
>> > Please consider mandating that these fields must be provided, then
>> > remove this check.
>>
>> With this patch clocks can be registered and unregistered at any time.
>> When the clock in unregistered I drop the reference to the clk_ops (so
>> the module can be unregistered, but if the clock is still referenced,
>> those functions still can be called. That's why I have to check for the
>> presense of ->ops. On the other hand ->ops->get_rate can be made mandatory.
>
> So...how does the user know that the clock disappeared? Is it really a
> good idea to allow clocks to be unregistered while someone is using it?

What should we do if a user explicitly unbinds the driver that has registered
a clock? We can't fail that operation and say "keep the device bound".
So the only way is to let him use the reference, but return some error
for each call.

>
>> > > +static unsigned long clk_get_rate_parent(struct clk *clk, void *data)
>> > > +{
>> > > + struct clk *parent = __clk_get_parent(clk);
>> > > + unsigned long rate = 0;
>> > > +
>> > > + BUG_ON(!parent);
>> > > +
>> > > + if (!parent->ops || !parent->ops->get_rate)
>> > > +         WARN_ON(1);
>> > > + else
>> > > +         rate = parent->ops->get_rate(parent, parent->data);
>> > > +
>> > > + clk_put(parent);
>> > > +
>> > > + return rate;
>> > > +}
>> >
>> > Can we avoid the (mysterious) void* here?  Do something which will
>> > allow the C type system to check our stuff?
>>
>> I don't know how we can avoid it. Each clock can have "private" data
>> bound to it. Previously the proposed way was to embed struct clk. However
>> since struct clk is dynamic now, it's not directly possible. And all
>> solutions I can think upon are more or less hacky.
>
> Can't you just add some sort of additional_size parameter to the alloc
> function to make it possible for clock drivers to extend it?

... and fill the "extension" with private information. Wait! That information
is already present in some form in the kernel. So if we won't use a pointer
to it, we'll duplicate that info and in fact increase the memory cost
of the clock.
That seems like the real drawback.

> Removing the kobject would of course solve this too. I forgot why we
> wanted a kobject in there in the first place (I think I actually said
> that I _didn't_ want it.)

Yes, I remeber that mail. But things are so easy with kobjects...

-- 
With best wishes
Dmitry
