Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbXI0HVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbXI0HVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbXI0HUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:20:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:60414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbXI0HUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:20:36 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 27 Sep 2007 17:20:24 +1000
Message-Id: <1070927072024.4225@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 004 of 4] Drop 'size' argument from bio_endio and bi_end_io.
References: <20070927171111.3251.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As bi_end_io is only called once when the reqeust is complete,
the 'size' argument is now redundant.  Remove it.

Now there is no need for bio_endio to subtract the size completed
from bi_size.  So don't do that either.

While we are at it, change bi_end_io to return void.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c            |   10 ++++----
 ./drivers/block/aoe/aoeblk.c   |    4 +--
 ./drivers/block/aoe/aoecmd.c   |    2 -
 ./drivers/block/aoe/aoedev.c   |    4 +--
 ./drivers/block/cciss.c        |    2 -
 ./drivers/block/cpqarray.c     |    2 -
 ./drivers/block/floppy.c       |    6 -----
 ./drivers/block/loop.c         |    4 +--
 ./drivers/block/pktcdvd.c      |   25 +++++----------------
 ./drivers/block/rd.c           |    4 +--
 ./drivers/block/umem.c         |    2 -
 ./drivers/md/dm-crypt.c        |   21 +++++------------
 ./drivers/md/dm-emc.c          |    5 ----
 ./drivers/md/dm-io.c           |    8 ------
 ./drivers/md/dm-mpath.c        |    4 +--
 ./drivers/md/dm-raid1.c        |    4 +--
 ./drivers/md/dm-snap.c         |    2 -
 ./drivers/md/dm-zero.c         |    2 -
 ./drivers/md/dm.c              |   18 +++++----------
 ./drivers/md/faulty.c          |   10 +++-----
 ./drivers/md/linear.c          |    4 +--
 ./drivers/md/md.c              |   25 ++++++---------------
 ./drivers/md/multipath.c       |   13 +++--------
 ./drivers/md/raid0.c           |    4 +--
 ./drivers/md/raid1.c           |   30 +++++--------------------
 ./drivers/md/raid10.c          |   31 ++++++--------------------
 ./drivers/md/raid5.c           |   48 +++++++++++++----------------------------
 ./drivers/s390/block/dcssblk.c |    4 +--
 ./drivers/s390/block/xpram.c   |    6 +----
 ./drivers/scsi/scsi_lib.c      |   10 ++------
 ./fs/bio.c                     |   35 +++++------------------------
 ./fs/block_dev.c               |    2 -
 ./fs/buffer.c                  |    6 -----
 ./fs/direct-io.c               |   13 +----------
 ./fs/gfs2/super.c              |    4 ---
 ./fs/jfs/jfs_logmgr.c          |    5 ----
 ./fs/jfs/jfs_metapage.c        |   12 +---------
 ./fs/mpage.c                   |   12 +---------
 ./fs/ocfs2/cluster/heartbeat.c |    4 ---
 ./fs/xfs/linux-2.6/xfs_aops.c  |    4 ---
 ./fs/xfs/linux-2.6/xfs_buf.c   |    4 ---
 ./include/linux/bio.h          |    6 ++---
 ./include/linux/swap.h         |    2 -
 ./mm/bounce.c                  |   25 ++++-----------------
 ./mm/page_io.c                 |   12 +---------
 45 files changed, 132 insertions(+), 328 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-09-27 17:07:59.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-09-27 16:50:20.000000000 +1000
@@ -544,7 +544,7 @@ static void req_bio_endio(struct request
 		bio->bi_size -= nbytes;
 		bio->bi_sector += (nbytes >> 9);
 		if (bio->bi_size == 0)
-			bio_endio(bio, bio->bi_size, error);
+			bio_endio(bio, error);
 	} else {
 
 		/*
@@ -2372,7 +2372,7 @@ static int __blk_rq_map_user(struct requ
 
 unmap_bio:
 	/* if it was boucned we must call the end io function */
-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, 0);
 	__blk_rq_unmap_user(orig_bio);
 	bio_put(bio);
 	return ret;
@@ -2481,7 +2481,7 @@ int blk_rq_map_user_iov(struct request_q
 		return PTR_ERR(bio);
 
 	if (bio->bi_size != len) {
-		bio_endio(bio, bio->bi_size, 0);
+		bio_endio(bio, 0);
 		bio_unmap_user(bio);
 		return -EINVAL;
 	}
@@ -3017,7 +3017,7 @@ out:
 	return 0;
 
 end_io:
-	bio_endio(bio, nr_sectors << 9, err);
+	bio_endio(bio, err);
 	return 0;
 }
 
@@ -3164,7 +3164,7 @@ static inline void __generic_make_reques
 				bdevname(bio->bi_bdev, b),
 				(long long) bio->bi_sector);
 end_io:
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, -EIO);
 			break;
 		}
 

diff .prev/drivers/block/aoe/aoeblk.c ./drivers/block/aoe/aoeblk.c
--- .prev/drivers/block/aoe/aoeblk.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/aoe/aoeblk.c	2007-09-27 16:51:34.000000000 +1000
@@ -138,7 +138,7 @@ aoeblk_make_request(struct request_queue
 	buf = mempool_alloc(d->bufpool, GFP_NOIO);
 	if (buf == NULL) {
 		printk(KERN_INFO "aoe: buf allocation failure\n");
-		bio_endio(bio, bio->bi_size, -ENOMEM);
+		bio_endio(bio, -ENOMEM);
 		return 0;
 	}
 	memset(buf, 0, sizeof(*buf));
@@ -159,7 +159,7 @@ aoeblk_make_request(struct request_queue
 			d->aoemajor, d->aoeminor);
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
-		bio_endio(bio, bio->bi_size, -ENXIO);
+		bio_endio(bio, -ENXIO);
 		return 0;
 	}
 

diff .prev/drivers/block/aoe/aoecmd.c ./drivers/block/aoe/aoecmd.c
--- .prev/drivers/block/aoe/aoecmd.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/aoe/aoecmd.c	2007-09-27 16:51:02.000000000 +1000
@@ -652,7 +652,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			disk_stat_add(disk, sectors[rw], n_sect);
 			disk_stat_add(disk, io_ticks, duration);
 			n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
-			bio_endio(buf->bio, buf->bio->bi_size, n);
+			bio_endio(buf->bio, n);
 			mempool_free(buf, d->bufpool);
 		}
 	}

diff .prev/drivers/block/aoe/aoedev.c ./drivers/block/aoe/aoedev.c
--- .prev/drivers/block/aoe/aoedev.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/aoe/aoedev.c	2007-09-27 16:44:54.000000000 +1000
@@ -119,7 +119,7 @@ aoedev_downdev(struct aoedev *d)
 		bio = buf->bio;
 		if (--buf->nframesout == 0) {
 			mempool_free(buf, d->bufpool);
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, -EIO);
 		}
 		skb_shinfo(f->skb)->nr_frags = f->skb->data_len = 0;
 	}
@@ -130,7 +130,7 @@ aoedev_downdev(struct aoedev *d)
 		list_del(d->bufq.next);
 		bio = buf->bio;
 		mempool_free(buf, d->bufpool);
-		bio_endio(bio, bio->bi_size, -EIO);
+		bio_endio(bio, -EIO);
 	}
 
 	if (d->gd)

