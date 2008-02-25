Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYBYMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYBYMXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYBYMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:23:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60640 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbYBYMXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:23:07 -0500
Subject: [PATCH] sched: revert load_balance_monitor()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 13:22:47 +0100
Message-Id: <1203942167.6242.142.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: revert load_balance_monitor()

The following commit causes a number of serious regressions:

  commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
  Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
  Date:   Fri Jan 25 21:08:00 2008 +0100
  sched: group scheduler, fix fairness of cpu bandwidth allocation for task groups

Namely:
 - very frequent wakeups on SMP, reported by PowerTop users.
 - cacheline trashing on (large) SMP
 - some latencies larger than 500ms

While there is a mergeable patch to fix the latter, the former issues
are IMHO not fixable in a manner suitable for .25 (we're at -rc3 now).
Hence I propose to revert this patch and try again for .26.

( minimal revert - leaves most of the code present, just removes the activation
  and sysctl interface ).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 include/linux/sched.h |    4 ----
 kernel/sched.c        |   15 ---------------
 kernel/sysctl.c       |   18 ------------------
 3 files changed, 37 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1541,10 +1541,6 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
-extern unsigned int sysctl_sched_min_bal_int_shares;
-extern unsigned int sysctl_sched_max_bal_int_shares;
-#endif
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7083,21 +7083,6 @@ void __init sched_init_smp(void)
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	if (nr_cpu_ids == 1)
-		return;
-
-	lb_monitor_task = kthread_create(load_balance_monitor, NULL,
-					 "group_balance");
-	if (!IS_ERR(lb_monitor_task)) {
-		lb_monitor_task->flags |= PF_NOFREEZE;
-		wake_up_process(lb_monitor_task);
-	} else {
-		printk(KERN_ERR "Could not create load balance monitor thread"
-			"(error = %ld) \n", PTR_ERR(lb_monitor_task));
-	}
-#endif
 }
 #else
 void __init sched_init_smp(void)
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -311,24 +311,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
-	{
-		.ctl_name       = CTL_UNNUMBERED,
-		.procname       = "sched_min_bal_int_shares",
-		.data           = &sysctl_sched_min_bal_int_shares,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-	{
-		.ctl_name       = CTL_UNNUMBERED,
-		.procname       = "sched_max_bal_int_shares",
-		.data           = &sysctl_sched_max_bal_int_shares,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-#endif
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,


