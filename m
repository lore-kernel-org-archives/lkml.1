Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0CKSby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:31:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:40814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab0CKSbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:31:45 -0500
Date: Thu, 11 Mar 2010 18:30:55 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301062.6785.29.camel@marge.simson.net>
References: <1268301062.6785.29.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove avg_wakeup
Message-ID: <tip-b42e0c41a422a212ddea0666d5a3a0e3c35206db@git.kernel.org>
Git-Commit-ID: b42e0c41a422a212ddea0666d5a3a0e3c35206db
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:30:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b42e0c41a422a212ddea0666d5a3a0e3c35206db
Gitweb:     http://git.kernel.org/tip/b42e0c41a422a212ddea0666d5a3a0e3c35206db
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:15:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:50 +0100

sched: Remove avg_wakeup

Testing the load which led to this heuristic (nfs4 kbuild) shows that it has
outlived it's usefullness.  With intervening load balancing changes, I cannot
see any difference with/without, so recover there fastpath cycles.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301062.6785.29.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    3 ---
 kernel/sched.c          |   26 ++++----------------------
 kernel/sched_debug.c    |    1 -
 kernel/sched_fair.c     |   31 -------------------------------
 kernel/sched_features.h |    6 ------
 5 files changed, 4 insertions(+), 63 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 13efe7d..70c560f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1185,9 +1185,6 @@ struct sched_entity {
 
 	u64			nr_migrations;
 
-	u64			start_runtime;
-	u64			avg_wakeup;
-
 #ifdef CONFIG_SCHEDSTATS
 	struct sched_statistics statistics;
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 60b1bbe..35a8626 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1880,9 +1880,6 @@ static void update_avg(u64 *avg, u64 sample)
 static void
 enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
-	if (wakeup)
-		p->se.start_runtime = p->se.sum_exec_runtime;
-
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup, head);
 	p->se.on_rq = 1;
@@ -1890,17 +1887,11 @@ enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (sleep) {
-		if (p->se.last_wakeup) {
-			update_avg(&p->se.avg_overlap,
-				p->se.sum_exec_runtime - p->se.last_wakeup);
-			p->se.last_wakeup = 0;
-		} else {
-			update_avg(&p->se.avg_wakeup,
-				sysctl_sched_wakeup_granularity);
-		}
+	if (sleep && p->se.last_wakeup) {
+		update_avg(&p->se.avg_overlap,
+			p->se.sum_exec_runtime - p->se.last_wakeup);
+		p->se.last_wakeup = 0;
 	}
-
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
@@ -2466,13 +2457,6 @@ out_activate:
 	 */
 	if (!in_interrupt()) {
 		struct sched_entity *se = &current->se;
-		u64 sample = se->sum_exec_runtime;
-
-		if (se->last_wakeup)
-			sample -= se->last_wakeup;
-		else
-			sample -= se->start_runtime;
-		update_avg(&se->avg_wakeup, sample);
 
 		se->last_wakeup = se->sum_exec_runtime;
 	}
@@ -2540,8 +2524,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
-	p->se.start_runtime		= 0;
-	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index ad9df44..20b95a4 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -408,7 +408,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
-	PN(se.avg_wakeup);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8ad164b..6fc6285 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1592,42 +1592,11 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 }
 #endif /* CONFIG_SMP */
 
-/*
- * Adaptive granularity
- *
- * se->avg_wakeup gives the average time a task runs until it does a wakeup,
- * with the limit of wakeup_gran -- when it never does a wakeup.
- *
- * So the smaller avg_wakeup is the faster we want this task to preempt,
- * but we don't want to treat the preemptee unfairly and therefore allow it
- * to run for at least the amount of time we'd like to run.
- *
- * NOTE: we use 2*avg_wakeup to increase the probability of actually doing one
- *
- * NOTE: we use *nr_running to scale with load, this nicely matches the
- *       degrading latency on load.
- */
-static unsigned long
-adaptive_gran(struct sched_entity *curr, struct sched_entity *se)
-{
-	u64 this_run = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	u64 expected_wakeup = 2*se->avg_wakeup * cfs_rq_of(se)->nr_running;
-	u64 gran = 0;
-
-	if (this_run < expected_wakeup)
-		gran = expected_wakeup - this_run;
-
-	return min_t(s64, gran, sysctl_sched_wakeup_granularity);
-}
-
 static unsigned long
 wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 {
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
-	if (cfs_rq_of(curr)->curr && sched_feat(ADAPTIVE_GRAN))
-		gran = adaptive_gran(curr, se);
-
 	/*
 	 * Since its curr running now, convert the gran from real-time
 	 * to virtual-time in his units.
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index d5059fd..96ef5db 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -31,12 +31,6 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 
 /*
- * Compute wakeup_gran based on task behaviour, clipped to
- *  [0, sched_wakeup_gran_ns]
- */
-SCHED_FEAT(ADAPTIVE_GRAN, 1)
-
-/*
  * When converting the wakeup granularity to virtual time, do it such
  * that heavier tasks preempting a lighter task have an edge.
  */