diff .prev/drivers/block/cciss.c ./drivers/block/cciss.c
--- .prev/drivers/block/cciss.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/cciss.c	2007-09-27 16:44:54.000000000 +1000
@@ -1194,7 +1194,7 @@ static inline void complete_buffers(stru
 		int nr_sectors = bio_sectors(bio);
 
 		bio->bi_next = NULL;
-		bio_endio(bio, nr_sectors << 9, status ? 0 : -EIO);
+		bio_endio(bio, status ? 0 : -EIO);
 		bio = xbh;
 	}
 }

diff .prev/drivers/block/cpqarray.c ./drivers/block/cpqarray.c
--- .prev/drivers/block/cpqarray.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/cpqarray.c	2007-09-27 16:44:54.000000000 +1000
@@ -987,7 +987,7 @@ static inline void complete_buffers(stru
 		xbh = bio->bi_next;
 		bio->bi_next = NULL;
 		
-		bio_endio(bio, nr_sectors << 9, ok ? 0 : -EIO);
+		bio_endio(bio, ok ? 0 : -EIO);
 
 		bio = xbh;
 	}

diff .prev/drivers/block/floppy.c ./drivers/block/floppy.c
--- .prev/drivers/block/floppy.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/floppy.c	2007-09-27 16:44:54.000000000 +1000
@@ -3815,14 +3815,10 @@ static int check_floppy_change(struct ge
  * a disk in the drive, and whether that disk is writable.
  */
 
-static int floppy_rb0_complete(struct bio *bio, unsigned int bytes_done,
+static void floppy_rb0_complete(struct bio *bio,
 			       int err)
 {
-	if (bio->bi_size)
-		return 1;
-
 	complete((struct completion *)bio->bi_private);
-	return 0;
 }
 
 static int __floppy_read_block_0(struct block_device *bdev)

diff .prev/drivers/block/loop.c ./drivers/block/loop.c
--- .prev/drivers/block/loop.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/loop.c	2007-09-27 16:44:54.000000000 +1000
@@ -551,7 +551,7 @@ static int loop_make_request(struct requ
 
 out:
 	spin_unlock_irq(&lo->lo_lock);
-	bio_io_error(old_bio, old_bio->bi_size);
+	bio_io_error(old_bio);
 	return 0;
 }
 
@@ -580,7 +580,7 @@ static inline void loop_handle_bio(struc
 		bio_put(bio);
 	} else {
 		int ret = do_bio_filebacked(lo, bio);
-		bio_endio(bio, bio->bi_size, ret);
+		bio_endio(bio, ret);
 	}
 }
 

diff .prev/drivers/block/pktcdvd.c ./drivers/block/pktcdvd.c
--- .prev/drivers/block/pktcdvd.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/pktcdvd.c	2007-09-27 16:44:54.000000000 +1000
@@ -1058,15 +1058,12 @@ static void pkt_make_local_copy(struct p
 	}
 }
 
-static int pkt_end_io_read(struct bio *bio, unsigned int bytes_done, int err)
+static void pkt_end_io_read(struct bio *bio, int err)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	if (bio->bi_size)
-		return 1;
-
 	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
 		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
 
@@ -1077,19 +1074,14 @@ static int pkt_end_io_read(struct bio *b
 		wake_up(&pd->wqueue);
 	}
 	pkt_bio_finished(pd);
-
-	return 0;
 }
 
-static int pkt_end_io_packet_write(struct bio *bio, unsigned int bytes_done, int err)
+static void pkt_end_io_packet_write(struct bio *bio, int err)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	if (bio->bi_size)
-		return 1;
-
 	VPRINTK("pkt_end_io_packet_write: id=%d, err=%d\n", pkt->id, err);
 
 	pd->stats.pkt_ended++;
@@ -1098,7 +1090,6 @@ static int pkt_end_io_packet_write(struc
 	atomic_dec(&pkt->io_wait);
 	atomic_inc(&pkt->run_sm);
 	wake_up(&pd->wqueue);
-	return 0;
 }
 
 /*
@@ -1470,7 +1461,7 @@ static void pkt_finish_packet(struct pac
 	while (bio) {
 		next = bio->bi_next;
 		bio->bi_next = NULL;
-		bio_endio(bio, bio->bi_size, uptodate ? 0 : -EIO);
+		bio_endio(bio, uptodate ? 0 : -EIO);
 		bio = next;
 	}
 	pkt->orig_bios = pkt->orig_bios_tail = NULL;
@@ -2462,19 +2453,15 @@ static int pkt_close(struct inode *inode
 }
 
 
-static int pkt_end_io_read_cloned(struct bio *bio, unsigned int bytes_done, int err)
+static void pkt_end_io_read_cloned(struct bio *bio, int err)
 {
 	struct packet_stacked_data *psd = bio->bi_private;
 	struct pktcdvd_device *pd = psd->pd;
 
-	if (bio->bi_size)
-		return 1;
-
 	bio_put(bio);
-	bio_endio(psd->bio, psd->bio->bi_size, err);
+	bio_endio(psd->bio, err);
 	mempool_free(psd, psd_pool);
 	pkt_bio_finished(pd);
-	return 0;
 }
 
 static int pkt_make_request(struct request_queue *q, struct bio *bio)
@@ -2620,7 +2607,7 @@ static int pkt_make_request(struct reque
 	}
 	return 0;
 end_io:
-	bio_io_error(bio, bio->bi_size);
+	bio_io_error(bio);
 	return 0;
 }
 

diff .prev/drivers/block/rd.c ./drivers/block/rd.c
--- .prev/drivers/block/rd.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/rd.c	2007-09-27 16:44:54.000000000 +1000
@@ -287,10 +287,10 @@ static int rd_make_request(struct reques
 	if (ret)
 		goto fail;
 
-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, 0);
 	return 0;
 fail:
-	bio_io_error(bio, bio->bi_size);
+	bio_io_error(bio);
 	return 0;
 } 
 

diff .prev/drivers/block/umem.c ./drivers/block/umem.c
--- .prev/drivers/block/umem.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/block/umem.c	2007-09-27 16:44:54.000000000 +1000
@@ -532,7 +532,7 @@ static void process_page(unsigned long d
 
 		return_bio = bio->bi_next;
 		bio->bi_next = NULL;
-		bio_endio(bio, bio->bi_size, 0);
+		bio_endio(bio, 0);
 	}
 }
 

diff .prev/drivers/md/dm.c ./drivers/md/dm.c
--- .prev/drivers/md/dm.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm.c	2007-09-27 16:44:54.000000000 +1000
@@ -484,23 +484,20 @@ static void dec_pending(struct dm_io *io
 			blk_add_trace_bio(io->md->queue, io->bio,
 					  BLK_TA_COMPLETE);
 
-			bio_endio(io->bio, io->bio->bi_size, io->error);
+			bio_endio(io->bio, io->error);
 		}
 
 		free_io(io->md, io);
 	}
 }
 
-static int clone_endio(struct bio *bio, unsigned int done, int error)
+static void clone_endio(struct bio *bio, int error)
 {
 	int r = 0;
 	struct dm_target_io *tio = bio->bi_private;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
-	if (bio->bi_size)
-		return 1;
-
 	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
 		error = -EIO;
 
@@ -514,7 +511,7 @@ static int clone_endio(struct bio *bio, 
 			error = r;
 		else if (r == DM_ENDIO_INCOMPLETE)
 			/* The target will handle the io */
