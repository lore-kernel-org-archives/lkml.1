Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbXLRBhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbXLRBhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbXLRBgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:36:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbXLRBgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:36:31 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/21] [PATCH] get rid of _MASK flags
Date: Mon, 17 Dec 2007 20:52:25 -0200
Message-Id: <11979319763641-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197931971748-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for the *_MASK flags (TF_MASK, IF_MASK, etc), found in
processor.h (both _32 and _64). They have a one-to-one mapping with the
EFLAGS value. This patch removes the definitions, and use the already
exisant X86_EFLAGS_ version when applicable.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/ia32/ia32_signal.c    |    4 ++--
 arch/x86/kernel/kprobes_64.c   |   20 ++++++++++----------
 arch/x86/kernel/signal_64.c    |    4 ++--
 arch/x86/kernel/traps_64.c     |    2 +-
 include/asm-x86/kprobes.h      |    2 +-
 include/asm-x86/processor.h    |    2 ++
 include/asm-x86/processor_32.h |    1 -
 include/asm-x86/processor_64.h |   11 -----------
 8 files changed, 18 insertions(+), 28 deletions(-)

Index: linux-2.6-x86/arch/x86/ia32/ia32_signal.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/ia32/ia32_signal.c
+++ linux-2.6-x86/arch/x86/ia32/ia32_signal.c
@@ -501,7 +501,7 @@ int ia32_setup_frame(int sig, struct k_s
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~X86_EFLAGS_TF;
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -601,7 +601,7 @@ int ia32_setup_rt_frame(int sig, struct 
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~X86_EFLAGS_TF;
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
Index: linux-2.6-x86/arch/x86/kernel/signal_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/signal_64.c
+++ linux-2.6-x86/arch/x86/kernel/signal_64.c
@@ -295,7 +295,7 @@ static int setup_rt_frame(int sig, struc
 	   see include/asm-x86_64/uaccess.h for details. */
 	set_fs(USER_DS);
 
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~X86_EFLAGS_TF;
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 #ifdef DEBUG_SIG
@@ -463,7 +463,7 @@ do_notify_resume(struct pt_regs *regs, v
 	       
 	/* Pending single-step? */
 	if (thread_info_flags & _TIF_SINGLESTEP) {
-		regs->flags |= TF_MASK;
+		regs->flags |= X86_EFLAGS_TF;
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
Index: linux-2.6-x86/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6-x86/arch/x86/kernel/traps_64.c
@@ -903,7 +903,7 @@ clear_dr7:
 
 clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~X86_EFLAGS_TF;
 	preempt_conditional_cli(regs);
 }
 
Index: linux-2.6-x86/include/asm-x86/kprobes.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/kprobes.h
+++ linux-2.6-x86/include/asm-x86/kprobes.h
@@ -88,7 +88,7 @@ struct kprobe_ctlblk {
  */
 static inline void restore_interrupts(struct pt_regs *regs)
 {
-	if (regs->flags & IF_MASK)
+	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
 
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_X86_PROCESSOR_H
 #define __ASM_X86_PROCESSOR_H
 
+#include <asm/processor-flags.h>
+
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)
 {
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -19,7 +19,6 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
-#include <asm/processor-flags.h>
 #include <asm/desc_defs.h>
 
 static inline int desc_empty(const void *ptr)
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -18,19 +18,8 @@
 #include <asm/percpu.h>
 #include <linux/personality.h>
 #include <linux/cpumask.h>
-#include <asm/processor-flags.h>
 #include <asm/desc_defs.h>
 
-#define TF_MASK		0x00000100
-#define IF_MASK		0x00000200
-#define IOPL_MASK	0x00003000
-#define NT_MASK		0x00004000
-#define VM_MASK		0x00020000
-#define AC_MASK		0x00040000
-#define VIF_MASK	0x00080000	/* virtual interrupt flag */
-#define VIP_MASK	0x00100000	/* virtual interrupt pending */
-#define ID_MASK		0x00200000
-
 static inline int desc_empty(const void *ptr)
 {
 	const u32 *desc = ptr;
Index: linux-2.6-x86/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/kprobes.c
+++ linux-2.6-x86/arch/x86/kernel/kprobes.c
@@ -387,9 +387,9 @@ static void __kprobes set_current_kprobe
 {
 	__get_cpu_var(current_kprobe) = p;
 	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
-		= (regs->flags & (TF_MASK | IF_MASK));
+		= (regs->flags & (X86_EFLAGS_TF | X86_EFLAGS_IF));
 	if (is_IF_modifier(p->ainsn.insn))
-		kcb->kprobe_saved_flags &= ~IF_MASK;
+		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
 }
 
 static __always_inline void clear_btf(void)
@@ -407,8 +407,8 @@ static __always_inline void restore_btf(
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
 	clear_btf();
-	regs->flags |= TF_MASK;
-	regs->flags &= ~IF_MASK;
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
 	/*single step inline if the instruction is an int3*/
 	if (p->opcode == BREAKPOINT_INSTRUCTION)
 		regs->ip = (unsigned long)p->addr;
@@ -454,7 +454,7 @@ static int __kprobes kprobe_handler(stru
 		if (p) {
 			if (kcb->kprobe_status == KPROBE_HIT_SS &&
 				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->flags &= ~TF_MASK;
+				regs->flags &= ~X86_EFLAGS_TF;
 				regs->flags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
 #ifdef CONFIG_X86_64
@@ -749,10 +749,10 @@ static void __kprobes resume_execution(s
 		insn++;
 #endif
 
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~X86_EFLAGS_TF;
 	switch (*insn) {
 	case 0x9c:	/* pushfl */
-		*tos &= ~(TF_MASK | IF_MASK);
+		*tos &= ~(X86_EFLAGS_TF | X86_EFLAGS_IF);
 		*tos |= kcb->kprobe_old_flags;
 		break;
 	case 0xc2:	/* iret/ret/lret */
@@ -852,7 +852,7 @@ out:
 	 * will have TF set, in which case, continue the remaining processing
 	 * of do_debug, as if this is not a probe hit.
 	 */
-	if (regs->flags & TF_MASK)
+	if (regs->flags & X86_EFLAGS_TF)
 		return 0;
 
 	return 1;
@@ -982,7 +982,7 @@ int __kprobes setjmp_pre_handler(struct 
 	 */
 	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
 	       MIN_STACK_SIZE(addr));
-	regs->flags &= ~IF_MASK;
+	regs->flags &= ~X86_EFLAGS_IF;
 	trace_hardirqs_off();
 	regs->ip = (unsigned long)(jp->entry);
 	return 1;
