Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbXLWByX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbXLWByX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbXLWByF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:54:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbXLWByD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:54:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=KzUnGw/NJpQwNmuMDikkZkyJ00DrLRKAl589GC7slEC6Z4PBgNqHqGBpbX75CLIo6QpzpFTBaveNRvndvzCCu0hGGVOx0TvaEtkDgsrta9Z/j2RLqdkS02JX5apSyWeNYac0T6+n1mbqAtssNTh4P5Cs8BSa2lupLJgYGmrs5Hw=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 12/24] udf: convert UDF_SB_LVIDIU macro to udf_sb_lvidiu function
Date: Sun, 23 Dec 2007 02:51:02 +0100
Message-Id: <1198374674-12128-13-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/ialloc.c |   16 ++++++++--------
 fs/udf/super.c  |   34 +++++++++++++++++-----------------
 fs/udf/udf_sb.h |   10 ++++++++--
 3 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index ddbf1e6..269f588 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -45,11 +45,11 @@ void udf_free_inode(struct inode *inode)
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (sbi->s_lvid_bh) {
 		if (S_ISDIR(inode->i_mode))
-			UDF_SB_LVIDIU(sb)->numDirs =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) - 1);
+			udf_sb_lvidiu(sb)->numDirs =
+				cpu_to_le32(le32_to_cpu(udf_sb_lvidiu(sb)->numDirs) - 1);
 		else
-			UDF_SB_LVIDIU(sb)->numFiles =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
+			udf_sb_lvidiu(sb)->numFiles =
+				cpu_to_le32(le32_to_cpu(udf_sb_lvidiu(sb)->numFiles) - 1);
 
 		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
@@ -93,11 +93,11 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		uint64_t uniqueID;
 		lvhd = (struct logicalVolHeaderDesc *)(udf_sb_lvid(sb)->logicalVolContentsUse);
 		if (S_ISDIR(mode))
-			UDF_SB_LVIDIU(sb)->numDirs =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) + 1);
+			udf_sb_lvidiu(sb)->numDirs =
+				cpu_to_le32(le32_to_cpu(udf_sb_lvidiu(sb)->numDirs) + 1);
 		else
-			UDF_SB_LVIDIU(sb)->numFiles =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) + 1);
+			udf_sb_lvidiu(sb)->numFiles =
+				cpu_to_le32(le32_to_cpu(udf_sb_lvidiu(sb)->numFiles) + 1);
 		UDF_I_UNIQUE(inode) = uniqueID = le64_to_cpu(lvhd->uniqueID);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index f9109c5..6c14c4d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -476,7 +476,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	udf_sb(sb)->s_umask = uopt.umask;
 
 	if (udf_sb_lvid_bh(sb)) {
-		int write_rev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
+		int write_rev = le16_to_cpu(udf_sb_lvidiu(sb)->minUDFWriteRev);
 		if (write_rev > UDF_MAX_WRITE_VERSION)
 			*flags |= MS_RDONLY;
 	}
@@ -1381,8 +1381,8 @@ static void udf_open_lvid(struct super_block *sb)
 		int i;
 		kernel_timestamp cpu_time;
 
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
+		udf_sb_lvidiu(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
+		udf_sb_lvidiu(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
 			udf_sb_lvid(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
 		udf_sb_lvid(sb)->integrityType = LVID_INTEGRITY_TYPE_OPEN;
@@ -1407,16 +1407,16 @@ static void udf_close_lvid(struct super_block *sb)
 
 	if (udf_sb_lvid_bh(sb) &&
 	    udf_sb_lvid(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
+		udf_sb_lvidiu(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
+		udf_sb_lvidiu(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
 			udf_sb_lvid(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
-		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev))
-			UDF_SB_LVIDIU(sb)->minUDFReadRev = cpu_to_le16(UDF_SB_UDFREV(sb));
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->minUDFWriteRev = cpu_to_le16(UDF_SB_UDFREV(sb));
+		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(udf_sb_lvidiu(sb)->maxUDFWriteRev))
+			udf_sb_lvidiu(sb)->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
+		if (UDF_SB_UDFREV(sb) > le16_to_cpu(udf_sb_lvidiu(sb)->minUDFReadRev))
+			udf_sb_lvidiu(sb)->minUDFReadRev = cpu_to_le16(UDF_SB_UDFREV(sb));
+		if (UDF_SB_UDFREV(sb) > le16_to_cpu(udf_sb_lvidiu(sb)->minUDFWriteRev))
+			udf_sb_lvidiu(sb)->minUDFWriteRev = cpu_to_le16(UDF_SB_UDFREV(sb));
 		udf_sb_lvid(sb)->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
 		udf_sb_lvid(sb)->descTag.descCRC =
@@ -1540,13 +1540,13 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	udf_debug("Lastblock=%d\n", udf_sb_last_block(sb));
 
 	if (udf_sb_lvid_bh(sb)) {
-		uint16_t minUDFReadRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
-		uint16_t minUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
-		/* uint16_t maxUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev); */
+		uint16_t minUDFReadRev = le16_to_cpu(udf_sb_lvidiu(sb)->minUDFReadRev);
+		uint16_t minUDFWriteRev = le16_to_cpu(udf_sb_lvidiu(sb)->minUDFWriteRev);
+		/* uint16_t maxUDFWriteRev = le16_to_cpu(udf_sb_lvidiu(sb)->maxUDFWriteRev); */
 
 		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
 			printk(KERN_ERR "UDF-fs: minUDFReadRev=%x (max is %x)\n",
-			       le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev),
+			       le16_to_cpu(udf_sb_lvidiu(sb)->minUDFReadRev),
 			       UDF_MAX_READ_VERSION);
 			goto error_out;
 		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION) {
@@ -1735,8 +1735,8 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bfree = udf_count_free(sb);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = (udf_sb_lvid_bh(sb) ?
-			(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
-			 le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) + buf->f_bfree;
+			(le32_to_cpu(udf_sb_lvidiu(sb)->numFiles) +
+			 le32_to_cpu(udf_sb_lvidiu(sb)->numDirs)) : 0) + buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
 	/* __kernel_fsid_t f_fsid */
 	buf->f_namelen = UDF_NAME_LEN - 2;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index ac222f6..a9ff8fb 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -95,6 +95,14 @@ static inline struct logicalVolIntegrityDesc *udf_sb_lvid(struct super_block *sb
 	return (struct logicalVolIntegrityDesc *)udf_sb_lvid_bh(sb)->b_data;
 }
 
+static inline struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_block *sb)
+{
+	struct logicalVolIntegrityDesc *lvid = udf_sb_lvid(sb);
+	__u32 number_of_partitions = le32_to_cpu(lvid->numOfPartitions);
+	__u32 offset = number_of_partitions * 2 * sizeof(uint32_t)/sizeof(uint8_t);
+	return (struct logicalVolIntegrityDescImpUse *)&(lvid->impUse[offset]);
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -159,8 +167,6 @@ static inline struct logicalVolIntegrityDesc *udf_sb_lvid(struct super_block *sb
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_LVIDIU(X)			( (struct logicalVolIntegrityDescImpUse *)&(udf_sb_lvid(X)->impUse[le32_to_cpu(udf_sb_lvid(X)->numOfPartitions) * 2 * sizeof(uint32_t)/sizeof(uint8_t)]) )
-
 #define UDF_SB_UMASK(X)				( udf_sb(X)->s_umask )
 #define UDF_SB_GID(X)				( udf_sb(X)->s_gid )
 #define UDF_SB_UID(X)				( udf_sb(X)->s_uid )
-- 
1.5.3.4

