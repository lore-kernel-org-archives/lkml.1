Return-Path: <linux-kernel-owner+w=401wt.eu-S941131AbXGaCaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941131AbXGaCaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940568AbXGaCSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:36153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940560AbXGaCSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:50 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:36 +1000
Message-Id: <1070731021836.25591@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 032 of 35] Remove blk_queue_merge_bvec and bio_split and related code.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


No driver calls blk_queue_merge_bvec or bio_split any more,
so they can go.

Also, several places test if merge_bvec_fn is set or not.  As it is
now never set (it doens't even exist) they can be cleaned up too.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   23 ---------
 ./drivers/md/dm-table.c  |   12 -----
 ./drivers/md/linear.c    |    7 --
 ./drivers/md/md.c        |    1 
 ./drivers/md/multipath.c |   16 ------
 ./drivers/md/raid0.c     |    8 ---
 ./drivers/md/raid1.c     |   14 -----
 ./drivers/md/raid10.c    |   14 -----
 ./fs/bio.c               |  112 -----------------------------------------------
 ./include/linux/bio.h    |   20 --------
 ./include/linux/blkdev.h |    3 -
 11 files changed, 230 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:22.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:27.000000000 +1000
@@ -150,29 +150,6 @@ void blk_queue_prep_rq(struct request_qu
 
 EXPORT_SYMBOL(blk_queue_prep_rq);
 
-/**
- * blk_queue_merge_bvec - set a merge_bvec function for queue
- * @q:		queue
- * @mbfn:	merge_bvec_fn
- *
- * Usually queues have static limitations on the max sectors or segments that
- * we can put in a request. Stacking drivers may have some settings that
- * are dynamic, and thus we have to query the queue whether it is ok to
- * add a new bio_vec to a bio at a given offset or not. If the block device
- * has such limitations, it needs to register a merge_bvec_fn to control
- * the size of bio's sent to it. Note that a block device *must* allow a
- * single page to be added to an empty bio. The block device driver may want
- * to use the bio_split() function to deal with these bio's. By default
- * no merge_bvec_fn is defined for a queue, and only the fixed limits are
- * honored.
- */
-void blk_queue_merge_bvec(struct request_queue *q, merge_bvec_fn *mbfn)
-{
-	q->merge_bvec_fn = mbfn;
-}
-
-EXPORT_SYMBOL(blk_queue_merge_bvec);
-
 void blk_queue_softirq_done(struct request_queue *q, softirq_done_fn *fn)
 {
 	q->softirq_done_fn = fn;

diff .prev/drivers/md/dm-table.c ./drivers/md/dm-table.c
--- .prev/drivers/md/dm-table.c	2007-07-31 11:19:52.000000000 +1000
+++ ./drivers/md/dm-table.c	2007-07-31 11:21:27.000000000 +1000
@@ -539,18 +539,6 @@ void dm_set_device_limits(struct dm_targ
 	rs->max_sectors =
 		min_not_zero(rs->max_sectors, q->max_sectors);
 
-	/* FIXME: Device-Mapper on top of RAID-0 breaks because DM
-	 *        currently doesn't honor MD's merge_bvec_fn routine.
-	 *        In this case, we'll force DM to use PAGE_SIZE or
-	 *        smaller I/O, just to be safe. A better fix is in the
-	 *        works, but add this for the time being so it will at
-	 *        least operate correctly.
-	 */
-	if (q->merge_bvec_fn)
-		rs->max_sectors =
-			min_not_zero(rs->max_sectors,
-				     (unsigned int) (PAGE_SIZE >> 9));
-
 	rs->max_phys_segments =
 		min_not_zero(rs->max_phys_segments,
 			     q->max_phys_segments);

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2007-07-31 11:21:23.000000000 +1000
+++ ./drivers/md/linear.c	2007-07-31 11:21:27.000000000 +1000
@@ -123,13 +123,6 @@ static linear_conf_t *linear_conf(mddev_
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->size = rdev->size;
 		conf->array_size += rdev->size;

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/md.c	2007-07-31 11:21:27.000000000 +1000
@@ -3462,7 +3462,6 @@ static int do_md_stop(mddev_t * mddev, i
 				set_disk_ro(disk, 0);
 			blk_queue_make_request(mddev->queue, md_fail_request);
 			mddev->pers->stop(mddev);
-			mddev->queue->merge_bvec_fn = NULL;
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->issue_flush_fn = NULL;
 			mddev->queue->backing_dev_info.congested_fn = NULL;

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/multipath.c	2007-07-31 11:21:27.000000000 +1000
@@ -321,16 +321,6 @@ static int multipath_add_disk(mddev_t *m
 			q = rdev->bdev->bd_disk->queue;
 			blk_queue_stack_limits(mddev->queue, q);
 
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 * (Note: it is very unlikely that a device with
-		 * merge_bvec_fn will be involved in multipath.)
-		 */
-			if (q->merge_bvec_fn &&
-			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
-
 			conf->working_disks++;
 			mddev->degraded--;
 			rdev->raid_disk = path;
@@ -477,12 +467,6 @@ static int multipath_run (mddev_t *mddev
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, not that we ever expect a device with
-		 * a merge_bvec_fn to be involved in multipath */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!test_bit(Faulty, &rdev->flags))
 			conf->working_disks++;

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-07-31 11:21:23.000000000 +1000
+++ ./drivers/md/raid0.c	2007-07-31 11:21:27.000000000 +1000
@@ -161,14 +161,6 @@ static int create_strip_zones (mddev_t *
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev1->bdev->bd_disk->queue);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 */
-
-		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!smallest || (rdev1->size <smallest->size))
 			smallest = rdev1;

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-07-31 11:21:24.000000000 +1000
+++ ./drivers/md/raid10.c	2007-07-31 11:21:27.000000000 +1000
@@ -1049,13 +1049,6 @@ static int raid10_add_disk(mddev_t *mdde
 
 			blk_queue_stack_limits(mddev->queue,
 					       rdev->bdev->bd_disk->queue);
-			/* as we don't honour merge_bvec_fn, we must never risk
-			 * violating it, so limit ->max_sector to one PAGE, as
-			 * a one page request is never in violation.
-			 */
-			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-				mddev->queue->max_sectors = (PAGE_SIZE>>9);
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -2006,13 +1999,6 @@ static int run(mddev_t *mddev)
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			mddev->queue->max_sectors = (PAGE_SIZE>>9);
 
 		disk->head_position = 0;
 	}

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:21:23.000000000 +1000
+++ ./drivers/md/raid1.c	2007-07-31 11:21:27.000000000 +1000
@@ -1069,13 +1069,6 @@ static int raid1_add_disk(mddev_t *mddev
 
 			blk_queue_stack_limits(mddev->queue,
 					       rdev->bdev->bd_disk->queue);
-			/* as we don't honour merge_bvec_fn, we must never risk
-			 * violating it, so limit ->max_sector to one PAGE, as
-			 * a one page request is never in violation.
-			 */
-			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -1912,13 +1905,6 @@ static int run(mddev_t *mddev)
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->head_position = 0;
 	}

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:21:23.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:27.000000000 +1000
@@ -34,13 +34,6 @@ static struct kmem_cache *bio_slab __rea
 
 #define BIOVEC_NR_POOLS 6
 
-/*
- * a small number of entries is fine, not going to be performance critical.
- * basically we just need to survive
- */
-#define BIO_SPLIT_ENTRIES 2
-mempool_t *bio_split_pool __read_mostly;
-
 struct biovec_slab {
 	int nr_vecs;
 	char *name; 
@@ -322,11 +315,6 @@ static int __bio_add_page(struct request
 		if (page == prev->bv_page &&
 		    offset == prev->bv_offset + prev->bv_len) {
 			prev->bv_len += len;
-			if (q->merge_bvec_fn &&
-			    q->merge_bvec_fn(q, bio, prev) < len) {
-				prev->bv_len -= len;
-				return 0;
-			}
 
 			goto done;
 		}
@@ -344,24 +332,6 @@ static int __bio_add_page(struct request
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 
-	/*
-	 * if queue has other restrictions (eg varying max sector size
-	 * depending on offset), it can specify a merge_bvec_fn in the
-	 * queue to get further control
-	 */
-	if (q->merge_bvec_fn) {
-		/*
-		 * merge_bvec_fn() returns number of bytes it can accept
-		 * at this offset
-		 */
-		if (q->merge_bvec_fn(q, bio, bvec) < len) {
-			bvec->bv_page = NULL;
-			bvec->bv_len = 0;
-			bvec->bv_offset = 0;
-			return 0;
-		}
-	}
-
 	bio->bi_vcnt++;
  done:
 	bio->bi_size += len;
@@ -977,80 +947,6 @@ void bio_endio(struct bio *bio, int erro
 		bio->bi_end_io(bio, error);
 }
 
-void bio_pair_release(struct bio_pair *bp)
-{
-	if (atomic_dec_and_test(&bp->cnt)) {
-		struct bio *master = bp->bio1.bi_private;
-
-		bio_endio(master, bp->error);
-		mempool_free(bp, bp->bio2.bi_private);
-	}
-}
-
-static void bio_pair_end_1(struct bio *bi, int err)
-{
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
-
-	if (err)
-		bp->error = err;
-
-	bio_pair_release(bp);
-}
-
-static void bio_pair_end_2(struct bio *bi, int err)
-{
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
-
-	if (err)
-		bp->error = err;
-
-	bio_pair_release(bp);
-}
-
-/*
- * split a bio - only worry about a bio with a single page
- * in it's iovec
- */
-struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
-{
-	struct bio_pair *bp = mempool_alloc(pool, GFP_NOIO);
-
-	if (!bp)
-		return bp;
-
-	blk_add_trace_pdu_int(bdev_get_queue(bi->bi_bdev), BLK_TA_SPLIT, bi,
-				bi->bi_sector + first_sectors);
-
-	BUG_ON(bi->bi_vcnt != 1);
-	atomic_set(&bp->cnt, 3);
-	bp->error = 0;
-	bp->bio1 = *bi;
-	bp->bio2 = *bi;
-	bp->bio2.bi_sector += first_sectors;
-	bp->bio2.bi_size -= first_sectors << 9;
-	bp->bio1.bi_size = first_sectors << 9;
-
-	bp->bv1 = bi->bi_io_vec[0];
-	bp->bv2 = bi->bi_io_vec[0];
-	bp->bv2.bv_offset += first_sectors << 9;
-	bp->bv2.bv_len -= first_sectors << 9;
-	bp->bv1.bv_len = first_sectors << 9;
-
-	bp->bio1.bi_io_vec = &bp->bv1;
-	bp->bio2.bi_io_vec = &bp->bv2;
-
-	bp->bio1.bi_max_vecs = 1;
-	bp->bio2.bi_max_vecs = 1;
-
-	bp->bio1.bi_end_io = bio_pair_end_1;
-	bp->bio2.bi_end_io = bio_pair_end_2;
-
-	bp->bio1.bi_private = bi;
-	bp->bio2.bi_private = pool;
-
-	return bp;
-}
-
 static void multi_split_endio(struct bio *bio, int err)
 {
 	struct bio *master = bio->bi_private;
@@ -1206,11 +1102,6 @@ static int __init init_bio(void)
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
-	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
-						     sizeof(struct bio_pair));
-	if (!bio_split_pool)
-		panic("bio: can't create split pool\n");
-
 	return 0;
 }
 
@@ -1227,9 +1118,6 @@ EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_map_kern);
-EXPORT_SYMBOL(bio_pair_release);
-EXPORT_SYMBOL(bio_split);
-EXPORT_SYMBOL(bio_split_pool);
 EXPORT_SYMBOL(bio_copy_user);
 EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:21:23.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:27.000000000 +1000
@@ -260,26 +260,6 @@ struct bio_iterator {
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
 
 
-/*
- * A bio_pair is used when we need to split a bio.
- * This can only happen for a bio that refers to just one
- * page of data, and in the unusual situation when the
- * page crosses a chunk/device boundary
- *
- * The address of the master bio is stored in bio1.bi_private
- * The address of the pool the pair was allocated from is stored
- *   in bio2.bi_private
- */
-struct bio_pair {
-	struct bio	bio1, bio2;
-	struct bio_vec	bv1, bv2;
-	atomic_t	cnt;
-	int		error;
-};
-extern struct bio_pair *bio_split(struct bio *bi, mempool_t *pool,
-				  int first_sectors);
-extern mempool_t *bio_split_pool;
-extern void bio_pair_release(struct bio_pair *dbio);
 extern struct bio *bio_multi_split(struct bio *master, int first_sectors,
 			    struct bio **remainder);
 

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:21:22.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:27.000000000 +1000
@@ -365,7 +365,6 @@ typedef int (prep_rq_fn) (struct request
 typedef void (unplug_fn) (struct request_queue *);
 
 struct bio_vec;
-typedef int (merge_bvec_fn) (struct request_queue *, struct bio *, struct bio_vec *);
 typedef int (issue_flush_fn) (struct request_queue *, struct gendisk *, sector_t *);
 typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
@@ -403,7 +402,6 @@ struct request_queue
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
-	merge_bvec_fn		*merge_bvec_fn;
 	issue_flush_fn		*issue_flush_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
@@ -805,7 +803,6 @@ extern void blk_queue_hardsect_size(stru
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
-extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
