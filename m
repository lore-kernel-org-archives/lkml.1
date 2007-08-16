Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXHPFOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXHPFOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759707AbXHPFNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:13:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:51253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487AbXHPFNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:13:45 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 15:13:37 +1000
Message-Id: <1070816051337.31344@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 002 of 5] Replace bio_data with blk_rq_data
References: <20070816150445.30843.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Almost every call to bio_data is for the first bio
in a request.  A future patch will add some accounting
information to 'struct request' which will need to be
used to find the start of the request in the bio.
So replace bio_data with blk_rq_data which takes a 'struct request *'

The one exception is in dm-emc were using
   page_address(bio->bi_io_vec[0].bv_page);
is appropriate.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c                  |   16 ++++++++++++----
 ./drivers/block/floppy.c             |    2 +-
 ./drivers/ide/ide-cd.c               |   11 ++++++-----
 ./drivers/ide/ide-io.c               |    2 +-
 ./drivers/md/dm-emc.c                |    2 +-
 ./drivers/message/fusion/mptsas.c    |    4 ++--
 ./drivers/scsi/libsas/sas_expander.c |    4 ++--
 ./include/linux/bio.h                |    4 +---
 ./include/linux/blkdev.h             |    1 +
 9 files changed, 27 insertions(+), 19 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 15:02:29.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 15:02:30.000000000 +1000
