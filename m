Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZIVWZU (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 22 Sep 2009 18:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZIVWZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 18:25:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44840 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbZIVWZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 18:25:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] Apply review feedback from Josh Triplett, part 2
Date: Tue, 22 Sep 2009 15:25:14 -0700
Message-Id: <12536583161028-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090922222443.GA3178@linux.vnet.ibm.com>
References: <20090922222443.GA3178@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    4 ++
 include/linux/rcutree.h  |    6 +---
 init/main.c              |    1 -
 kernel/rcutree.c         |   72 +++++++++++++++++++++-------------------------
 kernel/rcutree.h         |   31 ++++++++++++++-----
 kernel/rcutree_plugin.h  |   23 +++++++++++++-
 6 files changed, 82 insertions(+), 55 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6fe0363..7033121 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -196,6 +196,8 @@ static inline void rcu_read_lock_sched(void)
 	__acquire(RCU_SCHED);
 	rcu_read_acquire();
 }
+
+/* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_lock_sched_notrace(void)
 {
 	preempt_disable_notrace();
@@ -213,6 +215,8 @@ static inline void rcu_read_unlock_sched(void)
 	__release(RCU_SCHED);
 	preempt_enable();
 }
+
+/* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_unlock_sched_notrace(void)
 {
 	__release(RCU_SCHED);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 88109c8..19a3b06 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -90,10 +90,6 @@ extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
 
-static inline void rcu_init_sched(void)
-{
-}
-
 #ifdef CONFIG_NO_HZ
 void rcu_enter_nohz(void);
 void rcu_exit_nohz(void);
@@ -106,7 +102,7 @@ static inline void rcu_exit_nohz(void)
 }
 #endif /* CONFIG_NO_HZ */
 
-/* A context switch is a grace period for rcutree. */
+/* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
 {
 	return num_online_cpus() == 1;
diff --git a/init/main.c b/init/main.c
index 2c5ade7..ba9427e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -804,7 +804,6 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
-	rcu_init_sched(); /* needed by module_init stage. */
 	init_workqueues();
 	cpuset_init_smp();
 	usermodehelper_init();
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d45ffb8..61472bd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -80,24 +80,29 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
-extern long rcu_batches_completed_sched(void);
-static struct rcu_node *rcu_get_root(struct rcu_state *rsp);
-static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
-			  struct rcu_node *rnp, unsigned long flags);
-static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
+/* Forward declarations for rcutree_plugin.h */
+static inline void rcu_bootup_announce(void);
+long rcu_batches_completed(void);
+static void rcu_preempt_note_context_switch(int cpu);
+static int rcu_preempted_readers(struct rcu_node *rnp);
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+static void rcu_print_task_stall(struct rcu_node *rnp);
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
-static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp);
+static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp);
+static void rcu_preempt_offline_cpu(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-static void __rcu_process_callbacks(struct rcu_state *rsp,
-				    struct rcu_data *rdp);
-static void __call_rcu(struct rcu_head *head,
-		       void (*func)(struct rcu_head *rcu),
-		       struct rcu_state *rsp);
-static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp);
-static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
-					   int preemptable);
+static void rcu_preempt_check_callbacks(int cpu);
+static void rcu_preempt_process_callbacks(void);
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
+static int rcu_preempt_pending(int cpu);
+static int rcu_preempt_needs_cpu(int cpu);
+static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
+static void __init __rcu_init_preempt(void);
 
-#include "rcutree_plugin.h"
 
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
@@ -376,7 +381,7 @@ static long dyntick_recall_completed(struct rcu_state *rsp)
 /*
  * Snapshot the specified CPU's dynticks counter so that we can later
  * credit them with an implicit quiescent state.  Return 1 if this CPU
- * is already in a quiescent state courtesy of dynticks idle mode.
+ * is in dynticks idle mode, which is an extended quiescent state.
  */
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
@@ -619,9 +624,15 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	note_new_gpnum(rsp, rdp);
 
 	/*
-	 * Because we are first, we know that all our callbacks will
-	 * be covered by this upcoming grace period, even the ones
-	 * that were registered arbitrarily recently.
+	 * Because this CPU just now started the new grace period, we know
+	 * that all of its callbacks will be covered by this upcoming grace
+	 * period, even the ones that were registered arbitrarily recently.
+	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
+	 * 
+	 * Other CPUs cannot be sure exactly when the grace period started.
+	 * Therefore, their recently registered callbacks must pass through
+	 * an additional RCU_NEXT_READY stage, so that they will be handled
+	 * by the next RCU grace period.
 	 */
 	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
