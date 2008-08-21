Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbYHUPcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbYHUPcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYHUPcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:32:14 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:60728 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYHUPcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:32:12 -0400
Message-ID: <48AD8A72.70609@colorfullife.com>
Date: Thu, 21 Aug 2008 17:32:02 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: paulmck@linux.vnet.ibm.com
Subject: Re: [RFC, PATCH] state machine based rcu
References: <48AD8969.7060900@colorfullife.com> <48AD89EF.3090406@colorfullife.com>
In-Reply-To: <48AD89EF.3090406@colorfullife.com>
Content-Type: multipart/mixed;
 boundary="------------080306080101040507050301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080306080101040507050301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[Hiding in shame, but I swear: The patch was attached!]

--
    Manfred

--------------080306080101040507050301
Content-Type: text/plain;
 name="patch-kernel-rcu-state-private"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-kernel-rcu-state-private"

>From 517b52362254f8c383fd28d956c0e63314d38807 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Thu, 21 Aug 2008 17:18:10 +0200
Subject: [PATCH] kernel/rcuclassic.c: state machine based rcu implementation.

Attached is a slightly different concept for the rcu code:
Right now, each cpu locally decides what it does, the only
global thing is the bitmap that keeps track of grace periods.
What this grace period means is defined by the cpu: it's possible
that some cpus interpret a grace period as the sign for
calling the rcu callbacks, other cpus just interpret it as the
sign that it should look for the next grace period.

The patch reverses that: Now there is a global state.
The system is either collecting pointers for the next grace
period, or it's waiting for a grace period to complete.
All cpus do the same thing.

Additionally, the patch removes the cpu bitmask:
Since all cpus must do something and the only thing that
is tested for is an empty bitmask, the bitmask can be replaced
with an integer that counts the outstanding cpus.
Theoretically, this could be an atomic_t.
(right now, the bitmasks are still there, but just for debugging).
If needed, a slow path can reconstruct the bitmap on the fly.
{for_each_online_cpu(i) if (rcu_pending(i) {do_something()} }

The patch is work in progress:
- NMIs do not work yet, they cause deadlocks.
- synchronize_sched() and call_rcu_sched() are broken.
- some debug printks are left inside.
- The counters could be made hierarchical for better scalability.
- the nohz code is not tested.

The patch is against tip/rcu.
---
 include/linux/hardirq.h    |    4 +-
 include/linux/rcuclassic.h |  179 +++++---
 include/linux/rcucpumask.h |  154 +++++++
 kernel/Makefile            |    2 +-
 kernel/rcuclassic.c        | 1081 ++++++++++++++++++++++++--------------------
 kernel/rcucpumask.c        |  119 +++++
 6 files changed, 984 insertions(+), 555 deletions(-)
 create mode 100644 include/linux/rcucpumask.h
 create mode 100644 kernel/rcucpumask.c

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 181006c..91c39da 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,13 +118,13 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
+#ifdef CONFIG_NO_HZ
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 #else
 # define rcu_irq_enter() do { } while (0)
 # define rcu_irq_exit() do { } while (0)
-#endif /* CONFIG_PREEMPT_RCU */
+#endif /* CONFIG_NO_HZ */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 1658995..811969f 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -28,6 +28,8 @@
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU
  *
+ * Rewrite based on a global state machine
+ * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
  */
 
 #ifndef __LINUX_RCUCLASSIC_H
@@ -39,88 +41,97 @@
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
+#include <linux/rcucpumask.h>
 
+/*
+ * global state machine:
+ * - each cpu regularly check the global state and compares it with it's own local state.
+ * - if both state do not match, then the cpus do the required work and afterwards
+ *   - update their local state
+ *   - clear their bit in the cpu bitmask.
+ * The state machine is protected by the protocol:
+ * The state can only change when all cpus have completed the current stage, thus
+ * random changes cannot happen.
+ * The only exception is the change from RCU_STATE_DESTROY to RCU_STATE_DESTROY_AND_COLLECT,
+ * but this change doesn't matter, because RCU_STATE_DESTROY is a subset of
+ * RCU_STATE_DESTROY_AND_COLLECT.
+ *
+ * The state is stored in the rcu_cpumask structure.
+ */
 
-/* Global control variables for rcupdate callback mechanism. */
-struct rcu_ctrlblk {
-	long	cur;		/* Current batch number.                      */
-	long	completed;	/* Number of the last completed batch         */
-	long	pending;	/* Number of the last pending batch           */
-#ifdef CONFIG_DEBUG_RCU_STALL
-	unsigned long gp_check;	/* Time grace period should end, in seconds.  */
-#endif /* #ifdef CONFIG_DEBUG_RCU_STALL */
-
-	int	signaled;
+/* RCU_STATE_DESTROY:
+ * call callbacks that were registered by call_rcu for the objects in rcu_cpu_state.old
+ */
+#define RCU_STATE_DESTROY		1
+/* RCU_STATE_DESTROY_AND_COLLECT:
+ * - call callbacks that were registered by call_rcu for the objects in rcu_cpu_state.old
+ * - move the objects from rcu_cpu_state.new to rcu_cpu_state.new
+ */
+#define RCU_STATE_DESTROY_AND_COLLECT	2
+/* RCU_STATE_GRACE
+ * - wait for a quiescent state
+ */
+#define RCU_STATE_GRACE			3
 
-	spinlock_t	lock	____cacheline_internodealigned_in_smp;
-	cpumask_t	cpumask; /* CPUs that need to switch in order    */
-				 /* for current batch to proceed.        */
+struct rcu_global_state {
+	seqlock_t		lock;
+	int			start_immediately;
+	long			completed;
+	struct rcu_cpumask	cpus;
 } ____cacheline_internodealigned_in_smp;
 
-/* Is batch a before batch b ? */
-static inline int rcu_batch_before(long a, long b)
-{
-	return (a - b) < 0;
-}
+struct rcu_cpu_state {
+	int state;
 
-/* Is batch a after batch b ? */
-static inline int rcu_batch_after(long a, long b)
-{
-	return (a - b) > 0;
-}
+	int mode;
+	int count;
+	/* new objects, directly from call_rcu().
+	 * The list are length-based, not NULL-terminated.
+	 */
+	struct rcu_head *new;	/* new objects */
+	struct rcu_head **newtail;
+	long            newqlen; 	 /* # of queued callbacks */
+
+	unsigned long	timeout;
 
-/* Per-CPU data for Read-Copy UPdate. */
-struct rcu_data {
-	/* 1) quiescent state handling : */
-	long		quiescbatch;     /* Batch # for grace period */
-	int		passed_quiesc;	 /* User-mode/idle loop etc. */
-	int		qs_pending;	 /* core waits for quiesc state */
+	/* objects that are in rcu grace processing. The actual
+	* state depends on rcu_cpumask_getstate(&rgs->cpus);
+	 */
+	struct rcu_head *old;
+	struct rcu_head **oldtail;
+	long            oldqlen;
 
-	/* 2) batch handling */
 	/*
-	 * if nxtlist is not NULL, then:
-	 * batch:
-	 *	The batch # for the last entry of nxtlist
-	 * [*nxttail[1], NULL = *nxttail[2]):
-	 *	Entries that batch # <= batch
-	 * [*nxttail[0], *nxttail[1]):
-	 *	Entries that batch # <= batch - 1
-	 * [nxtlist, *nxttail[0]):
-	 *	Entries that batch # <= batch - 2
-	 *	The grace period for these entries has completed, and
-	 *	the other grace-period-completed entries may be moved
-	 *	here temporarily in rcu_process_callbacks().
+	 * quiescent state looking:
+	 * When the cpu sees RCU_STATE_DESTROY_AND_COLLECT, it clears looking.
+	 * When the cpu sees RCU_STATE_GRACE, it sets looking and clears
+	 * quiet.
+	 * If looking and quiet are both set, then there was a grace period,
+	 * even if the state machine is called from non-idle context.
 	 */
-	long  	       	batch;
-	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail[3];
-	long            qlen; 	 	 /* # of queued callbacks */
-	struct rcu_head *donelist;
-	struct rcu_head **donetail;
-	long		blimit;		 /* Upper limit on a processed batch */
-	int cpu;
-	struct rcu_head barrier;
+	int quiet;
+	int looking;
 };
 
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
-DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
+/* Note: only one structure for _bh and _normal. */
+struct rcu_cpu_dead {
+	/*
+	 * objects that are scheduled for immediate call of
+	 * ->func().
+	 */
+	struct rcu_head *dead;
+	struct rcu_head **deadtail;
+	long		deadqlen;
 
-/*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
- * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
- */
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-}
-static inline void rcu_bh_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
-}
+	long		batchcount;
+};
+
+DECLARE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_normal);
+DECLARE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_bh);
+DECLARE_PER_CPU(struct rcu_cpu_dead, rcu_cpudata_dead);
+
+extern long rcu_batches_completed(void);
+extern long rcu_batches_completed_bh(void);
 
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
@@ -160,19 +171,41 @@ extern struct lockdep_map rcu_lock_map;
 		local_bh_enable(); \
 	} while (0)
 
+/*
+ * FIXME:
+ * This is wrong:
+ * NMIs are not handled.
+ */
 #define __synchronize_sched() synchronize_rcu()
 
+/*
+ * FIXME:
+ * This is wrong:
+ * NMIs are not handled.
+ */
 #define call_rcu_sched(head, func) call_rcu(head, func)
 
 extern void __rcu_init(void);
 #define rcu_init_sched()	do { } while (0)
 extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
-
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);
 
+#ifdef CONFIG_NO_HZ
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+#else /* CONFIG_NO_HZ */
 #define rcu_enter_nohz()	do { } while (0)
 #define rcu_exit_nohz()		do { } while (0)
+#endif /* CONFIG_NO_HZ */
+
+static inline void rcu_qsctr_inc(int cpu)
+{
+	per_cpu(rcu_cpudata_normal, cpu).quiet = 1;
+	per_cpu(rcu_cpudata_bh, cpu).quiet = 1;
+}
+
+static inline void rcu_bh_qsctr_inc(int cpu)
+{
+	per_cpu(rcu_cpudata_bh, cpu).quiet = 1;
+}
 
 #endif /* __LINUX_RCUCLASSIC_H */
diff --git a/include/linux/rcucpumask.h b/include/linux/rcucpumask.h
new file mode 100644
index 0000000..0a650dd
--- /dev/null
+++ b/include/linux/rcucpumask.h
@@ -0,0 +1,154 @@
+/*
+ * cpu mask with integrated locking, intended for rcu
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
+ *
+ */
+
+#ifndef __LINUX_RCUCPUMASK_H
+#define __LINUX_RCUCPUMASK_H
+
+#include <linux/spinlock.h>
+#include <linux/cpumask.h>
+
+#define RCUCPUMASK_CPULIMIT	512
+
+#if (NR_CPUS > RCUCPUMASK_CPULIMIT)
+
+Bla Bla Bla
+
+#elif (NR_CPUS > 1)
+
+/*
+ * cpu bitmask:
+ * "normal" implementation, single spinlock.
+ */
+
+#define RCUCPUMASK_FLAT 1
+
+struct rcu_cpumask {
+	spinlock_t lock;
+
+	/* number of cpus that are tracked by rcu */
+	int cpus_total;
+
+	/* number of cpus that are still unresolved */
+	int cpus_open;
+
+	int state ____cacheline_internodealigned_in_smp;
+
+	/* debug only: two bitmaps to double check the counters */
+	cpumask_t mask_cpu_total;
+	cpumask_t mask_cpu_open;
+} ____cacheline_internodealigned_in_smp;
+
+#define __RCU_CPUMASK_INIT(ptr) { .lock = __SPIN_LOCK_UNLOCKED(&(ptr)->lock) }
+
+/**
+ * rcu_cpumask_init(rcm, new_state) - initialize cpu mask with all live cpus.
+ * @rcm: rcu cpumask pointer.
+ * @new_state: new global state of the state machine
+ *
+ * This function sets the cpu bits for all cpus that might read pointers
+ * to rcu protected structures.
+ */
+extern void rcu_cpumask_init(struct rcu_cpumask *rcm, int newstate, int setupcpus);
+
+/**
+ * rcu_cpumask_clear_and_test(rcm, cpu) - remove one cpu from cpumask
+ * @rcm: rcu cpumask pointer.
+ * @cpu: cpu to remove
+ *
+ * This function clears the bit for the given @cpu from the cpu mask.
+ * If no other bits are set, then the function returns 1, otherwise 0.
+ */
+extern int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu);
+
+/**
+ * rcu_cpumask_addcpu(rcm, cpu) - list a cpu as important for rcu
+ * @rcm: rcu cpumask pointer.
+ * @cpu: cpu to remove
+ *
+ * This function adds the given cpu to the list of cpus that might access
+ * rcu related structures.
+ * The function return the current state, i.e. the state for which the cpu
+ * doesn't need to do anything.
+ */
+extern int rcu_cpumask_addcpu(struct rcu_cpumask *rcm, int cpu);
+
+/**
+ * rcu_cpumask_removecpu(rcm, cpu) - remove a cpu from cpu list.
+ * @rcm: rcu cpumask pointer.
+ * @cpu: cpu to remove
+ *
+ * The function removes the given @cpu from the list of rcu related cpus.
+ * A cpu that is not listed must neither call call_rcu() nor access any
+ * rcu protected structures.
+ *
+ * The function returns the state for which the cpu is still listed,
+ * i.e. the cpu must do the work for that state.
+ */
+extern int rcu_cpumask_removecpu(struct rcu_cpumask *rcm, int cpu);
+
+#else /* NR_CPUS == 1 */
+
+/*
+ * cpu bitmask: uniprocessor optimized.
+ * - there is just one cpu, it's always online.
+ * - clear_and_test always clears the only bit that could be set,
+ *   thus it always returns 1.
+ * Conclusion: No datastorage at all needed.
+ */
+
+struct rcu_cpumask {
+	int state;
+};
+
+#define __RCU_CPUMASK_INIT(ptr) { .state = 0 }
+
+static inline void rcu_cpumask_init(struct rcu_cpumask *rcm, int newstate, int setupcpus)
+{
+	rcm->state = newstate;
+}
+static inline int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu)
+{
+	return 1;
+}
+static inline int rcu_cpumask_addcpu(struct rcu_cpumask *rcm, int cpu)
+{
+	return rcm->state;
+}
+
+static inline int rcu_cpumask_removecpu(struct rcu_cpumask *rcm, int cpu)
+{
+	return rcm->state;
+}
+
+#endif /* NR_CPUS == 1 */
+
+/**
+ * rcu_cpumask_getstate(rcm) - retrieve the current state
+ * @rcm: rcu cpumask pointer.
+ *
+ * This function returns the current state from the cpu mask.
+ */
+static inline int rcu_cpumask_getstate(struct rcu_cpumask *rcm)
+{
+	return rcm->state;
+}
+
+#endif /* __LINUX_RCUCPUMASK_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..5880391 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -73,7 +73,7 @@ obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
-obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
+obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o rcucpumask.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 01e761a..a63f578 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -29,6 +29,9 @@
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU
  *
+ * Rewrite based on a global state machine
+ * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
+ *
  */
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -49,6 +52,7 @@
 #include <linux/mutex.h>
 #include <linux/time.h>
 
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
@@ -56,112 +60,131 @@ struct lockdep_map rcu_lock_map =
 EXPORT_SYMBOL_GPL(rcu_lock_map);
 #endif
 
