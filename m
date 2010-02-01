Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0BAS5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:57:19 -0500
Received: from verein.lst.de ([213.95.11.210]:36245 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0BAS5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:57:16 -0500
Date: Mon, 1 Feb 2010 19:55:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: linux@arm.linux.org.uk, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: [PATCH 1/6] generic sys_old_select
Message-ID: <20100201185506.GA11045@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic implementation of the old select syscall, which expects it's
argument in a memory block and switch all architectures over to use it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/arm/kernel/calls.S
===================================================================
--- linux-2.6.orig/arch/arm/kernel/calls.S	2010-01-12 14:08:15.988003897 +0100
+++ linux-2.6/arch/arm/kernel/calls.S	2010-01-29 23:35:20.167003790 +0100
@@ -91,7 +91,7 @@
 		CALL(sys_settimeofday)
 /* 80 */	CALL(sys_getgroups16)
 		CALL(sys_setgroups16)
-		CALL(OBSOLETE(old_select))	/* used by libc4 */
+		CALL(OBSOLETE(sys_old_select))	/* used by libc4 */
 		CALL(sys_symlink)
 		CALL(sys_ni_syscall)		/* was sys_lstat */
 /* 85 */	CALL(sys_readlink)
Index: linux-2.6/arch/m68k/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/entry.S	2010-01-12 14:08:16.008003720 +0100
+++ linux-2.6/arch/m68k/kernel/entry.S	2010-01-29 23:35:20.167003790 +0100
@@ -510,7 +510,7 @@ sys_call_table:
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
Index: linux-2.6/arch/m68knommu/kernel/syscalltable.S
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/syscalltable.S	2010-01-12 14:08:16.037010906 +0100
+++ linux-2.6/arch/m68knommu/kernel/syscalltable.S	2010-01-29 23:35:20.168003778 +0100
@@ -100,7 +100,7 @@ ENTRY(sys_call_table)
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
Index: linux-2.6/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/syscall_table_32.S	2010-01-12 14:08:16.058006317 +0100
+++ linux-2.6/arch/x86/kernel/syscall_table_32.S	2010-01-29 23:35:20.169024159 +0100
@@ -81,7 +81,7 @@ ENTRY(sys_call_table)
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
Index: linux-2.6/arch/x86/include/asm/sys_ia32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/sys_ia32.h	2010-01-12 14:08:16.077254299 +0100
+++ linux-2.6/arch/x86/include/asm/sys_ia32.h	2010-01-29 23:35:20.170003753 +0100
@@ -40,8 +40,6 @@ asmlinkage long sys32_rt_sigprocmask(int
 				     compat_sigset_t __user *, unsigned int);
 asmlinkage long sys32_alarm(unsigned int);
 
-struct sel_arg_struct;
-asmlinkage long sys32_old_select(struct sel_arg_struct __user *);
 asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
 asmlinkage long sys32_sysfs(int, u32, u32);
 
Index: linux-2.6/arch/arm/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/unistd.h	2010-01-19 20:00:31.717004132 +0100
+++ linux-2.6/arch/arm/include/asm/unistd.h	2010-01-29 23:35:20.171004090 +0100
@@ -443,6 +443,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_OLD_SELECT
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
Index: linux-2.6/arch/h8300/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/unistd.h	2010-01-12 14:08:16.123027306 +0100
+++ linux-2.6/arch/h8300/include/asm/unistd.h	2010-01-29 23:35:20.172010434 +0100
@@ -348,6 +348,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/m68k/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/unistd.h	2010-01-12 14:08:16.027006350 +0100
+++ linux-2.6/arch/m68k/include/asm/unistd.h	2010-01-29 23:35:20.173024739 +0100
@@ -359,6 +359,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/unistd_32.h	2010-01-12 14:08:16.087262626 +0100
+++ linux-2.6/arch/x86/include/asm/unistd_32.h	2010-01-29 23:35:20.173024739 +0100
@@ -366,6 +366,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2010-01-12 14:08:16.140253941 +0100
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2010-01-29 23:35:20.175003692 +0100
@@ -1107,25 +1107,6 @@ sys32_alarm (unsigned int seconds)
 	return alarm_setitimer(seconds);
 }
 
