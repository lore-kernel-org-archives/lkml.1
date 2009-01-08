Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbZAHWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbZAHWoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbZAHWoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:44:00 -0500
Received: from kumera.dghda.com ([80.68.90.171]:55946 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbZAHWn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:43:59 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH, v2 2/4] ufs: don't truncate longer ufs2 fast symlinks
Date: Thu,  8 Jan 2009 22:43:49 +0000
Message-Id: <1231454631-14329-2-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1231454631-14329-1-git-send-email-duaneg@dghda.com>
References: <1231454631-14329-1-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ufs2 fast symlinks can be twice as long as ufs ones, however the code
was using the ufs size in various places. Fix that so ufs2 symlinks over
60 characters aren't truncated.

Note that we copy the entire area instead of using the maxsymlinklen field
from the superblock. This way we will be more robust against corruption (of
the superblock).

While we are at it, use memcpy instead of open-coding it with for loops.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Let me know if you would prefer me to split the for loop -> memcpy into a
separate patch.

Version 1 -> 2:
  * Replaced for loops with memcpy

 fs/ufs/inode.c |   37 ++++++++++++++++---------------------
 fs/ufs/ufs.h   |    2 +-
 2 files changed, 17 insertions(+), 22 deletions(-)

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
1.6.0.6

