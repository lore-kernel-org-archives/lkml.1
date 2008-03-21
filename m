Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYCUQXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYCUQXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYCUQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:23:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47877 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYCUQXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:23:12 -0400
Date: Fri, 21 Mar 2008 17:23:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler updates
Message-ID: <20080321162303.GA30833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.4
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.4 required=5.9 tests=BAYES_00,DIET_1 autolearn=no SpamAssassin version=3.2.3
	0.1 DIET_1                 BODY: Lose Weight Spam
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

(the topology.h change is a NOP for upstream, to make it easier for s390 
to work on their topology changes.)

Thanks,

	Ingo

------------------>
Heiko Carstens (2):
      sched: add exported arch_reinit_sched_domains() to header file.
      sched: add arch_update_cpu_topology hook.

Peter Zijlstra (1):
      sched: cleanup old and rarely used 'debug' features.

Roel Kluin (1):
      sched: remove double unlikely from schedule()

 include/linux/sched.h    |    1 +
 include/linux/topology.h |    2 ++
 kernel/sched.c           |   17 +++++++++--------
 kernel/sched_fair.c      |   14 --------------
 4 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3625fca..fed07d0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -790,6 +790,7 @@ struct sched_domain {
 };
 
 extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new);
+extern int arch_reinit_sched_domains(void);
 
 #endif	/* CONFIG_SMP */
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 2d8dac8..bd14f8b 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -50,6 +50,8 @@
 	for_each_online_node(node)						\
 		if (nr_cpus_node(node))
 
+void arch_update_cpu_topology(void);
+
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
 #define REMOTE_DISTANCE		20
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f7c5eb..28c73f0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -594,18 +594,14 @@ enum {
 	SCHED_FEAT_NEW_FAIR_SLEEPERS	= 1,
 	SCHED_FEAT_WAKEUP_PREEMPT	= 2,
 	SCHED_FEAT_START_DEBIT		= 4,
-	SCHED_FEAT_TREE_AVG		= 8,
-	SCHED_FEAT_APPROX_AVG		= 16,
-	SCHED_FEAT_HRTICK		= 32,
-	SCHED_FEAT_DOUBLE_TICK		= 64,
+	SCHED_FEAT_HRTICK		= 8,
+	SCHED_FEAT_DOUBLE_TICK		= 16,
 };
 
 const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_NEW_FAIR_SLEEPERS	* 1 |
 		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
-		SCHED_FEAT_TREE_AVG		* 0 |
-		SCHED_FEAT_APPROX_AVG		* 0 |
 		SCHED_FEAT_HRTICK		* 1 |
 		SCHED_FEAT_DOUBLE_TICK		* 0;
 
@@ -3886,7 +3882,7 @@ need_resched_nonpreemptible:
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				unlikely(signal_pending(prev)))) {
+				signal_pending(prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
 			deactivate_task(rq, prev, 1);
@@ -6811,6 +6807,10 @@ static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
  */
 static cpumask_t fallback_doms;
 
+void __attribute__((weak)) arch_update_cpu_topology(void)
+{
+}
+
 /*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
@@ -6820,6 +6820,7 @@ static int arch_init_sched_domains(const cpumask_t *cpu_map)
 {
 	int err;
 
+	arch_update_cpu_topology();
 	ndoms_cur = 1;
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms_cur)
@@ -6924,7 +6925,7 @@ match2:
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-static int arch_reinit_sched_domains(void)
+int arch_reinit_sched_domains(void)
 {
 	int err;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index b85cac4..86a9337 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -302,11 +302,6 @@ static u64 __sched_vslice(unsigned long rq_weight, unsigned long nr_running)
 	return vslice;
 }
 
-static u64 sched_vslice(struct cfs_rq *cfs_rq)
-{
-	return __sched_vslice(cfs_rq->load.weight, cfs_rq->nr_running);
-}
-
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	return __sched_vslice(cfs_rq->load.weight + se->load.weight,
@@ -504,15 +499,6 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	} else
 		vruntime = cfs_rq->min_vruntime;
 
-	if (sched_feat(TREE_AVG)) {
-		struct sched_entity *last = __pick_last_entity(cfs_rq);
-		if (last) {
-			vruntime += last->vruntime;
-			vruntime >>= 1;
-		}
-	} else if (sched_feat(APPROX_AVG) && cfs_rq->nr_running)
-		vruntime += sched_vslice(cfs_rq)/2;
-
 	/*
 	 * The 'current' period is already promised to the current tasks,
 	 * however the extra weight of the new task will slow them down a
