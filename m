Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZCZKNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZCZKNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZCZKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:13:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58890 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZCZKNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:13:40 -0400
Date: Thu, 26 Mar 2009 11:13:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block updates for 2.6.30
Message-ID: <20090326101337.GQ27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing particularly interesting in there, see below for full diff.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.30

Avishay Traeger (1):
      block: Repeated lines in switching-sched.txt

Boaz Harrosh (3):
      bsg: add support for tail queuing
      block: WARN in __blk_put_request() for potential bio leak
      bsg: Remove bogus check against request_queue->max_sectors

Dave Jones (1):
      cpqarray: enable bus mastering

Ingo Molnar (1):
      block: cleanup bio_alloc_bioset()

Jens Axboe (7):
      block: don't create bio_vec slabs of less than the inline number
      cciss: add BUILD_BUG_ON() for catching bad CommandList_struct alignment
      block: remove various blk_queue_*() setting functions in blk_init_queue_node()
      block: get rid of unused blkdev_free_rq() define
      Move the default_backing_dev_info out of readahead.c and into backing-dev.c
      btrfs: get rid of current_is_pdflush() in btrfs_btree_balance_dirty
      Get rid of pdflush_operation() in emergency sync and remount

Martin K. Petersen (1):
      block: add private bio_set for bio integrity allocations

Nikanth Karthikesan (2):
      loop: support barrier writes
      loop: fix circular locking in loop_clr_fd()

Petros Koutoupis (2):
      block: genhd.h comment needs updating
      block: genhd.h cleanup patch

 Documentation/block/switching-sched.txt |    6 --
 block/blk-core.c                        |   13 ++---
 block/blk-merge.c                       |    2 +
 block/bsg.c                             |   12 +++--
 block/scsi_ioctl.c                      |   21 ++------
 drivers/block/cciss.c                   |    7 +++
 drivers/block/cpqarray.c                |    1 +
 drivers/block/loop.c                    |   48 ++++++++++++++++--
 fs/bio-integrity.c                      |   85 +++++++++---------------------
 fs/bio.c                                |   87 ++++++++++++++++--------------
 fs/btrfs/disk-io.c                      |    2 +-
 fs/super.c                              |   11 +++-
 fs/sync.c                               |   14 +++++-
 include/linux/bio.h                     |   18 ++-----
 include/linux/bsg.h                     |    8 +++
 include/linux/genhd.h                   |    5 +-
 mm/backing-dev.c                        |   26 +++++++++-
 mm/readahead.c                          |   25 ---------
 18 files changed, 205 insertions(+), 186 deletions(-)

---

diff --git a/Documentation/block/switching-sched.txt b/Documentation/block/switching-sched.txt
index 634c952..d5af3f6 100644
--- a/Documentation/block/switching-sched.txt
+++ b/Documentation/block/switching-sched.txt
@@ -35,9 +35,3 @@ noop anticipatory deadline [cfq]
 # echo anticipatory > /sys/block/hda/queue/scheduler
 # cat /sys/block/hda/queue/scheduler
 noop [anticipatory] deadline cfq
-
-Each io queue has a set of io scheduler tunables associated with it. These
-tunables control how the io scheduler works. You can find these entries
-in:
-
-/sys/block/<device>/queue/iosched
diff --git a/block/blk-core.c b/block/blk-core.c
index 29bcfac..996ed90 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -603,13 +603,10 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
 	q->queue_lock		= lock;
 
-	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
-
+	/*
+	 * This also sets hw/phys segments, boundary and size
+	 */
 	blk_queue_make_request(q, __make_request);
-	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
-
-	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
-	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
 
 	q->sg_reserved_size = INT_MAX;
 
@@ -735,7 +732,6 @@ static void freed_request(struct request_queue *q, int rw, int priv)
 		__freed_request(q, rw ^ 1);
 }
 
-#define blkdev_free_rq(list) list_entry((list)->next, struct request, queuelist)
 /*
  * Get a free request, queue_lock must be held.
  * Returns NULL on failure, with queue_lock held.
@@ -1066,6 +1062,9 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 
 	elv_completed_request(q, req);
 
+	/* this is a bio leak */
+	WARN_ON(req->bio != NULL);
+
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
 	 * it didn't come out of our reserved rq pools
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5a244f0..e39cb24 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -403,6 +403,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (blk_rq_cpu_valid(next))
 		req->cpu = next->cpu;
 
+	/* owner-ship of bio passed from next to req */
+	next->bio = NULL;
 	__blk_put_request(q, next);
 	return 1;
 }
