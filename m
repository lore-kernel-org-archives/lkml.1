Return-Path: <linux-kernel-owner+w=401wt.eu-S965824AbXENLeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965824AbXENLeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966043AbXENLco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:32:44 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27932 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757172AbXENLc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:29 -0400
Message-Id: <20070514110651.929217256@suse.de>
References: <20070514110650.866217377@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:53 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [RFD Patch 3/4] Dont use a NULL nameidata in xattr_permission()
Content-Disposition: inline; filename=xattr_permission.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create nameidata2 struct xattr_permission so that it does not pass NULL
to permission.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

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
