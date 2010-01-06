Return-Path: <linux-kernel-owner+w=401wt.eu-S932432Ab0AFR0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0AFR0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411Ab0AFRYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:24:50 -0500
Received: from verein.lst.de ([213.95.11.210]:33852 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab0AFRYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:24:46 -0500
Date: Wed, 6 Jan 2010 18:21:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: linux@arm.linux.org.uk, starvik@axis.com, jesper.nilsson@axis.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: [PATCH 2/3] generic sys_old_mmap
Message-ID: <20100106172135.GB17163@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic implementation of the old mmap syscall, which expects it's
argument in a memory block and switch all architectures over to use it.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h	2010-01-04 15:08:23.390023359 +0100
+++ linux-2.6/include/linux/syscalls.h	2010-01-04 15:08:24.308004141 +0100
@@ -23,6 +23,7 @@ struct kexec_segment;
 struct linux_dirent;
 struct linux_dirent64;
 struct list_head;
+struct mmap_arg_struct;
 struct msgbuf;
 struct msghdr;
 struct mmsghdr;
@@ -838,4 +839,6 @@ asmlinkage long sys_perf_event_open(
 asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long pgoff);
+asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
+
 #endif
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2010-01-04 15:08:08.168003737 +0100
+++ linux-2.6/mm/mmap.c	2010-01-04 15:08:24.310004186 +0100
@@ -1083,6 +1083,30 @@ out:
 	return retval;
 }
 
+#ifdef __ARCH_WANT_SYS_OLD_MMAP
+struct mmap_arg_struct {
+	unsigned long addr;
+	unsigned long len;
+	unsigned long prot;
+	unsigned long flags;
+	unsigned long fd;
+	unsigned long offset;
+};
+
+SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
+{
+	struct mmap_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	if (a.offset & ~PAGE_MASK)
+		return -EINVAL;
+
+	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
+			      a.offset >> PAGE_SHIFT);
+}
+#endif /* __ARCH_WANT_SYS_OLD_MMAP */
+
 /*
  * Some shared mappigns will want the pages marked read-only
  * to track write events. If so, we'll downgrade vm_page_prot
Index: linux-2.6/arch/arm/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/unistd.h	2010-01-04 15:08:23.380013634 +0100
+++ linux-2.6/arch/arm/include/asm/unistd.h	2010-01-04 15:08:24.310004186 +0100
@@ -442,6 +442,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
Index: linux-2.6/arch/arm/kernel/calls.S
===================================================================
--- linux-2.6.orig/arch/arm/kernel/calls.S	2010-01-04 15:08:23.376004395 +0100
+++ linux-2.6/arch/arm/kernel/calls.S	2010-01-04 15:08:24.311005781 +0100
@@ -99,7 +99,7 @@
 		CALL(sys_swapon)
 		CALL(sys_reboot)
 		CALL(OBSOLETE(sys_old_readdir))	/* used by libc4 */
-/* 90 */	CALL(OBSOLETE(old_mmap))	/* used by libc4 */
+/* 90 */	CALL(OBSOLETE(sys_old_mmap))	/* used by libc4 */
 		CALL(sys_munmap)
 		CALL(sys_truncate)
 		CALL(sys_ftruncate)
Index: linux-2.6/arch/arm/kernel/sys_arm.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/sys_arm.c	2010-01-04 15:08:23.390023359 +0100
+++ linux-2.6/arch/arm/kernel/sys_arm.c	2010-01-04 15:08:24.312004022 +0100
@@ -28,32 +28,6 @@
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
-{
-	int error = -EFAULT;
-	struct mmap_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
Index: linux-2.6/arch/cris/arch-v10/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/entry.S	2010-01-04 15:08:08.212254275 +0100
+++ linux-2.6/arch/cris/arch-v10/kernel/entry.S	2010-01-04 15:08:24.313003172 +0100
@@ -692,7 +692,7 @@ sys_call_table:	
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
Index: linux-2.6/arch/cris/arch-v32/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/entry.S	2010-01-04 15:08:08.229253996 +0100
+++ linux-2.6/arch/cris/arch-v32/kernel/entry.S	2010-01-04 15:08:24.314003369 +0100
@@ -615,7 +615,7 @@ sys_call_table:
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
Index: linux-2.6/arch/cris/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/unistd.h	2010-01-04 15:08:08.240254071 +0100
+++ linux-2.6/arch/cris/include/asm/unistd.h	2010-01-04 15:08:24.314003369 +0100
@@ -364,6 +364,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/cris/kernel/sys_cris.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/sys_cris.c	2010-01-04 15:08:08.203010849 +0100
+++ linux-2.6/arch/cris/kernel/sys_cris.c	2010-01-04 15:08:24.315004056 +0100
@@ -26,24 +26,6 @@
 #include <asm/uaccess.h>
 #include <asm/segment.h>
 
-asmlinkage unsigned long old_mmap(unsigned long __user *args)
-{        
-	unsigned long buffer[6];
-	int err = -EFAULT;
-
-	if (copy_from_user(&buffer, args, sizeof(buffer)))
-		goto out;
-
-	err = -EINVAL;
-	if (buffer[5] & ~PAGE_MASK) /* verify that offset is on page boundary */
-		goto out;
-
-	err = sys_mmap_pgoff(buffer[0], buffer[1], buffer[2], buffer[3],
-                       buffer[4], buffer[5] >> PAGE_SHIFT);
-out:
-	return err;
-}
-
 asmlinkage long
 sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
           unsigned long flags, unsigned long fd, unsigned long pgoff)
