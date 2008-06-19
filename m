Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYFSWNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYFSWNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYFSWNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:13:42 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55347 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751394AbYFSWNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:13:40 -0400
Message-ID: <485ADA12.5010505@sgi.com>
Date: Thu, 19 Jun 2008 15:13:38 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>
In-Reply-To: <485AD138.4010404@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> 
> Why not use the real pda for all cpus?

Yeah, I figured that out after doing some more thinking... ;-)

> 
> Do you move the boot-cpu's per-cpu data? (Please don't)  If not, you can
> just use percpu__pda from the start without having to do anything else,
> and then set up %gs pointing to the pda base for each secondary cpu.

The problem is that the static percpu area is removed as it lies
in the initdata section, so the pda is removed as well.

But I took your suggestion to move the fixup to before secondary_startup.

Below is a revised version.  It builds but I'll have to test it tomorrow.
Note the addition of:

+       initial_pda = (unsigned long)get_percpu_pda(cpu);

in do_boot_cpu.

I'm not sure yet what to put into acpi_save_state_mem:

        initial_code = (unsigned long)wakeup_long64;
+       /* ZZZ initial_pda = (unsigned long)?; */

Thanks again for your help!

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig                 |    3 +
 arch/x86/kernel/acpi/sleep.c     |    1 
 arch/x86/kernel/head64.c         |   34 ++++++---------
 arch/x86/kernel/head_64.S        |   13 +++++
 arch/x86/kernel/setup.c          |   86 +++++++++++----------------------------
 arch/x86/kernel/setup64.c        |    3 -
 arch/x86/kernel/smpboot.c        |   52 -----------------------
 arch/x86/kernel/vmlinux_64.lds.S |    1 
 include/asm-x86/desc.h           |    5 ++
 include/asm-x86/pda.h            |    3 -
 include/asm-x86/percpu.h         |   46 +++++---------------
 include/asm-x86/trampoline.h     |    1 
 12 files changed, 78 insertions(+), 170 deletions(-)

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
--- linux-2.6.tip.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6.tip/arch/x86/kernel/acpi/sleep.c
@@ -76,6 +76,7 @@ int acpi_save_state_mem(void)
 	stack_start.sp = temp_stack + 4096;
 #endif
 	initial_code = (unsigned long)wakeup_long64;
