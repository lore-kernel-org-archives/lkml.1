Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0BAS6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:58:06 -0500
Received: from verein.lst.de ([213.95.11.210]:36264 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0BAS6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:58:02 -0500
Date: Mon, 1 Feb 2010 19:56:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org,
       takata@linux-m32r.org, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: [PATCH 6/6] generic sys_olduname
Message-ID: <20100201185640.GF11045@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic implementations of the old and really old uname system calls.
Note that sh only implements sys_olduname but not sys_oldolduname, but
I'm not going to bother with another ifdef for that special case.

m32r implemented an old uname but never wired it up, so kill it, too.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/mips/kernel/syscall.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/syscall.c	2010-01-29 23:35:26.551003998 +0100
+++ linux-2.6/arch/mips/kernel/syscall.c	2010-01-29 23:35:31.796277657 +0100
@@ -215,48 +215,6 @@ out:
 	return error;
 }
 
-/*
- * Compacrapability ...
- */
-SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
-{
-	if (name && !copy_to_user(name, utsname(), sizeof (*name)))
-		return 0;
-	return -EFAULT;
-}
-
-/*
- * Compacrapability ...
- */
-SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
-{
-	int error;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error -= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error -= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error -= __put_user(0, name->release + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error -= __put_user(0, name->version + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error = __put_user(0, name->machine + __OLD_UTS_LEN);
-	error = error ? -EFAULT : 0;
-
-	return error;
-}
-
 SYSCALL_DEFINE1(set_thread_area, unsigned long, addr)
 {
 	struct thread_info *ti = task_thread_info(current);
Index: linux-2.6/arch/powerpc/kernel/syscalls.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/syscalls.c	2010-01-29 23:35:30.661004396 +0100
+++ linux-2.6/arch/powerpc/kernel/syscalls.c	2010-01-29 23:35:31.796277657 +0100
@@ -101,63 +101,6 @@ ppc_select(int n, fd_set __user *inp, fd
 }
 #endif
 
-#ifdef CONFIG_PPC64
-#define OVERRIDE_MACHINE    (personality(current->personality) == PER_LINUX32)
-#else
-#define OVERRIDE_MACHINE    0
-#endif
-
-static inline int override_machine(char __user *mach)
-{
-	if (OVERRIDE_MACHINE) {
-		/* change ppc64 to ppc */
-		if (__put_user(0, mach+3) || __put_user(0, mach+4))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-int sys_uname(struct old_utsname __user *name)
-{
-	int err = 0;
-	
-	down_read(&uts_sem);
-	if (copy_to_user(name, utsname(), sizeof(*name)))
-		err = -EFAULT;
-	up_read(&uts_sem);
-	if (!err)
-		err = override_machine(name->machine);
-	return err;
-}
-
-int sys_olduname(struct oldold_utsname __user *name)
-{
-	int error;
-
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-  
-	down_read(&uts_sem);
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->release + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->version + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error |= override_machine(name->machine);
-	up_read(&uts_sem);
-
-	return error? -EFAULT: 0;
-}
-
 long ppc_fadvise64_64(int fd, int advice, u32 offset_high, u32 offset_low,
 		      u32 len_high, u32 len_low)
 {
Index: linux-2.6/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2010-01-29 23:35:20.184012102 +0100
+++ linux-2.6/arch/x86/ia32/ia32entry.S	2010-01-29 23:35:31.797278203 +0100
@@ -563,7 +563,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall			/* old mpx syscall holder */
 	.quad sys_setpgid
 	.quad quiet_ni_syscall			/* old ulimit syscall holder */
-	.quad sys32_olduname
+	.quad sys_olduname
 	.quad sys_umask		/* 60 */
 	.quad sys_chroot
 	.quad compat_sys_ustat
@@ -613,7 +613,7 @@ ia32_sys_call_table:
 	.quad compat_sys_newstat
 	.quad compat_sys_newlstat
 	.quad compat_sys_newfstat
-	.quad sys32_uname
+	.quad sys_uname
 	.quad stub32_iopl		/* 110 */
 	.quad sys_vhangup
 	.quad quiet_ni_syscall	/* old "idle" system call */
Index: linux-2.6/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/x86/ia32/sys_ia32.c	2010-01-29 23:35:29.066012533 +0100
+++ linux-2.6/arch/x86/ia32/sys_ia32.c	2010-01-29 23:35:31.799278947 +0100
@@ -434,58 +434,6 @@ asmlinkage long sys32_sendfile(int out_f
 	return ret;
 }
 
-asmlinkage long sys32_olduname(struct oldold_utsname __user *name)
-{
-	char *arch = "x86_64";
-	int err;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	down_read(&uts_sem);
-
-	err = __copy_to_user(&name->sysname, &utsname()->sysname,
-			     __OLD_UTS_LEN);
-	err |= __put_user(0, name->sysname+__OLD_UTS_LEN);
-	err |= __copy_to_user(&name->nodename, &utsname()->nodename,
-			      __OLD_UTS_LEN);
-	err |= __put_user(0, name->nodename+__OLD_UTS_LEN);
-	err |= __copy_to_user(&name->release, &utsname()->release,
-			      __OLD_UTS_LEN);
-	err |= __put_user(0, name->release+__OLD_UTS_LEN);
-	err |= __copy_to_user(&name->version, &utsname()->version,
-			      __OLD_UTS_LEN);
-	err |= __put_user(0, name->version+__OLD_UTS_LEN);
-
-	if (personality(current->personality) == PER_LINUX32)
-		arch = "i686";
-
-	err |= __copy_to_user(&name->machine, arch, strlen(arch) + 1);
-
-	up_read(&uts_sem);
-
-	err = err ? -EFAULT : 0;
-
-	return err;
-}
-
-long sys32_uname(struct old_utsname __user *name)
-{
-	int err;
-
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof(*name));
-	up_read(&uts_sem);
-	if (personality(current->personality) == PER_LINUX32)
-		err |= copy_to_user(&name->machine, "i686", 5);
-
-	return err ? -EFAULT : 0;
-}
-
 asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 			     compat_uptr_t __user *envp, struct pt_regs *regs)
 {
Index: linux-2.6/arch/x86/include/asm/sys_ia32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/sys_ia32.h	2010-01-29 23:35:29.067004419 +0100
+++ linux-2.6/arch/x86/include/asm/sys_ia32.h	2010-01-29 23:35:31.799278947 +0100
@@ -53,11 +53,6 @@ asmlinkage long sys32_pwrite(unsigned in
 
 asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
 
-struct oldold_utsname;
-struct old_utsname;
-asmlinkage long sys32_olduname(struct oldold_utsname __user *);
-long sys32_uname(struct old_utsname __user *);
-
 asmlinkage long sys32_execve(char __user *, compat_uptr_t __user *,
 			     compat_uptr_t __user *, struct pt_regs *);
 asmlinkage long sys32_clone(unsigned int, unsigned int, struct pt_regs *);
Index: linux-2.6/arch/x86/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/syscalls.h	2010-01-29 23:35:30.938006430 +0100
+++ linux-2.6/arch/x86/include/asm/syscalls.h	2010-01-29 23:35:31.801003957 +0100
@@ -50,13 +50,6 @@ asmlinkage int sys_sigaction(int, const 
 			     struct old_sigaction __user *);
 unsigned long sys_sigreturn(struct pt_regs *);
 
-/* kernel/sys_i386_32.c */
-struct oldold_utsname;
-struct old_utsname;
-
-asmlinkage int sys_uname(struct old_utsname __user *);
-asmlinkage int sys_olduname(struct oldold_utsname __user *);
-
 /* kernel/vm86_32.c */
 int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
 int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
Index: linux-2.6/arch/x86/kernel/sys_i386_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/sys_i386_32.c	2010-01-29 23:35:26.563011673 +0100
+++ linux-2.6/arch/x86/kernel/sys_i386_32.c	2010-01-29 23:35:31.801003957 +0100
@@ -25,55 +25,6 @@
 #include <asm/syscalls.h>
 
 /*
- * Old cruft
- */
-asmlinkage int sys_uname(struct old_utsname __user *name)
-{
-	int err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof(*name));
-	up_read(&uts_sem);
-	return err? -EFAULT:0;
-}
-
-asmlinkage int sys_olduname(struct oldold_utsname __user *name)
-{
-	int error;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	down_read(&uts_sem);
-
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->release + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->version + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
-
-	up_read(&uts_sem);
-
-	error = error ? -EFAULT : 0;
-
-	return error;
-}
-
-
-/*
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h	2010-01-29 23:35:26.580004409 +0100
+++ linux-2.6/include/linux/syscalls.h	2010-01-29 23:35:31.803024117 +0100
@@ -31,6 +31,8 @@ struct msqid_ds;
 struct new_utsname;
 struct nfsctl_arg;
 struct __old_kernel_stat;
+struct oldold_utsname;
+struct old_utsname;
 struct pollfd;
 struct rlimit;
 struct rusage;
@@ -655,6 +657,8 @@ asmlinkage long sys_gethostname(char __u
 asmlinkage long sys_sethostname(char __user *name, int len);
 asmlinkage long sys_setdomainname(char __user *name, int len);
 asmlinkage long sys_newuname(struct new_utsname __user *name);
+asmlinkage long sys_uname(struct old_utsname __user *);
+asmlinkage long sys_olduname(struct oldold_utsname __user *);
 
 asmlinkage long sys_getrlimit(unsigned int resource,
 				struct rlimit __user *rlim);
Index: linux-2.6/kernel/sys.c
===================================================================
--- linux-2.6.orig/kernel/sys.c	2010-01-29 23:35:30.658004573 +0100
+++ linux-2.6/kernel/sys.c	2010-01-29 23:35:31.804014745 +0100
@@ -1141,6 +1141,60 @@ SYSCALL_DEFINE1(newuname, struct new_uts
 	return errno;
 }
 
+#ifdef __ARCH_WANT_SYS_OLD_UNAME
+/*
+ * Old cruft
+ */
+SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
+{
+	int error = 0;
+
+	if (!name)
+		return -EFAULT;
+
+	down_read(&uts_sem);
+	if (copy_to_user(name, utsname(), sizeof(*name)))
+		error = -EFAULT;
+	up_read(&uts_sem);
+
+	if (!error && override_architecture(name))
+		error = -EFAULT;
+	return error;
+}
+
+SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
+{
+	int error;
+
+	if (!name)
+		return -EFAULT;
+	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
+		return -EFAULT;
+
+	down_read(&uts_sem);
+	error = __copy_to_user(&name->sysname, &utsname()->sysname,
+			       __OLD_UTS_LEN);
+	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->release, &utsname()->release,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->release + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->version, &utsname()->version,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->version + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->machine, &utsname()->machine,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
+	up_read(&uts_sem);
+
+	if (!error && override_architecture(name))
+		error = -EFAULT;
+	return error ? -EFAULT : 0;
+}
+#endif
+
 SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 {
 	int errno;
Index: linux-2.6/arch/m32r/kernel/sys_m32r.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/sys_m32r.c	2010-01-29 23:35:26.550023915 +0100
+++ linux-2.6/arch/m32r/kernel/sys_m32r.c	2010-01-29 23:35:31.805011311 +0100
@@ -76,17 +76,6 @@ asmlinkage int sys_tas(int __user *addr)
 	return oldval;
 }
 
-asmlinkage int sys_uname(struct old_utsname __user * name)
-{
-	int err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof (*name));
-	up_read(&uts_sem);
-	return err?-EFAULT:0;
-}
-
 asmlinkage int sys_cacheflush(void *addr, int bytes, int cache)
 {
 	/* This should flush more selectively ...  */
Index: linux-2.6/arch/sh/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/syscalls.h	2010-01-29 23:35:26.556004146 +0100
+++ linux-2.6/arch/sh/include/asm/syscalls.h	2010-01-29 23:35:31.805011311 +0100
@@ -3,15 +3,12 @@
 
 #ifdef __KERNEL__
 
-struct old_utsname;
-
 asmlinkage int old_mmap(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
 			int fd, unsigned long off);
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff);
-asmlinkage int sys_uname(struct old_utsname __user *name);
 
 #ifdef CONFIG_SUPERH32
 # include "syscalls_32.h"
Index: linux-2.6/arch/sh/kernel/sys_sh.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/sys_sh.c	2010-01-29 23:35:26.557003785 +0100
+++ linux-2.6/arch/sh/kernel/sys_sh.c	2010-01-29 23:35:31.806003616 +0100
@@ -93,14 +93,3 @@ asmlinkage int sys_cacheflush(unsigned l
 	up_read(&current->mm->mmap_sem);
 	return 0;
 }
-
-asmlinkage int sys_uname(struct old_utsname __user *name)
-{
-	int err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof(*name));
-	up_read(&uts_sem);
-	return err?-EFAULT:0;
-}
Index: linux-2.6/arch/um/kernel/syscall.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/syscall.c	2010-01-12 14:08:13.494003031 +0100
+++ linux-2.6/arch/um/kernel/syscall.c	2010-01-29 23:35:31.807010728 +0100
@@ -51,51 +51,6 @@ long old_mmap(unsigned long addr, unsign
 	return err;
 }
 
-long sys_uname(struct old_utsname __user * name)
-{
-	long err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof (*name));
-	up_read(&uts_sem);
-	return err?-EFAULT:0;
-}
-
-long sys_olduname(struct oldold_utsname __user * name)
-{
-	long error;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE,name,sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	down_read(&uts_sem);
-
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->release + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->version + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
-
-	up_read(&uts_sem);
-
-	error = error ? -EFAULT : 0;
-
-	return error;
-}
-
 int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 {
 	mm_segment_t fs;
Index: linux-2.6/arch/mips/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/unistd.h	2010-01-29 23:35:26.572011841 +0100
+++ linux-2.6/arch/mips/include/asm/unistd.h	2010-01-29 23:35:31.808004150 +0100
@@ -1014,6 +1014,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/powerpc/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/unistd.h	2010-01-29 23:35:26.574004483 +0100
+++ linux-2.6/arch/powerpc/include/asm/unistd.h	2010-01-29 23:35:31.809004347 +0100
@@ -377,6 +377,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/sh/include/asm/unistd_32.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/unistd_32.h	2010-01-29 23:35:26.575004401 +0100
+++ linux-2.6/arch/sh/include/asm/unistd_32.h	2010-01-29 23:35:31.809004347 +0100
@@ -371,6 +371,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/sh/include/asm/unistd_64.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/unistd_64.h	2010-01-29 23:35:26.576007602 +0100
+++ linux-2.6/arch/sh/include/asm/unistd_64.h	2010-01-29 23:35:31.810004545 +0100
@@ -411,6 +411,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
Index: linux-2.6/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/unistd_32.h	2010-01-29 23:35:26.579004142 +0100
+++ linux-2.6/arch/x86/include/asm/unistd_32.h	2010-01-29 23:35:31.811004113 +0100
@@ -367,6 +367,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
Index: linux-2.6/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/unistd_64.h	2010-01-29 23:35:30.940005707 +0100
+++ linux-2.6/arch/x86/include/asm/unistd_64.h	2010-01-29 23:35:31.811004113 +0100
@@ -680,6 +680,7 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
