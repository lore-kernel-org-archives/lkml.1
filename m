Return-Path: <linux-kernel-owner+w=401wt.eu-S940727AbXGaCUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940727AbXGaCUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965505AbXGaCQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:16:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:35991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966550AbXGaCQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:16:42 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:29 +1000
Message-Id: <1070731021629.25195@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 008 of 35] Introduce bi_iocnt to count requests sharing the one bio.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This count is currently only used by raid5 (which used to use bi_phys_segments),
but it will be used more widely in future.

generic_make_request sets the count to 1, and bio_endio decrements it and
calls bi_end_io only when it hits zero.  A make_request_fn can do whatever
it likes if it doesn't call bio_endio directly.

As some bios do not come through generic_make_request (some are stuck on
the head of the request queue by scsi) we init bi_iocnt in bio_init too.

It now becomes important to call bi_endio exactly the right number of times,
so order_bio_endio can no-longer use it to call flush_dry_bio_endio.
So remove that function and opencode the effect inside ordered_bio_endio.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c   |   31 +++++++------------------------
 ./drivers/md/raid5.c  |   30 +++++++++++-------------------
 ./fs/bio.c            |    4 +++-
 ./include/linux/bio.h |    3 +++
 4 files changed, 24 insertions(+), 44 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:51.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:52.000000000 +1000
@@ -527,44 +527,25 @@ int blk_do_ordered(struct request_queue 
 	return 1;
 }
 
-static void flush_dry_bio_endio(struct bio *bio, int error)
-{
-
-	/*
-	 * This is dry run, restore bio_sector and size.  We'll finish
-	 * this request again with the original bi_end_io after an
-	 * error occurs or post flush is complete.
-	 */
-
-	/* Reset bio */
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
-}
-
 static int ordered_bio_endio(struct request *rq, struct bio *bio,
 			     int error)
 {
 	struct request_queue *q = rq->q;
-	bio_end_io_t *endio;
-	void *private;
 
 	if (&q->bar_rq != rq)
 		return 0;
 
 	/*
 	 * Okay, this is the barrier request in progress, dry finish it.
+	 *
+	 * We'll finish this request again with the original
+	 * bi_end_io after an error occurs or post flush is complete.
 	 */
+
 	if (error && !q->orderr)
 		q->orderr = error;
 
-	endio = bio->bi_end_io;
-	private = bio->bi_private;
-	bio->bi_end_io = flush_dry_bio_endio;
-	bio->bi_private = q;
-
-	bio_endio(bio, error);
-
-	bio->bi_end_io = endio;
-	bio->bi_private = private;
+	set_bit(BIO_UPTODATE, &bio->bi_flags);
 
 	return 1;
 }