-
 /* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_ctrlblk = {
-	.cur = -300,
-	.completed = -300,
-	.pending = -300,
-	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
+static struct rcu_global_state rcu_global_state_normal = {
+	.lock = __SEQLOCK_UNLOCKED(&rcu_global_state_normal.lock),
+	.start_immediately = 0,
+	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_normal.cpus)
 };
-static struct rcu_ctrlblk rcu_bh_ctrlblk = {
-	.cur = -300,
-	.completed = -300,
-	.pending = -300,
-	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
+
+static struct rcu_global_state rcu_global_state_bh = {
+	.lock = __SEQLOCK_UNLOCKED(&rcu_global_state_bh.lock),
+	.start_immediately = 0,
+	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_bh.cpus)
 };
 
-DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
+DEFINE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_normal) = { 0L };
+DEFINE_PER_CPU(struct rcu_cpu_state, rcu_cpudata_bh) = { 0L };
+DEFINE_PER_CPU(struct rcu_cpu_dead, rcu_cpudata_dead) = { 0L };
 
-static int blimit = 10;
-static int qhimark = 10000;
-static int qlowmark = 100;
 
-#ifdef CONFIG_SMP
-static void force_quiescent_state(struct rcu_data *rdp,
-			struct rcu_ctrlblk *rcp)
-{
-	int cpu;
-	cpumask_t cpumask;
-	unsigned long flags;
+/*
+ * rcu_cpumode:
+ * -1:
+ * "normal" rcu behavior: the scheduler and the timer interrupt
+ * check for grace periods, read side critical sections are permitted
+ * everywhere.
+ *
+ * 0:
+ * This cpu is sitting in the idle thread, with disabled hz timer.
+ *
+ * > 0:
+ * The cpu is in an interrupt that interrupted a nohz idle thread.
+ */
 
-	set_need_resched();
-	spin_lock_irqsave(&rcp->lock, flags);
-	if (unlikely(!rcp->signaled)) {
-		rcp->signaled = 1;
-		/*
-		 * Don't send IPI to itself. With irqs disabled,
-		 * rdp->cpu is the current cpu.
-		 *
-		 * cpu_online_map is updated by the _cpu_down()
-		 * using __stop_machine(). Since we're in irqs disabled
-		 * section, __stop_machine() is not exectuting, hence
-		 * the cpu_online_map is stable.
-		 *
-		 * However,  a cpu might have been offlined _just_ before
-		 * we disabled irqs while entering here.
-		 * And rcu subsystem might not yet have handled the CPU_DEAD
-		 * notification, leading to the offlined cpu's bit
-		 * being set in the rcp->cpumask.
-		 *
-		 * Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
-		 * sending smp_reschedule() to an offlined CPU.
-		 */
-		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
-		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask_nr(cpu, cpumask)
-			smp_send_reschedule(cpu);
-	}
-	spin_unlock_irqrestore(&rcp->lock, flags);
+#define RCU_CPUMODE_INVALID	-2
+#define RCU_CPUMODE_DELAYED	-1
+DEFINE_PER_CPU(int, rcu_cpumode) = { 0L };
+
+int qlowmark = 100;
+
+long rcu_batches_completed(void)
+{
+	return rcu_global_state_normal.completed;
 }
-#else
-static inline void force_quiescent_state(struct rcu_data *rdp,
-			struct rcu_ctrlblk *rcp)
+
+long rcu_batches_completed_bh(void)
 {
-	set_need_resched();
+	return rcu_global_state_normal.completed;
 }
-#endif
 
-static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
-		struct rcu_data *rdp)
+/**
+ * rcu_state_startcycle - start the next rcu cycle
+ * @rgs: global rcu state
+ *
+ * The function starts the next rcu cycle, either immediately or
+ * by setting rgs->start_immediately.
+ */
+static void rcu_state_startcycle(struct rcu_global_state *rgs)
+{
+	unsigned seq;
+	int do_real_start;
+
+	BUG_ON(!irqs_disabled());
+	do {
+		seq = read_seqbegin(&rgs->lock);
+		if (rgs->start_immediately == 0) {
+			do_real_start = 1;
+		} else {
+			do_real_start = 0;
+			BUG_ON(rcu_cpumask_getstate(&rgs->cpus) == RCU_STATE_DESTROY);
+		}
+	} while (read_seqretry(&rgs->lock, seq));
+
+	if (do_real_start) {
+		write_seqlock(&rgs->lock);
+		switch(rcu_cpumask_getstate(&rgs->cpus)) {
+		case RCU_STATE_DESTROY_AND_COLLECT:
+		case RCU_STATE_GRACE:
+			rgs->start_immediately = 1;
+			break;
+		case RCU_STATE_DESTROY:
+			rcu_cpumask_init(&rgs->cpus, RCU_STATE_DESTROY_AND_COLLECT, 1);
+			smp_wmb();
+			BUG_ON(rgs->start_immediately);
+			break;
+		default:
+			BUG();
+		}
+		write_sequnlock(&rgs->lock);
+	}
+}
+
+/*
+ * Delay that can occur for synchronize_rcu() callers
+ */
+#define RCU_MAX_DELAY	(HZ/30+1)
+
+static void rcu_checkqlen(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int inc)
 {
-	long batch;
+	BUG_ON(!irqs_disabled());
+	if (unlikely(rcs->newqlen == 0)) {
+		rcs->timeout = jiffies + RCU_MAX_DELAY;
+	}
+	if ((rcs->newqlen < qlowmark) && (rcs->newqlen+inc >= qlowmark))
+		rcu_state_startcycle(rgs);
 
-	head->next = NULL;
-	smp_mb(); /* Read of rcu->cur must happen after any change by caller. */
+	rcs->newqlen += inc;
 
 	/*
-	 * Determine the batch number of this callback.
-	 *
-	 * Using ACCESS_ONCE to avoid the following error when gcc eliminates
-	 * local variable "batch" and emits codes like this:
-	 *	1) rdp->batch = rcp->cur + 1 # gets old value
-	 *	......
-	 *	2)rcu_batch_after(rcp->cur + 1, rdp->batch) # gets new value
-	 * then [*nxttail[0], *nxttail[1]) may contain callbacks
-	 * that batch# = rdp->batch, see the comment of struct rcu_data.
+	 * This is not really a bug, it might happen when interrupt calls
+	 * call_rcu() while the cpu is in nohz mode. see rcu_irq_exit
 	 */
-	batch = ACCESS_ONCE(rcp->cur) + 1;
-
-	if (rdp->nxtlist && rcu_batch_after(batch, rdp->batch)) {
-		/* process callbacks */
-		rdp->nxttail[0] = rdp->nxttail[1];
-		rdp->nxttail[1] = rdp->nxttail[2];
-		if (rcu_batch_after(batch - 1, rdp->batch))
-			rdp->nxttail[0] = rdp->nxttail[2];
-	}
+	WARN_ON( (rcs->newqlen >= qlowmark) && (rcu_cpumask_getstate(&rgs->cpus) == RCU_STATE_DESTROY));
+}
 
-	rdp->batch = batch;
-	*rdp->nxttail[2] = head;
-	rdp->nxttail[2] = &head->next;
 
