Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbXIQScA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbXIQScA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXIQS1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:47 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35384 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXIQS1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:45 -0400
Subject: [PATCH 18/24] elevate write count for do_utimes()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:42 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182742.687F93EA@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/utimes.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/utimes.c~elevate-write-count-for-do-utimes fs/utimes.c
--- lxc/fs/utimes.c~elevate-write-count-for-do-utimes	2007-09-17 09:44:06.000000000 -0700
+++ lxc-dave/fs/utimes.c	2007-09-17 09:44:06.000000000 -0700
@@ -2,6 +2,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
@@ -88,8 +89,8 @@ long do_utimes(int dfd, char __user *fil
 
 	inode = dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(nd.mnt);
+	if (error)
 		goto dput_and_out;
 
 	/* Don't worry, the checks are done in inode_change_ok() */
@@ -97,7 +98,7 @@ long do_utimes(int dfd, char __user *fil
 	if (times) {
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-                        goto dput_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
@@ -117,22 +118,24 @@ long do_utimes(int dfd, char __user *fil
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
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	if (f)
 		fput(f);
_
