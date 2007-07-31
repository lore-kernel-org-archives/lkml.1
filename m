Return-Path: <linux-kernel-owner+w=401wt.eu-S940656AbXGaC2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940656AbXGaC2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940537AbXGaCSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:36 -0400
Received: from mail.suse.de ([195.135.220.2]:52850 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940239AbXGaCSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:34 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:21 +1000
Message-Id: <1070731021821.25544@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 029 of 35] Teach md/raid10 to split arbitrarily large bios.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


.. using the new bio_multi_split.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |   70 ++++++++++----------------------------------------
 1 file changed, 14 insertions(+), 56 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-07-31 11:21:22.000000000 +1000
+++ ./drivers/md/raid10.c	2007-07-31 11:21:24.000000000 +1000
@@ -436,33 +436,6 @@ static sector_t raid10_find_virt(conf_t 
 	return (vchunk << conf->chunk_shift) + offset;
 }
 
-/**
- *	raid10_mergeable_bvec -- tell bio layer if a two requests can be merged
- *	@q: request queue
- *	@bio: the buffer head that's been built up so far
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can accept at this offset
- *      If near_copies == raid_disk, there are no striping issues,
- *      but in that case, the function isn't called at all.
- */
-static int raid10_mergeable_bvec(struct request_queue *q, struct bio *bio,
-				struct bio_vec *bio_vec)
-{
-	mddev_t *mddev = q->queuedata;
-	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
-	int max;
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
-	unsigned int bio_sectors = bio->bi_size >> 9;
-
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
-	if (max <= bio_vec->bv_len && bio_sectors == 0)
-		return bio_vec->bv_len;
-	else
-		return max;
-}
-
 /*
  * This routine returns the disk from which the requested read should
  * be done. There is a per-array 'next expected sequential IO' sector
@@ -772,6 +745,7 @@ static int make_request(struct request_q
 	mirror_info_t *mirror;
 	r10bio_t *r10_bio;
 	struct bio *read_bio;
+	struct bio *remainder = bio;
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
@@ -785,35 +759,21 @@ static int make_request(struct request_q
 	}
 
 	/* If this request crosses a chunk boundary, we need to
-	 * split it.  This will only happen for 1 PAGE (or less) requests.
+	 * split it.
 	 */
-	if (unlikely( (bio->bi_sector & conf->chunk_mask) + (bio->bi_size >> 9)
-		      > chunk_sects &&
-		    conf->near_copies < conf->raid_disks)) {
-		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1)
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
-		bp = bio_split(bio, bio_split_pool,
-			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
-		if (make_request(q, &bp->bio1))
-			generic_make_request(&bp->bio1);
-		if (make_request(q, &bp->bio2))
-			generic_make_request(&bp->bio2);
-
-		bio_pair_release(bp);
-		return 0;
-	bad_map:
-		printk("raid10_make_request bug: can't convert block across chunks"
-		       " or bigger than %dk %llu %d\n", chunk_sects/2,
-		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
-
-		bio_io_error(bio);
-		return 0;
+	while ((remainder->bi_sector & conf->chunk_mask)
+	       + (remainder->bi_size >> 9)
+	       > chunk_sects &&
+	       conf->near_copies < conf->raid_disks) {
+		struct bio *new =
+			bio_multi_split(bio,
+					chunk_sects
+					 - (remainder->bi_sector
+					    & (chunk_sects - 1)),
+					&remainder);
+		make_request(q, new);
 	}
+	bio = remainder;
 
 	md_write_start(mddev, bio);
 
@@ -2116,8 +2076,6 @@ static int run(mddev_t *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-	if (conf->near_copies < mddev->raid_disks)
-		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
 	return 0;
 
 out_free_conf:
