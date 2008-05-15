Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYEORBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYEORBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYEORBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:01:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50205 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYEORBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:01:40 -0400
Date: Thu, 15 May 2008 22:40:42 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080515171042.GG14823@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080512023758.GN3612@linux.vnet.ibm.com> <1210563200.3151.10.camel@ymzhang> <20080512045246.GP3612@linux.vnet.ibm.com> <1210568533.3151.13.camel@ymzhang> <1210583090.7402.4.camel@marge.simson.net> <1210584047.6524.12.camel@lappy.programming.kicks-ass.net> <20080514134414.GA12693@linux.vnet.ibm.com> <1210777967.10126.17.camel@twins> <20080515082033.GA14823@linux.vnet.ibm.com> <1210840898.21616.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210840898.21616.27.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:41:38AM +0200, Peter Zijlstra wrote:
> Yes - and that should not be too big an issue as long as we can deal
> with it.
> 
> Any number we'll put to it will be based on a snapshot of the state so
> we're wrong no matter what we do. The trick is trying to keep sane.

more than staleness, interspersing of writes/reads is my concern.

Lets say that CPU0 is updating tg->cfs_rq[0]->aggregate.load,shares,rq_weight 
at CPU domain (comprising of cpu 0-7). That will result in writes in this order:

	->rq_weight = ?
	->task_weight = ?
	->shares = ?
	->load = ?

At the same time, CPU1 could be doing a load_balance_fair() in SMT
domain, reading the above same words in this order:

	->rq_weight
	->load
	->task_weight
	->shares

What if the writes (on cpu0) and reads (on cpu1) are interspersed? Won't
it give incoherent results for the reader?

> My current stack on top of sched-devel:
> 
> http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/

Doesnt improve things here (8-way Intel Xeon with SCHED_SMT set):

2.6.25 							     : 21762.4
2.6.26-rc1 + sched_devel 				     : 17937.5 (-17.6%)
2.6.26-rc1 + sched_devel + your patches 		     : 17047   (-21.6%)
2.6.26-rc1 + sched_devel + patch_below  		     : 18368.9 (-15.6%)
2.6.26-rc1 + sched_devel + patch_below + ^NORMALIZED_SLEEPER : 19589.6 (-9.9%)

I will check if patch_below + your patches help close down the gap (tomorrow):


---
 kernel/sched.c      |   98 ++++++++++++++++++++++++++--------------------------
 kernel/sched_fair.c |   26 +++++--------
 2 files changed, 61 insertions(+), 63 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1568,12 +1568,12 @@ static int task_hot(struct task_struct *
  */
 
 static inline struct aggregate_struct *
-aggregate(struct task_group *tg, struct sched_domain *sd)
+aggregate(struct task_group *tg, int this_cpu)
 {
-	return &tg->cfs_rq[sd->first_cpu]->aggregate;
+	return &tg->cfs_rq[this_cpu]->aggregate;
 }
 
-typedef void (*aggregate_func)(struct task_group *, struct sched_domain *);
+typedef void (*aggregate_func)(struct task_group *, struct sched_domain *, int);
 
 /*
  * Iterate the full tree, calling @down when first entering a node and @up when
@@ -1581,14 +1581,14 @@ typedef void (*aggregate_func)(struct ta
  */
 static
 void aggregate_walk_tree(aggregate_func down, aggregate_func up,
-			 struct sched_domain *sd)
+			 struct sched_domain *sd, int this_cpu)
 {
 	struct task_group *parent, *child;
 
 	rcu_read_lock();
 	parent = &root_task_group;
 down:
-	(*down)(parent, sd);
+	(*down)(parent, sd, this_cpu);
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1596,7 +1596,7 @@ down:
 up:
 		continue;
 	}
-	(*up)(parent, sd);
+	(*up)(parent, sd, this_cpu);
 
 	child = parent;
 	parent = parent->parent;
@@ -1609,7 +1609,8 @@ up:
  * Calculate the aggregate runqueue weight.
  */
 static
-void aggregate_group_weight(struct task_group *tg, struct sched_domain *sd)
+void aggregate_group_weight(struct task_group *tg, struct sched_domain *sd,
+				int this_cpu)
 {
 	unsigned long rq_weight = 0;
 	unsigned long task_weight = 0;
@@ -1620,15 +1621,16 @@ void aggregate_group_weight(struct task_
 		task_weight += tg->cfs_rq[i]->task_weight;
 	}
 
-	aggregate(tg, sd)->rq_weight = rq_weight;
-	aggregate(tg, sd)->task_weight = task_weight;
+	aggregate(tg, this_cpu)->rq_weight = rq_weight;
+	aggregate(tg, this_cpu)->task_weight = task_weight;
 }
 
 /*
  * Compute the weight of this group on the given cpus.
  */
 static
