Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZBKOmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZBKOmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZBKOlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:41:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZBKOlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:41:51 -0500
Date: Wed, 11 Feb 2009 15:41:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20090211144135.GA7088@elte.hu>
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
Peter Zijlstra (1):
      sched: revert recent sync wakeup changes

Suresh Siddha (1):
      sched: fix nohz load balancer on cpu offline


 kernel/sched.c      |   27 +++++++++++----------------
 kernel/sched_fair.c |   11 +++++++++--
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 242d0d4..f11c02b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2266,16 +2266,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
-	if (!sync) {
-		if (current->se.avg_overlap < sysctl_sched_migration_cost &&
-			  p->se.avg_overlap < sysctl_sched_migration_cost)
-			sync = 1;
-	} else {
-		if (current->se.avg_overlap >= sysctl_sched_migration_cost ||
-			  p->se.avg_overlap >= sysctl_sched_migration_cost)
-			sync = 0;
-	}
-
 #ifdef CONFIG_SMP
 	if (sched_feat(LB_WAKEUP_UPDATE)) {
 		struct sched_domain *sd;
@@ -3890,19 +3880,24 @@ int select_nohz_load_balancer(int stop_tick)
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
-		/*
-		 * If we are going offline and still the leader, give up!
-		 */
-		if (!cpu_active(cpu) &&
-		    atomic_read(&nohz.load_balancer) == cpu) {
+		if (!cpu_active(cpu)) {
+			if (atomic_read(&nohz.load_balancer) != cpu)
+				return 0;
+
+			/*
+			 * If we are going offline and still the leader,
+			 * give up!
+			 */
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
+
 			return 0;
 		}
 
+		cpumask_set_cpu(cpu, nohz.cpu_mask);
+
 		/* time for ilb owner also to sleep */
 		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a7e50ba..0566f2a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1191,15 +1191,20 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	    int idx, unsigned long load, unsigned long this_load,
 	    unsigned int imbalance)
 {
+	struct task_struct *curr = this_rq->curr;
+	struct task_group *tg;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
-	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
 
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
+	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
+			p->se.avg_overlap > sysctl_sched_migration_cost))
+		sync = 0;
+
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1426,7 +1431,9 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (sched_feat(WAKEUP_OVERLAP) && sync) {
+	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
+			(se->avg_overlap < sysctl_sched_migration_cost &&
+			 pse->avg_overlap < sysctl_sched_migration_cost))) {
 		resched_task(curr);
 		return;
 	}