-	if (unlikely(++rdp->qlen > qhimark)) {
-		rdp->blimit = INT_MAX;
-		force_quiescent_state(rdp, &rcu_ctrlblk);
+static void __call_rcu(struct rcu_head *head, struct rcu_global_state *rgs,
+		struct rcu_cpu_state *rcs)
+{
+	if (rcs->new == NULL) {
+		rcs->new = head;
+	} else {
+		(*rcs->newtail) = head;
 	}
+	rcs->newtail = &head->next;
+
+	rcu_checkqlen(rgs, rcs, 1);
 }
 
 /**
@@ -182,7 +205,7 @@ void call_rcu(struct rcu_head *head,
 
 	head->func = func;
 	local_irq_save(flags);
-	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
+	__call_rcu(head, &rcu_global_state_normal, &__get_cpu_var(rcu_cpudata_normal));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
@@ -210,462 +233,367 @@ void call_rcu_bh(struct rcu_head *head,
 
 	head->func = func;
 	local_irq_save(flags);
-	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
+	__call_rcu(head, &rcu_global_state_bh, &__get_cpu_var(rcu_cpudata_bh));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
-/*
- * Return the number of RCU batches processed thus far.  Useful
- * for debug and statistics.
- */
-long rcu_batches_completed(void)
-{
-	return rcu_ctrlblk.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
-
-/*
- * Return the number of RCU batches processed thus far.  Useful
- * for debug and statistics.
- */
-long rcu_batches_completed_bh(void)
-{
-	return rcu_bh_ctrlblk.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
+#define RCU_BATCH_MIN		100
+#define	RCU_BATCH_INCFACTOR	2
+#define RCU_BATCH_DECFACTOR	4
 
-/* Raises the softirq for processing rcu_callbacks. */
-static inline void raise_rcu_softirq(void)
+static void rcu_move_and_raise(struct rcu_cpu_state *rcs, int do_raise)
 {
-	raise_softirq(RCU_SOFTIRQ);
-}
+	struct rcu_cpu_dead *rcd = &get_cpu_var(rcu_cpudata_dead);
 
-/*
- * Invoke the completed RCU callbacks. They are expected to be in
- * a per-cpu list.
- */
-static void rcu_do_batch(struct rcu_data *rdp)
-{
-	struct rcu_head *next, *list;
-	int count = 0;
+	BUG_ON(!irqs_disabled());
 
-	list = rdp->donelist;
-	while (list) {
-		next = list->next;
-		prefetch(next);
-		list->func(list);
-		list = next;
-		if (++count >= rdp->blimit)
-			break;
+	/* update batch limit:
+	 * - if there are still old entries when new entries are added:
+	 *   double the batch count.
+	 * - if there are no old entries: reduce it by 25%, but never below 100.
+	 */
+	if (rcd->deadqlen)
+		rcd->batchcount = rcd->batchcount*RCU_BATCH_INCFACTOR;
+	 else
+		rcd->batchcount = rcd->batchcount-rcd->batchcount/RCU_BATCH_DECFACTOR;
+	if (rcd->batchcount < RCU_BATCH_MIN)
+		rcd->batchcount = RCU_BATCH_MIN;
+
+	if (rcs->old != NULL) {
+		if (rcd->dead == NULL) {
+			rcd->dead = rcs->old;
+		} else {
+			(*rcd->deadtail) = rcs->old;
+		}
+		rcd->deadtail = rcs->oldtail;
+		rcd->deadqlen += rcs->oldqlen;
 	}
-	rdp->donelist = list;
 
-	local_irq_disable();
-	rdp->qlen -= count;
-	local_irq_enable();
-	if (rdp->blimit == INT_MAX && rdp->qlen <= qlowmark)
-		rdp->blimit = blimit;
+	rcs->old = NULL;
+	rcs->oldtail = NULL;
+	rcs->oldqlen = 0;
 
-	if (!rdp->donelist)
-		rdp->donetail = &rdp->donelist;
-	else
-		raise_rcu_softirq();
-}
-
-/*
- * Grace period handling:
- * The grace period handling consists out of two steps:
- * - A new grace period is started.
- *   This is done by rcu_start_batch. The start is not broadcasted to
- *   all cpus, they must pick this up by comparing rcp->cur with
- *   rdp->quiescbatch. All cpus are recorded  in the
- *   rcu_ctrlblk.cpumask bitmap.
- * - All cpus must go through a quiescent state.
- *   Since the start of the grace period is not broadcasted, at least two
- *   calls to rcu_check_quiescent_state are required:
- *   The first call just notices that a new grace period is running. The
- *   following calls check if there was a quiescent state since the beginning
- *   of the grace period. If so, it updates rcu_ctrlblk.cpumask. If
- *   the bitmap is empty, then the grace period is completed.
- *   rcu_check_quiescent_state calls rcu_start_batch(0) to start the next grace
- *   period (if necessary).
- */
+	if (do_raise)
+		raise_softirq(RCU_SOFTIRQ);
 
-#ifdef CONFIG_DEBUG_RCU_STALL
-
-static inline void record_gp_check_time(struct rcu_ctrlblk *rcp)
-{
-	rcp->gp_check = get_seconds() + 3;
+	put_cpu_var(rcu_cpudata_dead);
 }
 
-static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
+static void __rcu_state_machine(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs,
+					int global_state, int is_quiet, int do_raise, int cpu)
 {
-	int cpu;
-	long delta;
+	int inc_state;
 	unsigned long flags;
 
-	/* Only let one CPU complain about others per time interval. */
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	delta = get_seconds() - rcp->gp_check;
-	if (delta < 2L || cpus_empty(rcp->cpumask)) {
-		spin_unlock(&rcp->lock);
-		return;
+	/*
+	 * Theoretically, this code should run under read_seqbegin().
+	 * But: important chages (i.e. from COLLECT to GRACE,
+	 * from GRACE to DESTROY) only happen when all cpus have completed
+	 * their work. If rcu_cpumask_getstate(&rgs->cpus) != rcs->state, then we haven't completed
+	 * our work yet. Thus such a change cannot happen.
+	 * The only change that might happen is a change from RCU_STATE_DESTROY
+	 * to RCU_STATE_DESTROY_AND_COLLECT. We'll notice that in the next
+	 * round.
+	 * no need for an mb() either - it simply doesn't matter.
+	 * Actually: when rcu_state_startcycle() is called, then it's guaranteed
+	 * that global_state and rcu_cpumask_getstate(&rgs->cpus) do not match...
+	 */
+	local_irq_save(flags);
+	if (global_state == RCU_STATE_DESTROY && rcs->newqlen > 0 &&
+		time_after(jiffies, rcs->timeout) && do_raise) {
+printk(KERN_ERR" delayed rcu start for %p: %ld entries (cpu %d, ptr %p).\n", rgs, rcs->newqlen, cpu, rcs);
+		rcu_state_startcycle(rgs);
 	}
-	rcp->gp_check = get_seconds() + 30;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-
-	/* OK, time to rat on our buddy... */
-
-	printk(KERN_ERR "RCU detected CPU stalls:");
-	for_each_cpu_mask(cpu, rcp->cpumask)
-		printk(" %d", cpu);
-	printk(" (detected by %d, t=%lu/%lu)\n",
-	       smp_processor_id(), get_seconds(), rcp->gp_check);
-}
-
-static void print_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	unsigned long flags;
-
-	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu)\n",
-			smp_processor_id(), get_seconds(), rcp->gp_check);
-	dump_stack();
-	spin_lock_irqsave(&rcp->lock, flags);
-	if ((long)(get_seconds() - rcp->gp_check) >= 0L)
-		rcp->gp_check = get_seconds() + 30;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-}
-
-static void check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-	long delta;
-
-	delta = get_seconds() - rcp->gp_check;
-	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0L) {
 
-		/* We haven't checked in, so go dump stack. */
-
-		print_cpu_stall(rcp);
-
-	} else {
-		if (!cpus_empty(rcp->cpumask) && delta >= 2L) {
-			/* They had two seconds to dump stack, so complain. */
-			print_other_cpu_stall(rcp);
+	inc_state = 0;
+	if (global_state != rcs->state) {
+		switch(global_state) {
+		case RCU_STATE_DESTROY:
+			rcs->state = RCU_STATE_DESTROY;
+			rcu_move_and_raise(rcs, do_raise);
+			break;
+		case RCU_STATE_DESTROY_AND_COLLECT:
+			rcs->state = RCU_STATE_DESTROY_AND_COLLECT;
+			rcu_move_and_raise(rcs, do_raise);
+			rcs->old = rcs->new;
+			rcs->oldtail = rcs->newtail;
+			rcs->oldqlen = rcs->newqlen;
+			rcs->new = NULL;
+			rcs->newtail = NULL;
+			rcs->newqlen = 0;
+			rcs->looking = 0;
+			if (rcu_cpumask_clear_and_test(&rgs->cpus, cpu))
+				inc_state = 1;
+			break;
+		case RCU_STATE_GRACE:
+			if (is_quiet || (rcs->quiet && rcs->looking)) {
+				rcs->state = RCU_STATE_GRACE;
+				if (rcu_cpumask_clear_and_test(&rgs->cpus, cpu))
+					inc_state = 1;
+			}
+			rcs->quiet = 0;
+			rcs->looking = 1;
+			break;
+		default:
+			BUG();
 		}
 	}
-}
-
-#else /* #ifdef CONFIG_DEBUG_RCU_STALL */
 
-static inline void record_gp_check_time(struct rcu_ctrlblk *rcp)
-{
-}
-
-static inline void
-check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-}
-
-#endif /* #else #ifdef CONFIG_DEBUG_RCU_STALL */
-
-/*
- * Register a new batch of callbacks, and start it up if there is currently no
- * active batch and the batch to be registered has not already occurred.
- * Caller must hold rcu_ctrlblk.lock.
- */
-static void rcu_start_batch(struct rcu_ctrlblk *rcp)
-{
-	if (rcp->cur != rcp->pending &&
-			rcp->completed == rcp->cur) {
-		rcp->cur++;
-		record_gp_check_time(rcp);
+	if (unlikely(inc_state)) {
+		local_irq_save(flags);
+		write_seqlock(&rgs->lock);
 
+		BUG_ON(rcu_cpumask_getstate(&rgs->cpus) != rcs->state);
+		BUG_ON(global_state != rcu_cpumask_getstate(&rgs->cpus));
 		/*
-		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
-		 * Barrier  Otherwise it can cause tickless idle CPUs to be
-		 * included in rcp->cpumask, which will extend graceperiods
-		 * unnecessarily.
+		 * advance the state machine:
+		 * - from COLLECT to GRACE
+		 * - from GRACE to DESTROY/COLLECT
 		 */
-		smp_mb();
-		cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
-
-		rcp->signaled = 0;
+		switch(rcu_cpumask_getstate(&rgs->cpus)) {
+		case RCU_STATE_DESTROY_AND_COLLECT:
+			rcu_cpumask_init(&rgs->cpus, RCU_STATE_GRACE, 1);
+			break;
+		case RCU_STATE_GRACE:
+			rgs->completed++;
+			if (rgs->start_immediately) {
+				rcu_cpumask_init(&rgs->cpus, RCU_STATE_DESTROY_AND_COLLECT, 1);
+			} else {
+				rcu_cpumask_init(&rgs->cpus, RCU_STATE_DESTROY, 0);
+			}
+			rgs->start_immediately = 0;
+			break;
+		default:
+			BUG();
+		}
+		write_sequnlock(&rgs->lock);
+		local_irq_restore(flags);
 	}
 }
 
-/*
- * cpu went through a quiescent state since the beginning of the grace period.
- * Clear it from the cpu mask and complete the grace period if it was the last
- * cpu. Start another grace period if someone has further entries pending
- */
-static void cpu_quiet(int cpu, struct rcu_ctrlblk *rcp)
+static void rcu_state_machine(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int is_quiet, int cpu)
 {
-	cpu_clear(cpu, rcp->cpumask);
-	if (cpus_empty(rcp->cpumask)) {
-		/* batch completed ! */
-		rcp->completed = rcp->cur;
-		rcu_start_batch(rcp);
-	}
-}
+	int global_state = rcu_cpumask_getstate(&rgs->cpus);
 
-/*
- * Check if the cpu has gone through a quiescent state (say context
- * switch). If so and if it already hasn't done so in this RCU
- * quiescent cycle, then indicate that it has done so.
- */
-static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
-					struct rcu_data *rdp)
-{
-	unsigned long flags;
+	/* gcc should not optimize away the local variable global_state... */
+	barrier();
+	__rcu_state_machine(rgs, rcs, global_state, is_quiet, 1, cpu);
+}
 
-	if (rdp->quiescbatch != rcp->cur) {
-		/* start new grace period: */
-		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
-		rdp->quiescbatch = rcp->cur;
-		return;
-	}
+#if defined(CONFIG_HOTPLUG_CPU) || defined (CONFIG_NO_HZ)
 
-	/* Grace period already completed for this cpu?
-	 * qs_pending is checked instead of the actual bitmap to avoid
-	 * cacheline trashing.
-	 */
-	if (!rdp->qs_pending)
-		return;
+static void __rcu_remove_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int cpu)
+{
+	int global_state;
+	unsigned seq;
 
-	/*
-	 * Was there a quiescent state since the beginning of the grace
-	 * period? If no, then exit and wait for the next call.
+	BUG_ON(!irqs_disabled());
+	/* task 1:
+	 * Do the work that the cpu is still supposed to do.
+	 * We rely on the lock inside the rcu_cpumask, that guarantees that
+	 * we neither do too much nor too little.
+	 * But do not raise the softirq, the caller is responsible handling
+	 * the entries stil in the queues.
 	 */
-	if (!rdp->passed_quiesc)
-		return;
-	rdp->qs_pending = 0;
+	global_state = rcu_cpumask_removecpu(&rgs->cpus, cpu);
 
-	spin_lock_irqsave(&rcp->lock, flags);
 	/*
-	 * rdp->quiescbatch/rcp->cur and the cpu bitmap can come out of sync
-	 * during cpu startup. Ignore the quiescent state.
+	 * ensure that we are not in the middle of updating
+	 * rcu_cpumask_getstate(&rgs->cpus): otherwise __rcu_state_machine()
+	 * would return with "nothing to do", although
+	 * the cpu must do something.
 	 */
-	if (likely(rdp->quiescbatch == rcp->cur))
-		cpu_quiet(rdp->cpu, rcp);
+	do {
+		seq = read_seqbegin(&rgs->lock);
+	} while (read_seqretry(&rgs->lock, seq));
 
-	spin_unlock_irqrestore(&rcp->lock, flags);
+	__rcu_state_machine(rgs, rcs, global_state, 1, 0, cpu);
 }
 
