Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZGaNEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZGaNEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZGaNEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:04:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34832 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbZGaNEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:04:10 -0400
Date: Fri, 31 Jul 2009 15:04:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.31-rc4
Message-ID: <20090731130409.GS12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some minor bits for 2.6.31-rc4. 4 fixes for mg_disk, one fix for an oops
regression on reading/writing to some sysfs files for ->make_request_fn
based drivers, fixing a silly shared io context thinko, and reverting
the _GPL'ness of the end_io function exports.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Bartlomiej Zolnierkiewicz (1):
      mg_disk: fix issue with data integrity on error in mg_write()

Jens Axboe (2):
      block: always assign default lock to queues
      block: make the end_io functions be non-GPL exports

Li Zefan (1):
      io context: fix ref counting

Xiaotian Feng (1):
      block: fix improper kobject release in blk_integrity_unregister

unsik Kim (3):
      mg_disk: remove prohibited sleep operation
      mg_disk: fix reading invalid status when use polling driver
      mg_disk: Add missing ready status check on mg_write()

 block/blk-core.c          |   19 +++------
 block/blk-integrity.c     |    1 +
 block/blk-settings.c      |    7 +++
 drivers/block/mg_disk.c   |  101 +++++++++++++++++++++++++--------------------
 include/linux/iocontext.h |    2 +-
 5 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b45435..e3299a7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -575,13 +575,6 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 		return NULL;
 	}
 
-	/*
-	 * if caller didn't supply a lock, they get per-queue locking with
-	 * our embedded lock
-	 */
-	if (!lock)
-		lock = &q->__queue_lock;
-
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
@@ -2143,7 +2136,7 @@ bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
 	return blk_end_bidi_request(rq, error, nr_bytes, 0);
 }
-EXPORT_SYMBOL_GPL(blk_end_request);
+EXPORT_SYMBOL(blk_end_request);
 
 /**
  * blk_end_request_all - Helper function for drives to finish the request.
@@ -2164,7 +2157,7 @@ void blk_end_request_all(struct request *rq, int error)
 	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
 	BUG_ON(pending);
 }
-EXPORT_SYMBOL_GPL(blk_end_request_all);
+EXPORT_SYMBOL(blk_end_request_all);
 
 /**
  * blk_end_request_cur - Helper function to finish the current request chunk.
@@ -2182,7 +2175,7 @@ bool blk_end_request_cur(struct request *rq, int error)
 {
 	return blk_end_request(rq, error, blk_rq_cur_bytes(rq));
 }
-EXPORT_SYMBOL_GPL(blk_end_request_cur);
+EXPORT_SYMBOL(blk_end_request_cur);
 
 /**
  * __blk_end_request - Helper function for drivers to complete the request.
@@ -2201,7 +2194,7 @@ bool __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
 	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
 }
-EXPORT_SYMBOL_GPL(__blk_end_request);
+EXPORT_SYMBOL(__blk_end_request);
 
 /**
  * __blk_end_request_all - Helper function for drives to finish the request.
@@ -2222,7 +2215,7 @@ void __blk_end_request_all(struct request *rq, int error)
 	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
 	BUG_ON(pending);
 }
-EXPORT_SYMBOL_GPL(__blk_end_request_all);
+EXPORT_SYMBOL(__blk_end_request_all);
 
 /**
  * __blk_end_request_cur - Helper function to finish the current request chunk.
@@ -2241,7 +2234,7 @@ bool __blk_end_request_cur(struct request *rq, int error)
 {
 	return __blk_end_request(rq, error, blk_rq_cur_bytes(rq));
 }
-EXPORT_SYMBOL_GPL(__blk_end_request_cur);
+EXPORT_SYMBOL(__blk_end_request_cur);
 
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 73e28d3..15c6308 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -379,6 +379,7 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
 	kobject_del(&bi->kobj);
+	kobject_put(&bi->kobj);
 	kmem_cache_free(integrity_cachep, bi);
 	disk->integrity = NULL;
 }
diff --git a/block/blk-settings.c b/block/blk-settings.c
index bd582a7..8a3ea3b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -165,6 +165,13 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_set_default_limits(&q->limits);
 
 	/*
+	 * If the caller didn't supply a lock, fall back to our embedded
+	 * per-queue locks
+	 */
+	if (!q->queue_lock)
+		q->queue_lock = &q->__queue_lock;
+
+	/*
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index f703f54..6d7fbaa 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -36,7 +36,6 @@
 
 /* Register offsets */
 #define MG_BUFF_OFFSET			0x8000
-#define MG_STORAGE_BUFFER_SIZE		0x200
 #define MG_REG_OFFSET			0xC000
 #define MG_REG_FEATURE			(MG_REG_OFFSET + 2)	/* write case */
 #define MG_REG_ERROR			(MG_REG_OFFSET + 2)	/* read case */
@@ -219,6 +218,16 @@ static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
 	host->error = MG_ERR_NONE;
 	expire = jiffies + msecs_to_jiffies(msec);
 
+	/* These 2 times dummy status read prevents reading invalid
+	 * status. A very little time (3 times of mflash operating clk)
+	 * is required for busy bit is set. Use dummy read instead of
+	 * busy wait, because mflash's PLL is machine dependent.
+	 */
+	if (prv_data->use_polling) {
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+	}
+
 	status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 
 	do {
@@ -245,8 +254,6 @@ static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
 			mg_dump_status("not ready", status, host);
 			return MG_ERR_INV_STAT;
 		}