Index: linux-2.6/arch/h8300/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/unistd.h	2010-01-04 15:08:23.381005101 +0100
+++ linux-2.6/arch/h8300/include/asm/unistd.h	2010-01-04 15:08:24.316003903 +0100
@@ -348,6 +348,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
Index: linux-2.6/arch/h8300/kernel/sys_h8300.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/sys_h8300.c	2010-01-04 15:08:23.391022997 +0100
+++ linux-2.6/arch/h8300/kernel/sys_h8300.c	2010-01-04 15:08:24.316003903 +0100
@@ -27,40 +27,6 @@
 #include <asm/unistd.h>
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
- * handle more than 4 system call parameters, so these system calls
- * used a memory block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct *arg)
-{
-	struct mmap_arg_struct a;
-	int error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
-			       a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
Index: linux-2.6/arch/h8300/kernel/syscalls.S
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/syscalls.S	2010-01-04 15:08:23.386003992 +0100
+++ linux-2.6/arch/h8300/kernel/syscalls.S	2010-01-04 15:08:24.317004380 +0100
@@ -104,7 +104,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_swapon)
 	.long SYMBOL_NAME(sys_reboot)
 	.long SYMBOL_NAME(sys_old_readdir)
-	.long SYMBOL_NAME(old_mmap)		/* 90 */
+	.long SYMBOL_NAME(sys_old_mmap)		/* 90 */
 	.long SYMBOL_NAME(sys_munmap)
 	.long SYMBOL_NAME(sys_truncate)
 	.long SYMBOL_NAME(sys_ftruncate)
