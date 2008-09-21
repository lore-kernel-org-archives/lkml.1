Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYIUASr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYIUASr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 20:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYIUASg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 20:18:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32779 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYIUASf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 20:18:35 -0400
To: jens.axboe@oracle.com, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH] md: Add support for data integrity to MD
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Date: Sat, 20 Sep 2008 20:18:27 -0400
Message-ID: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If all subdevices support the same protection format the MD device is
flagged as capable.

Depends on d7533ad0e132f92e75c1b2eb7c26387b25a583c1 being reverted.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/md.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 45521da..b038581 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3497,7 +3497,7 @@ static int do_md_run(mddev_t * mddev)
 	int err;
 	int chunk_size;
 	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *prev;
 	struct gendisk *disk;
 	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
@@ -3759,6 +3759,35 @@ static int do_md_run(mddev_t * mddev)
 	sysfs_notify(&mddev->kobj, NULL, "sync_action");
 	sysfs_notify(&mddev->kobj, NULL, "degraded");
 	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+
+	/* Data integrity passthrough not supported on RAID 4, 5 and 6 */
+	if (pers->level >= 4 && pers->level <= 6)
+		return 0;
+
+	prev = NULL;
+
+	rdev_for_each(rdev, tmp, mddev) {
+
+		if (prev && blk_integrity_compare(prev->bdev, rdev->bdev) < 0) {
+			printk(KERN_ERR "%s: %s %s Integrity mismatch!\n",
+			       __func__, prev->bdev->bd_disk->disk_name,
+			       rdev->bdev->bd_disk->disk_name);
+			return 0;
+		}
+
+		prev = rdev;
+	}
+
+	if (prev && bdev_get_integrity(prev->bdev)) {
+
+		if (blk_integrity_register(disk, prev->bdev->bd_disk->integrity))
+			printk(KERN_ERR "%s: %s Could not register integrity!\n",
+			       __func__, disk->disk_name);
+		else
+			printk(KERN_INFO "Enabling data integrity on %s\n",
+			       disk->disk_name);
+	}
+
 	return 0;
 }
 
@@ -3947,6 +3976,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
+	blk_integrity_unregister(disk);
 	md_new_event(mddev);
 	sysfs_notify(&mddev->kobj, NULL, "array_state");
 out:
-- 
1.5.5.1



