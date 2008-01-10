Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbYAJWIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbYAJWIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYAJWIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:08:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37438 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbYAJWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Jt0q15c1/8Q6CdFpqTJ/TQ4IlGT0B3vOpugcbTSYCEQAtFAhh5ud534FqeWpLShZ5z+oW78+4LHZX044UJVYKFr1ewEESlGuhYFya15GnS5RrMgLYyrmhQ0A1G7x8rEk2xENvqQOEh3qcIei4Ts/w0mLJurQg1eS98ewQJ+0ZkA=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/16] udf: create common function for tag checksumming
Date: Thu, 10 Jan 2008 23:06:25 +0100
Message-Id: <1200002792-8449-10-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/inode.c   |   15 ++-------------
 fs/udf/misc.c    |   35 ++++++++++++++---------------------
 fs/udf/namei.c   |    9 +--------
 fs/udf/super.c   |   16 ++--------------
 fs/udf/udfdecl.h |    3 +++
 5 files changed, 22 insertions(+), 56 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 9adde18..6751945 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1440,7 +1440,6 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	uint32_t udfperms;
 	uint16_t icbflags;
 	uint16_t crclen;
-	int i;
 	kernel_timestamp cpu_time;
 	int err = 0;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
@@ -1476,12 +1475,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use +
 							   sizeof(tag), crclen,
 							   0));
-
-		use->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				use->descTag.tagChecksum +=
-						((uint8_t *)&(use->descTag))[i];
+		use->descTag.tagChecksum = udf_tag_checksum(&use->descTag);
 
 		mark_buffer_dirty(bh);
 		brelse(bh);
@@ -1650,12 +1644,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
 	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag),
 						  crclen, 0));
-
-	fe->descTag.tagChecksum = 0;
-	for (i = 0; i < 16; i++)
-		if (i != 4)
-			fe->descTag.tagChecksum +=
-				((uint8_t *)&(fe->descTag))[i];
+	fe->descTag.tagChecksum = udf_tag_checksum(&fe->descTag);
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index a0bf415..585e4ea 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -51,7 +51,6 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 	uint8_t *ea = NULL, *ad = NULL;
 	int offset;
 	uint16_t crclen;
-	int i;
 
 	ea = UDF_I_DATA(inode);
 	if (UDF_I_LENEATTR(inode)) {
@@ -138,11 +137,7 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 		eahd->descTag.descCRCLength = cpu_to_le16(crclen);
 		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd +
 						sizeof(tag), crclen, 0));
-		eahd->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				eahd->descTag.tagChecksum +=
-					((uint8_t *)&(eahd->descTag))[i];
+		eahd->descTag.tagChecksum = udf_tag_checksum(&eahd->descTag);
 		UDF_I_LENEATTR(inode) += size;
 		return (struct genericFormat *)&ea[offset];
 	}
@@ -207,8 +202,6 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 {
 	tag *tag_p;
 	struct buffer_head *bh = NULL;
-	register uint8_t checksum;
-	register int i;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 
 	/* Read the block */
@@ -234,12 +227,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	}
 
 	/* Verify the tag checksum */
-	checksum = 0U;
-	for (i = 0; i < 4; i++)
-		checksum += (uint8_t)(bh->b_data[i]);
-	for (i = 5; i < 16; i++)
-		checksum += (uint8_t)(bh->b_data[i]);
-	if (checksum != tag_p->tagChecksum) {
+	if (udf_tag_checksum(tag_p) != tag_p->tagChecksum) {
 		printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
 		goto error_out;
 	}
@@ -277,17 +265,11 @@ struct buffer_head *udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc,
 void udf_update_tag(char *data, int length)
 {
 	tag *tptr = (tag *)data;
-	int i;
-
 	length -= sizeof(tag);
 
-	tptr->tagChecksum = 0;
 	tptr->descCRCLength = cpu_to_le16(length);
 	tptr->descCRC = cpu_to_le16(udf_crc(data + sizeof(tag), length, 0));
-
-	for (i = 0; i < 16; i++)
-		if (i != 4)
-			tptr->tagChecksum += (uint8_t)(data[i]);
+	tptr->tagChecksum = udf_tag_checksum(tptr);
 }
 
 void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
@@ -300,3 +282,14 @@ void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
 	tptr->tagLocation = cpu_to_le32(loc);
 	udf_update_tag(data, length);
 }
+
+u8 udf_tag_checksum(const tag *t)
+{
+	u8 *data = (u8 *)t;
+	u8 checksum = 0;
+	int i;
+	for (i = 0; i < sizeof(tag); ++i)
+		if (i != 4) /* position of checksum */
+			checksum += data[i];
+	return checksum;
+}
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 25d518b..f1cf18f 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -47,8 +47,6 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 {
 	uint16_t crclen = fibh->eoffset - fibh->soffset - sizeof(tag);
 	uint16_t crc;
-	uint8_t checksum = 0;
-	int i;
 	int offset;
 	uint16_t liu = le16_to_cpu(cfi->lengthOfImpUse);
 	uint8_t lfi = cfi->lengthFileIdent;
@@ -122,13 +120,8 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 
 	cfi->descTag.descCRC = cpu_to_le16(crc);
 	cfi->descTag.descCRCLength = cpu_to_le16(crclen);
+	cfi->descTag.tagChecksum = udf_tag_checksum(&cfi->descTag);
 
-	for (i = 0; i < 16; i++) {
-		if (i != 4)
-			checksum += ((uint8_t *)&cfi->descTag)[i];
-	}
-
-	cfi->descTag.tagChecksum = checksum;
 	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset)) {
 		memcpy((uint8_t *)sfi, (uint8_t *)cfi,
 			sizeof(struct fileIdentDesc));
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7f75a94..12fb91d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1564,7 +1564,6 @@ static void udf_open_lvid(struct super_block *sb)
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = sbi->s_lvid_bh;
 	if (bh) {
-		int i;
 		kernel_timestamp cpu_time;
 		struct logicalVolIntegrityDesc *lvid =
 				(struct logicalVolIntegrityDesc *)bh->b_data;
@@ -1582,12 +1581,7 @@ static void udf_open_lvid(struct super_block *sb)
 				le16_to_cpu(lvid->descTag.descCRCLength),
 				0));
 
-		lvid->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				lvid->descTag.tagChecksum +=
-					((uint8_t *) &(lvid->descTag))[i];
-
+		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
 		mark_buffer_dirty(bh);
 	}
 }
@@ -1595,7 +1589,6 @@ static void udf_open_lvid(struct super_block *sb)
 static void udf_close_lvid(struct super_block *sb)
 {
 	kernel_timestamp cpu_time;
-	int i;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = sbi->s_lvid_bh;
 	struct logicalVolIntegrityDesc *lvid;
@@ -1626,12 +1619,7 @@ static void udf_close_lvid(struct super_block *sb)
 				le16_to_cpu(lvid->descTag.descCRCLength),
 				0));
 
-		lvid->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				lvid->descTag.tagChecksum +=
-					((uint8_t *)&(lvid->descTag))[i];
-
+		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
 		mark_buffer_dirty(bh);
 	}
 }
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index b17ca67..005e3ad 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -36,6 +36,9 @@
 
 #define udf_get_lb_pblock(sb,loc,offset) udf_get_pblock((sb), (loc).logicalBlockNum, (loc).partitionReferenceNum, (offset))
 
+/* computes tag checksum */
+u8 udf_tag_checksum(const tag *t);
+
 struct dentry;
 struct inode;
 struct task_struct;
-- 
1.5.3.7

