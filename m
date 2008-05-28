Return-Path: <linux-kernel-owner+w=401wt.eu-S1751050AbYE1N6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbYE1N6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYE1N56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:57:58 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:44160 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYE1N55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:57:57 -0400
Date: Wed, 28 May 2008 15:56:45 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com, david-b@pacbell.net,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 1/2] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080528155645.38a88953@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <bc64b4640805280544o7fac1565gd7e1e09ece6c5500@mail.gmail.com>
References: <20080522211942.GA11271@doriath.ww600.siemens.net>
	<20080522212142.GA11850@doriath.ww600.siemens.net>
	<20080527150919.8d5a3e1c.akpm@linux-foundation.org>
	<20080527234115.GA13110@doriath.ww600.siemens.net>
	<20080528094457.6687e0dd@hskinnemo-gx745.norway.atmel.com>
	<bc64b4640805280544o7fac1565gd7e1e09ece6c5500@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 13:56:35.0809 (UTC) FILETIME=[A4A25D10:01C8C0CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry <dbaryshkov@gmail.com> wrote:
> Hi,
> 
> Haavard, few words before detailed comments. In this version of the patchset
> I tried to solve the problem of dynamic unregistration of clocks.
> Consider this example:
> 1) Module A register CLKA
> 2) Module B clk_gets CLKA
> 3) Module A is unloaded
> 3.1) As it's unloaded module A unregisters CLKA
> 4) Module B tries to clk_get_rate on CLKA

clk_get_rate() returns unsigned long, so we're screwed. I think we need
to prevent unloading module A until module B clk_puts CLKA.

> I can think of several solutions for this problem, but IMO the most clear one is
> to force struct clk to be fully dynamic and to use kobjects for it's management.
> This helped me:
> 1) to cleanup the above case

You forgot to audit all drivers to make sure they handle bogus return
values from the clk functions appropriately.

> 2) to cleanup that "clk_alloc_function" mess (required for clock aliasing, etc)

I have to say I'm glad the "clk function" stuff is gone as I never
really understood it...

> 3) to get sysfs integration for free

I wouldn't call making struct clk twice as big as it used to be "free".

> Also, please, bear in mind, that I titled this version of the patchset as "RFC".
> I just wanted to know your opinion on this approach. If it's less acceptable,
> I'll get back to my previous patchset.

Yes, I think it's less acceptable than the previous patchset. But if
other people like this patchset better, I can always stay with my own
implementation of the clk api on avr32.

> 2008/5/28 Haavard Skinnemoen <haavard.skinnemoen@atmel.com>:
> > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> >> Hi,
> >>
> >> On Tue, May 27, 2008 at 03:09:19PM -0700, Andrew Morton wrote:
> >> > On Fri, 23 May 2008 01:21:42 +0400
> >> > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> >> >
> >> > > Provide a generic framework that platform may choose
> >> > > to support clocks api. In particular this provides
> >> > > platform-independant struct clk definition, a full
> >> > > implementation of clocks api and a set of functions
> >> > > for registering and unregistering clocks in a safe way.
> >> > >
> >> >
> >> > Nobody interested in this?
> >
> > Sorry. I am...or at least I used to be until struct clk went all porky
> > and got hidden away in a .c file...
> 
> It get hidden because in this patchset it contains only private fields
> not intended for public usage.

"private" fields for a mid-layer that doesn't actually do anything
translates into useless fields in my book.

> >> > The documentation should perhaps explain that set_mode() is called
> >> > under spin_lock_irqsave() and hence cannot do much.
> >>
> >> All functions from clk_ops are run with spinlock held.
> >
> > Why is that necessary?
> >
> > I've been thinking a bit lately about starting up oscillators through
> > the clk framework, and that may take up to several seconds. Doing that
> > under an irqsafe spinlock would be madness...
> 
> Consider two kernel threads trying to enable single clock...
> I'm sure locking conditions can be relaxed, but I can't come up with
> the solution yet. Maybe you can?

No, I really wish I could, but I can't think of any way to remove the
lock. A mutex is not an option I guess since these things might get
called from interrupt handlers and whatnot.

> >
> >> > > +EXPORT_SYMBOL(clks_register);
> >> >
> >> > The patch generally has nice documentation, but these two major
> >> > interface functions were omitted.
> >>
> >> Oops...
> >
> > Where's the interface to register a single clock btw?
> >
> > I have to say I really hate this "struct clk_table" thing. Another
> > reason why struct clk should be in a header file, not a .c file.
> 
> See above. The struct clk incorporates the kobject, so it should
> never ever be declared.

