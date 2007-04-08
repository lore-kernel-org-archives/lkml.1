Return-Path: <linux-kernel-owner+w=401wt.eu-S1750985AbXDHPyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbXDHPyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXDHPyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:54:00 -0400
Received: from mail.screens.ru ([213.234.233.54]:37374 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXDHPx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:53:59 -0400
Date: Sun, 8 Apr 2007 19:53:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Message-ID: <20070408155337.GA126@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For review only.

To implement for-in-kerenl-use-only CLONE_ flags, we need to filter out them
in sys_clone().

These below

	arch/sparc/
	arch/sparc64/
	arch/ia64/
	arch/v850/
	arch/xtensa/

are not changed, they use assembly to implement sys_clone().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h               |    3 +++
 arch/alpha/kernel/process.c         |    3 ++-
 arch/arm/kernel/sys_arm.c           |    3 ++-
 arch/arm26/kernel/sys_arm.c         |    2 +-
 arch/avr32/kernel/process.c         |    2 +-
 arch/blackfin/kernel/process.c      |    2 +-
 arch/cris/arch-v10/kernel/process.c |    3 ++-
 arch/cris/arch-v32/kernel/process.c |    3 ++-
 arch/frv/kernel/process.c           |    3 ++-
 arch/h8300/kernel/process.c         |    2 +-
 arch/i386/kernel/process.c          |    2 +-
 arch/m32r/kernel/process.c          |    2 +-
 arch/m68k/kernel/process.c          |    2 +-
 arch/m68knommu/kernel/process.c     |    2 +-
 arch/mips/kernel/linux32.c          |    2 +-
 arch/mips/kernel/syscall.c          |    2 +-
 arch/parisc/kernel/process.c        |    3 ++-
 arch/powerpc/kernel/process.c       |    3 ++-
 arch/s390/kernel/compat_linux.c     |    2 +-
 arch/s390/kernel/process.c          |    2 +-
 arch/sh/kernel/process.c            |    2 +-
 arch/sh64/kernel/process.c          |    2 +-
 arch/um/sys-i386/syscalls.c         |    4 ++--
 arch/um/sys-x86_64/syscalls.c       |    4 ++--
 arch/x86_64/ia32/sys_ia32.c         |    3 ++-
 arch/x86_64/kernel/process.c        |    3 ++-
 arch/xtensa/kernel/process.c        |    3 ++-
 27 files changed, 41 insertions(+), 28 deletions(-)

--- 2.6.21-rc5-mm4/include/linux/sched.h~1_MASK	2007-04-07 20:11:14.000000000 +0400
+++ 2.6.21-rc5-mm4/include/linux/sched.h	2007-04-07 22:07:50.000000000 +0400
@@ -27,6 +27,9 @@
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 
+/* user-space visible */
+#define SYS_CLONE_MASK		(~0x0)
+
 /*
  * Scheduling policies
  */
--- 2.6.21-rc5-mm4/arch/alpha/kernel/process.c~1_MASK	2007-04-07 20:11:11.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/alpha/kernel/process.c	2007-04-07 22:32:37.000000000 +0400
@@ -249,7 +249,8 @@ alpha_clone(unsigned long clone_flags, u
 	if (!usp)
 		usp = rdusp();
 
-	return do_fork(clone_flags, usp, regs, 0, parent_tid, child_tid);
+	return do_fork(clone_flags & SYS_CLONE_MASK, usp, regs, 0,
+			parent_tid, child_tid);
 }
 
 int
--- 2.6.21-rc5-mm4/arch/arm/kernel/sys_arm.c~1_MASK	2007-01-07 22:57:52.000000000 +0300
+++ 2.6.21-rc5-mm4/arch/arm/kernel/sys_arm.c	2007-04-07 22:10:02.000000000 +0400
@@ -252,7 +252,8 @@ asmlinkage int sys_clone(unsigned long c
 	if (!newsp)
 		newsp = regs->ARM_sp;
 
-	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0,
+			parent_tidptr, child_tidptr);
 }
 
 asmlinkage int sys_vfork(struct pt_regs *regs)
--- 2.6.21-rc5-mm4/arch/arm26/kernel/sys_arm.c~1_MASK	2006-10-22 18:23:57.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/arm26/kernel/sys_arm.c	2007-04-07 22:29:56.000000000 +0400
@@ -256,7 +256,7 @@ asmlinkage int sys_clone(unsigned long c
 	if (!newsp)
 		newsp = regs->ARM_sp;
 
-	return do_fork(clone_flags, newsp, regs, 0, NULL, NULL);
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0, NULL, NULL);
 }
 
 asmlinkage int sys_vfork(struct pt_regs *regs)
