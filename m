Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbXLWBx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbXLWBx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXLWBxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:53:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbXLWBxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=CKeKiKHej+FJ/q8d4vvQqMSbdW0Du9yW5DpXOxAyEv+IR43qFuoN+XnrzRUjekBN4dvNWTVN1WHq+QPIkMyDOYu8a1N1rSJd+f4f7LpmlZiktZ/K5GwD0hGx9EEDp1oRmDg2VHs3wufDmEj2ZXBsuihUyew9PA4jPlDGeiuNnl8=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 10/24] udf: convert UDF_SB_LVIDBH macro to udf_sb_lvid_bh function
Date: Sun, 23 Dec 2007 02:51:00 +0100
Message-Id: <1198374674-12128-11-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change UDF_SB_LVIDBH macro to udf_sb_lvid_bh inline function
- rename s_lvidbh field to s_lvid_bh

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c           |   26 +++++++++++++-------------
 fs/udf/ialloc.c           |    8 ++++----
 fs/udf/namei.c            |    8 ++++----
 fs/udf/super.c            |   26 +++++++++++++-------------
 fs/udf/udf_sb.h           |    8 ++++++--
 include/linux/udf_fs_sb.h |    2 +-
 6 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index e313d80..d689d16 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -188,7 +188,7 @@ do_more:
 		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
-			if (UDF_SB_LVIDBH(sb)) {
+			if (udf_sb_lvid_bh(sb)) {
 				UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)] =
 					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]) + 1);
 			}
@@ -202,8 +202,8 @@ do_more:
 	}
 error_return:
 	sb->s_dirt = 1;
-	if (UDF_SB_LVIDBH(sb))
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+	if (udf_sb_lvid_bh(sb))
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return;
 }
@@ -261,10 +261,10 @@ repeat:
 	if (block_count > 0)
 		goto repeat;
 out:
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -389,10 +389,10 @@ got_block:
 
 	mark_buffer_dirty(bh);
 
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -432,10 +432,10 @@ static void udf_table_free_blocks(struct super_block *sb,
 	   but.. oh well */
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]) + count);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 
 	start = bloc.logicalBlockNum + offset;
@@ -670,10 +670,10 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 
 	brelse(epos.bh);
 
