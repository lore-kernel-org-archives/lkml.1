Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZLBUKY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 2 Dec 2009 15:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZLBUKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:10:20 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50404 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZLBUKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:10:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] rcu: add expedited grace-period support for preemptible RCU
Date: Wed,  2 Dec 2009 12:10:15 -0800
Message-Id: <1259784616158-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091202200955.GA12950@linux.vnet.ibm.com>
References: <20091202200955.GA12950@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Implement an synchronize_rcu_expedited() for preemptible RCU that actually
is expedited.  This uses synchronize_sched_expedited() to force all
threads currently running in a preemptible-RCU read-side critical section
onto the appropriate ->blocked_tasks[] list, then takes a snapshot of
all of these lists and waits for them to drain.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c     |   34 ++++++--
 kernel/rcutree.c        |   10 ++-
 kernel/rcutree.h        |   35 ++++++++-
 kernel/rcutree_plugin.h |  198 ++++++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutree_trace.c  |   10 ++-
 5 files changed, 260 insertions(+), 27 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 3dd0ca2..a621a67 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -327,6 +327,11 @@ rcu_torture_cb(struct rcu_head *p)
 		cur_ops->deferred_free(rp);
 }
 
+static int rcu_no_completed(void)
+{
+	return 0;
+}
+
 static void rcu_torture_deferred_free(struct rcu_torture *p)
 {
 	call_rcu(&p->rtort_rcu, rcu_torture_cb);
@@ -388,6 +393,21 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.name		= "rcu_sync"
 };
 
+static struct rcu_torture_ops rcu_expedited_ops = {
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_no_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_rcu_expedited,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_expedited"
+};
+
 /*
  * Definitions for rcu_bh torture testing.
  */
@@ -581,11 +601,6 @@ static void sched_torture_read_unlock(int idx)
 	preempt_enable();
 }
 
