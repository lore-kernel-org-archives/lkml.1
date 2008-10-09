Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbYJIJex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbYJIJex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYJIJeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:34:44 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:21130 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754525AbYJIJen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:34:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5PUN1tF3g+JqsJ+vK8ZjuJwxdd+l1ttvVqdY/gTPxzNwSuLkdulY2gak3GgaGc8ugizDBjqvj57IS0h6EC8FByeMRv2Bo07MlV3PcaMfA58rreWkW8i1d7Jp+1A7yDbamaxVa9qnmswDGARCGkrMTK4H6YINPWCDWI9d/cd7nng=  ;
X-YMail-OSG: qeYrzNUVM1kjVCy1bhMZPS4hqEB2o5uOTap5JBhVSQ1MIGO1AFLFThN1.ytvwGaq59T75H.uKUtfj1gE.OLWgBhBt35TDufx7HYZiHaTagaMdQiY_LPtflINMdl7MGw2wGa7sU48t_xI7sKkkCYXiKHj5C65scPsEQUrpHU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Date: Thu, 9 Oct 2008 02:34:40 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
References: <200809241251.32606.david-b@pacbell.net> <200810071114.03219.david-b@pacbell.net> <20081008094849.752a29c0@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081008094849.752a29c0@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810090234.41243.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008, Haavard Skinnemoen wrote:
>
> Ok, so the limitations of various chips vary a lot...which means that
> it's difficult to predict what IRQF_DEBOUNCED actually does.

The specific QOS achieved is system-specific; the term for
that kind of mechanism is "hinting".  It's very clearly defined
what the hint means .. but a given system might not use it.

The madvise(2) system call is a userspace example of hinting.

 
> > > What kind of guarantees should IRQF_DEBOUNCE provide? Filtering short
> > > glitches may be useful, but if drivers start assuming it will do real
> > > debouncing of badly filtered switches and buttons, I think we're in for
> > > some trouble...
> > 
> > The quality-of-service question rears its ugly head ... ;)
> > 
> > If QOS is exposed (e.g. "unsigned debounce_usec" in the irq_desc),
> > that sort of begs the question of how to *change* that.  I had
> > hoped to let someone else address the issue of such interfaces...
> > 
> > What would you think about advice to debounce by default on the
> > order of one millisecond, where hardware allows?  Later, ways
> > to query and update that QOS could be defined.
> 
> I suppose a good start would be to add a comment saying that.
> 
> On the other hand, I don't see how drivers can even tell if the
> hardware supports IRQF_DEBOUNCED at all...

That is, "On the other hand, 'later' is not yet..." ?

Are you suggesting that debouncing support shouldn't
be provided without QOS query/update support?


> > > > Having this mechanism in genirq would let boards remove a bunch of
> > > > nonportable code, and would let drivers like gpio_keys, gpio_mouse,
> > > > and various touchscreens work more reliably.  It'd also let various
> > > > SOC-specific MMC and CF card drivers switch over to more standard
> > > > (and widely understandable) mechanisms.
> > > > 
> > > > I'd like to submit such updates for the 2.6.28 merge window, in
> > > > part to let mainline avoid needing yet another driver-specific
> > > > programming interface for IRQ debouncing.  (For TWL4030/TPS659x0,
> > > > as used in most OMAP3 boards including the Gumstix Overo and the
> > > > BeagleBoard.)
> > > 
> > > Given that the limitations of this interface are clearly documented, I'm
> > > all for it.
> > 
> > What changes would you suggest in the $SUBJECT patch then?
> 
> Just a comment, really. But I realize that it's difficult to specify
> any guarantees since hardware may give you anything from a few
> nanoseconds to 30 ms...

Done:  "as close to 1 msec as hardware allows".  (I think less
than that is probably too little, and more would likely be OK.)

 
> > > What would be perhaps even more useful is generic software debouncing
> > > support. Something like
> > > 
> > >   int request_debounced_irq(int irq, unsigned long debounce_us,
> > > 		void (*handler)(void *data), void *data);

Note by the way what I think is a problematic assumption there:
that this *exact* debounce period matters.  It seems to be more
usual that it just fit into a range of reasonable values; a bit
more or less won't matter, almost by definition.

(And also, that routine is less functional than request_irq ...)


> > > which would set up a handler which disables the interrupt and sets up a
> > > timer which will ack/unmask the interrupt and run the handler.
> > 
> > Why require "software debouncing" if perhaps the hardware could do
> > it all for you?
> 
> Because of the "perhaps" part of your sentence.

I'm not sure which sentence you refer too, but the first
"perhaps" above is yours!  :)


> But ok, drivers really shouldn't have to care, so let's call it
> "generic debouncing support".

OK..

 
> > > This would mean the "interrupt handler" really gets run in softirq
> > > context, and shared interrupt would probably be impossible to support,
> > > but I think it would be useful for certain kinds of interrupts.
> > > 
> > > What do you think?
> > 
> > Seems plausible.
> > 
> > I won't volunteer to write such a thing myself, but I can easily
> > imagine it starting to grow users.  At least, in the embedded
> > Linux space ... the server/desktop crowd seems unlikely to run
> > with that sort of hardware.
> 
> Maybe we should just add this interface and drop the flag? 

What I like about the flag is that it's really simple, a
"fire and forget" model.  Easy for drivers to use.  And it
need not be incompatible with a fancier interface...

The debounce() method might usefully be changed to take the
requested delay in microseconds, instead of a boolean.  And
to return the actual delay.  That would make it easier to
support fancier calls later, maybe just exposing the raw
irq_chip call like

	usecs = set_irq_debounce(irq, range_spec);

The notion of a request_debounced_irq() needs more cooking
yet though, IMO.


> A flag will 
> never be able to convey some important parameters like how long to
> debounce.

But how important *is* that detail to most drivers?  In practice.
I susct pethey pick numbers today since they have to debounce with
software timers, which require numbers.


> Then a irq chip implementation can decide to do it in 
> hardware if the requested debounce delay matches what the hardware can
> provide.

I think irq_chip calls should be limited to hardware support.
Keep them really simple; put layers on top of them if needed.


> Maybe we should let drivers provide a range of acceptable delays so
> that the irq chip driver won't have to guess at how long it is
> acceptable to deviate from the specified delay.

I can't see it working otherwise.  Of course, maybe there should
just be generic ranges rather than expecting drivers to understand
how springy contacts might be on a given board, or how dirty they
may be to cause other kinds of chatter.

- Dave