+	/* ZZZ initial_pda = (unsigned long)?; */
 	saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */
 
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
@@ -91,6 +77,20 @@ void __init x86_64_start_kernel(char * r
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
@@ -102,12 +102,6 @@ void __init x86_64_start_kernel(char * r
 
 	early_printk("Kernel alive\n");
 
-	_cpu_pda = __cpu_pda;
-	cpu_pda(0) = &_boot_cpu_pda;
-	pda_init(0);
-
-	early_printk("Kernel really alive\n");
-
 	copy_bootdata(__va(real_mode_data));
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
--- linux-2.6.tip.orig/arch/x86/kernel/head_64.S
+++ linux-2.6.tip/arch/x86/kernel/head_64.S
@@ -12,6 +12,7 @@
 #include <linux/linkage.h>
 #include <linux/threads.h>
 #include <linux/init.h>
+#include <asm/asm-offsets.h>
 #include <asm/desc.h>
 #include <asm/segment.h>
 #include <asm/pgtable.h>
@@ -132,6 +133,12 @@ ident_complete:
 #ifdef CONFIG_SMP
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
+
+	/*
+	 * Fix up per_cpu__gdt_page offset when basing percpu
+	 * variables at zero.  This is only needed for the boot cpu.
+	 */
+	addq	$__per_cpu_load, early_gdt_descr_base
 #endif
 
 	/* Due to ENTRY(), sometimes the empty space gets filled with
@@ -224,10 +231,11 @@ ENTRY(secondary_startup_64)
 	 * that does in_interrupt() 
 	 */ 
 	movl	$MSR_GS_BASE,%ecx
-	movq	$empty_zero_page,%rax
+	movq	initial_pda(%rip), %rax
 	movq    %rax,%rdx
 	shrq	$32,%rdx
 	wrmsr	
+	movq	%rax,%gs:pda_data_offset
 
 	/* esi is pointer to real mode structure with interesting info.
 	   pass it to C */
@@ -250,6 +258,8 @@ ENTRY(secondary_startup_64)
 	.align	8
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
+	ENTRY(initial_pda)
+	.quad	__per_cpu_load
 	__FINITDATA
 
 	ENTRY(stack_start)
@@ -394,6 +404,7 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
+early_gdt_descr_base:
 	.quad   per_cpu__gdt_page
 
 ENTRY(phys_base)
--- linux-2.6.tip.orig/arch/x86/kernel/setup.c
+++ linux-2.6.tip/arch/x86/kernel/setup.c
@@ -30,6 +30,11 @@ DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_a
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
+#ifdef CONFIG_X86_64
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
+#endif
+
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 #define	X86_64_NUMA	1
 
@@ -48,7 +53,7 @@ static void __init setup_node_to_cpumask
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -95,64 +100,9 @@ static void __init setup_cpumask_of_cpu(
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
-
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
 
-/*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
- */
 void __init setup_per_cpu_areas(void)
 {
 	ssize_t size = PERCPU_ENOUGH_ROOM;
@@ -165,9 +115,6 @@ void __init setup_per_cpu_areas(void)
 	nr_cpu_ids = num_processors;
 #endif
 
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
@@ -187,9 +134,28 @@ void __init setup_per_cpu_areas(void)
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
--- linux-2.6.tip.orig/arch/x86/kernel/setup64.c
+++ linux-2.6.tip/arch/x86/kernel/setup64.c
@@ -35,9 +35,6 @@ struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
 char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
--- linux-2.6.tip.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.tip/arch/x86/kernel/smpboot.c
@@ -762,45 +762,6 @@ static void __cpuinit do_fork_idle(struc
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
@@ -818,16 +779,6 @@ static int __cpuinit do_boot_cpu(int api
 	};
 	INIT_WORK(&c_idle.work, do_fork_idle);
 
-#ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	if (cpu > 0) {
-		boot_error = get_local_pda(cpu);
-		if (boot_error)
-			goto restore_state;
-			/* if can't get pda memory, can't start cpu */
-	}
-#endif
-
 	alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
@@ -865,6 +816,7 @@ do_rest:
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+	initial_pda = (unsigned long)get_percpu_pda(cpu);
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
@@ -940,8 +892,6 @@ do_rest:
 		}
 	}
 
-restore_state:
-
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
--- linux-2.6.tip.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6.tip/arch/x86/kernel/vmlinux_64.lds.S
@@ -16,6 +16,7 @@ jiffies_64 = jiffies;
 _proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
+	percpu PT_LOAD FLAGS(7);	/* RWE */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
--- linux-2.6.tip.orig/include/asm-x86/desc.h
+++ linux-2.6.tip/include/asm-x86/desc.h
@@ -41,6 +41,11 @@ static inline struct desc_struct *get_cp
 
 #ifdef CONFIG_X86_64
 
+static inline struct x8664_pda *get_percpu_pda(unsigned int cpu)
+{
+	return &per_cpu(pda, cpu);
+}
+
 static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
--- linux-2.6.tip.orig/include/asm-x86/pda.h
+++ linux-2.6.tip/include/asm-x86/pda.h
@@ -37,10 +37,9 @@ struct x8664_pda {
 	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
-extern struct x8664_pda **_cpu_pda;
 extern void pda_init(int);
 
-#define cpu_pda(i) (_cpu_pda[i])
+#define cpu_pda(i) (&per_cpu(pda, i))
 
 /*
  * There is no fast way to get the base address of the PDA, all the accesses
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
+#ifdef CONFIG_SMP
 #define __my_cpu_offset read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
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
 
--- linux-2.6.tip.orig/include/asm-x86/trampoline.h
+++ linux-2.6.tip/include/asm-x86/trampoline.h
@@ -12,6 +12,7 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
+extern unsigned long initial_pda;
 
 #define TRAMPOLINE_BASE 0x6000
 extern unsigned long setup_trampoline(void);
