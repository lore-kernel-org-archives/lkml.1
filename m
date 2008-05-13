Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYEMUDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYEMUDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759602AbYEMUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:02:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:61925 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222AbYEMUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fxfIXZUcJ5cIfym/BEWCXon9OqtSO5lYAeHoCoenP6est4ej7QPrzAXuKNcl8a/LpZB1hddHjSfGLvpwRMLfhbpXFoM5rts0G5FmWcj1PN4L9M9Bm5LjyDQP/2chdOGF6EuOiOeBptnEn8icnMsrgHaQ7WYfoN5x8Z4thgV+pc4=
From: Abdel Benamrouche <draconux@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Abdel Benamrouche <draconux@gmail.com>
Subject: [PATCH 2/2] /block/ioctl.c and /fs/partition/check.c
Date: Tue, 13 May 2008 22:02:45 +0200
Message-Id: <1210708965-12220-3-git-send-email-draconux@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check value returned by add_partion()

Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
---
 block/ioctl.c         |    5 +++--
 fs/partitions/check.c |    8 +++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 52d6385..77185e5 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -17,6 +17,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	long long start, length;
 	int part;
 	int i;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -61,9 +62,9 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 				}
 			}
 			/* all seems OK */
-			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
+			err = add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
 			mutex_unlock(&bdev->bd_mutex);
-			return 0;
+			return err;
 		case BLKPG_DEL_PARTITION:
 			if (!disk->part[part-1])
 				return -ENXIO;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index a1396a9..94f4e3c 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -500,8 +500,14 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		if (from + size > get_capacity(disk)) {
 			printk(" %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
+			continue;
+		}
+		res = add_partition(disk, p, from, size, state->parts[p].flags);
+		if (res) {
+			printk(" %s: p%d could not be added. got error %d\n",
+				disk->disk_name, p, -res);
+			continue;
 		}
-		add_partition(disk, p, from, size, state->parts[p].flags);
 #ifdef CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags & ADDPART_FLAG_RAID)
 			md_autodetect_dev(bdev->bd_dev+p);
-- 
1.5.4.3