--- 2.6.21-rc5-mm4/arch/avr32/kernel/process.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/avr32/kernel/process.c	2007-04-07 22:33:33.000000000 +0400
@@ -359,7 +359,7 @@ asmlinkage int sys_clone(unsigned long c
 {
 	if (!newsp)
 		newsp = regs->sp;
-	return do_fork(clone_flags, newsp, regs, 0,
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0,
 		       (int __user *)parent_tidptr,
 		       (int __user *)child_tidptr);
 }
--- 2.6.21-rc5-mm4/arch/blackfin/kernel/process.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/blackfin/kernel/process.c	2007-04-07 22:51:34.000000000 +0400
@@ -239,7 +239,7 @@ asmlinkage int bfin_clone(struct pt_regs
 		newsp = rdusp();
 	else
 		newsp -= 12;
-	return do_fork(clone_flags, newsp, regs, 0, NULL, NULL);
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0, NULL, NULL);
 }
 
 int
--- 2.6.21-rc5-mm4/arch/cris/arch-v10/kernel/process.c~1_MASK	2006-07-29 05:05:33.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/cris/arch-v10/kernel/process.c	2007-04-07 22:25:20.000000000 +0400
@@ -189,7 +189,8 @@ asmlinkage int sys_clone(unsigned long n
 {
 	if (!newusp)
 		newusp = rdusp();
-	return do_fork(flags, newusp, regs, 0, parent_tid, child_tid);
+	return do_fork(flags & SYS_CLONE_MASK, newusp, regs, 0,
+			parent_tid, child_tid);
 }
 
 /* vfork is a system call in i386 because of register-pressure - maybe
--- 2.6.21-rc5-mm4/arch/cris/arch-v32/kernel/process.c~1_MASK	2006-07-29 05:05:33.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/cris/arch-v32/kernel/process.c	2007-04-07 22:26:06.000000000 +0400
@@ -206,7 +206,8 @@ sys_clone(unsigned long newusp, unsigned
 	if (!newusp)
 		newusp = rdusp();
 
-	return do_fork(flags, newusp, regs, 0, parent_tid, child_tid);
+	return do_fork(flags & SYS_CLONE_MASK, newusp, regs, 0,
+			parent_tid, child_tid);
 }
 
 /*
--- 2.6.21-rc5-mm4/arch/frv/kernel/process.c~1_MASK	2006-07-29 05:05:59.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/frv/kernel/process.c	2007-04-07 22:49:02.000000000 +0400
@@ -183,7 +183,8 @@ asmlinkage int sys_clone(unsigned long c
 {
 	if (!newsp)
 		newsp = user_stack(__frame);
-	return do_fork(clone_flags, newsp, __frame, 0, parent_tidptr, child_tidptr);
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, __frame, 0,
+			parent_tidptr, child_tidptr);
 } /* end sys_clone() */
 
 /*****************************************************************************/
--- 2.6.21-rc5-mm4/arch/h8300/kernel/process.c~1_MASK	2006-07-29 05:05:33.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/h8300/kernel/process.c	2007-04-07 22:36:35.000000000 +0400
@@ -187,7 +187,7 @@ asmlinkage int h8300_clone(struct pt_reg
 	newsp = regs->er2;
 	if (!newsp)
 		newsp  = rdusp();
-	return do_fork(clone_flags, newsp, regs, 0, NULL, NULL);
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0, NULL, NULL);
 
 }
 
