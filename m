Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXCHVkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXCHVkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030664AbXCHVkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:40:02 -0500
Received: from mail.suse.de ([195.135.220.2]:54436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030480AbXCHVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:40:00 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zachary Amsden <zach@vmware.com>
Subject: Re: hardwired VMI crap
Date: Thu, 8 Mar 2007 22:39:44 +0100
User-Agent: KMail/1.9.5
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Daniel Arai <arai@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <45EE1EA3.90803@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com>
In-Reply-To: <45F0761C.6060107@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082239.44585.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 21:46, Zachary Amsden wrote:
> Thomas Gleixner wrote:
> > On Thu, 2007-03-08 at 02:06 -0800, Zachary Amsden wrote:
> >   
> >>>> The correct solution here is to properly separate the APIC, SMP, and 
> >>>> timer code so the logic of it which we want to reuse is separated from 
> >>>> the hardware dependence.  Clock events and clocksources take care of 
> >>>> most of the timer issues, but there is still ugliness from SMP timer 
> >>>> events depending on having part of the APIC infrastructure for wiring 
> >>>> the interrupt gates.
> >>>>     
> >>>>         
> >>> what are you talking about? A clockevents driver does not need to know 
> >>> about lapic details, at all. In terms of interrupt gates for the 
> >>> hypervisor to notify about clock events - use a virtual interrupt 
> >>> controller via genirq.
> >>>   
> >>>       
> >> See my last e-mail.  It is not possible on i386, since local per-cpu 
> >> interrupts are only supported via the APIC.
> >>     
> >
> > It is not possible from your POV. It is possible, as we have already a
> > complete irq abstraction layer, which supports _ALL_ of the
> > requirements.
> >
> > To make use of it in a maintainable way, it just needs the work of doing
> > a proper client for the genirq layer, which get's its interrupt injected
> > by the hypervisor.
> >
> > genirq() does not care by which mechanism handle_percpu_irq() is called.
> >
> > We provided the abstractions and you just tell us straight in the face,
> > that your hypervisor works that way and therefor we have to accept that
> > you do it that way.
> >
> > It's not rocket science to implement an abstract interrupt controller,
> > which lets you inject per cpu or global interrupts into the generic
> > layer. It needs some preparatory work to distangle the boot code
> > assumptions from the implicit hardware, but this is a better spent time,
> > than another set of hackery, which you already advertised for smpboot.c
> >   
> 
> When we're about two weeks away from a product release and you are 
> threatening to unmerge or block our code because we didn't create an 
> abstract interrupt controller,

At least in Linux we don't really work with deadlines; if there 
are issues they need to be fixed even if it takes longer. I don't 
expect the version in .21 to be really usable anyways; it is clearly
still in development.

> we re-used the APIC and IO-APIC, this is  
> uber rocket science.  We've been doing things this way, with public 
> patches for over a year, and you've even been CC'd on some of the 
> discussions.  So it is a little late to tell us - "redesign your 
> hypervisor, or else.."

It shouldn't touch the hypervisor, just the paravirt VMI backend shouldn't it?
I assume you could do a very minimal APIC layer that is just enough to 
talk to your softapic and a genapic backend for IPIs.

At least I would welcome anything that shrinks the number of 
paravirt hooks.

I'm just not sure it would be less hooks: you would probably need
functions to start other CPUs at least.
 
I must admit I also didn't quite get what was the big problem with
hooking apic_read/apic_write.

For the timer you just need to use a own exclusive 
clocksource that never touches PIT.

> We faithfully emulate lapic, io_apic, the pit, pic, and a normal 
> interrupt subsystem. We can't magically stop using these things because  
> we have to support traditional full virtualization.  Which means any 
> version of Linux, virtual interrupt controller or not, is going to boot 
> up, find these things, and try to use them.  So for a paravirt kernel, 
> either we have to disable each of these things in the Linux code or just 
> re-use them.

If you don't enable them they should be already disabled as default 
state, shouldn't they? 

With an own custom clocksource and possible own APIC layer nobody
would ever enable the APICs.

> 1) Rewrite the interrupt subsystem of our hypervisor, making it 
> incompatible with full virtualization, so that we can support an 
> abstract interrupt controller with a "clean" interface

What do you mean with rewrite? It's quite easy to add a new
backend to the generic IRQ code. They aren't a lot of code.

> 2) Reuse the same method that HPET, PIT and other time clients in i386 
> use - the global_clock_event pointer which allows you to wrest control 
> back from the APIC and reuse the lapic_events local clockevents.

If you used an own APIC layer APIC would never get control at all.

> 3) Create a new low level interrupt handler for the per-cpu VMI timer 
> IRQs instead of re-using the APIC handler
> 4) Use the irq APIs to allocate IRQ-0 as a percpu IRQ, then change the 
> IO-APIC code so it can know not to convert this PIC IRQ into a IO-APIC 
> edge IRQ.
> 5) Disable the io-apic code entirely in paravirt mode.  Rather than 
> change it, merge a parallel copy of it into the VMI code
>  so that we can use the 99% of the code we need, with the one bugfix for 
> #4 above

You could probably do a much simpler version, couldn't you? A lot of 
the stuff in apic.c/io_apic.c shouldn't be needed for a clean virtual
interface. But yes it would probably be still a lot of code.

Still (2) is probably best for now, but the other alternatives
are not as ridiculous as you paint them.


-Andi
