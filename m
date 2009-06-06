Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZFFGwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZFFGwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZFFGw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:52:28 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:16529
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbZFFGw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:52:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjACACuvKUp8qN0Z/2dsb2JhbAAI0DOECgU
X-IronPort-AV: E=Sophos;i="4.41,314,1241366400"; 
   d="scan'208";a="522999117"
Subject: Re: [PATCH] gpiolib: allow poll on gpio value
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906052301.39877.david-b@pacbell.net>
References: <1244212590-15620-1-git-send-email-dg@emlix.com>
	 <1244260002.22690.21.camel@linux-51e8.site>
	 <200906052301.39877.david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Jun 2009 16:51:42 +1000
Message-Id: <1244271102.22690.59.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 23:01 -0700, David Brownell wrote:
> On Friday 05 June 2009, Ben Nizette wrote:
> > 
> > Hey, good stuff Daniel.  There's a fair few common features missing but
> > they can be added at a later date.
> > 
> > - Ability to honour rising and falling filters even if the hardware only
> > supports both-edge (as lots of gpio interrupts do)
> 
> I suspect that's inadvisable.  Userspace code will need to know
> what trigger model it's using, yes?  Lies are doubleplusungood.
> 

Well if the user wants to know that poll(2) will report each time value
transitions 0 -> 1 for example then why should it care whether that
filtering has come straight from the interrupt controller or some piece
of code has simply discarded the 1 -> 0 transitions for it?

Doing this in the kernel is a good idea IMO - the probability of the
gpio changing value between and interrupt and it's handler is much lower
than between interrupt and userspace reading "value".

Of course document that pulses smaller than interrupt latency may be
missed - a limitation which I think is perfectly fair.

> 
> > - Support for polling the gpio at some interval for gpios which don't
> > support irqs at all
> 
> I had that thought.  Units ... seconds?  Milliseconds mapped to HZ?
> Could come later.

Certainly could come later.  ms are as good a choice as any, just so
long as root can set a lower bound on polling period.

> 
> 
> > - Debounce support
> 
> Software?  Hardware capabilties vary *widely* ... three cases that
> come quickly to mind:  (a) twl4030 fixed 30 msec delays, (b) at91
> and avr32 "deglitch" filter, just syncs to a clock that's likely
> from 30-100 MHz, (c) omap2/omap3, up to 255 cycles of 32 KiHz clock
> but appplies entire GPIO banks, (d) DaVinci, no hardware support.
> 
> I can imagine a standard software filter option, but that would
> need to be a separate sysfs mechanism since it wouldn't always
> be desired.  (And separate patch, if needed.)
> 
> For hardware options ... do that by hardware-specific sysfs hooks
> if they're really needed.

Oh gods, software for sure.  Yeah hardware debounce support is something
which I'm not game to tackle.

I guess debouncing can be done by userspace though.  In fact it almost
is done to some approximation simply by the fact that by the time the
user actually gets around to reacting the pin's probably settled anyway.

> 
> 
> > - Reporting of number of changes since last read
> 
> Feels a more than bit overkilled by now.  ;)

UIO does it and I've found it useful there.  I've also had requests to
implement this in my old gpio sysfs notification implementation (now
sadly neglected).  Apart from anything else it leads to easy
implementation for things like robust event counters - a common use case
for this kind of thing.

> 
> 
> > These are all things which exist in many out-of-tree or
> > platform-specific implementations of this kind of thing and until
> > they're there I reckon people will largely stick with what they've got.
> > But that's really their problem of course, this is still valuable.
> > 
> > Regarding the code itself, not much but:
> > 
> > On Fri, 2009-06-05 at 16:36 +0200, Daniel Glöckner wrote:
> > >  
> > > +	"poll_edge" ... reads as either "none", "rising", "falling", or
> > 
> > IMO this is misleading, sounds like you're polling the gpio. 
> 
> So, just name the sysfs attribute "edge"?
> 

Sure.  Or notification_edge though it's a mouthful.  "poll" is just so
horribly overloaded in this field.

>  
> > > +
> > > +	struct sysfs_dirent	*value_sd;
> > >  };
> > 
> > No CONFIG_ option to turn all this off?
> > 
> > What's the .text and .data impact of this?  Sure it's going to be small,
> > but to some people (especially those likely to care about gpio) 1k
> > of .data is something worth being able to turn off.
> 
> I think it's probably OK to have this covered by the current
> GPIO_SYSFS flag.

Fair 'nuff.  AFAICT this code is covered by that option already but the
value_sd field still needs to be wrapped.

> 
>  
> > Using an IDR keyed to the gpio value and just allocating your useful
> > data structures when poll_edge != "none" would help too.
> 
> Can do that without an IDR, I think...

Sure.  If you're dynamically allocating these data structures though you
need some way to keep track of them.  Either point to them with a field
in struct gpio_desc (which of course misses the point), chain them
together in a list or tree or $(EXOTIC_DATA_STRUCTURE) or stick them in
an IDR.  IDRs just happen to be light, easy, fast and suit this
integer-to-pointer case.


	--Ben.



