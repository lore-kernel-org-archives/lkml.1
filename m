Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYC0BVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYC0BVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbYC0BTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:19:46 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:48665 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbYC0BTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:19:19 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/7] omfs: define filesystem structures
Date: Wed, 26 Mar 2008 20:45:54 -0400
Message-Id: <1206578760-9050-1-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMFS is a proprietary filesystem created for the ReplayTV and
also used by the Rio Karma.  It uses hash tables with unordered,
unbounded lists in each bucket for directories, extents for
data blocks, 64-bit addressing for blocks, with up to 8K blocks
(only 2K of a given block is ever used for metadata, so the FS
still works with 4K pages).

This and the following set of changes add support for OMFS; this
change adds the header file.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
Hi all,

I've been maintaining this reverse-engineered filesystem
out-of-tree since around 2.6.12.  It has stabilized to the point
that, while not quite feature-complete, it is close enough that
I'm pretty much just applying VFS API updates to it these days.
So, in the spirit of stable_api_nonsense, I request that it be
considered for inclusion for .26 or later.

There is a small user community (<20?) using the driver today.
According to google, it has been packaged by others for Debian,
Ubuntu, and Mandriva.

I have also written an implementation in FUSE.  However, in
its current unoptimized state, it's about half the speed of the
kernel driver.  Either way, the kernel version could use a review 
given some distros have apparently picked it up.

 fs/omfs/omfs.h |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 150 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/omfs.h

diff --git a/fs/omfs/omfs.h b/fs/omfs/omfs.h
new file mode 100644
index 0000000..4a602e9
--- /dev/null
+++ b/fs/omfs/omfs.h
@@ -0,0 +1,150 @@
+#ifndef _OMFS_H
+#define _OMFS_H
+
+#include <linux/module.h>
+#include <linux/fs.h>
+
+#define OMFS_MAGIC 0xC2993D87
+#define OMFS_IMAGIC 0xD2
+
+#define OMFS_DIR 'D'
+#define OMFS_FILE 'F'
+#define OMFS_INODE_NORMAL 'e'
+#define OMFS_INODE_CONTINUATION 'c'
+#define OMFS_INODE_SYSTEM 's'
+#define OMFS_NAMELEN 256
+#define OMFS_DIR_START 0x1b8
+#define OMFS_EXTENT_START 0x1d0
+#define OMFS_EXTENT_CONT 0x40
+#define OMFS_XOR_COUNT 19
+
+#define OMFS_STATE_NEW 1
+
+/* In-memory structures */
+struct omfs_sb_info {
+	u64 s_num_blocks;
+	u64 s_bitmap_ino;
+	u64 s_root_ino;
+	u32 s_blocksize;
+	u32 s_mirrors;
+	u32 s_sys_blocksize;
+	u32 s_clustersize;
+	int s_block_shift;
+	unsigned long **s_imap;
+	int s_imap_size;
+	struct mutex s_bitmap_lock;
+};
+
+struct omfs_inode_info {
+	u8 i_state;
+	struct inode vfs_inode;
+};
+
+/* On-disk structures */
+struct omfs_super_block {
+	char s_fill1[256];
+	__be64 s_root_block;
+	__be64 s_num_blocks;
+	__be32 s_magic;
+	__be32 s_blocksize;
+	__be32 s_mirrors;
+	__be32 s_sys_blocksize;
+};
+
+struct omfs_header {
+	__be64 h_self;
+	__be32 h_body_size;
+	__be16 h_crc;
+	char h_fill1[2];
+	u8 h_version;
+	char h_type;
+	u8 h_magic;
+	u8 h_check_xor;
+	__be32 h_fill2;
+};
+
+struct omfs_root_block {
+	struct omfs_header r_head;
+	__be64 r_fill1;
+	__be64 r_num_blocks;
+	__be64 r_root_dir;
+	__be64 r_bitmap;
+	__be32 r_blocksize;
+	__be32 r_clustersize;
+	__be64 r_mirrors;
+	char r_name[OMFS_NAMELEN];
+};
+
+struct omfs_inode {
+	struct omfs_header i_head;
+	__be64 i_parent;
+	__be64 i_sibling;
+	__be64 i_ctime;
+	char i_fill1[35];
+	char i_type;
+	__be32 i_fill2;
+	char i_fill3[64];
+	char i_name[OMFS_NAMELEN];
+	__be64 i_size;
+};
+
+struct omfs_extent_entry {
+	__be64 e_cluster;
+	__be64 e_blocks;
+};
+
+struct omfs_extent {
+	__be64 e_next;
+	__be32 e_extent_count;
+	__be32 e_fill;
+	struct omfs_extent_entry e_entry;
+};
+
+
+/* convert a cluster number to a 512-byte block number */
+static inline sector_t clus_to_blk(struct omfs_sb_info *sbi, sector_t block)
+{
+	return block << sbi->s_block_shift;
+}
+
+static inline struct omfs_sb_info *OMFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static inline struct omfs_inode_info *OMFS_I(struct inode *inode)
+{
+	return list_entry(inode, struct omfs_inode_info, vfs_inode);
+}
+
+/* bitmap.c */
+extern unsigned long omfs_count_free(struct super_block *sb);
+extern int omfs_allocate_block(struct super_block *sb, u64 block);
+extern int omfs_allocate_range(struct super_block *sb, int min_request,
+			int max_request, u64 *return_block, int *return_size);
+extern int omfs_clear_range(struct super_block *sb, u64 block, int count);
+
+/* checksum.c */
+int omfs_update_checksums(struct omfs_inode *oi, struct super_block *sb,
+		ino_t ino);
+
+/* dir.c */
+extern struct file_operations omfs_dir_operations;
+extern struct inode_operations omfs_dir_inops;
+extern int omfs_make_empty(struct inode *inode, struct super_block *sb);
+
+/* file.c */
+extern struct file_operations omfs_file_operations;
+extern struct inode_operations omfs_file_inops;
+extern struct address_space_operations omfs_aops;
+extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
+extern int omfs_shrink_inode(struct inode *inode);
+
+/* inode.c */
+extern struct inode *omfs_iget(struct super_block *sb, ino_t inode);
+extern struct inode *omfs_new_inode(struct inode *dir, int mode);
+extern int omfs_reserve_block(struct super_block *sb, sector_t block);
+extern int omfs_find_empty_block(struct super_block *sb, int mode, ino_t *ino);
+extern int omfs_sync_inode(struct inode *inode);
+
+#endif
-- 
1.5.4.2.182.gb3092


