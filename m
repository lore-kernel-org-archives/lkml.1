Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZLWPON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZLWPON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZLWPOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:14:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:44010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZLWPOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:14:11 -0500
Subject: [PATCH 8/6][RFC] sched: Remove load_balance_newidle()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20091217185021.684424629@chello.nl>
References: <20091217185021.684424629@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 16:13:38 +0100
Message-ID: <1261581218.4937.151.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The two functions: load_balance{,_newidle}() are very similar, with the
following differences:
 - rq->lock usage
 - sb->balance_interval updates
 - *balance check

So remove the load_balance_newidle() call with 
load_balance(.idle = CPU_NEWLY_IDLE), explicitly unlock the rq->lock before
calling (would be done by double_lock_balance() anyway), and ignore the other
differences for now.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |  135 +++++-----------------------------------------------
 1 file changed, 13 insertions(+), 122 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -3010,125 +3010,6 @@ out:
 }
 
 /*
- * Check this_cpu to ensure it is balanced within domain. Attempt to move
- * tasks if there is an imbalance.
- *
- * Called from schedule when this_rq is about to become idle (CPU_NEWLY_IDLE).
- * this_rq is locked.
- */
-static int
-load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
-{
-	struct sched_group *group;
-	struct rq *busiest = NULL;
-	unsigned long imbalance;
-	int ld_moved = 0;
-	int sd_idle = 0;
-	int all_pinned = 0;
-	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
-
-	cpumask_copy(cpus, cpu_active_mask);
-
-	/*
-	 * When power savings policy is enabled for the parent domain, idle
-	 * sibling can pick up load irrespective of busy siblings. In this case,
-	 * let the state of idle sibling percolate up as IDLE, instead of
-	 * portraying it as CPU_NOT_IDLE.
-	 */
-	if (sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		sd_idle = 1;
-
-	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
-redo:
-	update_shares_locked(this_rq, sd);
-	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
-				   &sd_idle, cpus, NULL);
-	if (!group) {
-		schedstat_inc(sd, lb_nobusyg[CPU_NEWLY_IDLE]);
-		goto out_balanced;
-	}
-
-	busiest = find_busiest_queue(group, CPU_NEWLY_IDLE, imbalance, cpus);
-	if (!busiest) {
-		schedstat_inc(sd, lb_nobusyq[CPU_NEWLY_IDLE]);
-		goto out_balanced;
-	}
-
-	BUG_ON(busiest == this_rq);
-
-	schedstat_add(sd, lb_imbalance[CPU_NEWLY_IDLE], imbalance);
-
-	ld_moved = 0;
-	if (busiest->nr_running > 1) {
-		/* Attempt to move tasks */
-		double_lock_balance(this_rq, busiest);
-		/* this_rq->clock is already updated */
-		update_rq_clock(busiest);
-		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-					imbalance, sd, CPU_NEWLY_IDLE,
-					&all_pinned);
-		double_unlock_balance(this_rq, busiest);
-
-		if (unlikely(all_pinned)) {
-			cpumask_clear_cpu(cpu_of(busiest), cpus);
-			if (!cpumask_empty(cpus))
-				goto redo;
-		}
-	}
-
-	if (!ld_moved) {
-		int active_balance = 0;
-
-		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
-		sd->nr_balance_failed++;
-
-		if (need_active_balance(sd, sd_idle, CPU_NEWLY_IDLE)) {
-			double_lock_balance(this_rq, busiest);
-
-			/*
-			 * don't kick the migration_thread, if the curr
-			 * task on busiest cpu can't be moved to this_cpu
-			 */
-			if (!cpumask_test_cpu(this_cpu,
-					      &busiest->curr->cpus_allowed)) {
-				double_unlock_balance(this_rq, busiest);
-				all_pinned = 1;
-				return ld_moved;
-			}
-
-			if (!busiest->active_balance) {
-				busiest->active_balance = 1;
-				busiest->push_cpu = this_cpu;
-				active_balance = 1;
-			}
-
-			double_unlock_balance(this_rq, busiest);
-			/*
-			 * Should not call ttwu while holding a rq->lock
-			 */
-			raw_spin_unlock(&this_rq->lock);
-			if (active_balance)
-				wake_up_process(busiest->migration_thread);
-			raw_spin_lock(&this_rq->lock);
-		}
-	} else
-		sd->nr_balance_failed = 0;
-
-	update_shares_locked(this_rq, sd);
-	return ld_moved;
-
-out_balanced:
-	schedstat_inc(sd, lb_balanced[CPU_NEWLY_IDLE]);
-	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	sd->nr_balance_failed = 0;
-
-	return 0;
-}
-
-/*
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
@@ -3143,16 +3024,23 @@ static void idle_balance(int this_cpu, s
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	/*
+	 * Drop the rq->lock, but keep IRQ/preempt disabled.
+	 */
+	raw_spin_unlock(&this_rq->lock);
+
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
+		int balance = 0;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-		if (sd->flags & SD_BALANCE_NEWIDLE)
+		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			/* If we've pulled tasks over stop searching: */
-			pulled_task = load_balance_newidle(this_cpu, this_rq,
-							   sd);
+			pulled_task = load_balance(this_cpu, this_rq,
+						   sd, CPU_NEWLY_IDLE, &balance);
+		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
@@ -3162,6 +3050,9 @@ static void idle_balance(int this_cpu, s
 			break;
 		}
 	}
+
+	raw_spin_lock(&this_rq->lock);
+
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
 		 * We are going idle. next_balance may be set based on


