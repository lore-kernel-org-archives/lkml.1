Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbXDXIVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbXDXIVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXDXIUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24148 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbXDXIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:41 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/15] cfq-iosched: get rid of ->cur_rr and ->cfq_list
Date: Tue, 24 Apr 2007 10:15:38 +0200
Message-Id: <11774025432644-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's only used for preemption now that the IDLE and RT queues also
use the rbtree. If we pass an 'add_front' variable to
cfq_service_tree_add(), we can set ->rb_key to 0 to force insertion
at the front of the tree.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   87 +++++++++++++++++++--------------------------------
 1 files changed, 32 insertions(+), 55 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 251131a..2d0e9c5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -45,9 +45,6 @@ static int cfq_slice_idle = HZ / 125;
  */
 #define CFQ_QHASH_SHIFT		6
 #define CFQ_QHASH_ENTRIES	(1 << CFQ_QHASH_SHIFT)
-#define list_entry_qhash(entry)	hlist_entry((entry), struct cfq_queue, cfq_hash)
-
-#define list_entry_cfqq(ptr)	list_entry((ptr), struct cfq_queue, cfq_list)
 
 #define RQ_CIC(rq)		((struct cfq_io_context*)(rq)->elevator_private)
 #define RQ_CFQQ(rq)		((rq)->elevator_private2)
@@ -91,7 +88,6 @@ struct cfq_data {
 	 * rr list of queues with requests and the count of them
 	 */
 	struct cfq_rb_root service_tree;
-	struct list_head cur_rr;
 	unsigned int busy_queues;
 
 	/*
@@ -146,8 +142,6 @@ struct cfq_queue {
 	struct hlist_node cfq_hash;
 	/* hash key */
 	unsigned int key;
-	/* member of the rr/busy/cur/idle cfqd list */
-	struct list_head cfq_list;
 	/* service_tree member */
 	struct rb_node rb_node;
 	/* service_tree key */
@@ -452,16 +446,19 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
  * we will service the queues.
  */
 static void cfq_service_tree_add(struct cfq_data *cfqd,
-				    struct cfq_queue *cfqq)
+				    struct cfq_queue *cfqq, int add_front)
 {
 	struct rb_node **p = &cfqd->service_tree.rb.rb_node;
 	struct rb_node *parent = NULL;
 	unsigned long rb_key;
 	int left;
 
-	rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
-	rb_key += cfqq->slice_resid;
-	cfqq->slice_resid = 0;
+	if (!add_front) {
+		rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
+		rb_key += cfqq->slice_resid;
+		cfqq->slice_resid = 0;
+	} else
+		rb_key = 0;
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
 		/*
@@ -516,13 +513,13 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 /*
  * Update cfqq's position in the service tree.
  */
-static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
+static void cfq_resort_rr_list(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	/*
 	 * Resorting requires the cfqq to be on the RR list already.
 	 */
 	if (cfq_cfqq_on_rr(cfqq))
-		cfq_service_tree_add(cfqq->cfqd, cfqq);
+		cfq_service_tree_add(cfqd, cfqq, 0);
 }
 
 /*
@@ -536,7 +533,7 @@ cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
 
-	cfq_resort_rr_list(cfqq, 0);
+	cfq_resort_rr_list(cfqd, cfqq);
 }
 
 /*
@@ -548,7 +545,6 @@ cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 	cfq_clear_cfqq_on_rr(cfqq);
-	list_del_init(&cfqq->cfq_list);
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node))
 		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
@@ -765,7 +761,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (timed_out && !cfq_cfqq_slice_new(cfqq))
 		cfqq->slice_resid = cfqq->slice_end - jiffies;
 
-	cfq_resort_rr_list(cfqq, preempted);
+	cfq_resort_rr_list(cfqd, cfqq);
 
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
@@ -793,31 +789,28 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, int preempted,
  */
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
-	struct cfq_queue *cfqq = NULL;
+	struct cfq_queue *cfqq;
+	struct rb_node *n;
 
-	if (!list_empty(&cfqd->cur_rr)) {
-		/*
-		 * if current list is non-empty, grab first entry.
-		 */
-		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
-	} else if (!RB_EMPTY_ROOT(&cfqd->service_tree.rb)) {
-		struct rb_node *n = cfq_rb_first(&cfqd->service_tree);
+	if (RB_EMPTY_ROOT(&cfqd->service_tree.rb))
+		return NULL;
 
-		cfqq = rb_entry(n, struct cfq_queue, rb_node);
-		if (cfq_class_idle(cfqq)) {
-			unsigned long end;
+	n = cfq_rb_first(&cfqd->service_tree);
+	cfqq = rb_entry(n, struct cfq_queue, rb_node);
 
-			/*
-			 * if we have idle queues and no rt or be queues had
-			 * pending requests, either allow immediate service if
-			 * the grace period has passed or arm the idle grace
-			 * timer
-			 */
-			end = cfqd->last_end_request + CFQ_IDLE_GRACE;
-			if (time_before(jiffies, end)) {
-				mod_timer(&cfqd->idle_class_timer, end);
-				cfqq = NULL;
-			}
+	if (cfq_class_idle(cfqq)) {
+		unsigned long end;
+
+		/*
+		 * if we have idle queues and no rt or be queues had
+		 * pending requests, either allow immediate service if
+		 * the grace period has passed or arm the idle grace
+		 * timer
+		 */
+		end = cfqd->last_end_request + CFQ_IDLE_GRACE;
+		if (time_before(jiffies, end)) {
+			mod_timer(&cfqd->idle_class_timer, end);
+			cfqq = NULL;
 		}
 	}
 
@@ -1069,18 +1062,6 @@ static inline int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	return dispatched;
 }
 
-static int cfq_forced_dispatch_cfqqs(struct list_head *list)
-{
-	struct cfq_queue *cfqq, *next;
-	int dispatched;
-
-	dispatched = 0;
-	list_for_each_entry_safe(cfqq, next, list, cfq_list)
-		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
-
-	return dispatched;
-}
-
 /*
  * Drain our current requests. Used for barriers and when switching
  * io schedulers on-the-fly.
@@ -1096,8 +1077,6 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 	}
 
-	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->cur_rr);
-
 	cfq_slice_expired(cfqd, 0, 0);
 
 	BUG_ON(cfqd->busy_queues);
@@ -1427,7 +1406,6 @@ retry:
 		memset(cfqq, 0, sizeof(*cfqq));
 
 		INIT_HLIST_NODE(&cfqq->cfq_hash);
-		INIT_LIST_HEAD(&cfqq->cfq_list);
 		RB_CLEAR_NODE(&cfqq->rb_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
@@ -1706,8 +1684,8 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * so we know that it will be selected next.
 	 */
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
-	list_del_init(&cfqq->cfq_list);
-	list_add(&cfqq->cfq_list, &cfqd->cur_rr);
+
+	cfq_service_tree_add(cfqd, cfqq, 1);
 
 	cfqq->slice_end = 0;
 	cfq_mark_cfqq_slice_new(cfqq);
@@ -2077,7 +2055,6 @@ static void *cfq_init_queue(request_queue_t *q)
 	memset(cfqd, 0, sizeof(*cfqd));
 
 	cfqd->service_tree = CFQ_RB_ROOT;
-	INIT_LIST_HEAD(&cfqd->cur_rr);
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
 	cfqd->cfq_hash = kmalloc_node(sizeof(struct hlist_head) * CFQ_QHASH_ENTRIES, GFP_KERNEL, q->node);
-- 
1.5.1.1.190.g74474

