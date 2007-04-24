Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXDXITU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXDXITU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXDXITS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:19:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41278 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031047AbXDXIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:43 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/15] cfq-iosched: speed up rbtree handling
Date: Tue, 24 Apr 2007 10:15:33 +0200
Message-Id: <11774025432403-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For cases where the rbtree is mainly used for sorting and min retrieval,
a nice speedup of the rbtree code is to maintain a cache of the leftmost
node in the tree.

Also spotted in the CFS CPU scheduler code.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   62 +++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ad29a99..7f964ee 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -70,6 +70,18 @@ static struct completion *ioc_gone;
 #define sample_valid(samples)	((samples) > 80)
 
 /*
+ * Most of our rbtree usage is for sorting with min extraction, so
+ * if we cache the leftmost node we don't have to walk down the tree
+ * to find it. Idea borrowed from Ingo Molnars CFS scheduler. We should
+ * move this into the elevator for the rq sorting as well.
+ */
+struct cfq_rb_root {
+	struct rb_root rb;
+	struct rb_node *left;
+};
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
+
+/*
  * Per block device queue structure
  */
 struct cfq_data {
@@ -78,7 +90,7 @@ struct cfq_data {
 	/*
 	 * rr list of queues with requests and the count of them
 	 */
-	struct rb_root service_tree;
+	struct cfq_rb_root service_tree;
 	struct list_head cur_rr;
 	struct list_head idle_rr;
 	unsigned int busy_queues;
@@ -378,6 +390,23 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
 	}
 }
 
+static struct rb_node *cfq_rb_first(struct cfq_rb_root *root)
+{
+	if (root->left)
+		return root->left;
+
+	return rb_first(&root->rb);
+}
+
+static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
+{
+	if (root->left == n)
+		root->left = NULL;
+
+	rb_erase(n, &root->rb);
+	RB_CLEAR_NODE(n);
+}
+
 /*
  * would be nice to take fifo expire time into account as well
  */
@@ -417,10 +446,10 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 static void cfq_service_tree_add(struct cfq_data *cfqd,
 				    struct cfq_queue *cfqq)
 {
-	struct rb_node **p = &cfqd->service_tree.rb_node;
+	struct rb_node **p = &cfqd->service_tree.rb.rb_node;
 	struct rb_node *parent = NULL;
-	struct cfq_queue *__cfqq;
 	unsigned long rb_key;
+	int left = 1;
 
 	rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
 	rb_key += cfqq->slice_resid;
@@ -433,22 +462,29 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 		if (rb_key == cfqq->rb_key)
 			return;
 
-		rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
 	}
 
 	while (*p) {
+		struct cfq_queue *__cfqq;
+
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
 		if (rb_key < __cfqq->rb_key)
 			p = &(*p)->rb_left;
-		else
+		else {
 			p = &(*p)->rb_right;
+			left = 0;
+		}
 	}
 
+	if (left)
+		cfqd->service_tree.left = &cfqq->rb_node;
+
 	cfqq->rb_key = rb_key;
 	rb_link_node(&cfqq->rb_node, parent, p);
-	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree);
+	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree.rb);
 }
 
 static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
@@ -509,10 +545,8 @@ cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_clear_cfqq_on_rr(cfqq);
 	list_del_init(&cfqq->cfq_list);
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
-		rb_erase(&cfqq->rb_node, &cfqd->service_tree);
-		RB_CLEAR_NODE(&cfqq->rb_node);
-	}
+	if (!RB_EMPTY_NODE(&cfqq->rb_node))
+		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
@@ -758,8 +792,8 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		 * if current list is non-empty, grab first entry.
 		 */
 		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
-	} else if (!RB_EMPTY_ROOT(&cfqd->service_tree)) {
-		struct rb_node *n = rb_first(&cfqd->service_tree);
+	} else if (!RB_EMPTY_ROOT(&cfqd->service_tree.rb)) {
+		struct rb_node *n = cfq_rb_first(&cfqd->service_tree);
 
 		cfqq = rb_entry(n, struct cfq_queue, rb_node);
 	} else if (!list_empty(&cfqd->idle_rr)) {
@@ -1030,7 +1064,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	int dispatched = 0;
 	struct rb_node *n;
 
-	while ((n = rb_first(&cfqd->service_tree)) != NULL) {
+	while ((n = cfq_rb_first(&cfqd->service_tree)) != NULL) {
 		struct cfq_queue *cfqq = rb_entry(n, struct cfq_queue, rb_node);
 
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
@@ -2014,7 +2048,7 @@ static void *cfq_init_queue(request_queue_t *q)
 
 	memset(cfqd, 0, sizeof(*cfqd));
 
-	cfqd->service_tree = RB_ROOT;
+	cfqd->service_tree = CFQ_RB_ROOT;
 	INIT_LIST_HEAD(&cfqd->cur_rr);
 	INIT_LIST_HEAD(&cfqd->idle_rr);
 	INIT_LIST_HEAD(&cfqd->cic_list);
-- 
1.5.1.1.190.g74474

