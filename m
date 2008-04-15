Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbYDOUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbYDOUIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761514AbYDOUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:07:28 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55319 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758238AbYDOUHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:07:25 -0400
Message-Id: <20080415200724.582628000@polaris-admin.engr.sgi.com>
References: <20080415200724.217829000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Apr 2008 13:07:26 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: [PATCH 2/2] x86: cleanup early per cpu variables/accesses
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

  * Additionally, some scattered x86 code variations are consolidated
    aiding the merger of i386/x86_64.  The affected variables are:

	x86_bios_cpu_apicid
	x86_cpu_to_apicid
	x86_cpu_to_node_map
	node_to_cpumask_map
	cpu_to_node_map(removed)

  * Change some calls from early_cpu_to_node to (non-early) cpu_to_node.
    This reduces the amount of code generated.  An example is:

     /* Returns the number of the current Node. */
    -#define numa_node_id()	(early_cpu_to_node(raw_smp_processor_id()))
    +#define numa_node_id()	(__get_cpu_var(x86_cpu_to_node_map))

    In this case,  x86_cpu_to_node_map will always be correct.  If it's
    running on the boot cpu (which is always granted cpu index of 0 and
    it's node will also be zero) then it is initialized correctly.
    If, for some reason the system needs to re-boot say a guest OS, with
    a cpu/node other than zero, then the initial cpu and node indices
    should be adjusted before continuing startup.

  * The coverage of CONFIG_DEBUG_PER_CPU_MAPS has been increased while
    the non-debug case has been optimized a bit.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

# for checkpatch "incidents":
Cc:      Andy Whitcroft <apw@shadowen.org>
Cc:      Randy Dunlap <rdunlap@xenotime.net>
Cc:      Joel Schopp <jschopp@austin.ibm.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
checkpatch.pl results: 3 "errors"/1 "warning"...

I'm not sure how to reformat this to get rid of these errors/warnings:

#define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)			\
	DEFINE_PER_CPU(_type, _name) = _initvalue;			\
	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\
				{ [0 ... NR_CPUS-1] = _initvalue };	\
	__typeof__(_type) *_name##_early_ptr = _name##_early_map

#define DECLARE_EARLY_PER_CPU(_type, _name)			\
	DECLARE_PER_CPU(_type, _name);				\
	extern __typeof__(_type) *_name##_early_ptr;		\
	extern __typeof__(_type)  _name##_early_map[]

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#601: FILE: include/asm-x86/percpu.h:156:
+	DEFINE_PER_CPU(_type, _name) = _initvalue;			\

WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
#602: FILE: include/asm-x86/percpu.h:157:
+	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\

WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
#603: FILE: include/asm-x86/percpu.h:158:
+				{ [0 ... NR_CPUS-1] = _initvalue };	\

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#610: FILE: include/asm-x86/percpu.h:165:
+	DECLARE_PER_CPU(_type, _name);				\

total: 3 errors, 2 warnings, 659 lines checked
---
 arch/x86/kernel/apic_32.c  |    9 +--
 arch/x86/kernel/apic_64.c  |   11 +---
 arch/x86/kernel/setup.c    |   79 ++++++++++++++++++++++++++++----
 arch/x86/kernel/setup_32.c |   24 ----------
 arch/x86/kernel/setup_64.c |    9 ---
 arch/x86/kernel/smpboot.c  |   41 +++--------------
 arch/x86/mm/numa_64.c      |   43 ++++-------------
 include/asm-x86/numa.h     |   28 +++++++++++
 include/asm-x86/numa_64.h  |   15 ------
 include/asm-x86/percpu.h   |   46 +++++++++++++++++++
 include/asm-x86/smp.h      |   15 +-----
 include/asm-x86/topology.h |  108 ++++++++++++++++++++-------------------------
 12 files changed, 221 insertions(+), 207 deletions(-)

--- linux-2.6.x86.sched.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6.x86.sched/arch/x86/kernel/apic_32.c
@@ -52,9 +52,6 @@
 
 unsigned long mp_lapic_addr;
 
-DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
 /*
  * Knob to control our willingness to enable the local APIC.
  *
@@ -1533,9 +1530,9 @@ void __cpuinit generic_processor_info(in
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
--- linux-2.6.x86.sched.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6.x86.sched/arch/x86/kernel/apic_64.c
@@ -87,9 +87,6 @@ static unsigned long apic_phys;
 
 unsigned long mp_lapic_addr;
 
-DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
 unsigned int __cpuinitdata maxcpus = NR_CPUS;
 /*
  * Get the LAPIC version
@@ -1090,9 +1087,9 @@ void __cpuinit generic_processor_info(in
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
@@ -1268,7 +1265,7 @@ __cpuinit int apic_is_clustered_box(void
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
 		return 0;
 
-	bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
 	for (i = 0; i < NR_CPUS; i++) {
--- linux-2.6.x86.sched.orig/arch/x86/kernel/setup.c
+++ linux-2.6.x86.sched/arch/x86/kernel/setup.c
@@ -18,13 +18,21 @@ unsigned disabled_cpus __cpuinitdata;
 unsigned int boot_cpu_physical_apicid = -1U;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
+/* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
 
-DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
-EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
+/* map cpu index to physical APIC ID */
+DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
+DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
 
-/* Bitmask of physically existing CPUs */
-physid_mask_t phys_cpu_present_map;
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
+
+/* map cpu index to node index */
+#ifdef CONFIG_NUMA
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+#endif
 
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
 /*
@@ -37,20 +45,21 @@ static void __init setup_per_cpu_maps(vo
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		per_cpu(x86_cpu_to_apicid, cpu) = x86_cpu_to_apicid_init[cpu];
+		per_cpu(x86_cpu_to_apicid, cpu) =
+				early_per_cpu_map(x86_cpu_to_apicid, cpu);
 		per_cpu(x86_bios_cpu_apicid, cpu) =
-						x86_bios_cpu_apicid_init[cpu];
+				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
 #ifdef CONFIG_NUMA
 		per_cpu(x86_cpu_to_node_map, cpu) =
-						x86_cpu_to_node_map_init[cpu];
+				early_per_cpu_map(x86_cpu_to_node_map, cpu);
 #endif
 	}
 
 	/* indicate the early static arrays will soon be gone */
-	x86_cpu_to_apicid_early_ptr = NULL;
-	x86_bios_cpu_apicid_early_ptr = NULL;
+	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
+	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
 #ifdef CONFIG_NUMA
-	x86_cpu_to_node_map_early_ptr = NULL;
+	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 }
 