-		if (prv_data->use_polling)
-			msleep(1);
 
 		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 	} while (time_before(cur_jiffies, expire));
@@ -469,9 +476,18 @@ static unsigned int mg_out(struct mg_host *host,
 	return MG_ERR_NONE;
 }
 
+static void mg_read_one(struct mg_host *host, struct request *req)
+{
+	u16 *buff = (u16 *)req->buffer;
+	u32 i;
+
+	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
+		*buff++ = inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
+			      (i << 1));
+}
+
 static void mg_read(struct request *req)
 {
-	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
 
 	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
@@ -482,49 +498,65 @@ static void mg_read(struct request *req)
 	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
 
 	do {
-		u16 *buff = (u16 *)req->buffer;
-
 		if (mg_wait(host, ATA_DRQ,
 			    MG_TMAX_WAIT_RD_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
-			*buff++ = inw((unsigned long)host->dev_base +
-				      MG_BUFF_OFFSET + (j << 1));
+
+		mg_read_one(host, req);
 
 		outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
 	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
 }
 
+static void mg_write_one(struct mg_host *host, struct request *req)
+{
+	u16 *buff = (u16 *)req->buffer;
+	u32 i;
+
+	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
+		outw(*buff++, (unsigned long)host->dev_base + MG_BUFF_OFFSET +
+		     (i << 1));
+}
+
 static void mg_write(struct request *req)
 {
-	u32 j;
 	struct mg_host *host = req->rq_disk->private_data;
+	unsigned int rem = blk_rq_sectors(req);
 
-	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
+	if (mg_out(host, blk_rq_pos(req), rem,
 		   MG_CMD_WR, NULL) != MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
 		return;
 	}
 
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
-	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
+	       rem, blk_rq_pos(req), req->buffer);
+
+	if (mg_wait(host, ATA_DRQ,
+		    MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+		mg_bad_rw_intr(host);
+		return;
+	}
 
 	do {
-		u16 *buff = (u16 *)req->buffer;
+		mg_write_one(host, req);
 
-	if (mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
+
+		rem--;
+		if (rem > 1 && mg_wait(host, ATA_DRQ,
+					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return;
+		} else if (mg_wait(host, MG_STAT_READY,
+					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
 		}
-		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
-			outw(*buff++, (unsigned long)host->dev_base +
-				      MG_BUFF_OFFSET + (j << 1));
-
-		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
-				MG_REG_COMMAND);
 	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
 }
 
@@ -532,7 +564,6 @@ static void mg_read_intr(struct mg_host *host)
 {
 	struct request *req = host->req;
 	u32 i;
-	u16 *buff;
 
 	/* check status */
 	do {
@@ -550,13 +581,7 @@ static void mg_read_intr(struct mg_host *host)
 	return;
 
 ok_to_read:
-	/* get current segment of request */
-	buff = (u16 *)req->buffer;
-
-	/* read 1 sector */
-	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
-		*buff++ = inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
-			      (i << 1));
+	mg_read_one(host, req);
 
 	MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
 	       blk_rq_pos(req), blk_rq_sectors(req) - 1, req->buffer);
@@ -575,8 +600,7 @@ ok_to_read:
 static void mg_write_intr(struct mg_host *host)
 {
 	struct request *req = host->req;
-	u32 i, j;
-	u16 *buff;
+	u32 i;
 	bool rem;
 
 	/* check status */
@@ -597,12 +621,7 @@ static void mg_write_intr(struct mg_host *host)
 ok_to_write:
 	if ((rem = mg_end_request(host, 0, MG_SECTOR_SIZE))) {
 		/* write 1 sector and set handler if remains */
-		buff = (u16 *)req->buffer;
-		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
-			outw(*buff, (unsigned long)host->dev_base +
-					MG_BUFF_OFFSET + (j << 1));
-			buff++;
-		}
+		mg_write_one(host, req);
 		MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
 		       blk_rq_pos(req), blk_rq_sectors(req), req->buffer);
 		host->mg_do_intr = mg_write_intr;
@@ -667,9 +686,6 @@ static unsigned int mg_issue_req(struct request *req,
 		unsigned int sect_num,
 		unsigned int sect_cnt)
 {
-	u16 *buff;
-	u32 i;
-
 	switch (rq_data_dir(req)) {
 	case READ:
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr)
@@ -693,12 +709,7 @@ static unsigned int mg_issue_req(struct request *req,
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
-		buff = (u16 *)req->buffer;
-		for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
-			outw(*buff, (unsigned long)host->dev_base +
-					MG_BUFF_OFFSET + (i << 1));
-			buff++;
-		}
+		mg_write_one(host, req);
 		mod_timer(&host->timer, jiffies + 3 * HZ);
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index dd05434..4da4a75 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -92,7 +92,7 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	 * a race).
 	 */
 	if (ioc && atomic_long_inc_not_zero(&ioc->refcount)) {
-		atomic_long_inc(&ioc->refcount);
+		atomic_inc(&ioc->nr_tasks);
 		return ioc;
 	}
 
-- 
Jens Axboe

