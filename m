Return-Path: <linux-kernel-owner+w=401wt.eu-S935705AbZAPORo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705AbZAPORo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933999AbZAPOQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:47 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:46175 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152AbZAPOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LQAhmY/vSYIqlgUZgkOa2I4ehUdTt5JbYHjBydGJD1G32l6CLm5KZfB0iKdRUKkOrO
         t2Vech2TTT4BL045M5G8e0QkPqg4g4rNk2GN5h78/Mw585W3BRmag6X6R0pSlJJVIAET
         p/b0B1pQ6Nuq4Z4YJ5J22UP4Pu2aVWpd5ByTY=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 06/17] x86-64: Move current task from PDA to per-cpu and consolidate with 32-bit.
Date: Fri, 16 Jan 2009 09:16:25 -0500
Message-Id: <1232115396-26367-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-5-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
index 1cf466f..fbc8468 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -898,10 +898,7 @@ void __cpuinit pda_init(int cpu)
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
index 46c6bf0..0c01ad2 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -241,7 +241,7 @@ void show_registers(struct pt_regs *regs)
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
index a33da98..ecc2fc5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -792,13 +792,12 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 
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
1.6.1.rc1