-void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd)
+void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd,
+				int this_cpu)
 {
 	unsigned long shares = 0;
 	int i;
@@ -1636,10 +1638,11 @@ void aggregate_group_shares(struct task_
 	for_each_cpu_mask(i, sd->span)
 		shares += tg->cfs_rq[i]->shares;
 
-	if ((!shares && aggregate(tg, sd)->rq_weight) || shares > tg->shares)
+	if ((!shares && aggregate(tg, this_cpu)->rq_weight) ||
+						 shares > tg->shares)
 		shares = tg->shares;
 
-	aggregate(tg, sd)->shares = shares;
+	aggregate(tg, this_cpu)->shares = shares;
 }
 
 /*
@@ -1647,7 +1650,8 @@ void aggregate_group_shares(struct task_
  * weight and this group's parent's load, i.e. top-down.
  */
 static
-void aggregate_group_load(struct task_group *tg, struct sched_domain *sd)
+void aggregate_group_load(struct task_group *tg, struct sched_domain *sd,
+					int this_cpu)
 {
 	unsigned long load;
 
@@ -1659,17 +1663,17 @@ void aggregate_group_load(struct task_gr
 			load += cpu_rq(i)->load.weight;
 
 	} else {
-		load = aggregate(tg->parent, sd)->load;
+		load = aggregate(tg->parent, this_cpu)->load;
 
 		/*
 		 * shares is our weight in the parent's rq so
 		 * shares/parent->rq_weight gives our fraction of the load
 		 */
-		load *= aggregate(tg, sd)->shares;
-		load /= aggregate(tg->parent, sd)->rq_weight + 1;
+		load *= aggregate(tg, this_cpu)->shares;
+		load /= aggregate(tg->parent, this_cpu)->rq_weight + 1;
 	}
 
-	aggregate(tg, sd)->load = load;
+	aggregate(tg, this_cpu)->load = load;
 }
 
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
@@ -1679,7 +1683,7 @@ static void __set_se_shares(struct sched
  */
 static void
 __update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,
-			  int tcpu)
+			  int tcpu, int this_cpu)
 {
 	int boost = 0;
 	unsigned long shares;
@@ -1706,8 +1710,8 @@ __update_group_shares_cpu(struct task_gr
 	 *               \Sum rq_weight
 	 *
 	 */
-	shares = aggregate(tg, sd)->shares * rq_weight;
-	shares /= aggregate(tg, sd)->rq_weight + 1;
+	shares = aggregate(tg, this_cpu)->shares * rq_weight;
+	shares /= aggregate(tg, this_cpu)->rq_weight + 1;
 
 	/*
 	 * record the actual number of shares, not the boosted amount.
@@ -1734,8 +1738,8 @@ __move_group_shares(struct task_group *t
 
 	shares = tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
 
-	__update_group_shares_cpu(tg, sd, scpu);
-	__update_group_shares_cpu(tg, sd, dcpu);
+	__update_group_shares_cpu(tg, sd, scpu, dcpu);
+	__update_group_shares_cpu(tg, sd, dcpu, dcpu);
 
 	/*
 	 * ensure we never loose shares due to rounding errors in the
@@ -1761,9 +1765,10 @@ move_group_shares(struct task_group *tg,
 }
 
 static
-void aggregate_group_set_shares(struct task_group *tg, struct sched_domain *sd)
+void aggregate_group_set_shares(struct task_group *tg, struct sched_domain *sd,
+					int this_cpu)
 {
-	unsigned long shares = aggregate(tg, sd)->shares;
+	unsigned long shares = aggregate(tg, this_cpu)->shares;
 	int i;
 
 	for_each_cpu_mask(i, sd->span) {
@@ -1771,20 +1776,20 @@ void aggregate_group_set_shares(struct t
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		__update_group_shares_cpu(tg, sd, i);
+		__update_group_shares_cpu(tg, sd, i, this_cpu);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
 
-	aggregate_group_shares(tg, sd);
+	aggregate_group_shares(tg, sd, this_cpu);
 
 	/*
 	 * ensure we never loose shares due to rounding errors in the
 	 * above redistribution.
 	 */
-	shares -= aggregate(tg, sd)->shares;
+	shares -= aggregate(tg, this_cpu)->shares;
 	if (shares) {
 		tg->cfs_rq[sd->first_cpu]->shares += shares;
-		aggregate(tg, sd)->shares += shares;
+		aggregate(tg, this_cpu)->shares += shares;
 	}
 }
 
@@ -1793,20 +1798,22 @@ void aggregate_group_set_shares(struct t
  * while walking down the tree.
  */
 static
-void aggregate_get_down(struct task_group *tg, struct sched_domain *sd)
+void aggregate_get_down(struct task_group *tg, struct sched_domain *sd,
+				 int this_cpu)
 {
-	aggregate_group_weight(tg, sd);
-	aggregate_group_shares(tg, sd);
-	aggregate_group_load(tg, sd);
+	aggregate_group_weight(tg, sd, this_cpu);
+	aggregate_group_shares(tg, sd, this_cpu);
+	aggregate_group_load(tg, sd, this_cpu);
 }
 
 /*
  * Rebalance the cpu shares while walking back up the tree.
  */
 static
-void aggregate_get_up(struct task_group *tg, struct sched_domain *sd)
+void aggregate_get_up(struct task_group *tg, struct sched_domain *sd,
+				 int this_cpu)
 {
-	aggregate_group_set_shares(tg, sd);
+	aggregate_group_set_shares(tg, sd, this_cpu);
 }
 
 static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
@@ -1819,18 +1826,15 @@ static void __init init_aggregate(void)
 		spin_lock_init(&per_cpu(aggregate_lock, i));
 }
 
-static int get_aggregate(struct sched_domain *sd)
+static void get_aggregate(struct sched_domain *sd, int this_cpu)
 {
-	if (!spin_trylock(&per_cpu(aggregate_lock, sd->first_cpu)))
-		return 0;
-
-	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, sd);
-	return 1;
+	spin_lock(&per_cpu(aggregate_lock, this_cpu));
+	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, sd, this_cpu);
 }
 
