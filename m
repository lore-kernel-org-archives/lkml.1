Return-Path: <linux-kernel-owner+w=401wt.eu-S935941AbZAOWxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935941AbZAOWxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934583AbZAOWIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:08:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934579AbZAOWIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:08:18 -0500
Date: Thu, 15 Jan 2009 23:08:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090115220809.GA7793@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      Revert "sched: improve preempt debugging"

Lin Ming (1):
      sched: sched_slice() fixlet

Peter Zijlstra (4):
      sched: fix bandwidth validation for UID grouping
      sched: SCHED_IDLE weight change
      sched: SCHED_OTHER vs SCHED_IDLE isolation
      sched: fix update_min_vruntime


 kernel/sched.c      |   13 ++++++++++---
 kernel/sched_fair.c |   37 +++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8be2c13..6acfb3c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1323,8 +1323,8 @@ static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
  * slice expiry etc.
  */
 
-#define WEIGHT_IDLEPRIO		2
-#define WMULT_IDLEPRIO		(1 << 31)
+#define WEIGHT_IDLEPRIO                3
+#define WMULT_IDLEPRIO         1431655765
 
 /*
  * Nice levels are multiplicative, with a gentle 10% change for every
@@ -4440,7 +4440,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
+	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
@@ -9050,6 +9050,13 @@ static int tg_schedulable(struct task_group *tg, void *data)
 		runtime = d->rt_runtime;
 	}
 
+#ifdef CONFIG_USER_SCHED
+	if (tg == &root_task_group) {
+		period = global_rt_period();
+		runtime = global_rt_runtime();
+	}
+#endif
+
 	/*
 	 * Cannot have more runtime than the period.
 	 */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8e1352c..5cc1c16 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -283,7 +283,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 						   struct sched_entity,
 						   run_node);
 
-		if (vruntime == cfs_rq->min_vruntime)
+		if (!cfs_rq->curr)
 			vruntime = se->vruntime;
 		else
 			vruntime = min_vruntime(vruntime, se->vruntime);
@@ -429,7 +429,10 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
 
 	for_each_sched_entity(se) {
-		struct load_weight *load = &cfs_rq->load;
+		struct load_weight *load;
+
+		cfs_rq = cfs_rq_of(se);
+		load = &cfs_rq->load;
 
 		if (unlikely(!se->on_rq)) {
 			struct load_weight lw = cfs_rq->load;
@@ -677,9 +680,13 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 			unsigned long thresh = sysctl_sched_latency;
 
 			/*
-			 * convert the sleeper threshold into virtual time
+			 * Convert the sleeper threshold into virtual time.
+			 * SCHED_IDLE is a special sub-class.  We care about
+			 * fairness only relative to other SCHED_IDLE tasks,
+			 * all of which have the same weight.
 			 */
-			if (sched_feat(NORMALIZED_SLEEPER))
+			if (sched_feat(NORMALIZED_SLEEPER) &&
+					task_of(se)->policy != SCHED_IDLE)
 				thresh = calc_delta_fair(thresh, se);
 
 			vruntime -= thresh;
@@ -1340,14 +1347,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
 static void set_last_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->last = se;
+	if (likely(task_of(se)->policy != SCHED_IDLE)) {
+		for_each_sched_entity(se)
+			cfs_rq_of(se)->last = se;
+	}
 }
 
 static void set_next_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->next = se;
+	if (likely(task_of(se)->policy != SCHED_IDLE)) {
+		for_each_sched_entity(se)
+			cfs_rq_of(se)->next = se;
+	}
 }
 
 /*
@@ -1393,12 +1404,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 		return;
 
 	/*
-	 * Batch tasks do not preempt (their preemption is driven by
+	 * Batch and idle tasks do not preempt (their preemption is driven by
 	 * the tick):
 	 */
-	if (unlikely(p->policy == SCHED_BATCH))
+	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
+	/* Idle tasks are by definition preempted by everybody. */
+	if (unlikely(curr->policy == SCHED_IDLE)) {
+		resched_task(curr);
+		return;
+	}
+
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
