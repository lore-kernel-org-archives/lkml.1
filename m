Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXDOTIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXDOTIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXDOTIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:08:25 -0400
Received: from fallback.mail.ru ([194.67.57.14]:29928 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbXDOTIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:08:24 -0400
Date: Sun, 15 Apr 2007 23:08:11 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH]: ufs proper handling of zero link case
Message-ID: <20070415190811.GA5495@rain>
Mail-Followup-To: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should fix or partly fix this bug:
http://bugzilla.kernel.org/show_bug.cgi?id=8276

The problem is:
- if we see "zero link case" during reading inode operation,
we call ufs_error(which remount fs readonly), but not "mark" inode as
bad (1)
- in readonly case we do not fill some data structures, which are used
in read and write case (2)
- VFS call ufs_delete_inode if link count is zero (3)

so (1)->(3)->(2) cause oops, this patch should fix such scenario

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jim Paris <jim@jtan.com>

---

Index: linux-2.6.21-rc6/fs/ufs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ufs/inode.c
+++ linux-2.6.21-rc6/fs/ufs/inode.c
@@ -601,7 +601,7 @@ static void ufs_set_inode_ops(struct ino
 				   ufs_get_inode_dev(inode->i_sb, UFS_I(inode)));
 }
 
-static void ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
+static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 {
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -613,8 +613,10 @@ static void ufs1_read_inode(struct inode
 	 */
 	inode->i_mode = mode = fs16_to_cpu(sb, ufs_inode->ui_mode);
 	inode->i_nlink = fs16_to_cpu(sb, ufs_inode->ui_nlink);
-	if (inode->i_nlink == 0)
+	if (inode->i_nlink == 0) {
 		ufs_error (sb, "ufs_read_inode", "inode %lu has zero nlink\n", inode->i_ino);
+		return -1;
+	}
 	
 	/*
 	 * Linux now has 32-bit uid and gid, so we can support EFT.
@@ -643,9 +645,10 @@ static void ufs1_read_inode(struct inode
 		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
 			ufsi->i_u1.i_symlink[i] = ufs_inode->ui_u2.ui_symlink[i];
 	}
+	return 0;
 }
 
-static void ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
+static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 {
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -658,8 +661,10 @@ static void ufs2_read_inode(struct inode
 	 */
 	inode->i_mode = mode = fs16_to_cpu(sb, ufs2_inode->ui_mode);
 	inode->i_nlink = fs16_to_cpu(sb, ufs2_inode->ui_nlink);
-	if (inode->i_nlink == 0)
+	if (inode->i_nlink == 0) {
 		ufs_error (sb, "ufs_read_inode", "inode %lu has zero nlink\n", inode->i_ino);
+		return -1;
+	}
 
         /*
          * Linux now has 32-bit uid and gid, so we can support EFT.
@@ -690,6 +695,7 @@ static void ufs2_read_inode(struct inode
 		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
 			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];
 	}
+	return 0;
 }
 
 void ufs_read_inode(struct inode * inode)
@@ -698,6 +704,7 @@ void ufs_read_inode(struct inode * inode
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct buffer_head * bh;
+	int err;
 
 	UFSD("ENTER, ino %lu\n", inode->i_ino);
 
@@ -720,14 +727,17 @@ void ufs_read_inode(struct inode * inode
 	if ((UFS_SB(sb)->s_flags & UFS_TYPE_MASK) == UFS_TYPE_UFS2) {
 		struct ufs2_inode *ufs2_inode = (struct ufs2_inode *)bh->b_data;
 
-		ufs2_read_inode(inode,
-				ufs2_inode + ufs_inotofsbo(inode->i_ino));
+		err = ufs2_read_inode(inode,
+				      ufs2_inode + ufs_inotofsbo(inode->i_ino));
 	} else {
 		struct ufs_inode *ufs_inode = (struct ufs_inode *)bh->b_data;
 
-		ufs1_read_inode(inode, ufs_inode + ufs_inotofsbo(inode->i_ino));
+		err = ufs1_read_inode(inode,
+				      ufs_inode + ufs_inotofsbo(inode->i_ino));
 	}
 
+	if (err)
+		goto bad_inode;
 	inode->i_version++;
 	ufsi->i_lastfrag =
 		(inode->i_size + uspi->s_fsize - 1) >> uspi->s_fshift;
@@ -888,6 +898,8 @@ void ufs_delete_inode (struct inode * in
 	loff_t old_i_size;
 
 	truncate_inode_pages(&inode->i_data, 0);
+	if (is_bad_inode(inode))
+		goto no_delete;
 	/*UFS_I(inode)->i_dtime = CURRENT_TIME;*/
 	lock_kernel();
 	mark_inode_dirty(inode);
@@ -898,4 +910,7 @@ void ufs_delete_inode (struct inode * in
 		ufs_warning(inode->i_sb, __FUNCTION__, "ufs_truncate failed\n");
 	ufs_free_inode (inode);
 	unlock_kernel();
+	return;
+no_delete:
+	clear_inode(inode);	/* We must guarantee clearing of inode... */
 }

-- 
/Evgeniy

