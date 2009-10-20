Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbZJTSMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbZJTSMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZJTSMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:12:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23407 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZJTSMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=C853K/5rqNlsuvn05RS+yR4Antlv53dowU0kI2MefYpMD9mrTGGOUoU9mWthiCsToP
         dOUKlBzbDT67cFuMNRJ8wGOC5AJ2FZVU+n4xIcBZFBYbk5kMPUy9qrfI3hkC9uN8ozvg
         Fmy5ykgMHNIhlQhktpgBuJG8R7MW/l8WjbjSI=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC V2 PATCH 2/5] cfq-iosched: preparation to handle multiple service trees
Date: Tue, 20 Oct 2009 20:11:59 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910202012.00196.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We embed a pointer to the service tree in each queue, to handle multiple
service trees easily.
Service trees are enriched with a counter.
cfq_add_rq_rb is invoked after putting the rq in the fifo, to ensure
that all fields in rq are properly initialized.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 25a3f46..c59609c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -69,8 +69,9 @@ static DEFINE_SPINLOCK(ioc_gone_lock);
 struct cfq_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
+	unsigned count;
 };
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, }
 
 /*
  * Per process-grouping structure
@@ -115,6 +116,9 @@ struct cfq_queue {
 	unsigned short ioprio_class, org_ioprio_class;
 
 	pid_t pid;
+
+	struct cfq_rb_root *service_tree;
+	struct cfq_io_context *cic;
 };
 
 /*
@@ -254,6 +258,7 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 				struct cfq_queue *cfqq, bool is_sync)
 {
 	cic->cfqq[is_sync] = cfqq;
+	cfqq->cic = cic;
 }
 
 /*
@@ -482,6 +487,7 @@ static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 	if (root->left == n)
 		root->left = NULL;
 	rb_erase_init(n, &root->rb);
+	--root->count;
 }
 
 /*
@@ -532,11 +538,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct rb_node **p, *parent;
 	struct cfq_queue *__cfqq;
 	unsigned long rb_key;
+	struct cfq_rb_root *service_tree = &cfqd->service_tree;
 	int left;
 
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&cfqd->service_tree.rb);
+		parent = rb_last(&service_tree->rb);
 		if (parent && parent != &cfqq->rb_node) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 			rb_key += __cfqq->rb_key;
@@ -554,7 +561,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqq->slice_resid = 0;
 	} else {
 		rb_key = -HZ;
-		__cfqq = cfq_rb_first(&cfqd->service_tree);
+		__cfqq = cfq_rb_first(service_tree);
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
 	}
 
@@ -565,12 +572,14 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		if (rb_key == cfqq->rb_key)
 			return;
 
-		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
+		cfqq->service_tree = NULL;
 	}
 
 	left = 1;
 	parent = NULL;
-	p = &cfqd->service_tree.rb.rb_node;
+	cfqq->service_tree = service_tree;
+	p = &service_tree->rb.rb_node;
 	while (*p) {
 		struct rb_node **n;
 
@@ -602,11 +611,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 	if (left)
-		cfqd->service_tree.left = &cfqq->rb_node;
+		service_tree->left = &cfqq->rb_node;
 
 	cfqq->rb_key = rb_key;
 	rb_link_node(&cfqq->rb_node, parent, p);
-	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree.rb);
+	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
+	service_tree->count++;
 }
 
 static struct cfq_queue *
@@ -709,8 +719,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 	cfq_clear_cfqq_on_rr(cfqq);
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node))
-		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
+		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
+		cfqq->service_tree = NULL;
+	}
 	if (cfqq->p_root) {
 		rb_erase(&cfqq->p_node, cfqq->p_root);
 		cfqq->p_root = NULL;
@@ -2194,10 +2206,9 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	cfq_log_cfqq(cfqd, cfqq, "insert_request");
 	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
 
-	cfq_add_rq_rb(rq);
-
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
+	cfq_add_rq_rb(rq);
 
 	cfq_rq_enqueued(cfqd, cfqq, rq);
 }
-- 
1.6.2.5


