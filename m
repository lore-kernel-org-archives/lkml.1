Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbZDBOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbZDBOtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760015AbZDBOsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:48:54 -0400
Received: from ottawa-hs-64-26-147-143.d-ip.magma.ca ([64.26.147.143]:38951
	"EHLO gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759031AbZDBOsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:48:51 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 10:48:51 EDT
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/5] Block: Discard may need to allocate pages
Date: Thu,  2 Apr 2009 10:37:23 -0400
Message-Id: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

SCSI and ATA both need to send data to the device.  In order to do this,
the BIO must be allocated with room for a page to be added, and the bio
needs to be passed to the discard prep function.  We also need to free
the page attached to the BIO before we free it.

init_request_from_bio() is not currently called from a context which
forbids sleeping, and to make sure it stays that way (so we don't have
to use GFP_ATOMIC), add a might_sleep() to it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 block/blk-barrier.c       |    4 +++-
 block/blk-core.c          |    4 +++-
 block/ioctl.c             |    4 +++-
 drivers/mtd/mtd_blkdevs.c |    2 +-
 include/linux/blkdev.h    |    3 ++-
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f7dae57..82a3035 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -356,6 +356,8 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	}
 
+	if (bio_has_data(bio))
+		__free_page(bio_page(bio));
 	bio_put(bio);
 }
 
@@ -387,7 +389,7 @@ int blkdev_issue_discard(struct block_device *bdev,
 		return -EOPNOTSUPP;
 
 	while (nr_sects && !ret) {
-		bio = bio_alloc(gfp_mask, 0);
+		bio = bio_alloc(gfp_mask, 1);
 		if (!bio)
 			return -ENOMEM;
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 996ed90..7899761 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1095,6 +1095,8 @@ EXPORT_SYMBOL(blk_put_request);
 
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
+	might_sleep();
+
 	req->cpu = bio->bi_comp_cpu;
 	req->cmd_type = REQ_TYPE_FS;
 
@@ -1118,7 +1120,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_DISCARD;
 		if (bio_barrier(bio))
 			req->cmd_flags |= REQ_SOFTBARRIER;
-		req->q->prepare_discard_fn(req->q, req);
+		req->q->prepare_discard_fn(req->q, req, bio);
 	} else if (unlikely(bio_barrier(bio)))
 		req->cmd_flags |= (REQ_HARDBARRIER | REQ_NOMERGE);
 
diff --git a/block/ioctl.c b/block/ioctl.c
index 0f22e62..088a9ba 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -145,7 +145,7 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 		DECLARE_COMPLETION_ONSTACK(wait);
 		struct bio *bio;
 
-		bio = bio_alloc(GFP_KERNEL, 0);
+		bio = bio_alloc(GFP_KERNEL, 1);
 		if (!bio)
 			return -ENOMEM;
 
@@ -170,6 +170,8 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 			ret = -EOPNOTSUPP;
 		else if (!bio_flagged(bio, BIO_UPTODATE))
 			ret = -EIO;
+		if (bio_has_data(bio))
+			__free_page(bio_page(bio));
 		bio_put(bio);
 	}
 	return ret;
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 1409f01..2b6ed4b 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -33,7 +33,7 @@ struct mtd_blkcore_priv {
 };
 
 static int blktrans_discard_request(struct request_queue *q,
-				    struct request *req)
+				    struct request *req, struct bio *bio)
 {
 	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
 	req->cmd[0] = REQ_LB_OP_DISCARD;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..9d9bd7b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -260,7 +260,8 @@ typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
-typedef int (prepare_discard_fn) (struct request_queue *, struct request *);
+typedef int (prepare_discard_fn) (struct request_queue *, struct request *,
+							struct bio *bio);
 
 struct bio_vec;
 struct bvec_merge_data {
-- 
1.6.2.1

