Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYHBTvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYHBTvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbYHBTvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:51:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:48849 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbYHBTvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=nHuekCFbXIRnV0+s2RnSZ5/aVtiGxF++rj1ESNuYZcRhYMODPimwpt3g0+4aw9tlaN
         b2prONVYqJCO7hqdzs3Weg7qpTlBV0XQ0XXdKsVyUykfXUSf/eiDKn1lQAP1wafEu1LG
         94CXmU3FX7Qw/W44xyUbvPlRND6E8WDsnMv3Q=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: Abdel Benamrouche <draconux@gmail.com>, stable@kernel.org
Subject: [RFC, 2.6.26.2-rc1]  fs/partition/check.c: fix return value warning
Date: Sat, 2 Aug 2008 22:02:47 +0200
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808022202.48079.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d805dda412346225a50af2d399d958a4bc676c38 Mon Sep 17 00:00:00 2001
From: Abdel Benamrouche <draconux@gmail.com>
Date: Fri, 25 Jul 2008 01:48:25 -0700
Subject: [PATCH] fs/partition/check.c: fix return value warning

[ Upstream commit d805dda412346225a50af2d399d958a4bc676c38 ]

fs/partitions/check.c:381: warning: ignoring return value of ___device_add___,
  declared with attribute warn_unused_result

[akpm@linux-foundation.org: multiple-return-statements-per-function are evil]
Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index efef715..2e6413f 100644
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
-		kfree(p);
-		return;
+		err = -ENOMEM;
+		goto out0;
 	}
 	p->start_sect = start;
 	p->nr_sects = len;
@@ -378,15 +378,31 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 
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
+out0:
+	kfree(p);
+	return err;
 }
 
 /* Not exported, helper to add_disk(). */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e878741..118216f 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -541,7 +541,7 @@ extern dev_t blk_lookup_devt(const char *name, int part);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
-extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
+extern int __must_check add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
