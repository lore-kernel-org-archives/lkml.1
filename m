Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYGNGGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYGNGGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYGNGG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:06:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:60167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYGNGG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:06:26 -0400
Message-ID: <487AECD0.5010602@kernel.org>
Date: Mon, 14 Jul 2008 15:06:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] block: fix block_class iteration locking
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Jul 2008 06:06:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

genhd.c used block_class_lock when it wants to iterate over
block_class.devices list.  This is incorrect as block_class_lock has
nothing to do with synchronization around block_class.devices list, so
there's a window, albeit small, where the list can change while it's
being iterated over.  Fix it by using block_class.sem instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b922d48..b646e7e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -234,7 +234,7 @@ void __init printk_all_partitions(void)
 	char buf[BDEVNAME_SIZE];
 	int n;
 
-	mutex_lock(&block_class_lock);
+	down(&block_class.sem);
 	/* For each block device... */
 	list_for_each_entry(dev, &block_class.devices, node) {
 		if (dev->type != &disk_type)
@@ -275,7 +275,7 @@ void __init printk_all_partitions(void)
 		}
 	}
 
-	mutex_unlock(&block_class_lock);
+	up(&block_class.sem);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -285,7 +285,7 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 	loff_t k = *pos;
 	struct device *dev;
 
-	mutex_lock(&block_class_lock);
+	down(&block_class.sem);
 	list_for_each_entry(dev, &block_class.devices, node) {
 		if (dev->type != &disk_type)
 			continue;
@@ -311,7 +311,7 @@ static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 
 static void part_stop(struct seq_file *part, void *v)
 {
-	mutex_unlock(&block_class_lock);
+	up(&block_class.sem);
 }
 
 static int show_partition(struct seq_file *part, void *v)
@@ -533,7 +533,7 @@ static void *diskstats_start(struct seq_file *part, loff_t *pos)
 	loff_t k = *pos;
 	struct device *dev;
 
-	mutex_lock(&block_class_lock);
+	down(&block_class.sem);
 	list_for_each_entry(dev, &block_class.devices, node) {
 		if (dev->type != &disk_type)
 			continue;
@@ -560,7 +560,7 @@ static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 
 static void diskstats_stop(struct seq_file *part, void *v)
 {
-	mutex_unlock(&block_class_lock);
+	up(&block_class.sem);
 }
 
 static int diskstats_show(struct seq_file *s, void *v)
@@ -658,7 +658,7 @@ dev_t blk_lookup_devt(const char *name, int part)
 	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
 
-	mutex_lock(&block_class_lock);
+	down(&block_class.sem);
 	list_for_each_entry(dev, &block_class.devices, node) {
 		if (dev->type != &disk_type)
 			continue;
@@ -671,7 +671,7 @@ dev_t blk_lookup_devt(const char *name, int part)
 			break;
 		}
 	}
-	mutex_unlock(&block_class_lock);
+	up(&block_class.sem);
 
 	return devt;
 }
-- 
1.5.4.5

