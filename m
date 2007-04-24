Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXDXIVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXDXIVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbXDXIUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24146 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbXDXIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:40 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/15] cfq-iosched: sort RT queues into the rbtree
Date: Tue, 24 Apr 2007 10:15:34 +0200
Message-Id: <1177402543664-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently CFQ does a linked insert into the current list for RT
queues. We can just factor the class into the rb insertion,
and then we don't have to treat RT queues in a special way. It's
faster, too.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7f964ee..38ac492 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -471,7 +471,16 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
-		if (rb_key < __cfqq->rb_key)
+		/*
+		 * sort RT queues first, we always want to give
+		 * preference to them. after that, sort on the next
+		 * service time.
+		 */
+		if (cfq_class_rt(cfqq) > cfq_class_rt(__cfqq))
+			p = &(*p)->rb_left;
+		else if (cfq_class_rt(cfqq) < cfq_class_rt(__cfqq))
+			p = &(*p)->rb_right;
+		else if (rb_key < __cfqq->rb_key)
 			p = &(*p)->rb_left;
 		else {
 			p = &(*p)->rb_right;
@@ -490,7 +499,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 {
 	struct cfq_data *cfqd = cfqq->cfqd;
-	struct list_head *n;
 
 	/*
 	 * Resorting requires the cfqq to be on the RR list already.
@@ -500,25 +508,14 @@ static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 
 	list_del_init(&cfqq->cfq_list);
 
-	if (cfq_class_rt(cfqq)) {
-		/*
-		 * At to the front of the current list, but behind other
-		 * RT queues.
-		 */
-		n = &cfqd->cur_rr;
-		while (n->next != &cfqd->cur_rr)
-			if (!cfq_class_rt(cfqq))
-				break;
-
-		list_add(&cfqq->cfq_list, n);
-	} else if (cfq_class_idle(cfqq)) {
+	if (cfq_class_idle(cfqq)) {
 		/*
 		 * IDLE goes to the tail of the idle list
 		 */
 		list_add_tail(&cfqq->cfq_list, &cfqd->idle_rr);
 	} else {
 		/*
-		 * So we get here, ergo the queue is a regular best-effort queue
+		 * RT and BE queues, sort into the rbtree
 		 */
 		cfq_service_tree_add(cfqd, cfqq);
 	}
-- 
1.5.1.1.190.g74474

