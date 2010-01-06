Return-Path: <linux-kernel-owner+w=401wt.eu-S932441Ab0AFRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0AFRYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406Ab0AFRYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:24:49 -0500
Received: from verein.lst.de ([213.95.11.210]:33851 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab0AFRYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:24:45 -0500
Date: Wed, 6 Jan 2010 18:21:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: linux@arm.linux.org.uk, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: [PATCH 1/3] generic sys_old_select
Message-ID: <20100106172112.GA17163@lst.de>
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
--- linux-2.6.orig/arch/arm/kernel/calls.S	2009-12-25 17:00:28.468254363 +0100
+++ linux-2.6/arch/arm/kernel/calls.S	2009-12-26 13:39:31.491254119 +0100
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
--- linux-2.6.orig/arch/m68k/kernel/entry.S	2009-12-25 17:00:29.324254148 +0100
+++ linux-2.6/arch/m68k/kernel/entry.S	2009-12-26 13:39:31.492254107 +0100
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
--- linux-2.6.orig/arch/m68knommu/kernel/syscalltable.S	2009-12-25 17:00:29.328253959 +0100
+++ linux-2.6/arch/m68knommu/kernel/syscalltable.S	2009-12-26 13:39:31.493254024 +0100
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
--- linux-2.6.orig/arch/x86/kernel/syscall_table_32.S	2009-12-25 17:00:29.783009834 +0100
+++ linux-2.6/arch/x86/kernel/syscall_table_32.S	2009-12-26 13:39:31.493254024 +0100
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
--- linux-2.6.orig/arch/x86/include/asm/sys_ia32.h	2009-12-25 17:00:29.734004014 +0100
+++ linux-2.6/arch/x86/include/asm/sys_ia32.h	2009-12-26 13:46:13.581006872 +0100
@@ -40,8 +40,6 @@ asmlinkage long sys32_rt_sigprocmask(int
 				     compat_sigset_t __user *, unsigned int);
 asmlinkage long sys32_alarm(unsigned int);
 
-struct sel_arg_struct;
-asmlinkage long sys32_old_select(struct sel_arg_struct __user *);
 asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
 asmlinkage long sys32_sysfs(int, u32, u32);
 
Index: linux-2.6/arch/arm/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/unistd.h	2009-12-17 09:39:54.260254298 +0100
+++ linux-2.6/arch/arm/include/asm/unistd.h	2009-12-26 13:39:31.495283123 +0100
@@ -442,6 +442,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_OLD_SELECT
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
Index: linux-2.6/arch/h8300/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/unistd.h	2009-12-17 09:39:54.357004264 +0100
+++ linux-2.6/arch/h8300/include/asm/unistd.h	2009-12-26 13:39:31.496253988 +0100
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
--- linux-2.6.orig/arch/m68k/include/asm/unistd.h	2009-12-17 09:39:54.388004163 +0100
+++ linux-2.6/arch/m68k/include/asm/unistd.h	2009-12-26 13:39:31.497282820 +0100
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
--- linux-2.6.orig/arch/x86/include/asm/unistd_32.h	2009-12-25 17:00:29.739004651 +0100
+++ linux-2.6/arch/x86/include/asm/unistd_32.h	2009-12-26 13:39:31.497282820 +0100
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
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2009-12-25 17:00:29.262254285 +0100
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2009-12-26 13:45:12.878256099 +0100
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
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2009-12-25 17:00:29.708004335 +0100
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2009-12-26 13:47:20.352006284 +0100
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
--- linux-2.6.orig/fs/select.c	2009-12-17 09:39:54.792277244 +0100
+++ linux-2.6/fs/select.c	2009-12-26 13:39:31.501255812 +0100
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
--- linux-2.6.orig/arch/h8300/kernel/syscalls.S	2009-12-25 17:00:29.259271992 +0100
+++ linux-2.6/arch/h8300/kernel/syscalls.S	2009-12-26 13:39:31.502254054 +0100
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
--- linux-2.6.orig/arch/mn10300/include/asm/unistd.h	2009-12-17 09:39:54.561277984 +0100
+++ linux-2.6/arch/mn10300/include/asm/unistd.h	2009-12-26 13:39:31.502254054 +0100
@@ -374,6 +374,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/mn10300/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/entry.S	2009-12-25 17:00:29.438254697 +0100
+++ linux-2.6/arch/mn10300/kernel/entry.S	2009-12-26 13:39:31.503254041 +0100
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
--- linux-2.6.orig/include/linux/syscalls.h	2009-12-25 17:00:33.004004130 +0100
+++ linux-2.6/include/linux/syscalls.h	2009-12-26 13:39:31.506293604 +0100
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
--- linux-2.6.orig/arch/arm/kernel/sys_arm.c	2009-12-26 13:39:50.209003837 +0100
+++ linux-2.6/arch/arm/kernel/sys_arm.c	2009-12-26 13:39:59.390005806 +0100
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
--- linux-2.6.orig/arch/h8300/kernel/sys_h8300.c	2009-12-26 13:40:06.430253758 +0100
+++ linux-2.6/arch/h8300/kernel/sys_h8300.c	2009-12-26 13:40:19.805078463 +0100
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
--- linux-2.6.orig/arch/m68k/kernel/sys_m68k.c	2009-12-26 13:40:27.049004874 +0100
+++ linux-2.6/arch/m68k/kernel/sys_m68k.c	2009-12-26 13:40:32.428259085 +0100
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
--- linux-2.6.orig/arch/ia64/ia32/ia32_entry.S	2009-12-26 13:45:21.329253965 +0100
+++ linux-2.6/arch/ia64/ia32/ia32_entry.S	2009-12-26 13:45:28.092033001 +0100
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
--- linux-2.6.orig/arch/m68knommu/kernel/sys_m68k.c	2009-12-26 13:41:05.507003655 +0100
+++ linux-2.6/arch/m68knommu/kernel/sys_m68k.c	2009-12-26 13:41:12.721029811 +0100
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
--- linux-2.6.orig/arch/mn10300/kernel/sys_mn10300.c	2009-12-26 13:41:47.351003868 +0100
+++ linux-2.6/arch/mn10300/kernel/sys_mn10300.c	2009-12-26 13:41:56.338012043 +0100
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
--- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2009-12-26 13:45:34.374003951 +0100
+++ linux-2.6/arch/x86/ia32/ia32entry.S	2009-12-26 13:45:42.635256475 +0100
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
--- linux-2.6.orig/arch/x86/include/asm/syscalls.h	2009-12-26 13:42:07.250004054 +0100
+++ linux-2.6/arch/x86/include/asm/syscalls.h	2009-12-26 13:48:05.167279593 +0100
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
--- linux-2.6.orig/arch/x86/kernel/sys_i386_32.c	2009-12-26 13:41:21.416004266 +0100
+++ linux-2.6/arch/x86/kernel/sys_i386_32.c	2009-12-26 13:41:26.310010208 +0100
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
--- linux-2.6.orig/fs/compat.c	2009-12-26 13:43:52.431003939 +0100
+++ linux-2.6/fs/compat.c	2009-12-26 13:49:24.179256485 +0100
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
--- linux-2.6.orig/arch/s390/kernel/entry.h	2009-12-26 13:47:33.348003992 +0100
+++ linux-2.6/arch/s390/kernel/entry.h	2009-12-26 13:47:36.435281114 +0100
@@ -28,7 +28,6 @@ struct new_utsname;
 struct mmap_arg_struct;
 struct fadvise64_64_args;
 struct old_sigaction;
-struct sel_arg_struct;
 
 long sys_mmap2(struct mmap_arg_struct __user  *arg);
 long sys_s390_old_mmap(struct mmap_arg_struct __user *arg);
Index: linux-2.6/arch/um/sys-i386/syscalls.c
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/syscalls.c	2009-12-26 13:47:41.973253601 +0100
+++ linux-2.6/arch/um/sys-i386/syscalls.c	2009-12-26 13:47:50.359267238 +0100
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
--- linux-2.6.orig/include/linux/compat.h	2009-12-26 13:48:19.749003759 +0100
+++ linux-2.6/include/linux/compat.h	2009-12-26 13:49:03.089019792 +0100
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
