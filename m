Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbZDHQGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbZDHQGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZDHQFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:05:46 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47948 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZDHQFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:05:44 -0400
Date: Wed, 8 Apr 2009 20:05:42 +0400
From: Oleg Drokin <green@linuxhacker.ru>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Separate out common fstatat code into vfs_fstatat
Message-ID: <20090408160541.GA1812319@fiona.linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a version incorporating Christoph's suggestion.

Separate out common *fstatat functionality into a single function
instead of duplicating it all over the code.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>

 arch/arm/kernel/sys_oabi-compat.c |   19 +++---------
 arch/s390/kernel/compat_linux.c   |   18 +++---------
 arch/sparc/kernel/sys_sparc32.c   |   19 +++---------
 arch/x86/ia32/sys_ia32.c          |   19 +++---------
 fs/compat.c                       |   19 +++---------
 fs/stat.c                         |   56 +++++++++++++++++++-------------------
 include/linux/fs.h                |    1 
 7 files changed, 54 insertions(+), 97 deletions(-)

Index: linux-2.6.29/arch/arm/kernel/sys_oabi-compat.c
===================================================================
--- linux-2.6.29.orig/arch/arm/kernel/sys_oabi-compat.c	2009-04-08 01:47:52.000000000 -0400
+++ linux-2.6.29/arch/arm/kernel/sys_oabi-compat.c	2009-04-08 11:44:30.000000000 -0400
@@ -176,21 +176,12 @@
 				   int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
+	int error;
 
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-	error = cp_oldabi_stat64(&stat, statbuf);
-
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_oldabi_stat64(&stat, statbuf);
 }
 
 struct oabi_flock64 {
Index: linux-2.6.29/arch/s390/kernel/compat_linux.c
===================================================================
--- linux-2.6.29.orig/arch/s390/kernel/compat_linux.c	2009-04-08 01:47:52.000000000 -0400
+++ linux-2.6.29/arch/s390/kernel/compat_linux.c	2009-04-08 11:44:38.000000000 -0400
@@ -702,20 +702,12 @@
 				struct stat64_emu31 __user* statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
+	int error;
 
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_stat64(statbuf, &stat);
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_stat64(statbuf, &stat);
 }
 
 /*
Index: linux-2.6.29/arch/sparc/kernel/sys_sparc32.c
===================================================================
--- linux-2.6.29.orig/arch/sparc/kernel/sys_sparc32.c	2009-04-08 01:47:52.000000000 -0400
+++ linux-2.6.29/arch/sparc/kernel/sys_sparc32.c	2009-04-08 11:44:47.000000000 -0400
@@ -206,21 +206,12 @@
 		struct compat_stat64 __user * statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_compat_stat64(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_compat_stat64(&stat, statbuf);
 }
 
 asmlinkage long compat_sys_sysfs(int option, u32 arg1, u32 arg2)
Index: linux-2.6.29/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.29.orig/arch/x86/ia32/sys_ia32.c	2009-04-08 01:47:52.000000000 -0400
+++ linux-2.6.29/arch/x86/ia32/sys_ia32.c	2009-04-08 11:44:54.000000000 -0400
@@ -129,21 +129,12 @@
 			      struct stat64 __user *statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
+	int error;
 
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_stat64(statbuf, &stat);
-
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_stat64(statbuf, &stat);
 }
 
 /*
Index: linux-2.6.29/fs/compat.c
===================================================================
--- linux-2.6.29.orig/fs/compat.c	2009-04-08 01:47:52.000000000 -0400
+++ linux-2.6.29/fs/compat.c	2009-04-08 11:44:17.000000000 -0400
@@ -203,21 +203,12 @@
 		struct compat_stat __user *statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_compat_stat(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_compat_stat(&stat, statbuf);
 }
 #endif
 
Index: linux-2.6.29/fs/stat.c
===================================================================
--- linux-2.6.29.orig/fs/stat.c	2009-04-08 01:47:52.000000000 -0400
+++ linux-2.6.29/fs/stat.c	2009-04-08 11:47:19.000000000 -0400
@@ -109,6 +109,24 @@
 
 EXPORT_SYMBOL(vfs_fstat);
 
+int vfs_fstatat(int dfd, char __user *filename, struct kstat *stat, int flag)
+{
+	int error = -EINVAL;
+
+	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
+		goto out;
+
+	if (flag & AT_SYMLINK_NOFOLLOW)
+		error = vfs_lstat_fd(dfd, filename, stat);
+	else
+		error = vfs_stat_fd(dfd, filename, stat);
+out:
+	return error;
+}
+
+EXPORT_SYMBOL(vfs_fstatat);
+
+
 #ifdef __ARCH_WANT_OLD_STAT
 
 /*
@@ -264,21 +282,12 @@
 		struct stat __user *, statbuf, int, flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_new_stat(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_new_stat(&stat, statbuf);
 }
 #endif
 
@@ -404,21 +413,12 @@
 		struct stat64 __user *, statbuf, int, flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_new_stat64(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_new_stat64(&stat, statbuf);
 }
 #endif /* __ARCH_WANT_STAT64 */
 
Index: linux-2.6.29/include/linux/fs.h
===================================================================
--- linux-2.6.29.orig/include/linux/fs.h	2009-04-08 01:47:52.000000000 -0400
+++ linux-2.6.29/include/linux/fs.h	2009-04-08 11:47:38.000000000 -0400
@@ -2075,6 +2075,7 @@
 extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
+extern int vfs_fstatat(int , char __user *, struct kstat *, int);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