-struct sel_arg_struct {
-	unsigned int n;
-	unsigned int inp;
-	unsigned int outp;
-	unsigned int exp;
-	unsigned int tvp;
-};
-
-asmlinkage long
-sys32_old_select (struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	return compat_sys_select(a.n, compat_ptr(a.inp), compat_ptr(a.outp),
-				 compat_ptr(a.exp), compat_ptr(a.tvp));
-}
-
 #define SEMOP		 1
 #define SEMGET		 2
 #define SEMCTL		 3
Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2010-01-12 14:08:16.103003946 +0100
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2010-01-29 23:35:20.175003692 +0100
@@ -332,24 +332,6 @@ asmlinkage long sys32_alarm(unsigned int
 	return alarm_setitimer(seconds);
 }
 
-struct sel_arg_struct {
-	unsigned int n;
-	unsigned int inp;
-	unsigned int outp;
-	unsigned int exp;
-	unsigned int tvp;
-};
-
-asmlinkage long sys32_old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	return compat_sys_select(a.n, compat_ptr(a.inp), compat_ptr(a.outp),
-				 compat_ptr(a.exp), compat_ptr(a.tvp));
-}
-
 asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
 			      int options)
 {
Index: linux-2.6/fs/select.c
===================================================================
--- linux-2.6.orig/fs/select.c	2010-01-12 14:08:16.194003803 +0100
+++ linux-2.6/fs/select.c	2010-01-29 23:35:20.176004099 +0100
@@ -691,6 +691,23 @@ SYSCALL_DEFINE6(pselect6, int, n, fd_set
 }
 #endif /* HAVE_SET_RESTORE_SIGMASK */
 
+#ifdef __ARCH_WANT_SYS_OLD_SELECT
+struct sel_arg_struct {
+	unsigned long n;
+	fd_set __user *inp, *outp, *exp;
+	struct timeval __user *tvp;
+};
+
+SYSCALL_DEFINE1(old_select, struct sel_arg_struct __user *, arg)
+{
+	struct sel_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
+}
+#endif
+
 struct poll_list {
 	struct poll_list *next;
 	int len;
Index: linux-2.6/arch/h8300/kernel/syscalls.S
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/syscalls.S	2010-01-12 14:08:16.128253391 +0100
+++ linux-2.6/arch/h8300/kernel/syscalls.S	2010-01-29 23:35:20.177003178 +0100
@@ -96,7 +96,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_settimeofday)
 	.long SYMBOL_NAME(sys_getgroups16)	/* 80 */
 	.long SYMBOL_NAME(sys_setgroups16)
-	.long SYMBOL_NAME(old_select)
+	.long SYMBOL_NAME(sys_old_select)
 	.long SYMBOL_NAME(sys_symlink)
 	.long SYMBOL_NAME(sys_lstat)
 	.long SYMBOL_NAME(sys_readlink)		/* 85 */
Index: linux-2.6/arch/mn10300/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/unistd.h	2010-01-19 20:00:31.762003647 +0100
+++ linux-2.6/arch/mn10300/include/asm/unistd.h	2010-01-29 23:35:20.178004074 +0100
@@ -375,6 +375,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/mn10300/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/entry.S	2010-01-19 20:00:31.763003634 +0100
+++ linux-2.6/arch/mn10300/kernel/entry.S	2010-01-29 23:35:20.179003992 +0100
@@ -468,7 +468,7 @@ ENTRY(sys_call_table)
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h	2010-01-19 20:00:32.320004402 +0100
+++ linux-2.6/include/linux/syscalls.h	2010-01-29 23:35:20.179003992 +0100
@@ -34,6 +34,7 @@ struct pollfd;
 struct rlimit;
 struct rusage;
 struct sched_param;
+struct sel_arg_struct;
 struct semaphore;
 struct sembuf;
 struct shmid_ds;
@@ -638,6 +639,7 @@ asmlinkage long sys_poll(struct pollfd _
 				long timeout);
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
+asmlinkage long sys_old_select(struct sel_arg_struct __user * arg);
 asmlinkage long sys_epoll_create(int size);
 asmlinkage long sys_epoll_create1(int flags);
 asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
Index: linux-2.6/arch/arm/kernel/sys_arm.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/sys_arm.c	2010-01-12 14:08:15.995003182 +0100
+++ linux-2.6/arch/arm/kernel/sys_arm.c	2010-01-29 23:35:20.181024291 +0100
@@ -54,27 +54,6 @@ out:
 	return error;
 }
 
