Return-Path: <linux-kernel-owner+w=401wt.eu-S933573AbYBOWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbYBOWo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761075AbYBOWht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:49 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39292 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183AbYBOWhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:42 -0500
Subject: [PATCH 13/30] r/o bind mounts: elevate write count for xattr_permission() callers
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:38 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223738.F4FABDE9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This basically audits the callers of xattr_permission(), which calls
permission() and can perform writes to the filesystem.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/nfsd/nfs4proc.c |    7 ++++++-
 linux-2.6.git-dave/fs/xattr.c         |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes fs/nfsd/nfs4proc.c
--- linux-2.6.git/fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes	2008-02-15 13:25:49.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/nfs4proc.c	2008-02-15 13:25:49.000000000 -0800
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
--- linux-2.6.git/fs/xattr.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes	2008-02-15 13:25:49.000000000 -0800
+++ linux-2.6.git-dave/fs/xattr.c	2008-02-15 13:25:49.000000000 -0800
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
@@ -262,7 +261,11 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
+	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
 }
@@ -277,7 +280,11 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
+	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
 }
@@ -293,9 +300,14 @@ sys_fsetxattr(int fd, char __user *name,
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
