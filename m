Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZK3DE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZK3DE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZK3DEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:04:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbZK3DAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 03/21] blkio: Implement macro to traverse each idle tree in group
Date: Sun, 29 Nov 2009 21:59:10 -0500
Message-Id: <1259549968-10369-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Implement a macro to traverse each service tree in the group. This avoids
  usage of double for loop and special condition for idle tree 4 times.

o Macro is little twisted because of special handling of idle class service
  tree.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3baa3f4..c73ff44 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -303,6 +303,15 @@ CFQ_CFQQ_FNS(deep);
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
+/* Traverses through cfq group service trees */
+#define for_each_cfqg_st(cfqg, i, j, st) \
+	for (i = 0; i < 3; i++) \
+		for (j = 0, st = i < 2 ? &cfqg->service_trees[i][j] : \
+			&cfqg->service_tree_idle; \
+			(i < 2 && j < 3) || (i == 2 && j < 1); \
+			j++, st = i < 2 ? &cfqg->service_trees[i][j]: NULL) \
+
+
 static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
 {
 	if (cfq_class_idle(cfqq))
@@ -565,6 +574,10 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
  */
 static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 {
+	/* Service tree is empty */
+	if (!root->count)
+		return NULL;
+
 	if (!root->left)
 		root->left = rb_first(&root->rb);
 
@@ -1592,18 +1605,14 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	int dispatched = 0;
 	int i, j;
 	struct cfq_group *cfqg = &cfqd->root_group;
+	struct cfq_rb_root *st;
 
-	for (i = 0; i < 2; ++i)
-		for (j = 0; j < 3; ++j)
-			while ((cfqq = cfq_rb_first(&cfqg->service_trees[i][j]))
-				!= NULL)
-				dispatched += __cfq_forced_dispatch_cfqq(cfqq);
-
-	while ((cfqq = cfq_rb_first(&cfqg->service_tree_idle)) != NULL)
-		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+	for_each_cfqg_st(cfqg, i, j, st) {
+		while ((cfqq = cfq_rb_first(st)) != NULL)
+			dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+	}
 
 	cfq_slice_expired(cfqd, 0);
-
 	BUG_ON(cfqd->busy_queues);
 
 	cfq_log(cfqd, "forced_dispatch=%d", dispatched);
@@ -2974,6 +2983,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	struct cfq_data *cfqd;
 	int i, j;
 	struct cfq_group *cfqg;
+	struct cfq_rb_root *st;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
@@ -2981,11 +2991,8 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	/* Init root group */
 	cfqg = &cfqd->root_group;
-
-	for (i = 0; i < 2; ++i)
-		for (j = 0; j < 3; ++j)
-			cfqg->service_trees[i][j] = CFQ_RB_ROOT;
-	cfqg->service_tree_idle = CFQ_RB_ROOT;
+	for_each_cfqg_st(cfqg, i, j, st)
+		*st = CFQ_RB_ROOT;
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
-- 
1.6.2.5

