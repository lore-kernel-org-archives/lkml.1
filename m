Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbZARQl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbZARQl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760479AbZARQji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:55198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759598AbZARQjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:37 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/12] x86-64: Convert irqstacks to per-cpu
Date: Mon, 19 Jan 2009 01:39:10 +0900
Message-Id: <1232296759-2253-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Move the irqstackptr variable from the PDA to per-cpu.  Make the
stacks themselves per-cpu, removing some specific allocation code.
Add a seperate flag (is_boot_cpu) to simplify the per-cpu boot
adjustments.

tj: * sprinkle some underbars around.

    * irq_stack_ptr is not used till traps_init(), no reason to
      initialize it early.  On SMP, just leaving it NULL till proper
      initialization in setup_per_cpu_areas() works.  Dropped
      is_boot_cpu and early irq_stack_ptr initialization.

    * do DECLARE/DEFINE_PER_CPU(char[IRQ_STACK_SIZE], irq_stack)
      instead of (char, irq_stack[IRQ_STACK_SIZE]).

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/page_64.h   |    4 ++--
 arch/x86/include/asm/pda.h       |    1 -
 arch/x86/include/asm/processor.h |    3 +++
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/cpu/common.c     |   19 +++++++------------
 arch/x86/kernel/dumpstack_64.c   |   33 +++++++++++++++++----------------
 arch/x86/kernel/entry_64.S       |    6 +++---
 arch/x86/kernel/setup_percpu.c   |    4 +++-
 8 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 5ebca29..e27fdbe 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -13,8 +13,8 @@
 #define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
 #define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
 
