Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYAJWJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYAJWJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbYAJWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:09:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37438 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760056AbYAJWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:09:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=x4nXw77Nqh/zBZ6DkpUhtKRWYZvUvfda3J3wPAFffA5PXIECTM01EH1tyioKBx8C1rNdMSTpEOveLtKWgo98/KMzHCIP7ajRcJU0xvDlEPGJ272RREFjDSwh0KOJd+X2v6TYn1t4GosTiv6hfXSw43Gt4YH8wyszRoRxxL3YKiY=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 12/16] udf: convert byte order of constant instead of variable
Date: Thu, 10 Jan 2008 23:06:28 +0100
Message-Id: <1200002792-8449-13-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert byte order of constant instead of variable,
which can be done at compile time (vs run time)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/udf/directory.c |    4 ++--
 fs/udf/inode.c     |   16 ++++++++--------
 fs/udf/misc.c      |   12 ++++++------
 fs/udf/super.c     |   16 ++++++++--------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index d4ae723..598bcf7 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -225,7 +225,7 @@ struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize, int *offset)
 	if ((*offset > 0) && (*offset < bufsize))
 		ptr += *offset;
 	fi = (struct fileIdentDesc *)ptr;
-	if (le16_to_cpu(fi->descTag.tagIdent) != TAG_IDENT_FID) {
+	if (fi->descTag.tagIdent != cpu_to_le16(TAG_IDENT_FID)) {
 		udf_debug("0x%x != TAG_IDENT_FID\n",
 			  le16_to_cpu(fi->descTag.tagIdent));
 		udf_debug("offset: %u sizeof: %lu bufsize: %u\n",
@@ -262,7 +262,7 @@ static extent_ad *udf_get_fileextent(void *buffer, int bufsize, int *offset)
 
 	fe = (struct fileEntry *)buffer;
 
-	if (le16_to_cpu(fe->descTag.tagIdent) != TAG_IDENT_FE) {
+	if (fe->descTag.tagIdent != cpu_to_le16(TAG_IDENT_FE)) {
 		udf_debug("0x%x != TAG_IDENT_FE\n",
 			  le16_to_cpu(fe->descTag.tagIdent));
 		return NULL;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6751945..bb73635 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1103,7 +1103,7 @@ static void __udf_read_inode(struct inode *inode)
 
 	fe = (struct fileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->icbTag.strategyType) == 4096) {
+	if (fe->icbTag.strategyType == cpu_to_le16(4096)) {
 		struct buffer_head *ibh = NULL, *nbh = NULL;
 		struct indirectEntry *ie;
 
@@ -1140,7 +1140,7 @@ static void __udf_read_inode(struct inode *inode)
 		} else {
 			brelse(ibh);
 		}
-	} else if (le16_to_cpu(fe->icbTag.strategyType) != 4) {
+	} else if (fe->icbTag.strategyType != cpu_to_le16(4)) {
 		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
 		       le16_to_cpu(fe->icbTag.strategyType));
 		brelse(bh);
@@ -1164,9 +1164,9 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->icbTag.strategyType) == 4)
+	if (fe->icbTag.strategyType == cpu_to_le16(4))
 		UDF_I_STRAT4096(inode) = 0;
-	else /* if (le16_to_cpu(fe->icbTag.strategyType) == 4096) */
+	else /* if (fe->icbTag.strategyType == cpu_to_le16(4096)) */
 		UDF_I_STRAT4096(inode) = 1;
 
 	UDF_I_ALLOCTYPE(inode) = le16_to_cpu(fe->icbTag.flags) &
@@ -1177,7 +1177,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	UDF_I_LENALLOC(inode) = 0;
 	UDF_I_NEXT_ALLOC_BLOCK(inode) = 0;
 	UDF_I_NEXT_ALLOC_GOAL(inode) = 0;
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE) {
+	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
 		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
@@ -1189,7 +1189,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		       bh->b_data + sizeof(struct extendedFileEntry),
 		       inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry));
-	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
+	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_FE)) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
 		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
@@ -1199,7 +1199,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry),
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
-	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
+	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_USE)) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 1;
 		UDF_I_LENALLOC(inode) = le32_to_cpu(
@@ -1458,7 +1458,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
+	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_USE)) {
 		struct unallocSpaceEntry *use =
 			(struct unallocSpaceEntry *)bh->b_data;
 
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 585e4ea..a3a513f 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -74,8 +74,8 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 
 		if (UDF_I_LENEATTR(inode)) {
 			/* check checksum/crc */
-			if (le16_to_cpu(eahd->descTag.tagIdent) !=
-					TAG_IDENT_EAHD ||
+			if (eahd->descTag.tagIdent !=
+					cpu_to_le16(TAG_IDENT_EAHD) ||
 			    le32_to_cpu(eahd->descTag.tagLocation) !=
 					UDF_I_LOCATION(inode).logicalBlockNum)
 				return NULL;
@@ -161,8 +161,8 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
 		/* check checksum/crc */
-		if (le16_to_cpu(eahd->descTag.tagIdent) !=
-				TAG_IDENT_EAHD ||
+		if (eahd->descTag.tagIdent !=
+				cpu_to_le16(TAG_IDENT_EAHD) ||
 		    le32_to_cpu(eahd->descTag.tagLocation) !=
 				UDF_I_LOCATION(inode).logicalBlockNum)
 			return NULL;
@@ -233,8 +233,8 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	}
 
 	/* Verify the tag version */
-	if (le16_to_cpu(tag_p->descVersion) != 0x0002U &&
-	    le16_to_cpu(tag_p->descVersion) != 0x0003U) {
+	if (tag_p->descVersion != cpu_to_le16(0x0002U) &&
+	    tag_p->descVersion != cpu_to_le16(0x0003U)) {
 		udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
 			  le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 12fb91d..b102958 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1014,20 +1014,20 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 				le32_to_cpu(p->partitionLength); /* blocks */
 			map->s_partition_root =
 				le32_to_cpu(p->partitionStartingLocation);
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_READ_ONLY)
+			if (p->accessType ==
+					cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_READ_ONLY;
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_WRITE_ONCE)
+			if (p->accessType ==
+					cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_WRITE_ONCE;
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_REWRITABLE)
+			if (p->accessType ==
+					cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_REWRITABLE;
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_OVERWRITABLE)
+			if (p->accessType ==
+				    cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_OVERWRITABLE;
 
-- 
1.5.3.7

