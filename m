Return-Path: <linux-kernel-owner+w=401wt.eu-S1763311AbZLQEv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311AbZLQEv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761558AbZLQEuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:50:51 -0500
Received: from kroah.org ([198.145.64.141]:55273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762978AbZLQEDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:42 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035644.782513558@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: [014/151] sched: Rate-limit newidle
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit 1b9508f6831e10d53256825de8904caa22d1ca2c upstream.

Rate limit newidle to migration_cost. It's a win for all
stages of sysbench oltp tests.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c       |   22 +++++++++++++++++++++-
 kernel/sched_debug.c |    4 ++++
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -591,6 +591,8 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
+	u64 idle_stamp;
+	u64 avg_idle;
 #endif
 
 	/* calc_load related fields */
@@ -2384,6 +2386,17 @@ static int try_to_wake_up(struct task_st
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
 
@@ -4429,6 +4442,11 @@ static void idle_balance(int this_cpu, s
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
+	this_rq->idle_stamp = this_rq->clock;
+
+	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+		return;
+
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 
@@ -4443,8 +4461,10 @@ static void idle_balance(int this_cpu, s
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
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -285,12 +285,16 @@ static void print_cpu(struct seq_file *m
 
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


