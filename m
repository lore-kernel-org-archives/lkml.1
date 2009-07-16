Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbZGPPnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbZGPPnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZGPPnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:43:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:59694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbZGPPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:43:47 -0400
Subject: [GIT PULL] scheduler patches
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 17:43:35 +0200
Message-Id: <1247759015.6586.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull these scheduler patches from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git sched-fixes-for-linus

Thanks,

  Peter

---
Fabio Checconi (1):
      sched: Fix rt_rq->pushable_tasks initialization in init_rt_rq()

Lucas De Marchi (1):
      sched: Reset sched stats on fork()

Paul Turner (1):
      sched: Fix bug in SCHED_IDLE interaction with group scheduling

Peter Zijlstra (1):
      sched_rt: Fix overload bug on rt group scheduling

Wolfram Sang (1):
      sched: Documentation/sched-rt-group: Fix style issues & bump version

 Documentation/scheduler/sched-rt-group.txt |   13 ++++----
 kernel/sched.c                             |   43 +++++++++++++++++++++------
 kernel/sched_fair.c                        |    3 +-
 kernel/sched_rt.c                          |   18 +++++++++++-
 4 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 1df7f9c..86eabe6 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -73,7 +73,7 @@ The remaining CPU time will be used for user input and other tasks. Because
 realtime tasks have explicitly allocated the CPU time they need to perform
 their tasks, buffer underruns in the graphics or audio can be eliminated.
 
-NOTE: the above example is not fully implemented as of yet (2.6.25). We still
+NOTE: the above example is not fully implemented yet. We still
 lack an EDF scheduler to make non-uniform periods usable.
 
 
@@ -140,14 +140,15 @@ The other option is:
 
 .o CONFIG_CGROUP_SCHED (aka "Basis for grouping tasks" = "Control groups")
 
-This uses the /cgroup virtual file system and "/cgroup/<cgroup>/cpu.rt_runtime_us"
-to control the CPU time reserved for each control group instead.
+This uses the /cgroup virtual file system and
+"/cgroup/<cgroup>/cpu.rt_runtime_us" to control the CPU time reserved for each
+control group instead.
 
 For more information on working with control groups, you should read
 Documentation/cgroups/cgroups.txt as well.
 
-Group settings are checked against the following limits in order to keep the configuration
-schedulable:
+Group settings are checked against the following limits in order to keep the
+configuration schedulable:
 
    \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
 
@@ -189,7 +190,7 @@ Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
 the biggest challenge as the current linux PI infrastructure is geared towards
 the limited static priority levels 0-99. With deadline scheduling you need to
 do deadline inheritance (since priority is inversely proportional to the
-deadline delta (deadline - now).
+deadline delta (deadline - now)).
 
 This means the whole PI machinery will have to be reworked - and that is one of
 the most complex pieces of code we have.
diff --git a/kernel/sched.c b/kernel/sched.c
index 7c9098d..efecfda 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -493,6 +493,7 @@ struct rt_rq {
 #endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
+	unsigned long rt_nr_total;
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
@@ -2571,15 +2572,37 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_start		= 0;
-	p->se.sum_sleep_runtime		= 0;
-	p->se.sleep_start		= 0;
-	p->se.block_start		= 0;
-	p->se.sleep_max			= 0;
-	p->se.block_max			= 0;
-	p->se.exec_max			= 0;
-	p->se.slice_max			= 0;
-	p->se.wait_max			= 0;
+	p->se.wait_start			= 0;
+	p->se.wait_max				= 0;
+	p->se.wait_count			= 0;
+	p->se.wait_sum				= 0;
+
+	p->se.sleep_start			= 0;
+	p->se.sleep_max				= 0;
+	p->se.sum_sleep_runtime			= 0;
+
+	p->se.block_start			= 0;
+	p->se.block_max				= 0;
+	p->se.exec_max				= 0;
+	p->se.slice_max				= 0;
+
+	p->se.nr_migrations_cold		= 0;
+	p->se.nr_failed_migrations_affine	= 0;
+	p->se.nr_failed_migrations_running	= 0;
+	p->se.nr_failed_migrations_hot		= 0;
+	p->se.nr_forced_migrations		= 0;
+	p->se.nr_forced2_migrations		= 0;
+
+	p->se.nr_wakeups			= 0;
+	p->se.nr_wakeups_sync			= 0;
+	p->se.nr_wakeups_migrate		= 0;
+	p->se.nr_wakeups_local			= 0;
+	p->se.nr_wakeups_remote			= 0;
+	p->se.nr_wakeups_affine			= 0;
+	p->se.nr_wakeups_affine_attempts	= 0;
+	p->se.nr_wakeups_passive		= 0;
+	p->se.nr_wakeups_idle			= 0;
+
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -9070,7 +9093,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
-	plist_head_init(&rq->rt.pushable_tasks, &rq->lock);
+	plist_head_init(&rt_rq->pushable_tasks, &rq->lock);
 #endif
 
 	rt_rq->rt_time = 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ba7fd6e..7c248dc 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -687,7 +687,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 			 * all of which have the same weight.
 			 */
 			if (sched_feat(NORMALIZED_SLEEPER) &&
-					task_of(se)->policy != SCHED_IDLE)
+					(!entity_is_task(se) ||
+					 task_of(se)->policy != SCHED_IDLE))
 				thresh = calc_delta_fair(thresh, se);
 
 			vruntime -= thresh;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9bf0d2a..3918e01 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -10,6 +10,8 @@ static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 
 #ifdef CONFIG_RT_GROUP_SCHED
 
+#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return rt_rq->rq;
@@ -22,6 +24,8 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 
 #else /* CONFIG_RT_GROUP_SCHED */
 
+#define rt_entity_is_task(rt_se) (1)
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return container_of(rt_rq, struct rq, rt);
@@ -73,7 +77,7 @@ static inline void rt_clear_overload(struct rq *rq)
 
 static void update_rt_migration(struct rt_rq *rt_rq)
 {
-	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
+	if (rt_rq->rt_nr_migratory && rt_rq->rt_nr_total > 1) {
 		if (!rt_rq->overloaded) {
 			rt_set_overload(rq_of_rt_rq(rt_rq));
 			rt_rq->overloaded = 1;
@@ -86,6 +90,12 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	if (!rt_entity_is_task(rt_se))
+		return;
+
+	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+
+	rt_rq->rt_nr_total++;
 	if (rt_se->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory++;
 
@@ -94,6 +104,12 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	if (!rt_entity_is_task(rt_se))
+		return;
+
+	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+
+	rt_rq->rt_nr_total--;
 	if (rt_se->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory--;
 


