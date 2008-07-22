Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbYGVFer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbYGVFer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYGVFYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbYGVFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 39/79] block: make /proc/partitions and /proc/diskstats use class_find_device()
Date: Mon, 21 Jul 2008 22:19:03 -0700
Message-Id: <1216703983-21448-39-git-send-email-gregkh@suse.de>
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
 block/genhd.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 70f1d70..c13cc77 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -317,17 +317,21 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 	return NULL;
 }
 
+static int find_next(struct device *dev, void *data)
+{
+	if (dev->type == &disk_type)
+		return 1;
+	return 0;
+}
+
 static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 {
 	struct gendisk *gp = v;
 	struct device *dev;
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
-		if (&dev->node == &block_class.devices)
-			return NULL;
-		if (dev->type == &disk_type)
-			return dev_to_disk(dev);
-	}
+	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
+	if (dev)
+		return dev_to_disk(dev);
 	return NULL;
 }
 
@@ -578,12 +582,9 @@ static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 	struct device *dev;
 
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
-		if (&dev->node == &block_class.devices)
-			return NULL;
-		if (dev->type == &disk_type)
-			return dev_to_disk(dev);
-	}
+	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
+	if (dev)
+		return dev_to_disk(dev);
 	return NULL;
 }
 
-- 
1.5.6.3

