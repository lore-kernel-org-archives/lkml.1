Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYHRMxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYHRMxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYHRMxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:53:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:50610 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754080AbYHRMxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:53:20 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Ingo Oeser <ioe-lkml@rameria.de>
Subject: [PATCH REVIEW] udf: Fix error paths in udf_new_inode()
Date: Mon, 18 Aug 2008 14:53:18 +0200
Message-Id: <12190639981625-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12190639982548-git-send-email-jack@suse.cz>
References: y
 <12190639982548-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I case we failed to allocate memory for inode when creating it, we did not
properly free block already allocated for this inode. Move memory allocation
before the block allocation which fixes this issue. Also remove a few
superfluous initializations already done in udf_alloc_inode().

CC: Ingo Oeser <ioe-lkml@rameria.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/ialloc.c |   41 ++++++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index c4943c8..a4f2b3c 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -76,11 +76,24 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	*err = -ENOSPC;
 
 	iinfo = UDF_I(inode);
-	iinfo->i_unique = 0;
-	iinfo->i_lenExtents = 0;
-	iinfo->i_next_alloc_block = 0;
-	iinfo->i_next_alloc_goal = 0;
-	iinfo->i_strat4096 = 0;
+	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
+		iinfo->i_efe = 1;
+		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
+			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
+		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
+					    sizeof(struct extendedFileEntry),
+					    GFP_KERNEL);
+	} else {
+		iinfo->i_efe = 0;
+		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
+					    sizeof(struct fileEntry),
+					    GFP_KERNEL);
+	}
+	if (!iinfo->i_ext.i_data) {
+		iput(inode);
+		*err = -ENOMEM;
+		return NULL;
+	}
 
 	block = udf_new_block(dir->i_sb, NULL,
 			      dinfo->i_location.partitionReferenceNum,
@@ -130,24 +143,6 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenAlloc = 0;
 	iinfo->i_use = 0;
-	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
-		iinfo->i_efe = 1;
-		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
-			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
-		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
-					    sizeof(struct extendedFileEntry),
-					    GFP_KERNEL);
-	} else {
-		iinfo->i_efe = 0;
-		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
-					    sizeof(struct fileEntry),
-					    GFP_KERNEL);
-	}
-	if (!iinfo->i_ext.i_data) {
-		iput(inode);
-		*err = -ENOMEM;
-		return NULL;
-	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-- 
1.5.2.4

