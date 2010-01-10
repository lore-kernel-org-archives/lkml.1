Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850Ab0AJVEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0AJVEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768Ab0AJVEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:04:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:52681 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab0AJVEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dJhGOxt0WlVgk83mDaMKhzJR4nTQENOArCmd+mHpN6TV/vPB9ncL+4Or1Ev+I1ZTFz
         8VtA6+x1T3Fi3jmRYWkOh919NsWWertQdFh5a+xz6qWhPQjuvCmFqcmiZBTMAkLRTvT7
         dBPCAoVbdiysQu6W8gw4lrSe7BjdI84/d7vaQ=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH] cfq-iosched: NCQ SSDs do not need read queue merging
Date: Sun, 10 Jan 2010 22:04:21 +0100
Message-Id: <1263157461-12294-1-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1262211768-10858-1-git-send-email-czoccolo@gmail.com>
References: <1262211768-10858-1-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NCQ SSDs' performances are not affected by
distance of read requests, so there is no point in having
overhead to merge such queues.

Non-NCQ SSDs showed regression in some special cases, so
they are ruled out by this patch.

This patch intentionally doesn't affect writes, so
it changes the queued[] field, to be indexed by
READ/WRITE instead of SYNC/ASYNC, and only compute proximity
for queues with WRITE requests.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 918c7fd..3b7c60e 100644
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
@@ -436,6 +436,10 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 	cic->cfqq[is_sync] = cfqq;
 }
 
+static inline bool is_smart_ssd(struct cfq_queue *cfqq)
+{
+	return blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag;
+}
 /*
  * We regard a request as SYNC, if it's either a read or has the SYNC bit
  * set (in which case it could also be direct WRITE).
@@ -1268,7 +1272,8 @@ static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		return;
 	if (!cfqq->next_rq)
 		return;
-
+	if (is_smart_ssd(cfqd) && !cfqq->queued[WRITE])
+		return;
 	cfqq->p_root = &cfqd->prio_trees[cfqq->org_ioprio];
 	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->p_root,
 				      blk_rq_pos(cfqq->next_rq), &parent, &p);
@@ -1337,10 +1342,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
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
 
@@ -1363,7 +1368,7 @@ static void cfq_add_rq_rb(struct request *rq)
 	struct cfq_data *cfqd = cfqq->cfqd;
 	struct request *__alias, *prev;
 
-	cfqq->queued[rq_is_sync(rq)]++;
+	cfqq->queued[rq_data_dir(rq)]++;
 
 	/*
 	 * looks a little odd, but the first insert might return an alias.
@@ -1393,7 +1398,7 @@ static void cfq_add_rq_rb(struct request *rq)
 static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
-	cfqq->queued[rq_is_sync(rq)]--;
+	cfqq->queued[rq_data_dir(rq)]--;
 	cfq_add_rq_rb(rq);
 }
 
@@ -1689,7 +1694,8 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 	struct cfq_queue *__cfqq;
 	sector_t sector = cfqd->last_position;
 
-	if (RB_EMPTY_ROOT(root))
+	if (RB_EMPTY_ROOT(root) ||
+	    (is_smart_ssd(cfqd) && !cur_cfqq->queued[WRITE]))
 		return NULL;
 
 	/*
@@ -1796,7 +1802,7 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	/* We do for queues that were marked with idle window flag. */
 	if (cfq_cfqq_idle_window(cfqq) &&
-	   !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
+	   !is_smart_ssd(cfqd))
 		return true;
 
 	/*
@@ -1817,7 +1823,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * for devices that support queuing, otherwise we still have a problem
 	 * with sync vs async workloads.
 	 */
-	if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
+	if (is_smart_ssd(cfqd))
 		return;
 
 	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
-- 
1.6.4.4

