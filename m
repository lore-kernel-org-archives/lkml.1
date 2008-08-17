Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYHQHxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYHQHxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 03:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYHQHxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 03:53:42 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:58180 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYHQHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 03:53:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroFAEhxp0hMRKxB/2dsb2JhbACBYrAFgVg
Date: Sun, 17 Aug 2008 03:53:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Fair low-latency rwlock v3
Message-ID: <20080817075335.GA25019@Krystal>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:32:38 up 73 days, 12:13,  6 users,  load average: 0.22, 0.21,
	0.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
[...]
> So this way you can be fair, and not allow readers to starve a writer. The 
> only reader that is allowed past a waiting writer is the reader on that 
> same CPU.
> 
> And notice how the fast-path needs no spinlock or anything else - it's 
> still just a single locked instruction. In comparison, if I read your 
> example code right, it is absolutely horrid and has an extra spinlock 
> access for the fair_write_lock case.
> 
> 			Linus

Hi Linus,

Using a writer subscription to the rwlock to make sure the readers stop taking
the lock when a writer is waiting for it is indeed a good way to insure
fairness. I just fixed the issues you pointed in my patch (spinlock removed,
added a write fastpath with a single atomic op) and also used the subscription
idea to get fairness for writers. Contention delay tests shows that fairness is
achieved pretty well. For periodical writers, busy looping readers and
periodical interrupt readers :

6 thread readers (busy-looping)
3 thread writers (1ms period)
2 periodical interrupt readers on 7/8 cpus (IPIs).

-  21us max. contention for writer
- 154us max. contention for thread readers
-  16us max. contention for interrupt readers

(benchmark details below)

I still perceive two potential problems with your approach. It's not related to
fairness between readers and writers, but more on the effect on interrupt
latency on the system. This is actually what my patch try to address.

First there is a long interrupt handler scenario, as bad as disabling interrupts
for a long time period, which is not fixed by your solution :

CPU A
thread context, takes the read lock, gets interrupted, softirq runs.

CPU B
thread context, subscribes for the writer lock, busy loops waiting for CPU A.
(in your solution, interrupts are enabled here so interrupt handlers on CPU B
can come in)

CPU C
interrupt context, takes the read lock, contended because CPU B busy loops
waiting for the writer lock.

-> CPU C will have an interrupt handler running for the duration of the softirq
on CPU A, which will impact interrupt latency on CPU C.

Second, I tend to think this it might be difficult to atomically set the writer
state and disable interrupts, unless we disable interrupts, cmpxchg the writer
test, reenable interrupts if it fails in a loop, which does not seem very neat.


Fair low-latency rwlock v3

Changelog since v2 :
Add writer fairness in addition to fairness wrt interrupts and softirqs.
Added contention delays performance tests for thread and interrupt contexts to
changelog.

Changelog since v1 :
- No more spinlock to protect against concurrent writes, it is done within
  the existing atomic variable.
- Write fastpath with a single atomic op.

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Sat, 16 Aug 2008, Mathieu Desnoyers wrote:
> > 
> > I have hit this problem when tying to implement a better rwlock design
> > than is currently in the mainline kernel (I know the RT kernel has a
> > hard time with rwlocks)
> 
> Have you looked at my sleping rwlock trial thing?
> 
[...]
>  - and because it is designed for sleeping, I'm pretty sure that you can 
>    easily drop interrupts in the contention path, to make 
>    write_lock_irq[save]() be reasonable.
> 
> In particular, the third bullet is the important one: because it's 
> designed to have a "contention" path that has _extra_ information for the 
> contended case, you could literally make the extra information have things 
> like a list of pending writers, so that you can drop interrupts on one 
> CPU, while you adding information to let the reader side know that if the 
> read-lock happens on that CPU, it needs to be able to continue in order to 
> not deadlock.
> 
> 		Linus

No, I just had a look at it, thanks for the pointer!

