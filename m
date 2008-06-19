Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYFSPQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYFSPQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYFSPQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:16:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58333 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbYFSPQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:16:28 -0400
Date: Thu, 19 Jun 2008 17:16:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20080619151612.GA11337@elte.hu>
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

please pull the latest misc core-kernel fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	Ingo

------------------>
Jason Wessel (1):
      softlockup: fix NMI hangs due to lock race - 2.6.26-rc regression

Li Zefan (1):
      cpuset: limit the input of cpuset.sched_relax_domain_level

Steven Rostedt (1):
      rcupreempt: remove export of rcu_batches_completed_bh

 Documentation/cpusets.txt |    2 +-
 kernel/cpuset.c           |    4 ++--
 kernel/rcupreempt.c       |    2 --
 kernel/sched.c            |    7 ++++++-
 kernel/softlockup.c       |   15 ++++++++++-----
 5 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
index d803c5c..353504d 100644
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -542,7 +542,7 @@ otherwise initial value -1 that indicates the cpuset has no request.
    2  : search cores in a package.
    3  : search cpus in a node [= system wide on non-NUMA system]
  ( 4  : search nodes in a chunk of node [on NUMA system] )
- ( 5~ : search system wide [on NUMA system])
+ ( 5  : search system wide [on NUMA system] )
 
 This file is per-cpuset and affect the sched domain where the cpuset
 belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 039baa4..66103a1 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1037,8 +1037,8 @@ int current_cpuset_is_being_rebound(void)
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
-	if ((int)val < 0)
-		val = -1;
+	if (val < -1 || val >= SD_LV_MAX)
+		return -EINVAL;
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index e1cdf19..5e02b77 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -217,8 +217,6 @@ long rcu_batches_completed(void)
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
-
 void __rcu_read_lock(void)
 {
 	int idx;
diff --git a/kernel/sched.c b/kernel/sched.c
index eaf6751..bb2c699 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6877,7 +6877,12 @@ static int default_relax_domain_level = -1;
 
 static int __init setup_relax_domain_level(char *str)
 {
-	default_relax_domain_level = simple_strtoul(str, NULL, 0);
+	unsigned long val;
+
+	val = simple_strtoul(str, NULL, 0);
+	if (val < SD_LV_MAX)
+		default_relax_domain_level = val;
+
 	return 1;
 }
 __setup("relax_domain_level=", setup_relax_domain_level);
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 01b6522..c828c23 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -49,12 +49,17 @@ static unsigned long get_timestamp(int this_cpu)
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-void touch_softlockup_watchdog(void)
+static void __touch_softlockup_watchdog(void)
 {
 	int this_cpu = raw_smp_processor_id();
 
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
+
+void touch_softlockup_watchdog(void)
+{
+	__raw_get_cpu_var(touch_timestamp) = 0;
+}
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
 void touch_all_softlockup_watchdogs(void)
@@ -80,7 +85,7 @@ void softlockup_tick(void)
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
-		touch_softlockup_watchdog();
+		__touch_softlockup_watchdog();
 		return;
 	}
 
@@ -95,7 +100,7 @@ void softlockup_tick(void)
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
-		touch_softlockup_watchdog();
+		__touch_softlockup_watchdog();
 		return;
 	}
 
@@ -214,7 +219,7 @@ static int watchdog(void *__bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
 	/* initialize timestamp */
-	touch_softlockup_watchdog();
+	__touch_softlockup_watchdog();
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	/*
@@ -223,7 +228,7 @@ static int watchdog(void *__bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-		touch_softlockup_watchdog();
+		__touch_softlockup_watchdog();
 		schedule();
 
 		if (kthread_should_stop())
