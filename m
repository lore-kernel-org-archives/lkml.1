Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbZDHGZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbZDHGZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761843AbZDHGZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:25:00 -0400
Received: from linuxhacker.ru ([217.76.32.60]:34842 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613AbZDHGY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:24:59 -0400
X-Greylist: delayed 1845 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 02:24:59 EDT
Date: Wed, 8 Apr 2009 09:54:11 +0400
From: Oleg Drokin <green@linuxhacker.ru>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Separate out common fstatat code
Message-ID: <20090408055411.GA1615245@fiona.linuxhacker.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

   It seems we have way too many copy&pasted fstatat code elsewhere which
   might not have been a problem until now, but with all the changes
   with "stat light" now and who knows what other additions in there in
   the future, it really helps if we have only one copy of the code.

   Hence this patch adds fstatat_common() that fills struct kstat with
   proper values and does all the AT flags parsing that's needed and
   then calls all the proper underlying functions, what's left to the
   caller now is to only copy filled out kstat buffer to the final
   destination.

Bye,
    Oleg

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fstatat_common_code.diff"

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>

 arch/arm/kernel/sys_oabi-compat.c |   14 +++-----------
 arch/s390/kernel/compat_linux.c   |   12 ++----------
 arch/sparc/kernel/sys_sparc32.c   |   12 ++----------
 arch/x86/ia32/sys_ia32.c          |   12 ++----------
 fs/compat.c                       |   12 ++----------
 fs/stat.c                         |   34 +++++++++++++++++-----------------
 include/linux/fs.h                |    1 +
 7 files changed, 29 insertions(+), 68 deletions(-)

Index: linux-2.6.29/arch/arm/kernel/sys_oabi-compat.c
===================================================================
--- linux-2.6.29.orig/arch/arm/kernel/sys_oabi-compat.c	2009-04-08 01:31:41.000000000 -0400
+++ linux-2.6.29/arch/arm/kernel/sys_oabi-compat.c	2009-04-08 01:41:59.000000000 -0400
@@ -176,20 +176,12 @@
 				   int flag)
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
+	int error;
 
+	error = fstatat_common(dfd, filename, &stat, flag);
 	if (!error)
-	error = cp_oldabi_stat64(&stat, statbuf);
+		error = cp_oldabi_stat64(&stat, statbuf);
 
-out:
 	return error;
 }
 
Index: linux-2.6.29/arch/s390/kernel/compat_linux.c
===================================================================
--- linux-2.6.29.orig/arch/s390/kernel/compat_linux.c	2009-04-08 01:31:41.000000000 -0400
+++ linux-2.6.29/arch/s390/kernel/compat_linux.c	2009-04-08 01:40:31.000000000 -0400
@@ -702,19 +702,11 @@
 				struct stat64_emu31 __user* statbuf, int flag)
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
+	int error;
 
+	error = fstatat_common(dfd, filename, &stat, flag);
 	if (!error)
 		error = cp_stat64(statbuf, &stat);
-out:
 	return error;
 }
 
Index: linux-2.6.29/arch/sparc/kernel/sys_sparc32.c
===================================================================
--- linux-2.6.29.orig/arch/sparc/kernel/sys_sparc32.c	2009-04-08 01:31:41.000000000 -0400
+++ linux-2.6.29/arch/sparc/kernel/sys_sparc32.c	2009-04-08 01:42:32.000000000 -0400
@@ -206,20 +206,12 @@
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
+	int error;
 
+	error = fstatat_common(dfd, filename, &stat, flag);
 	if (!error)
 		error = cp_compat_stat64(&stat, statbuf);
 
-out:
 	return error;
 }
 
Index: linux-2.6.29/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.29.orig/arch/x86/ia32/sys_ia32.c	2009-04-08 01:31:41.000000000 -0400
+++ linux-2.6.29/arch/x86/ia32/sys_ia32.c	2009-04-08 01:43:02.000000000 -0400
@@ -129,20 +129,12 @@
 			      struct stat64 __user *statbuf, int flag)
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
+	int error;
 
+	error = fstatat_common(dfd, filename, &stat, flag);
 	if (!error)
 		error = cp_stat64(statbuf, &stat);
 
-out:
 	return error;
 }
 
Index: linux-2.6.29/fs/compat.c
===================================================================
--- linux-2.6.29.orig/fs/compat.c	2009-04-08 01:31:41.000000000 -0400
+++ linux-2.6.29/fs/compat.c	2009-04-08 01:43:36.000000000 -0400
@@ -203,20 +203,12 @@
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
+	int error;
 
+	error = fstatat_common(dfd, filename, &stat, flag);
 	if (!error)
 		error = cp_compat_stat(&stat, statbuf);
 
-out:
 	return error;
 }
 #endif
Index: linux-2.6.29/fs/stat.c
===================================================================
--- linux-2.6.29.orig/fs/stat.c	2009-04-08 01:31:41.000000000 -0400
+++ linux-2.6.29/fs/stat.c	2009-04-08 01:45:21.000000000 -0400
@@ -259,25 +259,33 @@
 	return error;
 }
 
-#if !defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_SYS_NEWFSTATAT)
-SYSCALL_DEFINE4(newfstatat, int, dfd, char __user *, filename,
-		struct stat __user *, statbuf, int, flag)
+int fstatat_common(int dfd, char __user *filename, struct kstat *stat, int flag)
 {
-	struct kstat stat;
 	int error = -EINVAL;
 
 	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
 		goto out;
 
 	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
+		error = vfs_lstat_fd(dfd, filename, stat);
 	else
-		error = vfs_stat_fd(dfd, filename, &stat);
+		error = vfs_stat_fd(dfd, filename, stat);
+out:
+	return error;
+}
+EXPORT_SYMBOL(fstatat_common);
+
+#if !defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_SYS_NEWFSTATAT)
+SYSCALL_DEFINE4(newfstatat, int, dfd, char __user *, filename,
+		struct stat __user *, statbuf, int, flag)
+{
+	struct kstat stat;
+	int error;
 
+	error = fstatat_common(dfd, filename, &stat, flag);
 	if (!error)
 		error = cp_new_stat(&stat, statbuf);
 
-out:
 	return error;
 }
 #endif
@@ -404,20 +412,12 @@
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
+	int error;
 
+	error = fstatat_common(dfd, filename, &stat, flag);
 	if (!error)
 		error = cp_new_stat64(&stat, statbuf);
 
-out:
 	return error;
 }
 #endif /* __ARCH_WANT_STAT64 */
Index: linux-2.6.29/include/linux/fs.h
===================================================================
--- linux-2.6.29.orig/include/linux/fs.h	2009-04-08 01:31:41.000000000 -0400
+++ linux-2.6.29/include/linux/fs.h	2009-04-08 01:38:36.000000000 -0400
@@ -2075,6 +2075,7 @@
 extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
+extern int fstatat_common(int , char __user *, struct kstat *, int);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);

--+QahgC5+KEYLbs62--
