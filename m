Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYE2Qh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYE2Qh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYE2QhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:37:12 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33162 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYE2QhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:37:10 -0400
Date: Thu, 29 May 2008 22:16:07 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080529164607.GC12836@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483DA5E7.5050600@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 12:35:19PM -0600, Chris Friesen wrote:
> Looking much better, but still some fairness issues with more complex 
> setups.
>
> pid 2477 in A, others in B
> 2477	99.5%
> 2478	49.9%
> 2479	49.9%
>
> move 2478 to A
> 2479	99.9%
> 2477	49.9%
> 2478	49.9%
>
> So far so good.  I then created C, and moved 2478 to it.  A 3-second "top" 
> gave almost a 15% error from the desired behaviour for one group:
>
> 2479	76.2%
> 2477	72.2%
> 2478	51.0%
>
>
> A 10-sec average was better, but we still see errors of 6%:
> 2478	72.8%
> 2477	64.0%
> 2479	63.2%

Found couple of issues:

	1. A minor bug in load_balance_fair() in calculation of moved_load:

		moved_load /= busiest_cfs_rq->load.weight + 1;

	   In place of busiest_cfs_rq->load.weight, the load before
	   moving tasks needs to be used. Fix in the updated patch below.

	2. We walk task groups sequentially in load_balance_fair() w/o
	   necessarily looking for the best group. This results in
	   load_balance_fair() in picking non optimal group/tasks
	   to pull. I have a hack below (strict = 1/0) to rectify this
	   problem, but we need a better algo to pick the best group
	   from which to pull tasks.

	3. sd->imbalance_pct (default = 125) specifies how much imbalance we 
	   tolerate. Lower the value, better will be the fairness. To check 
	   this, I changed default to 105, which is giving me better
	   results.

With the updated patch and imbalance_pct = 105, here's how my 60-sec avg looks 
like:

 4353 root      20   0  1384  232  176 R 67.0  0.0   2:47.23  1 hoga
 4354 root      20   0  1384  228  176 R 66.5  0.0   2:44.65  1 hogb
 4355 root      20   0  1384  228  176 R 66.3  0.0   2:28.18  0 hogb

Error is < 1%

> I then set up a scenario with 3 tasks in A, 2 in B, and 1 in C.  A 
> 10-second "top" gave errors of up to 6.5%:
> 2500	60.1%
> 2491	37.5%
> 2492	37.4%
> 2489	25.0%
> 2488	19.9%
> 2490	19.9%
>
> a re-test gave errors of up to 8.1%:
>
> 2534	74.8%
> 2533	30.1%
> 2532	30.0%
> 2529	25.0%
> 2530	20.0%
> 2531	20.0%
>
> Another retest gave perfect results initially:
>
> 2559	66.5%
> 2560	33.4%
> 2561	33.3%
> 2564	22.3%
> 2562	22.2%
> 2563	22.1%
>
> but moving 2564 from group A to C and then back to A disturbed the perfect 
> division of time and resulted in almost the same utilization pattern as 
> above:
>
> 2559	74.9%
> 2560	30.0%
> 2561	29.6%
> 2564	25.3%
> 2562	20.0%
> 2563	20.0%

Again with the updated patch and changed imbalance_pct, here's what I see:

 4458 root      20   0  1384  232  176 R 66.3  0.0   2:11.04  0 hogc
 4457 root      20   0  1384  232  176 R 33.7  0.0   1:06.19  0 hogb
 4456 root      20   0  1384  232  176 R 33.4  0.0   1:06.59  0 hogb
 4455 root      20   0  1384  228  176 R 22.5  0.0   0:44.09  0 hoga
 4453 root      20   0  1384  232  176 R 22.3  0.0   0:44.10  1 hoga
 4454 root      20   0  1384  228  176 R 22.2  0.0   0:43.94  1 hoga

(Error < 1%)

In summary, can you do this before running your tests:

1. Apply updated patch below on top of 2.6.26-rc3 + Peter's patches
(http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/)

2. Setup test env as below:

	# mkdir /cgroup
	# mount -t cgroup -ocpu none /cgroup
	# cd /cgroup

	# #Move all tasks to 'sys' group and give it low shares
	# mkdir sys
	# cd sys
	# for i in `cat ../tasks`
	  do
		echo $i > tasks
	  done
	# echo 100 > cpu.shares

	# cd /proc/sys/kernel/sched_domain
	# for i in `find . -name imbalance_pct`; do echo 105 > $i; done


---
 init/Kconfig         |    2 +-
 kernel/sched.c       |   12 +++++++++---
 kernel/sched_debug.c |    3 ++-
 kernel/sched_fair.c  |   26 +++++++++++++++++---------
 4 files changed, 29 insertions(+), 14 deletions(-)