--- 2.6.21-rc5-mm4/arch/i386/kernel/process.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/i386/kernel/process.c	2007-04-07 22:05:32.000000000 +0400
@@ -727,7 +727,7 @@ asmlinkage int sys_clone(struct pt_regs 
 	unsigned long newsp;
 	int __user *parent_tidptr, *child_tidptr;
 
-	clone_flags = regs.ebx;
+	clone_flags = regs.ebx & SYS_CLONE_MASK;
 	newsp = regs.ecx;
 	parent_tidptr = (int __user *)regs.edx;
 	child_tidptr = (int __user *)regs.edi;
--- 2.6.21-rc5-mm4/arch/m32r/kernel/process.c~1_MASK	2007-04-05 12:18:26.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/m32r/kernel/process.c	2007-04-07 22:48:08.000000000 +0400
@@ -289,7 +289,7 @@ asmlinkage int sys_clone(unsigned long c
 	if (!newsp)
 		newsp = regs.spu;
 
-	return do_fork(clone_flags, newsp, &regs, 0,
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, &regs, 0,
 		       (int __user *)parent_tidptr, (int __user *)child_tidptr);
 }
 
--- 2.6.21-rc5-mm4/arch/m68k/kernel/process.c~1_MASK	2006-10-22 18:24:17.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/m68k/kernel/process.c	2007-04-07 22:31:14.000000000 +0400
@@ -225,7 +225,7 @@ asmlinkage int m68k_clone(struct pt_regs
 	int __user *parent_tidptr, *child_tidptr;
 
 	/* syscall2 puts clone_flags in d1 and usp in d2 */
-	clone_flags = regs->d1;
+	clone_flags = regs->d1 & SYS_CLONE_MASK;
 	newsp = regs->d2;
 	parent_tidptr = (int __user *)regs->d3;
 	child_tidptr = (int __user *)regs->d4;
--- 2.6.21-rc5-mm4/arch/m68knommu/kernel/process.c~1_MASK	2006-12-17 19:06:39.000000000 +0300
+++ 2.6.21-rc5-mm4/arch/m68knommu/kernel/process.c	2007-04-07 22:15:46.000000000 +0400
@@ -192,7 +192,7 @@ asmlinkage int m68k_clone(struct pt_regs
 	unsigned long newsp;
 
 	/* syscall2 puts clone_flags in d1 and usp in d2 */
-	clone_flags = regs->d1;
+	clone_flags = regs->d1 & SYS_CLONE_MASK;
 	newsp = regs->d2;
 	if (!newsp)
 		newsp = rdusp();
--- 2.6.21-rc5-mm4/arch/mips/kernel/linux32.c~1_MASK	2007-04-05 12:18:26.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/mips/kernel/linux32.c	2007-04-07 22:11:23.000000000 +0400
@@ -564,7 +564,7 @@ _sys32_clone(nabi_no_regargs struct pt_r
 	unsigned long newsp;
 	int __user *parent_tidptr, *child_tidptr;
 
-	clone_flags = regs.regs[4];
+	clone_flags = regs.regs[4] & SYS_CLONE_MASK;
 	newsp = regs.regs[5];
 	if (!newsp)
 		newsp = regs.regs[29];
--- 2.6.21-rc5-mm4/arch/mips/kernel/syscall.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/mips/kernel/syscall.c	2007-04-07 22:12:57.000000000 +0400
@@ -181,7 +181,7 @@ _sys_clone(nabi_no_regargs struct pt_reg
 	unsigned long newsp;
 	int __user *parent_tidptr, *child_tidptr;
 
-	clone_flags = regs.regs[4];
+	clone_flags = regs.regs[4] & SYS_CLONE_MASK;
 	newsp = regs.regs[5];
 	if (!newsp)
 		newsp = regs.regs[29];
--- 2.6.21-rc5-mm4/arch/parisc/kernel/process.c~1_MASK	2007-04-05 12:18:26.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/parisc/kernel/process.c	2007-04-07 22:34:56.000000000 +0400
@@ -252,7 +252,8 @@ sys_clone(unsigned long clone_flags, uns
 	else
 	  child_tidptr = NULL;
 
-	return do_fork(clone_flags, usp, regs, 0, parent_tidptr, child_tidptr);
+	return do_fork(clone_flags & SYS_CLONE_MASK, usp, regs, 0,
+			parent_tidptr, child_tidptr);
 }
 
 int
--- 2.6.21-rc5-mm4/arch/powerpc/kernel/process.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/powerpc/kernel/process.c	2007-04-07 22:50:41.000000000 +0400
@@ -775,7 +775,8 @@ int sys_clone(unsigned long clone_flags,
 		child_tidp = TRUNC_PTR(child_tidp);
 	}
 #endif
- 	return do_fork(clone_flags, usp, regs, 0, parent_tidp, child_tidp);
+ 	return do_fork(clone_flags & SYS_CLONE_MASK, usp, regs, 0,
+ 			parent_tidp, child_tidp);
 }
 
 int sys_fork(unsigned long p1, unsigned long p2, unsigned long p3,
--- 2.6.21-rc5-mm4/arch/s390/kernel/compat_linux.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/s390/kernel/compat_linux.c	2007-04-07 22:47:20.000000000 +0400
@@ -927,7 +927,7 @@ asmlinkage long sys32_clone(void)
 	unsigned long newsp;
 	int __user *parent_tidptr, *child_tidptr;
 
-	clone_flags = regs->gprs[3] & 0xffffffffUL;
+	clone_flags = regs->gprs[3] & SYS_CLONE_MASK;
 	newsp = regs->orig_gpr2 & 0x7fffffffUL;
 	parent_tidptr = compat_ptr(regs->gprs[4]);
 	child_tidptr = compat_ptr(regs->gprs[5]);
--- 2.6.21-rc5-mm4/arch/s390/kernel/process.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/s390/kernel/process.c	2007-04-07 22:39:48.000000000 +0400
@@ -292,7 +292,7 @@ asmlinkage long sys_clone(void)
 	unsigned long newsp;
 	int __user *parent_tidptr, *child_tidptr;
 
-	clone_flags = regs->gprs[3];
+	clone_flags = regs->gprs[3] & SYS_CLONE_MASK;
 	newsp = regs->orig_gpr2;
 	parent_tidptr = (int __user *) regs->gprs[4];
 	child_tidptr = (int __user *) regs->gprs[5];
--- 2.6.21-rc5-mm4/arch/sh/kernel/process.c~1_MASK	2007-04-05 12:18:26.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/sh/kernel/process.c	2007-04-07 22:19:43.000000000 +0400
@@ -393,7 +393,7 @@ asmlinkage int sys_clone(unsigned long c
 	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
 	if (!newsp)
 		newsp = regs->regs[15];
-	return do_fork(clone_flags, newsp, regs, 0,
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0,
 			(int __user *)parent_tidptr,
 			(int __user *)child_tidptr);
 }
--- 2.6.21-rc5-mm4/arch/sh64/kernel/process.c~1_MASK	2006-10-22 18:23:58.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/sh64/kernel/process.c	2007-04-07 22:37:20.000000000 +0400
@@ -548,7 +548,7 @@ asmlinkage int sys_clone(unsigned long c
 {
 	if (!newsp)
 		newsp = pregs->regs[15];
-	return do_fork(clone_flags, newsp, pregs, 0, 0, 0);
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, pregs, 0, 0, 0);
 }
 
 /*
--- 2.6.21-rc5-mm4/arch/um/sys-i386/syscalls.c~1_MASK	2006-06-13 04:28:07.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/um/sys-i386/syscalls.c	2007-04-07 22:21:53.000000000 +0400
@@ -78,8 +78,8 @@ long sys_clone(unsigned long clone_flags
 		newsp = UPT_SP(&current->thread.regs.regs);
 
 	current->thread.forking = 1;
-	ret = do_fork(clone_flags, newsp, &current->thread.regs, 0, parent_tid,
-		      child_tid);
+	ret = do_fork(clone_flags & SYS_CLONE_MASK, newsp,
+			&current->thread.regs, 0, parent_tid, child_tid);
 	current->thread.forking = 0;
 	return ret;
 }
--- 2.6.21-rc5-mm4/arch/um/sys-x86_64/syscalls.c~1_MASK	2007-04-05 12:18:26.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/um/sys-x86_64/syscalls.c	2007-04-07 22:23:27.000000000 +0400
@@ -135,8 +135,8 @@ long sys_clone(unsigned long clone_flags
 	if (!newsp)
 		newsp = UPT_SP(&current->thread.regs.regs);
 	current->thread.forking = 1;
-	ret = do_fork(clone_flags, newsp, &current->thread.regs, 0, parent_tid,
-		      child_tid);
+	ret = do_fork(clone_flags & SYS_CLONE_MASK, newsp,
+			&current->thread.regs, 0, parent_tid, child_tid);
 	current->thread.forking = 0;
 	return ret;
 }
--- 2.6.21-rc5-mm4/arch/x86_64/ia32/sys_ia32.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/x86_64/ia32/sys_ia32.c	2007-04-07 22:38:50.000000000 +0400
@@ -811,7 +811,8 @@ asmlinkage long sys32_clone(unsigned int
 	void __user *child_tid = (void __user *)regs->rdi;
 	if (!newsp)
 		newsp = regs->rsp;
-        return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+        return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0,
+        		parent_tid, child_tid);
 }
 
 /*
--- 2.6.21-rc5-mm4/arch/x86_64/kernel/process.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/x86_64/kernel/process.c	2007-04-07 22:37:57.000000000 +0400
@@ -715,7 +715,8 @@ sys_clone(unsigned long clone_flags, uns
 {
 	if (!newsp)
 		newsp = regs->rsp;
-	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+	return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0,
+			parent_tid, child_tid);
 }
 
 /*
--- 2.6.21-rc5-mm4/arch/xtensa/kernel/process.c~1_MASK	2007-04-07 20:11:12.000000000 +0400
+++ 2.6.21-rc5-mm4/arch/xtensa/kernel/process.c	2007-04-07 22:50:02.000000000 +0400
@@ -430,7 +430,8 @@ long xtensa_clone(unsigned long clone_fl
 {
         if (!newsp)
                 newsp = regs->areg[1];
-        return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+        return do_fork(clone_flags & SYS_CLONE_MASK, newsp, regs, 0,
+        		parent_tid, child_tid);
 }
 
 /*

