Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZJSUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZJSUVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZJSUVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:21:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:6470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZJSUVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=X0e22vPmkAlXFFPCp+5mQjVTNpjFhKejUrlJKJxj2hfevtDFnIG+Oogs02cSEWC7tO
         1ncAHJDjYaEhP7OvSp77+Ce8IA7TWd+/KCQazEWd6n/qXexlExYULRXBKH93GcrmsM57
         9G1dmVnll8AjkwkBmZOWPaO8cY+Y0/N0BvKbQ=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC PATCH 2/5] cfq-iosched: preparation to handle multiple service trees
Date: Mon, 19 Oct 2009 22:21:15 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910192221.15739.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We embed a pointer to the service tree in each queue, to handle multiple
service trees easily.
Service trees are enriched with a counter.
Queues are enriched with a back pointer to their context.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 04d3b66..f866b17 100644
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
@@ -474,6 +479,7 @@ static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 	if (root->left == n)
 		root->left = NULL;
 	rb_erase_init(n, &root->rb);
+	--root->count;
 }
 
 /*
@@ -524,11 +530,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
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
@@ -546,7 +553,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqq->slice_resid = 0;
 	} else {
 		rb_key = -HZ;
-		__cfqq = cfq_rb_first(&cfqd->service_tree);
+		__cfqq = cfq_rb_first(service_tree);
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
 	}
 
@@ -557,12 +564,14 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
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
 
@@ -594,11 +603,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
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
@@ -701,8 +711,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
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
-- 
1.6.2.5


