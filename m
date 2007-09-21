Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbXIUMeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbXIUMeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXIUMeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:34:05 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45012 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXIUMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:34:01 -0400
Message-Id: <20070921123330.357683322@szeredi.hu>
References: <20070921122343.307289079@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 21 Sep 2007 14:23:44 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 1/5] VFS: pass open file to ->setattr()
Content-Disposition: inline; filename=vfs_setattr_file.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Pass the open file into the filesystem's ->setattr() method for
fchmod, fchown and some of the utimes variants.

This is needed to be able to correctly implement open-unlink-fsetattr
semantics in some filesystem such as sshfs, without having to resort
to "silly-renaming".

The infrastructure is already there, so just need to fill in
attrs.ia_file and set ATTR_FILE in attrs.ia_valid.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/open.c
===================================================================
--- linux.orig/fs/open.c	2007-09-21 13:44:57.000000000 +0200
+++ linux/fs/open.c	2007-09-21 13:45:04.000000000 +0200
@@ -581,7 +581,8 @@ asmlinkage long sys_fchmod(unsigned int 
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
-	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME | ATTR_FILE;
+	newattrs.ia_file = file;
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
@@ -631,7 +632,8 @@ asmlinkage long sys_chmod(const char __u
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
+static int chown_common(struct dentry * dentry, uid_t user, gid_t group,
+			struct file *file)
 {
 	struct inode * inode;
 	int error;
@@ -660,6 +662,10 @@ static int chown_common(struct dentry * 
 	if (!S_ISDIR(inode->i_mode))
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
+	if (file) {
+		newattrs.ia_file = file;
+		newattrs.ia_valid |= ATTR_FILE;
+	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
@@ -675,7 +681,7 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	path_release(&nd);
 out:
 	return error;
@@ -695,7 +701,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	path_release(&nd);
 out:
 	return error;
@@ -709,7 +715,7 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	path_release(&nd);
 out:
 	return error;
@@ -728,7 +734,7 @@ asmlinkage long sys_fchown(unsigned int 
 
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = chown_common(dentry, user, group);
+	error = chown_common(dentry, user, group, file);
 	fput(file);
 out:
 	return error;
Index: linux/fs/utimes.c
===================================================================
--- linux.orig/fs/utimes.c	2007-09-21 13:44:57.000000000 +0200
+++ linux/fs/utimes.c	2007-09-21 13:45:04.000000000 +0200
@@ -130,6 +130,10 @@ long do_utimes(int dfd, char __user *fil
 			}
 		}
 	}
+	if (f) {
+		newattrs.ia_file = f;
+		newattrs.ia_valid |= ATTR_FILE;
+	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);

--
