Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbZAMOap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbZAMOap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbZAMOaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:30:16 -0500
Received: from styx.suse.cz ([82.119.242.94]:40010 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757120AbZAMOaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:30:14 -0500
Date: Tue, 13 Jan 2009 15:30:12 +0100
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090113143011.GB10064@duck.suse.cz>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113140347.GD17664@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-01-09 09:03:47, Theodore Tso wrote:
> Adding a barrier shouldn't be that hard; just a matter adding a call
> to blkdev_issue_flush() to ext2_sync_file() before it returns.
  Yes. Something like the patch below?

  But it's not the whole story. Strictly speaking we should also call
blkdev_issue_flush() whenever we write things because of O_SYNC or
O_DIRSYNC flags. My patch does also that (it's based on the previous ext2
patch I've sent a while before).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

---
>From 0f5a1865a9f1538886699c5d13d3527343c88c11 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 13 Jan 2009 15:09:18 +0100
Subject: [PATCH] ext2: Add blk_issue_flush() to syncing paths

To be really safe that the data hit the platter, we should also flush drive's
writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/dir.c   |    5 ++++-
 fs/ext2/fsync.c |    7 +++++--
 fs/ext2/inode.c |    7 +++++++
 fs/ext2/xattr.c |    6 +++++-
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 7fba549..9ab9347 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -25,6 +25,7 @@
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
@@ -96,8 +97,10 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	}
 	unlock_page(page);
 
-	if (IS_DIRSYNC(dir))
+	if (IS_DIRSYNC(dir)) {
 		err = ext2_sync_inode(dir);
+		blkdev_issue_flush(dir->i_sb->s_bdev, NULL);
+	}
 
 	return err;
 }
diff --git a/fs/ext2/fsync.c b/fs/ext2/fsync.c
index fc66c93..9cd1838 100644
--- a/fs/ext2/fsync.c
+++ b/fs/ext2/fsync.c
@@ -24,6 +24,7 @@
 
 #include "ext2.h"
 #include <linux/buffer_head.h>		/* for sync_mapping_buffers() */
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 
 
 /*
@@ -39,12 +40,14 @@ int ext2_sync_file(struct file *file, struct dentry *dentry, int datasync)
 
 	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode->i_state & I_DIRTY))
-		return ret;
+		goto out;
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		return ret;
+		goto out;
 
 	err = ext2_sync_inode(inode);
 	if (ret == 0)
 		ret = err;
+out:
+	blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
 }
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 23fff2f..49b479e 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -33,6 +33,7 @@
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/blkdev.h>	/* for blkdev_issue_flush() */
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
@@ -68,9 +69,14 @@ void ext2_delete_inode (struct inode * inode)
 	mark_inode_dirty(inode);
 	ext2_update_inode(inode, inode_needs_sync(inode));
 
+	/* Make sure inode deletion really gets to disk. Disk write caches
+	 * are flushed either in ext2_truncate() or we do it explicitly */
 	inode->i_size = 0;
 	if (inode->i_blocks)
 		ext2_truncate (inode);
+	else if (inode_needs_sync(inode))
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+
 	ext2_free_inode (inode);
 
 	return;
@@ -1104,6 +1110,7 @@ do_indirects:
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
 		ext2_sync_inode (inode);
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	} else {
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 987a526..d480216 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -60,6 +60,7 @@
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
 #include <linux/rwsem.h>
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -702,6 +703,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 				DQUOT_FREE_BLOCK(inode, 1);
 			goto cleanup;
 		}
+		blkdev_issue_flush(sb->s_bdev, NULL);
 	} else
 		mark_inode_dirty(inode);
 
@@ -792,8 +794,10 @@ ext2_xattr_delete_inode(struct inode *inode)
 			le32_to_cpu(HDR(bh)->h_refcount));
 		unlock_buffer(bh);
 		mark_buffer_dirty(bh);
-		if (IS_SYNC(inode))
+		if (IS_SYNC(inode)) {
 			sync_dirty_buffer(bh);
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		}
 		DQUOT_FREE_BLOCK(inode, 1);
 	}
 	EXT2_I(inode)->i_file_acl = 0;
-- 
1.6.0.2

