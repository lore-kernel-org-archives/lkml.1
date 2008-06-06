Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbYFFPV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbYFFPV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYFFPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:21:47 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49426 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645AbYFFPVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:21:45 -0400
Date: Fri, 6 Jun 2008 08:21:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, minyard@acm.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
Message-ID: <20080606152134.GA13641@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

A couple of questions about the x86 architecture...

1.	Can recoverable machine-check exceptions occur from within
	NMI handlers?  If so, there is a bug in preemptable RCU's
	CONFIG_NO_HZ handling that could be fixed by a patch something
	like the one shown below (untested, probably does not even
	compile).

2.	Does the IPMI subsystem make use of RCU read-side primitives
	from within SMI handlers?  If so, we need the SMI handlers to
	invoke rcu_irq_enter() upon entry and rcu_irq_exit() upon exit
	when they are invoked from dynticks idle state.  Or something
	similar, depending on restrictions on code within SMI handlers.

If I need to forward either of these questions to someone else, please
let me know!

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcupreempt.h |   18 -----
 kernel/rcupreempt.c        |  156 ++++++++++++++++++++-------------------------
 2 files changed, 73 insertions(+), 101 deletions(-)

diff -urpNa -X dontdiff linux-2.6.26-rc4/include/linux/rcupreempt.h linux-2.6.26-rc4-nohznest/include/linux/rcupreempt.h
--- linux-2.6.26-rc4/include/linux/rcupreempt.h	2008-05-30 04:39:01.000000000 -0700
+++ linux-2.6.26-rc4-nohznest/include/linux/rcupreempt.h	2008-06-01 07:21:25.000000000 -0700
@@ -81,22 +81,8 @@ extern struct rcupreempt_trace *rcupreem
 struct softirq_action;
 
 #ifdef CONFIG_NO_HZ
-DECLARE_PER_CPU(long, dynticks_progress_counter);
-
-static inline void rcu_enter_nohz(void)
-{
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
-}
-
-static inline void rcu_exit_nohz(void)
-{
-	__get_cpu_var(dynticks_progress_counter)++;
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
-	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
-}
-
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
 #else /* CONFIG_NO_HZ */
 #define rcu_enter_nohz()	do { } while (0)
 #define rcu_exit_nohz()		do { } while (0)
diff -urpNa -X dontdiff linux-2.6.26-rc4/kernel/rcupreempt.c linux-2.6.26-rc4-nohznest/kernel/rcupreempt.c
--- linux-2.6.26-rc4/kernel/rcupreempt.c	2008-05-30 04:39:01.000000000 -0700
+++ linux-2.6.26-rc4-nohznest/kernel/rcupreempt.c	2008-06-01 07:21:22.000000000 -0700
@@ -415,9 +415,57 @@ static void __rcu_advance_callbacks(stru
 
 #ifdef CONFIG_NO_HZ
 
-DEFINE_PER_CPU(long, dynticks_progress_counter) = 1;
+/*
+ * The low-order DYNTICKS_PROGRESS_SHIFT bits are a nesting-level count,
+ * and the rest of the bits are a counter that, when even, indicates that
+ * the corresponding CPU is in dynticks-idle mode (and thus should be
+ * ignored by RCU).  Otherwise, if the counter represented by the upper
+ * bits is odd, RCU must pay attention to this CPU.  This counter is
+ * manipulated atomically only when entering or exiting dynticks-idle
+ * mode.  All other cases use non-atomic instructions and avoid all
+ * memory barriers.
+ */
+
+DEFINE_PER_CPU(atomic_t, dynticks_progress_counter) = ATOMIC_INIT(1);
 static DEFINE_PER_CPU(long, rcu_dyntick_snapshot);
-static DEFINE_PER_CPU(int, rcu_update_flag);
+
+#define DYNTICKS_PROGRESS_SHIFT		8
+#define DYNTICKS_PROGRESS_LOB		(1 << DYNITICKS_PROGRESS_SHIFT)
+#define DYNTICKS_PROGRESS_NEST_MASK	(DYNTICKS_PROGRESS_LOB - 1)
+
+/**
+ * rcu_enter_nohz - Called before shutting down scheduling-clock irq.
+ *
+ * This updates the dynticks_progress_counter to let the RCU
+ * grace-period detection machinery know that this CPU is no
+ * longer active.
+ */
+void rcu_enter_nohz(void)
+{
+	atomic_t *dpcp = &__get_cpu_var(dynticks_progress_counter);
+
+	smp_mb();
+	atomic_add(DYNTICKS_PROGRESS_CTR_LOB - 1, dpcp);
+	WARN_ON(atomic_read(dpcp) &
+		(DYNTICKS_PROGRESS_CTR_LOB + DYNTICKS_PROGRESS_NEST_MASK));
+}
+
+/**
+ * rcu_exit_nohz - Called before restarting scheduling-clock irq.
+ *
+ * This updates the dynticks_progress_counter to let the RCU
+ * grace-period detection machinery know that this CPU is once
+ * again active.
+ */
+void rcu_exit_nohz(void)
+{
+	atomic_t *dpcp = &__get_cpu_var(dynticks_progress_counter);
+
+	atomic_add(DYNTICKS_PROGRESS_CTR_LOB + 1, dpcp);
+	smp_mb();
+	WARN_ON(!(atomic_read(dpcp) & DYNTICKS_PROGRESS_CTR_LOB) ||
+		!(atomic_read(dpcp) & DYNTICKS_PROGRESS_NEST_MASK));
+}
 
 /**
  * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
@@ -429,62 +477,16 @@ static DEFINE_PER_CPU(int, rcu_update_fl
 void rcu_irq_enter(void)
 {
 	int cpu = smp_processor_id();
+	atomic_t *dpcp = &per_cpu(dynticks_progress_counter, cpu);
 
-	if (per_cpu(rcu_update_flag, cpu))
-		per_cpu(rcu_update_flag, cpu)++;
+	if (atomic_read(dpcp) & DYNTICKS_PROGRESS_CTR_LOB) {
 
-	/*
-	 * Only update if we are coming from a stopped ticks mode
-	 * (dynticks_progress_counter is even).
-	 */
-	if (!in_interrupt() &&
-	    (per_cpu(dynticks_progress_counter, cpu) & 0x1) == 0) {
-		/*
-		 * The following might seem like we could have a race
-		 * with NMI/SMIs. But this really isn't a problem.
-		 * Here we do a read/modify/write, and the race happens
-		 * when an NMI/SMI comes in after the read and before
-		 * the write. But NMI/SMIs will increment this counter
-		 * twice before returning, so the zero bit will not
-		 * be corrupted by the NMI/SMI which is the most important
-		 * part.
-		 *
-		 * The only thing is that we would bring back the counter
-		 * to a postion that it was in during the NMI/SMI.
-		 * But the zero bit would be set, so the rest of the
-		 * counter would again be ignored.
-		 *
-		 * On return from the IRQ, the counter may have the zero
-		 * bit be 0 and the counter the same as the return from
-		 * the NMI/SMI. If the state machine was so unlucky to
-		 * see that, it still doesn't matter, since all
-		 * RCU read-side critical sections on this CPU would
-		 * have already completed.
-		 */
-		per_cpu(dynticks_progress_counter, cpu)++;
-		/*
-		 * The following memory barrier ensures that any
-		 * rcu_read_lock() primitives in the irq handler
-		 * are seen by other CPUs to follow the above
-		 * increment to dynticks_progress_counter. This is
-		 * required in order for other CPUs to correctly
-		 * determine when it is safe to advance the RCU
-		 * grace-period state machine.
-		 */
-		smp_mb(); /* see above block comment. */
-		/*
-		 * Since we can't determine the dynamic tick mode from
-		 * the dynticks_progress_counter after this routine,
-		 * we use a second flag to acknowledge that we came
-		 * from an idle state with ticks stopped.
-		 */
-		per_cpu(rcu_update_flag, cpu)++;
-		/*
-		 * If we take an NMI/SMI now, they will also increment
-		 * the rcu_update_flag, and will not update the
-		 * dynticks_progress_counter on exit. That is for
-		 * this IRQ to do.
-		 */
+		/* Nested interrupt, just adjust the nesting level. */
+
+		atomic_set(dpcp, atomic_read(dpcp) + 1);
+		WARN_ON(!(atomic_read(dpcp) & DYNTICKS_PROGRESS_CTR_LOB) ||
+			!(atomic_read(dpcp) & DYNTICKS_PROGRESS_NEST_MASK));
+		return;
 	}
 }
 
