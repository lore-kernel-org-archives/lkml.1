Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZGJSgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZGJSgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZGJSgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:36:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46162 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZGJSgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:36:03 -0400
Date: Fri, 10 Jul 2009 20:36:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block/io bits for 2.6.31-rc2
Message-ID: <20090710183601.GF23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Three regression fixes, plus one further fix for the oom_cfqq fallback
in cfq. The congestion_wait() fallout is mostly one-liners, bringing the
wait/wakeup/set/clear bit usage in line again after the sync/async
change in 2.6.30.

I'll be away the next two weeks, but Tejun has promised to keep an eye
on important block layer bits while I'm away.

  git://git.kernel.dk/linux-2.6-block.git for-linus

FUJITA Tomonori (2):
      block: call blk_scsi_ioctl_init()
      block: fix sg SG_DXFER_TO_FROM_DEV regression

Jens Axboe (1):
      Fix congestion_wait() sync/async vs read/write confusion

Vivek Goyal (1):
      cfq-iosched: reset oom_cfqq in cfq_set_request()

 arch/x86/lib/usercopy_32.c  |    2 +-
 block/cfq-iosched.c         |    2 +-
 block/scsi_ioctl.c          |    1 +
 drivers/block/pktcdvd.c     |   10 ++++++----
 drivers/md/dm-crypt.c       |    2 +-
 drivers/scsi/sg.c           |    4 ++++
 fs/bio.c                    |   22 ++++++++++++----------
 fs/fat/file.c               |    2 +-
 fs/fuse/dev.c               |    8 ++++----
 fs/nfs/write.c              |    8 +++++---
 fs/reiserfs/journal.c       |    2 +-
 fs/xfs/linux-2.6/kmem.c     |    4 ++--
 fs/xfs/linux-2.6/xfs_buf.c  |    2 +-
 include/linux/backing-dev.h |    6 +++---
 include/linux/blkdev.h      |    9 +++++----
 mm/backing-dev.c            |    7 +++----
 mm/memcontrol.c             |    2 +-
 mm/page-writeback.c         |    8 ++++----
 mm/page_alloc.c             |    4 ++--
 mm/vmscan.c                 |    8 ++++----
 20 files changed, 62 insertions(+), 51 deletions(-)

diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 7c8ca91..1f118d4 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -751,7 +751,7 @@ survive:
 
 			if (retval == -ENOMEM && is_global_init(current)) {
 				up_read(&current->mm->mmap_sem);
-				congestion_wait(WRITE, HZ/50);
+				congestion_wait(BLK_RW_ASYNC, HZ/50);
 				goto survive;
 			}
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 87276eb..fd7080e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2311,7 +2311,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 		goto queue_fail;
 
 	cfqq = cic_to_cfqq(cic, is_sync);
-	if (!cfqq) {
+	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
 		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	}
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f0e0ce0..e5b1001 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -680,3 +680,4 @@ int __init blk_scsi_ioctl_init(void)
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
 	return 0;
 }
+fs_initcall(blk_scsi_ioctl_init);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 83650e0..99a506f 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1372,8 +1372,10 @@ try_next_bio:
 	wakeup = (pd->write_congestion_on > 0
 	 		&& pd->bio_queue_size <= pd->write_congestion_off);
 	spin_unlock(&pd->lock);
-	if (wakeup)
-		clear_bdi_congested(&pd->disk->queue->backing_dev_info, WRITE);
+	if (wakeup) {
+		clear_bdi_congested(&pd->disk->queue->backing_dev_info,
+					BLK_RW_ASYNC);
+	}
 
 	pkt->sleep_time = max(PACKET_WAIT_TIME, 1);
 	pkt_set_state(pkt, PACKET_WAITING_STATE);