@@ -881,7 +892,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 
 	/*
 	 * Move callbacks from the outgoing CPU to the running CPU.
-	 * Note that the outgoing CPU is now quiscent, so it is now
+	 * Note that the outgoing CPU is now quiescent, so it is now
 	 * (uncharacteristically) safe to access its rcu_data structure.
 	 * Note also that we must carefully retain the order of the
 	 * outgoing CPU's callbacks in order for rcu_barrier() to work
@@ -1572,25 +1583,6 @@ do { \
 	} \
 } while (0)
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
-
-void __init __rcu_init_preempt(void)
-{
-	int i;			/* All used by RCU_INIT_FLAVOR(). */
-	int j;
-	struct rcu_node *rnp;
-
-	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
-}
-
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-
-void __init __rcu_init_preempt(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
-
 void __init __rcu_init(void)
 {
 	int i;			/* All used by RCU_INIT_FLAVOR(). */
@@ -1607,6 +1599,8 @@ void __init __rcu_init(void)
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
+#include "rcutree_plugin.h"
+
 module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 9aa8c8a..a48d11f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -79,15 +79,21 @@ struct rcu_dynticks {
  * Definition for node within the RCU grace-period-detection hierarchy.
  */
 struct rcu_node {
-	spinlock_t lock;
+	spinlock_t lock;	/* Root rcu_node's lock protects some */
+				/*  rcu_state fields as well as following. */
 	long	gpnum;		/* Current grace period for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
 	unsigned long qsmask;	/* CPUs or groups that need to switch in */
 				/*  order for current grace period to proceed.*/
+				/*  In leaf rcu_node, each bit corresponds to */
+				/*  an rcu_data structure, otherwise, each */
+				/*  bit corresponds to a child rcu_node */
+				/*  structure. */
 	unsigned long qsmaskinit;
 				/* Per-GP initialization for qsmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
+				/*  Only one bit will be set in this mask. */
 	int	grplo;		/* lowest-numbered CPU or group here. */
 	int	grphi;		/* highest-numbered CPU or group here. */
 	u8	grpnum;		/* CPU/group number for next level up. */
@@ -95,6 +101,9 @@ struct rcu_node {
 	struct rcu_node *parent;
 	struct list_head blocked_tasks[2];
 				/* Tasks blocked in RCU read-side critsect. */
+				/*  Grace period number (->gpnum) x blocked */
+				/*  by tasks on the (x & 0x1) element of the */
+				/*  blocked_tasks[] array. */
 } ____cacheline_internodealigned_in_smp;
 
 /* Index values for nxttail array in struct rcu_data. */
@@ -126,19 +135,22 @@ struct rcu_data {
 	 * Any of the partitions might be empty, in which case the
 	 * pointer to that partition will be equal to the pointer for
 	 * the following partition.  When the list is empty, all of
-	 * the nxttail elements point to nxtlist, which is NULL.
+	 * the nxttail elements point to the ->nxtlist pointer itself,
+	 * which in that case is NULL.
 	 *
-	 * [*nxttail[RCU_NEXT_READY_TAIL], NULL = *nxttail[RCU_NEXT_TAIL]):
-	 *	Entries that might have arrived after current GP ended
-	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
-	 *	Entries known to have arrived before current GP ended
-	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
-	 *	Entries that batch # <= ->completed - 1: waiting for current GP
 	 * [nxtlist, *nxttail[RCU_DONE_TAIL]):
 	 *	Entries that batch # <= ->completed
 	 *	The grace period for these entries has completed, and
 	 *	the other grace-period-completed entries may be moved
 	 *	here temporarily in rcu_process_callbacks().
+	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
+	 *	Entries that batch # <= ->completed - 1: waiting for current GP
+	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
+	 *	Entries known to have arrived before current GP ended
+	 * [*nxttail[RCU_NEXT_READY_TAIL], *nxttail[RCU_NEXT_TAIL]):
+	 *	Entries that might have arrived after current GP ended
+	 *	Note that the value of *nxttail[RCU_NEXT_TAIL] will
+	 *	always be NULL, as this is the end of the list.
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
@@ -216,6 +228,9 @@ struct rcu_state {
 						/* Force QS state. */
 	long	gpnum;				/* Current gp number. */
 	long	completed;			/* # of last completed gp. */
+
+	/* End  of fields guarded by root rcu_node's lock. */
+
 	spinlock_t onofflock;			/* exclude on/offline and */
 						/*  starting new GP. */
 	spinlock_t fqslock;			/* Only one task forcing */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 01485e8..2c73162 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -420,6 +420,18 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
+ * Initialize preemptable RCU's state structures.
+ */
+static void __init __rcu_init_preempt(void)
+{
+	int i;			/* All used by RCU_INIT_FLAVOR(). */
+	int j;
+	struct rcu_node *rnp;
+
+	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
+}
+
+/*
  * Check for a task exiting while in a preemptable-RCU read-side
  * critical section, clean up if so.  No need to issue warnings,
  * as debug_check_no_locks_held() already does this if lockdep
@@ -519,7 +531,7 @@ static void rcu_preempt_offline_cpu(int cpu)
  * Because preemptable RCU does not exist, it never has any callbacks
  * to check.
  */
-void rcu_preempt_check_callbacks(int cpu)
+static void rcu_preempt_check_callbacks(int cpu)
 {
 }
 
@@ -527,7 +539,7 @@ void rcu_preempt_check_callbacks(int cpu)
  * Because preemptable RCU does not exist, it never has any callbacks
  * to process.
  */
-void rcu_preempt_process_callbacks(void)
+static void rcu_preempt_process_callbacks(void)
 {
 }
 
@@ -564,4 +576,11 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 {
 }
 
+/*
+ * Because preemptable RCU does not exist, it need not be initialized.
+ */
+static void __init __rcu_init_preempt(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
-- 
1.5.2.5

