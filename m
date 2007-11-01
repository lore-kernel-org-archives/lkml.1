Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbXKAXLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbXKAXLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXKAXIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55002 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbXKAXIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:43 -0400
Subject: [PATCH 10/27] r-o-bind-mounts-elevate-mount-count-for-extended-attributes
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:39 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230839.D1B0DBB9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This basically audits the callers of xattr_permission(), which calls
permission() and can perform writes to the filesystem.

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/nfsd/nfs4proc.c |    7 ++++++-
 linux-2.6.git-dave/fs/xattr.c         |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes fs/nfsd/nfs4proc.c
--- linux-2.6.git/fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes	2007-11-01 14:46:11.000000000 -0700
+++ linux-2.6.git-dave/fs/nfsd/nfs4proc.c	2007-11-01 14:46:11.000000000 -0700
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
 
diff -puN fs/xattr.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes fs/xattr.c
--- linux-2.6.git/fs/xattr.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes	2007-11-01 14:46:11.000000000 -0700
+++ linux-2.6.git-dave/fs/xattr.c	2007-11-01 14:46:11.000000000 -0700
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