Index: linux-2.6/arch/m68k/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/entry.S	2010-01-04 15:08:23.377003963 +0100
+++ linux-2.6/arch/m68k/kernel/entry.S	2010-01-04 15:08:24.319004216 +0100
@@ -518,7 +518,7 @@ sys_call_table:
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
Index: linux-2.6/arch/m68k/kernel/sys_m68k.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/sys_m68k.c	2010-01-04 15:08:23.392024452 +0100
+++ linux-2.6/arch/m68k/kernel/sys_m68k.c	2010-01-04 15:08:24.320003645 +0100
@@ -42,40 +42,6 @@ asmlinkage long sys_mmap2(unsigned long 
 }
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
- * handle more than 4 system call parameters, so these system calls
- * used a memory block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
-{
-	struct mmap_arg_struct a;
-	int error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
-			       a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
Index: linux-2.6/arch/m68knommu/kernel/sys_m68k.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/sys_m68k.c	2010-01-04 15:08:23.393254008 +0100
+++ linux-2.6/arch/m68knommu/kernel/sys_m68k.c	2010-01-04 15:08:24.320003645 +0100
@@ -28,40 +28,6 @@
 #include <asm/unistd.h>
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
- * handle more than 4 system call parameters, so these system calls
- * used a memory block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct *arg)
-{
-	struct mmap_arg_struct a;
-	int error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
-				a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
Index: linux-2.6/arch/m68knommu/kernel/syscalltable.S
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/syscalltable.S	2010-01-04 15:08:32.726003999 +0100
+++ linux-2.6/arch/m68knommu/kernel/syscalltable.S	2010-01-04 15:08:38.276293254 +0100
@@ -108,7 +108,7 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall	/* sys_swapon */
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
Index: linux-2.6/arch/m68k/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/unistd.h	2010-01-04 15:08:55.402254019 +0100
+++ linux-2.6/arch/m68k/include/asm/unistd.h	2010-01-04 15:09:03.373016429 +0100
@@ -359,6 +359,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
Index: linux-2.6/arch/s390/kernel/sys_s390.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/sys_s390.c	2010-01-04 15:10:02.959004479 +0100
+++ linux-2.6/arch/s390/kernel/sys_s390.c	2010-01-04 15:11:11.524319061 +0100
@@ -33,13 +33,12 @@
 #include "entry.h"
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux for S/390 isn't able to handle more than 5
- * system call parameters, so these system calls used a memory
- * block for parameter passing..
+ * Perform the mmap() system call. Linux for S/390 isn't able to handle more
+ * than 5 system call parameters, so this system call uses a memory block
+ * for parameter passing.
  */
 
-struct mmap_arg_struct {
+struct s390_mmap_arg_struct {
 	unsigned long addr;
 	unsigned long len;
 	unsigned long prot;
@@ -48,9 +47,9 @@ struct mmap_arg_struct {
 	unsigned long offset;
 };
 
-SYSCALL_DEFINE1(mmap2, struct mmap_arg_struct __user *, arg)
+SYSCALL_DEFINE1(mmap2, struct s390_mmap_arg_struct __user *, arg)
 {
-	struct mmap_arg_struct a;
+	struct s390_mmap_arg_struct a;
 	int error = -EFAULT;
 
 	if (copy_from_user(&a, arg, sizeof(a)))
@@ -60,23 +59,6 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE1(s390_old_mmap, struct mmap_arg_struct __user *, arg)
-{
-	struct mmap_arg_struct a;
-	long error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
Index: linux-2.6/arch/s390/kernel/syscalls.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/syscalls.S	2010-01-04 15:11:39.608253773 +0100
+++ linux-2.6/arch/s390/kernel/syscalls.S	2010-01-04 15:13:00.175267679 +0100
@@ -98,7 +98,7 @@ SYSCALL(sys_uselib,sys_uselib,sys32_usel
 SYSCALL(sys_swapon,sys_swapon,sys32_swapon_wrapper)
 SYSCALL(sys_reboot,sys_reboot,sys32_reboot_wrapper)
 SYSCALL(sys_ni_syscall,sys_ni_syscall,old32_readdir_wrapper)	/* old readdir syscall */
-SYSCALL(sys_s390_old_mmap,sys_s390_old_mmap,old32_mmap_wrapper)	/* 90 */
+SYSCALL(sys_old_mmap,sys_old_mmap,old32_mmap_wrapper)		/* 90 */
 SYSCALL(sys_munmap,sys_munmap,sys32_munmap_wrapper)
 SYSCALL(sys_truncate,sys_truncate,sys32_truncate_wrapper)
 SYSCALL(sys_ftruncate,sys_ftruncate,sys32_ftruncate_wrapper)
Index: linux-2.6/arch/s390/kernel/entry.h
===================================================================
--- linux-2.6.orig/arch/s390/kernel/entry.h	2010-01-04 15:13:11.433003827 +0100
+++ linux-2.6/arch/s390/kernel/entry.h	2010-01-04 15:13:30.795281710 +0100
@@ -25,12 +25,11 @@ void __init startup_init(void);
 void die(const char * str, struct pt_regs * regs, long err);
 
 struct new_utsname;
-struct mmap_arg_struct;
+struct s390_mmap_arg_struct;
 struct fadvise64_64_args;
 struct old_sigaction;
 
-long sys_mmap2(struct mmap_arg_struct __user  *arg);
-long sys_s390_old_mmap(struct mmap_arg_struct __user *arg);
+long sys_mmap2(struct s390_mmap_arg_struct __user  *arg);
 long sys_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
 long sys_s390_newuname(struct new_utsname __user *name);
Index: linux-2.6/arch/s390/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/unistd.h	2010-01-04 15:13:47.155253884 +0100
+++ linux-2.6/arch/s390/include/asm/unistd.h	2010-01-04 15:14:01.463256055 +0100
@@ -390,6 +390,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/x86/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/syscalls.h	2010-01-04 15:15:09.319253881 +0100
+++ linux-2.6/arch/x86/include/asm/syscalls.h	2010-01-04 15:15:27.644034152 +0100
@@ -51,11 +51,9 @@ asmlinkage int sys_sigaction(int, const 
 unsigned long sys_sigreturn(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
-struct mmap_arg_struct;
 struct oldold_utsname;
 struct old_utsname;
 
-asmlinkage int old_mmap(struct mmap_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
 asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
Index: linux-2.6/arch/x86/kernel/sys_i386_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/sys_i386_32.c	2010-01-04 15:14:06.407003845 +0100
+++ linux-2.6/arch/x86/kernel/sys_i386_32.c	2010-01-04 15:14:18.886035858 +0100
@@ -25,40 +25,6 @@
 #include <asm/syscalls.h>
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/i386 didn't use to be able to handle more than
- * 4 system call parameters, so these system calls used a memory
- * block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
-{
-	struct mmap_arg_struct a;
-	int err = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	err = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	err = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags,
-			a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return err;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
Index: linux-2.6/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/syscall_table_32.S	2010-01-04 15:14:48.459004044 +0100
+++ linux-2.6/arch/x86/kernel/syscall_table_32.S	2010-01-04 15:14:53.777321070 +0100
@@ -89,7 +89,7 @@ ENTRY(sys_call_table)
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2010-01-04 15:16:23.866003845 +0100
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2010-01-04 15:16:37.709284260 +0100
@@ -883,7 +883,7 @@ ia32_do_mmap (struct file *file, unsigne
  * system calls used a memory block for parameter passing..
  */
 
-struct mmap_arg_struct {
+struct mmap_arg_struct32 {
 	unsigned int addr;
 	unsigned int len;
 	unsigned int prot;
@@ -893,9 +893,9 @@ struct mmap_arg_struct {
 };
 
 asmlinkage long
-sys32_mmap (struct mmap_arg_struct __user *arg)
+sys32_mmap (struct mmap_arg_struct32 __user *arg)
 {
-	struct mmap_arg_struct a;
+	struct mmap_arg_struct32 a;
 	struct file *file = NULL;
 	unsigned long addr;
 	int flags;
Index: linux-2.6/arch/um/sys-i386/shared/sysdep/syscalls.h
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/shared/sysdep/syscalls.h	2010-01-04 15:18:24.138004285 +0100
+++ linux-2.6/arch/um/sys-i386/shared/sysdep/syscalls.h	2010-01-04 15:18:31.187256375 +0100
@@ -13,8 +13,6 @@ typedef long syscall_handler_t(struct pt
  */
 extern syscall_handler_t sys_rt_sigaction;
 
-extern syscall_handler_t old_mmap_i386;
-
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
Index: linux-2.6/arch/um/sys-i386/sys_call_table.S
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/sys_call_table.S	2010-01-04 15:18:10.727004861 +0100
+++ linux-2.6/arch/um/sys-i386/sys_call_table.S	2010-01-04 15:18:18.684006265 +0100
@@ -7,7 +7,7 @@
 #define sys_vm86old sys_ni_syscall
 #define sys_vm86 sys_ni_syscall
 
-#define old_mmap old_mmap_i386
+#define old_mmap sys_old_mmap
 
 #define ptregs_fork sys_fork
 #define ptregs_execve sys_execve
Index: linux-2.6/arch/um/sys-i386/syscalls.c
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/syscalls.c	2010-01-04 15:17:45.088254030 +0100
+++ linux-2.6/arch/um/sys-i386/syscalls.c	2010-01-04 15:18:00.593032749 +0100
@@ -12,39 +12,6 @@
 #include "asm/unistd.h"
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/i386 didn't use to be able to handle more than
- * 4 system call parameters, so these system calls used a memory
- * block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-extern int old_mmap(unsigned long addr, unsigned long len,
-		    unsigned long prot, unsigned long flags,
-		    unsigned long fd, unsigned long offset);
-
-long old_mmap_i386(struct mmap_arg_struct __user *arg)
-{
-	struct mmap_arg_struct a;
-	int err = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	err = old_mmap(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
- out:
-	return err;
-}
-
-/*
  * The prototype on i386 is:
  *
  *     int clone(int flags, void * child_stack, int * parent_tidptr, struct user_desc * newtls, int * child_tidptr)
Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2010-01-04 15:17:12.066254323 +0100
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2010-01-04 15:17:27.264006359 +0100
@@ -143,7 +143,7 @@ asmlinkage long sys32_fstatat(unsigned i
  * block for parameter passing..
  */
 
-struct mmap_arg_struct {
+struct mmap_arg_struct32 {
 	unsigned int addr;
 	unsigned int len;
 	unsigned int prot;
@@ -152,9 +152,9 @@ struct mmap_arg_struct {
 	unsigned int offset;
 };
 
-asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
+asmlinkage long sys32_mmap(struct mmap_arg_struct32 __user *arg)
 {
-	struct mmap_arg_struct a;
+	struct mmap_arg_struct32 a;
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
Index: linux-2.6/arch/x86/include/asm/sys_ia32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/sys_ia32.h	2010-01-04 15:17:33.349253881 +0100
+++ linux-2.6/arch/x86/include/asm/sys_ia32.h	2010-01-04 15:17:38.000000000 +0100
@@ -26,8 +26,8 @@ asmlinkage long sys32_lstat64(char __use
 asmlinkage long sys32_fstat64(unsigned int, struct stat64 __user *);
 asmlinkage long sys32_fstatat(unsigned int, char __user *,
 			      struct stat64 __user *, int);
-struct mmap_arg_struct;
-asmlinkage long sys32_mmap(struct mmap_arg_struct __user *);
+struct mmap_arg_struct32;
+asmlinkage long sys32_mmap(struct mmap_arg_struct32 __user *);
 asmlinkage long sys32_mprotect(unsigned long, size_t, unsigned long);
 
 struct sigaction32;
Index: linux-2.6/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/unistd_32.h	2010-01-04 15:15:38.727254013 +0100
+++ linux-2.6/arch/x86/include/asm/unistd_32.h	2010-01-04 15:15:54.348009581 +0100
@@ -366,6 +366,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
