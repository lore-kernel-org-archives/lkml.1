Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbZLIJzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbZLIJzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZLIJzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:55:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:45189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbZLIJzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:55:35 -0500
Date: Wed, 9 Dec 2009 09:55:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Discard some old bits
Message-ID: <tip-6cecd084d0fd27bb1e498e2829fd45846d806856@git.kernel.org>
Git-Commit-ID: 6cecd084d0fd27bb1e498e2829fd45846d806856
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6cecd084d0fd27bb1e498e2829fd45846d806856
Gitweb:     http://git.kernel.org/tip/6cecd084d0fd27bb1e498e2829fd45846d806856
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Nov 2009 13:00:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:07 +0100

sched: Discard some old bits

WAKEUP_RUNNING was an experiment, not sure why that ever ended up being
merged...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    2 --
 kernel/sched.c          |   17 +++++++----------
 kernel/sched_debug.c    |    1 -
 kernel/sched_fair.c     |    3 ---
 kernel/sched_features.h |    5 -----
 5 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 31d9dec..4b1ebd3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1152,8 +1152,6 @@ struct sched_entity {
 	u64			start_runtime;
 	u64			avg_wakeup;
 
-	u64			avg_running;
-
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
diff --git a/kernel/sched.c b/kernel/sched.c
index 33c9035..0170735 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2493,7 +2493,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_overlap		= 0;
 	p->se.start_runtime		= 0;
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
-	p->se.avg_running		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start			= 0;
@@ -5379,13 +5378,14 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *p)
+static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
+	if (prev->state == TASK_RUNNING) {
+		u64 runtime = prev->se.sum_exec_runtime;
 
-	update_avg(&p->se.avg_running, runtime);
+		runtime -= prev->se.prev_sum_exec_runtime;
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
 
-	if (p->state == TASK_RUNNING) {
 		/*
 		 * In order to avoid avg_overlap growing stale when we are
 		 * indeed overlapping and hence not getting put to sleep, grow
@@ -5395,12 +5395,9 @@ static void put_prev_task(struct rq *rq, struct task_struct *p)
 		 * correlates to the amount of cache footprint a task can
 		 * build up.
 		 */
-		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
-		update_avg(&p->se.avg_overlap, runtime);
-	} else {
-		update_avg(&p->se.avg_running, 0);
+		update_avg(&prev->se.avg_overlap, runtime);
 	}
-	p->sched_class->put_prev_task(rq, p);
+	prev->sched_class->put_prev_task(rq, prev);
 }
 
 /*
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 6988cf0..5fda666 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -399,7 +399,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
 	PN(se.avg_wakeup);
-	PN(se.avg_running);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 76b5792..e9f5dae 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1689,9 +1689,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 			pse->avg_overlap < sysctl_sched_migration_cost)
 		goto preempt;
 
-	if (sched_feat(WAKEUP_RUNNING) && pse->avg_running < se->avg_running)
-		goto preempt;
-
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 0d94083..d5059fd 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -54,11 +54,6 @@ SCHED_FEAT(WAKEUP_SYNC, 0)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 
 /*
- * Wakeup preemption towards tasks that run short
- */
-SCHED_FEAT(WAKEUP_RUNNING, 0)
-
-/*
  * Use the SYNC wakeup hint, pipes and the likes use this to indicate
  * the remote end is likely to consume the data we just wrote, and
  * therefore has cache benefit from being placed on the same cpu, see
