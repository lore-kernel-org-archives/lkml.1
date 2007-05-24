Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbXEXUZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbXEXUZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbXEXUZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:25:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:35939 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750809AbXEXUZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:25:33 -0400
Date: Thu, 24 May 2007 22:36:53 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070524203653.GA7693@duck.suse.cz>
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20070524170554.GC19709@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Thu 24-05-07 19:05:54, Jan Kara wrote:
>   Hello,
> 
>   attached is a patch that fixes possible leakage of free blocks / use of
> free blocks in UDF (which spilled nice assertion failures I've added in my
> first round of patches). More details in the changelog. Andrew, please apply.
> Both changes have survived some time of fsx and fsstress testing so they
> should be reasonably safe.
  Sorry for replying to myself but this patch had a minor problem of
printing some bogus warnings when directories were deleted (I wonder why
fsstress didn't find it). Attached is a new version of the patch without
this problem.

									Honza

--opJtzjQTFsWo+cga
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="udf-2.6.22-rc2-2-udf_block_leak.diff"

It is wrong to call udf_discard_prealloc() from udf_clear_inode() as at that time
inode changes won't be written any more which can lead to leakage of blocks, use
of free blocks or improperly aligned extents. Also udf_discard_prealloc() does two
different things - it removes preallocated blocks and truncates the last extent to
exactly match i_size. We move the latter functionality to udf_truncate_tail_extent(),
call udf_discard_prealloc() when last reference to a file is dropped and call
udf_truncate_tail_extent() when inode is being removed from inode cach
(udf_drop_inode() call). We cannot call udf_truncate_tail_extent() earlier as
subsequent open+write would find the last block of the file mapped and happily write
to the end of it, although the last extent says it's shorter.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/inode.c linux-2.6.22-rc2-2-udf_block_leak/fs/udf/inode.c
--- linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/inode.c	2007-05-24 18:16:36.000000000 +0200
+++ linux-2.6.22-rc2-2-udf_block_leak/fs/udf/inode.c	2007-05-24 21:13:59.000000000 +0200
@@ -100,14 +100,20 @@ no_delete:
 	clear_inode(inode);
 }
 
-void udf_clear_inode(struct inode *inode)
+void udf_drop_inode(struct inode *inode)
 {
 	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
 		lock_kernel();
+		/* Discard preallocation for directories, symlinks, etc. */
 		udf_discard_prealloc(inode);
+		udf_truncate_tail_extent(inode);
 		unlock_kernel();
 	}
+	generic_drop_inode(inode);
+}
 
+void udf_clear_inode(struct inode *inode)
+{
 	kfree(UDF_I_DATA(inode));
 	UDF_I_DATA(inode) = NULL;
 }
diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/super.c linux-2.6.22-rc2-2-udf_block_leak/fs/udf/super.c
--- linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/super.c	2007-05-24 18:00:05.000000000 +0200
+++ linux-2.6.22-rc2-2-udf_block_leak/fs/udf/super.c	2007-05-24 18:18:54.000000000 +0200
@@ -162,6 +162,7 @@ static const struct super_operations udf
 	.write_inode		= udf_write_inode,
 	.delete_inode		= udf_delete_inode,
 	.clear_inode		= udf_clear_inode,
+	.drop_inode		= udf_drop_inode,
 	.put_super		= udf_put_super,
 	.write_super		= udf_write_super,
 	.statfs			= udf_statfs,
diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/truncate.c linux-2.6.22-rc2-2-udf_block_leak/fs/udf/truncate.c
--- linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/truncate.c	2007-05-24 18:00:05.000000000 +0200
+++ linux-2.6.22-rc2-2-udf_block_leak/fs/udf/truncate.c	2007-05-24 21:31:38.000000000 +0200
@@ -61,7 +61,11 @@ static void extent_trunc(struct inode * 
 	}
 }
 
-void udf_discard_prealloc(struct inode * inode)
+/*
+ * Truncate the last extent to match i_size. This function assumes
+ * that preallocation extent is already truncated.
+ */
+void udf_truncate_tail_extent(struct inode *inode)
 {
 	struct extent_position epos = { NULL, 0, {0, 0}};
 	kernel_lb_addr eloc;
@@ -71,7 +75,10 @@ void udf_discard_prealloc(struct inode *
 	int adsize;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB ||
-		inode->i_size == UDF_I_LENEXTENTS(inode))
+	    inode->i_size == UDF_I_LENEXTENTS(inode))
+		return;
+	/* Are we going to delete the file anyway? */
+	if (inode->i_nlink == 0)
 		return;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
