Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZKQOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZKQOip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZKQOio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:38:44 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35334 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZKQOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:38:43 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, linux-hotplug@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] [RFC] Add support for uevents on block device idle changes
Date: Tue, 17 Nov 2009 09:37:39 -0500
Message-Id: <1258468659-5446-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.5.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace may wish to know whether a given disk is active or idle, for
example to modify power management policy based on access patterns. This
patch adds a deferrable timer to the block layer which will fire if the
disk is idle for a user-definable period of time, generating a uevent. A
uevent will also be generated if an access is received while the disk is
classified as idle.

This patch seems to work as designed, but introduces a noticable amount of
userspace overhead in udevd. I'm guessing that this is because change events
on block devices are normally associated with disk removal/insertion, so
a large quantity of complex rules end up getting run in order to deal with
RAID setup or whatever. Is there a better way to deliver these events?
---
 Documentation/ABI/testing/sysfs-block |    9 +++++
 block/blk-core.c                      |    9 +++++
 block/genhd.c                         |   55 +++++++++++++++++++++++++++++++++
 fs/partitions/check.c                 |    3 ++
 include/linux/genhd.h                 |    6 +++
 5 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 5f3beda..5519720 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -128,3 +128,12 @@ Description:
 		preferred request size for workloads where sustained
 		throughput is desired.  If no optimal I/O size is
 		reported this file contains 0.
+
+What:		/sys/block/<disk>/idle_hysteresis
+Date:		November 2009
+Contact:	Matthew Garrett <mjg@redhat.com>
+Description:
+		Contains the number of milliseconds to wait after an access
+		before declaring that a disk is idle. Any accesses during
+		this time will reset the timer. "0" (the default) indicates
+		that no events will be generated.
\ No newline at end of file
diff --git a/block/blk-core.c b/block/blk-core.c
index 71da511..f278817 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1452,6 +1452,15 @@ static inline void __generic_make_request(struct bio *bio)
 		if (should_fail_request(bio))
 			goto end_io;
 
+		if (bio->bi_bdev->bd_disk->hysteresis_time &&
+		    bio_has_data(bio) &&
+		    !mod_timer(&bio->bi_bdev->bd_disk->hysteresis_timer,
+			       jiffies+msecs_to_jiffies
+			       (bio->bi_bdev->bd_disk->hysteresis_time))) {
+			bio->bi_bdev->bd_disk->idle = 0;
+			schedule_work(&bio->bi_bdev->bd_disk->idle_notify);
+		}
+
 		/*
 		 * If this device has partitions, remap block n
 		 * of partition p to block n+start(p) of the disk.
diff --git a/block/genhd.c b/block/genhd.c
index 517e433..f59fbe0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -504,6 +504,26 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
+static void disk_idle(unsigned long data)
+{
+	struct gendisk *gd = (struct gendisk *)data;
+
+	gd->idle = 1;
+	schedule_work(&gd->idle_notify);
+}
+
+static void disk_idle_notify_thread(struct work_struct *work)
+{
+	struct gendisk *gd = container_of(work, struct gendisk, idle_notify);
+	char event[] = "IDLE=0";
+	char *envp[] = { event, NULL };
+
+	if (gd->idle)
+		event[5] = '1';
+
+	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
+}
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
@@ -543,6 +563,10 @@ void add_disk(struct gendisk *disk)
 
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
+
+	init_timer(&disk->hysteresis_timer);
+	setup_timer(&disk->hysteresis_timer, disk_idle, (unsigned long)disk);
+
 	register_disk(disk);
 	blk_register_queue(disk);
 
@@ -861,6 +885,32 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
 	return sprintf(buf, "%d\n", queue_alignment_offset(disk->queue));
 }
 
+static ssize_t disk_idle_hysteresis_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%d\n", disk->hysteresis_time);
+}
+
+static ssize_t disk_idle_hysteresis_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	unsigned long timeout;
+	int res;
+
+	res = strict_strtoul(buf, 10, &timeout);
+	if (res)
+		return -EINVAL;
+
+	disk->hysteresis_time = timeout;
+
+	return count;
+}
+
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -870,6 +920,8 @@ static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+static DEVICE_ATTR(idle_hysteresis, 0644, disk_idle_hysteresis_show,
+		   disk_idle_hysteresis_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -890,6 +942,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_idle_hysteresis.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
@@ -1183,6 +1236,8 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 		device_initialize(disk_to_dev(disk));
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
+		INIT_WORK(&disk->idle_notify,
+			  disk_idle_notify_thread);
 	}
 	return disk;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7b685e1..d55dd29 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -652,6 +652,9 @@ void del_gendisk(struct gendisk *disk)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
+	cancel_work_sync(&disk->idle_notify);
+	del_timer_sync(&disk->hysteresis_timer);
+
 	/* invalidate stuff */
 	disk_part_iter_init(&piter, disk,
 			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 297df45..7e969a5 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kdev_t.h>
 #include <linux/rcupdate.h>
+#include <linux/timer.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -163,10 +164,15 @@ struct gendisk {
 
 	atomic_t sync_io;		/* RAID */
 	struct work_struct async_notify;
+	struct work_struct idle_notify;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
 #endif
 	int node_id;
+
+	bool idle;
+	int hysteresis_time;
+	struct timer_list hysteresis_timer;
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
-- 
1.6.5.2

