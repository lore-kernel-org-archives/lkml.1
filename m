Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYGaVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYGaVoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbYGaVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:44:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYGaVoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:44:05 -0400
Date: Thu, 31 Jul 2008 23:43:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080731214352.GA22791@elte.hu>
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
Hugh Dickins (1):
      sched: move sched_clock before first use

OGAWA Hirofumi (1):
      sched: fix SCHED_HRTICK dependency

Peter Zijlstra (2):
      sched: fix warning in hrtick_start_fair()
      lockdep: change scheduler annotation

roel kluin (1):
      sched: test runtime rather than period in global_rt_runtime()


 kernel/Kconfig.hz    |    2 +-
 kernel/sched.c       |   12 +++++-------
 kernel/sched_clock.c |   19 +++++++++----------
 kernel/sched_fair.c  |    2 +-
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 382dd5a..94fabd5 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && USE_GENERIC_SMP_HELPERS
+	def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)
diff --git a/kernel/sched.c b/kernel/sched.c
index 0236958..f63af45 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -600,7 +600,6 @@ struct rq {
 	/* BKL stats */
 	unsigned int bkl_count;
 #endif
-	struct lock_class_key rq_lock_key;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -834,7 +833,7 @@ static inline u64 global_rt_period(void)
 
 static inline u64 global_rt_runtime(void)
 {
-	if (sysctl_sched_rt_period < 0)
+	if (sysctl_sched_rt_runtime < 0)
 		return RUNTIME_INF;
 
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
@@ -2759,10 +2758,10 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	} else {
 		if (rq1 < rq2) {
 			spin_lock(&rq1->lock);
-			spin_lock(&rq2->lock);
+			spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
 		} else {
 			spin_lock(&rq2->lock);
-			spin_lock(&rq1->lock);
+			spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
 	update_rq_clock(rq1);
@@ -2805,10 +2804,10 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
 			spin_lock(&busiest->lock);
-			spin_lock(&this_rq->lock);
+			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
 			ret = 1;
 		} else
-			spin_lock(&busiest->lock);
+			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
 	}
 	return ret;
 }
@@ -7998,7 +7997,6 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
-		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 22ed55d..5a2dc7d 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -32,6 +32,15 @@
 #include <linux/ktime.h>
 #include <linux/module.h>
 
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * This is default implementation.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __attribute__((weak)) sched_clock(void)
+{
+	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+}
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
@@ -321,16 +330,6 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
 #endif
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- * This is default implementation.
- * Architectures and sub-architectures can override this.
- */
-unsigned long long __attribute__((weak)) sched_clock(void)
-{
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
-}
-
 unsigned long long cpu_clock(int cpu)
 {
 	unsigned long long clock;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cf2cd6c..0fe94ea 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -899,7 +899,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 		 * doesn't make sense. Rely on vruntime for fairness.
 		 */
 		if (rq->curr != p)
-			delta = max(10000LL, delta);
+			delta = max_t(s64, 10000LL, delta);
 
 		hrtick_start(rq, delta);
 	}
