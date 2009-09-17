Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbZIQHtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbZIQHtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbZIQHtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:49:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:48579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169AbZIQHtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:49:19 -0400
Date: Thu, 17 Sep 2009 07:48:49 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add new wakeup preemption mode: WAKEUP_RUNNING
Message-ID: <tip-e334d174b6c916c4a9a2e4ba626c760c7e98cb78@git.kernel.org>
Git-Commit-ID: e334d174b6c916c4a9a2e4ba626c760c7e98cb78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 07:48:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e334d174b6c916c4a9a2e4ba626c760c7e98cb78
Gitweb:     http://git.kernel.org/tip/e334d174b6c916c4a9a2e4ba626c760c7e98cb78
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 16 Sep 2009 12:31:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 09:36:01 +0200

sched: Add new wakeup preemption mode: WAKEUP_RUNNING

Create a new wakeup preemption mode, preempt towards tasks that run
shorter on avg. It sets next buddy to be sure we actually run the task
we preempted for.

Test results:

 root@twins:~# while :; do :; done &
 [1] 6537
 root@twins:~# while :; do :; done &
 [2] 6538
 root@twins:~# while :; do :; done &
 [3] 6539
 root@twins:~# while :; do :; done &
 [4] 6540

 root@twins:/home/peter# ./latt -c4 sleep 4
 Entries: 48 (clients=4)

 Averages:
 ------------------------------
        Max          4750 usec
        Avg           497 usec
        Stdev         737 usec

 root@twins:/home/peter# echo WAKEUP_RUNNING > /debug/sched_features

 root@twins:/home/peter# ./latt -c4 sleep 4
 Entries: 48 (clients=4)

 Averages:
 ------------------------------
        Max            14 usec
        Avg             5 usec
        Stdev           3 usec

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <new-submission>


---
 include/linux/sched.h   |    2 ++
 kernel/sched.c          |   17 ++++++++++-------
 kernel/sched_debug.c    |    1 +
 kernel/sched_fair.c     |   14 +++++++++++---
 kernel/sched_features.h |    5 +++++
 5 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4a39bb..8af3d24 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1113,6 +1113,8 @@ struct sched_entity {
 	u64			start_runtime;
 	u64			avg_wakeup;
 
+	u64			avg_running;
+
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
diff --git a/kernel/sched.c b/kernel/sched.c
index 5049d95..f55133c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2454,6 +2454,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_overlap		= 0;
 	p->se.start_runtime		= 0;
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
+	p->se.avg_running		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start			= 0;
@@ -5306,14 +5307,13 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *prev)
+static void put_prev_task(struct rq *rq, struct task_struct *p)
 {
-	if (prev->state == TASK_RUNNING) {
-		u64 runtime = prev->se.sum_exec_runtime;
+	u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
 
-		runtime -= prev->se.prev_sum_exec_runtime;
-		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+	update_avg(&p->se.avg_running, runtime);
 
+	if (p->state == TASK_RUNNING) {
 		/*
 		 * In order to avoid avg_overlap growing stale when we are
 		 * indeed overlapping and hence not getting put to sleep, grow
@@ -5323,9 +5323,12 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
 		 * correlates to the amount of cache footprint a task can
 		 * build up.
 		 */
-		update_avg(&prev->se.avg_overlap, runtime);
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+		update_avg(&p->se.avg_overlap, runtime);
+	} else {
+		update_avg(&p->se.avg_running, 0);
 	}
-	prev->sched_class->put_prev_task(rq, prev);
+	p->sched_class->put_prev_task(rq, p);
 }
 
 /*
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 5ddbd08..efb8440 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -395,6 +395,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
 	PN(se.avg_wakeup);
+	PN(se.avg_running);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c741cd9..3e6f78c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1605,9 +1605,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 	}
 
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
 	if ((sched_feat(WAKEUP_SYNC) && sync) ||
 	    (sched_feat(WAKEUP_OVERLAP) &&
 	     (se->avg_overlap < sysctl_sched_migration_cost &&
@@ -1616,6 +1613,17 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 	}
 
+	if (sched_feat(WAKEUP_RUNNING)) {
+		if (pse->avg_running < se->avg_running) {
+			set_next_buddy(pse);
+			resched_task(curr);
+			return;
+		}
+	}
+
+	if (!sched_feat(WAKEUP_PREEMPT))
+		return;
+
 	find_matching_se(&se, &pse);
 
 	BUG_ON(!pse);
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index d5059fd..eba3faa 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -54,6 +54,11 @@ SCHED_FEAT(WAKEUP_SYNC, 0)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 
 /*
+ * Wakeup preemption towards tasks that run short
+ */
+SCHED_FEAT(WAKEUP_RUNNING, 1)
+
+/*
  * Use the SYNC wakeup hint, pipes and the likes use this to indicate
  * the remote end is likely to consume the data we just wrote, and
  * therefore has cache benefit from being placed on the same cpu, see
