Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYLYU74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYLYU74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYLYU7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:59:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51752 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbYLYU7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:59:03 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: drop the use of the tss interrupt stack table (IST)
Date: Thu, 25 Dec 2008 22:58:44 +0200
Message-Id: <1230238726-17506-2-git-send-email-avi@redhat.com>
In-Reply-To: <1230238726-17506-1-git-send-email-avi@redhat.com>
References: <1230238726-17506-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IST is the only thing that requires a valid TSS while running in
kernel mode.  Dropping its use unlocks an optimization opportunity for
kvm: if we don't need a valid TSS while in kernel mode we can defer the
use of the VMLOAD/VMSAVE instructions until the next context switch,
reducing the executions of these costly instructions by a nice factor.

Kernel reliability should also be improved since interrupt paths are
simplified.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/desc.h      |   12 -----
 arch/x86/include/asm/page_64.h   |    7 ---
 arch/x86/include/asm/processor.h |   11 ----
 arch/x86/kernel/cpu/common.c     |   34 -------------
 arch/x86/kernel/dumpstack_64.c   |   96 --------------------------------------
 arch/x86/kernel/entry_64.S       |   17 ++-----
 arch/x86/kernel/traps.c          |   12 ++--
 7 files changed, 10 insertions(+), 179 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index e6b82b1..0465c75 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -369,18 +369,6 @@ static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
 	_set_gate(n, GATE_TASK, (void *)0, 0, 0, (gdt_entry<<3));
 }
 
-static inline void set_intr_gate_ist(int n, void *addr, unsigned ist)
-{
-	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0, ist, __KERNEL_CS);
-}
-
-static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
-{
-	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
-}
-
 #else
 /*
  * GET_DESC_BASE reads the descriptor base of the specified segment.
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 5ebca29..7c89095 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -16,13 +16,6 @@
 #define IRQSTACK_ORDER 2
 #define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
 
-#define STACKFAULT_STACK 1
-#define DOUBLEFAULT_STACK 2
-#define NMI_STACK 3
-#define DEBUG_STACK 4
-#define MCE_STACK 5
-#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
-
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 5ca01e3..4ef899c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -273,13 +273,6 @@ struct tss_struct {
 
 DECLARE_PER_CPU(struct tss_struct, init_tss);
 
-/*
- * Save the original ist values for checking stack pointers during debugging
- */
-struct orig_ist {
-	unsigned long		ist[7];
-};
-
 #define	MXCSR_DEFAULT		0x1f80
 
 struct i387_fsave_struct {
@@ -372,10 +365,6 @@ union thread_xstate {
 	struct xsave_struct		xsave;
 };
 
-#ifdef CONFIG_X86_64
-DECLARE_PER_CPU(struct orig_ist, orig_ist);
-#endif
-
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b9c9ea0..8563c51 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -903,9 +903,6 @@ void __cpuinit pda_init(int cpu)
 	}
 }
 
-char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-			   DEBUG_STKSZ] __page_aligned_bss;
-
 extern asmlinkage void ignore_sysret(void);
 
 /* May not be marked __init: used by software suspend */
@@ -931,12 +928,6 @@ void syscall_init(void)
 
 unsigned long kernel_eflags;
 
-/*
- * Copies of the original ist values from the tss are only accessed during
- * debugging, no special alignment required.
- */
-DEFINE_PER_CPU(struct orig_ist, orig_ist);
-
 #else
 
 /* Make sure %fs is initialized properly in idle threads */
