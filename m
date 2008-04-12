Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbYDLXAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbYDLXAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757633AbYDLW7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:59:01 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35381 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYDLW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:58:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/7] omfs: add directory routines
Date: Sat, 12 Apr 2008 18:58:37 -0400
Message-Id: <1208041121-26787-4-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add lookup and directory management routines for OMFS.  The filesystem uses
    hashing based on the filename and stores collisions, unordered, in siblings
    of files' inode structures.  To support telldir, the current position in
    the hash table is encoded in fpos.

    Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/dir.c |  479 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 479 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/dir.c

diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
new file mode 100644
index 0000000..3b7cf2e
--- /dev/null
+++ b/fs/omfs/dir.c
@@ -0,0 +1,479 @@
+/*
+ * OMFS (as used by RIO Karma) directory operations.
+ * Copyright (C) 2005 Bob Copeland <me@bobcopeland.com>
+ * Released under GPL v2.
+ */
+
+#include <linux/fs.h>
+#include <linux/ctype.h>
+#include <linux/buffer_head.h>
+#include "omfs.h"
+
+static int omfs_hash(const char *name, int namelen, int mod)
+{
+	int i, hash = 0;
+	for (i = 0; i < namelen; i++)
+		hash ^= tolower(name[i]) << (i % 24);
+	return hash % mod;
+}
+
+/*
+ * Finds the bucket for a given name and reads the containing block;
+ * *ofs is set to the offset of the first list entry.
+ */
+static struct buffer_head *omfs_get_bucket(struct inode *dir,
+		const char *name, int namelen, int *ofs)
+{
+	int nbuckets = (dir->i_size - OMFS_DIR_START)/8;
+	int block = clus_to_blk(OMFS_SB(dir->i_sb), dir->i_ino);
+	int bucket = omfs_hash(name, namelen, nbuckets);
+
+	*ofs = OMFS_DIR_START + bucket * 8;
+	return sb_bread(dir->i_sb, block);
+}
+
+static struct buffer_head *omfs_scan_list(struct inode *dir, u64 block,
+				const char *name, int namelen,
+				u64 *prev_block)
+{
+	struct buffer_head *bh;
+	struct omfs_inode *oi;
+	*prev_block = ~0;
+
+	while (block != ~0) {
+		bh = sb_bread(dir->i_sb,
+			clus_to_blk(OMFS_SB(dir->i_sb), block));
+		if (!bh)
+			return NULL;
+
+		oi = (struct omfs_inode *) bh->b_data;
+		if (omfs_is_bad(OMFS_SB(dir->i_sb), &oi->i_head, block)) {
+			block = ~0;
+			goto err;
+		}
+		if (strncmp(oi->i_name, name, namelen) == 0)
+			return bh;
+
+		*prev_block = block;
+		block = be64_to_cpu(oi->i_sibling);
+err:
+		brelse(bh);
+	}
+	return NULL;
+}
+
+static struct buffer_head *omfs_find_entry(struct inode *dir,
+					   const char *name, int namelen)
+{
+	struct buffer_head *bh;
+	int ofs;
+	u64 block, dummy;
+
+	bh = omfs_get_bucket(dir, name, namelen, &ofs);
+	if (!bh)
+		goto out;
+
+	block = be64_to_cpu(*((__be64 *) &bh->b_data[ofs]));
+	brelse(bh);
+
+	bh = omfs_scan_list(dir, block, name, namelen, &dummy);
+out:
+	return bh;
+}
+
+int omfs_make_empty(struct inode *inode, struct super_block *sb)
+{
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+	int block = clus_to_blk(sbi, inode->i_ino);
+	struct buffer_head *bh;
+	struct omfs_inode *oi;
+
+	bh = sb_bread(sb, block);
+	if (!bh)
+		return -ENOMEM;
+
+	memset(bh->b_data, 0, sizeof(struct omfs_inode));
+
+	if (inode->i_mode & S_IFDIR) {
+		memset(&bh->b_data[OMFS_DIR_START], 0xff,
+			sbi->s_sys_blocksize - OMFS_DIR_START);
+	} else
+		omfs_make_empty_table(bh, OMFS_EXTENT_START);
+
+	oi = (struct omfs_inode *) bh->b_data;
+	oi->i_head.h_self = cpu_to_be64(inode->i_ino);
+	oi->i_sibling = ~0ULL;
+
+	mark_buffer_dirty(bh);
+	brelse(bh);
+	return 0;
+}
+
+static int omfs_add_link(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	struct omfs_inode *oi;
+	struct buffer_head *bh;
+	u64 block;
+	__be64 *entry;
+	int ofs;
+
+	/* just prepend to head of queue in proper bucket */
+	bh = omfs_get_bucket(dir, name, namelen, &ofs);
+	if (!bh)
+		goto out;
+
+	entry = (__be64 *) &bh->b_data[ofs];
+	block = be64_to_cpu(*entry);
+	*entry = cpu_to_be64(inode->i_ino);
+	mark_buffer_dirty(bh);
+	brelse(bh);
+
+	/* now set the sibling and parent pointers on the new inode */
+	bh = sb_bread(dir->i_sb, clus_to_blk(OMFS_SB(dir->i_sb), inode->i_ino));
+	if (!bh)
+		goto out;
+
+	oi = (struct omfs_inode *) bh->b_data;
+	memcpy(oi->i_name, name, namelen);
+	memset(oi->i_name + namelen, 0, OMFS_NAMELEN - namelen);
+	oi->i_sibling = cpu_to_be64(block);
+	oi->i_parent = cpu_to_be64(dir->i_ino);
+	mark_buffer_dirty(bh);
+	brelse(bh);
+
+	dir->i_ctime = CURRENT_TIME_SEC;
+
+	/* mark affected inodes dirty to rebuild checksums */
+	mark_inode_dirty(dir);
+	mark_inode_dirty(inode);
+	return 0;
+out:
+	return -ENOMEM;
+}
+
+static int omfs_delete_entry(struct dentry *dentry)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct inode *dirty = NULL;
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	struct omfs_inode *oi;
+	struct buffer_head *bh, *bh2;
+	__be64 *entry, next;
+	u64 block, prev;
+	int ofs;
+	int err = 0;
+
+	/* delete the proper node in the bucket's linked list */
+	bh = omfs_get_bucket(dir, name, namelen, &ofs);
+	if (!bh) {
+		err = -ENOMEM;
+		goto out;
+	}
+	entry = (__be64 *) &bh->b_data[ofs];
+	block = be64_to_cpu(*entry);
+
+	bh2 = omfs_scan_list(dir, block, name, namelen, &prev);
+	if (!bh2) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	oi = (struct omfs_inode *) bh2->b_data;
+	next = oi->i_sibling;
+	brelse(bh2);
+
+	if (prev != ~0) {
+		/* found in middle of list, get list ptr */
+		brelse(bh);
+		bh = sb_bread(dir->i_sb,
+			clus_to_blk(OMFS_SB(dir->i_sb), prev));
+		if (!bh) {
+			err = -ENOMEM;
+			goto out;
+		}
+		oi = (struct omfs_inode *) bh->b_data;
+		entry = &oi->i_sibling;
+		dirty = omfs_iget(dir->i_sb, prev);
+		if (IS_ERR(dirty))
+			return PTR_ERR(dirty);
+	}
+
+	*entry = next;
+	mark_buffer_dirty(bh);
+	brelse(bh);
+
+	if (dirty) {
+		mark_inode_dirty(dirty);
+		iput(dirty);
+	}
+out:
+	return err;
+}
+
+static int omfs_dir_is_empty(struct inode *inode)
+{
+	int nbuckets = (inode->i_size - OMFS_DIR_START) / 8;
+	struct buffer_head *bh;
+	u64 *ptr;
+	int i;
+
+	bh = sb_bread(inode->i_sb, clus_to_blk(OMFS_SB(inode->i_sb),
+			inode->i_ino));
+
+	if (!bh)
+		return 0;
+
+	ptr = (u64 *) &bh->b_data[OMFS_DIR_START];
+
+	for (i = 0; i < nbuckets; i++, ptr++)
+		if (*ptr != ~0)
+			break;
+
+	brelse(bh);
+	return *ptr != ~0;
+}
+
+static int omfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	int ret;
+	struct inode *inode = dentry->d_inode;
+
+	ret = omfs_delete_entry(dentry);
+	if (ret)
+		goto end_unlink;
+
+	inode->i_nlink--;
+	mark_inode_dirty(inode);
+	mark_inode_dirty(dir);
+
+end_unlink:
+	return ret;
+}
+
+static int omfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int err = -ENOTEMPTY;
+	struct inode *inode = dentry->d_inode;
+
+	if (omfs_dir_is_empty(inode)) {
+		err = omfs_unlink(dir, dentry);
+		if (!err) {
+			inode->i_nlink--;
+			mark_inode_dirty(inode);
+		}
+	}
+	return err;
+}
+
+static int omfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int err = 0;
+	struct inode *inode;
+
+	mode |= S_IFDIR;
+
+	inode = omfs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			inode->i_mode |= S_ISGID;
+	}
+
+	err = omfs_make_empty(inode, dir->i_sb);
+	if (err)
+		goto out;
+
+	err = omfs_add_link(dentry, inode);
+	if (err)
+		goto out;
+
+	d_instantiate(dentry, inode);
+out:
+	return err;
+}
+
+static int omfs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd)
+{
+	int err;
+	struct inode *inode;
+
+	mode |= S_IFREG;
+
+	inode = omfs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	err = omfs_make_empty(inode, dir->i_sb);
+	if (err)
+		goto out;
+
+	err = omfs_add_link(dentry, inode);
+	if (err)
+		goto out;
+
+	d_instantiate(dentry, inode);
+out:
+	return err;
+}
+
+static struct dentry *omfs_lookup(struct inode *dir, struct dentry *dentry,
+				  struct nameidata *nd)
+{
+	struct buffer_head *bh;
+	struct inode *inode = NULL;
+
+	if (dentry->d_name.len > OMFS_NAMELEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	bh = omfs_find_entry(dir, dentry->d_name.name, dentry->d_name.len);
+	if (bh) {
+		struct omfs_inode *oi = (struct omfs_inode *)bh->b_data;
+		ino_t ino = be64_to_cpu(oi->i_head.h_self);
+		brelse(bh);
+		inode = omfs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+	}
+	d_add(dentry, inode);
+	return NULL;
+}
+
+/* sanity check block's self pointer */
+int omfs_is_bad(struct omfs_sb_info *sbi, struct omfs_header *header, 
+	u64 fsblock)
+{
+	int is_bad;
+	u64 ino = be64_to_cpu(header->h_self);
+	is_bad = ((ino != fsblock) || (ino < sbi->s_root_ino) ||
+		(ino > sbi->s_num_blocks));
+
+	if (is_bad)
+		printk(KERN_WARNING "omfs: bad hash chain detected\n");
+
+	return is_bad;
+}
+
+static int omfs_fill_chain(struct file *filp, void *dirent, filldir_t filldir,
+		u64 fsblock, int hindex)
+{
+	struct inode *dir = filp->f_dentry->d_inode;
+	struct buffer_head *bh = NULL;
+	struct omfs_inode *oi;
+	u64 self;
+	int res = 0;
+	unsigned char d_type;
+
+	/* follow chain in this bucket */
+	while (fsblock != ~0) {
+		bh = sb_bread(dir->i_sb, clus_to_blk(OMFS_SB(dir->i_sb),
+				fsblock));
+		if (!bh)
+			goto out;
+
+		oi = (struct omfs_inode *) bh->b_data;
+		if (omfs_is_bad(OMFS_SB(dir->i_sb), &oi->i_head, fsblock)) {
+			fsblock = ~0;
+			hindex = 0;
+			goto out;
+		}
+
+		self = fsblock;
+		fsblock = be64_to_cpu(oi->i_sibling);
+
+		/* skip visited nodes */
+		if (hindex) {
+			hindex--;
+			continue;
+		}
+
+		d_type = (oi->i_type == OMFS_DIR) ? DT_DIR : DT_REG;
+
+		res = filldir(dirent, oi->i_name, strnlen(oi->i_name,
+			OMFS_NAMELEN), filp->f_pos, self, d_type);
+		if (res == 0)
+			filp->f_pos++;
+	}
+out:
+	if (!bh)
+		brelse(bh);
+	return res;
+}
+
+static int omfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *dir = filp->f_dentry->d_inode;
+	struct buffer_head *bh = NULL;
+	loff_t offset, res;
+	unsigned int hchain, hindex;
+	int nbuckets;
+	u64 fsblock;
+	int ret = -EINVAL;
+
+	if (filp->f_pos >> 32)
+		goto success;
+
+	switch ((unsigned long) filp->f_pos) {
+	case 0:
+		if (filldir(dirent, ".", 1, 0, dir->i_ino, DT_DIR) < 0)
+			goto success;
+		filp->f_pos++;
+		/* fall through */
+	case 1:
+		if (filldir(dirent, "..", 2, 1,
+		    parent_ino(filp->f_dentry), DT_DIR) < 0)
+			goto success;
+		filp->f_pos = 1 << 20;
+		/* fall through */
+	}
+
+	nbuckets = (dir->i_size - OMFS_DIR_START) / 8;
+
+	/* high 12 bits store bucket + 1 and low 20 bits store hash index */
+	hchain = (filp->f_pos >> 20) - 1;
+	hindex = filp->f_pos & 0xfffff;
+
+	bh = sb_bread(dir->i_sb, clus_to_blk(OMFS_SB(dir->i_sb), dir->i_ino));
+	if (!bh)
+		goto out;
+
+	offset = OMFS_DIR_START + hchain * 8;
+
+	for (; hchain < nbuckets; hchain++, offset += 8) {
+		fsblock = be64_to_cpu(*((__be64 *) &bh->b_data[offset]));
+
+		res = omfs_fill_chain(filp, dirent, filldir, fsblock, hindex);
+		hindex = 0;
+		if (res < 0)
+			goto success;
+
+		filp->f_pos = (hchain+2) << 20;
+	}
+success:
+	ret = 0;
+out:
+	if (bh)
+		brelse(bh);
+	return ret;
+}
+
+struct inode_operations omfs_dir_inops = {
+	.lookup = omfs_lookup,
+	.mkdir = omfs_mkdir,
+	.rename = simple_rename,
+	.create = omfs_create,
+	.unlink = omfs_unlink,
+	.rmdir = omfs_rmdir,
+};
+
+struct file_operations omfs_dir_operations = {
+	.read = generic_read_dir,
+	.readdir = omfs_readdir,
+};
-- 
1.5.4.2


