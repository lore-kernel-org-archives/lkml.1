Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZGHIYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZGHIYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 04:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZGHIYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 04:24:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294AbZGHIYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 04:24:16 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: jens.axboe@oracle.com
Subject: [PATCH] Send uevents for disk write_protect changes
Date: Wed, 8 Jul 2009 13:55:52 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.31-rc2-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081355.53226.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Subject: Send uevents for write_protect changes

Whenever a block device changes it's read-only attribute
notify the userspace about it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/genhd.c b/block/genhd.c
index f4c64c2..b89328e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1215,6 +1215,16 @@ void put_disk(struct gendisk *disk)
 
 EXPORT_SYMBOL(put_disk);
 
+static void set_disk_ro_uevent(struct gendisk *gd, int ro)
+{
+	char event[] = "DISK_RO=1";
+	char *envp[] = { event, NULL };
+
+	if (!ro)
+		event[8] = '0';
+	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
+}
+
 void set_device_ro(struct block_device *bdev, int flag)
 {
 	bdev->bd_part->policy = flag;
@@ -1227,8 +1237,12 @@ void set_disk_ro(struct gendisk *disk, int flag)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
-	disk_part_iter_init(&piter, disk,
-			    DISK_PITER_INCL_EMPTY | DISK_PITER_INCL_PART0);
+	if (disk->part0.policy != flag) {
+		set_disk_ro_uevent(disk, flag);
+		disk->part0.policy = flag;
+	}
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter)))
 		part->policy = flag;
 	disk_part_iter_exit(&piter);

