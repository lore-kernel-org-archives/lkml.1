Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXHCRxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXHCRxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764713AbXHCRub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:50:31 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34799 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764480AbXHCRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:50:27 -0400
Message-Id: <20070803174940.781335925@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:33 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 07/11] fuse: refresh stale attributes in fuse_permission()
Content-Disposition: inline; filename=fuse_permission_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

fuse_permission() didn't refresh inode attributes before using them,
even if the validity has already expired.

Thanks to Junjiro Okajima for spotting this.

Also remove some old code to unconditionally refresh the attributes on
the root inode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-08-03 18:36:01.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-08-03 18:36:15.000000000 +0200
@@ -663,7 +663,7 @@ static int fuse_link(struct dentry *entr
 	return err;
 }
 
-int fuse_do_getattr(struct inode *inode)
+static int fuse_do_getattr(struct inode *inode)
 {
 	int err;
 	struct fuse_attr_out arg;
@@ -723,30 +723,6 @@ static int fuse_allow_task(struct fuse_c
 	return 0;
 }
 
-/*
- * Check whether the inode attributes are still valid
- *
- * If the attribute validity timeout has expired, then fetch the fresh
- * attributes with a 'getattr' request
- *
- * I'm not sure why cached attributes are never returned for the root
- * inode, this is probably being too cautious.
- */
-static int fuse_revalidate(struct dentry *entry)
-{
-	struct inode *inode = entry->d_inode;
-	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct fuse_conn *fc = get_fuse_conn(inode);
-
-	if (!fuse_allow_task(fc, current))
-		return -EACCES;
-	if (get_node_id(inode) != FUSE_ROOT_ID &&
-	    fi->i_time >= get_jiffies_64())
-		return 0;
-
-	return fuse_do_getattr(inode);
-}
-
 static int fuse_access(struct inode *inode, int mask)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -794,16 +770,33 @@ static int fuse_access(struct inode *ino
 static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	bool refreshed = false;
+	int err = 0;
 
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
-	else if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
+
+	/*
+	 * If attributes are needed, but are stale, refresh them
+	 * before proceeding
+	 */
+	if (((fc->flags & FUSE_DEFAULT_PERMISSIONS) || (mask & MAY_EXEC)) &&
+	    fi->i_time < get_jiffies_64()) {
+		err = fuse_do_getattr(inode);
+		if (err)
+			return err;
+
+		refreshed = true;
+	}
+
+	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		int err = generic_permission(inode, mask, NULL);
 
 		/* If permission is denied, try to refresh file
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
-		if (err == -EACCES) {
+		if (err == -EACCES && !refreshed) {
 		 	err = fuse_do_getattr(inode);
 			if (!err)
 				err = generic_permission(inode, mask, NULL);
@@ -814,7 +807,6 @@ static int fuse_permission(struct inode 
 		   noticed immediately, only after the attribute
 		   timeout has expired */
 
-		return err;
 	} else {
 		int mode = inode->i_mode;
 		if ((mask & MAY_EXEC) && !S_ISDIR(mode) && !(mode & S_IXUGO))
@@ -822,8 +814,8 @@ static int fuse_permission(struct inode 
 
 		if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
 			return fuse_access(inode, mask);
-		return 0;
 	}
+	return err;
 }
 
 static int parse_dirfile(char *buf, size_t nbytes, struct file *file,
@@ -1052,7 +1044,16 @@ static int fuse_getattr(struct vfsmount 
 			struct kstat *stat)
 {
 	struct inode *inode = entry->d_inode;
-	int err = fuse_revalidate(entry);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	int err = 0;
+
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
+	if (fi->i_time < get_jiffies_64())
+		err = fuse_do_getattr(inode);
+
 	if (!err)
 		generic_fillattr(inode, stat);
 
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-08-03 18:36:13.000000000 +0200
+++ linux/fs/fuse/file.c	2007-08-03 18:36:15.000000000 +0200
@@ -106,14 +106,6 @@ int fuse_open_common(struct inode *inode
 	if (err)
 		return err;
 
-	/* If opening the root node, no lookup has been performed on
-	   it, so the attributes must be refreshed */
-	if (get_node_id(inode) == FUSE_ROOT_ID) {
-		err = fuse_do_getattr(inode);
-		if (err)
-		 	return err;
-	}
-
 	ff = fuse_file_alloc();
 	if (!ff)
 		return -ENOMEM;
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-08-03 18:36:05.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-08-03 18:36:15.000000000 +0200
@@ -533,11 +533,6 @@ void request_send_background(struct fuse
 void fuse_abort_conn(struct fuse_conn *fc);
 
 /**
- * Get the attributes of a file
- */
-int fuse_do_getattr(struct inode *inode);
-
-/**
  * Invalidate inode attributes
  */
 void fuse_invalidate_attr(struct inode *inode);

--
