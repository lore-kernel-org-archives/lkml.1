Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbYDZASP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbYDZASP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760799AbYDZAP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:15:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59164 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753767AbYDZAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:50 -0400
Message-Id: <20080426001549.311788000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:50 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] x86: cleanup early per cpu variables/accesses v4
Content-Disposition: inline; filename=early_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
    used by some per_cpu variables that are initialized and accessed
    before there are per_cpu areas allocated.

    ["Early" in respect to per_cpu variables is "earlier than the per_cpu
    areas have been setup".]

    This patchset adds these new macros:

	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)
	EXPORT_EARLY_PER_CPU_SYMBOL(_name)
	DECLARE_EARLY_PER_CPU(_type, _name)

	early_per_cpu_ptr(_name)
	early_per_cpu_map(_name, _idx)
	early_per_cpu(_name, _cpu)

    The DEFINE macro defines the per_cpu variable as well as the early
    map and pointer.  It also initializes the per_cpu variable and map
    elements to "_initvalue".  The early_* macros provide access to
    the initial map (usually setup during system init) and the early
    pointer.  This pointer is initialized to point to the early map
    but is then NULL'ed when the actual per_cpu areas are setup.  After
    that the per_cpu variable is the correct access to the variable.

    The early_per_cpu() macro is not very efficient but does show how to
    access the variable if you have a function that can be called both
    "early" and "late".  It tests the early ptr to be NULL, and if not
    then it's still valid.  Otherwise, the per_cpu variable is used
    instead:

	#define early_per_cpu(_name, _cpu) 			\
		(early_per_cpu_ptr(_name) ?			\
			early_per_cpu_ptr(_name)[_cpu] :	\
			per_cpu(_name, _cpu))


    A better method is to actually check the pointer manually.  In the
    case below, numa_set_node can be called both "early" and "late":

	void __cpuinit numa_set_node(int cpu, int node)
	{
	    int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);

	    if (cpu_to_node_map)
		    cpu_to_node_map[cpu] = node;
	    else 
		    per_cpu(x86_cpu_to_node_map, cpu) = node;
	}

  * Add a flag "arch_provides_topology_pointers" that indicates pointers
    to topology cpumask_t maps are available.  Otherwise, use the function
    returning the cpumask_t value.  This is useful if cpumask_t set size
    is very large to avoid copying data on to/off of the stack.

  * The coverage of CONFIG_DEBUG_PER_CPU_MAPS has been increased while
    the non-debug case has been optimized a bit.

  * Remove an unreferenced compiler warning in drivers/base/topology.c

  * Clean up #ifdef in setup.c


For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v4:
    Some more minor cleanups (last 2 items above).

v3-folded:
    Folded in followon "fix" patches to consolidate changes into one place.
    Includes change to drivers/base/topology.c to fix s390 build error.
    Includes change to fix preemption warning when numa_node_id is used.

v2: Remerged PATCH 2/2 with latest x86.git/latest and sched-devel/latest,
    rebuilt and retested 4k-akpm2, 4k-defconfig, nonuma, & nosmp configs.
    Cleaned up asm-x86/topology.h a little bit.)

    (Removed checkpatch warnings and Cc list.)
---
 arch/x86/Kconfig           |    2 
 arch/x86/Kconfig.debug     |    2 
 arch/x86/kernel/apic_32.c  |    9 --
 arch/x86/kernel/apic_64.c  |   11 +--
 arch/x86/kernel/setup.c    |   99 +++++++++++++++++++++++++++----
 arch/x86/kernel/setup_32.c |   24 -------
 arch/x86/kernel/setup_64.c |    9 --
 arch/x86/kernel/smpboot.c  |   20 ------
 arch/x86/mm/numa_64.c      |   43 +++----------
 arch/x86/mm/srat_64.c      |    2 
 drivers/base/topology.c    |   25 +++++++
 include/asm-x86/numa_64.h  |   19 ++----
 include/asm-x86/percpu.h   |   46 ++++++++++++++
 include/asm-x86/smp.h      |   15 ----
 include/asm-x86/topology.h |  141 +++++++++++++++++++++++++--------------------
 15 files changed, 271 insertions(+), 196 deletions(-)

