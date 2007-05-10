Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbXEJOCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbXEJOCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbXEJOAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:00:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:14594 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762163AbXEJOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qDXr71GptfvnsnZBsYY/y+S0z6vBwwfwfnlRrQ0Pus9jodJl4RRfgVaYHUUX3hx0gRTVPiFBfKearMoOQufYflIlzAhgtM0repV5kIFtEhn4AQ81Svu7s2W9yatWSmYgz6iVRMh4tDzzlY3Oyztr9i9w34Lkn0PAsqwZJDVYHUI=
Date: Thu, 10 May 2007 18:00:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070510140000.GA12399@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds cheking for granted memory while
filling up inode data to prevent possible NULL
pointer usage. If there is not enough memory to
fill inode data we just mark it as "bad".

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Please check the patch, maybe just marking inode as
"bad" is not a good solution.

 fs/udf/inode.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index c846155..91cddae 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1144,6 +1144,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
 		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
+		if (!UDF_I_DATA(inode))
+		{
+			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
+			       inode->i_ino);
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 	}
 	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE)
@@ -1151,6 +1158,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
 		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
+		if (!UDF_I_DATA(inode))
+		{
+			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
+			       inode->i_ino);
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry), inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 	}
 	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE)
@@ -1161,6 +1175,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			le32_to_cpu(
 				((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
 		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry), GFP_KERNEL);
+		if (!UDF_I_DATA(inode))
+		{
+			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
+			       inode->i_ino);
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct unallocSpaceEntry), inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
 		return;
 	}
@@ -1178,7 +1199,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
 	if (!inode->i_nlink)
 		inode->i_nlink = 1;
-	
+
 	inode->i_size = le64_to_cpu(fe->informationLength);
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
 
@@ -1230,7 +1251,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	}
 	else
 	{
-		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) << 
+		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
 		if ( udf_stamp_to_time(&convtime, &convtime_usec,
@@ -2059,7 +2080,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	}
-	
+
 	brelse(epos.bh);
 	brelse(oepos.bh);
 	return (elen >> 30);
