Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbXCSUQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbXCSUQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXCSUQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:16:20 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:40712 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXCSUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:16:19 -0400
Date: Mon, 19 Mar 2007 16:12:50 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [stable] [PATCH] UML - arch_prctl should set thread fs
Message-ID: <20070319201250.GC12179@c2.user-mode-linux.org>
References: <20070316161015.GA7948@c2.user-mode-linux.org> <20070316230031.GA13798@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316230031.GA13798@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 04:00:31PM -0700, Greg KH wrote:
> That's because it doesn't apply at all to the current 2.6.20.3 kernel
> tree.  Can you rediff it for that one so that we can apply it properly?

My apologies - that depended on a previous patch which I thought had
made it into -stable.  Below is a combination patch - I think larger
than normal for -stable, but a good part of it is non-code changes.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


x86_64 needs some TLS fixes.  What was missing was remembering the child
thread id during clone and stuffing it into the child during each context
switch.

The %fs value is stored separately in the thread structure since the host
controls what effect it has on the actual register file.  The host also needs
to store it in its own thread struct, so we need the value kept outside the
register file.

arch_prctl_skas was fixed to call PTRACE_ARCH_PRCTL appropriately.  There is
some saving and restoring of registers in the ARCH_SET_* cases so that the
correct set of registers are changed on the host and restored to the process
when it runs again.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/include/os.h                 |    2 
 arch/um/os-Linux/sys-x86_64/Makefile |    2 
 arch/um/os-Linux/sys-x86_64/prctl.c  |   12 +++++
 arch/um/sys-x86_64/syscalls.c        |   76 ++++++++++++++++++++++++++---------
 arch/um/sys-x86_64/tls.c             |   11 +++--
 include/asm-um/processor-x86_64.h    |    6 +-
 include/asm-um/ptrace-x86_64.h       |    6 --
 7 files changed, 86 insertions(+), 29 deletions(-)

Index: linux-2.6.20.3/arch/um/include/os.h
===================================================================
--- linux-2.6.20.3.orig/arch/um/include/os.h
+++ linux-2.6.20.3/arch/um/include/os.h
@@ -341,4 +341,6 @@ extern void maybe_sigio_broken(int fd, i
 extern void sig_handler_common_skas(int sig, void *sc_ptr);
 extern void user_signal(int sig, union uml_pt_regs *regs, int pid);
 
+extern int os_arch_prctl(int pid, int code, unsigned long *addr);
+
 #endif
Index: linux-2.6.20.3/arch/um/os-Linux/sys-x86_64/Makefile
===================================================================
--- linux-2.6.20.3.orig/arch/um/os-Linux/sys-x86_64/Makefile
+++ linux-2.6.20.3/arch/um/os-Linux/sys-x86_64/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-$(CONFIG_MODE_SKAS) = registers.o signal.o
+obj-$(CONFIG_MODE_SKAS) = registers.o prctl.o signal.o
 
 USER_OBJS := $(obj-y)
 
Index: linux-2.6.20.3/arch/um/os-Linux/sys-x86_64/prctl.c
===================================================================
--- /dev/null
+++ linux-2.6.20.3/arch/um/os-Linux/sys-x86_64/prctl.c
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
+	return ptrace(PTRACE_ARCH_PRCTL, pid, (unsigned long) addr, code);
+}
Index: linux-2.6.20.3/arch/um/sys-x86_64/syscalls.c
===================================================================
--- linux-2.6.20.3.orig/arch/um/sys-x86_64/syscalls.c
+++ linux-2.6.20.3/arch/um/sys-x86_64/syscalls.c
@@ -16,6 +16,7 @@
 #include "asm/prctl.h" /* XXX This should get the constants from libc */
 #include "choose-mode.h"
 #include "kern.h"