diff --git a/block/bsg.c b/block/bsg.c
index 0ce8806..206060e 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -218,9 +218,6 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
 
 	if (hdr->guard != 'Q')
 		return -EINVAL;
-	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
-	    hdr->din_xfer_len > (q->max_sectors << 9))
-		return -EIO;
 
 	switch (hdr->protocol) {
 	case BSG_PROTOCOL_SCSI:
@@ -353,6 +350,8 @@ static void bsg_rq_end_io(struct request *rq, int uptodate)
 static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 			    struct bsg_command *bc, struct request *rq)
 {
+	int at_head = (0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL));
+
 	/*
 	 * add bc command to busy queue and submit rq for io
 	 */
@@ -368,7 +367,7 @@ static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 	dprintk("%s: queueing rq %p, bc %p\n", bd->name, rq, bc);
 
 	rq->end_io_data = bc;
-	blk_execute_rq_nowait(q, NULL, rq, 1, bsg_rq_end_io);
+	blk_execute_rq_nowait(q, NULL, rq, at_head, bsg_rq_end_io);
 }
 
 static struct bsg_command *bsg_next_done_cmd(struct bsg_device *bd)
@@ -924,6 +923,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		struct request *rq;
 		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
+		int at_head;
 		u8 sense[SCSI_SENSE_BUFFERSIZE];
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
@@ -936,7 +936,9 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		bio = rq->bio;
 		if (rq->next_rq)
 			bidi_bio = rq->next_rq->bio;
-		blk_execute_rq(bd->queue, NULL, rq, 0);
+
+		at_head = (0 == (hdr.flags & BSG_FLAG_Q_AT_TAIL));
+		blk_execute_rq(bd->queue, NULL, rq, at_head);
 		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ee9c67d..626ee27 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -214,21 +214,10 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 	return 0;
 }
 