+#endif
 
 #ifdef CONFIG_HOTPLUG_CPU
-
-/* warning! helper for rcu_offline_cpu. do not use elsewhere without reviewing
- * locking requirements, the list it's pulling from has to belong to a cpu
- * which is dead and hence not processing interrupts.
+/**
+ * rcu_bulk_add - bulk add new rcu objects.
+ * @rgs: global rcu state
+ * @rcs: cpu state
+ * @h: linked list of rcu objects.
+ *
+ * Must be called with enabled local interrupts
  */
-static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
-				struct rcu_head **tail, long batch)
+static void rcu_bulk_add(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, struct rcu_head *h, struct rcu_head **htail, int len)
 {
-	if (list) {
+
+	BUG_ON(irqs_disabled());
+
+	if (len > 0) {
 		local_irq_disable();
-		this_rdp->batch = batch;
-		*this_rdp->nxttail[2] = list;
-		this_rdp->nxttail[2] = tail;
+		if (rcs->new == NULL) {
+			rcs->new = h;
+		} else {
+			(*rcs->newtail) = h;
+		}
+		rcs->newtail = htail;
+
+		rcu_checkqlen(rgs, rcs, len);
 		local_irq_enable();
 	}
 }
 
-static void __rcu_offline_cpu(struct rcu_data *this_rdp,
-				struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-	unsigned long flags;
 
+static void __rcu_offline_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *this_rcs,
+					struct rcu_cpu_state *other_rcs, int cpu)
+{
 	/*
-	 * if the cpu going offline owns the grace period
-	 * we can block indefinitely waiting for it, so flush
-	 * it here
+	 * task 1: Do the work that the other cpu is still supposed to do.
 	 */
-	spin_lock_irqsave(&rcp->lock, flags);
-	if (rcp->cur != rcp->completed)
-		cpu_quiet(rdp->cpu, rcp);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
-	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
-	spin_unlock(&rcp->lock);
-
-	this_rdp->qlen += rdp->qlen;
-	local_irq_restore(flags);
+	__rcu_remove_cpu(rgs, other_rcs, cpu);
+	per_cpu(rcu_cpumode, cpu) = RCU_CPUMODE_INVALID;
+
+	/* task 2: move all entries from the new cpu into the lists of the current cpu.
+	 * locking: The other cpu is dead, thus no locks are required.
+	 *  Thus it's more or less a bulk call_rcu().
+	 * For the sake of simplicity, all objects are treated as "new", even the objects
+	 * that are already in old.
+	 */
+	rcu_bulk_add(rgs, this_rcs, other_rcs->new, other_rcs->newtail, other_rcs->newqlen);
+	rcu_bulk_add(rgs, this_rcs, other_rcs->old, other_rcs->oldtail, other_rcs->oldqlen);
 }
 
 static void rcu_offline_cpu(int cpu)
 {
-	struct rcu_data *this_rdp = &get_cpu_var(rcu_data);
-	struct rcu_data *this_bh_rdp = &get_cpu_var(rcu_bh_data);
-
-	__rcu_offline_cpu(this_rdp, &rcu_ctrlblk,
-					&per_cpu(rcu_data, cpu));
-	__rcu_offline_cpu(this_bh_rdp, &rcu_bh_ctrlblk,
-					&per_cpu(rcu_bh_data, cpu));
-	put_cpu_var(rcu_data);
-	put_cpu_var(rcu_bh_data);
-}
+	struct rcu_cpu_state *this_rcs_normal = &get_cpu_var(rcu_cpudata_normal);
+	struct rcu_cpu_state *this_rcs_bh = &get_cpu_var(rcu_cpudata_bh);
+	struct rcu_cpu_dead *this_rcd, *other_rcd;
 
-#else
+	BUG_ON(irqs_disabled());
 
-static void rcu_offline_cpu(int cpu)
-{
-}
+	/* step 1: move new & old lists, clear cpu bitmask */
+	__rcu_offline_cpu(&rcu_global_state_normal, this_rcs_normal,
+					&per_cpu(rcu_cpudata_normal, cpu), cpu);
+	__rcu_offline_cpu(&rcu_global_state_bh, this_rcs_bh,
+					&per_cpu(rcu_cpudata_bh, cpu), cpu);
+	put_cpu_var(rcu_cpudata_normal);
+	put_cpu_var(rcu_cpudata_bh);
 
-#endif
-
-/*
- * This does the RCU processing work from softirq context.
- */
-static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
-					struct rcu_data *rdp)
-{
-	long completed_snap;
+	/* step 2: move dead list */
+	this_rcd = &get_cpu_var(rcu_cpudata_dead);
+	other_rcd = &per_cpu(rcu_cpudata_dead, cpu);
 
-	if (rdp->nxtlist) {
+	if (other_rcd->dead != NULL) {
 		local_irq_disable();
-		completed_snap = ACCESS_ONCE(rcp->completed);
-
-		/*
-		 * move the other grace-period-completed entries to
-		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
-		 */
-		if (!rcu_batch_before(completed_snap, rdp->batch))
-			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
-		else if (!rcu_batch_before(completed_snap, rdp->batch - 1))
-			rdp->nxttail[0] = rdp->nxttail[1];
-
-		/*
-		 * the grace period for entries in
-		 * [rdp->nxtlist, *rdp->nxttail[0]) has completed and
-		 * move these entries to donelist
-		 */
-		if (rdp->nxttail[0] != &rdp->nxtlist) {
-			*rdp->donetail = rdp->nxtlist;
-			rdp->donetail = rdp->nxttail[0];
-			rdp->nxtlist = *rdp->nxttail[0];
-			*rdp->donetail = NULL;
-
-			if (rdp->nxttail[1] == rdp->nxttail[0])
-				rdp->nxttail[1] = &rdp->nxtlist;
-			if (rdp->nxttail[2] == rdp->nxttail[0])
-				rdp->nxttail[2] = &rdp->nxtlist;
-			rdp->nxttail[0] = &rdp->nxtlist;
+		if (this_rcd->dead == NULL) {
+			this_rcd->dead = other_rcd->dead;
+		} else {
+			(*this_rcd->deadtail) = other_rcd->dead;
 		}
-
+		this_rcd->deadtail = other_rcd->deadtail;
+		this_rcd->deadqlen += other_rcd->deadqlen;
 		local_irq_enable();
-
-		if (rcu_batch_after(rdp->batch, rcp->pending)) {
-			unsigned long flags;
-
-			/* and start it/schedule start if it's a new batch */
-			spin_lock_irqsave(&rcp->lock, flags);
-			if (rcu_batch_after(rdp->batch, rcp->pending)) {
-				rcp->pending = rdp->batch;
-				rcu_start_batch(rcp);
-			}
-			spin_unlock_irqrestore(&rcp->lock, flags);
-		}
 	}
 
-	rcu_check_quiescent_state(rcp, rdp);
-	if (rdp->donelist)
-		rcu_do_batch(rdp);
+	put_cpu_var(rcu_cpudata_dead);
+
+	BUG_ON(rcu_needs_cpu(cpu));
 }
 
-static void rcu_process_callbacks(struct softirq_action *unused)
-{
-	/*
-	 * Memory references from any prior RCU read-side critical sections
-	 * executed by the interrupted code must be see before any RCU
-	 * grace-period manupulations below.
-	 */
+#else
 
-	smp_mb(); /* See above block comment. */
+static void rcu_offline_cpu(int cpu)
+{
+}
 
-	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
-	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
+#endif
 
+static int __rcu_pending(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs)
+{
 	/*
-	 * Memory references from any later RCU read-side critical sections
-	 * executed by the interrupted code must be see after any RCU
-	 * grace-period manupulations above.
+	 * This cpu must do something for the state machine.
 	 */
-
-	smp_mb(); /* See above block comment. */
-}
-
-static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-	/* Check for CPU stalls, if enabled. */
-	check_cpu_stall(rcp, rdp);
-
-	if (rdp->nxtlist) {
-		long completed_snap = ACCESS_ONCE(rcp->completed);
-
-		/*
-		 * This cpu has pending rcu entries and the grace period
-		 * for them has completed.
-		 */
-		if (!rcu_batch_before(completed_snap, rdp->batch))
-			return 1;
-		if (!rcu_batch_before(completed_snap, rdp->batch - 1) &&
-				rdp->nxttail[0] != rdp->nxttail[1])
-			return 1;
-		if (rdp->nxttail[0] != &rdp->nxtlist)
-			return 1;
-
-		/*
-		 * This cpu has pending rcu entries and the new batch
-		 * for then hasn't been started nor scheduled start
-		 */
-		if (rcu_batch_after(rdp->batch, rcp->pending))
-			return 1;
-	}
-
-	/* This cpu has finished callbacks to invoke */
-	if (rdp->donelist)
+	if (rcu_cpumask_getstate(&rgs->cpus) != rcs->state)
 		return 1;
-
-	/* The rcu core waits for a quiescent state from the cpu */
-	if (rdp->quiescbatch != rcp->cur || rdp->qs_pending)
+	/*
+	 * The state machine is stopped and the current
+	 * cpu has outstanding rcu callbacks
+	 */
+	if (rcs->state == RCU_STATE_DESTROY && rcs->newqlen)
 		return 1;
 
-	/* nothing to do */
 	return 0;
 }
 
-/*
+/**
+ * void rcu_pending(int cpu) - check for pending rcu related work.
+ * @cpu: cpu to check.
+ *
  * Check to see if there is any immediate RCU-related work to be done
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
+ *
+ * This function is inherently racy: If it returns 1, then there is something
+ * to do. If it return 0, then there was nothing to do. It's possible that
+ * by the time rcu_pending returns, there is now something to do.
+ *
  */
 int rcu_pending(int cpu)
 {
-	return __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
-		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu));
+	return __rcu_pending(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu)) ||
+		__rcu_pending(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu));
 }
 
