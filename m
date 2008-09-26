Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYIZSxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYIZSxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYIZSxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:53:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:57865 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYIZSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=k+qBOrE7xtEK3cJ2qaLYxwqFj6gE7pmkd3sEsotJMqibL2kpeWMtifIzgoDqmsZoZ3
         fZL/h1MvVQXCshynDgQFnMgGrmpkQVZYpkA5tziAFbsnuUVPC0TYleNuGeIGWOZHLbrk
         N1agtdX3HyzurYUK2SHfvlGoDQv/LhPaFx2l8=
From: Denis ChengRq <crquan@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fs/block_dev.c: __read_mostly improvement and sb_is_blkdev_sb utilization
Date: Sat, 27 Sep 2008 02:52:59 +0800
Message-Id: <1222455179-29953-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch includes serveral improvements:
1. iget5_locked in bdget really needs blockdev_superblock, instead of bd_mnt,
  so bd_mnt could be just a local variable;
2. blockdev_superblock really needs __read_mostly, while local var bd_mnt not;
3. make use of sb_is_blkdev_sb in bd_forget, instead of direct reference to
  blockdev_superblock.

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 fs/block_dev.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index aff5421..6d8a3ca 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -326,12 +326,13 @@ static struct file_system_type bd_type = {
 	.kill_sb	= kill_anon_super,
 };
 
-static struct vfsmount *bd_mnt __read_mostly;
-struct super_block *blockdev_superblock;
+struct super_block *blockdev_superblock __read_mostly;
 
 void __init bdev_cache_init(void)
 {
 	int err;
+	struct vfsmount *bd_mnt;
+
 	bdev_cachep = kmem_cache_create("bdev_cache", sizeof(struct bdev_inode),
 			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 				SLAB_MEM_SPREAD|SLAB_PANIC),
@@ -373,7 +374,7 @@ struct block_device *bdget(dev_t dev)
 	struct block_device *bdev;
 	struct inode *inode;
 
-	inode = iget5_locked(bd_mnt->mnt_sb, hash(dev),
+	inode = iget5_locked(blockdev_superblock, hash(dev),
 			bdev_test, bdev_set, &dev);
 
 	if (!inode)
@@ -463,7 +464,7 @@ void bd_forget(struct inode *inode)
 
 	spin_lock(&bdev_lock);
 	if (inode->i_bdev) {
-		if (inode->i_sb != blockdev_superblock)
+		if (!sb_is_blkdev_sb(inode->i_sb))
 			bdev = inode->i_bdev;
 		__bd_forget(inode);
 	}
-- 
1.5.6.3

