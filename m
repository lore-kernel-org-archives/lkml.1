Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbXJELu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbXJELu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJELuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:50:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35176 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXJELuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:50:50 -0400
Date: Fri, 5 Oct 2007 13:50:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [code] Unlimited partitions, a try
Message-ID: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


15 partitions (at least for sd_mod devices) are too few.

So I tried the following: after scanning the disk (sda), when we know
the number of partitions P on a disk, create a new block device
/dev/gd0 that is a copy of sda (in terms of disk->queue, etc.). This
is done using alloc_disk(P).

However, read() on gd0 will just return 0. It takes a `blockdev --rereadpt
/dev/gd0` before the disk is accessible. And if I add a call to
rescan inside gpdisk_new() it oopses (probably rightfully so). I do not 
know all the block layer magic, so expect some horrible code.

Ideas, hints, anything is welcome.

---
 block/Makefile        |    1 
 block/genhd.c         |    5 +
 block/gpdisk.c        |  139 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c     |    1 
 fs/partitions/check.c |   19 ++++++
 include/linux/genhd.h |   16 +++++
 include/scsi/sd.h     |    3 +
 7 files changed, 182 insertions(+), 2 deletions(-)

Index: linux-2.6.23/block/Makefile
===================================================================
--- linux-2.6.23.orig/block/Makefile
+++ linux-2.6.23/block/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_BLOCK) := elevator.o ll_rw_blk.o ioctl.o genhd.o scsi_ioctl.o
+obj-${CONFIG_BLOCK} += gpdisk.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
Index: linux-2.6.23/block/genhd.c
===================================================================
--- linux-2.6.23.orig/block/genhd.c
+++ linux-2.6.23/block/genhd.c
@@ -744,6 +744,9 @@ struct gendisk *alloc_disk_node(int mino
 		rand_initialize_disk(disk);
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
+		atomic_set(&disk->gpdisk_enabled, false);
+		disk->gpdisk         = NULL;
+		disk->gpdisk_parent  = NULL;
 	}
 	return disk;
 }
