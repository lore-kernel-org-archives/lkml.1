Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbXHIJ2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbXHIJ2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937981AbXHIJ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:16 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45681 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764986AbXHIJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:14 -0400
Message-Id: <20070809092512.500760417@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:52 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 6/9] fuse: clean up execute permission checking
Content-Disposition: inline; filename=fuse_exec_permission_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Define a new function fuse_refresh_attributes() that conditionally
refreshes the attributes based on the validity timeout.

In fuse_permission() only refresh the attributes for checking the
execute bits if necessary.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-08-09 11:01:55.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-08-09 11:04:30.000000000 +0200
@@ -695,6 +695,20 @@ static int fuse_do_getattr(struct inode 
 }
 
 /*
+ * Check if attributes are still valid, and if not send a GETATTR
+ * request to refresh them.
+ */
+static int fuse_refresh_attributes(struct inode *inode)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	if (fi->i_time < get_jiffies_64())
+		return fuse_do_getattr(inode);
+	else
+		return 0;
+}
+
+/*
  * Calling into a user-controlled filesystem gives the filesystem
  * daemon ptrace-like capabilities over the requester process.  This
  * means, that the filesystem daemon is able to record the exact
@@ -770,7 +784,6 @@ static int fuse_access(struct inode *ino
 static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	bool refreshed = false;
 	int err = 0;
 
@@ -778,12 +791,11 @@ static int fuse_permission(struct inode 
 		return -EACCES;
 
 	/*
-	 * If attributes are needed, but are stale, refresh them
-	 * before proceeding
+	 * If attributes are needed, refresh them before proceeding
 	 */
-	if (((fc->flags & FUSE_DEFAULT_PERMISSIONS) || (mask & MAY_EXEC)) &&
-	    fi->i_time < get_jiffies_64()) {
-		err = fuse_do_getattr(inode);
+	if ((fc->flags & FUSE_DEFAULT_PERMISSIONS) ||
+	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
+		err = fuse_refresh_attributes(inode);
 		if (err)
 			return err;
 
@@ -806,14 +818,17 @@ static int fuse_permission(struct inode 
 		   exist.  So if permissions are revoked this won't be
 		   noticed immediately, only after the attribute
 		   timeout has expired */
-
-	} else {
-		int mode = inode->i_mode;
-		if ((mask & MAY_EXEC) && !S_ISDIR(mode) && !(mode & S_IXUGO))
-			return -EACCES;
-
-		if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
-			return fuse_access(inode, mask);
+	} else if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR))) {
+		err = fuse_access(inode, mask);
+	} else if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+		if (!(inode->i_mode & S_IXUGO)) {
+			if (refreshed)
+				return -EACCES;
+
+			err = fuse_do_getattr(inode);
+			if (!err && !(inode->i_mode & S_IXUGO))
+				return -EACCES;
+		}
 	}
 	return err;
 }
@@ -1046,14 +1061,12 @@ static int fuse_getattr(struct vfsmount 
 	struct inode *inode = entry->d_inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	int err = 0;
+	int err;
 
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
-	if (fi->i_time < get_jiffies_64())
-		err = fuse_do_getattr(inode);
-
+	err = fuse_refresh_attributes(inode);
 	if (!err) {
 		generic_fillattr(inode, stat);
 		stat->mode = fi->orig_i_mode;

--