I don't understand that reasoning. Why can't you declare a struct that
contains a kobject? I've allocated platform_devices statically lots of
times -- those have embedded kobjects too.

Why not split out the registration bits of clk_alloc() into a separate
clk_register() or clk_add() call?

> > Why do you have to iterate over clks_kset->list twice?
> 
> There are two types of clocks. Ones that are bound to devices
> and ones that aren't. E.g. on my development board there is
> a MMCCLK which is driven by the chip and is used by my driver
> and there is a MMCCLK which is driven by PXA and used by
> pxa2xx-mci driver. That's why first you try to find the clock from
> "bound" ones (ones wich provide can_get) and then from
> all other.

Oh.

How about making can_get() mandatory and provide a default
clk_can_always_get() function for clocks that aren't bound to devices?

> >> > > + spin_lock_irqsave(&clocks_lock, flags);
> >> > > +
> >> > > + if (!clk->ops || !clk->ops->get_rate)
> >> > > +         goto out;
> >> >
> >> > Did we really need to hold the lock to perform this check?
> >> >
> >> > Is it really valid for a clock to have no ->ops and no -ops->get_rate?
> >> > Please consider mandating that these fields must be provided, then
> >> > remove this check.
> >>
> >> With this patch clocks can be registered and unregistered at any time.
> >> When the clock in unregistered I drop the reference to the clk_ops (so
> >> the module can be unregistered, but if the clock is still referenced,
> >> those functions still can be called. That's why I have to check for the
> >> presense of ->ops. On the other hand ->ops->get_rate can be made mandatory.
> >
> > So...how does the user know that the clock disappeared? Is it really a
> > good idea to allow clocks to be unregistered while someone is using it?
> 
> What should we do if a user explicitly unbinds the driver that has registered
> a clock? We can't fail that operation and say "keep the device bound".
> So the only way is to let him use the reference, but return some error
> for each call.

Why can't we fail that operation? We certainly can't return an error
for all calls with the existing API.

Isn't it quite common to prevent a module from being unloaded if
another module is using it? try_module_get() in clk_get() and
module_put() in clk_put() should do the trick, no?

Or you can stall the unregistration until all users are gone. The DMA
engine layer does something like that.

> >> > > +static unsigned long clk_get_rate_parent(struct clk *clk, void *data)
> >> > > +{
> >> > > + struct clk *parent = __clk_get_parent(clk);
> >> > > + unsigned long rate = 0;
> >> > > +
> >> > > + BUG_ON(!parent);
> >> > > +
> >> > > + if (!parent->ops || !parent->ops->get_rate)
> >> > > +         WARN_ON(1);
> >> > > + else
> >> > > +         rate = parent->ops->get_rate(parent, parent->data);
> >> > > +
> >> > > + clk_put(parent);
> >> > > +
> >> > > + return rate;
> >> > > +}
> >> >
> >> > Can we avoid the (mysterious) void* here?  Do something which will
> >> > allow the C type system to check our stuff?
> >>
> >> I don't know how we can avoid it. Each clock can have "private" data
> >> bound to it. Previously the proposed way was to embed struct clk. However
> >> since struct clk is dynamic now, it's not directly possible. And all
> >> solutions I can think upon are more or less hacky.
> >
> > Can't you just add some sort of additional_size parameter to the alloc
> > function to make it possible for clock drivers to extend it?
> 
> ... and fill the "extension" with private information. Wait! That information
> is already present in some form in the kernel. So if we won't use a pointer
> to it, we'll duplicate that info and in fact increase the memory cost
> of the clock.
> That seems like the real drawback.

Huh? Isn't that a very strong argument against keeping struct clk
hidden? That's certainly going to cause duplication since you can't
share any data at all between the mid-layer and the hardware driver...

I guess what I'm not understanding is why this struct clk with an
embedded kobject in it is so special that you can't allocate it in a
normal way (even though clk_alloc() does a quite normal kmalloc() in
order to allocate it...)

> > Removing the kobject would of course solve this too. I forgot why we
> > wanted a kobject in there in the first place (I think I actually said
> > that I _didn't_ want it.)
> 
> Yes, I remeber that mail. But things are so easy with kobjects...

Easy?

You have to use different data structures for registration and normal
use, all users are burdened with the task of checking whether the clock
is actually valid every time they try to use it, sharing of data
between the mid-layer and the hardware driver is prevented, and all
driver hooks got an extra parameter.

Haavard