@@ -793,6 +796,8 @@ EXPORT_SYMBOL(set_device_ro);
 void set_disk_ro(struct gendisk *disk, int flag)
 {
 	int i;
+	if (gpdisk_online(disk))
+		set_disk_ro(disk->gpdisk, flag);
 	disk->policy = flag;
 	for (i = 0; i < disk->minors - 1; i++)
 		if (disk->part[i]) disk->part[i]->policy = flag;
Index: linux-2.6.23/block/gpdisk.c
===================================================================
--- /dev/null
+++ linux-2.6.23/block/gpdisk.c
@@ -0,0 +1,139 @@
+#include <linux/genhd.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#define MINOR_IS_ALLOCATED ((void *)0xB4C4)
+
+static unsigned int gpdisk_major = 0;
+module_param(gpdisk_major, uint, S_IRUGO);
+
+static LIST_HEAD(gpdisk_regions);
+static DEFINE_SPINLOCK(gpdisk_region_lock);
+static DEFINE_SPINLOCK(gpdisk_id_lock);
+static DEFINE_IDR(gpdisk_id_idr);
+
+static unsigned int gpdisk_first_minor = 0;
+
+static int gpdisk_get_region(unsigned int size)
+{
+	/* still to be done */
+	unsigned int old;
+
+	old = gpdisk_first_minor;
+	gpdisk_first_minor += size;
+	return old;
+}
+
+static void gpdisk_put_region(unsigned int start, unsigned int n)
+{
+	/* same */
+}
+
+static int gpdisk_get_diskid(void)
+{
+	int new_id, ret;
+
+ again:
+	ret = idr_pre_get(&gpdisk_id_idr, GFP_KERNEL);
+	if (ret == 0)
+		return -ENOMEM;
+
+	spin_lock(&gpdisk_id_lock);
+	ret = idr_get_new(&gpdisk_id_idr, MINOR_IS_ALLOCATED, &new_id);
+	if (ret == -EAGAIN) {
+		spin_unlock(&gpdisk_id_lock);
+		cond_resched();
+		goto again;
+	}
+	if (ret != 0)
+		goto out;
+
+	ret = new_id;
+ out:
+	spin_unlock(&gpdisk_id_lock);
+	return ret;
+}
+
+static void gpdisk_put_diskid(unsigned int id)
+{
+	idr_remove(&gpdisk_id_idr, id);
+}
+
+void gpdisk_new(struct gendisk *disk, unsigned int minors)
+{
+	struct block_device *bdev;
+	struct gendisk *gpdisk;
+	int disk_id, minor_start;
+
+	gpdisk = alloc_disk(minors);
+	if (gpdisk == NULL)
+		return;
+
+	disk_id = gpdisk_get_diskid();
+	if (disk_id < 0)
+		goto out;
+
+	minor_start = gpdisk_get_region(minors);
+	if (minor_start < 0)
+		goto out2;
+
+	disk->gpdisk          = gpdisk;
+	disk->gpdisk_id       = disk_id;
+
+	sprintf(gpdisk->disk_name, "gd%u", disk_id);
+	gpdisk->gpdisk_parent = disk;
+	gpdisk->major         = gpdisk_major;
+	gpdisk->first_minor   = minor_start;
+	gpdisk->minors        = minors;
+	gpdisk->fops          = disk->fops;
+
+	/* safe? */
+	gpdisk->private_data  = disk->private_data;
+	gpdisk->queue         = disk->queue;
+	gpdisk->driverfs_dev  = disk->driverfs_dev;
+	gpdisk->flags         = disk->flags;
+
+	add_disk(gpdisk);
+	return;
+
+ out2:
+	gpdisk_put_diskid(disk_id);
+ out:
+	put_disk(gpdisk);
+	return;
+}
+
+void gpdisk_release(struct gendisk *disk)
+{
+	gpdisk_put_region(disk->gpdisk->first_minor, disk->gpdisk->minors);
+	gpdisk_put_diskid(disk->gpdisk_id);
+}
+
+static int __init gpdisk_init(void)
+{
+	int i;
+
+	i = register_blkdev(gpdisk_major, "gpdisk");
+	if (gpdisk_major == 0) {
+		/* dynamic major */
+		if (i == 0)
+			return -ENODEV;
+		gpdisk_major = i;
+	} else {
+		/* fixed major */
+		if (i != 0)
+			return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __exit gpdisk_exit(void)
+{
+	unregister_blkdev(gpdisk_major, "gpdisk");
+}
+
+module_init(gpdisk_init);
+module_exit(gpdisk_exit);
Index: linux-2.6.23/drivers/scsi/sd.c
===================================================================
--- linux-2.6.23.orig/drivers/scsi/sd.c
+++ linux-2.6.23/drivers/scsi/sd.c
@@ -1610,6 +1610,7 @@ static int sd_probe(struct device *dev)
 	gd = alloc_disk(16);
 	if (!gd)
 		goto out_free;
+	atomic_set(&gd->gpdisk_enabled, true);
 
 	if (!idr_pre_get(&sd_index_idr, GFP_KERNEL))
 		goto out_put;
Index: linux-2.6.23/fs/partitions/check.c
===================================================================
--- linux-2.6.23.orig/fs/partitions/check.c
+++ linux-2.6.23/fs/partitions/check.c
@@ -168,7 +168,7 @@ check_partition(struct gendisk *hd, stru
 	if (isdigit(state->name[strlen(state->name)-1]))
 		sprintf(state->name, "p");
 
-	state->limit = hd->minors;
+	state->limit = MAX_PART;
 	i = res = err = 0;
 	while (!res && check_part[i]) {
 		memset(&state->parts, 0, sizeof(state->parts));
@@ -528,6 +528,7 @@ exit:
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
+	unsigned int max;
 	int p, res;
 
 	if (bdev->bd_part_count)
@@ -536,6 +537,11 @@ int rescan_partitions(struct gendisk *di
 	if (res)
 		return res;
 	bdev->bd_invalidated = 0;
+	if (gpdisk_online(disk)) {
+		gpdisk_release(disk);
+		del_gendisk(disk->gpdisk);
+		disk->gpdisk = NULL;
+	}
 	for (p = 1; p < disk->minors; p++)
 		delete_partition(disk, p);
 	if (disk->fops->revalidate_disk)
@@ -544,7 +550,8 @@ int rescan_partitions(struct gendisk *di
 		return 0;
 	if (IS_ERR(state))	/* I/O error reading the partition table */
 		return -EIO;
-	for (p = 1; p < state->limit; p++) {
+	max = min(disk->minors, state->next);
+	for (p = 1; p < max; p++) {
 		sector_t size = state->parts[p].size;
 		sector_t from = state->parts[p].from;
 		if (!size)
@@ -560,6 +567,8 @@ int rescan_partitions(struct gendisk *di
 #endif
 	}
 	kfree(state);
+	if (atomic_read(&disk->gpdisk_enabled) > 0)
+		gpdisk_new(disk, state->next);
 	return 0;
 }
 
@@ -588,6 +597,12 @@ void del_gendisk(struct gendisk *disk)
 {
 	int p;
 
+	if (gpdisk_online(disk)) {
+		gpdisk_release(disk);
+		del_gendisk(disk->gpdisk);
+		disk->gpdisk = NULL;
+	}
+
 	/* invalidate stuff */
 	for (p = disk->minors - 1; p > 0; p--) {
 		invalidate_partition(disk, p);
Index: linux-2.6.23/include/linux/genhd.h
===================================================================
--- linux-2.6.23.orig/include/linux/genhd.h
+++ linux-2.6.23/include/linux/genhd.h
@@ -67,6 +67,7 @@ struct partition {
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <asm/atomic.h>
 
 struct partition {
 	unsigned char boot_ind;		/* 0x80 - active */
@@ -141,6 +142,10 @@ struct gendisk {
 	struct disk_stats dkstats;
 #endif
 	struct work_struct async_notify;
+
+	struct gendisk *gpdisk, *gpdisk_parent;
+	unsigned int gpdisk_id;
+	atomic_t gpdisk_enabled;
 };
 
 /* Structure for sysfs attributes on block devices */
@@ -255,11 +260,22 @@ static inline sector_t get_capacity(stru
 {
 	return disk->capacity;
 }
+
+static inline bool gpdisk_online(const struct gendisk *disk)
+{
+	return atomic_read(&disk->gpdisk_enabled) > 0 && disk->gpdisk != NULL;
+}
+
 static inline void set_capacity(struct gendisk *disk, sector_t size)
 {
 	disk->capacity = size;
+	if (gpdisk_online(disk))
+		disk->gpdisk->capacity = size;
 }
 
+extern void gpdisk_new(struct gendisk *, unsigned int);
+extern void gpdisk_release(struct gendisk *);
+
 #endif  /*  __KERNEL__  */
 
 #ifdef CONFIG_SOLARIS_X86_PARTITION
Index: linux-2.6.23/include/scsi/sd.h
===================================================================
--- linux-2.6.23.orig/include/scsi/sd.h
+++ linux-2.6.23/include/scsi/sd.h
@@ -62,6 +62,9 @@ static void sd_print_sense_hdr(struct sc
 static void sd_print_result(struct scsi_disk *, int);
 
 #define sd_printk(prefix, sdsk, fmt, a...)				\
+	gpdisk_online((sdsk)->disk) ?					\
+	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
+		    (sdsk)->disk->gpdisk->disk_name, ##a) :		\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
 		    (sdsk)->disk->disk_name, ##a) :			\
