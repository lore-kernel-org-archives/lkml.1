Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXGLA1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXGLA1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964933AbXGLASN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:18:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47491 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964861AbXGLARn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:43 -0400
Subject: [PATCH 19/23] elevate write count for do_utimes()
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:36 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001736.5B457374@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/utimes.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/utimes.c~elevate-write-count-for-do-utimes fs/utimes.c
--- lxc/fs/utimes.c~elevate-write-count-for-do-utimes	2007-07-10 12:46:14.000000000 -0700
+++ lxc-dave/fs/utimes.c	2007-07-10 12:46:14.000000000 -0700
@@ -2,6 +2,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
@@ -75,8 +76,8 @@ long do_utimes(int dfd, char __user *fil
 
 	inode = dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(nd.mnt);
+	if (error)
 		goto dput_and_out;
 
 	/* Don't worry, the checks are done in inode_change_ok() */
@@ -84,7 +85,7 @@ long do_utimes(int dfd, char __user *fil
 	if (times) {
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
@@ -104,22 +105,24 @@ long do_utimes(int dfd, char __user *fil
 	} else {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (current->fsuid != inode->i_uid) {
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
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	if (f)
 		fput(f);
_
