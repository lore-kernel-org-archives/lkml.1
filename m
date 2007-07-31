Return-Path: <linux-kernel-owner+w=401wt.eu-S941314AbXGaC3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941314AbXGaC3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938776AbXGaCSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:36130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940549AbXGaCSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:39 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:26 +1000
Message-Id: <1070731021826.25561@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 030 of 35] Teach raid5 to split incoming bios.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We only need to split bios if we want to read around the cache,
as when we go through the cache, the sharing is already done.

So use bio_multi_split to split up read requests, and get rid of
raid5_mergeable_bvec as it is no longer needed.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   86 ++++++++++-----------------------------------------
 1 file changed, 18 insertions(+), 68 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-07-31 11:21:22.000000000 +1000
+++ ./drivers/md/raid5.c	2007-07-31 11:21:25.000000000 +1000
@@ -3805,39 +3805,6 @@ static int raid5_congested(void *data, i
 	return 0;
 }
 
-/* We want read requests to align with chunks where possible,
- * but write requests don't need to.
- */
-static int raid5_mergeable_bvec(struct request_queue *q, struct bio *bio, struct bio_vec *biovec)
-{
-	mddev_t *mddev = q->queuedata;
-	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
-	int max;
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
-	unsigned int bio_sectors = bio->bi_size >> 9;
-
-	if (bio_data_dir(bio) == WRITE)
-		return biovec->bv_len; /* always allow writes to be mergeable */
-
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0;
-	if (max <= biovec->bv_len && bio_sectors == 0)
-		return biovec->bv_len;
-	else
-		return max;
-}
-
-
-static int in_chunk_boundary(mddev_t *mddev, struct bio *bio)
-{
-	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
-	unsigned int bio_sectors = bio->bi_size >> 9;
-
-	return  chunk_sectors >=
-		((sector & (chunk_sectors - 1)) + bio_sectors);
-}
-
 /*
  *  add bio to the retry LIFO  ( in O(1) ... we are in interrupt )
  *  later sampled by raid5d.
@@ -3914,23 +3881,6 @@ static void raid5_align_endio(struct bio
 	add_bio_to_retry(raid_bi, conf);
 }
 
-static int bio_fits_rdev(struct bio *bi)
-{
-	struct request_queue *q = bdev_get_queue(bi->bi_bdev);
-
-	if ((bi->bi_size>>9) > q->max_sectors)
-		return 0;
-
-	if (q->merge_bvec_fn)
-		/* it's too hard to apply the merge_bvec_fn at this stage,
-		 * just just give up
-		 */
-		return 0;
-
-	return 1;
-}
-
-
 static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -3941,16 +3891,10 @@ static int chunk_aligned_read(struct req
 	struct bio* align_bi;
 	mdk_rdev_t *rdev;
 
-	if (!in_chunk_boundary(mddev, raid_bio)) {
-		pr_debug("chunk_aligned_read : non aligned\n");
-		return 0;
-	}
 	/*
  	 * use bio_clone to make a copy of the bio
 	 */
 	align_bi = bio_clone(raid_bio, GFP_NOIO);
-	if (!align_bi)
-		return 0;
 	/*
 	 *   set bi_end_io to a new function, and set bi_private to the
 	 *     original bio.
@@ -3976,13 +3920,6 @@ static int chunk_aligned_read(struct req
 		align_bi->bi_bdev =  rdev->bdev;
 		align_bi->bi_sector += rdev->data_offset;
 
-		if (!bio_fits_rdev(align_bi)) {
-			/* too big in some way */
-			bio_put(align_bi);
-			rdev_dec_pending(rdev, mddev);
-			return 0;
-		}
-
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_queue,
 				    conf->quiesce == 0,
@@ -4021,9 +3958,24 @@ static int make_request(struct request_q
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
 
 	if (rw == READ &&
-	     mddev->reshape_position == MaxSector &&
-	     chunk_aligned_read(q,bi))
-            	return 0;
+	    mddev->reshape_position == MaxSector) {
+		struct bio *remainder = bi;
+		int chunk_sects = mddev->chunk_size >> 9;
+		while (chunk_sects < ((remainder->bi_sector & (chunk_sects - 1))
+				      + (remainder->bi_size >> 9))) {
+			struct bio *new =
+				bio_multi_split(bi,
+						chunk_sects -
+						  (remainder->bi_sector
+						   & (chunk_sects - 1)),
+						&remainder);
+			if (!chunk_aligned_read(q, new))
+				make_request(q, new);
+		}
+		bi = remainder;
+		if (chunk_aligned_read(q, bi))
+			return 0;
+	}
 
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
@@ -4948,8 +4900,6 @@ static int run(mddev_t *mddev)
 	mddev->array_size =  mddev->size * (conf->previous_raid_disks -
 					    conf->max_degraded);
 
-	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
-
 	return 0;
 abort:
 	if (conf) {
