Return-Path: <linux-kernel-owner+w=401wt.eu-S933335AbZHDTHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbZHDTHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933162AbZHDTHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:07:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933136AbZHDTHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:07:36 -0400
Date: Tue, 4 Aug 2009 21:07:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090804190727.GA1318@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
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
Gregory Haskins (1):
      sched: Fix race in cpupri introduced by cpumask_var changes

Peter Zijlstra (1):
      sched: Fix latencytop and sleep profiling vs group scheduling


 kernel/sched_cpupri.c |   15 ++++++++++++++-
 kernel/sched_fair.c   |   32 +++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index e6c2517..d014efb 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -81,8 +81,21 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
-		if (lowest_mask)
+		if (lowest_mask) {
 			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+
+			/*
+			 * We have to ensure that we have at least one bit
+			 * still set in the array, since the map could have
+			 * been concurrently emptied between the first and
+			 * second reads of vec->mask.  If we hit this
+			 * condition, simply act as though we never hit this
+			 * priority level and continue on.
+			 */
+			if (cpumask_any(lowest_mask) >= nr_cpu_ids)
+				continue;
+		}
+
 		return 1;
 	}
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9ffb2b2..652e8bd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -611,9 +611,13 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHEDSTATS
+	struct task_struct *tsk = NULL;
+
+	if (entity_is_task(se))
+		tsk = task_of(se);
+
 	if (se->sleep_start) {
 		u64 delta = rq_of(cfs_rq)->clock - se->sleep_start;
-		struct task_struct *tsk = task_of(se);
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -624,11 +628,11 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		se->sleep_start = 0;
 		se->sum_sleep_runtime += delta;
 
-		account_scheduler_latency(tsk, delta >> 10, 1);
+		if (tsk)
+			account_scheduler_latency(tsk, delta >> 10, 1);
 	}
 	if (se->block_start) {
 		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
-		struct task_struct *tsk = task_of(se);
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -639,17 +643,19 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		se->block_start = 0;
 		se->sum_sleep_runtime += delta;
 
-		/*
-		 * Blocking time is in units of nanosecs, so shift by 20 to
-		 * get a milliseconds-range estimation of the amount of
-		 * time that the task spent sleeping:
-		 */
-		if (unlikely(prof_on == SLEEP_PROFILING)) {
-
-			profile_hits(SLEEP_PROFILING, (void *)get_wchan(tsk),
-				     delta >> 20);
+		if (tsk) {
+			/*
+			 * Blocking time is in units of nanosecs, so shift by
+			 * 20 to get a milliseconds-range estimation of the
+			 * amount of time that the task spent sleeping:
+			 */
+			if (unlikely(prof_on == SLEEP_PROFILING)) {
+				profile_hits(SLEEP_PROFILING,
+						(void *)get_wchan(tsk),
+						delta >> 20);
+			}
+			account_scheduler_latency(tsk, delta >> 10, 0);
 		}
-		account_scheduler_latency(tsk, delta >> 10, 0);
 	}
 #endif
 }
