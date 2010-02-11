Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0BKMAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:00:10 -0500
Received: from mail.2ka.mipt.ru ([194.85.80.4]:34357 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab0BKMAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:00:08 -0500
Content-transfer-encoding: 7BIT
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] block: implement compatible DISCARD support
Date: Thu, 11 Feb 2010 13:53:45 +0300
Message-id: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are no many discs has native TRIM (aka) discard
feature support. But in fact this is good feature. We can easily
simlulate it for devices which has not native support.
In compat mode discard dequest transforms in to simple zerofiled
write request.
In fact currently blkdev_issue_discard function implemented
incorrectly.
1) Whait flags not optimal we dont have to wait for each bio in flight.
2) Not wait by default. Which makes it fairly useless.
3) Send each bio with barrier flag(if requested). Which result in
   bad performance. In fact caller just want to make shure that full
   request is completed and ordered against other requests.
5) It use allocated_page instead of ZERO_PAGE.

This patch introduce generic blkdev_issue_zeroout() function which also
may be used for native discard request support, in this case zero payload
simply ignored.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-barrier.c    |  190 +++++++++++++++++++++++++++++-------------------
 block/ioctl.c          |    3 +-
 include/linux/blkdev.h |    6 +-
 3 files changed, 121 insertions(+), 78 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 8618d89..5894a38 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -340,106 +340,148 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-static void blkdev_discard_end_io(struct bio *bio, int err)
+struct bio_batch
 {
+	atomic_t done;
+	unsigned long flags;
+	struct completion *wait;
+};
+
+static void bio_batch_end_io(struct bio *bio, int err)
+{
+	struct bio_batch *bb = bio->bi_private;
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			set_bit(BIO_EOPNOTSUPP, &bb->flags);
+		else
+			clear_bit(BIO_UPTODATE, &bb->flags);
 	}
-
-	if (bio->bi_private)
-		complete(bio->bi_private);
-	__free_page(bio_page(bio));
-
+	atomic_inc(&bb->done);
+	complete(bb->wait);
 	bio_put(bio);
 }
 
 /**
- * blkdev_issue_discard - queue a discard
- * @bdev:	blockdev to issue discard for
+ * blkdev_issue_zeroout generate number of zero filed write bios
+ * @bdev:	blockdev to issue
  * @sector:	start sector
  * @nr_sects:	number of sectors to discard
  * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @flags:	DISCARD_FL_* flags to control behaviour
+ * @rw:		RW flags
  *
  * Description:
- *    Issue a discard request for the sectors in question.
+ *  Generate and issue number of bios with zerofiled pages.
+ *  Send barrier at the end if requested. This guarantie that. All bios
+ *  submitted before the barrier will be completed before the barrier.
+ *  Empty barrier allow us to avoid post queue flush.
  */
-int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, int flags)
+
+int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, sector_t max_sects, gfp_t mask, int rw)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request_queue *q = bdev_get_queue(bdev);
-	int type = flags & DISCARD_FL_BARRIER ?
-		DISCARD_BARRIER : DISCARD_NOBARRIER;
-	struct bio *bio;
-	struct page *page;
 	int ret = 0;
+	struct bio *bio;
+	struct bio_batch bb;
+	unsigned int sz, issued = 0;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	unsigned int do_barrier = rw | (1 << BIO_RW_BARRIER);
+	rw &= ~(1 << BIO_RW_BARRIER);
+	BUG_ON(!(rw | (1 << BIO_RW)));
 