-	if (alloc_count && UDF_SB_LVIDBH(sb)) {
+	if (alloc_count && udf_sb_lvid_bh(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 		sb->s_dirt = 1;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -771,10 +771,10 @@ static int udf_table_new_block(struct super_block *sb,
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
 	brelse(goal_epos.bh);
 
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 
 	sb->s_dirt = 1;
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 92dc9ae..5cfac06 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -43,7 +43,7 @@ void udf_free_inode(struct inode *inode)
 	clear_inode(inode);
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (sbi->s_lvidbh) {
+	if (sbi->s_lvid_bh) {
 		if (S_ISDIR(inode->i_mode))
 			UDF_SB_LVIDIU(sb)->numDirs =
 				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) - 1);
@@ -51,7 +51,7 @@ void udf_free_inode(struct inode *inode)
 			UDF_SB_LVIDIU(sb)->numFiles =
 				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
 
-		mark_buffer_dirty(sbi->s_lvidbh);
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
 
@@ -88,7 +88,7 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	}
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
 		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->logicalVolContentsUse);
@@ -102,7 +102,7 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 	inode->i_mode = mode;
 	inode->i_uid = current->fsuid;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 066153f..4122d2b 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1014,7 +1014,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_no_entry;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb)) {
+	if (udf_sb_lvid_bh(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
 		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
@@ -1024,7 +1024,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
-		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(inode->i_sb));
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
@@ -1066,7 +1066,7 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb)) {
+	if (udf_sb_lvid_bh(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
 		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
@@ -1076,7 +1076,7 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
-		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(inode->i_sb));
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e641d8f..b1f02a4 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -475,7 +475,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	udf_sb(sb)->s_gid   = uopt.gid;
 	udf_sb(sb)->s_umask = uopt.umask;
 
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		int write_rev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
 		if (write_rev > UDF_MAX_WRITE_VERSION)
 			*flags |= MS_RDONLY;
@@ -1097,18 +1097,18 @@ static void udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
 	       (bh = udf_read_tagged(sb, loc.extLocation,
 				     loc.extLocation, &ident)) &&
 	       ident == TAG_IDENT_LVID) {
-		UDF_SB_LVIDBH(sb) = bh;
+		udf_sb(sb)->s_lvid_bh = bh;
 
 		if (UDF_SB_LVID(sb)->nextIntegrityExt.extLength)
 			udf_load_logicalvolint(sb,
 				leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
 
-		if (UDF_SB_LVIDBH(sb) != bh)
+		if (udf_sb_lvid_bh(sb) != bh)
 			brelse(bh);
 		loc.extLength -= sb->s_blocksize;
 		loc.extLocation++;
 	}
-	if (UDF_SB_LVIDBH(sb) != bh)
+	if (udf_sb_lvid_bh(sb) != bh)
 		brelse(bh);
 }
 
@@ -1377,7 +1377,7 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 
 static void udf_open_lvid(struct super_block *sb)
 {
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		int i;
 		kernel_timestamp cpu_time;
 
@@ -1396,7 +1396,7 @@ static void udf_open_lvid(struct super_block *sb)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
 					((uint8_t *) &(UDF_SB_LVID(sb)->descTag))[i];
 
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 }
 
@@ -1405,7 +1405,7 @@ static void udf_close_lvid(struct super_block *sb)
 	kernel_timestamp cpu_time;
 	int i;
 
-	if (UDF_SB_LVIDBH(sb) &&
+	if (udf_sb_lvid_bh(sb) &&
 	    UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
@@ -1429,7 +1429,7 @@ static void udf_close_lvid(struct super_block *sb)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
 					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
 
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 }
 
@@ -1539,7 +1539,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 	udf_debug("Lastblock=%d\n", udf_sb_last_block(sb));
 
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		uint16_t minUDFReadRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
 		uint16_t minUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
 		/* uint16_t maxUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev); */
@@ -1631,7 +1631,7 @@ error_out:
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
-	brelse(UDF_SB_LVIDBH(sb));
+	brelse(udf_sb_lvid_bh(sb));
 	udf_sb_free(sb);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
@@ -1706,7 +1706,7 @@ static void udf_put_super(struct super_block *sb)
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
-	brelse(UDF_SB_LVIDBH(sb));
+	brelse(udf_sb_lvid_bh(sb));
 	udf_sb_free(sb);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
@@ -1734,7 +1734,7 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_blocks = UDF_SB_PARTLEN(sb, udf_sb_partition(sb));
 	buf->f_bfree = udf_count_free(sb);
 	buf->f_bavail = buf->f_bfree;
-	buf->f_files = (UDF_SB_LVIDBH(sb) ?
+	buf->f_files = (udf_sb_lvid_bh(sb) ?
 			(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
 			 le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) + buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
@@ -1837,7 +1837,7 @@ static unsigned int udf_count_free(struct super_block *sb)
 {
 	unsigned int accum = 0;
 
-	if (UDF_SB_LVIDBH(sb)) {
+	if (udf_sb_lvid_bh(sb)) {
 		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > udf_sb_partition(sb)) {
 			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]);
 			if (accum == 0xFFFFFFFF)
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index ea4ec0f..dd0ba67 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -85,6 +85,11 @@ static inline __u32 udf_sb_last_block(struct super_block *sb)
 	return udf_sb(sb)->s_last_block;
 }
 
+static inline struct buffer_head *udf_sb_lvid_bh(struct super_block *sb)
+{
+	return udf_sb(sb)->s_lvid_bh;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -149,8 +154,7 @@ static inline __u32 udf_sb_last_block(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_LVIDBH(X)			( udf_sb(X)->s_lvidbh )
-#define UDF_SB_LVID(X)				( (struct logicalVolIntegrityDesc *)UDF_SB_LVIDBH(X)->b_data )
+#define UDF_SB_LVID(X)				( (struct logicalVolIntegrityDesc *)udf_sb_lvid_bh(X)->b_data )
 #define UDF_SB_LVIDIU(X)			( (struct logicalVolIntegrityDescImpUse *)&(UDF_SB_LVID(X)->impUse[le32_to_cpu(UDF_SB_LVID(X)->numOfPartitions) * 2 * sizeof(uint32_t)/sizeof(uint8_t)]) )
 
 #define UDF_SB_UMASK(X)				( udf_sb(X)->s_umask )
diff --git a/include/linux/udf_fs_sb.h b/include/linux/udf_fs_sb.h
index 2f46ce6..a9f19ab 100644
--- a/include/linux/udf_fs_sb.h
+++ b/include/linux/udf_fs_sb.h
@@ -86,7 +86,7 @@ struct udf_sb_info
 	__u32			s_anchor[4];
 	__u32			s_last_block;
 
-	struct buffer_head	*s_lvidbh;
+	struct buffer_head	*s_lvid_bh;
 
 	/* Default permissions */
 	mode_t			s_umask;
-- 
1.5.3.4

