Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZLWPO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZLWPO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZLWPOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:14:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbZLWPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:14:24 -0500
Subject: [PATCH 7/6][RFC] sched: unify load_balance{,_newidle}()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20091217185021.684424629@chello.nl>
References: <20091217185021.684424629@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 16:13:36 +0100
Message-ID: <1261581216.4937.150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


load_balance() and load_balance_newidle() look remarkably similar, one
key point they differ in is the condition on when to active balance.

So split out that logic into a separate function.

One side effect is that previously load_balance_newidle() used to fail and
return -1 under these conditions, whereas now it doesn't. I've not yet fully
figured out the whole -1 return case for either load_balance{,_newidle}().

It also differs in that sd->cache_nice_tries is now added on the 
CPU_NEWLY_IDLE case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |  115 ++++++++++++++++++++++++++--------------------------
 1 file changed, 59 insertions(+), 56 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -2816,6 +2816,39 @@ find_busiest_queue(struct sched_group *g
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
+static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
+{
+	if (idle == CPU_NEWLY_IDLE) {
+		/*
+		 * The only task running in a non-idle cpu can be moved to this
+		 * cpu in an attempt to completely freeup the other CPU
+		 * package.
+		 *
+		 * The package power saving logic comes from
+		 * find_busiest_group(). If there are no imbalance, then
+		 * f_b_g() will return NULL. However when sched_mc={1,2} then
+		 * f_b_g() will select a group from which a running task may be
+		 * pulled to this cpu in order to make the other package idle.
+		 * If there is no opportunity to make a package idle and if
+		 * there are no imbalance, then f_b_g() will return NULL and no
+		 * action will be taken in load_balance_newidle().
+		 *
+		 * Under normal task pull operation due to imbalance, there
+		 * will be more than one task in the source run queue and
+		 * move_tasks() will succeed.  ld_moved will be true and this
+		 * active balance code will not be triggered.
+		 */
+		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
+		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+			return 0;
+
+		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+			return 0;
+	}
+
+	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
+}
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
@@ -2902,8 +2935,7 @@ redo:
 		schedstat_inc(sd, lb_failed[idle]);
 		sd->nr_balance_failed++;
 
-		if (unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2)) {
-
+		if (need_active_balance(sd, sd_idle, idle)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the migration_thread, if the curr
@@ -3049,66 +3081,37 @@ redo:
 		int active_balance = 0;
 
 		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
-		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-			return -1;
-
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
-			return -1;
+		sd->nr_balance_failed++;
 
-		if (sd->nr_balance_failed++ < 2)
-			return -1;
+		if (need_active_balance(sd, sd_idle, CPU_NEWLY_IDLE)) {
+			double_lock_balance(this_rq, busiest);
 
-		/*
-		 * The only task running in a non-idle cpu can be moved to this
-		 * cpu in an attempt to completely freeup the other CPU
-		 * package. The same method used to move task in load_balance()
-		 * have been extended for load_balance_newidle() to speedup
-		 * consolidation at sched_mc=POWERSAVINGS_BALANCE_WAKEUP (2)
-		 *
-		 * The package power saving logic comes from
-		 * find_busiest_group().  If there are no imbalance, then
-		 * f_b_g() will return NULL.  However when sched_mc={1,2} then
-		 * f_b_g() will select a group from which a running task may be
-		 * pulled to this cpu in order to make the other package idle.
-		 * If there is no opportunity to make a package idle and if
-		 * there are no imbalance, then f_b_g() will return NULL and no
-		 * action will be taken in load_balance_newidle().
-		 *
-		 * Under normal task pull operation due to imbalance, there
-		 * will be more than one task in the source run queue and
-		 * move_tasks() will succeed.  ld_moved will be true and this
-		 * active balance code will not be triggered.
-		 */
+			/*
+			 * don't kick the migration_thread, if the curr
+			 * task on busiest cpu can't be moved to this_cpu
+			 */
+			if (!cpumask_test_cpu(this_cpu,
+					      &busiest->curr->cpus_allowed)) {
+				double_unlock_balance(this_rq, busiest);
+				all_pinned = 1;
+				return ld_moved;
+			}
 
-		/* Lock busiest in correct order while this_rq is held */
-		double_lock_balance(this_rq, busiest);
+			if (!busiest->active_balance) {
+				busiest->active_balance = 1;
+				busiest->push_cpu = this_cpu;
+				active_balance = 1;
+			}
 
-		/*
-		 * don't kick the migration_thread, if the curr
-		 * task on busiest cpu can't be moved to this_cpu
-		 */
-		if (!cpumask_test_cpu(this_cpu, &busiest->curr->cpus_allowed)) {
 			double_unlock_balance(this_rq, busiest);
-			all_pinned = 1;
-			return ld_moved;
-		}
-
-		if (!busiest->active_balance) {
-			busiest->active_balance = 1;
-			busiest->push_cpu = this_cpu;
-			active_balance = 1;
+			/*
+			 * Should not call ttwu while holding a rq->lock
+			 */
+			raw_spin_unlock(&this_rq->lock);
+			if (active_balance)
+				wake_up_process(busiest->migration_thread);
+			raw_spin_lock(&this_rq->lock);
 		}
-
-		double_unlock_balance(this_rq, busiest);
-		/*
-		 * Should not call ttwu while holding a rq->lock
-		 */
-		raw_spin_unlock(&this_rq->lock);
-		if (active_balance)
-			wake_up_process(busiest->migration_thread);
-		raw_spin_lock(&this_rq->lock);
-
 	} else
 		sd->nr_balance_failed = 0;
 


