Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYHYJRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYHYJRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbYHYJRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:17:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:53151 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbYHYJRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:17:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Abdel Benamrouche <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] block: don't grab block_class_lock unnecessarily
Date: Mon, 25 Aug 2008 18:15:37 +0900
Message-Id: <1219655740-11672-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219655740-11672-1-git-send-email-tj@kernel.org>
References: <1219655740-11672-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 Aug 2008 09:16:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block_class_lock protects major_names array and bdev_map and doesn't
have anything to do with block class devices.  Don't grab them while
iterating over block class devices.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3a43c1d..5a1511e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -285,9 +285,7 @@ static int printk_partition(struct device *dev, void *data)
  */
 void __init printk_all_partitions(void)
 {
-	mutex_lock(&block_class_lock);
 	class_for_each_device(&block_class, NULL, NULL, printk_partition);
-	mutex_unlock(&block_class_lock);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -311,7 +309,6 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 	if (!n)
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
-	mutex_lock(&block_class_lock);
 	dev = class_find_device(&block_class, NULL, &n, find_start);
 	if (dev)
 		return dev_to_disk(dev);
@@ -338,7 +335,6 @@ static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 
 static void part_stop(struct seq_file *part, void *v)
 {
-	mutex_unlock(&block_class_lock);
 }
 
 static int show_partition(struct seq_file *part, void *v)
@@ -571,7 +567,6 @@ static void *diskstats_start(struct seq_file *part, loff_t *pos)
 	struct device *dev;
 	loff_t n = *pos;
 
-	mutex_lock(&block_class_lock);
 	dev = class_find_device(&block_class, NULL, &n, find_start);
 	if (dev)
 		return dev_to_disk(dev);
@@ -592,7 +587,6 @@ static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 
 static void diskstats_stop(struct seq_file *part, void *v)
 {
-	mutex_unlock(&block_class_lock);
 }
 
 static int diskstats_show(struct seq_file *s, void *v)
@@ -711,14 +705,12 @@ dev_t blk_lookup_devt(const char *name, int part)
 	dev_t devt = MKDEV(0, 0);
 	struct find_block find;
 
-	mutex_lock(&block_class_lock);
 	find.name = name;
 	find.part = part;
 	dev = class_find_device(&block_class, NULL, (void *)&find, match_id);
 	if (dev)
 		devt = MKDEV(MAJOR(dev->devt),
 			     MINOR(dev->devt) + part);
-	mutex_unlock(&block_class_lock);
 
 	return devt;
 }
-- 
1.5.4.5

