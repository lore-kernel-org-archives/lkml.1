Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbYE3EKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbYE3EKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYE3EBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45476 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753367AbYE3EA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:26 -0400
Message-Id: <20080530040023.999560464@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:59 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 39/41] x86: Replace cpu_pda() using percpu logic and get rid of _cpu_pda()
Content-Disposition: inline; filename=zero_based_replace_pda_with_percpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_cpu_pda() is pointing to the pda which is at the beginning of the per cpu area.
This means that cpu_pda and _cpu_pda[] are both pointing at the percpu area!
per_cpu() can be used instead of cpu_pda() when accessing pda fields.

Typically the offsets to the per cpu areas are stored in an array _per_cpu_offset
(generic per cpu support can then provide more functionality).
Use that array for x86_64 and get rid of the pda pointers.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/head64.c   |    7 ++++++-
 arch/x86/kernel/irq_64.c   |   16 ++++++++--------
 arch/x86/kernel/nmi_64.c   |    6 +++---
 arch/x86/kernel/setup.c    |   15 ++++-----------
 arch/x86/kernel/setup64.c  |    6 +-----
 arch/x86/kernel/smpboot.c  |    2 +-
 arch/x86/kernel/traps_64.c |    9 +++++----
 include/asm-x86/pda.h      |    4 ----
 include/asm-x86/percpu.h   |   32 +++++++-------------------------
 9 files changed, 35 insertions(+), 62 deletions(-)

Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c	2008-05-29 20:29:55.000000000 -0700
+++ linux-2.6/arch/x86/kernel/head64.c	2008-05-29 20:48:18.000000000 -0700
@@ -119,8 +119,13 @@ static void __init reserve_setup_data(vo
 	}
 }
 
+static struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
+
 void __init x86_64_start_kernel(char * real_mode_data)
 {
+#ifndef CONFIG_SMP
+	unsigned long __per_cpu_offset[1];
+#endif
 	int i;
 
 	/*
@@ -157,7 +162,7 @@ void __init x86_64_start_kernel(char * r
 	early_printk("Kernel alive\n");
 
  	for (i = 0; i < NR_CPUS; i++)
- 		cpu_pda(i) = &boot_cpu_pda[i];
+ 		__per_cpu_offset[i] = (unsigned long)&boot_cpu_pda[i];
 
 	pda_init(0);
 	copy_bootdata(__va(real_mode_data));
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c	2008-05-29 20:29:55.000000000 -0700
+++ linux-2.6/arch/x86/kernel/irq_64.c	2008-05-29 20:48:18.000000000 -0700
@@ -115,37 +115,37 @@ skip:
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
+			seq_printf(p, "%10u ", per_cpu(pda.__nmi_count, j));
 		seq_printf(p, "  Non-maskable interrupts\n");
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->apic_timer_irqs);
+			seq_printf(p, "%10u ", per_cpu(pda.apic_timer_irqs, j));
 		seq_printf(p, "  Local timer interrupts\n");
 #ifdef CONFIG_SMP
 		seq_printf(p, "RES: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_resched_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_resched_count, j));
 		seq_printf(p, "  Rescheduling interrupts\n");
 		seq_printf(p, "CAL: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_call_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_call_count, j));
 		seq_printf(p, "  function call interrupts\n");
 		seq_printf(p, "TLB: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_tlb_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_tlb_count, j));
 		seq_printf(p, "  TLB shootdowns\n");
 #endif
 		seq_printf(p, "TRM: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_thermal_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_thermal_count, j));
 		seq_printf(p, "  Thermal event interrupts\n");
 		seq_printf(p, "THR: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_threshold_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_threshold_count, j));
 		seq_printf(p, "  Threshold APIC interrupts\n");
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_spurious_count, j));
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
Index: linux-2.6/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/nmi_64.c	2008-05-29 20:29:55.000000000 -0700
+++ linux-2.6/arch/x86/kernel/nmi_64.c	2008-05-29 20:48:18.000000000 -0700
@@ -100,19 +100,19 @@ int __init check_nmi_watchdog(void)
 #endif
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++)
-		prev_nmi_count[cpu] = cpu_pda(cpu)->__nmi_count;
+		prev_nmi_count[cpu] = per_cpu(pda.__nmi_count, cpu);
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
 
 	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
-		if (cpu_pda(cpu)->__nmi_count - prev_nmi_count[cpu] <= 5) {
+		if (per_cpu(pda.__nmi_count, cpu) - prev_nmi_count[cpu] <= 5) {
 			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
 			       "appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
-				cpu_pda(cpu)->__nmi_count);
+				per_cpu(pda.__nmi_count, cpu));
 			per_cpu(wd_enabled, cpu) = 0;
 			atomic_dec(&nmi_active);
 		}
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c	2008-05-29 20:29:55.000000000 -0700
+++ linux-2.6/arch/x86/kernel/setup.c	2008-05-29 20:48:18.000000000 -0700
@@ -77,14 +77,8 @@ static void __init setup_cpumask_of_cpu(
 static inline void setup_cpumask_of_cpu(void) { }
 #endif
 
-#ifdef CONFIG_X86_32
-/*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
- */
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
-#endif
 
 /*
  * Great future plan:
@@ -128,12 +122,11 @@ void __init setup_per_cpu_areas(void)
 		 * So far an embryonic per cpu area was used containing only
 		 * the pda. Move the pda contents into the full per cpu area.
 		  */
-		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
-		memcpy(ptr, cpu_pda(i), sizeof(struct x8664_pda));
-		cpu_pda(i) = (struct x8664_pda *)ptr;
-#else
-		__per_cpu_offset[i] = ptr - __per_cpu_start;
+		per_cpu(pda.data_offset, i) = ptr - __per_cpu_start;
+		memcpy(ptr, &per_cpu(pda, i), sizeof(struct x8664_pda));
 #endif
+		__per_cpu_offset[i] = ptr - __per_cpu_start;
+
 		highest_cpu = i;
 	}
 
Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2008-05-29 20:29:55.000000000 -0700
+++ linux-2.6/arch/x86/kernel/setup64.c	2008-05-29 20:48:18.000000000 -0700
@@ -34,10 +34,6 @@ struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
-
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
 char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
