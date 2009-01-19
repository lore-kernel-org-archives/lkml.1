Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbZASCqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbZASCqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbZASCqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:46:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:56100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067AbZASCqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:46:20 -0500
Message-ID: <4973E972.10503@kernel.org>
Date: Mon, 19 Jan 2009 11:46:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 4/5] x86-64: Move stack_canary into irq_stack
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com> <1232326345-3534-1-git-send-email-brgerst@gmail.com> <1232326345-3534-2-git-send-email-brgerst@gmail.com> <1232326345-3534-3-git-send-email-brgerst@gmail.com> <1232326345-3534-4-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232326345-3534-4-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Jan 2009 02:46:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Now that the PDA is empty except for the stack canary, it can be removed.
The irqstack is moved to the start of the per-cpu section.  If the stack
protector is enabled, the canary overlaps the bottom 48 bytes of the irqstack.

tj: * updated subject
    * dropped asm relocation of irq_stack_ptr
    * updated comments a bit

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
This is the version which ended up in my git tree.

 arch/x86/include/asm/pda.h       |    5 -----
 arch/x86/include/asm/percpu.h    |    6 ------
 arch/x86/include/asm/processor.h |   25 ++++++++++++++++++++++++-
 arch/x86/kernel/asm-offsets_64.c |    4 ----
 arch/x86/kernel/cpu/common.c     |    7 ++++---
 arch/x86/kernel/head_64.S        |    6 +++---
 arch/x86/kernel/process_64.c     |    6 +++---
 arch/x86/kernel/setup_percpu.c   |   34 ++++------------------------------
 arch/x86/kernel/vmlinux_64.lds.S |    8 ++++++--
 9 files changed, 44 insertions(+), 57 deletions(-)

Index: work/arch/x86/include/asm/pda.h
===================================================================
--- work.orig/arch/x86/include/asm/pda.h
+++ work/arch/x86/include/asm/pda.h
@@ -17,11 +17,6 @@ struct x8664_pda {
 	unsigned long unused4;
 	int unused5;
 	unsigned int unused6;		/* 36 was cpunumber */
-#ifdef CONFIG_CC_STACKPROTECTOR
-	unsigned long stack_canary;	/* 40 stack canary value */
-					/* gcc-ABI: this canary MUST be at
-					   offset 40!!! */
-#endif
 	short in_bootmem;		/* pda lives in bootmem */
 } ____cacheline_aligned_in_smp;
 
