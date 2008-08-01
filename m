Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYHALJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYHALJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYHALIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:08:53 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60602 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755582AbYHALIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:08:52 -0400
X-SourceIP: 80.57.229.25
Subject: [PATCH] lockdep: re-annotate scheduler runqueues
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080801.021348.233313767.davem@davemloft.net>
References: <20080731.155504.167792984.davem@davemloft.net>
	 <20080801.011122.32782916.davem@davemloft.net>
	 <20080801090100.GA25142@elte.hu>
	 <20080801.021348.233313767.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:08:43 +0200
Message-Id: <1217588923.9686.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I cannot seem to reproduce this on my quad (I'll let it run a fwe hours
just to make sure), could you meanwhile try on a somewhat larger
machine?

The thing that triggered it for David is a regular kernel build with
large concurrency.

(don't forget to 'fix' printk or apply David's oops_in_progress patch)

---
Subject: lockdep: re-annotate scheduler runqueues

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


