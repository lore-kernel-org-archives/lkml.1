Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYJXJ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYJXJ7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYJXJ6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:58:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:36226 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYJXJ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:58:48 -0400
Message-Id: <20081024091109.832347739@chello.nl>
References: <20081024090611.936552213@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 11:06:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/8] sched: avg_vruntime
Content-Disposition: inline; filename=sched-avg-vruntime.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renicing requires scaling the lag. Therefore we need a way to compute the it.
Lag is defined as the difference between the service time received from the
ideal model and the actual scheduler.

The defining property of a fair scheduler is that the sum of all lags is zero;
which can be seen is trivially true for the ideal case, as all lags are zero.

Therefore, the average of all virtual runtimes will be the point of zero lag.

We cannot prove fairness for CFS due to sleeper fairness (without it we can).
However since we can observe it does converge to fairness in stable operation,
we can say the zero lag point converges to the average.

We can't just take the average of vruntime - as it will use the full range
of its u64 and will wrap around. Instead we'll use the average of
(vruntime - min_vruntime)

\Sum_{i}^{n} 1/n (v_{i} - v) = 1/n (\Sum_{i}^{n} v_{i}) - vn

By factoring out the 1/n (never storing that) we avoid rounding, which
would bring an accumulating error.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |    3 ++
 kernel/sched_debug.c |    3 ++
 kernel/sched_fair.c  |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 61 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -383,6 +383,9 @@ struct cfs_rq {
 	struct load_weight load;
 	unsigned long nr_running;
 
+	long nr_queued;
+	s64 avg_vruntime;
+
 	u64 exec_clock;
 	u64 min_vruntime;
 
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -161,6 +161,9 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
+			SPLIT_NS(avg_vruntime(cfs_rq)));
+
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -271,6 +271,56 @@ static inline s64 entity_key(struct cfs_
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
+static void
+avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_vruntime += key;
+	cfs_rq->nr_queued++;
+}
+
+static void
+avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_vruntime -= key;
+	cfs_rq->nr_queued--;
+}
+
+static inline
+void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
+{
+	cfs_rq->avg_vruntime -= cfs_rq->nr_queued * delta;
+}
+
+static u64 avg_vruntime(struct cfs_rq *cfs_rq)
+{
+	s64 avg = cfs_rq->avg_vruntime;
+	long nr_queued = cfs_rq->nr_queued;
+
+	if (cfs_rq->curr) {
+		nr_queued++;
+		avg += entity_key(cfs_rq, cfs_rq->curr);
+	}
+
+	if (nr_queued)
+		avg = div_s64(avg, nr_queued);
+
+	return cfs_rq->min_vruntime + avg;
+}
+
+static void __update_min_vruntime(struct cfs_rq *cfs_rq, u64 vruntime)
+{
+	/*
+	 * open coded max_vruntime() to allow updating avg_vruntime
+	 */
+	s64 delta = (s64)(vruntime - cfs_rq->min_vruntime);
+	if (delta > 0) {
+		avg_vruntime_update(cfs_rq, delta);
+		cfs_rq->min_vruntime = vruntime;
+	}
+}
+
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
@@ -289,7 +339,7 @@ static void update_min_vruntime(struct c
 			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
-	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+	__update_min_vruntime(cfs_rq, vruntime);
 }
 
 /*
@@ -303,6 +353,8 @@ static void __enqueue_entity(struct cfs_
 	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
+	avg_vruntime_add(cfs_rq, se);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -345,6 +397,8 @@ static void __dequeue_entity(struct cfs_
 		cfs_rq->next = NULL;
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+
+	avg_vruntime_sub(cfs_rq, se);
 }
 
 static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)

-- 

