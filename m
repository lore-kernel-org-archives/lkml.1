Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYIYIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYIYIqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYIYIqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:46:07 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60905 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYIYIqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:46:05 -0400
Date: Thu, 25 Sep 2008 10:45:52 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Milton Miller <miltonm@bga.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Christoph Raisch <RAISCH@de.ibm.com>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
 hardirq preemption
Message-ID: <20080925104552.05bd3eb3@bull.net>
In-Reply-To: <0fa2693104ff3250114d82837911b9e8@bga.com>
References: <200809231743.23828.ossthema@de.ibm.com>
	<20080915100406.342e027a@bull.net>
	<200809240958.m8O9wM7k010996@sullivan.realtime.net>
	<20080924143055.6102f317@bull.net>
	<0fa2693104ff3250114d82837911b9e8@bga.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 11:42:15 -0500 Milton Miller <miltonm@bga.com> wrote:

> On Sep 24, 2008, at 7:30 AM, Sebastien Dugue wrote:
> >   Hi Milton,
> > On Wed, 24 Sep 2008 04:58:22 -0500 (CDT) Milton Miller 
> > <miltonm@bga.com> wrote:
> >> On Mon Sep 15 at 18:04:06 EST in 2008, Sebastien Dugue wrote:
> >>> When entering the low level handler, level sensitive interrupts are
> >>> masked, then eio'd in interrupt context and then unmasked at the
> >>> end of hardirq processing.  That's fine as any interrupt comming
> >>> in-between will still be processed since the kernel replays those
> >>> pending interrupts.
> >>
> >> Is this to generate some kind of software managed nesting and priority
> >> of the hardware level interrupts?
> >
> >   No, not really. This is only to be sure to not miss interrupts coming
> > from the same source that were received during threaded hardirq 
> > processing.
> > Some instrumentation showed that it never seems to happen in the eHEA
> > interrupt case, so I think we can forget this aspect.
> 
> I don't trust "the interrupt can never happen during hea hardirq", 
> because I think there will be a race between their rearming the next 
> interrupt and the unmask being called.

  So do I, it was just to make sure I was not hit by another interrupt while
handling the previous one and thus reduce the number of hypothesis.

  I sure do not say that it cannot happen, just that that path is not taken
when I have the eHEA hang.

> 
> I was trying to understand why the mask and early eoi, but I guess its 
> to handle other more limited interrupt controllers where the interrupts 
> stack in hardware instead of software.
> 
> >   Also, the problem only manifests with the eHEA RX interrupt. For 
> > example,
> > the IBM Power Raid (ipr) SCSI exhibits absolutely no problem under an 
> > RT
> > kernel. From this I conclude that:
> >
> >   IPR - PCI - XICS is OK
> >   eHEA - IBMEBUS - XICS is broken with hardirq preemption.
> >
> >   I also checked that forcing the eHEA interrupt to take the non 
> > threaded
> > path does work.
> 
> For a long period of time, XICS dealt only with level interrupts.   
> First Micro Channel, and later PCI buses.  The IPI is made level by 
> software conventions.  Recently, EHCA, EHEA, and MSI interrupts were 
> added which by their nature are edge based.  The logic that converts 
> those interrupts to the XICS layer is responsible for the resend when 
> no cpu can accept them, but not to retrigger after an EOI.

 OK

