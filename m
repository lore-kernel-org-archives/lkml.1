Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYIZMBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYIZMBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYIZMB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:01:27 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57232 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYIZMB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:01:26 -0400
Date: Fri, 26 Sep 2008 11:16:37 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: "Milton Miller" <miltonm@bga.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
 hardirq preemption
Message-ID: <20080926111637.496e7960@bull.net>
In-Reply-To: <48dc216c.b3.9f2.577594313@bga.com>
References: <48dc216c.b3.9f2.577594313@bga.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 18:40:28 -0500 "Milton Miller" <miltonm@bga.com> wrote:

> (I trimmed the cc list for the implementation discussion).

  Yep, good thing.

<snip>

> > 
> >   Whoops, my bad, in the non threaded case, there's no
> > mask at all, only an unmask+eoi at the end, maybe that's
> > an oversight!
>  
> No, not an oversight.  The point is, don't mask/unmask
> between ack/eoi while handling the interrupt.  For many
> irq controllers, the eoi must be done from the same cpu,
> hence the mask and eoi before actually handling the
> interrupt in the general case.   Its a feature of xics
> that we don't have to play that game, but can do the
> cpu and device eoi separately.

  Ok, will try to play with this a bit more.

<snip>

>  
> >   That may be, but I'm only looking at the code (read no
> > specifications at hand) and it looks like a black box to
> > me.
>  
> "PowerPC External Interrupt Architecture" is defined in
> appendix A of "Power.org Standard for 
> Power Architecture Platform Requirements
> (Workstation, Server)", available to Power.org members.
> "The developer-level membership in Power.org is free."
> (see www.power.org).

  I already have that one and started to dig into the interrupt stuff, but as
with all normative stuff it's boring to the extreme and not always without
flaws. Looks like I know what I'll be reading this WE.

>  
> That said, it likely won't mention the eHEA in enough
> detail to note that the interrupt gets cleared on
> unmask.
>  
> On the other hand, I have actually seen the source
> to implementations of the xics logic, so I have a
> very good understanding of it (and know of a few
> implementation "features", shall we say).

  Good to know.

>  
>  
> > > The path lengh for mask and unmask is always VERY slow
> > > and single  threaded global lock and single context in
> > > xics.  It is designed and  tuned to run at driver
> > > startup and shutdown (and adapter reset and  reinitalize
> > > during pci error processing), not during normal irq 
> > > processing.
> > 
> >   Now, that is quite interesting then. Those mask() and
> > unmask() should then be called shutdown() and startup()
> > and not at each interrupt or am I misunderstanding you.
>  
> Basically, yes.  but linux likes to let drivers mask at
> other times, and that is the facility we have.

  Darn, do those drivers really need that heavywheight masking
at the source or something simpler could be accomplished by
fiddling with the processor priority in mask and unmask?

>  
> > > The XICS hardware implicitly masks the specific source
> > > as part of  interrupt ack (get_irq), and implicitly
> > > undoes this mask at eoi.   In  addition, it helps to
> > > manage the cpu priority by supplying the previous 
> > priority as part of the get_irq process and providing for
> > > the priority  to be restored (lowered only) as part of
> > > the eoi.  The hardware does  support setting the cpu
> > priority independently.
> > 
> >   This confirms, then, that the mask and unmask methods
> > should be empty for the xics.
> > 
> > > 
> > > We should only be using this implicit masking for xics,
> > > and not the  explicit masking for any normal interrupt
> > > processing.
> > 
> >   OK
> > 
> > >  I don't know if 
> > > this means making the mask/unmask setting a bit in
> > > software,
> > 
> >   Used by whom? 
>  
> The thought here was if we can't change the caller, then
> maybe we could try to figure out what the caller was
> trying to accomplish and defer what was requested based
> on context.   Obviously, we are better off changing the
> caller.

  That will not be so easy as we'll change behaviour for every user of
the genirq layer.

>  
> > 
> > > and the 
> > > enable/disable to actually call what we do now on
> > > mask/unmask, or if it  means we need a new flow type on
> > real time.
> > 
> >   Maybe a new flow type is not necessary considering what
> > you said.
>  
> Maybe not, but I think it would be preferred ... we do have
> the source to both sides.

  That's straightforward to do in the non threaded case, however, in the
threaded case the xics code would have to also manage the hardirq thread
as we would not be able to reuse the generic one (because of the unmask it
does at the very end).

<snip>

> > > I think the flows we want on xics are:
> > > 
> > > (non-threaded)
> > >     getirq (implicit source specific mask until eoi)
> > >     handle interrupt
> > >     eoi (implicit cpu priority restore)
> > 
> >   Yep
> > 
> > > 
> > > (threaded)
> > >     getirq (implicit source specific mask until eoi)
> > >     explicit cpu priority restore
> >         ^
> >   How do you go about doing that? Still not clear to me.
>  
> xics_set_cpu_priority(0xff)

  OK

>  
> of course, there needs to be some kind of 
> struct irq_chip method to call it.

  Yep, excepted that it's currently not provided by irq_chip.

>  
> > >     handle interrupt
> > >     eoi (implicit cpu priority restore to same as
> > > explicit level) 
> > > Where the cpu priority restore allows receiving other
> > > interrupts of the  same priority from the hardware.
> > > 
> > > So I guess the question is can the rt kernel interrupt
> > > processing take  advantage of xics auto mask,
> > 
> >   It should, but even mainline could benefit from it I
> > guess.
> > 
>  
> I haven't looked, but are you implying mainline calls
> mask and unmask for each interrupt, and not just when
> the driver does unmask/mask/request/free?

  Nope you're right, I got confused. I only looked at the non threaded case
under preempt-rt which does unmask + eoi (without mask) whereas mainline
only does eoi

>  
> Otherwise, I am not sure mainline is doing anything wrong.
>  

  Right

> > > or does someone need to write state 
> > > tracking in the xics code to work around this, changing
> > > mask under  interrupt to "defer eoi to unmask" (which I
> > > can not see as clean, and  having shutdown problems).
> > > 
> >   Thanks a lot Milton for those explanations,
> > 
> >   Sebastien.
>  
> You're welcome.  I don't have time to work on the rt kernel,
> but I'll be glad to help suggest an implementation that
> works efficiently.
>  
  Thanks a lot,

  Sebastien.
