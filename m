Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbYC1PCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbYC1PCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbYC1PBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:01:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:20593 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186AbYC1PBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=HomLmL0d7I/WLVmKd9Z1wfgTII+lr4ujP45X+vKGx3lcZVT5jFq4orynSC/H+SoiEogw6w1fKCyylCME/PZ0V+N6S+K6m7XAA7XRAHUdnLwVUS93647vCFIK/55tz9UxpDpJgHwX5Uxc+bkzdiJL9CttqNBnAQhPObgowJiRW6I=
Message-Id: <20080328150050.564326943@gmail.com>
References: <20080328145655.076024373@gmail.com>
User-Agent: quilt/0.46-1
Date: Fri, 28 Mar 2008 17:56:56 +0300
From: gorcunov@gmail.com
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 1/2] x86: cleanup - replace most VM86 flags with flags from processor-flags.h
Content-Disposition: inline; filename=x86-vm86-gen-flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/vm86_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/vm86_32.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/vm86_32.c	2008-03-27 21:57:55.000000000 +0300
@@ -139,7 +139,7 @@ struct pt_regs *save_v86_state(struct ke
 		printk("no vm86_info: BAD\n");
 		do_exit(SIGSEGV);
 	}
-	set_flags(regs->pt.flags, VEFLAGS, VIF_MASK | current->thread.v86mask);
+	set_flags(regs->pt.flags, VEFLAGS, X86_EFLAGS_VIF | current->thread.v86mask);
 	tmp = copy_vm86_regs_to_user(&current->thread.vm86_info->regs, regs);
 	tmp += put_user(current->thread.screen_bitmap, &current->thread.vm86_info->screen_bitmap);
 	if (tmp) {
@@ -306,13 +306,13 @@ static void do_sys_vm86(struct kernel_vm
 		tsk->thread.v86mask = 0;
 		break;
 	case CPU_386:
-		tsk->thread.v86mask = NT_MASK | IOPL_MASK;
+		tsk->thread.v86mask = X86_EFLAGS_NT | X86_EFLAGS_IOPL;
 		break;
 	case CPU_486:
-		tsk->thread.v86mask = AC_MASK | NT_MASK | IOPL_MASK;
+		tsk->thread.v86mask = X86_EFLAGS_AC | X86_EFLAGS_NT | X86_EFLAGS_IOPL;
 		break;
 	default:
-		tsk->thread.v86mask = ID_MASK | AC_MASK | NT_MASK | IOPL_MASK;
+		tsk->thread.v86mask = X86_EFLAGS_ID | X86_EFLAGS_AC | X86_EFLAGS_NT | X86_EFLAGS_IOPL;
 		break;
 	}
 
@@ -363,24 +363,24 @@ static inline void return_to_32bit(struc
 
 static inline void set_IF(struct kernel_vm86_regs *regs)
 {
-	VEFLAGS |= VIF_MASK;
-	if (VEFLAGS & VIP_MASK)
+	VEFLAGS |= X86_EFLAGS_VIF;
+	if (VEFLAGS & X86_EFLAGS_VIP)
 		return_to_32bit(regs, VM86_STI);
 }
 
 static inline void clear_IF(struct kernel_vm86_regs *regs)
 {
-	VEFLAGS &= ~VIF_MASK;
+	VEFLAGS &= ~X86_EFLAGS_VIF;
 }
 
 static inline void clear_TF(struct kernel_vm86_regs *regs)
 {
-	regs->pt.flags &= ~TF_MASK;
+	regs->pt.flags &= ~X86_EFLAGS_TF;
 }
 
 static inline void clear_AC(struct kernel_vm86_regs *regs)
 {
-	regs->pt.flags &= ~AC_MASK;
+	regs->pt.flags &= ~X86_EFLAGS_AC;
 }
 
 /*
@@ -399,7 +399,7 @@ static inline void set_vflags_long(unsig
 {
 	set_flags(VEFLAGS, flags, current->thread.v86mask);
 	set_flags(regs->pt.flags, flags, SAFE_MASK);
-	if (flags & IF_MASK)
+	if (flags & X86_EFLAGS_IF)
 		set_IF(regs);
 	else
 		clear_IF(regs);
@@ -409,7 +409,7 @@ static inline void set_vflags_short(unsi
 {
 	set_flags(VFLAGS, flags, current->thread.v86mask);
 	set_flags(regs->pt.flags, flags, SAFE_MASK);
-	if (flags & IF_MASK)
+	if (flags & X86_EFLAGS_IF)
 		set_IF(regs);
 	else
 		clear_IF(regs);
@@ -419,9 +419,9 @@ static inline unsigned long get_vflags(s
 {
 	unsigned long flags = regs->pt.flags & RETURN_MASK;
 
-	if (VEFLAGS & VIF_MASK)
-		flags |= IF_MASK;
-	flags |= IOPL_MASK;
+	if (VEFLAGS & X86_EFLAGS_VIF)
+		flags |= X86_EFLAGS_IF;
+	flags |= X86_EFLAGS_IOPL;
 	return flags | (VEFLAGS & current->thread.v86mask);
 }
 
@@ -573,11 +573,11 @@ void handle_vm86_fault(struct kernel_vm8
 
 #define CHECK_IF_IN_TRAP \
 	if (VMPI.vm86dbg_active && VMPI.vm86dbg_TFpendig) \
-		newflags |= TF_MASK
+		newflags |= X86_EFLAGS_TF
 #define VM86_FAULT_RETURN do { \
-	if (VMPI.force_return_for_pic  && (VEFLAGS & (IF_MASK | VIF_MASK))) \
+	if (VMPI.force_return_for_pic  && (VEFLAGS & (X86_EFLAGS_IF | X86_EFLAGS_VIF))) \
 		return_to_32bit(regs, VM86_PICRETURN); \
-	if (orig_flags & TF_MASK) \
+	if (orig_flags & X86_EFLAGS_TF) \
 		handle_vm86_trap(regs, 0, 1); \
 	return; } while (0)
 
Index: linux-2.6.git/include/asm-x86/vm86.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/vm86.h	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/include/asm-x86/vm86.h	2008-03-27 21:44:15.000000000 +0300
@@ -12,19 +12,13 @@
  * Linus
  */
 
-#define TF_MASK		0x00000100
-#define IF_MASK		0x00000200
-#define IOPL_MASK	0x00003000
-#define NT_MASK		0x00004000
+#include <asm/processor-flags.h>
+
 #ifdef CONFIG_VM86
 #define VM_MASK		0x00020000
 #else
 #define VM_MASK		0 /* ignored */
 #endif
-#define AC_MASK		0x00040000
-#define VIF_MASK	0x00080000	/* virtual interrupt flag */
-#define VIP_MASK	0x00100000	/* virtual interrupt pending */
-#define ID_MASK		0x00200000
 
 #define BIOSSEG		0x0f000
 
Index: linux-2.6.git/arch/x86/mm/kmmio.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/kmmio.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/x86/mm/kmmio.c	2008-03-27 22:03:20.000000000 +0300
@@ -278,7 +278,7 @@ int kmmio_handler(struct pt_regs *regs, 
 
 	ctx->fpage = faultpage;
 	ctx->probe = get_kmmio_probe(addr);
-	ctx->saved_flags = (regs->flags & (TF_MASK|IF_MASK));
+	ctx->saved_flags = (regs->flags & (X86_EFLAGS_TF | X86_EFLAGS_IF));
 	ctx->addr = addr;
 
 	if (ctx->probe && ctx->probe->pre_handler)
@@ -288,8 +288,8 @@ int kmmio_handler(struct pt_regs *regs, 
 	 * Enable single-stepping and disable interrupts for the faulting
 	 * context. Local interrupts must not get enabled during stepping.
 	 */
-	regs->flags |= TF_MASK;
-	regs->flags &= ~IF_MASK;
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
 
 	/* Now we set present bit in PTE and single step. */
 	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
@@ -330,7 +330,7 @@ static int post_kmmio_handler(unsigned l
 
 	arm_kmmio_fault_page(ctx->fpage->page, NULL);
 
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~X86_EFLAGS_TF;
 	regs->flags |= ctx->saved_flags;
 
 	/* These were acquired in kmmio_handler(). */
@@ -344,7 +344,7 @@ static int post_kmmio_handler(unsigned l
 	 * will have TF set, in which case, continue the remaining processing
 	 * of do_debug, as if this is not a probe hit.
 	 */
-	if (!(regs->flags & TF_MASK))
+	if (!(regs->flags & X86_EFLAGS_TF))
 		ret = 1;
 out:
 	put_cpu_var(kmmio_ctx);
Index: linux-2.6.git/arch/x86/kernel/kmemcheck_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/kmemcheck_32.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/kmemcheck_32.c	2008-03-27 22:05:57.000000000 +0300
@@ -346,11 +346,11 @@ kmemcheck_show(struct pt_regs *regs)
 	 * NOTE: In the rare case of multiple faults, we must not override
 	 * the original flags:
 	 */
-	if (!(regs->flags & TF_MASK))
+	if (!(regs->flags & X86_EFLAGS_TF))
 		__get_cpu_var(kmemcheck_reg_flags) = regs->flags;
 
-	regs->flags |= TF_MASK;
-	regs->flags &= ~IF_MASK;
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
 }
 
 /*
@@ -372,10 +372,10 @@ kmemcheck_hide(struct pt_regs *regs)
 		__get_cpu_var(kmemcheck_addr2) = 0;
 		__get_cpu_var(kmemcheck_balance) = 0;
 
-		if (!(__get_cpu_var(kmemcheck_reg_flags) & TF_MASK))
-			regs->flags &= ~TF_MASK;
-		if (__get_cpu_var(kmemcheck_reg_flags) & IF_MASK)
-			regs->flags |= IF_MASK;
+		if (!(__get_cpu_var(kmemcheck_reg_flags) & X86_EFLAGS_TF))
+			regs->flags &= ~X86_EFLAGS_TF;
+		if (__get_cpu_var(kmemcheck_reg_flags) & X86_EFLAGS_IF)
+			regs->flags |= X86_EFLAGS_IF;
 		return;
 	}
 
@@ -384,10 +384,10 @@ kmemcheck_hide(struct pt_regs *regs)
 	__get_cpu_var(kmemcheck_addr1) = 0;
 	__get_cpu_var(kmemcheck_addr2) = 0;
 
-	if (!(__get_cpu_var(kmemcheck_reg_flags) & TF_MASK))
-		regs->flags &= ~TF_MASK;
-	if (__get_cpu_var(kmemcheck_reg_flags) & IF_MASK)
-		regs->flags |= IF_MASK;
+	if (!(__get_cpu_var(kmemcheck_reg_flags) & X86_EFLAGS_TF))
+		regs->flags &= ~X86_EFLAGS_TF;
+	if (__get_cpu_var(kmemcheck_reg_flags) & X86_EFLAGS_IF)
+		regs->flags |= X86_EFLAGS_IF;
 }
 
 void
Index: linux-2.6.git/arch/ia64/ia32/ia32_signal.c
===================================================================
--- linux-2.6.git.orig/arch/ia64/ia32/ia32_signal.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/ia64/ia32/ia32_signal.c	2008-03-27 22:10:33.000000000 +0300
@@ -839,7 +839,7 @@ setup_frame_ia32 (int sig, struct k_siga
 	set_fs(USER_DS);
 
 #if 0
-	regs->eflags &= ~TF_MASK;
+	regs->eflags &= ~X86_EFLAGS_TF;
 #endif
 
 #if 0
@@ -917,7 +917,7 @@ setup_rt_frame_ia32 (int sig, struct k_s
 	set_fs(USER_DS);
 
 #if 0
-	regs->eflags &= ~TF_MASK;
+	regs->eflags &= ~X86_EFLAGS_TF;
 #endif
 
 #if 0
Index: linux-2.6.git/arch/x86/kernel/kgdb.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/kgdb.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/kgdb.c	2008-03-27 22:07:54.000000000 +0300
@@ -371,12 +371,12 @@ int kgdb_arch_handle_exception(int e_vec
 		newPC = linux_regs->ip;
 
 		/* clear the trace bit */
-		linux_regs->flags &= ~TF_MASK;
+		linux_regs->flags &= ~X86_EFLAGS_TF;
 		atomic_set(&kgdb_cpu_doing_single_step, -1);
 
 		/* set the trace bit if we're stepping */
 		if (remcomInBuffer[0] == 's') {
-			linux_regs->flags |= TF_MASK;
+			linux_regs->flags |= X86_EFLAGS_TF;
 			kgdb_single_step = 1;
 			if (kgdb_contthread) {
 				atomic_set(&kgdb_cpu_doing_single_step,
Index: linux-2.6.git/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/kprobes.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/kprobes.c	2008-03-27 22:08:32.000000000 +0300
@@ -489,7 +489,7 @@ static int __kprobes reenter_kprobe(stru
 		break;
 	case KPROBE_HIT_SS:
 		if (p == kprobe_running()) {
-			regs->flags &= ~TF_MASK;
+			regs->flags &= ~X86_EFLAGS_TF;
 			regs->flags |= kcb->kprobe_saved_flags;
 			return 0;
 		} else {
Index: linux-2.6.git/arch/x86/kernel/signal_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/signal_32.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/signal_32.c	2008-03-27 22:09:11.000000000 +0300
@@ -419,7 +419,7 @@ setup_frame(int sig, struct k_sigaction 
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -507,7 +507,7 @@ static int setup_rt_frame(int sig, struc
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 

-- 
