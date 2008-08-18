Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYHRXZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYHRXZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 19:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYHRXZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 19:25:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48011 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYHRXZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 19:25:16 -0400
Date: Mon, 18 Aug 2008 16:25:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Fair low-latency rwlock v5
Message-ID: <20080818232500.GF6732@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817191034.GA5258@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 03:10:35PM -0400, Mathieu Desnoyers wrote:
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > 
> > 
> > On Sun, 17 Aug 2008, Mathieu Desnoyers wrote:
> > > +/*
> > > + * Uncontended fastpath.
> > > + */
> > > +static int fair_write_lock_irq_fast(struct fair_rwlock *rwlock)
> > 
> > So first off, you should call this "trylock", since it doesn't necessarily 
> > get the lock at all. It has nothing to do with fast.
> > 
> > Secondly:
> > 
> > > +	value = atomic_long_read(&rwlock->value);
> > > +	if (likely(!value)) {
> > > +		/* no other reader nor writer present, try to take the lock */
> > > +		local_bh_disable();
> > > +		local_irq_disable();
> > > +		if (likely(atomic_long_cmpxchg(&rwlock->value, value,
> > 
> > This is actually potentially very slow. 
> > 
> > Why? If the lock is uncontended, but is not in the current CPU's caches, 
> > the read -> rmw operation generates multiple cache coherency protocol 
> > events. First it gets the line in shared mode (for the read), and then 
> > later it turns it into exclusive mode.
> > 
> > So if it's likely that the value is zero (or even if it's just the only 
> > case we really care about), then you really should do the
> > 
> > 	atomic_long_cmpxchg(&rwlock->value, 0, newvalue);
> > 
> > thing as the _first_ access to the lock.
> > 
> > Yeah, yeah, that means that you need to do the local_bh_disable etc first 
> > too, and undo it if it fails, but the failure path should be the unusual 
> > one. 
> > 
> > 			Linus
> 
> Ah, you are right. This new version implements a "single cmpxchg"
> uncontended code path, changes the _fast semantic for "trylock
> uncontended" and also adds the trylock primitives.

Interesting approach!  Questions and comments interspersed below.

						Thanx, Paul

> Thanks for the input,
> 
> Mathieu
> 
> 
> Fair low-latency rwlock v5
> 
> Fair low-latency rwlock provides fairness for writers against reader threads,
> but lets softirq and irq readers in even when there are subscribed writers
> waiting for the lock. Writers could starve reader threads.
> 
> Changelog since v4 :
> rename _fast -> trylock uncontended
> Remove the read from the uncontended read and write cases : just do a cmpxchg
> expecting "sub_expect", 0 for "lock", 1 subscriber for a "trylock".
> Use the value returned by the first cmpxchg as following value instead of doing
> an unnecessary read.
> 
> Here is why read + rmw is wrong (quoting Linus) :
> 
> "This is actually potentially very slow.
> 
> Why? If the lock is uncontended, but is not in the current CPU's caches,
> the read -> rmw operation generates multiple cache coherency protocol
> events. First it gets the line in shared mode (for the read), and then
> later it turns it into exclusive mode."
> 
> Changelog since v3 :
> Added writer subscription and fair trylock. The writer subscription keeps the
> reader threads out of the lock.
> 
> Changelog since v2 :
> Add writer fairness in addition to fairness wrt interrupts and softirqs.
> Added contention delays performance tests for thread and interrupt contexts to
> changelog.
> 
> Changelog since v1 :
> - No more spinlock to protect against concurrent writes, it is done within
>   the existing atomic variable.
> - Write fastpath with a single atomic op.
> 
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > 
> > 
> > On Sat, 16 Aug 2008, Mathieu Desnoyers wrote:
> > > 
> > > I have hit this problem when tying to implement a better rwlock design
> > > than is currently in the mainline kernel (I know the RT kernel has a
> > > hard time with rwlocks)
> > 
> > Have you looked at my sleping rwlock trial thing?
> > 
> [...]
> >  - and because it is designed for sleeping, I'm pretty sure that you can 
> >    easily drop interrupts in the contention path, to make 
> >    write_lock_irq[save]() be reasonable.
> > 
> > In particular, the third bullet is the important one: because it's 
> > designed to have a "contention" path that has _extra_ information for the 
> > contended case, you could literally make the extra information have things 
> > like a list of pending writers, so that you can drop interrupts on one 
> > CPU, while you adding information to let the reader side know that if the 
> > read-lock happens on that CPU, it needs to be able to continue in order to 
> > not deadlock.
> > 
> > 		Linus
> 
> No, I just had a look at it, thanks for the pointer!
> 
> Tweakable contention behavior seems interesting, but I don't think it
> deals with the fact that on a mainline kernel, when an interrupt handler
> comes in and asks for a read lock, it has to get it on the spot. (RT
> kernels can get away with that using threaded threaded interrupts, but
> that's a completely different scheme). Therefore, the impact is that
> interrupts must be disabled around write lock usage, and we end up in
> the situation where this interrupt disable section can last for a long
> time, given it waits for every readers (including ones which does not
> disable interrupts nor softirqs) to complete.
> 
> Actually, I just used LTTng traces and eventually made a small patch to
> lockdep to detect whenever a spinlock or a rwlock is used both with
> interrupts enabled and disabled. Those sites are likely to produce very
> high latencies and should IMHO be considered as bogus. The basic bogus
> scenario is to have a spinlock held on CPU A with interrupts enabled
> being interrupted and then a softirq runs. On CPU B, the same lock is
> acquired with interrupts off. We therefore disable interrupts on CPU B
> for the duration of the softirq currently running on the CPU A, which is
> really not something that helps keeping short latencies. My preliminary
> results shows that there are a lot of inconsistent spinlock/rwlock irq
> on/off uses in the kernel.
> 
> This kind of scenario is pretty easy to fix for spinlocks (either move
> the interrupt disable within the spinlock section if the spinlock is
> never used by an interrupt handler or make sure that every users has
> interrupts disabled).
> 
> The problem comes with rwlocks : it is correct to have readers both with
> and without irq disable, even when interrupt handlers use the read lock.
> However, the write lock has to disable interrupt in that case, and we
> suffer from the high latency I pointed out. The tasklist_lock is the
> perfect example of this. In the following patch, I try to address this
> issue.
> 
> The core idea is this :
> 
> This "fair" rwlock writer subscribes to the lock, which locks out the 
> reader threads. Then, it takes waits until all reader threads exited their
> critical section and takes the mutex (1 bit within the "long"). Then it
> disables softirqs, locks out the softirqs, waits for all softirqs to exit their
> critical section, disables irqs and locks out irqs. It then waits for irqs to
> exit their critical section. Only then is the writer allowed to modify the data
> structure.
> 
> The writer fast path checks for a non-contended lock (all bits set to 0) and
> does an atomic cmpxchg to set the subscription, mutex, softirq exclusion and irq
> exclusion bits.
> 
> The reader does an atomic cmpxchg to check if there is a subscribed writer. If
> not, it increments the reader count for its context (thread, softirq, irq).
> 
> The test module is available at :
> 
> http://ltt.polymtl.ca/svn/trunk/tests/kernel/test-fair-rwlock.c
> 
> ** Performance tests
> 
> Dual quad-core Xeon 2.0GHz E5405
> 
> * Lock contention delays, per context, 60s test
> 
> 6 thread readers (no delay loop)
> 3 thread writers (10us period)
> 2 periodical interrupt readers on 7/8 cpus (IPIs).
> 
> writer_thread/0 iterations : 2980374, max contention 1007442 cycles
> writer_thread/1 iterations : 2992675, max contention 917364 cycles
> trylock_writer_thread/0 iterations : 13533386, successful iterations : 3357015
> trylock_writer_thread/1 iterations : 13310980, successful iterations : 3278394
> reader_thread/0 iterations : 13624664, max contention 1296450 cycles
> reader_thread/1 iterations : 12183042, max contention 1524810 cycles
> reader_thread/2 iterations : 13302985, max contention 1017834 cycles
> reader_thread/3 iterations : 13398307, max contention 1016700 cycles
> trylock_reader_thread/0 iterations : 60849620, successful iterations : 14708736
> trylock_reader_thread/1 iterations : 63830891, successful iterations : 15827695
> interrupt_reader_thread/0 iterations : 559
> interrupt readers on CPU 0, max contention : 13914 cycles
> interrupt readers on CPU 1, max contention : 16446 cycles
> interrupt readers on CPU 2, max contention : 11604 cycles
> interrupt readers on CPU 3, max contention : 14124 cycles
> interrupt readers on CPU 4, max contention : 16494 cycles
> interrupt readers on CPU 5, max contention : 12930 cycles
> interrupt readers on CPU 6, max contention : 9432 cycles
> interrupt readers on CPU 7, max contention : 14514 cycles
> trylock_interrupt_reader_thread/0 iterations : 573
> trylock interrupt readers on CPU 0, iterations 1249, successful iterations : 1135
> trylock interrupt readers on CPU 1, iterations 1152, successful iterations : 1064
> trylock interrupt readers on CPU 2, iterations 1239, successful iterations : 1135
> trylock interrupt readers on CPU 3, iterations 1227, successful iterations : 1130
> trylock interrupt readers on CPU 4, iterations 1029, successful iterations : 908
> trylock interrupt readers on CPU 5, iterations 1161, successful iterations : 1063
> trylock interrupt readers on CPU 6, iterations 612, successful iterations : 578
> trylock interrupt readers on CPU 7, iterations 1007, successful iterations : 932
> 
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/fair-rwlock.h |   61 ++++
>  lib/Makefile                |    2 
>  lib/fair-rwlock.c           |  557 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 620 insertions(+)
> 
> Index: linux-2.6-lttng/include/linux/fair-rwlock.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/linux/fair-rwlock.h	2008-08-17 11:48:42.000000000 -0400
> @@ -0,0 +1,61 @@
> +#ifndef _LINUX_FAIR_RWLOCK_H
> +#define _LINUX_FAIR_RWLOCK_H
> +
> +/*
> + * Fair low-latency rwlock
> + *
> + * Allows writer fairness wrt readers and also minimally impact the irq latency
> + * of the system.
> + *
> + * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + * August 2008
> + */
> +
> +#include <asm/atomic.h>
> +
> +struct fair_rwlock {
> +	atomic_long_t value;
> +};
> +
> +/* Reader lock */
> +
> +/*
> + * many readers, from irq/softirq/thread context.
> + * protects against writers.
> + */
> +void fair_read_lock(struct fair_rwlock *rwlock);
> +int fair_read_trylock(struct fair_rwlock *rwlock);
> +void fair_read_unlock(struct fair_rwlock *rwlock);
> +
> +/* Writer Lock */
> +
> +/*
> + * Subscription for write lock. Must be used for write trylock only.
> + * Insures fairness wrt reader threads.
> + */
> +void fair_write_subscribe(struct fair_rwlock *rwlock);
> +
> +/*
> + * Safe against other writers in thread context.
> + * Safe against irq/softirq/thread readers.
> + */
> +void fair_write_lock_irq(struct fair_rwlock *rwlock);
> +int fair_write_trylock_subscribed_irq(struct fair_rwlock *rwlock);
> +void fair_write_unlock_irq(struct fair_rwlock *rwlock);
> +
> +/*
> + * Safe against other writers in thread context.
> + * Safe against softirq/thread readers.
> + */
> +void fair_write_lock_bh(struct fair_rwlock *rwlock);
> +int fair_write_trylock_subscribed_bh(struct fair_rwlock *rwlock);
> +void fair_write_unlock_bh(struct fair_rwlock *rwlock);
> +
> +/*
> + * Safe against other writers in thread context.
> + * Safe against thread readers.
> + */
> +void fair_write_lock(struct fair_rwlock *rwlock);
> +int fair_write_trylock_subscribed(struct fair_rwlock *rwlock);
> +void fair_write_unlock(struct fair_rwlock *rwlock);
> +#endif /* _LINUX_FAIR_RWLOCK_H */
> Index: linux-2.6-lttng/lib/Makefile
> ===================================================================
> --- linux-2.6-lttng.orig/lib/Makefile	2008-08-16 03:22:14.000000000 -0400
> +++ linux-2.6-lttng/lib/Makefile	2008-08-16 03:29:12.000000000 -0400
> @@ -43,6 +43,8 @@ obj-$(CONFIG_DEBUG_PREEMPT) += smp_proce
>  obj-$(CONFIG_DEBUG_LIST) += list_debug.o
>  obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
> 
> +obj-y += fair-rwlock.o
> +
>  ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
>    lib-y += dec_and_lock.o
>  endif
> Index: linux-2.6-lttng/lib/fair-rwlock.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/lib/fair-rwlock.c	2008-08-17 14:20:38.000000000 -0400
> @@ -0,0 +1,557 @@
> +/*
> + * Fair low-latency rwlock
> + *
> + * Allows writer fairness wrt readers and also minimally impact the irq latency
> + * of the system.
> + *
> + * A typical case leading to long interrupt latencies :
> + *
> + * - rwlock shared between
> + *   - Rare update in thread context
> + *   - Frequent slow read in thread context (task list iteration)
> + *   - Fast interrupt handler read
> + *
> + * The slow write must therefore disable interrupts around the write lock,
> + * but will therefore add up to the global interrupt latency; worse case being
> + * the duration of the slow read.
> + *
> + * This "fair" rwlock writer subscribes to the lock, which locks out the reader
> + * threads. Then, it takes waits until all reader threads exited their critical
> + * section and takes the mutex (1 bit within the "long"). Then it disables
> + * softirqs, locks out the softirqs, waits for all softirqs to exit their
> + * critical section, disables irqs and locks out irqs. It then waits for irqs to
> + * exit their critical section. Only then is the writer allowed to modify the
> + * data structure.
> + *
> + * The writer fast path checks for a non-contended lock (all bits set to 0) and
> + * does an atomic cmpxchg to set the subscription, mutex, softirq exclusion and
> + * irq exclusion bits.
> + *
> + * The reader does an atomic cmpxchg to check if there is a subscribed writer.
> + * If not, it increments the reader count for its context (thread, softirq,
> + * irq).
> + *
> + * rwlock bits :
> + *
> + * - bits 0 .. log_2(NR_CPUS)-1) are the thread readers count
> + *   (max number of threads : NR_CPUS)
> + * - bits log_2(NR_CPUS) .. 2*log_2(NR_CPUS)-1 are the softirq readers count
> + *   (max # of softirqs: NR_CPUS)
> + * - bits 2*log_2(NR_CPUS) .. 3*log_2(NR_CPUS)-1 are the hardirq readers count
> + *   (max # of hardirqs: NR_CPUS)
> + *
> + * - bits 3*log_2(NR_CPUS) .. 4*log_2(NR_CPUS)-1 are the writer subscribers
> + *   count. Locks against reader threads if non zero.
> + *   (max # of writer subscribers : NR_CPUS)
> + * - bit 4*log_2(NR_CPUS) is the write mutex
> + * - bit 4*log_2(NR_CPUS)+1 is the writer lock against softirqs
> + * - bit 4*log_2(NR_CPUS)+2 is the writer lock against hardirqs

OK...  64 bits less three for the writer bits is 61 bits, divided by
four gives us 15 bits, which limits us to 32,768 CPUs (16,384 if we need
a guard bit separating the fields).  This should be enough for the next
few years.

However, if critical sections are to be preemptable (as they need to be
in -rt, then this limit applies to the number of -tasks- rather than the
number of CPUs.  32,768 is IMHO an uncomfortably low ceiling for the
number of tasks in a system, given that my laptop supports several
thousand without breaking a sweat.

So, how about combining the softirq and hardirq bits, giving the range 0
.. 2*log_2(NR_CPUS)-1 over to tasks?  This would give 30 bits, allowing
more than 10^9 tasks, which should be enough for the next few years.
Better yet, why not begin the bit allotment at the high end of the word,
allowing whatever is left over at the bottom for tasks?

Alternatively, "hardirq" and "softirq" runs in process context in -rt,
so the three read-side bitfields should be able to be combined into one
in that case.

> + * e.g. : NR_CPUS = 16
> + *
> + * THREAD_RMASK:      0x0000000f
> + * SOFTIRQ_RMASK:     0x000000f0
> + * HARDIRQ_RMASK:     0x00000f00
> + * SUBSCRIBERS_WMASK: 0x0000f000
> + * WRITER_MUTEX:      0x00010000
> + * SOFTIRQ_WMASK:     0x00020000
> + * HARDIRQ_WMASK:     0x00040000
> + *
> + * Bits usage :
> + *
> + * nr cpus for thread read
> + * nr cpus for softirq read
> + * nr cpus for hardirq read
> + *
> + * IRQ-safe write lock :
> + * nr cpus for write subscribers, disables new thread readers if non zero
> + * if (nr thread read == 0 && write mutex == 0)
> + * 1 bit for write mutex
> + * (softirq off)
> + * 1 bit for softirq exclusion
> + * if (nr softirq read == 0)
> + * (hardirq off)
> + * 1 bit for hardirq exclusion
> + * if (nr hardirq read == 0)
> + * -> locked
> + *
> + * Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + */
> +
> +#include <linux/fair-rwlock.h>
> +#include <linux/hardirq.h>
> +#include <linux/module.h>
> +
> +#if (NR_CPUS > 64 && (BITS_PER_LONG == 32 || NR_CPUS > 32768))
> +#error "fair rwlock needs more bits per long to deal with that many CPUs"
> +#endif
> +
> +#define THREAD_ROFFSET	1UL
> +#define THREAD_RMASK	((NR_CPUS - 1) * THREAD_ROFFSET)

NR_CPUS is required to be a power of two?  News to me...

> +#define SOFTIRQ_ROFFSET	(THREAD_RMASK + 1)
> +#define SOFTIRQ_RMASK	((NR_CPUS - 1) * SOFTIRQ_ROFFSET)
> +#define HARDIRQ_ROFFSET	((SOFTIRQ_RMASK | THREAD_RMASK) + 1)
> +#define HARDIRQ_RMASK	((NR_CPUS - 1) * HARDIRQ_ROFFSET)
> +
> +#define SUBSCRIBERS_WOFFSET	\
> +	((HARDIRQ_RMASK | SOFTIRQ_RMASK | THREAD_RMASK) + 1)
> +#define SUBSCRIBERS_WMASK	\
> +	((NR_CPUS - 1) * SUBSCRIBERS_WOFFSET)
> +#define WRITER_MUTEX		\
> +	((SUBSCRIBERS_WMASK | HARDIRQ_RMASK | SOFTIRQ_RMASK | THREAD_RMASK) + 1)
> +#define SOFTIRQ_WMASK	(WRITER_MUTEX << 1)
> +#define SOFTIRQ_WOFFSET	SOFTIRQ_WMASK
> +#define HARDIRQ_WMASK	(SOFTIRQ_WMASK << 1)
> +#define HARDIRQ_WOFFSET	HARDIRQ_WMASK
> +
> +#ifdef FAIR_RWLOCK_DEBUG
> +#define printk_dbg printk
> +#else
> +#define printk_dbg(fmt, args...)
> +#endif
> +
> +
> +/*
> + * Uncontended fastpath.
> + */
> +static long fair_read_trylock_uncontended(struct fair_rwlock *rwlock,
> +	long expect_readers, long roffset)
> +{
> +	/* no other reader nor writer present, try to take the lock */
> +	return atomic_long_cmpxchg(&rwlock->value, expect_readers,
> +					(expect_readers + roffset));
> +}

Suggest inlining this one, as it is just a wrapper.  (Or is gcc smart
enough to figure that out on its own these days?)

> +
> +/*
> + * Reader lock
> + *
> + * First try to get the uncontended lock. If it is non-zero (can be common,
> + * since we allow multiple readers), pass the returned cmpxchg value to the loop
> + * to try to get the reader lock.
> + *
> + * trylock will fail if a writer is subscribed or holds the lock, but will
> + * spin if there is concurency to win the cmpxchg. It could happen if, for
> + * instance, other concurrent reads need to update the roffset or if a
> + * writer updated the lock bits which does not contend us. Since many
> + * concurrent readers is a common case, it makes sense not to fail is it
> + * happens.
> + *
> + * the non-trylock case will spin for both situations.
> + */
> +
> +static int _fair_read_lock_ctx(struct fair_rwlock *rwlock,
> +		long roffset, long wmask, int trylock)
> +{
> +	long value, newvalue;
> +
> +	/*
> +	 * Try uncontended lock.
> +	 */
> +	value = fair_read_trylock_uncontended(rwlock, 0, roffset);
> +	if (likely(value == 0))
> +		return 1;
> +
> +	for (;;) {
> +		if (value & wmask) {
> +			if (!trylock) {
> +				/* Order value reads */
> +				smp_rmb();

I don't understand the need for this smp_rmb() -- what other location
are we maintaining order with?  The CPU must maintain order of accesses
to a single variable (cache coherence requires this).

I suggest replacing the smp_rmb() with a barrier().  Not that optimizing
a spinloop is violently important...

> +				value = atomic_long_read(&rwlock->value);
> +				continue;
> +			} else
> +				return 0;
> +		}
> +
> +		newvalue = atomic_long_cmpxchg(&rwlock->value,
> +				value, value + roffset);

Why not use fair_read_trylock_uncontended()?  Or equivalently, why not
replace calls to fair_read_trylock_uncontended() with the bare cmpxchg?

> +		if (likely(newvalue == value))
> +			break;
> +		else
> +			value = newvalue;
> +	}
> +
> +	printk_dbg("lib reader got in with value %lX, wmask %lX\n",
> +		value, wmask);
> +	return 1;
> +}
> +
> +/*
> + * many readers, from irq/softirq/thread context.
> + * protects against writers.
> + */
> +void fair_read_lock(struct fair_rwlock *rwlock)
> +{
> +	if (in_irq())
> +		_fair_read_lock_ctx(rwlock, HARDIRQ_ROFFSET, HARDIRQ_WMASK, 0);
> +	else if (in_softirq())
> +		_fair_read_lock_ctx(rwlock, SOFTIRQ_ROFFSET, SOFTIRQ_WMASK, 0);
> +	else {
> +		preempt_disable();
> +		_fair_read_lock_ctx(rwlock, THREAD_ROFFSET, SUBSCRIBERS_WMASK,
> +					0);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(fair_read_lock);
> +
> +int fair_read_trylock(struct fair_rwlock *rwlock)
> +{
> +	int ret;
> +
> +	if (in_irq())
> +		return _fair_read_lock_ctx(rwlock,
> +					HARDIRQ_ROFFSET, HARDIRQ_WMASK, 1);
> +	else if (in_softirq())
> +		return _fair_read_lock_ctx(rwlock,
> +					SOFTIRQ_ROFFSET, SOFTIRQ_WMASK, 1);
> +	else {
> +		preempt_disable();
> +		ret = _fair_read_lock_ctx(rwlock,
> +					THREAD_ROFFSET, SUBSCRIBERS_WMASK, 1);
> +		if (!ret)
> +			preempt_enable();
> +		return ret;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(fair_read_trylock);
> +
> +void fair_read_unlock(struct fair_rwlock *rwlock)
> +{
> +	/* atomic_long_sub orders reads */
> +	if (in_irq())
> +		atomic_long_sub(HARDIRQ_ROFFSET, &rwlock->value);
> +	else if (in_softirq())
> +		atomic_long_sub(SOFTIRQ_ROFFSET, &rwlock->value);
> +	else {
> +		atomic_long_sub(THREAD_ROFFSET, &rwlock->value);
> +		preempt_enable();
> +	}
> +}
> +EXPORT_SYMBOL_GPL(fair_read_unlock);
> +
> +/* Writer lock */
> +
> +/*
> + * Lock out a specific execution context from the read lock. Wait for both the
> + * rmask and the wmask to be empty before proceeding to take the lock.
> + */
> +static void _fair_write_lock_ctx_wait(struct fair_rwlock *rwlock,
> +		long value, long rmask, long wmask)
> +{
> +	long newvalue;
> +
> +	for (;;) {
> +		if (value & (rmask | wmask)) {
> +			/* Order value reads */
> +			smp_rmb();

Suggest replacing the smp_rmb() with barrier() as noted above.

> +			value = atomic_long_read(&rwlock->value);
> +			continue;
> +		}
> +		newvalue = atomic_long_cmpxchg(&rwlock->value,
> +				value, value | wmask);
> +		if (likely(newvalue == value))
> +			break;
> +		else
> +			value = newvalue;
> +	}
> +	printk_dbg("lib writer got in with value %lX, new %lX, rmask %lX\n",
> +		value, value | wmask, rmask);
> +}
> +
> +/*
> + * Lock out a specific execution context from the read lock. First lock the read
> + * context out of the lock, then wait for every readers to exit their critical
> + * section.
> + */
> +static void _fair_write_lock_ctx_force(struct fair_rwlock *rwlock,
> +		long rmask, long woffset)
> +{
> +	long value;
> +
> +	atomic_long_add(woffset, &rwlock->value);
> +	do {
> +		value = atomic_long_read(&rwlock->value);
> +		/* Order rwlock->value read wrt following reads */
> +		smp_rmb();

Suggest replacing the smp_rmb() with barrier() as noted above.

> +	} while (value & rmask);
> +	printk_dbg("lib writer got in with value %lX, woffset %lX, rmask %lX\n",
> +		value, woffset, rmask);
> +}
> +
> +void fair_write_subscribe(struct fair_rwlock *rwlock)
> +{
> +	preempt_disable();
> +
> +	/* lock out threads */
> +	atomic_long_add(SUBSCRIBERS_WOFFSET, &rwlock->value);
> +}
> +EXPORT_SYMBOL_GPL(fair_write_subscribe);
> +
> +/*
> + * Uncontended fastpath.
> + */
> +static long
> +fair_write_trylock_irq_uncontended(struct fair_rwlock *rwlock,
> +	long expect_sub, long sub_woffset)
> +{
> +	long value;
> +
> +	/* no other reader nor writer present, try to take the lock */
> +	local_bh_disable();
> +	local_irq_disable();
> +	value = atomic_long_cmpxchg(&rwlock->value, expect_sub,
> +			expect_sub + (sub_woffset | SOFTIRQ_WOFFSET
> +				| HARDIRQ_WOFFSET | WRITER_MUTEX));
> +	if (unlikely(value != expect_sub)) {
> +		local_irq_enable();
> +		local_bh_enable();
> +	}
> +	return value;
> +}
> +
> +/*
> + * Safe against other writers in thread context.
> + * Safe against irq/softirq/thread readers.
> + */
> +void fair_write_lock_irq(struct fair_rwlock *rwlock)
> +{
> +	long value;
> +
> +	preempt_disable();
> +	value = fair_write_trylock_irq_uncontended(rwlock,
> +			0, SUBSCRIBERS_WOFFSET);
> +	if (likely(!value))
> +		return;
> +
> +	/* lock out threads */
> +	atomic_long_add(SUBSCRIBERS_WOFFSET, &rwlock->value);

Why don't we use fair_write_subscribe() here?  Ah, because we have
already disabled preemption...

OK, so why do we have fair_write_subscribe() defined in the first place?

> +	/* lock out other writers when no reader threads left */
> +	_fair_write_lock_ctx_wait(rwlock, value + SUBSCRIBERS_WOFFSET,
> +		THREAD_RMASK, WRITER_MUTEX);

OK, I'll bite...  Why don't we also have to wait for the softirq and
hardirq readers?  I would expect THREAD_RMASK|SOFTIRQ_RMASK|HARDIRQ_RMASK
rather than just THREAD_RMASK above.

Never mind, I finally see the following pair of statements.

So, the idea is to allow recursive readers in irq when we also have
readers in the interrupted process context, right?  But isn't the
common case going to be no irq handlers read-holding the lock?  If
so, wouldn't we want to try for all of them at once if we could, using
a state machine?

Also, just to be sure I understand, writers waiting for other writers
would spin in the above _fair_write_lock_ctx_wait(), correct?

> +	/* lock out softirqs */
> +	local_bh_disable();

Why not just local_irq_disable() at this point and be done with it?

> +	_fair_write_lock_ctx_force(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WOFFSET);
> +
> +	/* lock out hardirqs */
> +	local_irq_disable();
> +	_fair_write_lock_ctx_force(rwlock, HARDIRQ_RMASK, HARDIRQ_WOFFSET);
> +
> +	/* atomic_long_cmpxchg orders writes */
> +}
> +EXPORT_SYMBOL_GPL(fair_write_lock_irq);
> +
> +/*
> + * Must already be subscribed. Will fail if there is contention caused by
> + * interrupt readers, softirq readers, other writers. Will also fail if there is
> + * concurrent cmpxchg update, even if it is only a writer subscription. It is
> + * not considered as a common case and therefore does not jusfity looping.

"justify"?  (Sorry, couldn't resist...)

> + *
> + * Second cmpxchg deals with other write subscribers.
> + */
> +int fair_write_trylock_subscribed_irq(struct fair_rwlock *rwlock)
> +{
> +	long value;
> +
> +	value = fair_write_trylock_irq_uncontended(rwlock,
> +			SUBSCRIBERS_WOFFSET, 0);
> +	if (likely(value == SUBSCRIBERS_WOFFSET))
> +		return 1;
> +
> +	if (likely(!(value & ~SUBSCRIBERS_WMASK))) {
> +		/* no other reader nor writer present, try to take the lock */
> +		local_bh_disable();
> +		local_irq_disable();

Doesn't local_irq_disable() imply local_bh_disable()?  So why not just
do local_irq_disable()?

> +		if (likely(atomic_long_cmpxchg(&rwlock->value, value,
> +				value + (SOFTIRQ_WOFFSET
> +					| HARDIRQ_WOFFSET | WRITER_MUTEX))
> +						== value))
> +			return 1;
> +		local_irq_enable();
> +		local_bh_enable();
> +	}
> +	return 0;
> +
> +}
> +EXPORT_SYMBOL_GPL(fair_write_trylock_subscribed_irq);
> +
> +void fair_write_unlock_irq(struct fair_rwlock *rwlock)
> +{
> +	/*
> +	 * atomic_long_sub makes sure we commit the data before reenabling
> +	 * the lock.
> +	 */
> +	atomic_long_sub(HARDIRQ_WOFFSET | SOFTIRQ_WOFFSET
> +			| WRITER_MUTEX | SUBSCRIBERS_WOFFSET,
> +			&rwlock->value);
> +	local_irq_enable();
> +	local_bh_enable();
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL_GPL(fair_write_unlock_irq);
> +
> +/*
> + * Uncontended fastpath.
> + */
> +static long fair_write_trylock_bh_uncontended(struct fair_rwlock *rwlock,
> +	long expect_sub, long sub_woffset)
> +{
> +	long value;
> +
> +	/* no other reader nor writer present, try to take the lock */
> +	local_bh_disable();
> +	value = atomic_long_cmpxchg(&rwlock->value, expect_sub,
> +		expect_sub + (sub_woffset | SOFTIRQ_WOFFSET | WRITER_MUTEX));
> +	if (unlikely(value != expect_sub))
> +		local_bh_enable();
> +	return value;
> +}
> +
> +/*
> + * Safe against other writers in thread context.
> + * Safe against softirq/thread readers.
> + */
> +void fair_write_lock_bh(struct fair_rwlock *rwlock)
> +{
> +	long value;
> +
> +	preempt_disable();
> +	value = fair_write_trylock_bh_uncontended(rwlock,
> +			0, SUBSCRIBERS_WOFFSET);
> +	if (likely(!value))
> +		return;
> +
> +	/* lock out threads */
> +	atomic_long_add(SUBSCRIBERS_WOFFSET, &rwlock->value);
> +
> +	/* lock out other writers when no reader threads left */
> +	_fair_write_lock_ctx_wait(rwlock, value + SUBSCRIBERS_WOFFSET,
> +		THREAD_RMASK, WRITER_MUTEX);
> +
> +	/* lock out softirqs */
> +	local_bh_disable();
> +	_fair_write_lock_ctx_force(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WOFFSET);

Seems like we would want to at least give an error if there were
hardirq readers...  (Can't think of a reasonable use case mixing
fair_write_lock_bh() with hardirq readers, but might well be simply a
momentary failure of imagination.)

> +	/* atomic_long_cmpxchg orders writes */
> +}
> +EXPORT_SYMBOL_GPL(fair_write_lock_bh);
> +
> +/*
> + * Must already be subscribed. Will fail if there is contention caused by
> + * softirq readers, other writers. Will also fail if there is concurrent cmpxchg
> + * update, even if it is only a writer subscription. It is not considered as a
> + * common case and therefore does not jusfity looping.
> + */
> +int fair_write_trylock_subscribed_bh(struct fair_rwlock *rwlock)
> +{
> +	long value;
> +
> +	value = fair_write_trylock_bh_uncontended(rwlock,
> +			SUBSCRIBERS_WOFFSET, 0);
> +	if (likely(value == SUBSCRIBERS_WOFFSET))
> +		return 1;
> +
> +	if (likely(!(value & ~SUBSCRIBERS_WMASK))) {
> +		/* no other reader nor writer present, try to take the lock */
> +		local_bh_disable();
> +		local_irq_disable();
> +		if (likely(atomic_long_cmpxchg(&rwlock->value, value,
> +				value + (SOFTIRQ_WOFFSET | WRITER_MUTEX))
> +						== value))
> +			return 1;
> +		local_irq_enable();
> +		local_bh_enable();
> +	}
> +	return 0;
> +
> +}
> +EXPORT_SYMBOL_GPL(fair_write_trylock_subscribed_bh);
> +
> +void fair_write_unlock_bh(struct fair_rwlock *rwlock)
> +{
> +	/*
> +	 * atomic_long_sub makes sure we commit the data before reenabling
> +	 * the lock.
> +	 */
> +	atomic_long_sub(SOFTIRQ_WOFFSET | WRITER_MUTEX | SUBSCRIBERS_WOFFSET,
> +			&rwlock->value);
> +	local_bh_enable();
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL_GPL(fair_write_unlock_bh);
> +
> +/*
> + * Uncontended fastpath.
> + */
> +static long fair_write_trylock_uncontended(struct fair_rwlock *rwlock,
> +	long expect_sub, long sub_woffset)
> +{
> +	/* no other reader nor writer present, try to take the lock */
> +	return atomic_long_cmpxchg(&rwlock->value, expect_sub,
> +					(expect_sub + sub_woffset)
> +					| WRITER_MUTEX);
> +}
> +
> +/*
> + * Safe against other writers in thread context.
> + * Safe against thread readers.
> + */
> +void fair_write_lock(struct fair_rwlock *rwlock)
> +{
> +	long value;
> +
> +	preempt_disable();
> +	value = fair_write_trylock_uncontended(rwlock, 0, SUBSCRIBERS_WOFFSET);
> +	if (likely(!value))
> +		return;
> +
> +	/* lock out threads */
> +	atomic_long_add(SUBSCRIBERS_WOFFSET, &rwlock->value);
> +
> +	/* lock out other writers when no reader threads left */
> +	_fair_write_lock_ctx_wait(rwlock, value + SUBSCRIBERS_WOFFSET,
> +		THREAD_RMASK, WRITER_MUTEX);

The theory here is that there shouldn't be any readers in bh or irq?
But suppose that we are calling fair_write_lock() with irqs already
disabled?  Wouldn't we still want to wait for bh and irq readers in
that case?

> +	/* atomic_long_cmpxchg orders writes */
> +}
> +EXPORT_SYMBOL_GPL(fair_write_lock);
> +
> +/*
> + * Must already be subscribed. Will fail if there is contention caused by
> + * other writers. Will also fail if there is concurrent cmpxchg update, even if
> + * it is only a writer subscription. It is not considered as a common case and
> + * therefore does not jusfity looping.
> + */
> +int fair_write_trylock_subscribed(struct fair_rwlock *rwlock)
> +{
> +	long value;
> +
> +	value = fair_write_trylock_uncontended(rwlock, SUBSCRIBERS_WOFFSET, 0);
> +	if (likely(value == SUBSCRIBERS_WOFFSET))
> +		return 1;
> +
> +	if (likely(!(value & ~SUBSCRIBERS_WMASK))) {
> +		/* no other reader nor writer present, try to take the lock */
> +		local_bh_disable();
> +		local_irq_disable();
> +		if (likely(atomic_long_cmpxchg(&rwlock->value, value,
> +				value | WRITER_MUTEX) == value))
> +			return 1;
> +		local_irq_enable();
> +		local_bh_enable();
> +	}
> +	return 0;
> +
> +}
> +EXPORT_SYMBOL_GPL(fair_write_trylock_subscribed);

I still find the _subscribed() stuff a bit scary...  Sample use case?

> +void fair_write_unlock(struct fair_rwlock *rwlock)
> +{
> +	/*
> +	 * atomic_long_sub makes sure we commit the data before reenabling
> +	 * the lock.
> +	 */
> +	atomic_long_sub(WRITER_MUTEX | SUBSCRIBERS_WOFFSET, &rwlock->value);
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL_GPL(fair_write_unlock);
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
