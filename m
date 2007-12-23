Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbXLWBzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbXLWBzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbXLWBzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:55:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbXLWBzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=VjNkEqYdMzzOIomIEXVpE7jFMRql/faR919eEXGyKQnfrJyffSW340haYeQQLGDJPNnh7ZQ+6KeRvBIEXAiRmwj2Tk99icerP6kl2ILA5ldgWZWxmmB/MIEPUFa6ddVpEKmfwlfh4o5Jhi48/peecv/Sf8qG/eUFPLAdHFwses0=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 16/24] udf: convert UDF_SB_UDFREV macro to udf_sb_revision function
Date: Sun, 23 Dec 2007 02:51:06 +0100
Message-Id: <1198374674-12128-17-git-send-email-marcin.slusarz@gmail.com>
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
 fs/udf/balloc.c   |    2 +-
 fs/udf/inode.c    |   14 +++++++-------
 fs/udf/misc.c     |    2 +-
 fs/udf/namei.c    |    2 +-
 fs/udf/super.c    |   10 +++++-----
 fs/udf/truncate.c |    6 +++---
 fs/udf/udf_sb.h   |    8 ++++++--
 7 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 4c31666..23aae18 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -559,7 +559,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 				}
 				epos.offset = sizeof(struct allocExtDesc);
 			}
-			if (UDF_SB_UDFREV(sb) >= 0x0200)
+			if (udf_sb_revision(sb) >= 0x0200)
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,
 					    epos.block.logicalBlockNum, sizeof(tag));
 			else
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 46cf40c..1cdb381 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1537,7 +1537,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 				ICBTAG_FLAG_SETGID | ICBTAG_FLAG_STICKY));
 
 	fe->icbTag.flags = cpu_to_le16(icbflags);
-	if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
+	if (udf_sb_revision(inode->i_sb) >= 0x0200)
 		fe->descTag.descVersion = cpu_to_le16(3);
 	else
 		fe->descTag.descVersion = cpu_to_le16(2);
@@ -1667,7 +1667,7 @@ int8_t udf_add_aext(struct inode * inode, struct extent_position * epos,
 				mark_inode_dirty(inode);
 			}
 		}
-		if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
+		if (udf_sb_revision(inode->i_sb) >= 0x0200)
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 3, 1,
 				    epos->block.logicalBlockNum, sizeof(tag));
 		else
@@ -1690,7 +1690,7 @@ int8_t udf_add_aext(struct inode * inode, struct extent_position * epos,
 		}
 		if (epos->bh) {
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    udf_sb_revision(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos->bh->b_data, loffset);
 			else
 				udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
@@ -1711,7 +1711,7 @@ int8_t udf_add_aext(struct inode * inode, struct extent_position * epos,
 		aed = (struct allocExtDesc *)epos->bh->b_data;
 		aed->lengthAllocDescs =
 			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || udf_sb_revision(inode->i_sb) >= 0x0201)
 			udf_update_tag(epos->bh->b_data, epos->offset + (inc ? 0 : adsize));
 		else
 			udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
@@ -1754,7 +1754,7 @@ int8_t udf_write_aext(struct inode * inode, struct extent_position * epos,
 
 	if (epos->bh) {
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-		    UDF_SB_UDFREV(inode->i_sb) >= 0x0201) {
+		    udf_sb_revision(inode->i_sb) >= 0x0201) {
 			struct allocExtDesc *aed = (struct allocExtDesc *)epos->bh->b_data;
 			udf_update_tag(epos->bh->b_data,
 				       le32_to_cpu(aed->lengthAllocDescs) + sizeof(struct allocExtDesc));
@@ -1907,7 +1907,7 @@ int8_t udf_delete_aext(struct inode * inode, struct extent_position epos,
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - (2 * adsize));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    udf_sb_revision(inode->i_sb) >= 0x0201)
 				udf_update_tag(oepos.bh->b_data, oepos.offset - (2 * adsize));
 			else
 				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
@@ -1923,7 +1923,7 @@ int8_t udf_delete_aext(struct inode * inode, struct extent_position epos,
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    udf_sb_revision(inode->i_sb) >= 0x0201)
 				udf_update_tag(oepos.bh->b_data, epos.offset - adsize);
 			else
 				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 42d731a..4854573 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -84,7 +84,7 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 			size -= sizeof(struct extendedAttrHeaderDesc);
 			UDF_I_LENEATTR(inode) += sizeof(struct extendedAttrHeaderDesc);
 			eahd->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EAHD);
-			if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
+			if (udf_sb_revision(inode->i_sb) >= 0x0200)
 				eahd->descTag.descVersion = cpu_to_le16(3);
 			else
 				eahd->descTag.descVersion = cpu_to_le16(2);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 4a18bfc..d5ef33a 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -535,7 +535,7 @@ add:
 	}
 
 	memset(cfi, 0, sizeof(struct fileIdentDesc));
