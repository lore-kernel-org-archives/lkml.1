Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbZARQks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbZARQks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759739AbZARQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:55196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361AbZARQjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:36 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] x86-64: Move current task from PDA to per-cpu and consolidate with 32-bit.
Date: Mon, 19 Jan 2009 01:39:13 +0900
Message-Id: <1232296759-2253-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/current.h   |   24 +++---------------------
 arch/x86/include/asm/pda.h       |    4 ++--
 arch/x86/include/asm/system.h    |    4 ++--
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |    5 +----
 arch/x86/kernel/dumpstack_64.c   |    2 +-
 arch/x86/kernel/process_64.c     |    5 ++++-
 arch/x86/kernel/smpboot.c        |    3 +--
 arch/x86/xen/smp.c               |    3 +--
 9 files changed, 15 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index 0728480..c68c361 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -1,39 +1,21 @@
 #ifndef _ASM_X86_CURRENT_H
 #define _ASM_X86_CURRENT_H
 
-#ifdef CONFIG_X86_32
 #include <linux/compiler.h>
 #include <asm/percpu.h>
 
+#ifndef __ASSEMBLY__
 struct task_struct;
 
 DECLARE_PER_CPU(struct task_struct *, current_task);
-static __always_inline struct task_struct *get_current(void)
-{
-	return percpu_read(current_task);
-}
-
-#else /* X86_32 */
-
-#ifndef __ASSEMBLY__
-#include <asm/pda.h>
-
-struct task_struct;
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return read_pda(pcurrent);
+	return percpu_read(current_task);
 }
 
-#else /* __ASSEMBLY__ */
-
-#include <asm/asm-offsets.h>
-#define GET_CURRENT(reg) movq %gs:(pda_pcurrent),reg
+#define current get_current()
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* X86_32 */
-
-#define current get_current()
-
 #endif /* _ASM_X86_CURRENT_H */
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 668d5a5..7209302 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -11,8 +11,8 @@
 
 /* Per processor datastructure. %gs points to it while the kernel runs */
 struct x8664_pda {
-	struct task_struct *pcurrent;	/* 0  Current process */
-	unsigned long dummy;
+	unsigned long unused1;
+	unsigned long unused2;
 	unsigned long kernelstack;	/* 16 top of kernel stack for current */
 	unsigned long oldrsp;		/* 24 user rsp for system call */
 	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 8e626ea..4399aac 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -94,7 +94,7 @@ do {									\
 	     "call __switch_to\n\t"					  \
 	     ".globl thread_return\n"					  \
 	     "thread_return:\n\t"					  \
-	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
+	     "movq "__percpu_seg_str"%P[current_task],%%rsi\n\t"	  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
@@ -106,7 +106,7 @@ do {									\
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
 	       [tif_fork] "i" (TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
+	       [current_task] "m" (per_cpu_var(current_task))		  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index cae6697..4f7a210 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -51,7 +51,6 @@ int main(void)
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
 	ENTRY(kernelstack); 
 	ENTRY(oldrsp); 
-	ENTRY(pcurrent); 
 	ENTRY(irqcount);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4221e92..b50e38d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -903,10 +903,7 @@ void __cpuinit pda_init(int cpu)
 	pda->kernelstack = (unsigned long)stack_thread_info() -
 				 PDA_STACKOFFSET + THREAD_SIZE;
 
-	if (cpu == 0) {
-		/* others are initialized in smpboot.c */
-		pda->pcurrent = &init_task;
-	} else {
+	if (cpu != 0) {
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
 	}
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 28e26a4..d35db59 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -242,7 +242,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 	unsigned long sp;
 	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+	struct task_struct *cur = current;
 
 	sp = regs->sp;
 	printk("CPU %d ", cpu);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 416fb92..e00c31a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -57,6 +57,9 @@
 
 asmlinkage extern void ret_from_fork(void);
 
+DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);
+
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
@@ -615,7 +618,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	prev->usersp = read_pda(oldrsp);
 	write_pda(oldrsp, next->usersp);
-	write_pda(pcurrent, next_p);
+	percpu_write(current_task, next_p);
 
 	write_pda(kernelstack,
 		  (unsigned long)task_stack_page(next_p) +
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2f0e0f1..5854be0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -790,13 +790,12 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 
 	set_idle_for_cpu(cpu, c_idle.idle);
 do_rest:
-#ifdef CONFIG_X86_32
 	per_cpu(current_task, cpu) = c_idle.idle;
+#ifdef CONFIG_X86_32
 	init_gdt(cpu);
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
 #endif
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 9ff3b09..72c2eb9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -279,12 +279,11 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
 
+	per_cpu(current_task, cpu) = idle;
 #ifdef CONFIG_X86_32
 	init_gdt(cpu);
-	per_cpu(current_task, cpu) = idle;
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = idle;
 	clear_tsk_thread_flag(idle, TIF_FORK);
 #endif
 	xen_setup_timer(cpu);
-- 
1.6.0.2

