Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYIYXkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYIYXkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYIYXkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:40:32 -0400
Received: from mercury.realtime.net ([205.238.132.86]:38785 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbYIYXka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:40:30 -0400
From: "Milton Miller" <miltonm@bga.com>
To: Sebastien Dugue <sebastien.dugue@bull.net>,
       Milton Miller <miltonm@bga.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with hardirq preemption
X-Mailer: Quality Web Email v3.1t
X-Originating-IP: 32.97.110.142
Date: Thu, 25 Sep 2008 18:40:28 -0500
Message-id: <48dc216c.b3.9f2.577594313@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Authenticated-User: miltonm@bga.com 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I trimmed the cc list for the implementation discussion).
 
> On Wed, 24 Sep 2008 11:42:15 -0500 Milton Miller
> <miltonm@bga.com> wrote:
> 
> > On Sep 24, 2008, at 7:30 AM, Sebastien Dugue wrote:
> > >   Hi Milton,
> > > On Wed, 24 Sep 2008 04:58:22 -0500 (CDT) Milton Miller
> > > <miltonm@bga.com> wrote:
> > >> On Mon Sep 15 at 18:04:06 EST in 2008, Sebastien
> > Dugue wrote: >>> When entering the low level handler,
> > level sensitive interrupts are >>> masked, then eio'd in
> > interrupt context and then unmasked at the >>> end of
> > hardirq processing.  That's fine as any interrupt
> > comming >>> in-between will still be processed since the
> > kernel replays those >>> pending interrupts.
> > >>
> > >> Is this to generate some kind of software managed
> > nesting and priority >> of the hardware level
> > interrupts? >
> > >   No, not really. This is only to be sure to not miss
> > > interrupts coming from the same source that were
> > > received during threaded hardirq  processing.
> > > Some instrumentation showed that it never seems to
> > > happen in the eHEA interrupt case, so I think we can
> > > forget this aspect. 
> > I don't trust "the interrupt can never happen during hea
> > hardirq",  because I think there will be a race between
> > their rearming the next  interrupt and the unmask being
> > called.
> 
>   So do I, it was just to make sure I was not hit by
> another interrupt while handling the previous one and thus
> reduce the number of hypothesis.
> 
>   I sure do not say that it cannot happen, just that that
> path is not taken when I have the eHEA hang.
> 
> > I was trying to understand why the mask and early eoi,
> > but I guess its  to handle other more limited interrupt
> > controllers where the interrupts  stack in hardware
> > instead of software. 
> > >   Also, the problem only manifests with the eHEA RX
> > > interrupt. For  example,
> > > the IBM Power Raid (ipr) SCSI exhibits absolutely no
> > > problem under an  RT
> > > kernel. From this I conclude that:
> > >
> > >   IPR - PCI - XICS is OK
> > >   eHEA - IBMEBUS - XICS is broken with hardirq
> > preemption. >
> > >   I also checked that forcing the eHEA interrupt to
> > > take the non  threaded
> > > path does work.
> > 
> > For a long period of time, XICS dealt only with level
> > interrupts.    First Micro Channel, and later PCI buses.
> >  The IPI is made level by  software conventions. 
> > Recently, EHCA, EHEA, and MSI interrupts were  added
> > which by their nature are edge based.  The logic that
> > converts  those interrupts to the XICS layer is
> > responsible for the resend when  no cpu can accept them,
> > but not to retrigger after an EOI.
> 
>  OK
> 
> > 
> > >   Here is a side by side comparison of the fasteoi
> > > flow with and  without hardirq
> > > threading (sorry it's a bit wide)
> > (removed)
> > >   the non-threaded flow does (in interrupt context):
> > >
> > >     mask
> 
>   Whoops, my bad, in the non threaded case, there's no
> mask at all, only an unmask+eoi at the end, maybe that's
> an oversight!
 
No, not an oversight.  The point is, don't mask/unmask
between ack/eoi while handling the interrupt.  For many
irq controllers, the eoi must be done from the same cpu,
hence the mask and eoi before actually handling the
interrupt in the general case.   Its a feature of xics
that we don't have to play that game, but can do the
cpu and device eoi separately.
 
> > >     handle interrupt
> > >     unmask
> > >     eoi
> > >
> > >   the threaded flow does:
> > >
> > >     mask
> > >     eoi
> > >         handle interrupt
> > >         unmask
> > >
> > >   If I remove the mask() call, then the eHEA is no
> > > longer hanging. 
> > Hmm, I guess I'm confused.  You are saying the irq does
> > not appear if  it occurs while it is masked?
> 
>   Looks like it is, but I cannot say for sure, the only
> observable effect is that I do not get any more interrupts
> coming from the eHEA.
 
(removed features of xics)
 
 
>   That may be, but I'm only looking at the code (read no
> specifications at hand) and it looks like a black box to
> me.
 