-/*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls.
- */
-
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp, *outp, *exp;
-	struct timeval __user *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
Index: linux-2.6/arch/h8300/kernel/sys_h8300.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/sys_h8300.c	2010-01-12 14:08:16.134253247 +0100
+++ linux-2.6/arch/h8300/kernel/sys_h8300.c	2010-01-29 23:35:20.182003257 +0100
@@ -60,22 +60,6 @@ out:
 	return error;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set *inp, *outp, *exp;
-	struct timeval *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
Index: linux-2.6/arch/m68k/kernel/sys_m68k.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/sys_m68k.c	2010-01-12 14:08:16.016023317 +0100
+++ linux-2.6/arch/m68k/kernel/sys_m68k.c	2010-01-29 23:35:20.182003257 +0100
@@ -75,22 +75,6 @@ out:
 	return error;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp, *outp, *exp;
-	struct timeval __user *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
Index: linux-2.6/arch/ia64/ia32/ia32_entry.S
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/ia32_entry.S	2010-01-12 14:08:16.149022167 +0100
+++ linux-2.6/arch/ia64/ia32/ia32_entry.S	2010-01-29 23:35:20.183011625 +0100
@@ -260,7 +260,7 @@ ia32_syscall_table:
 	data8 compat_sys_settimeofday
 	data8 sys32_getgroups16	  /* 80 */
 	data8 sys32_setgroups16
-	data8 sys32_old_select
+	data8 compat_sys_old_select
 	data8 sys_symlink
 	data8 sys_ni_syscall
 	data8 sys_readlink	  /* 85 */
Index: linux-2.6/arch/m68knommu/kernel/sys_m68k.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/sys_m68k.c	2010-01-12 14:08:16.048262408 +0100
+++ linux-2.6/arch/m68knommu/kernel/sys_m68k.c	2010-01-29 23:35:20.183011625 +0100
@@ -61,22 +61,6 @@ out:
 	return error;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set *inp, *outp, *exp;
