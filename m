Return-Path: <linux-kernel-owner+w=401wt.eu-S933427AbZHWJDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbZHWJDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbZHWJDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:03:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:37001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbZHWJDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:03:41 -0400
Date: Sun, 23 Aug 2009 09:03:13 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12509746134003-git-send-email->
References: <12509746134003-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Merge preemptable-RCU functionality into hierarchical RCU
Message-ID: <tip-f41d911f8c49a5d65c86504c19e8204bb605c4fd@git.kernel.org>
Git-Commit-ID: f41d911f8c49a5d65c86504c19e8204bb605c4fd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:03:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f41d911f8c49a5d65c86504c19e8204bb605c4fd
Gitweb:     http://git.kernel.org/tip/f41d911f8c49a5d65c86504c19e8204bb605c4fd
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 22 Aug 2009 13:56:52 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 10:32:40 +0200

rcu: Merge preemptable-RCU functionality into hierarchical RCU

Create a kernel/rcutree_plugin.h file that contains definitions
for preemptable RCU (or, under the #else branch of the #ifdef,
empty definitions for the classic non-preemptable semantics).
These definitions fit into plugins defined in kernel/rcutree.c
for this purpose.

This variant of preemptable RCU uses a new algorithm whose
read-side expense is roughly that of classic hierarchical RCU
under CONFIG_PREEMPT. This new algorithm's update-side expense
is similar to that of classic hierarchical RCU, and, in absence
of read-side preemption or blocking, is exactly that of classic
hierarchical RCU.  Perhaps more important, this new algorithm
has a much simpler implementation, saving well over 1,000 lines
of code compared to mainline's implementation of preemptable
RCU, which will hopefully be retired in favor of this new
algorithm.

The simplifications are obtained by maintaining per-task
nesting state for running tasks, and using a simple
lock-protected algorithm to handle accounting when tasks block
within RCU read-side critical sections, making use of lessons
learned while creating numerous user-level RCU implementations
over the past 18 months.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <12509746134003-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/init_task.h  |   15 ++
 include/linux/rcupdate.h   |    2 +-
 include/linux/rcupreempt.h |    4 +
 include/linux/rcutree.h    |   16 ++
 include/linux/sched.h      |   37 ++++
 init/Kconfig               |   22 ++-
 kernel/Makefile            |    1 +
 kernel/exit.c              |    1 +
 kernel/fork.c              |    5 +-
 kernel/rcutree.c           |  135 +++++++++-----
 kernel/rcutree.h           |    9 +
 kernel/rcutree_plugin.h    |  447 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree_trace.c     |   20 ++
 lib/Kconfig.debug          |    2 +-
 14 files changed, 661 insertions(+), 55 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 7fc01b1..971a968 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -94,6 +94,20 @@ extern struct group_info init_groups;
 # define CAP_INIT_BSET  CAP_INIT_EFF_SET
 #endif
 
+#ifdef CONFIG_PREEMPT_RCU
+#define INIT_TASK_RCU_PREEMPT(tsk)					\
+	.rcu_read_lock_nesting = 0,					\
+	.rcu_flipctr_idx = 0,
+#elif defined(CONFIG_TREE_PREEMPT_RCU)
+#define INIT_TASK_RCU_PREEMPT(tsk)					\
+	.rcu_read_lock_nesting = 0,					\
+	.rcu_read_unlock_special = 0,					\
+	.rcu_blocked_cpu = -1,						\
+	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),
+#else
+#define INIT_TASK_RCU_PREEMPT(tsk)
+#endif
+
 extern struct cred init_cred;
 
 #ifdef CONFIG_PERF_COUNTERS
@@ -173,6 +187,7 @@ extern struct cred init_cred;
 	INIT_LOCKDEP							\
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
+	INIT_TASK_RCU_PREEMPT(tsk)					\
 }
 
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9d85ee1..26892f5 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -66,7 +66,7 @@ extern void rcu_scheduler_starting(void);
 extern int rcu_needs_cpu(int cpu);
 extern int rcu_scheduler_active;
 
-#if defined(CONFIG_TREE_RCU)
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
 #elif defined(CONFIG_PREEMPT_RCU)
 #include <linux/rcupreempt.h>
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index aff4772..a42ab88 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -98,6 +98,10 @@ static inline long rcu_batches_completed_bh(void)
 	return rcu_batches_completed();
 }
 
