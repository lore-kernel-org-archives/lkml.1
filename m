Return-Path: <linux-kernel-owner+w=401wt.eu-S937772AbXG3Iz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937772AbXG3Iz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbXG3IzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:55:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58121 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760666AbXG3IzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:55:12 -0400
Date: Mon, 30 Jul 2007 14:37:26 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070730083259.GD9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in>
References: <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org>
 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in>
 <20070730083259.GD9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, 30 Jul 2007, Rodolfo Giometti wrote:

> On Mon, Jul 30, 2007 at 09:49:20AM +0530, Satyam Sharma wrote:
> > 
> > Hmm? I still don't see why you can't introduce spin_lock_irqsave/restore()
> > in pps_event() around the access to pps_source.
> 
> In pps_event() is not useful using spin_lock_irqsave/restore() since
> the only difference between spin_lock_irqsave() and spin_lock() is
> that the former will turn off interrupts if they are on, otherwise
> does nothing (if we are already in an interrupt handler).

Yup. But two pps_event()'s on different CPU's could still race.


> Maybe you meant I should using spin_lock_irqsave/restore() in user
> context, but doing like this I will disable interrupts

Yup, but the goal is to avoid races. Otherwise why bother doing any
locking at all?


> and I don't
> wish doing it since, in this manner, the interrupt handler will be
> delayed and the (probably) PPS event recording will be wrong. I
> prefere loosing the event that registering it at delayed time.

What you're risking is not "losing an event" (which, btw, you should
not be, either), but a *deadlock*.


> > > About using both mutex and spinlock I did it since (I think) I should
> > > protect syscalls from each others and from pps_register/unregister(),
> > > and pps_event() against pps_register/unregister().
> > 
> > Nopes, it's not about protecting code from each other, you're needlessly
> > complicating things. Locking is pretty simple, really -- any shared data,
> > that can be concurrently accessed by multiple threads (or from interrupts)
> > must be protected with a lock. Note that *data* is protected by a lock,
> > and not "code" that handles it (well, this is the kind of behaviour most
> > cases need, at least, including yours).
> 
> Of course, I meant "protecting data". In fact to protect pps_source[]
> I need spin_lock() to protect user context from interrupt context and
> mutex to protect user context from itself.

But that's nonsensical! That's not how you implement locking!

First, spin_lock() is *not* enough to protect access from process context
from access from interrupt context.

Second, if you *already* have a lock to protect any data, introducing
*another* lock to protect the same data is ... utterly crazy!


> > So here we're introducing the lock to protect *pps_source*, and not keep
> > *threads* of execution from stepping over each other. So, simply, just
> > ensure you grab the lock whenever you want to start accessing the shared
> > data, and release it when you're done.
> 
> I see. But consider pps_register_source(). This function should
> provide protection of pps_source against both interrupt context
> (pps_event()) and user context (maybe pps_unregister_source() or one
> syscalls). Using only mutex is not possible, since we cannot use mutex
> in interrupt context, and using only spin_locks is not possible since
> in UP() they became void.

Yup, but that's okay. On UP, spin_lock_irqsave() becomes local_irq_save()
which is what you want anyway on UP.


> Can you please show me how I could write pps_register_source() in
> order to be correct from your point of view?

The simplest, most straightforward, and safest, most correct, way would
be to just use spin_lock_irqsave/restore() to around all access to the
shared/global data, from _any_ context.

Anyway, I'll try and see if I find some time this week to implement
what I was mentioning ...


> > The _irqsave/restore() variants are required because (say) one of the
> > syscalls executing in process context grabs the spinlock. Then, before it
> > has released it, it gets interrupted and pps_event() begins executing.
> > Now pps_event() also wants to grab the lock, but the syscall already
> > has it, so will continue spinning and deadlock!
> 
> That's the point. I don't wish using _irqsave/restore() since they may
> delay interrupt handler execution. As above, I prefere loosing the
> event then registering it at wrong time.

Ok, think of it this way -- you don't have an option. You just *have*
to use them. As I said, please read Rusty Russell's introduction to
locking in the kernel.


> > I think you're unnecessarily worrying about contention here -- you can
> > have multiple locks (one for the list, and separate ones for your sources)
> > if you're really worrying about contention -- or probably rwlocks. But
> > really, rwlocks would end up being *slower* than spinlocks, unless the
> > contention is really heavy and it helps to keep multiple readers in the
> > critical section. But frankly, with at max a few (I'd expect generally
> > one) PPS sources ever to be connected / registered with teh system, and
> > just one-pulse-per-second, I don't see why any contention is ever gonna
> > happen.
> 
> Why you wish using one lock per sources? Just one lock for the
> list/array is not enought? :-o

No, I am *not* wishing / advocating that at all. Just that you appear so
_reluctant_ to use spinlocks and are unnecessarily worrying about
contention, disabling interrupts, etc etc.

Just use the spin_lock_irqsave/restore() variants, and you'll be fine.


Satyam
