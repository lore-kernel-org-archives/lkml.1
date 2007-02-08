Return-Path: <linux-kernel-owner+w=401wt.eu-S1945929AbXBHWFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945929AbXBHWFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945921AbXBHWFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:05:10 -0500
Received: from [198.99.130.12] ([198.99.130.12]:39084 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1945916AbXBHWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:04:47 -0500
Message-Id: <200702082157.l18LvVFB007602@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       wstearns@pobox.com, Antoine Martin <antoine@nagafix.co.uk>
Subject: [PATCH 2/3] UML - x86_64 thread fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 08 Feb 2007 16:57:31 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 needs some TLS fixes.  What was missing was remembering the
child thread id during clone and stuffing it into the child during
each context switch.

The %fs value is stored separately in the thread structure since the
host controls what effect it has on the actual register file.  The
host also needs to store it in its own thread struct, so we need the
value kept outside the register file.

arch_prctl_skas was fixed to call PTRACE_ARCH_PRCTL appropriately.
There is some saving and restoring of registers in the ARCH_SET_*
cases so that the correct set of registers are changed on the host and
restored to the process when it runs again.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/include/os.h                 |    2 
 arch/um/os-Linux/sys-x86_64/Makefile |    2 
 arch/um/os-Linux/sys-x86_64/prctl.c  |   12 +++++
 arch/um/sys-x86_64/syscalls.c        |   73 ++++++++++++++++++++++++++---------
 arch/um/sys-x86_64/tls.c             |   11 +++--
 include/asm-um/processor-x86_64.h    |    6 +-
 include/asm-um/ptrace-x86_64.h       |    6 --
 7 files changed, 83 insertions(+), 29 deletions(-)

Index: linux-2.6.18-mm/arch/um/include/os.h
===================================================================
--- linux-2.6.18-mm.orig/arch/um/include/os.h	2007-02-08 16:08:07.000000000 -0500
+++ linux-2.6.18-mm/arch/um/include/os.h	2007-02-08 16:48:02.000000000 -0500
@@ -340,4 +340,6 @@ extern void maybe_sigio_broken(int fd, i
 extern void sig_handler_common_skas(int sig, void *sc_ptr);
 extern void user_signal(int sig, union uml_pt_regs *regs, int pid);
 
+extern int os_arch_prctl(int pid, int code, unsigned long *addr);
+
 #endif
Index: linux-2.6.18-mm/arch/um/os-Linux/sys-x86_64/Makefile
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/sys-x86_64/Makefile	2007-02-08 16:08:07.000000000 -0500
+++ linux-2.6.18-mm/arch/um/os-Linux/sys-x86_64/Makefile	2007-02-08 16:08:28.000000000 -0500
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-$(CONFIG_MODE_SKAS) = registers.o signal.o
+obj-$(CONFIG_MODE_SKAS) = registers.o prctl.o signal.o
 
 USER_OBJS := $(obj-y)
 
Index: linux-2.6.18-mm/arch/um/os-Linux/sys-x86_64/prctl.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.18-mm/arch/um/os-Linux/sys-x86_64/prctl.c	2007-02-08 16:08:28.000000000 -0500
@@ -0,0 +1,12 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit.com,linux.intel.com})
+ * Licensed under the GPL
+ */
+
+#include <sys/ptrace.h>
+#include <linux/ptrace.h>
+
+int os_arch_prctl(int pid, int code, unsigned long *addr)
+{
+        return ptrace(PTRACE_ARCH_PRCTL, pid, (unsigned long) addr, code);
+}
Index: linux-2.6.18-mm/arch/um/sys-x86_64/syscalls.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-x86_64/syscalls.c	2007-02-08 16:08:07.000000000 -0500
+++ linux-2.6.18-mm/arch/um/sys-x86_64/syscalls.c	2007-02-08 16:48:02.000000000 -0500
@@ -16,6 +16,7 @@
 #include "asm/prctl.h" /* XXX This should get the constants from libc */
 #include "choose-mode.h"
 #include "kern.h"
