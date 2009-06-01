Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZFAOfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZFAOfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZFAOfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:35:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39977 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZFAOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:35:00 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] FS: filesystem corruption notification
Date: Mon,  1 Jun 2009 17:34:48 +0300
Message-Id: <7ed7ce4308999530ac3b69690ccd0e649970800d.1243863850.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 01 Jun 2009 14:34:56.0137 (UTC) FILETIME=[222A4F90:01C9E2C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic mechnism to notify the userspace about possible filesystem
corruption through sysfs entry (/sys/block/<bdev>/<part>/fs_unclean)
and uevent (KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]).

To mark fs clean (e.g. after fs was fixed by userspace):

echo 0 > /sys/block/<bdev>/<part>/fs_unclean
(you will still receive uevent KOBJ_CHANGE with env var FS_UNCLEAN=0)

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/partitions/check.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |    2 ++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..e1a6221 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -196,6 +196,24 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	return ERR_PTR(res);
 }
 
+void notify_part_fs_unclean(struct device *dev, uint8_t unclean)
+{
+	char event_string[11];
+	char *envp[] = { event_string, NULL };
+
+	if ((unclean != 0 && unclean != 1) ||
+		unclean == dev_to_part(dev)->fs_unclean)
+		return;
+
+	dev_to_part(dev)->fs_unclean = unclean;
+
+	sysfs_notify(&dev->kobj, NULL, "fs_unclean");
+
+	sprintf(event_string, "FS_DIRTY=%u", unclean);
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+}
+EXPORT_SYMBOL(notify_part_fs_unclean);
+
 static ssize_t part_partition_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -246,6 +264,26 @@ ssize_t part_stat_show(struct device *dev,
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
 
+ssize_t part_fs_unclean_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%d\n", p->fs_unclean);
+}
+
+ssize_t part_fs_unclean_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	int i;
+
+	if (count > 0 && sscanf(buf, "%d", &i) > 0)
+		notify_part_fs_unclean(dev, (i == 0) ? 0 : 1);
+
+	return count;
+}
+
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 ssize_t part_fail_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
@@ -273,6 +311,9 @@ static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
+static struct device_attribute dev_attr_fs_unclean =
+	__ATTR(fs_unclean, S_IRUGO|S_IWUSR, part_fs_unclean_show,
+		part_fs_unclean_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -283,6 +324,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
 	&dev_attr_stat.attr,
+	&dev_attr_fs_unclean.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a1a28ca..2e6d42e 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -98,6 +98,7 @@ struct hd_struct {
 #endif
 	unsigned long stamp;
 	int in_flight;
+	int fs_unclean;
 #ifdef	CONFIG_SMP
 	struct disk_stats *dkstats;
 #else
@@ -528,6 +529,7 @@ extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     sector_t len, int flags);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
+extern void notify_part_fs_unclean(struct device *dev, uint8_t unclean);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
-- 
1.6.0.4

