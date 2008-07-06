Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbYGFJ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbYGFJ0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 05:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYGFJ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 05:26:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58795 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYGFJ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 05:26:30 -0400
Message-ID: <48708F2F.2060406@cn.fujitsu.com>
Date: Sun, 06 Jul 2008 17:23:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 2/2] rcu classic: new algorithm for callbacks-processing(v2)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is v2, it's a little deference from v1 that I
had send to lkml.
use ACCESS_ONCE
use rcu_batch_after/rcu_batch_before for batch # comparison.

rcutorture test result:
(hotplugs: do cpu-online/offline once per second)

No CONFIG_NO_HZ:           OK, 12hours
No CONFIG_NO_HZ, hotplugs: OK, 12hours
CONFIG_NO_HZ=y:            OK, 24hours
CONFIG_NO_HZ=y, hotplugs:  Failed.
(Failed also without my patch applied, exactly the same bug occurred,
http://lkml.org/lkml/2008/7/3/24)

v1's email thread:
http://lkml.org/lkml/2008/6/2/539


v1's description:

The code/algorithm of the implement of current callbacks-processing
is very efficient and technical. But when I studied it and I found
a disadvantage:

In multi-CPU systems, when a new RCU callback is being
queued(call_rcu[_bh]), this callback will be invoked after the grace
period for the batch with batch number = rcp->cur+2 has completed
very very likely in current implement. Actually, this callback can be
invoked after the grace period for the batch with
batch number = rcp->cur+1 has completed. The delay of invocation means
that latency of synchronize_rcu() is extended. But more important thing
is that the callbacks usually free memory, and these works are delayed
too! it's necessary for reclaimer to free memory as soon as
possible when left memory is few.

A very simple way can solve this problem:
a field(struct rcu_head::batch) is added to record the batch number for
the RCU callback. And when a new RCU callback is being queued, we
determine the batch number for this callback(head->batch = rcp->cur+1)
and we move this callback to rdp->donelist if we find
that head->batch <= rcp->completed when we process callbacks.
This simple way reduces the wait time for invocation a lot. (about
2.5Grace Period -> 1.5Grace Period in average in multi-CPU systems)

This is my algorithm. But I do not add any field for struct rcu_head
in my implement. We just need to memorize the last 2 batches and
their batch number, because these 2 batches include all entries that
for whom the grace period hasn't completed. So we use a special
linked-list rather than add a field.
Please see the comment of struct rcu_data.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5efd734..8ed9de6 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -66,11 +66,7 @@ static inline int rcu_batch_after(long a, long b)
 	return (a - b) > 0;
 }
 
