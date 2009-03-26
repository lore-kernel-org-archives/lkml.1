Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZCZPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZCZPwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZCZPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:52:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242AbZCZPw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:52:27 -0400
Message-ID: <49CBA46E.6050306@redhat.com>
Date: Thu, 26 Mar 2009 16:51:10 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] block: elevator quiescing helpers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

Simple helper functions to quiesce the request queue.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/blk.h      |    4 ++++
 block/elevator.c |   40 +++++++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 13 deletions(-)

Index: linux-2.6/block/blk.h
===================================================================
--- linux-2.6.orig/block/blk.h
+++ linux-2.6/block/blk.h
@@ -70,6 +70,10 @@ void blk_queue_congestion_threshold(stru

 int blk_dev_init(void);

+void elv_quisce_start(struct request_queue *q);
+void elv_quisce_end(struct request_queue *q);
+
+
 /*
  * Return the threshold (number of used requests) at which the queue is
  * considered to be congested.  It include a little hysteresis to keep the
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -587,6 +587,31 @@ static void elv_drain_elevator(struct re
 	}
 }

+/*
+ * Call with queue lock held, interrupts disabled
+ */
+void elv_quisce_start(struct request_queue *q)
+{
+	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
+
+	/*
+	 * make sure we don't have any requests in flight
+	 */
+	elv_drain_elevator(q);
+	while (q->rq.elvpriv) {
+		blk_start_queueing(q);
+		spin_unlock_irq(q->queue_lock);
+		msleep(10);
+		spin_lock_irq(q->queue_lock);
+		elv_drain_elevator(q);
+	}
+}
+
+void elv_quisce_end(struct request_queue *q)
+{
+	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
+}
+
 void elv_insert(struct request_queue *q, struct request *rq, int where)
 {
 	struct list_head *pos;
@@ -1101,18 +1126,7 @@ static int elevator_switch(struct reques
 	 * Turn on BYPASS and drain all requests w/ elevator private data
 	 */
 	spin_lock_irq(q->queue_lock);
-
-	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
-
-	elv_drain_elevator(q);
-
-	while (q->rq.elvpriv) {
-		blk_start_queueing(q);
-		spin_unlock_irq(q->queue_lock);
-		msleep(10);
-		spin_lock_irq(q->queue_lock);
-		elv_drain_elevator(q);
-	}
+	elv_quisce_start(q);

 	/*
 	 * Remember old elevator.
@@ -1136,7 +1150,7 @@ static int elevator_switch(struct reques
 	 */
 	elevator_exit(old_elevator);
 	spin_lock_irq(q->queue_lock);
-	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
+	elv_quisce_end(q);
 	spin_unlock_irq(q->queue_lock);

 	blk_add_trace_msg(q, "elv switch: %s", e->elevator_type->elevator_name);