@@ -2592,10 +2594,10 @@ static int pkt_make_request(struct request_queue *q, struct bio *bio)
 	spin_lock(&pd->lock);
 	if (pd->write_congestion_on > 0
 	    && pd->bio_queue_size >= pd->write_congestion_on) {
-		set_bdi_congested(&q->backing_dev_info, WRITE);
+		set_bdi_congested(&q->backing_dev_info, BLK_RW_ASYNC);
 		do {
 			spin_unlock(&pd->lock);
-			congestion_wait(WRITE, HZ);
+			congestion_wait(BLK_RW_ASYNC, HZ);
 			spin_lock(&pd->lock);
 		} while(pd->bio_queue_size > pd->write_congestion_off);
 	}
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9933eb8..529e2ba 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -776,7 +776,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		 * But don't wait if split was due to the io size restriction
 		 */
 		if (unlikely(out_of_pages))
-			congestion_wait(WRITE, HZ/100);
+			congestion_wait(BLK_RW_ASYNC, HZ/100);
 
 		/*
 		 * With async crypto it is unsafe to share the crypto context
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4d6f2fe..9230402 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1656,6 +1656,10 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		md->nr_entries = req_schp->k_use_sg;
 		md->offset = 0;
 		md->null_mapped = hp->dxferp ? 0 : 1;
+		if (dxfer_dir == SG_DXFER_TO_FROM_DEV)
+			md->from_user = 1;
+		else
+			md->from_user = 0;
 	}
 
 	if (iov_count) {
diff --git a/fs/bio.c b/fs/bio.c
index 1486b19..7673800 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -705,14 +705,13 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
 }
 
 static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
-			  struct sg_iovec *iov, int iov_count, int uncopy,
-			  int do_free_page)
+			  struct sg_iovec *iov, int iov_count,
+			  int to_user, int from_user, int do_free_page)
 {
 	int ret = 0, i;
 	struct bio_vec *bvec;
 	int iov_idx = 0;
 	unsigned int iov_off = 0;
-	int read = bio_data_dir(bio) == READ;
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *bv_addr = page_address(bvec->bv_page);
@@ -727,13 +726,14 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 			iov_addr = iov[iov_idx].iov_base + iov_off;
 
 			if (!ret) {
-				if (!read && !uncopy)
-					ret = copy_from_user(bv_addr, iov_addr,
-							     bytes);
-				if (read && uncopy)
+				if (to_user)
 					ret = copy_to_user(iov_addr, bv_addr,
 							   bytes);
 
+				if (from_user)
+					ret = copy_from_user(bv_addr, iov_addr,
+							     bytes);
+
 				if (ret)
 					ret = -EFAULT;
 			}
@@ -770,7 +770,8 @@ int bio_uncopy_user(struct bio *bio)
 
 	if (!bio_flagged(bio, BIO_NULL_MAPPED))
 		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, 1, bmd->is_our_pages);
+				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+				     0, bmd->is_our_pages);
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
@@ -875,8 +876,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	/*
 	 * success
 	 */
-	if (!write_to_vm && (!map_data || !map_data->null_mapped)) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
+	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
+	    (map_data && map_data->from_user)) {
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 1, 0);
 		if (ret)
 			goto cleanup;
 	}
diff --git a/fs/fat/file.c b/fs/fat/file.c
index b28ea64..f042b96 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -134,7 +134,7 @@ static int fat_file_release(struct inode *inode, struct file *filp)
 	if ((filp->f_mode & FMODE_WRITE) &&
 	     MSDOS_SB(inode->i_sb)->options.flush) {
 		fat_flush_inodes(inode->i_sb, inode, NULL);
-		congestion_wait(WRITE, HZ/10);
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 	return 0;
 }
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f58ecbc..6484eb7 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -286,8 +286,8 @@ __releases(&fc->lock)
 		}
 		if (fc->num_background == FUSE_CONGESTION_THRESHOLD &&
 		    fc->connected && fc->bdi_initialized) {
-			clear_bdi_congested(&fc->bdi, READ);
-			clear_bdi_congested(&fc->bdi, WRITE);
+			clear_bdi_congested(&fc->bdi, BLK_RW_SYNC);
+			clear_bdi_congested(&fc->bdi, BLK_RW_ASYNC);
 		}
 		fc->num_background--;
 		fc->active_background--;
