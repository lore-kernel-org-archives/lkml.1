Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZBZJsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZBZJsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 04:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBZJs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 04:48:26 -0500
Received: from brick.kernel.dk ([93.163.65.50]:39103 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZBZJsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 04:48:25 -0500
Date: Thu, 26 Feb 2009 10:48:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] block bits for 2.6.29-rc
Message-ID: <20090226094821.GH6602@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A small collection of fixes for the current -rc series, please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (4):
      block: fix bogus gcc warning for uninitialized var usage
      cciss: shorten 30s timeout on controller reset
      block: reduce stack footprint of blk_recount_segments()
      xen/blkfront: use blk_rq_map_sg to generate ring entries

Márton Németh (1):
      block: add documentation for register_blkdev()

 block/blk-merge.c            |   94 +++++++++++++++++++++++------------------
 block/genhd.c                |   16 +++++++
 drivers/block/cciss.c        |   10 +++-
 drivers/block/xen-blkfront.c |   30 +++++++-------
 fs/bio.c                     |    2 +-
 include/linux/blkdev.h       |    2 +
 6 files changed, 94 insertions(+), 60 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b92f5b0..a104593 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -38,72 +38,84 @@ void blk_recalc_rq_sectors(struct request *rq, int nsect)
 	}
 }
 
-void blk_recalc_rq_segments(struct request *rq)
+static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
+					     struct bio *bio,
+					     unsigned int *seg_size_ptr)
 {
-	int nr_phys_segs;
 	unsigned int phys_size;
 	struct bio_vec *bv, *bvprv = NULL;
-	int seg_size;
-	int cluster;
-	struct req_iterator iter;
-	int high, highprv = 1;
-	struct request_queue *q = rq->q;
+	int cluster, i, high, highprv = 1;
+	unsigned int seg_size, nr_phys_segs;
+	struct bio *fbio;
 
-	if (!rq->bio)
-		return;
+	if (!bio)
+		return 0;
 
+	fbio = bio;
 	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	seg_size = 0;
 	phys_size = nr_phys_segs = 0;
-	rq_for_each_segment(bv, rq, iter) {
-		/*
-		 * the trick here is making sure that a high page is never
-		 * considered part of another segment, since that might
-		 * change with the bounce page.
-		 */
-		high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
-		if (high || highprv)
-			goto new_segment;
-		if (cluster) {
-			if (seg_size + bv->bv_len > q->max_segment_size)
-				goto new_segment;
-			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bv))
-				goto new_segment;
-			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
+	for_each_bio(bio) {
+		bio_for_each_segment(bv, bio, i) {
+			/*
+			 * the trick here is making sure that a high page is
+			 * never considered part of another segment, since that
+			 * might change with the bounce page.
+			 */
+			high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
+			if (high || highprv)
 				goto new_segment;
+			if (cluster) {
+				if (seg_size + bv->bv_len > q->max_segment_size)
+					goto new_segment;
+				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bv))
+					goto new_segment;
+				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
+					goto new_segment;
+
+				seg_size += bv->bv_len;
+				bvprv = bv;
+				continue;
+			}
+new_segment:
+			if (nr_phys_segs == 1 && seg_size >
+			    fbio->bi_seg_front_size)
+				fbio->bi_seg_front_size = seg_size;
 
-			seg_size += bv->bv_len;
+			nr_phys_segs++;
 			bvprv = bv;
-			continue;
+			seg_size = bv->bv_len;
+			highprv = high;
 		}
-new_segment:
-		if (nr_phys_segs == 1 && seg_size > rq->bio->bi_seg_front_size)
-			rq->bio->bi_seg_front_size = seg_size;
-
-		nr_phys_segs++;
-		bvprv = bv;
-		seg_size = bv->bv_len;
-		highprv = high;
 	}
 
-	if (nr_phys_segs == 1 && seg_size > rq->bio->bi_seg_front_size)
+	if (seg_size_ptr)
+		*seg_size_ptr = seg_size;
+
+	return nr_phys_segs;
+}
+
+void blk_recalc_rq_segments(struct request *rq)
+{
+	unsigned int seg_size = 0, phys_segs;
+
+	phys_segs = __blk_recalc_rq_segments(rq->q, rq->bio, &seg_size);
+
+	if (phys_segs == 1 && seg_size > rq->bio->bi_seg_front_size)
 		rq->bio->bi_seg_front_size = seg_size;
 	if (seg_size > rq->biotail->bi_seg_back_size)
 		rq->biotail->bi_seg_back_size = seg_size;
 
-	rq->nr_phys_segments = nr_phys_segs;
+	rq->nr_phys_segments = phys_segs;
 }
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
-	struct request rq;
 	struct bio *nxt = bio->bi_next;
-	rq.q = q;
-	rq.bio = rq.biotail = bio;
+
 	bio->bi_next = NULL;
-	blk_recalc_rq_segments(&rq);
+	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio, NULL);
 	bio->bi_next = nxt;
-	bio->bi_phys_segments = rq.nr_phys_segments;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
 EXPORT_SYMBOL(blk_recount_segments);