Tweakable contention behavior seems interesting, but I don't think it
deals with the fact that on a mainline kernel, when an interrupt handler
comes in and asks for a read lock, it has to get it on the spot. (RT
kernels can get away with that using threaded threaded interrupts, but
that's a completely different scheme). Therefore, the impact is that
interrupts must be disabled around write lock usage, and we end up in
the situation where this interrupt disable section can last for a long
time, given it waits for every readers (including ones which does not
disable interrupts nor softirqs) to complete.

Actually, I just used LTTng traces and eventually made a small patch to
lockdep to detect whenever a spinlock or a rwlock is used both with
interrupts enabled and disabled. Those sites are likely to produce very
high latencies and should IMHO be considered as bogus. The basic bogus
scenario is to have a spinlock held on CPU A with interrupts enabled
being interrupted and then a softirq runs. On CPU B, the same lock is
acquired with interrupts off. We therefore disable interrupts on CPU B
for the duration of the softirq currently running on the CPU A, which is
really not something that helps keeping short latencies. My preliminary
results shows that there are a lot of inconsistent spinlock/rwlock irq
on/off uses in the kernel.

This kind of scenario is pretty easy to fix for spinlocks (either move
the interrupt disable within the spinlock section if the spinlock is
never used by an interrupt handler or make sure that every users has
interrupts disabled).

The problem comes with rwlocks : it is correct to have readers both with
and without irq disable, even when interrupt handlers use the read lock.
However, the write lock has to disable interrupt in that case, and we
suffer from the high latency I pointed out. The tasklist_lock is the
perfect example of this. In the following patch, I try to address this
issue.

The core idea is this :

This "fair" rwlock writer subscribes to the lock, which locks out the 
reader threads. Then, it takes waits until all reader threads exited their
critical section and takes the mutex (1 bit within the "long"). Then it
disables softirqs, locks out the softirqs, waits for all softirqs to exit their
critical section, disables irqs and locks out irqs. It then waits for irqs to
exit their critical section. Only then is the writer allowed to modify the data
structure.

The writer fast path checks for a non-contended lock (all bits set to 0) and
does an atomic cmpxchg to set the subscription, mutex, softirq exclusion and irq
exclusion bits.

The reader does an atomic cmpxchg to check if there is a subscribed writer. If
not, it increments the reader count for its context (thread, softirq, irq).

The test module is available at :

http://ltt.polymtl.ca/svn/trunk/tests/kernel/test-fair-rwlock.c

** Performance tests

Dual quad-core Xeon 2.0GHz E5405

* Lock contention delays, per context, 30s test

6 thread readers (no delay loop)
3 thread writers (no delay loop)
2 periodical interrupt readers on 7/8 cpus (IPIs).

writer_thread/0 iterations : 2757002, max contention 561144 cycles
writer_thread/1 iterations : 2550357, max contention 606036 cycles
writer_thread/2 iterations : 2561024, max contention 593082 cycles
reader_thread/0 iterations : 199444, max contention 5776327560 cycles
reader_thread/1 iterations : 129680, max contention 5768277564 cycles
reader_thread/2 iterations : 76323, max contention 5775994128 cycles
reader_thread/3 iterations : 110571, max contention 4336139232 cycles
reader_thread/4 iterations : 120402, max contention 5513734818 cycles
reader_thread/5 iterations : 227301, max contention 4510503438 cycles
interrupt_reader_thread/0 iterations : 225
interrupt readers on CPU 0, max contention : 46056 cycles
interrupt readers on CPU 1, max contention : 32694 cycles
interrupt readers on CPU 2, max contention : 57432 cycles
interrupt readers on CPU 3, max contention : 29520 cycles
interrupt readers on CPU 4, max contention : 25908 cycles
interrupt readers on CPU 5, max contention : 36246 cycles
interrupt readers on CPU 6, max contention : 17916 cycles
interrupt readers on CPU 7, max contention : 34866 cycles

* Lock contention delays, per context, 600s test

6 thread readers (no delay loop)
3 thread writers (1ms period)
2 periodical interrupt readers on 7/8 cpus (IPIs).

writer_thread/0 iterations : 75001, max contention 42168 cycles
writer_thread/1 iterations : 75008, max contention 43674 cycles
writer_thread/2 iterations : 74999, max contention 43656 cycles
reader_thread/0 iterations : 256202476, max contention 307458 cycles
reader_thread/1 iterations : 270441472, max contention 261648 cycles
reader_thread/2 iterations : 258978159, max contention 171468 cycles
reader_thread/3 iterations : 247473522, max contention 97344 cycles
reader_thread/4 iterations : 285541056, max contention 136842 cycles
reader_thread/5 iterations : 269070814, max contention 134052 cycles
interrupt_reader_thread/0 iterations : 5772
interrupt readers on CPU 0, max contention : 13602 cycles
interrupt readers on CPU 1, max contention : 20082 cycles
interrupt readers on CPU 2, max contention : 12846 cycles
interrupt readers on CPU 3, max contention : 17892 cycles
interrupt readers on CPU 4, max contention : 31572 cycles
interrupt readers on CPU 5, max contention : 27444 cycles
interrupt readers on CPU 6, max contention : 16140 cycles
interrupt readers on CPU 7, max contention : 16026 cycles


Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/fair-rwlock.h |   51 ++++++
 lib/Makefile                |    2 
 lib/fair-rwlock.c           |  368 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)

