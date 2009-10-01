Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZJAIQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZJAIQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZJAIQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:16:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:38370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbZJAIKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:19 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/19] scheduler: implement sched_class_equal()
Date: Thu,  1 Oct 2009 17:09:01 +0900
Message-Id: <1254384558-1018-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->identity to sched_class and implement and use
sched_class_equal() which compares the field to test for equality.
This is to allow sub-classing scheduler classes so that part of it can
be overridden while maintaining most of the original behavior.  Please
note that __setscheduler() only switches sched_class if the new
sched_class's identity different from the current one.

NOT_SIGNED_OFF_YET
---
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   16 +++++++++++-----
 kernel/sched_fair.c     |    5 +++--
 kernel/sched_idletask.c |    1 +
 kernel/sched_rt.c       |    1 +
 5 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..02f505d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1065,6 +1065,7 @@ struct sched_domain;
 
 struct sched_class {
 	const struct sched_class *next;
+	const struct sched_class *identity;
 
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
diff --git a/kernel/sched.c b/kernel/sched.c
index ee61f45..66d918a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1813,6 +1813,8 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 
 static void calc_load_account_active(struct rq *this_rq);
 
+#define sched_class_equal(a, b)		((a)->identity == (b)->identity)
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -1987,7 +1989,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
 				       int oldprio, int running)
 {
-	if (prev_class != p->sched_class) {
+	if (!sched_class_equal(prev_class, p->sched_class)) {
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p, running);
 		p->sched_class->switched_to(rq, p, running);
@@ -2012,7 +2014,7 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
 
-	if (p->sched_class != &fair_sched_class)
+	if (!sched_class_equal(p->sched_class, &fair_sched_class))
 		return 0;
 
 	if (sysctl_sched_migration_cost == -1)
@@ -6139,6 +6141,8 @@ static struct task_struct *find_process_by_pid(pid_t pid)
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
+	const struct sched_class *new_class = NULL;
+
 	BUG_ON(p->se.on_rq);
 
 	p->policy = policy;
@@ -6146,13 +6150,15 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
-		p->sched_class = &fair_sched_class;
+		new_class = &fair_sched_class;
 		break;
 	case SCHED_FIFO:
 	case SCHED_RR:
-		p->sched_class = &rt_sched_class;
+		new_class = &rt_sched_class;
 		break;
 	}
+	if (!sched_class_equal(p->sched_class, new_class))
+		p->sched_class = new_class;
 
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
@@ -10384,7 +10390,7 @@ cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		return -EINVAL;
 #else
 	/* We don't support RT-tasks being in separate groups */
-	if (tsk->sched_class != &fair_sched_class)
+	if (!sched_class_equal(tsk->sched_class, &fair_sched_class))
 		return -EINVAL;
 #endif
 	return 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..a12d1bd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -961,7 +961,7 @@ static void hrtick_update(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 
-	if (curr->sched_class != &fair_sched_class)
+	if (!sched_class_equal(curr->sched_class, &fair_sched_class))
 		return;
 
 	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
@@ -1576,7 +1576,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 	}
 
-	if (unlikely(p->sched_class != &fair_sched_class))
+	if (unlikely(!sched_class_equal(p->sched_class, &fair_sched_class)))
 		return;
 
 	if (unlikely(se == pse))
@@ -1962,6 +1962,7 @@ unsigned int get_rr_interval_fair(struct task_struct *task)
  * All the scheduling class methods:
  */
 static const struct sched_class fair_sched_class = {
+	.identity		= &fair_sched_class,
 	.next			= &idle_sched_class,
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index b133a28..57a0c4b 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -106,6 +106,7 @@ unsigned int get_rr_interval_idle(struct task_struct *task)
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
 static const struct sched_class idle_sched_class = {
+	.identity		= &idle_sched_class,
 	/* .next is NULL */
 	/* no enqueue/yield_task for idle tasks */
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..06a8106 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1746,6 +1746,7 @@ unsigned int get_rr_interval_rt(struct task_struct *task)
 }
 
 static const struct sched_class rt_sched_class = {
+	.identity		= &rt_sched_class,
 	.next			= &fair_sched_class,
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
-- 
1.6.4.2