diff --git a/block/genhd.c b/block/genhd.c
index e1eadcc..a9ec910 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -256,6 +256,22 @@ void blkdev_show(struct seq_file *seqf, off_t offset)
 }
 #endif /* CONFIG_PROC_FS */
 
+/**
+ * register_blkdev - register a new block device
+ *
+ * @major: the requested major device number [1..255]. If @major=0, try to
+ *         allocate any unused major number.
+ * @name: the name of the new block device as a zero terminated string
+ *
+ * The @name must be unique within the system.
+ *
+ * The return value depends on the @major input parameter.
+ *  - if a major device number was requested in range [1..255] then the
+ *    function returns zero on success, or a negative error code
+ *  - if any unused major number was requested with @major=0 parameter
+ *    then the return value is the allocated major number in range
+ *    [1..255] or a negative error code otherwise
+ */
 int register_blkdev(unsigned int major, const char *name)
 {
 	struct blk_major_name **n, *p;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d2cb67b..b5a0611 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3611,11 +3611,15 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		schedule_timeout_uninterruptible(30*HZ);
 
 		/* Now try to get the controller to respond to a no-op */
-		for (i=0; i<12; i++) {
+		for (i=0; i<30; i++) {
 			if (cciss_noop(pdev) == 0)
 				break;
-			else
-				printk("cciss: no-op failed%s\n", (i < 11 ? "; re-trying" : ""));
+
+			schedule_timeout_uninterruptible(HZ);
+		}
+		if (i == 30) {
+			printk(KERN_ERR "cciss: controller seems dead\n");
+			return -EBUSY;
 		}
 	}
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 918ef72..b6c8ce2 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -40,6 +40,7 @@
 #include <linux/hdreg.h>
 #include <linux/cdrom.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
 
 #include <xen/xenbus.h>
 #include <xen/grant_table.h>
@@ -82,6 +83,7 @@ struct blkfront_info
 	enum blkif_state connected;
 	int ring_ref;
 	struct blkif_front_ring ring;
+	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	unsigned int evtchn, irq;
 	struct request_queue *rq;
 	struct work_struct work;
@@ -204,12 +206,11 @@ static int blkif_queue_request(struct request *req)
 	struct blkfront_info *info = req->rq_disk->private_data;
 	unsigned long buffer_mfn;
 	struct blkif_request *ring_req;
-	struct req_iterator iter;
-	struct bio_vec *bvec;
 	unsigned long id;
 	unsigned int fsect, lsect;
-	int ref;
+	int i, ref;
 	grant_ref_t gref_head;
+	struct scatterlist *sg;
 
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
 		return 1;
@@ -238,12 +239,13 @@ static int blkif_queue_request(struct request *req)
 	if (blk_barrier_rq(req))
 		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
 
-	ring_req->nr_segments = 0;
-	rq_for_each_segment(bvec, req, iter) {
-		BUG_ON(ring_req->nr_segments == BLKIF_MAX_SEGMENTS_PER_REQUEST);
-		buffer_mfn = pfn_to_mfn(page_to_pfn(bvec->bv_page));
-		fsect = bvec->bv_offset >> 9;
-		lsect = fsect + (bvec->bv_len >> 9) - 1;
+	ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
+	BUG_ON(ring_req->nr_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
+
+	for_each_sg(info->sg, sg, ring_req->nr_segments, i) {
+		buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
+		fsect = sg->offset >> 9;
+		lsect = fsect + (sg->length >> 9) - 1;
 		/* install a grant reference. */
 		ref = gnttab_claim_grant_reference(&gref_head);
 		BUG_ON(ref == -ENOSPC);
@@ -254,16 +256,12 @@ static int blkif_queue_request(struct request *req)
 				buffer_mfn,
 				rq_data_dir(req) );
 
-		info->shadow[id].frame[ring_req->nr_segments] =
-				mfn_to_pfn(buffer_mfn);
-
-		ring_req->seg[ring_req->nr_segments] =
+		info->shadow[id].frame[i] = mfn_to_pfn(buffer_mfn);
+		ring_req->seg[i] =
 				(struct blkif_request_segment) {
 					.gref       = ref,
 					.first_sect = fsect,
 					.last_sect  = lsect };
-
-		ring_req->nr_segments++;
 	}
 
 	info->ring.req_prod_pvt++;
@@ -622,6 +620,8 @@ static int setup_blkring(struct xenbus_device *dev,
 	SHARED_RING_INIT(sring);
 	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
+	sg_init_table(info->sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
+
 	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
 	if (err < 0) {
 		free_page((unsigned long)sring);
diff --git a/fs/bio.c b/fs/bio.c
index 72ab251..124b95c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -302,7 +302,7 @@ void bio_init(struct bio *bio)
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
 	struct bio *bio = NULL;
-	void *p;
+	void *uninitialized_var(p);
 
 	if (bs) {
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index dcaa0fd..465d6ba 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -708,6 +708,8 @@ struct req_iterator {
 };
 
 /* This should not be used directly - use rq_for_each_segment */
+#define for_each_bio(_bio)		\
+	for (; _bio; _bio = _bio->bi_next)
 #define __rq_for_each_bio(_bio, rq)	\
 	if ((rq->bio))			\
 		for (_bio = (rq)->bio; _bio; _bio = _bio->bi_next)

-- 
Jens Axboe

