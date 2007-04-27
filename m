Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbXD0PYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbXD0PYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXD0PYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:24:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbXD0PYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:24:30 -0400
Date: Fri, 27 Apr 2007 11:23:58 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200704271523.l3RFNwGN031209@devserv.devel.redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4: merged utimensat implementation
Cc: adobriyan@openvz.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I took Alexey's lutimes patches and merged it with the utimensat patch.
Fortunately Alexey already did most of the work, the conversion to
timespec.  I just changed the name of the syscall, made the flag part
of the syscall parameters, and did away with the old do_utimes definition
(the new do_utimes takes a timespec and a flag now).  All five patches
patches are rolled into one.

Note, at userlevel I don't intend to expose the flags parameter.  We'll
have separate utimensat and lutimensat interfaces.  But there is no
reason to duplicate all that code in the kernel.

I'll send the updated test program separately.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index be133f1..b4cf563 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -955,15 +955,25 @@ osf_setitimer(int which, struct itimerval32 __user *in, struct itimerval32 __use
 asmlinkage int
 osf_utimes(char __user *filename, struct timeval32 __user *tvs)
 {
-	struct timeval ktvs[2];
+	struct timespec tv[2];
 
 	if (tvs) {
+		struct timeval ktvs[2];
 		if (get_tv32(&ktvs[0], &tvs[0]) ||
 		    get_tv32(&ktvs[1], &tvs[1]))
 			return -EFAULT;
+
+		if (ktvs[0].tv_usec < 0 || ktvs[0].tv_usec >= 1000000 ||
+		    ktvs[1].tv_usec < 0 || ktvs[1].tv_usec >= 1000000)
+			return -EINVAL;
+
+		tv[0].tv_sec = ktvs[0].tv_sec;
+		tv[0].tv_nsec = 1000 * ktvs[0].tv_usec;
+		tv[1].tv_sec = ktvs[1].tv_sec;
+		tv[1].tv_nsec = 1000 * ktvs[1].tv_usec;
 	}
 
-	return do_utimes(AT_FDCWD, filename, tvs ? ktvs : NULL);
+	return do_utimes(AT_FDCWD, filename, tvs ? tv : NULL, 0);
 }
 
 #define MAX_SELECT_SECONDS \
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index 7876a02..692e46a 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -775,15 +775,25 @@ asmlinkage long sys32_settimeofday(struct compat_timeval __user *tv,
 asmlinkage long sys32_utimes(char __user *filename,
 			     struct compat_timeval __user *tvs)
 {
-	struct timeval ktvs[2];
+	struct timespec tv[2];
 
 	if (tvs) {
+		struct timeval ktvs[2];
 		if (get_tv32(&ktvs[0], tvs) ||
 		    get_tv32(&ktvs[1], 1+tvs))
 			return -EFAULT;
+
+		if (ktvs[0].tv_usec < 0 || ktvs[0].tv_usec >= 1000000 ||
+		    ktvs[1].tv_usec < 0 || ktvs[1].tv_usec >= 1000000)
+			return -EINVAL;
+
+		tv[0].tv_sec = ktvs[0].tv_sec;
+		tv[0].tv_nsec = 1000 * ktvs[0].tv_usec;
+		tv[1].tv_sec = ktvs[1].tv_sec;
+		tv[1].tv_nsec = 1000 * ktvs[1].tv_usec;
 	}
 
-	return do_utimes(AT_FDCWD, filename, (tvs ? &ktvs[0] : NULL));
+	return do_utimes(AT_FDCWD, filename, tvs ? tv : NULL);
 }
 
 /* These are here just in case some old sparc32 binary calls it. */
diff --git a/arch/x86_64/ia32/ia32entry.S b/arch/x86_64/ia32/ia32entry.S
index 796df69..12611c8 100644
--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -714,9 +714,10 @@ ia32_sys_call_table:
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
 	.quad sys_sync_file_range
-	.quad sys_tee
+	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad compat_sys_utimensat	/* 320 */
 ia32_syscall_end:		
diff --git a/fs/compat.c b/fs/compat.c
index 040a8be..c59cbc2 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -79,30 +79,57 @@ int compat_printk(const char *fmt, ...)
  */
 asmlinkage long compat_sys_utime(char __user *filename, struct compat_utimbuf __user *t)
 {
-	struct timeval tv[2];
+	struct timespec tv[2];
 
 	if (t) {
 		if (get_user(tv[0].tv_sec, &t->actime) ||
 		    get_user(tv[1].tv_sec, &t->modtime))
 			return -EFAULT;
-		tv[0].tv_usec = 0;
-		tv[1].tv_usec = 0;
+		tv[0].tv_nsec = 0;
+		tv[1].tv_nsec = 0;
 	}
-	return do_utimes(AT_FDCWD, filename, t ? tv : NULL);
+	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
+}
+
+asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename, struct compat_timespec __user *t, int flags)
+{
+	struct timespec tv[2];
+
+	if  (t) {
+		if (get_compat_timespec(&tv[0], &t[0]) ||
+		    get_compat_timespec(&tv[1], &t[1]))
+			return -EFAULT;
+
+		if ((tv[0].tv_nsec == UTIME_OMIT || tv[0].tv_nsec == UTIME_NOW)
+		    && tv[0].tv_sec != 0)
+			return -EINVAL;
+		if ((tv[1].tv_nsec == UTIME_OMIT || tv[1].tv_nsec == UTIME_NOW)
+		    && tv[1].tv_sec != 0)
+			return -EINVAL;
+
+		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
+			return 0;
+	}
+	return do_utimes(dfd, filename, t ? tv : NULL, flags);
 }
 
 asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, struct compat_timeval __user *t)
 {
-	struct timeval tv[2];
+	struct timespec tv[2];
 
 	if (t) {
 		if (get_user(tv[0].tv_sec, &t[0].tv_sec) ||
-		    get_user(tv[0].tv_usec, &t[0].tv_usec) ||
+		    get_user(tv[0].tv_nsec, &t[0].tv_usec) ||
 		    get_user(tv[1].tv_sec, &t[1].tv_sec) ||
-		    get_user(tv[1].tv_usec, &t[1].tv_usec))
+		    get_user(tv[1].tv_nsec, &t[1].tv_usec))
 			return -EFAULT;
+		if (tv[0].tv_nsec >= 1000000 || tv[0].tv_nsec < 0 ||
+		    tv[1].tv_nsec >= 1000000 || tv[1].tv_nsec < 0)
+			return -EINVAL;
+		tv[0].tv_nsec *= 1000;
+		tv[1].tv_nsec *= 1000;
 	}
