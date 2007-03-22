Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXCVCFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXCVCFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965499AbXCVCFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:05:55 -0400
Received: from mail12.syd.optusnet.com.au ([211.29.132.193]:44855 "EHLO
	mail12.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbXCVCFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:05:54 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Subject: [PATCH] sched: rsdl check for niced tasks lowering prio level
Date: Thu, 22 Mar 2007 13:04:57 +1100
User-Agent: KMail/1.9.5
Cc: Artur Skawina <art_k@o2.pl>, linux list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703220429.45311.kernel@kolivas.org> <200703221124.59126.kernel@kolivas.org> <200703221152.45141.kernel@kolivas.org>
In-Reply-To: <200703221152.45141.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221304.58011.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the best fix for the bug pointed out. Thanks.

I'll try and find pc time to wrap these two patches together and make a v0.32
available.

---
Ensure niced tasks are not inappropriately limiting sleeping unniced tasks
by explicitly checking what the best static priority that has run this
major rotation was.

Reimplement SCHED_BATCH using this check.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

Index: linux-2.6.21-rc4-mm1/kernel/sched.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/sched.c	2007-03-22 12:44:05.000000000 +1100
+++ linux-2.6.21-rc4-mm1/kernel/sched.c	2007-03-22 12:58:26.000000000 +1100
@@ -201,8 +201,11 @@ struct rq {
 	struct prio_array *active, *expired, arrays[2];
 	unsigned long *dyn_bitmap, *exp_bitmap;
 
-	int prio_level;
-	/* The current dynamic priority level this runqueue is at */
+	int prio_level, best_static_prio;
+	/*
+	 * The current dynamic priority level this runqueue is at, and the
+	 * best static priority queued this major rotation.
+	 */
 
 	unsigned long prio_rotation;
 	/* How many times we have rotated the priority queue */
@@ -704,16 +707,24 @@ static inline int entitled_slot(int stat
 
 /*
  * Find the first unused slot by this task that is also in its prio_matrix
- * level.
+ * level. Ensure that the prio_level is not unnecessarily low by checking
+ * that best_static_prio this major rotation was not a niced task.
+ * SCHED_BATCH tasks do not perform this check so they do not induce
+ * latencies in tasks of any nice level.
  */
 static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
-	DECLARE_BITMAP(tmp, PRIO_RANGE);
+	if (p->static_prio < rq->best_static_prio && p->policy != SCHED_BATCH)
+		return SCHED_PRIO(find_first_zero_bit(p->bitmap, PRIO_RANGE));
+	else {
+		DECLARE_BITMAP(tmp, PRIO_RANGE);
 
-	bitmap_or(tmp, p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
-		  PRIO_RANGE);
-	return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
-		USER_PRIO(rq->prio_level)));
+		bitmap_or(tmp, p->bitmap,
+			  prio_matrix[USER_PRIO(p->static_prio)],
+			  PRIO_RANGE);
+		return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
+			USER_PRIO(rq->prio_level)));
+	}
 }
 
 static void queue_expired(struct task_struct *p, struct rq *rq)
@@ -3315,6 +3326,7 @@ static inline void major_prio_rotation(s
 	rq->active = new_array;
 	rq->exp_bitmap = rq->expired->prio_bitmap;
 	rq->dyn_bitmap = rq->active->prio_bitmap;
+	rq->best_static_prio = MAX_PRIO;
 	rq->prio_rotation++;
 }
 
@@ -3640,10 +3652,12 @@ need_resched_nonpreemptible:
 	}
 switch_tasks:
 	if (next == rq->idle) {
+		rq->best_static_prio = MAX_PRIO;
 		rq->prio_level = MAX_RT_PRIO;
 		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
-	}
+	} else if (next->static_prio < rq->best_static_prio)
+		rq->best_static_prio = next->static_prio;
 	prefetch(next);
 	prefetch_stack(next);
 	clear_tsk_need_resched(prev);
@@ -7093,6 +7107,7 @@ void __init sched_init(void)
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->prio_rotation = 0;
+		rq->best_static_prio = MAX_PRIO;
 		rq->prio_level = MAX_RT_PRIO;
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;

-- 
-ck
