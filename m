Return-Path: <linux-kernel-owner+w=401wt.eu-S1762566AbZLKVVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566AbZLKVVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758903AbZLKVVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:21:03 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35314 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878AbZLKVVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:21:01 -0500
From: Matthew Garrett <mjg@redhat.com>
To: jens.axboe@oracle.com
Cc: pavel@ucw.cz, kay.sievers@vrfy.org, david@fubar.dk,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [RFC] Add support for events on block device idle changes
Date: Fri, 11 Dec 2009 16:20:22 -0500
Message-Id: <1260566422-2194-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091123195000.GK8742@kernel.dk>
References: <20091123195000.GK8742@kernel.dk>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looked into polling and realised that it's not going to work - reducing
the performance hit requires the idle->active transition to be acknowleged
as quickly as possible, so there needs to be an event for that. And for
that to happen, we need to have an idea of whether the disk is idle or not.
That could be done by just performing a comparison of the last request time
against the current time, but it still ends up giving us several of the
same problems.

What I've done in this version is move the timer modification to the
completion, with request submission just performing the timer deletion. This
should make things less expensive than the previous versions of the patch.
I've also added updates to the idle_hysteresis file, which makes it possible
to implement a mechanism for multiple applications with different timeout
requirements. This is somewhat hacky, but avoids putting any more complexity
in fast path code. Thoughts?

--- 

Userspace may wish to know whether a given disk is active or idle, for
example to modify power management policy based on access patterns. This
patch adds a deferrable timer to the block layer which will fire if the
disk is idle for a user-definable period of time, generating a
notification event on the device's stat node. An event will also be
generated if an access is received while the disk is classified as idle.

 Documentation/ABI/testing/sysfs-block |   49 +++++++++++++++++++++++++++++-
 block/blk-core.c                      |    5 +++
 block/elevator.c                      |    7 ++++
 block/genhd.c                         |   54 +++++++++++++++++++++++++++++++++
 fs/partitions/check.c                 |    9 ++++-
 include/linux/genhd.h                 |    6 ++++
 6 files changed, 127 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 5f3beda..03b411b 100644
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
@@ -15,6 +15,14 @@ Description:
 		 9 - I/Os currently in progress
 		10 - time spent doing I/Os (ms)
 		11 - weighted time spent doing I/Os (ms)
+		12 - -1 if the disk is active, otherwise the length of time in
+		     milliseconds since the disk became idle (determined by
+		     the idle_hysteresis setting)
+
+		Applications that call poll() or select() on this attribute
+		will be woken when the block device undergoes a transition
+		between active and idle.
+
 		For more details refer Documentation/iostats.txt
 
 
@@ -128,3 +136,42 @@ Description:
 		preferred request size for workloads where sustained
 		throughput is desired.  If no optimal I/O size is
 		reported this file contains 0.
+
+What:		/sys/block/<disk>/idle_hysteresis
+Date:		November 2009
+Contact:	Matthew Garrett <mjg@redhat.com>
+Description:
+		Contains the number of milliseconds to wait after an
+		access before declaring that a disk is idle. Any
+		accesses to the block device during this time will
+		reset the timer. "0" (the default) indicates that no
+		events will be generated. If a value has already been
+		written to this file, then the only valid values are
+		either "0" (to disable notification) or a number
+		smaller than the current value. On write, a
+		notification will be sent to any userspace
+		applications poll()ing on this file.
+
+		The intended use of this interface is to allow
+		applications to change power management policy based
+		on disk activity patterns. The first application to
+		use this interface should write its timeout value and
+		continue monitoring this file along with
+		"stat". Notifications will be sent to the "stat" file
+		when the disk switches from active to idle or
+		vice-versa.
+
+		If more than one application uses this interface, the
+		second application should attempt to write its own
+		timeout. If this fails, it should read the current
+		timeout. It will then be woken on active to idle
+		transitions, at which point it should sleep for the
+		time difference between its desired timeout and the
+		programmed timeout. On waking, it should then re-read
+		the "state" file to determine if the disk has been
+		idle for long enough.
+
+		If the write is successful, then the first application
+		to use the interface will be woken instead. It should
+		then modify its wakeup code to match the above
+		description.
diff --git a/block/blk-core.c b/block/blk-core.c
index 10e305f..16b501a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2115,6 +2115,11 @@ static void blk_finish_request(struct request *req, int error)
 	if (unlikely(laptop_mode) && blk_fs_request(req))
 		laptop_io_completion(req);
 
+	if (blk_fs_request(req) && req->rq_disk->hysteresis_time)
+		mod_timer(&req->rq_disk->hysteresis_timer,
+			  jiffies+msecs_to_jiffies
+			  (req->rq_disk->hysteresis_time));
+
 	blk_delete_timer(req);
 
 	blk_account_io_done(req);
diff --git a/block/elevator.c b/block/elevator.c
index a847046..01f0bfb 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -683,6 +683,13 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		BUG();
 	}
 
+	if (blk_fs_request(rq) && rq->rq_disk->hysteresis_time &&
+	    rq->rq_disk->idle) {
+		rq->rq_disk->idle = 0;
+		del_timer(&rq->rq_disk->hysteresis_timer);
+		schedule_work(&rq->rq_disk->idle_notify);
+	}
+
 	if (unplug_it && blk_queue_plugged(q)) {
 		int nrq = q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC]
 				- queue_in_flight(q);
diff --git a/block/genhd.c b/block/genhd.c
index 517e433..802c142 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -504,6 +504,21 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
+static void disk_idle(unsigned long data)
+{
+	struct gendisk *gd = (struct gendisk *)data;
+
+	gd->idle = jiffies;
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
 
@@ -861,6 +880,36 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
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
+	if (disk->hysteresis_time && timeout > disk->hysteresis_time)
+		return -EINVAL;
+
+	disk->hysteresis_time = timeout;
+	sysfs_notify(&dev->kobj, NULL, "idle_hysteresis");
+
+	return count;
+}
+
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -870,6 +919,8 @@ static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+static DEVICE_ATTR(idle_hysteresis, 0644, disk_idle_hysteresis_show,
+		   disk_idle_hysteresis_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -890,6 +941,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_idle_hysteresis.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
@@ -1183,6 +1235,8 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 		device_initialize(disk_to_dev(disk));
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
+		INIT_WORK(&disk->idle_notify,
+			  disk_idle_notify_thread);
 	}
 	return disk;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7b685e1..954dc32 100644
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
+		"%8u %8u %8u %8d"
 		"\n",
 		part_stat_read(p, ios[READ]),
 		part_stat_read(p, merges[READ]),
@@ -250,7 +251,8 @@ ssize_t part_stat_show(struct device *dev,
 		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
 		part_in_flight(p),
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
-		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
+		jiffies_to_msecs(part_stat_read(p, time_in_queue)),
+		gd->idle ? jiffies_to_msecs(jiffies - gd->idle) : -1);
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
index 297df45..b8e6158 100644
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
+	unsigned long idle;
+	int hysteresis_time;
+	struct timer_list hysteresis_timer;
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
-- 
1.6.5.2

