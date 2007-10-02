Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXJBPzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXJBPzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXJBPwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:38 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:48716 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXJBPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:34 -0400
Message-Id: <20071002155216.210593319@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:30 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 04/12] fuse: clean up open file passing in setattr
Content-Disposition: inline; filename=fuse_fsetattr.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clean up supplying open file to the setattr operation.  In addition to
being a cleanup it prepares for the changes in the way the open file
is passed to the setattr method.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-25 21:19:13.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-25 21:19:13.000000000 +0200
@@ -1032,11 +1032,6 @@ static void iattr_to_fattr(struct iattr 
 		arg->atime = iattr->ia_atime.tv_sec;
 		arg->mtime = iattr->ia_mtime.tv_sec;
 	}
-	if (ivalid & ATTR_FILE) {
-		struct fuse_file *ff = iattr->ia_file->private_data;
-		arg->valid |= FATTR_FH;
-		arg->fh = ff->fh;
-	}
 }
 
 /*
@@ -1047,7 +1042,8 @@ static void iattr_to_fattr(struct iattr 
  * vmtruncate() doesn't allow for this case, so do the rlimit checking
  * and the actual truncation by hand.
  */
-static int fuse_setattr(struct dentry *entry, struct iattr *attr)
+static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
+			   struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1082,6 +1078,11 @@ static int fuse_setattr(struct dentry *e
 
 	memset(&inarg, 0, sizeof(inarg));
 	iattr_to_fattr(attr, &inarg);
+	if (file) {
+		struct fuse_file *ff = file->private_data;
+		inarg.valid |= FATTR_FH;
+		inarg.fh = ff->fh;
+	}
 	req->in.h.opcode = FUSE_SETATTR;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
@@ -1108,6 +1109,14 @@ static int fuse_setattr(struct dentry *e
 	return 0;
 }
 
+static int fuse_setattr(struct dentry *entry, struct iattr *attr)
+{
+	if (attr->ia_valid & ATTR_FILE)
+		return fuse_do_setattr(entry, attr, attr->ia_file);
+	else
+		return fuse_do_setattr(entry, attr, NULL);
+}
+
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
 			struct kstat *stat)
 {

--
