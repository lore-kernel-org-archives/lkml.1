Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZDVMEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZDVMEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZDVMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:03:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZDVMD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:03:57 -0400
Date: Wed, 22 Apr 2009 14:03:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.30-rc3
Message-ID: <20090422120355.GD4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of fixes for 2.6.30-rc3. It includes fixes for regressions
and bug fixes in general, along with two buglets in CFQ. Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Alexander Beregalov (1):
      pktcdvd.h should include mempool.h

Bartlomiej Zolnierkiewicz (1):
      block: enable by default support for large devices and files on 32-bit archs

Jeff Moyer (2):
      cfq-iosched: make seek_mean converge more quickly
      cfq-iosched: use the default seek distance when there aren't enough seek samples

Jens Axboe (1):
      block: make blk_abort_queue() ignore non-request based devices

Jerome Marchand (1):
      block: simplify I/O stat accounting

Tejun Heo (6):
      scatterlist: make sure sg_miter_next() doesn't return 0 sized mappings
      block: fix SG_IO vector request data length handling
      block: fix queue bounce limit setting
      bio: fix bio_kmalloc()
      bio: use bio_kmalloc() in copy/map functions
      block: include empty disks in /proc/diskstats

 block/Kconfig           |   11 +++--
 block/blk-core.c        |    6 ++-
 block/blk-merge.c       |    5 ++-
 block/blk-settings.c    |   20 ++++---
 block/blk-sysfs.c       |    4 --
 block/blk-timeout.c     |    6 ++
 block/blk.h             |    7 +--
 block/cfq-iosched.c     |   15 +++--
 block/genhd.c           |   12 +++--
 block/scsi_ioctl.c      |   13 +++++-
 fs/bio.c                |  124 +++++++++++++++++++++-------------------------
 include/linux/bio.h     |    1 +
 include/linux/blkdev.h  |    3 +
 include/linux/genhd.h   |    1 +
 include/linux/pktcdvd.h |    1 +
 lib/scatterlist.c       |    9 ++-
 16 files changed, 131 insertions(+), 107 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index e7d1278..2c39527 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -26,6 +26,7 @@ if BLOCK
 config LBD
 	bool "Support for large block devices and files"
 	depends on !64BIT
+	default y
 	help
 	  Enable block devices or files of size 2TB and larger.
 
@@ -38,11 +39,13 @@ config LBD
 
 	  The ext4 filesystem requires that this feature be enabled in
 	  order to support filesystems that have the huge_file feature
-	  enabled.    Otherwise, it will refuse to mount any filesystems
-	  that use the huge_file feature, which is enabled by default
-	  by mke2fs.ext4.   The GFS2 filesystem also requires this feature.
+	  enabled.  Otherwise, it will refuse to mount in the read-write
+	  mode any filesystems that use the huge_file feature, which is
+	  enabled by default by mke2fs.ext4.
 
-	  If unsure, say N.
+	  The GFS2 filesystem also requires this feature.
+
+	  If unsure, say Y.
 
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
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
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 69c42ad..57af728 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -156,26 +156,28 @@ EXPORT_SYMBOL(blk_queue_make_request);
 
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
- * @q:  the request queue for the device
- * @dma_addr:   bus address limit
+ * @q: the request queue for the device
+ * @dma_mask: the maximum address the device can handle
  *
  * Description:
  *    Different hardware can have different requirements as to what pages
  *    it can do I/O directly to. A low level driver can call
  *    blk_queue_bounce_limit to have lower memory pages allocated as bounce
- *    buffers for doing I/O to pages residing above @dma_addr.
+ *    buffers for doing I/O to pages residing above @dma_mask.
  **/
