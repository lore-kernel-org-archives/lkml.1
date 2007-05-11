Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbXEKHZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbXEKHZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXEKHZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:25:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:3836 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbXEKHZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=kJAKKKbDgulhcZs1tz17QgtliSRWVgpZE8FBBJX3omZuwwndAfaDQBnL5OyGHaZelQaq4Q3pINnNAN4FV9cRRlSxDi9pyqplGWE+pfjBQTzqoqoOiNH7mk+OF898bGTCbWQ6KZz4e9W9YQywPFGPYB+duWVhwTrKoeIwjLVzD9U=
Date: Fri, 11 May 2007 11:25:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: [PATCH] UDF: check for allocated memory for inode data v2
Message-ID: <20070511072500.GA9444@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for granted memory while filling up inode data
to prevent possible NULL pointer usage. If there is not enough memory
to fill inode data we just mark it as "bad". Also some whitespace cleanup.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Andrew, don't be surprised with coding style - I've tried to keep the
same style as the whole file has.

 fs/udf/inode.c |   51 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index c846155..696cbcc 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -49,6 +49,7 @@ MODULE_LICENSE("GPL");
 static mode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
 static void udf_fill_inode(struct inode *, struct buffer_head *);
+static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
 	long *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
@@ -721,7 +722,7 @@ static void udf_split_extents(struct inode *inode, int *c, int offset, int newbl
 			(*c) ++;
 			(*endnum) ++;
 		}
-		
+
 		laarr[curr].extLocation.logicalBlockNum = newblocknum;
 		if (etype == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			laarr[curr].extLocation.partitionReferenceNum =
@@ -823,7 +824,7 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
 				{
 					numalloc -= elen;
 					if (*endnum > (i+1))
-						memmove(&laarr[i], &laarr[i+1], 
+						memmove(&laarr[i], &laarr[i+1],
 							sizeof(long_ad) * (*endnum - (i+1)));
 					i --;
 					(*endnum) --;
@@ -1011,7 +1012,7 @@ void udf_truncate(struct inode * inode)
 	{
 		block_truncate_page(inode->i_mapping, inode->i_size, udf_get_block);
 		udf_truncate_extents(inode);
-	}	
+	}
 
 	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	if (IS_SYNC(inode))
@@ -1074,10 +1075,10 @@ __udf_read_inode(struct inode *inode)
 			{
 				kernel_lb_addr loc;
 				ie = (struct indirectEntry *)ibh->b_data;
-	
+
 				loc = lelb_to_cpu(ie->indirectICB.extLocation);
-	
-				if (ie->indirectICB.extLength && 
+
+				if (ie->indirectICB.extLength &&
 					(nbh = udf_read_ptagged(inode->i_sb, loc, 0, &ident)))
 				{
 					if (ident == TAG_IDENT_FE ||
@@ -1143,14 +1144,22 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	{
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
-		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry)))
+		{
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 	}
 	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE)
 	{
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
-		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct fileEntry)))
+		{
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry), inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 	}
 	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE)
@@ -1160,7 +1169,11 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		UDF_I_LENALLOC(inode) =
 			le32_to_cpu(
 				((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
-		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry)))
+		{
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct unallocSpaceEntry), inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
 		return;
 	}
@@ -1178,7 +1191,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
 	if (!inode->i_nlink)
 		inode->i_nlink = 1;
-	
+
 	inode->i_size = le64_to_cpu(fe->informationLength);
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
 
@@ -1230,7 +1243,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	}
 	else
 	{
-		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) << 
+		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
 		if ( udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1361,6 +1374,20 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	}
 }
 
+static int udf_alloc_i_data(struct inode *inode, size_t size)
+{
+	UDF_I_DATA(inode) = kmalloc(size, GFP_KERNEL);
+
+	if (!UDF_I_DATA(inode))
+	{
+		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) no free memory\n",
+		       inode->i_ino);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static mode_t
 udf_convert_permissions(struct fileEntry *fe)
 {
@@ -2059,7 +2086,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	}
-	
+
 	brelse(epos.bh);
 	brelse(oepos.bh);
 	return (elen >> 30);
