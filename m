Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbZHDUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbZHDUOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZHDUOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:14:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48082 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbZHDUOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:14:46 -0400
Date: Tue, 4 Aug 2009 22:14:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.31-rc5
Message-ID: <20090804201446.GJ12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two things here - one is an IO topology fix set, a pre-requisite for
merging and fixing those for dm. The other is switching bsg to default
on and removing the experimental label. Distros have been shipping it on
for some time, and udev makes good use of it. The experimental label
should have been removed long ago.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus



John Stoffel (1):
      Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG

Martin K. Petersen (4):
      block: Make blk_queue_stack_limits use the new stacking interface
      block: Add a wrapper for setting minimum request size without a queue
      block: Stack optimal I/O size
      block: Update topology documentation

 Documentation/ABI/testing/sysfs-block |   37 ++++++++++------
 block/Kconfig                         |   11 +++--
 block/blk-settings.c                  |   77 +++++++++++++++++++-------------
 include/linux/blkdev.h                |    1 +
 4 files changed, 77 insertions(+), 49 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index cbbd3e0..5f3beda 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -94,28 +94,37 @@ What:		/sys/block/<disk>/queue/physical_block_size
 Date:		May 2009
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
-		This is the smallest unit the storage device can write
-		without resorting to read-modify-write operation.  It is
-		usually the same as the logical block size but may be
-		bigger.  One example is SATA drives with 4KB sectors
-		that expose a 512-byte logical block size to the
-		operating system.
+		This is the smallest unit a physical storage device can
+		write atomically.  It is usually the same as the logical
+		block size but may be bigger.  One example is SATA
+		drives with 4KB sectors that expose a 512-byte logical
+		block size to the operating system.  For stacked block
+		devices the physical_block_size variable contains the
+		maximum physical_block_size of the component devices.
 
 What:		/sys/block/<disk>/queue/minimum_io_size
 Date:		April 2009
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
-		Storage devices may report a preferred minimum I/O size,
-		which is the smallest request the device can perform
-		without incurring a read-modify-write penalty.  For disk
-		drives this is often the physical block size.  For RAID
-		arrays it is often the stripe chunk size.
+		Storage devices may report a granularity or preferred
+		minimum I/O size which is the smallest request the
+		device can perform without incurring a performance
+		penalty.  For disk drives this is often the physical
+		block size.  For RAID arrays it is often the stripe
+		chunk size.  A properly aligned multiple of
+		minimum_io_size is the preferred request size for
+		workloads where a high number of I/O operations is
+		desired.
 
 What:		/sys/block/<disk>/queue/optimal_io_size
 Date:		April 2009
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
 		Storage devices may report an optimal I/O size, which is
-		the device's preferred unit of receiving I/O.  This is
-		rarely reported for disk drives.  For RAID devices it is
-		usually the stripe width or the internal block size.
+		the device's preferred unit for sustained I/O.  This is
+		rarely reported for disk drives.  For RAID arrays it is
+		usually the stripe width or the internal track size.  A
+		properly aligned multiple of optimal_io_size is the
+		preferred request size for workloads where sustained
+		throughput is desired.  If no optimal I/O size is
+		reported this file contains 0.
diff --git a/block/Kconfig b/block/Kconfig
index 95a86ad..9be0b56 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -48,9 +48,9 @@ config LBDAF
 	  If unsure, say Y.
 
 config BLK_DEV_BSG
-	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	---help---
+	bool "Block layer SG support v4"
+	default y
+	help
 	  Saying Y here will enable generic SG (SCSI generic) v4 support
 	  for any block device.
 
@@ -60,7 +60,10 @@ config BLK_DEV_BSG
 	  protocols (e.g. Task Management Functions and SMP in Serial
 	  Attached SCSI).
 
-	  If unsure, say N.
+	  This option is required by recent UDEV versions to properly
+	  access device serial numbers, etc.
+
+	  If unsure, say Y.
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8a3ea3b..476d870 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -7,6 +7,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
+#include <linux/gcd.h>
 
 #include "blk.h"
 
@@ -384,8 +385,8 @@ void blk_queue_alignment_offset(struct request_queue *q, unsigned int offset)
 EXPORT_SYMBOL(blk_queue_alignment_offset);
 
 /**
- * blk_queue_io_min - set minimum request size for the queue
- * @q:	the request queue for the device
+ * blk_limits_io_min - set minimum request size for a device
+ * @limits: the queue limits
  * @min:  smallest I/O size in bytes
  *
  * Description:
@@ -394,15 +395,35 @@ EXPORT_SYMBOL(blk_queue_alignment_offset);
  *   smallest I/O the device can perform without incurring a performance
  *   penalty.
  */
