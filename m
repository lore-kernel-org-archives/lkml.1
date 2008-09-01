Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYIAQWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYIAQWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYIAQWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:22:34 -0400
Received: from verein.lst.de ([213.95.11.210]:60054 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYIAQWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:22:32 -0400
Date: Mon, 1 Sep 2008 18:22:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] compat: generic compat get/settimeofday
Message-ID: <20080901162231.GC16320@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing arch specific in get/settimeofday.  The details of the timeval
conversion varied a little from arch to arch, but all with the same
results.

Also add an extern declaration for sys_tz to linux/time.h because
externs in .c files are fowned upon.  I'll kill the externs in various
other files in a sparate patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/powerpc/kernel/sys_ppc32.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/sys_ppc32.c	2008-09-01 09:31:49.000000000 -0300
+++ linux-2.6/arch/powerpc/kernel/sys_ppc32.c	2008-09-01 09:32:42.000000000 -0300
@@ -71,69 +71,6 @@ asmlinkage long compat_sys_sysfs(u32 opt
 	return sys_sysfs((int)option, arg1, arg2);
 }
 
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) |
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
-
-
-
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-extern struct timezone sys_tz;
-
-asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	
-	return 0;
-}
-
-
-
-asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-	
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 #ifdef CONFIG_SYSVIPC
 long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compat_uptr_t ptr,
 	       u32 fifth)
Index: linux-2.6/kernel/compat.c
===================================================================
--- linux-2.6.orig/kernel/compat.c	2008-09-01 09:29:15.000000000 -0300
+++ linux-2.6/kernel/compat.c	2008-09-01 09:32:42.000000000 -0300
@@ -26,6 +26,64 @@
 
 #include <asm/uaccess.h>
 
