Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYHYJSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYHYJSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbYHYJRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:17:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:53154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbYHYJRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:17:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Abdel Benamrouche <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] block: fix partition info printouts
Date: Mon, 25 Aug 2008 18:15:36 +0900
Message-Id: <1219655740-11672-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219655740-11672-1-git-send-email-tj@kernel.org>
References: <1219655740-11672-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 Aug 2008 09:16:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent block_class iteration updates 5c6f35c5..27f3025 broke partition
info printouts.

* printk_all_partitions(): Partition print out stops when it meets a
  partition hole.  Partition printing inner loop should continue
  instead of exiting on empty partition slot.

* /proc/partitions and /proc/diskstats: If all information can't be
  read in single read(), the information is truncated.  This is
  because find_start() doesn't actually update the counter containing
  the initial seek.  It runs to the end and ends up always reporting
  EOF on the second read.

This patch fixes both problems.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index decc8f1..3a43c1d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -238,7 +238,7 @@ static int printk_partition(struct device *dev, void *data)
 	int n;
 
 	if (dev->type != &disk_type)
-		goto exit;
+		return 0;
 
 	sgp = dev_to_disk(dev);
 	/*
@@ -246,7 +246,7 @@ static int printk_partition(struct device *dev, void *data)
 	 */
 	if (get_capacity(sgp) == 0 ||
 	    (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO))
-		goto exit;
+		return 0;
 
 	/*
 	 * Note, unlike /proc/partitions, I am showing the numbers in
@@ -266,15 +266,15 @@ static int printk_partition(struct device *dev, void *data)
 	/* now show the partitions */
 	for (n = 0; n < sgp->minors - 1; ++n) {
 		if (sgp->part[n] == NULL)
-			goto exit;
+			continue;
 		if (sgp->part[n]->nr_sects == 0)
-			goto exit;
+			continue;
 		printk("  %02x%02x %10llu %s\n",
 			sgp->major, n + 1 + sgp->first_minor,
 			(unsigned long long)sgp->part[n]->nr_sects >> 1,
 			disk_name(sgp, n + 1, buf));
 	}
-exit:
+
 	return 0;
 }
 
@@ -294,11 +294,11 @@ void __init printk_all_partitions(void)
 /* iterator */
 static int find_start(struct device *dev, void *data)
 {
-	loff_t k = *(loff_t *)data;
+	loff_t *k = (loff_t *)data;
 
 	if (dev->type != &disk_type)
 		return 0;
-	if (!k--)
+	if (!(*k)--)
 		return 1;
 	return 0;
 }
@@ -312,7 +312,7 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	mutex_lock(&block_class_lock);
-	dev = class_find_device(&block_class, NULL, (void *)pos, find_start);
+	dev = class_find_device(&block_class, NULL, &n, find_start);
 	if (dev)
 		return dev_to_disk(dev);
 	return NULL;
@@ -569,9 +569,10 @@ static struct device_type disk_type = {
 static void *diskstats_start(struct seq_file *part, loff_t *pos)
 {
 	struct device *dev;
+	loff_t n = *pos;
 
 	mutex_lock(&block_class_lock);
-	dev = class_find_device(&block_class, NULL, (void *)pos, find_start);
+	dev = class_find_device(&block_class, NULL, &n, find_start);
 	if (dev)
 		return dev_to_disk(dev);
 	return NULL;
-- 
1.5.4.5