-			return 1;
+			return;
 		else if (r) {
 			DMWARN("unimplemented target endio return value: %d", r);
 			BUG();
@@ -530,7 +527,6 @@ static int clone_endio(struct bio *bio, 
 
 	bio_put(bio);
 	free_tio(md, tio);
-	return r;
 }
 
 static sector_t max_io_len(struct mapped_device *md,
@@ -761,7 +757,7 @@ static void __split_bio(struct mapped_de
 
 	ci.map = dm_get_table(md);
 	if (!ci.map) {
-		bio_io_error(bio, bio->bi_size);
+		bio_io_error(bio);
 		return;
 	}
 
@@ -803,7 +799,7 @@ static int dm_request(struct request_que
 	 * guarantee it is (or can be) handled by the targets correctly.
 	 */
 	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
@@ -820,13 +816,13 @@ static int dm_request(struct request_que
 		up_read(&md->io_lock);
 
 		if (bio_rw(bio) == READA) {
-			bio_io_error(bio, bio->bi_size);
+			bio_io_error(bio);
 			return 0;
 		}
 
 		r = queue_io(md, bio);
 		if (r < 0) {
-			bio_io_error(bio, bio->bi_size);
+			bio_io_error(bio);
 			return 0;
 
 		} else if (r == 0)

diff .prev/drivers/md/dm-crypt.c ./drivers/md/dm-crypt.c
--- .prev/drivers/md/dm-crypt.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm-crypt.c	2007-09-27 16:44:54.000000000 +1000
@@ -489,7 +489,7 @@ static void dec_pending(struct dm_crypt_
 	if (!atomic_dec_and_test(&io->pending))
 		return;
 
-	bio_endio(io->base_bio, io->base_bio->bi_size, io->error);
+	bio_endio(io->base_bio, io->error);
 
 	mempool_free(io, cc->io_pool);
 }
@@ -509,25 +509,19 @@ static void kcryptd_queue_io(struct dm_c
 	queue_work(_kcryptd_workqueue, &io->work);
 }
 
-static int crypt_endio(struct bio *clone, unsigned int done, int error)
+static void crypt_endio(struct bio *clone, int error)
 {
 	struct dm_crypt_io *io = clone->bi_private;
 	struct crypt_config *cc = io->target->private;
 	unsigned read_io = bio_data_dir(clone) == READ;
 
 	/*
-	 * free the processed pages, even if
-	 * it's only a partially completed write
+	 * free the processed pages
 	 */
-	if (!read_io)
-		crypt_free_buffer_pages(cc, clone, done);
-
-	/* keep going - not finished yet */
-	if (unlikely(clone->bi_size))
-		return 1;
-
-	if (!read_io)
+	if (!read_io) {
+		crypt_free_buffer_pages(cc, clone, clone->bi_size);
 		goto out;
+	}
 
 	if (unlikely(!bio_flagged(clone, BIO_UPTODATE))) {
 		error = -EIO;
@@ -537,12 +531,11 @@ static int crypt_endio(struct bio *clone
 	bio_put(clone);
 	io->post_process = 1;
 	kcryptd_queue_io(io);
-	return 0;
+	return;
 
 out:
 	bio_put(clone);
 	dec_pending(io, error);
-	return error;
 }
 
 static void clone_init(struct dm_crypt_io *io, struct bio *clone)

diff .prev/drivers/md/dm-emc.c ./drivers/md/dm-emc.c
--- .prev/drivers/md/dm-emc.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm-emc.c	2007-09-27 16:44:54.000000000 +1000
@@ -38,13 +38,10 @@ static inline void free_bio(struct bio *
 	bio_put(bio);
 }
 
-static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
+static void emc_endio(struct bio *bio, int error)
 {
 	struct dm_path *path = bio->bi_private;
 
-	if (bio->bi_size)
-		return 1;
-
 	/* We also need to look at the sense keys here whether or not to
 	 * switch to the next PG etc.
 	 *

diff .prev/drivers/md/dm-io.c ./drivers/md/dm-io.c
--- .prev/drivers/md/dm-io.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm-io.c	2007-09-27 16:44:54.000000000 +1000
@@ -124,15 +124,11 @@ static void dec_count(struct io *io, uns
 	}
 }
 
-static int endio(struct bio *bio, unsigned int done, int error)
+static void endio(struct bio *bio, int error)
 {
 	struct io *io;
 	unsigned region;
 
-	/* keep going until we've finished */
-	if (bio->bi_size)
-		return 1;
-
 	if (error && bio_data_dir(bio) == READ)
 		zero_fill_bio(bio);
 
@@ -146,8 +142,6 @@ static int endio(struct bio *bio, unsign
 	bio_put(bio);
 
 	dec_count(io, region, error);
-
-	return 0;
 }
 
 /*-----------------------------------------------------------------

diff .prev/drivers/md/dm-mpath.c ./drivers/md/dm-mpath.c
--- .prev/drivers/md/dm-mpath.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm-mpath.c	2007-09-27 16:44:54.000000000 +1000
@@ -390,11 +390,11 @@ static void dispatch_queued_ios(struct m
 
 		r = map_io(m, bio, mpio, 1);
 		if (r < 0)
-			bio_endio(bio, bio->bi_size, r);
+			bio_endio(bio, r);
 		else if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
 		else if (r == DM_MAPIO_REQUEUE)
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, -EIO);
 
 		bio = next;
 	}

diff .prev/drivers/md/dm-raid1.c ./drivers/md/dm-raid1.c
--- .prev/drivers/md/dm-raid1.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm-raid1.c	2007-09-27 16:44:54.000000000 +1000
@@ -820,7 +820,7 @@ static void write_callback(unsigned long
 				break;
 			}
 	}
-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, 0);
 }
 
 static void do_write(struct mirror_set *ms, struct bio *bio)
@@ -900,7 +900,7 @@ static void do_writes(struct mirror_set 
 	 */
 	if (unlikely(ms->log_failure))
 		while ((bio = bio_list_pop(&sync)))
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, -EIO);
 	else while ((bio = bio_list_pop(&sync)))
 		do_write(ms, bio);
 

diff .prev/drivers/md/dm-snap.c ./drivers/md/dm-snap.c
--- .prev/drivers/md/dm-snap.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm-snap.c	2007-09-27 16:44:54.000000000 +1000
@@ -636,7 +636,7 @@ static void error_bios(struct bio *bio)
 	while (bio) {
 		n = bio->bi_next;
 		bio->bi_next = NULL;
-		bio_io_error(bio, bio->bi_size);
+		bio_io_error(bio);
 		bio = n;
 	}
 }

diff .prev/drivers/md/dm-zero.c ./drivers/md/dm-zero.c
--- .prev/drivers/md/dm-zero.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/dm-zero.c	2007-09-27 16:44:54.000000000 +1000
@@ -43,7 +43,7 @@ static int zero_map(struct dm_target *ti
 		break;
 	}
 
-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, 0);
 
 	/* accepted bio, don't make new request */
 	return DM_MAPIO_SUBMITTED;

diff .prev/drivers/md/faulty.c ./drivers/md/faulty.c
--- .prev/drivers/md/faulty.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/faulty.c	2007-09-27 16:44:54.000000000 +1000
@@ -65,18 +65,16 @@
 #include <linux/raid/md.h>
 
 
-static int faulty_fail(struct bio *bio, unsigned int bytes_done, int error)
+static void faulty_fail(struct bio *bio, int error)
 {
 	struct bio *b = bio->bi_private;
 
 	b->bi_size = bio->bi_size;
 	b->bi_sector = bio->bi_sector;
 
-	if (bio->bi_size == 0)
-		bio_put(bio);
+	bio_put(bio);
 
-	clear_bit(BIO_UPTODATE, &b->bi_flags);
-	return (b->bi_end_io)(b, bytes_done, -EIO);
+	bio_io_error(b);
 }
 
 typedef struct faulty_conf {
@@ -179,7 +177,7 @@ static int make_request(struct request_q
 			/* special case - don't decrement, don't generic_make_request,
 			 * just fail immediately
 			 */
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, -EIO);
 			return 0;
 		}
 

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/linear.c	2007-09-27 16:44:54.000000000 +1000
@@ -338,7 +338,7 @@ static int linear_make_request (struct r
 	sector_t block;
 
 	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
@@ -358,7 +358,7 @@ static int linear_make_request (struct r
 			bdevname(tmp_dev->rdev->bdev, b),
 			(unsigned long long)tmp_dev->size,
 		        (unsigned long long)tmp_dev->offset);
-		bio_io_error(bio, bio->bi_size);
+		bio_io_error(bio);
 		return 0;
 	}
 	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/md.c	2007-09-27 16:44:54.000000000 +1000
@@ -213,7 +213,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
 
 static int md_fail_request (struct request_queue *q, struct bio *bio)
 {
-	bio_io_error(bio, bio->bi_size);
+	bio_io_error(bio);
 	return 0;
 }
 
@@ -384,12 +384,10 @@ static void free_disk_sb(mdk_rdev_t * rd
 }
 
 
-static int super_written(struct bio *bio, unsigned int bytes_done, int error)
+static void super_written(struct bio *bio, int error)
 {
 	mdk_rdev_t *rdev = bio->bi_private;
 	mddev_t *mddev = rdev->mddev;
-	if (bio->bi_size)
-		return 1;
 
 	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		printk("md: super_written gets error=%d, uptodate=%d\n",
@@ -401,16 +399,13 @@ static int super_written(struct bio *bio
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
 	bio_put(bio);
-	return 0;
 }
 
-static int super_written_barrier(struct bio *bio, unsigned int bytes_done, int error)
+static void super_written_barrier(struct bio *bio, int error)
 {
 	struct bio *bio2 = bio->bi_private;
 	mdk_rdev_t *rdev = bio2->bi_private;
 	mddev_t *mddev = rdev->mddev;
-	if (bio->bi_size)
-		return 1;
 
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
 	    error == -EOPNOTSUPP) {
@@ -424,11 +419,11 @@ static int super_written_barrier(struct 
 		spin_unlock_irqrestore(&mddev->write_lock, flags);
 		wake_up(&mddev->sb_wait);
 		bio_put(bio);
-		return 0;
+	} else {
+		bio_put(bio2);
+		bio->bi_private = rdev;
+		super_written(bio, error);
 	}
-	bio_put(bio2);
-	bio->bi_private = rdev;
-	return super_written(bio, bytes_done, error);
 }
 
 void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
@@ -489,13 +484,9 @@ void md_super_wait(mddev_t *mddev)
 	finish_wait(&mddev->sb_wait, &wq);
 }
 
-static int bi_complete(struct bio *bio, unsigned int bytes_done, int error)
+static void bi_complete(struct bio *bio, int error)
 {
-	if (bio->bi_size)
-		return 1;
-
 	complete((struct completion*)bio->bi_private);
-	return 0;
 }
 
 int sync_page_io(struct block_device *bdev, sector_t sector, int size,

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/multipath.c	2007-09-27 16:44:54.000000000 +1000
@@ -82,21 +82,17 @@ static void multipath_end_bh_io (struct 
 	struct bio *bio = mp_bh->master_bio;
 	multipath_conf_t *conf = mddev_to_conf(mp_bh->mddev);
 
-	bio_endio(bio, bio->bi_size, err);
+	bio_endio(bio, err);
 	mempool_free(mp_bh, conf->pool);
 }
 
-static int multipath_end_request(struct bio *bio, unsigned int bytes_done,
-				 int error)
+static void multipath_end_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh * mp_bh = (struct multipath_bh *)(bio->bi_private);
 	multipath_conf_t *conf = mddev_to_conf(mp_bh->mddev);
 	mdk_rdev_t *rdev = conf->multipaths[mp_bh->path].rdev;
 
-	if (bio->bi_size)
-		return 1;
-
 	if (uptodate)
 		multipath_end_bh_io(mp_bh, 0);
 	else if (!bio_rw_ahead(bio)) {
@@ -112,7 +108,6 @@ static int multipath_end_request(struct 
 	} else
 		multipath_end_bh_io(mp_bh, error);
 	rdev_dec_pending(rdev, conf->mddev);
-	return 0;
 }
 
 static void unplug_slaves(mddev_t *mddev)
@@ -155,7 +150,7 @@ static int multipath_make_request (struc
 	const int rw = bio_data_dir(bio);
 
 	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
@@ -169,7 +164,7 @@ static int multipath_make_request (struc
 
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
-		bio_endio(bio, bio->bi_size, -EIO);
+		bio_endio(bio, -EIO);
 		mempool_free(mp_bh, conf->pool);
 		return 0;
 	}

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/raid0.c	2007-09-27 16:44:54.000000000 +1000
@@ -420,7 +420,7 @@ static int raid0_make_request (struct re
 	const int rw = bio_data_dir(bio);
 
 	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
@@ -490,7 +490,7 @@ bad_map:
 		" or bigger than %dk %llu %d\n", chunk_size, 
 		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 
-	bio_io_error(bio, bio->bi_size);
+	bio_io_error(bio);
 	return 0;
 }
 			   

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/raid10.c	2007-09-27 16:44:54.000000000 +1000
@@ -227,7 +227,7 @@ static void raid_end_bio_io(r10bio_t *r1
 {
 	struct bio *bio = r10_bio->master_bio;
 
-	bio_endio(bio, bio->bi_size,
+	bio_endio(bio,
 		test_bit(R10BIO_Uptodate, &r10_bio->state) ? 0 : -EIO);
 	free_r10bio(r10_bio);
 }
@@ -243,15 +243,13 @@ static inline void update_head_pos(int s
 		r10_bio->devs[slot].addr + (r10_bio->sectors);
 }
 
-static int raid10_end_read_request(struct bio *bio, unsigned int bytes_done, int error)
+static void raid10_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
 	int slot, dev;
 	conf_t *conf = mddev_to_conf(r10_bio->mddev);
 
-	if (bio->bi_size)
-		return 1;
 
 	slot = r10_bio->read_slot;
 	dev = r10_bio->devs[slot].devnum;
@@ -284,19 +282,15 @@ static int raid10_end_read_request(struc
 	}
 
 	rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
-	return 0;
 }
 
-static int raid10_end_write_request(struct bio *bio, unsigned int bytes_done, int error)
+static void raid10_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
 	int slot, dev;
 	conf_t *conf = mddev_to_conf(r10_bio->mddev);
 
-	if (bio->bi_size)
-		return 1;
-
 	for (slot = 0; slot < conf->copies; slot++)
 		if (r10_bio->devs[slot].bio == bio)
 			break;
@@ -339,7 +333,6 @@ static int raid10_end_write_request(stru
 	}
 
 	rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
-	return 0;
 }
 
 
@@ -787,7 +780,7 @@ static int make_request(struct request_q
 	unsigned long flags;
 
 	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
@@ -819,7 +812,7 @@ static int make_request(struct request_q
 		       " or bigger than %dk %llu %d\n", chunk_sects/2,
 		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 
-		bio_io_error(bio, bio->bi_size);
+		bio_io_error(bio);
 		return 0;
 	}
 
@@ -1155,15 +1148,12 @@ abort:
 }
 
 
-static int end_sync_read(struct bio *bio, unsigned int bytes_done, int error)
+static void end_sync_read(struct bio *bio, int error)
 {
 	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
 	conf_t *conf = mddev_to_conf(r10_bio->mddev);
 	int i,d;
 
-	if (bio->bi_size)
-		return 1;
-
 	for (i=0; i<conf->copies; i++)
 		if (r10_bio->devs[i].bio == bio)
 			break;
@@ -1192,10 +1182,9 @@ static int end_sync_read(struct bio *bio
 		reschedule_retry(r10_bio);
 	}
 	rdev_dec_pending(conf->mirrors[d].rdev, conf->mddev);
-	return 0;
 }
 
-static int end_sync_write(struct bio *bio, unsigned int bytes_done, int error)
+static void end_sync_write(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
@@ -1203,9 +1192,6 @@ static int end_sync_write(struct bio *bi
 	conf_t *conf = mddev_to_conf(mddev);
 	int i,d;
 
-	if (bio->bi_size)
-		return 1;
-
 	for (i = 0; i < conf->copies; i++)
 		if (r10_bio->devs[i].bio == bio)
 			break;
@@ -1228,7 +1214,6 @@ static int end_sync_write(struct bio *bi
 		}
 	}
 	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
-	return 0;
 }
 
 /*
@@ -1374,7 +1359,7 @@ static void recovery_request_write(mddev
 	if (test_bit(R10BIO_Uptodate, &r10_bio->state))
 		generic_make_request(wbio);
 	else
-		bio_endio(wbio, wbio->bi_size, -EIO);
+		bio_endio(wbio, -EIO);
 }
 
 

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/raid1.c	2007-09-27 16:44:54.000000000 +1000
@@ -238,7 +238,7 @@ static void raid_end_bio_io(r1bio_t *r1_
 			(unsigned long long) bio->bi_sector +
 				(bio->bi_size >> 9) - 1);
 
-		bio_endio(bio, bio->bi_size,
+		bio_endio(bio,
 			test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
 	}
 	free_r1bio(r1_bio);
@@ -255,16 +255,13 @@ static inline void update_head_pos(int d
 		r1_bio->sector + (r1_bio->sectors);
 }
 
-static int raid1_end_read_request(struct bio *bio, unsigned int bytes_done, int error)
+static void raid1_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
 	int mirror;
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
-	if (bio->bi_size)
-		return 1;
-	
 	mirror = r1_bio->read_disk;
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
@@ -301,10 +298,9 @@ static int raid1_end_read_request(struct
 	}
 
 	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
-	return 0;
 }
 
-static int raid1_end_write_request(struct bio *bio, unsigned int bytes_done, int error)
+static void raid1_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
@@ -312,8 +308,6 @@ static int raid1_end_write_request(struc
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 	struct bio *to_put = NULL;
 
-	if (bio->bi_size)
-		return 1;
 
 	for (mirror = 0; mirror < conf->raid_disks; mirror++)
 		if (r1_bio->bios[mirror] == bio)
@@ -366,7 +360,7 @@ static int raid1_end_write_request(struc
 					       (unsigned long long) mbio->bi_sector,
 					       (unsigned long long) mbio->bi_sector +
 					       (mbio->bi_size >> 9) - 1);
-					bio_endio(mbio, mbio->bi_size, 0);
+					bio_endio(mbio, 0);
 				}
 			}
 		}
@@ -400,8 +394,6 @@ static int raid1_end_write_request(struc
 
 	if (to_put)
 		bio_put(to_put);
-
-	return 0;
 }
 
 
@@ -796,7 +788,7 @@ static int make_request(struct request_q
 	if (unlikely(!mddev->barriers_work && bio_barrier(bio))) {
 		if (rw == WRITE)
 			md_write_end(mddev);
-		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
@@ -1137,14 +1129,11 @@ abort:
 }
 
 
-static int end_sync_read(struct bio *bio, unsigned int bytes_done, int error)
+static void end_sync_read(struct bio *bio, int error)
 {
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
 	int i;
 
-	if (bio->bi_size)
-		return 1;
-
 	for (i=r1_bio->mddev->raid_disks; i--; )
 		if (r1_bio->bios[i] == bio)
 			break;
@@ -1160,10 +1149,9 @@ static int end_sync_read(struct bio *bio
 
 	if (atomic_dec_and_test(&r1_bio->remaining))
 		reschedule_retry(r1_bio);
-	return 0;
 }
 
-static int end_sync_write(struct bio *bio, unsigned int bytes_done, int error)
+static void end_sync_write(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
@@ -1172,9 +1160,6 @@ static int end_sync_write(struct bio *bi
 	int i;
 	int mirror=0;
 
-	if (bio->bi_size)
-		return 1;
-
 	for (i = 0; i < conf->raid_disks; i++)
 		if (r1_bio->bios[i] == bio) {
 			mirror = i;
@@ -1200,7 +1185,6 @@ static int end_sync_write(struct bio *bi
 		md_done_sync(mddev, r1_bio->sectors, uptodate);
 		put_buf(r1_bio);
 	}
-	return 0;
 }
 
 static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/md/raid5.c	2007-09-27 17:08:04.000000000 +1000
@@ -108,12 +108,11 @@ static void return_io(struct bio *return
 {
 	struct bio *bi = return_bi;
 	while (bi) {
-		int bytes = bi->bi_size;
 
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes,
+		bi->bi_end_io(bi,
 			      test_bit(BIO_UPTODATE, &bi->bi_flags)
 			        ? 0 : -EIO);
 		bi = return_bi;
@@ -382,10 +381,10 @@ static unsigned long get_stripe_work(str
 	return pending;
 }
 
-static int
-raid5_end_read_request(struct bio *bi, unsigned int bytes_done, int error);
-static int
-raid5_end_write_request (struct bio *bi, unsigned int bytes_done, int error);
+static void
+raid5_end_read_request(struct bio *bi, int error);
+static void
+raid5_end_write_request(struct bio *bi, int error);
 
 static void ops_run_io(struct stripe_head *sh)
 {
@@ -1113,8 +1112,7 @@ static void shrink_stripes(raid5_conf_t 
 	conf->slab_cache = NULL;
 }
 
-static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
-				   int error)
+static void raid5_end_read_request(struct bio * bi, int error)
 {
  	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
@@ -1123,8 +1121,6 @@ static int raid5_end_read_request(struct
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 
-	if (bi->bi_size)
-		return 1;
 
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
@@ -1135,7 +1131,7 @@ static int raid5_end_read_request(struct
 		uptodate);
 	if (i == disks) {
 		BUG();
-		return 0;
+		return;
 	}
 
 	if (uptodate) {
@@ -1188,20 +1184,15 @@ static int raid5_end_read_request(struct
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
-	return 0;
 }
 
-static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
-				    int error)
+static void raid5_end_write_request (struct bio *bi, int error)
 {
  	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
-	if (bi->bi_size)
-		return 1;
-
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
@@ -1211,7 +1202,7 @@ static int raid5_end_write_request (stru
 		uptodate);
 	if (i == disks) {
 		BUG();
-		return 0;
+		return;
 	}
 
 	if (!uptodate)
@@ -1222,7 +1213,6 @@ static int raid5_end_write_request (stru
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
-	return 0;
 }
 
 
@@ -3343,7 +3333,7 @@ static struct bio *remove_bio_from_retry
  *  first).
  *  If the read failed..
  */
-static int raid5_align_endio(struct bio *bi, unsigned int bytes, int error)
+static void raid5_align_endio(struct bio *bi, int error)
 {
 	struct bio* raid_bi  = bi->bi_private;
 	mddev_t *mddev;
@@ -3351,8 +3341,6 @@ static int raid5_align_endio(struct bio 
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	mdk_rdev_t *rdev;
 
-	if (bi->bi_size)
-		return 1;
 	bio_put(bi);
 
 	mddev = raid_bi->bi_bdev->bd_disk->queue->queuedata;
@@ -3363,17 +3351,16 @@ static int raid5_align_endio(struct bio 
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error && uptodate) {
-		bio_endio(raid_bi, bytes, 0);
+		bio_endio(raid_bi, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_stripe);
-		return 0;
+		return;
 	}
 
 
 	pr_debug("raid5_align_endio : io error...handing IO for a retry\n");
 
 	add_bio_to_retry(raid_bi, conf);
-	return 0;
 }
 
 static int bio_fits_rdev(struct bio *bi)
@@ -3479,7 +3466,7 @@ static int make_request(struct request_q
 	int remaining;
 
 	if (unlikely(bio_barrier(bi))) {
-		bio_endio(bi, bi->bi_size, -EOPNOTSUPP);
+		bio_endio(bi, -EOPNOTSUPP);
 		return 0;
 	}
 
@@ -3595,12 +3582,11 @@ static int make_request(struct request_q
 	remaining = --bi->bi_phys_segments;
 	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0) {
-		int bytes = bi->bi_size;
 
 		if ( rw == WRITE )
 			md_write_end(mddev);
-		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes,
+
+		bi->bi_end_io(bi,
 			      test_bit(BIO_UPTODATE, &bi->bi_flags)
 			        ? 0 : -EIO);
 	}
@@ -3878,10 +3864,8 @@ static int  retry_aligned_read(raid5_con
 	remaining = --raid_bio->bi_phys_segments;
 	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0) {
-		int bytes = raid_bio->bi_size;
 
-		raid_bio->bi_size = 0;
-		raid_bio->bi_end_io(raid_bio, bytes,
+		raid_bio->bi_end_io(raid_bio,
 			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
 			        ? 0 : -EIO);
 	}

diff .prev/drivers/s390/block/dcssblk.c ./drivers/s390/block/dcssblk.c
--- .prev/drivers/s390/block/dcssblk.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/s390/block/dcssblk.c	2007-09-27 16:44:54.000000000 +1000
@@ -674,10 +674,10 @@ dcssblk_make_request(struct request_queu
 		}
 		bytes_done += bvec->bv_len;
 	}
-	bio_endio(bio, bytes_done, 0);
+	bio_endio(bio, 0);
 	return 0;
 fail:
-	bio_io_error(bio, bio->bi_size);
+	bio_io_error(bio);
 	return 0;
 }
 

diff .prev/drivers/s390/block/xpram.c ./drivers/s390/block/xpram.c
--- .prev/drivers/s390/block/xpram.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/s390/block/xpram.c	2007-09-27 16:44:54.000000000 +1000
@@ -230,12 +230,10 @@ static int xpram_make_request(struct req
 		}
 	}
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
-	bytes = bio->bi_size;
-	bio->bi_size = 0;
-	bio->bi_end_io(bio, bytes, 0);
+	bio_end_io(bio, 0);
 	return 0;
 fail:
-	bio_io_error(bio, bio->bi_size);
+	bio_io_error(bio);
 	return 0;
 }
 

diff .prev/drivers/scsi/scsi_lib.c ./drivers/scsi/scsi_lib.c
--- .prev/drivers/scsi/scsi_lib.c	2007-09-27 17:07:59.000000000 +1000
+++ ./drivers/scsi/scsi_lib.c	2007-09-27 16:44:54.000000000 +1000
@@ -275,13 +275,9 @@ static int scsi_merge_bio(struct request
 	return 0;
 }
 
-static int scsi_bi_endio(struct bio *bio, unsigned int bytes_done, int error)
+static void scsi_bi_endio(struct bio *bio, int error)
 {
-	if (bio->bi_size)
-		return 1;
-
 	bio_put(bio);
-	return 0;
 }
 
 /**
@@ -337,7 +333,7 @@ static int scsi_req_map_sg(struct reques
 			if (bio->bi_vcnt >= nr_vecs) {
 				err = scsi_merge_bio(rq, bio);
 				if (err) {
-					bio_endio(bio, bio->bi_size, 0);
+					bio_endio(bio, 0);
 					goto free_bios;
 				}
 				bio = NULL;
@@ -359,7 +355,7 @@ free_bios:
 		/*
 		 * call endio instead of bio_put incase it was bounced
 		 */
-		bio_endio(bio, bio->bi_size, 0);
+		bio_endio(bio, 0);
 	}
 
 	return err;

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/bio.c	2007-09-27 17:08:04.000000000 +1000
@@ -798,13 +798,9 @@ void bio_unmap_user(struct bio *bio)
 	bio_put(bio);
 }
 
-static int bio_map_kern_endio(struct bio *bio, unsigned int bytes_done, int err)
+static void bio_map_kern_endio(struct bio *bio, int err)
 {
-	if (bio->bi_size)
-		return 1;
-
 	bio_put(bio);
-	return 0;
 }
 
 
@@ -1002,12 +998,10 @@ void bio_check_pages_dirty(struct bio *b
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
- * @bytes_done:	number of bytes completed
  * @error:	error, if any
  *
  * Description:
- *   bio_endio() will end I/O on @bytes_done number of bytes. This
- *   must always be the whole (remaining) bio. bio_endio() is the
+ *   bio_endio() will end I/O on the whole bio. bio_endio() is the
  *   preferred way to end I/O on a bio, it takes care of clearing
  *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
  *   established -Exxxx (-EIO, for instance) error values in case
@@ -1015,22 +1009,15 @@ void bio_check_pages_dirty(struct bio *b
  *   bio unless they own it and thus know that it has an end_io
  *   function.
  **/
-void bio_endio(struct bio *bio, unsigned int bytes_done, int error)
+void bio_endio(struct bio *bio, int error)
 {
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	if (unlikely(bytes_done != bio->bi_size)) {
-		printk("%s: want %u bytes done, only %u left\n", __FUNCTION__,
-						bytes_done, bio->bi_size);
-		bytes_done = bio->bi_size;
-	}
-
-	bio->bi_size = 0; /* expected by some callees - will be removed */
 	if (bio->bi_end_io)
-		bio->bi_end_io(bio, bytes_done, error);
+		bio->bi_end_io(bio, error);
 }
 
 void bio_pair_release(struct bio_pair *bp)
@@ -1038,37 +1025,29 @@ void bio_pair_release(struct bio_pair *b
 	if (atomic_dec_and_test(&bp->cnt)) {
 		struct bio *master = bp->bio1.bi_private;
 
-		bio_endio(master, master->bi_size, bp->error);
+		bio_endio(master, bp->error);
 		mempool_free(bp, bp->bio2.bi_private);
 	}
 }
 
-static int bio_pair_end_1(struct bio * bi, unsigned int done, int err)
+static void bio_pair_end_1(struct bio *bi, int err)
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
 
 	if (err)
 		bp->error = err;
 
-	if (bi->bi_size)
-		return 1;
-
 	bio_pair_release(bp);
-	return 0;
 }
 
-static int bio_pair_end_2(struct bio * bi, unsigned int done, int err)
+static void bio_pair_end_2(struct bio *bi, int err)
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
 
 	if (err)
 		bp->error = err;
 
-	if (bi->bi_size)
-		return 1;
-
 	bio_pair_release(bp);
-	return 0;
 }
 
 /*

diff .prev/fs/block_dev.c ./fs/block_dev.c
--- .prev/fs/block_dev.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/block_dev.c	2007-09-27 16:44:54.000000000 +1000
@@ -172,7 +172,7 @@ blkdev_direct_IO(int rw, struct kiocb *i
 }
 
 #if 0
-static int blk_end_aio(struct bio *bio, unsigned int bytes_done, int error)
+static void blk_end_aio(struct bio *bio, int error)
 {
 	struct kiocb *iocb = bio->bi_private;
 	atomic_t *bio_count = &iocb->ki_bio_count;

diff .prev/fs/buffer.c ./fs/buffer.c
--- .prev/fs/buffer.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/buffer.c	2007-09-27 16:44:54.000000000 +1000
@@ -2634,13 +2634,10 @@ sector_t generic_block_bmap(struct addre
 	return tmp.b_blocknr;
 }
 
-static int end_bio_bh_io_sync(struct bio *bio, unsigned int bytes_done, int err)
+static void end_bio_bh_io_sync(struct bio *bio, int err)
 {
 	struct buffer_head *bh = bio->bi_private;
 
-	if (bio->bi_size)
-		return 1;
-
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		set_bit(BH_Eopnotsupp, &bh->b_state);
@@ -2648,7 +2645,6 @@ static int end_bio_bh_io_sync(struct bio
 
 	bh->b_end_io(bh, test_bit(BIO_UPTODATE, &bio->bi_flags));
 	bio_put(bio);
-	return 0;
 }
 
 int submit_bh(int rw, struct buffer_head * bh)

diff .prev/fs/direct-io.c ./fs/direct-io.c
--- .prev/fs/direct-io.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/direct-io.c	2007-09-27 16:44:54.000000000 +1000
@@ -264,15 +264,12 @@ static int dio_bio_complete(struct dio *
 /*
  * Asynchronous IO callback. 
  */
-static int dio_bio_end_aio(struct bio *bio, unsigned int bytes_done, int error)
+static void dio_bio_end_aio(struct bio *bio, int error)
 {
 	struct dio *dio = bio->bi_private;
 	unsigned long remaining;
 	unsigned long flags;
 
-	if (bio->bi_size)
-		return 1;
-
 	/* cleanup the bio */
 	dio_bio_complete(dio, bio);
 
@@ -287,8 +284,6 @@ static int dio_bio_end_aio(struct bio *b
 		aio_complete(dio->iocb, ret, 0);
 		kfree(dio);
 	}
-
-	return 0;
 }
 
 /*
@@ -298,21 +293,17 @@ static int dio_bio_end_aio(struct bio *b
  * During I/O bi_private points at the dio.  After I/O, bi_private is used to
  * implement a singly-linked list of completed BIOs, at dio->bio_list.
  */
-static int dio_bio_end_io(struct bio *bio, unsigned int bytes_done, int error)
+static void dio_bio_end_io(struct bio *bio, int error)
 {
 	struct dio *dio = bio->bi_private;
 	unsigned long flags;
 
-	if (bio->bi_size)
-		return 1;
-
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	bio->bi_private = dio->bio_list;
 	dio->bio_list = bio;
 	if (--dio->refcount == 1 && dio->waiter)
 		wake_up_process(dio->waiter);
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
-	return 0;
 }
 
 static int

diff .prev/fs/gfs2/super.c ./fs/gfs2/super.c
--- .prev/fs/gfs2/super.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/gfs2/super.c	2007-09-27 16:44:54.000000000 +1000
@@ -160,11 +160,9 @@ int gfs2_check_sb(struct gfs2_sbd *sdp, 
 }
 
 
-static int end_bio_io_page(struct bio *bio, unsigned int bytes_done, int error)
+static void end_bio_io_page(struct bio *bio, int error)
 {
 	struct page *page = bio->bi_private;
-	if (bio->bi_size)
-		return 1;
 
 	if (!error)
 		SetPageUptodate(page);

diff .prev/fs/jfs/jfs_logmgr.c ./fs/jfs/jfs_logmgr.c
--- .prev/fs/jfs/jfs_logmgr.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/jfs/jfs_logmgr.c	2007-09-27 16:44:54.000000000 +1000
@@ -2200,16 +2200,13 @@ static int lbmIOWait(struct lbuf * bp, i
  *
  * executed at INTIODONE level
  */
-static int lbmIODone(struct bio *bio, unsigned int bytes_done, int error)
+static void lbmIODone(struct bio *bio, int error)
 {
 	struct lbuf *bp = bio->bi_private;
 	struct lbuf *nextbp, *tail;
 	struct jfs_log *log;
 	unsigned long flags;
 
-	if (bio->bi_size)
-		return 1;
-
 	/*
 	 * get back jfs buffer bound to the i/o buffer
 	 */

diff .prev/fs/jfs/jfs_metapage.c ./fs/jfs/jfs_metapage.c
--- .prev/fs/jfs/jfs_metapage.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/jfs/jfs_metapage.c	2007-09-27 16:44:54.000000000 +1000
@@ -280,14 +280,10 @@ static void last_read_complete(struct pa
 	unlock_page(page);
 }
 
-static int metapage_read_end_io(struct bio *bio, unsigned int bytes_done,
-				int err)
+static void metapage_read_end_io(struct bio *bio, int err)
 {
 	struct page *page = bio->bi_private;
 
-	if (bio->bi_size)
-		return 1;
-
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		printk(KERN_ERR "metapage_read_end_io: I/O error\n");
 		SetPageError(page);
@@ -341,16 +337,12 @@ static void last_write_complete(struct p
 	end_page_writeback(page);
 }
 
-static int metapage_write_end_io(struct bio *bio, unsigned int bytes_done,
-				 int err)
+static void metapage_write_end_io(struct bio *bio, int err)
 {
 	struct page *page = bio->bi_private;
 
 	BUG_ON(!PagePrivate(page));
 
-	if (bio->bi_size)
-		return 1;
-
 	if (! test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		printk(KERN_ERR "metapage_write_end_io: I/O error\n");
 		SetPageError(page);

diff .prev/fs/mpage.c ./fs/mpage.c
--- .prev/fs/mpage.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/mpage.c	2007-09-27 16:44:54.000000000 +1000
@@ -39,14 +39,11 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static int mpage_end_io_read(struct bio *bio, unsigned int bytes_done, int err)
+static void mpage_end_io_read(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 
-	if (bio->bi_size)
-		return 1;
-
 	do {
 		struct page *page = bvec->bv_page;
 
@@ -62,17 +59,13 @@ static int mpage_end_io_read(struct bio 
 		unlock_page(page);
 	} while (bvec >= bio->bi_io_vec);
 	bio_put(bio);
-	return 0;
 }
 
-static int mpage_end_io_write(struct bio *bio, unsigned int bytes_done, int err)
+static void mpage_end_io_write(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 
-	if (bio->bi_size)
-		return 1;
-
 	do {
 		struct page *page = bvec->bv_page;
 
@@ -87,7 +80,6 @@ static int mpage_end_io_write(struct bio
 		end_page_writeback(page);
 	} while (bvec >= bio->bi_io_vec);
 	bio_put(bio);
-	return 0;
 }
 
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)

diff .prev/fs/ocfs2/cluster/heartbeat.c ./fs/ocfs2/cluster/heartbeat.c
--- .prev/fs/ocfs2/cluster/heartbeat.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/ocfs2/cluster/heartbeat.c	2007-09-27 16:44:54.000000000 +1000
@@ -217,7 +217,6 @@ static void o2hb_wait_on_io(struct o2hb_
 }
 
 static int o2hb_bio_end_io(struct bio *bio,
-			   unsigned int bytes_done,
 			   int error)
 {
 	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
@@ -227,9 +226,6 @@ static int o2hb_bio_end_io(struct bio *b
 		wc->wc_error = error;
 	}
 
-	if (bio->bi_size)
-		return 1;
-
 	o2hb_bio_wait_dec(wc, 1);
 	bio_put(bio);
 	return 0;

diff .prev/fs/xfs/linux-2.6/xfs_aops.c ./fs/xfs/linux-2.6/xfs_aops.c
--- .prev/fs/xfs/linux-2.6/xfs_aops.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/xfs/linux-2.6/xfs_aops.c	2007-09-27 16:44:54.000000000 +1000
@@ -326,14 +326,10 @@ xfs_iomap_valid(
 STATIC int
 xfs_end_bio(
 	struct bio		*bio,
-	unsigned int		bytes_done,
 	int			error)
 {
 	xfs_ioend_t		*ioend = bio->bi_private;
 
-	if (bio->bi_size)
-		return 1;
-
 	ASSERT(atomic_read(&bio->bi_cnt) >= 1);
 	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
 

diff .prev/fs/xfs/linux-2.6/xfs_buf.c ./fs/xfs/linux-2.6/xfs_buf.c
--- .prev/fs/xfs/linux-2.6/xfs_buf.c	2007-09-27 17:07:59.000000000 +1000
+++ ./fs/xfs/linux-2.6/xfs_buf.c	2007-09-27 16:44:54.000000000 +1000
@@ -1106,16 +1106,12 @@ _xfs_buf_ioend(
 STATIC int
 xfs_buf_bio_end_io(
 	struct bio		*bio,
-	unsigned int		bytes_done,
 	int			error)
 {
 	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
 	unsigned int		blocksize = bp->b_target->bt_bsize;
 	struct bio_vec		*bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 
-	if (bio->bi_size)
-		return 1;
-
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		bp->b_error = EIO;
 

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-09-27 17:07:59.000000000 +1000
+++ ./include/linux/bio.h	2007-09-27 16:44:54.000000000 +1000
@@ -64,7 +64,7 @@ struct bio_vec {
 
 struct bio_set;
 struct bio;
-typedef int (bio_end_io_t) (struct bio *, unsigned int, int);
+typedef void (bio_end_io_t) (struct bio *, int);
 typedef void (bio_destructor_t) (struct bio *);
 
 /*
@@ -226,7 +226,7 @@ struct bio {
 #define BIO_SEG_BOUNDARY(q, b1, b2) \
 	BIOVEC_SEG_BOUNDARY((q), __BVEC_END((b1)), __BVEC_START((b2)))
 
-#define bio_io_error(bio, bytes) bio_endio((bio), (bytes), -EIO)
+#define bio_io_error(bio) bio_endio((bio), -EIO)
 
 /*
  * drivers should not use the __ version unless they _really_ want to
@@ -286,7 +286,7 @@ extern struct bio *bio_alloc_bioset(gfp_
 extern void bio_put(struct bio *);
 extern void bio_free(struct bio *, struct bio_set *);
 
-extern void bio_endio(struct bio *, unsigned int, int);
+extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 extern int bio_hw_segments(struct request_queue *, struct bio *);

diff .prev/include/linux/swap.h ./include/linux/swap.h
--- .prev/include/linux/swap.h	2007-09-27 17:07:59.000000000 +1000
+++ ./include/linux/swap.h	2007-09-27 16:44:54.000000000 +1000
@@ -221,7 +221,7 @@ extern void swap_unplug_io_fn(struct bac
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct file *, struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern int end_swap_bio_read(struct bio *bio, unsigned int bytes_done, int err);
+extern void end_swap_bio_read(struct bio *bio, int err);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swapper_space;

diff .prev/mm/bounce.c ./mm/bounce.c
--- .prev/mm/bounce.c	2007-09-27 17:07:59.000000000 +1000
+++ ./mm/bounce.c	2007-09-27 16:44:54.000000000 +1000
@@ -140,26 +140,19 @@ static void bounce_end_io(struct bio *bi
 		mempool_free(bvec->bv_page, pool);
 	}
 
-	bio_endio(bio_orig, bio_orig->bi_size, err);
+	bio_endio(bio_orig, err);
 	bio_put(bio);
 }
 
-static int bounce_end_io_write(struct bio *bio, unsigned int bytes_done, int err)
+static void bounce_end_io_write(struct bio *bio, int err)
 {
-	if (bio->bi_size)
-		return 1;
-
 	bounce_end_io(bio, page_pool, err);
-	return 0;
 }
 
-static int bounce_end_io_write_isa(struct bio *bio, unsigned int bytes_done, int err)
+static void bounce_end_io_write_isa(struct bio *bio, int err)
 {
-	if (bio->bi_size)
-		return 1;
 
 	bounce_end_io(bio, isa_page_pool, err);
-	return 0;
 }
 
 static void __bounce_end_io_read(struct bio *bio, mempool_t *pool, int err)
@@ -172,22 +165,14 @@ static void __bounce_end_io_read(struct 
 	bounce_end_io(bio, pool, err);
 }
 
-static int bounce_end_io_read(struct bio *bio, unsigned int bytes_done, int err)
+static void bounce_end_io_read(struct bio *bio, int err)
 {
-	if (bio->bi_size)
-		return 1;
-
 	__bounce_end_io_read(bio, page_pool, err);
-	return 0;
 }
 
-static int bounce_end_io_read_isa(struct bio *bio, unsigned int bytes_done, int err)
+static void bounce_end_io_read_isa(struct bio *bio, int err)
 {
-	if (bio->bi_size)
-		return 1;
-
 	__bounce_end_io_read(bio, isa_page_pool, err);
-	return 0;
 }
 
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,

diff .prev/mm/page_io.c ./mm/page_io.c
--- .prev/mm/page_io.c	2007-09-27 17:07:59.000000000 +1000
+++ ./mm/page_io.c	2007-09-27 16:44:54.000000000 +1000
@@ -44,14 +44,11 @@ static struct bio *get_swap_bio(gfp_t gf
 	return bio;
 }
 
-static int end_swap_bio_write(struct bio *bio, unsigned int bytes_done, int err)
+static void end_swap_bio_write(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
-	if (bio->bi_size)
-		return 1;
-
 	if (!uptodate) {
 		SetPageError(page);
 		/*
@@ -71,17 +68,13 @@ static int end_swap_bio_write(struct bio
 	}
 	end_page_writeback(page);
 	bio_put(bio);
-	return 0;
 }
 
-int end_swap_bio_read(struct bio *bio, unsigned int bytes_done, int err)
+void end_swap_bio_read(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
-	if (bio->bi_size)
-		return 1;
-
 	if (!uptodate) {
 		SetPageError(page);
 		ClearPageUptodate(page);
@@ -94,7 +87,6 @@ int end_swap_bio_read(struct bio *bio, u
 	}
 	unlock_page(page);
 	bio_put(bio);
-	return 0;
 }
 
 /*