Index: linux-2.6-lttng/include/linux/fair-rwlock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/fair-rwlock.h	2008-08-17 03:41:00.000000000 -0400
@@ -0,0 +1,51 @@
+#ifndef _LINUX_FAIR_RWLOCK_H
+#define _LINUX_FAIR_RWLOCK_H
+
+/*
+ * Fair low-latency rwlock
+ *
+ * Allows writer fairness wrt readers and also minimally impact the irq latency
+ * of the system.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ * August 2008
+ */
+
+#include <asm/atomic.h>
+
+struct fair_rwlock {
+	atomic_long_t value;
+};
+
+/* Reader lock */
+
+/*
+ * many readers, from irq/softirq/thread context.
+ * protects against writers.
+ */
+void fair_read_lock(struct fair_rwlock *rwlock);
+void fair_read_unlock(struct fair_rwlock *rwlock);
+
+/* Writer Lock */
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against irq/softirq/thread readers.
+ */
+void fair_write_lock_irq(struct fair_rwlock *rwlock);
+void fair_write_unlock_irq(struct fair_rwlock *rwlock);
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against softirq/thread readers.
+ */
+void fair_write_lock_bh(struct fair_rwlock *rwlock);
+void fair_write_unlock_bh(struct fair_rwlock *rwlock);
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against thread readers.
+ */
+void fair_write_lock(struct fair_rwlock *rwlock);
+void fair_write_unlock(struct fair_rwlock *rwlock);
+#endif /* _LINUX_FAIR_RWLOCK_H */
Index: linux-2.6-lttng/lib/Makefile
===================================================================
--- linux-2.6-lttng.orig/lib/Makefile	2008-08-16 03:22:14.000000000 -0400
+++ linux-2.6-lttng/lib/Makefile	2008-08-16 03:29:12.000000000 -0400
@@ -43,6 +43,8 @@ obj-$(CONFIG_DEBUG_PREEMPT) += smp_proce
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
+obj-y += fair-rwlock.o
+
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
 endif
