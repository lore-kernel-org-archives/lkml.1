Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYGVFdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYGVFdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYGVFXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:43119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835AbYGVFXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 34/79] block: make printk_partition use the class iterator function
Date: Mon, 21 Jul 2008 22:18:58 -0700
Message-Id: <1216703983-21448-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper class iterator function instead of mucking around in the
internals of the class structures.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |   95 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3ccf5c0..10b9ac4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -227,58 +227,65 @@ struct gendisk *get_gendisk(dev_t devt, int *part)
 }
 
 /*
- * print a full list of all partitions - intended for places where the root
- * filesystem can't be mounted and thus to give the victim some idea of what
- * went wrong
+ * print a partitions - intended for places where the root filesystem can't be
+ * mounted and thus to give the victim some idea of what went wrong
  */
-void __init printk_all_partitions(void)
+static int printk_partition(struct device *dev, void *data)
 {
-	struct device *dev;
 	struct gendisk *sgp;
 	char buf[BDEVNAME_SIZE];
 	int n;
 
-	mutex_lock(&block_class_lock);
-	/* For each block device... */
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (dev->type != &disk_type)
-			continue;
-		sgp = dev_to_disk(dev);
-		/*
-		 * Don't show empty devices or things that have been surpressed
-		 */
-		if (get_capacity(sgp) == 0 ||
-		    (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO))
-			continue;
+	if (dev->type != &disk_type)
+		goto exit;
 
-		/*
-		 * Note, unlike /proc/partitions, I am showing the numbers in
-		 * hex - the same format as the root= option takes.
-		 */
-		printk("%02x%02x %10llu %s",
-			sgp->major, sgp->first_minor,
-			(unsigned long long)get_capacity(sgp) >> 1,
-			disk_name(sgp, 0, buf));
-		if (sgp->driverfs_dev != NULL &&
-		    sgp->driverfs_dev->driver != NULL)
-			printk(" driver: %s\n",
-				sgp->driverfs_dev->driver->name);
-		else
-			printk(" (driver?)\n");
-
-		/* now show the partitions */
-		for (n = 0; n < sgp->minors - 1; ++n) {
-			if (sgp->part[n] == NULL)
-				continue;
-			if (sgp->part[n]->nr_sects == 0)
-				continue;
-			printk("  %02x%02x %10llu %s\n",
-				sgp->major, n + 1 + sgp->first_minor,
-				(unsigned long long)sgp->part[n]->nr_sects >> 1,
-				disk_name(sgp, n + 1, buf));
-		}
+	sgp = dev_to_disk(dev);
+	/*
+	 * Don't show empty devices or things that have been surpressed
+	 */
+	if (get_capacity(sgp) == 0 ||
+	    (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO))
+		goto exit;
+
+	/*
+	 * Note, unlike /proc/partitions, I am showing the numbers in
+	 * hex - the same format as the root= option takes.
+	 */
+	printk("%02x%02x %10llu %s",
+		sgp->major, sgp->first_minor,
+		(unsigned long long)get_capacity(sgp) >> 1,
+		disk_name(sgp, 0, buf));
+	if (sgp->driverfs_dev != NULL &&
+	    sgp->driverfs_dev->driver != NULL)
+		printk(" driver: %s\n",
+			sgp->driverfs_dev->driver->name);
+	else
+		printk(" (driver?)\n");
+
+	/* now show the partitions */
+	for (n = 0; n < sgp->minors - 1; ++n) {
+		if (sgp->part[n] == NULL)
+			goto exit;
+		if (sgp->part[n]->nr_sects == 0)
+			goto exit;
+		printk("  %02x%02x %10llu %s\n",
+			sgp->major, n + 1 + sgp->first_minor,
+			(unsigned long long)sgp->part[n]->nr_sects >> 1,
+			disk_name(sgp, n + 1, buf));
 	}
+exit:
+	return 0;
+}
 
+/*
+ * print a full list of all partitions - intended for places where the root
+ * filesystem can't be mounted and thus to give the victim some idea of what
+ * went wrong
+ */
+void __init printk_all_partitions(void)
+{
+	mutex_lock(&block_class_lock);
+	class_for_each_device(&block_class, NULL, NULL, printk_partition);
 	mutex_unlock(&block_class_lock);
 }
 
-- 
1.5.6.3

