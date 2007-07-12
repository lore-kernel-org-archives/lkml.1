Return-Path: <linux-kernel-owner+w=401wt.eu-S935753AbXGLANF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935753AbXGLANF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936888AbXGLACJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:02:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44344 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935980AbXGLACE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:02:04 -0400
Date: Wed, 11 Jul 2007 17:01:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       linux-rt-users@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH -rt WIP] NMI-safe lightweight parallel-update -rt RCU
Message-ID: <20070712000157.GA4168@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Just work in progress, not recommended for inclusion.  Seems stable
under rigorous rcutorture testing, so should be OK for experimentation.

This snapshot has an implementation of rcu_read_lock() and
rcu_read_unlock() that may be invoked from NMI/SMI handlers, and that
do not contain any heavyweight atomics or memory barriers (though they
still do momentarily disable IRQs).  The grace-period computation is now
fully parallel, which will become important with upcoming multicore CPUs.

Next steps: (1) port to -mm.  (2) bring forward to latest -rt.  (3)
remove ugly debug code.  (4) integrate with CPU hotplug (which should
finally be easy to do).  (5) integrate with dynticks, hopefully so as
to not require waking up dynticked CPUs unnecessarily.  (6) get RCU
priority boosting re-merged (which I have done for testing purposes a
couple of times along the way).  (7) apply some fixes to keep malevolent
compilers from optimizing RCU out of existence (e.g., volatile cast
in rcu_dereference() -- been working with the concurrency people in
the C/C++ standards committees, and they have an amazingly permissive
attitude towards compiler optimizations...).  Not a complete list, and
not necessarily in this order.

