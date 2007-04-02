Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbXDBHCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbXDBHCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXDBHCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:02:17 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:38630 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXDBHCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:02:16 -0400
Date: Mon, 2 Apr 2007 09:01:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] show partitions on mount error
In-Reply-To: <20070401224804.ab39b41b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704020808100.1245@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012008590.12316@yvahk01.tjqt.qr>
 <20070401224804.ab39b41b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Apr 1 2007 22:47, Andrew Morton wrote:
>On Sun, 1 Apr 2007 20:15:53 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>> 
>> Display all possible partitions when the root filesystem is not mounted.
>> This helps to track spell'o's and missing drivers.
>> 
>> +void printk_all_partitions(void)
>
>I made this __init.

Seems reasonable.
I have done some additional cleanups, see patch below.


>It would be nice to include a sample of the resulting output for people
>to review.

Loaded with PXELINUX...

	LABEL l
		KERNEL bzImage
		APPEND root=/dev/foobar

or root=/dev/sdb both produce:

[...]
VFS: Cannot open root device "foobar" or unknown-block(0,0)
Please append a correct "root=" boot option; here are the available partitions:
0800    8388608 sda driver: sd
  0801     192748 sda1
  0802    8193150 sda2
0810    4194304 sdb driver: sd
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

With root=/dev/sdb, the list of possible filesystems is also displayed
(a patch that was merged a (long)while back).


---

Integrated __init annotation, and deindented the loop by one level.
Replaces original patch.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/block/genhd.c
===================================================================
--- linux-2.6.21-rc5.orig/block/genhd.c
+++ linux-2.6.21-rc5/block/genhd.c
@@ -215,6 +215,59 @@ struct gendisk *get_gendisk(dev_t dev, i
 	return  kobj ? to_disk(kobj) : NULL;
 }
 
+/*
+ * printk a full list of all partitions - intended for
+ * places where the root filesystem can't be mounted and thus
+ * to give the victim some idea of what went wrong
+ */
+void __init printk_all_partitions(void)
+{
+	int n;
+	struct gendisk *sgp;
+	mutex_lock(&block_subsys_lock);
+
+	/* For each block device... */
+	list_for_each_entry(sgp, &block_subsys.kset.list, kobj.entry) {
+		char buf[BDEVNAME_SIZE];
+		/*
+		 * Don't show empty devices or things that have been surpressed
+		 */
+		if (get_capacity(sgp) == 0 ||
+		  (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO))
+			continue;
+
+		/*
+		 * Note, unlike /proc/partitions, I am showing the numbers in
+		 * hex - the same format as the root= option takes.
+		 */
+		printk("%02x%02x %10llu %s",
+		       sgp->major, sgp->first_minor,
+		       (unsigned long long)get_capacity(sgp) >> 1,
+		       disk_name(sgp, 0, buf));
+		if (sgp->driverfs_dev != NULL &&
+		  sgp->driverfs_dev->driver != NULL)
+			printk(" driver: %s\n",
+			       sgp->driverfs_dev->driver->name);
+		else
+			printk(" (driver?)\n");
+
+		/* now show the partitions */
+		for (n = 0; n < sgp->minors - 1; ++n) {
+			if (sgp->part[n] == NULL)
+				continue;
+			if (sgp->part[n]->nr_sects == 0)
+				continue;
+			printk("  %02x%02x %10llu %s\n",
+			       sgp->major, n + 1 + sgp->first_minor,
+			       (unsigned long long)sgp->part[n]->nr_sects >> 1,
+			       disk_name(sgp, n + 1, buf));
+		} /* partition subloop */
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
