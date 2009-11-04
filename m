Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZKDTeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZKDTeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbZKDTeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:34:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:60239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZKDTeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:34:16 -0500
Date: Wed, 4 Nov 2009 19:33:48 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rate-limit newidle
Message-ID: <tip-1b9508f6831e10d53256825de8904caa22d1ca2c@git.kernel.org>
Git-Commit-ID: 1b9508f6831e10d53256825de8904caa22d1ca2c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b9508f6831e10d53256825de8904caa22d1ca2c
Gitweb:     http://git.kernel.org/tip/1b9508f6831e10d53256825de8904caa22d1ca2c
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 4 Nov 2009 17:53:50 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 19:13:48 +0100

sched: Rate-limit newidle

Rate limit newidle to migration_cost. It's a win for all
stages of sysbench oltp tests.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c       |   22 +++++++++++++++++++++-
 kernel/sched_debug.c |    4 ++++
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ae026aa..f849212 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -589,6 +589,8 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
+	u64 idle_stamp;
+	u64 avg_idle;
 #endif
 
 	/* calc_load related fields */
@@ -2353,6 +2355,17 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (rq != orig_rq)
 		update_rq_clock(rq);
 
+	if (rq->idle_stamp) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
+
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
@@ -4389,6 +4402,11 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
+	this_rq->idle_stamp = this_rq->clock;
+
+	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+		return;
+
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 
@@ -4403,8 +4421,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
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
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index efb8440..6988cf0 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -285,12 +285,16 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+#define P64(n) SEQ_printf(m, "  .%-30s: %Ld\n", #n, rq->n);
 
 	P(yld_count);
 
 	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
+#ifdef CONFIG_SMP
+	P64(avg_idle);
+#endif
 
 	P(ttwu_count);
 	P(ttwu_local);
