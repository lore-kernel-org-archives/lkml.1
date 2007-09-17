Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbXIQSaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbXIQSaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbXIQS1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:42 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44366 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXIQS1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:38 -0400
Subject: [PATCH 12/24] elevate mount count for extended attributes
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:33 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182733.19AE94A2@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This basically audits the callers of xattr_permission(), which
calls permission() and can perform writes to the filesystem.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/nfsd/nfs4proc.c |    7 ++++++-
 lxc-dave/fs/xattr.c         |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~elevate-mount-count-for-extended-attributes fs/nfsd/nfs4proc.c
--- lxc/fs/nfsd/nfs4proc.c~elevate-mount-count-for-extended-attributes	2007-09-17 09:44:03.000000000 -0700
+++ lxc-dave/fs/nfsd/nfs4proc.c	2007-09-17 09:44:03.000000000 -0700
@@ -658,14 +658,19 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 			return status;
 		}
 	}
+	status = mnt_want_write(cstate->current_fh.fh_export->ex_mnt);
+	if (status)
+		return status;
 	status = nfs_ok;
 	if (setattr->sa_acl != NULL)
 		status = nfsd4_set_nfs4_acl(rqstp, &cstate->current_fh,
 					    setattr->sa_acl);
 	if (status)
-		return status;
+		goto out;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &setattr->sa_iattr,
 				0, (time_t)0);
+out:
+	mnt_drop_write(cstate->current_fh.fh_export->ex_mnt);
 	return status;
 }
 
diff -puN fs/xattr.c~elevate-mount-count-for-extended-attributes fs/xattr.c
--- lxc/fs/xattr.c~elevate-mount-count-for-extended-attributes	2007-09-17 09:44:03.000000000 -0700
+++ lxc-dave/fs/xattr.c	2007-09-17 09:44:03.000000000 -0700
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/xattr.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -32,8 +33,6 @@ xattr_permission(struct inode *inode, co
 	 * filesystem  or on an immutable / append-only inode.
 	 */
 	if (mask & MAY_WRITE) {
-		if (IS_RDONLY(inode))
-			return -EROFS;
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
 	}
@@ -235,7 +234,11 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.dentry, name, value, size, flags);
+	mnt_drop_write(nd.mnt);
 	path_release(&nd);
 	return error;
 }
@@ -250,7 +253,11 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.dentry, name, value, size, flags);
+	mnt_drop_write(nd.mnt);
 	path_release(&nd);
 	return error;
 }
@@ -266,9 +273,14 @@ sys_fsetxattr(int fd, char __user *name,
 	f = fget(fd);
 	if (!f)
 		return error;
+	error = mnt_want_write(f->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
 	error = setxattr(dentry, name, value, size, flags);
+	mnt_drop_write(f->f_vfsmnt);
+out_fput:
 	fput(f);
 	return error;
 }
_
