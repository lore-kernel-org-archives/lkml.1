Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbXIRT4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbXIRT4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbXIRT4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:56:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:48347 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbXIRT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sKn679VQDUQeT0KYMBBa3vVUrhao8qKEtMZb5n/veU0tXqrSlaOdFSpMQJ8OQWBnl+FsjZA2TkBI2lw+qugFjw/BDOy2KBQs7RPxmZvJpQ4XsAT5Jab05OwUFet+9oqiqvab4aGdXHIpVCobcaGPtsI2AdsqYqB2pN9xeIRoTRg=
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 21:56:30 +0200
Message-Id: <1190145390.5204.41.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(3)

rework enqueue/dequeue_entity() to get rid of sched_class::set_curr_task().
This simplifies sched_setscheduler(), rt_mutex_setprio() and sched_move_tasks().

Signed-off-by : Dmitry Adamushko <dmitry.adamushko@gmail.com>
Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3728cd6..1094804 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -870,7 +870,6 @@ struct sched_class {
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *all_pinned, int *this_best_prio);
 
-	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index 361fad8..bc1a625 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3910,8 +3910,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	int oldprio, on_rq, running;
 	unsigned long flags;
+	int oldprio, on_rq;
 	struct rq *rq;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
@@ -3921,12 +3921,8 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	oldprio = p->prio;
 	on_rq = p->se.on_rq;
-	running = task_running(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
 
 	if (rt_prio(prio))
 		p->sched_class = &rt_sched_class;
@@ -3936,15 +3932,13 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	p->prio = prio;
 
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
 		enqueue_task(rq, p, 0);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
 		 * our priority decreased, or if we are not currently running on
 		 * this runqueue and our priority is higher than the current's
 		 */
-		if (running) {
+		if (task_running(rq, p)) {
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
 		} else {
@@ -4150,7 +4144,7 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 int sched_setscheduler(struct task_struct *p, int policy,
 		       struct sched_param *param)
 {
-	int retval, oldprio, oldpolicy = -1, on_rq, running;
+	int retval, oldprio, oldpolicy = -1, on_rq;
 	unsigned long flags;
 	struct rq *rq;
 
@@ -4232,24 +4226,20 @@ recheck:
 	}
 	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
-	running = task_running(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		deactivate_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
+
 	oldprio = p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
+
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
 		activate_task(rq, p, 0);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
 		 * our priority decreased, or if we are not currently running on
 		 * this runqueue and our priority is higher than the current's
 		 */
-		if (running) {
+		if (task_running(rq, p)) {
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
 		} else {
@@ -6853,19 +6843,13 @@ static void sched_move_task(struct container_subsys *ss, struct container *cont,
 	running = task_running(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, tsk, 0);
-		if (unlikely(running))
-			tsk->sched_class->put_prev_task(rq, tsk);
-	}
 
 	set_task_cfs_rq(tsk);
 
-	if (on_rq) {
-		if (unlikely(running))
-			tsk->sched_class->set_curr_task(rq);
+	if (on_rq)
 		enqueue_task(rq, tsk, 0);
-	}
 
 done:
 	task_rq_unlock(rq, &flags);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e65af8c..6539377 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -475,9 +475,20 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 }
 
 static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+		int wakeup, int set_curr)
 {
 	/*
+ 	 * In case of the 'current'.
+ 	 */
+	if (unlikely(set_curr)) {
+		update_stats_curr_start(cfs_rq, se);
+		cfs_rq->curr = se;
+		account_entity_enqueue(cfs_rq, se);
+		return;
+	}
+
+	/*
 	 * Update the fair clock.
 	 */
 	update_curr(cfs_rq);
@@ -488,8 +499,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 	}
 
 	update_stats_enqueue(cfs_rq, se);
-	if (se != cfs_rq->curr)
-		__enqueue_entity(cfs_rq, se);
+	__enqueue_entity(cfs_rq, se);
 	account_entity_enqueue(cfs_rq, se);
 }
 
@@ -509,8 +519,12 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 		}
 	}
 #endif
-	if (se != cfs_rq->curr)
+	if (likely(se != cfs_rq->curr))
 		__dequeue_entity(cfs_rq, se);
+	else {
+		update_stats_curr_end(cfs_rq, se);
+		cfs_rq->curr = NULL;
+	}
 	account_entity_dequeue(cfs_rq, se);
 }
 
@@ -692,12 +706,17 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int set_curr = 0;
+
+	/* Are we enqueuing the current task? */
+	if (unlikely(task_running(rq, p)))
+		set_curr = 1;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, wakeup);
+		enqueue_entity(cfs_rq, se, wakeup, set_curr);
 	}
 }
 
@@ -983,29 +1002,6 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 	resched_task(rq->curr);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-/* Account for a task changing its policy or group.
- *
- * This routine is mostly called to set cfs_rq->curr field when a task
- * migrates between groups/classes.
- */
-static void set_curr_task_fair(struct rq *rq)
-{
-	struct sched_entity *se = &rq->curr->se;
-
-	for_each_sched_entity(se)
-		set_next_entity(cfs_rq_of(se), se);
-}
-#else
-static void set_curr_task_fair(struct rq *rq)
-{
-	struct sched_entity *se = &rq->curr->se;
-	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-
-	cfs_rq->curr = se;
-}
-#endif
-
 /*
  * All the scheduling class methods:
  */
@@ -1021,7 +1017,6 @@ struct sched_class fair_sched_class __read_mostly = {
 
 	.load_balance		= load_balance_fair,
 
-	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
 	.task_new		= task_new_fair,
 };
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 5ebf829..3503fb2 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -50,10 +50,6 @@ static void task_tick_idle(struct rq *rq, struct task_struct *curr)
 {
 }
 
-static void set_curr_task_idle(struct rq *rq)
-{
-}
-
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
@@ -70,7 +66,6 @@ static struct sched_class idle_sched_class __read_mostly = {
 
 	.load_balance		= load_balance_idle,
 
-	.set_curr_task          = set_curr_task_idle,
 	.task_tick		= task_tick_idle,
 	/* no .task_new for idle tasks */
 };
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b86944c..3c77c03 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -218,10 +218,6 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p)
 	}
 }
 
-static void set_curr_task_rt(struct rq *rq)
-{
-}
-
 static struct sched_class rt_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
@@ -234,6 +230,5 @@ static struct sched_class rt_sched_class __read_mostly = {
 
 	.load_balance		= load_balance_rt,
 
-	.set_curr_task          = set_curr_task_rt,
 	.task_tick		= task_tick_rt,
 };

---

Dmitry


