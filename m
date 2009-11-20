Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZKTDNp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 19 Nov 2009 22:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbZKTDNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 22:13:39 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50226 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbZKTDNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 22:13:37 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: fix grace-period-stall bug on large systems with CPU hotplug
Date: Thu, 19 Nov 2009 19:13:40 -0800
Message-Id: <1258686821744-git-send-email->
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the last CPU of a given leaf rcu_node structure goes offline,
all of the tasks queued on that leaf rcu_node structure (due to having
blocked in their current RCU read-side critical sections) are requeued
onto the root rcu_node structure.  This requeuing is carried out by
rcu_preempt_offline_tasks().  However, it is possible that these queued
tasks are the only thing preventing the leaf rcu_node structure from
reporting a quiescent state up the rcu_node hierarchy.  Unfortunately,
the old code would fail to do this reporting, resulting in a grace-period
stall given the following sequence of events:

1.	Kernel built for more than 32 CPUs on 32-bit systems or for more
	than 64 CPUs on 64-bit systems, so that there is more than one
	rcu_node structure.  (Or CONFIG_RCU_FANOUT is artificially set
	to a number smaller than CONFIG_NR_CPUS.)

2.	The kernel is built with CONFIG_TREE_PREEMPT_RCU.

3.	A task running on a CPU associated with a given leaf rcu_node
	structure blocks while in an RCU read-side critical section
	-and- that CPU has not yet passed through a quiescent state
	for the current RCU grace period.  This will cause the task
	to be queued on the leaf rcu_node's blocked_tasks[] array, in
	particular, on the element of this array corresponding to the
	current grace period.

4.	Each of the remaining CPUs corresponding to this same leaf rcu_node
	structure pass through a quiescent state.  However, the task is
	still in its RCU read-side critical section, so these quiescent
	states cannot be reported further up the rcu_node hierarchy.
	Nevertheless, all bits in the leaf rcu_node structure's ->qsmask
	field are now zero.

5.	Each of the remaining CPUs go offline.  (The events in step
	#4 and #5 can happen in any order as long as each CPU passes
	through a quiescent state before going offline.)

6.	When the last CPU goes offline, __rcu_offline_cpu() will invoke
	rcu_preempt_offline_tasks(), which will move the task to the
	root rcu_node structure, but without reporting a quiescent state
	up the rcu_node hierarchy (and this failure to report a quiescent
	state is the bug).

	But because this leaf rcu_node structure's ->qsmask field is
	already zero and its ->block_tasks[] entries are all empty,
	force_quiescent_state() will skip this rcu_node structure.

	Therefore, grace periods are now hung.

This patch abstracts some code out of rcu_read_unlock_special(), calling
the result task_quiet() by analogy with cpu_quiet(), and invokes task_quiet()
from both rcu_read_lock_special() and __rcu_offline_cpu().  Invoking
task_quiet() from __rcu_offline_cpu() reports the quiescent state up
the rcu_node hierarchy, fixing the bug.  This ends up requiring a separate
lock_class_key per level of the rcu_node hierarchy, which this patch also
provides.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   40 +++++++++++----------
 kernel/rcutree.h        |    3 ++
 kernel/rcutree_plugin.h |   85 +++++++++++++++++++++++++++++++++-------------
 3 files changed, 85 insertions(+), 43 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9b36d6d..b79bfcd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -51,7 +51,7 @@
 
 /* Data structures. */
 
-static struct lock_class_key rcu_root_class;
+static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 
 #define RCU_STATE_INITIALIZER(name) { \
 	.level = { &name.node[0] }, \
@@ -936,6 +936,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	unsigned long mask;
+	int need_quiet = 0;
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp;
 
@@ -949,29 +950,30 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		spin_lock(&rnp->lock);		/* irqs already disabled. */
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
-			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			if (rnp != rdp->mynode)
+				spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
-
-		/*
-		 * If there was a task blocking the current grace period,
-		 * and if all CPUs have checked in, we need to propagate
-		 * the quiescent state up the rcu_node hierarchy.  But that
-		 * is inconvenient at the moment due to deadlock issues if
-		 * this should end the current grace period.  So set the
-		 * offlined CPU's bit in ->qsmask in order to force the
-		 * next force_quiescent_state() invocation to clean up this
-		 * mess in a deadlock-free manner.
-		 */
-		if (rcu_preempt_offline_tasks(rsp, rnp, rdp) && !rnp->qsmask)
-			rnp->qsmask |= mask;
-
+		if (rnp == rdp->mynode)
+			need_quiet = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+		else
+			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
-		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL);
 
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	/*
+	 * We still hold the leaf rcu_node structure lock here, and
+	 * irqs are still disabled.  The reason for this subterfuge is
+	 * because invoking task_quiet() with ->onofflock held leads
+	 * to deadlock.
+	 */
+	spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	rnp = rdp->mynode;
+	if (need_quiet)
+		task_quiet(rnp, flags);
+	else
+		spin_unlock_irqrestore(&rnp->lock, flags);
 
 	rcu_adopt_orphan_cbs(rsp);
 }
