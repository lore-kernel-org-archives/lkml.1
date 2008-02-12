Return-Path: <linux-kernel-owner+w=401wt.eu-S1763527AbYBLS6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763527AbYBLS6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763100AbYBLS5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:57:45 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33023 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761022AbYBLS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:57:42 -0500
Date: Tue, 12 Feb 2008 13:55:28 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/4] UML - Fix FP register corruption
Message-ID: <20080212185528.GA2079@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ee3d9bd4de1ed93d2a7ee41c331ed30a1c7b8acd, while greatly
simplifying the kernel SIGSEGV handler that runs in the process
address space, introduced a bug which corrupts FP state in the
process.

Previously, the SIGSEGV handler called the sigreturn system call by
hand - it couldn't return through the restorer provided to it because
that could try to call the libc restorer which likely wouldn't exist
in the process address space.  So, it blocked off some signals,
including SIGUSR1, on entry to the SIGSEGV handler, queued a SIGUSR1
to itself, and invoked sigreturn.  The SIGUSR1 was delivered, and was
visible to the UML kernel after sigreturn finished.

The commit eliminated the signal masking and the call to sigreturn.
The handler simply hits itself with a SIGTRAP to let the UML kernel
know that it is finished.  UML then restores the process registers,
which effectively longjmps the process out of the signal handler,
skipping sigreturn's restoring of register state and the signal mask.

The bug is that the host apparently sets used_fp to 0 when it saves
the process FP state in the sigcontext on the process signal stack.
Thus, when the process is longjmped out of the handler, its FP state
is corrupt because it wasn't saved on the context switch to the UML
kernel.

This manifested itself as sleep hanging.  For some reason, sleep uses
floating point in order to calculate the sleep interval.  When a page
fault corrupts its FP state, it is faked into essentially sleeping
forever.

This patch saves the FP state before entering the SIGSEGV handler and
restores it afterwards.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/registers.h                 |    2 ++
 arch/um/include/sysdep-i386/ptrace_user.h   |    3 +++
 arch/um/include/sysdep-x86_64/ptrace_user.h |    3 +++
 arch/um/os-Linux/skas/process.c             |   15 +++++++++++++++
 arch/um/os-Linux/sys-i386/registers.c       |   16 ++++++++++++++++
 arch/um/os-Linux/sys-x86_64/registers.c     |   10 ++++++++++
 6 files changed, 49 insertions(+)

Index: linux-2.6-git/arch/um/include/sysdep-i386/ptrace_user.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-i386/ptrace_user.h	2008-02-12 13:18:59.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-i386/ptrace_user.h	2008-02-12 13:35:12.000000000 -0500
@@ -9,6 +9,7 @@
 #include <sys/ptrace.h>
 #include <linux/ptrace.h>
 #include <asm/ptrace.h>
+#include "user_constants.h"
 
 #define PT_OFFSET(r) ((r) * sizeof(long))
 
@@ -40,6 +41,8 @@
 #define PT_SP_OFFSET PT_OFFSET(UESP)
 #define PT_SP(regs) ((regs)[UESP])
 
+#define FP_SIZE ((HOST_XFP_SIZE > HOST_FP_SIZE) ? HOST_XFP_SIZE : HOST_FP_SIZE)
+
 #ifndef FRAME_SIZE
 #define FRAME_SIZE (17)
 #endif
Index: linux-2.6-git/arch/um/include/sysdep-x86_64/ptrace_user.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-x86_64/ptrace_user.h	2008-02-12 13:18:59.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-x86_64/ptrace_user.h	2008-02-12 13:35:12.000000000 -0500
@@ -12,6 +12,7 @@
 #include <linux/ptrace.h>
 #include <asm/ptrace.h>
 #undef __FRAME_OFFSETS
+#include "user_constants.h"
 
 #define PT_INDEX(off) ((off) / sizeof(unsigned long))
 
@@ -69,6 +70,8 @@
 #define REGS_IP_INDEX PT_INDEX(RIP)
 #define REGS_SP_INDEX PT_INDEX(RSP)
 
+#define FP_SIZE (HOST_FP_SIZE)
+
 #endif
 
 /*
Index: linux-2.6-git/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/skas/process.c	2008-02-12 13:18:59.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/skas/process.c	2008-02-12 13:37:02.000000000 -0500
@@ -115,6 +115,14 @@ void get_skas_faultinfo(int pid, struct 
 			       sizeof(struct ptrace_faultinfo));
 	}
 	else {
+		unsigned long fpregs[FP_SIZE];
+
+		err = get_fp_registers(pid, fpregs);
+		if (err < 0) {
+			printk(UM_KERN_ERR "save_fp_registers returned %d\n",
+			       err);
+			fatal_sigsegv();
+		}
 		err = ptrace(PTRACE_CONT, pid, 0, SIGSEGV);
 		if (err) {
 			printk(UM_KERN_ERR "Failed to continue stub, pid = %d, "
@@ -128,6 +136,13 @@ void get_skas_faultinfo(int pid, struct 
 		 * the stub stack page. We just have to copy it.
 		 */
 		memcpy(fi, (void *)current_stub_stack(), sizeof(*fi));
+
+		err = put_fp_registers(pid, fpregs);
+		if (err < 0) {
+			printk(UM_KERN_ERR "put_fp_registers returned %d\n",
+			       err);
+			fatal_sigsegv();
+		}
 	}
 }
 
Index: linux-2.6-git/arch/um/include/registers.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/registers.h	2008-02-12 13:18:59.000000000 -0500
+++ linux-2.6-git/arch/um/include/registers.h	2008-02-12 13:35:12.000000000 -0500
@@ -18,5 +18,7 @@ extern int restore_registers(int pid, st
 extern int init_registers(int pid);
 extern void get_safe_registers(unsigned long *regs);
 extern unsigned long get_thread_reg(int reg, jmp_buf *buf);
+extern int get_fp_registers(int pid, unsigned long *regs);
+extern int put_fp_registers(int pid, unsigned long *regs);
 
 #endif
Index: linux-2.6-git/arch/um/os-Linux/sys-i386/registers.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/sys-i386/registers.c	2008-02-12 13:18:59.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/sys-i386/registers.c	2008-02-12 13:37:29.000000000 -0500
@@ -56,6 +56,22 @@ unsigned long get_thread_reg(int reg, jm
 
 int have_fpx_regs = 1;
 
+int get_fp_registers(int pid, unsigned long *regs)
+{
+	if (have_fpx_regs)
+		return save_fpx_registers(pid, regs);
+	else
+		return save_fp_registers(pid, regs);
+}
+
+int put_fp_registers(int pid, unsigned long *regs)
+{
+	if (have_fpx_regs)
+		return restore_fpx_registers(pid, regs);
+	else
+		return restore_fp_registers(pid, regs);
+}
+
 void arch_init_registers(int pid)
 {
 	unsigned long fpx_regs[HOST_XFP_SIZE];
Index: linux-2.6-git/arch/um/os-Linux/sys-x86_64/registers.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/sys-x86_64/registers.c	2008-02-12 13:18:59.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/sys-x86_64/registers.c	2008-02-12 13:35:12.000000000 -0500
@@ -40,3 +40,13 @@ unsigned long get_thread_reg(int reg, jm
 		return 0;
 	}
 }
+
+int get_fp_registers(int pid, unsigned long *regs)
+{
+	return save_fp_registers(pid, regs);
+}
+
+int put_fp_registers(int pid, unsigned long *regs)
+{
+	return restore_fp_registers(pid, regs);
+}