@@ -89,7 +85,7 @@ __setup("noexec32=", nonx32_setup);
 
 void pda_init(int cpu)
 { 
-	struct x8664_pda *pda = cpu_pda(cpu);
+	struct x8664_pda *pda = &per_cpu(pda, cpu);
 
 	/* Setup up data that may be needed in __get_free_pages early */
 	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0)); 
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c	2008-05-29 20:29:55.000000000 -0700
+++ linux-2.6/arch/x86/kernel/smpboot.c	2008-05-29 20:48:18.000000000 -0700
@@ -895,7 +895,7 @@ do_rest:
 	stack_start.sp = (void *) c_idle.idle->thread.sp;
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
+	per_cpu(pda.pcurrent, cpu) = c_idle.idle;
 	init_rsp = c_idle.idle->thread.sp;
 	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
 	initial_code = (unsigned long)start_secondary;
Index: linux-2.6/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps_64.c	2008-05-29 20:29:56.000000000 -0700
+++ linux-2.6/arch/x86/kernel/traps_64.c	2008-05-29 20:48:18.000000000 -0700
@@ -263,7 +263,8 @@ void dump_trace(struct task_struct *tsk,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long*)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irqstack_end =
+		(unsigned long*)per_cpu(pda.irqstackptr, cpu);
 	unsigned used = 0;
 	struct thread_info *tinfo;
 
@@ -397,8 +398,8 @@ _show_stack(struct task_struct *tsk, str
 	unsigned long *stack;
 	int i;
 	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end = (unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack = (unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+	unsigned long *irqstack_end = (unsigned long *)per_cpu(pda.irqstackptr, cpu);
+	unsigned long *irqstack = (unsigned long *)(per_cpu(pda.irqstackptr, cpu) - IRQSTACKSIZE);
 
 	// debugging aid: "show_stack(NULL, NULL);" prints the
 	// back trace for this cpu.
@@ -462,7 +463,7 @@ void show_registers(struct pt_regs *regs
 	int i;
 	unsigned long sp;
 	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+	struct task_struct *cur = per_cpu(pda.pcurrent, cpu);
 	u8 *ip;
 	unsigned int code_prologue = code_bytes * 43 / 64;
 	unsigned int code_len = code_bytes;
Index: linux-2.6/include/asm-x86/pda.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pda.h	2008-05-29 20:29:56.000000000 -0700
+++ linux-2.6/include/asm-x86/pda.h	2008-05-29 20:48:18.000000000 -0700
@@ -37,12 +37,8 @@ struct x8664_pda {
 	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
-extern struct x8664_pda *_cpu_pda[];
-extern struct x8664_pda boot_cpu_pda[];
 extern void pda_init(int);
 
-#define cpu_pda(i) (_cpu_pda[i])
-
 /*
  * There is no fast way to get the base address of the PDA, all the accesses
  * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
Index: linux-2.6/include/asm-x86/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu.h	2008-05-29 20:32:03.000000000 -0700
+++ linux-2.6/include/asm-x86/percpu.h	2008-05-29 20:48:18.000000000 -0700
@@ -6,12 +6,12 @@
 #include <asm/pda.h>
 
 #ifdef CONFIG_SMP
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset read_pda(data_offset)
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-#endif
-
+#define __my_cpu_offset x86_read_percpu(pda.data_offset)
 #define __percpu_seg "%%gs:"
+#else
+#define __percpu_seg ""
+
+#endif
 
 #include <asm-generic/percpu.h>
 
@@ -46,30 +46,12 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 
 #else /* ...!ASSEMBLY */
 
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    cpu - 32bit register containing the current CPU number
- *
- * The resulting address is stored in the "cpu" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
 #ifdef CONFIG_SMP
-
 #define __my_cpu_offset x86_read_percpu(this_cpu_off)
-
-/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
-
-#else  /* !SMP */
-
+#else
 #define __percpu_seg ""
-
-#endif	/* SMP */
+#endif
 
 #include <asm-generic/percpu.h>
 

-- 
