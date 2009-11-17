Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZKQS5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZKQS5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZKQS5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:57:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39374 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZKQS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:57:47 -0500
Date: Tue, 17 Nov 2009 18:57:42 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Zeuthen <david@fubar.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091117185742.GA19829@srcf.ucam.org>
References: <1258468659-5446-1-git-send-email-mjg@redhat.com> <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> <1258474180.16176.62.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258474180.16176.62.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. How about something like this? It adds an extra field to the stat 
file and introduces David's suggestion of making it pollable.

commit ba6d4c7ab7940ae8dc11a884281d0a36b20455b9
Author: Matthew Garrett <mjg@redhat.com>
Date:   Mon Nov 16 17:44:03 2009 -0500

    [RFC] Add support for uevents on block device idle changes
    
    Userspace may wish to know whether a given disk is active or idle, for
    example to modify power management policy based on access patterns. This
    patch adds a deferrable timer to the block layer which will fire if the
    disk is idle for a user-definable period of time, generating a uevent. A
    uevent will also be generated if an access is received while the disk is
    classified as idle.

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 5f3beda..8747f42 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -3,7 +3,7 @@ Date:		February 2008
 Contact:	Jerome Marchand <jmarchan@redhat.com>
 Description:
 		The /sys/block/<disk>/stat files displays the I/O
-		statistics of disk <disk>. They contain 11 fields:
+		statistics of disk <disk>. They contain 12 fields:
 		 1 - reads completed succesfully
 		 2 - reads merged
 		 3 - sectors read
@@ -15,6 +15,7 @@ Description:
 		 9 - I/Os currently in progress
 		10 - time spent doing I/Os (ms)
 		11 - weighted time spent doing I/Os (ms)
+		12 - 1 if the disk is idle (determined by idle_hysteresis)
 		For more details refer Documentation/iostats.txt
 
 
@@ -128,3 +129,12 @@ Description:
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
index 517e433..ea37e48 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -504,6 +504,21 @@ static int exact_lock(dev_t devt, void *data)
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
+
+	sysfs_notify(&disk_to_dev(gd)->kobj, NULL, "stat");
+}
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
@@ -543,6 +558,10 @@ void add_disk(struct gendisk *disk)
 
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
+
+	init_timer(&disk->hysteresis_timer);
+	setup_timer(&disk->hysteresis_timer, disk_idle, (unsigned long)disk);
+
 	register_disk(disk);
 	blk_register_queue(disk);
 
@@ -861,6 +880,32 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
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
@@ -870,6 +915,8 @@ static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+static DEVICE_ATTR(idle_hysteresis, 0644, disk_idle_hysteresis_show,
+		   disk_idle_hysteresis_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -890,6 +937,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_idle_hysteresis.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
@@ -1183,6 +1231,8 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 		device_initialize(disk_to_dev(disk));
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
+		INIT_WORK(&disk->idle_notify,
+			  disk_idle_notify_thread);
 	}
 	return disk;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7b685e1..cccfb7d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -230,6 +230,7 @@ ssize_t part_stat_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
+	struct gendisk *gd = dev_to_disk(dev);
 	int cpu;
 
 	cpu = part_stat_lock();
@@ -238,7 +239,7 @@ ssize_t part_stat_show(struct device *dev,
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
-		"%8u %8u %8u"
+		"%8u %8u %8u %1u"
 		"\n",
 		part_stat_read(p, ios[READ]),
 		part_stat_read(p, merges[READ]),
@@ -250,7 +251,8 @@ ssize_t part_stat_show(struct device *dev,
 		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
 		part_in_flight(p),
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
-		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
+		jiffies_to_msecs(part_stat_read(p, time_in_queue)),
+		gd->idle);
 }
 
 ssize_t part_inflight_show(struct device *dev,
@@ -652,6 +654,9 @@ void del_gendisk(struct gendisk *disk)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
+	del_timer_sync(&disk->hysteresis_timer);
+	cancel_work_sync(&disk->idle_notify);
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
Matthew Garrett | mjg59@srcf.ucam.org