> 
> >   Here is a side by side comparison of the fasteoi flow with and 
> > without hardirq
> > threading (sorry it's a bit wide)
> (removed)
> >   the non-threaded flow does (in interrupt context):
> >
> >     mask

  Whoops, my bad, in the non threaded case, there's no mask at all, only an
unmask+eoi at the end, maybe that's an oversight!


> >     handle interrupt
> >     unmask
> >     eoi
> >
> >   the threaded flow does:
> >
> >     mask
> >     eoi
> > 		handle interrupt
> > 		unmask
> >
> >   If I remove the mask() call, then the eHEA is no longer hanging.
> 
> Hmm, I guess I'm confused.  You are saying the irq does not appear if 
> it occurs while it is masked?

  Looks like it is, but I cannot say for sure, the only observable effect
is that I do not get any more interrupts coming from the eHEA.

>  Well, in that case, I would guess that 
> the hypervisor is checking if the irq is previously pending while it 
> was masked and resetting it as part of the unmask.   It can't do it on 
> level, but can on the true edge sources.  I would further say the 
> justification for this might be the hardware might make it pending from 
> some previous stale event that might result in the false interrupt on 
> startup were it not to do this clear.
> 
> >> The reason I ask is the xics controller can do unlimited nesting
> >> of hardware interrupts.  In fact, the hardware has 255 levels of
> >> priority, of which 16 or so are reserved by the hypervisor, leaving
> >> over 200 for the os to manage.  Higher numbers are lower in priority,
> >> and the hardware will only dispatch an interrupt to a given cpu if
> >> it is currenty at a lower priority.  If it is at a higher priority
> >> and the interrupt is not bound to a specific cpu it will look for
> >> another cpu to dispatch it.  The hardware will not re-present an
> >> irq until the it is EOId (managed by a small state machine per
> >> interrupt at the source, which also handles no cpu available try
> >> again later), but software can return its cpu priority to the
> >> previous level to recieve other interrupt sources at the same level.
> >> The hardware also supports lazy update of the cpu priority register
> >> when an interrupt is presented; as long as the cpu is hard-irq
> >> enabled it can take the irq then write is real priority and let the
> >> hw decide if the irq is still pending or it must defer or try another
> >> cpu in the rejection scenerio.  The only restriction is that the
> >> EOI can not cause an interrupt reject by raising the priority while
> >> sending the EOI command.
> >>
> >> The per-interrupt mask and unmask calls have to go through RTAS, a
> >> single-threaded global context, which in addition to increasing
> >> path length will really limit scalability.  The interrupt controller
> >> poll and reject facilities are accessed through hypervisor calls
> >> which are comparable to a fast syscall, and parallel to all cpus.
> >>
> >> We used to lower the priority to allow other interrupts in, but we
> >> realized that in addition to the questionable latency in doing so,
> >> it only caused unlimited stack nesting and overflow without per-irq
> >> stacks.  We currently set IPIs above other irqs so we typically
> >> only process them during a hard irq (but we return to base level
> >> after IPI and could take another base irq, a bug).
> >>
> >>
> >> So, Sebastien, with this information, is does the RT kernel have
> >> a strategy that better matches this hardware?
> >
> >   Don't think so. I think that the problem may be elsewhere as
> > everything is fine with PCI devices (well at least SCSI).
> 
> Those are true level sources, and not edge.

  Right.

> 
> >   As I said earlier in another mail, it seems that the eHEA
> > is behaving as if it was generating edge interrupts which do not
> > support masking. Don't know.
> 
> (I wrote this next paragraph before parsing the "remove mask and it 
> works" / I'm confused paragraph above, so it may not be a problem).
> 
> These sources are truly edge.  Once you do an EOI you are taking 
> responsibility to do the replay yourself.  In your threaded case, you 
> EOI and therefore the hardware will arm for the next event.  When you 
> add the mask, the delivery is deferred until it is unmasked at the end 
> of your EOI loop.  When you do not, the new interrupt may come in but 
> you just EOI it but do not tell the running thread that it happened, 
> then you are dropping the irq event.   Since the source is truly edge, 
> there is no hardware replay and the interrupt is lost.
> 
> (I think the pci express gigabit is one of the few msi interrupt 
> adapters that both IBM and Linux support).
> 
> >   Thanks a lot for the explanation, looks like the xics + hypervisor
> > combo is way more complex than I thought.
> 
> While the hypervisor adds a bit of path length (an hcall vs a single 
> mmio access for get_irq/eoi with multiple priority irq nesting), the 
> model is no more or less complicated than native xics.

  That may be, but I'm only looking at the code (read no specifications at hand)
and it looks like a black box to me.

> 
> The path lengh for mask and unmask is always VERY slow and single 
> threaded global lock and single context in xics.  It is designed and 
> tuned to run at driver startup and shutdown (and adapter reset and 
> reinitalize during pci error processing), not during normal irq 
> processing.

  Now, that is quite interesting then. Those mask() and unmask() should then
be called shutdown() and startup() and not at each interrupt or am I
misunderstanding you.

> 
> The XICS hardware implicitly masks the specific source as part of 
> interrupt ack (get_irq), and implicitly undoes this mask at eoi.   In 
> addition, it helps to manage the cpu priority by supplying the previous 
> priority as part of the get_irq process and providing for the priority 
> to be restored (lowered only) as part of the eoi.  The hardware does 
> support setting the cpu priority independently.

  This confirms, then, that the mask and unmask methods should be empty
for the xics.

> 
> We should only be using this implicit masking for xics, and not the 
> explicit masking for any normal interrupt processing.

  OK

>  I don't know if 
> this means making the mask/unmask setting a bit in software,

  Used by whom? 

> and the 
> enable/disable to actually call what we do now on mask/unmask, or if it 
> means we need a new flow type on real time.

  Maybe a new flow type is not necessary considering what you said.

> 
> While call to mask and unmask might work on level interrupts, its 
> really slow and will limit performance if done on every interrupt.
> 
> >   the non-threaded flow does (in interrupt context):
> >
> >     mask

  Same Whoops, no mask is done in the non threaded case

> >     handle interrupt
> >     unmask
> >     eoi
> >
> >   the threaded flow does:
> >
> >     mask
> >     eoi
> > 		handle interrupt
> > 		unmask
> 
> I think the flows we want on xics are:
> 
> (non-threaded)
> 	getirq (implicit source specific mask until eoi)
> 	handle interrupt
> 	eoi (implicit cpu priority restore)

  Yep

> 
> (threaded)
> 	getirq (implicit source specific mask until eoi)
> 	explicit cpu priority restore
        ^
  How do you go about doing that? Still not clear to me.

> 	handle interrupt
> 	eoi (implicit cpu priority restore to same as explicit level)
> 
> Where the cpu priority restore allows receiving other interrupts of the 
> same priority from the hardware.
> 
> So I guess the question is can the rt kernel interrupt processing take 
> advantage of xics auto mask,

  It should, but even mainline could benefit from it I guess.

> or does someone need to write state 
> tracking in the xics code to work around this, changing mask under 
> interrupt to "defer eoi to unmask" (which I can not see as clean, and 
> having shutdown problems).


  Thanks a lot Milton for those explanations,


  Sebastien.







