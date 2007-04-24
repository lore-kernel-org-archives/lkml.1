Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXDXIUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXDXIUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXDXIUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41273 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031039AbXDXIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:43 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 14/15] cfq-iosched: improve sync vs async workloads
Date: Tue, 24 Apr 2007 10:15:42 +0200
Message-Id: <11774025432834-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f920527..772df89 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -96,6 +96,7 @@ struct cfq_data {
 	struct hlist_head *cfq_hash;
 
 	int rq_in_driver;
+	int sync_flight;
 	int hw_tag;
 
 	/*
@@ -905,11 +906,15 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
  */
 static void cfq_dispatch_insert(request_queue_t *q, struct request *rq)
 {
+	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
 	elv_dispatch_sort(q, rq);
+
+	if (cfq_cfqq_sync(cfqq))
+		cfqd->sync_flight++;
 }
 
 /*
@@ -1094,27 +1099,24 @@ static int cfq_dispatch_requests(request_queue_t *q, int force)
 	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
 		int max_dispatch;
 
-		if (cfqd->busy_queues > 1) {
-			/*
-			 * So we have dispatched before in this round, if the
-			 * next queue has idling enabled (must be sync), don't
-			 * allow it service until the previous have completed.
-			 */
-			if (cfqd->rq_in_driver && cfq_cfqq_idle_window(cfqq) &&
-			    dispatched)
+		max_dispatch = cfqd->cfq_quantum;
+		if (cfq_class_idle(cfqq))
+			max_dispatch = 1;
+
+		if (cfqq->dispatched >= max_dispatch) {
+			if (cfqd->busy_queues > 1)
 				break;
-			if (cfqq->dispatched >= cfqd->cfq_quantum)
+			if (cfqq->dispatched >= 4 * max_dispatch)
 				break;
 		}
 
+		if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
+			break;
+
 		cfq_clear_cfqq_must_dispatch(cfqq);
 		cfq_clear_cfqq_wait_request(cfqq);
 		del_timer(&cfqd->idle_slice_timer);
 
-		max_dispatch = cfqd->cfq_quantum;
-		if (cfq_class_idle(cfqq))
-			max_dispatch = 1;
-
 		dispatched += __cfq_dispatch_requests(cfqd, cfqq, max_dispatch);
 	}
 
@@ -1767,6 +1769,9 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
 
+	if (cfq_cfqq_sync(cfqq))
+		cfqd->sync_flight--;
+
 	if (!cfq_class_idle(cfqq))
 		cfqd->last_end_request = now;
 
-- 
1.5.1.1.190.g74474

