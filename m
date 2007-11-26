Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbXKZUgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbXKZUgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXKZUf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:35:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbXKZUfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:35:54 -0500
Date: Mon, 26 Nov 2007 21:35:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20071126203542.GA17976@elte.hu>
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
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

6 commits: two fixes, a tuning tweak and 3 small cleanups.

Thanks!

	Ingo

------------------>
Ingo Molnar (4):
      sched: fix prev_stime calculation
      sched: fix kernel/acct.c comment
      sched: fix RLIMIT_CPU comment
      sched: bump version of kernel/sched_debug.c

Pavel Emelyanov (1):
      sched: don't forget to unlock uids_mutex on error paths

Zou Nan hai (1):
      sched: fix minimum granularity tunings

 fs/proc/array.c                |    4 +++-
 include/asm-generic/resource.h |    2 +-
 kernel/acct.c                  |    2 +-
 kernel/sched_debug.c           |    2 +-
 kernel/sched_fair.c            |   12 ++++++------
 kernel/user.c                  |    7 ++++++-
 6 files changed, 18 insertions(+), 11 deletions(-)

Index: linux/fs/proc/array.c
===================================================================
--- linux.orig/fs/proc/array.c
+++ linux/fs/proc/array.c
@@ -374,7 +374,9 @@ static cputime_t task_stime(struct task_
 	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
 			cputime_to_clock_t(task_utime(p));
 
-	p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+	if (stime >= 0)
+		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+
 	return p->prev_stime;
 }
 #endif
Index: linux/include/asm-generic/resource.h
===================================================================
--- linux.orig/include/asm-generic/resource.h
+++ linux/include/asm-generic/resource.h
@@ -12,7 +12,7 @@
  *   then it defines them prior including asm-generic/resource.h. )
  */
 
-#define RLIMIT_CPU		0	/* CPU time in ms */
+#define RLIMIT_CPU		0	/* CPU time in sec */
 #define RLIMIT_FSIZE		1	/* Maximum filesize */
 #define RLIMIT_DATA		2	/* max data size */
 #define RLIMIT_STACK		3	/* max stack size */
Index: linux/kernel/acct.c
===================================================================
--- linux.orig/kernel/acct.c
+++ linux/kernel/acct.c
@@ -413,7 +413,7 @@ static u32 encode_float(u64 value)
  *  The acct_process() call is the workhorse of the process
  *  accounting system. The struct acct is built here and then written
  *  into the accounting file. This function should only be called from
- *  do_exit().
+ *  do_exit() or when switching to a different output file.
  */
 
 /*
Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -199,7 +199,7 @@ static int sched_debug_show(struct seq_f
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.06-v22, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.07, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -22,7 +22,7 @@
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
- * (default: 20ms * ilog(ncpus), units: nanoseconds)
+ * (default: 20ms * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * NOTE: this latency value is not the same as the concept of
  * 'timeslice length' - timeslices in CFS are of variable length
@@ -36,14 +36,14 @@ unsigned int sysctl_sched_latency = 2000
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
- * (default: 1 msec * ilog(ncpus), units: nanoseconds)
+ * (default: 4 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 1000000ULL;
+unsigned int sysctl_sched_min_granularity = 4000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
  */
-static unsigned int sched_nr_latency = 20;
+static unsigned int sched_nr_latency = 5;
 
 /*
  * After fork, child runs first. (default) If set to 0 then
@@ -61,7 +61,7 @@ unsigned int __read_mostly sysctl_sched_
 
 /*
  * SCHED_BATCH wake-up granularity.
- * (default: 10 msec * ilog(ncpus), units: nanoseconds)
+ * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
@@ -71,7 +71,7 @@ unsigned int sysctl_sched_batch_wakeup_g
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 10 msec * ilog(ncpus), units: nanoseconds)
+ * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
Index: linux/kernel/user.c
===================================================================
--- linux.orig/kernel/user.c
+++ linux/kernel/user.c
@@ -337,8 +337,11 @@ struct user_struct * alloc_uid(struct us
 		struct user_struct *new;
 
 		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
-		if (!new)
+		if (!new) {
+			uids_mutex_unlock();
 			return NULL;
+		}
+
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
 		atomic_set(&new->processes, 0);
@@ -355,6 +358,7 @@ struct user_struct * alloc_uid(struct us
 
 		if (alloc_uid_keyring(new, current) < 0) {
 			kmem_cache_free(uid_cachep, new);
+			uids_mutex_unlock();
 			return NULL;
 		}
 
@@ -362,6 +366,7 @@ struct user_struct * alloc_uid(struct us
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
+			uids_mutex_unlock();
 			return NULL;
 		}
 
