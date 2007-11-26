Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbXKZEvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbXKZEvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 23:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXKZEuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 23:50:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43976 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbXKZEux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 23:50:53 -0500
Date: Mon, 26 Nov 2007 10:33:44 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [PATCH 2/4] sched: minor fixes for group scheduler
Message-ID: <20071126050344.GC5304@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126050044.GA5304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Minor bug fixes for group scheduler:

- Use a mutex to serialize add/remove of task groups and also when
  changing shares of a task group. Use the same mutex when printing cfs_rq
  stats for various task groups.
- Use list_for_each_entry_rcu in for_each_leaf_cfs_rq macro (when walking task 
  group list)


Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched.c      |   33 +++++++++++++++++++++++++--------
 kernel/sched_fair.c |    4 +++-
 2 files changed, 28 insertions(+), 9 deletions(-)

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
 
@@ -6747,7 +6762,6 @@ void __init sched_init(void)
 			se->parent = NULL;
 		}
 		init_task_group.shares = init_task_group_load;
-		spin_lock_init(&init_task_group.lock);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -6987,14 +7001,15 @@ struct task_group *sched_create_group(vo
 		se->parent = NULL;
 	}
 
+	tg->shares = NICE_0_LOAD;
+
+	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 		cfs_rq = tg->cfs_rq[i];
 		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 	}
-
-	tg->shares = NICE_0_LOAD;
-	spin_lock_init(&tg->lock);
+	unlock_task_group_list();
 
 	return tg;
 
@@ -7040,10 +7055,12 @@ void sched_destroy_group(struct task_gro
 	struct cfs_rq *cfs_rq = NULL;
 	int i;
 
+	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		cfs_rq = tg->cfs_rq[i];
 		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
 	}
+	unlock_task_group_list();
 
 	BUG_ON(!cfs_rq);
 
@@ -7117,7 +7134,7 @@ int sched_group_set_shares(struct task_g
 {
 	int i;
 
-	spin_lock(&tg->lock);
+	lock_task_group_list();
 	if (tg->shares == shares)
 		goto done;
 
@@ -7126,7 +7143,7 @@ int sched_group_set_shares(struct task_g
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
@@ -1126,7 +1126,9 @@ static void print_cfs_stats(struct seq_f
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_rq(m, cpu, &cpu_rq(cpu)->cfs);
 #endif
+	lock_task_group_list();
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
+	unlock_task_group_list();
 }
 #endif

-- 
Regards,
vatsa
