Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYFDAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYFDAbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYFDAa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:30:26 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56083 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752022AbYFDAaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:30:21 -0400
Message-Id: <20080604003019.509483000@polaris-admin.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 17:30:21 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86_64: Fold pda into per cpu area
Content-Disposition: inline; filename=zero_based_fold
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Declare the pda as a per cpu variable.

  * Make the x86_64 per cpu area start at zero.

  * Since the pda is now the first element of the per_cpu area, cpu_pda()
    is no longer needed and per_cpu() can be used instead.  This also makes
    the _cpu_pda[] table obsolete.

  * Since %gs is pointing to the pda, it will then also point to the per cpu
    variables and can be accessed thusly:

	%gs:[&per_cpu_xxxx - __per_cpu_start]

Based on linux-2.6.tip

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig                 |    3 +
 arch/x86/kernel/head64.c         |   34 ++++++--------
 arch/x86/kernel/irq_64.c         |   36 ++++++++-------
 arch/x86/kernel/setup.c          |   90 ++++++++++++---------------------------
 arch/x86/kernel/setup64.c        |    5 --
 arch/x86/kernel/smpboot.c        |   51 ----------------------
 arch/x86/kernel/traps_64.c       |   11 +++-
 arch/x86/kernel/vmlinux_64.lds.S |    1 
 include/asm-x86/percpu.h         |   48 ++++++--------------
 9 files changed, 89 insertions(+), 190 deletions(-)

--- linux-2.6.tip.orig/arch/x86/Kconfig
+++ linux-2.6.tip/arch/x86/Kconfig
@@ -129,6 +129,9 @@ config HAVE_SETUP_PER_CPU_AREA
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
+config HAVE_ZERO_BASED_PER_CPU
+	def_bool X86_64_SMP
+
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
--- linux-2.6.tip.orig/arch/x86/kernel/head64.c
+++ linux-2.6.tip/arch/x86/kernel/head64.c
@@ -25,20 +25,6 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 
-/* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda __read_mostly;
-
-#ifdef CONFIG_SMP
-/*
- * We install an empty cpu_pda pointer table to indicate to early users
- * (numa_set_node) that the cpu_pda pointer table for cpus other than
- * the boot cpu is not yet setup.
- */
-static struct x8664_pda *__cpu_pda[NR_CPUS] __initdata;
-#else
-static struct x8664_pda *__cpu_pda[NR_CPUS] __read_mostly;
-#endif
-
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
@@ -159,6 +145,20 @@ void __init x86_64_start_kernel(char * r
 	/* Cleanup the over mapped high alias */
 	cleanup_highmap();
 
+	/* point to boot pda which is the first element in the percpu area */
+	{
+		struct x8664_pda *pda;
+#ifdef CONFIG_SMP
+		pda = (struct x8664_pda *)__per_cpu_load;
+		pda->data_offset = per_cpu_offset(0) = (unsigned long)pda;
+#else
+		pda = &per_cpu(pda, 0);
+		pda->data_offset = (unsigned long)pda;
+#endif
+	}
+	/* initialize boot cpu_pda data */
+	pda_init(0);
+
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
@@ -170,12 +170,6 @@ void __init x86_64_start_kernel(char * r
 
 	early_printk("Kernel alive\n");
 
-	_cpu_pda = __cpu_pda;
-	cpu_pda(0) = &_boot_cpu_pda;
-	pda_init(0);
-
-	early_printk("Kernel really alive\n");
-
 	copy_bootdata(__va(real_mode_data));
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
--- linux-2.6.tip.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6.tip/arch/x86/kernel/irq_64.c
@@ -115,39 +115,43 @@ skip:
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
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_resched_count, j));
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
 #ifdef CONFIG_X86_MCE
 		seq_printf(p, "TRM: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_thermal_count);
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_thermal_count, j));
 		seq_printf(p, "  Thermal event interrupts\n");
 		seq_printf(p, "THR: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_threshold_count);
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_threshold_count, j));
 		seq_printf(p, "  Threshold APIC interrupts\n");
 #endif
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_count);
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_spurious_count, j));
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
@@ -159,19 +163,19 @@ skip:
  */
 u64 arch_irq_stat_cpu(unsigned int cpu)
 {
-	u64 sum = cpu_pda(cpu)->__nmi_count;
+	u64 sum = per_cpu(pda.__nmi_count, cpu);
 
-	sum += cpu_pda(cpu)->apic_timer_irqs;
+	sum += per_cpu(pda.apic_timer_irqs, cpu);
 #ifdef CONFIG_SMP
-	sum += cpu_pda(cpu)->irq_resched_count;
-	sum += cpu_pda(cpu)->irq_call_count;
-	sum += cpu_pda(cpu)->irq_tlb_count;
+	sum += per_cpu(pda.irq_resched_count, cpu);
+	sum += per_cpu(pda.irq_call_count, cpu);
+	sum += per_cpu(pda.irq_tlb_count, cpu);
 #endif
 #ifdef CONFIG_X86_MCE
-	sum += cpu_pda(cpu)->irq_thermal_count;
-	sum += cpu_pda(cpu)->irq_threshold_count;
+	sum += per_cpu(pda.irq_thermal_count, cpu);
+	sum += per_cpu(pda.irq_threshold_count, cpu);
 #endif
-	sum += cpu_pda(cpu)->irq_spurious_count;
+	sum += per_cpu(pda.irq_spurious_count, cpu);
 	return sum;
 }
 
