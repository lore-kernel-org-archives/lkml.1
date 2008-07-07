Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYGGTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYGGTcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYGGTcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:32:12 -0400
Received: from 166.sub-75-208-119.myvzw.com ([75.208.119.166]:60977 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754140AbYGGTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:32:11 -0400
Message-Id: <20080707190838.710151521@goop.org>
References: <20080707190749.299430659@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 12:07:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 4/4] xen: implement Xen-specific spinlocks
Content-Disposition: inline; filename=xen-pv-spinlocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard ticket spinlocks are very expensive in a virtual
environment, because their performance depends on Xen's scheduler
giving vcpus time in the order that they're supposed to take the
spinlock.

This implements a Xen-specific spinlock, which should be much more
efficient.

The fast-path is essentially the old Linux-x86 locks, using a single
lock byte.  The locker decrements the byte; if the result is 0, then
they have the lock.  If the lock is negative, then locker must spin
until the lock is positive again.

When there's contention, the locker spin for 2^16[*] iterations waiting
to get the lock.  If it fails to get the lock in that time, it adds
itself to the contention count in the lock and blocks on a per-cpu
event channel.

When unlocking the spinlock, the locker looks to see if there's anyone
blocked waiting for the lock by checking for a non-zero waiter count.
If there's a waiter, it traverses the per-cpu "lock_spinners"
variable, which contains which lock each CPU is waiting on.  It picks
one CPU waiting on the lock and sends it an event to wake it up.

This allows efficient fast-path spinlock operation, while allowing
spinning vcpus to give up their processor time while waiting for a
contended lock.

[*] 2^16 iterations is threshold at which 98% locks have been taken
according to Thomas Friebel's Xen Summit talk "Preventing Guests from
Spinning Around".  Therefore, we'd expect the lock and unlock slow
paths will only be entered 2% of the time.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Thomas Friebel <thomas.friebel@amd.com>
---
 arch/x86/xen/smp.c           |  172 +++++++++++++++++++++++++++++++++++++++++-
 drivers/xen/events.c         |   27 ++++++
 include/asm-x86/xen/events.h |    1 
 include/xen/events.h         |    7 +
 4 files changed, 206 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -15,6 +15,7 @@
  * This does not handle HOTPLUG_CPU yet.
  */
 #include <linux/sched.h>
+#include <linux/kernel_stat.h>
 #include <linux/err.h>
 #include <linux/smp.h>
 
@@ -34,6 +35,8 @@
 
 #include "xen-ops.h"
 #include "mmu.h"
+
+static void __cpuinit xen_init_lock_cpu(int cpu);
 
 cpumask_t xen_cpu_initialized_map;
 
@@ -179,6 +182,8 @@
 {
 	unsigned cpu;
 
+	xen_init_lock_cpu(0);
+
 	smp_store_cpu_info(0);
 	cpu_data(0).x86_max_cores = 1;
 	set_cpu_sibling_map(0);
@@ -301,6 +306,7 @@
 	clear_tsk_thread_flag(idle, TIF_FORK);
 #endif
 	xen_setup_timer(cpu);
+	xen_init_lock_cpu(cpu);
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
@@ -413,6 +419,170 @@
 	return IRQ_HANDLED;
 }
 
