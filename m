Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbXDXIWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbXDXIWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXDXIUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24150 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbXDXIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:41 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/15] cfq-iosched: sort IDLE queues into the rbtree
Date: Tue, 24 Apr 2007 10:15:35 +0200
Message-Id: <11774025432620-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Same treatment as the RT conversion, just put the sorted idle
branch at the end of the tree.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   67 +++++++++++++++++++++++---------------------------
 1 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 38ac492..e6cc77f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -92,7 +92,6 @@ struct cfq_data {
 	 */
 	struct cfq_rb_root service_tree;
 	struct list_head cur_rr;
-	struct list_head idle_rr;
 	unsigned int busy_queues;
 
 	/*
@@ -467,25 +466,33 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 
 	while (*p) {
 		struct cfq_queue *__cfqq;
+		struct rb_node **n;
 
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
 		/*
 		 * sort RT queues first, we always want to give
-		 * preference to them. after that, sort on the next
-		 * service time.
+		 * preference to them. IDLE queues goes to the back.
+		 * after that, sort on the next service time.
 		 */
 		if (cfq_class_rt(cfqq) > cfq_class_rt(__cfqq))
-			p = &(*p)->rb_left;
+			n = &(*p)->rb_left;
 		else if (cfq_class_rt(cfqq) < cfq_class_rt(__cfqq))
-			p = &(*p)->rb_right;
+			n = &(*p)->rb_right;
+		else if (cfq_class_idle(cfqq) < cfq_class_idle(__cfqq))
+			n = &(*p)->rb_left;
+		else if (cfq_class_idle(cfqq) > cfq_class_idle(__cfqq))
+			n = &(*p)->rb_right;
 		else if (rb_key < __cfqq->rb_key)
-			p = &(*p)->rb_left;
-		else {
-			p = &(*p)->rb_right;
+			n = &(*p)->rb_left;
+		else
+			n = &(*p)->rb_right;
+
+		if (n == &(*p)->rb_right)
 			left = 0;
-		}
+
+		p = n;
 	}
 
 	if (left)
@@ -506,19 +513,7 @@ static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 	if (!cfq_cfqq_on_rr(cfqq))
 		return;
 
-	list_del_init(&cfqq->cfq_list);
-
-	if (cfq_class_idle(cfqq)) {
-		/*
-		 * IDLE goes to the tail of the idle list
-		 */
-		list_add_tail(&cfqq->cfq_list, &cfqd->idle_rr);
-	} else {
-		/*
-		 * RT and BE queues, sort into the rbtree
-		 */
-		cfq_service_tree_add(cfqd, cfqq);
-	}
+	cfq_service_tree_add(cfqd, cfqq);
 }
 
 /*
@@ -791,20 +786,22 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
 	} else if (!RB_EMPTY_ROOT(&cfqd->service_tree.rb)) {
 		struct rb_node *n = cfq_rb_first(&cfqd->service_tree);
+		unsigned long end;
 
 		cfqq = rb_entry(n, struct cfq_queue, rb_node);
-	} else if (!list_empty(&cfqd->idle_rr)) {
-		/*
-		 * if we have idle queues and no rt or be queues had pending
-		 * requests, either allow immediate service if the grace period
-		 * has passed or arm the idle grace timer
-		 */
-		unsigned long end = cfqd->last_end_request + CFQ_IDLE_GRACE;
-
-		if (time_after_eq(jiffies, end))
-			cfqq = list_entry_cfqq(cfqd->idle_rr.next);
-		else
-			mod_timer(&cfqd->idle_class_timer, end);
+		if (cfq_class_idle(cfqq)) {
+			/*
+			 * if we have idle queues and no rt or be queues had
+			 * pending requests, either allow immediate service if
+			 * the grace period has passed or arm the idle grace
+			 * timer
+			 */
+			end = cfqd->last_end_request + CFQ_IDLE_GRACE;
+			if (time_before(jiffies, end)) {
+				mod_timer(&cfqd->idle_class_timer, end);
+				cfqq = NULL;
+			}
+		}
 	}
 
 	return cfqq;
@@ -1068,7 +1065,6 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	}
 
 	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->cur_rr);
-	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->idle_rr);
 
 	cfq_slice_expired(cfqd, 0, 0);
 
@@ -2047,7 +2043,6 @@ static void *cfq_init_queue(request_queue_t *q)
 
 	cfqd->service_tree = CFQ_RB_ROOT;
 	INIT_LIST_HEAD(&cfqd->cur_rr);
-	INIT_LIST_HEAD(&cfqd->idle_rr);
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
 	cfqd->cfq_hash = kmalloc_node(sizeof(struct hlist_head) * CFQ_QHASH_ENTRIES, GFP_KERNEL, q->node);
-- 
1.5.1.1.190.g74474

