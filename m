Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXD0DIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXD0DIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 23:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbXD0DIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 23:08:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbXD0DIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 23:08:40 -0400
Date: Thu, 26 Apr 2007 23:08:36 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200704270308.l3R38axl031062@devserv.devel.redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v3: utimensat implementation
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One comment I got suggested to clean up the overflow tests.  There
is no reason to not perform the full micro-second overflow test
in those two places.  The four conditions are reduced by the compiler
to just two tests so there's no problems with performance.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>

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
index 040a8be..d8a8cb5 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -79,28 +79,55 @@ int compat_printk(const char *fmt, ...)
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
 	return do_utimes(AT_FDCWD, filename, t ? tv : NULL);
 }
 
+asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename, struct compat_timespec __user *t)
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
+	return do_utimes(dfd, filename, t ? tv : NULL);
+}
+
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
 	return do_utimes(dfd, filename, t ? tv : NULL);
 }
diff --git a/fs/utimes.c b/fs/utimes.c
index 99cf2cb..d854af7 100644
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
@@ -76,7 +77,7 @@ out:
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-long do_utimes(int dfd, char __user *filename, struct timeval *times)
+long do_utimes(int dfd, char __user *filename, struct timespec *times)
 {
 	int error;
 	struct nameidata nd;
@@ -100,11 +101,21 @@ long do_utimes(int dfd, char __user *filename, struct timeval *times)
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
@@ -123,13 +134,55 @@ out:
 	return error;
 }
 
+asmlinkage long sys_utimensat(int dfd, char __user *filename, struct timespec __user *utimes)
+{
+	struct timespec tstimes[2];
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
+	return do_utimes(dfd, filename, utimes ? tstimes : NULL);
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
+	return do_utimes(dfd, filename, utimes ? tstimes : NULL);
 }
 
 asmlinkage long sys_utimes(char __user *filename, struct timeval __user *utimes)
diff --git a/include/asm-i386/unistd.h b/include/asm-i386/unistd.h
index 833fa17..17a9d5a 100644
--- a/include/asm-i386/unistd.h
+++ b/include/asm-i386/unistd.h
@@ -325,6 +325,7 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_utimensat		320
 
 #ifdef __KERNEL__
 
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
index 8ea8dea..936b21b 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -109,7 +109,7 @@ extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, char __user *filename, struct timeval *times);
+extern long do_utimes(int dfd, char __user *filename, struct timespec *times);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