+struct xen_spinlock {
+	unsigned char lock;		/* 0 -> free; 1 -> locked */
+	unsigned short spinners;	/* count of waiting cpus */
+};
+
+static int xen_spin_is_locked(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	return xl->lock != 0;
+}
+
+static int xen_spin_is_contended(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	/* Not strictly true; this is only the count of contended
+	   lock-takers entering the slow path. */
+	return xl->spinners != 0;
+}
+
+static int xen_spin_trylock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	u8 old = 1;
+
+	asm("xchgb %b0,%1"
+	    : "+q" (old), "+m" (xl->lock) : : "memory");
+
+	return old == 0;
+}
+
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
+
+static inline void spinning_lock(struct xen_spinlock *xl)
+{
+	__get_cpu_var(lock_spinners) = xl;
+	wmb();			/* set lock of interest before count */
+	asm(LOCK_PREFIX " incw %0"
+	    : "+m" (xl->spinners) : : "memory");
+}
+
+static inline void unspinning_lock(struct xen_spinlock *xl)
+{
+	asm(LOCK_PREFIX " decw %0"
+	    : "+m" (xl->spinners) : : "memory");
+	wmb();			/* decrement count before clearing lock */
+	__get_cpu_var(lock_spinners) = NULL;
+}
+
+static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	int irq = __get_cpu_var(lock_kicker_irq);
+	int ret;
+
+	/* If kicker interrupts not initialized yet, just spin */
+	if (irq == -1)
+		return 0;
+
+	/* announce we're spinning */
+	spinning_lock(xl);
+
+	/* clear pending */
+	xen_clear_irq_pending(irq);
+
+	/* check again make sure it didn't become free while
+	   we weren't looking  */
+	ret = xen_spin_trylock(lock);
+	if (ret)
+		goto out;
+
+	/* block until irq becomes pending */
+	xen_poll_irq(irq);
+	kstat_this_cpu.irqs[irq]++;
+
+out:
+	unspinning_lock(xl);
+	return ret;
+}
+
+static void xen_spin_lock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	int timeout;
+	u8 oldval;
+
+	do {
+		timeout = 1 << 10;
+
+		asm("1: xchgb %1,%0\n"
+		    "   testb %1,%1\n"
+		    "   jz 3f\n"
+		    "2: rep;nop\n"
+		    "   cmpb $0,%0\n"
+		    "   je 1b\n"
+		    "   dec %2\n"
+		    "   jnz 2b\n"
+		    "3:\n"
+		    : "+m" (xl->lock), "=q" (oldval), "+r" (timeout)
+		    : "1" (1)
+		    : "memory");
+
+	} while (unlikely(oldval != 0 && !xen_spin_lock_slow(lock)));
+}
+
+static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		/* XXX should mix up next cpu selection */
+		if (per_cpu(lock_spinners, cpu) == xl) {
+			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
+			break;
+		}
+	}
+}
+
+static void xen_spin_unlock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	smp_wmb();		/* make sure no writes get moved after unlock */
+	xl->lock = 0;		/* release lock */
+
+	/* make sure unlock happens before kick */
+	barrier();
+
+	if (unlikely(xl->spinners))
+		xen_spin_unlock_slow(xl);
+}
+
+static __cpuinit void xen_init_lock_cpu(int cpu)
+{
+	int irq;
+	const char *name;
+
+	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
+	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
+				     cpu,
+				     xen_reschedule_interrupt,
+				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				     name,
+				     NULL);
+
+	if (irq >= 0) {
+		disable_irq(irq); /* make sure it's never delivered */
+		per_cpu(lock_kicker_irq, cpu) = irq;
+	}
+
+	printk("cpu %d spinlock event irq %d\n", cpu, irq);
+}
+
+static void __init xen_init_spinlocks(void)
+{
+	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
+	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
+	pv_lock_ops.spin_lock = xen_spin_lock;
+	pv_lock_ops.spin_trylock = xen_spin_trylock;
+	pv_lock_ops.spin_unlock = xen_spin_unlock;
+}
+
 static const struct smp_ops xen_smp_ops __initdata = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
@@ -430,5 +600,5 @@
 {
 	smp_ops = xen_smp_ops;
 	xen_fill_possible_map();
-	paravirt_use_bytelocks();
+	xen_init_spinlocks();
 }
===================================================================
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -741,6 +741,33 @@
 	}
 }
 
+/* Clear an irq's pending state, in preparation for polling on it */
+void xen_clear_irq_pending(int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+
+	if (VALID_EVTCHN(evtchn))
+		clear_evtchn(evtchn);
+}
+
+/* Poll waiting for an irq to become pending.  In the usual case, the
+   irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq(int irq)
+{
+	evtchn_port_t evtchn = evtchn_from_irq(irq);
+
+	if (VALID_EVTCHN(evtchn)) {
+		struct sched_poll poll;
+
+		poll.nr_ports = 1;
+		poll.timeout = 0;
+		poll.ports = &evtchn;
+
+		if (HYPERVISOR_sched_op(SCHEDOP_poll, &poll) != 0)
+			BUG();
+	}
+}
+
 void xen_irq_resume(void)
 {
 	unsigned int cpu, irq, evtchn;
===================================================================
--- a/include/asm-x86/xen/events.h
+++ b/include/asm-x86/xen/events.h
@@ -5,6 +5,7 @@
 	XEN_RESCHEDULE_VECTOR,
 	XEN_CALL_FUNCTION_VECTOR,
 	XEN_CALL_FUNCTION_SINGLE_VECTOR,
+	XEN_SPIN_UNLOCK_VECTOR,
 
 	XEN_NR_IPIS,
 };
===================================================================
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -45,4 +45,11 @@
 extern void xen_irq_resume(void);
 extern void xen_evtchn_do_upcall(struct pt_regs *regs);
 
+/* Clear an irq's pending state, in preparation for polling on it */
+void xen_clear_irq_pending(int irq);
+
+/* Poll waiting for an irq to become pending.  In the usual case, the
+   irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq(int irq);
+
 #endif	/* _XEN_EVENTS_H */

-- 

