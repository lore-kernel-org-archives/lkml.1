Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYJIKar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYJIKar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbYJIKai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:30:38 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:47136 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbYJIKah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:30:37 -0400
Date: Thu, 9 Oct 2008 12:30:30 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Message-ID: <20081009123030.4c9607c1@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200810090234.41243.david-b@pacbell.net>
References: <200809241251.32606.david-b@pacbell.net>
	<200810071114.03219.david-b@pacbell.net>
	<20081008094849.752a29c0@hskinnemo-gx745.norway.atmel.com>
	<200810090234.41243.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Oct 2008 10:30:16.0527 (UTC) FILETIME=[055C55F0:01C929FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 08 October 2008, Haavard Skinnemoen wrote:
> >
> > Ok, so the limitations of various chips vary a lot...which means that
> > it's difficult to predict what IRQF_DEBOUNCED actually does.
> 
> The specific QOS achieved is system-specific; the term for
> that kind of mechanism is "hinting".  It's very clearly defined
> what the hint means .. but a given system might not use it.

I know that, but is "hinting" really what drivers need?

> The madvise(2) system call is a userspace example of hinting.

That's different. Ignoring madvise() hints might hurt performance
slightly, but it won't result in any fundamentally different behaviour.

On the other hand, lack of debouncing might cause the gpio_keys driver
to report 1000 keypresses instead of one when the user pushes a button.
That's much more harmful.

So if someone goes and replaces the debounce timer in gpio_keys with
this IRQF_DEBOUNCE flag, it might work very well on hardware which
happens to use a 30 ms debounce interval, but will break horribly on
hardware with shorter debounce intervals.

> > > What would you think about advice to debounce by default on the
> > > order of one millisecond, where hardware allows?  Later, ways
> > > to query and update that QOS could be defined.
> > 
> > I suppose a good start would be to add a comment saying that.
> > 
> > On the other hand, I don't see how drivers can even tell if the
> > hardware supports IRQF_DEBOUNCED at all...
> 
> That is, "On the other hand, 'later' is not yet..." ?

Right.

> Are you suggesting that debouncing support shouldn't
> be provided without QOS query/update support?

Sort of. I'm just wondering how drivers can rely on a feature which
provides such vague promises.

> > Just a comment, really. But I realize that it's difficult to specify
> > any guarantees since hardware may give you anything from a few
> > nanoseconds to 30 ms...
> 
> Done:  "as close to 1 msec as hardware allows".  (I think less
> than that is probably too little, and more would likely be OK.)

It could be zero on hardware which doesn't support debouncing at all.

> > > > What would be perhaps even more useful is generic software debouncing
> > > > support. Something like
> > > > 
> > > >   int request_debounced_irq(int irq, unsigned long debounce_us,
> > > > 		void (*handler)(void *data), void *data);
> 
> Note by the way what I think is a problematic assumption there:
> that this *exact* debounce period matters.  It seems to be more
> usual that it just fit into a range of reasonable values; a bit
> more or less won't matter, almost by definition.

Yes, I actually came to that conclusion myself, as you've already seen
below.

> (And also, that routine is less functional than request_irq ...)

I guess we could add a "flags" parameter if that's what you mean.

> > > > which would set up a handler which disables the interrupt and sets up a
> > > > timer which will ack/unmask the interrupt and run the handler.
> > > 
> > > Why require "software debouncing" if perhaps the hardware could do
> > > it all for you?
> > 
> > Because of the "perhaps" part of your sentence.
> 
> I'm not sure which sentence you refer too, but the first
> "perhaps" above is yours!  :)

I mean that it's difficult to rely on hardware that "perhaps" can do
debouncing for you. I think many drivers need to know for sure.

> > Maybe we should just add this interface and drop the flag? 
> 
> What I like about the flag is that it's really simple, a
> "fire and forget" model.  Easy for drivers to use.  And it
> need not be incompatible with a fancier interface...

Could be. But I think the examples you provided (gpio_keys and
gpio_mouse) need stronger guarantees before they can drop their
debouncing timers.

> The debounce() method might usefully be changed to take the
> requested delay in microseconds, instead of a boolean.  And
> to return the actual delay.  That would make it easier to
> support fancier calls later, maybe just exposing the raw
> irq_chip call like
> 
> 	usecs = set_irq_debounce(irq, range_spec);

Maybe that's better. Just request the interrupt as normal, and then try
to enable debouncing. If the actual delay is too short, the driver can
set up its own timer.

> The notion of a request_debounced_irq() needs more cooking
> yet though, IMO.

Yes, it was only a suggestion, I didn't mean to provide a fully-cooked
interface. But I think something like that (or set_irq_debounce) would
be useful to many drivers.

> > A flag will 
> > never be able to convey some important parameters like how long to
> > debounce.
> 
> But how important *is* that detail to most drivers?  In practice.
> I susct pethey pick numbers today since they have to debounce with
> software timers, which require numbers.

I think it's very important to drivers that have to deal with
mechanical buttons and switches. In many cases, only the board code
knows what kind of switch is hooked up to the interrupt, so the driver
just passes on that information from the platform data.

> > Then a irq chip implementation can decide to do it in 
> > hardware if the requested debounce delay matches what the hardware can
> > provide.
> 
> I think irq_chip calls should be limited to hardware support.
> Keep them really simple; put layers on top of them if needed.

Ok, so let's just pass the range spec to the debounce() method, and if
it fails, the genirq core can decide to do debouncing in software.

> > Maybe we should let drivers provide a range of acceptable delays so
> > that the irq chip driver won't have to guess at how long it is
> > acceptable to deviate from the specified delay.
> 
> I can't see it working otherwise.  Of course, maybe there should
> just be generic ranges rather than expecting drivers to understand
> how springy contacts might be on a given board, or how dirty they
> may be to cause other kinds of chatter.

Maybe. I'd prefer real numbers to generic-sounding names like
low/medium/high, but if someone can come up with a good way to express
this, I guess that could work.

And I don't really expect drivers to understand this, but drivers can
get help from the platform or board code.

Haavard