@@ -414,8 +414,8 @@ static void fuse_request_send_nowait_locked(struct fuse_conn *fc,
 		fc->blocked = 1;
 	if (fc->num_background == FUSE_CONGESTION_THRESHOLD &&
 	    fc->bdi_initialized) {
-		set_bdi_congested(&fc->bdi, READ);
-		set_bdi_congested(&fc->bdi, WRITE);
+		set_bdi_congested(&fc->bdi, BLK_RW_SYNC);
+		set_bdi_congested(&fc->bdi, BLK_RW_ASYNC);
 	}
 	list_add_tail(&req->list, &fc->bg_queue);
 	flush_bg_queue(fc);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index ce72882..0a0a2ff 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -202,8 +202,10 @@ static int nfs_set_page_writeback(struct page *page)
 		struct nfs_server *nfss = NFS_SERVER(inode);
 
 		if (atomic_long_inc_return(&nfss->writeback) >
-				NFS_CONGESTION_ON_THRESH)
-			set_bdi_congested(&nfss->backing_dev_info, WRITE);
+				NFS_CONGESTION_ON_THRESH) {
+			set_bdi_congested(&nfss->backing_dev_info,
+						BLK_RW_ASYNC);
+		}
 	}
 	return ret;
 }
@@ -215,7 +217,7 @@ static void nfs_end_page_writeback(struct page *page)
 
 	end_page_writeback(page);
 	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
-		clear_bdi_congested(&nfss->backing_dev_info, WRITE);
+		clear_bdi_congested(&nfss->backing_dev_info, BLK_RW_ASYNC);
 }
 
 /*
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 77f5bb7..9062220 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -997,7 +997,7 @@ static int reiserfs_async_progress_wait(struct super_block *s)
 	DEFINE_WAIT(wait);
 	struct reiserfs_journal *j = SB_JOURNAL(s);
 	if (atomic_read(&j->j_async_throttle))
-		congestion_wait(WRITE, HZ / 10);
+		congestion_wait(BLK_RW_ASYNC, HZ / 10);
 	return 0;
 }
 
diff --git a/fs/xfs/linux-2.6/kmem.c b/fs/xfs/linux-2.6/kmem.c
index 1cd3b55..2d3f90a 100644
--- a/fs/xfs/linux-2.6/kmem.c
+++ b/fs/xfs/linux-2.6/kmem.c
@@ -53,7 +53,7 @@ kmem_alloc(size_t size, unsigned int __nocast flags)
 			printk(KERN_ERR "XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
 					__func__, lflags);
-		congestion_wait(WRITE, HZ/50);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
 
@@ -130,7 +130,7 @@ kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
 			printk(KERN_ERR "XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
 					__func__, lflags);
-		congestion_wait(WRITE, HZ/50);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 1418b91..0c93c7e 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -412,7 +412,7 @@ _xfs_buf_lookup_pages(
 
 			XFS_STATS_INC(xb_page_retries);
 			xfsbufd_wakeup(0, gfp_mask);
-			congestion_wait(WRITE, HZ/50);
+			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto retry;
 		}
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 0ec2c59..3a52a63 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -229,9 +229,9 @@ static inline int bdi_rw_congested(struct backing_dev_info *bdi)
 				  (1 << BDI_async_congested));
 }
 
-void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
-void set_bdi_congested(struct backing_dev_info *bdi, int rw);
-long congestion_wait(int rw, long timeout);
+void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
+void set_bdi_congested(struct backing_dev_info *bdi, int sync);
+long congestion_wait(int sync, long timeout);
 
 
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 49ae079..0146e0f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -723,6 +723,7 @@ struct rq_map_data {
 	int nr_entries;
 	unsigned long offset;
 	int null_mapped;
+	int from_user;
 };
 
 struct req_iterator {
@@ -779,18 +780,18 @@ extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
  * congested queues, and wake up anyone who was waiting for requests to be
  * put back.
  */
