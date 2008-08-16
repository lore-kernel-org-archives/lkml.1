Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYHPVUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYHPVUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 17:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYHPVT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 17:19:59 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:46690 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYHPVT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 17:19:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJ3fpkhMRKxB/2dsb2JhbACBYrBggVg
Date: Sat, 16 Aug 2008 17:19:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Fair rwlock
Message-ID: <20080816211954.GB7358@Krystal>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:52:04 up 73 days,  1:32,  6 users,  load average: 3.78, 2.45,
	1.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This "fair" rwlock locks out the threads first, then disables softirqs,
then locks out the softirqs, then disables irqs and locks out softirqs. Only
then is the writer allowed to modify the data structure.

A spinlock is used to insure writer mutual exclusion.

The test module is available at :

http://ltt.polymtl.ca/svn/trunk/tests/kernel/test-fair-rwlock.c

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/fair-rwlock.h |   64 +++++++++++
 lib/Makefile                |    2 
 lib/fair-rwlock.c           |  244 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 310 insertions(+)

Index: linux-2.6-lttng/include/linux/fair-rwlock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/fair-rwlock.h	2008-08-16 03:29:12.000000000 -0400
@@ -0,0 +1,64 @@
+/*
+ * Fair rwlock
+ *
+ * Allows more fairness than the standard rwlock for this kind of common
+ * scenario (tasklist_lock) :
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
+ * This "fair" rwlock locks out the threads first, then disables softirqs,
+ * then locks out the softirqs, then disables irqs and locks out softirqs. Only
+ * then is the writer allowed to modify the data structure.
+ *
+ * A spinlock is used to insure writer mutual exclusion.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ * August 2008
+ */
+
+#include <linux/spinlock.h>
+#include <asm/atomic.h>
+
+struct fair_rwlock {
+	atomic_long_t value;
+	spinlock_t wlock;
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
+++ linux-2.6-lttng/lib/fair-rwlock.c	2008-08-16 16:48:26.000000000 -0400
@@ -0,0 +1,244 @@
+/*
+ * Fair rwlock
+ *
+ * Allows more fairness than the standard rwlock for this kind of common
+ * scenario (tasklist_lock) :
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
+ * This "fair" rwlock locks out the threads first, then disables softirqs,
+ * then locks out the softirqs, then disables irqs and locks out softirqs. Only
+ * then is the writer allowed to modify the data structure.
+ *
+ * A spinlock is used to insure writer mutual exclusion.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ * August 2008
+ *
+ * Distributed under GPLv2
+ *
+ * concurrency between :
+ * - thread
+ * - softirq handlers
+ * - hardirq handlers
+ *
+ * System-wide max
+ *
+ * - bits 0 .. log_2(NR_CPUS)-1) are the thread count
+ *   (max number of threads : NR_CPUS)
+ * - bit 3*log_2(NR_CPUS) is the writer lock against threads
+ *
+ * - bits log_2(NR_CPUS) .. 2*log_2(NR_CPUS)-1 are the softirq count
+ *   (max # of softirqs: NR_CPUS)
+ * - bit 3*log_2(NR_CPUS)+1 is the writer lock against softirqs
+ *
+ * - bits 2*log_2(NR_CPUS) .. 3*log_2(NR_CPUS)-1 are the hardirq count
+ *   (max # of hardirqs: NR_CPUS)
+ * - bit 3*log_2(NR_CPUS)+2 is the writer lock against hardirqs
+ *
+ * e.g. : NR_CPUS = 256
+ *
+ * THREAD_RMASK:  0x000000ff
+ * SOFTIRQ_RMASK: 0x0000ff00
+ * HARDIRQ_RMASK: 0x00ff0000
+ * THREAD_WMASK:  0x01000000
+ * SOFTIRQ_WMASK: 0x02000000
+ * HARDIRQ_WMASK: 0x04000000
+ */
+
+#include <linux/fair-rwlock.h>
+#include <linux/hardirq.h>
+#include <linux/module.h>
+
+#if (NR_CPUS > 512 && (BITS_PER_LONG == 32 || NR_CPUS > 1048576))
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
+#define THREAD_WMASK	((HARDIRQ_RMASK | SOFTIRQ_RMASK | THREAD_RMASK) + 1)
+#define SOFTIRQ_WMASK	(THREAD_WMASK << 1)
+#define HARDIRQ_WMASK	(SOFTIRQ_WMASK << 1)
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
+	atomic_long_add(roffset, &rwlock->value);
+	do {
+		value = atomic_long_read(&rwlock->value);
+		/* Order rwlock->value read wrt following reads */
+		smp_rmb();
+	} while (value & wmask);
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
+		_fair_read_lock_ctx(rwlock, THREAD_ROFFSET, THREAD_WMASK);
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
+/* Lock out a specific execution context from the lock */
+static void _fair_write_lock_ctx(struct fair_rwlock *rwlock,
+		long rmask, long wmask)
+{
+	long value;
+
+	for (;;) {
+		value = atomic_long_read(&rwlock->value);
+		if (value & rmask) {
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
+ * Safe against other writers in thread context.
+ * Safe against irq/softirq/thread readers.
+ */
+void fair_write_lock_irq(struct fair_rwlock *rwlock)
+{
+	spin_lock(&rwlock->wlock);
+
+	/* lock out threads */
+	_fair_write_lock_ctx(rwlock, THREAD_RMASK, THREAD_WMASK);
+
+	/* lock out softirqs */
+	local_bh_disable();
+	_fair_write_lock_ctx(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WMASK);
+
+	/* lock out hardirqs */
+	local_irq_disable();
+	_fair_write_lock_ctx(rwlock, HARDIRQ_RMASK, HARDIRQ_WMASK);
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
+	atomic_long_sub(THREAD_WMASK | SOFTIRQ_WMASK | HARDIRQ_WMASK,
+			&rwlock->value);
+	local_irq_enable();
+	local_bh_enable();
+	spin_unlock(&rwlock->wlock);
+}
+EXPORT_SYMBOL_GPL(fair_write_unlock_irq);
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against softirq/thread readers.
+ */
+void fair_write_lock_bh(struct fair_rwlock *rwlock)
+{
+	spin_lock(&rwlock->wlock);
+
+	/* lock out threads */
+	_fair_write_lock_ctx(rwlock, THREAD_RMASK, THREAD_WMASK);
+
+	/* lock out softirqs */
+	local_bh_disable();
+	_fair_write_lock_ctx(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WMASK);
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
+	atomic_long_sub(THREAD_WMASK | SOFTIRQ_WMASK, &rwlock->value);
+	local_bh_enable();
+	spin_unlock(&rwlock->wlock);
+}
+EXPORT_SYMBOL_GPL(fair_write_unlock_bh);
+
+/*
+ * Safe against other writers in thread context.
+ * Safe against thread readers.
+ */
+void fair_write_lock(struct fair_rwlock *rwlock)
+{
+	spin_lock(&rwlock->wlock);
+
+	/* lock out threads */
+	_fair_write_lock_ctx(rwlock, THREAD_RMASK, THREAD_WMASK);
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
+	atomic_long_sub(THREAD_WMASK, &rwlock->value);
+	spin_unlock(&rwlock->wlock);
+}
+EXPORT_SYMBOL_GPL(fair_write_unlock);


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
