Return-Path: <linux-kernel-owner+w=401wt.eu-S1031065AbXDXIZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031065AbXDXIZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXDXIUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41274 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031038AbXDXIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:43 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 11/15] cfq-iosched: don't pass unused preemption variable around
Date: Tue, 24 Apr 2007 10:15:39 +0200
Message-Id: <11774025432031-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use it anymore in the slice expiry handling.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 2d0e9c5..b680002 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -746,7 +746,7 @@ __cfq_set_active_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
  */
 static void
 __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		    int preempted, int timed_out)
+		    int timed_out)
 {
 	if (cfq_cfqq_wait_request(cfqq))
 		del_timer(&cfqd->idle_slice_timer);
@@ -755,8 +755,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_clear_cfqq_wait_request(cfqq);
 
 	/*
-	 * store what was left of this slice, if the queue idled out
-	 * or was preempted
+	 * store what was left of this slice, if the queue idled/timed out
 	 */
 	if (timed_out && !cfq_cfqq_slice_new(cfqq))
 		cfqq->slice_resid = cfqq->slice_end - jiffies;
@@ -774,13 +773,12 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqd->dispatch_slice = 0;
 }
 
-static inline void cfq_slice_expired(struct cfq_data *cfqd, int preempted,
-				     int timed_out)
+static inline void cfq_slice_expired(struct cfq_data *cfqd, int timed_out)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
 	if (cfqq)
-		__cfq_slice_expired(cfqd, cfqq, preempted, timed_out);
+		__cfq_slice_expired(cfqd, cfqq, timed_out);
 }
 
 /*
@@ -989,7 +987,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	}
 
 expire:
-	cfq_slice_expired(cfqd, 0, 0);
+	cfq_slice_expired(cfqd, 0);
 new_queue:
 	cfqq = cfq_set_active_queue(cfqd);
 keep_queue:
@@ -1043,7 +1041,7 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	    cfqd->dispatch_slice >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
-		cfq_slice_expired(cfqd, 0, 0);
+		cfq_slice_expired(cfqd, 0);
 	}
 
 	return dispatched;
@@ -1077,7 +1075,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 	}
 
-	cfq_slice_expired(cfqd, 0, 0);
+	cfq_slice_expired(cfqd, 0);
 
 	BUG_ON(cfqd->busy_queues);
 
@@ -1147,7 +1145,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
-		__cfq_slice_expired(cfqd, cfqq, 0, 0);
+		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -1204,7 +1202,7 @@ static void cfq_free_io_context(struct io_context *ioc)
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	if (unlikely(cfqq == cfqd->active_queue)) {
-		__cfq_slice_expired(cfqd, cfqq, 0, 0);
+		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -1677,7 +1675,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
  */
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	cfq_slice_expired(cfqd, 1, 1);
+	cfq_slice_expired(cfqd, 1);
 
 	/*
 	 * Put the new queue at the front of the of the current list,
@@ -1784,7 +1782,7 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
 			cfq_clear_cfqq_slice_new(cfqq);
 		}
 		if (cfq_slice_used(cfqq))
-			cfq_slice_expired(cfqd, 0, 1);
+			cfq_slice_expired(cfqd, 1);
 		else if (sync && RB_EMPTY_ROOT(&cfqq->sort_list))
 			cfq_arm_slice_timer(cfqd);
 	}
@@ -1979,7 +1977,7 @@ static void cfq_idle_slice_timer(unsigned long data)
 		}
 	}
 expire:
-	cfq_slice_expired(cfqd, 0, timed_out);
+	cfq_slice_expired(cfqd, timed_out);
 out_kick:
 	cfq_schedule_dispatch(cfqd);
 out_cont:
@@ -2025,7 +2023,7 @@ static void cfq_exit_queue(elevator_t *e)
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
-		__cfq_slice_expired(cfqd, cfqd->active_queue, 0, 0);
+		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
 	while (!list_empty(&cfqd->cic_list)) {
 		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
-- 
1.5.1.1.190.g74474