@@ -2907,8 +2907,8 @@ static void init_request_from_bio(struct
 	req->current_nr_sectors = req->hard_cur_sectors = bio_cur_sectors(bio);
 	req->nr_phys_segments = bio_phys_segments(req->q, bio);
 	req->nr_hw_segments = bio_hw_segments(req->q, bio);
-	req->buffer = bio_data(bio);	/* see ->buffer comment above */
 	req->bio = req->biotail = bio;
+	req->buffer = blk_rq_data(req);	/* see ->buffer comment above */
 	req->ioprio = bio_prio(bio);
 	req->rq_disk = bio->bi_bdev->bd_disk;
 	req->start_time = jiffies;
@@ -2977,7 +2977,7 @@ static int __make_request(struct request
 			 * it didn't need a bounce buffer then it better
 			 * not touch req->buffer either...
 			 */
-			req->buffer = bio_data(bio);
+			req->buffer = blk_rq_data(req);
 			req->current_nr_sectors = bio_cur_sectors(bio);
 			req->hard_cur_sectors = req->current_nr_sectors;
 			req->sector = req->hard_sector = bio->bi_sector;
@@ -3373,7 +3373,7 @@ static void blk_recalc_rq_sectors(struct
 			rq->nr_sectors = rq->hard_nr_sectors;
 			rq->hard_cur_sectors = bio_cur_sectors(rq->bio);
 			rq->current_nr_sectors = rq->hard_cur_sectors;
-			rq->buffer = bio_data(rq->bio);
+			rq->buffer = blk_rq_data(rq);
 		}
 
 		/*
@@ -3678,14 +3678,22 @@ void blk_rq_bio_prep(struct request_queu
 	rq->current_nr_sectors = bio_cur_sectors(bio);
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
-	rq->buffer = bio_data(bio);
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
+	rq->buffer = blk_rq_data(rq);
 }
 
 EXPORT_SYMBOL(blk_rq_bio_prep);
 
+void *blk_rq_data(struct request *rq)
+{
+	return page_address(bio_page(rq->bio)) +
+		bio_offset(rq->bio);
+}
+EXPORT_SYMBOL(blk_rq_data);
+
+
 int kblockd_schedule_work(struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);

diff .prev/drivers/block/floppy.c ./drivers/block/floppy.c
--- .prev/drivers/block/floppy.c	2007-08-16 14:57:31.000000000 +1000
+++ ./drivers/block/floppy.c	2007-08-16 15:02:30.000000000 +1000
@@ -2456,7 +2456,7 @@ static int buffer_chain_size(void)
 	int i;
 	char *base;
 
-	base = bio_data(current_req->bio);
+	base = blk_rq_data(current_req);
 	size = 0;
 
 	rq_for_each_bio(bio, current_req) {

diff .prev/drivers/ide/ide-cd.c ./drivers/ide/ide-cd.c
--- .prev/drivers/ide/ide-cd.c	2007-08-16 14:57:31.000000000 +1000
+++ ./drivers/ide/ide-cd.c	2007-08-16 15:02:30.000000000 +1000
@@ -1381,10 +1381,11 @@ static ide_startstop_t cdrom_start_seek 
    start it over entirely, or even put it back on the request queue. */
 static void restore_request (struct request *rq)
 {
-	if (rq->buffer != bio_data(rq->bio)) {
-		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) / SECTOR_SIZE;
+	if (rq->buffer != blk_rq_data(rq)) {
+		sector_t n = (rq->buffer - (char *)blk_rq_data(rq))
+			/ SECTOR_SIZE;
 
-		rq->buffer = bio_data(rq->bio);
+		rq->buffer = blk_rq_data(rq);
 		rq->nr_sectors += n;
 		rq->sector -= n;
 	}
@@ -1659,7 +1660,7 @@ static void post_transform_command(struc
 		return;
 
 	if (req->bio)
-		ibuf = bio_data(req->bio);
+		ibuf = blk_rq_data(req);
 	else
 		ibuf = req->data;
 
@@ -1768,7 +1769,7 @@ static ide_startstop_t cdrom_newpc_intr(
 		 * bio backed?
 		 */
 		if (rq->bio) {
-			ptr = bio_data(rq->bio);
+			ptr = blk_rq_data(rq);
 			blen = bio_iovec(rq->bio)->bv_len;
 		}
 

diff .prev/drivers/ide/ide-io.c ./drivers/ide/ide-io.c
--- .prev/drivers/ide/ide-io.c	2007-08-16 14:57:31.000000000 +1000
+++ ./drivers/ide/ide-io.c	2007-08-16 15:02:30.000000000 +1000
@@ -1426,7 +1426,7 @@ static ide_startstop_t ide_dma_timeout_r
 	rq->sector = rq->bio->bi_sector;
 	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
 	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->buffer = bio_data(rq->bio);
+	rq->buffer = blk_rq_data(rq);
 out:
 	return ret;
 }

diff .prev/drivers/md/dm-emc.c ./drivers/md/dm-emc.c
--- .prev/drivers/md/dm-emc.c	2007-08-16 14:57:31.000000000 +1000
+++ ./drivers/md/dm-emc.c	2007-08-16 15:02:30.000000000 +1000
@@ -167,7 +167,7 @@ static struct request *emc_trespass_get(
 		return NULL;
 	}
 
-	page22 = (unsigned char *)bio_data(bio);
+	page22 = (unsigned char *)page_address(bio->bi_io_vec[0].bv_page);
 	memset(page22, 0, data_size);
 
 	memcpy(page22, h->short_trespass ?

diff .prev/drivers/message/fusion/mptsas.c ./drivers/message/fusion/mptsas.c
--- .prev/drivers/message/fusion/mptsas.c	2007-08-16 14:57:31.000000000 +1000
+++ ./drivers/message/fusion/mptsas.c	2007-08-16 15:02:30.000000000 +1000
@@ -1382,7 +1382,7 @@ static int mptsas_smp_handler(struct Scs
 		       mpt_addr_size()) << MPI_SGE_FLAGS_SHIFT;
 	flagsLength |= (req->data_len - 4);
 
-	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
+	dma_addr_out = pci_map_single(ioc->pcidev, blk_rq_data(req),
 				      req->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_out)
 		goto put_mf;
@@ -1392,7 +1392,7 @@ static int mptsas_smp_handler(struct Scs
 	/* response */
 	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
 	flagsLength |= rsp->data_len + 4;
-	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
+	dma_addr_in =  pci_map_single(ioc->pcidev, blk_rq_data(rsp),
 				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_in)
 		goto unmap;

diff .prev/drivers/scsi/libsas/sas_expander.c ./drivers/scsi/libsas/sas_expander.c
--- .prev/drivers/scsi/libsas/sas_expander.c	2007-08-16 14:57:31.000000000 +1000
+++ ./drivers/scsi/libsas/sas_expander.c	2007-08-16 15:02:30.000000000 +1000
@@ -1924,8 +1924,8 @@ int sas_smp_handler(struct Scsi_Host *sh
 		return -EINVAL;
 	}
 
-	ret = smp_execute_task(dev, bio_data(req->bio), req->data_len,
-			       bio_data(rsp->bio), rsp->data_len);
+	ret = smp_execute_task(dev, blk_rq_data(req), req->data_len,
+			       blk_rq_data(rsp), rsp->data_len);
 
 	return ret;
 }

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-08-16 14:57:31.000000000 +1000
+++ ./include/linux/bio.h	2007-08-16 15:02:30.000000000 +1000
@@ -167,8 +167,7 @@ struct bio {
 } while (0)
 
 /*
- * various member access, note that bio_data should of course not be used
- * on highmem page vectors
+ * various member access
  */
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
 #define bio_iovec(bio)		bio_iovec_idx((bio), (bio)->bi_idx)
@@ -177,7 +176,6 @@ struct bio {
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 #define bio_cur_sectors(bio)	(bio_iovec(bio)->bv_len >> 9)
-#define bio_data(bio)		(page_address(bio_page((bio))) + bio_offset((bio)))
 #define bio_barrier(bio)	((bio)->bi_rw & (1 << BIO_RW_BARRIER))
 #define bio_sync(bio)		((bio)->bi_rw & (1 << BIO_RW_SYNC))
 #define bio_failfast(bio)	((bio)->bi_rw & (1 << BIO_RW_FAILFAST))

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-08-16 14:57:31.000000000 +1000
+++ ./include/linux/blkdev.h	2007-08-16 15:02:30.000000000 +1000
@@ -700,6 +700,7 @@ extern int blk_execute_rq(struct request
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 extern int blk_verify_command(unsigned char *, int);
+extern void *blk_rq_data(struct request *);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
