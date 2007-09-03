Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbXICCcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbXICCcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXICCZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:48 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57677 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbXICCY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:57 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 24/32] Unionfs: remove old nfsro option
Date: Sun,  2 Sep 2007 22:20:47 -0400
Message-Id: <11887860581709-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Ensure that a branch set as 'ro' behaves like a real readonly mounted lower
file system.  This allows us to remove the old 'nfsro' option.  Now unionfs
handles even an readonly exported NFS file system, which was mounted on the
client in readwrite mode.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c       |   48 ++++++++++++++++++++++-----------------------
 include/linux/union_fs.h |    3 --
 2 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index d6a79d5..4574fbe 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -948,47 +948,44 @@ static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
  * Basically copied from the kernel vfs permission(), but we've changed
  * the following:
  *   (1) the IS_RDONLY check is skipped, and
- *   (2) if you set the mount option `mode=nfsro', we assume that -EACCES
- *   means that the export is read-only and we should check standard Unix
- *   permissions.  This means that NFS ACL checks (or other advanced
- *   permission features) are bypassed. Note however, that we do call
- *   security_inode_permission, and therefore security inside SELinux, etc.
- *   are performed.
+ *   (2) We return 0 (success) if the non-leftmost branch is mounted
+ *       readonly, to allow copyup to work.
+ *   (3) we do call security_inode_permission, and therefore security inside
+ *       SELinux, etc. are performed.
  */
-static int inode_permission(struct inode *inode, int mask,
+static int inode_permission(struct super_block *sb, struct inode *inode, int mask,
 			    struct nameidata *nd, int bindex)
 {
 	int retval, submask;
 
 	if (mask & MAY_WRITE) {
+		umode_t mode = inode->i_mode;
 		/* The first branch is allowed to be really readonly. */
-		if (bindex == 0) {
-			umode_t mode = inode->i_mode;
-			if (IS_RDONLY(inode) &&
-			    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
-				return -EROFS;
-		}
+		if (bindex == 0 &&
+		    IS_RDONLY(inode) &&
+		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
+			return -EROFS;
 		/*
 		 * Nobody gets write access to an immutable file.
 		 */
 		if (IS_IMMUTABLE(inode))
 			return -EACCES;
+		/*
+		 * For all other branches than the first one, we ignore
+		 * EROFS or if the branch is mounted as readonly, to let
+		 * copyup take place.
+		 */
+		if (bindex > 0 &&
+		    is_robranch_super(sb, bindex) &&
+		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
+			return 0;
 	}
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
-	if (inode->i_op && inode->i_op->permission) {
+	if (inode->i_op && inode->i_op->permission)
 		retval = inode->i_op->permission(inode, submask, nd);
-		if ((retval == -EACCES) && (submask & MAY_WRITE) &&
-		    (!strcmp("nfs", (inode)->i_sb->s_type->name)) &&
-		    (nd) && (nd->mnt) && (nd->mnt->mnt_sb)) {
-			int perms;
-			perms = branchperms(nd->mnt->mnt_sb, bindex);
-			if (perms & MAY_NFSRO)
-				retval = generic_permission(inode, submask,
-							    NULL);
-		}
-	} else
+	else
 		retval = generic_permission(inode, submask, NULL);
 
 	if (retval && retval != -EROFS)	/* ignore EROFS */
@@ -1046,7 +1043,8 @@ static int unionfs_permission(struct inode *inode, int mask,
 		 * We use our own special version of permission, such that
 		 * only the first branch returns -EROFS.
 		 */
-		err = inode_permission(lower_inode, mask, nd, bindex);
+		err = inode_permission(inode->i_sb, lower_inode, mask, nd,
+				       bindex);
 
 		/*
 		 * The permissions are an intersection of the overall directory
diff --git a/include/linux/union_fs.h b/include/linux/union_fs.h
index 223ccab..9bc4e3b 100644
--- a/include/linux/union_fs.h
+++ b/include/linux/union_fs.h
@@ -22,8 +22,5 @@
 /* We don't support normal remount, but unionctl uses it. */
 # define UNIONFS_REMOUNT_MAGIC		0x4a5a4380
 
-/* should be at least LAST_USED_UNIONFS_PERMISSION<<1 */
-#define MAY_NFSRO			16
-
 #endif /* _LINUX_UNIONFS_H */
 
-- 
1.5.2.2.238.g7cbf2f2

