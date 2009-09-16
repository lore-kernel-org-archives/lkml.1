Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZIPN21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZIPN21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbZIPN2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:28:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57930 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbZIPNYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:48 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 05/16] fs: Assign bdi in super_block
Date: Wed, 16 Sep 2009 15:24:43 +0200
Message-Id: <1253107494-20160-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do this automatically in get_sb_bdev() from the set_bdev_super()
callback. Filesystems that have their own private backing_dev_info
must assign that in ->fill_super().

Note that ->s_bdi assignment is required for proper writeback!

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/btrfs/disk-io.c |    1 +
 fs/fuse/inode.c    |    2 ++
 fs/nfs/super.c     |    2 ++
 fs/super.c         |    6 ++++++
 fs/sync.c          |    9 ++++++++-
 fs/ubifs/super.c   |    1 +
 include/linux/fs.h |    1 +
 7 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 15831d5..8b81927 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1600,6 +1600,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
+	sb->s_bdi = &fs_info->bdi;
 
 	/*
 	 * we set the i_size on the btree inode to the max possible int.
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4567db6..e5dbecd 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -894,6 +894,8 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto err_put_conn;
 
+	sb->s_bdi = &fc->bdi;
+
 	/* Handle umasking inside the fuse code */
 	if (sb->s_flags & MS_POSIXACL)
 		fc->dont_mask = 1;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 867f705..de93569 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1918,6 +1918,8 @@ static inline void nfs_initialise_sb(struct super_block *sb)
 	if (server->flags & NFS_MOUNT_NOAC)
 		sb->s_flags |= MS_SYNCHRONOUS;
 
+	sb->s_bdi = &server->backing_dev_info;
+
 	nfs_super_set_maxbytes(sb, server->maxfilesize);
 }
 
diff --git a/fs/super.c b/fs/super.c
index 9cda337..b03fea8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -707,6 +707,12 @@ static int set_bdev_super(struct super_block *s, void *data)
 {
 	s->s_bdev = data;
 	s->s_dev = s->s_bdev->bd_dev;
+
+	/*
+	 * We set the bdi here to the queue backing, file systems can
+	 * overwrite this in ->fill_super()
+	 */
+	s->s_bdi = &bdev_get_queue(s->s_bdev)->backing_dev_info;
 	return 0;
 }
 
diff --git a/fs/sync.c b/fs/sync.c
index 1923409..c08467a 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -27,6 +27,13 @@
  */
 static int __sync_filesystem(struct super_block *sb, int wait)
 {
+	/*
+	 * This should be safe, as we require bdi backing to actually
+	 * write out data in the first place
+	 */
+	if (!sb->s_bdi)
+		return 0;
+
 	/* Avoid doing twice syncing and cache pruning for quota sync */
 	if (!wait) {
 		writeout_quota_sb(sb, -1);
@@ -101,7 +108,7 @@ restart:
 		spin_unlock(&sb_lock);
 
 		down_read(&sb->s_umount);
-		if (!(sb->s_flags & MS_RDONLY) && sb->s_root)
+		if (!(sb->s_flags & MS_RDONLY) && sb->s_root && sb->s_bdi)
 			__sync_filesystem(sb, wait);
 		up_read(&sb->s_umount);
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 51763aa..c4af069 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1980,6 +1980,7 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto out_bdi;
 
+	sb->s_bdi = &c->bdi;
 	sb->s_fs_info = c;
 	sb->s_magic = UBIFS_SUPER_MAGIC;
 	sb->s_blocksize = UBIFS_BLOCK_SIZE;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index db29588..90162fb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1342,6 +1342,7 @@ struct super_block {
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
 	struct block_device	*s_bdev;
+	struct backing_dev_info *s_bdi;
 	struct mtd_info		*s_mtd;
 	struct list_head	s_instances;
 	struct quota_info	s_dquot;	/* Diskquota specific options */
-- 
1.6.4.1.207.g68ea