@@ -3149,6 +3130,8 @@ static inline void __generic_make_reques
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 
+	atomic_set(&bio->bi_iocnt, 1);
+
 	might_sleep();
 	/* Test device or partition size, when known. */
 	maxsector = bio->bi_bdev->bd_inode->i_size >> 9;

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/raid5.c	2007-07-31 11:20:52.000000000 +1000
@@ -851,7 +851,7 @@ static void ops_complete_biofill(void *s
 				dev_q->sector + STRIPE_SECTORS) {
 				rbi2 = r5_next_bio(rbi, dev_q->sector);
 				spin_lock_irq(&conf->device_lock);
-				if (--rbi->bi_phys_segments == 0) {
+				if (atomic_dec_and_test(&rbi->bi_iocnt)) {
 					rbi->bi_next = return_bi;
 					return_bi = rbi;
 				}
@@ -2294,7 +2294,7 @@ static int add_queue_bio(struct stripe_q
 	if (*bip)
 		bi->bi_next = *bip;
 	*bip = bi;
-	bi->bi_phys_segments ++;
+	atomic_inc(&bi->bi_iocnt);
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sq->lock);
 
@@ -2395,7 +2395,7 @@ handle_requests_to_failed_array(raid5_co
 			sq->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *nextbi = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
-			if (--bi->bi_phys_segments == 0) {
+			if (atomic_dec_and_test(&bi->bi_iocnt)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
@@ -2410,7 +2410,7 @@ handle_requests_to_failed_array(raid5_co
 		       sq->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *bi2 = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
-			if (--bi->bi_phys_segments == 0) {
+			if (atomic_dec_and_test(&bi->bi_iocnt)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
@@ -2435,7 +2435,7 @@ handle_requests_to_failed_array(raid5_co
 				struct bio *nextbi =
 					r5_next_bio(bi, sq->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
+				if (atomic_dec_and_test(&bi->bi_iocnt)) {
 					bi->bi_next = *return_bi;
 					*return_bi = bi;
 				}
@@ -2640,7 +2640,7 @@ static void handle_completed_write_reque
 				while (wbi && wbi->bi_sector <
 					dev_q->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev_q->sector);
-					if (--wbi->bi_phys_segments == 0) {
+					if (atomic_dec_and_test(&wbi->bi_iocnt)) {
 						md_write_end(conf->mddev);
 						wbi->bi_next = *return_bi;
 						*return_bi = wbi;
@@ -3426,7 +3426,7 @@ static void handle_stripe6(struct stripe
 				copy_data(0, rbi, dev->page, dev_q->sector);
 				rbi2 = r5_next_bio(rbi, dev_q->sector);
 				spin_lock_irq(&conf->device_lock);
-				if (--rbi->bi_phys_segments == 0) {
+				if (atomic_dec_and_test(&rbi->bi_iocnt)) {
 					rbi->bi_next = return_bi;
 					return_bi = rbi;
 				}
@@ -3870,7 +3870,7 @@ static struct bio *remove_bio_from_retry
 	if(bi) {
 		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
-		bi->bi_phys_segments = 1; /* biased count of active stripes */
+		atomic_set(&bi->bi_iocnt, 1);
 		bi->bi_hw_segments = 0; /* count of processed stripes */
 	}
 
@@ -4014,7 +4014,6 @@ static int make_request(struct request_q
 	sector_t logical_sector, last_sector;
 	struct stripe_queue *sq;
 	const int rw = bio_data_dir(bi);
-	int remaining;
 
 	if (unlikely(bio_barrier(bi))) {
 		bio_endio(bi, -EOPNOTSUPP);
@@ -4034,7 +4033,7 @@ static int make_request(struct request_q
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	atomic_set(&bi->bi_iocnt, 1);
 
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
@@ -4131,10 +4130,7 @@ static int make_request(struct request_q
 		}
 			
 	}
-	spin_lock_irq(&conf->device_lock);
-	remaining = --bi->bi_phys_segments;
-	spin_unlock_irq(&conf->device_lock);
-	if (remaining == 0) {
+	if (atomic_dec_and_test(&bi->bi_iocnt)) {
 
 		if ( rw == WRITE )
 			md_write_end(mddev);
@@ -4408,7 +4404,6 @@ static int  retry_aligned_read(raid5_con
 	int dd_idx, pd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
-	int remaining;
 	int handled = 0;
 	int disks = conf->raid_disks;
 	int data_disks = disks - conf->max_degraded;
@@ -4455,10 +4450,7 @@ static int  retry_aligned_read(raid5_con
 		handle_queue(sq, disks, data_disks);
 		handled++;
 	}
-	spin_lock_irq(&conf->device_lock);
-	remaining = --raid_bio->bi_phys_segments;
-	spin_unlock_irq(&conf->device_lock);
-	if (remaining == 0) {
+	if (atomic_dec_and_test(&raid_bio->bi_iocnt)) {
 
 		raid_bio->bi_end_io(raid_bio,
 			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:20:51.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:20:52.000000000 +1000
@@ -141,6 +141,7 @@ void bio_init(struct bio *bio)
 	bio->bi_max_vecs = 0;
 	bio->bi_end_io = NULL;
 	atomic_set(&bio->bi_cnt, 1);
+	atomic_set(&bio->bi_iocnt, 1);
 	bio->bi_private = NULL;
 }
 
@@ -1013,7 +1014,8 @@ void bio_endio(struct bio *bio, int erro
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 
-	if (bio->bi_end_io)
+	if (atomic_dec_and_test(&bio->bi_iocnt) &&
+	    bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
 

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:20:51.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:20:52.000000000 +1000
@@ -108,6 +108,9 @@ struct bio {
 
 	bio_end_io_t		*bi_end_io;
 	atomic_t		bi_cnt;		/* pin count */
+	atomic_t		bi_iocnt;	/* number of io requests
+						 * referring to this bio
+						 */
 
 	void			*bi_private;
 
