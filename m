Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXDOUz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXDOUz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXDOUz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:55:27 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:26714 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753930AbXDOUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:55:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FDewLPrsKCfLL2juP+7c+IgNmdV/SztBPS9Cb+LTHWZ4HEN481Tig5pnsaJJtqnjxPVcS0wpzPqLh5AU+RqNz8jHy2GHjmbWSVB5WB8lAWpbmvOCndjua6l/AfBdUqCqv1hVKHNvXdw11mrHgeFKLEZEDdJsuor6kpLBKxz3af8=  ;
X-YMail-OSG: t1Vzu_sVM1mrRzXofwFD_DQW2gV4yDmn5Zbaui8jm5FiNxLY9Y86N196K7oaMT19Gq2DIfCzEw--
From: David Brownell <david-b@pacbell.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
Date: Sun, 15 Apr 2007 12:47:57 -0700
User-Agent: KMail/1.7.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704102152.21287.david-b@pacbell.net> <1686019041.20070412165702@gmail.com>
In-Reply-To: <1686019041.20070412165702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151247.57724.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 6:57 am, Paul Sokolovsky wrote:
> Wednesday, April 11, 2007, 7:52:20 AM, you wrote:

> > So, talking about what an (optional) implementation framework might
> > look like (and which could handle the SOC, FPGA, I2C, and MFD cases
> > I've looked at):

See patches in following messages ... a preliminary "gpio_chip" core
for such a framework, plus example support for one SOC family's GPIOs,
and then updating one board's handling of GPIOs, including over I2C.


>   Thanks for describing this once again. But I really looked into your
> January's code and this code already. And I fully agree that this will
> work! And your code could have been long ago in git, but is not, ...

Actually, no ... there was a pressing need to adopt some simple basic
interfaces, but no such need for implementation infrastructure to
support fancier features (until the basic interface was in use).
Plus, that code was barely proof-of-concept.

The fact that there are now three simple generic drivers (i2c-gpio,
leds-gpio, gpio_keys) and various additional drivers using those same
interfaces -- working already on multiple platforms! -- illustrates
that anything more than a programming interface, with support on a
handful of "seed" platforms, wasn't required initially.


>   Yes, and let that's something which can be entailed from your
> approach: you argue that it's extensible interface, but kernel is
> exactly not C++ classlib, there must be implementation.

I said "implementation choice" not "extensible interface"; those
are two very different approaches.

You keep bringing C++ into this.  You may not know that doesn't
win points in Linux.  If the point is solid, it doesn't need to
rely on parallels to languages that won't be used in the kernel.
(Plus, why would you imply C++ class libraries don't need to
have implementations?)


> And that 
> implementation: a) will contain inline access for CPU SOC GPIO
> controllers, just because "they are always there";

Not what I said.  You said "will", I said "can"; there's a big
difference.  Consider that for example the OMAP infrastructure
for GPIOs already has a fair amount of indirection, while most
other platforms started more simply ... some of them only
included inlines, others just had simple accessor functions.

My "can" allows all those; your "will" disallows most of them.

And none of them unified that model with non-SOC GPIOs.


> b) will not contain 
> anything else, just because "it's not always there". That's exactly
> what implementation will go into 2.6.21.

Again, not what I said.  The implementations there today just
wrap pre-existing GPIO code which mostly addressed SOC support
since that's the first thing that's needed.  But extensibility
has always been on the agenda.  It's just *details* of how to
extend that have been deferred ... not just by this iteration
of the interface, but by all the preceding platform-specific
ones too.


>   Yes, you argue that anyone who needs to extend Generic GPIO API to
> their case can do that, and in such way that he won't lose single tick
> comparing to using direct low-level methods. 

Again, not what I said ... I've discouraged changing/extending the
programming interface.  But I've certainly pointed out ways that
existing performance expectations can be preserved without changing
that programming interface.


>   But let's face it - most people will not hack mainline-provided
> inlinable headers to add efficient handling for their boards'
> additional GPIO,

Many folk working with embedded hardware will be more than willing
to do exactly that, should performance be a factor.  Especially if the
platform code is written so it's straightforward ... 


> 2) Thankfully, we don't have gpio_chip yet. The temptation to clone
> irq_chip, irq_desc, and stuff is high. So, what we talk here about is
> not only how to implement extensible GPIO, but whether we finally can
> break away from need to use in-kernel bureaucracies for handling each
> and every (low-level) object.

By "bureaucracy" I presume you mean the existence of opaque cookies?
Or do you mean the implied resource tracking?  (Remember that one of
the most basic tasks of an operating system is resource management...)


> > Let me rephrase that in a way I think clarifies things ... and adds
> > some of the context you've omitted:
> 
> >  - What I sketched was (a) a "gpio controller" abstraction, plus
> >    mapping of GPIO numbers to (b) controller, e.g. "yyy[gpio >> 5]"
> >    and (c) controller-specific gpio index, e.g. "gpio & 0x1f";
> 
> >    That's how people have managed GPIOs on Linux for many years now.
> >    It plays well with the very common use of GPIOs as IRQ sources.
> 
> >    Usually the "gpio controller" is a register bank on a SOC, but as
> >    I've pointed out, that could be generalized through the classic
> >    "another level of indirection" technology (not patentable) at
> >    the cost of a new mandatory indirect function call.
> 
> >  - What you sketched essentially says "let's save results (b) and (c)
> >    together in a structure and use that instead of GPIO numbers",
> >    with the mandatory indirect function call.
> 
> Yes. Except not "save", but use from the beginning, as "master"
> identifiers.
>
> >  						Also "let's define
> >    a new programming interface in terms of that struct".

So you're agreeing that, at a technical level, what I described
could be augmented by a "caching" facility ... giving a programming
interface with all the characteristics of your "GPIODEV" thingie.

All you're really disagreeing with is bootstrapping issues; and
whether there is in fact a need for such a layer.  The only argument
I could possibly buy is that it avoids the lookup of (b) ... but
that doesn't seem to matter in most cases I've looked at.


Consider the following /sys/kernel/debug/gpio dump, associated
with one system running the patches I'm posting in other followup
messages:

Controller: MPUIO, 192..207, irqs
  GPIO 193 ( 1): in  hi (  tps65010), IRQ 353/falling
  GPIO 194 ( 2): in  lo (    wakeup), IRQ 354/rising wakeup
  GPIO 196 ( 4): out hi (  idle_led)

Controller: GPIO, 0..15, irqs
  GPIO   0 ( 0): in  lo (   smc_irq), IRQ 160/rising
  GPIO   2 ( 2): out hi (  lcd_pwdn)
  GPIO   3 ( 3): out lo ( timer_led)
  GPIO   4 ( 4): in  hi (         ?), IRQ 164/falling
  GPIO   6 ( 6): in  lo (         ?)
  GPIO  11 (11): out lo (  cam_pwdn)

Controller: GPIO, 32..47, irqs
  GPIO  37 ( 5): in  lo (         ?), IRQ 197/rising wakeup

Controller: GPIO, 48..63, irqs
  GPIO  62 (14): in  hi (    cf_irq), IRQ 222/falling

Controller: tps65010, 208..213, can sleep
  GPIO 208 ( 0): out lo (  vbus_dis)
  GPIO 209 ( 1): out lo (  d3:green)
  GPIO 210 ( 2): out lo ( lan_reset)
  GPIO 211 ( 3): out lo (dsp_pwr_en)
  GPIO 212 ( 4): out lo (  d9:green)
  GPIO 213 ( 5): out lo (  d2:green)

Most of those don't get looked up in GPIO tables even once
a week after the system boots ... the exceptions being the
various LEDs, which obviously aren't performance-critical.
IRQs go another path, and the various power controls don't
change often after boot either.

FWIW, GPIO 37 is ttyS0.RXD used to wake up from sleep,
IRQ-164 is the touchscreen IRQ, and GPIO-6 is a busy signal
from the touchscreen that's not actually used.  They don't
yet use gpio_request(), which is why they're not labeled.


> > Note that I'm giving you the benefit of the doubt in several respects
> > there.  Your original (a) was quite bizarre, and your updated one isn't
> > a lot better because it still needs odd conversions.
> 
>   Well, that's why I used macro initially - to assign some sense to
> those low-level typecasts. You and other people told macros must get
> lost, so they are, and I guess, it's unfair now to say that typecast
> sores you eye - I tried to save everyone from that. But in the end,
> it's C, not me, or GPIODEV. I can rewrite it in asm, and there won't
> be typecasts. But we know why we don't write in asm ;-).

The issue I was referring to was abuse of "void *" pointers when
you should have been using typesafe ones.  And the association
with devices was wierd too.

- Dave

