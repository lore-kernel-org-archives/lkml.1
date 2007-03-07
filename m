Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXCGUe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXCGUe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXCGUe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:34:26 -0500
Received: from www.osadl.org ([213.239.205.134]:43888 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965635AbXCGUeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:34:25 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EEF966.6060902@goop.org>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 21:40:32 +0100
Message-Id: <1173300032.24738.750.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 09:41 -0800, Jeremy Fitzhardinge wrote:
> Other hypervisors may take other approaches, depending on what the real
> underlying hardware is and the real requirements.  One could imagine a
> hypervisor exposing an hpet mapping, for example, or just having some
> kind of completely synthetic time source.
> 
> The point is that if we were to build an abstraction layer over all of
> these just so that we could have a single clocksource/event
> implementation, it would be pretty much equivalent to the existing clock
> infrastructure, and would add no value.

I tend to disagree. The clockevents infrastructure was designed to cope
with the existing mess of real hardware. The discussion over the last
days exposed me to even more exotic designs than the hardware vendors
were able to deliver until now.

> I was very pleased when I saw the clocksource/event mechanisms go into
> the kernel because it means different hypervisors can have a clock*
> implementation to match their own particular time model/interface
> without having to clutter up the pv_ops interface, and still have a
> well-defined interface to the rest of the kernel's time infrastructure.

I know exactly where you are heading:

Offload the handling of hypervisor design decisions to the kernel and
let us deal with that. So we need to implement 128 bit math to convert
back and forth and I expect more interesting things to creep up. 

All this is of _NO_ use and benefit for the kernel itself.

Real hardware copes well with relative deltas for the events, even when
it is match register based. I thought long about the support for
absolute expiry values in cycles and decided against them to avoid that
math hackery, which you folks now demand.

> I don't think having a clock implementation for each hypervisor is such
> a big deal.  The Xen one, for example, is 300 lines of straightforward code.
> 
> > Abstractions for the abstractions sake are braindead. There is no real
> > reason to implement 128 bit math into that path just to make the virtual
> > clockevent device look like real hardware.
> >
> > The abstraction of clockevents helps you to get rid of hardwired
> > hardware assumptions, but you insist on creating them artificially for
> > reasons which are beyond my grasp.
> >   
> The hypervisor may present abstracted time hardware, but there is real
> time hardware under there somewhere, and there are benefits to making
> the abstraction as thin as possible.

Yeah, it's much faster to do the conversion in the kernel and not in the
hypervisor thin layer. See also below.

> Xen chooses to express its time
> interfaces in ns and so is a good direct match for the Linux time
> infrastructure, but it still has to the 128-bit cycles<->ns conversion
> *somewhere*, because the underlying hardware is still using cycles.  It
> sounds like the VMWare folks have chosen to directly use cycles in order
> to avoid that conversion altogether.

Neither the host OS nor the hypervisors use cycles as the main unit for
their own time related code. They all have the required conversion code
already available.

The historical design of hypervisors was based on emulating the hardware
1:1. So the TSC needs to be a TSC and the LAPIC a LAPIC. 

Paravitualized guests can use smarter virtual hardware which is exposed
to the kernel. Using paravirtualization only to speed up the emulation
of legacy crap without thinking about the overall possible enhancements
is just backwards. 

Paravirtualization is a technique that presents a software interface to
virtual machines that is similar but not identical to that of the
underlying hardware.

clockevents allow you to do that easy and simple, but you insist on a
1:1 conversion of your current design and offload the legacy burden of
your historical hardware usage to the kernel developers. No thanks.

Also let's compare the code flow for a Linux guest on a Linux host:

cylces based:

program_next_event()
	convert to a virtual cycle value
	call into the emulated clock event device
		call into the hypervisor
			convert to nanoseconds
			arm a hrtimer
			convert to real hardware cycles

nanosecond based:

program_next_event()
	call into the emulated clock event device
		call into the hypervisor
			arm a hrtimer
			convert to real hardware cycles

> > Jeremy spent a couple of hours to get NO_HZ running for Xen yesterday
> > instead of writing up lengthy excuses, why it is soooo hard and takes
> > sooo much time and the current interface is sooo insufficient.
> >   
> 
> Yep, it worked out well.  The only warty thing in there is the asm
> 128-bit math needed in scale_delta() to convert tsc cycles to ns.  John
> Stultz had suggested (on a much earlier incarnation of this code) that
> it could be generally useful and could be hoisted to somewhere more
> common.  I've included the whole thing below.
> 
> /*
>  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
>  * yielding a 64-bit result.
>  */
> static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
> {
> 	u64 product;
> #ifdef __i386__
> 	u32 tmp1, tmp2;
> #endif
> 
> 	if (shift < 0)
> 		delta >>= -shift;
> 	else
> 		delta <<= shift;
> 
> #ifdef __i386__
> 	__asm__ (
> 		"mul  %5       ; "
> 		"mov  %4,%%eax ; "
> 		"mov  %%edx,%4 ; "
> 		"mul  %5       ; "
> 		"xor  %5,%5    ; "
> 		"add  %4,%%eax ; "
> 		"adc  %5,%%edx ; "
> 		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
> 		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
> #elif __x86_64__
> 	__asm__ (
> 		"mul %%rdx ; shrd $32,%%rdx,%%rax"
> 		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
> #else
> #error implement me!

Yay. Here we are. Once we move that stuff into the core kernel
infrastructure, we have to maintain that warty thing in the worst case
for 24 archs and educate people _NOT_ to use it on an 32 bit ARM 74Mhz
CPU. Those are the things we care about.

> static int xen_set_next_event(unsigned long delta,
> 			      struct clock_event_device *evt)
> {
> 	s64 event = startup_offset + ktime_to_ns(evt->next_event);
> 
> 	if (HYPERVISOR_set_timer_op(event) < 0)
> 		BUG();
>
> 	/* We may have missed the deadline, but there's no real way of
> 	   knowing for sure.  If the event was in the past, then we'll
> 	   get an immediate interrupt. */
> 
> 	return 0;
> }

Looks nice and should serve the purpose for everyone. Here is the real
point for a paravirt_ops() interface.

	return paravirt_ops->clockevent->set_next_event(vcpu, event);

That way all hypervisors can do with that what they want without
cluttering the kernel with their horrible design decisions.

> static const struct clock_event_device xen_clockevent = {
> 	.name = "xen",
> 	.features = CLOCK_EVT_FEAT_ONESHOT,
> 
> 	.max_delta_ns = 0x7fffffff,
> 	.min_delta_ns = 100,	/* ? */
> 
> 	.mult = 1<<XEN_SHIFT,
> 	.shift = XEN_SHIFT,

We can optimize this by skipping the conversion via a feature flag.

> 	.rating = 500,
> 
> 	.set_mode = xen_set_mode,
> 	.set_next_event = xen_set_next_event,
> };
> static DEFINE_PER_CPU(struct clock_event_device, xen_clock_events);

Your implementation is almost the perfect prototype, if you move the
128 bit hackery into the hypervisor and hide it away from the kernel :)

One of these is perfectly fine for _ALL_ of the hypervisor folks.
Anything else is just a backwards decision for the kernel.

We can guarantee that we can and will fix up the 200 lines of code for a
sane clocksource and a clockevent emulation in case we modify those
interfaces, while keeping keeping the specified and agreed paravirt ops
interface intact, but I have ZERO interest to support and fixup 10
different implementations of glue layers with 20 different ways of
making the core clock code horrible.

Again: Imposing the per hypervisor idea of emulation is just backwards.

Create a shared set of interfaces into the hypervisor and do there
whatever you want and need to do. That's what was discussed at the
Kernel Summit in essence. paravirt ops are there to avoid the burden of
maintainence for the various flavours of hypervisor crack and not to
make an easy backdoor to sneak it in and let us have the brain damage.

	tglx