@@ -1731,6 +1733,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
 			spin_lock_init(&rnp->lock);
+			lockdep_set_class(&rnp->lock, &rcu_node_class[i]);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
@@ -1753,7 +1756,6 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
-	lockdep_set_class(&rcu_get_root(rsp)->lock, &rcu_root_class);
 }
 
 /*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 17a28a0..a81188c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -305,6 +305,9 @@ static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempted_readers(struct rcu_node *rnp);
+#ifdef CONFIG_HOTPLUG_CPU
+static void task_quiet(struct rcu_node *rnp, unsigned long flags);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_task_stall(struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5ca2d26..0bdb592 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -160,11 +160,51 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
 }
 
+/*
+ * Record a quiescent state for all tasks that were previously queued
+ * on the specified rcu_node structure and that were blocking the current
+ * RCU grace period.  The caller must hold the specified rnp->lock with
+ * irqs disabled, and this lock is released upon return, but irqs remain
+ * disabled.
+ */
+static void task_quiet(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
+{
+	unsigned long mask;
+	struct rcu_node *rnp_p;
+
+	if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;  /* Still need more quiescent states! */
+	}
+
+	rnp_p = rnp->parent;
+	if (rnp_p == NULL) {
+		/*
+		 * Either there is only one rcu_node in the tree,
+		 * or tasks were kicked up to root rcu_node due to
+		 * CPUs going offline.
+		 */
+		cpu_quiet_msk_finish(&rcu_preempt_state, flags);
+		return;
+	}
+
+	/* Report up the rest of the hierarchy. */
+	mask = rnp->grpmask;
+	spin_unlock(&rnp->lock);	/* irqs remain disabled. */
+	spin_lock(&rnp_p->lock);	/* irqs already disabled. */
+	cpu_quiet_msk(mask, &rcu_preempt_state, rnp_p, flags);
+}
+
+/*
+ * Handle special cases during rcu_read_unlock(), such as needing to
+ * notify RCU core processing or task having blocked during the RCU
+ * read-side critical section.
+ */
 static void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	unsigned long flags;
-	unsigned long mask;
 	struct rcu_node *rnp;
 	int special;
 
@@ -213,30 +253,15 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		/*
 		 * If this was the last task on the current list, and if
 		 * we aren't waiting on any CPUs, report the quiescent state.
-		 * Note that both cpu_quiet_msk_finish() and cpu_quiet_msk()
-		 * drop rnp->lock and restore irq.
+		 * Note that task_quiet() releases rnp->lock.
 		 */
-		if (!empty && rnp->qsmask == 0 &&
-		    !rcu_preempted_readers(rnp)) {
-			struct rcu_node *rnp_p;
-
-			if (rnp->parent == NULL) {
-				/* Only one rcu_node in the tree. */
-				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
-				return;
-			}
-			/* Report up the rest of the hierarchy. */
-			mask = rnp->grpmask;
+		if (empty)
 			spin_unlock_irqrestore(&rnp->lock, flags);
-			rnp_p = rnp->parent;
-			spin_lock_irqsave(&rnp_p->lock, flags);
-			WARN_ON_ONCE(rnp->qsmask);
-			cpu_quiet_msk(mask, &rcu_preempt_state, rnp_p, flags);
-			return;
-		}
-		spin_unlock(&rnp->lock);
+		else
+			task_quiet(rnp, flags);
+	} else {
+		local_irq_restore(flags);
 	}
-	local_irq_restore(flags);
 }
 
 /*
@@ -303,6 +328,8 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
  * rcu_node.  The reason for not just moving them to the immediate
  * parent is to remove the need for rcu_read_unlock_special() to
  * make more than two attempts to acquire the target rcu_node's lock.
+ * Returns true if there were tasks blocking the current RCU grace
+ * period.
  *
  * Returns 1 if there was previously a task blocking the current grace
  * period on the specified rcu_node structure.
@@ -316,7 +343,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
-	int retval = rcu_preempted_readers(rnp);
+	int retval;
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
 	struct task_struct *tp;
 
@@ -334,6 +361,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * rcu_nodes in terms of gp_num value.  This fact allows us to
 	 * move the blocked_tasks[] array directly, element by element.
 	 */
+	retval = rcu_preempted_readers(rnp);
 	for (i = 0; i < 2; i++) {
 		lp = &rnp->blocked_tasks[i];
 		lp_root = &rnp_root->blocked_tasks[i];
@@ -346,7 +374,6 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
 		}
 	}
-
 	return retval;
 }
 
@@ -512,6 +539,16 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/* Because preemptible RCU does not exist, no quieting of tasks. */
+static void task_quiet(struct rcu_node *rnp, unsigned long flags)
+{
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
-- 
1.5.2.5

