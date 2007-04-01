Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXDASQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXDASQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbXDASQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:16:16 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39636 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933793AbXDASQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:16:08 -0400
Date: Sun, 1 Apr 2007 20:15:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 10/16] show-partitions-on-mount-error.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012008590.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Display all possible partitions when the root filesystem is not mounted.
This helps to track spell'o's and missing drivers.

From: David Alan Gilbert, http://lkml.org/lkml/2005/2/26/92

Updated to work with newer kernels.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 block/genhd.c         |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |    1 
 init/do_mounts.c      |    7 +++++-
 3 files changed, 61 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc5/block/genhd.c
===================================================================
--- linux-2.6.21-rc5.orig/block/genhd.c
+++ linux-2.6.21-rc5/block/genhd.c
@@ -215,6 +215,60 @@ struct gendisk *get_gendisk(dev_t dev, i
 	return  kobj ? to_disk(kobj) : NULL;
 }
 
+/*
+ * printk a full list of all partitions - intended for
+ * places where the root filesystem can't be mounted and thus
+ * to give the victim some idea of what went wrong
+ */
+void printk_all_partitions(void)
+{
+	int n;
+        struct gendisk* sgp;
+	mutex_lock(&block_subsys_lock);
+
+        /* For each block device... */
+	list_for_each_entry(sgp, &block_subsys.kset.list, kobj.entry) {
+		char buf[BDEVNAME_SIZE];
+	  	/*
+	  	 * Don't show empty devices or things that have been surpressed
+	  	 */
+		if (get_capacity(sgp) &&
+		  !(sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)) {
+			/*
+			 * Note, unlike /proc/partitions I am showing the
+			 * numbers in hex in the same format as the root=
+			 * option
+			 */
+			printk("%02x%02x %10llu %s",
+			       sgp->major, sgp->first_minor,
+			       (unsigned long long)get_capacity(sgp) >> 1,
+			       disk_name(sgp, 0, buf));
+			if ((sgp->driverfs_dev) &&
+			  (sgp->driverfs_dev->driver)) {
+				printk(" driver: %s\n",
+				       sgp->driverfs_dev->driver->name);
+			} else {
+				printk(" (driver?)\n");
+			}
+
+			/* now show the partitions */
+			for (n = 0; n < sgp->minors - 1; ++n) {
+				if (!sgp->part[n])
+					continue;
+				if (sgp->part[n]->nr_sects == 0)
+					continue;
+				printk("  %02x%02x %10llu %s\n",
+				       sgp->major, n + 1 + sgp->first_minor,
+				       (unsigned long long)sgp->part[n]->nr_sects >> 1 ,
+				       disk_name(sgp, n + 1, buf));
+			} /* partition subloop */
+		} /* Non 0 size, not surpressed */
+	} /* Block device loop */
+
+	mutex_unlock(&block_subsys_lock);
+	return;
+}
+
 #ifdef CONFIG_PROC_FS
 /* iterator */
 static void *part_start(struct seq_file *part, loff_t *pos)
Index: linux-2.6.21-rc5/include/linux/genhd.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/genhd.h
+++ linux-2.6.21-rc5/include/linux/genhd.h
@@ -413,6 +413,7 @@ char *disk_name (struct gendisk *hd, int
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
 extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
+extern void printk_all_partitions(void);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
Index: linux-2.6.21-rc5/init/do_mounts.c
===================================================================
--- linux-2.6.21-rc5.orig/init/do_mounts.c
+++ linux-2.6.21-rc5/init/do_mounts.c
@@ -7,6 +7,7 @@
 #include <linux/root_dev.h>
 #include <linux/security.h>
 #include <linux/delay.h>
+#include <linux/genhd.h>
 #include <linux/mount.h>
 #include <linux/device.h>
 
@@ -307,17 +308,21 @@ retry:
 	        /*
 		 * Allow the user to distinguish between failed sys_open
 		 * and bad superblock on root device.
+		 * and give them a list of the available devices
 		 */
 #ifdef CONFIG_BLOCK
 		__bdevname(ROOT_DEV, b);
 #endif
 		printk("VFS: Cannot open root device \"%s\" or %s\n",
 				root_device_name, b);
-		printk("Please append a correct \"root=\" boot option\n");
+		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
+		printk_all_partitions();
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
 
+	printk("List of all partitions:\n");
+	printk_all_partitions();
 	printk("No filesystem could mount root, tried: ");
 	for (p = fs_names; *p; p += strlen(p)+1)
 		printk(" %s", p);
#<EOF>
