Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbXEKSdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbXEKSdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXEKSdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:33:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:20984 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758377AbXEKSdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:33:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=BccDeYRdZXtKC29w4Oklz1Naj6uituiqwiEx3LIPRwh7WrwISuhfIa68qJnS0cosLlc7+QuPpezkF1myZFBeECZ8hdn5dYLGfFbaOPIMwZvds4CSFH0IT3xt/ValtUHML9iUYASpLvAp5A/PjfKWQWYzOi3MKAVGxH8M8xD8s5M=
Date: Fri, 11 May 2007 22:32:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@ucw.cz>
Subject: [PATCH] UDF: check for allocated memory for data of new inodes
Message-ID: <20070511183247.GA8431@cvg>
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

Christoph, I remember your notice about UDF_I_*
macroses... and I'm working on it now ;)

 fs/udf/ialloc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 8206983..efb46a4 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -50,7 +50,7 @@ void udf_free_inode(struct inode * inode)
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
 				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
-		
+
 		mark_buffer_dirty(sbi->s_lvidbh);
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -136,6 +136,12 @@ struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
 		UDF_I_EFE(inode) = 0;
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
 	}
+	if (!UDF_I_DATA(inode))
+	{
+		iput(inode);
+		*err = -ENOMEM;
+		return NULL;
+	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