Index: current/init/Kconfig
===================================================================
--- current.orig/init/Kconfig
+++ current/init/Kconfig
@@ -349,7 +349,7 @@ config RT_GROUP_SCHED
 	  See Documentation/sched-rt-group.txt for more information.
 
 choice
-	depends on GROUP_SCHED
+	depends on GROUP_SCHED && (FAIR_GROUP_SCHED || RT_GROUP_SCHED)
 	prompt "Basis for grouping tasks"
 	default USER_SCHED
 
Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1398,7 +1398,7 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator);
+	      int *this_best_prio, struct rq_iterator *iterator, int strict);
 
 static int
 iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
@@ -1534,6 +1534,9 @@ tg_shares_up(struct task_group *tg, int 
 	unsigned long shares = 0;
 	int i;
 
+	if (!tg->parent)
+		return;
+
 	for_each_cpu_mask(i, sd->span) {
 		rq_weight += tg->cfs_rq[i]->load.weight;
 		shares += tg->cfs_rq[i]->shares;
@@ -2896,7 +2899,7 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator)
+	      int *this_best_prio, struct rq_iterator *iterator, int strict)
 {
 	int loops = 0, pulled = 0, pinned = 0, skip_for_load;
 	struct task_struct *p;
@@ -2919,7 +2922,10 @@ next:
 	 * skip a task if it will be the highest priority task (i.e. smallest
 	 * prio value) on its new queue regardless of its load weight
 	 */
-	skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
+	if (strict)
+		skip_for_load = p->se.load.weight >= rem_load_move;
+	else
+		skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
 							 SCHED_LOAD_SCALE_FUZZ;
 	if ((skip_for_load && p->prio >= *this_best_prio) ||
 	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
Index: current/kernel/sched_debug.c
===================================================================
--- current.orig/kernel/sched_debug.c
+++ current/kernel/sched_debug.c
@@ -119,7 +119,7 @@ void print_cfs_rq(struct seq_file *m, in
 	struct sched_entity *last;
 	unsigned long flags;
 
-#if !defined(CONFIG_CGROUP_SCHED) || !defined(CONFIG_USER_SCHED)
+#ifndef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #else
 	char path[128] = "";
@@ -170,6 +170,7 @@ void print_cfs_rq(struct seq_file *m, in
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
+	SEQ_printf(m, "  .%-30s: %lu\n", "h_load", cfs_rq->h_load);
 #endif
 #endif
 }
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -1386,9 +1386,6 @@ __load_balance_iterator(struct cfs_rq *c
 		next = next->next;
 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
 	cfs_rq->balance_iterator = next;
 
 	if (entity_is_task(se))
@@ -1415,7 +1412,7 @@ static unsigned long
 __load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long max_load_move, struct sched_domain *sd,
 		enum cpu_idle_type idle, int *all_pinned, int *this_best_prio,
-		struct cfs_rq *cfs_rq)
+		struct cfs_rq *cfs_rq, int strict)
 {
 	struct rq_iterator cfs_rq_iterator;
 
@@ -1425,10 +1422,11 @@ __load_balance_fair(struct rq *this_rq, 
 
 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &cfs_rq_iterator);
+			this_best_prio, &cfs_rq_iterator, strict);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -1438,13 +1436,17 @@ load_balance_fair(struct rq *this_rq, in
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
 	struct task_group *tg;
+	int strict = 1;
 
 	update_h_load(cpu_of(busiest));
 
 	rcu_read_lock();
+
+retry:
 	list_for_each_entry(tg, &task_groups, list) {
 		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
 		long rem_load, moved_load;
+		unsigned long busiest_cfs_rq_load;
 
 		/*
 		 * empty group
@@ -1452,25 +1454,31 @@ load_balance_fair(struct rq *this_rq, in
 		if (!busiest_cfs_rq->task_weight)
 			continue;
 
-		rem_load = rem_load_move * busiest_cfs_rq->load.weight;
+		busiest_cfs_rq_load = busiest_cfs_rq->load.weight;
+		rem_load = rem_load_move * busiest_cfs_rq_load;
 		rem_load /= busiest_cfs_rq->h_load + 1;
 
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
-				tg->cfs_rq[busiest_cpu]);
+				tg->cfs_rq[busiest_cpu], strict);
 
 		if (!moved_load)
 			continue;
 
 		moved_load *= busiest_cfs_rq->h_load;
-		moved_load /= busiest_cfs_rq->load.weight + 1;
+		moved_load /= busiest_cfs_rq_load + 1;
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)
 			break;
 	}
+
+	if (rem_load_move && strict--)
+		goto retry;
+
 	rcu_read_unlock();
 
+
 	return max_load_move - rem_load_move;
 }
 #else
@@ -1482,7 +1490,7 @@ load_balance_fair(struct rq *this_rq, in
 {
 	return __load_balance_fair(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
+			this_best_prio, &busiest->cfs, 0);
 }
 #endif
 


-- 
Regards,
vatsa