-static inline void blk_clear_queue_congested(struct request_queue *q, int rw)
+static inline void blk_clear_queue_congested(struct request_queue *q, int sync)
 {
-	clear_bdi_congested(&q->backing_dev_info, rw);
+	clear_bdi_congested(&q->backing_dev_info, sync);
 }
 
 /*
  * A queue has just entered congestion.  Flag that in the queue's VM-visible
  * state flags and increment the global gounter of congested queues.
  */
-static inline void blk_set_queue_congested(struct request_queue *q, int rw)
+static inline void blk_set_queue_congested(struct request_queue *q, int sync)
 {
-	set_bdi_congested(&q->backing_dev_info, rw);
+	set_bdi_congested(&q->backing_dev_info, sync);
 }
 
 extern void blk_start_queue(struct request_queue *q);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 493b468..c86edd2 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -283,7 +283,6 @@ static wait_queue_head_t congestion_wqh[2] = {
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
 	};
 
-
 void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
 {
 	enum bdi_state bit;
@@ -308,18 +307,18 @@ EXPORT_SYMBOL(set_bdi_congested);
 
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
- * @rw: READ or WRITE
+ * @sync: SYNC or ASYNC IO
  * @timeout: timeout in jiffies
  *
  * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
  * write congestion.  If no backing_devs are congested then just wait for the
  * next write to be completed.
  */
-long congestion_wait(int rw, long timeout)
+long congestion_wait(int sync, long timeout)
 {
 	long ret;
 	DEFINE_WAIT(wait);
-	wait_queue_head_t *wqh = &congestion_wqh[rw];
+	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = io_schedule_timeout(timeout);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2fa20d..e717964 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1973,7 +1973,7 @@ try_to_free:
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
-			congestion_wait(WRITE, HZ/10);
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 		}
 
 	}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7687879..81627eb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -575,7 +575,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 		if (pages_written >= write_chunk)
 			break;		/* We've done our duty */
 
-		congestion_wait(WRITE, HZ/10);
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
@@ -669,7 +669,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
                 if (global_page_state(NR_UNSTABLE_NFS) +
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
-                congestion_wait(WRITE, HZ/10);
+                congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
 		 * The caller might hold locks which can prevent IO completion
@@ -715,7 +715,7 @@ static void background_writeout(unsigned long _min_pages)
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
 			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
+				congestion_wait(BLK_RW_ASYNC, HZ/10);
 			else
 				break;
 		}
@@ -787,7 +787,7 @@ static void wb_kupdate(unsigned long arg)
 		writeback_inodes(&wbc);
 		if (wbc.nr_to_write > 0) {
 			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
+				congestion_wait(BLK_RW_ASYNC, HZ/10);
 			else
 				break;	/* All the old data is written */
 		}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ad7cd1c..a35eeab 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1666,7 +1666,7 @@ __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 			preferred_zone, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
-			congestion_wait(WRITE, HZ/50);
+			congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (!page && (gfp_mask & __GFP_NOFAIL));
 
 	return page;
@@ -1831,7 +1831,7 @@ rebalance:
 	pages_reclaimed += did_some_progress;
 	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
-		congestion_wait(WRITE, HZ/50);
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
 		goto rebalance;
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5415526..dea7abd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1104,7 +1104,7 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
 		 */
 		if (nr_freed < nr_taken && !current_is_kswapd() &&
 		    lumpy_reclaim) {
-			congestion_wait(WRITE, HZ/10);
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 			/*
 			 * The attempt at page out may have made some
@@ -1721,7 +1721,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 
 		/* Take a nap, wait for some writeback to complete */
 		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
-			congestion_wait(WRITE, HZ/10);
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scanning_global_lru(sc))
@@ -1960,7 +1960,7 @@ loop_again:
 		 * another pass across the zones.
 		 */
 		if (total_scanned && priority < DEF_PRIORITY - 2)
-			congestion_wait(WRITE, HZ/10);
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
 		 * We do this so kswapd doesn't build up large priorities for
@@ -2233,7 +2233,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 				goto out;
 
 			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
-				congestion_wait(WRITE, HZ / 10);
+				congestion_wait(BLK_RW_ASYNC, HZ / 10);
 		}
 	}

-- 
Jens Axboe

