Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbXEUP6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbXEUP6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbXEUP6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:58:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:62068 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685AbXEUP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=T/V5Loxkl+eLZuG9L6EH+Rc/51VdLeq9CNV7Ikkf6RXRhUE9EVFFwXOLgvmmjb2epDc2KyzI8teBfhreWXLD8HNcN+LkFLG5GCzHpvAa0X2G0GFQ9biUxNJy/hDaKfBS4HJ+V3zg4bdi0eb0tLDCOYX6siAb3agJa77RVT0cBtg=
Date: Mon, 21 May 2007 19:57:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UDF: check for allocated memory for data of new inodes v2
Message-ID: <20070521155714.GA10022@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for granted memory for inode data
at the moment of it's creation.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Andrew, it seems my previous patch didn't release mutex so there I've it fixed.
Please replace the patch named 'udf-check-for-allocated-memory-for-data-of-new-inodes.patch'
with this one.

 ialloc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)


diff --git a/ialloc.c b/ialloc.c
index 8206983..10f3188 100644
--- a/ialloc.c
+++ b/ialloc.c
@@ -50,7 +50,7 @@ void udf_free_inode(struct inode * inode)
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
 				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
-		
+
 		mark_buffer_dirty(sbi->s_lvidbh);
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -136,6 +136,13 @@ struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
 		UDF_I_EFE(inode) = 0;
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
 	}
+	if (!UDF_I_DATA(inode))
+	{
+		iput(inode);
+		*err = -ENOMEM;
+		mutex_unlock(&sbi->s_alloc_mutex);
+		return NULL;
+	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