+#include "os.h"
 
 asmlinkage long sys_uname64(struct new_utsname __user * name)
 {
@@ -58,40 +59,67 @@ static long arch_prctl_tt(int code, unsi
 
 #ifdef CONFIG_MODE_SKAS
 
-/* XXX: Must also call arch_prctl in the host, beside saving the segment bases! */
-static long arch_prctl_skas(int code, unsigned long addr)
+static long arch_prctl_skas(int code, unsigned long __user *addr)
 {
-	long ret = 0;
+        unsigned long *ptr = addr, tmp;
+	long ret;
+        int pid = current->mm->context.skas.id.u.pid;
 
+	/*
+	 * With ARCH_SET_FS (and ARCH_SET_GS is treated similarly to
+	 * be safe), we need to call arch_prctl on the host because
+	 * setting %fs may result in something else happening (like a
+	 * GDT being set instead).  So, we let the host fiddle the
+	 * registers and restore them afterwards.
+	 *
+	 * So, the saved registers are stored to the process (this
+	 * needed because a stub may have been the last thing to run),
+	 * arch_prctl is run on the host, then the registers are read
+	 * back.
+	 */
 	switch(code){
 	case ARCH_SET_FS:
-		current->thread.regs.regs.skas.regs[FS_BASE / sizeof(unsigned long)] = addr;
-		break;
 	case ARCH_SET_GS:
-		current->thread.regs.regs.skas.regs[GS_BASE / sizeof(unsigned long)] = addr;
+                restore_registers(pid, &current->thread.regs.regs);
+                break;
+        case ARCH_GET_FS:
+        case ARCH_GET_GS:
+                /*
+                 * With these two, we read to a local pointer and
+                 * put_user it to the userspace pointer that we were
+                 * given.  If addr isn't valid (because it hasn't been
+                 * faulted in or is just bogus), we want put_user to
+                 * fault it in (or return -EFAULT) instead of having
+                 * the host return -EFAULT.
+                 */
+                ptr = &tmp;
+        }
+
+        ret = os_arch_prctl(pid, code, ptr);
+        if(ret)
+                return ret;
+
+        switch(code){
+	case ARCH_SET_FS:
+	case ARCH_SET_GS:
+                save_registers(pid, &current->thread.regs.regs);
 		break;
 	case ARCH_GET_FS:
-		ret = put_user(current->thread.regs.regs.skas.
-				regs[FS_BASE / sizeof(unsigned long)],
-				(unsigned long __user *)addr);
+		ret = put_user(tmp, addr);
 	        break;
 	case ARCH_GET_GS:
-		ret = put_user(current->thread.regs.regs.skas.
-				regs[GS_BASE / sizeof(unsigned long)],
-				(unsigned long __user *)addr);
+		ret = put_user(tmp, addr);
 	        break;
-	default:
-		ret = -EINVAL;
-		break;
 	}
 
-	return(ret);
+	return ret;
 }
 #endif
 
 long sys_arch_prctl(int code, unsigned long addr)
 {
-	return(CHOOSE_MODE_PROC(arch_prctl_tt, arch_prctl_skas, code, addr));
+	return CHOOSE_MODE_PROC(arch_prctl_tt, arch_prctl_skas, code,
+                                (unsigned long __user *) addr);
 }
 
 long sys_clone(unsigned long clone_flags, unsigned long newsp,
@@ -105,5 +133,14 @@ long sys_clone(unsigned long clone_flags
 	ret = do_fork(clone_flags, newsp, &current->thread.regs, 0, parent_tid,
 		      child_tid);
 	current->thread.forking = 0;
-	return(ret);
+	return ret;
 }
+
+void arch_switch_to_skas(struct task_struct *from, struct task_struct *to)
+{
+        if(to->thread.arch.fs == 0)
+                return;
+
+        arch_prctl_skas(ARCH_SET_FS, (void __user *) to->thread.arch.fs);
+}
+
Index: linux-2.6.18-mm/include/asm-um/processor-x86_64.h
===================================================================
--- linux-2.6.18-mm.orig/include/asm-um/processor-x86_64.h	2007-02-08 16:08:07.000000000 -0500
+++ linux-2.6.18-mm/include/asm-um/processor-x86_64.h	2007-02-08 16:49:22.000000000 -0500
@@ -13,6 +13,7 @@
 struct arch_thread {
         unsigned long debugregs[8];
         int debugregs_seq;
+        unsigned long fs;
         struct faultinfo faultinfo;
 };
 
@@ -25,8 +26,9 @@ extern inline void rep_nop(void)
 #define cpu_relax()   rep_nop()
 
 #define INIT_ARCH_THREAD { .debugregs  		= { [ 0 ... 7 ] = 0 }, \
-                           .debugregs_seq	= 0, \
-                           .faultinfo		= { 0, 0, 0 } }
+                           .debugregs_seq	= 0,			       \
+			   .fs			= 0, \
+			   .faultinfo		= { 0, 0, 0 } }
 
 static inline void arch_flush_thread(struct arch_thread *thread)
 {
Index: linux-2.6.18-mm/include/asm-um/ptrace-x86_64.h
===================================================================
--- linux-2.6.18-mm.orig/include/asm-um/ptrace-x86_64.h	2007-02-08 16:08:07.000000000 -0500
+++ linux-2.6.18-mm/include/asm-um/ptrace-x86_64.h	2007-02-08 16:48:02.000000000 -0500
@@ -81,9 +81,7 @@ static inline void arch_switch_to_tt(str
 {
 }
 
-static inline void arch_switch_to_skas(struct task_struct *from,
-                                       struct task_struct *to)
-{
-}
+extern void arch_switch_to_skas(struct task_struct *from,
+				struct task_struct *to);
 
 #endif
Index: linux-2.6.18-mm/arch/um/sys-x86_64/tls.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-x86_64/tls.c	2007-02-08 16:08:07.000000000 -0500
+++ linux-2.6.18-mm/arch/um/sys-x86_64/tls.c	2007-02-08 16:08:28.000000000 -0500
@@ -1,14 +1,17 @@
 #include "linux/sched.h"
 
-void debug_arch_force_load_TLS(void)
-{
-}
-
 void clear_flushed_tls(struct task_struct *task)
 {
 }
 
 int arch_copy_tls(struct task_struct *t)
 {
+	/*
+	 * If CLONE_SETTLS is set, we need to save the thread id
+	 * (which is argument 5, child_tid, of clone) so it can be set
+	 * during context switches.
+	 */
+	t->thread.arch.fs = t->thread.regs.regs.skas.regs[R8 / sizeof(long)];
+
         return 0;
 }

