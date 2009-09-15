Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZIOSRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZIOSRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZIOSRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:17:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59532 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZIOSQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:16:51 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/11] fs: remove bdev->bd_inode_backing_dev_info
Date: Tue, 15 Sep 2009 20:16:47 +0200
Message-Id: <1253038617-30204-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been unused since it was introduced in:

commit 520808bf20e90fdbdb320264ba7dd5cf9d47dcac
Author: Andrew Morton <akpm@osdl.org>
Date:   Fri May 21 00:46:17 2004 -0700

    [PATCH] block device layer: separate backing_dev_info infrastructure

So lets just kill it.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/block_dev.c        |    1 -
 fs/inode.c            |    4 +---
 fs/nilfs2/the_nilfs.c |    4 +---
 include/linux/fs.h    |    1 -
 4 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3581a4e..71e7e03 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -420,7 +420,6 @@ static void bdev_destroy_inode(struct inode *inode)
 {
 	struct bdev_inode *bdi = BDEV_I(inode);
 
-	bdi->bdev.bd_inode_backing_dev_info = NULL;
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index ae7b67e..b2ba83d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -182,9 +182,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	if (sb->s_bdev) {
 		struct backing_dev_info *bdi;
 
-		bdi = sb->s_bdev->bd_inode_backing_dev_info;
-		if (!bdi)
-			bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
+		bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
 		mapping->backing_dev_info = bdi;
 	}
 	inode->i_private = NULL;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d4168e2..ad391a8 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -591,9 +591,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 
 	nilfs->ns_mount_state = le16_to_cpu(sbp->s_state);
 
-	bdi = nilfs->ns_bdev->bd_inode_backing_dev_info;
-	if (!bdi)
-		bdi = nilfs->ns_bdev->bd_inode->i_mapping->backing_dev_info;
+	bdi = nilfs->ns_bdev->bd_inode->i_mapping->backing_dev_info;
 	nilfs->ns_bdi = bdi ? : &default_backing_dev_info;
 
 	/* Finding last segment */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b21cf6b..db29588 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -655,7 +655,6 @@ struct block_device {
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
 	struct list_head	bd_list;
-	struct backing_dev_info *bd_inode_backing_dev_info;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
 	 * to use this.  NOTE:  bd_claim allows an owner to claim
-- 
1.6.4.1.207.g68ea