@@ -960,17 +951,13 @@ void __cpuinit cpu_init(void)
 {
 	int cpu = stack_smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
-	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
 	unsigned long v;
-	char *estacks = NULL;
 	struct task_struct *me;
 	int i;
 
 	/* CPU 0 is initialised in head64.c */
 	if (cpu != 0)
 		pda_init(cpu);
-	else
-		estacks = boot_exception_stacks;
 
 	me = current;
 
@@ -1000,27 +987,6 @@ void __cpuinit cpu_init(void)
 	if (cpu != 0 && x2apic)
 		enable_x2apic();
 
-	/*
-	 * set up and load the per-CPU TSS
-	 */
-	if (!orig_ist->ist[0]) {
-		static const unsigned int order[N_EXCEPTION_STACKS] = {
-		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
-		};
-		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-			if (cpu) {
-				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-				if (!estacks)
-					panic("Cannot allocate exception "
-					      "stack %ld %d\n", v, cpu);
-			}
-			estacks += PAGE_SIZE << order[v];
-			orig_ist->ist[v] = t->x86_tss.ist[v] =
-					(unsigned long)estacks;
-		}
-	}
-
 	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
 	/*
 	 * <= is required because the CPU will access up to
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 96a5db7..a1be9af 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -31,81 +31,6 @@ void printk_address(unsigned long address, int reliable)
 			reliable ? "" : "? ", (void *) address);
 }
 
-static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-					unsigned *usedp, char **idp)
-{
-	static char ids[][8] = {
-		[DEBUG_STACK - 1] = "#DB",
-		[NMI_STACK - 1] = "NMI",
-		[DOUBLEFAULT_STACK - 1] = "#DF",
-		[STACKFAULT_STACK - 1] = "#SS",
-		[MCE_STACK - 1] = "#MC",
-#if DEBUG_STKSZ > EXCEPTION_STKSZ
-		[N_EXCEPTION_STACKS ...
-			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
-#endif
-	};
-	unsigned k;
-
-	/*
-	 * Iterate over all exception stacks, and figure out whether
-	 * 'stack' is in one of them:
-	 */
-	for (k = 0; k < N_EXCEPTION_STACKS; k++) {
-		unsigned long end = per_cpu(orig_ist, cpu).ist[k];
-		/*
-		 * Is 'stack' above this exception frame's end?
-		 * If yes then skip to the next frame.
-		 */
-		if (stack >= end)
-			continue;
-		/*
-		 * Is 'stack' above this exception frame's start address?
-		 * If yes then we found the right frame.
-		 */
-		if (stack >= end - EXCEPTION_STKSZ) {
-			/*
-			 * Make sure we only iterate through an exception
-			 * stack once. If it comes up for the second time
-			 * then there's something wrong going on - just
-			 * break out and return NULL:
-			 */
-			if (*usedp & (1U << k))
-				break;
-			*usedp |= 1U << k;
-			*idp = ids[k];
-			return (unsigned long *)end;
-		}
-		/*
-		 * If this is a debug stack, and if it has a larger size than
-		 * the usual exception stacks, then 'stack' might still
-		 * be within the lower portion of the debug stack:
-		 */
-#if DEBUG_STKSZ > EXCEPTION_STKSZ
-		if (k == DEBUG_STACK - 1 && stack >= end - DEBUG_STKSZ) {
-			unsigned j = N_EXCEPTION_STACKS - 1;
-
-			/*
-			 * Black magic. A large debug stack is composed of
-			 * multiple exception stack entries, which we
-			 * iterate through now. Dont look:
-			 */
-			do {
-				++j;
-				end -= EXCEPTION_STKSZ;
-				ids[j][4] = '1' + (j - N_EXCEPTION_STACKS);
-			} while (stack < end - EXCEPTION_STKSZ);
-			if (*usedp & (1U << j))
-				break;
-			*usedp |= 1U << j;
-			*idp = ids[j];
-			return (unsigned long *)end;
-		}
-#endif
-	}
-	return NULL;
-}
-
 /*
  * x86-64 can have up to three kernel stacks:
  * process stack
@@ -164,7 +89,6 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 {
 	const unsigned cpu = get_cpu();
 	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
-	unsigned used = 0;
 	struct thread_info *tinfo;
 
 	if (!task)
@@ -196,26 +120,6 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	 */
 	tinfo = task_thread_info(task);
 	for (;;) {
-		char *id;
-		unsigned long *estack_end;
-		estack_end = in_exception_stack(cpu, (unsigned long)stack,
-						&used, &id);
-
-		if (estack_end) {
-			if (ops->stack(data, id) < 0)
-				break;
-
-			bp = print_context_stack(tinfo, stack, bp, ops,
-							data, estack_end);
-			ops->stack(data, "<EOE>");
-			/*
-			 * We link to the next stack via the
-			 * second-to-last pointer (index -2 to end) in the
-			 * exception stack:
-			 */
-			stack = (unsigned long *) estack_end[-2];
-			continue;
-		}
 		if (irqstack_end) {
 			unsigned long *irqstack;
 			irqstack = irqstack_end -
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b86f332..8c882e1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -899,7 +899,7 @@ END(spurious_interrupt)
 
 	/* error code is on the stack already */
 	/* handle NMI like exceptions that can happen everywhere */
-	.macro paranoidentry sym, ist=0, irqtrace=1
+	.macro paranoidentry sym, irqtrace=1
 	SAVE_ALL
 	cld
 	movl $1,%ebx
@@ -910,22 +910,13 @@ END(spurious_interrupt)
 	SWAPGS
 	xorl  %ebx,%ebx
 1:
-	.if \ist
-	movq	%gs:pda_data_offset, %rbp
-	.endif
 	.if \irqtrace
 	TRACE_IRQS_OFF
 	.endif
 	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi
 	movq $-1,ORIG_RAX(%rsp)
-	.if \ist
-	subq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
-	.endif
 	call \sym
-	.if \ist
-	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
-	.endif
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	.if \irqtrace
 	TRACE_IRQS_OFF
@@ -1226,7 +1217,7 @@ KPROBE_ENTRY(debug)
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $0
 	CFI_ADJUST_CFA_OFFSET 8		
-	paranoidentry do_debug, DEBUG_STACK
+	paranoidentry do_debug
 	paranoidexit
 KPROBE_END(debug)
 
@@ -1236,7 +1227,7 @@ KPROBE_ENTRY(nmi)
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $-1
 	CFI_ADJUST_CFA_OFFSET 8
-	paranoidentry do_nmi, 0, 0
+	paranoidentry do_nmi, 0
 #ifdef CONFIG_TRACE_IRQFLAGS
 	paranoidexit 0
 #else
@@ -1250,7 +1241,7 @@ KPROBE_ENTRY(int3)
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
  	pushq $0
  	CFI_ADJUST_CFA_OFFSET 8
- 	paranoidentry do_int3, DEBUG_STACK
+	paranoidentry do_int3
  	jmp paranoid_exit1
  	CFI_ENDPROC
 KPROBE_END(int3)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 04d242a..c8f71ae 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -962,10 +962,10 @@ void __init trap_init(void)
 #endif
 
 	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
-	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	set_intr_gate(1, &debug);
+	set_intr_gate(2, &nmi);
 	/* int3 can be called from all */
-	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
+	set_system_intr_gate(3, &int3);
 	/* int4 can be called from all */
 	set_system_intr_gate(4, &overflow);
 	set_intr_gate(5, &bounds);
@@ -974,19 +974,19 @@ void __init trap_init(void)
 #ifdef CONFIG_X86_32
 	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
 #else
-	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+	set_intr_gate(8, &double_fault);
 #endif
 	set_intr_gate(9, &coprocessor_segment_overrun);
 	set_intr_gate(10, &invalid_TSS);
 	set_intr_gate(11, &segment_not_present);
-	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(12, &stack_segment);
 	set_intr_gate(13, &general_protection);
 	set_intr_gate(14, &page_fault);
 	set_intr_gate(15, &spurious_interrupt_bug);
 	set_intr_gate(16, &coprocessor_error);
 	set_intr_gate(17, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18, &machine_check, MCE_STACK);
+	set_intr_gate(18, &machine_check);
 #endif
 	set_intr_gate(19, &simd_coprocessor_error);
 
-- 
1.6.0.6