@@ -498,41 +500,25 @@ void rcu_irq_enter(void)
 void rcu_irq_exit(void)
 {
 	int cpu = smp_processor_id();
+	atomic_t *dpcp = &per_cpu(dynticks_progress_counter, cpu);
 
-	/*
-	 * rcu_update_flag is set if we interrupted the CPU
-	 * when it was idle with ticks stopped.
-	 * Once this occurs, we keep track of interrupt nesting
-	 * because a NMI/SMI could also come in, and we still
-	 * only want the IRQ that started the increment of the
-	 * dynticks_progress_counter to be the one that modifies
-	 * it on exit.
-	 */
-	if (per_cpu(rcu_update_flag, cpu)) {
-		if (--per_cpu(rcu_update_flag, cpu))
-			return;
-
-		/* This must match the interrupt nesting */
-		WARN_ON(in_interrupt());
+	if ((atomic_read(dpcp) &
+	     (DYNTICKS_PROGRESS_CTR_LOB | DYNTICKS_PROGRESS_NEST_MASK)) !=
+	    (DYNTICKS_PROGRESS_CTR_LOB | DYNTICKS_PROGRESS_NEST_MASK)) {
 
 		/*
-		 * If an NMI/SMI happens now we are still
-		 * protected by the dynticks_progress_counter being odd.
+		 * This rcu_irq_exit() will not bring the nesting count
+		 * to zero, so it will not put us back into dynticks-idle
+		 * mode.  So we need only decrement the nesting count.
 		 */
 
-		/*
-		 * The following memory barrier ensures that any
-		 * rcu_read_unlock() primitives in the irq handler
-		 * are seen by other CPUs to preceed the following
-		 * increment to dynticks_progress_counter. This
-		 * is required in order for other CPUs to determine
-		 * when it is safe to advance the RCU grace-period
-		 * state machine.
-		 */
-		smp_mb(); /* see above block comment. */
-		per_cpu(dynticks_progress_counter, cpu)++;
-		WARN_ON(per_cpu(dynticks_progress_counter, cpu) & 0x1);
+		atomic_set(dpcp, atomic_read(dpcp) - 1);
+		WARN_ON(!(atomic_read(dpcp) & DYNTICKS_PROGRESS_CTR_LOB) ||
+			!(atomic_read(dpcp) & DYNTICKS_PROGRESS_NEST_MASK));
+		return;
 	}
+	smp_mb();
+	atomic_add(DYNTICKS_PROGRESS_CTR_LOB - 1, dpcp);
 }
 
 static void dyntick_save_progress_counter(int cpu)