-	return do_utimes(dfd, filename, t ? tv : NULL);
+	return do_utimes(dfd, filename, t ? tv : NULL, 0);
 }
 
 asmlinkage long compat_sys_utimes(char __user *filename, struct compat_timeval __user *t)
diff --git a/fs/utimes.c b/fs/utimes.c
index 99cf2cb..6afff0a 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -3,6 +3,7 @@
 #include <linux/linkage.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
+#include <linux/stat.h>
 #include <linux/utime.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -20,54 +21,18 @@
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-asmlinkage long sys_utime(char __user * filename, struct utimbuf __user * times)
+asmlinkage long sys_utime(char __user *filename, struct utimbuf __user *times)
 {
-	int error;
-	struct nameidata nd;
-	struct inode * inode;
-	struct iattr newattrs;
-
-	error = user_path_walk(filename, &nd);
-	if (error)
-		goto out;
-	inode = nd.dentry->d_inode;
-
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto dput_and_out;
+	struct timespec tv[2];
 
-	/* Don't worry, the checks are done in inode_change_ok() */
-	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
-		error = -EPERM;
-		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto dput_and_out;
-
-		error = get_user(newattrs.ia_atime.tv_sec, &times->actime);
-		newattrs.ia_atime.tv_nsec = 0;
-		if (!error)
-			error = get_user(newattrs.ia_mtime.tv_sec, &times->modtime);
-		newattrs.ia_mtime.tv_nsec = 0;
-		if (error)
-			goto dput_and_out;
-
-		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
-	} else {
-                error = -EACCES;
-                if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
-
-		if (current->fsuid != inode->i_uid &&
-		    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
-			goto dput_and_out;
+		if (get_user(tv[0].tv_sec, &times->actime) ||
+		    get_user(tv[1].tv_sec, &times->modtime))
+			return -EFAULT;
+		tv[0].tv_nsec = 0;
+		tv[1].tv_nsec = 0;
 	}
-	mutex_lock(&inode->i_mutex);
-	error = notify_change(nd.dentry, &newattrs);
-	mutex_unlock(&inode->i_mutex);
-dput_and_out:
-	path_release(&nd);
-out:
-	return error;
+	return do_utimes(AT_FDCWD, filename, times ? tv : NULL, 0);
 }
 
 #endif
