Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYJ2SD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYJ2SD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYJ2SDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:03:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYJ2SC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:02:59 -0400
Subject: Re: [PATCH 6/8] sched: avg_vruntime
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       fabio <fabio@gandalf.sssup.it>
In-Reply-To: <20081024091109.832347739@chello.nl>
References: <20081024090611.936552213@chello.nl>
	 <20081024091109.832347739@chello.nl>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 16:48:34 +0100
Message-Id: <1225295314.9315.10.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 11:06 +0200, Peter Zijlstra wrote:
> plain text document attachment (sched-avg-vruntime.patch)
> Renicing requires scaling the lag. Therefore we need a way to compute the it.
> Lag is defined as the difference between the service time received from the
> ideal model and the actual scheduler.
> 
> The defining property of a fair scheduler is that the sum of all lags is zero;
> which can be seen is trivially true for the ideal case, as all lags are zero.
> 
> Therefore, the average of all virtual runtimes will be the point of zero lag.
> 
> We cannot prove fairness for CFS due to sleeper fairness (without it we can).
> However since we can observe it does converge to fairness in stable operation,
> we can say the zero lag point converges to the average.
> 
> We can't just take the average of vruntime - as it will use the full range
> of its u64 and will wrap around. Instead we'll use the average of
> (vruntime - min_vruntime)
> 
> \Sum_{i}^{n} 1/n (v_{i} - v) = 1/n (\Sum_{i}^{n} v_{i}) - vn
> 
> By factoring out the 1/n (never storing that) we avoid rounding, which
> would bring an accumulating error.

Hi Fabio,

you were right, this is wrong.

How about this..

The fluid model, would for each task t_i, generate an execution time e_i

  de_i = w_i / w_sum * dt

However, any real scheduler will be imperfect and have an error eps_i

  dE_i = de_i + eps_i,

But due to only dt actual time having past we can state that

  \Sum_i dE_i = dt, therefore  \Sum_i eps_i = 0.

This will be reflected in a virtual runtime skew of

  dv_i = eps_i / w_i

If we now wish to obtain the zero lag point, there were all tasks would
be in the fluid model, we get

  eps_i = dv_i * w_i, which yields: \Sum dv_i * w_i = 0

IOW avg(v_i*w_i) = v_fluid

1/n \Sum_i v_i*w_i, [v_i -> v_i-x] ->
1/n \sum_i (v_i-x)*w_i =
1/n \Sum v_i*w_i - \Sum x*w_i =
1/n \Sum v_i*w_i - x \Sum w_i

which in turn would yield a patch like below..

I'll also try and quantify the error and effect of using min_vruntime as
zero lag point as Ingo suggested.

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-10-29 16:43:16.000000000 +0100
+++ linux-2.6/kernel/sched.c	2008-10-29 16:43:27.000000000 +0100
@@ -384,6 +384,10 @@ struct cfs_rq {
 	struct load_weight load;
 	unsigned long nr_running;
 
+	long nr_queued;
+	long avg_load;
+	s64 avg_vruntime;
+
 	u64 exec_clock;
 	u64 min_vruntime;
 
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c	2008-10-29 16:43:04.000000000 +0100
+++ linux-2.6/kernel/sched_debug.c	2008-10-29 16:43:37.000000000 +0100
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
--- linux-2.6.orig/kernel/sched_fair.c	2008-10-29 16:43:17.000000000 +0100
+++ linux-2.6/kernel/sched_fair.c	2008-10-29 16:46:41.000000000 +0100
@@ -271,6 +271,60 @@ static inline s64 entity_key(struct cfs_
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
+static void
+avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_load += se->load.weight;
+	cfs_rq->avg_vruntime += key * se->load.weight;
+	cfs_rq->nr_queued++;
+}
+
+static void
+avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_load -= se->load.weight;
+	cfs_rq->avg_vruntime -= key * se->load.weight;
+	cfs_rq->nr_queued--;
+}
+
+static inline
+void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
+{
+	cfs_rq->avg_vruntime -= cfs_rq->nr_queued * cfs_rq->avg_load * delta;
+}
+
+static u64 avg_vruntime(struct cfs_rq *cfs_rq)
+{
+	s64 avg = cfs_rq->avg_vruntime;
+	long nr_queued = cfs_rq->nr_queued;
+
+	if (cfs_rq->curr) {
+		nr_queued++;
+		avg += entity_key(cfs_rq, cfs_rq->curr) * cfs_rq->curr->load.weight;
+	}
+
+	avg >>= NICE_0_SHIFT;
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
@@ -289,7 +343,7 @@ static void update_min_vruntime(struct c
 			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
-	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+	__update_min_vruntime(cfs_rq, vruntime);
 }
 
 /*
@@ -303,6 +357,8 @@ static void __enqueue_entity(struct cfs_
 	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
+	avg_vruntime_add(cfs_rq, se);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -345,6 +401,7 @@ static void __dequeue_entity(struct cfs_
 		cfs_rq->next = NULL;
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	avg_vruntime_sub(cfs_rq, se);
 }
 
 static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)


