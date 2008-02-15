Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbYBOWqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbYBOWqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764224AbYBOWhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:53 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40124 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762438AbYBOWhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:46 -0500
Subject: [PATCH 16/30] r/o bind mounts: elevate write count for do_utimes()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:42 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223742.552C557D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now includes fix for oops seen by akpm.

"never let a libc developer write your kernel code" - hch

"nor, apparently, a kernel developer" - akpm

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/utimes.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN fs/utimes.c~r-o-bind-mounts-elevate-write-count-for-do_utimes fs/utimes.c
--- linux-2.6.git/fs/utimes.c~r-o-bind-mounts-elevate-write-count-for-do_utimes	2008-02-15 13:25:50.000000000 -0800
+++ linux-2.6.git-dave/fs/utimes.c	2008-02-15 13:25:50.000000000 -0800
@@ -2,6 +2,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
@@ -59,6 +60,7 @@ long do_utimes(int dfd, char __user *fil
 	struct inode *inode;
 	struct iattr newattrs;
 	struct file *f = NULL;
+	struct vfsmount *mnt;
 
 	error = -EINVAL;
 	if (times && (!nsec_valid(times[0].tv_nsec) ||
@@ -79,18 +81,20 @@ long do_utimes(int dfd, char __user *fil
 		if (!f)
 			goto out;
 		dentry = f->f_path.dentry;
+		mnt = f->f_path.mnt;
 	} else {
 		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
 		if (error)
 			goto out;
 
 		dentry = nd.path.dentry;
+		mnt = nd.path.mnt;
 	}
 
 	inode = dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(mnt);
+	if (error)
 		goto dput_and_out;
 
 	/* Don't worry, the checks are done in inode_change_ok() */
@@ -98,7 +102,7 @@ long do_utimes(int dfd, char __user *fil
 	if (times) {
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
@@ -118,22 +122,24 @@ long do_utimes(int dfd, char __user *fil
 	} else {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (!is_owner_or_cap(inode)) {
 			if (f) {
 				if (!(f->f_mode & FMODE_WRITE))
-					goto dput_and_out;
+					goto mnt_drop_write_and_out;
 			} else {
 				error = vfs_permission(&nd, MAY_WRITE);
 				if (error)
-					goto dput_and_out;
+					goto mnt_drop_write_and_out;
 			}
 		}
 	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
+mnt_drop_write_and_out:
+	mnt_drop_write(mnt);
 dput_and_out:
 	if (f)
 		fput(f);
_
