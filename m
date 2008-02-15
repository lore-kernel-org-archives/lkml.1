Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbYBOWv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbYBOWv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932161AbYBOWiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:09 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60748 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbYBOWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:59 -0500
Subject: [PATCH 22/30] r/o bind mounts: elevate write count for chmod/chown callers
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:50 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223750.6E962669@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


chown/chmod,etc...  don't call permission in the same way that the normal
"open for write" calls do.  They still write to the filesystem, so bump the
write count during these operations.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/open.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-elevate-writer-count-for-chown-and-friends fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-elevate-writer-count-for-chown-and-friends	2008-02-15 13:25:55.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-15 13:25:55.000000000 -0800
@@ -567,12 +567,12 @@ asmlinkage long sys_fchmod(unsigned int 
 
 	audit_inode(NULL, dentry);
 
-	err = -EROFS;
-	if (IS_RDONLY(inode))
+	err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		goto out_putf;
 	err = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_putf;
+		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -581,6 +581,8 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(file->f_vfsmnt);
 out_putf:
 	fput(file);
 out:
@@ -600,13 +602,13 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = nd.path.dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
 		goto dput_and_out;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto out_drop_write;
 
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
@@ -616,6 +618,8 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
 out:
@@ -638,9 +642,6 @@ static int chown_common(struct dentry * 
 		printk(KERN_ERR "chown_common: NULL inode\n");
 		goto out;
 	}
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto out;
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out;
@@ -671,7 +672,12 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -691,7 +697,12 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -705,7 +716,12 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -722,9 +738,14 @@ asmlinkage long sys_fchown(unsigned int 
 	if (!file)
 		goto out;
 
+	error = mnt_want_write(file->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
 	error = chown_common(dentry, user, group);
+	mnt_drop_write(file->f_vfsmnt);
+out_fput:
 	fput(file);
 out:
 	return error;
_
