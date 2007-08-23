Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbXHWVjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbXHWVjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765421AbXHWVi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:38:26 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55543 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763426AbXHWViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:38:22 -0400
Date: Thu, 23 Aug 2007 17:38:07 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/7] UML - ptrace floating point fixes
Message-ID: <20070823213807.GA9110@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle floating point state better in ptrace.  The code now correctly
distinguishes between PTRACE_[GS]ETFPREGS and PTRACE_[GS]ETFPXREGS.
The FPX requests get handed off to arch-specific code because that's
not generic.

get_fpregs, set_fpregs, set_fpregs, and set_fpxregs needed real
implementations.

Something here exposed a missing include in asm/page.h, which needed
linux/types.h in order to get gfp_t, so that's fixed here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/ptrace.c         |   18 +++------
 arch/um/sys-i386/ptrace.c       |   73 ++++++++++++++++++++++++++--------------
 arch/um/sys-x86_64/ptrace.c     |   53 +++++++++++++++++++++--------
 include/asm-um/page.h           |    1 
 include/asm-um/ptrace-generic.h |   11 +++---
 include/asm-um/ptrace-i386.h    |    6 +++
 6 files changed, 107 insertions(+), 55 deletions(-)

Index: linux-2.6.22/arch/um/kernel/ptrace.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/ptrace.c	2007-08-23 12:56:16.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/ptrace.c	2007-08-23 12:56:44.000000000 -0400
@@ -143,22 +143,14 @@ long arch_ptrace(struct task_struct *chi
 #endif
 #ifdef PTRACE_GETFPREGS
 	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs(data, child);
+		ret = get_fpregs((struct user_i387_struct __user *) data,
+				 child);
 		break;
 #endif
 #ifdef PTRACE_SETFPREGS
 	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-	        ret = set_fpregs(data, child);
-		break;
-#endif
-#ifdef PTRACE_GETFPXREGS
-	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
-		ret = get_fpxregs(data, child);
-		break;
-#endif
-#ifdef PTRACE_SETFPXREGS
-	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
-		ret = set_fpxregs(data, child);
+	        ret = set_fpregs((struct user_i387_struct __user *) data,
+				 child);
 		break;
 #endif
 	case PTRACE_GET_THREAD_AREA:
@@ -227,6 +219,8 @@ long arch_ptrace(struct task_struct *chi
 #endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
+		if (ret == -EIO)
+			ret = subarch_ptrace(child, request, addr, data);
 		break;
 	}
 
Index: linux-2.6.22/arch/um/sys-x86_64/ptrace.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/ptrace.c	2007-08-23 12:56:16.000000000 -0400
+++ linux-2.6.22/arch/um/sys-x86_64/ptrace.c	2007-08-23 12:56:44.000000000 -0400
@@ -156,28 +156,53 @@ int is_syscall(unsigned long addr)
 	return(instr == 0x050f);
 }
 
-int get_fpregs(unsigned long buf, struct task_struct *child)
+int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	panic("get_fpregs");
-	return(0);
-}
+	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
 
-int set_fpregs(unsigned long buf, struct task_struct *child)
-{
-	panic("set_fpregs");
-	return(0);
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	err = save_fp_registers(userspace_pid[cpu], fpregs);
+	if (err)
+		return err;
+
+	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	if(n > 0)
+		return -EFAULT;
+
+	return n;
 }
 
-int get_fpxregs(unsigned long buf, struct task_struct *tsk)
+int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	panic("get_fpxregs");
-	return(0);
+	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
+
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	if (n > 0)
+		return -EFAULT;
+
+	return restore_fp_registers(userspace_pid[cpu], fpregs);
 }
 
-int set_fpxregs(unsigned long buf, struct task_struct *tsk)
+long subarch_ptrace(struct task_struct *child, long request, long addr,
+		    long data)
 {
-	panic("set_fxpregs");
-	return(0);
+	int ret = -EIO;
+
+	switch (request) {
+	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
+		ret = get_fpregs((struct user_i387_struct __user *) data,
+				 child);
+		break;
+	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
+		ret = set_fpregs((struct user_i387_struct __user *) data,
+				 child);
+		break;
+	}
+
+	return ret;
 }
 
 /*
Index: linux-2.6.22/include/asm-um/ptrace-generic.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/ptrace-generic.h	2007-08-23 12:56:16.000000000 -0400
+++ linux-2.6.22/include/asm-um/ptrace-generic.h	2007-08-23 12:56:44.000000000 -0400
@@ -9,6 +9,7 @@
 #ifndef __ASSEMBLY__
 
 #include "asm/arch/ptrace-abi.h"
+#include <asm/user.h>
 #include "sysdep/ptrace.h"
 
 struct pt_regs {
@@ -35,12 +36,14 @@ struct pt_regs {
 
 struct task_struct;
 
+extern long subarch_ptrace(struct task_struct *child, long request, long addr,
+			   long data);
 extern unsigned long getreg(struct task_struct *child, int regno);
 extern int putreg(struct task_struct *child, int regno, unsigned long value);
-extern int get_fpregs(unsigned long buf, struct task_struct *child);
-extern int set_fpregs(unsigned long buf, struct task_struct *child);
-extern int get_fpxregs(unsigned long buf, struct task_struct *child);
-extern int set_fpxregs(unsigned long buf, struct task_struct *tsk);
+extern int get_fpregs(struct user_i387_struct __user *buf,
+		      struct task_struct *child);
+extern int set_fpregs(struct user_i387_struct __user *buf,
+		      struct task_struct *child);
 
 extern void show_regs(struct pt_regs *regs);
 
Index: linux-2.6.22/include/asm-um/ptrace-i386.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/ptrace-i386.h	2007-08-23 12:56:16.000000000 -0400
+++ linux-2.6.22/include/asm-um/ptrace-i386.h	2007-08-23 12:56:44.000000000 -0400
@@ -10,6 +10,7 @@
 
 #include "linux/compiler.h"
 #include "asm/ptrace-generic.h"
+#include <asm/user.h>
 #include "sysdep/ptrace.h"
 
 #define PT_REGS_EAX(r) UPT_EAX(&(r)->regs)
@@ -45,6 +46,11 @@
  */
 struct user_desc;
 
