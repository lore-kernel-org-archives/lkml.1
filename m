Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYGYVM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYGYVM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbYGYVLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:11:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53615 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755762AbYGYVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:11:19 -0400
Message-Id: <20080725211118.089278000@polaris-admin.engr.sgi.com>
References: <20080725211117.586723000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jul 2008 14:11:20 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 3/4] x86_64: Fold pda into per cpu area
Content-Disposition: inline; filename=fold_pda_into_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: there are two FIXME's in arch/x86/xen/enlighten.c
	 and arch/x86/xen/smp.c that I'm not sure how to handle...?

  * Declare the pda as a per cpu variable.

  * Relocate the initial pda in head_64.S for the boot cpu (0).
    For secondary cpus, do_boot_cpu() sets up the correct initial pda.

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/common_64.c |    4 -
 arch/x86/kernel/head64.c        |   29 +-----------
 arch/x86/kernel/head_64.S       |   19 ++++++--
 arch/x86/kernel/setup_percpu.c  |   93 +++++++++++-----------------------------
 arch/x86/kernel/smpboot.c       |   53 ----------------------
 arch/x86/xen/enlighten.c        |   10 ++++
 arch/x86/xen/smp.c              |   11 +---
 include/asm-x86/desc.h          |    5 ++
 include/asm-x86/pda.h           |    3 -
 include/asm-x86/percpu.h        |   13 -----
 include/asm-x86/setup.h         |    1 
 include/asm-x86/smp.h           |    2 
 include/asm-x86/trampoline.h    |    1 
 13 files changed, 72 insertions(+), 172 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/common_64.c
@@ -418,8 +418,8 @@ __setup("clearcpuid=", setup_disablecpui
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
--- linux-2.6.tip.orig/arch/x86/kernel/head64.c
+++ linux-2.6.tip/arch/x86/kernel/head64.c
@@ -25,27 +25,6 @@
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
-void __init x86_64_init_pda(void)
-{
-	_cpu_pda = __cpu_pda;
-	cpu_pda(0) = &_boot_cpu_pda;
-	pda_init(0);
-}
-
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
@@ -98,6 +77,10 @@ void __init x86_64_start_kernel(char * r
 	/* Cleanup the over mapped high alias */
 	cleanup_highmap();
 
+	/* Initialize boot cpu_pda data */
+	/* (See head_64.S for earlier pda/gdt initialization) */
+	pda_init(0);
+
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
@@ -109,10 +92,6 @@ void __init x86_64_start_kernel(char * r
 
 	early_printk("Kernel alive\n");
 
-	x86_64_init_pda();
-
-	early_printk("Kernel really alive\n");
-
 	x86_64_start_reservations(real_mode_data);
 }
 
--- linux-2.6.tip.orig/arch/x86/kernel/head_64.S
+++ linux-2.6.tip/arch/x86/kernel/head_64.S
@@ -248,14 +248,21 @@ ENTRY(secondary_startup_64)
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
@@ -278,6 +285,12 @@ ENTRY(secondary_startup_64)
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
--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -134,56 +134,8 @@ unsigned long __per_cpu_offset[NR_CPUS] 
 #endif
 EXPORT_SYMBOL(__per_cpu_offset);
 
-#if !defined(CONFIG_SMP) || !defined(CONFIG_X86_64)
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
-			DBG("cpu %4d pda %p\n", cpu, cpu_pda(0));
-			continue;
-		}
-		DBG("cpu %4d pda %p\n", cpu, pda);
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
 /*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
+ * Allocate and initialize the per cpu areas which include the PDAs.
  */
 void __init setup_per_cpu_areas(void)
 {
@@ -191,16 +143,11 @@ void __init setup_per_cpu_areas(void)
 	char *ptr;
 	int cpu;
 
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
-	DBG("PERCPU: __per_cpu_start %p\n", __per_cpu_start);
-
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 		ptr = alloc_bootmem_pages(size);
@@ -215,26 +162,38 @@ void __init setup_per_cpu_areas(void)
 		else
 			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
 #endif
-		DBG("PERCPU: cpu %4d %p pda %p %p\n",
-			     cpu, ptr, _cpu_pda[cpu], cpu_pda(cpu));
-
 		/* Initialize each cpu's per_cpu area and save pointer */
 		memcpy(ptr, __per_cpu_load, __per_cpu_size);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 
-#ifdef CONFIG_X86_64
-		/* save for __my_cpu_offset() */
-		cpu_pda(cpu)->data_offset = (unsigned long)ptr;
+		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 
+#ifdef CONFIG_X86_64
 		/*
-		 * The boot cpu gdt page must be reloaded as we moved it
-		 * from the static per cpu area to the newly allocated area.
+		 * Note the boot cpu (0) has been using the static per_cpu load
+		 * area for it's pda.  We need to zero out the pdas for the
+		 * other cpus that are coming online.
+		 *
+		 * Additionally, for the boot cpu the gdt page must be reloaded
+		 * as we moved it from the static per cpu area to the newly
+		 * allocated area.
 		 */
-		if (cpu == 0) {
-			struct desc_ptr	gdt_descr = early_gdt_descr;
-
-			gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
-			native_load_gdt(&gdt_descr);
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
 		}
 #endif
 	}
--- linux-2.6.tip.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.tip/arch/x86/kernel/smpboot.c
@@ -744,45 +744,6 @@ static void __cpuinit do_fork_idle(struc
 	complete(&c_idle->done);
 }
 
-#ifdef CONFIG_X86_64
-/*
- * Allocate node local memory for the AP pda.
- *
- * Must be called after the _cpu_pda pointer table is initialized.
- */
-int __cpuinit get_local_pda(int cpu)
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
@@ -800,16 +761,6 @@ static int __cpuinit do_boot_cpu(int api
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
@@ -847,6 +798,7 @@ do_rest:
 #else
 	cpu_pda(cpu)->pcurrent = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+	initial_pda = (unsigned long)get_cpu_pda(cpu);
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
@@ -921,9 +873,6 @@ do_rest:
 				inquire_remote_apic(apicid);
 		}
 	}