-/*
- * unmap a request that was previously mapped to this sg_io_hdr. handles
- * both sg and non-sg sg_io_hdr.
- */
-static int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
-{
-	blk_rq_unmap_user(rq->bio);
-	blk_put_request(rq);
-	return 0;
-}
-
 static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 				 struct bio *bio)
 {
-	int r, ret = 0;
+	int ret = 0;
 
 	/*
 	 * fill in all the output members
@@ -253,12 +242,10 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 			ret = -EFAULT;
 	}
 
-	rq->bio = bio;
-	r = blk_unmap_sghdr_rq(rq, hdr);
-	if (ret)
-		r = ret;
+	blk_rq_unmap_user(bio);
+	blk_put_request(rq);
 
-	return r;
+	return ret;
 }
 
 static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4f9b6d7..5d0e135 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3898,6 +3898,13 @@ static struct pci_driver cciss_pci_driver = {
  */
 static int __init cciss_init(void)
 {
+	/*
+	 * The hardware requires that commands are aligned on a 64-bit
+	 * boundary. Given that we use pci_alloc_consistent() to allocate an
+	 * array of them, the size must be a multiple of 8 bytes.
+	 */
+	BUILD_BUG_ON(sizeof(CommandList_struct) % 8);
+
 	printk(KERN_INFO DRIVER_NAME "\n");
 
 	/* Register for our PCI devices */
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 5d39df1..ca268ca 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -617,6 +617,7 @@ static int cpqarray_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	int i;
 
 	c->pci_dev = pdev;
+	pci_set_master(pdev);
 	if (pci_enable_device(pdev)) {
 		printk(KERN_ERR "cpqarray: Unable to Enable PCI device\n");
 		return -1;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bf03455..2621ed2 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -474,10 +474,35 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	int ret;
 
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
-	if (bio_rw(bio) == WRITE)
+
+	if (bio_rw(bio) == WRITE) {
+		int barrier = bio_barrier(bio);
+		struct file *file = lo->lo_backing_file;
+
+		if (barrier) {
+			if (unlikely(!file->f_op->fsync)) {
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
+
+			ret = vfs_fsync(file, file->f_path.dentry, 0);
+			if (unlikely(ret)) {
+				ret = -EIO;
+				goto out;
+			}
+		}
+
 		ret = lo_send(lo, bio, pos);
-	else
+
+		if (barrier && !ret) {
+			ret = vfs_fsync(file, file->f_path.dentry, 0);
+			if (unlikely(ret))
+				ret = -EIO;
+		}
+	} else
 		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
+
+out:
 	return ret;
 }
 
@@ -826,6 +851,9 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->lo_queue->queuedata = lo;
 	lo->lo_queue->unplug_fn = loop_unplug;
 
+	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
+		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
+
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
 
@@ -941,11 +969,18 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 		bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
-	fput(filp);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
 	if (max_part > 0)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
+	mutex_unlock(&lo->lo_ctl_mutex);
+	/*
+	 * Need not hold lo_ctl_mutex to fput backing file.
+	 * Calling fput holding lo_ctl_mutex triggers a circular
+	 * lock dependency possibility warning as fput can take
+	 * bd_mutex which is usually taken before lo_ctl_mutex.
+	 */
+	fput(filp);
 	return 0;
 }
 
@@ -1163,7 +1198,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	struct loop_device *lo = bdev->bd_disk->private_data;
 	int err;
 
-	mutex_lock(&lo->lo_ctl_mutex);
+	mutex_lock_nested(&lo->lo_ctl_mutex, 1);
 	switch (cmd) {
 	case LOOP_SET_FD:
 		err = loop_set_fd(lo, mode, bdev, arg);
@@ -1172,7 +1207,10 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		err = loop_change_fd(lo, bdev, arg);
 		break;
 	case LOOP_CLR_FD:
+		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
 		err = loop_clr_fd(lo, bdev);
+		if (!err)
+			goto out_unlocked;
 		break;
 	case LOOP_SET_STATUS:
 		err = loop_set_status_old(lo, (struct loop_info __user *) arg);
@@ -1190,6 +1228,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
 	mutex_unlock(&lo->lo_ctl_mutex);
+
+out_unlocked:
 	return err;
 }
 
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index fe2b1aa..31c46a2 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -26,23 +26,23 @@
 #include <linux/workqueue.h>
 
 static struct kmem_cache *bio_integrity_slab __read_mostly;
+static mempool_t *bio_integrity_pool;
+static struct bio_set *integrity_bio_set;
 static struct workqueue_struct *kintegrityd_wq;
 
 /**
- * bio_integrity_alloc_bioset - Allocate integrity payload and attach it to bio
+ * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
  * @gfp_mask:	Memory allocation mask
  * @nr_vecs:	Number of integrity metadata scatter-gather elements
- * @bs:		bio_set to allocate from
  *
  * Description: This function prepares a bio for attaching integrity
  * metadata.  nr_vecs specifies the maximum number of pages containing
  * integrity metadata that can be attached.
  */
-struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
-							 gfp_t gfp_mask,
-							 unsigned int nr_vecs,
-							 struct bio_set *bs)
+struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
+						  gfp_t gfp_mask,
+						  unsigned int nr_vecs)
 {
 	struct bio_integrity_payload *bip;
 	struct bio_vec *iv;
@@ -50,7 +50,7 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	BUG_ON(bio == NULL);
 
-	bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
+	bip = mempool_alloc(bio_integrity_pool, gfp_mask);
 	if (unlikely(bip == NULL)) {
 		printk(KERN_ERR "%s: could not alloc bip\n", __func__);
 		return NULL;
@@ -58,10 +58,10 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	memset(bip, 0, sizeof(*bip));
 
-	iv = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, bs);
+	iv = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, integrity_bio_set);
 	if (unlikely(iv == NULL)) {
 		printk(KERN_ERR "%s: could not alloc bip_vec\n", __func__);
-		mempool_free(bip, bs->bio_integrity_pool);
+		mempool_free(bip, bio_integrity_pool);
 		return NULL;
 	}
 
@@ -72,35 +72,16 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	return bip;
 }
-EXPORT_SYMBOL(bio_integrity_alloc_bioset);
-
-/**
- * bio_integrity_alloc - Allocate integrity payload and attach it to bio
- * @bio:	bio to attach integrity metadata to
- * @gfp_mask:	Memory allocation mask
- * @nr_vecs:	Number of integrity metadata scatter-gather elements
- *
- * Description: This function prepares a bio for attaching integrity
- * metadata.  nr_vecs specifies the maximum number of pages containing
- * integrity metadata that can be attached.
- */
-struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
-						  gfp_t gfp_mask,
-						  unsigned int nr_vecs)
-{
-	return bio_integrity_alloc_bioset(bio, gfp_mask, nr_vecs, fs_bio_set);
-}
 EXPORT_SYMBOL(bio_integrity_alloc);
 
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
- * @bs:		bio_set this bio was allocated from
  *
  * Description: Used to free the integrity portion of a bio. Usually
  * called from bio_free().
  */
