Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYITVic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYITVic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYITViY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:38:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:51021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:38:23 -0400
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1220518266.9590.22.camel@minggr>
References: <1220518266.9590.22.camel@minggr>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 23:38:02 +0200
Message-Id: <1221946683.19227.4.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> ------- Comment #4 from ming.m.lin@intel.com  2008-09-17 17:55 -------
> sched_switch trace of oltp in 2.6.27-rc4
> http://myfreefilehosting.com/f/fc6c8eaacf_1.31MB
> 
> sched_switch trace of oltp in 2.6.27-rc5
> http://myfreefilehosting.com/f/a2f9aea1b0_0.42MB
> 
> Compared the 2 trace files, you can find that (at most time),
> with 2.6.27-rc5, mysql switches to sysbench when it's going to sleep
>           mysqld-3791  [07]   151.421836:   3791:120:R   +  3803:120:S
>           mysqld-3791  [07]   151.421876:   3791:120:S ==>  3803:120:R
>         sysbench-3803  [07]   151.421878:   3803:120:R   +  3791:120:S
>         sysbench-3803  [07]   151.421887:   3803:120:S ==>  3791:120:R
> 
> with 2.6.27-rc4, mysql switches to sysbench when it's still running
>           mysqld-3674  [07]    95.960220:   3674:120:R   +  3687:120:S
>           mysqld-3674  [07]    95.960220:   3674:120:R ==>  3687:120:R
>         sysbench-3687  [07]    95.960220:   3687:120:S ==>  3674:120:R
> 
> So with 2.6.27-rc5, sysbench wakes up mysql and then switches to it (mysql is
> in sleep state)
> 
> With 2.6.27-rc4, sysbench switches to mysql, no need to wake up it (mysql is
> still in running state)

Ming, how does this work for you?

---
Subject: sched: wakeup preempt when small overlap

Aggresively preempt a task if its avg overlap is very small, this should
avoid the task going to sleep and find it still running when we schedule
back to it - saving a wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7b4592c..cb44774 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -897,7 +897,7 @@ struct sched_class {
 	void (*yield_task) (struct rq *rq);
 	int  (*select_task_rq)(struct task_struct *p, int sync);
 
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
 
 	struct task_struct * (*pick_next_task) (struct rq *rq);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 32d56d6..e17d506 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -609,9 +609,9 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
+static inline void check_preempt_curr(struct rq *rq, struct task_struct *p, int sync)
 {
-	rq->curr->sched_class->check_preempt_curr(rq, p);
+	rq->curr->sched_class->check_preempt_curr(rq, p, sync);
 }
 
 static inline int cpu_of(struct rq *rq)
@@ -2299,7 +2299,7 @@ out_activate:
 
 out_running:
 	trace_sched_wakeup(rq, p);
-	check_preempt_curr(rq, p);
+	check_preempt_curr(rq, p, sync);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -2432,7 +2432,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		inc_nr_running(rq);
 	}
 	trace_sched_wakeup_new(rq, p);
-	check_preempt_curr(rq, p);
+	check_preempt_curr(rq, p, 0);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
@@ -2889,7 +2889,7 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	 * Note that idle threads have a prio of MAX_PRIO, for this test
 	 * to be always true for them.
 	 */
-	check_preempt_curr(this_rq, p);
+	check_preempt_curr(this_rq, p, 0);
 }
 
 /*
@@ -6015,7 +6015,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	set_task_cpu(p, dest_cpu);
 	if (on_rq) {
 		activate_task(rq_dest, p, 0);
-		check_preempt_curr(rq_dest, p);
+		check_preempt_curr(rq_dest, p, 0);
 	}
 done:
 	ret = 1;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a10ac0b..82a907c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1331,7 +1331,7 @@ static inline int depth_se(struct sched_entity *se)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
+static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 {
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
@@ -1348,6 +1348,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	if (unlikely(se == pse))
 		return;
 
+	cfs_rq_of(pse)->next = pse;
+
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
 	 * wake up path.
@@ -1355,8 +1357,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	if (test_tsk_need_resched(curr))
 		return;
 
-	cfs_rq_of(pse)->next = pse;
-
 	/*
 	 * Batch tasks do not preempt (their preemption is driven by
 	 * the tick):
@@ -1367,6 +1367,13 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	if (sched_feat(WAKEUP_OVERLAP) && sync && 
+			se->avg_overlap < sysctl_sched_migration_cost &&
+			pse->avg_overlap < sysctl_sched_migration_cost) {
+		resched_task(curr);
+		return;
+	}
+
 	/*
 	 * preemption test can be made between sibling entities who are in the
 	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
@@ -1649,7 +1656,7 @@ static void prio_changed_fair(struct rq *rq, struct task_struct *p,
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /*
@@ -1666,7 +1673,7 @@ static void switched_to_fair(struct rq *rq, struct task_struct *p,
 	if (running)
 		resched_task(rq->curr);
 	else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /* Account for a task changing its policy or group.
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 9353ca7..bf027a7 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -11,3 +11,4 @@ SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
+SCHED_FEAT(WAKEUP_OVERLAP, 1)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 3a4f92d..dec4cca 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -14,7 +14,7 @@ static int select_task_rq_idle(struct task_struct *p, int sync)
 /*
  * Idle tasks are unconditionally rescheduled:
  */
-static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int sync)
 {
 	resched_task(rq->idle);
 }
@@ -76,7 +76,7 @@ static void switched_to_idle(struct rq *rq, struct task_struct *p,
 	if (running)
 		resched_task(rq->curr);
 	else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 static void prio_changed_idle(struct rq *rq, struct task_struct *p,
@@ -93,7 +93,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 04875ef..2e228bd 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -787,7 +787,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int sync)
 {
 	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);