+static inline void exit_rcu(void)
+{
+}
+
 #ifdef CONFIG_RCU_TRACE
 struct rcupreempt_trace;
 extern long *rcupreempt_flipctr(int cpu);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c739d90..a893077 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,14 +35,30 @@ extern void rcu_bh_qs(int cpu);
 
 extern int rcu_needs_cpu(int cpu);
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+extern void __rcu_read_lock(void);
+extern void __rcu_read_unlock(void);
+extern void exit_rcu(void);
+
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
 static inline void __rcu_read_lock(void)
 {
 	preempt_disable();
 }
+
 static inline void __rcu_read_unlock(void)
 {
 	preempt_enable();
 }
+
+static inline void exit_rcu(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+
 static inline void __rcu_read_lock_bh(void)
 {
 	local_bh_disable();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3ab08e4..d7f98f6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1210,6 +1210,13 @@ struct task_struct {
 	int rcu_flipctr_idx;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	int rcu_read_lock_nesting;
+	char rcu_read_unlock_special;
+	int rcu_blocked_cpu;
+	struct list_head rcu_node_entry;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
 #endif
@@ -1723,6 +1730,36 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+#define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
+#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
+#define RCU_READ_UNLOCK_GOT_QS  (1 << 2) /* CPU has responded to RCU core. */
+
+static inline void rcu_copy_process(struct task_struct *p)
+{
+	p->rcu_read_lock_nesting = 0;
+	p->rcu_read_unlock_special = 0;
+	p->rcu_blocked_cpu = -1;
+	INIT_LIST_HEAD(&p->rcu_node_entry);
+}
+
+#elif defined(CONFIG_PREEMPT_RCU)
+
+static inline void rcu_copy_process(struct task_struct *p)
+{
+	p->rcu_read_lock_nesting = 0;
+	p->rcu_flipctr_idx = 0;
+}
+
+#else
+
+static inline void rcu_copy_process(struct task_struct *p)
+{
+}
+
+#endif
+
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed_ptr(struct task_struct *p,
 				const struct cpumask *new_mask);
diff --git a/init/Kconfig b/init/Kconfig
index 25373cf..f88da2d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -335,11 +335,20 @@ config PREEMPT_RCU
 	  now-naive assumptions about each RCU read-side critical section
 	  remaining on a given CPU through its execution.
 
+config TREE_PREEMPT_RCU
+	bool "Preemptable tree-based hierarchical RCU"
+	depends on PREEMPT
+	help
+	  This option selects the RCU implementation that is
+	  designed for very large SMP systems with hundreds or
+	  thousands of CPUs, but for which real-time response
+	  is also required.
+
 endchoice
 
 config RCU_TRACE
 	bool "Enable tracing for RCU"
-	depends on TREE_RCU || PREEMPT_RCU
+	depends on TREE_RCU || PREEMPT_RCU || TREE_PREEMPT_RCU
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
@@ -351,7 +360,7 @@ config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
 	range 2 32 if !64BIT
-	depends on TREE_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default 64 if 64BIT
 	default 32 if !64BIT
 	help
@@ -366,7 +375,7 @@ config RCU_FANOUT
 
 config RCU_FANOUT_EXACT
 	bool "Disable tree-based hierarchical RCU auto-balancing"
-	depends on TREE_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
 	  This option forces use of the exact RCU_FANOUT value specified,
@@ -379,11 +388,12 @@ config RCU_FANOUT_EXACT
 	  Say N if unsure.
 
 config TREE_RCU_TRACE
-	def_bool RCU_TRACE && TREE_RCU
+	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
 	select DEBUG_FS
 	help
-	  This option provides tracing for the TREE_RCU implementation,
-	  permitting Makefile to trivially select kernel/rcutree_trace.c.
+	  This option provides tracing for the TREE_RCU and
+	  TREE_PREEMPT_RCU implementations, permitting Makefile to
+	  trivially select kernel/rcutree_trace.c.
 
 config PREEMPT_RCU_TRACE
 	def_bool RCU_TRACE && PREEMPT_RCU
diff --git a/kernel/Makefile b/kernel/Makefile
index 2419c9d..1a38b47 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
+obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
 obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
diff --git a/kernel/exit.c b/kernel/exit.c
index 869dc22..263f95e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1010,6 +1010,7 @@ NORET_TYPE void do_exit(long code)
 		__free_pipe_info(tsk->splice_pipe);
 
 	preempt_disable();
+	exit_rcu();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	schedule();
diff --git a/kernel/fork.c b/kernel/fork.c
index 021e113..642e8b5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1022,10 +1022,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	copy_flags(clone_flags, p);
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
-#ifdef CONFIG_PREEMPT_RCU
-	p->rcu_read_lock_nesting = 0;
-	p->rcu_flipctr_idx = 0;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+	rcu_copy_process(p);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4ce3adc..cc02557 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -80,6 +80,21 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+extern long rcu_batches_completed_sched(void);
+static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
+			  struct rcu_node *rnp, unsigned long flags);
+static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
+static void __rcu_process_callbacks(struct rcu_state *rsp,
+				    struct rcu_data *rdp);
+static void __call_rcu(struct rcu_head *head,
+		       void (*func)(struct rcu_head *rcu),
+		       struct rcu_state *rsp);
+static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp);
+static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
+					   int preemptable);
+
+#include "rcutree_plugin.h"
+
 /*
  * Note a quiescent state.  Because we do not need to know
  * how many quiescent states passed, just if there was at least
@@ -87,16 +102,27 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
  */
 void rcu_sched_qs(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	local_irq_save(flags);
+	rdp = &per_cpu(rcu_sched_data, cpu);
 	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
+	rcu_preempt_qs(cpu);
+	local_irq_restore(flags);
 }
 
 void rcu_bh_qs(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	local_irq_save(flags);
+	rdp = &per_cpu(rcu_bh_data, cpu);
 	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_NO_HZ
@@ -123,16 +149,6 @@ long rcu_batches_completed_sched(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
 
 /*
- * Return the number of RCU batches processed thus far for debug & stats.
- * @@@ placeholder, maps to rcu_batches_completed_sched().
- */
-long rcu_batches_completed(void)
-{
-	return rcu_batches_completed_sched();
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
-
-/*
  * Return the number of RCU BH batches processed thus far for debug & stats.
  */
 long rcu_batches_completed_bh(void)
@@ -193,6 +209,10 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
+	/* If preemptable RCU, no point in sending reschedule IPI. */
+	if (rdp->preemptable)
+		return 0;
+
 	/* The CPU is online, so send it a reschedule IPI. */
 	if (rdp->cpu != smp_processor_id())
 		smp_send_reschedule(rdp->cpu);
@@ -473,6 +493,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	for (; rnp_cur < rnp_end; rnp_cur++) {
+		rcu_print_task_stall(rnp);
 		if (rnp_cur->qsmask == 0)
 			continue;
 		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
@@ -686,6 +707,19 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
+ * Clean up after the prior grace period and let rcu_start_gp() start up
+ * the next grace period if one is needed.  Note that the caller must
+ * hold rnp->lock, as required by rcu_start_gp(), which will release it.
+ */
+static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
+	__releases(rnp->lock)
+{
+	rsp->completed = rsp->gpnum;
+	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
+	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+}
+
+/*
  * Similar to cpu_quiet(), for which it is a helper function.  Allows
  * a group of CPUs to be quieted at one go, though all the CPUs in the
  * group must be represented by the same leaf rcu_node structure.
@@ -706,7 +740,7 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 			return;
 		}
 		rnp->qsmask &= ~mask;
-		if (rnp->qsmask != 0) {
+		if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
 
 			/* Other bits still set at this level, so done. */
 			spin_unlock_irqrestore(&rnp->lock, flags);
@@ -726,14 +760,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 
 	/*
 	 * Get here if we are the last CPU to pass through a quiescent
-	 * state for this grace period.  Clean up and let rcu_start_gp()
-	 * start up the next grace period if one is needed.  Note that
-	 * we still hold rnp->lock, as required by rcu_start_gp(), which
-	 * will release it.
+	 * state for this grace period.  Invoke cpu_quiet_msk_finish()
+	 * to clean up and start the next grace period if one is needed.
 	 */
-	rsp->completed = rsp->gpnum;
-	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
-	rcu_start_gp(rsp, flags);  /* releases rnp->lock. */
+	cpu_quiet_msk_finish(rsp, flags); /* releases rnp->lock. */
 }
 
 /*
@@ -840,11 +870,11 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		spin_lock(&rnp->lock);		/* irqs already disabled. */
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
-			spin_unlock(&rnp->lock); /* irqs already disabled. */
+			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
 		mask = rnp->grpmask;
-		spin_unlock(&rnp->lock);	/* irqs already disabled. */
+		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL);
 	lastcomp = rsp->completed;
@@ -1007,6 +1037,7 @@ void rcu_check_callbacks(int cpu, int user)
 
 		rcu_bh_qs(cpu);
 	}
+	rcu_preempt_check_callbacks(cpu);
 	raise_softirq(RCU_SOFTIRQ);
 }
 
