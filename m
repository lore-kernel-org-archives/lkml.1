Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYJ2BzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYJ2BzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYJ2Bup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:50:45 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:2359 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbYJ2BuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:50:05 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: [PATCH V2 07/16] Squashfs: export operations
Message-Id: <E1Kv0C4-0006H6-2E@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 29 Oct 2008 01:49:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/export.c |  152 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 152 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
new file mode 100644
index 0000000..6ba8724
--- /dev/null
+++ b/fs/squashfs/export.c
@@ -0,0 +1,152 @@
+/*
+ * Squashfs - a compressed read only filesystem for Linux
+ *
+ * Copyright (c) 2002, 2003, 2004, 2005, 2006, 2007, 2008
+ * Phillip Lougher <phillip@lougher.demon.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * export.c
+ */
+
+/*
+ * This file implements code to make Squashfs filesystems exportable (NFS etc.)
+ *
+ * The export code uses an inode lookup table to map inode numbers passed in
+ * filehandles to an inode location on disk.  This table is stored compressed
+ * into metadata blocks.  A second index table is used to locate these.  This
+ * second index table for speed of access (and because it is small) is read at
+ * mount time and cached in memory.
+ *
+ * The inode lookup table is used only by the export code, inode disk
+ * locations are directly encoded in directories, enabling direct access
+ * without an intermediate lookup for all operations except the export ops.
+ */
+
+#include <linux/fs.h>
+#include <linux/vfs.h>
+#include <linux/dcache.h>
+#include <linux/exportfs.h>
+#include <linux/zlib.h>
+
+#include "squashfs_fs.h"
+#include "squashfs_fs_sb.h"
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+
+/*
+ * Look-up inode number (ino) in table, returning the inode location.
+ */
+static long long squashfs_inode_lookup(struct super_block *sb, int ino_num)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	int blk = SQUASHFS_LOOKUP_BLOCK(ino_num - 1);
+	int offset = SQUASHFS_LOOKUP_BLOCK_OFFSET(ino_num - 1);
+	long long start = le64_to_cpu(msblk->inode_lookup_table[blk]);
+	__le64 ino;
+	int err;
+
+	TRACE("Entered squashfs_inode_lookup, inode_number = %d\n", ino_num);
+
+	err = squashfs_read_metadata(sb, &ino, &start, &offset, sizeof(ino));
+	if (err < 0)
+		return err;
+
+	TRACE("squashfs_inode_lookup, inode = 0x%llx\n",
+		(unsigned long long) le64_to_cpu(ino));
+
+	return le64_to_cpu(ino);
+}
+
+
+static struct dentry *squashfs_export_iget(struct super_block *sb,
+	unsigned int ino_num)
+{
+	long long ino;
+	struct dentry *dentry = ERR_PTR(-ENOENT);
+
+	TRACE("Entered squashfs_export_iget\n");
+
+	ino = squashfs_inode_lookup(sb, ino_num);
+	if (ino >= 0)
+		dentry = d_obtain_alias(squashfs_iget(sb, ino, ino_num));
+
+	return dentry;
+}
+
+
+static struct dentry *squashfs_fh_to_dentry(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	if ((fh_type != FILEID_INO32_GEN && fh_type != FILEID_INO32_GEN_PARENT)
+			|| fh_len < 2)
+		return NULL;
+
+	return squashfs_export_iget(sb, fid->i32.ino);
+}
+
+
+static struct dentry *squashfs_fh_to_parent(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	if (fh_type != FILEID_INO32_GEN_PARENT || fh_len < 4)
+		return NULL;
+
+	return squashfs_export_iget(sb, fid->i32.parent_ino);
+}
+
+
+static struct dentry *squashfs_get_parent(struct dentry *child)
+{
+	struct inode *inode = child->d_inode;
+	unsigned int parent_ino = SQUASHFS_I(inode)->parent;
+
+	return squashfs_export_iget(inode->i_sb, parent_ino);
+}
+
+
+__le64 *read_inode_lookup_table(struct super_block *sb,
+		long long lookup_table_start, unsigned int inodes)
+{
+	unsigned int length = SQUASHFS_LOOKUP_BLOCK_BYTES(inodes);
+	__le64 *inode_lookup_table;
+	int err;
+
+	TRACE("In read_inode_lookup_table, length %d\n", length);
+
+	/* Allocate inode lookup table */
+	inode_lookup_table = kmalloc(length, GFP_KERNEL);
+	if (inode_lookup_table == NULL) {
+		ERROR("Failed to allocate inode lookup table\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	err = squashfs_read_data(sb, inode_lookup_table, lookup_table_start,
+			length | SQUASHFS_COMPRESSED_BIT_BLOCK, NULL, length);
+	if (err < 0) {
+		ERROR("unable to read inode lookup table\n");
+		kfree(inode_lookup_table);
+		return ERR_PTR(err);
+	}
+
+	return inode_lookup_table;
+}
+
+
+const struct export_operations squashfs_export_ops = {
+	.fh_to_dentry = squashfs_fh_to_dentry,
+	.fh_to_parent = squashfs_fh_to_parent,
+	.get_parent = squashfs_get_parent
+};
-- 
1.5.2.5

