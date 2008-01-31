Return-Path: <linux-kernel-owner+w=401wt.eu-S1765772AbYAaVyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765772AbYAaVyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbYAaVye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:54:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696AbYAaVyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:54:33 -0500
Date: Thu, 31 Jan 2008 22:54:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler updates
Message-ID: <20080131215420.GA31330@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest scheduler-fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Thanks! The only behavioral changes are two fixes for interactivity 
problems reported recently. (they may also be backport candidates for 
v2.6.24)

	Ingo

------------------>
Gerald Stralko (1):
      sched: remove unused params

Ingo Molnar (1):
      debug: turn ignore_loglevel into an early param

Paul E. McKenney (1):
      RCU: add help text for "RCU implementation type"

Peter Zijlstra (1):
      sched: let +nice tasks have smaller impact

Srivatsa Vaddagiri (1):
      sched: fix high wake up latencies with FAIR_USER_SCHED

 init/Kconfig        |    8 ++++++++
 kernel/printk.c     |    4 ++--
 kernel/sched.c      |   10 +++++-----
 kernel/sched_fair.c |    8 ++++++--
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 0d0bbf2..dcc96a8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -775,6 +775,14 @@ config PREEMPT_NOTIFIERS
 choice
 	prompt "RCU implementation type:"
 	default CLASSIC_RCU
+	help
+	  This allows you to choose either the classic RCU implementation
+	  that is designed for best read-side performance on non-realtime
+	  systems, or the preemptible RCU implementation for best latency
+	  on realtime systems.  Note that some kernel preemption modes
+	  will restrict your choice.
+
+	  Select the default if you are unsure.
 
 config CLASSIC_RCU
 	bool "Classic RCU"
diff --git a/kernel/printk.c b/kernel/printk.c
index 58bbec6..29ae1e9 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -455,10 +455,10 @@ static int __init ignore_loglevel_setup(char *str)
 	ignore_loglevel = 1;
 	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
 
-	return 1;
+	return 0;
 }
 
-__setup("ignore_loglevel", ignore_loglevel_setup);
+early_param("ignore_loglevel", ignore_loglevel_setup);
 
 /*
  * Write out chars from start to end - 1 inclusive
diff --git a/kernel/sched.c b/kernel/sched.c
index ba4c880..8355e00 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1255,12 +1255,12 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
 #define sched_class_highest (&rt_sched_class)
 
-static void inc_nr_running(struct task_struct *p, struct rq *rq)
+static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
 }
 
-static void dec_nr_running(struct task_struct *p, struct rq *rq)
+static void dec_nr_running(struct rq *rq)
 {
 	rq->nr_running--;
 }
@@ -1354,7 +1354,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(p, rq);
+	inc_nr_running(rq);
 }
 
 /*
@@ -1366,7 +1366,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(p, rq);
+	dec_nr_running(rq);
 }
 
 /**
@@ -2006,7 +2006,7 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(p, rq);
+		inc_nr_running(rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 72e25c7..6c091d6 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -520,7 +520,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
+		if (sched_feat(NEW_FAIR_SLEEPERS))
 			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
@@ -1106,7 +1106,11 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	}
 
 	gran = sysctl_sched_wakeup_granularity;
-	if (unlikely(se->load.weight != NICE_0_LOAD))
+	/*
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
+	 */
+	if (unlikely(se->load.weight > NICE_0_LOAD))
 		gran = calc_delta_fair(gran, &se->load);
 
 	if (pse->vruntime + gran < se->vruntime)
