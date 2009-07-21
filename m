Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZGUGFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZGUGFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZGUGE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:04:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:62225 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZGUGEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:04:34 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [PATCH] 9p: Fix possible inode leak in v9fs_get_inode.
Date: Tue, 21 Jul 2009 00:03:55 -0600
Message-Id: <1248156236-3005-6-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing iput when cleaning up if v9fs_get_inode
fails after returning a valid inode.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 e221b14... 4a947f9... M	fs/9p/vfs_inode.c
 fs/9p/vfs_inode.c |  105 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 56 insertions(+), 49 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e221b14..4a947f9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -206,65 +206,72 @@ v9fs_blank_wstat(struct p9_wstat *wstat)
 
 struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 {
+	int err;
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "super block: %p mode: %o\n", sb, mode);
 
 	inode = new_inode(sb);
-	if (inode) {
-		inode->i_mode = mode;
-		inode->i_uid = current_fsuid();
-		inode->i_gid = current_fsgid();
-		inode->i_blocks = 0;
-		inode->i_rdev = 0;
-		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		inode->i_mapping->a_ops = &v9fs_addr_operations;
-
-		switch (mode & S_IFMT) {
-		case S_IFIFO:
-		case S_IFBLK:
-		case S_IFCHR:
-		case S_IFSOCK:
-			if (!v9fs_extended(v9ses)) {
-				P9_DPRINTK(P9_DEBUG_ERROR,
-				      "special files without extended mode\n");
-				return ERR_PTR(-EINVAL);
-			}
-			init_special_inode(inode, inode->i_mode,
-					   inode->i_rdev);
-			break;
-		case S_IFREG:
-			inode->i_op = &v9fs_file_inode_operations;
-			inode->i_fop = &v9fs_file_operations;
-			break;
-		case S_IFLNK:
-			if (!v9fs_extended(v9ses)) {
-				P9_DPRINTK(P9_DEBUG_ERROR,
-					"extended modes used w/o 9P2000.u\n");
-				return ERR_PTR(-EINVAL);
-			}
-			inode->i_op = &v9fs_symlink_inode_operations;
-			break;
-		case S_IFDIR:
-			inc_nlink(inode);
-			if (v9fs_extended(v9ses))
-				inode->i_op = &v9fs_dir_inode_operations_ext;
-			else
-				inode->i_op = &v9fs_dir_inode_operations;
-			inode->i_fop = &v9fs_dir_operations;
-			break;
-		default:
+	if (!inode) {
+		P9_EPRINTK(KERN_WARNING, "Problem allocating inode\n");
+		return -ENOMEM;
+	}
+
+	inode->i_mode = mode;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
+	inode->i_blocks = 0;
+	inode->i_rdev = 0;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_mapping->a_ops = &v9fs_addr_operations;
+
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFBLK:
+	case S_IFCHR:
+	case S_IFSOCK:
+		if (!v9fs_extended(v9ses)) {
 			P9_DPRINTK(P9_DEBUG_ERROR,
-				"BAD mode 0x%x S_IFMT 0x%x\n",
-				mode, mode & S_IFMT);
-			return ERR_PTR(-EINVAL);
+				   "special files without extended mode\n");
+			err = -EINVAL;
+			goto error;
 		}
-	} else {
-		P9_EPRINTK(KERN_WARNING, "Problem allocating inode\n");
-		return ERR_PTR(-ENOMEM);
+		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+		break;
+	case S_IFREG:
+		inode->i_op = &v9fs_file_inode_operations;
+		inode->i_fop = &v9fs_file_operations;
+		break;
+	case S_IFLNK:
+		if (!v9fs_extended(v9ses)) {
+			P9_DPRINTK(P9_DEBUG_ERROR,
+				   "extended modes used w/o 9P2000.u\n");
+			err = -EINVAL;
+			goto error;
+		}
+		inode->i_op = &v9fs_symlink_inode_operations;
+		break;
+	case S_IFDIR:
+		inc_nlink(inode);
+		if (v9fs_extended(v9ses))
+			inode->i_op = &v9fs_dir_inode_operations_ext;
+		else
+			inode->i_op = &v9fs_dir_inode_operations;
+		inode->i_fop = &v9fs_dir_operations;
+		break;
+	default:
+		P9_DPRINTK(P9_DEBUG_ERROR, "BAD mode 0x%x S_IFMT 0x%x\n",
+			   mode, mode & S_IFMT);
+		err = -EINVAL;
+		goto error;
 	}
+
 	return inode;
+
+error:
+	iput(inode);
+	return ERR_PTR(err);
 }
 
 /*
-- 
1.6.0.4

