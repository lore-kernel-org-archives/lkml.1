Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYHURk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYHURk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760839AbYHURjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:39:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:34438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760126AbYHURju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:39:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/15] block: drop references taken by class_find_device()
Date: Thu, 21 Aug 2008 10:32:59 -0700
Message-Id: <1219339983-9634-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Otherwise we leak references, which is not a good thing to do.


Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index f34befc..656c2c7 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -313,8 +313,10 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 
 	mutex_lock(&block_class_lock);
 	dev = class_find_device(&block_class, NULL, &k, find_start);
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return dev_to_disk(dev);
+	}
 	return NULL;
 }
 
@@ -331,8 +333,10 @@ static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 	struct device *dev;
 	++*pos;
 	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return dev_to_disk(dev);
+	}
 	return NULL;
 }
 
@@ -573,8 +577,10 @@ static void *diskstats_start(struct seq_file *part, loff_t *pos)
 
 	mutex_lock(&block_class_lock);
 	dev = class_find_device(&block_class, NULL, &k, find_start);
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return dev_to_disk(dev);
+	}
 	return NULL;
 }
 
@@ -585,8 +591,10 @@ static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 
 	++*pos;
 	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return dev_to_disk(dev);
+	}
 	return NULL;
 }
 
@@ -714,10 +722,12 @@ dev_t blk_lookup_devt(const char *name, int part)
 	mutex_lock(&block_class_lock);
 	find.name = name;
 	find.part = part;
-	dev = class_find_device(&block_class, NULL, (void *)&find, match_id);
-	if (dev)
+	dev = class_find_device(&block_class, NULL, &find, match_id);
+	if (dev) {
+		put_device(dev);
 		devt = MKDEV(MAJOR(dev->devt),
 			     MINOR(dev->devt) + part);
+	}
 	mutex_unlock(&block_class_lock);
 
 	return devt;
-- 
1.5.6.5

