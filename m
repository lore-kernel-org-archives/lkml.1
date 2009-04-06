Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbZDFMux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbZDFMux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZDFMsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50497 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbZDFMsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:16 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/8] block: Add flag for telling the IO schedulers NOT to anticipate more IO
Date: Mon,  6 Apr 2009 14:48:07 +0200
Message-Id: <1239022088-29002-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, CFQ will anticipate more IO from a given io context if the
previously completed IO was sync. This used to be fine, since the only
sync IO was reads and O_DIRECT writes. But with more "normal" sync writes
being used now, we don't want to anticipate for those.

Add a bio/request flag that informs the IO scheduler that this is a sync
request that we should not idle for. Introduce WRITE_ODIRECT specifically
for O_DIRECT writes, and make sure that the other sync writes set this
flag.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |    2 ++
 block/cfq-iosched.c    |    4 +++-
 fs/direct-io.c         |    2 +-
 include/linux/bio.h    |   19 +++++++++++--------
 include/linux/blkdev.h |    3 +++
 include/linux/fs.h     |    9 +++++----
 6 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c4198f0..2557280 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1128,6 +1128,8 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_UNPLUG;
 	if (bio_rw_meta(bio))
 		req->cmd_flags |= REQ_RW_META;
+	if (bio_noidle(bio))
+		req->cmd_flags |= REQ_NOIDLE;
 
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 664ebfd..9e80934 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1992,8 +1992,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		}
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
-		else if (sync && RB_EMPTY_ROOT(&cfqq->sort_list))
+		else if (sync && !rq_noidle(rq) &&
+			 RB_EMPTY_ROOT(&cfqq->sort_list)) {
 			cfq_arm_slice_timer(cfqd);
+		}
 	}
 
 	if (!cfqd->rq_in_driver)
diff --git a/fs/direct-io.c b/fs/direct-io.c
index b6d4390..da258e7 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1126,7 +1126,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	int acquire_i_mutex = 0;
 
 	if (rw & WRITE)
-		rw = WRITE_SYNC;
+		rw = WRITE_ODIRECT;
 
 	if (bdev)
 		bdev_blkbits = blksize_bits(bdev_hardsect_size(bdev));
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b05b1d4..b900d2c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -145,20 +145,21 @@ struct bio {
  * bit 2 -- barrier
  *	Insert a serialization point in the IO queue, forcing previously
  *	submitted IO to be completed before this one is issued.
- * bit 3 -- synchronous I/O hint: the block layer will unplug immediately
- *	Note that this does NOT indicate that the IO itself is sync, just
- *	that the block layer will not postpone issue of this IO by plugging.
- * bit 4 -- metadata request
+ * bit 3 -- synchronous I/O hint.
+ * bit 4 -- Unplug the device immediately after submitting this bio.
+ * bit 5 -- metadata request
  *	Used for tracing to differentiate metadata and data IO. May also
  *	get some preferential treatment in the IO scheduler
- * bit 5 -- discard sectors
+ * bit 6 -- discard sectors
  *	Informs the lower level device that this range of sectors is no longer
  *	used by the file system and may thus be freed by the device. Used
  *	for flash based storage.
- * bit 6 -- fail fast device errors
- * bit 7 -- fail fast transport errors
- * bit 8 -- fail fast driver errors
+ * bit 7 -- fail fast device errors
+ * bit 8 -- fail fast transport errors
+ * bit 9 -- fail fast driver errors
  *	Don't want driver retries for any fast fail whatever the reason.
+ * bit 10 -- Tell the IO scheduler not to wait for more requests after this
+	one has been submitted, even if it is a SYNC request.
  */
 #define BIO_RW		0	/* Must match RW in req flags (blkdev.h) */
 #define BIO_RW_AHEAD	1	/* Must match FAILFAST in req flags */
@@ -170,6 +171,7 @@ struct bio {
 #define BIO_RW_FAILFAST_DEV		7
 #define BIO_RW_FAILFAST_TRANSPORT	8
 #define BIO_RW_FAILFAST_DRIVER		9
+#define BIO_RW_NOIDLE	10
 
 #define bio_rw_flagged(bio, flag)	((bio)->bi_rw & (1 << (flag)))
 
@@ -188,6 +190,7 @@ struct bio {
 #define bio_rw_ahead(bio)	bio_rw_flagged(bio, BIO_RW_AHEAD)
 #define bio_rw_meta(bio)	bio_rw_flagged(bio, BIO_RW_META)
 #define bio_discard(bio)	bio_rw_flagged(bio, BIO_RW_DISCARD)
+#define bio_noidle(bio)		bio_rw_flagged(bio, BIO_RW_NOIDLE)
 
 /*
  * upper 16 bits of bi_rw define the io priority of this bio
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 67dae3b..e036609 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -118,6 +118,7 @@ enum rq_flag_bits {
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_UNPLUG,		/* unplug queue on submission */
+	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -145,6 +146,7 @@ enum rq_flag_bits {
 #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
 #define REQ_UNPLUG	(1 << __REQ_UNPLUG)
+#define REQ_NOIDLE	(1 << __REQ_NOIDLE)
 
 #define BLK_MAX_CDB	16
 
@@ -633,6 +635,7 @@ static inline bool rq_is_sync(struct request *rq)
 }
 
 #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
+#define rq_noidle(rq)		((rq)->cmd_flags & REQ_NOIDLE)
 
 static inline int blk_queue_full(struct request_queue *q, int sync)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ea05109..cae5720 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -95,11 +95,12 @@ struct inodes_stat_t {
 #define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
-#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
-#define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO))
-#define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
+#define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
+#define WRITE_SYNC	(WRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
+#define WRITE_ODIRECT	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define SWRITE_SYNC_PLUG	\
-	(SWRITE | (1 << BIO_RW_SYNCIO))
+			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
+#define SWRITE_SYNC	(SWRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
 #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
 #define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
-- 
1.6.2.1.423.g442d