-/*
+static int __rcu_needs_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs)
+{
+	if (rcs->new)
+		return 1;
+	if (rcs->old)
+		return 1;
+	return 0;
+}
+
+/**
+ * void rcu_needs_cpu(cpu) - check for outstanding rcu work.
+ * @cpu: cpu to check.
+ *
  * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
+ * by @cpu, even if none need be done immediately, returning
  * 1 if so.  This function is part of the RCU implementation; it is -not-
  * an exported member of the RCU API.
+ *
+ * Locking only works properly if the function is called for the current
+ * cpu and with disabled local interupts. It's a prerequisite for
+ * rcu_nohz_enter() that rcu_needs_cpu() return 0. Local interupts must not
+ * be enabled in between, otherwise a softirq could call call_rcu().
+ *
+ * Note: rcu_needs_cpu() can be 0 (cpu not needed) even though rcu_pending()
+ * return 1. This means that the outstanding work can be completed by either
+ * the CPU_DEAD callback or rcu_enter_nohz().
  */
 int rcu_needs_cpu(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
+	int ret;
+	BUG_ON(!irqs_disabled());
+
+	ret  = __rcu_needs_cpu(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu)) ||
+		__rcu_needs_cpu(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu)) ||
+		(per_cpu(rcu_cpudata_dead, cpu).deadqlen > 0);
+printk(KERN_ERR" rcu_needs cpu %d: %d.\n", cpu, ret);
 
