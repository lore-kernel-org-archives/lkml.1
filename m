Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbXFKKgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbXFKKgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 06:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbXFKKg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 06:36:26 -0400
Received: from styx.suse.cz ([82.119.242.94]:51285 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758907AbXFKKgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 06:36:25 -0400
Date: Mon, 11 Jun 2007 12:49:11 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix possible leakage of blocks in UDF (try 2)
Message-ID: <20070611104911.GH567@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi Andrew,

  attached is a new version of the patch fixing possible leakage of
preallocated blocks. This time it has survived also testing Eric gave it
without any deadlock or assertion failures so hopefully it's less wrong
than the previous one.. ;) Please apply, thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--y0ulUmNC+osPPQO6
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="udf-2.6.22-rc4-1-udf_block_leak.diff"

We have to take care that when we call udf_discard_prealloc() from udf_clear_inode()
we have to write inode ourselves afterwards (otherwise, some changes might be lost
leading to leakage of blocks, use of free blocks or improperly aligned extents).
Also udf_discard_prealloc() does two different things - it removes preallocated
blocks and truncates the last extent to exactly match i_size. We move the latter
functionality to udf_truncate_tail_extent(), call udf_discard_prealloc() when last
reference to a file is dropped and call udf_truncate_tail_extent() when inode
is being removed from inode cache (udf_clear_inode() call). We cannot call
udf_truncate_tail_extent() earlier as subsequent open+write would find the last
block of the file mapped and happily write to the end of it, although the last
extent says it's shorter.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/inode.c linux-2.6.22-rc2-2-udf_block_leak/fs/udf/inode.c
--- linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/inode.c	2007-05-24 18:16:36.000000000 +0200
+++ linux-2.6.22-rc2-2-udf_block_leak/fs/udf/inode.c	2007-06-07 16:38:37.000000000 +0200
@@ -100,14 +100,23 @@ no_delete:
 	clear_inode(inode);
 }
 
+/*
+ * If we are going to release inode from memory, we discard preallocation and
+ * truncate last inode extent to proper length. We could use drop_inode() but it's
+ * called under inode_lock and thus we cannot mark inode dirty there. We use
+ * clear_inode() but we have to make sure to write inode as it's not written
+ * automatically.
+ */
 void udf_clear_inode(struct inode *inode)
 {
 	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
 		lock_kernel();
+		/* Discard preallocation for directories, symlinks, etc. */
 		udf_discard_prealloc(inode);
+		udf_truncate_tail_extent(inode);
 		unlock_kernel();
+		write_inode_now(inode, 1);
 	}
-
 	kfree(UDF_I_DATA(inode));
 	UDF_I_DATA(inode) = NULL;
 }
diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/truncate.c linux-2.6.22-rc2-2-udf_block_leak/fs/udf/truncate.c
--- linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/truncate.c	2007-05-24 18:00:05.000000000 +0200
+++ linux-2.6.22-rc2-2-udf_block_leak/fs/udf/truncate.c	2007-06-06 14:33:29.000000000 +0200
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
@@ -79,25 +86,69 @@ void udf_discard_prealloc(struct inode *
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
+				printk(KERN_WARNING
+				       "udf_truncate_tail_extent(): Too long "
+				       "extent after EOF in inode %u: i_size: "
+				       "%Ld lbcount: %Ld extent %u+%u\n",
+				       (unsigned)inode->i_ino,
+				       (long long)inode->i_size,
+				       (long long)lbcount,
+				       (unsigned)eloc.logicalBlockNum,
+				       (unsigned)elen);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
 			extent_trunc(inode, &epos, eloc, etype, elen, nelen);
 			epos.offset += adsize;
-			lbcount = inode->i_size;
+			if (udf_next_aext(inode, &epos, &eloc, &elen, 1) != -1)
+				printk(KERN_ERR "udf_truncate_tail_extent(): "
+				       "Extent after EOF in inode %u.\n",
+				       (unsigned)inode->i_ino);
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
@@ -118,9 +169,9 @@ void udf_discard_prealloc(struct inode *
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
+++ linux-2.6.22-rc2-2-udf_block_leak/fs/udf/udfdecl.h	2007-06-07 16:32:54.000000000 +0200
@@ -146,6 +146,7 @@ extern void udf_free_inode(struct inode 
 extern struct inode * udf_new_inode (struct inode *, int, int *);
 
 /* truncate.c */
+extern void udf_truncate_tail_extent(struct inode *);
 extern void udf_discard_prealloc(struct inode *);
 extern void udf_truncate_extents(struct inode *);
 

--y0ulUmNC+osPPQO6--
