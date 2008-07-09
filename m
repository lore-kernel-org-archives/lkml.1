Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYGIQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYGIQwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYGIQvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751851AbYGIQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:30 -0400
Message-Id: <20080709165129.610711000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:31 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 02/15] x86_64: Fold pda into per cpu area
Content-Disposition: inline; filename=zero_based_fold
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: there is still a FIXME in this patch (see arch/x86/kernel/acpi/sleep.c)

  * Declare the pda as a per cpu variable.

  * Make the x86_64 per cpu area start at zero.

  * Relocate the initial pda and per_cpu(gdt_page) in head_64.S for the
    boot cpu (0).  For secondary cpus, do_boot_cpu() sets up the correct
    initial pda and gdt_page pointer.

  * Initialize per_cpu_offset to point to static pda in the per_cpu area
    (@ __per_cpu_load).

  * After allocation of the per cpu area for the boot cpu (0), reload the
    gdt page pointer.

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig                 |    3 +
 arch/x86/kernel/acpi/sleep.c     |    9 +++
 arch/x86/kernel/cpu/common_64.c  |    4 -
 arch/x86/kernel/head64.c         |   24 +--------
 arch/x86/kernel/head_64.S        |   45 ++++++++++++++++--
 arch/x86/kernel/setup_percpu.c   |   94 +++++++++++++++++----------------------
 arch/x86/kernel/smpboot.c        |   52 ---------------------
 arch/x86/kernel/vmlinux_64.lds.S |    1 
 include/asm-x86/desc.h           |    5 ++
 include/asm-x86/pda.h            |    3 -
 include/asm-x86/percpu.h         |   13 -----
 include/asm-x86/trampoline.h     |    1 
 12 files changed, 112 insertions(+), 142 deletions(-)

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
@@ -89,6 +89,15 @@ int acpi_save_state_mem(void)
 #ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + 4096;
 #endif
