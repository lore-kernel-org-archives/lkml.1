Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbZLFSEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbZLFSEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbZLFSEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:04:00 -0500
Received: from www.tglx.de ([62.245.132.106]:33222 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934078AbZLFSDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:24 -0500
Message-Id: <20091206111957.883215299@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 15/23] sched: Convert rt_runtime_lock to raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=sched-convert-rt-runtime-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c    |   28 ++++++++++++++--------------
 kernel/sched_rt.c |   46 +++++++++++++++++++++++-----------------------
 2 files changed, 37 insertions(+), 37 deletions(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -141,7 +141,7 @@ struct rt_prio_array {
 
 struct rt_bandwidth {
 	/* nests inside the rq lock: */
-	spinlock_t		rt_runtime_lock;
+	raw_spinlock_t		rt_runtime_lock;
 	ktime_t			rt_period;
 	u64			rt_runtime;
 	struct hrtimer		rt_period_timer;
@@ -178,7 +178,7 @@ void init_rt_bandwidth(struct rt_bandwid
 	rt_b->rt_period = ns_to_ktime(period);
 	rt_b->rt_runtime = runtime;
 
-	spin_lock_init(&rt_b->rt_runtime_lock);
+	raw_spin_lock_init(&rt_b->rt_runtime_lock);
 
 	hrtimer_init(&rt_b->rt_period_timer,
 			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -200,7 +200,7 @@ static void start_rt_bandwidth(struct rt
 	if (hrtimer_active(&rt_b->rt_period_timer))
 		return;
 
-	spin_lock(&rt_b->rt_runtime_lock);
+	raw_spin_lock(&rt_b->rt_runtime_lock);
 	for (;;) {
 		unsigned long delta;
 		ktime_t soft, hard;
@@ -217,7 +217,7 @@ static void start_rt_bandwidth(struct rt
 		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
 				HRTIMER_MODE_ABS_PINNED, 0);
 	}
-	spin_unlock(&rt_b->rt_runtime_lock);
+	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -470,7 +470,7 @@ struct rt_rq {
 	u64 rt_time;
 	u64 rt_runtime;
 	/* Nests inside the rq lock: */
-	spinlock_t rt_runtime_lock;
+	raw_spinlock_t rt_runtime_lock;
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	unsigned long rt_nr_boosted;
@@ -9361,7 +9361,7 @@ static void init_rt_rq(struct rt_rq *rt_
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
 	rt_rq->rt_runtime = 0;
-	spin_lock_init(&rt_rq->rt_runtime_lock);
+	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	rt_rq->rt_nr_boosted = 0;
@@ -10296,18 +10296,18 @@ static int tg_set_bandwidth(struct task_
 	if (err)
 		goto unlock;
 
-	spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
+	raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
 	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
 	tg->rt_bandwidth.rt_runtime = rt_runtime;
 
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = tg->rt_rq[i];
 
-		spin_lock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = rt_runtime;
-		spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
-	spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
+	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
  unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
@@ -10412,15 +10412,15 @@ static int sched_rt_global_constraints(v
 	if (sysctl_sched_rt_runtime == 0)
 		return -EBUSY;
 
-	spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
+	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
 
-		spin_lock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = global_rt_runtime();
-		spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
-	spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
+	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 
 	return 0;
 }
Index: linux-2.6-tip/kernel/sched_rt.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_rt.c
+++ linux-2.6-tip/kernel/sched_rt.c
@@ -327,7 +327,7 @@ static int do_balance_runtime(struct rt_
 
 	weight = cpumask_weight(rd->span);
 
-	spin_lock(&rt_b->rt_runtime_lock);
+	raw_spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
 	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
@@ -336,7 +336,7 @@ static int do_balance_runtime(struct rt_
 		if (iter == rt_rq)
 			continue;
 
-		spin_lock(&iter->rt_runtime_lock);
+		raw_spin_lock(&iter->rt_runtime_lock);
 		/*
 		 * Either all rqs have inf runtime and there's nothing to steal
 		 * or __disable_runtime() below sets a specific rq to inf to
@@ -358,14 +358,14 @@ static int do_balance_runtime(struct rt_
 			rt_rq->rt_runtime += diff;
 			more = 1;
 			if (rt_rq->rt_runtime == rt_period) {
-				spin_unlock(&iter->rt_runtime_lock);
+				raw_spin_unlock(&iter->rt_runtime_lock);
 				break;
 			}
 		}
 next:
-		spin_unlock(&iter->rt_runtime_lock);
+		raw_spin_unlock(&iter->rt_runtime_lock);
 	}
-	spin_unlock(&rt_b->rt_runtime_lock);
+	raw_spin_unlock(&rt_b->rt_runtime_lock);
 
 	return more;
 }
@@ -386,8 +386,8 @@ static void __disable_runtime(struct rq 
 		s64 want;
 		int i;
 
-		spin_lock(&rt_b->rt_runtime_lock);
-		spin_lock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_b->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		/*
 		 * Either we're all inf and nobody needs to borrow, or we're
 		 * already disabled and thus have nothing to do, or we have
@@ -396,7 +396,7 @@ static void __disable_runtime(struct rq 
 		if (rt_rq->rt_runtime == RUNTIME_INF ||
 				rt_rq->rt_runtime == rt_b->rt_runtime)
 			goto balanced;
-		spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 
 		/*
 		 * Calculate the difference between what we started out with
@@ -418,7 +418,7 @@ static void __disable_runtime(struct rq 
 			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
 				continue;
 
-			spin_lock(&iter->rt_runtime_lock);
+			raw_spin_lock(&iter->rt_runtime_lock);
 			if (want > 0) {
 				diff = min_t(s64, iter->rt_runtime, want);
 				iter->rt_runtime -= diff;
@@ -427,13 +427,13 @@ static void __disable_runtime(struct rq 
 				iter->rt_runtime -= want;
 				want -= want;
 			}
-			spin_unlock(&iter->rt_runtime_lock);
+			raw_spin_unlock(&iter->rt_runtime_lock);
 
 			if (!want)
 				break;
 		}
 
-		spin_lock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		/*
 		 * We cannot be left wanting - that would mean some runtime
 		 * leaked out of the system.
@@ -445,8 +445,8 @@ balanced:
 		 * runtime - in which case borrowing doesn't make sense.
 		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
-		spin_unlock(&rt_rq->rt_runtime_lock);
-		spin_unlock(&rt_b->rt_runtime_lock);
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}
 }
 
@@ -472,13 +472,13 @@ static void __enable_runtime(struct rq *
 	for_each_leaf_rt_rq(rt_rq, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 
-		spin_lock(&rt_b->rt_runtime_lock);
-		spin_lock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_b->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = rt_b->rt_runtime;
 		rt_rq->rt_time = 0;
 		rt_rq->rt_throttled = 0;
-		spin_unlock(&rt_rq->rt_runtime_lock);
-		spin_unlock(&rt_b->rt_runtime_lock);
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}
 }
 
@@ -496,9 +496,9 @@ static int balance_runtime(struct rt_rq 
 	int more = 0;
 
 	if (rt_rq->rt_time > rt_rq->rt_runtime) {
-		spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		more = do_balance_runtime(rt_rq);
-		spin_lock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
 	}
 
 	return more;
@@ -528,7 +528,7 @@ static int do_sched_rt_period_timer(stru
 		if (rt_rq->rt_time) {
 			u64 runtime;
 
-			spin_lock(&rt_rq->rt_runtime_lock);
+			raw_spin_lock(&rt_rq->rt_runtime_lock);
 			if (rt_rq->rt_throttled)
 				balance_runtime(rt_rq);
 			runtime = rt_rq->rt_runtime;
@@ -539,7 +539,7 @@ static int do_sched_rt_period_timer(stru
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
-			spin_unlock(&rt_rq->rt_runtime_lock);
+			raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		} else if (rt_rq->rt_nr_running)
 			idle = 0;
 
@@ -624,11 +624,11 @@ static void update_curr_rt(struct rq *rq
 		rt_rq = rt_rq_of_se(rt_se);
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
-			spin_lock(&rt_rq->rt_runtime_lock);
+			raw_spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
 			if (sched_rt_runtime_exceeded(rt_rq))
 				resched_task(curr);
-			spin_unlock(&rt_rq->rt_runtime_lock);
+			raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		}
 	}
 }