--- linux-2.6.sched.orig/arch/x86/Kconfig
+++ linux-2.6.sched/arch/x86/Kconfig
@@ -122,7 +122,7 @@ config ARCH_HAS_CPU_RELAX
 	def_bool y
 
 config HAVE_SETUP_PER_CPU_AREA
-	def_bool X86_64 || (X86_SMP && !X86_VOYAGER)
+	def_bool X86_64_SMP || (X86_SMP && !X86_VOYAGER)
 
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
--- linux-2.6.sched.orig/arch/x86/Kconfig.debug
+++ linux-2.6.sched/arch/x86/Kconfig.debug
@@ -56,7 +56,7 @@ config DEBUG_PAGEALLOC
 config DEBUG_PER_CPU_MAPS
 	bool "Debug access to per_cpu maps"
 	depends on DEBUG_KERNEL
-	depends on X86_64_SMP
+	depends on X86_SMP
 	default n
 	help
 	  Say Y to verify that the per_cpu map being accessed has
--- linux-2.6.sched.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6.sched/arch/x86/kernel/apic_32.c
@@ -52,9 +52,6 @@
 
 unsigned long mp_lapic_addr;
 
-DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
 /*
  * Knob to control our willingness to enable the local APIC.
  *
@@ -1538,9 +1535,9 @@ void __cpuinit generic_processor_info(in
 	}
 #ifdef CONFIG_SMP
 	/* are we being called early in kernel startup? */
