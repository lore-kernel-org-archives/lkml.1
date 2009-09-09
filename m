Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZIIPjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZIIPjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZIIPjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:39:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:54940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbZIIPjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:39:39 -0400
Date: Wed, 9 Sep 2009 15:37:07 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1252486344.28645.18.camel@marge.simson.net>
References: <1252486344.28645.18.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Turn off child_runs_first
Message-ID: <tip-2bba22c50b06abe9fd0d23933b1e64d35b419262@git.kernel.org>
Git-Commit-ID: 2bba22c50b06abe9fd0d23933b1e64d35b419262
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 09 Sep 2009 15:37:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bba22c50b06abe9fd0d23933b1e64d35b419262
Gitweb:     http://git.kernel.org/tip/2bba22c50b06abe9fd0d23933b1e64d35b419262
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 9 Sep 2009 15:41:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Sep 2009 17:30:05 +0200

sched: Turn off child_runs_first

Set child_runs_first default to off.

It hurts 'optimal' make -j<NR_CPUS> workloads as make jobs
get preempted by child tasks, reducing parallelism.

Note, this patch might make existing races in user
applications more prominent than before - so breakages
might be bisected to this commit.

Child-runs-first is broken on SMP to begin with, and we
already had it off briefly in v2.6.23 so most of the
offenders ought to be fixed. Would be nice not to revert
this commit but fix those apps finally ...

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1252486344.28645.18.camel@marge.simson.net>
[ made the sysctl independent of CONFIG_SCHED_DEBUG, in case
  people want to work around broken apps. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    2 +-
 kernel/sched_fair.c   |    4 ++--
 kernel/sysctl.c       |   16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3b7f43e..3a50e82 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1820,8 +1820,8 @@ extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_shares_ratelimit;
 extern unsigned int sysctl_sched_shares_thresh;
-#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_child_runs_first;
+#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e386e5d..af325a3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -48,10 +48,10 @@ unsigned int sysctl_sched_min_granularity = 4000000ULL;
 static unsigned int sched_nr_latency = 5;
 
 /*
- * After fork, child runs first. (default) If set to 0 then
+ * After fork, child runs first. If set to 0 (default) then
  * parent will (try to) run first.
  */
-const_debug unsigned int sysctl_sched_child_runs_first = 1;
+unsigned int sysctl_sched_child_runs_first __read_mostly;
 
 /*
  * sys_sched_yield() compat mode
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6c9836e..25d6bf3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -246,6 +246,14 @@ static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_child_runs_first",
+		.data		= &sysctl_sched_child_runs_first,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -300,14 +308,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_child_runs_first",
-		.data		= &sysctl_sched_child_runs_first,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_features",
 		.data		= &sysctl_sched_features,
 		.maxlen		= sizeof(unsigned int),