@@ -79,25 +86,63 @@ void udf_discard_prealloc(struct inode *
 	else if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
-		adsize = 0;
-
-	epos.block = UDF_I_LOCATION(inode);
+		BUG();
 
 	/* Find the last extent in the file */
 	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
 	{
 		etype = netype;
 		lbcount += elen;
-		if (lbcount > inode->i_size && lbcount - elen < inode->i_size)
-		{
-			WARN_ON(lbcount - inode->i_size >= inode->i_sb->s_blocksize);
+		if (lbcount > inode->i_size) {
+			if (lbcount - inode->i_size >= inode->i_sb->s_blocksize)
+				printk(KERN_WARNING "udf_truncate_tail_extent():\
+ Too long extent after EOF in inode %u: i_size: %Ld lbcount: %Ld extent %u+%u\n",
+(unsigned)inode->i_ino, (long long)inode->i_size, (long long)lbcount,
+(unsigned)eloc.logicalBlockNum, (unsigned)elen);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
 			extent_trunc(inode, &epos, eloc, etype, elen, nelen);
 			epos.offset += adsize;
-			lbcount = inode->i_size;
+			if (udf_next_aext(inode, &epos, &eloc, &elen, 1) != -1)
+				printk(KERN_ERR "udf_truncate_tail_extent(): \
+Extent after EOF in inode %u.\n", (unsigned)inode->i_ino);
+			break;
 		}
 	}
+	/* This inode entry is in-memory only and thus we don't have to mark
+	 * the inode dirty */
+	UDF_I_LENEXTENTS(inode) = inode->i_size;
+	brelse(epos.bh);
+}
+
+void udf_discard_prealloc(struct inode * inode)
+{
+	struct extent_position epos = { NULL, 0, {0, 0}};
+	kernel_lb_addr eloc;
+	uint32_t elen;
+	uint64_t lbcount = 0;
+	int8_t etype = -1, netype;
+	int adsize;
+
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB ||
+		inode->i_size == UDF_I_LENEXTENTS(inode))
+		return;
+
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
+		adsize = sizeof(short_ad); 
+	else if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_LONG)
+		adsize = sizeof(long_ad);
+	else
+		adsize = 0;
+
+	epos.block = UDF_I_LOCATION(inode);
+
+	/* Find the last extent in the file */
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
+	{
+		etype = netype;
+		lbcount += elen;
+	}
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 		epos.offset -= adsize;
 		lbcount -= elen;
@@ -118,9 +163,9 @@ void udf_discard_prealloc(struct inode *
 			mark_buffer_dirty_inode(epos.bh, inode);
 		}
 	}
+	/* This inode entry is in-memory only and thus we don't have to mark
+	 * the inode dirty */
 	UDF_I_LENEXTENTS(inode) = lbcount;
-
-	WARN_ON(lbcount != inode->i_size);
 	brelse(epos.bh);
 }
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/udfdecl.h linux-2.6.22-rc2-2-udf_block_leak/fs/udf/udfdecl.h
--- linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/udfdecl.h	2007-05-24 18:00:05.000000000 +0200
+++ linux-2.6.22-rc2-2-udf_block_leak/fs/udf/udfdecl.h	2007-05-24 18:18:54.000000000 +0200
@@ -103,6 +103,7 @@ extern struct buffer_head * udf_bread(st
 extern void udf_truncate(struct inode *);
 extern void udf_read_inode(struct inode *);
 extern void udf_delete_inode(struct inode *);
+extern void udf_drop_inode(struct inode *);
 extern void udf_clear_inode(struct inode *);
 extern int udf_write_inode(struct inode *, int);
 extern long udf_block_map(struct inode *, sector_t);
@@ -146,6 +147,7 @@ extern void udf_free_inode(struct inode 
 extern struct inode * udf_new_inode (struct inode *, int, int *);
 
 /* truncate.c */
+extern void udf_truncate_tail_extent(struct inode *);
 extern void udf_discard_prealloc(struct inode *);
 extern void udf_truncate_extents(struct inode *);
 

--opJtzjQTFsWo+cga--