-	struct timeval *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
Index: linux-2.6/arch/mn10300/kernel/sys_mn10300.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/sys_mn10300.c	2010-01-12 14:08:16.171254258 +0100
+++ linux-2.6/arch/mn10300/kernel/sys_mn10300.c	2010-01-29 23:35:20.184012102 +0100
@@ -32,24 +32,6 @@ asmlinkage long old_mmap(unsigned long a
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set *inp;
-	fd_set *outp;
-	fd_set *exp;
-	struct timeval *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
Index: linux-2.6/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2010-01-12 14:08:16.113004172 +0100
+++ linux-2.6/arch/x86/ia32/ia32entry.S	2010-01-29 23:35:20.184012102 +0100
@@ -586,7 +586,7 @@ ia32_sys_call_table:
 	.quad compat_sys_settimeofday
 	.quad sys_getgroups16	/* 80 */
 	.quad sys_setgroups16
-	.quad sys32_old_select
+	.quad compat_sys_old_select
 	.quad sys_symlink
 	.quad sys_lstat
 	.quad sys_readlink		/* 85 */
Index: linux-2.6/arch/x86/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/syscalls.h	2010-01-12 14:08:16.096004242 +0100
+++ linux-2.6/arch/x86/include/asm/syscalls.h	2010-01-29 23:35:20.185004057 +0100
@@ -52,12 +52,10 @@ unsigned long sys_sigreturn(struct pt_re
 
 /* kernel/sys_i386_32.c */
 struct mmap_arg_struct;
-struct sel_arg_struct;
 struct oldold_utsname;
 struct old_utsname;
 
 asmlinkage int old_mmap(struct mmap_arg_struct __user *);
-asmlinkage int old_select(struct sel_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
 asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
Index: linux-2.6/arch/x86/kernel/sys_i386_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/sys_i386_32.c	2010-01-12 14:08:16.068010594 +0100
+++ linux-2.6/arch/x86/kernel/sys_i386_32.c	2010-01-29 23:35:20.186004046 +0100
@@ -58,23 +58,6 @@ out:
 	return err;
 }
 
-
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp, *outp, *exp;
-	struct timeval __user *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
Index: linux-2.6/fs/compat.c
===================================================================
--- linux-2.6.orig/fs/compat.c	2010-01-12 14:08:16.202003005 +0100
+++ linux-2.6/fs/compat.c	2010-01-29 23:35:20.187003404 +0100
@@ -1795,6 +1795,24 @@ asmlinkage long compat_sys_select(int n,
 	return ret;
 }
 
+struct compat_sel_arg_struct {
+	compat_ulong_t n;
+	compat_ulong_t inp;
+	compat_ulong_t outp;
+	compat_ulong_t exp;
+	compat_ulong_t tvp;
+};
+
+asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg)
+{
+	struct compat_sel_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	return compat_sys_select(a.n, compat_ptr(a.inp), compat_ptr(a.outp),
+				 compat_ptr(a.exp), compat_ptr(a.tvp));
+}
+
 #ifdef HAVE_SET_RESTORE_SIGMASK
 static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
Index: linux-2.6/arch/s390/kernel/entry.h
===================================================================
--- linux-2.6.orig/arch/s390/kernel/entry.h	2010-01-12 14:08:16.179253810 +0100
+++ linux-2.6/arch/s390/kernel/entry.h	2010-01-29 23:35:20.187003404 +0100
@@ -28,7 +28,6 @@ struct new_utsname;
 struct mmap_arg_struct;
 struct fadvise64_64_args;
 struct old_sigaction;
-struct sel_arg_struct;
 
 long sys_mmap2(struct mmap_arg_struct __user  *arg);
 long sys_s390_old_mmap(struct mmap_arg_struct __user *arg);
Index: linux-2.6/arch/um/sys-i386/syscalls.c
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/syscalls.c	2010-01-12 14:08:16.188003178 +0100
+++ linux-2.6/arch/um/sys-i386/syscalls.c	2010-01-29 23:35:20.188011634 +0100
@@ -44,24 +44,6 @@ long old_mmap_i386(struct mmap_arg_struc
 	return err;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp;
-	fd_set __user *outp;
-	fd_set __user *exp;
-	struct timeval __user *tvp;
-};
-
-long old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * The prototype on i386 is:
  *
Index: linux-2.6/include/linux/compat.h
===================================================================
--- linux-2.6.orig/include/linux/compat.h	2010-01-12 14:08:16.214260642 +0100
+++ linux-2.6/include/linux/compat.h	2010-01-29 23:35:20.189025938 +0100
@@ -23,6 +23,7 @@
 typedef __compat_uid32_t	compat_uid_t;
 typedef __compat_gid32_t	compat_gid_t;
 
+struct compat_sel_arg_struct;
 struct rusage;
 
 struct compat_itimerspec { 
@@ -249,6 +250,8 @@ asmlinkage long compat_sys_select(int n,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 		struct compat_timeval __user *tvp);
 
+asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg);
+
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
 				 compat_uint_t __user *stat_addr, int options,
 				 struct compat_rusage __user *ru);
