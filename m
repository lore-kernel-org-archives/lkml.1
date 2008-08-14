Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbYHNSyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbYHNSyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHNSyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:54:47 -0400
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:44356 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYHNSyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:54:47 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH REVIEW] udf: Fix lock inversion between iprune_mutex and alloc_mutex
Date: Thu, 14 Aug 2008 20:48:10 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <12187361983539-git-send-email-jack@suse.cz>
In-Reply-To: <12187361983539-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808142048.10966.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Thursday 14 August 2008, Jan Kara wrote:
> A memory allocation inside alloc_mutex must not recurse back
> into the filesystem itself because that leads to lock inversion
> between iprune_mutex and alloc_mutex (and thus to deadlocks - see
> traces below). Make allocations inside alloc_mutex use GFP_NOFS
> to avoid this problem.

What about moving the allocation before taking the mutex?
That way, we even reduce the lock contention and simplify the failure path.

Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index eb9cfa2..76446eb 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -90,6 +90,25 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		return NULL;
 	}
 
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
+
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (sbi->s_lvid_bh) {
 		struct logicalVolIntegrityDesc *lvid =
@@ -129,25 +148,6 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
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
-		mutex_unlock(&sbi->s_alloc_mutex);
-		return NULL;
-	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