-static void put_aggregate(struct sched_domain *sd)
+static void put_aggregate(struct sched_domain *sd, int this_cpu)
 {
-	spin_unlock(&per_cpu(aggregate_lock, sd->first_cpu));
+	spin_unlock(&per_cpu(aggregate_lock, this_cpu));
 }
 
 static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
@@ -1844,12 +1848,12 @@ static inline void init_aggregate(void)
 {
 }
 
-static inline int get_aggregate(struct sched_domain *sd)
+static void get_aggregate(struct sched_domain *sd, int this_cpu)
 {
 	return 0;
 }
 
-static inline void put_aggregate(struct sched_domain *sd)
+static void put_aggregate(struct sched_domain *sd, int this_cpu)
 {
 }
 #endif
@@ -3635,11 +3639,10 @@ static int load_balance(int this_cpu, st
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
-	int unlock_aggregate;
 
 	cpus_setall(*cpus);
 
-	unlock_aggregate = get_aggregate(sd);
+	get_aggregate(sd, this_cpu);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3777,8 +3780,7 @@ out_one_pinned:
 	else
 		ld_moved = 0;
 out:
-	if (unlock_aggregate)
-		put_aggregate(sd);
+	put_aggregate(sd, this_cpu);
 	return ld_moved;
 }
 
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -1388,28 +1388,24 @@ load_balance_fair(struct rq *this_rq, in
 
 	rcu_read_lock();
 	list_for_each_entry(tg, &task_groups, list) {
-		long imbalance;
-		unsigned long this_weight, busiest_weight;
+		unsigned long busiest_weight;
 		long rem_load, max_load, moved_load;
 
+		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
+
 		/*
 		 * empty group
 		 */
-		if (!aggregate(tg, sd)->task_weight)
+		if (!aggregate(tg, this_cpu)->task_weight || !busiest_weight)
 			continue;
 
-		rem_load = rem_load_move * aggregate(tg, sd)->rq_weight;
-		rem_load /= aggregate(tg, sd)->load + 1;
-
-		this_weight = tg->cfs_rq[this_cpu]->task_weight;
-		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
-
-		imbalance = (busiest_weight - this_weight) / 2;
+		rem_load = rem_load_move * aggregate(tg, this_cpu)->rq_weight;
+		rem_load /= aggregate(tg, this_cpu)->load + 1;
 
-		if (imbalance < 0)
-			imbalance = busiest_weight;
+		if (!rem_load)
+			continue;
 
-		max_load = max(rem_load, imbalance);
+		max_load = rem_load;
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
 				max_load, sd, idle, all_pinned, this_best_prio,
 				tg->cfs_rq[busiest_cpu]);
@@ -1419,8 +1415,8 @@ load_balance_fair(struct rq *this_rq, in
 
 		move_group_shares(tg, sd, busiest_cpu, this_cpu);
 
-		moved_load *= aggregate(tg, sd)->load;
-		moved_load /= aggregate(tg, sd)->rq_weight + 1;
+		moved_load *= aggregate(tg, this_cpu)->load;
+		moved_load /= aggregate(tg, this_cpu)->rq_weight + 1;
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)




-- 
Regards,
vatsa
