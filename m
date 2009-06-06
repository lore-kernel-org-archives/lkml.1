Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZFFJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZFFJXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZFFJXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:23:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:3779 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZFFJXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:23:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,315,1241420400"; 
   d="scan'208";a="151340639"
Date: Sun, 7 Jun 2009 00:57:59 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2]Intel Moorestown NAND driver - update to sync up with
	block layer APIs change in linux-next tree
Message-ID: <20090606165759.GC27257@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

   This is an incremental patch for Intel Moorestown NAND flash driver to account for block layer API updates in
   linux-next tree. It has passed compiling against linux-next tree, tag
   next-20090605.

   Thanks.

   Rgds,
   Yunpeng


>From 2155b682e282f4fccac5c7cb71ef6da65d4baa1f Mon Sep 17 00:00:00 2001
From: Gao Yunpeng <yunpeng.gao@intel.com>
Date: Sat, 6 Jun 2009 21:37:58 +0800
Subject: [PATCH] Fix build errors causing by block layer APIs change

Signed-off-by: Gao Yunpeng <yunpeng.gao@intel.com>
---
 drivers/staging/mrst_nand/ffsport.c |   61 ++++++++++++++++++----------------
 1 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/mrst_nand/ffsport.c b/drivers/staging/mrst_nand/ffsport.c
index 5a919f4..347ff20 100644
--- a/drivers/staging/mrst_nand/ffsport.c
+++ b/drivers/staging/mrst_nand/ffsport.c
@@ -145,7 +145,7 @@ u32 *GLOB_MEMMAP_TOBUS(u32 *ptr)
 
 #define GLOB_SBD_NAME          "nd"
 #define GLOB_SBD_IRQ_NUM       (29)
-#define GLOB_VERSION		"driver version 20090531"
+#define GLOB_VERSION		"driver version 20090606"
 
 #define GLOB_SBD_IOCTL_GC                                              (0x7701)
 #define GLOB_SBD_IOCTL_WL                                              (0x7702)
@@ -358,7 +358,7 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 	char *buf;
 	u32 ratio = IdentifyDeviceData.PageDataSize >> 9;
 
-	start_addr = (u64)(req->sector) << 9;
+	start_addr = (u64)(blk_rq_pos(req)) << 9;
 	/* Add a big enough offset to prevent the OS Image from
 	*  being accessed or damaged by file system */
 	start_addr += (SBD_BLOCK_SIZE * res_blks_os);
@@ -366,22 +366,22 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
 			req->cmd[0] == REQ_LB_OP_FLUSH) {
 		if (force_flush_cache()) /* Fail to flush cache */
-			return 0;
+			return -EIO;
 		else
-			return 1;
+			return 0;
 	}
 
 	if (!blk_fs_request(req))
-		return 0;
+		return -EIO;
 
-	if (req->sector + req->current_nr_sectors > get_capacity(tr->gd)) {
+	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) > get_capacity(tr->gd)) {
 		printk(KERN_ERR "Spectra error: request over the NAND "
 			"capacity!sector %d, current_nr_sectors %d, "
 			"while capacity is %d\n",
-			(int)req->sector,
-			req->current_nr_sectors,
+			(int)blk_rq_pos(req),
+			blk_rq_cur_sectors(req),
 			(int)get_capacity(tr->gd));
-		return 0;
+		return -EIO;
 	}
 
 	logical_start_sect = start_addr >> 9;
@@ -390,7 +390,7 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 
 	addr = (u64)hd_start_sect * ratio * 512;
 	buf = req->buffer;
-	nsect = req->current_nr_sectors;
+	nsect = blk_rq_cur_sectors(req);
 
 	if (rsect)
 		tsect =  (ratio - rsect) < nsect ? (ratio - rsect) : nsect;
@@ -402,7 +402,7 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 			if (GLOB_FTL_Page_Read(tr->tmp_buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 			memcpy(buf, tr->tmp_buf + (rsect << 9), tsect << 9);
 			addr += IdentifyDeviceData.PageDataSize;
@@ -415,7 +415,7 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 			if (GLOB_FTL_Page_Read(buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 			addr += IdentifyDeviceData.PageDataSize;
 			buf += IdentifyDeviceData.PageDataSize;
@@ -426,11 +426,11 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 			if (GLOB_FTL_Page_Read(tr->tmp_buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 			memcpy(buf, tr->tmp_buf, (nsect % ratio) << 9);
 		}
-		return 1;
+		return 0;
 
 	case WRITE:
 		/* Write the first NAND page */
@@ -438,13 +438,13 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 			if (GLOB_FTL_Page_Read(tr->tmp_buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 			memcpy(tr->tmp_buf + (rsect << 9), buf, tsect << 9);
 			if (GLOB_FTL_Page_Write(tr->tmp_buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 			addr += IdentifyDeviceData.PageDataSize;
 			buf += tsect << 9;
@@ -456,7 +456,7 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 			if (GLOB_FTL_Page_Write(buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 			addr += IdentifyDeviceData.PageDataSize;
 			buf += IdentifyDeviceData.PageDataSize;
@@ -467,20 +467,20 @@ static int do_transfer(struct spectra_nand_dev *tr, struct request *req)
 			if (GLOB_FTL_Page_Read(tr->tmp_buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 			memcpy(tr->tmp_buf, buf, (nsect % ratio) << 9);
 			if (GLOB_FTL_Page_Write(tr->tmp_buf, addr)) {
 				printk(KERN_ERR "Error in %s, Line %d\n",
 					__FILE__, __LINE__);
-				return 0;
+				return -EIO;
 			}
 		}
-		return 1;
+		return 0;
 
 	default:
 		printk(KERN_NOTICE "Unknown request %u\n", rq_data_dir(req));
-		return 0;
+		return -EIO;
 	}
 }
 
@@ -489,18 +489,16 @@ static int spectra_trans_thread(void *arg)
 {
 	struct spectra_nand_dev *tr = arg;
 	struct request_queue *rq = tr->queue;
+	struct request *req = NULL;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
 	current->flags |= PF_MEMALLOC;
 
 	spin_lock_irq(rq->queue_lock);
 	while (!kthread_should_stop()) {
-		struct request *req;
-		int res = 0;
-
-		req = elv_next_request(rq);
+		int res;
 
-		if (!req) {
+		if (!req && !(req = blk_fetch_request(rq))) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(rq->queue_lock);
 			schedule();
@@ -516,8 +514,13 @@ static int spectra_trans_thread(void *arg)
 
 		spin_lock_irq(rq->queue_lock);
 
-		end_request(req, res);
+		if (!__blk_end_request_cur(req, res))
+			req = NULL;
 	}
+
+	if (req)
+		__blk_end_request_all(req, -EIO);
+
 	spin_unlock_irq(rq->queue_lock);
 
 	return 0;
@@ -736,8 +739,8 @@ static int SBD_setup_device(struct spectra_nand_dev *dev, int which)
 	}
 	dev->queue->queuedata = dev;
 
-	/* blk_queue_hardsect_size(dev->queue, SBD_SECTOR_SIZE); */
-	blk_queue_hardsect_size(dev->queue, 512);
+	/* blk_queue_logical_block_size(dev->queue, SBD_SECTOR_SIZE); */
+	blk_queue_logical_block_size(dev->queue, 512);
 	blk_queue_ordered(dev->queue, QUEUE_ORDERED_DRAIN_FLUSH,
 						SBD_prepare_flush);
 
-- 
1.5.4.5

