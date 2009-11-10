Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZKJCtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZKJCtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZKJCtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:49:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:52766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754002AbZKJCtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:49:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/YA08wsfLYSw91yELGe9CPd0ztdUGa8dVqJWB0ec
	YDOraEhew4A8xK
Subject: [patch 1/2] sched: Revert 1b9508f in preparation for new version
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 03:49:39 +0100
Message-Id: <1257821379.5648.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Revert 1b9508f in preparation for new version
    
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched.c       |   22 +---------------------
 kernel/sched_debug.c |    4 ----
 2 files changed, 1 insertion(+), 25 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -589,8 +589,6 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
-	u64 idle_stamp;
-	u64 avg_idle;
 #endif
 
 	/* calc_load related fields */
@@ -2383,17 +2381,6 @@ static int try_to_wake_up(struct task_st
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
 
@@ -4430,11 +4417,6 @@ static void idle_balance(int this_cpu, s
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
-	this_rq->idle_stamp = this_rq->clock;
-
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
-
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 
@@ -4449,10 +4431,8 @@ static void idle_balance(int this_cpu, s
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -285,16 +285,12 @@ static void print_cpu(struct seq_file *m
 
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
-#define P64(n) SEQ_printf(m, "  .%-30s: %Ld\n", #n, rq->n);
 
 	P(yld_count);
 
 	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
-#ifdef CONFIG_SMP
-	P64(avg_idle);
-#endif
 
 	P(ttwu_count);
 	P(ttwu_local);


