Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbZLPRGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbZLPRGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZLPRGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:53816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbZLPRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:16 -0500
Message-Id: <20091216170518.114746117@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/12] sched: Add pre and post wakeup hooks
Content-Disposition: inline; filename=foo0.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As will be apparent in the next patch, we need a pre wakeup hook for
sched_fair task migration, hence rename the post wakeup hook and one pre
wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   12 ++++++++----
 kernel/sched_rt.c     |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1091,7 +1091,8 @@ struct sched_class {
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const struct cpumask *newmask);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2380,6 +2380,10 @@ static int try_to_wake_up(struct task_st
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
+
+	if (p->sched_class->task_waking)
+		p->sched_class->task_waking(rq, p);
+
 	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
@@ -2443,8 +2447,8 @@ out_running:
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
 
 	if (unlikely(rq->idle_stamp)) {
 		u64 delta = rq->clock - rq->idle_stamp;
@@ -2636,8 +2640,8 @@ void wake_up_new_task(struct task_struct
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1472,7 +1472,7 @@ static void post_schedule_rt(struct rq *
  * If we are not running and we are not going to reschedule soon, we should
  * try to push tasks away now
  */
-static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
+static void task_woken_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
@@ -1753,7 +1753,7 @@ static const struct sched_class rt_sched
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
-	.task_wake_up		= task_wake_up_rt,
+	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
 #endif
 

-- 

