Return-Path: <linux-kernel-owner+w=401wt.eu-S941538AbXGaCcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941538AbXGaCcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940916AbXGaCX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:23:57 -0400
Received: from smtp.xtech.com.ar ([200.68.115.49]:3887 "EHLO
	motherbox.xtech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940626AbXGaCXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:23:55 -0400
From: Diego Woitasen <diego@woitasen.com.ar>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Diego Woitasen <diego@woitasen.com.ar>
Subject: [PATCH] remove unneded lock_kernel in drivers/md/dm.c and use unlocked_ioctl.
Date: Mon, 30 Jul 2007 23:23:49 -0300
Message-Id: <11858486294133-git-send-email-diego@woitasen.com.ar>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
---
 drivers/md/dm.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 141ff9f..aebb207 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -282,17 +282,16 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
-static int dm_blk_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long dm_blk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md;
 	struct dm_table *map;
 	struct dm_target *tgt;
+	struct inode *inode;
 	int r = -ENOTTY;
 
-	/* We don't really need this lock, but we do need 'inode'. */
-	unlock_kernel();
 
+	inode = file->f_path.dentry->d_inode;
 	md = inode->i_bdev->bd_disk->private_data;
 
 	map = dm_get_table(md);
@@ -317,7 +316,6 @@ static int dm_blk_ioctl(struct inode *inode, struct file *file,
 out:
 	dm_table_put(map);
 
-	lock_kernel();
 	return r;
 }
 
@@ -1550,7 +1548,7 @@ EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
-	.ioctl = dm_blk_ioctl,
+	.unlocked_ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.owner = THIS_MODULE
 };
-- 
1.5.2.4

