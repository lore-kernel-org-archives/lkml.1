Return-Path: <linux-kernel-owner+w=401wt.eu-S1751541AbZL3WW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbZL3WW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZL3WW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:22:56 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64846 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZL3WWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AQUec7mqe6wN07NjgMH2lmzc78BysRlOzrZHItuDTRzfODK7m7dsdDIVj5r104l07j
         A+1C/uiLflsStA3NkbuTHGz0I8pt7+mAXbA6yaR6x76eqILsv1u+1GTks73akf6MyL5G
         D+FgVbMm9q/mkdVN8p3SRRjb7JlbaEEtt7o2k=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH] cfq-iosched: non-rot devices do not need read queue merging
Date: Wed, 30 Dec 2009 23:22:47 +0100
Message-Id: <1262211768-10858-1-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <20091230213439.GQ4489@kernel.dk>
References: <20091230213439.GQ4489@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non rotational devices' performances are not affected by
distance of read requests, so there is no point in having
overhead to merge such queues.
This doesn't apply to writes, so this patch changes the
queued[] field, to be indexed by READ/WRITE instead of
SYNC/ASYNC, and only compute proximity for queues with
WRITE requests.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 918c7fd..7da9391 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -108,9 +108,9 @@ struct cfq_queue {
 	struct rb_root sort_list;
 	/* if fifo isn't expired, next request to serve */
 	struct request *next_rq;
-	/* requests queued in sort_list */
+	/* requests queued in sort_list, indexed by READ/WRITE */
 	int queued[2];
-	/* currently allocated requests */
+	/* currently allocated requests, indexed by READ/WRITE */
 	int allocated[2];
 	/* fifo list of requests in sort_list */
 	struct list_head fifo;
@@ -1268,7 +1268,8 @@ static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		return;
 	if (!cfqq->next_rq)
 		return;
-
+	if (blk_queue_nonrot(cfqd->queue) && !cfqq->queued[WRITE])
+		return;
 	cfqq->p_root = &cfqd->prio_trees[cfqq->org_ioprio];
 	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->p_root,
 				      blk_rq_pos(cfqq->next_rq), &parent, &p);
@@ -1337,10 +1338,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 static void cfq_del_rq_rb(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
-	const int sync = rq_is_sync(rq);
+	const int rw = rq_data_dir(rq);
 
-	BUG_ON(!cfqq->queued[sync]);
-	cfqq->queued[sync]--;
+	BUG_ON(!cfqq->queued[rw]);
+	cfqq->queued[rw]--;
 
 	elv_rb_del(&cfqq->sort_list, rq);
 
@@ -1363,7 +1364,7 @@ static void cfq_add_rq_rb(struct request *rq)
 	struct cfq_data *cfqd = cfqq->cfqd;
 	struct request *__alias, *prev;
 
-	cfqq->queued[rq_is_sync(rq)]++;
+	cfqq->queued[rq_data_dir(rq)]++;
 
 	/*
 	 * looks a little odd, but the first insert might return an alias.
@@ -1393,7 +1394,7 @@ static void cfq_add_rq_rb(struct request *rq)
 static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
-	cfqq->queued[rq_is_sync(rq)]--;
+	cfqq->queued[rq_data_dir(rq)]--;
 	cfq_add_rq_rb(rq);
 }
 
@@ -1689,7 +1690,8 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 	struct cfq_queue *__cfqq;
 	sector_t sector = cfqd->last_position;
 
-	if (RB_EMPTY_ROOT(root))
+	if (RB_EMPTY_ROOT(root) ||
+	    (blk_queue_nonrot(cfqd->queue) && !cur_cfqq->queued[WRITE]))
 		return NULL;
 
 	/*
-- 
1.6.4.4