-void bio_integrity_free(struct bio *bio, struct bio_set *bs)
+void bio_integrity_free(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 
@@ -111,8 +92,8 @@ void bio_integrity_free(struct bio *bio, struct bio_set *bs)
 	    && bip->bip_buf != NULL)
 		kfree(bip->bip_buf);
 
-	bvec_free_bs(bs, bip->bip_vec, bip->bip_pool);
-	mempool_free(bip, bs->bio_integrity_pool);
+	bvec_free_bs(integrity_bio_set, bip->bip_vec, bip->bip_pool);
+	mempool_free(bip, bio_integrity_pool);
 
 	bio->bi_integrity = NULL;
 }
@@ -686,19 +667,17 @@ EXPORT_SYMBOL(bio_integrity_split);
  * @bio:	New bio
  * @bio_src:	Original bio
  * @gfp_mask:	Memory allocation mask
- * @bs:		bio_set to allocate bip from
  *
  * Description:	Called to allocate a bip when cloning a bio
  */
-int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-			gfp_t gfp_mask, struct bio_set *bs)
+int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask)
 {
 	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
 	struct bio_integrity_payload *bip;
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc_bioset(bio, gfp_mask, bip_src->bip_vcnt, bs);
+	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
 
 	if (bip == NULL)
 		return -EIO;
@@ -714,37 +693,25 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 }
 EXPORT_SYMBOL(bio_integrity_clone);
 
-int bioset_integrity_create(struct bio_set *bs, int pool_size)
+static int __init bio_integrity_init(void)
 {
-	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size,
-							  bio_integrity_slab);
-	if (!bs->bio_integrity_pool)
-		return -1;
-
-	return 0;
-}
-EXPORT_SYMBOL(bioset_integrity_create);
+	kintegrityd_wq = create_workqueue("kintegrityd");
 
-void bioset_integrity_free(struct bio_set *bs)
-{
-	if (bs->bio_integrity_pool)
-		mempool_destroy(bs->bio_integrity_pool);
-}
-EXPORT_SYMBOL(bioset_integrity_free);
+	if (!kintegrityd_wq)
+		panic("Failed to create kintegrityd\n");
 
-void __init bio_integrity_init_slab(void)
-{
 	bio_integrity_slab = KMEM_CACHE(bio_integrity_payload,
 					SLAB_HWCACHE_ALIGN|SLAB_PANIC);
-}
 
-static int __init integrity_init(void)
-{
-	kintegrityd_wq = create_workqueue("kintegrityd");
+	bio_integrity_pool = mempool_create_slab_pool(BIO_POOL_SIZE,
+						      bio_integrity_slab);
+	if (!bio_integrity_pool)
+		panic("bio_integrity: can't allocate bip pool\n");
 
-	if (!kintegrityd_wq)
-		panic("Failed to create kintegrityd\n");
+	integrity_bio_set = bioset_create(BIO_POOL_SIZE, 0);
+	if (!integrity_bio_set)
+		panic("bio_integrity: can't allocate bio_set\n");
 
 	return 0;
 }
