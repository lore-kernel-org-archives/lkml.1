Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZIGVGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZIGVGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZIGVGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:06:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbZIGVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:06:31 -0400
Date: Mon, 7 Sep 2009 14:05:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 8/8] jffs2/jfs/xfs: switch over to 'check_acl' rather than
 'permission()'
In-Reply-To: <alpine.LFD.2.01.0909071404370.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071405070.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404370.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 12:29:03 -0700

This avoids an indirect call in the VFS for each path component lookup.

Well, at least as long as you own the directory in question, and the ACL
check is unnecessary.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/jffs2/acl.c              |    7 +------
 fs/jffs2/acl.h              |    4 ++--
 fs/jffs2/dir.c              |    2 +-
 fs/jffs2/file.c             |    2 +-
 fs/jffs2/symlink.c          |    2 +-
 fs/jfs/acl.c                |    7 +------
 fs/jfs/file.c               |    2 +-
 fs/jfs/jfs_acl.h            |    2 +-
 fs/jfs/namei.c              |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c |   16 ++++------------
 10 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 8fcb623..7edb62e 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -258,7 +258,7 @@ static int jffs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 	return rc;
 }
 
-static int jffs2_check_acl(struct inode *inode, int mask)
+int jffs2_check_acl(struct inode *inode, int mask)
 {
 	struct posix_acl *acl;
 	int rc;
@@ -274,11 +274,6 @@ static int jffs2_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-int jffs2_permission(struct inode *inode, int mask)
-{
-	return generic_permission(inode, mask, jffs2_check_acl);
-}
-
 int jffs2_init_acl_pre(struct inode *dir_i, struct inode *inode, int *i_mode)
 {
 	struct posix_acl *acl, *clone;
diff --git a/fs/jffs2/acl.h b/fs/jffs2/acl.h
index fc929f2..f0ba63e 100644
--- a/fs/jffs2/acl.h
+++ b/fs/jffs2/acl.h
@@ -26,7 +26,7 @@ struct jffs2_acl_header {
 
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 
-extern int jffs2_permission(struct inode *, int);
+extern int jffs2_check_acl(struct inode *, int);
 extern int jffs2_acl_chmod(struct inode *);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, int *);
 extern int jffs2_init_acl_post(struct inode *);
@@ -36,7 +36,7 @@ extern struct xattr_handler jffs2_acl_default_xattr_handler;
 
 #else
 
-#define jffs2_permission			(NULL)
+#define jffs2_check_acl				(NULL)
 #define jffs2_acl_chmod(inode)			(0)
 #define jffs2_init_acl_pre(dir_i,inode,mode)	(0)
 #define jffs2_init_acl_post(inode)		(0)
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 6f60cc9..7aa4417 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -55,7 +55,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.rmdir =	jffs2_rmdir,
 	.mknod =	jffs2_mknod,
 	.rename =	jffs2_rename,
-	.permission =	jffs2_permission,
+	.check_acl =	jffs2_check_acl,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 23c9475..b7b74e2 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -56,7 +56,7 @@ const struct file_operations jffs2_file_operations =
 
 const struct inode_operations jffs2_file_inode_operations =
 {
-	.permission =	jffs2_permission,
+	.check_acl =	jffs2_check_acl,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index b7339c3..4ec11e8 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -21,7 +21,7 @@ const struct inode_operations jffs2_symlink_inode_operations =
 {
 	.readlink =	generic_readlink,
 	.follow_link =	jffs2_follow_link,
-	.permission =	jffs2_permission,
+	.check_acl =	jffs2_check_acl,
 	.setattr =	jffs2_setattr,
 	.setxattr =	jffs2_setxattr,
 	.getxattr =	jffs2_getxattr,
diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index a29c7c3..d66477c 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -114,7 +114,7 @@ out:
 	return rc;
 }
 
-static int jfs_check_acl(struct inode *inode, int mask)
+int jfs_check_acl(struct inode *inode, int mask)
 {
 	struct posix_acl *acl = jfs_get_acl(inode, ACL_TYPE_ACCESS);
 
@@ -129,11 +129,6 @@ static int jfs_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-int jfs_permission(struct inode *inode, int mask)
-{
-	return generic_permission(inode, mask, jfs_check_acl);
-}
-
 int jfs_init_acl(tid_t tid, struct inode *inode, struct inode *dir)
 {
 	struct posix_acl *acl = NULL;
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 7f6063a..2b70fa7 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -96,7 +96,7 @@ const struct inode_operations jfs_file_inode_operations = {
 	.removexattr	= jfs_removexattr,
 #ifdef CONFIG_JFS_POSIX_ACL
 	.setattr	= jfs_setattr,
-	.permission	= jfs_permission,
+	.check_acl	= jfs_check_acl,
 #endif
 };
 
diff --git a/fs/jfs/jfs_acl.h b/fs/jfs/jfs_acl.h
index 88475f1..b07bd41 100644
--- a/fs/jfs/jfs_acl.h
+++ b/fs/jfs/jfs_acl.h
@@ -20,7 +20,7 @@
 
 #ifdef CONFIG_JFS_POSIX_ACL
 
-int jfs_permission(struct inode *, int);
+int jfs_check_acl(struct inode *, int);
 int jfs_init_acl(tid_t, struct inode *, struct inode *);
 int jfs_setattr(struct dentry *, struct iattr *);
 
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 514ee2e..c79a427 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1543,7 +1543,7 @@ const struct inode_operations jfs_dir_inode_operations = {
 	.removexattr	= jfs_removexattr,
 #ifdef CONFIG_JFS_POSIX_ACL
 	.setattr	= jfs_setattr,
-	.permission	= jfs_permission,
+	.check_acl	= jfs_check_acl,
 #endif
 };
 
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 8070b34..6c32f1d 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -485,14 +485,6 @@ xfs_vn_put_link(
 }
 
 STATIC int
-xfs_vn_permission(
-	struct inode		*inode,
-	int			mask)
-{
-	return generic_permission(inode, mask, xfs_check_acl);
-}
-
-STATIC int
 xfs_vn_getattr(
 	struct vfsmount		*mnt,
 	struct dentry		*dentry,
@@ -696,7 +688,7 @@ xfs_vn_fiemap(
 }
 
 static const struct inode_operations xfs_inode_operations = {
-	.permission		= xfs_vn_permission,
+	.check_acl		= xfs_check_acl,
 	.truncate		= xfs_vn_truncate,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
@@ -724,7 +716,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
-	.permission		= xfs_vn_permission,
+	.check_acl		= xfs_check_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -749,7 +741,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
-	.permission		= xfs_vn_permission,
+	.check_acl		= xfs_check_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
@@ -762,7 +754,7 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.readlink		= generic_readlink,
 	.follow_link		= xfs_vn_follow_link,
 	.put_link		= xfs_vn_put_link,
-	.permission		= xfs_vn_permission,
+	.check_acl		= xfs_check_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
 	.setxattr		= generic_setxattr,
-- 
1.6.4.1.209.g74b8

