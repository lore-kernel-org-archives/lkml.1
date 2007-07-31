Return-Path: <linux-kernel-owner+w=401wt.eu-S940599AbXGaCVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940599AbXGaCVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966677AbXGaCQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:16:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:36004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966638AbXGaCQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:16:53 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:40 +1000
Message-Id: <1070731021640.25225@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 010 of 35] New function blk_req_append_bio
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ll_back_merge_fn is currently exported to SCSI where is it used,
together with blk_rq_bio_prep, in exactly the same way these
functions are used in __blk_rq_map_user.

So move the common code into a new function (blk_rq_append_bio), and
don't export ll_back_merge_fn any longer.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c       |   38 ++++++++++++++++++++++----------------
 ./drivers/scsi/scsi_lib.c |   11 +----------
 ./include/linux/blkdev.h  |    6 +++---
 3 files changed, 26 insertions(+), 29 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:52.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:55.000000000 +1000
@@ -1405,7 +1405,8 @@ static inline int ll_new_hw_segment(stru
 	return 1;
 }
 
-int ll_back_merge_fn(struct request_queue *q, struct request *req, struct bio *bio)
+static int ll_back_merge_fn(struct request_queue *q, struct request *req,
+			    struct bio *bio)
 {
 	unsigned short max_sectors;
 	int len;
@@ -1441,7 +1442,6 @@ int ll_back_merge_fn(struct request_queu
 
 	return ll_new_hw_segment(q, req, bio);
 }
-EXPORT_SYMBOL(ll_back_merge_fn);
 
 static int ll_front_merge_fn(struct request_queue *q, struct request *req, 
 			     struct bio *bio)
@@ -2331,6 +2331,23 @@ static int __blk_rq_unmap_user(struct bi
 	return ret;
 }
 
+int blk_rq_append_bio(struct request_queue *q, struct request *rq,
+		      struct bio *bio)
+{
+	if (!rq->bio)
+		blk_rq_bio_prep(q, rq, bio);
+	else if (!ll_back_merge_fn(q, rq, bio))
+		return -EINVAL;
+	else {
+		rq->biotail->bi_next = bio;
+		rq->biotail = bio;
+
+		rq->data_len += bio->bi_size;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(blk_rq_append_bio);
+
 static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 			     void __user *ubuf, unsigned int len)
 {
@@ -2362,21 +2379,10 @@ static int __blk_rq_map_user(struct requ
 	 */
 	bio_get(bio);
 
-	if (!rq->bio)
-		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio)) {
-		ret = -EINVAL;
-		goto unmap_bio;
-	} else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
-
-		rq->data_len += bio->bi_size;
-	}
-
-	return bio->bi_size;
+	ret = blk_rq_append_bio(q, rq, bio);
+	if (!ret)
+		return bio->bi_size;
 
-unmap_bio:
 	/* if it was boucned we must call the end io function */
 	bio_endio(bio, 0);
 	__blk_rq_unmap_user(orig_bio);

diff .prev/drivers/scsi/scsi_lib.c ./drivers/scsi/scsi_lib.c
--- .prev/drivers/scsi/scsi_lib.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/scsi/scsi_lib.c	2007-07-31 11:20:55.000000000 +1000
@@ -263,16 +263,7 @@ static int scsi_merge_bio(struct request
 		bio->bi_rw |= (1 << BIO_RW);
 	blk_queue_bounce(q, &bio);
 
-	if (!rq->bio)
-		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio))
-		return -EINVAL;
-	else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
-	}
-
-	return 0;
+	return blk_rq_append_bio(q, rq, bio);
 }
 
 static void scsi_bi_endio(struct bio *bio, int error)

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:20:47.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:20:55.000000000 +1000
@@ -681,10 +681,10 @@ extern int sg_scsi_ioctl(struct file *, 
 		struct gendisk *, struct scsi_ioctl_command __user *);
 
 /*
- * Temporary export, until SCSI gets fixed up.
+ * Temporary(?) export, until SCSI gets fixed up.
  */
-extern int ll_back_merge_fn(struct request_queue *, struct request *,
-		struct bio *);
+extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
+			     struct bio *bio);
 
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
