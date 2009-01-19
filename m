Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZASAxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZASAxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZASAwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:52:35 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:52398 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbZASAwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:52:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O6bp1Z+KJgSyR4+z7Nj+BZHLtJJrmcgeho5fBluPiWXfKUdqKRtvNu+/TPGqJKwdyn
         JWkR9ixwZx7rOUes/5CccaOewRnrCsJ9PpEaAeGHXKDRfB4HIM3dG9LUGNLcp9gfBHyI
         XUapCWU/6czHUOPUegzKw5AJrc2c1NqNuMk2I=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 4/5] x86-64: Remove the PDA
Date: Sun, 18 Jan 2009 19:52:24 -0500
Message-Id: <1232326345-3534-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232326345-3534-3-git-send-email-brgerst@gmail.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
 <1232326345-3534-2-git-send-email-brgerst@gmail.com>
 <1232326345-3534-3-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the PDA is empty except for the stack canary, it can be removed.
The irqstack is moved to the start of the per-cpu section.  If the stack
protector is enabled, the canary overlaps the bottom 48 bytes of the irqstack.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h       |    5 -----
 arch/x86/include/asm/percpu.h    |    6 ------
 arch/x86/include/asm/processor.h |   25 ++++++++++++++++++++++++-
 arch/x86/kernel/asm-offsets_64.c |    4 ----
 arch/x86/kernel/cpu/common.c     |   10 +++-------
 arch/x86/kernel/head_64.S        |   13 +++++--------
 arch/x86/kernel/process_64.c     |    6 +++---
 arch/x86/kernel/setup_percpu.c   |   34 ++++------------------------------
 arch/x86/kernel/vmlinux_64.lds.S |    8 ++++++--
 9 files changed, 45 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 6ca7bc0..ba46416 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
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
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 165d527..ce980db 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
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
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f511246..cfe3237 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
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
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 64c834a..94f9c8b 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f83a4d6..94ea5cb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -881,13 +881,9 @@ __setup("clearcpuid=", setup_disablecpuid);
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-DEFINE_PER_CPU_PAGE_ALIGNED(char[IRQ_STACK_SIZE], irq_stack);
-#ifdef CONFIG_SMP
-DEFINE_PER_CPU(char *, irq_stack_ptr);	/* will be set during per cpu init */
-#else
+DEFINE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union) __aligned(PAGE_SIZE);
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
-	per_cpu_var(irq_stack) + IRQ_STACK_SIZE - 64;
-#endif
+	per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
 DEFINE_PER_CPU(unsigned long, kernel_stack) =
 	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
@@ -960,7 +956,7 @@ void __cpuinit cpu_init(void)
 
 	loadsegment(fs, 0);
 	loadsegment(gs, 0);
-	load_pda_offset(cpu);
+	load_gs_base(cpu);
 
 #ifdef CONFIG_NUMA
 	if (cpu != 0 && percpu_read(node_number) == 0 &&
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 98ea26a..8c83de6 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -216,6 +216,7 @@ ENTRY(secondary_startup_64)
 	cmpl	$0, per_cpu__cpu_number(%rax)
 	jne	1f
 	addq	%rax, early_gdt_descr_base(%rip)
+	addq	%rax, per_cpu__irq_stack_ptr(%rax)
 1:
 #endif
 	/*
@@ -242,13 +243,9 @@ ENTRY(secondary_startup_64)
 
 	/* Set up %gs.
 	 *
-	 * On SMP, %gs should point to the per-cpu area.  For initial
-	 * boot, make %gs point to the init data section.  For a
-	 * secondary CPU,initial_gs should be set to its pda address
-	 * before the CPU runs this code.
-	 *
-	 * On UP, initial_gs points to PER_CPU_VAR(__pda) and doesn't
-	 * change.
+	 * The base of %gs always points to the bottom of the irqstack
+	 * union.  If the stack protector canary is enabled, it is located
+	 * at %gs:40.
 	 */
 	movl	$MSR_GS_BASE,%ecx
 	movq	initial_gs(%rip),%rax
@@ -281,7 +278,7 @@ ENTRY(secondary_startup_64)
 #ifdef CONFIG_SMP
 	.quad	__per_cpu_load
 #else
-	.quad	PER_CPU_VAR(__pda)
+	.quad	per_cpu__irq_stack_union
 #endif
 	__FINITDATA
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4523ff8..604b69e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -627,12 +627,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index efbafbb..65c10c4 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -77,30 +77,6 @@ static void __init setup_node_to_cpumask_map(void);
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
+		 * CPU0 modified data in the init per-cpu area, reload %gs
+		 * offset for CPU0.
 		 */
 		if (cpu == 0)
-			load_pda_offset(0);
-		else
-			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
+			load_gs_base(cpu);
 #endif
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index a09abb8..c974099 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
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
-- 
1.6.1.rc1