-/*
- * Per-CPU data for Read-Copy UPdate.
- * nxtlist - new callbacks are added here
- * curlist - current batch for which quiescent cycle started if any
- */
+/* Per-CPU data for Read-Copy UPdate. */
 struct rcu_data {
 	/* 1) quiescent state handling : */
 	long		quiescbatch;     /* Batch # for grace period */
@@ -78,12 +74,24 @@ struct rcu_data {
 	int		qs_pending;	 /* core waits for quiesc state */
 
 	/* 2) batch handling */
-	long  	       	batch;           /* Batch # for current RCU batch */
+	/*
+	 * if nxtlist is not NULL, then:
+	 * batch:
+	 *	The batch # for the last entry of nxtlist
+	 * [*nxttail[1], NULL = *nxttail[2]):
+	 *	Entries that batch # <= batch
+	 * [*nxttail[0], *nxttail[1]):
+	 *	Entries that batch # <= batch - 1
+	 * [nxtlist, *nxttail[0]):
+	 *	Entries that batch # <= batch - 2
+	 *	The grace period for these entries has completed, and
+	 *	the other grace-period-completed entries may be moved
+	 *	here temporarily in rcu_process_callbacks().
+	 */
+	long  	       	batch;
 	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail;
+	struct rcu_head **nxttail[3];
 	long            qlen; 	 	 /* # of queued callbacks */
-	struct rcu_head *curlist;
-	struct rcu_head **curtail;
 	struct rcu_head *donelist;
 	struct rcu_head **donetail;
 	long		blimit;		 /* Upper limit on a processed batch */
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 9ac3b94..d9c1caf 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -120,6 +120,43 @@ static inline void force_quiescent_state(struct rcu_data *rdp,
 }
 #endif
 
+static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
+		struct rcu_data *rdp)
+{
+	long batch;
+	smp_mb(); /* reads the most recently updated value of rcu->cur. */
+
+	/*
+	 * Determine the batch number of this callback.
+	 *
+	 * Using ACCESS_ONCE to avoid the following error when gcc eliminates
+	 * local variable "batch" and emits codes like this:
+	 *	1) rdp->batch = rcp->cur + 1 # gets old value
+	 *	......
+	 *	2)rcu_batch_after(rcp->cur + 1, rdp->batch) # gets new value
+	 * then [*nxttail[0], *nxttail[1]) may contain callbacks
+	 * that batch# = rdp->batch, see the comment of struct rcu_data.
+	 */
+	batch = ACCESS_ONCE(rcp->cur) + 1;
+
+	if (rdp->nxtlist && rcu_batch_after(batch, rdp->batch)) {
+		/* process callbacks */
+		rdp->nxttail[0] = rdp->nxttail[1];
+		rdp->nxttail[1] = rdp->nxttail[2];
+		if (rcu_batch_after(batch - 1, rdp->batch))
+			rdp->nxttail[0] = rdp->nxttail[2];
+	}
+
+	rdp->batch = batch;
+	*rdp->nxttail[2] = head;
+	rdp->nxttail[2] = &head->next;
+
+	if (unlikely(++rdp->qlen > qhimark)) {
+		rdp->blimit = INT_MAX;
+		force_quiescent_state(rdp, &rcu_ctrlblk);
+	}
+}
+
 /**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -135,18 +172,11 @@ void call_rcu(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
-	struct rcu_data *rdp;
 
 	head->func = func;
 	head->next = NULL;
 	local_irq_save(flags);
-	rdp = &__get_cpu_var(rcu_data);
-	*rdp->nxttail = head;
-	rdp->nxttail = &head->next;
-	if (unlikely(++rdp->qlen > qhimark)) {
-		rdp->blimit = INT_MAX;
-		force_quiescent_state(rdp, &rcu_ctrlblk);
-	}
+	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
@@ -171,20 +201,11 @@ void call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
-	struct rcu_data *rdp;
 
 	head->func = func;
 	head->next = NULL;
 	local_irq_save(flags);
-	rdp = &__get_cpu_var(rcu_bh_data);
-	*rdp->nxttail = head;
-	rdp->nxttail = &head->next;
-
-	if (unlikely(++rdp->qlen > qhimark)) {
-		rdp->blimit = INT_MAX;
-		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
-	}
-
+	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
@@ -213,12 +234,6 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
 static inline void raise_rcu_softirq(void)
 {
 	raise_softirq(RCU_SOFTIRQ);
-	/*
-	 * The smp_mb() here is required to ensure that this cpu's
-	 * __rcu_process_callbacks() reads the most recently updated
-	 * value of rcu->cur.
-	 */
-	smp_mb();
 }
 
 /*
@@ -360,13 +375,15 @@ static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
  * which is dead and hence not processing interrupts.
  */
 static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