+	/*
+	 * FIXME: with zero-based percpu variables, the pda and gdt_page
+	 * addresses must be offset by the base of this cpu's percpu area.
+	 * Where/how should we do this?
+	 *
+	 * for secondary cpu startup in smpboot.c:do_boot_cpu() this is done:
+	 *	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+	 *	initial_pda = (unsigned long)get_cpu_pda(cpu);
+	 */
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/common_64.c
@@ -423,8 +423,8 @@ __setup("clearcpuid=", setup_disablecpui
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
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
@@ -91,6 +77,10 @@ void __init x86_64_start_kernel(char * r
 	/* Cleanup the over mapped high alias */
 	cleanup_highmap();
 
+	/* Initialize boot cpu_pda data */
+	/* (See head_64.S for earlier pda/gdt initialization) */
+	pda_init(0);
+
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
@@ -102,12 +92,6 @@ void __init x86_64_start_kernel(char * r
 
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
@@ -203,7 +204,27 @@ ENTRY(secondary_startup_64)
 	 * addresses where we're currently running on. We have to do that here
 	 * because in 32bit we couldn't load a 64bit linear address.
 	 */
-	lgdt	early_gdt_descr(%rip)
+
+#ifdef CONFIG_SMP
+	 /*
+	 * For zero-based percpu variables, the base (__per_cpu_load) must
+	 * be added to the offset of per_cpu__gdt_page.  This is only needed
+	 * for the boot cpu but we can't do this prior to secondary_startup_64.
+	 * So we use a NULL gdt adrs to indicate that we are starting up the
+	 * boot cpu and not the secondary cpus.  do_boot_cpu() will fixup
+	 * the gdt adrs for those cpus.
+	 */
+#define PER_CPU_GDT_PAGE	0
+	movq	early_gdt_descr_base(%rip), %rax
+	testq	%rax, %rax
+	jnz	1f
+	movq	$__per_cpu_load, %rax
+	addq	$per_cpu__gdt_page, %rax
+	movq	%rax, early_gdt_descr_base(%rip)
+#else
+#define PER_CPU_GDT_PAGE	per_cpu__gdt_page
+#endif
+1:	lgdt	early_gdt_descr(%rip)
 
 	/* set up data segments. actually 0 would do too */
 	movl $__KERNEL_DS,%eax
@@ -220,14 +241,21 @@ ENTRY(secondary_startup_64)
 	movl %eax,%gs
 
 	/* 
-	 * Setup up a dummy PDA. this is just for some early bootup code
-	 * that does in_interrupt() 
+	 * Setup up the real PDA.
+	 *
+	 * For SMP, the boot cpu (0) uses the static pda which is the first
+	 * element in the percpu area (@__per_cpu_load).  This pda is moved
+	 * to the real percpu area once that is allocated.  Secondary cpus
+	 * will use the initial_pda value setup in do_boot_cpu().
 	 */ 
 	movl	$MSR_GS_BASE,%ecx
-	movq	$empty_zero_page,%rax
+	movq	initial_pda(%rip), %rax
 	movq    %rax,%rdx
 	shrq	$32,%rdx
 	wrmsr	
+#ifdef CONFIG_SMP
+	movq	%rax, %gs:pda_data_offset
+#endif
 
 	/* esi is pointer to real mode structure with interesting info.
 	   pass it to C */
@@ -250,6 +278,12 @@ ENTRY(secondary_startup_64)
 	.align	8
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
+	ENTRY(initial_pda)
+#ifdef CONFIG_SMP
+	.quad	__per_cpu_load		# Overwritten for secondary CPUs
+#else
+	.quad	per_cpu__pda
+#endif
 	__FINITDATA
 
 	ENTRY(stack_start)
@@ -394,7 +428,8 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
-	.quad   per_cpu__gdt_page
+early_gdt_descr_base:
+	.quad	PER_CPU_GDT_PAGE	# Overwritten for secondary CPUs
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -14,6 +14,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
+#include <asm/desc.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
@@ -119,63 +120,26 @@ static void __init setup_cpumask_of_cpu(
 static inline void setup_cpumask_of_cpu(void) { }
 #endif
 
-#ifdef CONFIG_X86_32
 /*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
+ * Pointers to per cpu areas for each cpu
  */
+#ifndef CONFIG_HAVE_ZERO_BASED_PER_CPU
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
-static inline void setup_cpu_pda_map(void) { }
-
-#elif !defined(CONFIG_SMP)
-static inline void setup_cpu_pda_map(void) { }
-
-#else /* CONFIG_SMP && CONFIG_X86_64 */
+#else
 
 /*
- * Allocate cpu_pda pointer table and array via alloc_bootmem.
+ * Initialize percpu offset for boot cpu (0) to static percpu area
+ * for referencing very early in kernel startup.
  */
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
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
+	[0] = (unsigned long)__per_cpu_load
+};
+EXPORT_SYMBOL(__per_cpu_offset);
 #endif
 
 /*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
+ * Allocate and initialize the per cpu areas which include the PDAs.
  */
 void __init setup_per_cpu_areas(void)
 {
@@ -193,9 +157,6 @@ void __init setup_per_cpu_areas(void)
 	nr_cpu_ids = num_processors;
 #endif
 
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
@@ -215,10 +176,41 @@ void __init setup_per_cpu_areas(void)
 		else
 			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
 #endif
+		/* Initialize each cpu's per_cpu area and save pointer */
+		memcpy(ptr, __per_cpu_load, __per_cpu_size);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
+
+#ifdef CONFIG_X86_64
+		/*
+		 * Note the boot cpu (0) has been using the static per_cpu load
+		 * area for it's pda.  We need to zero out the pdas for the
+		 * other cpus that are coming online.
+		 *
+		 * Additionally, for the boot cpu the gdt page must be reloaded
+		 * as we moved it from the static per cpu area to the newly
+		 * allocated area.
+		 */
+		{
+			/* We rely on the fact that pda is the first element */
+			struct x8664_pda *pda = (struct x8664_pda *)ptr;
+
+			if (cpu) {
+				memset(pda, 0, sizeof(*pda));
+				pda->data_offset = (unsigned long)ptr;
+			} else {
+				struct desc_ptr	gdt_descr = early_gdt_descr;
+
+				pda->data_offset = (unsigned long)ptr;
+				gdt_descr.address =
+					(unsigned long)get_cpu_gdt_table(0);
+				native_load_gdt(&gdt_descr);
+				pda_init(0);
+			}
+
+		}
+#endif
 	}
 
 	printk(KERN_INFO "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
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
+	initial_pda = (unsigned long)get_cpu_pda(cpu);
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
 
+static inline struct x8664_pda *get_cpu_pda(unsigned int cpu)
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
+#define cpu_pda(cpu) (&per_cpu(pda, cpu))
 
 /*
  * There is no fast way to get the base address of the PDA, all the accesses
--- linux-2.6.tip.orig/include/asm-x86/percpu.h
+++ linux-2.6.tip/include/asm-x86/percpu.h
@@ -3,20 +3,11 @@
 
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
+/* Same as asm-generic/percpu.h */
+#ifdef CONFIG_SMP
 #define __my_cpu_offset read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
 #endif
 #include <asm-generic/percpu.h>
 
--- linux-2.6.tip.orig/include/asm-x86/trampoline.h
+++ linux-2.6.tip/include/asm-x86/trampoline.h
@@ -12,6 +12,7 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
+extern unsigned long initial_pda;
 
 #define TRAMPOLINE_BASE 0x6000
 extern unsigned long setup_trampoline(void);

-- 