--- linux-2.6.tip.orig/arch/x86/kernel/setup.c
+++ linux-2.6.tip/arch/x86/kernel/setup.c
@@ -29,6 +29,11 @@ DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_a
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
+#ifdef CONFIG_X86_64
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
+#endif
+
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 #define	X86_64_NUMA	1
 
@@ -47,7 +52,7 @@ static void __init setup_node_to_cpumask
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -94,64 +99,9 @@ static void __init setup_cpumask_of_cpu(
 static inline void setup_cpumask_of_cpu(void) { }
 #endif
 
-#ifdef CONFIG_X86_32
-/*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
- */
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
-static inline void setup_cpu_pda_map(void) { }
-
-#elif !defined(CONFIG_SMP)
-static inline void setup_cpu_pda_map(void) { }
-
-#else /* CONFIG_SMP && CONFIG_X86_64 */
-
-/*
- * Allocate cpu_pda pointer table and array via alloc_bootmem.
- */
-static void __init setup_cpu_pda_map(void)
-{
-	char *pda;
-	struct x8664_pda **new_cpu_pda;
-	unsigned long size;
-	int cpu;
-
-	size = roundup(sizeof(struct x8664_pda), cache_line_size());
-
-	/* allocate cpu_pda array and pointer table */
-	{
-		unsigned long tsize = nr_cpu_ids * sizeof(void *);
-		unsigned long asize = size * (nr_cpu_ids - 1);
-
-		tsize = roundup(tsize, cache_line_size());
-		new_cpu_pda = alloc_bootmem(tsize + asize);
-		pda = (char *)new_cpu_pda + tsize;
-	}
 
-	/* initialize pointer table to static pda's */
-	for_each_possible_cpu(cpu) {
-		if (cpu == 0) {
-			/* leave boot cpu pda in place */
-			new_cpu_pda[0] = cpu_pda(0);
-			continue;
-		}
-		new_cpu_pda[cpu] = (struct x8664_pda *)pda;
-		new_cpu_pda[cpu]->in_bootmem = 1;
-		pda += size;
-	}
-
-	/* point to new pointer table */
-	_cpu_pda = new_cpu_pda;
-}
-#endif
-
-/*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
- */
 void __init setup_per_cpu_areas(void)
 {
 	ssize_t size = PERCPU_ENOUGH_ROOM;
@@ -164,9 +114,6 @@ void __init setup_per_cpu_areas(void)
 	nr_cpu_ids = num_processors;
 #endif
 
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
 	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
@@ -186,9 +133,28 @@ void __init setup_per_cpu_areas(void)
 		else
 			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
 #endif
+		/* Initialize each cpu's per_cpu area and save pointer */
+		memcpy(ptr, __per_cpu_load, __per_cpu_size);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
+#ifdef CONFIG_X86_64
+		/*
+		 * Note the boot cpu has been using the static per_cpu load
+		 * area for it's pda.  We need to zero out the pda's for the
+		 * other cpu's that are coming online.
+		 */
+		{
+			/* we rely on the fact that pda is the first element */
+			struct x8664_pda *pda = (struct x8664_pda *)ptr;
+
+			if (cpu)
+				memset(pda, 0, sizeof(struct x8664_pda));
+			else
+				pda_init(0);
+
+			pda->data_offset = (unsigned long)ptr;
+		}
+#endif
 	}
 
 	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
@@ -240,8 +206,8 @@ void __cpuinit numa_set_node(int cpu, in
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
-	if (cpu_pda(cpu) && node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
+	if (per_cpu_offset(cpu))
+		per_cpu(pda.nodenumber, cpu) = node;
 
 	if (cpu_to_node_map)
 		cpu_to_node_map[cpu] = node;
--- linux-2.6.tip.orig/arch/x86/kernel/setup64.c
+++ linux-2.6.tip/arch/x86/kernel/setup64.c
@@ -35,9 +35,6 @@ struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
 char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
@@ -89,7 +86,7 @@ __setup("noexec32=", nonx32_setup);
 
 void pda_init(int cpu)
 { 
-	struct x8664_pda *pda = cpu_pda(cpu);
+	struct x8664_pda *pda = &per_cpu(pda, cpu);
 
 	/* Setup up data that may be needed in __get_free_pages early */
 	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0)); 
--- linux-2.6.tip.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.tip/arch/x86/kernel/smpboot.c
@@ -798,45 +798,6 @@ static void __cpuinit do_fork_idle(struc
 	complete(&c_idle->done);
 }
 
-#ifdef CONFIG_X86_64
-/*
- * Allocate node local memory for the AP pda.
- *
- * Must be called after the _cpu_pda pointer table is initialized.
- */
-static int __cpuinit get_local_pda(int cpu)
-{
-	struct x8664_pda *oldpda, *newpda;
-	unsigned long size = sizeof(struct x8664_pda);
-	int node = cpu_to_node(cpu);
-
-	if (cpu_pda(cpu) && !cpu_pda(cpu)->in_bootmem)
-		return 0;
-
-	oldpda = cpu_pda(cpu);
-	newpda = kmalloc_node(size, GFP_ATOMIC, node);
-	if (!newpda) {
-		printk(KERN_ERR "Could not allocate node local PDA "
-			"for CPU %d on node %d\n", cpu, node);
-
-		if (oldpda)
-			return 0;	/* have a usable pda */
-		else
-			return -1;
-	}
-
-	if (oldpda) {
-		memcpy(newpda, oldpda, size);
-		if (!after_bootmem)
-			free_bootmem((unsigned long)oldpda, size);
-	}
-
-	newpda->in_bootmem = 0;
-	cpu_pda(cpu) = newpda;
-	return 0;
-}
-#endif /* CONFIG_X86_64 */
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -860,14 +821,6 @@ static int __cpuinit do_boot_cpu(int api
 		printk(KERN_ERR "Failed to allocate GDT for CPU %d\n", cpu);
 		return -1;
 	}
-
-	/* Allocate node local memory for AP pdas */
-	if (cpu > 0) {
-		boot_error = get_local_pda(cpu);
-		if (boot_error)
-			goto restore_state;
-			/* if can't get pda memory, can't start cpu */
-	}
 #endif
 
 	alternatives_smp_switch(1);
@@ -908,7 +861,7 @@ do_rest:
 	stack_start.sp = (void *) c_idle.idle->thread.sp;
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
+	per_cpu(pda.pcurrent, cpu) = c_idle.idle;
 	init_rsp = c_idle.idle->thread.sp;
 	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
 	initial_code = (unsigned long)start_secondary;
@@ -985,8 +938,6 @@ do_rest:
 		}
 	}
 