-subsys_initcall(integrity_init);
+subsys_initcall(bio_integrity_init);
diff --git a/fs/bio.c b/fs/bio.c
index d4f0632..a040cde 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -248,7 +248,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 	if (bio_integrity(bio))
-		bio_integrity_free(bio, bs);
+		bio_integrity_free(bio);
 
 	/*
 	 * If we have front padding, adjust the bio pointer before freeing
@@ -301,48 +301,51 @@ void bio_init(struct bio *bio)
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	struct bio_vec *bvl = NULL;
 	struct bio *bio = NULL;
-	void *uninitialized_var(p);
+	unsigned long idx = 0;
+	void *p = NULL;
 
 	if (bs) {
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
-
-		if (p)
-			bio = p + bs->front_pad;
-	} else
+		if (!p)
+			goto err;
+		bio = p + bs->front_pad;
+	} else {
 		bio = kmalloc(sizeof(*bio), gfp_mask);
+		if (!bio)
+			goto err;
+	}
 
-	if (likely(bio)) {
-		struct bio_vec *bvl = NULL;
-
-		bio_init(bio);
-		if (likely(nr_iovecs)) {
-			unsigned long uninitialized_var(idx);
-
-			if (nr_iovecs <= BIO_INLINE_VECS) {
-				idx = 0;
-				bvl = bio->bi_inline_vecs;
-				nr_iovecs = BIO_INLINE_VECS;
-			} else {
-				bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx,
-							bs);
-				nr_iovecs = bvec_nr_vecs(idx);
-			}
-			if (unlikely(!bvl)) {
-				if (bs)
-					mempool_free(p, bs->bio_pool);
-				else
-					kfree(bio);
-				bio = NULL;
-				goto out;
-			}
-			bio->bi_flags |= idx << BIO_POOL_OFFSET;
-			bio->bi_max_vecs = nr_iovecs;
-		}
-		bio->bi_io_vec = bvl;
+	bio_init(bio);
+
+	if (unlikely(!nr_iovecs))
+		goto out_set;
+
+	if (nr_iovecs <= BIO_INLINE_VECS) {
+		bvl = bio->bi_inline_vecs;
+		nr_iovecs = BIO_INLINE_VECS;
+	} else {
+		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
+		if (unlikely(!bvl))
+			goto err_free;
+
+		nr_iovecs = bvec_nr_vecs(idx);
 	}
-out:
+	bio->bi_flags |= idx << BIO_POOL_OFFSET;
+	bio->bi_max_vecs = nr_iovecs;
+out_set:
+	bio->bi_io_vec = bvl;
+
 	return bio;
+
+err_free:
+	if (bs)
+		mempool_free(p, bs->bio_pool);
+	else
+		kfree(bio);
+err:
+	return NULL;
 }
 
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
@@ -463,7 +466,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask);
 
 		if (ret < 0) {
 			bio_put(b);
@@ -1526,7 +1529,6 @@ void bioset_free(struct bio_set *bs)
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
-	bioset_integrity_free(bs);
 	biovec_free_pools(bs);
 	bio_put_slab(bs);
 
@@ -1567,9 +1569,6 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	if (bioset_integrity_create(bs, pool_size))
-		goto bad;
-
 	if (!biovec_create_pools(bs, pool_size))
 		return bs;
 
@@ -1586,6 +1585,13 @@ static void __init biovec_init_slabs(void)
 		int size;
 		struct biovec_slab *bvs = bvec_slabs + i;
 
+#ifndef CONFIG_BLK_DEV_INTEGRITY
+		if (bvs->nr_vecs <= BIO_INLINE_VECS) {
+			bvs->slab = NULL;
+			continue;
+		}
+#endif
+
 		size = bvs->nr_vecs * sizeof(struct bio_vec);
 		bvs->slab = kmem_cache_create(bvs->name, size, 0,
                                 SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
@@ -1600,7 +1606,6 @@ static int __init init_bio(void)
 	if (!bio_slabs)
 		panic("bio: can't allocate bios\n");
 
-	bio_integrity_init_slab();
 	biovec_init_slabs();
 
 	fs_bio_set = bioset_create(BIO_POOL_SIZE, 0);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e18175..6ec80c0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2385,7 +2385,7 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	unsigned long thresh = 32 * 1024 * 1024;
 	tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 
-	if (current_is_pdflush() || current->flags & PF_MEMALLOC)
+	if (current->flags & PF_MEMALLOC)
 		return;
 
 	num_dirty = count_range_bits(tree, &start, (u64)-1,
diff --git a/fs/super.c b/fs/super.c
index 6ce5014..dd4acb1 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -674,7 +674,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	return 0;
 }
 
-static void do_emergency_remount(unsigned long foo)
+static void do_emergency_remount(struct work_struct *work)
 {
 	struct super_block *sb;
 
@@ -697,12 +697,19 @@ static void do_emergency_remount(unsigned long foo)
 		spin_lock(&sb_lock);
 	}
 	spin_unlock(&sb_lock);
+	kfree(work);
 	printk("Emergency Remount complete\n");
 }
 
 void emergency_remount(void)
 {
-	pdflush_operation(do_emergency_remount, 0);
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_emergency_remount);
+		schedule_work(work);
+	}
 }
 
 /*
diff --git a/fs/sync.c b/fs/sync.c
index a16d53e..ec95a69 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -42,9 +42,21 @@ SYSCALL_DEFINE0(sync)
 	return 0;
 }
 
+static void do_sync_work(struct work_struct *work)
+{
+	do_sync(0);
+	kfree(work);
+}
+
 void emergency_sync(void)
 {
-	pdflush_operation(do_sync, 0);
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_sync_work);
+		schedule_work(work);
+	}
 }
 
 /*
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d8bd43b..b05b1d4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -426,9 +426,6 @@ struct bio_set {
 	unsigned int front_pad;
 
 	mempool_t *bio_pool;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	mempool_t *bio_integrity_pool;
-#endif
 	mempool_t *bvec_pool;
 };
 
@@ -519,9 +516,8 @@ static inline int bio_has_data(struct bio *bio)
 
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
-extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
-extern void bio_integrity_free(struct bio *, struct bio_set *);
+extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern int bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
@@ -531,27 +527,21 @@ extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
-extern int bioset_integrity_create(struct bio_set *, int);
-extern void bioset_integrity_free(struct bio_set *);
-extern void bio_integrity_init_slab(void);
+extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
 #define bio_integrity(a)		(0)
-#define bioset_integrity_create(a, b)	(0)
 #define bio_integrity_prep(a)		(0)
 #define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c,d )	(0)
-#define bioset_integrity_free(a)	do { } while (0)
-#define bio_integrity_free(a, b)	do { } while (0)
+#define bio_integrity_clone(a, b, c)	(0)
+#define bio_integrity_free(a)		do { } while (0)
 #define bio_integrity_endio(a, b)	do { } while (0)
 #define bio_integrity_advance(a, b)	do { } while (0)
 #define bio_integrity_trim(a, b, c)	do { } while (0)
 #define bio_integrity_split(a, b, c)	do { } while (0)
 #define bio_integrity_set_tag(a, b, c)	do { } while (0)
 #define bio_integrity_get_tag(a, b, c)	do { } while (0)
-#define bio_integrity_init_slab(a)	do { } while (0)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index cf0303a..3f0c64a 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -7,6 +7,14 @@
 #define BSG_SUB_PROTOCOL_SCSI_TMF	1
 #define BSG_SUB_PROTOCOL_SCSI_TRANSPORT	2
 
+/*
+ * For flags member below
+ * sg.h sg_io_hdr also has bits defined for it's flags member. However
+ * none of these bits are implemented/used by bsg. The bits below are
+ * allocated to not conflict with sg.h ones anyway.
+ */
+#define BSG_FLAG_Q_AT_TAIL 0x10 /* default, == 0 at this bit, is Q_AT_HEAD */
+
 struct sg_io_v4 {
 	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
 	__u32 protocol;		/* [i] 0 -> SCSI , .... */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 16948ea..634c530 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -333,11 +333,10 @@ static inline void part_dec_in_flight(struct hd_struct *part)
 		part_to_disk(part)->part0.in_flight--;
 }
 
