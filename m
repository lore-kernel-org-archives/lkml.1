Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYHDNTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYHDNTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYHDNTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:19:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYHDNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:19:22 -0400
Message-Id: <20080804131011.929471978@chello.nl>
References: <20080804130317.994042639@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 04 Aug 2008 15:03:20 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [RFC][PATCH 3/7] lockdep: re-annotate scheduler runqueues
Content-Disposition: inline; filename=lockdep-sched-annotate.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a per-rq lock class, use the regular nesting operations.

However, take extra care with double_lock_balance() as it can release the
already held rq->lock (and therefore change its nesting class).

So what can happen is:

 spin_lock(rq->lock);	// this rq subclass 0

 double_lock_balance(rq, other_rq);
   // release rq
   // acquire other_rq->lock subclass 0
   // acquire rq->lock subclass 1

 spin_unlock(other_rq->lock);

leaving you with rq->lock in subclass 1

So a subsequent double_lock_balance() call can try to nest a subclass 1
lock while already holding a subclass 1 lock.

Fix this by introducing double_unlock_balance() which releases the other
rq's lock, but also re-sets the subclass for this rq's lock to 0.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |   21 +++++++++++++--------
 kernel/sched_rt.c |    8 +++++---
 2 files changed, 18 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -600,7 +600,6 @@ struct rq {
 	/* BKL stats */
 	unsigned int bkl_count;
 #endif
-	struct lock_class_key rq_lock_key;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -2759,10 +2758,10 @@ static void double_rq_lock(struct rq *rq
 	} else {
 		if (rq1 < rq2) {
 			spin_lock(&rq1->lock);
-			spin_lock(&rq2->lock);
+			spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
 		} else {
 			spin_lock(&rq2->lock);
-			spin_lock(&rq1->lock);
+			spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
 	update_rq_clock(rq1);
@@ -2805,14 +2804,21 @@ static int double_lock_balance(struct rq
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
 			spin_lock(&busiest->lock);
-			spin_lock(&this_rq->lock);
+			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
 			ret = 1;
 		} else
-			spin_lock(&busiest->lock);
+			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
 	}
 	return ret;
 }
 
+static void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(busiest->lock)
+{
+	spin_unlock(&busiest->lock);
+	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+}
+
 /*
  * If dest_cpu is allowed for this process, migrate the task to it.
  * This is accomplished by forcing the cpu_allowed mask to only
@@ -3637,7 +3643,7 @@ redo:
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 					imbalance, sd, CPU_NEWLY_IDLE,
 					&all_pinned);
-		spin_unlock(&busiest->lock);
+		double_unlock_balance(this_rq, busiest);
 
 		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), *cpus);
@@ -3752,7 +3758,7 @@ static void active_load_balance(struct r
 		else
 			schedstat_inc(sd, alb_failed);
 	}
-	spin_unlock(&target_rq->lock);
+	double_unlock_balance(busiest_rq, target_rq);
 }
 
 #ifdef CONFIG_NO_HZ
@@ -8000,7 +8006,6 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
-		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -861,6 +861,8 @@ static void put_prev_task_rt(struct rq *
 #define RT_MAX_TRIES 3
 
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
+static void double_unlock_balance(struct rq *this_rq, struct rq *busiest);
+
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
@@ -1022,7 +1024,7 @@ static struct rq *find_lock_lowest_rq(st
 			break;
 
 		/* try again */
-		spin_unlock(&lowest_rq->lock);
+		double_unlock_balance(rq, lowest_rq);
 		lowest_rq = NULL;
 	}
 
@@ -1091,7 +1093,7 @@ static int push_rt_task(struct rq *rq)
 
 	resched_task(lowest_rq->curr);
 
-	spin_unlock(&lowest_rq->lock);
+	double_unlock_balance(rq, lowest_rq);
 
 	ret = 1;
 out:
@@ -1197,7 +1199,7 @@ static int pull_rt_task(struct rq *this_
 
 		}
  skip:
-		spin_unlock(&src_rq->lock);
+		double_unlock_balance(this_rq, src_rq);
 	}
 
 	return ret;

-- 

