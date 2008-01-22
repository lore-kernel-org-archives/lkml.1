Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbYAVDOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbYAVDOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760156AbYAVDGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:52 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760056AbYAVDGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:48 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 10/49] ext4: Rename i_dir_acl to i_size_high
Date: Mon, 21 Jan 2008 22:01:49 -0500
Message-Id: <1200970948-17903-11-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-10-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Rename ext4_inode.i_dir_acl to i_size_high
drop ext4_inode_info.i_dir_acl as it is not used
Rename ext4_inode.i_size to ext4_inode.i_size_lo
Add helper function for accessing the ext4_inode combined i_size.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c          |    1 -
 fs/ext4/inode.c           |   55 ++++++++++++++++++---------------------------
 include/linux/ext4_fs.h   |   15 +++++++++--
 include/linux/ext4_fs_i.h |    1 -
 4 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00b152b..17b5df1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -709,7 +709,6 @@ got:
 	if (!S_ISDIR(mode))
 		ei->i_flags &= ~EXT4_DIRSYNC_FL;
 	ei->i_file_acl = 0;
-	ei->i_dir_acl = 0;
 	ei->i_dtime = 0;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7bcec18..e663455 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2694,7 +2694,6 @@ void ext4_read_inode(struct inode * inode)
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
-	inode->i_size = le32_to_cpu(raw_inode->i_size);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2720,15 +2719,11 @@ void ext4_read_inode(struct inode * inode)
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
-	    cpu_to_le32(EXT4_OS_HURD))
+	    cpu_to_le32(EXT4_OS_HURD)) {
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
-	if (!S_ISREG(inode->i_mode)) {
-		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
-	} else {
-		inode->i_size |=
-			((__u64)le32_to_cpu(raw_inode->i_size_high)) << 32;
 	}
+	inode->i_size = ext4_isize(raw_inode);
 	ei->i_disksize = inode->i_size;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 	ei->i_block_group = iloc.block_group;
@@ -2852,7 +2847,6 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_gid_high = 0;
 	}
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
-	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
 
 	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
 	EXT4_INODE_SET_XTIME(i_mtime, inode, raw_inode);
@@ -2867,32 +2861,27 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_file_acl_high =
 			cpu_to_le16(ei->i_file_acl >> 32);
 	raw_inode->i_file_acl_lo = cpu_to_le32(ei->i_file_acl);
-	if (!S_ISREG(inode->i_mode)) {
-		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
-	} else {
-		raw_inode->i_size_high =
-			cpu_to_le32(ei->i_disksize >> 32);
-		if (ei->i_disksize > 0x7fffffffULL) {
-			struct super_block *sb = inode->i_sb;
-			if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_LARGE_FILE) ||
-			    EXT4_SB(sb)->s_es->s_rev_level ==
-					cpu_to_le32(EXT4_GOOD_OLD_REV)) {
-			       /* If this is the first large file
-				* created, add a flag to the superblock.
-				*/
-				err = ext4_journal_get_write_access(handle,
-						EXT4_SB(sb)->s_sbh);
-				if (err)
-					goto out_brelse;
-				ext4_update_dynamic_rev(sb);
-				EXT4_SET_RO_COMPAT_FEATURE(sb,
+	ext4_isize_set(raw_inode, ei->i_disksize);
+	if (ei->i_disksize > 0x7fffffffULL) {
+		struct super_block *sb = inode->i_sb;
+		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				EXT4_FEATURE_RO_COMPAT_LARGE_FILE) ||
+				EXT4_SB(sb)->s_es->s_rev_level ==
+				cpu_to_le32(EXT4_GOOD_OLD_REV)) {
+			/* If this is the first large file
+			 * created, add a flag to the superblock.
+			 */
+			err = ext4_journal_get_write_access(handle,
+					EXT4_SB(sb)->s_sbh);
+			if (err)
+				goto out_brelse;
+			ext4_update_dynamic_rev(sb);
+			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
-				sb->s_dirt = 1;
-				handle->h_sync = 1;
-				err = ext4_journal_dirty_metadata(handle,
-						EXT4_SB(sb)->s_sbh);
-			}
+			sb->s_dirt = 1;
+			handle->h_sync = 1;
+			err = ext4_journal_dirty_metadata(handle,
+					EXT4_SB(sb)->s_sbh);
 		}
 	}
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 6894f36..a8f3fae 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -275,7 +275,7 @@ struct ext4_mount_options {
 struct ext4_inode {
 	__le16	i_mode;		/* File mode */
 	__le16	i_uid;		/* Low 16 bits of Owner Uid */
-	__le32	i_size;		/* Size in bytes */
+	__le32	i_size_lo;	/* Size in bytes */
 	__le32	i_atime;	/* Access time */
 	__le32	i_ctime;	/* Inode Change time */
 	__le32	i_mtime;	/* Modification time */
@@ -298,7 +298,7 @@ struct ext4_inode {
 	__le32	i_block[EXT4_N_BLOCKS];/* Pointers to blocks */
 	__le32	i_generation;	/* File version (for NFS) */
 	__le32	i_file_acl_lo;	/* File ACL */
-	__le32	i_dir_acl;	/* Directory ACL */
+	__le32	i_size_high;
 	__le32	i_obso_faddr;	/* Obsoleted fragment address */
 	union {
 		struct {
@@ -330,7 +330,6 @@ struct ext4_inode {
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
 };
 
-#define i_size_high	i_dir_acl
 
 #define EXT4_EPOCH_BITS 2
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
@@ -1049,7 +1048,17 @@ static inline void ext4_r_blocks_count_set(struct ext4_super_block *es,
 	es->s_r_blocks_count_hi = cpu_to_le32(blk >> 32);
 }
 
+static inline loff_t ext4_isize(struct ext4_inode *raw_inode)
+{
+	return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
+		le32_to_cpu(raw_inode->i_size_lo);
+}
 
+static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
+{
+	raw_inode->i_size_lo = cpu_to_le32(i_size);
+	raw_inode->i_size_high = cpu_to_le32(i_size >> 32);
+}
 
 #define ext4_std_error(sb, errno)				\
 do {								\
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index 2b4e370..f1cd493 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -85,7 +85,6 @@ struct ext4_inode_info {
 	__le32	i_data[15];	/* unconverted */
 	__u32	i_flags;
 	ext4_fsblk_t	i_file_acl;
-	__u32	i_dir_acl;
 	__u32	i_dtime;
 
 	/*
-- 
1.5.4.rc3.31.g1271-dirty

