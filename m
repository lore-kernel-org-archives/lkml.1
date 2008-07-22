Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbYGVFeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbYGVFeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYGVFYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:00 -0400
Received: from mail.suse.de ([195.135.220.2]:53882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239AbYGVFX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 37/79] block: make proc files seq_start use the class_find_device()
Date: Mon, 21 Jul 2008 22:19:01 -0700
Message-Id: <1216703983-21448-37-git-send-email-gregkh@suse.de>
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
 block/genhd.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 68a5f28..f03bdad 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -291,18 +291,25 @@ void __init printk_all_partitions(void)
 
 #ifdef CONFIG_PROC_FS
 /* iterator */
+static int find_start(struct device *dev, void *data)
+{
+	loff_t k = *(loff_t *)data;
+
+	if (dev->type != &disk_type)
+		return 0;
+	if (!k--)
+		return 1;
+	return 0;
+}
+
 static void *part_start(struct seq_file *part, loff_t *pos)
 {
-	loff_t k = *pos;
 	struct device *dev;
 
 	mutex_lock(&block_class_lock);
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (dev->type != &disk_type)
-			continue;
-		if (!k--)
-			return dev_to_disk(dev);
-	}
+	dev = class_find_device(&block_class, NULL, (void *)pos, find_start);
+	if (dev)
+		return dev_to_disk(dev);
 	return NULL;
 }
 
@@ -555,16 +562,12 @@ static struct device_type disk_type = {
 
 static void *diskstats_start(struct seq_file *part, loff_t *pos)
 {
-	loff_t k = *pos;
 	struct device *dev;
 
 	mutex_lock(&block_class_lock);
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (dev->type != &disk_type)
-			continue;
-		if (!k--)
-			return dev_to_disk(dev);
-	}
+	dev = class_find_device(&block_class, NULL, (void *)pos, find_start);
+	if (dev)
+		return dev_to_disk(dev);
 	return NULL;
 }
 
-- 
1.5.6.3

