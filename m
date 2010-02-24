Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0BXUEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:04:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab0BXUEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:04:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 10/10] scheduler: __rcu annotations
Date: Wed, 24 Feb 2010 21:04:06 +0100
Message-Id: <1267041846-10469-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX1/l16N2dzM8MSCt+xIBFaNes4dDH85f07xyhFG
 E5BtHG75MRTh1ytuy7YnlEsjTq7xWZ5doCjrI5gLa6qRkh+kMB
 wQZKS9LJMJ6JRyGCLymeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/fdtable.h |    2 +-
 include/linux/sched.h   |    6 +++---
 kernel/exit.c           |   12 ++++++------
 kernel/fork.c           |    2 +-
 kernel/sched.c          |   31 ++++++++++++++++---------------
 5 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index a2ec74b..552a114 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -45,7 +45,7 @@ struct files_struct {
    * read mostly part
    */
 	atomic_t count;
-	struct fdtable *fdt;
+	struct fdtable __rcu *fdt;
 	struct fdtable fdtab;
   /*
    * written part on a separate cache line in SMP
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f14d925..6aa50e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1282,7 +1282,7 @@ struct task_struct {
 	struct sched_info sched_info;
 #endif
 
-	struct list_head tasks;
+	struct rcu_list_head tasks;
 	struct plist_node pushable_tasks;
 
 	struct mm_struct *mm, *active_mm;
@@ -1340,7 +1340,7 @@ struct task_struct {
 
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
-	struct list_head thread_group;
+	struct rcu_list_head thread_group;
 
 	struct completion *vfork_done;		/* for vfork() */
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
@@ -2240,7 +2240,7 @@ static inline struct task_struct *next_thread(const struct task_struct *p)
 
 static inline int thread_group_empty(struct task_struct *p)
 {
-	return list_empty(&p->thread_group);
+	return list_empty_rcu(&p->thread_group);
 }
 
 #define delay_group_leader(p) \
diff --git a/kernel/exit.c b/kernel/exit.c
index 546774a..6d9bbf1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -85,7 +85,7 @@ static void __exit_signal(struct task_struct *tsk)
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
 
-	sighand = rcu_dereference(tsk->sighand);
+	sighand = tsk->sighand;
 	spin_lock(&sighand->siglock);
 
 	posix_cpu_timers_exit(tsk);
@@ -1180,18 +1180,18 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
-		int why, status;
+		int why, __status;
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
-			status = exit_code >> 8;
+			__status = exit_code >> 8;
 		} else {
 			why = (exit_code & 0x80) ? CLD_DUMPED : CLD_KILLED;
-			status = exit_code & 0x7f;
+			__status = exit_code & 0x7f;
 		}
-		return wait_noreap_copyout(wo, p, pid, uid, why, status);
+		return wait_noreap_copyout(wo, p, pid, uid, why, __status);
 	}
 
 	/*
@@ -1616,7 +1616,7 @@ repeat:
 	 */
 	wo->notask_error = -ECHILD;
 	if ((wo->wo_type < PIDTYPE_MAX) &&
-	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
+	   (!wo->wo_pid || hlist_empty_rcu(&wo->wo_pid->tasks[wo->wo_type])))
 		goto notask;
 
 	set_current_state(TASK_INTERRUPTIBLE);
diff --git a/kernel/fork.c b/kernel/fork.c
index ba7489b..7a3bf5b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1230,7 +1230,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * We dont wake it up yet.
 	 */
 	p->group_leader = p;
-	INIT_LIST_HEAD(&p->thread_group);
+	INIT_LIST_HEAD_RCU(&p->thread_group);
 
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..7eff482 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -52,6 +52,7 @@
 #include <linux/threads.h>
 #include <linux/timer.h>
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/percpu.h>
@@ -239,7 +240,7 @@ static DEFINE_MUTEX(sched_domains_mutex);
 
 struct cfs_rq;
 
-static LIST_HEAD(task_groups);
+static LIST_HEAD_RCU(task_groups);
 
 /* task group related information */
 struct task_group {
@@ -267,11 +268,11 @@ struct task_group {
 #endif
 
 	struct rcu_head rcu;
-	struct list_head list;
+	struct rcu_list_head list;
 
 	struct task_group *parent;
-	struct list_head siblings;
-	struct list_head children;
+	struct rcu_list_head siblings;
+	struct rcu_list_head children;
 };
 
 #ifdef CONFIG_USER_SCHED
@@ -418,7 +419,7 @@ struct cfs_rq {
 	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
 	 * list is used during load balance.
 	 */
-	struct list_head leaf_cfs_rq_list;
+	struct rcu_list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
 #ifdef CONFIG_SMP
@@ -476,7 +477,7 @@ struct rt_rq {
 	unsigned long rt_nr_boosted;
 
 	struct rq *rq;
-	struct list_head leaf_rt_rq_list;
+	struct rcu_list_head leaf_rt_rq_list;
 	struct task_group *tg;
 	struct sched_rt_entity *rt_se;
 #endif
@@ -547,10 +548,10 @@ struct rq {
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
-	struct list_head leaf_cfs_rq_list;
+	struct rcu_list_head leaf_cfs_rq_list;
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
-	struct list_head leaf_rt_rq_list;
+	struct rcu_list_head leaf_rt_rq_list;
 #endif
 
 	/*
@@ -9423,7 +9424,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
 	if (add)
-		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 
 	tg->se[cpu] = se;
 	/* se could be NULL for init_task_group */
@@ -9455,7 +9456,7 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	rt_rq->rt_se = rt_se;
 	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 	if (add)
-		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
+		list_add_rcu(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
 	tg->rt_se[cpu] = rt_se;
 	if (!rt_se)
@@ -9547,8 +9548,8 @@ void __init sched_init(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_GROUP_SCHED
-	list_add(&init_task_group.list, &task_groups);
-	INIT_LIST_HEAD(&init_task_group.children);
+	list_add_rcu(&init_task_group.list, &task_groups);
+	INIT_LIST_HEAD_RCU(&init_task_group.children);
 
 #ifdef CONFIG_USER_SCHED
 	INIT_LIST_HEAD(&root_task_group.children);
@@ -9573,7 +9574,7 @@ void __init sched_init(void)
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares = init_task_group_load;
-		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
+		INIT_LIST_HEAD_RCU(&rq->leaf_cfs_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
 		/*
 		 * How much cpu bandwidth does init_task_group get?
@@ -9619,7 +9620,7 @@ void __init sched_init(void)
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
-		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
+		INIT_LIST_HEAD_RCU(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
 		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
 #elif defined CONFIG_USER_SCHED
@@ -10058,7 +10059,7 @@ struct task_group *sched_create_group(struct task_group *parent)
 	WARN_ON(!parent); /* root should already exist */
 
 	tg->parent = parent;
-	INIT_LIST_HEAD(&tg->children);
+	INIT_LIST_HEAD_RCU(&tg->children);
 	list_add_rcu(&tg->siblings, &parent->children);
 	spin_unlock_irqrestore(&task_group_lock, flags);
 
-- 
1.6.3.3