-	if (x86_cpu_to_apicid_early_ptr) {
-		u16 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
-		u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
+		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
+		u16 *bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 
 		cpu_to_apicid[cpu] = apicid;
 		bios_cpu_apicid[cpu] = apicid;
--- linux-2.6.sched.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6.sched/arch/x86/kernel/apic_64.c
@@ -87,9 +87,6 @@ static unsigned long apic_phys;
 
 unsigned long mp_lapic_addr;
 
-DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
 unsigned int __cpuinitdata maxcpus = NR_CPUS;
 /*
  * Get the LAPIC version
@@ -1091,9 +1088,9 @@ void __cpuinit generic_processor_info(in
 		cpu = 0;
 	}
 	/* are we being called early in kernel startup? */
-	if (x86_cpu_to_apicid_early_ptr) {
-		u16 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
-		u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
+		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
+		u16 *bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 
 		cpu_to_apicid[cpu] = apicid;
 		bios_cpu_apicid[cpu] = apicid;
@@ -1269,7 +1266,7 @@ __cpuinit int apic_is_clustered_box(void
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
 		return 0;
 
-	bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
 	for (i = 0; i < NR_CPUS; i++) {
--- linux-2.6.sched.orig/arch/x86/kernel/setup.c
+++ linux-2.6.sched/arch/x86/kernel/setup.c
@@ -14,17 +14,28 @@
 
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
+
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
-DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
-
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+/* map cpu index to physical APIC ID */
+DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
+DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#define	X86_64_NUMA	1
+
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+#endif
+
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -35,20 +46,21 @@ static void __init setup_per_cpu_maps(vo
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		per_cpu(x86_cpu_to_apicid, cpu) = x86_cpu_to_apicid_init[cpu];
+		per_cpu(x86_cpu_to_apicid, cpu) =
+				early_per_cpu_map(x86_cpu_to_apicid, cpu);
 		per_cpu(x86_bios_cpu_apicid, cpu) =
-						x86_bios_cpu_apicid_init[cpu];
-#ifdef CONFIG_NUMA
+				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
+#ifdef X86_64_NUMA
 		per_cpu(x86_cpu_to_node_map, cpu) =
-						x86_cpu_to_node_map_init[cpu];
+				early_per_cpu_map(x86_cpu_to_node_map, cpu);
 #endif
 	}
 
 	/* indicate the early static arrays will soon be gone */
-	x86_cpu_to_apicid_early_ptr = NULL;
-	x86_bios_cpu_apicid_early_ptr = NULL;
-#ifdef CONFIG_NUMA
-	x86_cpu_to_node_map_early_ptr = NULL;
+	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
+	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
+#ifdef X86_64_NUMA
+	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 }
 
@@ -107,7 +119,8 @@ void __init setup_per_cpu_areas(void)
 		if (!node_online(node) || !NODE_DATA(node)) {
 			ptr = alloc_bootmem_pages(size);
 			printk(KERN_INFO
-			       "cpu %d has no node or node-local memory\n", i);
+			       "cpu %d has no node %d or node-local memory\n",
+				i, node);
 		}
 		else
 			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
@@ -135,3 +148,63 @@ void __init setup_per_cpu_areas(void)
 }
 
 #endif
+
+#ifdef X86_64_NUMA
+void __cpuinit numa_set_node(int cpu, int node)
+{
+	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
+
+	if (cpu_to_node_map)
+		cpu_to_node_map[cpu] = node;
+
+	else if (per_cpu_offset(cpu))
+		per_cpu(x86_cpu_to_node_map, cpu) = node;
+
+	else
+		Dprintk(KERN_INFO "Setting node for non-present cpu %d\n", cpu);
+}
+
+void __cpuinit numa_clear_node(int cpu)
+{
+	numa_set_node(cpu, NUMA_NO_NODE);
+}
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
+}
+#endif /* CONFIG_NUMA */
+
+#if defined(CONFIG_DEBUG_PER_CPU_MAPS) && defined(CONFIG_X86_64)
+
+int cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
+		printk(KERN_WARNING
+			"cpu_to_node(%d): usage too early!\n", cpu);
+		dump_stack();
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+EXPORT_SYMBOL(cpu_to_node);
+
+int early_cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map))
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+
+	if (!per_cpu_offset(cpu)) {
+		printk(KERN_WARNING
+			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
+			dump_stack();
+		return NUMA_NO_NODE;
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+#endif
--- linux-2.6.sched.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6.sched/arch/x86/kernel/setup_32.c
@@ -725,18 +725,6 @@ char * __init __attribute__((weak)) memo
 	return machine_specific_memory_setup();
 }
 
-#ifdef CONFIG_NUMA
-/*
- * In the golden day, when everything among i386 and x86_64 will be
- * integrated, this will not live here
- */
-void *x86_cpu_to_node_map_early_ptr;
-int x86_cpu_to_node_map_init[NR_CPUS] = {
-	[0 ... NR_CPUS-1] = NUMA_NO_NODE
-};
-DEFINE_PER_CPU(int, x86_cpu_to_node_map) = NUMA_NO_NODE;
-#endif
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -870,18 +858,6 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
-#ifdef CONFIG_X86_SMP
-	/*
-	 * setup to use the early static init tables during kernel startup
-	 * X86_SMP will exclude sub-arches that don't deal well with it.
-	 */
-	x86_cpu_to_apicid_early_ptr = (void *)x86_cpu_to_apicid_init;
-	x86_bios_cpu_apicid_early_ptr = (void *)x86_bios_cpu_apicid_init;
-#ifdef CONFIG_NUMA
-	x86_cpu_to_node_map_early_ptr = (void *)x86_cpu_to_node_map_init;
-#endif
-#endif
-
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif
--- linux-2.6.sched.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6.sched/arch/x86/kernel/setup_64.c
@@ -398,15 +398,6 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
-#ifdef CONFIG_SMP
-	/* setup to use the early static init tables during kernel startup */
-	x86_cpu_to_apicid_early_ptr = (void *)x86_cpu_to_apicid_init;
-	x86_bios_cpu_apicid_early_ptr = (void *)x86_bios_cpu_apicid_init;
-#ifdef CONFIG_NUMA
-	x86_cpu_to_node_map_early_ptr = (void *)x86_cpu_to_node_map_init;
-#endif
-#endif
-
 #ifdef CONFIG_ACPI
 	/*
 	 * Initialize the ACPI boot-time table parser (gets the RSDP and SDT).
--- linux-2.6.sched.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.sched/arch/x86/kernel/smpboot.c
@@ -68,22 +68,6 @@
 #include <mach_wakecpu.h>
 #include <smpboot_hooks.h>
 
-/*
- * FIXME: For x86_64, those are defined in other files. But moving them here,
- * would make the setup areas dependent on smp, which is a loss. When we
- * integrate apic between arches, we can probably do a better job, but
- * right now, they'll stay here -- glommer
- */
-
-/* which logical CPU number maps to which CPU (physical APIC ID) */
-u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
-			{ [0 ... NR_CPUS-1] = BAD_APICID };
-void *x86_cpu_to_apicid_early_ptr;
-
-u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
-				= { [0 ... NR_CPUS-1] = BAD_APICID };
-void *x86_bios_cpu_apicid_early_ptr;
-
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
 #endif
@@ -985,7 +969,7 @@ do_rest:
 		/* Try to put things back the way they were before ... */
 		unmap_cpu_to_logical_apicid(cpu);
 #ifdef CONFIG_X86_64
-		clear_node_cpumask(cpu); /* was set by numa_add_cpu */
+		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
 #endif
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
@@ -1364,7 +1348,7 @@ static void __ref remove_cpu_from_maps(i
 	cpu_clear(cpu, cpu_callin_map);
 	/* was set by cpu_init() */
 	clear_bit(cpu, (unsigned long *)&cpu_initialized);
-	clear_node_cpumask(cpu);
+	numa_remove_cpu(cpu);
 #endif
 }
 
--- linux-2.6.sched.orig/arch/x86/mm/numa_64.c
+++ linux-2.6.sched/arch/x86/mm/numa_64.c
@@ -31,16 +31,6 @@ bootmem_data_t plat_node_bdata[MAX_NUMNO
 
 struct memnode memnode;
 
-#ifdef CONFIG_SMP
-int x86_cpu_to_node_map_init[NR_CPUS] = {
-	[0 ... NR_CPUS-1] = NUMA_NO_NODE
-};
-void *x86_cpu_to_node_map_early_ptr;
-EXPORT_SYMBOL(x86_cpu_to_node_map_early_ptr);
-#endif
-DEFINE_PER_CPU(int, x86_cpu_to_node_map) = NUMA_NO_NODE;
-EXPORT_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-
 s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
@@ -578,24 +568,6 @@ void __init numa_initmem_init(unsigned l
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
 }
 
-__cpuinit void numa_add_cpu(int cpu)
-{
-	set_bit(cpu,
-		(unsigned long *)&node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-
-void __cpuinit numa_set_node(int cpu, int node)
-{
-	int *cpu_to_node_map = x86_cpu_to_node_map_early_ptr;
-
-	if(cpu_to_node_map)
-		cpu_to_node_map[cpu] = node;
-	else if(per_cpu_offset(cpu))
-		per_cpu(x86_cpu_to_node_map, cpu) = node;
-	else
-		Dprintk(KERN_INFO "Setting node for non-present cpu %d\n", cpu);
-}
-
 unsigned long __init numa_free_all_bootmem(void)
 {
 	unsigned long pages = 0;
@@ -642,6 +614,7 @@ static __init int numa_setup(char *opt)
 }
 early_param("numa", numa_setup);
 
+#ifdef CONFIG_NUMA
 /*
  * Setup early cpu_to_node.
  *
@@ -653,14 +626,19 @@ early_param("numa", numa_setup);
  * is already initialized in a round robin manner at numa_init_array,
  * prior to this call, and this initialization is good enough
  * for the fake NUMA cases.
+ *
+ * Called before the per_cpu areas are setup.
  */
 void __init init_cpu_to_node(void)
 {
-	int i;
+	int cpu;
+	u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	BUG_ON(cpu_to_apicid == NULL);
+
+	for_each_possible_cpu(cpu) {
 		int node;
-		u16 apicid = x86_cpu_to_apicid_init[i];
+		u16 apicid = cpu_to_apicid[cpu];
 
 		if (apicid == BAD_APICID)
 			continue;
@@ -669,8 +647,9 @@ void __init init_cpu_to_node(void)
 			continue;
 		if (!node_online(node))
 			continue;
-		numa_set_node(i, node);
+		numa_set_node(cpu, node);
 	}
 }
+#endif
 
 
--- linux-2.6.sched.orig/arch/x86/mm/srat_64.c
+++ linux-2.6.sched/arch/x86/mm/srat_64.c
@@ -403,7 +403,7 @@ int __init acpi_scan_nodes(unsigned long
 		if (node == NUMA_NO_NODE)
 			continue;
 		if (!node_isset(node, node_possible_map))
-			numa_set_node(i, NUMA_NO_NODE);
+			numa_clear_node(i);
 	}
 	numa_init_array();
 	return 0;
--- linux-2.6.sched.orig/drivers/base/topology.c
+++ linux-2.6.sched/drivers/base/topology.c
@@ -40,6 +40,7 @@ static ssize_t show_##name(struct sys_de
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
+#if defined(topology_thread_siblings) || defined(topology_core_siblings)
 static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
@@ -54,21 +55,41 @@ static ssize_t show_cpumap(int type, cpu
 	}
 	return n;
 }
+#endif
 
+#ifdef arch_provides_topology_pointers
 #define define_siblings_show_map(name)					\
-static inline ssize_t show_##name(struct sys_device *dev, char *buf)	\
+static ssize_t show_##name(struct sys_device *dev, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
 	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
-static inline ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
+static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
 {									\
 	unsigned int cpu = dev->id;					\
 	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
 }
 
+#else
+#define define_siblings_show_map(name)					\
+static ssize_t show_##name(struct sys_device *dev, char *buf)	\
+{									\
+	unsigned int cpu = dev->id;					\
+	cpumask_t mask = topology_##name(cpu);				\
+	return show_cpumap(0, &mask, buf);				\
+}
+
+#define define_siblings_show_list(name)					\
+static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
+{									\
+	unsigned int cpu = dev->id;					\
+	cpumask_t mask = topology_##name(cpu);				\
+	return show_cpumap(1, &mask, buf);				\
+}
+#endif
+
 #define define_siblings_show_func(name)		\
 	define_siblings_show_map(name); define_siblings_show_list(name)
 
--- linux-2.6.sched.orig/include/asm-x86/numa_64.h
+++ linux-2.6.sched/include/asm-x86/numa_64.h
@@ -14,11 +14,9 @@ extern int compute_hash_shift(struct boo
 
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
-extern void numa_add_cpu(int cpu);
 extern void numa_init_array(void);
 extern int numa_off;
 
-extern void numa_set_node(int cpu, int node);
 extern void srat_reserve_add_area(int nodeid);
 extern int hotadd_percent;
 
@@ -31,15 +29,16 @@ extern void setup_node_bootmem(int nodei
 
 #ifdef CONFIG_NUMA
 extern void __init init_cpu_to_node(void);
-
-static inline void clear_node_cpumask(int cpu)
-{
-	clear_bit(cpu, (unsigned long *)&node_to_cpumask_map[cpu_to_node(cpu)]);
-}
-
+extern void __cpuinit numa_set_node(int cpu, int node);
+extern void __cpuinit numa_clear_node(int cpu);
+extern void __cpuinit numa_add_cpu(int cpu);
+extern void __cpuinit numa_remove_cpu(int cpu);
 #else
-#define init_cpu_to_node() do {} while (0)
-#define clear_node_cpumask(cpu) do {} while (0)
+static inline void init_cpu_to_node(void)		{ }
+static inline void numa_set_node(int cpu, int node)	{ }
+static inline void numa_clear_node(int cpu)		{ }
+static inline void numa_add_cpu(int cpu, int node)	{ }
+static inline void numa_remove_cpu(int cpu)		{ }
 #endif
 
 #endif
--- linux-2.6.sched.orig/include/asm-x86/percpu.h
+++ linux-2.6.sched/include/asm-x86/percpu.h
@@ -143,4 +143,50 @@ do {							\
 #define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
 #endif /* !__ASSEMBLY__ */
 #endif /* !CONFIG_X86_64 */
+
+#ifdef CONFIG_SMP
+
+/*
+ * Define the "EARLY_PER_CPU" macros.  These are used for some per_cpu
+ * variables that are initialized and accessed before there are per_cpu
+ * areas allocated.
+ */
+
+#define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)			\
+	DEFINE_PER_CPU(_type, _name) = _initvalue;			\
+	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\
+				{ [0 ... NR_CPUS-1] = _initvalue };	\
+	__typeof__(_type) *_name##_early_ptr = _name##_early_map
+
+#define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
+	EXPORT_PER_CPU_SYMBOL(_name)
+
+#define DECLARE_EARLY_PER_CPU(_type, _name)			\
+	DECLARE_PER_CPU(_type, _name);				\
+	extern __typeof__(_type) *_name##_early_ptr;		\
+	extern __typeof__(_type)  _name##_early_map[]
+
+#define	early_per_cpu_ptr(_name) (_name##_early_ptr)
+#define	early_per_cpu_map(_name, _idx) (_name##_early_map[_idx])
+#define	early_per_cpu(_name, _cpu) 				\
+	(early_per_cpu_ptr(_name) ?				\
+		early_per_cpu_ptr(_name)[_cpu] :		\
+		per_cpu(_name, _cpu))
+
+#else	/* !CONFIG_SMP */
+#define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)		\
+	DEFINE_PER_CPU(_type, _name) = _initvalue
+
+#define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
+	EXPORT_PER_CPU_SYMBOL(_name)
+
+#define DECLARE_EARLY_PER_CPU(_type, _name)			\
+	DECLARE_PER_CPU(_type, _name)
+
+#define	early_per_cpu(_name, _cpu) per_cpu(_name, _cpu)
+#define	early_per_cpu_ptr(_name) NULL
+/* no early_per_cpu_map() */
+
+#endif	/* !CONFIG_SMP */
+
 #endif /* _ASM_X86_PERCPU_H_ */
--- linux-2.6.sched.orig/include/asm-x86/smp.h
+++ linux-2.6.sched/include/asm-x86/smp.h
@@ -29,21 +29,12 @@ extern int smp_num_siblings;
 extern unsigned int num_processors;
 extern cpumask_t cpu_initialized;
 
-#ifdef CONFIG_SMP
-extern u16 x86_cpu_to_apicid_init[];
-extern u16 x86_bios_cpu_apicid_init[];
-extern void *x86_cpu_to_apicid_early_ptr;
-extern void *x86_bios_cpu_apicid_early_ptr;
-#else
-#define x86_cpu_to_apicid_early_ptr NULL
-#define x86_bios_cpu_apicid_early_ptr NULL
-#endif
-
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
-DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
-DECLARE_PER_CPU(u16, x86_bios_cpu_apicid);
+
+DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
+DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
 /* Static state in head.S used to set up a CPU */
 extern struct {
--- linux-2.6.sched.orig/include/asm-x86/topology.h
+++ linux-2.6.sched/include/asm-x86/topology.h
@@ -25,87 +25,67 @@
 #ifndef _ASM_X86_TOPOLOGY_H
 #define _ASM_X86_TOPOLOGY_H
 
+/* Node not present */
+#define NUMA_NO_NODE	(-1)
+
 #ifdef CONFIG_NUMA
 #include <linux/cpumask.h>
 #include <asm/mpspec.h>
 
-/* Mappings between logical cpu number and node number */
 #ifdef CONFIG_X86_32
-extern int cpu_to_node_map[];
-#else
-/* Returns the number of the current Node. */
-#define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
-#endif
-
-DECLARE_PER_CPU(int, x86_cpu_to_node_map);
-
-#ifdef CONFIG_SMP
-extern int x86_cpu_to_node_map_init[];
-extern void *x86_cpu_to_node_map_early_ptr;
-#else
-#define x86_cpu_to_node_map_early_ptr NULL
-#endif
 
+/* Mappings between node number and cpus on that node. */
 extern cpumask_t node_to_cpumask_map[];
 
-#define NUMA_NO_NODE	(-1)
+/* Mappings between logical cpu number and node number */
+extern int cpu_to_node_map[];
 
 /* Returns the number of the node containing CPU 'cpu' */
-#ifdef CONFIG_X86_32
-#define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 static inline int cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
+#define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
 #else /* CONFIG_X86_64 */
 
-#ifdef CONFIG_SMP
-static inline int early_cpu_to_node(int cpu)
-{
-	int *cpu_to_node_map = x86_cpu_to_node_map_early_ptr;
+/* Mappings between node number and cpus on that node. */
+extern cpumask_t node_to_cpumask_map[];
 
-	if (cpu_to_node_map)
-		return cpu_to_node_map[cpu];
-	else if (per_cpu_offset(cpu))
-		return per_cpu(x86_cpu_to_node_map, cpu);
-	else
-		return NUMA_NO_NODE;
-}
-#else
-#define	early_cpu_to_node(cpu)	cpu_to_node(cpu)
-#endif
+/* Mappings between logical cpu number and node number */
+DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
+
+/* Returns the number of the current Node. */
+#define numa_node_id()	(per_cpu(x86_cpu_to_node_map, raw_smp_processor_id()))
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+extern int cpu_to_node(int cpu);
+extern int early_cpu_to_node(int cpu);
+extern cpumask_t *_node_to_cpumask_ptr(int node);
+extern cpumask_t node_to_cpumask(int node);
+
+#else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
+/* Returns the number of the node containing CPU 'cpu' */
 static inline int cpu_to_node(int cpu)
 {
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-	if (x86_cpu_to_node_map_early_ptr) {
-		printk("KERN_NOTICE cpu_to_node(%d): usage too early!\n",
-		       (int)cpu);
-		dump_stack();
-		return ((int *)x86_cpu_to_node_map_early_ptr)[cpu];
-	}
-#endif
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
-#ifdef	CONFIG_NUMA
-
-/* Returns a pointer to the cpumask of CPUs on Node 'node'. */
-#define node_to_cpumask_ptr(v, node)		\
-		cpumask_t *v = &(node_to_cpumask_map[node])
-
-#define node_to_cpumask_ptr_next(v, node)	\
-			   v = &(node_to_cpumask_map[node])
-#endif
+/* Same function but used if called before per_cpu areas are setup */
+static inline int early_cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map))
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
 
-#endif /* CONFIG_X86_64 */
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
 
-/*
- * Returns the number of the node containing Node 'node'. This
- * architecture is flat, so it is a pretty simple function!
- */
-#define parent_node(node) (node)
+/* Returns a pointer to the cpumask of CPUs on Node 'node'. */
+static inline cpumask_t *_node_to_cpumask_ptr(int node)
+{
+	return &node_to_cpumask_map[node];
+}
 
 /* Returns a bitmask of CPUs on Node 'node'. */
 static inline cpumask_t node_to_cpumask(int node)
@@ -113,14 +93,29 @@ static inline cpumask_t node_to_cpumask(
 	return node_to_cpumask_map[node];
 }
 
+#endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
+#endif /* CONFIG_X86_64 */
+
+/* Replace default node_to_cpumask_ptr with optimized version */
+#define node_to_cpumask_ptr(v, node)		\
+		cpumask_t *v = _node_to_cpumask_ptr(node)
+
+#define node_to_cpumask_ptr_next(v, node)	\
+			   v = _node_to_cpumask_ptr(node)
+
 /* Returns the number of the first CPU on Node 'node'. */
 static inline int node_to_first_cpu(int node)
 {
-	cpumask_t mask = node_to_cpumask(node);
-
-	return first_cpu(mask);
+	node_to_cpumask_ptr(mask, node);
+	return first_cpu(*mask);
 }
 
+/*
+ * Returns the number of the node containing Node 'node'. This
+ * architecture is flat, so it is a pretty simple function!
+ */
+#define parent_node(node) (node)
+
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 #define pcibus_to_cpumask(bus) __pcibus_to_cpumask(bus)
 
@@ -178,8 +173,31 @@ extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
 
-#else /* CONFIG_NUMA */
+#else /* !CONFIG_NUMA */
+
+#define numa_node_id()		0
+#define	cpu_to_node(cpu)	0
+#define	early_cpu_to_node(cpu)	0
+
+static inline cpumask_t *_node_to_cpumask_ptr(int node)
+{
+	return &cpu_online_map;
+}
+static inline cpumask_t node_to_cpumask(int node)
+{
+	return cpu_online_map;
+}
+static inline int node_to_first_cpu(int node)
+{
+	return first_cpu(cpu_online_map);
+}
+
+/* Replace default node_to_cpumask_ptr with optimized version */
+#define node_to_cpumask_ptr(v, node)		\
+		cpumask_t *v = _node_to_cpumask_ptr(node)
 
+#define node_to_cpumask_ptr_next(v, node)	\
+			   v = _node_to_cpumask_ptr(node)
 #endif
 
 #include <asm-generic/topology.h>
@@ -191,6 +209,9 @@ extern cpumask_t cpu_coregroup_map(int c
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 #define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
+
+/* indicates that pointers to the topology cpumask_t maps are valid */
+#define arch_provides_topology_pointers		yes
 #endif
 
 struct pci_bus;
@@ -214,4 +235,4 @@ static inline void set_mp_bus_to_node(in
 }
 #endif
 
-#endif
+#endif /* _ASM_X86_TOPOLOGY_H */

-- 