+extern int get_fpxregs(struct user_fxsr_struct __user *buf,
+		       struct task_struct *child);
+extern int set_fpxregs(struct user_fxsr_struct __user *buf,
+		       struct task_struct *tsk);
+
 extern int ptrace_get_thread_area(struct task_struct *child, int idx,
                                   struct user_desc __user *user_desc);
 
Index: linux-2.6.22/arch/um/sys-i386/ptrace.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/ptrace.c	2007-08-23 12:56:24.000000000 -0400
+++ linux-2.6.22/arch/um/sys-i386/ptrace.c	2007-08-23 12:56:50.000000000 -0400
@@ -6,6 +6,7 @@
 #include "linux/mm.h"
 #include "linux/sched.h"
 #include "asm/uaccess.h"
+#include "skas.h"
 
 extern int arch_switch_tls(struct task_struct *from, struct task_struct *to);
 
@@ -144,48 +145,64 @@ int peek_user(struct task_struct *child,
 	return put_user(tmp, (unsigned long __user *) data);
 }
 
-static inline int convert_fxsr_to_user(struct _fpstate __user *buf,
-				       struct pt_regs *regs)
+int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	return 0;
-}
+	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
 
-static inline int convert_fxsr_from_user(struct pt_regs *regs,
-					 struct _fpstate __user *buf)
-{
-	return 0;
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	err = save_fp_registers(userspace_pid[cpu], fpregs);
+	if (err)
+		return err;
+
+	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	if(n > 0)
+		return -EFAULT;
+
+	return n;
 }
 
-int get_fpregs(unsigned long buf, struct task_struct *child)
+int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
-	int err;
+	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_FP_SIZE];
 
-	err = convert_fxsr_to_user((struct _fpstate __user *) buf,
-				   &child->thread.regs);
-	if (err)
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	if (n > 0)
 		return -EFAULT;
-	return 0;
+
+	return restore_fp_registers(userspace_pid[cpu], fpregs);
 }
 
-int set_fpregs(unsigned long buf, struct task_struct *child)
+int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	int err;
+	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_XFP_SIZE];
 
-	err = convert_fxsr_from_user(&child->thread.regs,
-				     (struct _fpstate __user *) buf);
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	err = save_fpx_registers(userspace_pid[cpu], fpregs);
 	if (err)
+		return err;
+
+	n = copy_to_user((void *) buf, fpregs, sizeof(fpregs));
+	if(n > 0)
 		return -EFAULT;
-	return 0;
-}
 
-int get_fpxregs(unsigned long buf, struct task_struct *tsk)
-{
-	return 0;
+	return n;
 }
 
-int set_fpxregs(unsigned long buf, struct task_struct *tsk)
+int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
-	return 0;
+	int n, cpu = ((struct thread_info *) child->stack)->cpu;
+	long fpregs[HOST_XFP_SIZE];
+
+	BUG_ON(sizeof(*buf) != sizeof(fpregs));
+	n = copy_from_user(fpregs, (void *) buf, sizeof(fpregs));
+	if (n > 0)
+		return -EFAULT;
+
+	return restore_fpx_registers(userspace_pid[cpu], fpregs);
 }
 
 #ifdef notdef
@@ -209,3 +226,9 @@ int dump_fpu(struct pt_regs *regs, elf_f
 {
 	return 1;
 }
+
+long subarch_ptrace(struct task_struct *child, long request, long addr,
+		    long data)
+{
+	return -EIO;
+}
Index: linux-2.6.22/include/asm-um/page.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/page.h	2007-08-23 12:56:16.000000000 -0400
+++ linux-2.6.22/include/asm-um/page.h	2007-08-23 12:56:44.000000000 -0400
@@ -9,6 +9,7 @@
 
 struct page;
 
+#include <linux/types.h>
 #include <asm/vm-flags.h>
 
 /* PAGE_SHIFT determines the page size */
