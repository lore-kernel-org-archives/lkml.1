Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXKSMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXKSMPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbXKSMPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:15:38 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55126 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXKSMPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:15:37 -0500
Date: Mon, 19 Nov 2007 17:58:28 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: [PATCH 1/2] sched: Minor cleanups
Message-ID: <20071119122828.GB28777@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119122713.GA28777@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Minor scheduler cleanups:

- Fix coding style
- remove obsolete comment
- Use list_for_each_entry_rcu when walking task group list


Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched.c      |   21 +++------------------
 kernel/sched_fair.c |    5 ++++-
 2 files changed, 7 insertions(+), 19 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -191,12 +191,12 @@ struct task_group init_task_group = {
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
@@ -864,21 +864,6 @@ iter_move_one_task(struct rq *this_rq, i
 
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
+	rcu_read_lock();
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
+	rcu_read_unlock();
 }
 #endif

-- 
Regards,
vatsa
