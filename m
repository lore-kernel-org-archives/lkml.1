Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYIOVHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYIOVHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYIOVGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:31 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64415 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbYIOVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:27 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 01/14] VFS: Factor out part of vfs_setxattr so it can be called from the SELinux hook for inode_setsecctx.
Date: Mon, 15 Sep 2008 16:41:05 -0400
Message-Id: <1221511278-28051-2-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This factors out the part of the vfs_setxattr function that performs the
setting of the xattr and its notification. This is needed so the SELinux
implementation of inode_setsecctx can handle the setting of it's xattr while
maintaining the proper separation of layers.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/xattr.c            |   55 +++++++++++++++++++++++++++++++++++++-----------
 include/linux/xattr.h |    1 +
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 468377e..2f93006 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -66,22 +66,28 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 	return inode_permission(inode, mask);
 }
 
-int
-vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		size_t size, int flags)
+/**
+ *  __vfs_setxattr_noperm - perform setxattr operation without performing
+ *  permission checks.
+ *
+ *  @dentry - object to perform setxattr on
+ *  @name - xattr name to set
+ *  @value - value to set @name to
+ *  @size - size of @value
+ *  @flags - flags to pass into filesystem operations
+ *
+ *  returns the result of the internal setxattr or setsecurity operations.
+ *
+ *  This function requires the caller to lock the inode's i_mutex before it
+ *  is executed. It also assumes that the caller will make the appropriate
+ *  permission checks.
+ */
+int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
-	int error;
-
-	error = xattr_permission(inode, name, MAY_WRITE);
-	if (error)
-		return error;
+	int error = -EOPNOTSUPP;
 
-	mutex_lock(&inode->i_mutex);
-	error = security_inode_setxattr(dentry, name, value, size, flags);
-	if (error)
-		goto out;
-	error = -EOPNOTSUPP;
 	if (inode->i_op->setxattr) {
 		error = inode->i_op->setxattr(dentry, name, value, size, flags);
 		if (!error) {
@@ -97,6 +103,29 @@ vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		if (!error)
 			fsnotify_xattr(dentry);
 	}
+
+	return error;
+}
+
+
+int
+vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = xattr_permission(inode, name, MAY_WRITE);
+	if (error)
+		return error;
+
+	mutex_lock(&inode->i_mutex);
+	error = security_inode_setxattr(dentry, name, value, size, flags);
+	if (error)
+		goto out;
+
+	error = __vfs_setxattr_noperm(dentry, name, value, size, flags);
+
 out:
 	mutex_unlock(&inode->i_mutex);
 	return error;
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index d131e35..5c84af8 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -49,6 +49,7 @@ struct xattr_handler {
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
+int __vfs_setxattr_noperm(struct dentry *, const char *, const void *, size_t, int);
 int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
 int vfs_removexattr(struct dentry *, const char *);
 
-- 
1.5.5.1