-static int sched_torture_completed(void)
-{
-	return 0;
-}
-
 static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 {
 	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
@@ -602,7 +617,7 @@ static struct rcu_torture_ops sched_ops = {
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
-	.completed	= sched_torture_completed,
+	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sched_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= rcu_barrier_sched,
@@ -617,7 +632,7 @@ static struct rcu_torture_ops sched_sync_ops = {
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
-	.completed	= sched_torture_completed,
+	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= NULL,
@@ -631,7 +646,7 @@ static struct rcu_torture_ops sched_expedited_ops = {
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
-	.completed	= sched_torture_completed,
+	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_sched_expedited,
 	.cb_barrier	= NULL,
@@ -1116,7 +1131,8 @@ rcu_torture_init(void)
 	int cpu;
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
-		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
+		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
+		  &rcu_bh_ops, &rcu_bh_sync_ops,
 		  &srcu_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d47e03e..53ae959 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -948,7 +948,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	unsigned long mask;
-	int need_quiet = 0;
+	int need_report = 0;
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp;
 
@@ -967,7 +967,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 			break;
 		}
 		if (rnp == rdp->mynode)
-			need_quiet = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
 		else
 			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
@@ -982,10 +982,12 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	 */
 	spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
 	rnp = rdp->mynode;
-	if (need_quiet)
+	if (need_report & RCU_OFL_TASKS_NORM_GP)
 		rcu_report_unblock_qs_rnp(rnp, flags);
 	else
 		spin_unlock_irqrestore(&rnp->lock, flags);
+	if (need_report & RCU_OFL_TASKS_EXP_GP)
+		rcu_report_exp_rnp(rsp, rnp);
 
 	rcu_adopt_orphan_cbs(rsp);
 }
@@ -1843,6 +1845,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			rnp->level = i;
 			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
+			INIT_LIST_HEAD(&rnp->blocked_tasks[2]);
+			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
 		}
 	}
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index df2e0b6..d2a0046 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -104,8 +104,12 @@ struct rcu_node {
 				/*  an rcu_data structure, otherwise, each */
 				/*  bit corresponds to a child rcu_node */
 				/*  structure. */
+	unsigned long expmask;	/* Groups that have ->blocked_tasks[] */
+				/*  elements that need to drain to allow the */
+				/*  current expedited grace period to */
+				/*  complete (only for TREE_PREEMPT_RCU). */
 	unsigned long qsmaskinit;
-				/* Per-GP initialization for qsmask. */
+				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
 				/*  Only one bit will be set in this mask. */
 	int	grplo;		/* lowest-numbered CPU or group here. */
@@ -113,7 +117,7 @@ struct rcu_node {
 	u8	grpnum;		/* CPU/group number for next level up. */
 	u8	level;		/* root is at level 0. */
 	struct rcu_node *parent;
-	struct list_head blocked_tasks[2];
+	struct list_head blocked_tasks[4];
 				/* Tasks blocked in RCU read-side critsect. */
 				/*  Grace period number (->gpnum) x blocked */
 				/*  by tasks on the (x & 0x1) element of the */
@@ -128,6 +132,21 @@ struct rcu_node {
 	for ((rnp) = &(rsp)->node[0]; \
 	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
 
+/*
+ * Do a breadth-first scan of the non-leaf rcu_node structures for the
+ * specified rcu_state structure.  Note that if there is a singleton
+ * rcu_node tree with but one rcu_node structure, this loop is a no-op.
+ */
+#define rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) \
+	for ((rnp) = &(rsp)->node[0]; \
+	     (rnp) < (rsp)->level[NUM_RCU_LVLS - 1]; (rnp)++)
+
+/*
+ * Scan the leaves of the rcu_node hierarchy for the specified rcu_state
+ * structure.  Note that if there is a singleton rcu_node tree with but
+ * one rcu_node structure, this loop -will- visit the rcu_node structure.
+ * It is still a leaf node, even if it is also the root node.
+ */
 #define rcu_for_each_leaf_node(rsp, rnp) \
 	for ((rnp) = (rsp)->level[NUM_RCU_LVLS - 1]; \
 	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
@@ -261,7 +280,7 @@ struct rcu_state {
 	long	gpnum;				/* Current gp number. */
 	long	completed;			/* # of last completed gp. */
 
-	/* End  of fields guarded by root rcu_node's lock. */
+	/* End of fields guarded by root rcu_node's lock. */
 
 	spinlock_t onofflock;			/* exclude on/offline and */
 						/*  starting new GP.  Also */
@@ -293,6 +312,13 @@ struct rcu_state {
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 };
 
+/* Return values for rcu_preempt_offline_tasks(). */
+
+#define RCU_OFL_TASKS_NORM_GP	0x1		/* Tasks blocking normal */
+						/*  GP were moved to root. */
+#define RCU_OFL_TASKS_EXP_GP	0x2		/* Tasks blocking expedited */
+						/*  GP were moved to root. */
+
 #ifdef RCU_TREE_NONCORE
 
 /*
@@ -333,6 +359,9 @@ static void rcu_preempt_offline_cpu(int cpu);
 static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
+#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c9f0c97..37fbccd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -24,12 +24,15 @@
  *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
+#include <linux/delay.h>
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 
+static int rcu_preempted_readers_exp(struct rcu_node *rnp);
+
 /*
  * Tell them what RCU they are running.
  */
@@ -157,7 +160,10 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  */
 static int rcu_preempted_readers(struct rcu_node *rnp)
 {
-	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+	int phase = rnp->gpnum & 0x1;
+
+	return !list_empty(&rnp->blocked_tasks[phase]) ||
+	       !list_empty(&rnp->blocked_tasks[phase + 2]);
 }
 
 /*
@@ -204,6 +210,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 static void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
+	int empty_exp;
 	unsigned long flags;
 	struct rcu_node *rnp;
 	int special;
@@ -247,6 +254,8 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
 		}
 		empty = !rcu_preempted_readers(rnp);
+		empty_exp = !rcu_preempted_readers_exp(rnp);
+		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		list_del_init(&t->rcu_node_entry);
 		t->rcu_blocked_node = NULL;
 
@@ -259,6 +268,13 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			spin_unlock_irqrestore(&rnp->lock, flags);
 		else
 			rcu_report_unblock_qs_rnp(rnp, flags);
+
+		/*
+		 * If this was the last task on the expedited lists,
+		 * then we need to report up the rcu_node hierarchy.
+		 */
+		if (!empty_exp && !rcu_preempted_readers_exp(rnp))
+			rcu_report_exp_rnp(&rcu_preempt_state, rnp);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -343,7 +359,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
-	int retval;
+	int retval = 0;
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
 	struct task_struct *tp;
 
@@ -353,7 +369,9 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	}
 	WARN_ON_ONCE(rnp != rdp->mynode &&
 		     (!list_empty(&rnp->blocked_tasks[0]) ||
-		      !list_empty(&rnp->blocked_tasks[1])));
+		      !list_empty(&rnp->blocked_tasks[1]) ||
+		      !list_empty(&rnp->blocked_tasks[2]) ||
+		      !list_empty(&rnp->blocked_tasks[3])));
 
 	/*
 	 * Move tasks up to root rcu_node.  Rely on the fact that the
@@ -361,8 +379,11 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * rcu_nodes in terms of gp_num value.  This fact allows us to
 	 * move the blocked_tasks[] array directly, element by element.
 	 */
-	retval = rcu_preempted_readers(rnp);
-	for (i = 0; i < 2; i++) {
+	if (rcu_preempted_readers(rnp))
+		retval |= RCU_OFL_TASKS_NORM_GP;
+	if (rcu_preempted_readers_exp(rnp))
+		retval |= RCU_OFL_TASKS_EXP_GP;
+	for (i = 0; i < 4; i++) {
 		lp = &rnp->blocked_tasks[i];
 		lp_root = &rnp_root->blocked_tasks[i];
 		while (!list_empty(lp)) {
@@ -449,14 +470,159 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
+static long sync_rcu_preempt_exp_count;
+static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
+
+/*
+ * Return non-zero if there are any tasks in RCU read-side critical
+ * sections blocking the current preemptible-RCU expedited grace period.
+ * If there is no preemptible-RCU expedited grace period currently in
+ * progress, returns zero unconditionally.
+ */
+static int rcu_preempted_readers_exp(struct rcu_node *rnp)
+{
+	return !list_empty(&rnp->blocked_tasks[2]) ||
+	       !list_empty(&rnp->blocked_tasks[3]);
+}
+
+/*
+ * return non-zero if there is no RCU expedited grace period in progress
+ * for the specified rcu_node structure, in other words, if all CPUs and
+ * tasks covered by the specified rcu_node structure have done their bit
+ * for the current expedited grace period.  Works only for preemptible
+ * RCU -- other RCU implementation use other means.
+ *
+ * Caller must hold sync_rcu_preempt_exp_mutex.
+ */
+static int sync_rcu_preempt_exp_done(struct rcu_node *rnp)
+{
+	return !rcu_preempted_readers_exp(rnp) &&
+	       ACCESS_ONCE(rnp->expmask) == 0;
+}
+
+/*
+ * Report the exit from RCU read-side critical section for the last task
+ * that queued itself during or before the current expedited preemptible-RCU
+ * grace period.  This event is reported either to the rcu_node structure on
+ * which the task was queued or to one of that rcu_node structure's ancestors,
+ * recursively up the tree.  (Calm down, calm down, we do the recursion
+ * iteratively!)
+ *
+ * Caller must hold sync_rcu_preempt_exp_mutex.
+ */
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	unsigned long flags;
+	unsigned long mask;
+
+	spin_lock_irqsave(&rnp->lock, flags);
+	for (;;) {
+		if (!sync_rcu_preempt_exp_done(rnp))
+			break;
+		if (rnp->parent == NULL) {
+			wake_up(&sync_rcu_preempt_exp_wq);
+			break;
+		}
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock); /* irqs remain disabled */
+		rnp = rnp->parent;
+		spin_lock(&rnp->lock); /* irqs already disabled */
+		rnp->expmask &= ~mask;
+	}
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Snapshot the tasks blocking the newly started preemptible-RCU expedited
+ * grace period for the specified rcu_node structure.  If there are no such
+ * tasks, report it up the rcu_node hierarchy.
+ *
+ * Caller must hold sync_rcu_preempt_exp_mutex and rsp->onofflock.
+ */
+static void
+sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	int must_wait;
+
+	spin_lock(&rnp->lock); /* irqs already disabled */
+	list_splice_init(&rnp->blocked_tasks[0], &rnp->blocked_tasks[2]);
+	list_splice_init(&rnp->blocked_tasks[1], &rnp->blocked_tasks[3]);
+	must_wait = rcu_preempted_readers_exp(rnp);
+	spin_unlock(&rnp->lock); /* irqs remain disabled */
+	if (!must_wait)
+		rcu_report_exp_rnp(rsp, rnp);
+}
+
 /*
- * Wait for an rcu-preempt grace period.  We are supposed to expedite the
- * grace period, but this is the crude slow compatability hack, so just
- * invoke synchronize_rcu().
+ * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
+ * is to invoke synchronize_sched_expedited() to push all the tasks to
+ * the ->blocked_tasks[] lists, move all entries from the first set of
+ * ->blocked_tasks[] lists to the second set, and finally wait for this
+ * second set to drain.
  */
 void synchronize_rcu_expedited(void)
 {
-	synchronize_rcu();
+	unsigned long flags;
+	struct rcu_node *rnp;
+	struct rcu_state *rsp = &rcu_preempt_state;
+	long snap;
+	int trycount = 0;
+
+	smp_mb(); /* Caller's modifications seen first by other CPUs. */
+	snap = ACCESS_ONCE(sync_rcu_preempt_exp_count) + 1;
+	smp_mb(); /* Above access cannot bleed into critical section. */
+
+	/*
+	 * Acquire lock, falling back to synchronize_rcu() if too many
+	 * lock-acquisition failures.  Of course, if someone does the
+	 * expedited grace period for us, just leave.
+	 */
+	while (!mutex_trylock(&sync_rcu_preempt_exp_mutex)) {
+		if (trycount++ < 10)
+			udelay(trycount * num_online_cpus());
+		else {
+			synchronize_rcu();
+			return;
+		}
+		if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
+			goto mb_ret; /* Others did our work for us. */
+	}
+	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
+		goto unlock_mb_ret; /* Others did our work for us. */
+
+	/* force all RCU readers onto blocked_tasks[]. */
+	synchronize_sched_expedited();
+
+	spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/* Initialize ->expmask for all non-leaf rcu_node structures. */
+	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
+		spin_lock(&rnp->lock); /* irqs already disabled. */
+		rnp->expmask = rnp->qsmaskinit;
+		spin_unlock(&rnp->lock); /* irqs remain disabled. */
+	}
+
+	/* Snapshot current state of ->blocked_tasks[] lists. */
+	rcu_for_each_leaf_node(rsp, rnp)
+		sync_rcu_preempt_exp_init(rsp, rnp);
+	if (NUM_RCU_NODES > 1)
+		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
+
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
+
+	/* Wait for snapshotted ->blocked_tasks[] lists to drain. */
+	rnp = rcu_get_root(rsp);
+	wait_event(sync_rcu_preempt_exp_wq,
+		   sync_rcu_preempt_exp_done(rnp));
+
+	/* Clean up and exit. */
+	smp_mb(); /* ensure expedited GP seen before counter increment. */
+	ACCESS_ONCE(sync_rcu_preempt_exp_count)++;
+unlock_mb_ret:
+	mutex_unlock(&sync_rcu_preempt_exp_mutex);
+mb_ret:
+	smp_mb(); /* ensure subsequent action seen after grace period. */
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
@@ -655,6 +821,20 @@ void synchronize_rcu_expedited(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Because preemptable RCU does not exist, there is never any need to
+ * report on tasks preempted in RCU read-side critical sections during
+ * expedited RCU grace periods.
+ */
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	return;
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Because preemptable RCU does not exist, it never has any work to do.
  */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 1984cdc..9d2c884 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -157,6 +157,7 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
 	long gpnum;
 	int level = 0;
+	int phase;
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
@@ -173,10 +174,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 			seq_puts(m, "\n");
 			level = rnp->level;
 		}
-		seq_printf(m, "%lx/%lx %c>%c %d:%d ^%d    ",
+		phase = gpnum & 0x1;
+		seq_printf(m, "%lx/%lx %c%c>%c%c %d:%d ^%d    ",
 			   rnp->qsmask, rnp->qsmaskinit,
-			   "T."[list_empty(&rnp->blocked_tasks[gpnum & 1])],
-			   "T."[list_empty(&rnp->blocked_tasks[!(gpnum & 1)])],
+			   "T."[list_empty(&rnp->blocked_tasks[phase])],
+			   "E."[list_empty(&rnp->blocked_tasks[phase + 2])],
+			   "T."[list_empty(&rnp->blocked_tasks[!phase])],
+			   "E."[list_empty(&rnp->blocked_tasks[!phase + 2])],
 			   rnp->grplo, rnp->grphi, rnp->grpnum);
 	}
 	seq_puts(m, "\n");
-- 
1.5.2.5

