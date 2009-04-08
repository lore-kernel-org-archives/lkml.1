Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZDHMNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZDHMNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933421AbZDHMBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:01:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48971 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933373AbZDHMAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 09/13] writeback: btrfs must register its backing_devices
Date: Wed,  8 Apr 2009 14:00:12 +0200
Message-Id: <1239192016-19857-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btrfs puts dirty inodes on there, so it must register a thread
to handle them. Also fixes failure to check bdi_init() return value,
and bad inherit of ->capabilities flags from the default bdi.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/btrfs/disk-io.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 92caa80..3c91484 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1366,12 +1366,24 @@ static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 	free_extent_map(em);
 }
 
+/*
+ * If this fails, caller must call bdi_destroy() to get rid of the
+ * bdi again.
+ */
 static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 {
-	bdi_init(bdi);
+	int err;
+
+	bdi->capabilities = BDI_CAP_MAP_COPY;
+	err = bdi_init(bdi);
+	if (err)
+		return err;
+
+	err = bdi_register(bdi, NULL, "btrfs");
+	if (err)
+		return err;
+
 	bdi->ra_pages	= default_backing_dev_info.ra_pages;
-	bdi->state		= 0;
-	bdi->capabilities	= default_backing_dev_info.capabilities;
 	bdi->unplug_io_fn	= btrfs_unplug_io_fn;
 	bdi->unplug_io_data	= info;
 	bdi->congested_fn	= btrfs_congested_fn;
@@ -1595,7 +1607,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->sb = sb;
 	fs_info->max_extent = (u64)-1;
 	fs_info->max_inline = 8192 * 1024;
-	setup_bdi(fs_info, &fs_info->bdi);
+	if (setup_bdi(fs_info, &fs_info->bdi))
+		goto fail_bdi;
 	fs_info->btree_inode = new_inode(sb);
 	fs_info->btree_inode->i_ino = 1;
 	fs_info->btree_inode->i_nlink = 1;
@@ -1951,8 +1964,8 @@ fail_iput:
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+fail_bdi:
 	bdi_destroy(&fs_info->bdi);
-
 fail:
 	kfree(extent_root);
 	kfree(tree_root);
-- 
1.6.2.2.446.gfbdc0