"PowerPC External Interrupt Architecture" is defined in
appendix A of "Power.org™ Standard for 
Power Architecture™ Platform Requirements
(Workstation, Server)", available to Power.org members.
"The developer-level membership in Power.org is free."
(see www.power.org).
 
That said, it likely won't mention the eHEA in enough
detail to note that the interrupt gets cleared on
unmask.
 
On the other hand, I have actually seen the source
to implementations of the xics logic, so I have a
very good understanding of it (and know of a few
implementation "features", shall we say).
 
 
> > The path lengh for mask and unmask is always VERY slow
> > and single  threaded global lock and single context in
> > xics.  It is designed and  tuned to run at driver
> > startup and shutdown (and adapter reset and  reinitalize
> > during pci error processing), not during normal irq 
> > processing.
> 
>   Now, that is quite interesting then. Those mask() and
> unmask() should then be called shutdown() and startup()
> and not at each interrupt or am I misunderstanding you.
 
Basically, yes.  but linux likes to let drivers mask at
other times, and that is the facility we have.
 
> > The XICS hardware implicitly masks the specific source
> > as part of  interrupt ack (get_irq), and implicitly
> > undoes this mask at eoi.   In  addition, it helps to
> > manage the cpu priority by supplying the previous 
> priority as part of the get_irq process and providing for
> > the priority  to be restored (lowered only) as part of
> > the eoi.  The hardware does  support setting the cpu
> priority independently.
> 
>   This confirms, then, that the mask and unmask methods
> should be empty for the xics.
> 
> > 
> > We should only be using this implicit masking for xics,
> > and not the  explicit masking for any normal interrupt
> > processing.
> 
>   OK
> 
> >  I don't know if 
> > this means making the mask/unmask setting a bit in
> > software,
> 
>   Used by whom? 
 
The thought here was if we can't change the caller, then
maybe we could try to figure out what the caller was
trying to accomplish and defer what was requested based
on context.   Obviously, we are better off changing the
caller.
 
> 
> > and the 
> > enable/disable to actually call what we do now on
> > mask/unmask, or if it  means we need a new flow type on
> real time.
> 
>   Maybe a new flow type is not necessary considering what
> you said.
 
Maybe not, but I think it would be preferred ... we do have
the source to both sides.
 
> > While call to mask and unmask might work on level
> > interrupts, its  really slow and will limit performance
> > if done on every interrupt. 
> > >   the non-threaded flow does (in interrupt context):
> > >
> > >     mask
> 
>   Same Whoops, no mask is done in the non threaded case
I was just copying for context :=)
 
> > >     handle interrupt
> > >     unmask
> > >     eoi
> > >
> > >   the threaded flow does:
> > >
> > >     mask
> > >     eoi
> > >         handle interrupt
> > >         unmask
> > 
> > I think the flows we want on xics are:
> > 
> > (non-threaded)
> >     getirq (implicit source specific mask until eoi)
> >     handle interrupt
> >     eoi (implicit cpu priority restore)
> 
>   Yep
> 
> > 
> > (threaded)
> >     getirq (implicit source specific mask until eoi)
> >     explicit cpu priority restore
>         ^
>   How do you go about doing that? Still not clear to me.
 
xics_set_cpu_priority(0xff)
 
of course, there needs to be some kind of 
struct irq_chip method to call it.
 
> >     handle interrupt
> >     eoi (implicit cpu priority restore to same as
> > explicit level) 
> > Where the cpu priority restore allows receiving other
> > interrupts of the  same priority from the hardware.
> > 
> > So I guess the question is can the rt kernel interrupt
> > processing take  advantage of xics auto mask,
> 
>   It should, but even mainline could benefit from it I
> guess.
> 
 
I haven't looked, but are you implying mainline calls
mask and unmask for each interrupt, and not just when
the driver does unmask/mask/request/free?
 
Otherwise, I am not sure mainline is doing anything wrong.
 
> > or does someone need to write state 
> > tracking in the xics code to work around this, changing
> > mask under  interrupt to "defer eoi to unmask" (which I
> > can not see as clean, and  having shutdown problems).
> > 
>   Thanks a lot Milton for those explanations,
> 
>   Sebastien.
 
You're welcome.  I don't have time to work on the rt kernel,
but I'll be glad to help suggest an implementation that
works efficiently.
 
milton
