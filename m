Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYE1TyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYE1TyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYE1Txy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:53:54 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:47431 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYE1Txx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:53:53 -0400
Date: Wed, 28 May 2008 21:52:53 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com, david-b@pacbell.net,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 1/2] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080528215253.25b30929@siona.local>
In-Reply-To: <20080528153434.GA10062@doriath.ww600.siemens.net>
References: <20080522211942.GA11271@doriath.ww600.siemens.net>
 <20080522212142.GA11850@doriath.ww600.siemens.net>
 <20080527150919.8d5a3e1c.akpm@linux-foundation.org>
 <20080527234115.GA13110@doriath.ww600.siemens.net>
 <20080528094457.6687e0dd@hskinnemo-gx745.norway.atmel.com>
 <bc64b4640805280544o7fac1565gd7e1e09ece6c5500@mail.gmail.com>
 <20080528155645.38a88953@hskinnemo-gx745.norway.atmel.com>
 <20080528153434.GA10062@doriath.ww600.siemens.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 19:52:54.0236 (UTC) FILETIME=[6B2B71C0:01C8C0FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 19:34:34 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> On Wed, May 28, 2008 at 03:56:45PM +0200, Haavard Skinnemoen wrote:
> > clk_get_rate() returns unsigned long, so we're screwed. I think we need
> > to prevent unloading module A until module B clk_puts CLKA.
> 
> That can be changed to plain long.

Yeah, but current users aren't aware that it can fail at all.

> > You forgot to audit all drivers to make sure they handle bogus return
> > values from the clk functions appropriately.
> 
> I don't think it's a primary task...

If we change the semantics of the clk API, someone has to do it...

> > "private" fields for a mid-layer that doesn't actually do anything
> > translates into useless fields in my book.
> 
> Sorry, I don't understand you. Here is the definition from the C file:
> struct clk {
> 	struct kobject kobj;
> 	int usage;
> 	const struct clk_ops *ops;
> 	void *data;
> };
> 
> Which fields are useless from your POV? The mid-layer manages clocks
> registration, so kobj. It manages usage (enablement) counters.
> It serves per-clock operations. What do you dislike here?

Most of the 36 bytes that the kobject take up are useless. The fields
that _are_ useful are often useful to the hardware driver too, e.g.
"parent" and possibly "usage".

> > I don't understand that reasoning. Why can't you declare a struct that
> > contains a kobject? I've allocated platform_devices statically lots of
> > times -- those have embedded kobjects too.
> 
> Citing Documentation/kobject.txt:
> Because kobjects are dynamic, they must not be declared statically or on
> the stack, but instead, always allocated dynamically.  Future versions of
> the kernel will contain a run-time check for kobjects that are created
> statically and will warn the developer of this improper usage.
> 
> However as static devices do work, we can probably go that way.

Right...I forgot about that restriction. Maybe static platform_devices
work mostly by chance.

> > Isn't it quite common to prevent a module from being unloaded if
> > another module is using it? try_module_get() in clk_get() and
> > module_put() in clk_put() should do the trick, no?
> > 
> > Or you can stall the unregistration until all users are gone. The DMA
> > engine layer does something like that.
> 
> try_module_get()/module_put() won't help.

Why not? Because a clock provider may decide to remove a clock
unrelated to module removal?

> Stalling the unregistration sounds pretty bad also. However maybe we
> should just BUG() in such cases :)

I don't think BUG()ing is appropriate since the module providing the
clock has no way of knowing whether it's ok to unregister the clock.

Maybe we can do the try_module_get()/module_put() thing and BUG() if
the module tries to remove a clock that is in use?

> Haavard, if I return struct clk definition to header, permit clocks to
> be allocated statically, drop again that "priv" in favour of embedding,
> would you agree on kobject-based implementation? I'd really like to use
> them. Because otherwise we are nearly reimplementing them from scratch.

Well...I still think the struct clk is too big. And I'm also not too
happy about changing the semantics of the API so that users have to be
prepared to handle that a clock they hold a reference to may go away at
any time.

But if we really do end up having to deal with "clock hotplugging",
maybe a kref is what we really need, not a whole kobject?

Haavard
