Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZKJCuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZKJCuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZKJCuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:50:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:36311 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755495AbZKJCuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:50:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wvFwvazewVBc7WNruSSoLP6VyMOkb0j0T4MRiv6
	h/xRd8ETNy3lNO
Subject: [patch 2/2] sched: Fix and rate-limit newidle
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, "alex.shi" <alex.shi@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 03:50:02 +0100
Message-Id: <1257821402.5648.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: Fix and rate-limit newidle

Commit 1b9508f, "Rate-limit newidle" has been confirmed to fix the netperf
UDP loopback regression reported by Alex Shi.  This is a replacement, moved
to a more out of the way spot, and with a fix to ensure that balancing
doesn't try to balance runqueues which haven't gone online yet, which can
mess up CPU enumeration during boot.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Alex Shi <alex.shi@intel.com>
Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c       |   28 +++++++++++++++++++++++++---
 kernel/sched_debug.c |    2 ++
 2 files changed, 27 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -589,6 +589,8 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
+	u64 idle_stamp;
+	u64 avg_idle;
 #endif
 
 	/* calc_load related fields */
@@ -2437,6 +2439,17 @@ out_running:
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
@@ -4114,7 +4127,7 @@ static int load_balance(int this_cpu, st
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4277,7 +4290,7 @@ load_balance_newidle(int this_cpu, struc
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4417,6 +4430,11 @@ static void idle_balance(int this_cpu, s
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
+	this_rq->idle_stamp = this_rq->clock;
+
+	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+		return;
+
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 
@@ -4431,8 +4449,10 @@ static void idle_balance(int this_cpu, s
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task)
+		if (pulled_task) {
+			this_rq->idle_stamp = 0;
 			break;
+		}
 	}
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -9535,6 +9555,8 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->online = 0;
 		rq->migration_thread = NULL;
+		rq->idle_stamp = 0;
+		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
 #endif
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -285,12 +285,14 @@ static void print_cpu(struct seq_file *m
 
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+#define P64(n) SEQ_printf(m, "  .%-30s: %Ld\n", #n, rq->n);
 
 	P(yld_count);
 
 	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
+	P64(avg_idle);
 
 	P(ttwu_count);
 	P(ttwu_local);