Index: work/arch/x86/include/asm/percpu.h
===================================================================
--- work.orig/arch/x86/include/asm/percpu.h
+++ work/arch/x86/include/asm/percpu.h
@@ -133,12 +133,6 @@ do {							\
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
-#ifdef CONFIG_X86_64
-extern void load_pda_offset(int cpu);
-#else
-static inline void load_pda_offset(int cpu) { }
-#endif
-
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_SMP
Index: work/arch/x86/include/asm/processor.h
===================================================================
--- work.orig/arch/x86/include/asm/processor.h
+++ work/arch/x86/include/asm/processor.h
@@ -379,8 +379,31 @@ union thread_xstate {
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
-DECLARE_PER_CPU(char[IRQ_STACK_SIZE], irq_stack);
+union irq_stack_union {
+	char irq_stack[IRQ_STACK_SIZE];
+	/*
+	 * GCC hardcodes the stack canary as %gs:40.  Since the
+	 * irq_stack is the object at %gs:0, we reserve the bottom
+	 * 48 bytes of the irq stack for the canary.
+	 */
+	struct {
+		char gs_base[40];
+#ifdef CONFIG_CC_STACKPROTECTOR
+		unsigned long stack_canary;
+#endif
+	};
+};
+
+DECLARE_PER_CPU(union irq_stack_union, irq_stack_union);
 DECLARE_PER_CPU(char *, irq_stack_ptr);
+
+static inline void load_gs_base(int cpu)
+{
+	/* Memory clobbers used to order pda/percpu accesses */
+	mb();
+	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
+	mb();
+}
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
Index: work/arch/x86/kernel/asm-offsets_64.c
===================================================================
--- work.orig/arch/x86/kernel/asm-offsets_64.c
+++ work/arch/x86/kernel/asm-offsets_64.c
@@ -48,10 +48,6 @@ int main(void)
 #endif
 	BLANK();
 #undef ENTRY
-#define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	DEFINE(pda_size, sizeof(struct x8664_pda));
-	BLANK();
-#undef ENTRY
 #ifdef CONFIG_PARAVIRT
 	BLANK();
 	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
Index: work/arch/x86/kernel/cpu/common.c
===================================================================
--- work.orig/arch/x86/kernel/cpu/common.c
+++ work/arch/x86/kernel/cpu/common.c
@@ -881,12 +881,13 @@ __setup("clearcpuid=", setup_disablecpui
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-DEFINE_PER_CPU_PAGE_ALIGNED(char[IRQ_STACK_SIZE], irq_stack);
+DEFINE_PER_CPU_FIRST(union irq_stack_union,
+		     irq_stack_union) __aligned(PAGE_SIZE);
 #ifdef CONFIG_SMP
 DEFINE_PER_CPU(char *, irq_stack_ptr);	/* will be set during per cpu init */
 #else
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
-	per_cpu_var(irq_stack) + IRQ_STACK_SIZE - 64;
+	per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 #endif
 
 DEFINE_PER_CPU(unsigned long, kernel_stack) =
@@ -960,7 +961,7 @@ void __cpuinit cpu_init(void)
 
 	loadsegment(fs, 0);
 	loadsegment(gs, 0);
-	load_pda_offset(cpu);
+	load_gs_base(cpu);
 
 #ifdef CONFIG_NUMA
 	if (cpu != 0 && percpu_read(node_number) == 0 &&
Index: work/arch/x86/kernel/head_64.S
===================================================================
--- work.orig/arch/x86/kernel/head_64.S
+++ work/arch/x86/kernel/head_64.S
@@ -247,8 +247,8 @@ ENTRY(secondary_startup_64)
 	 * secondary CPU,initial_gs should be set to its pda address
 	 * before the CPU runs this code.
 	 *
-	 * On UP, initial_gs points to PER_CPU_VAR(__pda) and doesn't
-	 * change.
+	 * On UP, initial_gs points to PER_CPU_VAR(irq_stack_union)
+	 * and doesn't change.
 	 */
 	movl	$MSR_GS_BASE,%ecx
 	movq	initial_gs(%rip),%rax
@@ -281,7 +281,7 @@ ENTRY(secondary_startup_64)
 #ifdef CONFIG_SMP
 	.quad	__per_cpu_load
 #else
-	.quad	PER_CPU_VAR(__pda)
+	.quad	PER_CPU_VAR(irq_stack_union)
 #endif
 	__FINITDATA
 
Index: work/arch/x86/kernel/process_64.c
===================================================================
--- work.orig/arch/x86/kernel/process_64.c
+++ work/arch/x86/kernel/process_64.c
@@ -627,12 +627,12 @@ __switch_to(struct task_struct *prev_p,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
+	percpu_write(irq_stack_union.stack_canary, canary);
 	/*
 	 * Build time only check to make sure the stack_canary is at
-	 * offset 40 in the pda; this is a gcc ABI requirement
+	 * %gs:40; this is a gcc ABI requirement
 	 */
-	BUILD_BUG_ON(offsetof(struct x8664_pda, stack_canary) != 40);
+	BUILD_BUG_ON(offsetof(union irq_stack_union, stack_canary) != 40);
 #endif
 
 	/*
Index: work/arch/x86/kernel/setup_percpu.c
===================================================================
--- work.orig/arch/x86/kernel/setup_percpu.c
+++ work/arch/x86/kernel/setup_percpu.c
@@ -77,30 +77,6 @@ static void __init setup_node_to_cpumask
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
-/*
- * Define load_pda_offset() and per-cpu __pda for x86_64.
- * load_pda_offset() is responsible for loading the offset of pda into
- * %gs.
- *
- * On SMP, pda offset also duals as percpu base address and thus it
- * should be at the start of per-cpu area.  To achieve this, it's
- * preallocated in vmlinux_64.lds.S directly instead of using
- * DEFINE_PER_CPU().
- */
-#ifdef CONFIG_X86_64
-void __cpuinit load_pda_offset(int cpu)
-{
-	/* Memory clobbers used to order pda/percpu accesses */
-	mb();
-	wrmsrl(MSR_GS_BASE, cpu_pda(cpu));
-	mb();
-}
-#ifndef CONFIG_SMP
-DEFINE_PER_CPU(struct x8664_pda, __pda);
-#endif
-EXPORT_PER_CPU_SYMBOL(__pda);
-#endif /* CONFIG_SMP && CONFIG_X86_64 */
-
 #ifdef CONFIG_X86_64
 
 /* correctly size the local cpu masks */
@@ -207,15 +183,13 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(cpu_number, cpu) = cpu;
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
-			(char *)per_cpu(irq_stack, cpu) + IRQ_STACK_SIZE - 64;
+			per_cpu(irq_stack_union.irq_stack, cpu) + IRQ_STACK_SIZE - 64;
 		/*
-		 * CPU0 modified pda in the init data area, reload pda
-		 * offset for CPU0 and clear the area for others.
+		 * Up to this point, CPU0 has been using .data.init
+		 * area.  Reload %gs offset for CPU0.
 		 */
 		if (cpu == 0)
-			load_pda_offset(0);
-		else
-			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
+			load_gs_base(cpu);
 #endif
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
Index: work/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- work.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ work/arch/x86/kernel/vmlinux_64.lds.S
@@ -220,8 +220,7 @@ SECTIONS
    * so that it can be accessed as a percpu variable.
    */
   . = ALIGN(PAGE_SIZE);
-  PERCPU_VADDR_PREALLOC(0, :percpu, pda_size)
-  per_cpu____pda = __per_cpu_start;
+  PERCPU_VADDR(0, :percpu)
 #else
   PERCPU(PAGE_SIZE)
 #endif
@@ -262,3 +261,8 @@ SECTIONS
  */
 ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
 	"kernel image bigger than KERNEL_IMAGE_SIZE")
+
+#ifdef CONFIG_SMP
+ASSERT((per_cpu__irq_stack_union == 0),
+        "irq_stack_union is not at start of per-cpu area");
+#endif
