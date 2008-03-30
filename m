Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYC3DRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYC3DRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 23:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYC3DRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 23:17:30 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:52439 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYC3DR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 23:17:29 -0400
Date: Sat, 29 Mar 2008 23:16:45 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Arnd Bergmann <arnd@arndb.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/7] omfs: define filesystem structures
Message-ID: <20080330031645.GA18825@hash.localnet>
References: <1206578760-9050-1-git-send-email-me@bobcopeland.com> <20080328201940.GA3974@ucw.cz> <20080328231833.GA16515@hash.localnet> <200803290415.43189.arnd@arndb.de> <20080329152920.GA10653@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329152920.GA10653@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of this patch, with these changes:
 - remove unnecessary omfs_inode_info
 - update prototype for omfs_update_checksums to kill unused params

>From b2f65cb52dea81ff51489be3af791936fc4b336c Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Thu, 27 Mar 2008 17:22:47 -0400
Subject: [PATCH] omfs: define filesystem structures

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
 fs/omfs/omfs.h |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/omfs.h

diff --git a/fs/omfs/omfs.h b/fs/omfs/omfs.h
new file mode 100644
index 0000000..349764b
--- /dev/null
+++ b/fs/omfs/omfs.h
@@ -0,0 +1,137 @@
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
+/* bitmap.c */
+extern unsigned long omfs_count_free(struct super_block *sb);
+extern int omfs_allocate_block(struct super_block *sb, u64 block);
+extern int omfs_allocate_range(struct super_block *sb, int min_request,
+			int max_request, u64 *return_block, int *return_size);
+extern int omfs_clear_range(struct super_block *sb, u64 block, int count);
+
+/* checksum.c */
+int omfs_update_checksums(struct omfs_inode *oi);
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


