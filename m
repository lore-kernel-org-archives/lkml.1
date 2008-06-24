Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbYFXOQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbYFXOQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760290AbYFXOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:16:29 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:5019 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbYFXOQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:16:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/3] sched: enable interrupts and drop rq-lock during newidle
	balancing
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, ghaskins@novell.com, dbahi@novell.com,
       npiggin@suse.de
Date: Tue, 24 Jun 2008 08:16:07 -0600
Message-ID: <20080624141607.28487.75030.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080624141527.28487.77778.stgit@lsg.lsg.lab.novell.com>
References: <20080624141527.28487.77778.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oprofile data shows that the system may spend a significant amount of
time (60%+) in find_busiest_groups as a result of newidle balancing.  This
entire operation is a critical section since it occurs inline with
a schedule().  Since we do find_busiest_groups() et. al. without locks
held for normal balancing, lets do it for newidle as well.  It will
at least allow other cpus and interrupts to make forward progress
(against our RQ) while we try to balance.

Additionally, we abort the newidle processing if we are preempted.

This patch should both improve latency response, as well as increase
throughput.  It has shown to significantly contribute to a 6-12%
increase in network peformance.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   40 +++++++++++++++++++++++++++++++++-------
 1 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 54b27b4..e40c575 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3335,6 +3335,15 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	cpumask_t cpus = sd->span;
 	int remain = cpus_weight(sd->span) - 1;
 
+	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
+
+	/*
+	 * We are in a preempt-disabled section, so dropping the lock/irq
+	 * here simply means that other cores may acquire the lock,
+	 * and interrupts may occur.
+	 */
+	spin_unlock_irq(&this_rq->lock);
+
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -3345,7 +3354,6 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 		sd_idle = 1;
 
-	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
 redo:
 	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
 				   &sd_idle, &cpus, NULL);
@@ -3366,22 +3374,37 @@ redo:
 	schedstat_add(sd, lb_imbalance[CPU_NEWLY_IDLE], imbalance);
 
 	ld_moved = 0;
-	if (busiest->nr_running > 1) {
+	if (!need_resched() && busiest->nr_running > 1) {
 		/* Attempt to move tasks */
-		double_lock_balance(this_rq, busiest);
-		/* this_rq->clock is already updated */
-		update_rq_clock(busiest);
+		local_irq_disable();
+		double_rq_lock(this_rq, busiest);
+
+		BUG_ON(this_cpu != smp_processor_id());
+
+		/*
+		 * Checking rq->nr_running covers both the case where
+		 * newidle-balancing pulls a task, as well as if something
+		 * else issued a NEEDS_RESCHED (since we would only need
+		 * a reschedule if something was moved to us)
+		 */
+		if (this_rq->nr_running) {
+			spin_unlock(&busiest->lock);
+			goto out_balanced_locked;
+		}
+
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 					imbalance, sd, CPU_NEWLY_IDLE,
 					&all_pinned);
 		spin_unlock(&busiest->lock);
 
-		if (unlikely(all_pinned && remain)) {
+		if (unlikely(all_pinned && remain && !this_rq->nr_running)) {
+			spin_unlock_irq(&this_rq->lock);
 			cpu_clear(cpu_of(busiest), cpus);
 			remain--;
 			goto redo;
 		}
-	}
+	} else
+		spin_lock_irq(&this_rq->lock);
 
 	if (!ld_moved) {
 		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
@@ -3394,6 +3417,9 @@ redo:
 	return ld_moved;
 
 out_balanced:
+	spin_lock_irq(&this_rq->lock);
+
+out_balanced_locked:
 	schedstat_inc(sd, lb_balanced[CPU_NEWLY_IDLE]);
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))