-/* drivers/block/ll_rw_blk.c */
+/* block/blk-core.c */
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
-/* drivers/block/genhd.c */
-extern int get_blkdev_list(char *, int);
+/* block/genhd.c */
 extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8e85874..be68c95 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -2,11 +2,24 @@
 #include <linux/wait.h>
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/writeback.h>
 #include <linux/device.h>
 
+void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
+{
+}
+EXPORT_SYMBOL(default_unplug_io_fn);
+
+struct backing_dev_info default_backing_dev_info = {
+	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
+	.state		= 0,
+	.capabilities	= BDI_CAP_MAP_COPY,
+	.unplug_io_fn	= default_unplug_io_fn,
+};
+EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
 
@@ -166,9 +179,20 @@ static __init int bdi_class_init(void)
 	bdi_debug_init();
 	return 0;
 }
-
 postcore_initcall(bdi_class_init);
 
+static int __init default_bdi_init(void)
+{
+	int err;
+
+	err = bdi_init(&default_backing_dev_info);
+	if (!err)
+		bdi_register(&default_backing_dev_info, NULL, "default");
+
+	return err;
+}
+subsys_initcall(default_bdi_init);
+
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
diff --git a/mm/readahead.c b/mm/readahead.c
index bec83c1..9ce303d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -17,19 +17,6 @@
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
 
-void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
-{
-}
-EXPORT_SYMBOL(default_unplug_io_fn);
-
-struct backing_dev_info default_backing_dev_info = {
-	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
-	.state		= 0,
-	.capabilities	= BDI_CAP_MAP_COPY,
-	.unplug_io_fn	= default_unplug_io_fn,
-};
-EXPORT_SYMBOL_GPL(default_backing_dev_info);
-
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.
@@ -233,18 +220,6 @@ unsigned long max_sane_readahead(unsigned long nr)
 		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
 
-static int __init readahead_init(void)
-{
-	int err;
-
-	err = bdi_init(&default_backing_dev_info);
-	if (!err)
-		bdi_register(&default_backing_dev_info, NULL, "default");
-
-	return err;
-}
-subsys_initcall(readahead_init);
-
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */

-- 
Jens Axboe

