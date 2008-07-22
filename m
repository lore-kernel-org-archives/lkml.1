Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYGVFdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYGVFdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbYGVFXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:43123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192AbYGVFXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 35/79] block: make blk_lookup_devt use the class iterator function
Date: Mon, 21 Jul 2008 22:18:59 -0700
Message-Id: <1216703983-21448-35-git-send-email-gregkh@suse.de>
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
 block/genhd.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 10b9ac4..e8c42bf 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -677,24 +677,38 @@ void genhd_media_change_notify(struct gendisk *disk)
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 #endif  /*  0  */
 
+struct find_block {
+	const char *name;
+	int part;
+};
+
+static int match_id(struct device *dev, void *data)
+{
+	struct find_block *find = data;
+
+	if (dev->type != &disk_type)
+		return 0;
+	if (strcmp(dev->bus_id, find->name) == 0) {
+		struct gendisk *disk = dev_to_disk(dev);
+		if (find->part < disk->minors)
+			return 1;
+	}
+	return 0;
+}
+
 dev_t blk_lookup_devt(const char *name, int part)
 {
 	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
+	struct find_block find;
 
 	mutex_lock(&block_class_lock);
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (dev->type != &disk_type)
-			continue;
-		if (strcmp(dev->bus_id, name) == 0) {
-			struct gendisk *disk = dev_to_disk(dev);
-
-			if (part < disk->minors)
-				devt = MKDEV(MAJOR(dev->devt),
-					     MINOR(dev->devt) + part);
-			break;
-		}
-	}
+	find.name = name;
+	find.part = part;
+	dev = class_find_device(&block_class, NULL, (void *)&find, match_id);
+	if (dev)
+		devt = MKDEV(MAJOR(dev->devt),
+			     MINOR(dev->devt) + part);
 	mutex_unlock(&block_class_lock);
 
 	return devt;
-- 
1.5.6.3