-	if (UDF_SB_UDFREV(sb) >= 0x0200)
+	if (udf_sb_revision(sb) >= 0x0200)
 		udf_new_tag((char *)cfi, TAG_IDENT_FID, 3, 1, block, sizeof(tag));
 	else
 		udf_new_tag((char *)cfi, TAG_IDENT_FID, 2, 1, block, sizeof(tag));
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5a2c474..c520543 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1413,10 +1413,10 @@ static void udf_close_lvid(struct super_block *sb)
 			udf_sb_lvid(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
 		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(udf_sb_lvidiu(sb)->maxUDFWriteRev))
 			udf_sb_lvidiu(sb)->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(udf_sb_lvidiu(sb)->minUDFReadRev))
-			udf_sb_lvidiu(sb)->minUDFReadRev = cpu_to_le16(UDF_SB_UDFREV(sb));
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(udf_sb_lvidiu(sb)->minUDFWriteRev))
-			udf_sb_lvidiu(sb)->minUDFWriteRev = cpu_to_le16(UDF_SB_UDFREV(sb));
+		if (udf_sb_revision(sb) > le16_to_cpu(udf_sb_lvidiu(sb)->minUDFReadRev))
+			udf_sb_lvidiu(sb)->minUDFReadRev = cpu_to_le16(udf_sb_revision(sb));
+		if (udf_sb_revision(sb) > le16_to_cpu(udf_sb_lvidiu(sb)->minUDFWriteRev))
+			udf_sb_lvidiu(sb)->minUDFWriteRev = cpu_to_le16(udf_sb_revision(sb));
 		udf_sb_lvid(sb)->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
 		udf_sb_lvid(sb)->descTag.descCRC =
@@ -1553,7 +1553,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 			sb->s_flags |= MS_RDONLY;
 		}
 
-		UDF_SB_UDFREV(sb) = minUDFWriteRev;
+		udf_sb(sb)->s_udfrev = minUDFWriteRev;
 
 		if (minUDFReadRev >= UDF_VERS_USE_EXTENDED_FE)
 			UDF_SET_FLAG(sb, UDF_FLAG_USE_EXTENDED_FE);
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 7fc3912..79ba205 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -163,7 +163,7 @@ void udf_discard_prealloc(struct inode *inode)
 				cpu_to_le32(epos.offset -
 					    sizeof(struct allocExtDesc));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    udf_sb_revision(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos.bh->b_data, epos.offset);
 			else
 				udf_update_tag(epos.bh->b_data,
@@ -232,7 +232,7 @@ void udf_truncate_extents(struct inode *inode)
 						aed->lengthAllocDescs =
 						    cpu_to_le32(lenalloc);
 						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
-						    UDF_SB_UDFREV(sb) >= 0x0201)
+						    udf_sb_revision(sb) >= 0x0201)
 							udf_update_tag(epos.bh->b_data,
 								       lenalloc +
 								       sizeof(struct allocExtDesc));
@@ -271,7 +271,7 @@ void udf_truncate_extents(struct inode *inode)
 				    (struct allocExtDesc *)(epos.bh->b_data);
 				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
 				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
-				    UDF_SB_UDFREV(sb) >= 0x0201)
+				    udf_sb_revision(sb) >= 0x0201)
 					udf_update_tag(epos.bh->b_data,
 						       lenalloc + sizeof(struct allocExtDesc));
 				else
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index bae6a74..53d77fc 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -113,6 +113,11 @@ static inline __u16 udf_sb_serial_number(struct super_block *sb)
 	return udf_sb(sb)->s_serial_number;
 }
 
+static inline __u16 udf_sb_revision(struct super_block *sb)
+{
+	return udf_sb(sb)->s_udfrev;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -163,7 +168,7 @@ static inline __u16 udf_sb_serial_number(struct super_block *sb)
 #define UDF_SET_FLAG(X,Y)			( udf_sb(X)->s_flags |= ( 1 << (Y) ) )
 #define UDF_CLEAR_FLAG(X,Y)			( udf_sb(X)->s_flags &= ~( 1 << (Y) ) )
 
-#define UDF_UPDATE_UDFREV(X,Y)			( ((Y) > UDF_SB_UDFREV(X)) ? UDF_SB_UDFREV(X) = (Y) : UDF_SB_UDFREV(X) )
+#define UDF_UPDATE_UDFREV(X,Y)			( ((Y) > udf_sb_revision(X)) ? udf_sb(X)->s_udfrev = (Y) : udf_sb_revision(X) )
 
 #define UDF_SB_PARTTYPE(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_type )
 #define UDF_SB_PARTROOT(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_root )
@@ -177,7 +182,6 @@ static inline __u16 udf_sb_serial_number(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_UDFREV(X)			( udf_sb(X)->s_udfrev )
 #define UDF_SB_VAT(X)				( udf_sb(X)->s_vat )
 
 #endif /* __LINUX_UDF_SB_H */
-- 
1.5.3.4