-	if (!q)
-		return -ENXIO;
-
-	if (!blk_queue_discard(q))
-		return -EOPNOTSUPP;
-
-	while (nr_sects && !ret) {
-		unsigned int sector_size = q->limits.logical_block_size;
-		unsigned int max_discard_sectors =
-			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	atomic_set(&bb.done, 0);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
 
-		bio = bio_alloc(gfp_mask, 1);
+submit:
+	while (nr_sects != 0) {
+		bio = bio_alloc(mask, min(nr_sects, (sector_t)BIO_MAX_PAGES));
 		if (!bio)
-			goto out;
-		bio->bi_sector = sector;
-		bio->bi_end_io = blkdev_discard_end_io;
-		bio->bi_bdev = bdev;
-		if (flags & DISCARD_FL_WAIT)
-			bio->bi_private = &wait;
-
-		/*
-		 * Add a zeroed one-sector payload as that's what
-		 * our current implementations need.  If we'll ever need
-		 * more the interface will need revisiting.
-		 */
-		page = alloc_page(gfp_mask | __GFP_ZERO);
-		if (!page)
-			goto out_free_bio;
-		if (bio_add_pc_page(q, bio, page, sector_size, 0) < sector_size)
-			goto out_free_page;
+			break;
 
+		bio->bi_sector = sector;
+		bio->bi_bdev   = bdev;
+		bio->bi_private = &bb;
+		bio->bi_end_io = bio_batch_end_io;
+
+		while(nr_sects != 0) {
+			sz = min(PAGE_SIZE >> 9 , nr_sects);
+			if (max_sects - bio_sectors(bio) < sz)
+				sz = max_sects - bio_sectors(bio);
+			if (sz == 0)
+				/* bio has maximum size possible */
+				break;
+			ret = bio_add_page(bio, ZERO_PAGE(0), sz << 9, 0);
+			nr_sects -= ret >> 9;
+			sector += ret >> 9;
+			if (ret != sz)
+				break;
+		}
+		issued++;
+		submit_bio(rw, bio);
+	}
+	if (nr_sects == 0) {
 		/*
-		 * And override the bio size - the way discard works we
-		 * touch many more blocks on disk than the actual payload
-		 * length.
+		 * We have issued all data. Send final barrier if necessery.
 		 */
-		if (nr_sects > max_discard_sectors) {
-			bio->bi_size = max_discard_sectors << 9;
-			nr_sects -= max_discard_sectors;
-			sector += max_discard_sectors;
-		} else {
-			bio->bi_size = nr_sects << 9;
-			nr_sects = 0;
-		}
+		if (do_barrier)
+			ret = blkdev_issue_flush(bdev, NULL);
+	}
+	/* Wait for submitted bios and then continue */
+	while (issued != atomic_read(&bb.done))
+		wait_for_completion(&wait);
 
-		bio_get(bio);
-		submit_bio(type, bio);
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
+		/* One of bios in the batch was completed with error.*/
+		ret = -EIO;
 
-		if (flags & DISCARD_FL_WAIT)
-			wait_for_completion(&wait);
+	if (ret)
+		goto out;
 
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
-			ret = -EIO;
-		bio_put(bio);
+	if (test_bit(BIO_EOPNOTSUPP, &bb.flags)) {
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
-	return ret;
-out_free_page:
-	__free_page(page);
-out_free_bio:
-	bio_put(bio);
+	if (nr_sects != 0)
+		goto submit;
 out:
-	return -ENOMEM;
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_zeroout);
+
+/**
+ * blkdev_issue_discard - queue a discard
+ * @bdev:	blockdev to issue discard for
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to discard
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	DISCARD_FL_* flags to control behaviour
+ *
+ * Description:
+ *    Issue a discard request for the sectors in question.
+ */
+int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, int flags)
+{
+	int type = flags & DISCARD_FL_BARRIER ?
+		DISCARD_BARRIER : DISCARD_NOBARRIER;
+	struct request_queue *q = bdev_get_queue(bdev);
+	unsigned int max_size;
+
+	if (!blk_queue_discard(q) && !(flags & DISCARD_FL_BARRIER))
+		return -EOPNOTSUPP;
+	/*
+	 * Generate request with zeroed payload.
+	 * If device has native discard support it simply ignore this payload.
+	 * In case of compat mode this request will be sent as a simple
+	 * write request.
+	 */
+	if (!blk_queue_discard(q)) {
+		type &= ~(1 << BIO_RW_DISCARD);
+		max_size = UINT_MAX >> 9;
+	} else {
+		max_size = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	}
+	return blkdev_issue_zeroout(bdev, sector, nr_sects, max_size,
+				gfp_mask, type);
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
diff --git a/block/ioctl.c b/block/ioctl.c
index be48ea5..384b71c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -124,8 +124,7 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 
 	if (start + len > (bdev->bd_inode->i_size >> 9))
 		return -EINVAL;
-	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
-				    DISCARD_FL_WAIT);
+	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, 0);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ffb13ad..c762c9f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -997,8 +997,10 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 }
 
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
-#define DISCARD_FL_WAIT		0x01	/* wait for completion */
-#define DISCARD_FL_BARRIER	0x02	/* issue DISCARD_BARRIER request */
+#define DISCARD_FL_BARRIER	0x01	/* issue DISCARD_BARRIER request */
+#define DISCARD_FL_COMPAT	0x02	/* allow discard compat request mode */
+extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, sector_t max_sects, gfp_t mask, int rw);
 extern int blkdev_issue_discard(struct block_device *, sector_t sector,
 		sector_t nr_sects, gfp_t, int flags);
 
-- 
1.6.6

