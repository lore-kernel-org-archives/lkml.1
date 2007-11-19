Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbXKSSNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbXKSSNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbXKSSNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:13:04 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49946 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbXKSSNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:13:01 -0500
Date: Mon, 19 Nov 2007 23:55:50 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [PATCH 1/2] sched: Fix minor bugs and coding style issues
Message-ID: <20071119182550.GB25404@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119182113.GA25404@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119182113.GA25404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix these minor bugs/coding-style issues:

- s/INIT_TASK_GRP_LOAD/INIT_TASK_GROUP_LOAD
- remove obsolete comment
- Use list_for_each_entry_rcu when walking task group list in
  for_each_leaf_cfs_rq() macro
- Serialize addition/removal of task groups from rq->leaf_cfs_rq_list
  by using a mutex(task_group_mutex). Use the same mutex in
  print_cfs_stats when walking the task group list.


Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 kernel/sched.c      |   55 +++++++++++++++++++++++++++++-----------------------
 kernel/sched_fair.c |    5 +++-
 2 files changed, 35 insertions(+), 25 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -169,8 +169,6 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
-	/* spinlock to serialize modification to shares */
-	spinlock_t lock;
 	struct rcu_head rcu;
 };
 
@@ -182,6 +180,11 @@ static DEFINE_PER_CPU(struct cfs_rq, ini
 static struct sched_entity *init_sched_entity_p[NR_CPUS];
 static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
 
+/* task_group_mutex serializes add/remove of task groups and also changes to
+ * a task group's cpu shares.
+ */
+static DEFINE_MUTEX(task_group_mutex);
+
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
@@ -191,12 +194,12 @@ struct task_group init_task_group = {
 };
 
 #ifdef CONFIG_FAIR_USER_SCHED
-# define INIT_TASK_GRP_LOAD	2*NICE_0_LOAD
+# define INIT_TASK_GROUP_LOAD	2*NICE_0_LOAD	/* root user's cpu share */
 #else
-# define INIT_TASK_GRP_LOAD	NICE_0_LOAD
+# define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
 
-static int init_task_group_load = INIT_TASK_GRP_LOAD;
+static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 
 /* return group to which a task belongs */
 static inline struct task_group *task_group(struct task_struct *p)
@@ -222,9 +225,21 @@ static inline void set_task_cfs_rq(struc
 	p->se.parent = task_group(p)->se[cpu];
 }
 
+static inline void lock_task_group_list(void)
+{
+	mutex_lock(&task_group_mutex);
+}
+
+static inline void unlock_task_group_list(void)
+{
+	mutex_unlock(&task_group_mutex);
+}
+
 #else
 
 static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu) { }
+static inline void lock_task_group_list(void) { }
+static inline void unlock_task_group_list(void) { }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
@@ -864,21 +879,6 @@ iter_move_one_task(struct rq *this_rq, i
 
 #define sched_class_highest (&rt_sched_class)
 
-/*
- * Update delta_exec, delta_fair fields for rq.
- *
- * delta_fair clock advances at a rate inversely proportional to
- * total load (rq->load.weight) on the runqueue, while
- * delta_exec advances at the same rate as wall-clock (provided
- * cpu is not idle).
- *
- * delta_exec / delta_fair is a measure of the (smoothened) load on this
- * runqueue over any given interval. This (smoothened) load is used
- * during load balance.
- *
- * This function is called /before/ updating rq->load
- * and when switching tasks.
- */
 static inline void inc_load(struct rq *rq, const struct task_struct *p)
 {
 	update_load_add(&rq->load, p->se.load.weight);
@@ -6762,7 +6762,6 @@ void __init sched_init(void)
 			se->parent = NULL;
 		}
 		init_task_group.shares = init_task_group_load;
-		spin_lock_init(&init_task_group.lock);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -7002,14 +7001,17 @@ struct task_group *sched_create_group(vo
 		se->parent = NULL;
 	}
 
+	lock_task_group_list();
+
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 		cfs_rq = tg->cfs_rq[i];
 		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 	}
 
+	unlock_task_group_list();
+
 	tg->shares = NICE_0_LOAD;
-	spin_lock_init(&tg->lock);
 
 	return tg;
 
@@ -7055,11 +7057,15 @@ void sched_destroy_group(struct task_gro
 	struct cfs_rq *cfs_rq = NULL;
 	int i;
 
+	lock_task_group_list();
+
 	for_each_possible_cpu(i) {
 		cfs_rq = tg->cfs_rq[i];
 		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
 	}
 
+	unlock_task_group_list();
+
 	BUG_ON(!cfs_rq);
 
 	/* wait for possible concurrent references to cfs_rqs complete */
@@ -7132,7 +7138,8 @@ int sched_group_set_shares(struct task_g
 {
 	int i;
 
-	spin_lock(&tg->lock);
+	lock_task_group_list();
+
 	if (tg->shares == shares)
 		goto done;
 
@@ -7141,7 +7148,7 @@ int sched_group_set_shares(struct task_g
 		set_se_shares(tg->se[i], shares);
 
 done:
-	spin_unlock(&tg->lock);
+	unlock_task_group_list();
 	return 0;
 }
 
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -685,7 +685,7 @@ static inline struct cfs_rq *cpu_cfs_rq(
 
 /* Iterate thr' all leaf cfs_rq's on a runqueue */
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
-	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
+	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
 
 /* Do the two (enqueued) entities belong to the same group ? */
 static inline int
@@ -1126,7 +1126,10 @@ static void print_cfs_stats(struct seq_f
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_rq(m, cpu, &cpu_rq(cpu)->cfs);
 #endif
+
+	lock_task_group_list();
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
+	unlock_task_group_list();
 }
 #endif

-- 
Regards,
vatsa