@@ -1188,6 +1219,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_preempt_process_callbacks();
 
 	/*
 	 * Memory references from any later RCU read-side critical sections
@@ -1252,17 +1284,6 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
- * @@@ Queue an RCU callback for invocation after a grace period.
- * @@@ Placeholder pending rcutree_plugin.h.
- */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
-{
-	call_rcu_sched(head, func);
-}
-EXPORT_SYMBOL_GPL(call_rcu);
-
-
-/*
  * Queue an RCU for invocation after a quicker grace period.
  */
 void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
@@ -1335,7 +1356,8 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 static int rcu_pending(int cpu)
 {
 	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
-	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
+	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
+	       rcu_preempt_pending(cpu);
 }
 
 /*
@@ -1348,7 +1370,8 @@ int rcu_needs_cpu(int cpu)
 {
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
-	       per_cpu(rcu_bh_data, cpu).nxtlist;
+	       per_cpu(rcu_bh_data, cpu).nxtlist ||
+	       rcu_preempt_needs_cpu(cpu);
 }
 
 /*
@@ -1383,7 +1406,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
  * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
 static void __cpuinit
-rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 {
 	unsigned long flags;
 	long lastcomp;
@@ -1399,6 +1422,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
+	rdp->preemptable = preemptable;
 	rdp->passed_quiesc_completed = lastcomp - 1;
 	rdp->blimit = blimit;
 	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
@@ -1441,12 +1465,13 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 
 static void __cpuinit rcu_online_cpu(int cpu)
 {
-	rcu_init_percpu_data(cpu, &rcu_sched_state);
-	rcu_init_percpu_data(cpu, &rcu_bh_state);
+	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
+	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
+	rcu_preempt_init_percpu_data(cpu);
 }
 
 /*
- * Handle CPU online/offline notifcation events.
+ * Handle CPU online/offline notification events.
  */
 int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 			     unsigned long action, void *hcpu)
