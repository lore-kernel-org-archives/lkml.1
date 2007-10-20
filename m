Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbXJTEEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbXJTEEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJTEER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:04:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:54602 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbXJTEEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:04:15 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <alpine.LFD.0.999.0710191924520.3794@woody.linux-foundation.org>
References: <1192670742.12879.5.camel@pasglop>
	 <200710200402.43106.maximlevitsky@gmail.com>
	 <alpine.LFD.0.999.0710191924520.3794@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 14:04:04 +1000
Message-Id: <1192853044.17235.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 19:25 -0700, Linus Torvalds wrote:
> 
> On Sat, 20 Oct 2007, Maxim Levitsky wrote:
> > 
> > and the interrupt handler:
> > 
> > 	smp_rmb();
> > 	if (dev->insuspend)
> > 		goto out;
> 
> Something like that can work, yes. However, you need to make sure that:
> 
>  - even when you ignore the interrupt (because the driver doesn't care, 
>    it's suspending), you need to make sure the hardware gets shut up by 
>    reading (or writing) the proper interrupt status register.
>
>    Otherwise, with a level interrupt, the interrupt will continue to be 
>    held active ("screaming") and the CPU will get interrupted over and 
>    over again, until the irq subsystem will just turn the irq off 
>    entirely.

His suspend routine wrote to the IRQ mask (or equivalent) register in
his code example, thus the HW should shut up eventually, thus that isn't
strictly necessary, the IRQ in that case is just a "short
interrupt" (noticed by the PIC and delivered but possibly not asserted
anymore at this stage or about to go down).

We have many scenario generating such short interrupts (pretty much any
time we use interrupt disable/enable on the chip, for example it's
common with NAPI).

This is one of the reasons why we used to have a "timebomb" causing an
IRQ to erroneously get disabled by the IRQ core assuming the IRQ was
stuck, just because we accumulated too many short interrupts on that
line. A recent patch by Alan fixed that to use some more sensible
algorithm checking the time since the last spurrious interrupt, though I
suspect he's being too optimistic on his timeout value and some
scenario, such as NAPI with just the wrong packet rate, can still
trigger the bug. I need  to find a piece of HW slow enough in
de-asserting the IRQ to try to make a repro-case one of these days.

>  - when you resume, make sure that you get the engine going again, with 
>    the understanding that some interrupts may have gotten ignored.

And you forgot that he still needs synchronize_irq(), or his IRQ handler
might well be in the middle of doing something on another CPU, past the
point where it tested "insuspend", which will do no good when a
simultaneous pci_set_power_state() puts the chip into D3. On some
machines, this will machine check. Either that or he needs a spinlock in
his IRQ handler that he also takes around the code that sets insuspend. 

> Also, in general, these kinds of things shouldn't always even be 
> neicessary. If you use the suspend_late()/resume_early() hooks, those will 
> be called with interrupts off, and while they can be harder to debug (and 
> may be worth avoiding for non-critical drivers), they do allow for simpler 
> models partly exactly because they don't need to worry about interrupts 
> etc.

Yes, this is a easier way to deal with devices that are on a directly
mapped bus (path to them isn't gone by the time you hit suspend_late)
and don't need to do fancy things involing waiting for a queue to drain
using interrupts etc... (at one stage of HW complexity, having to
re-implement polled versions of everything is just not worth the
benefit). In general, suspend_late should cover the need of most PCI
devices I suppose.

Ben.


