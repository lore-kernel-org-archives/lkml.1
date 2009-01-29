Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZA2Ror@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZA2Ror (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbZA2RoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:44:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbZA2RoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:44:17 -0500
Date: Thu, 29 Jan 2009 12:44:15 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
In-Reply-To: <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>  <200901290955.38940.rusty@rustcorp.com.au>  <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins>
 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Jan 2009, Linus Torvalds wrote:

> 
> 
> On Thu, 29 Jan 2009, Steven Rostedt wrote:
> > 
> > The caller must wait till the LOCK bit is cleared before setting
> > it. When it is cleared, there is no IPI function using it.
> > A spinlock is used to synchronize the setting of the bit between
> > callers. Since only one callee can be called at a time, and it
> > is the only thing to clear it, the IPI does not need to use
> > any locking.
> 
> That spinlock cannot be right. It is provably wrong for so many reasons..
> 
> Think about it. We're talking about a per-CPU lock, which already makes no 
> sense: we're only locking against our own CPU, and we've already disabled 
> preemption for totally unrelated reasons.

Actually, we are locking against the destination CPU. Or perhaps I'm 
misunderstanding you.  The lock is protecting the destination data. The 
'cpu' variable  is the CPU we call to, not the current CPU.

> 
> And the only way locking can make sense against our own CPU is if we lock 
> against interrupts - but the lock isn't actually irq-safe, so if you are 
> trying to lock against interrupts, you are (a) doing it wrong (you should 
> disable interrupts, not use a spinlock) and (b) causing a deadlock if it 
> ever happens.

I did not think an interrupt handler was allowed to do a 
smp_call_function. If it is, then you are correct and this is very buggy.

Both smp_call_function and smp_call_function have a:

	WARN_ON(irqs_disabled());

and comments saying that interrupts must be enabled and that these can
not be called from interrupt or softirq handlers.

The spin lock is to protect this scenario:

	task on CPU 0 sends IPI to CPU 2
	task on CPU 1 sends IPI to CPU 2

The first task to get past that spin lock (which is for CPU 2) will send 
the IPI. The second task will keep have to spin until the LOCK bit is 
cleared.

In other words, that spin lock is just a fancy:

 again:
	flags = per_cpu(csd_data).flags & ~CSD_FLAG_LOCK;
	if (cmpxchg(&per_cpu(csd_data, cpu).lock, flags,
	    flags | CSD_FLAG_LOCK) != flags) {
		cpu_relax();
		goto again;
	}


> 
> In other words: no way in hell does that make any sense what-so-ever.
> 
> Just remove it. As it is, it can only hurt. There's no possible point to 
> it.
> 
> Now, if people actually do send IPI's from interrupts (and it does happen 
> - cross-cpu wakeups etc), then that implies that you do want to then make 
> the whole thing irq-safe. But the *spinlock* is pointless.

But these IPIs would not use the smp_call_function routines.

> 
> But to be irq-safe, you now need to protect the _whole_ region against 
> interrupts, because otherwise an incoming interrupt will hit while the 
> CSD_FLAG_LOCK bit is set, perhaps _before_ the actual IPI has been sent, 
> and now nothing will ever clear it. So the interrupt handler that tries to 
> send an IPI will now spin forever.

Again, this code is not allowed to run from an interrupt handler.

> 
> So NAK on this patch. I think the approach is correct, but the 
> implementation is buggy.

-- Steve

