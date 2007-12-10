Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbXLJDPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbXLJDPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXLJDPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:15:38 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:44481
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572AbXLJDPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:15:37 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RFC] sched: Fixed missed rt-balance points on priority shifts
To: dmitry.adamushko@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Sun, 09 Dec 2007 21:53:23 -0500
Message-ID: <20071210024709.4760.68134.stgit@novell1.haskins.net>
In-Reply-To: <475BEE6B.BA47.005A.0@novell.com>
References: <475BEE6B.BA47.005A.0@novell.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Steven, Dmitry,
   Here is a proposed fix for the issue that Dmitry brought up today.  It
   should apply cleanly to sched-devel (though I have a few of my other
   submitted fixes queued ahead of this that are not yet in sched-devel...so if
   you have a problem let me know and I will rebase/resubmit)

Regards,
-Greg

--------------------------
sched: Fixed missed rt-balance points on priority shifts

Dmitry Adamushko identified several holes in the rt-migration stategy relating
to changing priority via sched_setscheduler or rt_mutex_setprio:

http://lkml.org/lkml/2007/12/9/94

This patch should button up those conditions.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
---

 kernel/sched.c    |    8 ++++++++
 kernel/sched_rt.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 02f04bc..fd08ac2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -348,6 +348,7 @@ struct rt_rq {
 	/* highest queued rt task prio */
 	int highest_prio;
 	int overloaded;
+	int needs_pull;
 };
 
 #ifdef CONFIG_SMP
@@ -4037,6 +4038,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 			check_preempt_curr(rq, p);
 		}
 	}
+
+	wakeup_balance_rt(rq, p);
+
 	task_rq_unlock(rq, &flags);
 }
 
@@ -4341,6 +4345,9 @@ recheck:
 			check_preempt_curr(rq, p);
 		}
 	}
+
+	wakeup_balance_rt(rq, p);
+
 	__task_rq_unlock(rq);
 	spin_unlock_irqrestore(&p->pi_lock, flags);
 
@@ -6887,6 +6894,7 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
 		rq->rt.overloaded = 0;
+		rq->rt.needs_pull = 0;
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 65cbb78..1257575 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -84,6 +84,8 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 
 static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 {
+	int highest_prio = rq->rt.highest_prio;
+
 	WARN_ON(!rt_task(p));
 	WARN_ON(!rq->rt.rt_nr_running);
 	rq->rt.rt_nr_running--;
@@ -103,6 +105,42 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 	if (p->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory--;
 
+	if (rq->rt.highest_prio > highest_prio) {
+		/*
+		 * If the departing task is reducing our priority, we need to
+		 * check if we should pull tasks because its always possible
+		 * that another RQ tried to push tasks away but skipped us due
+		 * to elevated priority.  That elevated priority is now
+		 * subsiding so there may be tasks that are newly eligible for
+		 * migration.  This pull operation is currently facilitated
+		 * via schedule().
+		 */
+		rq->rt.needs_pull = 1;
+
+		/*
+		 * FIXME: I am not sure about this next part:
+		 *
+		 * If the departing task is already running, we dont need to be
+		 * specific about rescheduling because presumably it will
+		 * happen momentarily anyway.  However, if the departing task
+		 * was *not* the current task (#), we should invoke a
+		 * reschedule to make sure we have the optimal task running.
+		 *
+		 * (#) It may seem like a pathological condition to have the
+		 * highest priority task not also be the current task.  However
+		 * consider the condition where this highest task was enqueued
+		 * and subsequently dequeued before the RQ ever had a chance to
+		 * reschedule.
+		 *
+		 * I have no doubt that this is the proper thing to do to make
+		 * sure RT tasks are properly balanced.  What I cannot wrap my
+		 * head around at this late hour is if issuing a reschedule()
+		 * here may cause issues in other circumstances.  TBD
+		 */
+		if (!task_running(rq, p))
+			resched_task(rq->curr);
+	}
+
 	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
 }
@@ -662,8 +700,14 @@ static int pull_rt_task(struct rq *this_rq)
 static void schedule_balance_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio > prev->prio)
+	if (unlikely(rq->rt.needs_pull)) {
+		/*
+		 * Clear the flag first, since pulling may release the lock
+		 * and someone else may re-set the needs_pull
+		 */
+		rq->rt.needs_pull = 0;
 		pull_rt_task(rq);
+	}
 }
 
 static void schedule_tail_balance_rt(struct rq *rq)

