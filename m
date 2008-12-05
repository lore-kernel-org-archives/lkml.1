Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYLEHhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYLEHhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLEHh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:37:27 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYLEHhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:37:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=jPKiflvJBpba4sZgwN9sr8+LLfEi7LAD8XeWacp9XhUOZQV58He0qVMpIpC3xuNtj
	OySfY5hziKPS5VEYgVFhQ==
MIME-Version: 1.0
Date: Thu, 4 Dec 2008 23:37:19 -0800
Message-ID: <b040c32a0812042337r7bf6282apd53e3412458d415b@mail.gmail.com>
Subject: [patch] make wake-affine a sysctl variable
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn wake-affine into a fully controllable sysctl variable.

This is not the first time that SD_WAKE_AFFINE load balance has detrimental
performance impact to server workloads. Three years ago, I presented hard
benchmark results to the community and showed that multi-threaded database
workloads suffered from poor load balance decision made by SD_WAKE_AFFINE.
Today, the very same 3 years old performance bug bite us again on internet
server application workload. The performance impact is even more astonishing,
at 28% performance degradation.

The bug surfaced due to cover up agents went dormant.  Usually there are
several load balance actions in the system, most notably the idle load
balancer and the newly-idle l-b.  These two agents largely will correct the
mishaps that SD_WAKE_AFFINE would make and silently cover up bad behaving
task migrations.  However, in our production environment, scheduler doesn't
have any chance to run the cover up agents because CPU cycles are used
heavily, i.e., CPUs are rarely idle and effectively suppressed idle and
newly-idle balancer.  Without the corrective l-b action, the bug poke
right through and causing detrimental performance degradations.

Several people in the past attempted to fiddle with SD_WAKE_AFFINE, none
was successful AFAIK. Short of any other answer, I propose again that
kernel provides a knob to turn the darn thing off if one chooses to.


Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..d171cad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1671,7 +1671,6 @@ extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
-extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_shares_ratelimit;
@@ -1689,6 +1688,7 @@ int sched_rt_handler
 		loff_t *ppos);

 extern unsigned int sysctl_sched_compat_yield;
+extern unsigned int sysctl_sched_features;

 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index b7480fb..188629b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -676,6 +676,7 @@ int runqueue_is_locked(void)

 #define SCHED_FEAT(name, enabled)	\
 	__SCHED_FEAT_##name ,
+#define SCHED_FEAT_SYSCTL	SCHED_FEAT

 enum {
 #include "sched_features.h"
@@ -683,6 +684,7 @@ enum {

 #undef SCHED_FEAT

+#ifdef CONFIG_SCHED_DEBUG
 #define SCHED_FEAT(name, enabled)	\
 	(1UL << __SCHED_FEAT_##name) * enabled |

@@ -692,7 +694,6 @@ const_debug unsigned int sysctl_sched_features =

 #undef SCHED_FEAT

-#ifdef CONFIG_SCHED_DEBUG
 #define SCHED_FEAT(name, enabled)	\
 	#name ,

@@ -702,6 +703,7 @@ static __read_mostly char *sched_feat_names[] = {
 };

 #undef SCHED_FEAT
+#undef SCHED_FEAT_SYSCTL

 static int sched_feat_open(struct inode *inode, struct file *filp)
 {
@@ -801,9 +803,35 @@ static __init int sched_init_debug(void)
 }
 late_initcall(sched_init_debug);

-#endif
-
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+#define sched_feat_sysctl	sched_feat
+
+#else
+
+#undef SCHED_FEAT_SYSCTL
+#define SCHED_FEAT(name, enabled)	\
+	(1UL << __SCHED_FEAT_##name) * enabled |
+#define SCHED_FEAT_SYSCTL(name, enabled)
+
+const_debug unsigned int const_sysctl_sched_features =
+#include "sched_features.h"
+	0;
+#define sched_feat(x) (const_sysctl_sched_features & (1 << __SCHED_FEAT_##x))
+#undef SCHED_FEAT
+#undef SCHED_FEAT_SYSCTL
+
+#define SCHED_FEAT(name, enable)
+#define SCHED_FEAT_SYSCTL(name, enabled)	\
+	(1UL << __SCHED_FEAT_##name) * enabled |
+
+unsigned int __read_mostly sysctl_sched_features =
+#include "sched_features.h"
+	0;
+#define sched_feat_sysctl(x) (sysctl_sched_features & (1 << __SCHED_FEAT_##x))
+#undef SCHED_FEAT
+#undef SCHED_FEAT_SYSCTL
+
+#endif

 /*
  * Number of tasks to iterate in a single balance run.
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 98345e4..679b17f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1167,7 +1167,8 @@ wake_affine(struct sched_domain
 	unsigned long weight;
 	int balanced;

-	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
+	if (!(this_sd->flags & SD_WAKE_AFFINE) ||
+	    !sched_feat_sysctl(AFFINE_WAKEUPS))
 		return 0;

 	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..fcc32a2 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,8 +1,8 @@
+SCHED_FEAT_SYSCTL(AFFINE_WAKEUPS, 1)
 SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
 SCHED_FEAT(NORMALIZED_SLEEPER, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
-SCHED_FEAT(AFFINE_WAKEUPS, 1)
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 0)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3d56fe7..74852c1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -297,14 +297,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_features",
-		.data		= &sysctl_sched_features,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_migration_cost",
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
@@ -344,6 +336,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_features",
+		.data		= &sysctl_sched_features,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.ctl_name	= CTL_UNNUMBERED,
