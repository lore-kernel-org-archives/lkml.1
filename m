Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbYJLOZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbYJLOZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 10:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYJLOZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 10:25:36 -0400
Received: from sing.entic.net ([208.64.63.147]:57536 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbYJLOZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 10:25:32 -0400
Message-Id: <200810121425.m9CEPUxT029138@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Date: Sun, 12 Oct 2008 16:21:51 +0200
Subject: [PATCH] kernel/rcustate.c: state machine based rcu implementation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've updated the state machine based rcu code.
The main new point is a rewritten rcu_irq_exit() code, it should now
scale (no more write accesses to global memory).

Main points:
- As previously a state machine with system wide states: Either
  accumulate further call_rcu() callbacks, or collect the
  callbacks for the next grace period, or wait for a quiescent
  state.
  Rational:
  The rules for the state transistions are different for each state,
  thus a system wide state allows simpler transfer.
  e.g.: nohz cpus never have pending call_rcu() callbacks. Thus they
  can be skipped entirely for the "collect" stage.
  Right now there is no global state, thus every transistion must be
  treated as a grace period.
- Improved latency: There is only one for_each_cpu() loop per grace
  period, and even that loop is from schedule_work() with enabled
  local interrupts.
  Rational:
  for_each_cpu() loops with disabled local interrupts will cause
  latency problems.
- Experimental: it boots, nohz seems to works, cpu offline works.

What do you think?

The patch is against cdbb92b31d3c465aa96bd09f2d42c39b87b32bee plus the
CPU_STARTING patch I posted recently.

Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/hardirq.h    |   27 +-
 include/linux/rcuclassic.h |    2 -
 include/linux/rcucpumask.h |  150 ++++++
 include/linux/rcupdate.h   |   19 +-
 include/linux/rcupreempt.h |   14 -
 include/linux/rcustate.h   |  284 +++++++++++
 init/Kconfig               |   12 +-
 kernel/Makefile            |    1 +
 kernel/cpu.c               |    5 +-
 kernel/rcuclassic.c        |   18 +
 kernel/rcucpumask.c        |   93 ++++
 kernel/rcupreempt.c        |    6 +-
 kernel/rcustate.c          | 1136 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/softirq.c           |    2 +-
 14 files changed, 1733 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/rcucpumask.h
 create mode 100644 include/linux/rcustate.h
 create mode 100644 kernel/rcucpumask.c
 create mode 100644 kernel/rcustate.c

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 181006c..4c064a3 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,13 +118,13 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
-extern void rcu_irq_enter(void);
-extern void rcu_irq_exit(void);
+#ifdef CONFIG_NO_HZ
+extern void rcu_irq_enter(int in_nmi);
+extern void rcu_irq_exit(int in_nmi);
 #else
-# define rcu_irq_enter() do { } while (0)
-# define rcu_irq_exit() do { } while (0)
-#endif /* CONFIG_PREEMPT_RCU */
+# define rcu_irq_enter(in_nmi) do { } while (0)
+# define rcu_irq_exit(in_nmi) do { } while (0)
+#endif /* CONFIG_NO_HZ */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
@@ -132,14 +132,17 @@ extern void rcu_irq_exit(void);
  * always balanced, so the interrupted value of ->hardirq_context
  * will always be restored.
  */
-#define __irq_enter()					\
+#define ____irq_enter(in_nmi)				\
 	do {						\
-		rcu_irq_enter();			\
+		rcu_irq_enter(in_nmi);			\
 		account_system_vtime(current);		\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
 
+#define __irq_enter()	____irq_enter(0)
+#define __irq_exit()	____irq_exit(0)
+
 /*
  * Enter irq context (on NO_HZ, update jiffies):
  */
@@ -148,12 +151,12 @@ extern void irq_enter(void);
 /*
  * Exit irq context without processing softirqs:
  */
-#define __irq_exit()					\
+#define ____irq_exit(in_nmi)				\
 	do {						\
 		trace_hardirq_exit();			\
 		account_system_vtime(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
-		rcu_irq_exit();				\
+		rcu_irq_exit(in_nmi);			\
 	} while (0)
 
 /*
@@ -161,7 +164,7 @@ extern void irq_enter(void);
  */
 extern void irq_exit(void);
 
-#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
-#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
+#define nmi_enter()		do { lockdep_off(); ____irq_enter(1); } while (0)
+#define nmi_exit()		do { ____irq_exit(1); lockdep_on(); } while (0)
 
 #endif /* LINUX_HARDIRQ_H */
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5f89b62..9178f17 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -168,8 +168,6 @@ extern struct lockdep_map rcu_lock_map;
 
 #define __synchronize_sched() synchronize_rcu()
 
-#define call_rcu_sched(head, func) call_rcu(head, func)
-
 extern void __rcu_init(void);
 #define rcu_init_sched()	do { } while (0)
 extern void rcu_check_callbacks(int cpu, int user);
diff --git a/include/linux/rcucpumask.h b/include/linux/rcucpumask.h
new file mode 100644
index 0000000..43cacd4
--- /dev/null
+++ b/include/linux/rcucpumask.h
@@ -0,0 +1,150 @@
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
+	atomic_t cpus_open;
+
+	int state ____cacheline_internodealigned_in_smp;
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
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 86f1f5e..69c81e2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,7 +52,9 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
-#ifdef CONFIG_CLASSIC_RCU
+#ifdef CONFIG_STATE_RCU
+#include <linux/rcustate.h>
+#elif CONFIG_CLASSIC_RCU
 #include <linux/rcuclassic.h>
 #else /* #ifdef CONFIG_CLASSIC_RCU */
 #include <linux/rcupreempt.h>
@@ -263,6 +265,21 @@ extern void call_rcu(struct rcu_head *head,
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
 
+/**
+ * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual update function to be invoked after the grace period
+ *
+ * The update function will be invoked some time after a full
+ * synchronize_sched()-style grace period elapses, in other words after
+ * all currently executing preempt-disabled sections of code (including
+ * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
+ * completed.
+ */
+extern void call_rcu_sched(struct rcu_head *head,
+			   void (*func)(struct rcu_head *head));
+
+
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 3e05c09..bef8562 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -65,20 +65,6 @@ static inline void rcu_qsctr_inc(int cpu)
  */
 #define call_rcu_bh	 	call_rcu
 
-/**
- * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
- *
- * The update function will be invoked some time after a full
- * synchronize_sched()-style grace period elapses, in other words after
- * all currently executing preempt-disabled sections of code (including
- * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
- * completed.
- */
-extern void call_rcu_sched(struct rcu_head *head,
-			   void (*func)(struct rcu_head *head));
-
 extern void __rcu_read_lock(void)	__acquires(RCU);
 extern void __rcu_read_unlock(void)	__releases(RCU);
 extern int rcu_pending(int cpu);
diff --git a/include/linux/rcustate.h b/include/linux/rcustate.h
new file mode 100644
index 0000000..c8c4657
--- /dev/null
+++ b/include/linux/rcustate.h
@@ -0,0 +1,284 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (classic version)
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
+ * Copyright IBM Corporation, 2001
+ *
+ * Author: Dipankar Sarma <dipankar@in.ibm.com>
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ * Papers:
+ * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
+ * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ *
+ * Rewrite based on a global state machine
+ * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
+ */
+
+#ifndef __LINUX_RCUCLASSIC_H
+#define __LINUX_RCUCLASSIC_H
+
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
+#include <linux/percpu.h>
+#include <linux/cpumask.h>
+#include <linux/seqlock.h>
+#include <linux/rcucpumask.h>
+
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
+ */
+
+#define RCU_STATE_INVALID		0
+
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
+
+#define RCU_STATE_SHIFT			2
+
+struct rcu_global_state {
+	spinlock_t		lock;
+	int			start_immediately;
+	long			completed;
+	struct rcu_cpumask	cpus;
+
+	atomic_t poller_cpus;
+} ____cacheline_internodealigned_in_smp;
+
+/*
+ * Global state handling:
+ * - The global state is stored in rgs->cpus.state. This allows
+ *   an atomic update of the state and the outstanding cpus.
+ * - Only the low 2 bits of 'state' are the actual state, the upper bits are a
+ *   counter.
+ * - If the local state (rcs->state) is not equal to the global state, then
+ *   something needs to be done.
+ * - When in nohz mode, rcs->state contains the whole global state, including
+ *   the counter.
+ * - When in delayed mode, rcs->state contains only the low two bits.
+ * - When switching to nohz mode, rcs->state is initialized to
+ *   RCU_STATE_INVALID.
+ * - When switching to delayed mode, rcs->state is initialized by reading
+ *   from rgs->cpus.
+ */
+static inline int rcu_buildstate(int state, int count)
+{
+	return (count << RCU_STATE_SHIFT) + state;
+}
+
+static inline int rcu_getstate(int state)
+{
+	return ((1 << RCU_STATE_SHIFT)-1) & state;
+}
+
+static inline int rcu_getglobalstate(struct rcu_global_state *rgs)
+{
+	return rcu_getstate(rcu_cpumask_getstate(&rgs->cpus));
+}
+
+struct rcu_cpu_state {
+	int state;
+
+#ifdef CONFIG_NO_HZ
+	int kick_poller;
+#endif
+
+	/* new objects, directly from call_rcu().
+	 * The list are length-based, not NULL-terminated.
+	 */
+	struct rcu_head *new;	/* new objects */
+	struct rcu_head **newtail;
+	long            newqlen; 	 /* # of queued callbacks */
+
+	unsigned long	timeout;
+
+	/* objects that are in rcu grace processing. The actual
+	* state depends on rcu_cpumask_getstate(&rgs->cpus);
+	 */
+	struct rcu_head *old;
+	struct rcu_head **oldtail;
+	long            oldqlen;
+
+	/*
+	 * quiescent state looking:
+	 * When the cpu sees RCU_STATE_DESTROY_AND_COLLECT, it clears looking.
+	 * When the cpu sees RCU_STATE_GRACE, it sets looking and clears
+	 * quiet.
+	 * If looking and quiet are both set, then there was a grace period,
+	 * even if the state machine is called from non-idle context.
+	 */
+	int quiet;
+	int looking;
+};
+
+/* Note: only one structure for _bh and _normal. */
+struct rcu_cpu_dead {
+	/*
+	 * objects that are scheduled for immediate call of
+	 * ->func().
+	 */
+	struct rcu_head *dead;
+	struct rcu_head **deadtail;
+	long		deadqlen;
+
+	long		batchcount;
+};
+
+/*
+ * rcu_cpumode:
+ * RCU_CPUMODE_DELAYED:
+ * "normal" rcu behavior: the scheduler and the timer interrupt
+ * check for grace periods, read side critical sections are permitted
+ * everywhere.
+ *
+ * RCU_CPUMODE_NOHZ:
+ * This cpu is sitting in the idle thread, with disabled hz timer.
+ * These cpus are polled. NOHZ cpus must:
+ * - add themselv to the rcu_nohz_mask on irq and nmi entry.
+ *   rcu_nohz_mask is read in each interrupt on a nohz cpu, thus test and
+ *   set must be used.
+ * - increase total_count on {irq,nmi} entry. The poller uses that information
+ *   to decide if a cpu is so offline that it can be removed from
+ *   rcu_nohz_mask. (Positive effect: The cpu will be skipped when checking
+ *   for grace periods - possibly for a long time. Negative effect:
+ *   The next irq will trash the cache-line of rcu_nohz_mask)
+ * - increase in_{irq,nmi}_count on {irq,nmi} entry, decrease it on {irq,nmi}
+ *   exit
+ * - if both in_{nmi,irq}_count are 0 on {irq,nmi} {entry,exit}, then do for
+ *   	_normal and_bh:
+ *	- set the per-cpu state to the global state.
+ *	- only for irq exit:
+ *		- if kick_poller is set, then kick the poll task.
+ * - decrementing in_irq_count and to kick_poller are protected by poller_lock.
+ * - cpu_mode is only updated by the current cpu
+ */
+
+#define RCU_CPUMODE_INVALID	0
+#define RCU_CPUMODE_DELAYED	1
+#define RCU_CPUMODE_NOHZ	2
+
+struct rcu_percpu_data {
+	int cpu_mode;
+
+#ifdef CONFIG_NO_HZ
+	atomic_t total_count;
+
+	int in_nmi_count;
+	int in_irq_count;
+	spinlock_t	poller_lock;
+#endif
+
+	struct rcu_cpu_state state_normal;
+	struct rcu_cpu_state state_bh;
+	struct rcu_cpu_dead data_dead;
+};
+
+DECLARE_PER_CPU(struct rcu_percpu_data, rcu_percpu);
+
+extern long rcu_batches_completed(void);
+extern long rcu_batches_completed_bh(void);
+
+extern int rcu_pending(int cpu);
+extern int rcu_needs_cpu(int cpu);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern struct lockdep_map rcu_lock_map;
+# define rcu_read_acquire()	\
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+#else
+# define rcu_read_acquire()	do { } while (0)
+# define rcu_read_release()	do { } while (0)
+#endif
+
+#define __rcu_read_lock() \
+	do { \
+		preempt_disable(); \
+		__acquire(RCU); \
+		rcu_read_acquire(); \
+	} while (0)
+#define __rcu_read_unlock() \
+	do { \
+		rcu_read_release(); \
+		__release(RCU); \
+		preempt_enable(); \
+	} while (0)
+#define __rcu_read_lock_bh() \
+	do { \
+		local_bh_disable(); \
+		__acquire(RCU_BH); \
+		rcu_read_acquire(); \
+	} while (0)
+#define __rcu_read_unlock_bh() \
+	do { \
+		rcu_read_release(); \
+		__release(RCU_BH); \
+		local_bh_enable(); \
+	} while (0)
+
+extern void __rcu_init(void);
+#define rcu_init_sched()	do { } while (0)
+
+extern void __synchronize_sched(void);
+extern void rcu_check_callbacks(int cpu, int user);
+
+#ifdef CONFIG_NO_HZ
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+#else /* CONFIG_NO_HZ */
+#define rcu_enter_nohz()	do { } while (0)
+#define rcu_exit_nohz()		do { } while (0)
+#endif /* CONFIG_NO_HZ */
+
+static inline void rcu_qsctr_inc(int cpu)
+{
+	per_cpu(rcu_percpu, cpu).state_normal.quiet = 1;
+	per_cpu(rcu_percpu, cpu).state_bh.quiet = 1;
+}
+
+static inline void rcu_bh_qsctr_inc(int cpu)
+{
+	per_cpu(rcu_percpu, cpu).state_bh.quiet = 1;
+}
+
+#endif /* __LINUX_RCUCLASSIC_H */
diff --git a/init/Kconfig b/init/Kconfig
index c11da38..88286ba 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -903,10 +903,20 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
+config STATE_RCU
+	bool
+	default y
+	help
+	  This option selects a state machine based RCU implementation.
+	  It's a replacement for the "classic" rcu implementation that
+	  aims simpler code and better scalability.
+	  If unsure, say N. 
+
 config CLASSIC_RCU
-	def_bool !PREEMPT_RCU
+	def_bool !PREEMPT_RCU && !STATE_RCU
 	help
 	  This option selects the classic RCU implementation that is
 	  designed for best read-side performance on non-realtime
 	  systems.  Classic RCU is the default.  Note that the
 	  PREEMPT_RCU symbol is used to select/deselect this option.
+
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..6bc9503 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
+obj-$(CONFIG_STATE_RCU) += rcustate.o rcucpumask.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 46a8bbd..2c6bc29 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -199,13 +199,14 @@ static int __ref take_cpu_down(void *_param)
 	struct take_cpu_down_param *param = _param;
 	int err;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
-				param->hcpu);
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
 		return err;
 
+	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
+				param->hcpu);
+
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 37f72e5..e14e6b2 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -296,6 +296,13 @@ void call_rcu_bh(struct rcu_head *head,
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
+void call_rcu_sched(struct rcu_head *head,
+				void (*func)(struct rcu_head *rcu))
+{
+	call_rcu(head, func);
+}
+EXPORT_SYMBOL_GPL(call_rcu_sched);
+
 /*
  * Return the number of RCU batches processed thus far.  Useful
  * for debug and statistics.
@@ -764,6 +771,17 @@ static struct notifier_block __cpuinitdata rcu_nb = {
 	.notifier_call	= rcu_cpu_notify,
 };
 
+#ifdef CONFIG_NO_HZ
+
+void rcu_irq_enter(int in_nmi)
+{
+}
+
+void rcu_irq_exit(int in_nmi)
+{
+}
+#endif
+
 /*
  * Initializes rcu mechanism.  Assumed to be called early.
  * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
diff --git a/kernel/rcucpumask.c b/kernel/rcucpumask.c
new file mode 100644
index 0000000..436862c
--- /dev/null
+++ b/kernel/rcucpumask.c
@@ -0,0 +1,93 @@
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
+
+	rcm->state = newstate;
+	atomic_set(&rcm->cpus_open, setupcpus ? rcm->cpus_total : 0);
+
+	spin_unlock(&rcm->lock);
+}
+
+int rcu_cpumask_clear_and_test(struct rcu_cpumask *rcm, int cpu)
+{
+	int ret;
+
+	BUG_ON(atomic_read(&rcm->cpus_open) <= 0);
+	/* 
+	 * atomic_dec_and_test() implies a memory barrier, thus no mb()
+	 * required. 
+	 * ret 1: value now 0
+	 */
+	ret = atomic_dec_and_test(&rcm->cpus_open);
+
+	return ret;
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
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ca4bbbe..ab18347 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -434,13 +434,13 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
 static DEFINE_PER_CPU(int, rcu_update_flag);
 
 /**
- * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
+ * __rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
  *
  * If the CPU was idle with dynamic ticks active, this updates the
  * rcu_dyntick_sched.dynticks to let the RCU handling know that the
  * CPU is active.
  */
-void rcu_irq_enter(void)
+void __rcu_irq_enter(int in_nmi)
 {
 	int cpu = smp_processor_id();
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
@@ -510,7 +510,7 @@ void rcu_irq_enter(void)
  * rcu_dyntick_sched.dynticks to put let the RCU handling be
  * aware that the CPU is going back to idle with no ticks.
  */
-void rcu_irq_exit(void)
+void __rcu_irq_exit(int in_nmi)
 {
 	int cpu = smp_processor_id();
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
diff --git a/kernel/rcustate.c b/kernel/rcustate.c
new file mode 100644
index 0000000..deb1d1e
--- /dev/null
+++ b/kernel/rcustate.c
@@ -0,0 +1,1136 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion
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
+ * Copyright IBM Corporation, 2001
+ *
+ * Authors: Dipankar Sarma <dipankar@in.ibm.com>
+ *	    Manfred Spraul <manfred@colorfullife.com>
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ * Papers:
+ * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
+ * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ *
+ * Rewrite based on a global state machine
+ * (C) Manfred Spraul <manfred@colorfullife.com>, 2008
+ *
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/time.h>
+
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key rcu_lock_key;
+struct lockdep_map rcu_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
+EXPORT_SYMBOL_GPL(rcu_lock_map);
+#endif
+
+/* Definition for rcupdate control block. */
+static struct rcu_global_state rcu_global_state_normal = {
+	.lock = __SPIN_LOCK_UNLOCKED(&rcu_global_state_normal.lock),
+	.start_immediately = 0,
+	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_normal.cpus)
+};
+
+static struct rcu_global_state rcu_global_state_bh = {
+	.lock = __SPIN_LOCK_UNLOCKED(&rcu_global_state_bh.lock),
+	.start_immediately = 0,
+	.cpus = __RCU_CPUMASK_INIT(&rcu_global_state_bh.cpus)
+};
+
+DEFINE_PER_CPU(struct rcu_percpu_data, rcu_percpu);
+
+cpumask_t rcu_nohz_mask;
+
+int qlowmark = 100;
+
+#define RCU_IRQ_INIT	8
+#define RCU_IRQ_MAX	128
+#define RCU_IRQ_DOWN	2
+
+#define RCU_STRUCT_NORMAL	1
+#define RCU_STRUCT_BH		2
+
+static inline struct rcu_cpu_state *rcu_get_rcs(int rcu_struct, int cpu)
+{
+	switch (rcu_struct) {
+	case RCU_STRUCT_NORMAL:
+		return &per_cpu(rcu_percpu, cpu).state_normal;
+	case RCU_STRUCT_BH:
+		return &per_cpu(rcu_percpu, cpu).state_bh;
+	}
+	BUG();
+}
+
+static inline struct rcu_global_state *rcu_get_rgs(int rcu_struct)
+{
+	switch (rcu_struct) {
+	case RCU_STRUCT_NORMAL:
+		return &rcu_global_state_normal;
+	case RCU_STRUCT_BH:
+		return &rcu_global_state_bh;
+	}
+	BUG();
+}
+
+
+long rcu_batches_completed(void)
+{
+	return rcu_global_state_normal.completed;
+}
+
+long rcu_batches_completed_bh(void)
+{
+	return rcu_global_state_normal.completed;
+}
+
+static void rcu_state_init(struct rcu_global_state *rgs, int state)
+{
+	int init_cpus;
+
+	if (state == RCU_STATE_DESTROY)
+		init_cpus = 0;
+	else
+		init_cpus = 1;
+	rcu_cpumask_init(&rgs->cpus, rcu_buildstate(state, rgs->completed), init_cpus);	
+}
+
+/**
+ * rcu_state_startcycle - start the next rcu cycle
+ * @rgs: global rcu state
+ *
+ * The function starts the next rcu cycle, either immediately or
+ * by setting rgs->start_immediately.
+ * Local interrupts are disabled, the current cpu is tracked
+ * (either due to RCU_CPUMODE_DELAYED or because it's listed in
+ * rcu_nohz_mask or because it's listed in poller_cpus).
+ * Thus it's impossible that start_immediately goes to 0 and
+ * the entries listed in rcs->new are not included in the
+ * grace period.
+ */
+static void rcu_state_startcycle(struct rcu_global_state *rgs)
+{
+	BUG_ON(!irqs_disabled());
+
+	if (rgs->start_immediately == 0) {
+		spin_lock(&rgs->lock);
+		switch(rcu_getglobalstate(rgs)) {
+		case RCU_STATE_DESTROY_AND_COLLECT:
+		case RCU_STATE_GRACE:
+			rgs->start_immediately = 1;
+			break;
+		case RCU_STATE_DESTROY:
+			rcu_state_init(rgs, RCU_STATE_DESTROY_AND_COLLECT);
+			BUG_ON(rgs->start_immediately);
+			break;
+		default:
+			BUG();
+		}
+		spin_unlock(&rgs->lock);
+	}
+}
+
+/*
+ * Delay that can occur for synchronize_rcu() callers
+ */
+#define RCU_MAX_DELAY	(HZ/30+1)
+
+static void rcu_checkqlen(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int inc)
+{
+	BUG_ON(!irqs_disabled());
+	if (unlikely(rcs->newqlen == 0)) {
+		rcs->timeout = jiffies + RCU_MAX_DELAY;
+	}
+	if ((rcs->newqlen < qlowmark) && (rcs->newqlen+inc >= qlowmark))
+		rcu_state_startcycle(rgs);
+
+	rcs->newqlen += inc;
+
+	/*
+	 * This is not really a bug, it might happen when interrupt calls
+	 * call_rcu() while the cpu is in nohz mode. see rcu_irq_exit
+	 */
+	WARN_ON( (rcs->newqlen >= qlowmark) && (rcu_getglobalstate(rgs) == RCU_STATE_DESTROY));
+}
+
+
+static void __call_rcu(struct rcu_head *head, struct rcu_global_state *rgs,
+		struct rcu_cpu_state *rcs)
+{
+	if (rcs->new == NULL) {
+		rcs->new = head;
+	} else {
+		(*rcs->newtail) = head;
+	}
+	rcs->newtail = &head->next;
+
+	rcu_checkqlen(rgs, rcs, 1);
+}
+
+void call_rcu_sched(struct rcu_head *head,
+				void (*func)(struct rcu_head *rcu))
+{
+	call_rcu(head, func);
+}
+
+EXPORT_SYMBOL_GPL(call_rcu_sched);
+
+/*
+ * Wait until all currently running preempt_disable() code segments
+ * (including hardware-irq-disable segments) complete.  Note that
+ * in -rt this does -not- necessarily result in all currently executing
+ * interrupt -handlers- having completed.
+ */
+synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
+EXPORT_SYMBOL_GPL(__synchronize_sched);
+
+
+void call_rcu(struct rcu_head *head,
+				void (*func)(struct rcu_head *rcu))
+{
+	unsigned long flags;
+
+	head->func = func;
+	local_irq_save(flags);
+	__call_rcu(head, &rcu_global_state_normal, &__get_cpu_var(rcu_percpu).state_normal);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+void call_rcu_bh(struct rcu_head *head,
+				void (*func)(struct rcu_head *rcu))
+{
+	unsigned long flags;
+
+	head->func = func;
+	local_irq_save(flags);
+	__call_rcu(head, &rcu_global_state_bh, &__get_cpu_var(rcu_percpu).state_bh);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+#define RCU_BATCH_MIN		100
+#define	RCU_BATCH_INCFACTOR	2
+#define RCU_BATCH_DECFACTOR	4
+
+static void rcu_move_and_raise(struct rcu_cpu_state *rcs, int do_raise)
+{
+	struct rcu_cpu_dead *rcd;
+
+	BUG_ON(!irqs_disabled());
+	rcd = &__get_cpu_var(rcu_percpu).data_dead;
+
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
+	}
+
+	rcs->old = NULL;
+	rcs->oldtail = NULL;
+	rcs->oldqlen = 0;
+
+	if (do_raise)
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+static void rcu_advance_state(struct rcu_global_state *rgs)
+{
+	BUG_ON(!irqs_disabled());
+	spin_lock(&rgs->lock);
+
+	/*
+	 * advance the state machine:
+	 * - from COLLECT to GRACE
+	 * - from GRACE to DESTROY/COLLECT
+	 */
+	switch(rcu_getglobalstate(rgs)) {
+	case RCU_STATE_DESTROY_AND_COLLECT:
+		rcu_state_init(rgs, RCU_STATE_GRACE);
+		break;
+	case RCU_STATE_GRACE:
+		rgs->completed++;
+		if (rgs->start_immediately) {
+			rcu_state_init(rgs, RCU_STATE_DESTROY_AND_COLLECT);
+		} else {
+			rcu_state_init(rgs, RCU_STATE_DESTROY);
+		}
+		rgs->start_immediately = 0;
+		break;
+	default:
+		BUG();
+	}
+	spin_unlock(&rgs->lock);
+}
+
+static void __rcu_kick_poller(struct rcu_percpu_data *rps, struct rcu_global_state *rgs)
+{
+	if (rps->state_normal.kick_poller) {
+		rps->state_normal.kick_poller = 0;
+		if (atomic_dec_and_test(&rgs->poller_cpus))
+			rcu_advance_state(rgs);
+	}
+}
+static void rcu_kick_poller(struct rcu_percpu_data *rps)
+{
+	BUG_ON(!irqs_disabled());
+	BUG_ON(!spin_is_locked(&rps->poller_lock));
+
+	__rcu_kick_poller(rps, &rcu_global_state_normal);
+	__rcu_kick_poller(rps, &rcu_global_state_bh);
+}
+
+
+/**
+ * rcu_update_irqstate(cpu)
+ * @cpu: cpu to update
+ *
+ * cpu is a nohz cpu. This function decides if the cpu should be polled
+ * or if if it should be removed entirely from the grace period handling.
+ * Cpus that are removed entirely cannot take interrupts, they must
+ * add themselves back into rcu_nohz_mask() on irq/nmi entry.
+ */
+static void rcu_update_irqstate(int cpu)
+{
+	int rem;
+	struct rcu_percpu_data *rps;
+
+	rps = &per_cpu(rcu_percpu, cpu);
+
+	BUG_ON(!spin_is_locked(&rps->poller_lock));
+	BUG_ON(rps->cpu_mode != RCU_CPUMODE_NOHZ);
+
+	rem = atomic_read(&rps->total_count);
+	if (rem > RCU_IRQ_MAX)
+		rem = rem - RCU_IRQ_MAX;
+	else
+		rem = (rem + RCU_IRQ_DOWN - 1) / RCU_IRQ_DOWN;
+	atomic_sub(rem, &rps->total_count);
+
+	if (atomic_read(&rps->total_count) == 0) {
+		cpu_clear(cpu, rcu_nohz_mask);
+	}
+}
+
+static void rcu_do_poll(struct work_struct *reason);
+
+static DECLARE_WORK(rcu_work_normal, rcu_do_poll);
+static DECLARE_WORK(rcu_work_bh, rcu_do_poll);
+
+static void rcu_do_poll(struct work_struct *reason)
+{
+	struct rcu_global_state *rgs;
+	int rcu_struct, cpu, global_state;
+
+	if (reason == &rcu_work_normal) {
+		rcu_struct = RCU_STRUCT_NORMAL;
+	} else if (reason == &rcu_work_bh) {
+		rcu_struct = RCU_STRUCT_BH;
+	} else {
+		BUG();
+	}
+	rgs = rcu_get_rgs(rcu_struct);
+
+	atomic_set(&rgs->poller_cpus, 1);
+	global_state = rcu_cpumask_getstate(&rgs->cpus);
+
+	for_each_cpu_mask(cpu, rcu_nohz_mask) {
+		struct rcu_percpu_data *rps;
+		struct rcu_cpu_state *rcs;
+
+		rps = &per_cpu(rcu_percpu, cpu);
+		rcs = rcu_get_rcs(rcu_struct, cpu);
+
+		if (rcs->state == global_state)
+			continue;
+
+		BUG_ON(irqs_disabled());
+		spin_lock_irq(&rps->poller_lock);
+		if (rps->cpu_mode != RCU_CPUMODE_NOHZ)
+			goto continue_unlock;
+		if (rcs->state == global_state)
+			goto continue_unlock;
+		if (rps->in_irq_count) {
+			/*
+			 * Ok, we have lost:
+			 * - The cpu is in nohz mode
+			 * - The cpu did not complete a single irq since the
+			 *   global state was modified to RCU_STATE_GRACE.
+			 * - The cpu is inside an irq.
+			 * That means the cpu could be inside a rcu read side
+			 * critical section. Request that the cpu should kick
+			 * the rcu subsystem on irq exit and continue.
+			 */
+			atomic_inc(&rgs->poller_cpus);
+			rcs->kick_poller = 1;
+		} else {
+			/* Even worse: The cpu is in an NMI.
+			 * NMIs can't kick the rcu subsystem, thus we must
+			 * wait until the NMI exits. Note that this is
+			 * exceptionally rare, it can only happen if an NMI
+			 * doesn't exit for multiple jiffies.
+			 */
+			while (rps->in_nmi_count) {
+				cpu_relax();
+			}
+			rcs->state = global_state;
+		}
+		rcu_update_irqstate(cpu);
+continue_unlock:
+		spin_unlock_irq(&rps->poller_lock);
+	}
+	if (atomic_dec_and_test(&rgs->poller_cpus)) {
+		local_irq_disable();
+		rcu_advance_state(rgs);
+		local_irq_enable();
+	}
+}
+
+/**
+ * rcu_state_delayedcpus_done(rgs)
+ * @rgs: rcu global state
+ *
+ * 2nd part of the rcu grace period processing: all RCU_CPUMODE_DELAYED cpus
+ * completed. For RCU_STATE_GRACE (and only for this state), the
+ * RCU_CPUMODE_NOHZ cpus must be scanned as well.
+ * No need for any locking: the last RCU_CPUMODE_DELAYED cpu calls this
+ * function. "Last" is ensured by atomic_dec_and_test(), thus concurrent calls
+ * are impossible.
+ */
+static void rcu_state_delayedcpus_done(struct rcu_global_state *rgs, int rcu_struct)
+{
+	if (rcu_getglobalstate(rgs) != RCU_STATE_GRACE) {
+		rcu_advance_state(rgs);
+		return;
+	}
+	switch (rcu_struct) {
+	case RCU_STRUCT_NORMAL:
+		schedule_work(&rcu_work_normal);
+		break;
+	case RCU_STRUCT_BH:
+		schedule_work(&rcu_work_bh);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void __rcu_state_machine(int rcu_struct, int global_state, int is_quiet, int do_raise, int cpu)
+{
+	int inc_state;
+	struct rcu_global_state *rgs;
+	struct rcu_cpu_state *rcs;
+
+	BUG_ON(!irqs_disabled());
+
+	rgs = rcu_get_rgs(rcu_struct);
+	rcs = rcu_get_rcs(rcu_struct, cpu);
+	/*
+	 * Theoretically, this code should run under spin_lock(&rgs->lock),
+	 * But: important chages (i.e. from COLLECT to GRACE,
+	 * from GRACE to DESTROY) only happen when all cpus have completed
+	 * their work. If rcu_getglobalstate(rgs) != rcs->state, then we haven't completed
+	 * our work yet. Thus such a change cannot happen.
+	 * The only change that might happen is a change from RCU_STATE_DESTROY
+	 * to RCU_STATE_DESTROY_AND_COLLECT. We'll notice that in the next
+	 * round.
+	 * no need for an mb() either - it simply doesn't matter.
+	 * Actually: when rcu_state_startcycle() is called, then it's guaranteed
+	 * that global_state and rcu_getglobalstate(rgs) do not match...
+	 */
+	if (global_state == RCU_STATE_DESTROY && rcs->newqlen > 0 &&
+		time_after(jiffies, rcs->timeout) && do_raise) {
+		rcu_state_startcycle(rgs);
+	}
+
+	if (global_state == rcs->state)
+		return;
+
+	inc_state = 0;
+	switch(global_state) {
+	case RCU_STATE_DESTROY:
+		/* enforce the state machine:
+		 * DESTROY is only possible after GRACE
+		 */
+		BUG_ON(rcs->state != RCU_STATE_GRACE);
+		rcs->state = RCU_STATE_DESTROY;
+		rcu_move_and_raise(rcs, do_raise);
+		break;
+	case RCU_STATE_DESTROY_AND_COLLECT:
+		BUG_ON( (rcs->state != RCU_STATE_DESTROY) && (rcs->state != RCU_STATE_GRACE) );
+		rcs->state = RCU_STATE_DESTROY_AND_COLLECT;
+		rcu_move_and_raise(rcs, do_raise);
+		rcs->old = rcs->new;
+		rcs->oldtail = rcs->newtail;
+		rcs->oldqlen = rcs->newqlen;
+		rcs->new = NULL;
+		rcs->newtail = NULL;
+		rcs->newqlen = 0;
+		rcs->looking = 0;
+		if (rcu_cpumask_clear_and_test(&rgs->cpus, cpu))
+			inc_state = 1;
+		break;
+	case RCU_STATE_GRACE:
+		BUG_ON(rcs->state != RCU_STATE_DESTROY_AND_COLLECT);
+		if (is_quiet || (rcs->quiet && rcs->looking)) {
+			rcs->state = RCU_STATE_GRACE;
+			if (rcu_cpumask_clear_and_test(&rgs->cpus, cpu))
+				inc_state = 1;
+		}
+		rcs->quiet = 0;
+		rcs->looking = 1;
+		break;
+	default:
+		BUG();
+	}
+	if (unlikely(inc_state)) {
+		BUG_ON(rcu_getglobalstate(rgs) != rcs->state);
+		BUG_ON(rcu_getglobalstate(rgs) != global_state);
+
+		rcu_state_delayedcpus_done(rgs, rcu_struct);
+	}
+}
+
+static void rcu_state_machine(int rcu_struct, int is_quiet, int cpu)
+{
+	int global_state;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	global_state  = rcu_getglobalstate(rcu_get_rgs(rcu_struct));
+
+	/* gcc should not optimize away the local variable global_state... */
+	barrier();
+	__rcu_state_machine(rcu_struct, global_state, is_quiet, 1, cpu);
+	local_irq_restore(flags);
+}
+
+#if defined(CONFIG_HOTPLUG_CPU) || defined (CONFIG_NO_HZ)
+
+static void __rcu_remove_cpu(int rcu_struct, int cpu)
+{
+	int global_state;
+	struct rcu_global_state *rgs;
+
+	BUG_ON(!irqs_disabled());
+
+	rgs = rcu_get_rgs(rcu_struct);
+
+	/*
+	 * Figure out what this cpu is still supposed to do.
+	 * We rely on the lock inside the rcu_cpumask, that guarantees that
+	 * we neither do too much nor too little.
+	 * But do not raise the softirq, the caller is responsible handling
+	 * the entries still in the queues.
+	 */
+	global_state = rcu_cpumask_removecpu(&rgs->cpus, cpu);
+	global_state = rcu_getstate(global_state);
+
+	/*
+	 * ensure that we are not in the middle of updating
+	 * rcu_getglobalstate(&rgs->cpus): otherwise __rcu_state_machine()
+	 * would return with "nothing to do", although
+	 * the cpu must do something.
+	 */
+	spin_unlock_wait(&rgs->lock);
+
+	__rcu_state_machine(rcu_struct, global_state, 1, 0, cpu);
+	rcu_get_rcs(rcu_struct, cpu)->state = RCU_STATE_INVALID;
+}
+
+#endif
+
+#ifdef CONFIG_HOTPLUG_CPU
+/**
+ * rcu_bulk_add - bulk add new rcu objects.
+ * @rgs: global rcu state
+ * @rcs: cpu state
+ * @h: linked list of rcu objects.
+ *
+ * Must be called with enabled local interrupts
+ */
+static void rcu_bulk_add(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, struct rcu_head *h, struct rcu_head **htail, int len)
+{
+
+	BUG_ON(!irqs_disabled());
+
+	if (len > 0) {
+		if (rcs->new == NULL) {
+			rcs->new = h;
+		} else {
+			(*rcs->newtail) = h;
+		}
+		rcs->newtail = htail;
+
+		rcu_checkqlen(rgs, rcs, len);
+	}
+}
+
+static void __rcu_offline_cpu(int rcu_struct, struct rcu_cpu_state *target_rcs)
+{
+	int cpu = smp_processor_id();
+	struct rcu_global_state *rgs;
+	struct rcu_cpu_state *dying_rcs;
+
+	rgs = rcu_get_rgs(rcu_struct);
+	dying_rcs = rcu_get_rcs(rcu_struct, cpu);
+
+	/*
+	 * task 1: Do the work that the other cpu is still supposed to do.
+	 * offlining a nohz cpu is special, then nothing needs to be done:
+	 * everything was done by the last irq_exit().
+	 */
+	BUG_ON(!irqs_disabled());
+	if (per_cpu(rcu_percpu, cpu).cpu_mode == RCU_CPUMODE_DELAYED) {
+		__rcu_remove_cpu(rcu_struct, cpu);
+	}
+
+	/* task 2: move all entries from the new cpu into the lists of the current cpu.
+	 * locking: The other cpu is in stop_machine, thus no locks are required.
+	 *  Thus it's more or less a bulk call_rcu().
+	 * For the sake of simplicity, all objects are treated as "new", even the objects
+	 * that are already in old.
+	 */
+	rcu_bulk_add(rgs, target_rcs, dying_rcs->new, dying_rcs->newtail, dying_rcs->newqlen);
+	dying_rcs->new = NULL;
+	dying_rcs->newtail = NULL;
+	dying_rcs->newqlen = 0;
+	rcu_bulk_add(rgs, target_rcs, dying_rcs->old, dying_rcs->oldtail, dying_rcs->oldqlen);
+	dying_rcs->old = NULL;
+	dying_rcs->oldtail = NULL;
+	dying_rcs->oldqlen = 0;
+}
+
+/**
+ * rcu_offline_cpu(cpu): Offline a cpu
+ * @cpu: cpu to offline.
+ *
+ * The function does all work required to offline @cpu. It's called from
+ * stop_machine(). It moves the work that is still pending to a cpu that
+ * is online.
+ */
+static void rcu_offline_cpu(int cpu)
+{
+	int surviving_cpu;
+	struct rcu_percpu_data *surviving_rps;
+	struct rcu_cpu_dead *dying_rcd;
+
+	BUG_ON(!irqs_disabled());
+	BUG_ON(cpu != smp_processor_id());
+
+	/* stop 1: find a victim cpu that will inherit the outstanding
+	 * work.
+	 */
+	surviving_cpu = cpu+1;
+	do {
+		if (cpu_online(surviving_cpu))
+			break;
+		surviving_cpu++;
+		if (surviving_cpu == NR_CPUS)
+			surviving_cpu = 0;
+		BUG_ON(surviving_cpu == cpu);
+	} while (1);
+	surviving_rps = &per_cpu(rcu_percpu, surviving_cpu);
+
+	/* step 2: move new & old lists, clear cpu bitmask */
+
+	__rcu_offline_cpu(RCU_STRUCT_NORMAL, &surviving_rps->state_normal);
+	__rcu_offline_cpu(RCU_STRUCT_BH, &surviving_rps->state_bh);
+
+	/* step 3: move dead list */
+
+	dying_rcd = &__get_cpu_var(rcu_percpu).data_dead;
+	if (dying_rcd->dead != NULL) {
+		if (surviving_rps->data_dead.dead == NULL) {
+			surviving_rps->data_dead.dead = dying_rcd->dead;
+		} else {
+			(*surviving_rps->data_dead.deadtail) = dying_rcd->dead;
+		}
+		surviving_rps->data_dead.deadtail = dying_rcd->deadtail;
+		surviving_rps->data_dead.deadqlen += dying_rcd->deadqlen;
+		dying_rcd->dead = NULL;
+		dying_rcd->deadtail = NULL;
+		dying_rcd->deadqlen = 0;
+		local_irq_enable();
+	}
+
+	/* step 4: mark the cpu as invalid */
+	__get_cpu_var(rcu_percpu).cpu_mode = RCU_CPUMODE_INVALID;
+	cpu_clear(cpu, rcu_nohz_mask);
+
+	BUG_ON(rcu_needs_cpu(cpu));
+}
+
+#else
+
+static void rcu_offline_cpu(int cpu)
+{
+}
+
+#endif
+
+static int __rcu_pending(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs)
+{
+	/*
+	 * This cpu must do something for the state machine.
+	 */
+	if (rcu_getglobalstate(rgs) != rcs->state)
+		return 1;
+	/*
+	 * The state machine is stopped and the current
+	 * cpu has outstanding rcu callbacks
+	 */
+	if (rcs->state == RCU_STATE_DESTROY && rcs->newqlen)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * void rcu_pending(int cpu) - check for pending rcu related work.
+ * @cpu: cpu to check.
+ *
+ * Check to see if there is any immediate RCU-related work to be done
+ * by the current CPU, returning 1 if so.  This function is part of the
+ * RCU implementation; it is -not- an exported member of the RCU API.
+ *
+ * This function is inherently racy: If it returns 1, then there is something
+ * to do. If it return 0, then there was nothing to do. It's possible that
+ * by the time rcu_pending returns, there is now something to do.
+ *
+ */
+int rcu_pending(int cpu)
+{
+	struct rcu_percpu_data *rps;
+
+	rps = &per_cpu(rcu_percpu, cpu);
+
+	return __rcu_pending(&rcu_global_state_normal, &rps->state_normal) ||
+		__rcu_pending(&rcu_global_state_bh, &rps->state_bh);
+}
+
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
+ * Check to see if any future RCU-related work will need to be done
+ * by @cpu, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ *
+ * Locking only works properly if the function is called for the current
+ * cpu and with disabled local interupts. It's a prerequisite for
+ * rcu_nohz_enter() that rcu_needs_cpu() return 0. Local interupts must not
+ * be enabled in between, otherwise a softirq could call call_rcu().
+ *
+ * Note: rcu_needs_cpu() can be 0 (cpu not needed) even though rcu_pending()
+ * returns 1. This means that the outstanding work can be completed by either
+ * the CPU_DEAD callback or rcu_enter_nohz().
+ */
+int rcu_needs_cpu(int cpu)
+{
+	struct rcu_percpu_data *rps;
+
+	rps = &per_cpu(rcu_percpu, cpu);
+
+	return __rcu_needs_cpu(&rcu_global_state_normal, &rps->state_normal) ||
+		__rcu_needs_cpu(&rcu_global_state_bh, &rps->state_bh) ||
+		(rps->data_dead.deadqlen > 0);
+}
+
+/**
+ * rcu_check_callback(cpu, user) - external entry point for grace checking
+ * @cpu: cpu id.
+ * @user: user space was interrupted.
+ *
+ * Top-level function driving RCU grace-period detection, normally
+ * invoked from the scheduler-clock interrupt.  This function simply
+ * increments counters that are read only from softirq by this same
+ * CPU, so there are no memory barriers required.
+ *
+ * This function can run with disabled local interrupts, thus all
+ * callees must use local_irq_save()
+ */
+void rcu_check_callbacks(int cpu, int user)
+{
+	struct rcu_percpu_data *rps;
+	int normal_quiet;
+	int bh_quiet;
+
+
+	if (user ||
+	    (idle_cpu(cpu) && !in_softirq() &&
+				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+		/*
+		 * Get here if this CPU took its interrupt from user
+		 * mode or from the idle loop, and if this is not a
+		 * nested interrupt.  In this case, the CPU is in
+		 * a quiescent state, so count it.
+		 *
+		 */
+		normal_quiet = 1;
+		bh_quiet = 1;
+
+	} else if (!in_softirq()) {
+		/*
+		 * Get here if this CPU did not take its interrupt from
+		 * softirq, in other words, if it is not interrupting
+		 * a rcu_bh read-side critical section.  This is an _bh
+		 * critical section, so count it.
+		 */
+		normal_quiet = 0;
+		bh_quiet = 1;
+	} else {
+		/*
+		 * We are interrupting something. Nevertheless - check if we should collect
+		 * rcu objects. This can be done from arbitrary context.
+		 */
+		normal_quiet = 0;
+		bh_quiet = 0;
+	}
+	rps = &per_cpu(rcu_percpu, cpu);
+	rcu_state_machine(RCU_STRUCT_NORMAL, normal_quiet, cpu);
+	rcu_state_machine(RCU_STRUCT_BH, bh_quiet, cpu);
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
+
+		next = list->next;
+		prefetch(next);
+		list->func(list);
+		list = next;
+	}
+
+	/* step 3: if still entries left, raise the softirq again */
+	if (rcd->deadqlen)
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+static void rcu_process_callbacks(struct softirq_action *unused)
+{
+	rcu_do_batch(&get_cpu_var(rcu_percpu).data_dead);
+	put_cpu_var(rcu_percpu);
+}
+
+static void __rcu_add_cpu(struct rcu_global_state *rgs, struct rcu_cpu_state *rcs, int cpu)
+{
+	rcs->state = rcu_getstate(rcu_cpumask_addcpu(&rgs->cpus, cpu));
+}
+
+#ifdef CONFIG_NO_HZ
+
+void rcu_enter_nohz(void)
+{
+	struct rcu_percpu_data *rps;
+	int cpu = smp_processor_id();
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
+	rps = &__get_cpu_var(rcu_percpu);
+
+	__rcu_remove_cpu(RCU_STRUCT_NORMAL, cpu);
+	__rcu_remove_cpu(RCU_STRUCT_BH, cpu);
+	BUG_ON(rcu_needs_cpu(cpu));
+
+	BUG_ON(rps->cpu_mode != RCU_CPUMODE_DELAYED);
+	rps->cpu_mode = RCU_CPUMODE_NOHZ;
+
+	atomic_set(&rps->total_count, RCU_IRQ_INIT);
+
+	cpu_set(cpu, rcu_nohz_mask);
+}
+
+void rcu_exit_nohz(void)
+{
+	struct rcu_percpu_data *rps;
+	int cpu = smp_processor_id();
+
+	rps = &__get_cpu_var(rcu_percpu);
+
+	BUG_ON(!irqs_disabled());
+	BUG_ON(rps->in_irq_count != 0);
+	BUG_ON(rps->in_nmi_count != 0);
+	BUG_ON(rps->cpu_mode != RCU_CPUMODE_NOHZ);
+
+	spin_lock(&rps->poller_lock);
+	rcu_kick_poller(rps);
+	cpu_clear(cpu, rcu_nohz_mask);
+	rps->cpu_mode = RCU_CPUMODE_DELAYED;
+	spin_unlock(&rps->poller_lock);
+
+	__rcu_add_cpu(&rcu_global_state_normal, &rps->state_normal, cpu);
+	__rcu_add_cpu(&rcu_global_state_bh, &rps->state_bh, cpu);
+}
+
+void rcu_irq_enter(int in_nmi)
+{
+	struct rcu_percpu_data *rps;
+	int cpu = smp_processor_id();
+
+	rps = &__get_cpu_var(rcu_percpu);
+
+	BUG_ON(!irqs_disabled());
+
+	if (unlikely(rps->cpu_mode == RCU_CPUMODE_NOHZ)) {
+		if (unlikely(!cpu_isset(cpu, rcu_nohz_mask))) {
+			cpu_set(cpu, rcu_nohz_mask);
+		}
+		atomic_inc(&rps->total_count);
+
+		if (rps->in_irq_count == 0 && rps->in_nmi_count == 0) {
+			BUG_ON(rps->state_normal.kick_poller);
+			BUG_ON(rps->state_bh.kick_poller);
+
+			rps->state_normal.state = rcu_cpumask_getstate(&rcu_global_state_normal.cpus);
+			rps->state_bh.state = rcu_cpumask_getstate(&rcu_global_state_bh.cpus);
+ 		}
+		if (in_nmi) {
+			rps->in_nmi_count++;
+		} else {
+			rps->in_irq_count++;
+		}
+		/*
+		 * Here an explicit mb() is required:
+		 * All other memory ordering is enforced by the spinlock in rgs->cpus.
+		 * For interrupt in nohz mode, this is not the case: The counters
+		 * incs must be visible before any accesses to rcu protected memory,
+		 * the counter dec after all accesses.
+		 */
+		smp_mb();
+	}
+}
+
+void rcu_irq_exit(int in_nmi)
+{
+	struct rcu_percpu_data *rps;
+	rps = &__get_cpu_var(rcu_percpu);
+
+	BUG_ON(!irqs_disabled());
+
+
+	if (unlikely(rps->cpu_mode == RCU_CPUMODE_NOHZ)) {
+		smp_mb();	/* see rcu_irq_enter() */
+
+		if (in_nmi) {
+			rps->in_nmi_count--;
+			/*
+			 * Someone did call_rcu() from nmi context. Don't do this (tm).
+			 */
+			BUG_ON((rps->in_irq_count == 0) && rcu_needs_cpu(smp_processor_id()));
+		} else {
+			spin_lock(&rps->poller_lock);
+			rps->in_irq_count--;
+			if (rps->in_irq_count == 0) {
+				rps->state_normal.state = rcu_cpumask_getstate(&rcu_global_state_normal.cpus);
+				rps->state_bh.state = rcu_cpumask_getstate(&rcu_global_state_bh.cpus);
+
+				rcu_kick_poller(rps);
+	 		}
+			spin_unlock(&rps->poller_lock);
+			if (rcu_needs_cpu(smp_processor_id())) {
+				/*
+				 * task 2: Someone did a call_rcu() in the interupt.
+				 * Duh, we've lost. Force a reschedule, that leaves nohz mode.
+				 *
+				 * Note: This can race: our call_rcu() might have set
+				 * start_immediately. But: that start might happen before
+				 * we readd ourself to the global cpu mask. Then we would
+				 * not take part in the global cycle - and we would not set
+				 * start_immediately again, either, because our newqlen is
+				 * already above qlowmark. The timeout would
+				 * ensure forward progress, thus it's not that bad.
+				 *
+				 * FIXME: double check that this really works.
+				 */
+printk(KERN_ERR" irq exit %d - need resched .\n", smp_processor_id());
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
+}
+
+static void __cpuinit rcu_online_cpu(int cpu)
+{
+	struct rcu_percpu_data *rps;
+
+	BUG_ON(cpu_isset(cpu, rcu_nohz_mask));
+
+	rps = &per_cpu(rcu_percpu, cpu);
+
+	rcu_init_percpu_data(&rcu_global_state_normal, &rps->state_normal, cpu);
+	rcu_init_percpu_data(&rcu_global_state_bh, &rps->state_bh, cpu);
+
+	rps->cpu_mode = RCU_CPUMODE_DELAYED;
+
+	rps->data_dead.dead = NULL;
+	rps->data_dead.deadqlen = 0;
+	rps->data_dead.batchcount = RCU_BATCH_MIN;
+
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
+
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+				unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+printk(KERN_ERR "rcu_cpu_notify: %ld cpu %ld on cpu %d start.\n", action, cpu, smp_processor_id());
+	switch (action) {
+	case CPU_STARTING:
+	case CPU_STARTING_FROZEN:
+		rcu_online_cpu(cpu);
+		break;
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		rcu_offline_cpu(cpu);
+		break;
+	default:
+		break;
+	}
+printk(KERN_ERR "rcu_cpu_notify: %ld cpu %ld on cpu %d done.\n", action, cpu, smp_processor_id());
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata rcu_nb = {
+	.notifier_call	= rcu_cpu_notify,
+};
+
+/*
+ * Initializes rcu mechanism.  Assumed to be called early.
+ * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
+ * Note that rcu_qsctr and friends are implicitly
+ * initialized due to the choice of ``0'' for RCU_CTR_INVALID.
+ */
+void __init __rcu_init(void)
+{
+	rcu_state_init(&rcu_global_state_normal, RCU_STATE_DESTROY);
+	rcu_state_init(&rcu_global_state_bh, RCU_STATE_DESTROY);
+	rcu_cpu_notify(&rcu_nb, CPU_STARTING,
+			(void *)(long)smp_processor_id());
+	/* Register notifier for non-boot CPUs */
+	register_cpu_notifier(&rcu_nb);
+}
+
+module_param(qlowmark, int, 0);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index c506f26..cca5a83 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -284,10 +284,10 @@ void irq_exit(void)
 		invoke_softirq();
 
 #ifdef CONFIG_NO_HZ
+	rcu_irq_exit(0);
 	/* Make sure that timer wheel updates are propagated */
 	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
 		tick_nohz_stop_sched_tick(0);
-	rcu_irq_exit();
 #endif
 	preempt_enable_no_resched();
 }
-- 
1.5.5.1

