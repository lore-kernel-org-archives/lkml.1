Return-Path: <linux-kernel-owner+w=401wt.eu-S1765203AbYA3VSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765203AbYA3VSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbYA3VG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:06:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:25275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbYA3VGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:06:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=MqLa9nGbKlSTEG09joZILzV1fGl7iZ4ifsCcZz56t+AEXwBexaoHhb7Mhe61Rcf1+f6bklNkqTvk+XoEzdZLoTw4iIea4V6nPyWutEQRRhrKcrEMoLR4FJDcqbtZiKVpbHZVRJ1dAU5/cOQUh3IrkDpuiFrFLBBeNOoAdwa9UQk=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 06/10] udf: truncate: create function for updating of Allocation Ext Descriptor
Date: Wed, 30 Jan 2008 22:03:56 +0100
Message-Id: <1201727040-6769-7-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/truncate.c |   56 +++++++++++++++++++++-------------------------------
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index f64f827..eb98616 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -180,6 +180,24 @@ void udf_discard_prealloc(struct inode *inode)
 	brelse(epos.bh);
 }
 
+static void udf_update_alloc_ext_desc(struct inode *inode,
+				      struct extent_position *epos,
+				      u32 lenalloc)
+{
+	struct super_block *sb = inode->i_sb;
+	struct udf_sb_info *sbi = UDF_SB(sb);
+
+	struct allocExtDesc *aed = (struct allocExtDesc *) (epos->bh->b_data);
+	int len = sizeof(struct allocExtDesc);
+
+	aed->lengthAllocDescs =	cpu_to_le32(lenalloc);
+	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || sbi->s_udfrev >= 0x0201)
+		len += lenalloc;
+
+	udf_update_tag(epos->bh->b_data, len);
+	mark_buffer_dirty_inode(epos->bh, inode);
+}
+
 void udf_truncate_extents(struct inode *inode)
 {
 	struct extent_position epos;
@@ -187,7 +205,6 @@ void udf_truncate_extents(struct inode *inode)
 	uint32_t elen, nelen = 0, indirect_ext_len = 0, lenalloc;
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
-	struct udf_sb_info *sbi = UDF_SB(sb);
 	sector_t first_block = inode->i_size >> sb->s_blocksize_bits, offset;
 	loff_t byte_offset;
 	int adsize;
@@ -230,24 +247,9 @@ void udf_truncate_extents(struct inode *inode)
 				} else if (!epos.bh) {
 					iinfo->i_lenAlloc = lenalloc;
 					mark_inode_dirty(inode);
-				} else {
-					struct allocExtDesc *aed =
-						(struct allocExtDesc *)
-						(epos.bh->b_data);
-					int len = sizeof(struct allocExtDesc);
-
-					aed->lengthAllocDescs =
-						cpu_to_le32(lenalloc);
-					if (!UDF_QUERY_FLAG(sb,
-						UDF_FLAG_STRICT) ||
-						sbi->s_udfrev >= 0x0201)
-						len += lenalloc;
-
-					udf_update_tag(epos.bh->b_data,
-							len);
-					mark_buffer_dirty_inode(
-							epos.bh, inode);
-				}
+				} else
+					udf_update_alloc_ext_desc(inode,
+							&epos, lenalloc);
 				brelse(epos.bh);
 				epos.offset = sizeof(struct allocExtDesc);
 				epos.block = eloc;
@@ -273,20 +275,8 @@ void udf_truncate_extents(struct inode *inode)
 		} else if (!epos.bh) {
 			iinfo->i_lenAlloc = lenalloc;
 			mark_inode_dirty(inode);
-		} else {
-			struct allocExtDesc *aed =
-				(struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
-				sbi->s_udfrev >= 0x0201)
-				udf_update_tag(epos.bh->b_data,
-					lenalloc +
-					sizeof(struct allocExtDesc));
-			else
-				udf_update_tag(epos.bh->b_data,
-					sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(epos.bh, inode);
-		}
+		} else
+			udf_update_alloc_ext_desc(inode, &epos, lenalloc);
 	} else if (inode->i_size) {
 		if (byte_offset) {
 			kernel_long_ad extent;
-- 
1.5.3.7