-restore_state:
-
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		unmap_cpu_to_logical_apicid(cpu);
--- linux-2.6.tip.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.tip/arch/x86/kernel/traps_64.c
@@ -265,7 +265,8 @@ void dump_trace(struct task_struct *tsk,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long*)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irqstack_end =
+		(unsigned long*)per_cpu(pda.irqstackptr, cpu);
 	unsigned used = 0;
 	struct thread_info *tinfo;
 
@@ -399,8 +400,10 @@ _show_stack(struct task_struct *tsk, str
 	unsigned long *stack;
 	int i;
 	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end = (unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack = (unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+	unsigned long *irqstack_end =
+		(unsigned long *)per_cpu(pda.irqstackptr, cpu);
+	unsigned long *irqstack =
+		(unsigned long *)(per_cpu(pda.irqstackptr, cpu) - IRQSTACKSIZE);
 
 	// debugging aid: "show_stack(NULL, NULL);" prints the
 	// back trace for this cpu.
@@ -464,7 +467,7 @@ void show_registers(struct pt_regs *regs
 	int i;
 	unsigned long sp;
 	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+	struct task_struct *cur = __get_cpu_var(pda.pcurrent);
 	u8 *ip;
 	unsigned int code_prologue = code_bytes * 43 / 64;
 	unsigned int code_len = code_bytes;
--- linux-2.6.tip.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6.tip/arch/x86/kernel/vmlinux_64.lds.S
@@ -16,6 +16,7 @@ jiffies_64 = jiffies;
 _proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
+	percpu PT_LOAD FLAGS(4);	/* R__ */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
--- linux-2.6.tip.orig/include/asm-x86/percpu.h
+++ linux-2.6.tip/include/asm-x86/percpu.h
@@ -3,26 +3,20 @@
 
 #ifdef CONFIG_X86_64
 #include <linux/compiler.h>
-
-/* Same as asm-generic/percpu.h, except that we store the per cpu offset
-   in the PDA. Longer term the PDA and every per cpu variable
-   should be just put into a single section and referenced directly
-   from %gs */
-
-#ifdef CONFIG_SMP
 #include <asm/pda.h>
 
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
+#ifdef CONFIG_SMP
+#define __my_cpu_offset (x86_read_percpu(pda.data_offset))
+#define __percpu_seg "%%gs:"
+#else
+#define __percpu_seg ""
 #endif
+
 #include <asm-generic/percpu.h>
 
 DECLARE_PER_CPU(struct x8664_pda, pda);
 
-#else /* CONFIG_X86_64 */
+#else /* !CONFIG_X86_64 */
 
 #ifdef __ASSEMBLY__
 
@@ -51,36 +45,23 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 
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
 
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#endif /* __ASSEMBLY__ */
+#endif /* !CONFIG_X86_64 */
+
+#ifndef __ASSEMBLY__
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
@@ -215,7 +196,6 @@ do {							\
 				percpu_cmpxchg_op(per_cpu_var(var), old, new)
 
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 
 #ifdef CONFIG_SMP
 

-- 
