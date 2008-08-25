Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYHYJS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYHYJS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYHYJRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:17:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53155 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYHYJRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:17:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Abdel Benamrouche <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] block: use class_dev_iterator instead of class_for_each_device()
Date: Mon, 25 Aug 2008 18:15:38 +0900
Message-Id: <1219655740-11672-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219655740-11672-1-git-send-email-tj@kernel.org>
References: <1219655740-11672-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 Aug 2008 09:17:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent block_class iteration updates 5c6f35c5..27f3025 converted all
class device iteration to class_for_each_device() and
class_find_device(), which are correct but pain in the ass to use.
This pach converts them to newly introduced class_dev_iterator so that
they can use more natural control structures instead of separate
callbacks and struct to pass parameters to them.

This results in smaller and easier code.

This patch also restores the original behavior of not printing header
in /proc/partitions if there's no partition to print.  This is trivial
but still user-visible behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |  239 +++++++++++++++++++++++---------------------------------
 1 files changed, 98 insertions(+), 141 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5a1511e..e9d60fd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -228,113 +228,113 @@ struct gendisk *get_gendisk(dev_t devt, int *part)
 }
 
 /*
- * print a partitions - intended for places where the root filesystem can't be
- * mounted and thus to give the victim some idea of what went wrong
- */
-static int printk_partition(struct device *dev, void *data)
-{
-	struct gendisk *sgp;
-	char buf[BDEVNAME_SIZE];
-	int n;
-
-	if (dev->type != &disk_type)
-		return 0;
-
-	sgp = dev_to_disk(dev);
-	/*
-	 * Don't show empty devices or things that have been surpressed
-	 */
-	if (get_capacity(sgp) == 0 ||
-	    (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO))
-		return 0;
-
-	/*
-	 * Note, unlike /proc/partitions, I am showing the numbers in
-	 * hex - the same format as the root= option takes.
-	 */
-	printk("%02x%02x %10llu %s",
-		sgp->major, sgp->first_minor,
-		(unsigned long long)get_capacity(sgp) >> 1,
-		disk_name(sgp, 0, buf));
-	if (sgp->driverfs_dev != NULL &&
-	    sgp->driverfs_dev->driver != NULL)
-		printk(" driver: %s\n",
-			sgp->driverfs_dev->driver->name);
-	else
-		printk(" (driver?)\n");
-
-	/* now show the partitions */
-	for (n = 0; n < sgp->minors - 1; ++n) {
-		if (sgp->part[n] == NULL)
-			continue;
-		if (sgp->part[n]->nr_sects == 0)
-			continue;
-		printk("  %02x%02x %10llu %s\n",
-			sgp->major, n + 1 + sgp->first_minor,
-			(unsigned long long)sgp->part[n]->nr_sects >> 1,
-			disk_name(sgp, n + 1, buf));
-	}
-
-	return 0;
-}
-
-/*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
  * went wrong
  */
 void __init printk_all_partitions(void)
 {
-	class_for_each_device(&block_class, NULL, NULL, printk_partition);
+	struct class_dev_iter iter;
+	struct device *dev;
+
+	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
+	while ((dev = class_dev_iter_next(&iter))) {
+		struct gendisk *disk = dev_to_disk(dev);
+		char buf[BDEVNAME_SIZE];
+		int n;
+
+		/*
+		 * Don't show empty devices or things that have been
+		 * surpressed
+		 */
+		if (get_capacity(disk) == 0 ||
+		    (disk->flags & GENHD_FL_SUPPRESS_PARTITION_INFO))
+			continue;
+
+		/*
+		 * Note, unlike /proc/partitions, I am showing the
+		 * numbers in hex - the same format as the root=
+		 * option takes.
+		 */
+		printk("%02x%02x %10llu %s",
+		       disk->major, disk->first_minor,
+		       (unsigned long long)get_capacity(disk) >> 1,
+		       disk_name(disk, 0, buf));
+		if (disk->driverfs_dev != NULL &&
+		    disk->driverfs_dev->driver != NULL)
+			printk(" driver: %s\n",
+			       disk->driverfs_dev->driver->name);
+		else
+			printk(" (driver?)\n");
+
+		/* now show the partitions */
+		for (n = 0; n < disk->minors - 1; ++n) {
+			if (disk->part[n] == NULL)
+				continue;
+			if (disk->part[n]->nr_sects == 0)
+				continue;
+			printk("  %02x%02x %10llu %s\n",
+			       disk->major, n + 1 + disk->first_minor,
+			       (unsigned long long)disk->part[n]->nr_sects >> 1,
+			       disk_name(disk, n + 1, buf));
+		}
+	}
+	class_dev_iter_exit(&iter);
 }
 
 #ifdef CONFIG_PROC_FS
 /* iterator */
-static int find_start(struct device *dev, void *data)
+static void *disk_seqf_start(struct seq_file *seqf, loff_t *pos)
 {
-	loff_t *k = (loff_t *)data;
+	loff_t skip = *pos;
+	struct class_dev_iter *iter;
+	struct device *dev;
 
-	if (dev->type != &disk_type)
-		return 0;
-	if (!(*k)--)
-		return 1;
-	return 0;
+	iter = kmalloc(GFP_KERNEL, sizeof(*iter));
+	if (!iter)
+		return ERR_PTR(-ENOMEM);
+
+	seqf->private = iter;
+	class_dev_iter_init(iter, &block_class, NULL, &disk_type);
+	do {
+		dev = class_dev_iter_next(iter);
+		if (!dev)
+			return NULL;
+	} while (skip--);
+
+	return dev_to_disk(dev);
 }
 