Index: linux-2.6-lttng/lib/fair-rwlock.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/lib/fair-rwlock.c	2008-08-17 03:44:44.000000000 -0400
@@ -0,0 +1,368 @@
+/*
+ * Fair low-latency rwlock
+ *
+ * Allows writer fairness wrt readers and also minimally impact the irq latency
+ * of the system.
+ *
+ * A typical case leading to long interrupt latencies :
+ *
+ * - rwlock shared between
+ *   - Rare update in thread context
+ *   - Frequent slow read in thread context (task list iteration)
+ *   - Fast interrupt handler read
+ *
+ * The slow write must therefore disable interrupts around the write lock,
+ * but will therefore add up to the global interrupt latency; worse case being
+ * the duration of the slow read.
+ *
+ * This "fair" rwlock writer subscribes to the lock, which locks out the reader
+ * threads. Then, it takes waits until all reader threads exited their critical
+ * section and takes the mutex (1 bit within the "long"). Then it disables
+ * softirqs, locks out the softirqs, waits for all softirqs to exit their
+ * critical section, disables irqs and locks out irqs. It then waits for irqs to
+ * exit their critical section. Only then is the writer allowed to modify the
+ * data structure.
+ *
+ * The writer fast path checks for a non-contended lock (all bits set to 0) and
+ * does an atomic cmpxchg to set the subscription, mutex, softirq exclusion and
+ * irq exclusion bits.
+ *
+ * The reader does an atomic cmpxchg to check if there is a subscribed writer.
+ * If not, it increments the reader count for its context (thread, softirq,
+ * irq).
+ *
+ * rwlock bits :
+ *
+ * - bits 0 .. log_2(NR_CPUS)-1) are the thread readers count
+ *   (max number of threads : NR_CPUS)
+ * - bits log_2(NR_CPUS) .. 2*log_2(NR_CPUS)-1 are the softirq readers count
+ *   (max # of softirqs: NR_CPUS)
+ * - bits 2*log_2(NR_CPUS) .. 3*log_2(NR_CPUS)-1 are the hardirq readers count
+ *   (max # of hardirqs: NR_CPUS)
+ *
+ * - bits 3*log_2(NR_CPUS) .. 4*log_2(NR_CPUS)-1 are the writer subscribers
+ *   count. Locks against reader threads if non zero.
+ *   (max # of writer subscribers : NR_CPUS)
+ * - bit 4*log_2(NR_CPUS) is the write mutex
+ * - bit 4*log_2(NR_CPUS)+1 is the writer lock against softirqs
+ * - bit 4*log_2(NR_CPUS)+2 is the writer lock against hardirqs
+ *
+ * e.g. : NR_CPUS = 16
+ *
+ * THREAD_RMASK:      0x0000000f
+ * SOFTIRQ_RMASK:     0x000000f0
+ * HARDIRQ_RMASK:     0x00000f00
+ * SUBSCRIBERS_WMASK: 0x0000f000
+ * WRITER_MUTEX:      0x00010000
+ * SOFTIRQ_WMASK:     0x00020000
+ * HARDIRQ_WMASK:     0x00040000
+ *
+ * Bits usage :
+ *
+ * nr cpus for thread read
+ * nr cpus for softirq read
+ * nr cpus for hardirq read
+ *
+ * IRQ-safe write lock :
+ * nr cpus for write subscribers, disables new thread readers if non zero
+ * if (nr thread read == 0 && write mutex == 0)
+ * 1 bit for write mutex
+ * (softirq off)
+ * 1 bit for softirq exclusion
+ * if (nr softirq read == 0)
+ * (hardirq off)
+ * 1 bit for hardirq exclusion
+ * if (nr hardirq read == 0)
+ * -> locked
+ *
+ * Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/fair-rwlock.h>
+#include <linux/hardirq.h>
+#include <linux/module.h>
+
+#if (NR_CPUS > 64 && (BITS_PER_LONG == 32 || NR_CPUS > 32768))
+#error "fair rwlock needs more bits per long to deal with that many CPUs"
+#endif
+
+#define THREAD_ROFFSET	1UL
+#define THREAD_RMASK	((NR_CPUS - 1) * THREAD_ROFFSET)
+#define SOFTIRQ_ROFFSET	(THREAD_RMASK + 1)
+#define SOFTIRQ_RMASK	((NR_CPUS - 1) * SOFTIRQ_ROFFSET)
+#define HARDIRQ_ROFFSET	((SOFTIRQ_RMASK | THREAD_RMASK) + 1)
+#define HARDIRQ_RMASK	((NR_CPUS - 1) * HARDIRQ_ROFFSET)
+
+#define SUBSCRIBERS_WOFFSET	\
+	((HARDIRQ_RMASK | SOFTIRQ_RMASK | THREAD_RMASK) + 1)
+#define SUBSCRIBERS_WMASK	\
+	((NR_CPUS - 1) * SUBSCRIBERS_WOFFSET)
+#define WRITER_MUTEX		\
+	((SUBSCRIBERS_WMASK | HARDIRQ_RMASK | SOFTIRQ_RMASK | THREAD_RMASK) + 1)
+#define SOFTIRQ_WMASK	(WRITER_MUTEX << 1)
+#define SOFTIRQ_WOFFSET	SOFTIRQ_WMASK
+#define HARDIRQ_WMASK	(SOFTIRQ_WMASK << 1)
+#define HARDIRQ_WOFFSET	HARDIRQ_WMASK
+
+#ifdef FAIR_RWLOCK_DEBUG
+#define printk_dbg printk
+#else
+#define printk_dbg(fmt, args...)
+#endif
+
+/* Reader lock */
+
+static void _fair_read_lock_ctx(struct fair_rwlock *rwlock,
+		long roffset, long wmask)
+{
+	long value;
+
+	for (;;) {
+		value = atomic_long_read(&rwlock->value);
+		if (value & wmask) {
+			/* Order value reads */
+			smp_rmb();
+			continue;
+		}
+		if (atomic_long_cmpxchg(&rwlock->value, value, value + roffset)
+				== value)
+			break;
+	}
+
+	printk_dbg("lib reader got in with value %lX, wmask %lX\n",
+		value, wmask);
+}
+
+/*
+ * many readers, from irq/softirq/thread context.
+ * protects against writers.
+ */
+void fair_read_lock(struct fair_rwlock *rwlock)
+{
+	if (in_irq())
+		_fair_read_lock_ctx(rwlock, HARDIRQ_ROFFSET, HARDIRQ_WMASK);
+	else if (in_softirq())
+		_fair_read_lock_ctx(rwlock, SOFTIRQ_ROFFSET, SOFTIRQ_WMASK);
+	else {
+		preempt_disable();
+		_fair_read_lock_ctx(rwlock, THREAD_ROFFSET, SUBSCRIBERS_WMASK);
+	}
+}
+EXPORT_SYMBOL_GPL(fair_read_lock);
+
+void fair_read_unlock(struct fair_rwlock *rwlock)
+{
+	/* atomic_long_sub orders reads */
+	if (in_irq())
+		atomic_long_sub(HARDIRQ_ROFFSET, &rwlock->value);
+	else if (in_softirq())
+		atomic_long_sub(SOFTIRQ_ROFFSET, &rwlock->value);
+	else {
+		atomic_long_sub(THREAD_ROFFSET, &rwlock->value);
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL_GPL(fair_read_unlock);
+
+/* Writer lock */
+
+/*
+ * Lock out a specific execution context from the read lock. Wait for both the
+ * rmask and the wmask to be empty before proceeding to take the lock.
+ */
+static void _fair_write_lock_ctx_wait(struct fair_rwlock *rwlock,
+		long rmask, long wmask)
+{
+	long value;
+
+	for (;;) {
+		value = atomic_long_read(&rwlock->value);
+		if (value & (rmask | wmask)) {
+			/* Order value reads */
+			smp_rmb();
+			continue;
+		}
+		if (atomic_long_cmpxchg(&rwlock->value, value, value | wmask)
+				== value)
+			break;
+	}
+	printk_dbg("lib writer got in with value %lX, new %lX, rmask %lX\n",
+		value, value | wmask, rmask);
+}
+
+/*
+ * Lock out a specific execution context from the read lock. First lock the read
+ * context out of the lock, then wait for every readers to exit their critical
+ * section.
+ */
+static void _fair_write_lock_ctx_force(struct fair_rwlock *rwlock,
+		long rmask, long woffset)
+{
+	long value;
+
+	atomic_long_add(woffset, &rwlock->value);
+	do {
+		value = atomic_long_read(&rwlock->value);
+		/* Order rwlock->value read wrt following reads */
+		smp_rmb();
+	} while (value & rmask);
+	printk_dbg("lib writer got in with value %lX, woffset %lX, rmask %lX\n",
+		value, woffset, rmask);
+}
+
+
+/*
+ * Uncontended fastpath.
+ */
+static int fair_write_lock_irq_fast(struct fair_rwlock *rwlock)
+{
+	long value;
+
+
+	value = atomic_long_read(&rwlock->value);
+	if (likely(!value)) {
+		/* no other reader nor writer present, try to take the lock */
+		local_bh_disable();
+		local_irq_disable();
+		if (likely(atomic_long_cmpxchg(&rwlock->value, value,
+				value + (SUBSCRIBERS_WOFFSET | SOFTIRQ_WOFFSET
+					| HARDIRQ_WOFFSET | WRITER_MUTEX))
+						== value))
+			return 1;
+		local_irq_enable();
+		local_bh_enable();
+	}
+	return 0;
+}
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against irq/softirq/thread readers.
+ */
+void fair_write_lock_irq(struct fair_rwlock *rwlock)
+{
+	preempt_disable();
+
+	if (likely(fair_write_lock_irq_fast(rwlock)))
+		return;
+
+	/* lock out threads */
+	atomic_long_add(SUBSCRIBERS_WOFFSET, &rwlock->value);
+
+	/* lock out other writers when no reader threads left */
+	_fair_write_lock_ctx_wait(rwlock, THREAD_RMASK, WRITER_MUTEX);
+
+	/* lock out softirqs */
+	local_bh_disable();
+	_fair_write_lock_ctx_force(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WOFFSET);
+
+	/* lock out hardirqs */
+	local_irq_disable();
+	_fair_write_lock_ctx_force(rwlock, HARDIRQ_RMASK, HARDIRQ_WOFFSET);
+
+	/* atomic_long_cmpxchg orders writes */
+}
+EXPORT_SYMBOL_GPL(fair_write_lock_irq);
+
+void fair_write_unlock_irq(struct fair_rwlock *rwlock)
+{
+	/*
+	 * atomic_long_sub makes sure we commit the data before reenabling
+	 * the lock.
+	 */
+	atomic_long_sub(HARDIRQ_WOFFSET | SOFTIRQ_WOFFSET
+			| WRITER_MUTEX | SUBSCRIBERS_WOFFSET,
+			&rwlock->value);
+	local_irq_enable();
+	local_bh_enable();
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(fair_write_unlock_irq);
+
+/*
+ * Uncontended fastpath.
+ */
+static int fair_write_lock_bh_fast(struct fair_rwlock *rwlock)
+{
+	long value;
+
+	value = atomic_long_read(&rwlock->value);
+	if (likely(!value)) {
+		/* no other reader nor writer present, try to take the lock */
+		local_bh_disable();
+		if (likely(atomic_long_cmpxchg(&rwlock->value, value,
+					(value + SUBSCRIBERS_WOFFSET
+					+ SOFTIRQ_WOFFSET) | WRITER_MUTEX)
+							== value))
+			return 1;
+		local_bh_enable();
+	}
+	return 0;
+}
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against softirq/thread readers.
+ */
+void fair_write_lock_bh(struct fair_rwlock *rwlock)
+{
+	preempt_disable();
+
+	if (likely(fair_write_lock_bh_fast(rwlock)))
+		return;
+
+	/* lock out threads */
+	atomic_long_add(SUBSCRIBERS_WOFFSET, &rwlock->value);
+
+	/* lock out other writers when no reader threads left */
+	_fair_write_lock_ctx_wait(rwlock, THREAD_RMASK, WRITER_MUTEX);
+
+	/* lock out softirqs */
+	local_bh_disable();
+	_fair_write_lock_ctx_force(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WOFFSET);
+
+	/* atomic_long_cmpxchg orders writes */
+}
+EXPORT_SYMBOL_GPL(fair_write_lock_bh);
+
+void fair_write_unlock_bh(struct fair_rwlock *rwlock)
+{
+	/*
+	 * atomic_long_sub makes sure we commit the data before reenabling
+	 * the lock.
+	 */
+	atomic_long_sub(SOFTIRQ_WOFFSET | WRITER_MUTEX | SUBSCRIBERS_WOFFSET,
+			&rwlock->value);
+	local_bh_enable();
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(fair_write_unlock_bh);
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against thread readers.
+ */
+void fair_write_lock(struct fair_rwlock *rwlock)
+{
+	preempt_disable();
+
+	/* lock out threads */
+	atomic_long_add(SUBSCRIBERS_WOFFSET, &rwlock->value);
+
+	/* lock out other writers when no reader threads left */
+	_fair_write_lock_ctx_wait(rwlock, THREAD_RMASK, WRITER_MUTEX);
+
+	/* atomic_long_cmpxchg orders writes */
+}
+EXPORT_SYMBOL_GPL(fair_write_lock);
+
+void fair_write_unlock(struct fair_rwlock *rwlock)
+{
+	/*
+	 * atomic_long_sub makes sure we commit the data before reenabling
+	 * the lock.
+	 */
+	atomic_long_sub(WRITER_MUTEX | SUBSCRIBERS_WOFFSET, &rwlock->value);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(fair_write_unlock);


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
