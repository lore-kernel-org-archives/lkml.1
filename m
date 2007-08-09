Return-Path: <linux-kernel-owner+w=401wt.eu-S966202AbXHIPbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966202AbXHIPbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938645AbXHIP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:29:49 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40612 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764011AbXHIP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:29:45 -0400
Message-Id: <20070809152859.787064024@szeredi.hu>
References: <20070809152744.519270818@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 17:27:45 +0200
From: miklos@szeredi.hu
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 1/4] pass open file to ->setattr()
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
--- linux.orig/fs/open.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/open.c	2007-08-09 16:48:43.000000000 +0200
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
@@ -659,6 +661,10 @@ static int chown_common(struct dentry * 
 	}
 	if (!S_ISDIR(inode->i_mode))
 		newattrs.ia_valid |= ATTR_KILL_SUID|ATTR_KILL_SGID;
+	if (file) {
+		newattrs.ia_file = file;
+		newattrs.ia_valid |= ATTR_FILE;
+	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
@@ -674,7 +680,7 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	path_release(&nd);
 out:
 	return error;
@@ -694,7 +700,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	path_release(&nd);
 out:
 	return error;
@@ -708,7 +714,7 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	path_release(&nd);
 out:
 	return error;
@@ -727,7 +733,7 @@ asmlinkage long sys_fchown(unsigned int 
 
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = chown_common(dentry, user, group);
+	error = chown_common(dentry, user, group, file);
 	fput(file);
 out:
 	return error;
Index: linux/fs/utimes.c
===================================================================
--- linux.orig/fs/utimes.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/utimes.c	2007-08-09 16:48:43.000000000 +0200
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
