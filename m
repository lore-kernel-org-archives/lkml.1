Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXHPFPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXHPFPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760154AbXHPFNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:13:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:46445 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760079AbXHPFNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:13:51 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 15:13:44 +1000
Message-Id: <1070816051344.31362@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 003 of 5] Replace bio_cur_sectors with blk_rq_cur_sectors.
References: <20070816150445.30843.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


All calls to bio_cur_sectors are for the first bio in a 'struct request'.
A future patch will make the discovery of this number dependant on
information in the request.  So change the function to take a 
'struct request *' instread of a 'struct bio *', and make it a real
function as more code will need to be added.

One place wants the current bytes rather than sectors, so the
'real function' we create is blk_rq_cur_bytes, and 
blk_rq_cur_sectors divides this value by 512.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   18 ++++++++++++------
 ./drivers/ide/ide-cd.c   |   11 ++++++-----
 ./drivers/ide/ide-io.c   |    2 +-
 ./include/linux/bio.h    |    1 -
 ./include/linux/blkdev.h |    5 +++++
 5 files changed, 24 insertions(+), 13 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 15:02:30.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 15:02:30.000000000 +1000
@@ -2904,10 +2904,11 @@ static void init_request_from_bio(struct
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
 	req->hard_nr_sectors = req->nr_sectors = bio_sectors(bio);
-	req->current_nr_sectors = req->hard_cur_sectors = bio_cur_sectors(bio);
+	req->bio = req->biotail = bio;
+	req->current_nr_sectors = req->hard_cur_sectors =
+		blk_rq_cur_sectors(req);
 	req->nr_phys_segments = bio_phys_segments(req->q, bio);
 	req->nr_hw_segments = bio_hw_segments(req->q, bio);
-	req->bio = req->biotail = bio;
 	req->buffer = blk_rq_data(req);	/* see ->buffer comment above */
 	req->ioprio = bio_prio(bio);
 	req->rq_disk = bio->bi_bdev->bd_disk;
@@ -2978,7 +2979,7 @@ static int __make_request(struct request
 			 * not touch req->buffer either...
 			 */
 			req->buffer = blk_rq_data(req);
-			req->current_nr_sectors = bio_cur_sectors(bio);
+			req->current_nr_sectors = blk_rq_cur_sectors(req);
 			req->hard_cur_sectors = req->current_nr_sectors;
 			req->sector = req->hard_sector = bio->bi_sector;
 			req->nr_sectors = req->hard_nr_sectors += nr_sectors;
@@ -3371,7 +3372,7 @@ static void blk_recalc_rq_sectors(struct
 		    (rq->sector <= rq->hard_sector)) {
 			rq->sector = rq->hard_sector;
 			rq->nr_sectors = rq->hard_nr_sectors;
-			rq->hard_cur_sectors = bio_cur_sectors(rq->bio);
+			rq->hard_cur_sectors = blk_rq_cur_sectors(rq);
 			rq->current_nr_sectors = rq->hard_cur_sectors;
 			rq->buffer = blk_rq_data(rq);
 		}
@@ -3675,13 +3676,13 @@ void blk_rq_bio_prep(struct request_queu
 
 	rq->nr_phys_segments = bio_phys_segments(q, bio);
 	rq->nr_hw_segments = bio_hw_segments(q, bio);
-	rq->current_nr_sectors = bio_cur_sectors(bio);
-	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
 	rq->buffer = blk_rq_data(rq);
+	rq->current_nr_sectors = blk_rq_cur_sectors(rq);
+	rq->hard_cur_sectors = rq->current_nr_sectors;
 }
 
 EXPORT_SYMBOL(blk_rq_bio_prep);
@@ -3693,6 +3694,11 @@ void *blk_rq_data(struct request *rq)
 }
 EXPORT_SYMBOL(blk_rq_data);
 
+int blk_rq_cur_bytes(struct request *rq)
+{
+	return bio_iovec(rq->bio)->bv_len;
+}
+EXPORT_SYMBOL(blk_rq_cur_bytes);
 
 int kblockd_schedule_work(struct work_struct *work)
 {

diff .prev/drivers/ide/ide-cd.c ./drivers/ide/ide-cd.c
--- .prev/drivers/ide/ide-cd.c	2007-08-16 15:02:30.000000000 +1000
+++ ./drivers/ide/ide-cd.c	2007-08-16 15:02:30.000000000 +1000
@@ -1173,7 +1173,8 @@ static ide_startstop_t cdrom_read_intr (
 
 	/* First, figure out if we need to bit-bucket
 	   any of the leading sectors. */
-	nskip = min_t(int, rq->current_nr_sectors - bio_cur_sectors(rq->bio), sectors_to_transfer);
+	nskip = min_t(int, rq->current_nr_sectors - blk_rq_cur_sectors(rq),
+		      sectors_to_transfer);
 
 	while (nskip > 0) {
 		/* We need to throw away a sector. */
@@ -1273,7 +1274,7 @@ static int cdrom_read_from_buffer (ide_d
 	   represent the number of sectors to skip at the start of a transfer
 	   will fail.  I think that this will never happen, but let's be
 	   paranoid and check. */
-	if (rq->current_nr_sectors < bio_cur_sectors(rq->bio) &&
+	if (rq->current_nr_sectors < blk_rq_cur_sectors(rq) &&
 	    (rq->sector & (sectors_per_frame - 1))) {
 		printk(KERN_ERR "%s: cdrom_read_from_buffer: buffer botch (%ld)\n",
 			drive->name, (long)rq->sector);
@@ -1308,7 +1309,7 @@ static ide_startstop_t cdrom_start_read_
 	nskip = rq->sector & (sectors_per_frame - 1);
 	if (nskip > 0) {
 		/* Sanity check... */
-		if (rq->current_nr_sectors != bio_cur_sectors(rq->bio) &&
+		if (rq->current_nr_sectors != blk_rq_cur_sectors(rq) &&
 			(rq->sector & (sectors_per_frame - 1))) {
 			printk(KERN_ERR "%s: cdrom_start_read_continuation: buffer botch (%u)\n",
 				drive->name, rq->current_nr_sectors);
@@ -1389,7 +1390,7 @@ static void restore_request (struct requ
 		rq->nr_sectors += n;
 		rq->sector -= n;
 	}
-	rq->hard_cur_sectors = rq->current_nr_sectors = bio_cur_sectors(rq->bio);
+	rq->hard_cur_sectors = rq->current_nr_sectors = blk_rq_cur_sectors(rq);
 	rq->hard_nr_sectors = rq->nr_sectors;
 	rq->hard_sector = rq->sector;
 	rq->q->prep_rq_fn(rq->q, rq);
@@ -1770,7 +1771,7 @@ static ide_startstop_t cdrom_newpc_intr(
 		 */
 		if (rq->bio) {
 			ptr = blk_rq_data(rq);
-			blen = bio_iovec(rq->bio)->bv_len;
+			blen = blk_rq_cur_bytes(rq);
 		}
 
 		if (!ptr) {

diff .prev/drivers/ide/ide-io.c ./drivers/ide/ide-io.c
--- .prev/drivers/ide/ide-io.c	2007-08-16 15:02:30.000000000 +1000
+++ ./drivers/ide/ide-io.c	2007-08-16 15:02:30.000000000 +1000
@@ -1424,7 +1424,7 @@ static ide_startstop_t ide_dma_timeout_r
 		goto out;
 
 	rq->sector = rq->bio->bi_sector;
-	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
+	rq->current_nr_sectors = blk_rq_cur_sectors(rq);
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->buffer = blk_rq_data(rq);
 out:

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-08-16 15:02:30.000000000 +1000
+++ ./include/linux/bio.h	2007-08-16 15:02:30.000000000 +1000
@@ -175,7 +175,6 @@ struct bio {
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_cur_sectors(bio)	(bio_iovec(bio)->bv_len >> 9)
 #define bio_barrier(bio)	((bio)->bi_rw & (1 << BIO_RW_BARRIER))
 #define bio_sync(bio)		((bio)->bi_rw & (1 << BIO_RW_SYNC))
 #define bio_failfast(bio)	((bio)->bi_rw & (1 << BIO_RW_FAILFAST))

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-08-16 15:02:30.000000000 +1000
+++ ./include/linux/blkdev.h	2007-08-16 15:02:30.000000000 +1000
@@ -701,6 +701,11 @@ extern void blk_execute_rq_nowait(struct
 				  struct request *, int, rq_end_io_fn *);
 extern int blk_verify_command(unsigned char *, int);
 extern void *blk_rq_data(struct request *);
+extern int blk_rq_cur_bytes(struct request *);
+static inline int blk_rq_cur_sectors(struct request *rq)
+{
+	return blk_rq_cur_bytes(rq) >> 9;
+}
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
