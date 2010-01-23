Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132Ab0AWAWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0AWAWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524Ab0AWAWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:22:37 -0500
Received: from kroah.org ([198.145.64.141]:35088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab0AWAS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001113.021738616@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [22/29] block: bdev_stack_limits wrapper
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

commit 17be8c245054b9c7786545af3ba3ca4e54cd4ad9 upstream.

DM does not want to know about partition offsets.  Add a partition-aware
wrapper that DM can use when stacking block devices.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-settings.c   |   22 ++++++++++++++++++++++
 include/linux/blkdev.h |    2 ++
 2 files changed, 24 insertions(+)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -560,6 +560,28 @@ int blk_stack_limits(struct queue_limits
 EXPORT_SYMBOL(blk_stack_limits);
 
 /**
+ * bdev_stack_limits - adjust queue limits for stacked drivers
+ * @t:	the stacking driver limits (top device)
+ * @bdev:  the component block_device (bottom)
+ * @start:  first data sector within component device
+ *
+ * Description:
+ *    Merges queue limits for a top device and a block_device.  Returns
+ *    0 if alignment didn't change.  Returns -1 if adding the bottom
+ *    device caused misalignment.
+ */
+int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
+		      sector_t start)
+{
+	struct request_queue *bq = bdev_get_queue(bdev);
+
+	start += get_start_sect(bdev);
+
+	return blk_stack_limits(t, &bq->limits, start << 9);
+}
+EXPORT_SYMBOL(bdev_stack_limits);
+
+/**
  * disk_stack_limits - adjust queue limits for stacked drivers
  * @disk:  MD/DM gendisk (top)
  * @bdev:  the underlying block device (bottom)
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -942,6 +942,8 @@ extern void blk_queue_io_opt(struct requ
 extern void blk_set_default_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
+extern int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
+			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 			      sector_t offset);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);


