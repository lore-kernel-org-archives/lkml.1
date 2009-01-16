Return-Path: <linux-kernel-owner+w=401wt.eu-S936209AbZAPO1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936209AbZAPO1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936126AbZAPOY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:24:57 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:17214 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935814AbZAPOYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:24:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KeshCxlElTzoXZ3/5i1yhvqlfxqQQaFd3xJdrshAyfo7UnY2DsA0AEEpY8DxxjbVY0
         vl/wuWZxxIbgstzQyhWBzgzA9eiHlQE1jNvyscYj0s61sZh1Z5RBhB+VFiLTh9eukVx/
         TGop5WGRmvSgDFupL05MH4HOPO01HDWYMDqKQ=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 08/17] x86-64: Move oldrsp from PDA to per-cpu.
Date: Fri, 16 Jan 2009 09:16:27 -0500
Message-Id: <1232115396-26367-8-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-7-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h       |    2 +-
 arch/x86/kernel/asm-offsets_64.c |    2 --
 arch/x86/kernel/entry_64.S       |    8 ++++----
 arch/x86/kernel/process_64.c     |    8 +++++---
 arch/x86/xen/xen-asm_64.S        |    8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)

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
index cafff5f..6a13983 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -11,7 +11,6 @@
 #include <linux/hardirq.h>
 #include <linux/suspend.h>
 #include <linux/kbuild.h>
-#include <asm/pda.h>
 #include <asm/processor.h>
 #include <asm/segment.h>
 #include <asm/thread_info.h>
@@ -49,7 +48,6 @@ int main(void)
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	ENTRY(oldrsp); 
 	ENTRY(irqcount);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8f35796..1331fd2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -210,7 +210,7 @@ ENTRY(native_usergs_sysret64)
 
 	/* %rsp:at FRAMEEND */
 	.macro FIXUP_TOP_OF_STACK tmp offset=0
-	movq %gs:pda_oldrsp,\tmp
+	movq PER_CPU_VAR(oldrsp),\tmp
 	movq \tmp,RSP+\offset(%rsp)
 	movq $__USER_DS,SS+\offset(%rsp)
 	movq $__USER_CS,CS+\offset(%rsp)
@@ -221,7 +221,7 @@ ENTRY(native_usergs_sysret64)
 
 	.macro RESTORE_TOP_OF_STACK tmp offset=0
 	movq RSP+\offset(%rsp),\tmp
-	movq \tmp,%gs:pda_oldrsp
+	movq \tmp,PER_CPU_VAR(oldrsp)
 	movq EFLAGS+\offset(%rsp),\tmp
 	movq \tmp,R11+\offset(%rsp)
 	.endm
@@ -479,7 +479,7 @@ ENTRY(system_call)
 	 */
 ENTRY(system_call_after_swapgs)
 
-	movq	%rsp,%gs:pda_oldrsp
+	movq	%rsp,PER_CPU_VAR(oldrsp)
 	movq	PER_CPU_VAR(kernelstack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
@@ -523,7 +523,7 @@ sysret_check:
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	movq	%gs:pda_oldrsp, %rsp
+	movq	PER_CPU_VAR(oldrsp), %rsp
 	USERGS_SYSRET64
 
 	CFI_RESTORE_STATE
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2f5bb4d..d4a7391 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -60,6 +60,8 @@ asmlinkage extern void ret_from_fork(void);
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
+DEFINE_PER_CPU(unsigned long, oldrsp);
+
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
@@ -395,7 +397,7 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	write_pda(oldrsp, new_sp);
+	percpu_write(oldrsp, new_sp);
 	regs->cs		= __USER_CS;
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
@@ -616,8 +618,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = read_pda(oldrsp);
-	write_pda(oldrsp, next->usersp);
+	prev->usersp = percpu_read(oldrsp);
+	percpu_write(oldrsp, next->usersp);
 	percpu_write(current_task, next_p);
 
 	percpu_write(kernelstack,
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index eac2794..16d3bfb 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -195,11 +195,11 @@ RELOC(xen_sysexit, 1b+1)
 ENTRY(xen_sysret64)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
-	movq %rsp, %gs:pda_oldrsp
+	movq %rsp, PER_CPU_VAR(oldrsp)
 	movq PER_CPU_VAR(kernelstack),%rsp
 
 	pushq $__USER_DS
-	pushq %gs:pda_oldrsp
+	pushq PER_CPU_VAR(oldrsp)
 	pushq %r11
 	pushq $__USER_CS
 	pushq %rcx
@@ -212,11 +212,11 @@ RELOC(xen_sysret64, 1b+1)
 ENTRY(xen_sysret32)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
-	movq %rsp, %gs:pda_oldrsp
+	movq %rsp, PER_CPU_VAR(oldrsp)
 	movq PER_CPU_VAR(kernelstack), %rsp
 
 	pushq $__USER32_DS
-	pushq %gs:pda_oldrsp
+	pushq PER_CPU_VAR(oldrsp)
 	pushq %r11
 	pushq $__USER32_CS
 	pushq %rcx
-- 
1.6.1.rc1