-static void *part_start(struct seq_file *part, loff_t *pos)
+static void *disk_seqf_next(struct seq_file *seqf, void *v, loff_t *pos)
 {
 	struct device *dev;
-	loff_t n = *pos;
-
-	if (!n)
-		seq_puts(part, "major minor  #blocks  name\n\n");
 
-	dev = class_find_device(&block_class, NULL, &n, find_start);
+	(*pos)++;
+	dev = class_dev_iter_next(seqf->private);
 	if (dev)
 		return dev_to_disk(dev);
 	return NULL;
 }
 
-static int find_next(struct device *dev, void *data)
+static void disk_seqf_stop(struct seq_file *seqf, void *v)
 {
-	if (dev->type == &disk_type)
-		return 1;
-	return 0;
-}
+	struct class_dev_iter *iter = seqf->private;
 
-static void *part_next(struct seq_file *part, void *v, loff_t *pos)
-{
-	struct gendisk *gp = v;
-	struct device *dev;
-	++*pos;
-	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
-	if (dev)
-		return dev_to_disk(dev);
-	return NULL;
+	/* stop is called even after start failed :-( */
+	if (iter) {
+		class_dev_iter_exit(iter);
+		kfree(iter);
+	}
 }
 
-static void part_stop(struct seq_file *part, void *v)
+static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
 {
+	static void *p;
+
+	p = disk_seqf_start(seqf, pos);
+	if (!IS_ERR(p) && p)
+		seq_puts(part, "major minor  #blocks  name\n\n");
+	return p;
 }
 
 static int show_partition(struct seq_file *part, void *v)
@@ -370,9 +370,9 @@ static int show_partition(struct seq_file *part, void *v)
 }
 
 const struct seq_operations partitions_op = {
-	.start	= part_start,
-	.next	= part_next,
-	.stop	= part_stop,
+	.start	= show_partition_start,
+	.next	= disk_seqf_next,
+	.stop	= disk_seqf_stop,
 	.show	= show_partition
 };
 #endif
@@ -561,34 +561,6 @@ static struct device_type disk_type = {
  * The output looks suspiciously like /proc/partitions with a bunch of
  * extra fields.
  */
-
-static void *diskstats_start(struct seq_file *part, loff_t *pos)
-{
-	struct device *dev;
-	loff_t n = *pos;
-
-	dev = class_find_device(&block_class, NULL, &n, find_start);
-	if (dev)
-		return dev_to_disk(dev);
-	return NULL;
-}
-
-static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
-{
-	struct gendisk *gp = v;
-	struct device *dev;
-
-	++*pos;
-	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
-	if (dev)
-		return dev_to_disk(dev);
-	return NULL;
-}
-
-static void diskstats_stop(struct seq_file *part, void *v)
-{
-}
-
 static int diskstats_show(struct seq_file *s, void *v)
 {
 	struct gendisk *gp = v;
@@ -650,9 +622,9 @@ static int diskstats_show(struct seq_file *s, void *v)
 }
 
 const struct seq_operations diskstats_op = {
-	.start	= diskstats_start,
-	.next	= diskstats_next,
-	.stop	= diskstats_stop,
+	.start	= disk_seqf_start,
+	.next	= disk_seqf_next,
+	.stop	= disk_seqf_stop,
 	.show	= diskstats_show
 };
 #endif /* CONFIG_PROC_FS */
@@ -680,38 +652,23 @@ void genhd_media_change_notify(struct gendisk *disk)
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 #endif  /*  0  */
 
-struct find_block {
-	const char *name;
-	int part;
-};
-
-static int match_id(struct device *dev, void *data)
-{
-	struct find_block *find = data;
-
-	if (dev->type != &disk_type)
-		return 0;
-	if (strcmp(dev->bus_id, find->name) == 0) {
-		struct gendisk *disk = dev_to_disk(dev);
-		if (find->part < disk->minors)
-			return 1;
-	}
-	return 0;
-}
-
 dev_t blk_lookup_devt(const char *name, int part)
 {
-	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
-	struct find_block find;
+	struct class_dev_iter iter;
+	struct device *dev;
 
-	find.name = name;
-	find.part = part;
-	dev = class_find_device(&block_class, NULL, (void *)&find, match_id);
-	if (dev)
-		devt = MKDEV(MAJOR(dev->devt),
-			     MINOR(dev->devt) + part);
+	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
+	while ((dev = class_dev_iter_next(&iter))) {
+		struct gendisk *disk = dev_to_disk(dev);
 
+		if (!strcmp(dev->bus_id, name) && part < disk->minors) {
+			devt = MKDEV(MAJOR(dev->devt),
+				     MINOR(dev->devt) + part);
+			break;
+		}
+	}
+	class_dev_iter_exit(&iter);
 	return devt;
 }
 EXPORT_SYMBOL(blk_lookup_devt);
-- 
1.5.4.5