-	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
+	return ret;
 }
 
-/*
+/**
+ * rcu_check_callback(cpu, user) - external entry point for grace checking
+ * @cpu: cpu id.
+ * @user: user space was interrupted.
+ *
  * Top-level function driving RCU grace-period detection, normally
  * invoked from the scheduler-clock interrupt.  This function simply
  * increments counters that are read only from softirq by this same
  * CPU, so there are no memory barriers required.
+ *
+ * This function can run with disabled local interrupts, thus all
+ * callees must use local_irq_save()
  */
 void rcu_check_callbacks(int cpu, int user)
 {
@@ -679,17 +607,9 @@ void rcu_check_callbacks(int cpu, int user)
 		 * nested interrupt.  In this case, the CPU is in
 		 * a quiescent state, so count it.
 		 *
-		 * Also do a memory barrier.  This is needed to handle
-		 * the case where writes from a preempt-disable section
-		 * of code get reordered into schedule() by this CPU's
-		 * write buffer.  The memory barrier makes sure that
-		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
-		 * by other CPUs to happen after any such write.
 		 */
-
-		smp_mb();  /* See above block comment. */
-		rcu_qsctr_inc(cpu);
-		rcu_bh_qsctr_inc(cpu);
+		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 1, cpu);
+		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 1, cpu);
 
 	} else if (!in_softirq()) {
 
@@ -697,39 +617,233 @@ void rcu_check_callbacks(int cpu, int user)
 		 * Get here if this CPU did not take its interrupt from
 		 * softirq, in other words, if it is not interrupting
 		 * a rcu_bh read-side critical section.  This is an _bh
-		 * critical section, so count it.  The memory barrier
-		 * is needed for the same reason as is the above one.
+		 * critical section, so count it.
+		 */
+		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 0, cpu);
+		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 1, cpu);
+	} else {
+		/*
+		 * We are interrupting something. Nevertheless - check if we should collect
+		 * rcu objects. This can be done from arbitrary context.
 		 */
+		rcu_state_machine(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), 0, cpu);
+		rcu_state_machine(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), 0, cpu);
+	}
+}
+
+/*
+ * Invoke the completed RCU callbacks.
+ */
+static void rcu_do_batch(struct rcu_cpu_dead *rcd)
+{
+	struct rcu_head *list;
+	int i, count;
+
+	if (!rcd->deadqlen)
+		return;
+
+	/* step 1: pull up to rcs->batchcount objects */
+	BUG_ON(irqs_disabled());
+	local_irq_disable();
+
+	if (rcd->deadqlen > rcd->batchcount) {
+		struct rcu_head *walk;
+
+		list = rcd->dead;
+		count = rcd->batchcount;
+
+		walk = rcd->dead;
+		for (i=0;i<count;i++)
+			walk = walk->next;
+		rcd->dead = walk;
+
+	} else {
+		list = rcd->dead;
+		count = rcd->deadqlen;
+
+		rcd->dead = NULL;
+		rcd->deadtail = NULL;
+	}
+	rcd->deadqlen -= count;
+	BUG_ON(rcd->deadqlen < 0);
+
+	local_irq_enable();
+
+	/* step 2: call the rcu callbacks */
+
+	for (i=0;i<count;i++) {
+		struct rcu_head *next;
 
-		smp_mb();  /* See above block comment. */
-		rcu_bh_qsctr_inc(cpu);
+		next = list->next;
+		prefetch(next);
+		list->func(list);
+		list = next;
 	}
-	raise_rcu_softirq();
+
+	/* step 3: if still entries left, raise the softirq again */
+	if (rcd->deadqlen)
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+static void rcu_process_callbacks(struct softirq_action *unused)
+{
+	rcu_do_batch(&get_cpu_var(rcu_cpudata_dead));
+	put_cpu_var(rcu_cpudata_dead);
 }
 
-static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
-						struct rcu_data *rdp)
+static void __rcu_add_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int cpu)
 {
-	long flags;
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	memset(rdp, 0, sizeof(*rdp));
-	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
-	rdp->donetail = &rdp->donelist;
-	rdp->quiescbatch = rcp->completed;
-	rdp->qs_pending = 0;
-	rdp->cpu = cpu;
-	rdp->blimit = blimit;
-	spin_unlock_irqrestore(&rcp->lock, flags);
+	rcs->state = rcu_cpumask_addcpu(&rgs->cpus, cpu);
+}
+
+#ifdef CONFIG_NO_HZ
+
+void rcu_enter_nohz(void)
+{
+	int cpu = smp_processor_id();
+	int *pmode;
+
+	/*
+	 * call_rcu() between rcu_needs_cpu and rcu_enter_nohz() are
+	 * not permitted.
+	 * Thus both must be called with disabled local interrupts,
+	 * without enabling the interrupts in between.
+	 *
+	 * Note: disabling interrupts only prevents call_rcu().
+	 * it can obviously happen that another cpu forwards
+	 * the state machine. That doesn't hurt: __rcu_remove_cpu()
+	 * the the work that we need to do.
+	 */
+	BUG_ON(!irqs_disabled());
+
+	pmode = &get_cpu_var(rcu_cpumode);
+	BUG_ON(*pmode != RCU_CPUMODE_DELAYED);
+	*pmode = 0;
+	put_cpu_var(rcu_cpumode);
+
+	__rcu_remove_cpu(&rcu_global_state_normal, &get_cpu_var(rcu_cpudata_normal), cpu);
+	put_cpu_var(rcu_cpudata_normal);
+	__rcu_remove_cpu(&rcu_global_state_bh, &get_cpu_var(rcu_cpudata_bh), cpu);
+	put_cpu_var(rcu_cpudata_bh);
+
+	BUG_ON(rcu_needs_cpu(cpu));
+printk(KERN_ERR" enter_nohz %d.\n", cpu);
+}
+
+void rcu_exit_nohz(void)
+{
+	int cpu = smp_processor_id();
+	int *pmode;
+
+	BUG_ON(!irqs_disabled());
+
+	pmode = &get_cpu_var(rcu_cpumode);
+	BUG_ON(*pmode != 0);
+	*pmode = RCU_CPUMODE_DELAYED;
+	put_cpu_var(rcu_cpumode);
+
+	__rcu_add_cpu(&rcu_global_state_normal, &get_cpu_var(rcu_cpudata_normal), cpu);
+	put_cpu_var(rcu_cpudata_normal);
+	__rcu_add_cpu(&rcu_global_state_bh, &get_cpu_var(rcu_cpudata_bh), cpu);
+	put_cpu_var(rcu_cpudata_bh);
+
+printk(KERN_ERR" exit_nohz %d.\n", cpu);
+}
+
+void rcu_irq_enter(void)
+{
+	int *pmode;
+
+	BUG_ON(!irqs_disabled());
+
+	pmode = &get_cpu_var(rcu_cpumode);
+	if (unlikely(*pmode != RCU_CPUMODE_DELAYED)) {
+printk(KERN_ERR" irq enter %d, %d.\n", smp_processor_id(), *pmode);
+		/* FIXME:
+		 * This code is not NMI safe. especially:
+		 * __rcu_add_cpu acquires spinlocks.
+		 */
+		if (*pmode == 0) {
+			int cpu = smp_processor_id();
+
+			__rcu_add_cpu(&rcu_global_state_normal,&get_cpu_var(rcu_cpudata_normal), cpu);
+			put_cpu_var(rcu_cpudata_normal);
+			__rcu_add_cpu(&rcu_global_state_bh,&get_cpu_var(rcu_cpudata_bh), cpu);
+			put_cpu_var(rcu_cpudata_bh);
+		}
+		(*pmode)++;
+	}
+	put_cpu_var(rcu_cpumode);
+}
+
+void rcu_irq_exit(void)
+{
+	int *pmode;
+
+	BUG_ON(!irqs_disabled());
+
+	pmode = &get_cpu_var(rcu_cpumode);
+	if (unlikely(*pmode != RCU_CPUMODE_DELAYED)) {
+
+printk(KERN_ERR" irq exit %d, %d.\n", smp_processor_id(), *pmode);
+		(*pmode)--;
+
+		if (*pmode == 0) {
+			int cpu = smp_processor_id();
+			/* FIXME:
+			 * This code is not NMI safe. especially:
+			 * __rcu_remove_cpu acquires spinlocks.
+			 */
+
+			/*
+			 * task 1: remove us from the list of cpus that might be inside critical
+			 * sections and inform the global state machine that we are outside
+			 * any read side critical sections.
+			 */
+			__rcu_remove_cpu(&rcu_global_state_normal,&per_cpu(rcu_cpudata_normal, cpu), cpu);
+			__rcu_remove_cpu(&rcu_global_state_bh,&per_cpu(rcu_cpudata_bh, cpu), cpu);
+
+			if (rcu_needs_cpu(cpu)) {
+				/*
+				 * task 2: Someone did a call_rcu() in the interupt.
+				 * Duh, we've lost. Force a reschedule, that leaves nohz mode.
+				 * FIXME: double check that this really works.
+				 *
+				 * Note: This can race: our call_rcu() might have set
+				 * start_immediately. But: that start might happen before
+				 * we readd ourself to the global cpu mask. Then we would
+				 * not take part in the global cycle - and we would not set
+				 * start_immediately again, either. The timeout would
+				 * ensure forward progress, thus it's not that bad.
+				 */
+	printk(KERN_ERR" irq exit %d - need resched .\n", cpu);
+				set_need_resched();
+			}
+		}
+	}
+}
+
+#endif /* CONFIG_NO_HZ */
+
+static void rcu_init_percpu_data(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int cpu)
+{
+	__rcu_add_cpu(rgs, rcs, cpu);
+
+	rcs->new = rcs->old = NULL;
+	rcs->newqlen = rcs->oldqlen = 0;
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
+	rcu_init_percpu_data(&rcu_global_state_normal, &per_cpu(rcu_cpudata_normal, cpu), cpu);
+	rcu_init_percpu_data(&rcu_global_state_bh, &per_cpu(rcu_cpudata_bh, cpu), cpu);
+
+	per_cpu(rcu_cpumode, cpu) = RCU_CPUMODE_DELAYED;
+
+	per_cpu(rcu_cpudata_dead, cpu).dead = NULL;
+	per_cpu(rcu_cpudata_dead, cpu).deadqlen = 0;
+	per_cpu(rcu_cpudata_dead, cpu).batchcount = RCU_BATCH_MIN;
 
-	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
-	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
@@ -743,6 +857,15 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		/*
+		 * During CPU_UP_PREPARE, the cpu is fully accounted for
+		 * and added into the rcu_cpumask. Thus it must be properly
+		 * removed if the CPU_UP failed.
+		 * Therefore CPU_UP_CANCELED is equivalent to CPU_DEAD.
+		 */
+		/* fall-through */
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		rcu_offline_cpu(cpu);
@@ -765,12 +888,12 @@ static struct notifier_block __cpuinitdata rcu_nb = {
  */
 void __init __rcu_init(void)
 {
+	rcu_cpumask_init(&rcu_global_state_normal.cpus, RCU_STATE_DESTROY, 0);
+	rcu_cpumask_init(&rcu_global_state_bh.cpus, RCU_STATE_DESTROY, 0);
 	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
 	/* Register notifier for non-boot CPUs */
 	register_cpu_notifier(&rcu_nb);
 }
 
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
diff --git a/kernel/rcucpumask.c b/kernel/rcucpumask.c
new file mode 100644
index 0000000..85ceb1e
--- /dev/null
+++ b/kernel/rcucpumask.c
@@ -0,0 +1,119 @@
+/*
+ * Scalable cpu mask for rcu.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
+ *
+ */
+#include <linux/rcucpumask.h>
+#include <linux/bug.h>
+
+#ifdef RCUCPUMASK_FLAT
+
+void rcu_cpumask_init(struct rcu_cpumask *rcm, int newstate, int setupcpus)
+{
+	BUG_ON(!irqs_disabled());
+
+	spin_lock(&rcm->lock);
+	rcm->state = newstate;
+
+	if (setupcpus) {
+		rcm->cpus_open = rcm->cpus_total;
+
+		bitmap_copy(cpus_addr(rcm->mask_cpu_open), cpus_addr(rcm->mask_cpu_total), NR_CPUS);
+	} else {
+		rcm->cpus_open = 0;
+		cpus_clear(rcm->mask_cpu_open);
+	}
+	spin_unlock(&rcm->lock);
+}
+
+int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu)
+{
+	int ret;
+
+	BUG_ON(!irqs_disabled());
+
+	spin_lock(&rcm->lock);
+
+	BUG_ON(!cpu_isset(cpu, rcm->mask_cpu_open));
+	cpu_clear(cpu, rcm->mask_cpu_open);
+
+	rcm->cpus_open--;
+if (rcm->cpus_open < 0) {
+	printk(KERN_ERR" rcm %p cpu %d state %d.\n", rcm, cpu, rcm->state);
+for(;;);
+}
+	ret = rcm->cpus_open;
+	if (ret == 0) {
+if (!cpus_empty(rcm->mask_cpu_open)) {
+	printk(KERN_ERR" rcm %p cpu %d state %d.\n", rcm, cpu, rcm->state);
+for(;;);
+}
+	}
+	
+	spin_unlock(&rcm->lock);
+
+	return !ret;
+}
+
+int rcu_cpumask_addcpu(struct rcu_cpumask *rcm, int cpu)
+{
+	int ret;
+	unsigned long flags;
+
+	/*
+	 * This function is called both during early bootup (irqs disabled)
+	 * and during "normal" CPU_UP notifiers (irqs enabled).
+	 */
+	spin_lock_irqsave(&rcm->lock, flags);
+
+	BUG_ON(cpu_isset(cpu, rcm->mask_cpu_total));
+	cpu_set(cpu, rcm->mask_cpu_total);
+
+	rcm->cpus_total++;
+	ret = rcm->state;
+	
+	spin_unlock_irqrestore(&rcm->lock, flags);
+
+	return ret;
+}
+
+int rcu_cpumask_removecpu(struct rcu_cpumask *rcm, int cpu)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rcm->lock, flags);
+
+	BUG_ON(!cpu_isset(cpu, rcm->mask_cpu_total));
+	cpu_clear(cpu, rcm->mask_cpu_total);
+
+	rcm->cpus_total--;
+	ret = rcm->state;
+	
+	spin_unlock_irqrestore(&rcm->lock, flags);
+
+	return ret;
+}
+
+#endif /* RCUCPUMASK_FLAT */
+
+#ifdef RCUCPUMASK_HIERARCHICAL
+
+bla
+
+#endif /* RCUCPUMASK_HIERARCHICAL */
-- 
1.5.5.1


--------------080306080101040507050301--
