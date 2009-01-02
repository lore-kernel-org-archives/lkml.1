Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZABOJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZABOJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZABOJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:09:32 -0500
Received: from kumera.dghda.com ([80.68.90.171]:34178 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZABOJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:09:31 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Fri, 2 Jan 2009 14:09:26 +0000
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Duane Griffin <duaneg@dghda.com>, Evgeniy Dushistov <dushistov@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ufs: don't truncate longer ufs2 fast symlinks
Message-ID: <20090102140926.GA5814@dastardly.home.dghda.com>
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com> <1230742208-23972-2-git-send-email-duaneg@dghda.com> <20090101023232.GC28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090101023232.GC28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 02:32:32AM +0000, Al Viro wrote:
> On Wed, Dec 31, 2008 at 04:50:06PM +0000, Duane Griffin wrote:
> >  	} else {
> > -		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
> > +		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2; i++)
> >  			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];
> 
> a) that probably ought to be a memcpy()

OK, see below. I've changed the other close-by loops as well, for
consistency. Note however that they were copying an entire structure
(consisting of two arrays of the same type) whilst seeming to copy only
the first member. So the patch looks like it is changing behaviour, but
actually should not. Please let me know if you prefer this; I'll resend
the series if so.

> b) max len is superblock parameter and you've even validated it.  Why don't
> you use it?

It is only validated to an upper bound. If it is incorrectly set to
zero, say, this way at least the link names will show up. True, we copy
a bit of extra data around, but since it isn't exactly a fast path I
figured it was worth it for the extra reliability.

> 
> > -		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
> > +		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2; i++)
> >  			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];
> 
> Ditto.

---

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 39f8778..ac8b324 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -622,7 +622,6 @@ static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
 	mode_t mode;
-	unsigned i;
 
 	/*
 	 * Copy data to the in-core inode.
@@ -655,11 +654,11 @@ static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 
 	
 	if (S_ISCHR(mode) || S_ISBLK(mode) || inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufsi->i_u1.i_data[i] = ufs_inode->ui_u2.ui_addr.ui_db[i];
+		memcpy(ufsi->i_u1.i_data, &ufs_inode->ui_u2.ui_addr,
+		       sizeof(ufs_inode->ui_u2.ui_addr));
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufsi->i_u1.i_symlink[i] = ufs_inode->ui_u2.ui_symlink[i];
+		memcpy(ufsi->i_u1.i_symlink, ufs_inode->ui_u2.ui_symlink,
+		       sizeof(ufs_inode->ui_u2.ui_symlink));
 	}
 	return 0;
 }
@@ -669,7 +668,6 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
 	mode_t mode;
-	unsigned i;
 
 	UFSD("Reading ufs2 inode, ino %lu\n", inode->i_ino);
 	/*
@@ -704,12 +702,11 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 	*/
 
 	if (S_ISCHR(mode) || S_ISBLK(mode) || inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufsi->i_u1.u2_i_data[i] =
-				ufs2_inode->ui_u2.ui_addr.ui_db[i];
+		memcpy(ufsi->i_u1.u2_i_data, &ufs2_inode->ui_u2.ui_addr,
+		       sizeof(ufs2_inode->ui_u2.ui_addr));
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];
+		memcpy(ufsi->i_u1.i_symlink, ufs2_inode->ui_u2.ui_symlink,
+		       sizeof(ufs2_inode->ui_u2.ui_symlink));
 	}
 	return 0;
 }
@@ -781,7 +778,6 @@ static void ufs1_update_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 {
 	struct super_block *sb = inode->i_sb;
  	struct ufs_inode_info *ufsi = UFS_I(inode);
- 	unsigned i;
 
 	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
 	ufs_inode->ui_nlink = cpu_to_fs16(sb, inode->i_nlink);
@@ -809,12 +805,12 @@ static void ufs1_update_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 		/* ufs_inode->ui_u2.ui_addr.ui_db[0] = cpu_to_fs32(sb, inode->i_rdev); */
 		ufs_inode->ui_u2.ui_addr.ui_db[0] = ufsi->i_u1.i_data[0];
 	} else if (inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.i_data[i];
+		memcpy(&ufs_inode->ui_u2.ui_addr, ufsi->i_u1.i_data,
+		       sizeof(ufs_inode->ui_u2.ui_addr));
 	}
 	else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];
+		memcpy(&ufs_inode->ui_u2.ui_symlink, ufsi->i_u1.i_symlink,
+		       sizeof(ufs_inode->ui_u2.ui_symlink));
 	}
 
 	if (!inode->i_nlink)
@@ -825,7 +821,6 @@ static void ufs2_update_inode(struct inode *inode, struct ufs2_inode *ufs_inode)
 {
 	struct super_block *sb = inode->i_sb;
  	struct ufs_inode_info *ufsi = UFS_I(inode);
- 	unsigned i;
 
 	UFSD("ENTER\n");
 	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
@@ -850,11 +845,11 @@ static void ufs2_update_inode(struct inode *inode, struct ufs2_inode *ufs_inode)
 		/* ufs_inode->ui_u2.ui_addr.ui_db[0] = cpu_to_fs32(sb, inode->i_rdev); */
 		ufs_inode->ui_u2.ui_addr.ui_db[0] = ufsi->i_u1.u2_i_data[0];
 	} else if (inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.u2_i_data[i];
+		memcpy(&ufs_inode->ui_u2.ui_addr, ufsi->i_u1.u2_i_data,
+		       sizeof(ufs_inode->ui_u2.ui_addr));
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];
+		memcpy(&ufs_inode->ui_u2.ui_symlink, ufsi->i_u1.i_symlink,
+		       sizeof(ufs_inode->ui_u2.ui_symlink));
  	}
 
 	if (!inode->i_nlink)
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 11c0351..69b3427 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -23,7 +23,7 @@ struct ufs_sb_info {
 struct ufs_inode_info {
 	union {
 		__fs32	i_data[15];
-		__u8	i_symlink[4*15];
+		__u8	i_symlink[2 * 4 * 15];
 		__fs64	u2_i_data[15];
 	} i_u1;
 	__u32	i_flags;

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
