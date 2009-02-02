Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbZBBNRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbZBBNRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 08:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZBBNQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 08:16:58 -0500
Received: from brick.kernel.dk ([93.163.65.50]:23549 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbZBBNQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 08:16:57 -0500
Date: Mon, 2 Feb 2009 14:15:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] block bits
Message-ID: <20090202131502.GH30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One critical bit in here, which fixes a reported oops from the iostat
patch. The others are either trivial/minor or documentation. Please
pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Alberto Bertogli (2):
      Fix misleading comment in bio.h
      bio.h: If they MUST be inlined, then use __always_inline

Jens Axboe (3):
      block: fix oops in blk_queue_io_stat()
      block: fix inconsistent parenthesisation of QUEUE_FLAG_DEFAULT
      block: add text file detailing queue/ sysfs files

 Documentation/block/queue-sysfs.txt |   63 +++++++++++++++++++++++++++++++++++
 block/blk-core.c                    |    6 ++--
 block/blk.h                         |    8 ++++
 include/linux/bio.h                 |   10 +++--
 include/linux/blkdev.h              |    2 +-
 5 files changed, 81 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/block/queue-sysfs.txt

diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
new file mode 100644
index 0000000..e164403
--- /dev/null
+++ b/Documentation/block/queue-sysfs.txt
@@ -0,0 +1,63 @@
+Queue sysfs files
+=================
+
+This text file will detail the queue files that are located in the sysfs tree
+for each block device. Note that stacked devices typically do not export
+any settings, since their queue merely functions are a remapping target.
+These files are the ones found in the /sys/block/xxx/queue/ directory.
+
+Files denoted with a RO postfix are readonly and the RW postfix means
+read-write.
+
+hw_sector_size (RO)
+-------------------
+This is the hardware sector size of the device, in bytes.
+
+max_hw_sectors_kb (RO)
+----------------------
+This is the maximum number of kilobytes supported in a single data transfer.
+
+max_sectors_kb (RW)
+-------------------
+This is the maximum number of kilobytes that the block layer will allow
+for a filesystem request. Must be smaller than or equal to the maximum
+size allowed by the hardware.
+
+nomerges (RW)
+-------------
+This enables the user to disable the lookup logic involved with IO merging
+requests in the block layer. Merging may still occur through a direct
+1-hit cache, since that comes for (almost) free. The IO scheduler will not
+waste cycles doing tree/hash lookups for merges if nomerges is 1. Defaults
+to 0, enabling all merges.
+
+nr_requests (RW)
+----------------
+This controls how many requests may be allocated in the block layer for
+read or write requests. Note that the total allocated number may be twice
+this amount, since it applies only to reads or writes (not the accumulated
+sum).
+
+read_ahead_kb (RW)
+------------------
+Maximum number of kilobytes to read-ahead for filesystems on this block
+device.
+
+rq_affinity (RW)
+----------------
+If this option is enabled, the block layer will migrate request completions
+to the CPU that originally submitted the request. For some workloads
+this provides a significant reduction in CPU cycles due to caching effects.
+
+scheduler (RW)
+--------------
+When read, this file will display the current and available IO schedulers
+for this block device. The currently active IO scheduler will be enclosed
+in [] brackets. Writing an IO scheduler name to this file will switch
+control of this block device to that new IO scheduler. Note that writing
+an IO scheduler name to this file will attempt to load that IO scheduler
+module, if it isn't already present in the system.
+
+
+
+Jens Axboe <jens.axboe@oracle.com>, February 2009
diff --git a/block/blk-core.c b/block/blk-core.c
index ca69f3d..29bcfac 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -69,7 +69,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 	int rw = rq_data_dir(rq);
 	int cpu;
 
-	if (!blk_fs_request(rq) || !disk || !blk_queue_io_stat(disk->queue))
+	if (!blk_fs_request(rq) || !disk || !blk_do_io_stat(disk->queue))
 		return;
 
 	cpu = part_stat_lock();
@@ -1667,7 +1667,7 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
 	struct gendisk *disk = req->rq_disk;
 
-	if (!disk || !blk_queue_io_stat(disk->queue))
+	if (!disk || !blk_do_io_stat(disk->queue))
 		return;
 
 	if (blk_fs_request(req)) {
@@ -1686,7 +1686,7 @@ static void blk_account_io_done(struct request *req)
 {
 	struct gendisk *disk = req->rq_disk;
 
-	if (!disk || !blk_queue_io_stat(disk->queue))
+	if (!disk || !blk_do_io_stat(disk->queue))
 		return;
 
 	/*
diff --git a/block/blk.h b/block/blk.h
index 6e1ed40..0dce92c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -108,4 +108,12 @@ static inline int blk_cpu_to_group(int cpu)
 #endif
 }
 
+static inline int blk_do_io_stat(struct request_queue *q)
+{
+	if (q)
+		return blk_queue_io_stat(q);
+
+	return 0;
+}
+
 #endif
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0942765..2aa283a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -451,12 +451,13 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
 
 #ifdef CONFIG_HIGHMEM
 /*
- * remember to add offset! and never ever reenable interrupts between a
- * bvec_kmap_irq and bvec_kunmap_irq!!
+ * remember never ever reenable interrupts between a bvec_kmap_irq and
+ * bvec_kunmap_irq!
  *
  * This function MUST be inlined - it plays with the CPU interrupt flags.
  */
-static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
+static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
+		unsigned long *flags)
 {
 	unsigned long addr;
 
@@ -472,7 +473,8 @@ static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 	return (char *) addr + bvec->bv_offset;
 }
 
-static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
+static __always_inline void bvec_kunmap_irq(char *buffer,
+		unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d08c4b8..dcaa0fd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -455,7 +455,7 @@ struct request_queue
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
-				  1 << QUEUE_FLAG_STACKABLE)
+				 (1 << QUEUE_FLAG_STACKABLE))
 
 static inline int queue_is_locked(struct request_queue *q)
 {

-- 
Jens Axboe