Thoughts?

						Thanx, Paul

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcuclassic.h       |    3 
 include/linux/rcupreempt.h       |    2 
 include/linux/rcupreempt_trace.h |   36 +
 include/linux/sched.h            |    3 
 kernel/rcuclassic.c              |    2 
 kernel/rcupreempt.c              |  735 +++++++++++++++++++++++++++------------
 kernel/rcupreempt_trace.c        |  127 ++++++
 kernel/rcutorture.c              |   13 
 8 files changed, 683 insertions(+), 238 deletions(-)
 
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/include/linux/rcuclassic.h linux-2.6.21.5-rt17-puna/include/linux/rcuclassic.h
--- linux-2.6.21.5-rt17/include/linux/rcuclassic.h	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/include/linux/rcuclassic.h	2007-06-21 12:27:17.000000000 -0700
@@ -144,8 +144,5 @@ extern void rcu_check_callbacks(int cpu,
 extern void rcu_restart_cpu(int cpu);
 extern long rcu_batches_completed(void);
 
-struct softirq_action;
-extern void rcu_process_callbacks(struct softirq_action *unused);
-
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUCLASSIC_H */
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/include/linux/rcupreempt.h linux-2.6.21.5-rt17-puna/include/linux/rcupreempt.h
--- linux-2.6.21.5-rt17/include/linux/rcupreempt.h	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/include/linux/rcupreempt.h	2007-06-20 17:20:13.000000000 -0700
@@ -65,7 +65,5 @@ extern long rcu_batches_completed(void);
 
 struct softirq_action;
 
-extern void rcu_process_callbacks(struct softirq_action *unused);
-
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPREEMPT_H */
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/include/linux/rcupreempt_trace.h linux-2.6.21.5-rt17-puna/include/linux/rcupreempt_trace.h
--- linux-2.6.21.5-rt17/include/linux/rcupreempt_trace.h	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/include/linux/rcupreempt_trace.h	2007-06-20 16:48:34.000000000 -0700
@@ -53,12 +53,20 @@ struct rcupreempt_trace {
 	long		done_remove;
 	atomic_t	done_invoked;
 	long		rcu_check_callbacks;
-	atomic_t	rcu_try_flip1;
-	long		rcu_try_flip2;
-	long		rcu_try_flip3;
+	atomic_t	rcu_try_flip_1;
 	atomic_t	rcu_try_flip_e1;
-	long		rcu_try_flip_e2;
-	long		rcu_try_flip_e3;
+	long		rcu_try_flip_i1;
+	long		rcu_try_flip_ie1;
+	long		rcu_try_flip_g1;
+	long		rcu_try_flip_a1;
+	long		rcu_try_flip_ae1;
+	long		rcu_try_flip_a2;
+	long		rcu_try_flip_z1;
+	long		rcu_try_flip_ze1;
+	long		rcu_try_flip_z2;
+	long		rcu_try_flip_m1;
+	long		rcu_try_flip_me1;
+	long		rcu_try_flip_m2;
 };
 
 #ifdef CONFIG_RCU_TRACE
@@ -69,12 +77,20 @@ struct rcupreempt_trace {
 
 extern void rcupreempt_trace_move2done(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_move2wait(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_1(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_try_flip_e1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_e2(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_e3(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip2(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip3(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_i1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_ie1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_g1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_a1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_ae1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_a2(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_z1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_ze1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_z2(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_m1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_me1(struct rcupreempt_trace *trace);
+extern void rcupreempt_trace_try_flip_m2(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_check_callbacks(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_done_remove(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_invoke(struct rcupreempt_trace *trace);
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/include/linux/sched.h linux-2.6.21.5-rt17-puna/include/linux/sched.h
--- linux-2.6.21.5-rt17/include/linux/sched.h	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/include/linux/sched.h	2007-06-20 16:48:34.000000000 -0700
@@ -1034,8 +1034,7 @@ struct task_struct {
 
 #ifdef CONFIG_PREEMPT_RCU
         int rcu_read_lock_nesting;
-        atomic_t *rcu_flipctr1;
-        atomic_t *rcu_flipctr2;
+        int rcu_flipctr_idx;
 #endif
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/kernel/rcuclassic.c linux-2.6.21.5-rt17-puna/kernel/rcuclassic.c
--- linux-2.6.21.5-rt17/kernel/rcuclassic.c	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/kernel/rcuclassic.c	2007-06-21 12:30:42.000000000 -0700
@@ -424,7 +424,7 @@ static void __rcu_process_callbacks(stru
 		rcu_do_batch(rdp);
 }
 
-void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/kernel/rcupreempt.c linux-2.6.21.5-rt17-puna/kernel/rcupreempt.c
--- linux-2.6.21.5-rt17/kernel/rcupreempt.c	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/kernel/rcupreempt.c	2007-07-02 21:29:22.000000000 -0700
@@ -15,11 +15,13 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
- * Copyright (C) IBM Corporation, 2001
+ * Copyright (C) IBM Corporation, 2006
  *
  * Authors: Paul E. McKenney <paulmck@us.ibm.com>
  *		With thanks to Esben Nielsen, Bill Huey, and Ingo Molnar
- *		for pushing me away from locks and towards counters.
+ *		for pushing me away from locks and towards counters, and
+ *		to Suparna Bhattacharya for pushing me completely away
+ *		from atomic instructions on the read side.
  *
  * Papers:  http://www.rdrop.com/users/paulmck/RCU
  *
@@ -54,13 +56,16 @@
  * PREEMPT_RCU data structures.
  */
 
+#define GP_STAGES 4
 struct rcu_data {
 	raw_spinlock_t	lock;
 	long		completed;	/* Number of last completed batch. */
+	int		waitlistcount;
+	struct tasklet_struct rcu_tasklet;
 	struct rcu_head *nextlist;
 	struct rcu_head **nexttail;
-	struct rcu_head *waitlist;
-	struct rcu_head **waittail;
+	struct rcu_head *waitlist[GP_STAGES];
+	struct rcu_head **waittail[GP_STAGES];
 	struct rcu_head *donelist;
 	struct rcu_head **donetail;
 #ifdef CONFIG_RCU_TRACE
@@ -71,13 +76,90 @@ struct rcu_ctrlblk {
 	raw_spinlock_t	fliplock;
 	long		completed;	/* Number of last completed batch. */
 };
-static struct rcu_data rcu_data;
+static DEFINE_PER_CPU(struct rcu_data, rcu_data);
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.fliplock = RAW_SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
 	.completed = 0,
 };
-static DEFINE_PER_CPU(atomic_t [2], rcu_flipctr) =
-	{ ATOMIC_INIT(0), ATOMIC_INIT(0) };
+static DEFINE_PER_CPU(int [2], rcu_flipctr) = { 0, 0 };
+
+/*
+ * States for rcu_try_flip() and friends.
+ */
+
+enum rcu_try_flip_states {
+	rcu_try_flip_idle_state,	/* "I" */
+	rcu_try_flip_waitack_state, 	/* "A" */
+	rcu_try_flip_waitzero_state,	/* "Z" */
+	rcu_try_flip_waitmb_state	/* "M" */
+};
+static enum rcu_try_flip_states rcu_try_flip_state = rcu_try_flip_idle_state;
+#ifdef CONFIG_RCU_STATS
+static char *rcu_try_flip_state_names[] =
+	{ "idle", "waitack", "waitzero", "waitmb" };
+#endif /* #ifdef CONFIG_RCU_STATS */
+
+/*
+ * Enum and per-CPU flag to determine when each CPU has seen
+ * the most recent counter flip.
+ */
+
+enum rcu_flip_flag_values {
+	rcu_flip_seen,		/* Steady/initial state, last flip seen. */
+				/* Only GP detector can update. */
+	rcu_flipped		/* Flip just completed, need confirmation. */
+				/* Only corresponding CPU can update. */
+};
+static DEFINE_PER_CPU(enum rcu_flip_flag_values, rcu_flip_flag) = rcu_flip_seen;
+
+/*
+ * Enum and per-CPU flag to determine when each CPU has executed the
+ * needed memory barrier to fence in memory references from its last RCU
+ * read-side critical section in the just-completed grace period.
+ */
+
+enum rcu_mb_flag_values {
+	rcu_mb_done,		/* Steady/initial state, no mb()s required. */
+				/* Only GP detector can update. */
+	rcu_mb_needed		/* Flip just completed, need an mb(). */
+				/* Only corresponding CPU can update. */
+};
+static DEFINE_PER_CPU(enum rcu_mb_flag_values, rcu_mb_flag) = rcu_mb_done;
+
+/*
+ * Macro that prevents the compiler from reordering accesses, but does
+ * absolutely -nothing- to prevent CPUs from reordering.  This is used
+ * only to mediate communication between mainline code and hardware
+ * interrupt and NMI handlers.
+ */
+#define ORDERED_WRT_IRQ(x) (*(volatile typeof(x) *)&(x))
+
+/*
+ * RCU_DATA_ME: find the current CPU's rcu_data structure.
+ * RCU_DATA_CPU: find the specified CPU's rcu_data structure.
+ */
+#define RCU_DATA_ME()		(&__get_cpu_var(rcu_data))
+#define RCU_DATA_ME_0()		(&per_cpu(rcu_data, 0))
+#define RCU_DATA_CPU(cpu)	(&per_cpu(rcu_data, cpu))
+#define RCU_DATA_CPU_0(cpu)	(&per_cpu(rcu_data, 0))
+
+/*
+ * Helper macro for tracing when the appropriate rcu_data is not
+ * cached in a local variable, but where the CPU number is so cached.
+ */
+#define RCU_TRACE_CPU(f, cpu) RCU_TRACE(f, &(RCU_DATA_CPU(cpu)->trace));
+
+/*
+ * Helper macro for tracing when the appropriate rcu_data is not
+ * cached in a local variable.
+ */
+#define RCU_TRACE_ME(f) RCU_TRACE(f, &(RCU_DATA_ME()->trace));
+
+/*
+ * Helper macro for tracing when the appropriate rcu_data is pointed
+ * to by a local variable.
+ */
+#define RCU_TRACE_RDP(f, rdp) RCU_TRACE(f, &((rdp)->trace));
 
 /*
  * Return the number of RCU batches processed thus far.  Useful
@@ -90,102 +172,321 @@ long rcu_batches_completed(void)
 
 void __rcu_read_lock(void)
 {
-	int flipctr;
-	unsigned long oldirq;
+	int idx;
+	struct task_struct *me = current;
+	int nesting;
 
-	local_irq_save(oldirq);
+	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
+	if (nesting != 0) {
+
+		/* An earlier rcu_read_lock() covers us, just count it. */
 
-	if (current->rcu_read_lock_nesting++ == 0) {
+		me->rcu_read_lock_nesting = nesting + 1;
+
+	} else {
+		unsigned long oldirq;
 
 		/*
-		 * Outermost nesting of rcu_read_lock(), so atomically
-		 * increment the current counter for the current CPU.
+		 * Disable local interrupts to prevent the grace-period
+		 * detection state machine from seeing us half-done.
+		 * NMIs can still occur, of course, and might themselves
+		 * contain rcu_read_lock().
 		 */
 
-		flipctr = rcu_ctrlblk.completed & 0x1;
-		smp_read_barrier_depends();
-		current->rcu_flipctr1 = &(__get_cpu_var(rcu_flipctr)[flipctr]);
-		/* Can optimize to non-atomic on fastpath, but start simple. */
-		atomic_inc(current->rcu_flipctr1);
-		smp_mb__after_atomic_inc();  /* might optimize out... */
-		if (unlikely(flipctr != (rcu_ctrlblk.completed & 0x1))) {
-
-			/*
-			 * We raced with grace-period processing (flip).
-			 * Although we cannot be preempted here, there
-			 * could be interrupts, ECC errors and the like,
-			 * so just nail down both sides of the rcu_flipctr
-			 * array for the duration of our RCU read-side
-			 * critical section, preventing a second flip
-			 * from racing with us.  At some point, it would
-			 * be safe to decrement one of the counters, but
-			 * we have no way of knowing when that would be.
-			 * So just decrement them both in rcu_read_unlock().
-			 */
-
-			current->rcu_flipctr2 =
-				&(__get_cpu_var(rcu_flipctr)[!flipctr]);
-			/* Can again optimize to non-atomic on fastpath. */
-			atomic_inc(current->rcu_flipctr2);
-			smp_mb__after_atomic_inc();  /* might optimize out... */
-		}
+		local_irq_save(oldirq);
+
+		/*
+		 * Outermost nesting of rcu_read_lock(), so increment
+		 * the current counter for the current CPU.  Use volatile
+		 * casts to prevent the compiler from reordering.
+		 */
+
+		idx = ORDERED_WRT_IRQ(rcu_ctrlblk.completed) & 0x1;
+		smp_read_barrier_depends();  /* @@@@ might be unneeded */
+		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])++;
+
+		/*
+		 * Now that the per-CPU counter has been incremented, we
+		 * are protected from races with rcu_read_lock() invoked
+		 * from NMI handlers on this CPU.  We can therefore safely
+		 * increment the nesting counter, relieving further NMIs
+		 * of the need to do so.
+		 */
+
+		ORDERED_WRT_IRQ(me->rcu_read_lock_nesting) = nesting + 1;
+
+		/*
+		 * Now that we have preventing any NMIs from storing
+		 * to the ->rcu_flipctr_idx, we can safely use it to
+		 * remember which counter to decrement in the matching
+		 * rcu_read_unlock().
+		 */
+
+		ORDERED_WRT_IRQ(me->rcu_flipctr_idx) = idx;
+		local_irq_restore(oldirq);
 	}
-	local_irq_restore(oldirq);
 }
 
 void __rcu_read_unlock(void)
 {
-	unsigned long oldirq;
+	int idx;
+	struct task_struct *me = current;
+	int nesting;
 
-	local_irq_save(oldirq);
-	if (--current->rcu_read_lock_nesting == 0) {
+	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
+	if (nesting > 1) {
 
 		/*
-		 * Just atomically decrement whatever we incremented.
-		 * Might later want to awaken some task waiting for the
-		 * grace period to complete, but keep it simple for the
-		 * moment.
+		 * We are still protected by the enclosing rcu_read_lock(),
+		 * so simply decrement the counter.
 		 */
 
-		smp_mb__before_atomic_dec();
-		atomic_dec(current->rcu_flipctr1);
-		current->rcu_flipctr1 = NULL;
-		if (unlikely(current->rcu_flipctr2 != NULL)) {
-			atomic_dec(current->rcu_flipctr2);
-			current->rcu_flipctr2 = NULL;
-		}
-	}
+		me->rcu_read_lock_nesting = nesting - 1;
 
-	local_irq_restore(oldirq);
+	} else {
+		unsigned long oldirq;
+
+		/*
+		 * Disable local interrupts to prevent the grace-period
+		 * detection state machine from seeing us half-done.
+		 * NMIs can still occur, of course, and might themselves
+		 * contain rcu_read_lock() and rcu_read_unlock().
+		 */
+
+		local_irq_save(oldirq);
+
+		/*
+		 * Outermost nesting of rcu_read_unlock(), so we must
+		 * decrement the current counter for the current CPU.
+		 * This must be done carefully, because NMIs can
+		 * occur at any point in this code, and any rcu_read_lock()
+		 * and rcu_read_unlock() pairs in the NMI handlers
+		 * must interact non-destructively with this code.
+		 * Lots of volatile casts, and -very- careful ordering.
+		 *
+		 * Changes to this code, including this one, must be
+		 * inspected, validated, and tested extremely carefully!!!
+		 */
+
+		/*
+		 * First, pick up the index.  Enforce ordering for
+		 * DEC Alpha.
+		 */
+
+		idx = ORDERED_WRT_IRQ(me->rcu_flipctr_idx);
+		smp_read_barrier_depends();  /* @@@ Needed??? */
+
+		/*
+		 * Now that we have fetched the counter index, it is
+		 * safe to decrement the per-task RCU nesting counter.
+		 * After this, any interrupts or NMIs will increment and
+		 * decrement the per-CPU counters.
+		 */
+		ORDERED_WRT_IRQ(me->rcu_read_lock_nesting) = nesting - 1;
+
+		/*
+		 * It is now safe to decrement this task's nesting count.
+		 * NMIs that occur after this statement will route their
+		 * rcu_read_lock() calls through this "else" clause, and
+		 * will thus start incrementing the per-CPU coutner on
+		 * their own.  They will also clobber ->rcu_flipctr_idx,
+		 * but that is OK, since we have already fetched it.
+		 */
+
+		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])--;
+		local_irq_restore(oldirq);
+	}
 }
 
-static void __rcu_advance_callbacks(void)
+/*
+ * If a global counter flip has occurred since the last time that we
+ * advanced callbacks, advance them.  Hardware interrupts must be
+ * disabled when calling this function.
+ */
+static void __rcu_advance_callbacks(struct rcu_data *rdp)
 {
+	int cpu;
+	int i;
+	int wlc = 0;
 
-	if (rcu_data.completed != rcu_ctrlblk.completed) {
-		if (rcu_data.waitlist != NULL) {
-			*rcu_data.donetail = rcu_data.waitlist;
-			rcu_data.donetail = rcu_data.waittail;
-			RCU_TRACE(rcupreempt_trace_move2done, &rcu_data.trace);
+	if (rdp->completed != rcu_ctrlblk.completed) {
+		if (rdp->waitlist[GP_STAGES - 1] != NULL) {
+			*rdp->donetail = rdp->waitlist[GP_STAGES - 1];
+			rdp->donetail = rdp->waittail[GP_STAGES - 1];
+			RCU_TRACE_RDP(rcupreempt_trace_move2done, rdp);
+		}
+		for (i = GP_STAGES - 2; i >= 0; i--) {
+			if (rdp->waitlist[i] != NULL) {
+				rdp->waitlist[i + 1] = rdp->waitlist[i];
+				rdp->waittail[i + 1] = rdp->waittail[i];
+				wlc++;
+			} else {
+				rdp->waitlist[i + 1] = NULL;
+				rdp->waittail[i + 1] =
+					&rdp->waitlist[i + 1];
+			}
 		}
-		if (rcu_data.nextlist != NULL) {
-			rcu_data.waitlist = rcu_data.nextlist;
-			rcu_data.waittail = rcu_data.nexttail;
-			rcu_data.nextlist = NULL;
-			rcu_data.nexttail = &rcu_data.nextlist;
-			RCU_TRACE(rcupreempt_trace_move2wait, &rcu_data.trace);
+		if (rdp->nextlist != NULL) {
+			rdp->waitlist[0] = rdp->nextlist;
+			rdp->waittail[0] = rdp->nexttail;
+			wlc++;
+			rdp->nextlist = NULL;
+			rdp->nexttail = &rdp->nextlist;
+			RCU_TRACE_RDP(rcupreempt_trace_move2wait, rdp);
 		} else {
-			rcu_data.waitlist = NULL;
-			rcu_data.waittail = &rcu_data.waitlist;
+			rdp->waitlist[0] = NULL;
+			rdp->waittail[0] = &rdp->waitlist[0];
+		}
+		rdp->waitlistcount = wlc;
+		rdp->completed = rcu_ctrlblk.completed;
+	}
+
+	/*
+	 * Check to see if this CPU needs to report that it has seen
+	 * the most recent counter flip, thereby declaring that all
+	 * subsequent rcu_read_lock() invocations will respect this flip.
+	 */
+
+	cpu = raw_smp_processor_id();
+	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
+		smp_mb();  /* Subsequent counter accesses must see new value */
+		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
+		smp_mb();  /* Subsequent RCU read-side critical sections */
+			   /*  seen -after- acknowledgement. */
+	}
+}
+
+/*
+ * Get here when RCU is idle.  Decide whether we need to
+ * move out of idle state, and return non-zero if so.
+ * "Straightforward" approach for the moment, might later
+ * use callback-list lengths, grace-period duration, or
+ * some such to determine when to exit idle state.
+ * Might also need a pre-idle test that does not acquire
+ * the lock, but let's get the simple case working first...
+ */
+
+static int
+rcu_try_flip_idle(void)
+{
+	int cpu;
+
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_i1);
+	if (!rcu_pending(smp_processor_id())) {
+		RCU_TRACE_ME(rcupreempt_trace_try_flip_ie1);
+		return 0;
+	}
+
+	/*
+	 * Do the flip.
+	 */
+
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_g1);
+	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
+
+	/*
+	 * Need a memory barrier so that other CPUs see the new
+	 * counter value before they see the subsequent change of all
+	 * the rcu_flip_flag instances to rcu_flipped.
+	 */
+
+	smp_mb();
+
+	/* Now ask each CPU for acknowledgement of the flip. */
+
+	for_each_possible_cpu(cpu)
+		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
+
+	return 1;
+}
+
+/*
+ * Wait for CPUs to acknowledge the flip.
+ */
+
+static int
+rcu_try_flip_waitack(void)
+{
+	int cpu;
+
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
+	for_each_possible_cpu(cpu)
+		if (per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
+			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
+			return 0;
 		}
-		rcu_data.completed = rcu_ctrlblk.completed;
+
+	/*
+	 * Make sure our checks above don't bleed into subsequent
+	 * waiting for the sum of the counters to reach zero.
+	 */
+
+	smp_mb();
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_a2);
+	return 1;
+}
+
+/*
+ * Wait for collective ``last'' counter to reach zero,
+ * then tell all CPUs to do an end-of-grace-period memory barrier.
+ */
+
+static int
+rcu_try_flip_waitzero(void)
+{
+	int cpu;
+	int lastidx = !(rcu_ctrlblk.completed & 0x1);
+	int sum = 0;
+
+	/* Check to see if the sum of the "last" counters is zero. */
+
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(rcu_flipctr, cpu)[lastidx];
+	if (sum != 0) {
+		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
+		return 0;
 	}
+
+	/* Make sure we don't call for memory barriers before we see zero. */
+
+	smp_mb();
+
+	/* Call for a memory barrier from each CPU. */
+
+	for_each_possible_cpu(cpu)
+		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
+
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_z2);
+	return 1;
+}
+
+/*
+ * Wait for all CPUs to do their end-of-grace-period memory barrier.
+ * Return 0 once all CPUs have done so.
+ */
+
+static int
+rcu_try_flip_waitmb(void)
+{
+	int cpu;
+
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
+	for_each_possible_cpu(cpu)
+		if (per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
+			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
+			return 0;
+		}
+
+	smp_mb(); /* Ensure that the above checks precede any following flip. */
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_m2);
+	return 1;
 }
 
 /*
  * Attempt a single flip of the counters.  Remember, a single flip does
  * -not- constitute a grace period.  Instead, the interval between
- * a pair of consecutive flips is a grace period.
+ * at least three consecutive flips is a grace period.
  *
  * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
  * on a large SMP, they might want to use a hierarchical organization of
@@ -193,67 +494,69 @@ static void __rcu_advance_callbacks(void
  */
 static void rcu_try_flip(void)
 {
-	int cpu;
-	long flipctr;
 	unsigned long oldirq;
 
-	flipctr = rcu_ctrlblk.completed;
-	RCU_TRACE(rcupreempt_trace_try_flip1, &rcu_data.trace);
+	RCU_TRACE_ME(rcupreempt_trace_try_flip_1);
 	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, oldirq))) {
-		RCU_TRACE(rcupreempt_trace_try_flip_e1, &rcu_data.trace);
-		return;
-	}
-	if (unlikely(flipctr != rcu_ctrlblk.completed)) {
-
-		/* Our work is done!  ;-) */
-
-		RCU_TRACE(rcupreempt_trace_try_flip_e2, &rcu_data.trace);
-		spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
+		RCU_TRACE_ME(rcupreempt_trace_try_flip_e1);
 		return;
 	}
-	flipctr &= 0x1;
 
 	/*
-	 * Check for completion of all RCU read-side critical sections
-	 * that started prior to the previous flip.
+	 * Take the next transition(s) through the RCU grace-period
+	 * flip-counter state machine.
 	 */
 
-	RCU_TRACE(rcupreempt_trace_try_flip2, &rcu_data.trace);
-	for_each_possible_cpu(cpu) {
-		if (atomic_read(&per_cpu(rcu_flipctr, cpu)[!flipctr]) != 0) {
-			RCU_TRACE(rcupreempt_trace_try_flip_e3,
-							&rcu_data.trace);
-			spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
-			return;
-		}
+	switch (rcu_try_flip_state) {
+	case rcu_try_flip_idle_state:
+		if (rcu_try_flip_idle())
+			rcu_try_flip_state = rcu_try_flip_waitack_state;
+		break;
+	case rcu_try_flip_waitack_state:
+		if (rcu_try_flip_waitack())
+			rcu_try_flip_state = rcu_try_flip_waitzero_state;
+		break;
+	case rcu_try_flip_waitzero_state:
+		if (rcu_try_flip_waitzero())
+			rcu_try_flip_state = rcu_try_flip_waitmb_state;
+		break;
+	case rcu_try_flip_waitmb_state:
+		if (rcu_try_flip_waitmb())
+			rcu_try_flip_state = rcu_try_flip_idle_state;
 	}
-
-	/* Do the flip. */
-
-	smp_mb();
-	rcu_ctrlblk.completed++;
-
-	RCU_TRACE(rcupreempt_trace_try_flip3, &rcu_data.trace);
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
 }
 
+/*
+ * Check to see if this CPU needs to do a memory barrier in order to
+ * ensure that any prior RCU read-side critical sections have committed
+ * their counter manipulations and critical-section memory references
+ * before declaring the grace period to be completed.
+ */
+static void rcu_check_mb(int cpu)
+{
+	if (per_cpu(rcu_mb_flag, cpu) == rcu_mb_needed) {
+		smp_mb();  /* Ensure RCU read-side accesses are visible. */
+		per_cpu(rcu_mb_flag, cpu) = rcu_mb_done;
+	}
+}
+
 void rcu_check_callbacks(int cpu, int user)
 {
 	unsigned long oldirq;
+	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
 
-	if (rcu_ctrlblk.completed == rcu_data.completed) {
+	rcu_check_mb(cpu);
+	if (rcu_ctrlblk.completed == rdp->completed) {
 		rcu_try_flip();
-		if (rcu_ctrlblk.completed == rcu_data.completed) {
-			return;
-		}
 	}
-	spin_lock_irqsave(&rcu_data.lock, oldirq);
-	RCU_TRACE(rcupreempt_trace_check_callbacks, &rcu_data.trace);
-	__rcu_advance_callbacks();
-	if (rcu_data.donelist == NULL) {
-		spin_unlock_irqrestore(&rcu_data.lock, oldirq);
+	spin_lock_irqsave(&rdp->lock, oldirq);
+	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
+	__rcu_advance_callbacks(rdp);
+	if (rdp->donelist == NULL) {
+		spin_unlock_irqrestore(&rdp->lock, oldirq);
 	} else {
-		spin_unlock_irqrestore(&rcu_data.lock, oldirq);
+		spin_unlock_irqrestore(&rdp->lock, oldirq);
 		raise_softirq(RCU_SOFTIRQ);
 	}
 }
@@ -265,62 +568,68 @@ void rcu_check_callbacks(int cpu, int us
 void rcu_advance_callbacks(int cpu, int user)
 {
 	unsigned long oldirq;
+	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
 
-	if (rcu_ctrlblk.completed == rcu_data.completed) {
+	if (rcu_ctrlblk.completed == rdp->completed) {
 		rcu_try_flip();
-		if (rcu_ctrlblk.completed == rcu_data.completed) {
+		if (rcu_ctrlblk.completed == rdp->completed) {
 			return;
 		}
 	}
-	spin_lock_irqsave(&rcu_data.lock, oldirq);
-	RCU_TRACE(rcupreempt_trace_check_callbacks, &rcu_data.trace);
-	__rcu_advance_callbacks();
-	spin_unlock_irqrestore(&rcu_data.lock, oldirq);
+	spin_lock_irqsave(&rdp->lock, oldirq);
+	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
+	__rcu_advance_callbacks(rdp); 
+	spin_unlock_irqrestore(&rdp->lock, oldirq);
 }
 
-void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list;
+	struct rcu_data *rdp = RCU_DATA_ME();
 
-	spin_lock_irqsave(&rcu_data.lock, flags);
-	list = rcu_data.donelist;
+	spin_lock_irqsave(&rdp->lock, flags);
+	list = rdp->donelist;
 	if (list == NULL) {
-		spin_unlock_irqrestore(&rcu_data.lock, flags);
+		spin_unlock_irqrestore(&rdp->lock, flags);
 		return;
 	}
-	rcu_data.donelist = NULL;
-	rcu_data.donetail = &rcu_data.donelist;
-	RCU_TRACE(rcupreempt_trace_done_remove, &rcu_data.trace);
-	spin_unlock_irqrestore(&rcu_data.lock, flags);
+	rdp->donelist = NULL;
+	rdp->donetail = &rdp->donelist;
+	RCU_TRACE_RDP(rcupreempt_trace_done_remove, rdp);
+	spin_unlock_irqrestore(&rdp->lock, flags);
 	while (list) {
 		next = list->next;
 		list->func(list);
 		list = next;
-		RCU_TRACE(rcupreempt_trace_invoke, &rcu_data.trace);
+		RCU_TRACE_ME(rcupreempt_trace_invoke);
 	}
 }
 
 void fastcall call_rcu(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
-	unsigned long flags;
+	unsigned long oldirq;
+	struct rcu_data *rdp;
 
 	head->func = func;
 	head->next = NULL;
-	spin_lock_irqsave(&rcu_data.lock, flags);
-	__rcu_advance_callbacks();
-	*rcu_data.nexttail = head;
-	rcu_data.nexttail = &head->next;
-	RCU_TRACE(rcupreempt_trace_next_add, &rcu_data.trace);
-	spin_unlock_irqrestore(&rcu_data.lock, flags);
+	local_irq_save(oldirq);
+	rdp = RCU_DATA_ME();
+	spin_lock(&rdp->lock);
+	__rcu_advance_callbacks(rdp);
+	*rdp->nexttail = head;
+	rdp->nexttail = &head->next;
+	RCU_TRACE_RDP(rcupreempt_trace_next_add, rdp);
+	spin_unlock(&rdp->lock);
+	local_irq_restore(oldirq);
 }
 
 /*
- * Crude hack, reduces but does not eliminate possibility of failure.
- * Needs to wait for all CPUs to pass through a -voluntary- context
- * switch to eliminate possibility of failure.  (Maybe just crank
- * priority down...)
+ * Wait until all currently running preempt_disable() code segments
+ * (including hardware-irq-disable segments) complete.  Note that
+ * in -rt this does -not- necessarily result in all currently executing
+ * interrupt -handlers- having completed.
  */
 void __synchronize_sched(void)
 {
@@ -340,33 +649,71 @@ void __synchronize_sched(void)
 /*
  * Check to see if any future RCU-related work will need to be done
  * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * 1 if so.  Assumes that notifiers would take care of handling any
+ * outstanding requests from the RCU core.
+ *
+ * This function is part of the RCU implementation; it is -not-
  * an exported member of the RCU API.
  */
 int rcu_needs_cpu(int cpu)
 {
-	return !!rcu_data.waitlist || rcu_pending(cpu);
+	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+
+	return (rdp->donelist != NULL ||
+		!!rdp->waitlistcount ||
+		rdp->nextlist != NULL);
 }
 
 int notrace rcu_pending(int cpu)
 {
-	return (rcu_data.donelist != NULL ||
-		rcu_data.waitlist != NULL ||
-		rcu_data.nextlist != NULL);
+	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+
+	/* The CPU has at least one callback queued somewhere. */
+
+	if (rdp->donelist != NULL ||
+	    !!rdp->waitlistcount ||
+	    rdp->nextlist != NULL)
+	    	return 1;
+
+	/* The RCU core needs an acknowledgement from this CPU. */
+
+	if ((per_cpu(rcu_flip_flag, cpu) == rcu_flipped) ||
+	    (per_cpu(rcu_mb_flag, cpu) == rcu_mb_needed))
+	    	return 1;
+
+	/* This CPU has fallen behind the global grace-period number. */
+
+	if (rdp->completed != rcu_ctrlblk.completed)
+		return 1;
+
+	/* Nothing needed from this CPU. */
+
+	return 0;
 }
 
 void __init __rcu_init(void)
 {
-/*&&&&*/printk("WARNING: experimental RCU implementation.\n");
-	spin_lock_init(&rcu_data.lock);
-	rcu_data.completed = 0;
-	rcu_data.nextlist = NULL;
-	rcu_data.nexttail = &rcu_data.nextlist;
-	rcu_data.waitlist = NULL;
-	rcu_data.waittail = &rcu_data.waitlist;
-	rcu_data.donelist = NULL;
-	rcu_data.donetail = &rcu_data.donelist;
+	int cpu;
+	int i;
+	struct rcu_data *rdp;
+
+/*&&&&*/printk("WARNING: experimental non-atomic RCU implementation.\n");
+	for_each_possible_cpu(cpu) {
+		rdp = RCU_DATA_CPU(cpu);
+		spin_lock_init(&rdp->lock);
+		rdp->completed = 0;
+		rdp->waitlistcount = 0;
+		rdp->nextlist = NULL;
+		rdp->nexttail = &rdp->nextlist;
+		for (i = 0; i < GP_STAGES; i++) {
+			rdp->waitlist[i] = NULL;
+			rdp->waittail[i] = &rdp->waitlist[i];
+		}
+		rdp->donelist = NULL;
+		rdp->donetail = &rdp->donelist;
+	}
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
+/*&&&&*/printk("experimental non-atomic RCU implementation: init done\n");
 }
 
 /*
@@ -377,73 +724,41 @@ void synchronize_kernel(void)
 	synchronize_rcu();
 }
 
+#if 1
 #ifdef CONFIG_RCU_TRACE
-int rcu_read_proc_data(char *page)
-{
-	struct rcupreempt_trace *trace = &rcu_data.trace;
-	return sprintf(page,
-		       "ggp=%ld lgp=%ld rcc=%ld\n"
-		       "na=%ld nl=%ld wa=%ld wl=%ld da=%ld dl=%ld dr=%ld di=%d\n"
-		       "rtf1=%d rtf2=%ld rtf3=%ld rtfe1=%d rtfe2=%ld rtfe3=%ld\n",
-
-		       rcu_ctrlblk.completed,
-		       rcu_data.completed,
-		       trace->rcu_check_callbacks,
-
-		       trace->next_add,
-		       trace->next_length,
-		       trace->wait_add,
-		       trace->wait_length,
-		       trace->done_add,
-		       trace->done_length,
-		       trace->done_remove,
-		       atomic_read(&trace->done_invoked),
-
-		       atomic_read(&trace->rcu_try_flip1),
-		       trace->rcu_try_flip2,
-		       trace->rcu_try_flip3,
-		       atomic_read(&trace->rcu_try_flip_e1),
-		       trace->rcu_try_flip_e2,
-		       trace->rcu_try_flip_e3);
-}
-
-int rcu_read_proc_gp_data(char *page)
-{
-	long oldgp = rcu_ctrlblk.completed;
-
-	synchronize_rcu();
-	return sprintf(page, "oldggp=%ld  newggp=%ld\n",
-		       oldgp, rcu_ctrlblk.completed);
-}
-
-int rcu_read_proc_ptrs_data(char *page)
-{
-	return sprintf(page,
-		       "nl=%p/%p nt=%p\n wl=%p/%p wt=%p dl=%p/%p dt=%p\n",
-		       &rcu_data.nextlist, rcu_data.nextlist, rcu_data.nexttail,
-		       &rcu_data.waitlist, rcu_data.waitlist, rcu_data.waittail,
-		       &rcu_data.donelist, rcu_data.donelist, rcu_data.donetail
-		      );
-}
-
-int rcu_read_proc_ctrs_data(char *page)
+int rcu_preempt_trace_dump_stats(char *page)
 {
 	int cnt = 0;
 	int cpu;
-	int f = rcu_data.completed & 0x1;
+	int f;
+	struct rcu_data *rdp = RCU_DATA_CPU(raw_smp_processor_id());
+	void rcu_preempt_trace_dump_stats_sum(struct rcupreempt_trace *sum,
+					      struct rcupreempt_trace *rtp);
+	int rcu_preempt_trace_dump_stats_trace(char *page,
+	                                       struct rcupreempt_trace *trace);
+	struct rcupreempt_trace rt_sum = { 0 };
 
+	f = rdp->completed & 0x1;
+	cnt += sprintf(&page[cnt], "ggp=%ld lgp=%ld wlc=%d\n",
+		       rcu_ctrlblk.completed,
+		       rdp->completed,
+		       rdp->waitlistcount);
 	cnt += sprintf(&page[cnt], "CPU last cur\n");
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		cnt += sprintf(&page[cnt], "%3d %4d %3d\n",
 			       cpu,
-			       atomic_read(&per_cpu(rcu_flipctr, cpu)[!f]),
-			       atomic_read(&per_cpu(rcu_flipctr, cpu)[f]));
+			       per_cpu(rcu_flipctr, cpu)[!f],
+			       per_cpu(rcu_flipctr, cpu)[f]);
+		rdp = RCU_DATA_CPU(cpu);
+		rcu_preempt_trace_dump_stats_sum(&rt_sum, &rdp->trace);
 	}
-	cnt += sprintf(&page[cnt], "ggp = %ld\n", rcu_data.completed);
-	return (cnt);
-}
 
+	cnt += rcu_preempt_trace_dump_stats_trace(&page[cnt], &rt_sum);
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(rcu_preempt_trace_dump_stats);
 #endif /* #ifdef CONFIG_RCU_TRACE */
+#endif /* #if 1 */
 
 EXPORT_SYMBOL_GPL(call_rcu);
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/kernel/rcupreempt_trace.c linux-2.6.21.5-rt17-puna/kernel/rcupreempt_trace.c
--- linux-2.6.21.5-rt17/kernel/rcupreempt_trace.c	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/kernel/rcupreempt_trace.c	2007-06-20 16:48:34.000000000 -0700
@@ -55,29 +55,61 @@ void rcupreempt_trace_move2wait(struct r
 	trace->wait_add += trace->next_length;
 	trace->next_length = 0;
 }
-void rcupreempt_trace_try_flip1(struct rcupreempt_trace *trace)
+void rcupreempt_trace_try_flip_1(struct rcupreempt_trace *trace)
 {
-	atomic_inc(&trace->rcu_try_flip1);
+	atomic_inc(&trace->rcu_try_flip_1);
 }
 void rcupreempt_trace_try_flip_e1(struct rcupreempt_trace *trace)
 {
 	atomic_inc(&trace->rcu_try_flip_e1);
 }
-void rcupreempt_trace_try_flip_e2(struct rcupreempt_trace *trace)
+void rcupreempt_trace_try_flip_i1(struct rcupreempt_trace *trace)
 {
-	trace->rcu_try_flip_e2++;
+	trace->rcu_try_flip_i1++;
 }
-void rcupreempt_trace_try_flip_e3(struct rcupreempt_trace *trace)
+void rcupreempt_trace_try_flip_ie1(struct rcupreempt_trace *trace)
 {
-	trace->rcu_try_flip_e3++;
+	trace->rcu_try_flip_ie1++;
 }
-void rcupreempt_trace_try_flip2(struct rcupreempt_trace *trace)
+void rcupreempt_trace_try_flip_g1(struct rcupreempt_trace *trace)
 {
-	trace->rcu_try_flip2++;
+	trace->rcu_try_flip_g1++;
 }
-void rcupreempt_trace_try_flip3(struct rcupreempt_trace *trace)
+void rcupreempt_trace_try_flip_a1(struct rcupreempt_trace *trace)
 {
-	trace->rcu_try_flip3++;
+	trace->rcu_try_flip_a1++;
+}
+void rcupreempt_trace_try_flip_ae1(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_ae1++;
+}
+void rcupreempt_trace_try_flip_a2(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_a2++;
+}
+void rcupreempt_trace_try_flip_z1(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_z1++;
+}
+void rcupreempt_trace_try_flip_ze1(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_ze1++;
+}
+void rcupreempt_trace_try_flip_z2(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_z2++;
+}
+void rcupreempt_trace_try_flip_m1(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_m1++;
+}
+void rcupreempt_trace_try_flip_me1(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_me1++;
+}
+void rcupreempt_trace_try_flip_m2(struct rcupreempt_trace *trace)
+{
+	trace->rcu_try_flip_m2++;
 }
 void rcupreempt_trace_check_callbacks(struct rcupreempt_trace *trace)
 {
@@ -97,3 +129,78 @@ void rcupreempt_trace_next_add(struct rc
         trace->next_add++;
         trace->next_length++;
 }
+
+#if 1
+void rcu_preempt_trace_dump_stats_sum(struct rcupreempt_trace *sum,
+				      struct rcupreempt_trace *rtp)
+{
+	sum->next_length += rtp->next_length;
+	sum->next_add += rtp->next_add;
+	sum->wait_length += rtp->wait_length;
+	sum->wait_add += rtp->wait_add;
+	sum->done_length += rtp->done_length;
+	sum->done_add += rtp->done_add;
+	sum->done_remove += rtp->done_remove;
+	atomic_set(&sum->done_invoked,
+		   atomic_read(&sum->done_invoked) +
+		   atomic_read(&rtp->done_invoked));
+	sum->rcu_check_callbacks += rtp->rcu_check_callbacks;
+	atomic_set(&sum->rcu_try_flip_1,
+		   atomic_read(&sum->rcu_try_flip_1) +
+		   atomic_read(&rtp->rcu_try_flip_1));
+	atomic_set(&sum->rcu_try_flip_e1,
+		   atomic_read(&sum->rcu_try_flip_e1) +
+		   atomic_read(&rtp->rcu_try_flip_e1));
+	sum->rcu_try_flip_i1 += rtp->rcu_try_flip_i1;
+	sum->rcu_try_flip_ie1 += rtp->rcu_try_flip_ie1;
+	sum->rcu_try_flip_g1 += rtp->rcu_try_flip_g1;
+	sum->rcu_try_flip_a1 += rtp->rcu_try_flip_a1;
+	sum->rcu_try_flip_ae1 += rtp->rcu_try_flip_ae1;
+	sum->rcu_try_flip_a2 += rtp->rcu_try_flip_a2;
+	sum->rcu_try_flip_z1 += rtp->rcu_try_flip_z1;
+	sum->rcu_try_flip_ze1 += rtp->rcu_try_flip_ze1;
+	sum->rcu_try_flip_z2 += rtp->rcu_try_flip_z2;
+	sum->rcu_try_flip_m1 += rtp->rcu_try_flip_m1;
+	sum->rcu_try_flip_me1 += rtp->rcu_try_flip_me1;
+	sum->rcu_try_flip_m2 += rtp->rcu_try_flip_m2;
+}
+
+int rcu_preempt_trace_dump_stats_trace(char *page,
+				       struct rcupreempt_trace *trace)
+{
+	int cnt = 0;
+
+	cnt += sprintf(&page[cnt],
+		       "na=%ld nl=%ld wa=%ld wl=%ld da=%ld dl=%ld dr=%ld di=%d\n",
+		       trace->next_add,
+		       trace->next_length,
+		       trace->wait_add,
+		       trace->wait_length,
+		       trace->done_add,
+		       trace->done_length,
+		       trace->done_remove,
+		       atomic_read(&trace->done_invoked));
+	cnt += sprintf(&page[cnt],
+		       "\t_1=%d _e1=%d _i1=%ld _ie1=%ld _g1=%ld\n",
+		       atomic_read(&trace->rcu_try_flip_1),
+		       atomic_read(&trace->rcu_try_flip_e1),
+		       trace->rcu_try_flip_i1,
+		       trace->rcu_try_flip_ie1,
+		       trace->rcu_try_flip_g1);
+	cnt += sprintf(&page[cnt],
+		       "\t_a1=%ld _ae1=%ld _a2=%ld _z1=%ld _ze1=%ld _z2=%ld\n",
+		       trace->rcu_try_flip_a1,
+		       trace->rcu_try_flip_ae1,
+		       trace->rcu_try_flip_a2,
+		       trace->rcu_try_flip_z1,
+		       trace->rcu_try_flip_ze1,
+		       trace->rcu_try_flip_z2);
+	cnt += sprintf(&page[cnt],
+		       "\t_m1=%ld _me1=%ld _m2=%ld\n",
+		       trace->rcu_try_flip_m1,
+		       trace->rcu_try_flip_me1,
+		       trace->rcu_try_flip_m2);
+	return cnt;
+
+}
+#endif /* #if 1 */
diff -urpNa -X dontdiff linux-2.6.21.5-rt17/kernel/rcutorture.c linux-2.6.21.5-rt17-puna/kernel/rcutorture.c
--- linux-2.6.21.5-rt17/kernel/rcutorture.c	2007-06-20 16:44:54.000000000 -0700
+++ linux-2.6.21.5-rt17-puna/kernel/rcutorture.c	2007-06-20 16:48:34.000000000 -0700
@@ -258,6 +258,15 @@ static void rcu_torture_deferred_free(st
 	call_rcu(&p->rtort_rcu, rcu_torture_cb);
 }
 
+#if 1
+static int rcu_stats(char *page)
+{
+	int rcu_preempt_trace_dump_stats(char *page);
+
+	return rcu_preempt_trace_dump_stats(page);
+}
+#endif /* #if 1 */
+
 static struct rcu_torture_ops rcu_ops = {
 	.init = NULL,
 	.cleanup = NULL,
@@ -267,7 +276,11 @@ static struct rcu_torture_ops rcu_ops = 
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_torture_deferred_free,
 	.sync = synchronize_rcu,
+#if 1
+	.stats = rcu_stats,
+#else /* #if 1 */
 	.stats = NULL,
+#endif /* #else #if 1 */
 	.name = "rcu"
 };
 
