Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYFCDru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYFCDru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 23:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYFCDrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 23:47:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60829 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbYFCDrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 23:47:39 -0400
Message-ID: <4844BE83.5010401@cn.fujitsu.com>
Date: Tue, 03 Jun 2008 11:46:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] rcu classic: new algorithm for callbacks-processing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

rcutourture was tested successfully(x86_64/4cpu i386/2cpu i386/1cpu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index b3aa05b..fce7106 100644
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
index f4ffbd0..36ceb9f 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -104,6 +104,31 @@ static inline void force_quiescent_state(struct rcu_data *rdp,
 }
 #endif
 
+static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
+		struct rcu_data *rdp)
+{
+	long batch;
+	smp_mb(); /* reads the most recently updated value of rcu->cur. */
+	batch = rcp->cur + 1;
+
+	if (rdp->nxtlist && rdp->batch <= batch - 1) {
+		/* process callbacks */
+		rdp->nxttail[0] = rdp->nxttail[1];
+		rdp->nxttail[1] = rdp->nxttail[2];
+		if (rdp->batch <= batch - 2)
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
@@ -119,18 +144,11 @@ void call_rcu(struct rcu_head *head,
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
@@ -155,20 +173,11 @@ void call_rcu_bh(struct rcu_head *head,
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
@@ -197,12 +206,6 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
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
@@ -265,11 +268,6 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 	if (rcp->next_pending &&
 			rcp->completed == rcp->cur) {
 		rcp->next_pending = 0;
-		/*
-		 * next_pending == 0 must be visible in
-		 * __rcu_process_callbacks() before it can see new value of cur.
-		 */
-		smp_wmb();
 		rcp->cur++;
 
 		/*
@@ -350,13 +348,15 @@ static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
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
@@ -370,9 +370,8 @@ static void __rcu_offline_cpu(struct rcu_data *this_rdp,
 	if (rcp->cur != rcp->completed)
 		cpu_quiet(rdp->cpu, rcp);
 	spin_unlock_bh(&rcp->lock);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
-	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
-	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
+	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
+	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
 }
 
 static void rcu_offline_cpu(int cpu)
@@ -402,33 +401,37 @@ static void rcu_offline_cpu(int cpu)
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
 
-		/*
-		 * start the next batch of callbacks
+		/* move the other grace-period-completed entries to
+		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
 		 */
-
-		/* determine batch number */
-		rdp->batch = rcp->cur + 1;
-		/* see the comment and corresponding wmb() in
-		 * the rcu_start_batch()
+		if (rdp->batch <= rcp->completed)
+			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
+		else if (rdp->batch - 1 <= rcp->completed)
+			rdp->nxttail[0] = rdp->nxttail[1];
+
+		/* the grace period for entries in
+		 * [rdp->nxtlist, *rdp->nxttail[0]) has completed and
+		 * move these entries to donelist
 		 */
-		smp_rmb();
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
+
+		local_irq_enable();
 
-		if (!rcp->next_pending) {
+		if (rcp->cur < rdp->batch && !rcp->next_pending) {
 			/* and start it/schedule start if it's a new batch */
 			spin_lock(&rcp->lock);
 			rcp->next_pending = 1;
@@ -450,15 +453,24 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 
 static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
-	/* This cpu has pending rcu entries and the grace period
-	 * for them has completed.
-	 */
-	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch))
-		return 1;
-
-	/* This cpu has no pending entries, but there are new entries */
-	if (!rdp->curlist && rdp->nxtlist)
-		return 1;
+	if (rdp->nxtlist) {
+		/* This cpu has pending rcu entries and the grace period
+		 * for them has completed.
+		 */
+		if (rdp->batch <= rcp->completed)
+			return 1;
+		if (rdp->batch - 1 <= rcp->completed &&
+				rdp->nxttail[0] != rdp->nxttail[1])
+			return 1;
+		if (rdp->nxttail[0] != &rdp->nxtlist)
+			return 1;
+
+		/* This cpu has pending rcu entries and the new batch
+		 * for then hasn't been started nor scheduled start
+		 */
+		if (rcp->cur < rdp->batch && !rcp->next_pending)
+			return 1;
+	}
 
 	/* This cpu has finished callbacks to invoke */
 	if (rdp->donelist)
@@ -494,7 +506,7 @@ int rcu_needs_cpu(int cpu)
 	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
 	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
 
-	return (!!rdp->curlist || !!rdp_bh->curlist || rcu_pending(cpu));
+	return (!!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu));
 }
 
 void rcu_check_callbacks(int cpu, int user)
@@ -513,8 +525,7 @@ static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
 	memset(rdp, 0, sizeof(*rdp));
-	rdp->curtail = &rdp->curlist;
-	rdp->nxttail = &rdp->nxtlist;
+	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
 	rdp->donetail = &rdp->donelist;
 	rdp->quiescbatch = rcp->completed;
 	rdp->qs_pending = 0;