-				struct rcu_head **tail)
+				struct rcu_head **tail, long batch)
 {
-	local_irq_disable();
-	*this_rdp->nxttail = list;
-	if (list)
-		this_rdp->nxttail = tail;
-	local_irq_enable();
+	if (list) {
+		local_irq_disable();
+		this_rdp->batch = batch;
+		*this_rdp->nxttail[2] = list;
+		this_rdp->nxttail[2] = tail;
+		local_irq_enable();
+	}
 }
 
 static void __rcu_offline_cpu(struct rcu_data *this_rdp,
@@ -380,9 +397,9 @@ static void __rcu_offline_cpu(struct rcu_data *this_rdp,
 	if (rcp->cur != rcp->completed)
 		cpu_quiet(rdp->cpu, rcp);
 	spin_unlock_bh(&rcp->lock);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
-	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
-	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
+	/* spin_lock implies smp_mb() */
+	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
+	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
 }
 
 static void rcu_offline_cpu(int cpu)
@@ -412,27 +429,37 @@ static void rcu_offline_cpu(int cpu)
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 					struct rcu_data *rdp)
 {
-	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
-		*rdp->donetail = rdp->curlist;
-		rdp->donetail = rdp->curtail;
-		rdp->curlist = NULL;
-		rdp->curtail = &rdp->curlist;
-	}
-
-	if (rdp->nxtlist && !rdp->curlist) {
+	if (rdp->nxtlist) {
 		local_irq_disable();
-		rdp->curlist = rdp->nxtlist;
-		rdp->curtail = rdp->nxttail;
-		rdp->nxtlist = NULL;
-		rdp->nxttail = &rdp->nxtlist;
-		local_irq_enable();
 
 		/*
-		 * start the next batch of callbacks
+		 * move the other grace-period-completed entries to
+		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
+		 */
+		if (!rcu_batch_before(rcp->completed, rdp->batch))
+			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
+		else if (!rcu_batch_before(rcp->completed, rdp->batch - 1))
+			rdp->nxttail[0] = rdp->nxttail[1];
+
+		/*
+		 * the grace period for entries in
+		 * [rdp->nxtlist, *rdp->nxttail[0]) has completed and
+		 * move these entries to donelist
 		 */
+		if (rdp->nxttail[0] != &rdp->nxtlist) {
+			*rdp->donetail = rdp->nxtlist;
+			rdp->donetail = rdp->nxttail[0];
+			rdp->nxtlist = *rdp->nxttail[0];
+			*rdp->donetail = NULL;
+
+			if (rdp->nxttail[1] == rdp->nxttail[0])
+				rdp->nxttail[1] = &rdp->nxtlist;
+			if (rdp->nxttail[2] == rdp->nxttail[0])
+				rdp->nxttail[2] = &rdp->nxtlist;
+			rdp->nxttail[0] = &rdp->nxtlist;
+		}
 
-		/* determine batch number */
-		rdp->batch = rcp->cur + 1;
+		local_irq_enable();
 
 		if (rcu_batch_after(rdp->batch, rcp->pending)) {
 			/* and start it/schedule start if it's a new batch */
@@ -458,15 +485,26 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 
 static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
-	/* This cpu has pending rcu entries and the grace period
-	 * for them has completed.
-	 */
-	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch))
-		return 1;
+	if (rdp->nxtlist) {
+		/*
+		 * This cpu has pending rcu entries and the grace period
+		 * for them has completed.
+		 */
+		if (!rcu_batch_before(rcp->completed, rdp->batch))
+			return 1;
+		if (!rcu_batch_before(rcp->completed, rdp->batch - 1) &&
+				rdp->nxttail[0] != rdp->nxttail[1])
+			return 1;
+		if (rdp->nxttail[0] != &rdp->nxtlist)
+			return 1;
 
-	/* This cpu has no pending entries, but there are new entries */
-	if (!rdp->curlist && rdp->nxtlist)
-		return 1;
+		/*
+		 * This cpu has pending rcu entries and the new batch
+		 * for then hasn't been started nor scheduled start
+		 */
+		if (rcu_batch_after(rdp->batch, rcp->pending))
+			return 1;
+	}
 
 	/* This cpu has finished callbacks to invoke */
 	if (rdp->donelist)
@@ -502,7 +540,7 @@ int rcu_needs_cpu(int cpu)
 	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
 	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
 
-	return (!!rdp->curlist || !!rdp_bh->curlist || rcu_pending(cpu));
+	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
 }
 
 void rcu_check_callbacks(int cpu, int user)
@@ -521,8 +559,7 @@ static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
 	memset(rdp, 0, sizeof(*rdp));
-	rdp->curtail = &rdp->curlist;
-	rdp->nxttail = &rdp->nxtlist;
+	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
 	rdp->donetail = &rdp->donelist;
 	rdp->quiescbatch = rcp->completed;
 	rdp->qs_pending = 0;







