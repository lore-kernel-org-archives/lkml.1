Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbYHAVTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbYHAVTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761067AbYHAVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:11:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51844 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761051AbYHAVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:11:13 -0400
Date: Fri, 1 Aug 2008 14:11:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for
	callbacks-processing(v2)
Message-ID: <20080801211109.GB14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48708F2F.2060406@cn.fujitsu.com> <20080718140930.GT6875@elte.hu> <20080721100433.GC8384@linux.vnet.ibm.com> <20080725165454.GA7147@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725165454.GA7147@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 09:54:54AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 21, 2008 at 03:04:33AM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 18, 2008 at 04:09:30PM +0200, Ingo Molnar wrote:
> > > 
> > > * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > > 
> > > > This is v2, it's a little deference from v1 that I
> > > > had send to lkml.
> > > > use ACCESS_ONCE
> > > > use rcu_batch_after/rcu_batch_before for batch # comparison.
> > > > 
> > > > rcutorture test result:
> > > > (hotplugs: do cpu-online/offline once per second)
> > > > 
> > > > No CONFIG_NO_HZ:           OK, 12hours
> > > > No CONFIG_NO_HZ, hotplugs: OK, 12hours
> > > > CONFIG_NO_HZ=y:            OK, 24hours
> > > > CONFIG_NO_HZ=y, hotplugs:  Failed.
> > > > (Failed also without my patch applied, exactly the same bug occurred,
> > > > http://lkml.org/lkml/2008/7/3/24)
> > > 
> > > thanks, i've applied this to tip/core/rcu - but it would be nice have an 
> > > ack/nak from Paul as well, before we can proceed further.
> > 
> > I like the general approach -- simplification is a good thing.
> > 
> > So, for the moment:
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > I need to do a more detailed review (e.g., the memory-barrier changes
> > and the incorporation of some grace-period processing into call_rcu()),
> > after which I will either ask for changes or give a Reviewed-by.
> > 
> > I need to do this more-detailed review before we ship to mainline.
> > (Gak, already two weeks since Jiangshan sent this!!!  My apologies!!!)

And here is a patch to apply on top of Jiangshan's patch that
rationalizes the locking and memory barriers.  Much of this is general
cleanup, not necessarily directly related to Jiangshan's patch.
Given this as a base, it should be fairly easy to make a hierarchical
implementation for machines that see lock contention in the RCU
infrastructure -- split and make a hierarchy on rcu_ctrlblk.

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcuclassic.c |   62 +++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff -urpNa -X dontdiff linux-2.6.26-ljsimp/kernel/rcuclassic.c linux-2.6.26-ljsimpfix/kernel/rcuclassic.c
--- linux-2.6.26-ljsimp/kernel/rcuclassic.c	2008-07-24 13:46:58.000000000 -0700
+++ linux-2.6.26-ljsimpfix/kernel/rcuclassic.c	2008-07-28 12:47:29.000000000 -0700
@@ -86,6 +86,7 @@ static void force_quiescent_state(struct
 	int cpu;
 	cpumask_t cpumask;
 	set_need_resched();
+	spin_lock(&rcp->lock);
 	if (unlikely(!rcp->signaled)) {
 		rcp->signaled = 1;
 		/*
@@ -111,6 +112,7 @@ static void force_quiescent_state(struct
 		for_each_cpu_mask(cpu, cpumask)
 			smp_send_reschedule(cpu);
 	}
+	spin_unlock(&rcp->lock);
 }
 #else
 static inline void force_quiescent_state(struct rcu_data *rdp,
@@ -124,7 +126,11 @@ static void __call_rcu(struct rcu_head *
 		struct rcu_data *rdp)
 {
 	long batch;
-	smp_mb(); /* reads the most recently updated value of rcu->cur. */
+	unsigned long flags;
+
+	head->next = NULL;
+	local_irq_save(flags);
+	smp_mb(); /* Read of rcu->cur must happen after any change by caller. */
 
 	/*
 	 * Determine the batch number of this callback.
@@ -155,6 +161,7 @@ static void __call_rcu(struct rcu_head *
 		rdp->blimit = INT_MAX;
 		force_quiescent_state(rdp, &rcu_ctrlblk);
 	}
+	local_irq_restore(flags);
 }
 
 /**
@@ -171,13 +178,8 @@ static void __call_rcu(struct rcu_head *
 void call_rcu(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
-	unsigned long flags;
-
 	head->func = func;
-	head->next = NULL;
-	local_irq_save(flags);
 	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
-	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
@@ -200,13 +202,8 @@ EXPORT_SYMBOL_GPL(call_rcu);
 void call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
-	unsigned long flags;
-
 	head->func = func;
-	head->next = NULL;
-	local_irq_save(flags);
 	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
-	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
@@ -389,17 +386,17 @@ static void rcu_move_batch(struct rcu_da
 static void __rcu_offline_cpu(struct rcu_data *this_rdp,
 				struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
-	/* if the cpu going offline owns the grace period
+	/*
+	 * if the cpu going offline owns the grace period
 	 * we can block indefinitely waiting for it, so flush
 	 * it here
 	 */
 	spin_lock_bh(&rcp->lock);
 	if (rcp->cur != rcp->completed)
 		cpu_quiet(rdp->cpu, rcp);
-	spin_unlock_bh(&rcp->lock);
-	/* spin_lock implies smp_mb() */
 	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
 	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
+	spin_unlock_bh(&rcp->lock);
 }
 
 static void rcu_offline_cpu(int cpu)
@@ -429,16 +426,19 @@ static void rcu_offline_cpu(int cpu)
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 					struct rcu_data *rdp)
 {
+	long completed_snap;
+
 	if (rdp->nxtlist) {
 		local_irq_disable();
+		completed_snap = ACCESS_ONCE(rcp->completed);
 
 		/*
 		 * move the other grace-period-completed entries to
 		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
 		 */
-		if (!rcu_batch_before(rcp->completed, rdp->batch))
+		if (!rcu_batch_before(completed_snap, rdp->batch))
 			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
-		else if (!rcu_batch_before(rcp->completed, rdp->batch - 1))
+		else if (!rcu_batch_before(completed_snap, rdp->batch - 1))
 			rdp->nxttail[0] = rdp->nxttail[1];
 
 		/*
@@ -479,20 +479,38 @@ static void __rcu_process_callbacks(stru
 
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
+	/*
+	 * Memory references from any prior RCU read-side critical sections
+	 * executed by the interrupted code must be see before any RCU
+	 * grace-period manupulations below.
+	 */
+
+	smp_mb(); /* See above block comment. */
+
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
+
+	/*
+	 * Memory references from any later RCU read-side critical sections
+	 * executed by the interrupted code must be see after any RCU
+	 * grace-period manupulations above.
+	 */
+
+	smp_mb(); /* See above block comment. */
 }
 
 static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
 	if (rdp->nxtlist) {
+		long completed_snap = ACCESS_ONCE(rcp->completed);
+
 		/*
 		 * This cpu has pending rcu entries and the grace period
 		 * for them has completed.
 		 */
-		if (!rcu_batch_before(rcp->completed, rdp->batch))
+		if (!rcu_batch_before(completed_snap, rdp->batch))
 			return 1;
-		if (!rcu_batch_before(rcp->completed, rdp->batch - 1) &&
+		if (!rcu_batch_before(completed_snap, rdp->batch - 1) &&
 				rdp->nxttail[0] != rdp->nxttail[1])
 			return 1;
 		if (rdp->nxttail[0] != &rdp->nxtlist)
@@ -543,6 +561,12 @@ int rcu_needs_cpu(int cpu)
 	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
 }
 
+/*
+ * Top-level function driving RCU grace-period detection, normally
+ * invoked from the scheduler-clock interrupt.  This function simply
+ * increments counters that are read only from softirq by this same
+ * CPU, so there are no memory barriers required.
+ */
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
@@ -558,6 +582,7 @@ void rcu_check_callbacks(int cpu, int us
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
+	spin_lock(&rcp->lock);
 	memset(rdp, 0, sizeof(*rdp));
 	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
 	rdp->donetail = &rdp->donelist;
@@ -565,6 +590,7 @@ static void rcu_init_percpu_data(int cpu
 	rdp->qs_pending = 0;
 	rdp->cpu = cpu;
 	rdp->blimit = blimit;
+	spin_unlock(&rcp->lock);
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
