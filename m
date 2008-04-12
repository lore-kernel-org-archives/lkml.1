Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYDLXCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYDLXCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbYDLW7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:59:15 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35385 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbYDLW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:58:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/7] omfs: add inode routines
Date: Sat, 12 Apr 2008 18:58:36 -0400
Message-Id: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add basic superblock and inode handling routines for OMFS

    Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/inode.c |  439 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 439 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/inode.c

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
new file mode 100644
index 0000000..92d794f
--- /dev/null
+++ b/fs/omfs/inode.c
@@ -0,0 +1,439 @@
+/*
+ * Optimized MPEG FS - inode and super operations.
+ * Copyright (C) 2006 Bob Copeland <me@bobcopeland.com>
+ * Released under GPL v2.
+ */
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/vfs.h>
+#include <linux/buffer_head.h>
+#include <linux/vmalloc.h>
+#include "omfs.h"
+
+MODULE_AUTHOR("Bob Copeland <me@bobcopeland.com>");
+MODULE_DESCRIPTION("OMFS (ReplayTV/Karma) Filesystem for Linux");
+MODULE_LICENSE("GPL");
+
+struct inode *omfs_new_inode(struct inode *dir, int mode)
+{
+	struct inode *inode;
+	u64 new_block;
+	int res;
+	int len;
+	struct omfs_sb_info *sbi = OMFS_SB(dir->i_sb);
+
+	inode = new_inode(dir->i_sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	res = omfs_allocate_range(dir->i_sb, sbi->s_mirrors, sbi->s_mirrors,
+			&new_block, &len);
+	if (res)
+		return ERR_PTR(res);
+
+	inode->i_ino = new_block;
+	inode->i_mode = mode;
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+	inode->i_blocks = 0;
+	inode->i_mapping->a_ops = &omfs_aops;
+
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	switch (mode & S_IFMT) {
+	case S_IFDIR:
+		inode->i_op = &omfs_dir_inops;
+		inode->i_fop = &omfs_dir_operations;
+		inode->i_size = sbi->s_sys_blocksize;
+		inode->i_nlink++;
+		break;
+	case S_IFREG:
+		inode->i_op = &omfs_file_inops;
+		inode->i_fop = &omfs_file_operations;
+		inode->i_size = 0;
+		break;
+	}
+
+	insert_inode_hash(inode);
+	mark_inode_dirty(inode);
+	return inode;
+}
+
+static int omfs_write_inode(struct inode *inode, int wait)
+{
+	struct omfs_inode *oi;
+	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
+	struct buffer_head *bh, *bh2;
+	unsigned int block;
+	u64 ctime;
+	int i;
+	int ret = 0;
+
+	/* get current inode since we may have written sibling ptrs etc. */
+	block = clus_to_blk(sbi, inode->i_ino);
+	bh = sb_bread(inode->i_sb, block);
+	if (!bh) {
+		ret = -EIO;
+		goto out_nobh;
+	}
+
+	oi = (struct omfs_inode *) bh->b_data;
+
+	oi->i_head.h_self = cpu_to_be64(inode->i_ino);
+	if (S_ISDIR(inode->i_mode))
+		oi->i_type = OMFS_DIR;
+	else if (S_ISREG(inode->i_mode))
+		oi->i_type = OMFS_FILE;
+	else {
+		printk(KERN_WARNING "omfs: unknown file type: %d\n", 
+			inode->i_mode);
+		ret = -EIO;
+		goto out;
+	}
+
+	oi->i_head.h_body_size = cpu_to_be32(sbi->s_sys_blocksize -
+		sizeof(struct omfs_header));
+	oi->i_head.h_version = 1;
+	oi->i_head.h_type = OMFS_INODE_NORMAL;
+	oi->i_head.h_magic = OMFS_IMAGIC;
+	oi->i_size = cpu_to_be64(inode->i_size);
+
+	ctime = inode->i_ctime.tv_sec * 1000LL +
+		((inode->i_ctime.tv_nsec + 999)/1000);
+	oi->i_ctime = cpu_to_be64(ctime);
+
+	if (omfs_update_checksums(oi) != 0) {
+		ret = -EIO;
+		goto out;
+	}
+
+	mark_buffer_dirty(bh);
+	if (wait) {
+		sync_dirty_buffer(bh);
+		if (buffer_req(bh) && !buffer_uptodate(bh))
+			ret = -EIO;
+	}
+
+	/* if mirroring writes, copy to next fsblock */
+	for (i = 1; i < sbi->s_mirrors; i++) {
+		bh2 = sb_bread(inode->i_sb, block + i *
+			(sbi->s_blocksize / sbi->s_sys_blocksize));
+		if (!bh2) {
+			brelse(bh2);
+			ret = -EIO;
+			goto out;
+		}
+		memcpy(bh2->b_data, bh->b_data, bh->b_size);
+		mark_buffer_dirty(bh2);
+		if (wait) {
+			sync_dirty_buffer(bh2);
+			if (buffer_req(bh2) && !buffer_uptodate(bh2))
+				ret = -EIO;
+		}
+		brelse(bh2);
+	}
+out:
+	brelse(bh);
+out_nobh:
+	return ret;
+}
+
+int omfs_sync_inode(struct inode *inode)
+{
+	return omfs_write_inode(inode, 1);
+}
+
+/*
+ * called when an entry is deleted, need to clear the bits in the
+ * bitmaps.
+ */
+static void omfs_delete_inode(struct inode *inode)
+{
+	truncate_inode_pages(&inode->i_data, 0);
+
+	if (S_ISREG(inode->i_mode)) {
+		inode->i_size = 0;
+		omfs_shrink_inode(inode);
+	}
+
+	omfs_clear_range(inode->i_sb, inode->i_ino, 2);
+	clear_inode(inode);
+}
+
+struct inode *omfs_iget(struct super_block *sb, ino_t ino)
+{
+	struct omfs_inode *oi;
+	struct buffer_head *bh;
+	unsigned int block;
+	u64 ctime;
+	unsigned long nsecs;
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	block = clus_to_blk(OMFS_SB(inode->i_sb), ino);
+	bh = sb_bread(inode->i_sb, block);
+	if (!bh) {
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
+	}
+
+	oi = (struct omfs_inode *)bh->b_data;
+
+	/* check self */
+	if (ino != be64_to_cpu(oi->i_head.h_self)) {
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
+	}
+
+	inode->i_uid = 0;
+	inode->i_gid = 0;
+
+	ctime = be64_to_cpu(oi->i_ctime);
+	nsecs = do_div(ctime, 1000) * 1000L;
+
+	inode->i_atime.tv_sec = ctime;
+	inode->i_mtime.tv_sec = ctime;
+	inode->i_ctime.tv_sec = ctime;
+	inode->i_atime.tv_nsec = nsecs;
+	inode->i_mtime.tv_nsec = nsecs;
+	inode->i_ctime.tv_nsec = nsecs;
+
+	inode->i_mapping->a_ops = &omfs_aops;
+
+	switch (oi->i_type) {
+	case OMFS_DIR:
+		inode->i_mode = S_IFDIR | S_IRUGO | S_IWUGO | S_IXUGO;
+		inode->i_op = &omfs_dir_inops;
+		inode->i_fop = &omfs_dir_operations;
+		inode->i_size = be32_to_cpu(oi->i_head.h_body_size) +
+			sizeof(struct omfs_header);
+		inode->i_nlink++;
+		break;
+	case OMFS_FILE:
+		inode->i_mode = S_IFREG | S_IRUGO | S_IWUGO;
+		inode->i_fop = &omfs_file_operations;
+		inode->i_size = be64_to_cpu(oi->i_size);
+		break;
+	}
+	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
+}
+
+
+static void omfs_put_super(struct super_block *sb)
+{
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+	if (sbi) {
+		kfree(sbi->s_imap);
+		kfree(sbi);
+	}
+	sb->s_fs_info = NULL;
+}
+
+static int omfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *s = dentry->d_sb;
+	struct omfs_sb_info *sbi = OMFS_SB(s);
+	buf->f_type = OMFS_MAGIC;
+	buf->f_bsize = sbi->s_blocksize;
+	buf->f_blocks = sbi->s_num_blocks;
+	buf->f_files = sbi->s_num_blocks;
+	buf->f_namelen = OMFS_NAMELEN;
+
+	buf->f_bfree = buf->f_bavail = buf->f_ffree =
+		omfs_count_free(s);
+	return 0;
+}
+
+static struct super_operations omfs_sops = {
+	.write_inode	= omfs_write_inode,
+	.delete_inode	= omfs_delete_inode,
+	.put_super	= omfs_put_super,
+	.statfs		= omfs_statfs,
+};
+
+/*
+ * For Rio Karma, there is an on-disk free bitmap whose location is
+ * stored in the root block.  For ReplayTV, there is no such free bitmap
+ * so we have to walk the tree.  Both inodes and file data are allocated
+ * from the same map.  This array can be big (300k) so we allocate
+ * in units of the blocksize.
+ */
+static int omfs_get_imap(struct super_block *sb)
+{
+	int bitmap_size;
+	int array_size;
+	int count;
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+	struct buffer_head *bh;
+	unsigned long **ptr;
+	sector_t block;
+
+	bitmap_size = (sbi->s_num_blocks + 7) / 8;
+	array_size = (bitmap_size + sb->s_blocksize - 1) / sb->s_blocksize;
+
+	sbi->s_imap_size = array_size;
+	sbi->s_imap = kzalloc(array_size * sizeof(unsigned long *), GFP_KERNEL);
+	if (!sbi->s_imap)
+		return -ENOMEM;
+
+	block = clus_to_blk(sbi, sbi->s_bitmap_ino);
+	ptr = sbi->s_imap;
+	for (count = bitmap_size; count > 0; count -= sb->s_blocksize) {
+		bh = sb_bread(sb, block++);
+		if (!bh)
+			goto nomem;
+		*ptr = kmalloc(sb->s_blocksize, GFP_KERNEL);
+		if (!*ptr)
+			goto nomem;
+		memcpy(*ptr, bh->b_data, sb->s_blocksize);
+		if (count < sb->s_blocksize)
+			memset((void *)*ptr + count, 0xff, sb->s_blocksize - count);
+		brelse(bh);
+		ptr++;
+	}
+	return 0;
+nomem:
+	for (count = 0; count < array_size; count++)
+		kfree(sbi->s_imap[count]);
+
+	kfree(sbi->s_imap);
+	sbi->s_imap = NULL;
+	return -ENOMEM;
+}
+
+static void set_block_shift(struct omfs_sb_info *sbi)
+{
+	unsigned int scale = sbi->s_blocksize / sbi->s_sys_blocksize;
+	sbi->s_block_shift = 0;
+	for (scale >>= 1; scale; scale >>= 1)
+		sbi->s_block_shift++;
+}
+
+static int omfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct buffer_head *bh = NULL, *bh2 = NULL;
+	struct omfs_super_block *omfs_sb;
+	struct omfs_root_block *omfs_rb;
+	struct omfs_sb_info *sbi;
+	struct inode *root;
+	sector_t start;
+	int ret = 0;
+
+	sbi = kzalloc(sizeof(struct omfs_sb_info), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+	sb->s_fs_info = sbi;
+
+	sb->s_maxbytes = 0xffffffff;
+
+	sb_set_blocksize(sb, 0x200);
+
+	bh = sb_bread(sb, 0);
+	if (!bh)
+		goto out;
+
+	omfs_sb = (struct omfs_super_block *)bh->b_data;
+
+	if (be32_to_cpu(omfs_sb->s_magic) != OMFS_MAGIC) {
+		if (!silent)
+			printk(KERN_ERR "omfs: Invalid superblock (%x)\n",
+				   omfs_sb->s_magic);
+		goto out;
+	}
+	sb->s_magic = OMFS_MAGIC;
+
+	sbi->s_num_blocks = be64_to_cpu(omfs_sb->s_num_blocks);
+	sbi->s_blocksize = be32_to_cpu(omfs_sb->s_blocksize);
+	sbi->s_mirrors = be32_to_cpu(omfs_sb->s_mirrors);
+	sbi->s_root_ino = be64_to_cpu(omfs_sb->s_root_block);
+	sbi->s_sys_blocksize = be32_to_cpu(omfs_sb->s_sys_blocksize);
+	mutex_init(&sbi->s_bitmap_lock);
+
+	/*
+	 * Use sys_blocksize as the fs block since it is smaller than a
+	 * page while the fs blocksize can be larger.
+	 */
+	sb_set_blocksize(sb, sbi->s_sys_blocksize);
+
+	/*
+	 * ...and the difference goes into a shift.  sys_blocksize is always
+	 * a power of two factor of blocksize.
+	 */
+	set_block_shift(sbi);
+
+	start = clus_to_blk(sbi, be64_to_cpu(omfs_sb->s_root_block));
+	bh2 = sb_bread(sb, start);
+	if (!bh2)
+		goto out;
+
+	omfs_rb = (struct omfs_root_block *)bh2->b_data;
+
+	sbi->s_bitmap_ino = be64_to_cpu(omfs_rb->r_bitmap);
+	sbi->s_clustersize = be32_to_cpu(omfs_rb->r_clustersize);
+
+	ret = omfs_get_imap(sb);
+	if (ret)
+		goto end;
+
+	sb->s_op = &omfs_sops;
+
+	root = omfs_iget(sb, be64_to_cpu(omfs_rb->r_root_dir));
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto end;
+	}
+
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		iput(root);
+		goto out;
+	}
+	printk(KERN_DEBUG "omfs: Mounted volume %s\n", omfs_rb->r_name);
+	goto end;
+
+out:
+	ret = -EINVAL;
+
+end:
+	if (bh2)
+		brelse(bh2);
+	if (bh)
+		brelse(bh);
+	return ret;
+}
+
+static int omfs_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data, struct vfsmount *m)
+{
+	return get_sb_bdev(fs_type, flags, dev_name, data, omfs_fill_super, m);
+}
+
+static struct file_system_type omfs_fs_type = {
+	.owner = THIS_MODULE,
+	.name = "omfs",
+	.get_sb = omfs_get_sb,
+	.kill_sb = kill_block_super,
+	.fs_flags = FS_REQUIRES_DEV,
+};
+
+static int __init init_omfs_fs(void)
+{
+	return register_filesystem(&omfs_fs_type);
+}
+
+static void __exit exit_omfs_fs(void)
+{
+	unregister_filesystem(&omfs_fs_type);
+}
+
+module_init(init_omfs_fs);
+module_exit(exit_omfs_fs);
-- 
1.5.4.2