-void blk_queue_io_min(struct request_queue *q, unsigned int min)
+void blk_limits_io_min(struct queue_limits *limits, unsigned int min)
 {
-	q->limits.io_min = min;
+	limits->io_min = min;
 
-	if (q->limits.io_min < q->limits.logical_block_size)
-		q->limits.io_min = q->limits.logical_block_size;
+	if (limits->io_min < limits->logical_block_size)
+		limits->io_min = limits->logical_block_size;
 
-	if (q->limits.io_min < q->limits.physical_block_size)
-		q->limits.io_min = q->limits.physical_block_size;
+	if (limits->io_min < limits->physical_block_size)
+		limits->io_min = limits->physical_block_size;
+}
+EXPORT_SYMBOL(blk_limits_io_min);
+
+/**
+ * blk_queue_io_min - set minimum request size for the queue
+ * @q:	the request queue for the device
+ * @min:  smallest I/O size in bytes
+ *
+ * Description:
+ *   Storage devices may report a granularity or preferred minimum I/O
+ *   size which is the smallest request the device can perform without
+ *   incurring a performance penalty.  For disk drives this is often the
+ *   physical block size.  For RAID arrays it is often the stripe chunk
+ *   size.  A properly aligned multiple of minimum_io_size is the
+ *   preferred request size for workloads where a high number of I/O
+ *   operations is desired.
+ */
+void blk_queue_io_min(struct request_queue *q, unsigned int min)
+{
+	blk_limits_io_min(&q->limits, min);
 }
 EXPORT_SYMBOL(blk_queue_io_min);
 
@@ -412,8 +433,12 @@ EXPORT_SYMBOL(blk_queue_io_min);
  * @opt:  optimal request size in bytes
  *
  * Description:
- *   Drivers can call this function to set the preferred I/O request
- *   size for devices that report such a value.
+ *   Storage devices may report an optimal I/O size, which is the
+ *   device's preferred unit for sustained I/O.  This is rarely reported
+ *   for disk drives.  For RAID arrays it is usually the stripe width or
+ *   the internal track size.  A properly aligned multiple of
+ *   optimal_io_size is the preferred request size for workloads where
+ *   sustained throughput is desired.
  */
 void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
 {
@@ -433,27 +458,7 @@ EXPORT_SYMBOL(blk_queue_io_opt);
  **/
 void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 {
-	/* zero is "infinity" */
-	t->limits.max_sectors = min_not_zero(queue_max_sectors(t),
-					     queue_max_sectors(b));
-
-	t->limits.max_hw_sectors = min_not_zero(queue_max_hw_sectors(t),
-						queue_max_hw_sectors(b));
-
-	t->limits.seg_boundary_mask = min_not_zero(queue_segment_boundary(t),
-						   queue_segment_boundary(b));
-
-	t->limits.max_phys_segments = min_not_zero(queue_max_phys_segments(t),
-						   queue_max_phys_segments(b));
-
-	t->limits.max_hw_segments = min_not_zero(queue_max_hw_segments(t),
-						 queue_max_hw_segments(b));
-
-	t->limits.max_segment_size = min_not_zero(queue_max_segment_size(t),
-						  queue_max_segment_size(b));
-
-	t->limits.logical_block_size = max(queue_logical_block_size(t),
-					   queue_logical_block_size(b));
+	blk_stack_limits(&t->limits, &b->limits, 0);
 
 	if (!t->queue_lock)
 		WARN_ON_ONCE(1);
@@ -523,6 +528,16 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		return -1;
 	}
 
+	/* Find lcm() of optimal I/O size */
+	if (t->io_opt && b->io_opt)
+		t->io_opt = (t->io_opt * b->io_opt) / gcd(t->io_opt, b->io_opt);
+	else if (b->io_opt)
+		t->io_opt = b->io_opt;
+
+	/* Verify that optimal I/O size is a multiple of io_min */
+	if (t->io_min && t->io_opt % t->io_min)
+		return -1;
+
 	return 0;
 }
 EXPORT_SYMBOL(blk_stack_limits);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e7cb5db..69103e0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -913,6 +913,7 @@ extern void blk_queue_logical_block_size(struct request_queue *, unsigned short)
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
+extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_default_limits(struct queue_limits *lim);

-- 
Jens Axboe

