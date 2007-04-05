Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXDEAi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXDEAi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEAir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:38:47 -0400
Received: from [198.99.130.12] ([198.99.130.12]:50395 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbXDEAiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:38:25 -0400
Date: Wed, 4 Apr 2007 20:34:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 2/4] UML - Kernel segfaults should dump proper registers
Message-ID: <20070405003402.GA13275@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If there's a segfault inside the kernel, we want a dump of the registers
at the point of the segfault, not the registers at the point of
calling panic or the last userspace registers.

sig_handler_common_skas now uses a static register set in the case
of a SIGSEGV to avoid messing up the process registers if the
segfault turns out to be non-fatal.

The architecture sigcontext-to-pt_regs copying code was repurposed
to copy data out of the SEGV stack frame.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/common-offsets.h |    2 +
 arch/um/include/kern_util.h      |    2 +
 arch/um/kernel/trap.c            |   10 ++++++---
 arch/um/os-Linux/skas/trap.c     |   15 ++++++++++++--
 arch/um/sys-i386/signal.c        |   41 ++++++++++++++++++++++-----------------
 arch/um/sys-x86_64/signal.c      |   30 ++++++++++++++++++++++++++++
 6 files changed, 78 insertions(+), 22 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/trap.c	2007-04-02 12:19:04.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/trap.c	2007-04-02 12:19:07.000000000 -0400
@@ -170,8 +170,10 @@ unsigned long segv(struct faultinfo fi, 
 		flush_tlb_kernel_vm();
 		return 0;
 	}
-	else if(current->mm == NULL)
-		panic("Segfault with no mm");
+	else if(current->mm == NULL) {
+		show_regs(container_of(regs, struct pt_regs, regs));
+  		panic("Segfault with no mm");
+	}
 
 	if (SEGV_IS_FIXABLE(&fi) || SEGV_MAYBE_FIXABLE(&fi))
 		err = handle_page_fault(address, ip, is_write, is_user, &si.si_code);
