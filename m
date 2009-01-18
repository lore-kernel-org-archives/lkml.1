Return-Path: <linux-kernel-owner+w=401wt.eu-S934251AbZARQls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbZARQls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbZARQjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:55200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022AbZARQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:38 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/12] x86-64: Move oldrsp from PDA to per-cpu.
Date: Mon, 19 Jan 2009 01:39:15 +0900
Message-Id: <1232296759-2253-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

tj: * in asm-offsets_64.c, pda.h inclusion shouldn't be removed as pda
      is still referenced in the file
    * s/oldrsp/old_rsp/

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/entry_64.S       |   10 +++++-----
 arch/x86/kernel/process_64.c     |    8 +++++---
 arch/x86/xen/xen-asm_64.S        |    8 ++++----
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 4d28ffb..ae23deb 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -14,7 +14,7 @@ struct x8664_pda {
 	unsigned long unused1;
 	unsigned long unused2;
 	unsigned long unused3;
-	unsigned long oldrsp;		/* 24 user rsp for system call */
+	unsigned long unused4;
 	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
 	unsigned int unused6;		/* 36 was cpunumber */
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index cafff5f..afda6de 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -49,7 +49,6 @@ int main(void)
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	ENTRY(oldrsp); 
 	ENTRY(irqcount);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0dd4585..7c27da4 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -210,7 +210,7 @@ ENTRY(native_usergs_sysret64)
 
 	/* %rsp:at FRAMEEND */
 	.macro FIXUP_TOP_OF_STACK tmp offset=0
-	movq %gs:pda_oldrsp,\tmp
+	movq PER_CPU_VAR(old_rsp),\tmp
 	movq \tmp,RSP+\offset(%rsp)
 	movq $__USER_DS,SS+\offset(%rsp)
 	movq $__USER_CS,CS+\offset(%rsp)
@@ -221,7 +221,7 @@ ENTRY(native_usergs_sysret64)
 
 	.macro RESTORE_TOP_OF_STACK tmp offset=0
 	movq RSP+\offset(%rsp),\tmp
-	movq \tmp,%gs:pda_oldrsp
+	movq \tmp,PER_CPU_VAR(old_rsp)
 	movq EFLAGS+\offset(%rsp),\tmp
 	movq \tmp,R11+\offset(%rsp)
 	.endm
@@ -479,7 +479,7 @@ ENTRY(system_call)
 	 */
 ENTRY(system_call_after_swapgs)
 
-	movq	%rsp,%gs:pda_oldrsp
+	movq	%rsp,PER_CPU_VAR(old_rsp)
 	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
@@ -523,7 +523,7 @@ sysret_check:
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	movq	%gs:pda_oldrsp, %rsp
+	movq	PER_CPU_VAR(old_rsp), %rsp
 	USERGS_SYSRET64
 
 	CFI_RESTORE_STATE
@@ -833,7 +833,7 @@ common_interrupt:
 	XCPT_FRAME
 	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	interrupt do_IRQ
-	/* 0(%rsp): oldrsp-ARGOFFSET */
+	/* 0(%rsp): old_rsp-ARGOFFSET */
 ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6c5f576..4801289 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -60,6 +60,8 @@ asmlinkage extern void ret_from_fork(void);
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
+DEFINE_PER_CPU(unsigned long, old_rsp);
+
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
@@ -395,7 +397,7 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	write_pda(oldrsp, new_sp);
+	percpu_write(old_rsp, new_sp);
 	regs->cs		= __USER_CS;
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
@@ -616,8 +618,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = read_pda(oldrsp);
-	write_pda(oldrsp, next->usersp);
+	prev->usersp = percpu_read(old_rsp);
+	percpu_write(old_rsp, next->usersp);
 	percpu_write(current_task, next_p);
 
 	percpu_write(kernel_stack,
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 5a23e89..d6fc51f 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -194,11 +194,11 @@ RELOC(xen_sysexit, 1b+1)
 ENTRY(xen_sysret64)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
-	movq %rsp, %gs:pda_oldrsp
+	movq %rsp, PER_CPU_VAR(old_rsp)
 	movq PER_CPU_VAR(kernel_stack),%rsp
 
 	pushq $__USER_DS
-	pushq %gs:pda_oldrsp
+	pushq PER_CPU_VAR(old_rsp)
 	pushq %r11
 	pushq $__USER_CS
 	pushq %rcx
@@ -211,11 +211,11 @@ RELOC(xen_sysret64, 1b+1)
 ENTRY(xen_sysret32)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
-	movq %rsp, %gs:pda_oldrsp
+	movq %rsp, PER_CPU_VAR(old_rsp)
 	movq PER_CPU_VAR(kernel_stack), %rsp
 
 	pushq $__USER32_DS
-	pushq %gs:pda_oldrsp
+	pushq PER_CPU_VAR(old_rsp)
 	pushq %r11
 	pushq $__USER32_CS
 	pushq %rcx
-- 
1.6.0.2

