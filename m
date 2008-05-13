Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbYEMUDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbYEMUDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbYEMUCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:02:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:60756 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbYEMUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:02:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vPLkJjo2ZlMaj5FABdIsk39wCiaq6h877L7QysUfrhTa2fm3fDU0TjNwAgUMbCb8sD73u62P1gN74d/rnqM2Pze3kDQGQ3RIFXgtOkpV6ntgVV/hdJs0TiPWcqu7cejvA96FfVSBqdzCfO+p18NUrdHJOy4gaSnnRj6vZyC/aYg=
From: Abdel Benamrouche <draconux@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Abdel Benamrouche <draconux@gmail.com>
Subject: [PATCH 1/2] /fs/partition/check.c : fix return value warning (V2)
Date: Tue, 13 May 2008 22:02:44 +0200
Message-Id: <1210708965-12220-2-git-send-email-draconux@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/partitions/check.c:381: warning: ignoring return value of ___device_add___,
  declared with attribute warn_unused_result

Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
---
 fs/partitions/check.c |   25 ++++++++++++++++++++-----
 include/linux/genhd.h |    2 +-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6149e4b..a1396a9 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -344,18 +344,18 @@ static ssize_t whole_disk_show(struct device *dev,
 static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 		   whole_disk_show, NULL);
 
-void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
+int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
 	int err;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return;
+		return -ENOMEM;
 
 	if (!init_part_stats(p)) {
 		kfree(p);
-		return;
+		return -ENOMEM;
 	}
 	p->start_sect = start;
 	p->nr_sects = len;
@@ -378,15 +378,30 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
-	device_add(&p->dev);
+	err = device_add(&p->dev);
+	if (err)
+		goto out1;
 	partition_sysfs_add_subdir(p);
 	p->dev.uevent_suppress = 0;
-	if (flags & ADDPART_FLAG_WHOLEDISK)
+	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		err = device_create_file(&p->dev, &dev_attr_whole_disk);
+		if (err)
+			goto out2;
+	}
 
 	/* suppress uevent if the disk supresses it */
 	if (!disk->dev.uevent_suppress)
 		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+
+	return 0;
+
+out2:
+	device_del(&p->dev);
+out1:
+	put_device(&p->dev);
+	free_part_stats(p);
+	kfree(p);
+	return err;
 }
 
 /* Not exported, helper to add_disk(). */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e9874e7..dd9a37a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -529,7 +529,7 @@ extern dev_t blk_lookup_devt(const char *name);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
-extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
+extern int __must_check add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
-- 
1.5.4.3