-#define IRQSTACK_ORDER 2
-#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
+#define IRQ_STACK_ORDER 2
+#define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
 #define STACKFAULT_STACK 1
 #define DOUBLEFAULT_STACK 2
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 8ee835e..09965f7 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -22,7 +22,6 @@ struct x8664_pda {
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 #endif
-	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
 	short in_bootmem;		/* pda lives in bootmem */
 	short isidle;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 091cd88..f511246 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -378,6 +378,9 @@ union thread_xstate {
 
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
+
+DECLARE_PER_CPU(char[IRQ_STACK_SIZE], irq_stack);
+DECLARE_PER_CPU(char *, irq_stack_ptr);
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index f4cc81b..5b821fb 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -54,7 +54,6 @@ int main(void)
 	ENTRY(pcurrent); 
 	ENTRY(irqcount);
 	ENTRY(cpunumber);
-	ENTRY(irqstackptr);
 	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3d0cc6f..496f0a0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -881,7 +881,13 @@ __setup("clearcpuid=", setup_disablecpuid);
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-static char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
+DEFINE_PER_CPU_PAGE_ALIGNED(char[IRQ_STACK_SIZE], irq_stack);
+#ifdef CONFIG_SMP
+DEFINE_PER_CPU(char *, irq_stack_ptr);	/* will be set during per cpu init */
+#else
+DEFINE_PER_CPU(char *, irq_stack_ptr) =
+	per_cpu_var(irq_stack) + IRQ_STACK_SIZE - 64;
+#endif
 
 void __cpuinit pda_init(int cpu)
 {
@@ -901,18 +907,7 @@ void __cpuinit pda_init(int cpu)
 	if (cpu == 0) {
 		/* others are initialized in smpboot.c */
 		pda->pcurrent = &init_task;
-		pda->irqstackptr = boot_cpu_stack;
-		pda->irqstackptr += IRQSTACKSIZE - 64;
 	} else {
-		if (!pda->irqstackptr) {
-			pda->irqstackptr = (char *)
-				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-			if (!pda->irqstackptr)
-				panic("cannot allocate irqstack for cpu %d",
-				      cpu);
-			pda->irqstackptr += IRQSTACKSIZE - 64;
-		}
-
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
 	}
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index c302d07..28e26a4 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -106,7 +106,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irq_stack_end =
+		(unsigned long *)per_cpu(irq_stack_ptr, cpu);
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
@@ -160,23 +161,23 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			stack = (unsigned long *) estack_end[-2];
 			continue;
 		}
-		if (irqstack_end) {
-			unsigned long *irqstack;
-			irqstack = irqstack_end -
-				(IRQSTACKSIZE - 64) / sizeof(*irqstack);
+		if (irq_stack_end) {
+			unsigned long *irq_stack;
+			irq_stack = irq_stack_end -
+				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
 
-			if (stack >= irqstack && stack < irqstack_end) {
+			if (stack >= irq_stack && stack < irq_stack_end) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
 				bp = print_context_stack(tinfo, stack, bp,
-					ops, data, irqstack_end, &graph);
+					ops, data, irq_stack_end, &graph);
 				/*
 				 * We link to the next stack (which would be
 				 * the process stack normally) the last
 				 * pointer (index -1 to end) in the IRQ stack:
 				 */
-				stack = (unsigned long *) (irqstack_end[-1]);
-				irqstack_end = NULL;
+				stack = (unsigned long *) (irq_stack_end[-1]);
+				irq_stack_end = NULL;
 				ops->stack(data, "EOI");
 				continue;
 			}
@@ -199,10 +200,10 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	unsigned long *stack;
 	int i;
 	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+	unsigned long *irq_stack_end =
+		(unsigned long *)(per_cpu(irq_stack_ptr, cpu));
+	unsigned long *irq_stack =
+		(unsigned long *)(per_cpu(irq_stack_ptr, cpu) - IRQ_STACK_SIZE);
 
 	/*
 	 * debugging aid: "show_stack(NULL, NULL);" prints the
@@ -218,9 +219,9 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 
 	stack = sp;
 	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (stack >= irqstack && stack <= irqstack_end) {
-			if (stack == irqstack_end) {
-				stack = (unsigned long *) (irqstack_end[-1]);
+		if (stack >= irq_stack && stack <= irq_stack_end) {
+			if (stack == irq_stack_end) {
+				stack = (unsigned long *) (irq_stack_end[-1]);
 				printk(" <EOI> ");
 			}
 		} else {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4833f3a..d22677a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -345,7 +345,7 @@ ENTRY(save_args)
 1:	incl %gs:pda_irqcount
 	jne 2f
 	popq_cfi %rax			/* move return address... */
-	mov %gs:pda_irqstackptr,%rsp
+	mov PER_CPU_VAR(irq_stack_ptr),%rsp
 	EMPTY_FRAME 0
 	pushq_cfi %rax			/* ... to the new stack */
 	/*
@@ -1261,7 +1261,7 @@ ENTRY(call_softirq)
 	mov  %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
 	incl %gs:pda_irqcount
-	cmove %gs:pda_irqstackptr,%rsp
+	cmove PER_CPU_VAR(irq_stack_ptr),%rsp
 	push  %rbp			# backlink for old unwinder
 	call __do_softirq
 	leaveq
@@ -1300,7 +1300,7 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 11:	incl %gs:pda_irqcount
 	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	cmovzq %gs:pda_irqstackptr,%rsp
+	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
 	pushq %rbp			# backlink for old unwinder
 	call xen_evtchn_do_upcall
 	popq %rsp
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index b5c35af..8b53ef8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -192,7 +192,10 @@ void __init setup_per_cpu_areas(void)
 
 		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
+		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 #ifdef CONFIG_X86_64
+		per_cpu(irq_stack_ptr, cpu) =
+			(char *)per_cpu(irq_stack, cpu) + IRQ_STACK_SIZE - 64;
 		/*
 		 * CPU0 modified pda in the init data area, reload pda
 		 * offset for CPU0 and clear the area for others.
@@ -202,7 +205,6 @@ void __init setup_per_cpu_areas(void)
 		else
 			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
 #endif
-		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
-- 
1.6.0.2

