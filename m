Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYJ2Bxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYJ2Bxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYJ2Bua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:50:30 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:1337 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbYJ2BuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:50:05 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: [PATCH V2 12/16] Squashfs: header files
Message-Id: <E1Kv0C4-0006Ha-Fc@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 29 Oct 2008 01:49:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/squashfs.h       |   89 ++++++++++
 fs/squashfs/squashfs_fs.h    |  380 ++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs_fs_i.h  |   45 +++++
 fs/squashfs/squashfs_fs_sb.h |   76 +++++++++
 4 files changed, 590 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
new file mode 100644
index 0000000..b852934
--- /dev/null
+++ b/fs/squashfs/squashfs.h
@@ -0,0 +1,89 @@
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
+ * squashfs.h
+ */
+
+#define TRACE(s, args...)	pr_debug("SQUASHFS: "s, ## args)
+
+#define ERROR(s, args...)	pr_err("SQUASHFS error: "s, ## args)
+
+#define WARNING(s, args...)	pr_warning("SQUASHFS: "s, ## args)
+
+static inline struct squashfs_inode_info *SQUASHFS_I(struct inode *inode)
+{
+	return list_entry(inode, struct squashfs_inode_info, vfs_inode);
+}
+
+/* block.c */
+extern int squashfs_read_data(struct super_block *, void *,
+				long long, int, long long *, int);
+
+/* cache.c */
+extern struct squashfs_cache *squashfs_cache_init(char *, int, int, int);
+extern void squashfs_cache_delete(struct squashfs_cache *);
+struct squashfs_cache_entry *squashfs_cache_get(struct super_block *,
+				struct squashfs_cache *, long long, int);
+void squashfs_cache_put(struct squashfs_cache *, struct squashfs_cache_entry *);
+extern int squashfs_read_metadata(struct super_block *, void *,
+				long long *, int *, int);
+extern struct squashfs_cache_entry *get_cached_fragment(struct super_block *,
+				long long, int);
+extern void release_cached_fragment(struct squashfs_sb_info *,
+				struct squashfs_cache_entry *);
+
+/* export.c */
+extern __le64 *read_inode_lookup_table(struct super_block *, long long,
+			unsigned int);
+
+/* fragment.c */
+extern int get_fragment_location(struct super_block *, unsigned int,
+				long long *);
+extern __le64 *read_fragment_index_table(struct super_block *, long long,
+				unsigned int);
+
+/* id.c */
+extern int squashfs_get_id(struct super_block *, unsigned int, unsigned int *);
+extern __le64 *read_id_index_table(struct super_block *, long long,
+			unsigned short);
+
+/* inode.c */
+extern struct inode *squashfs_iget(struct super_block *, long long,
+			unsigned int);
+extern int squashfs_read_inode(struct inode *, long long);
+
+/*
+ * Inodes and files operations
+ */
+
+/* dir.c */
+extern const struct file_operations squashfs_dir_ops;
+
+/* export.c */
+extern const struct export_operations squashfs_export_ops;
+
+/* file.c */
+extern const struct address_space_operations squashfs_aops;
+
+/* namei.c */
+extern const struct inode_operations squashfs_dir_inode_ops;
+
+/* symlink.c */
+extern const struct address_space_operations squashfs_symlink_aops;
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
new file mode 100644
index 0000000..eef85b1
--- /dev/null
+++ b/fs/squashfs/squashfs_fs.h
@@ -0,0 +1,380 @@
+#ifndef SQUASHFS_FS
+#define SQUASHFS_FS
+/*
+ * Squashfs
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
+ * squashfs_fs.h
+ */
+
+#define SQUASHFS_CACHED_FRAGMENTS	CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE
+#define SQUASHFS_MAJOR			4
+#define SQUASHFS_MINOR			0
+#define SQUASHFS_MAGIC			0x73717368
+#define SQUASHFS_START			0
+
+/* size of metadata (inode and directory) blocks */
+#define SQUASHFS_METADATA_SIZE		8192
+#define SQUASHFS_METADATA_LOG		13
+
+/* default size of data blocks */
+#define SQUASHFS_FILE_SIZE		131072
+#define SQUASHFS_FILE_LOG		17
+
+#define SQUASHFS_FILE_MAX_SIZE		1048576
+
+/* Max number of uids and gids */
+#define SQUASHFS_IDS			65536
+
+/* Max length of filename (not 255) */
+#define SQUASHFS_NAME_LEN		256
+
+#define SQUASHFS_INVALID_FRAG		(0xffffffffU)
+#define SQUASHFS_INVALID_BLK		(-1LL)
+
+/* Filesystem flags */
+#define SQUASHFS_NOI			0
+#define SQUASHFS_NOD			1
+#define SQUASHFS_NOF			3
+#define SQUASHFS_NO_FRAG		4
+#define SQUASHFS_ALWAYS_FRAG		5
+#define SQUASHFS_DUPLICATE		6
+#define SQUASHFS_EXPORT			7
+
+#define SQUASHFS_BIT(flag, bit)		((flag >> bit) & 1)
+
+#define SQUASHFS_UNCOMPRESSED_INODES(flags)	SQUASHFS_BIT(flags, \
+						SQUASHFS_NOI)
+
+#define SQUASHFS_UNCOMPRESSED_DATA(flags)	SQUASHFS_BIT(flags, \
+						SQUASHFS_NOD)
+
+#define SQUASHFS_UNCOMPRESSED_FRAGMENTS(flags)	SQUASHFS_BIT(flags, \
+						SQUASHFS_NOF)
+
+#define SQUASHFS_NO_FRAGMENTS(flags)		SQUASHFS_BIT(flags, \
+						SQUASHFS_NO_FRAG)
+
+#define SQUASHFS_ALWAYS_FRAGMENTS(flags)	SQUASHFS_BIT(flags, \
+						SQUASHFS_ALWAYS_FRAG)
+
+#define SQUASHFS_DUPLICATES(flags)		SQUASHFS_BIT(flags, \
+						SQUASHFS_DUPLICATE)
+
+#define SQUASHFS_EXPORTABLE(flags)		SQUASHFS_BIT(flags, \
+						SQUASHFS_EXPORT)
+
+/* Max number of types and file types */
+#define SQUASHFS_DIR_TYPE		1
+#define SQUASHFS_REG_TYPE		2
+#define SQUASHFS_SYMLINK_TYPE		3
+#define SQUASHFS_BLKDEV_TYPE		4
+#define SQUASHFS_CHRDEV_TYPE		5
+#define SQUASHFS_FIFO_TYPE		6
+#define SQUASHFS_SOCKET_TYPE		7
+#define SQUASHFS_LDIR_TYPE		8
+#define SQUASHFS_LREG_TYPE		9
+#define SQUASHFS_LSYMLINK_TYPE		10
+#define SQUASHFS_LBLKDEV_TYPE		11
+#define SQUASHFS_LCHRDEV_TYPE		12
+#define SQUASHFS_LFIFO_TYPE		13
+#define SQUASHFS_LSOCKET_TYPE		14
+
+/* Flag whether block is compressed or uncompressed, bit is set if block is
+ * uncompressed */
+#define SQUASHFS_COMPRESSED_BIT		(1 << 15)
+
+#define SQUASHFS_COMPRESSED_SIZE(B)	(((B) & ~SQUASHFS_COMPRESSED_BIT) ? \
+		(B) & ~SQUASHFS_COMPRESSED_BIT :  SQUASHFS_COMPRESSED_BIT)
+
+#define SQUASHFS_COMPRESSED(B)		(!((B) & SQUASHFS_COMPRESSED_BIT))
+
+#define SQUASHFS_COMPRESSED_BIT_BLOCK	(1 << 24)
+
+#define SQUASHFS_COMPRESSED_SIZE_BLOCK(B)	((B) & \
+						~SQUASHFS_COMPRESSED_BIT_BLOCK)
+
+#define SQUASHFS_COMPRESSED_BLOCK(B)	(!((B) & SQUASHFS_COMPRESSED_BIT_BLOCK))
+
+/*
+ * Inode number ops.  Inodes consist of a compressed block number, and an
+ * uncompressed offset within that block
+ */
+#define SQUASHFS_INODE_BLK(A)		((unsigned int) ((A) >> 16))
+
+#define SQUASHFS_INODE_OFFSET(A)	((unsigned int) ((A) & 0xffff))
+
+#define SQUASHFS_MKINODE(A, B)		((long long)(((long long) (A)\
+					<< 16) + (B)))
+
+/* Translate between VFS mode and squashfs mode */
+#define SQUASHFS_MODE(A)		((A) & 0xfff)
+
+/* fragment and fragment table defines */
+#define SQUASHFS_FRAGMENT_BYTES(A)	\
+				((A) * sizeof(struct squashfs_fragment_entry))
+
+#define SQUASHFS_FRAGMENT_INDEX(A)	(SQUASHFS_FRAGMENT_BYTES(A) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_FRAGMENT_INDEX_OFFSET(A)	(SQUASHFS_FRAGMENT_BYTES(A) % \
+						SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_FRAGMENT_INDEXES(A)	((SQUASHFS_FRAGMENT_BYTES(A) + \
+					SQUASHFS_METADATA_SIZE - 1) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_FRAGMENT_INDEX_BYTES(A)	(SQUASHFS_FRAGMENT_INDEXES(A) *\
+						sizeof(long long))
+
+/* inode lookup table defines */
+#define SQUASHFS_LOOKUP_BYTES(A)	((A) * sizeof(long long))
+
+#define SQUASHFS_LOOKUP_BLOCK(A)	(SQUASHFS_LOOKUP_BYTES(A) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_LOOKUP_BLOCK_OFFSET(A)	(SQUASHFS_LOOKUP_BYTES(A) % \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_LOOKUP_BLOCKS(A)	((SQUASHFS_LOOKUP_BYTES(A) + \
+					SQUASHFS_METADATA_SIZE - 1) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_LOOKUP_BLOCK_BYTES(A)	(SQUASHFS_LOOKUP_BLOCKS(A) *\
+					sizeof(long long))
+
+/* uid/gid lookup table defines */
+#define SQUASHFS_ID_BYTES(A)		((A) * sizeof(unsigned int))
+
+#define SQUASHFS_ID_BLOCK(A)		(SQUASHFS_ID_BYTES(A) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_ID_BLOCK_OFFSET(A)	(SQUASHFS_ID_BYTES(A) % \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_ID_BLOCKS(A)		((SQUASHFS_ID_BYTES(A) + \
+					SQUASHFS_METADATA_SIZE - 1) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
+					sizeof(long long))
+
+/* cached data constants for filesystem */
+#define SQUASHFS_CACHED_BLKS		8
+
+#define SQUASHFS_MAX_FILE_SIZE_LOG	64
+
+#define SQUASHFS_MAX_FILE_SIZE		(1LL << \
+					(SQUASHFS_MAX_FILE_SIZE_LOG - 2))
+
+#define SQUASHFS_MARKER_BYTE		0xff
+
+/* meta index cache */
+#define SQUASHFS_META_INDEXES	(SQUASHFS_METADATA_SIZE / sizeof(unsigned int))
+#define SQUASHFS_META_ENTRIES	127
+#define SQUASHFS_META_SLOTS	8
+
+struct meta_entry {
+	long long		data_block;
+	unsigned int		index_block;
+	unsigned short		offset;
+	unsigned short		pad;
+};
+
+struct meta_index {
+	unsigned int		inode_number;
+	unsigned int		offset;
+	unsigned short		entries;
+	unsigned short		skip;
+	unsigned short		locked;
+	unsigned short		pad;
+	struct meta_entry	meta_entry[SQUASHFS_META_ENTRIES];
+};
+
+
+/*
+ * definitions for structures on disk
+ */
+#define ZLIB_COMPRESSION	 1
+
+struct squashfs_super_block {
+	__le32			s_magic;
+	__le32			inodes;
+	__le32			mkfs_time;
+	__le32			block_size;
+	__le32			fragments;
+	__le16			compression;
+	__le16			block_log;
+	__le16			flags;
+	__le16			no_ids;
+	__le16			s_major;
+	__le16			s_minor;
+	__le64			root_inode;
+	__le64			bytes_used;
+	__le64			id_table_start;
+	__le64			xattr_table_start;
+	__le64			inode_table_start;
+	__le64			directory_table_start;
+	__le64			fragment_table_start;
+	__le64			lookup_table_start;
+};
+
+struct squashfs_dir_index {
+	__le32			index;
+	__le32			start_block;
+	__le32			size;
+	unsigned char		name[0];
+};
+
+struct squashfs_base_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+};
+
+struct squashfs_ipc_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			nlink;
+};
+
+struct squashfs_dev_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			nlink;
+	__le32			rdev;
+};
+
+struct squashfs_symlink_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			nlink;
+	__le32			symlink_size;
+	char			symlink[0];
+};
+
+struct squashfs_reg_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			start_block;
+	__le32			fragment;
+	__le32			offset;
+	__le32			file_size;
+	__le16			block_list[0];
+};
+
+struct squashfs_lreg_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le64			start_block;
+	__le64			file_size;
+	__le64			sparse;
+	__le32			nlink;
+	__le32			fragment;
+	__le32			offset;
+	__le32			xattr;
+	__le16			block_list[0];
+};
+
+struct squashfs_dir_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			start_block;
+	__le32			nlink;
+	__le16			file_size;
+	__le16			offset;
+	__le32			parent_inode;
+};
+
+struct squashfs_ldir_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			nlink;
+	__le32			file_size;
+	__le32			start_block;
+	__le32			parent_inode;
+	__le16			i_count;
+	__le16			offset;
+	__le32			xattr;
+	struct squashfs_dir_index	index[0];
+};
+
+union squashfs_inode {
+	struct squashfs_base_inode		base;
+	struct squashfs_dev_inode		dev;
+	struct squashfs_symlink_inode		symlink;
+	struct squashfs_reg_inode		reg;
+	struct squashfs_lreg_inode		lreg;
+	struct squashfs_dir_inode		dir;
+	struct squashfs_ldir_inode		ldir;
+	struct squashfs_ipc_inode		ipc;
+};
+
+struct squashfs_dir_entry {
+	__le16			offset;
+	__le16			inode_number;
+	__le16			type;
+	__le16			size;
+	char			name[0];
+};
+
+struct squashfs_dir_header {
+	__le32			count;
+	__le32			start_block;
+	__le32			inode_number;
+};
+
+struct squashfs_fragment_entry {
+	__le64			start_block;
+	__le32			size;
+	unsigned int		unused;
+};
+
+#endif
diff --git a/fs/squashfs/squashfs_fs_i.h b/fs/squashfs/squashfs_fs_i.h
new file mode 100644
index 0000000..f78e6f8
--- /dev/null
+++ b/fs/squashfs/squashfs_fs_i.h
@@ -0,0 +1,45 @@
+#ifndef SQUASHFS_FS_I
+#define SQUASHFS_FS_I
+/*
+ * Squashfs
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
+ * squashfs_fs_i.h
+ */
+
+struct squashfs_inode_info {
+	long long	start;
+	int		offset;
+	union {
+		struct {
+			long long	fragment_block;
+			int		fragment_size;
+			int		fragment_offset;
+			long long	block_list_start;
+		};
+		struct {
+			long long	dir_idx_start;
+			int		dir_idx_offset;
+			int		dir_idx_cnt;
+			int		parent;
+		};
+	};
+	struct inode	vfs_inode;
+};
+#endif
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
new file mode 100644
index 0000000..cc9fd5d
--- /dev/null
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -0,0 +1,76 @@
+#ifndef SQUASHFS_FS_SB
+#define SQUASHFS_FS_SB
+/*
+ * Squashfs
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
+ * squashfs_fs_sb.h
+ */
+
+#include "squashfs_fs.h"
+
+struct squashfs_cache_entry {
+	long long		block;
+	int			length;
+	int			locked;
+	long long		next_index;
+	char			pending;
+	char			error;
+	int			waiting;
+	wait_queue_head_t	wait_queue;
+	char			*data;
+};
+
+struct squashfs_cache {
+	char			*name;
+	int			entries;
+	int			block_size;
+	int			next_blk;
+	int			waiting;
+	int			unused;
+	int			use_vmalloc;
+	spinlock_t		lock;
+	wait_queue_head_t	wait_queue;
+	struct squashfs_cache_entry entry[0];
+};
+
+struct squashfs_sb_info {
+	int			devblksize;
+	int			devblksize_log2;
+	struct squashfs_cache	*block_cache;
+	struct squashfs_cache	*fragment_cache;
+	int			next_meta_index;
+	__le64			*id_table;
+	__le64			*fragment_index;
+	unsigned int		*fragment_index_2;
+	char			*read_page;
+	struct mutex		read_data_mutex;
+	struct mutex		read_page_mutex;
+	struct mutex		meta_index_mutex;
+	struct meta_index	*meta_index;
+	z_stream		stream;
+	__le64			*inode_lookup_table;
+	long long		inode_table;
+	long long		directory_table;
+	unsigned int		block_size;
+	unsigned short		block_log;
+	long long		bytes_used;
+	unsigned int		inodes;
+};
+#endif
-- 
1.5.2.5