@@ -76,17 +41,21 @@ out:
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-long do_utimes(int dfd, char __user *filename, struct timeval *times)
+long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
 {
 	int error;
 	struct nameidata nd;
-	struct inode * inode;
+	struct inode *inode;
 	struct iattr newattrs;
 
-	error = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
+	error = -EINVAL;
+	if (flags & ~AT_SYMLINK_NOFOLLOW)
+		goto out;
 
+	error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
 	if (error)
 		goto out;
+
 	inode = nd.dentry->d_inode;
 
 	error = -EROFS;
@@ -100,11 +69,21 @@ long do_utimes(int dfd, char __user *filename, struct timeval *times)
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
                         goto dput_and_out;
 
-		newattrs.ia_atime.tv_sec = times[0].tv_sec;
-		newattrs.ia_atime.tv_nsec = times[0].tv_usec * 1000;
-		newattrs.ia_mtime.tv_sec = times[1].tv_sec;
-		newattrs.ia_mtime.tv_nsec = times[1].tv_usec * 1000;
-		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
+		if (times[0].tv_nsec == UTIME_OMIT)
+			newattrs.ia_valid &= ~ATTR_ATIME;
+		else if (times[0].tv_nsec != UTIME_NOW) {
+			newattrs.ia_atime.tv_sec = times[0].tv_sec;
+			newattrs.ia_atime.tv_nsec = times[0].tv_nsec;
+			newattrs.ia_valid |= ATTR_ATIME_SET;
+		}
+
+		if (times[1].tv_nsec == UTIME_OMIT)
+			newattrs.ia_valid &= ~ATTR_MTIME;
+		else if (times[1].tv_nsec != UTIME_NOW) {
+			newattrs.ia_mtime.tv_sec = times[1].tv_sec;
+			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
+			newattrs.ia_valid |= ATTR_MTIME_SET;
+		}
 	} else {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
@@ -123,13 +102,56 @@ out:
 	return error;
 }
 
+asmlinkage long sys_utimensat(int dfd, char __user *filename, struct timespec __user *utimes, int flags)
+{
+	struct timespec tstimes[2];
+
+	if (utimes) {
+		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
+			return -EFAULT;
+		if ((tstimes[0].tv_nsec == UTIME_OMIT ||
+		     tstimes[0].tv_nsec == UTIME_NOW) &&
+		    tstimes[0].tv_sec != 0)
+			return -EINVAL;
+		if ((tstimes[1].tv_nsec == UTIME_OMIT ||
+		     tstimes[1].tv_nsec == UTIME_NOW) &&
+		    tstimes[1].tv_sec != 0)
+			return -EINVAL;
+
+		/* Nothing to do, we must not even check the path.  */
+		if (tstimes[0].tv_nsec == UTIME_OMIT &&
+		    tstimes[1].tv_nsec == UTIME_OMIT)
+			return 0;
+	}
+
+	return do_utimes(dfd, filename, utimes ? tstimes : NULL, flags);
+}
+
 asmlinkage long sys_futimesat(int dfd, char __user *filename, struct timeval __user *utimes)
 {
 	struct timeval times[2];
+	struct timespec tstimes[2];
+
+	if (utimes) {
+		if (copy_from_user(&times, utimes, sizeof(times)))
+			return -EFAULT;
+
+		/* This test is needed to catch all invalid values.  If we
+		   would test only in do_utimes we would miss those invalid
+		   values truncated by the multiplication with 1000.  Note
+		   that we also catch UTIME_{NOW,OMIT} here which are only
+		   valid for utimensat.  */
+		if (times[0].tv_usec >= 1000000 || times[0].tv_usec < 0 ||
+		    times[1].tv_usec >= 1000000 || times[1].tv_usec < 0)
+			return -EINVAL;
+
+		tstimes[0].tv_sec = times[0].tv_sec;
+		tstimes[0].tv_nsec = 1000 * times[0].tv_usec;
+		tstimes[1].tv_sec = times[1].tv_sec;
+		tstimes[1].tv_nsec = 1000 * times[1].tv_usec;
+	}
 
-	if (utimes && copy_from_user(&times, utimes, sizeof(times)))
-		return -EFAULT;
-	return do_utimes(dfd, filename, utimes ? times : NULL);
+	return do_utimes(dfd, filename, utimes ? tstimes : NULL, 0);
 }
 
 asmlinkage long sys_utimes(char __user *filename, struct timeval __user *utimes)
diff --git a/include/asm-i386/unistd.h b/include/asm-i386/unistd.h
index 833fa17..bd21e79 100644
--- a/include/asm-i386/unistd.h
+++ b/include/asm-i386/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_utimensat		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/asm-x86_64/unistd.h b/include/asm-x86_64/unistd.h
index c5f596e..0aae2ae 100644
--- a/include/asm-x86_64/unistd.h
+++ b/include/asm-x86_64/unistd.h
@@ -619,8 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync_file_range)
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_utimensat		280
+__SYSCALL(__NR_utimensat, sys_utimensat)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_utimensat
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 679ef0d..611c398 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -53,6 +53,9 @@
 #define S_IWUGO		(S_IWUSR|S_IWGRP|S_IWOTH)
 #define S_IXUGO		(S_IXUSR|S_IXGRP|S_IXOTH)
 
+#define UTIME_NOW	((1l << 30) - 1l)
+#define UTIME_OMIT	((1l << 30) - 2l)
+
 #include <linux/types.h>
 #include <linux/time.h>
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 8ea8dea..39ffa6c 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -109,7 +109,7 @@ extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, char __user *filename, struct timeval *times);
+extern long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
