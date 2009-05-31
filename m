Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZEaOel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZEaOel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZEaOeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:34:10 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49478 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZEaOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UokgjYPwgTrhZmnIT02d9j/+kB8sjdISePXDgTG7cpkNgdO6EOggQv69+ivLBiH2qd
         uqiYBwD/JReBG6CZn8VSLqxXJGK8LM8MzfxNcO8tHW5K6/NPPA5l809g6+uO54dCTCmk
         2AAtzzvpkpcOFkMveNE9ONJx9c4yWuD6SQEsw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Date: Sun, 31 May 2009 16:39:24 +0200
Message-Id: <20090531143924.7164.25770.sendpatchset@localhost.localdomain>
In-Reply-To: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/4] partitions: add ->set_capacity block device method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] partitions: add ->set_capacity block device method

* Add ->set_capacity block device method and use it in rescan_partitions()
  to attempt enabling native capacity of the device upon detecting the
  partition which exceeds device capacity.

* Add GENHD_FL_NATIVE_CAPACITY flag to try limit attempts of enabling
  native capacity during partition scan.

Together with the consecutive patch implementing ->set_capacity method in
ide-gd device driver this allows automatic disabling of Host Protected Area
(HPA) if any partitions overlapping HPA are detected.

Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: Frans Pop <elendil@planet.nl>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/partitions/check.c  |   43 ++++++++++++++++++++++++++++++++-----------
 include/linux/blkdev.h |    2 ++
 include/linux/genhd.h  |    1 +
 3 files changed, 35 insertions(+), 11 deletions(-)

Index: b/fs/partitions/check.c
===================================================================
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -556,28 +556,49 @@ int rescan_partitions(struct gendisk *di
 
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
-		sector_t size = state->parts[p].size;
-		sector_t from = state->parts[p].from;
+		sector_t size, from;
+try_scan:
+		size = state->parts[p].size;
 		if (!size)
 			continue;
+
+		from = state->parts[p].from;
 		if (from >= get_capacity(disk)) {
 			printk(KERN_WARNING
 			       "%s: p%d ignored, start %llu is behind the end of the disk\n",
 			       disk->disk_name, p, (unsigned long long) from);
 			continue;
 		}
+
 		if (from + size > get_capacity(disk)) {
-			/*
-			 * we can not ignore partitions of broken tables
-			 * created by for example camera firmware, but we
-			 * limit them to the end of the disk to avoid
-			 * creating invalid block devices
-			 */
+			struct block_device_operations *bdops = disk->fops;
+			unsigned long long capacity;
+
 			printk(KERN_WARNING
-			       "%s: p%d size %llu exceeds device capacity, "
-			       "limited to end of disk\n",
+			       "%s: p%d size %llu exceeds device capacity, ",
 			       disk->disk_name, p, (unsigned long long) size);
-			size = get_capacity(disk) - from;
+
+			if (bdops->set_capacity &&
+			    (disk->flags & GENHD_FL_NATIVE_CAPACITY) == 0) {
+				printk(KERN_CONT "enabling native capacity\n");
+				capacity = bdops->set_capacity(disk, ~0ULL);
+				disk->flags |= GENHD_FL_NATIVE_CAPACITY;
+				if (capacity > get_capacity(disk)) {
+					set_capacity(disk, capacity);
+					check_disk_size_change(disk, bdev);
+					bdev->bd_invalidated = 0;
+				}
+				goto try_scan;
+			} else {
+				/*
+				 * we can not ignore partitions of broken tables
+				 * created by for example camera firmware, but
+				 * we limit them to the end of the disk to avoid
+				 * creating invalid block devices
+				 */
+				printk(KERN_CONT "limited to end of disk\n");
+				size = get_capacity(disk) - from;
+			}
 		}
 		part = add_partition(disk, p, from, size,
 				     state->parts[p].flags);
Index: b/include/linux/blkdev.h
===================================================================
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1221,6 +1221,8 @@ struct block_device_operations {
 	int (*direct_access) (struct block_device *, sector_t,
 						void **, unsigned long *);
 	int (*media_changed) (struct gendisk *);
+	unsigned long long (*set_capacity) (struct gendisk *,
+						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	struct module *owner;
Index: b/include/linux/genhd.h
===================================================================
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -114,6 +114,7 @@ struct hd_struct {
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
+#define GENHD_FL_NATIVE_CAPACITY		128
 
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