@@ -194,9 +196,11 @@ unsigned long segv(struct faultinfo fi, 
 	else if(!is_user && arch_fixup(ip, regs))
 		return 0;
 
-	if(!is_user)
+	if(!is_user) {
+		show_regs(container_of(regs, struct pt_regs, regs));
 		panic("Kernel mode fault at addr 0x%lx, ip 0x%lx",
 		      address, ip);
+	}
 
 	if (err == -EACCES) {
 		si.si_signo = SIGBUS;
Index: linux-2.6.21-mm/arch/um/include/kern_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/kern_util.h	2007-04-02 12:19:04.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/kern_util.h	2007-04-02 12:19:07.000000000 -0400
@@ -116,4 +116,6 @@ extern void log_info(char *fmt, ...) __a
 extern int __cant_sleep(void);
 extern void sigio_handler(int sig, union uml_pt_regs *regs);
 
+extern void copy_sc(union uml_pt_regs *regs, void *from);
+
 #endif
Index: linux-2.6.21-mm/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/common-offsets.h	2007-04-02 12:18:49.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/common-offsets.h	2007-04-02 12:19:07.000000000 -0400
@@ -24,5 +24,7 @@ DEFINE(UM_ELF_CLASS, ELF_CLASS);
 DEFINE(UM_ELFCLASS32, ELFCLASS32);
 DEFINE(UM_ELFCLASS64, ELFCLASS64);
 
+DEFINE(UM_NR_CPUS, NR_CPUS);
+
 /* For crypto assembler code. */
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/trap.c	2007-04-02 12:19:04.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/trap.c	2007-04-02 12:19:07.000000000 -0400
@@ -15,6 +15,8 @@
 #include "sysdep/ptrace_user.h"
 #include "os.h"
 
+static union uml_pt_regs ksig_regs[UM_NR_CPUS];
+
 void sig_handler_common_skas(int sig, void *sc_ptr)
 {
 	struct sigcontext *sc = sc_ptr;
@@ -27,10 +29,19 @@ void sig_handler_common_skas(int sig, vo
 	 * the process will die.
 	 * XXX Figure out why this is better than SA_NODEFER
 	 */
-	if(sig == SIGSEGV)
+	if(sig == SIGSEGV) {
 		change_sig(SIGSEGV, 1);
+		/* For segfaults, we want the data from the
+		 * sigcontext.  In this case, we don't want to mangle
+		 * the process registers, so use a static set of
+		 * registers.  For other signals, the process
+		 * registers are OK.
+		 */
+		r = &ksig_regs[cpu()];
+		copy_sc(r, sc_ptr);
+	}
+	else r = TASK_REGS(get_current());
 
-	r = TASK_REGS(get_current());
 	save_user = r->skas.is_user;
 	r->skas.is_user = 0;
 	if ( sig == SIGFPE || sig == SIGSEGV ||
Index: linux-2.6.21-mm/arch/um/sys-i386/signal.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/signal.c	2007-04-02 12:19:04.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/signal.c	2007-04-02 12:19:07.000000000 -0400
@@ -18,6 +18,28 @@
 
 #include "skas.h"
 
+void copy_sc(union uml_pt_regs *regs, void *from)
+{
+	struct sigcontext *sc = from;
+
+	REGS_GS(regs->skas.regs) = sc->gs;
+	REGS_FS(regs->skas.regs) = sc->fs;
+	REGS_ES(regs->skas.regs) = sc->es;
+	REGS_DS(regs->skas.regs) = sc->ds;
+	REGS_EDI(regs->skas.regs) = sc->edi;
+	REGS_ESI(regs->skas.regs) = sc->esi;
+	REGS_EBP(regs->skas.regs) = sc->ebp;
+	REGS_SP(regs->skas.regs) = sc->esp;
+	REGS_EBX(regs->skas.regs) = sc->ebx;
+	REGS_EDX(regs->skas.regs) = sc->edx;
+	REGS_ECX(regs->skas.regs) = sc->ecx;
+	REGS_EAX(regs->skas.regs) = sc->eax;
+	REGS_IP(regs->skas.regs) = sc->eip;
+	REGS_CS(regs->skas.regs) = sc->cs;
+	REGS_EFLAGS(regs->skas.regs) = sc->eflags;
+	REGS_SS(regs->skas.regs) = sc->ss;
+}
+
 static int copy_sc_from_user_skas(struct pt_regs *regs,
 				  struct sigcontext __user *from)
 {
@@ -30,25 +52,10 @@ static int copy_sc_from_user_skas(struct
 	if(err)
 		return err;
 
-	REGS_GS(regs->regs.skas.regs) = sc.gs;
-	REGS_FS(regs->regs.skas.regs) = sc.fs;
-	REGS_ES(regs->regs.skas.regs) = sc.es;
-	REGS_DS(regs->regs.skas.regs) = sc.ds;
-	REGS_EDI(regs->regs.skas.regs) = sc.edi;
-	REGS_ESI(regs->regs.skas.regs) = sc.esi;
-	REGS_EBP(regs->regs.skas.regs) = sc.ebp;
-	REGS_SP(regs->regs.skas.regs) = sc.esp;
-	REGS_EBX(regs->regs.skas.regs) = sc.ebx;
-	REGS_EDX(regs->regs.skas.regs) = sc.edx;
-	REGS_ECX(regs->regs.skas.regs) = sc.ecx;
-	REGS_EAX(regs->regs.skas.regs) = sc.eax;
-	REGS_IP(regs->regs.skas.regs) = sc.eip;
-	REGS_CS(regs->regs.skas.regs) = sc.cs;
-	REGS_EFLAGS(regs->regs.skas.regs) = sc.eflags;
-	REGS_SS(regs->regs.skas.regs) = sc.ss;
+	copy_sc(&regs->regs, &sc);
 
 	err = restore_fp_registers(userspace_pid[0], fpregs);
-	if(err < 0){
+	if(err < 0) {
 	  	printk("copy_sc_from_user_skas - PTRACE_SETFPREGS failed, "
 		       "errno = %d\n", -err);
 		return err;
Index: linux-2.6.21-mm/arch/um/sys-x86_64/signal.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-x86_64/signal.c	2007-04-02 12:19:04.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-x86_64/signal.c	2007-04-02 12:19:07.000000000 -0400
@@ -20,6 +20,36 @@
 
 #include "skas.h"
 
+void copy_sc(union uml_pt_regs *regs, void *from)
+{
+	struct sigcontext *sc = from;
+
+#define GETREG(regs, regno, sc, regname) \
+       (regs)->skas.regs[(regno) / sizeof(unsigned long)] = (sc)->regname
+
+       GETREG(regs, R8, sc, r8);
+       GETREG(regs, R9, sc, r9);
+       GETREG(regs, R10, sc, r10);
+       GETREG(regs, R11, sc, r11);
+       GETREG(regs, R12, sc, r12);
+       GETREG(regs, R13, sc, r13);
+       GETREG(regs, R14, sc, r14);
+       GETREG(regs, R15, sc, r15);
+       GETREG(regs, RDI, sc, rdi);
+       GETREG(regs, RSI, sc, rsi);
+       GETREG(regs, RBP, sc, rbp);
+       GETREG(regs, RBX, sc, rbx);
+       GETREG(regs, RDX, sc, rdx);
+       GETREG(regs, RAX, sc, rax);
+       GETREG(regs, RCX, sc, rcx);
+       GETREG(regs, RSP, sc, rsp);
+       GETREG(regs, RIP, sc, rip);
+       GETREG(regs, EFLAGS, sc, eflags);
+       GETREG(regs, CS, sc, cs);
+
+#undef GETREG
+}
+
 static int copy_sc_from_user_skas(struct pt_regs *regs,
                                  struct sigcontext __user *from)
 {