-#ifdef CONFIG_X86_64
-restore_state:
-#endif
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
--- linux-2.6.tip.orig/arch/x86/xen/enlighten.c
+++ linux-2.6.tip/arch/x86/xen/enlighten.c
@@ -1748,8 +1748,18 @@ asmlinkage void __init xen_start_kernel(
 #ifdef CONFIG_X86_64
 	/* Disable until direct per-cpu data access. */
 	have_vcpu_info_placement = 0;
+#if 0
+	/*
+	 * FIXME: is the above still true?
+	 * Also, x86_64_init_pda() has been removed...
+	 *   should anything replace it?
+	 *   (The offset for cpu_pda(0) is statically initialized
+	 *   to __per_cpu_load, while the remaining pda's come online
+	 *   in setup_per_cpu_areas().)
+	 */
 	x86_64_init_pda();
 #endif
+#endif
 
 	xen_smp_init();
 
--- linux-2.6.tip.orig/arch/x86/xen/smp.c
+++ linux-2.6.tip/arch/x86/xen/smp.c
@@ -285,13 +285,10 @@ static int __cpuinit xen_cpu_up(unsigned
 #endif
 
 #ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	WARN_ON(cpu == 0);
-	if (cpu > 0) {
-		rc = get_local_pda(cpu);
-		if (rc)
-			return rc;
-	}
+	/*
+	 * FIXME: I don't believe that calling get_local_pda() is
+	 * required any more...?
+	 */
 #endif
 
 #ifdef CONFIG_X86_32
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
 
--- linux-2.6.tip.orig/include/asm-x86/setup.h
+++ linux-2.6.tip/include/asm-x86/setup.h
@@ -92,7 +92,6 @@ extern unsigned long init_pg_tables_star
 extern unsigned long init_pg_tables_end;
 
 #else
-void __init x86_64_init_pda(void);
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
 
--- linux-2.6.tip.orig/include/asm-x86/smp.h
+++ linux-2.6.tip/include/asm-x86/smp.h
@@ -25,8 +25,6 @@ extern cpumask_t cpu_callin_map;
 extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
 
-extern int __cpuinit get_local_pda(int cpu);
-
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 extern cpumask_t cpu_initialized;
--- linux-2.6.tip.orig/include/asm-x86/trampoline.h
+++ linux-2.6.tip/include/asm-x86/trampoline.h
@@ -12,6 +12,7 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
+extern unsigned long initial_pda;
 
 #define TRAMPOLINE_BASE 0x6000
 extern unsigned long setup_trampoline(void);

-- 
