Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbXFZX3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbXFZX3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760746AbXFZXQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:16:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760847AbXFZXQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:16:32 -0400
Message-Id: <20070626231549.822514888@suse.de>
References: <20070626231510.883881222@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:15:13 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [RFD 3/4] Dont use a NULL nameidata in xattr_permission()
Content-Disposition: inline; filename=xattr_permission.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create nameidata2 struct xattr_permission so that it does not pass NULL
to permission.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -25,8 +25,16 @@
  * because different namespaces have very different rules.
  */
 static int
-xattr_permission(struct inode *inode, const char *name, int mask)
+xattr_permission(struct dentry *dentry, struct vfsmount *mnt, const char *name,
+		 int mask)
 {
+	struct inode *inode = dentry->d_inode;
+	struct nameidata2 nd;
+
+	nd.dentry = dentry;
+	nd.mnt = mnt;
+	nd.flags = 0;
+
 	/*
 	 * We can never set or remove an extended attribute on a read-only
 	 * filesystem  or on an immutable / append-only inode.
@@ -65,7 +73,7 @@ xattr_permission(struct inode *inode, co
 			return -EPERM;
 	}
 
-	return permission(inode, mask, NULL);
+	return permission(inode, mask, &nd);
 }
 
 int
@@ -75,7 +83,7 @@ vfs_setxattr(struct dentry *dentry, stru
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(dentry, mnt, name, MAY_WRITE);
 	if (error)
 		return error;
 
@@ -112,7 +120,7 @@ vfs_getxattr(struct dentry *dentry, stru
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_READ);
+	error = xattr_permission(dentry, mnt, name, MAY_READ);
 	if (error)
 		return error;
 
@@ -174,7 +182,7 @@ vfs_removexattr(struct dentry *dentry, s
 	if (!inode->i_op->removexattr)
 		return -EOPNOTSUPP;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(dentry, mnt, name, MAY_WRITE);
 	if (error)
 		return error;
 

-- 