+/*
+ * Note that the native side is already converted to a timespec, because
+ * that's what we want anyway.
+ */
+static int compat_get_timeval(struct timespec *o,
+		struct compat_timeval __user *i)
+{
+	long usec;
+
+	if (get_user(o->tv_sec, &i->tv_sec) ||
+	    get_user(usec, &i->tv_usec))
+		return -EFAULT;
+	o->tv_nsec = usec * 1000;
+	return 0;
+}
+
+static int compat_put_timeval(struct compat_timeval __user *o,
+		struct timeval *i)
+{
+	return (put_user(i->tv_sec, &o->tv_sec) ||
+		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
+}
+
+asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz)
+{
+	if (tv) {
+		struct timeval ktv;
+		do_gettimeofday(&ktv);
+		if (compat_put_timeval(tv, &ktv))
+			return -EFAULT;
+	}
+	if (tz) {
+		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz)
+{
+	struct timespec kts;
+	struct timezone ktz;
+
+ 	if (tv) {
+		if (compat_get_timeval(&kts, tv))
+			return -EFAULT;
+	}
+	if (tz) {
+		if (copy_from_user(&ktz, tz, sizeof(ktz)))
+			return -EFAULT;
+	}
+
+	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
+}
+
 int get_compat_timespec(struct timespec *ts, const struct compat_timespec __user *cts)
 {
 	return (!access_ok(VERIFY_READ, cts, sizeof(*cts)) ||
Index: linux-2.6/arch/s390/kernel/compat_linux.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/compat_linux.c	2008-09-01 09:31:49.000000000 -0300
+++ linux-2.6/arch/s390/kernel/compat_linux.c	2008-09-01 09:32:42.000000000 -0300
@@ -279,22 +279,6 @@ asmlinkage long sys32_getegid16(void)
 	return high2lowgid(current->egid);
 }
 
-/* 32-bit timeval and related flotsam.  */
-
-static inline long get_tv32(struct timeval *o, struct compat_timeval __user *i)
-{
-	return (!access_ok(VERIFY_READ, o, sizeof(*o)) ||
-		(__get_user(o->tv_sec, &i->tv_sec) ||
-		 __get_user(o->tv_usec, &i->tv_usec)));
-}
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) ||
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
 /*
  * sys32_ipc() is the de-multiplexer for the SysV IPC calls in 32bit emulation.
  *
@@ -522,57 +506,6 @@ sys32_delete_module(const char __user *n
 
 #endif  /* CONFIG_MODULES */
 
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-
-extern struct timezone sys_tz;
-
-asmlinkage long sys32_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-asmlinkage long sys32_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 asmlinkage long sys32_pread64(unsigned int fd, char __user *ubuf,
 				size_t count, u32 poshi, u32 poslo)
 {
Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h	2008-09-01 09:29:15.000000000 -0300
+++ linux-2.6/include/linux/time.h	2008-09-01 09:32:42.000000000 -0300
@@ -29,6 +29,8 @@ struct timezone {
 
 #ifdef __KERNEL__
 
+extern struct timezone sys_tz;
+
 /* Parameters used to convert the timespec values: */
 #define MSEC_PER_SEC	1000L
 #define USEC_PER_MSEC	1000L
Index: linux-2.6/arch/sparc64/kernel/sys_sparc32.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/sys_sparc32.c	2008-09-01 09:31:49.000000000 -0300
+++ linux-2.6/arch/sparc64/kernel/sys_sparc32.c	2008-09-01 09:32:42.000000000 -0300
@@ -58,15 +58,6 @@
 #include <asm/mmu_context.h>
 #include <asm/compat_signal.h>
 
-/* 32-bit timeval and related flotsam.  */
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) |
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
 #ifdef CONFIG_SYSVIPC                                                        
 asmlinkage long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compat_uptr_t ptr, u32 fifth)
 {
@@ -487,59 +478,6 @@ asmlinkage long sys32_delete_module(cons
 
 #endif  /* CONFIG_MODULES */
 
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-
-extern struct timezone sys_tz;
-
-asmlinkage long sys32_gettimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-asmlinkage long sys32_settimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 /* These are here just in case some old sparc32 binary calls it. */
 asmlinkage long sys32_pause(void)
 {
Index: linux-2.6/arch/s390/kernel/compat_linux.h
===================================================================
--- linux-2.6.orig/arch/s390/kernel/compat_linux.h	2008-09-01 09:31:48.000000000 -0300
+++ linux-2.6/arch/s390/kernel/compat_linux.h	2008-09-01 09:32:42.000000000 -0300
@@ -202,10 +202,6 @@ long sys32_execve(void);
 long sys32_init_module(void __user *umod, unsigned long len,
 		       const char __user *uargs);
 long sys32_delete_module(const char __user *name_user, unsigned int flags);
-long sys32_gettimeofday(struct compat_timeval __user *tv,
-			struct timezone __user *tz);
-long sys32_settimeofday(struct compat_timeval __user *tv,
-			struct timezone __user *tz);
 long sys32_pread64(unsigned int fd, char __user *ubuf, size_t count,
 		   u32 poshi, u32 poslo);
 long sys32_pwrite64(unsigned int fd, const char __user *ubuf,
Index: linux-2.6/arch/sparc64/kernel/systbls.S
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/systbls.S	2008-09-01 09:29:15.000000000 -0300
+++ linux-2.6/arch/sparc64/kernel/systbls.S	2008-09-01 09:32:42.000000000 -0300
@@ -41,8 +41,8 @@ sys_call_table32:
 /*100*/ .word sys32_getpriority, sys32_rt_sigreturn, sys32_rt_sigaction, sys32_rt_sigprocmask, sys32_rt_sigpending
 	.word compat_sys_rt_sigtimedwait, sys32_rt_sigqueueinfo, compat_sys_rt_sigsuspend, sys_setresuid, sys_getresuid
 /*110*/	.word sys_setresgid, sys_getresgid, sys_setregid, sys_nis_syscall, sys_nis_syscall
-	.word sys32_getgroups, sys32_gettimeofday, sys32_getrusage, sys_nis_syscall, sys_getcwd
-/*120*/	.word compat_sys_readv, compat_sys_writev, sys32_settimeofday, sys_fchown16, sys_fchmod
+	.word sys32_getgroups, compat_sys_gettimeofday, sys32_getrusage, sys_nis_syscall, sys_getcwd
+/*120*/	.word compat_sys_readv, compat_sys_writev, compat_sys_settimeofday, sys_fchown16, sys_fchmod
 	.word sys_nis_syscall, sys_setreuid16, sys_setregid16, sys_rename, sys_truncate
 /*130*/	.word sys_ftruncate, sys_flock, compat_sys_lstat64, sys_nis_syscall, sys_nis_syscall
 	.word sys_nis_syscall, sys32_mkdir, sys_rmdir, compat_sys_utimes, compat_sys_stat64
Index: linux-2.6/arch/s390/kernel/syscalls.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/syscalls.S	2008-09-01 09:31:48.000000000 -0300
+++ linux-2.6/arch/s390/kernel/syscalls.S	2008-09-01 09:32:42.000000000 -0300
@@ -86,8 +86,8 @@ SYSCALL(sys_sethostname,sys_sethostname,
 SYSCALL(sys_setrlimit,sys_setrlimit,compat_sys_setrlimit_wrapper)	/* 75 */
 SYSCALL(sys_old_getrlimit,sys_getrlimit,compat_sys_old_getrlimit_wrapper)
 SYSCALL(sys_getrusage,sys_getrusage,compat_sys_getrusage_wrapper)
-SYSCALL(sys_gettimeofday,sys_gettimeofday,sys32_gettimeofday_wrapper)
-SYSCALL(sys_settimeofday,sys_settimeofday,sys32_settimeofday_wrapper)
+SYSCALL(sys_gettimeofday,sys_gettimeofday,compat_sys_gettimeofday_wrapper)
+SYSCALL(sys_settimeofday,sys_settimeofday,compat_sys_settimeofday_wrapper)
 SYSCALL(sys_getgroups16,sys_ni_syscall,sys32_getgroups16_wrapper)	/* 80 old getgroups16 syscall */
 SYSCALL(sys_setgroups16,sys_ni_syscall,sys32_setgroups16_wrapper)	/* old setgroups16 syscall */
 NI_SYSCALL							/* old select syscall */
Index: linux-2.6/arch/s390/kernel/compat_wrapper.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/compat_wrapper.S	2008-09-01 09:31:48.000000000 -0300
+++ linux-2.6/arch/s390/kernel/compat_wrapper.S	2008-09-01 09:32:42.000000000 -0300
@@ -332,17 +332,17 @@ compat_sys_getrusage_wrapper:
 	llgtr	%r3,%r3			# struct rusage_emu31 *
 	jg	compat_sys_getrusage	# branch to system call
 
-	.globl	sys32_gettimeofday_wrapper
-sys32_gettimeofday_wrapper:
+	.globl	compat_sys_gettimeofday_wrapper
+compat_sys_gettimeofday_wrapper:
 	llgtr	%r2,%r2			# struct timeval_emu31 *
 	llgtr	%r3,%r3			# struct timezone *
-	jg	sys32_gettimeofday	# branch to system call
+	jg	compat_sys_gettimeofday	# branch to system call
 
-	.globl	sys32_settimeofday_wrapper
-sys32_settimeofday_wrapper:
+	.globl	compat_sys_settimeofday_wrapper
+compat_sys_settimeofday_wrapper:
 	llgtr	%r2,%r2			# struct timeval_emu31 *
 	llgtr	%r3,%r3			# struct timezone *
-	jg	sys32_settimeofday	# branch to system call
+	jg	compat_sys_settimeofday	# branch to system call
 
 	.globl	sys32_getgroups16_wrapper
 sys32_getgroups16_wrapper:
Index: linux-2.6/arch/ia64/ia32/ia32_entry.S
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/ia32_entry.S	2008-09-01 09:32:08.000000000 -0300
+++ linux-2.6/arch/ia64/ia32/ia32_entry.S	2008-09-01 09:32:42.000000000 -0300
@@ -251,8 +251,8 @@ ia32_syscall_table:
 	data8 compat_sys_setrlimit	  /* 75 */
 	data8 compat_sys_old_getrlimit
 	data8 compat_sys_getrusage
-	data8 sys32_gettimeofday
-	data8 sys32_settimeofday
+	data8 compat_sys_gettimeofday
+	data8 compat_sys_settimeofday
 	data8 sys32_getgroups16	  /* 80 */
 	data8 sys32_setgroups16
 	data8 sys32_old_select
Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2008-09-01 09:32:34.000000000 -0300
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2008-09-01 09:32:42.000000000 -0300
@@ -1098,68 +1098,12 @@ sys32_mremap (unsigned int addr, unsigne
 	return ret;
 }
 
-static inline long
-get_tv32 (struct timeval *o, struct compat_timeval __user *i)
-{
-	return (!access_ok(VERIFY_READ, i, sizeof(*i)) ||
-		(__get_user(o->tv_sec, &i->tv_sec) | __get_user(o->tv_usec, &i->tv_usec)));
-}
-
-static inline long
-put_tv32 (struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) | __put_user(i->tv_usec, &o->tv_usec)));
-}
-
 asmlinkage unsigned long
 sys32_alarm (unsigned int seconds)
 {
 	return alarm_setitimer(seconds);
 }
 
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-
-extern struct timezone sys_tz;
-
-asmlinkage long
-sys32_gettimeofday (struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-asmlinkage long
-sys32_settimeofday (struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timeval ktv;
-	struct timespec kts;
-	struct timezone ktz;
-
-	if (tv) {
-		if (get_tv32(&ktv, tv))
-			return -EFAULT;
-		kts.tv_sec = ktv.tv_sec;
-		kts.tv_nsec = ktv.tv_usec * 1000;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 struct sel_arg_struct {
 	unsigned int n;
 	unsigned int inp;
Index: linux-2.6/arch/parisc/kernel/sys_parisc32.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/sys_parisc32.c	2008-09-01 09:31:50.000000000 -0300
+++ linux-2.6/arch/parisc/kernel/sys_parisc32.c	2008-09-01 09:32:42.000000000 -0300
@@ -179,64 +179,6 @@ asmlinkage long sys32_sched_rr_get_inter
 	return ret;
 }
 
-static int
-put_compat_timeval(struct compat_timeval __user *u, struct timeval *t)
-{
-	struct compat_timeval t32;
-	t32.tv_sec = t->tv_sec;
-	t32.tv_usec = t->tv_usec;
-	return copy_to_user(u, &t32, sizeof t32);
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-asmlinkage int
-sys32_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-    extern void do_gettimeofday(struct timeval *tv);
-
-    if (tv) {
-	    struct timeval ktv;
-	    do_gettimeofday(&ktv);
-	    if (put_compat_timeval(tv, &ktv))
-		    return -EFAULT;
-    }
-    if (tz) {
-	    extern struct timezone sys_tz;
-	    if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-		    return -EFAULT;
-    }
-    return 0;
-}
-
-asmlinkage 
-int sys32_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 struct msgbuf32 {
     int mtype;
     char mtext[1];
Index: linux-2.6/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2008-09-01 09:29:15.000000000 -0300
+++ linux-2.6/arch/x86/ia32/ia32entry.S	2008-09-01 09:32:42.000000000 -0300
@@ -577,8 +577,8 @@ ia32_sys_call_table:
 	.quad compat_sys_setrlimit	/* 75 */
 	.quad compat_sys_old_getrlimit	/* old_getrlimit */
 	.quad compat_sys_getrusage
-	.quad sys32_gettimeofday
-	.quad sys32_settimeofday
+	.quad compat_sys_gettimeofday
+	.quad compat_sys_settimeofday
 	.quad sys_getgroups16	/* 80 */
 	.quad sys_setgroups16
 	.quad sys32_old_select
Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2008-09-01 09:31:49.000000000 -0300
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2008-09-01 09:32:42.000000000 -0300
@@ -367,75 +367,11 @@ asmlinkage long sys32_rt_sigprocmask(int
 	return 0;
 }
 
-static inline long get_tv32(struct timeval *o, struct compat_timeval __user *i)
-{
-	int err = -EFAULT;
-
-	if (access_ok(VERIFY_READ, i, sizeof(*i))) {
-		err = __get_user(o->tv_sec, &i->tv_sec);
-		err |= __get_user(o->tv_usec, &i->tv_usec);
-	}
-	return err;
-}
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	int err = -EFAULT;
-
-	if (access_ok(VERIFY_WRITE, o, sizeof(*o))) {
-		err = __put_user(i->tv_sec, &o->tv_sec);
-		err |= __put_user(i->tv_usec, &o->tv_usec);
-	}
-	return err;
-}
-
 asmlinkage long sys32_alarm(unsigned int seconds)
 {
 	return alarm_setitimer(seconds);
 }
 
-/*
- * Translations due to time_t size differences. Which affects all
- * sorts of things, like timeval and itimerval.
- */
-asmlinkage long sys32_gettimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-asmlinkage long sys32_settimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	struct timeval ktv;
-	struct timespec kts;
-	struct timezone ktz;
-
-	if (tv) {
-		if (get_tv32(&ktv, tv))
-			return -EFAULT;
-		kts.tv_sec = ktv.tv_sec;
-		kts.tv_nsec = ktv.tv_usec * NSEC_PER_USEC;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 struct sel_arg_struct {
 	unsigned int n;
 	unsigned int inp;
Index: linux-2.6/arch/mips/kernel/linux32.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/linux32.c	2008-09-01 09:31:49.000000000 -0300
+++ linux-2.6/arch/mips/kernel/linux32.c	2008-09-01 09:32:42.000000000 -0300
@@ -133,72 +133,6 @@ asmlinkage long sys32_ftruncate64(unsign
 	return sys_ftruncate(fd, merge_64(a2, a3));
 }
 
-static inline long
-get_tv32(struct timeval *o, struct compat_timeval __user *i)
-{
-	return (!access_ok(VERIFY_READ, i, sizeof(*i)) ||
-		(__get_user(o->tv_sec, &i->tv_sec) |
-		 __get_user(o->tv_usec, &i->tv_usec)));
-}
-
-static inline long
-put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) |
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
-extern struct timezone sys_tz;
-
-asmlinkage int
-sys32_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-		return 0;
-}
-
-asmlinkage int
-sys32_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 asmlinkage int sys32_llseek(unsigned int fd, unsigned int offset_high,
 			    unsigned int offset_low, loff_t __user * result,
 			    unsigned int origin)
Index: linux-2.6/arch/mips/kernel/scall64-n32.S
===================================================================
--- linux-2.6.orig/arch/mips/kernel/scall64-n32.S	2008-09-01 09:29:15.000000000 -0300
+++ linux-2.6/arch/mips/kernel/scall64-n32.S	2008-09-01 09:32:42.000000000 -0300
@@ -214,7 +214,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_fchown
 	PTR	sys_lchown
 	PTR	sys_umask
-	PTR	sys32_gettimeofday
+	PTR	compat_sys_gettimeofday
 	PTR	compat_sys_getrlimit		/* 6095 */
 	PTR	compat_sys_getrusage
 	PTR	compat_sys_sysinfo
@@ -279,7 +279,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_chroot
 	PTR	sys_sync
 	PTR	sys_acct
-	PTR	sys32_settimeofday
+	PTR	compat_sys_settimeofday
 	PTR	compat_sys_mount		/* 6160 */
 	PTR	sys_umount
 	PTR	sys_swapon
Index: linux-2.6/arch/mips/kernel/scall64-o32.S
===================================================================
--- linux-2.6.orig/arch/mips/kernel/scall64-o32.S	2008-09-01 09:29:15.000000000 -0300
+++ linux-2.6/arch/mips/kernel/scall64-o32.S	2008-09-01 09:32:42.000000000 -0300
@@ -283,8 +283,8 @@ sys_call_table:
 	PTR	compat_sys_setrlimit		/* 4075 */
 	PTR	compat_sys_getrlimit
 	PTR	compat_sys_getrusage
-	PTR	sys32_gettimeofday
-	PTR	sys32_settimeofday
+	PTR	compat_sys_gettimeofday
+	PTR	compat_sys_settimeofday
 	PTR	sys_getgroups			/* 4080 */
 	PTR	sys_setgroups
 	PTR	sys_ni_syscall			/* old_select */
Index: linux-2.6/arch/parisc/kernel/syscall_table.S
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/syscall_table.S	2008-09-01 09:29:15.000000000 -0300
+++ linux-2.6/arch/parisc/kernel/syscall_table.S	2008-09-01 09:32:42.000000000 -0300
@@ -149,8 +149,8 @@
 	ENTRY_COMP(getrlimit)
 	ENTRY_COMP(getrusage)
 	/* struct timeval and timezone are maybe?? consistent wide and narrow */
-	ENTRY_DIFF(gettimeofday)
-	ENTRY_DIFF(settimeofday)
+	ENTRY_COMP(gettimeofday)
+	ENTRY_COMP(settimeofday)
 	ENTRY_SAME(getgroups)		/* 80 */
 	ENTRY_SAME(setgroups)
 	/* struct socketaddr... */
Index: linux-2.6/include/linux/compat.h
===================================================================
--- linux-2.6.orig/include/linux/compat.h	2008-09-01 09:31:49.000000000 -0300
+++ linux-2.6/include/linux/compat.h	2008-09-01 09:32:42.000000000 -0300
@@ -234,6 +234,11 @@ extern int get_compat_itimerspec(struct 
 extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
 				 const struct itimerspec *src);
 
+asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz);
+asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz);
+
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
 extern int compat_printk(const char *fmt, ...);
