Return-Path: <linux-kernel-owner+w=401wt.eu-S935219AbZLPSlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219AbZLPSlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935165AbZLPSlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:41:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:53531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935219AbZLPSjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:39:43 -0500
Date: Wed, 16 Dec 2009 18:38:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170518.114746117@chello.nl>
References: <20091216170518.114746117@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Add pre and post wakeup hooks
Message-ID: <tip-efbbd05a595343a413964ad85a2ad359b7b7efbd@git.kernel.org>
Git-Commit-ID: efbbd05a595343a413964ad85a2ad359b7b7efbd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efbbd05a595343a413964ad85a2ad359b7b7efbd
Gitweb:     http://git.kernel.org/tip/efbbd05a595343a413964ad85a2ad359b7b7efbd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:58 +0100

sched: Add pre and post wakeup hooks

As will be apparent in the next patch, we need a pre wakeup hook
for sched_fair task migration, hence rename the post wakeup hook
and one pre wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170518.114746117@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   12 ++++++++----
 kernel/sched_rt.c     |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c858f3..2c9fa1c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1091,7 +1091,8 @@ struct sched_class {
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const struct cpumask *newmask);
diff --git a/kernel/sched.c b/kernel/sched.c
index 297dc44..6c571bd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2412,6 +2412,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
+
+	if (p->sched_class->task_waking)
+		p->sched_class->task_waking(rq, p);
+
 	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
@@ -2475,8 +2479,8 @@ out_running:
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
 
 	if (unlikely(rq->idle_stamp)) {
 		u64 delta = rq->clock - rq->idle_stamp;
@@ -2666,8 +2670,8 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
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
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d2ea282..f48328a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1472,7 +1472,7 @@ static void post_schedule_rt(struct rq *rq)
  * If we are not running and we are not going to reschedule soon, we should
  * try to push tasks away now
  */
-static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
+static void task_woken_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
@@ -1753,7 +1753,7 @@ static const struct sched_class rt_sched_class = {
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
-	.task_wake_up		= task_wake_up_rt,
+	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
 #endif
 
