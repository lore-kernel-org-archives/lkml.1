Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZHYSWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZHYSWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZHYSWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:22:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54041 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbZHYSWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:22:05 -0400
Date: Tue, 25 Aug 2009 11:22:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH -tip] Create rcutree plugins to handle hotplug CPU for
	multi-level trees
Message-ID: <20090825182204.GA26736@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When offlining CPUs from a multi-level tree, there is the possibility
of offlining the last CPU from a given node when there are preempted
RCU read-side critical sections that started life on one of the CPUs on
that node.  In this case, the corresponding tasks will be enqueued via
the task_struct's rcu_node_entry list_head onto one of the rcu_node's
blocked_tasks[] lists.  These tasks need to be moved somewhere else
so that they will prevent the current grace period from ending.
That somewhere is the root rcu_node.

With this patch, TREE_PREEMPT_RCU passes moderate rcutorture testing
with aggressive CPU-hotplugging (no delay between inserting/removing
randomly selected CPU).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/init_task.h |    2 -
 include/linux/sched.h     |    4 +-
 kernel/rcutree.c          |    2 +
 kernel/rcutree_plugin.h   |   69 ++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 79d4bae..9e7f2e8 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -98,7 +98,7 @@ extern struct group_info init_groups;
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
-	.rcu_blocked_cpu = -1,						\
+	.rcu_blocked_node = NULL,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index bfca26d..3fe0315 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1208,7 +1208,7 @@ struct task_struct {
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
-	int rcu_blocked_cpu;
+	void *rcu_blocked_node;
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
@@ -1735,7 +1735,7 @@ static inline void rcu_copy_process(struct task_struct *p)
 {
 	p->rcu_read_lock_nesting = 0;
 	p->rcu_read_unlock_special = 0;
-	p->rcu_blocked_cpu = -1;
+	p->rcu_blocked_node = NULL;
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index fee6316..d903e2f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -81,6 +81,7 @@ struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 extern long rcu_batches_completed_sched(void);
+static struct rcu_node *rcu_get_root(struct rcu_state *rsp);
 static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
 			  struct rcu_node *rnp, unsigned long flags);
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
@@ -876,6 +877,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
+		rcu_preempt_offline_tasks(rsp, rnp);
 		mask = rnp->grpmask;
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 201334c..04343be 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -92,7 +92,7 @@ static void rcu_preempt_qs(int cpu)
 		rnp = rdp->mynode;
 		spin_lock(&rnp->lock);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
-		t->rcu_blocked_cpu = cpu;
+		t->rcu_blocked_node = (void *)rnp;
 
 		/*
 		 * If this CPU has already checked in, then this task
@@ -170,12 +170,21 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
 
-		/* Remove this task from the list it blocked on. */
-		rnp = rcu_preempt_state.rda[t->rcu_blocked_cpu]->mynode;
-		spin_lock(&rnp->lock);
+		/*
+		 * Remove this task from the list it blocked on.  The
+		 * task can migrate while we acquire the lock, but at
+		 * most one time.  So at most two passes through loop.
+		 */
+		for (;;) {
+			rnp = (struct rcu_node *)t->rcu_blocked_node;
+			spin_lock(&rnp->lock);
+			if (rnp == (struct rcu_node *)t->rcu_blocked_node)
+				break;
+			spin_unlock(&rnp->lock);
+		}
 		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
 		list_del_init(&t->rcu_node_entry);
-		t->rcu_blocked_cpu = -1;
+		t->rcu_blocked_node = NULL;
 
 		/*
 		 * If this was the last task on the current list, and if
@@ -262,6 +271,47 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
+ * Handle tasklist migration for case in which all CPUs covered by the
+ * specified rcu_node have gone offline.  Move them up to the root
+ * rcu_node.  The reason for not just moving them to the immediate
+ * parent is to remove the need for rcu_read_unlock_special() to
+ * make more than two attempts to acquire the target rcu_node's lock.
+ *
+ * The caller must hold rnp->lock with irqs disabled.
+ */
+static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				      struct rcu_node *rnp)
+{
+	int i;
+	struct list_head *lp;
+	struct list_head *lp_root;
+	struct rcu_node *rnp_root = rcu_get_root(rsp);
+	struct task_struct *tp;
+
+	if (rnp == rnp_root)
+		return;  /* Shouldn't happen: at least one CPU online. */
+
+	/*
+	 * Move tasks up to root rcu_node.  Rely on the fact that the
+	 * root rcu_node can be at most one ahead of the rest of the
+	 * rcu_nodes in terms of gp_num value.  This fact allows us to
+	 * move the blocked_tasks[] array directly, element by element.
+	 */
+	for (i = 0; i < 2; i++) {
+		lp = &rnp->blocked_tasks[i];
+		lp_root = &rnp_root->blocked_tasks[i];
+		while (!list_empty(lp)) {
+			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
+			spin_lock(&rnp_root->lock); /* irqs already disabled */
+			list_del(&tp->rcu_node_entry);
+			tp->rcu_blocked_node = rnp_root;
+			list_add(&tp->rcu_node_entry, lp_root);
+			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
+		}
+	}
+}
+
+/*
  * Do CPU-offline processing for preemptable RCU.
  */
 static void rcu_preempt_offline_cpu(int cpu)
@@ -410,6 +460,15 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
+ * Because preemptable RCU does not exist, it never needs to migrate
+ * tasks that were blocked within RCU read-side critical sections.
+ */
+static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				      struct rcu_node *rnp)
+{
+}
+
+/*
  * Because preemptable RCU does not exist, it never needs CPU-offline
  * processing.
  */
