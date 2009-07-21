Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZGUF4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZGUF4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbZGUF43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:56:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:58914 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833AbZGUF43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:56:29 -0400
To: jens.axboe@oracle.com
Subject: [RESEND][PATCH] Send uevents for disk write_protect changes
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>,
       "device-mapper development" <dm-devel@redhat.com>
Content-Disposition: inline
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Date: Tue, 21 Jul 2009 11:28:07 +0530
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907211128.07252.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch is needed for the dm-multipath, so that the daemon can capture the 
event and reload the dm table when the read-only setting of the disk changes. 
Can this be merged?

Thanks
Nikanth

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