-void blk_queue_bounce_limit(struct request_queue *q, u64 dma_addr)
+void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
 {
-	unsigned long b_pfn = dma_addr >> PAGE_SHIFT;
+	unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
 	int dma = 0;
 
 	q->bounce_gfp = GFP_NOIO;
 #if BITS_PER_LONG == 64
-	/* Assume anything <= 4GB can be handled by IOMMU.
-	   Actually some IOMMUs can handle everything, but I don't
-	   know of a way to test this here. */
-	if (b_pfn < (min_t(u64, 0x100000000UL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
+	/*
+	 * Assume anything <= 4GB can be handled by IOMMU.  Actually
+	 * some IOMMUs can handle everything, but I don't know of a
+	 * way to test this here.
+	 */
+	if (b_pfn < (min_t(u64, 0xffffffffUL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
 	q->bounce_pfn = max_low_pfn;
 #else
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
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index bbbdc4b..8f570c4 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -211,6 +211,12 @@ void blk_abort_queue(struct request_queue *q)
 	struct request *rq, *tmp;
 	LIST_HEAD(list);
 
+	/*
+	 * Not a request based block device, nothing to abort
+	 */
+	if (!q->request_fn)
+		return;
+
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	elv_abort_queue(q);
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
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0d3b70d..7e13f04 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -947,14 +947,18 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
 		return cfqd->last_position - rq->sector;
 }
 
+#define CIC_SEEK_THR	8 * 1024
+#define CIC_SEEKY(cic)	((cic)->seek_mean > CIC_SEEK_THR)
+
 static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
 {
 	struct cfq_io_context *cic = cfqd->active_cic;
+	sector_t sdist = cic->seek_mean;
 
 	if (!sample_valid(cic->seek_samples))
-		return 0;
+		sdist = CIC_SEEK_THR;
 
-	return cfq_dist_from_last(cfqd, rq) <= cic->seek_mean;
+	return cfq_dist_from_last(cfqd, rq) <= sdist;
 }
 
 static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
@@ -1039,9 +1043,6 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	return cfqq;
 }
 
-
-#define CIC_SEEKY(cic) ((cic)->seek_mean > (8 * 1024))
-
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
@@ -1908,7 +1909,9 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_io_context *cic,
 	sector_t sdist;
 	u64 total;
 
-	if (cic->last_request_pos < rq->sector)
+	if (!cic->last_request_pos)
+		sdist = 0;
+	else if (cic->last_request_pos < rq->sector)
 		sdist = rq->sector - cic->last_request_pos;
 	else
 		sdist = cic->last_request_pos - rq->sector;
diff --git a/block/genhd.c b/block/genhd.c
index a9ec910..1a4916e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -98,7 +98,7 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 
 	if (flags & DISK_PITER_REVERSE)
 		piter->idx = ptbl->len - 1;
-	else if (flags & DISK_PITER_INCL_PART0)
+	else if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
 		piter->idx = 0;
 	else
 		piter->idx = 1;
@@ -134,7 +134,8 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 	/* determine iteration parameters */
 	if (piter->flags & DISK_PITER_REVERSE) {
 		inc = -1;
-		if (piter->flags & DISK_PITER_INCL_PART0)
+		if (piter->flags & (DISK_PITER_INCL_PART0 |
+				    DISK_PITER_INCL_EMPTY_PART0))
 			end = -1;
 		else
 			end = 0;
@@ -150,7 +151,10 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
-		if (!(piter->flags & DISK_PITER_INCL_EMPTY) && !part->nr_sects)
+		if (!part->nr_sects &&
+		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
+		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
+		      piter->idx == 0))
 			continue;
 
 		get_device(part_to_dev(part));
@@ -1011,7 +1015,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 				"\n\n");
 	*/
  
-	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
+	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 84b7f87..82a0ca2 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -290,6 +290,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	if (hdr->iovec_count) {
 		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
+		size_t iov_data_len;
 		struct sg_iovec *iov;
 
 		iov = kmalloc(size, GFP_KERNEL);
@@ -304,8 +305,18 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 			goto out;
 		}
 
+		/* SG_IO howto says that the shorter of the two wins */
+		iov_data_len = iov_length((struct iovec *)iov,
+					  hdr->iovec_count);
+		if (hdr->dxfer_len < iov_data_len) {
+			hdr->iovec_count = iov_shorten((struct iovec *)iov,
+						       hdr->iovec_count,
+						       hdr->dxfer_len);
+			iov_data_len = hdr->dxfer_len;
+		}
+
 		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
-					  hdr->dxfer_len, GFP_KERNEL);
+					  iov_data_len, GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
diff --git a/fs/bio.c b/fs/bio.c
index cd42bb8..7bbc98f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -175,14 +175,6 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
 	struct bio_vec *bvl;
 
 	/*
-	 * If 'bs' is given, lookup the pool and do the mempool alloc.
-	 * If not, this is a bio_kmalloc() allocation and just do a
-	 * kzalloc() for the exact number of vecs right away.
-	 */
-	if (!bs)
-		bvl = kmalloc(nr * sizeof(struct bio_vec), gfp_mask);
-
-	/*
 	 * see comment near bvec_array define!
 	 */
 	switch (nr) {
@@ -260,21 +252,6 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 	mempool_free(p, bs->bio_pool);
 }
 
-/*
- * default destructor for a bio allocated with bio_alloc_bioset()
- */
-static void bio_fs_destructor(struct bio *bio)
-{
-	bio_free(bio, fs_bio_set);
-}
-
-static void bio_kmalloc_destructor(struct bio *bio)
-{
-	if (bio_has_allocated_vec(bio))
-		kfree(bio->bi_io_vec);
-	kfree(bio);
-}
-
 void bio_init(struct bio *bio)
 {
 	memset(bio, 0, sizeof(*bio));
@@ -301,21 +278,15 @@ void bio_init(struct bio *bio)
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	unsigned long idx = BIO_POOL_NONE;
 	struct bio_vec *bvl = NULL;
-	struct bio *bio = NULL;
-	unsigned long idx = 0;
-	void *p = NULL;
-
-	if (bs) {
-		p = mempool_alloc(bs->bio_pool, gfp_mask);
-		if (!p)
-			goto err;
-		bio = p + bs->front_pad;
-	} else {
-		bio = kmalloc(sizeof(*bio), gfp_mask);
-		if (!bio)
-			goto err;
-	}
+	struct bio *bio;
+	void *p;
+
+	p = mempool_alloc(bs->bio_pool, gfp_mask);
+	if (unlikely(!p))
+		return NULL;
+	bio = p + bs->front_pad;
 
 	bio_init(bio);
 
@@ -332,22 +303,50 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 		nr_iovecs = bvec_nr_vecs(idx);
 	}
+out_set:
 	bio->bi_flags |= idx << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
-out_set:
 	bio->bi_io_vec = bvl;
-
 	return bio;
 
 err_free:
-	if (bs)
-		mempool_free(p, bs->bio_pool);
-	else
-		kfree(bio);
-err:
+	mempool_free(p, bs->bio_pool);
 	return NULL;
 }
 
+static void bio_fs_destructor(struct bio *bio)
+{
+	bio_free(bio, fs_bio_set);
+}
+
+/**
+ *	bio_alloc - allocate a new bio, memory pool backed
+ *	@gfp_mask: allocation mask to use
+ *	@nr_iovecs: number of iovecs
+ *
+ *	Allocate a new bio with @nr_iovecs bvecs.  If @gfp_mask
+ *	contains __GFP_WAIT, the allocation is guaranteed to succeed.
+ *
+ *	RETURNS:
+ *	Pointer to new bio on success, NULL on failure.
+ */
+struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
+{
+	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
+
+	if (bio)
+		bio->bi_destructor = bio_fs_destructor;
+
+	return bio;
+}
+
+static void bio_kmalloc_destructor(struct bio *bio)
+{
+	if (bio_integrity(bio))
+		bio_integrity_free(bio);
+	kfree(bio);
+}
+
 /**
  * bio_alloc - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -366,29 +365,20 @@ err:
  *   do so can cause livelocks under memory pressure.
  *
  **/
-struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
-{
-	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
-
-	if (bio)
-		bio->bi_destructor = bio_fs_destructor;
-
-	return bio;
-}
-
-/*
- * Like bio_alloc(), but doesn't use a mempool backing. This means that
- * it CAN fail, but while bio_alloc() can only be used for allocations
- * that have a short (finite) life span, bio_kmalloc() should be used
- * for more permanent bio allocations (like allocating some bio's for
- * initalization or setup purposes).
- */
 struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
 {
-	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
+	struct bio *bio;
 
-	if (bio)
-		bio->bi_destructor = bio_kmalloc_destructor;
+	bio = kmalloc(sizeof(struct bio) + nr_iovecs * sizeof(struct bio_vec),
+		      gfp_mask);
+	if (unlikely(!bio))
+		return NULL;
+
+	bio_init(bio);
+	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
+	bio->bi_max_vecs = nr_iovecs;
+	bio->bi_io_vec = bio->bi_inline_vecs;
+	bio->bi_destructor = bio_kmalloc_destructor;
 
 	return bio;
 }
@@ -832,7 +822,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		goto out_bmd;
 
@@ -956,7 +946,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
 
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
@@ -1140,7 +1130,7 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 	int offset, i;
 	struct bio *bio;
 
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b89cf2d..7b214fd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -132,6 +132,7 @@ struct bio {
  * top 4 bits of bio flags indicate the pool this bio came from
  */
 #define BIO_POOL_BITS		(4)
+#define BIO_POOL_NONE		((1UL << BIO_POOL_BITS) - 1)
 #define BIO_POOL_OFFSET		(BITS_PER_LONG - BIO_POOL_BITS)
 #define BIO_POOL_MASK		(1UL << BIO_POOL_OFFSET)
 #define BIO_POOL_IDX(bio)	((bio)->bi_flags >> BIO_POOL_OFFSET)	
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
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 634c530..a1a28ca 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -214,6 +214,7 @@ static inline void disk_put_part(struct hd_struct *part)
 #define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
 #define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
+#define DISK_PITER_INCL_EMPTY_PART0 (1 << 3) /* include empty partition 0 */
 
 struct disk_part_iter {
 	struct gendisk		*disk;
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 04b4d73..d745f5b 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -113,6 +113,7 @@ struct pkt_ctrl_command {
 #include <linux/cdrom.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+#include <linux/mempool.h>
 
 /* default bio write queue congestion marks */
 #define PKT_WRITE_CONGESTION_ON    10000
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b7b449d..a295e40 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -347,9 +347,12 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	sg_miter_stop(miter);
 
 	/* get to the next sg if necessary.  __offset is adjusted by stop */
-	if (miter->__offset == miter->__sg->length && --miter->__nents) {
-		miter->__sg = sg_next(miter->__sg);
-		miter->__offset = 0;
+	while (miter->__offset == miter->__sg->length) {
+		if (--miter->__nents) {
+			miter->__sg = sg_next(miter->__sg);
+			miter->__offset = 0;
+		} else
+			return false;
 	}
 
 	/* map the next page */

-- 
Jens Axboe