@@ -1521,6 +1546,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
 			spin_lock_init(&rnp->lock);
+			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
 			rnp->grplo = j * cpustride;
@@ -1538,13 +1564,16 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 					      j / rsp->levelspread[i - 1];
 			}
 			rnp->level = i;
+			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
+			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
 }
 
 /*
- * Helper macro for __rcu_init().  To be used nowhere else!
- * Assigns leaf node pointers into each CPU's rcu_data structure.
+ * Helper macro for __rcu_init() and __rcu_init_preempt().  To be used
+ * nowhere else!  Assigns leaf node pointers into each CPU's rcu_data
+ * structure.
  */
 #define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
@@ -1560,18 +1589,38 @@ do { \
 	} \
 } while (0)
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+void __init __rcu_init_preempt(void)
+{
+	int i;			/* All used by RCU_INIT_FLAVOR(). */
+	int j;
+	struct rcu_node *rnp;
+
+	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
+}
+
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+void __init __rcu_init_preempt(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+
 void __init __rcu_init(void)
 {
-	int i;			/* All used by RCU_DATA_PTR_INIT(). */
+	int i;			/* All used by RCU_INIT_FLAVOR(). */
 	int j;
 	struct rcu_node *rnp;
 
-	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
 	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
+	__rcu_init_preempt();
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 0024e5d..ca56036 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -80,6 +80,7 @@ struct rcu_dynticks {
  */
 struct rcu_node {
 	spinlock_t lock;
+	long	gpnum;		/* Current grace period for this node. */
 	unsigned long qsmask;	/* CPUs or groups that need to switch in */
 				/*  order for current grace period to proceed.*/
 	unsigned long qsmaskinit;
@@ -90,6 +91,8 @@ struct rcu_node {
 	u8	grpnum;		/* CPU/group number for next level up. */
 	u8	level;		/* root is at level 0. */
 	struct rcu_node *parent;
+	struct list_head blocked_tasks[2];
+				/* Tasks blocked in RCU read-side critsect. */
 } ____cacheline_internodealigned_in_smp;
 
 /* Index values for nxttail array in struct rcu_data. */
@@ -111,6 +114,7 @@ struct rcu_data {
 	bool		passed_quiesc;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
+	bool		preemptable;	/* Preemptable RCU? */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
 
@@ -244,5 +248,10 @@ DECLARE_PER_CPU(struct rcu_data, rcu_sched_data);
 extern struct rcu_state rcu_bh_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+extern struct rcu_state rcu_preempt_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
 #endif /* #ifdef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
new file mode 100644
index 0000000..cd2ab67
--- /dev/null
+++ b/kernel/rcutree_plugin.h
@@ -0,0 +1,447 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ * Internal non-public definitions that provide either classic
+ * or preemptable semantics.
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
+ * Copyright Red Hat, 2009
+ * Copyright IBM Corporation, 2009
+ *
+ * Author: Ingo Molnar <mingo@elte.hu>
+ *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
+
+/*
+ * Tell them what RCU they are running.
+ */
+static inline void rcu_bootup_announce(void)
+{
+	printk(KERN_INFO
+	       "Experimental preemptable hierarchical RCU implementation.\n");
+}
+
+/*
+ * Return the number of RCU-preempt batches processed thus far
+ * for debug and statistics.
+ */
+long rcu_batches_completed_preempt(void)
+{
+	return rcu_preempt_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed_preempt);
+
+/*
+ * Return the number of RCU batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_batches_completed_preempt();
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Record a preemptable-RCU quiescent state for the specified CPU.  Note
+ * that this just means that the task currently running on the CPU is
+ * not in a quiescent state.  There might be any number of tasks blocked
+ * while in an RCU read-side critical section.
+ */
+static void rcu_preempt_qs_record(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
+/*
+ * We have entered the scheduler or are between softirqs in ksoftirqd.
+ * If we are in an RCU read-side critical section, we need to reflect
+ * that in the state of the rcu_node structure corresponding to this CPU.
+ * Caller must disable hardirqs.
+ */
+static void rcu_preempt_qs(int cpu)
+{
+	struct task_struct *t = current;
+	int phase;
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
+
+	if (t->rcu_read_lock_nesting &&
+	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+
+		/* Possibly blocking in an RCU read-side critical section. */
+		rdp = rcu_preempt_state.rda[cpu];
+		rnp = rdp->mynode;
+		spin_lock(&rnp->lock);
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
+		t->rcu_blocked_cpu = cpu;
+
+		/*
+		 * If this CPU has already checked in, then this task
+		 * will hold up the next grace period rather than the
+		 * current grace period.  Queue the task accordingly.
+		 * If the task is queued for the current grace period
+		 * (i.e., this CPU has not yet passed through a quiescent
+		 * state for the current grace period), then as long
+		 * as that task remains queued, the current grace period
+		 * cannot end.
+		 */
+		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
+		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
+		smp_mb();  /* Ensure later ctxt swtch seen after above. */
+		spin_unlock(&rnp->lock);
+	}
+
+	/*
+	 * Either we were not in an RCU read-side critical section to
+	 * begin with, or we have now recorded that critical section
+	 * globally.  Either way, we can now note a quiescent state
+	 * for this CPU.  Again, if we were in an RCU read-side critical
+	 * section, and if that critical section was blocking the current
+	 * grace period, then the fact that the task has been enqueued
+	 * means that we continue to block the current grace period.
+	 */
+	rcu_preempt_qs_record(cpu);
+	t->rcu_read_unlock_special &= ~(RCU_READ_UNLOCK_NEED_QS |
+					RCU_READ_UNLOCK_GOT_QS);
+}
+
+/*
+ * Tree-preemptable RCU implementation for rcu_read_lock().
+ * Just increment ->rcu_read_lock_nesting, shared state will be updated
+ * if we block.
+ */
+void __rcu_read_lock(void)
+{
+	ACCESS_ONCE(current->rcu_read_lock_nesting)++;
+	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_lock);
+
+static void rcu_read_unlock_special(struct task_struct *t)
+{
+	int empty;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp;
+	int special;
+
+	/* NMI handlers cannot block and cannot safely manipulate state. */
+	if (in_nmi())
+		return;
+
+	local_irq_save(flags);
+
+	/*
+	 * If RCU core is waiting for this CPU to exit critical section,
+	 * let it know that we have done so.
+	 */
+	special = t->rcu_read_unlock_special;
+	if (special & RCU_READ_UNLOCK_NEED_QS) {
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_QS;
+	}
+
+	/* Hardware IRQ handlers cannot block. */
+	if (in_irq()) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	/* Clean up if blocked during RCU read-side critical section. */
+	if (special & RCU_READ_UNLOCK_BLOCKED) {
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
+
+		/* Remove this task from the list it blocked on. */
+		rnp = rcu_preempt_state.rda[t->rcu_blocked_cpu]->mynode;
+		spin_lock(&rnp->lock);
+		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+		list_del_init(&t->rcu_node_entry);
+		t->rcu_blocked_cpu = -1;
+
+		/*
+		 * If this was the last task on the current list, and if
+		 * we aren't waiting on any CPUs, report the quiescent state.
+		 * Note that both cpu_quiet_msk_finish() and cpu_quiet_msk()
+		 * drop rnp->lock and restore irq.
+		 */
+		if (!empty && rnp->qsmask == 0 &&
+		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
+			t->rcu_read_unlock_special &=
+				~(RCU_READ_UNLOCK_NEED_QS |
+				  RCU_READ_UNLOCK_GOT_QS);
+			if (rnp->parent == NULL) {
+				/* Only one rcu_node in the tree. */
+				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
+				return;
+			}
+			/* Report up the rest of the hierarchy. */
+			mask = rnp->grpmask;
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			rnp = rnp->parent;
+			spin_lock_irqsave(&rnp->lock, flags);
+			cpu_quiet_msk(mask, &rcu_preempt_state, rnp, flags);
+			return;
+		}
+		spin_unlock(&rnp->lock);
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Tree-preemptable RCU implementation for rcu_read_unlock().
+ * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ */
+void __rcu_read_unlock(void)
+{
+	struct task_struct *t = current;
+
+	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
+	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
+	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+		rcu_read_unlock_special(t);
+}
+EXPORT_SYMBOL_GPL(__rcu_read_unlock);
+
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+/*
+ * Scan the current list of tasks blocked within RCU read-side critical
+ * sections, printing out the tid of each.
+ */
+static void rcu_print_task_stall(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct list_head *lp;
+	int phase = rnp->gpnum & 0x1;
+	struct task_struct *t;
+
+	if (!list_empty(&rnp->blocked_tasks[phase])) {
+		spin_lock_irqsave(&rnp->lock, flags);
+		phase = rnp->gpnum & 0x1; /* re-read under lock. */
+		lp = &rnp->blocked_tasks[phase];
+		list_for_each_entry(t, lp, rcu_node_entry)
+			printk(" P%d", t->pid);
+		spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * Check for preempted RCU readers for the specified rcu_node structure.
+ * If the caller needs a reliable answer, it must hold the rcu_node's
+ * >lock.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+}
+
+/*
+ * Check for a quiescent state from the current CPU.  When a task blocks,
+ * the task is recorded in the corresponding CPU's rcu_node structure,
+ * which is checked elsewhere.
+ *
+ * Caller must disable hard irqs.
+ */
+static void rcu_preempt_check_callbacks(int cpu)
+{
+	struct task_struct *t = current;
+
+	if (t->rcu_read_lock_nesting == 0) {
+		t->rcu_read_unlock_special &=
+			~(RCU_READ_UNLOCK_NEED_QS | RCU_READ_UNLOCK_GOT_QS);
+		rcu_preempt_qs_record(cpu);
+		return;
+	}
+	if (per_cpu(rcu_preempt_data, cpu).qs_pending) {
+		if (t->rcu_read_unlock_special & RCU_READ_UNLOCK_GOT_QS) {
+			rcu_preempt_qs_record(cpu);
+			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_GOT_QS;
+		} else if (!(t->rcu_read_unlock_special &
+			     RCU_READ_UNLOCK_NEED_QS)) {
+			t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
+		}
+	}
+}
+
+/*
+ * Process callbacks for preemptable RCU.
+ */
+static void rcu_preempt_process_callbacks(void)
+{
+	__rcu_process_callbacks(&rcu_preempt_state,
+				&__get_cpu_var(rcu_preempt_data));
+}
+
+/*
+ * Queue a preemptable-RCU callback for invocation after a grace period.
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_preempt_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Check to see if there is any immediate preemptable-RCU-related work
+ * to be done.
+ */
+static int rcu_preempt_pending(int cpu)
+{
+	return __rcu_pending(&rcu_preempt_state,
+			     &per_cpu(rcu_preempt_data, cpu));
+}
+
+/*
+ * Does preemptable RCU need the CPU to stay out of dynticks mode?
+ */
+static int rcu_preempt_needs_cpu(int cpu)
+{
+	return !!per_cpu(rcu_preempt_data, cpu).nxtlist;
+}
+
+/*
+ * Initialize preemptable RCU's per-CPU data.
+ */
+static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
+{
+	rcu_init_percpu_data(cpu, &rcu_preempt_state, 1);
+}
+
+/*
+ * Check for a task exiting while in a preemptable-RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.
+ */
+void exit_rcu(void)
+{
+	struct task_struct *t = current;
+
+	if (t->rcu_read_lock_nesting == 0)
+		return;
+	t->rcu_read_lock_nesting = 1;
+	rcu_read_unlock();
+}
+
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+/*
+ * Tell them what RCU they are running.
+ */
+static inline void rcu_bootup_announce(void)
+{
+	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+}
+
+/*
+ * Return the number of RCU batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_batches_completed_sched();
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Because preemptable RCU does not exist, we never have to check for
+ * CPUs being in quiescent states.
+ */
+static void rcu_preempt_qs(int cpu)
+{
+}
+
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+/*
+ * Because preemptable RCU does not exist, we never have to check for
+ * tasks blocked within RCU read-side critical sections.
+ */
+static void rcu_print_task_stall(struct rcu_node *rnp)
+{
+}
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * Because preemptable RCU does not exist, there are never any preempted
+ * RCU readers.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return 0;
+}
+
+/*
+ * Because preemptable RCU does not exist, it never has any callbacks
+ * to check.
+ */
+void rcu_preempt_check_callbacks(int cpu)
+{
+}
+
+/*
+ * Because preemptable RCU does not exist, it never has any callbacks
+ * to process.
+ */
+void rcu_preempt_process_callbacks(void)
+{
+}
+
+/*
+ * In classic RCU, call_rcu() is just call_rcu_sched().
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	call_rcu_sched(head, func);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Because preemptable RCU does not exist, it never has any work to do.
+ */
+static int rcu_preempt_pending(int cpu)
+{
+	return 0;
+}
+
+/*
+ * Because preemptable RCU does not exist, it never needs any CPU.
+ */
+static int rcu_preempt_needs_cpu(int cpu)
+{
+	return 0;
+}
+
+/*
+ * Because preemptable RCU does not exist, there is no per-CPU
+ * data to initialize.
+ */
+static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 31af3a0..0ea1bff 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -77,6 +77,10 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata(struct seq_file *m, void *unused)
 {
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "rcu_preempt:\n");
+	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data, m);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	seq_puts(m, "rcu_sched:\n");
 	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data, m);
 	seq_puts(m, "rcu_bh:\n");
@@ -125,6 +129,10 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\"\n");
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "\"rcu_preempt:\"\n");
+	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	seq_puts(m, "\"rcu_sched:\"\n");
 	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data_csv, m);
 	seq_puts(m, "\"rcu_bh:\"\n");
@@ -172,6 +180,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcuhier(struct seq_file *m, void *unused)
 {
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "rcu_preempt:\n");
+	print_one_rcu_state(m, &rcu_preempt_state);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	seq_puts(m, "rcu_sched:\n");
 	print_one_rcu_state(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
@@ -194,6 +206,10 @@ static struct file_operations rcuhier_fops = {
 
 static int show_rcugp(struct seq_file *m, void *unused)
 {
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%ld\n",
+		   rcu_preempt_state.completed, rcu_preempt_state.gpnum);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%ld\n",
 		   rcu_sched_state.completed, rcu_sched_state.gpnum);
 	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%ld\n",
@@ -244,6 +260,10 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcu_pending(struct seq_file *m, void *unused)
 {
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "rcu_preempt:\n");
+	print_rcu_pendings(m, &rcu_preempt_state);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	seq_puts(m, "rcu_sched:\n");
 	print_rcu_pendings(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 12327b2..f87fb0c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -725,7 +725,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU || TREE_RCU
+	depends on CLASSIC_RCU || TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
 	  This option causes RCU to printk information on which
