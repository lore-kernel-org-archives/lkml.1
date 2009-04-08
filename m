Return-Path: <linux-kernel-owner+w=401wt.eu-S1763178AbZDHUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763178AbZDHUeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbZDHUeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:34:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbZDHUeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:34:03 -0400
Date: Wed, 8 Apr 2009 16:34:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kill vfs_stat_fd / vfs_lstat_fd
Message-ID: <20090408203402.GB14342@infradead.org>
References: <20090408160541.GA1812319@fiona.linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408160541.GA1812319@fiona.linuxhacker.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's really no reason to keep vfs_stat_fd and vfs_lstat_fd with
Oleg's vfs_fstatat.  Use vfs_fstatat for the few cases having the
directory fd, and switch all others to vfs_stat / vfs_lstat.


Reviewed-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/compat.c
===================================================================
--- xfs.orig/fs/compat.c	2009-04-08 22:20:41.262444943 +0200
+++ xfs/fs/compat.c	2009-04-08 22:20:47.526445520 +0200
@@ -180,22 +180,24 @@ asmlinkage long compat_sys_newstat(char 
 		struct compat_stat __user *statbuf)
 {
 	struct kstat stat;
-	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_compat_stat(&stat, statbuf);
-	return error;
+	error = = vfs_stat(filename, &stat);
+	if (error)
+		return error;
+	return cp_compat_stat(&stat, statbuf);
 }
 
 asmlinkage long compat_sys_newlstat(char __user * filename,
 		struct compat_stat __user *statbuf)
 {
 	struct kstat stat;
-	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_compat_stat(&stat, statbuf);
-	return error;
+	error = vfs_lstat(filename, &stat);
+	if (error)
+		return error;
+	return cp_compat_stat(&stat, statbuf);
 }
 
 #ifndef __ARCH_WANT_STAT64
Index: xfs/fs/stat.c
===================================================================
--- xfs.orig/fs/stat.c	2009-04-08 22:20:41.264445547 +0200
+++ xfs/fs/stat.c	2009-04-08 22:28:24.329448312 +0200
@@ -55,46 +55,6 @@ int vfs_getattr(struct vfsmount *mnt, st
 
 EXPORT_SYMBOL(vfs_getattr);
 
-int vfs_stat_fd(int dfd, char __user *name, struct kstat *stat)
-{
-	struct path path;
-	int error;
-
-	error = user_path_at(dfd, name, LOOKUP_FOLLOW, &path);
-	if (!error) {
-		error = vfs_getattr(path.mnt, path.dentry, stat);
-		path_put(&path);
-	}
-	return error;
-}
-
-int vfs_stat(char __user *name, struct kstat *stat)
-{
-	return vfs_stat_fd(AT_FDCWD, name, stat);
-}
-
-EXPORT_SYMBOL(vfs_stat);
-
-int vfs_lstat_fd(int dfd, char __user *name, struct kstat *stat)
-{
-	struct path path;
-	int error;
-
-	error = user_path_at(dfd, name, 0, &path);
-	if (!error) {
-		error = vfs_getattr(path.mnt, path.dentry, stat);
-		path_put(&path);
-	}
-	return error;
-}
-
-int vfs_lstat(char __user *name, struct kstat *stat)
-{
-	return vfs_lstat_fd(AT_FDCWD, name, stat);
-}
-
-EXPORT_SYMBOL(vfs_lstat);
-
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
 	struct file *f = fget(fd);
@@ -106,26 +66,43 @@ int vfs_fstat(unsigned int fd, struct ks
 	}
 	return error;
 }
-
 EXPORT_SYMBOL(vfs_fstat);
 
 int vfs_fstatat(int dfd, char __user *filename, struct kstat *stat, int flag)
 {
+	struct path path;
 	int error = -EINVAL;
+	int lookup_flags = 0;
 
 	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
 		goto out;
 
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, stat);
-	else
-		error = vfs_stat_fd(dfd, filename, stat);
+	if (!(flag & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+
+	error = user_path_at(dfd, filename, lookup_flags, &path);
+	if (error)
+		goto out;
+
+	error = vfs_getattr(path.mnt, path.dentry, stat);
+	path_put(&path);
 out:
 	return error;
 }
-
 EXPORT_SYMBOL(vfs_fstatat);
 
+int vfs_stat(char __user *name, struct kstat *stat)
+{
+	return vfs_fstatat(AT_FDCWD, name, stat, 0);
+}
+EXPORT_SYMBOL(vfs_stat);
+
+int vfs_lstat(char __user *name, struct kstat *stat)
+{
+	return vfs_fstatat(AT_FDCWD, name, stat, AT_SYMLINK_NOFOLLOW);
+}
+EXPORT_SYMBOL(vfs_lstat);
+
 
 #ifdef __ARCH_WANT_OLD_STAT
 
@@ -173,23 +150,25 @@ static int cp_old_stat(struct kstat *sta
 SYSCALL_DEFINE2(stat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_old_stat(&stat, statbuf);
+	error = vfs_stat(filename, &stat);
+	if (error)
+		return error;
 
-	return error;
+	return cp_old_stat(&stat, statbuf);
 }
 
 SYSCALL_DEFINE2(lstat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_old_stat(&stat, statbuf);
+	error = vfs_lstat(filename, &stat);
+	if (error)
+		return error;
 
-	return error;
+	return cp_old_stat(&stat, statbuf);
 }
 
 SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, statbuf)
@@ -258,23 +237,23 @@ static int cp_new_stat(struct kstat *sta
 SYSCALL_DEFINE2(newstat, char __user *, filename, struct stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);
-
-	if (!error)
-		error = cp_new_stat(&stat, statbuf);
+	int error = vfs_stat(filename, &stat);
 
-	return error;
+	if (error)
+		return error;
+	return cp_new_stat(&stat, statbuf);
 }
 
 SYSCALL_DEFINE2(newlstat, char __user *, filename, struct stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_new_stat(&stat, statbuf);
+	error = vfs_lstat(filename, &stat);
+	if (error)
+		return error;
 
-	return error;
+	return cp_new_stat(&stat, statbuf);
 }
 
 #if !defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_SYS_NEWFSTATAT)
Index: xfs/include/linux/fs.h
===================================================================
--- xfs.orig/include/linux/fs.h	2009-04-08 22:20:41.267529390 +0200
+++ xfs/include/linux/fs.h	2009-04-08 22:20:47.529528804 +0200
@@ -2223,8 +2223,6 @@ extern int vfs_readdir(struct file *, fi
 
 extern int vfs_stat(char __user *, struct kstat *);
 extern int vfs_lstat(char __user *, struct kstat *);
-extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
-extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , char __user *, struct kstat *, int);
 
