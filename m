Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYGANDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYGANDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYGANCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:02:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44039 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYGANCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:02:01 -0400
Message-Id: <20080701130156.863544252@szeredi.hu>
References: <20080701130125.529844715@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 01 Jul 2008 15:01:29 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       Ulrich Drepper <drepper@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [patch 4/4] vfs: immutable inode checking cleanup
Content-Disposition: inline; filename=vfs-immutable-inode-checking-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move the immutable and append-only checks from chmod, chown and utimes
into notify_change().  Checks for immutable and append-only files are
always performed by the VFS and not by the filesystem (see
permission() and may_...() in namei.c), so these belong in
notify_change(), and not in inode_change_ok().

This should be completely equivalent.

CC: Ulrich Drepper <drepper@redhat.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/attr.c   |    5 +++++
 fs/open.c   |   24 ++----------------------
 fs/utimes.c |    4 ----
 3 files changed, 7 insertions(+), 26 deletions(-)

Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-07-01 13:52:20.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-07-01 13:52:29.000000000 +0200
@@ -108,6 +108,11 @@ int notify_change(struct dentry * dentry
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
+		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+			return -EPERM;
+	}
+
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-07-01 13:52:17.000000000 +0200
+++ linux-2.6/fs/open.c	2008-07-01 13:52:29.000000000 +0200
@@ -598,9 +598,6 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = mnt_want_write(file->f_path.mnt);
 	if (err)
 		goto out_putf;
-	err = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -608,8 +605,6 @@ asmlinkage long sys_fchmod(unsigned int 
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out_putf:
 	fput(file);
@@ -633,11 +628,6 @@ asmlinkage long sys_fchmodat(int dfd, co
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
@@ -645,8 +635,6 @@ asmlinkage long sys_fchmodat(int dfd, co
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
@@ -661,18 +649,10 @@ asmlinkage long sys_chmod(const char __u
 
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
@@ -688,7 +668,7 @@ static int chown_common(struct dentry * 
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-out:
+
 	return error;
 }
 
Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-07-01 13:52:23.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-07-01 13:52:29.000000000 +0200
@@ -64,10 +64,6 @@ static int utimes_common(struct path *pa
 
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
