Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbYA3VSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbYA3VSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758889AbYA3VG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:06:28 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:46355 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbYA3VGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:06:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=eC4oC0XkUqDAvXGSTHADTJKApM5Y8DpHt9gw0XQjx4YUSF3n59hwxwHudTTSODELGu2QE8wuoCNpEYMIIkqfTxwQmdAsK5dATPCpiM9cTNwvyKHSGNESR3p9YzWYy3e1ulnlDrldKzm2LgFwFmSBStYAfpxM8ejhnR3uPdLDZE8=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 05/10] udf: simple cleanup of truncate.c
Date: Wed, 30 Jan 2008 22:03:55 +0100
Message-Id: <1201727040-6769-6-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove one indentation level by little code reorganization
- convert "if (smth) BUG();" to "BUG_ON(smth);"

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/truncate.c |   76 +++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index fe61be1..f64f827 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -224,34 +224,29 @@ void udf_truncate_extents(struct inode *inode)
 				if (indirect_ext_len) {
 					/* We managed to free all extents in the
 					 * indirect extent - free it too */
-					if (!epos.bh)
-						BUG();
+					BUG_ON(!epos.bh);
 					udf_free_blocks(sb, inode, epos.block,
 							0, indirect_ext_len);
+				} else if (!epos.bh) {
+					iinfo->i_lenAlloc = lenalloc;
+					mark_inode_dirty(inode);
 				} else {
-					if (!epos.bh) {
-						iinfo->i_lenAlloc =
-								lenalloc;
-						mark_inode_dirty(inode);
-					} else {
-						struct allocExtDesc *aed =
-							(struct allocExtDesc *)
-							(epos.bh->b_data);
-						int len =
-						    sizeof(struct allocExtDesc);
+					struct allocExtDesc *aed =
+						(struct allocExtDesc *)
+						(epos.bh->b_data);
+					int len = sizeof(struct allocExtDesc);
 
-						aed->lengthAllocDescs =
-						    cpu_to_le32(lenalloc);
-						if (!UDF_QUERY_FLAG(sb,
-							UDF_FLAG_STRICT) ||
-						    sbi->s_udfrev >= 0x0201)
-							len += lenalloc;
+					aed->lengthAllocDescs =
+						cpu_to_le32(lenalloc);
+					if (!UDF_QUERY_FLAG(sb,
+						UDF_FLAG_STRICT) ||
+						sbi->s_udfrev >= 0x0201)
+						len += lenalloc;
 
-						udf_update_tag(epos.bh->b_data,
-								len);
-						mark_buffer_dirty_inode(
-								epos.bh, inode);
-					}
+					udf_update_tag(epos.bh->b_data,
+							len);
+					mark_buffer_dirty_inode(
+							epos.bh, inode);
 				}
 				brelse(epos.bh);
 				epos.offset = sizeof(struct allocExtDesc);
@@ -272,28 +267,25 @@ void udf_truncate_extents(struct inode *inode)
 		}
 
 		if (indirect_ext_len) {
-			if (!epos.bh)
-				BUG();
+			BUG_ON(!epos.bh);
 			udf_free_blocks(sb, inode, epos.block, 0,
 					indirect_ext_len);
+		} else if (!epos.bh) {
+			iinfo->i_lenAlloc = lenalloc;
+			mark_inode_dirty(inode);
 		} else {
-			if (!epos.bh) {
-				iinfo->i_lenAlloc = lenalloc;
-				mark_inode_dirty(inode);
-			} else {
-				struct allocExtDesc *aed =
-				    (struct allocExtDesc *)(epos.bh->b_data);
-				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
-				    sbi->s_udfrev >= 0x0201)
-					udf_update_tag(epos.bh->b_data,
-						lenalloc +
-						sizeof(struct allocExtDesc));
-				else
-					udf_update_tag(epos.bh->b_data,
-						sizeof(struct allocExtDesc));
-				mark_buffer_dirty_inode(epos.bh, inode);
-			}
+			struct allocExtDesc *aed =
+				(struct allocExtDesc *)(epos.bh->b_data);
+			aed->lengthAllocDescs = cpu_to_le32(lenalloc);
+			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+				sbi->s_udfrev >= 0x0201)
+				udf_update_tag(epos.bh->b_data,
+					lenalloc +
+					sizeof(struct allocExtDesc));
+			else
+				udf_update_tag(epos.bh->b_data,
+					sizeof(struct allocExtDesc));
+			mark_buffer_dirty_inode(epos.bh, inode);
 		}
 	} else if (inode->i_size) {
 		if (byte_offset) {
-- 
1.5.3.7

