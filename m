Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbYAVDNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbYAVDNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbYAVDGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:46 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162AbYAVDGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:44 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 12/49] ext4: Support large files
Date: Mon, 21 Jan 2008 22:01:51 -0500
Message-Id: <1200970948-17903-13-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-12-git-send-email-tytso@mit.edu>
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
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This patch converts ext4_inode i_blocks to represent total
blocks occupied by the inode in file system block size.
Earlier the variable used to represent this in 512 byte
block size. This actually limited the total size of the file.

The feature is enabled transparently when we write an inode
whose i_blocks cannot be represnted as 512 byte units in a
48 bit variable.

inode flag  EXT4_HUGE_FILE_FL

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c         |   32 +++++++++++++++++++++++++-------
 fs/ext4/super.c         |    9 ++++++---
 include/linux/ext4_fs.h |    3 ++-
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bb89fe7..9cf8572 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2671,14 +2671,20 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 					struct ext4_inode_info *ei)
 {
 	blkcnt_t i_blocks ;
-	struct super_block *sb = ei->vfs_inode.i_sb;
+	struct inode *inode = &(ei->vfs_inode);
+	struct super_block *sb = inode->i_sb;
 
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		/* we are using combined 48 bit field */
 		i_blocks = ((u64)le16_to_cpu(raw_inode->i_blocks_high)) << 32 |
 					le32_to_cpu(raw_inode->i_blocks_lo);
-		return i_blocks;
+		if (ei->i_flags & EXT4_HUGE_FILE_FL) {
+			/* i_blocks represent file system block size */
+			return i_blocks  << (inode->i_blkbits - 9);
+		} else {
+			return i_blocks;
+		}
 	} else {
 		return le32_to_cpu(raw_inode->i_blocks_lo);
 	}
@@ -2829,8 +2835,9 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 * i_blocks can be represnted in a 32 bit variable
 		 * as multiple of 512 bytes
 		 */
-		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
+		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = 0;
+		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
 	} else if (i_blocks <= 0xffffffffffffULL) {
 		/*
 		 * i_blocks can be represented in a 48 bit variable
@@ -2841,12 +2848,23 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		if (err)
 			goto  err_out;
 		/* i_block is stored in the split  48 bit fields */
-		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
+		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
+		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
 	} else {
-		ext4_error(sb, __FUNCTION__,
-				"Wrong inode i_blocks count  %llu\n",
-				(unsigned long long)inode->i_blocks);
+		/*
+		 * i_blocks should be represented in a 48 bit variable
+		 * as multiple of  file system block size
+		 */
+		err = ext4_update_rocompat_feature(handle, sb,
+					    EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
+		if (err)
+			goto  err_out;
+		ei->i_flags |= EXT4_HUGE_FILE_FL;
+		/* i_block is stored in file system block size */
+		i_blocks = i_blocks >> (inode->i_blkbits - 9);
+		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
+		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
 	}
 err_out:
 	return err;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2b9dc96..64067de 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1631,11 +1631,14 @@ static loff_t ext4_max_size(int bits)
 		upper_limit >>= (bits - 9);
 
 	} else {
-		/* We use 48 bit ext4_inode i_blocks */
+		/*
+		 * We use 48 bit ext4_inode i_blocks
+		 * With EXT4_HUGE_FILE_FL set the i_blocks
+		 * represent total number of blocks in
+		 * file system block size
+		 */
 		upper_limit = (1LL << 48) - 1;
 
-		/* total blocks in file system block size */
-		upper_limit >>= (bits - 9);
 	}
 
 	/* indirect blocks */
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index be25eca..6ae91f4 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -178,8 +178,9 @@ struct ext4_group_desc
 #define EXT4_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define EXT4_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
-#define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
+#define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
-- 
1.5.4.rc3.31.g1271-dirty