+#include "os.h"
 
 asmlinkage long sys_uname64(struct new_utsname __user * name)
 {
@@ -58,40 +59,70 @@ static long arch_prctl_tt(int code, unsi
 
 #ifdef CONFIG_MODE_SKAS
 
-/* XXX: Must also call arch_prctl in the host, beside saving the segment bases! */
-static long arch_prctl_skas(int code, unsigned long addr)
+static long arch_prctl_skas(int code, unsigned long __user *addr)
 {
-	long ret = 0;
+	unsigned long *ptr = addr, tmp;
+	long ret;
+	int pid = current->mm->context.skas.id.u.pid;
+
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
+	switch(code){
+	case ARCH_SET_FS:
+	case ARCH_SET_GS:
+		restore_registers(pid, &current->thread.regs.regs);
+		break;
+	case ARCH_GET_FS:
+	case ARCH_GET_GS:
+		/*
+		 * With these two, we read to a local pointer and
+		 * put_user it to the userspace pointer that we were
+		 * given.  If addr isn't valid (because it hasn't been
+		 * faulted in or is just bogus), we want put_user to
+		 * fault it in (or return -EFAULT) instead of having
+		 * the host return -EFAULT.
+		 */
+		ptr = &tmp;
+	}
+
+	ret = os_arch_prctl(pid, code, ptr);
+	if(ret)
+		return ret;
 
 	switch(code){
 	case ARCH_SET_FS:
-		current->thread.regs.regs.skas.regs[FS_BASE / sizeof(unsigned long)] = addr;
+		current->thread.arch.fs = (unsigned long) ptr;
+		save_registers(pid, &current->thread.regs.regs);
 		break;
 	case ARCH_SET_GS:
-		current->thread.regs.regs.skas.regs[GS_BASE / sizeof(unsigned long)] = addr;
+		save_registers(pid, &current->thread.regs.regs);
 		break;
 	case ARCH_GET_FS:
-		ret = put_user(current->thread.regs.regs.skas.
-				regs[FS_BASE / sizeof(unsigned long)],
-				(unsigned long __user *)addr);
-	        break;
+		ret = put_user(tmp, addr);
+		break;
 	case ARCH_GET_GS:
-		ret = put_user(current->thread.regs.regs.skas.
-				regs[GS_BASE / sizeof(unsigned long)],
-				(unsigned long __user *)addr);
-	        break;
-	default:
-		ret = -EINVAL;
+		ret = put_user(tmp, addr);
 		break;
 	}
 
-	return(ret);
+	return ret;
 }
 #endif
 
 long sys_arch_prctl(int code, unsigned long addr)
 {
-	return(CHOOSE_MODE_PROC(arch_prctl_tt, arch_prctl_skas, code, addr));
+	return CHOOSE_MODE_PROC(arch_prctl_tt, arch_prctl_skas, code,
+				(unsigned long __user *) addr);
 }
 
 long sys_clone(unsigned long clone_flags, unsigned long newsp,
@@ -105,5 +136,14 @@ long sys_clone(unsigned long clone_flags
 	ret = do_fork(clone_flags, newsp, &current->thread.regs, 0, parent_tid,
 		      child_tid);
 	current->thread.forking = 0;
-	return(ret);
+	return ret;
 }
+
+void arch_switch_to_skas(struct task_struct *from, struct task_struct *to)
+{
+	if((to->thread.arch.fs == 0) || (to->mm == NULL))
+		return;
+
+	arch_prctl_skas(ARCH_SET_FS, (void __user *) to->thread.arch.fs);
+}
+
Index: linux-2.6.20.3/arch/um/sys-x86_64/tls.c
===================================================================
--- linux-2.6.20.3.orig/arch/um/sys-x86_64/tls.c
+++ linux-2.6.20.3/arch/um/sys-x86_64/tls.c
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
Index: linux-2.6.20.3/include/asm-um/processor-x86_64.h
===================================================================
--- linux-2.6.20.3.orig/include/asm-um/processor-x86_64.h
+++ linux-2.6.20.3/include/asm-um/processor-x86_64.h
@@ -13,6 +13,7 @@
 struct arch_thread {
         unsigned long debugregs[8];
         int debugregs_seq;
+	unsigned long fs;
         struct faultinfo faultinfo;
 };
 
@@ -25,8 +26,9 @@ extern inline void rep_nop(void)
 #define cpu_relax()   rep_nop()
 
 #define INIT_ARCH_THREAD { .debugregs  		= { [ 0 ... 7 ] = 0 }, \
-                           .debugregs_seq	= 0, \
-                           .faultinfo		= { 0, 0, 0 } }
+			   .debugregs_seq	= 0,			       \
+			   .fs			= 0, \
+			   .faultinfo		= { 0, 0, 0 } }
 
 static inline void arch_flush_thread(struct arch_thread *thread)
 {
Index: linux-2.6.20.3/include/asm-um/ptrace-x86_64.h
===================================================================
--- linux-2.6.20.3.orig/include/asm-um/ptrace-x86_64.h
+++ linux-2.6.20.3/include/asm-um/ptrace-x86_64.h
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