@@ -137,3 +146,53 @@ void __init setup_per_cpu_areas(void)
 }
 
 #endif
+
+#if defined(CONFIG_NUMA)
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
+void __cpuinit numa_add_cpu(int cpu)
+{
+	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+
+#endif
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
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
--- linux-2.6.x86.sched.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6.x86.sched/arch/x86/kernel/setup_32.c
@@ -724,18 +724,6 @@ char * __init __attribute__((weak)) memo
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
@@ -869,18 +857,6 @@ void __init setup_arch(char **cmdline_p)
 
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
--- linux-2.6.x86.sched.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6.x86.sched/arch/x86/kernel/setup_64.c
@@ -385,15 +385,6 @@ void __init setup_arch(char **cmdline_p)
 
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
--- linux-2.6.x86.sched.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.x86.sched/arch/x86/kernel/smpboot.c
@@ -67,22 +67,6 @@
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
@@ -147,32 +131,25 @@ static cpumask_t cpu_sibling_setup_map;
 int __cpuinitdata smp_b_stepping;
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
-
 /* which logical CPUs are on which nodes */
 cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly =
 				{ [0 ... MAX_NUMNODES-1] = CPU_MASK_NONE };
 EXPORT_SYMBOL(node_to_cpumask_map);
-/* which node each logical CPU is on */
-int cpu_to_node_map[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = 0 };
-EXPORT_SYMBOL(cpu_to_node_map);
 
 /* set up a mapping between cpu and node. */
 static void map_cpu_to_node(int cpu, int node)
 {
 	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
-	cpu_set(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = node;
+	numa_set_node(cpu, node);
+	numa_add_cpu(cpu);
 }
 
 /* undo a mapping between cpu and node. */
 static void unmap_cpu_to_node(int cpu)
 {
-	int node;
-
 	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
-	for (node = 0; node < MAX_NUMNODES; node++)
-		cpu_clear(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = 0;
+	numa_remove_cpu(cpu);
+	numa_clear_node(cpu);
 }
 #else /* !(CONFIG_NUMA && CONFIG_X86_32) */
 #define map_cpu_to_node(cpu, node)	({})
@@ -193,13 +170,13 @@ void map_cpu_to_logical_apicid(void)
 		node = first_online_node;
 
 	cpu_2_logical_apicid[cpu] = apicid;
-	map_cpu_to_node(cpu, node);
+	numa_set_node(cpu, node);
 }
 
 void unmap_cpu_to_logical_apicid(int cpu)
 {
 	cpu_2_logical_apicid[cpu] = BAD_APICID;
-	unmap_cpu_to_node(cpu);
+	numa_clear_node(cpu);
 }
 #else
 #define unmap_cpu_to_logical_apicid(cpu) do {} while (0)
@@ -973,9 +950,7 @@ do_rest:
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		unmap_cpu_to_logical_apicid(cpu);
-#ifdef CONFIG_X86_64
-		clear_node_cpumask(cpu); /* was set by numa_add_cpu */
-#endif
+		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
 		cpu_clear(cpu, cpu_possible_map);
@@ -1354,7 +1329,7 @@ static void __ref remove_cpu_from_maps(i
 	cpu_clear(cpu, cpu_callin_map);
 	/* was set by cpu_init() */
 	clear_bit(cpu, (unsigned long *)&cpu_initialized);
-	clear_node_cpumask(cpu);
+	numa_remove_cpu(cpu);
 #endif
 }
 
--- linux-2.6.x86.sched.orig/arch/x86/mm/numa_64.c
+++ linux-2.6.x86.sched/arch/x86/mm/numa_64.c
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
 
 
--- linux-2.6.x86.sched.orig/include/asm-x86/numa.h
+++ linux-2.6.x86.sched/include/asm-x86/numa.h
@@ -1,5 +1,33 @@
+#ifndef _ASM_X86_NUMA_H
+#define _ASM_X86_NUMA_H 1
+
 #ifdef CONFIG_X86_32
 # include "numa_32.h"
 #else
 # include "numa_64.h"
 #endif
+
+#ifndef CONFIG_NUMA
+static void inline init_cpu_to_node(void)		{ }
+static void inline numa_set_node(int cpu, int node)	{ }
+static void inline numa_clear_node(int cpu)		{ }
+static void inline numa_add_cpu(int cpu, int node)	{ }
+static void inline numa_remove_cpu(int cpu)		{ }
+
+#else
+extern void __init init_cpu_to_node(void);
+extern void __cpuinit numa_set_node(int cpu, int node);
+extern void numa_add_cpu(int cpu);
+
+static inline void numa_clear_node(int cpu)
+{
+	numa_set_node(cpu, NUMA_NO_NODE);
+}
+
+static inline void numa_remove_cpu(int cpu)
+{
+	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
+}
+#endif
+
+#endif /* _ASM_X86_NUMA_H */
--- linux-2.6.x86.sched.orig/include/asm-x86/numa_64.h
+++ linux-2.6.x86.sched/include/asm-x86/numa_64.h
@@ -14,11 +14,9 @@ extern int compute_hash_shift(struct boo
 
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
-extern void numa_add_cpu(int cpu);
 extern void numa_init_array(void);
 extern int numa_off;
 
-extern void numa_set_node(int cpu, int node);
 extern void srat_reserve_add_area(int nodeid);
 extern int hotadd_percent;
 
@@ -29,17 +27,4 @@ extern unsigned long numa_free_all_bootm
 extern void setup_node_bootmem(int nodeid, unsigned long start,
 			       unsigned long end);
 
-#ifdef CONFIG_NUMA
-extern void __init init_cpu_to_node(void);
-
-static inline void clear_node_cpumask(int cpu)
-{
-	clear_bit(cpu, (unsigned long *)&node_to_cpumask_map[cpu_to_node(cpu)]);
-}
-
-#else
-#define init_cpu_to_node() do {} while (0)
-#define clear_node_cpumask(cpu) do {} while (0)
-#endif
-
 #endif
--- linux-2.6.x86.sched.orig/include/asm-x86/percpu.h
+++ linux-2.6.x86.sched/include/asm-x86/percpu.h
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
--- linux-2.6.x86.sched.orig/include/asm-x86/smp.h
+++ linux-2.6.x86.sched/include/asm-x86/smp.h
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
--- linux-2.6.x86.sched.orig/include/asm-x86/topology.h
+++ linux-2.6.x86.sched/include/asm-x86/topology.h
@@ -31,82 +31,64 @@ struct pci_bus;
 #include <asm/mpspec.h>
 
 /* Mappings between logical cpu number and node number */
-#ifdef CONFIG_X86_32
-extern int cpu_to_node_map[];
-#else
-/* Returns the number of the current Node. */
-#define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
-#endif
+DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
-DECLARE_PER_CPU(int, x86_cpu_to_node_map);
+#define NUMA_NO_NODE	(-1)
 
-#ifdef CONFIG_SMP
-extern int x86_cpu_to_node_map_init[];
-extern void *x86_cpu_to_node_map_early_ptr;
-#else
-#define x86_cpu_to_node_map_early_ptr NULL
-#endif
+#ifndef CONFIG_NUMA
+#define numa_node_id()		0
+#define	cpu_to_node(cpu)	0
+#define	early_cpu_to_node(cpu)	0
+#define node_to_cpumask_ptr(v, node)		\
+		cpumask_t *v = &cpu_online_map
+#define node_to_cpumask_ptr_next(v, node)	\
+			   v = &cpu_online_map
+static inline cpumask_t node_to_cpumask(int node)
+{
+	return cpu_online_map;
+}
+static inline int node_to_first_cpu(int node)
+{
+	return first_cpu(cpu_online_map);
+}
+
+#else /* CONFIG_NUMA */
 
 extern cpumask_t node_to_cpumask_map[];
 
-#define NUMA_NO_NODE	(-1)
+/* Returns the number of the current Node. */
+#define numa_node_id()		(__get_cpu_var(x86_cpu_to_node_map))
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+extern int cpu_to_node(int cpu);
+extern int early_cpu_to_node(int cpu);
+#else
 
 /* Returns the number of the node containing CPU 'cpu' */
-#ifdef CONFIG_X86_32
-#define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 static inline int cpu_to_node(int cpu)
 {
-	return cpu_to_node_map[cpu];
+	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
-#else /* CONFIG_X86_64 */
-
-#ifdef CONFIG_SMP
+/* Same function but used if called before per_cpu areas are setup */
 static inline int early_cpu_to_node(int cpu)
 {
-	int *cpu_to_node_map = x86_cpu_to_node_map_early_ptr;
-
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
+	if (early_per_cpu_ptr(x86_cpu_to_node_map))
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
 
-static inline int cpu_to_node(int cpu)
-{
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
-
-#ifdef	CONFIG_NUMA
+#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
 
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 #define node_to_cpumask_ptr(v, node)		\
-		cpumask_t *v = &(node_to_cpumask_map[node])
-
+		cpumask_t *v = _node_to_cpumask_ptr(node)
 #define node_to_cpumask_ptr_next(v, node)	\
-			   v = &(node_to_cpumask_map[node])
-#endif
-
-#endif /* CONFIG_X86_64 */
-
-/*
- * Returns the number of the node containing Node 'node'. This
- * architecture is flat, so it is a pretty simple function!
- */
-#define parent_node(node) (node)
+			   v = _node_to_cpumask_ptr(node)
+static inline cpumask_t *_node_to_cpumask_ptr(int node)
+{
+	return &node_to_cpumask_map[node];
+}
 
 /* Returns a bitmask of CPUs on Node 'node'. */
 static inline cpumask_t node_to_cpumask(int node)
@@ -117,11 +99,19 @@ static inline cpumask_t node_to_cpumask(
 /* Returns the number of the first CPU on Node 'node'. */
 static inline int node_to_first_cpu(int node)
 {
-	cpumask_t mask = node_to_cpumask(node);
-
-	return first_cpu(mask);
+	node_to_cpumask_ptr(mask, node);
+	return first_cpu(*mask);
 }
 
+#endif /* CONFIG_NUMA */
+
+/*
+ * Returns the number of the node containing Node 'node'. This
+ * architecture is flat, so it is a pretty simple function!
+ */
+#define parent_node(node) (node)
+
+
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 #define pcibus_to_cpumask(bus) __pcibus_to_cpumask(bus)
 

-- 
