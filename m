Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbYEPQhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbYEPQhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYEPQdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:33:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33721 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbYEPQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:38 -0400
Message-Id: <20080516163223.610317060@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:44 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: [patch 08/22] vfs: immutable inode checking cleanup
Content-Disposition: inline; filename=immutable_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move the immutable and append-only checks from chmod, chown and utimes
into notify_change().  Checks for immutable and append-only files are
always performed by the VFS and not by the filesystem (see
permission() and may_...() in namei.c), so these belong in
notify_change(), and not in inode_change_ok().

This causes the following semantic changes in sys_utimensat(), if both
times are either UTIME_NOW or UTIME_OMIT:

 - if inode is immutable, then -EACCESS is returned instead of -EPERM
 - if inode is append-only, then success is returned instead of -EPERM

This should be OK, becuase this makes the UTIME_NOW on both behave
exactly the same as times == NULL.  If one of the times is UTIME_OMIT,
and the other is UTIME_NOW, it also makes no sense to return a
different error for immutable or append-only files.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Ulrich Drepper <drepper@redhat.com>
---
 fs/attr.c   |    6 ++++++
 fs/open.c   |   24 ++----------------------
 fs/utimes.c |    4 ----
 3 files changed, 8 insertions(+), 26 deletions(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-16 17:50:45.000000000 +0200
@@ -582,9 +582,6 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = mnt_want_write(file->f_path.mnt);
 	if (err)
 		goto out_putf;
-	err = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -592,8 +589,6 @@ asmlinkage long sys_fchmod(unsigned int 
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out_putf:
 	fput(file);
@@ -617,11 +612,6 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto dput_and_out;
-
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
-
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -629,8 +619,6 @@ asmlinkage long sys_fchmodat(int dfd, co
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
@@ -645,18 +633,10 @@ asmlinkage long sys_chmod(const char __u
 
 static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
 {
-	struct inode * inode;
+	struct inode *inode = dentry->d_inode;
 	int error;
 	struct iattr newattrs;
 
-	error = -ENOENT;
-	if (!(inode = dentry->d_inode)) {
-		printk(KERN_ERR "chown_common: NULL inode\n");
-		goto out;
-	}
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out;
 	newattrs.ia_valid =  ATTR_CTIME;
 	if (user != (uid_t) -1) {
 		newattrs.ia_valid |= ATTR_UID;
@@ -672,7 +652,7 @@ static int chown_common(struct dentry * 
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-out:
+
 	return error;
 }
 
Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-05-16 17:50:45.000000000 +0200
@@ -108,6 +108,12 @@ int notify_change(struct dentry * dentry
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
+			ATTR_ATIME_SET | ATTR_MTIME_SET)) {
+		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+			return -EPERM;
+	}
+
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-16 17:50:45.000000000 +0200
@@ -105,10 +105,6 @@ long do_utimes(int dfd, char __user *fil
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
-		error = -EPERM;
-                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto mnt_drop_write_and_out;
-
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
 		else if (times[0].tv_nsec != UTIME_NOW) {

--
