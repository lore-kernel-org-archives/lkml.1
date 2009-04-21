Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZDUNcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZDUNcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZDUNcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:32:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZDUNcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:32:14 -0400
Message-ID: <49EDCAD6.9000807@redhat.com>
Date: Tue, 21 Apr 2009 15:32:06 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH v3] block: simplify I/O stat accounting
References: <49E72F19.1030400@redhat.com> <49E8662D.5010607@redhat.com> <20090417113756.GU4593@kernel.dk> <20090417115449.GV4593@kernel.dk> <49E87502.3050806@redhat.com> <20090417123025.GW4593@kernel.dk>
In-Reply-To: <20090417123025.GW4593@kernel.dk>
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


Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/blk-core.c       |    6 ++++--
 block/blk-merge.c      |    5 ++++-
 block/blk-sysfs.c      |    4 ----
 block/blk.h            |    7 +------
 include/linux/blkdev.h |    3 +++
 5 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..2998fe3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -643,7 +643,7 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
+blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
@@ -652,7 +652,7 @@ blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
 
 	blk_rq_init(q, rq);
 
-	rq->cmd_flags = rw | REQ_ALLOCED;
+	rq->cmd_flags = flags | REQ_ALLOCED;
 
 	if (priv) {
 		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
@@ -792,6 +792,8 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	if (priv)
 		rl->elvpriv++;
 
+	if (blk_queue_io_stat(q))
+		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
 	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 63760ca..23d2a6f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -402,7 +402,10 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 
 	elv_merge_requests(q, req, next);
 
-	blk_account_io_merge(req);
+	/*
+	 * 'next' is going away, so update stats accordingly
+	 */
+	blk_account_io_merge(next);
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
 	if (blk_rq_cpu_valid(next))
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cac4e9f..3ff9bba 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -209,14 +209,10 @@ static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
 	ssize_t ret = queue_var_store(&stats, page, count);
 
 	spin_lock_irq(q->queue_lock);
-	elv_quiesce_start(q);
-
 	if (stats)
 		queue_flag_set(QUEUE_FLAG_IO_STAT, q);
 	else
 		queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
-
-	elv_quiesce_end(q);
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
diff --git a/block/blk.h b/block/blk.h
index 5dfc412..79c85f7 100644
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
index ba54c83..2755d5c 100644
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
+#define blk_rq_io_stat(rq)	((rq)->cmd_flags & REQ_IO_STAT)
 
 #define blk_account_rq(rq)	(blk_rq_started(rq) && (blk_fs_request(rq) || blk_discard_rq(rq))) 
 
