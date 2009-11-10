Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZKJEWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZKJEWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZKJEW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:22:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:45899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbZKJEW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:22:28 -0500
Date: Tue, 10 Nov 2009 04:21:47 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com, efault@gmx.de,
       alex.shi@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, yanmin_zhang@linux.intel.com,
       alex.shi@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257821402.5648.17.camel@marge.simson.net>
References: <1257821402.5648.17.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix and clean up rate-limit newidle code
Message-ID: <tip-eae0c9dfb534cb3449888b9601228efa6480fdb5@git.kernel.org>
Git-Commit-ID: eae0c9dfb534cb3449888b9601228efa6480fdb5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eae0c9dfb534cb3449888b9601228efa6480fdb5
Gitweb:     http://git.kernel.org/tip/eae0c9dfb534cb3449888b9601228efa6480fdb5
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 10 Nov 2009 03:50:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 04:25:58 +0100

sched: Fix and clean up rate-limit newidle code

Commit 1b9508f, "Rate-limit newidle" has been confirmed to fix
the netperf UDP loopback regression reported by Alex Shi.

This is a cleanup and a fix:

 - moved to a more out of the way spot

 - fix to ensure that balancing doesn't try to balance
   runqueues which haven't gone online yet, which can
   mess up CPU enumeration during boot.

Reported-by: Alex Shi <alex.shi@intel.com>
Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for an idle shared cache
Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
Cc: <stable@kernel.org> # .32.x
LKML-Reference: <1257821402.5648.17.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 23e3535..ad37776 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2354,17 +2354,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (rq != orig_rq)
 		update_rq_clock(rq);
 
-	if (rq->idle_stamp) {
-		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
-
-		if (delta > max)
-			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
-		rq->idle_stamp = 0;
-	}
-
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
@@ -2421,6 +2410,17 @@ out_running:
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
+
+	if (unlikely(rq->idle_stamp)) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
 #endif
 out:
 	task_rq_unlock(rq, &flags);
@@ -4098,7 +4098,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4261,7 +4261,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -9522,6 +9522,8 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->online = 0;
 		rq->migration_thread = NULL;
+		rq->idle_stamp = 0;
+		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
 #endif
