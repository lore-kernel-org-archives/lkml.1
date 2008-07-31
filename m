Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYGaW0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYGaW0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758542AbYGaW0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:26:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38551 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbYGaW0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:26:40 -0400
Date: Fri, 1 Aug 2008 00:26:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080731222624.GA22426@elte.hu>
References: <20080731214352.GA22791@elte.hu> <20080731.150457.77077498.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731.150457.77077498.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 31 Jul 2008 23:43:52 +0200
> 
> > Peter Zijlstra (2):
> >       sched: fix warning in hrtick_start_fair()
> >       lockdep: change scheduler annotation
> 
> Ingo, Peter forgot to tell you but this lockdep change
> blows up on my Niagara boxes in a way I haven't figured
> out yet.

are you sure it's this (trivial) annotation in sched.c that blows up, 
not your other (more invasive) changes to lockdep? This patch looked 
fine in my testing.

> So could you please not merge that change in for the
> time being?

sure thing, we can defer it until your bug is understood more fully. 
I've created a second, sched-fixes-for-linus-2 tree for Linus below - 
Linus, if you have not pulled the previous tree yet could you please 
pull this one?

	Ingo

------------------->
Linus,

Please pull the latest sched-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus-2

 Thanks,

	Ingo

------------------>
Hugh Dickins (1):
      sched: move sched_clock before first use

OGAWA Hirofumi (1):
      sched: fix SCHED_HRTICK dependency

Peter Zijlstra (1):
      sched: fix warning in hrtick_start_fair()

roel kluin (1):
      sched: test runtime rather than period in global_rt_runtime()


 kernel/Kconfig.hz    |    2 +-
 kernel/sched.c       |    2 +-
 kernel/sched_clock.c |   19 +++++++++----------
 kernel/sched_fair.c  |    2 +-
 4 files changed, 12 insertions(+), 13 deletions(-)

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
index 0236958..0d1717b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -834,7 +834,7 @@ static inline u64 global_rt_period(void)
 
 static inline u64 global_rt_runtime(void)
 {
-	if (sysctl_sched_rt_period < 0)
+	if (sysctl_sched_rt_runtime < 0)
 		return RUNTIME_INF;
 
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
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
