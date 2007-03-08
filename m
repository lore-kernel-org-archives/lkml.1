Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbXCHLDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbXCHLDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXCHLDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:03:06 -0500
Received: from www.osadl.org ([213.239.205.134]:48606 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211AbXCHLDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:03:04 -0500
Subject: Re: hardwired VMI crap
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Zachary Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45EFE010.7080108@vmware.com>
References: <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org> <Line.LNX.4.64.0703071304080.1851@d.namei>
	 <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com>
	 <1173302503.24738.795.camel@localhost.localdomain>
	 <45EF372E.7030600@goop.org>
	 <1173308717.24738.898.camel@localhost.localdomain>
	 <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu>
	 <45EFE010.7080108@vmware.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 12:09:14 +0100
Message-Id: <1173352154.24738.1023.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 02:06 -0800, Zachary Amsden wrote:
> >> The correct solution here is to properly separate the APIC, SMP, and 
> >> timer code so the logic of it which we want to reuse is separated from 
> >> the hardware dependence.  Clock events and clocksources take care of 
> >> most of the timer issues, but there is still ugliness from SMP timer 
> >> events depending on having part of the APIC infrastructure for wiring 
> >> the interrupt gates.
> >>     
> >
> > what are you talking about? A clockevents driver does not need to know 
> > about lapic details, at all. In terms of interrupt gates for the 
> > hypervisor to notify about clock events - use a virtual interrupt 
> > controller via genirq.
> >   
> 
> See my last e-mail.  It is not possible on i386, since local per-cpu 
> interrupts are only supported via the APIC.

It is not possible from your POV. It is possible, as we have already a
complete irq abstraction layer, which supports _ALL_ of the
requirements.

To make use of it in a maintainable way, it just needs the work of doing
a proper client for the genirq layer, which get's its interrupt injected
by the hypervisor.

genirq() does not care by which mechanism handle_percpu_irq() is called.

We provided the abstractions and you just tell us straight in the face,
that your hypervisor works that way and therefor we have to accept that
you do it that way.

It's not rocket science to implement an abstract interrupt controller,
which lets you inject per cpu or global interrupts into the generic
layer. It needs some preparatory work to distangle the boot code
assumptions from the implicit hardware, but this is a better spent time,
than another set of hackery, which you already advertised for smpboot.c

All we want you and the other hypervisor folks to do is to 

- use existing abstractions in the way they are designed
- create new ones where applicable
- break the hardwired hardware assumptions, so a sane emulation model
can be used.

This is a one time effort and of value for everyone and it is even
portable and reusable outside of i386. 

Nobody wants to prevent you of using existing facilities of the kernel
code. All we ask for is to use them in a sane way without hardwiring the
particular backend oddities all over the place.

This all is rushed in with the great promise, that it will be cleaned up
somewhere in the future, but this is not some random self contained
driver we talk about. It reaches into the guts of the kernel code and
once it is there we have to deal with it until the great promise is
fulfilled.

> > if you want to use hardwired hardware details as your API: DO IT WITHOUT 
> > MODIFYING LINUX. If you want anything more intelligent, something more 
> > 'paravirtual' - WORK WITH US AND WORK WITH THE OTHER HYPERVISORS. So far 
> > all i've seen from you was excuses and stonewalling on every step! We 
> >   
> 
> So far, all you have done is not complain about our code until it was 
> merged, the pursue every tactic possible to break it.  It is not us that 
> are stonewalling.

You have been told before. Andi asked you more than once to move to
clockevents.

I know its my fault that I just did not take enough time to look in
detail into the whole paravirt business before - mostly because I made
wrong assumptions about the design and intent of paravirt ops.

> In the meantime, having code that uses slightly older interfaces in the 
> kernel tree is not wrong in any way - it is pragmatic, because that code 
> is working today, and not only that, the sanest thing to do in a release 
> cycle.  And our code in the tree to be released imposes zero burden on 
> anyone except for us.  Are we stopping you from rewriting the timer 
> subsystem in the -rc tree?  How?  Because this code is supposed to be 
> settled.  Your deliberate breaking of our code forces us to come up with 
> workarounds that might be considered inappropriate, but nevertheless, 
> necessary.  Who has to deal with and adapt to this?  Certainly not you.  
> The burden to maintain the correctness of our code is on us.

That's just aside of reality. The reality is:

Ingo, Andi or I change code and it breaks one of the reachouts. Now this
get detected in -rc5 and gets a blocking issue. Report comes from user
and there is no time to fix it proper. The commit gets identified and it
simply falls back on us to fix it or revert the original patch.

Just look at it how it works. Dynticks break whatever crude assumption
in a driver and I have to spend my time on fixing it. We have enough
shit already there, which we break by such changes. No need to add
another steaming pile of it, which lures there to catch us.

If you can not change your hypervisor model to use a sane abstraction of
interrupts, then please emulate lapic, io_apic and everything else
_OUTSIDE_ of the kernel.

	tglx


