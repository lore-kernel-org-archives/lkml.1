Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZDPNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZDPNOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZDPNOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:14:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52646 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbZDPNOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:14:08 -0400
Message-ID: <49E72F19.1030400@redhat.com>
Date: Thu, 16 Apr 2009 15:14:01 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] block: simplify I/O stat accounting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This simplifies I/O stat accounting switching code and separates it
completely from I/O scheduler switch code.

Requests are accounted according to the state of their request queue
at the time of the request allocation. There is no need anymore to
flush the request queue when switching I/O accounting state.

Regards,
Jerome

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/blk-core.c       |    9 +++++----
 block/blk-merge.c      |    6 +++---
 block/blk-sysfs.c      |    4 ----
 block/blk.h            |    7 +------
 include/linux/blkdev.h |    3 +++
 5 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..30203a8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -643,7 +643,7 @@ static inline void blk_free_request(struct
request_queue *q, struct request *rq)
 }

 static struct request *
-blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t
gfp_mask)
+blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t
gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);

@@ -652,7 +652,7 @@ blk_alloc_request(struct request_queue *q, int rw,
int priv, gfp_t gfp_mask)

 	blk_rq_init(q, rq);

-	rq->cmd_flags = rw | REQ_ALLOCED;
+	rq->cmd_flags = flags | REQ_ALLOCED;

 	if (priv) {
 		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
@@ -744,7 +744,7 @@ static struct request *get_request(struct
request_queue *q, int rw_flags,
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	int may_queue, priv;
+	int may_queue, priv, iostat;

 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -792,9 +792,10 @@ static struct request *get_request(struct
request_queue *q, int rw_flags,
 	if (priv)
 		rl->elvpriv++;

+	iostat = blk_queue_io_stat(q) ? REQ_IO_STAT : 0;
 	spin_unlock_irq(q->queue_lock);

-	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
+	rq = blk_alloc_request(q, rw_flags | iostat, priv, gfp_mask);
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 63760ca..6a05270 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -338,9 +338,9 @@ static int ll_merge_requests_fn(struct request_queue
*q, struct request *req,
 	return 1;
 }

-static void blk_account_io_merge(struct request *req)
+static void blk_account_io_merge(struct request *req, struct request *next)
 {
-	if (blk_do_io_stat(req)) {
+	if (req->rq_disk && blk_rq_io_stat(next)) {
 		struct hd_struct *part;
 		int cpu;

@@ -402,7 +402,7 @@ static int attempt_merge(struct request_queue *q,
struct request *req,

 	elv_merge_requests(q, req, next);

-	blk_account_io_merge(req);
+	blk_account_io_merge(req, next);

 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
 	if (blk_rq_cpu_valid(next))
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 73f36be..3ff9bba 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -209,14 +209,10 @@ static ssize_t queue_iostats_store(struct
request_queue *q, const char *page,
 	ssize_t ret = queue_var_store(&stats, page, count);

 	spin_lock_irq(q->queue_lock);
-	elv_quisce_start(q);
-
 	if (stats)
 		queue_flag_set(QUEUE_FLAG_IO_STAT, q);
 	else
 		queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
-
-	elv_quisce_end(q);
 	spin_unlock_irq(q->queue_lock);

 	return ret;
diff --git a/block/blk.h b/block/blk.h
index 24fcaee..ad6dbdf 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -114,12 +114,7 @@ static inline int blk_cpu_to_group(int cpu)

 static inline int blk_do_io_stat(struct request *rq)
 {
-	struct gendisk *disk = rq->rq_disk;
-
-	if (!disk || !disk->queue)
-		return 0;
-
-	return blk_queue_io_stat(disk->queue) && (rq->cmd_flags & REQ_ELVPRIV);
+	return rq->rq_disk && blk_rq_io_stat(rq);
 }

 #endif
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba54c83..4629da4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -118,6 +118,7 @@ enum rq_flag_bits {
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
+	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_NR_BITS,		/* stops here */
 };

@@ -145,6 +146,7 @@ enum rq_flag_bits {
 #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
 #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
+#define REQ_IO_STAT	(1 << __REQ_IO_STAT)

 #define BLK_MAX_CDB	16

@@ -598,6 +600,7 @@ enum {
 				 blk_failfast_transport(rq) ||	\
 				 blk_failfast_driver(rq))
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
+#define blk_rq_io_stat(rq)	((rq)->flags & REQ_IO_STAT)

 #define blk_account_rq(rq)	(blk_rq_started(rq) && (blk_fs_request(rq)
|| blk_discard_rq(rq)))

