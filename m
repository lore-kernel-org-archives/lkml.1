Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbYDZAS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbYDZAS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbYDZAP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:15:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59171 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758120AbYDZAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:50 -0400
Message-Id: <20080426001550.087142000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:55 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] x86: remove static boot_cpu_pda array
Content-Disposition: inline; filename=rm-boot_pdas
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Remove the boot_cpu_pda array and pointer table from the data section.
    Allocate the pointer table during init.  If CONFIG_HOTPLUG_CPU is set
    then also allocate the cpu_pda array during init.  In either case,
    allocate the cpu_pda from node local memory when the cpu is started
    in do_boot_cpu().

    This removes 512k + 32k bytes from the data section.


For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/head64.c  |   26 ++++++++++++--
 arch/x86/kernel/setup.c   |   83 +++++++++++++++++++++++++++++++++++++---------
 arch/x86/kernel/setup64.c |    8 ++--
 arch/x86/kernel/smpboot.c |   54 ++++++++++++++++++++++-------
 include/asm-x86/pda.h     |    6 +--
 5 files changed, 139 insertions(+), 38 deletions(-)

--- linux-2.6.sched.orig/arch/x86/kernel/head64.c
+++ linux-2.6.sched/arch/x86/kernel/head64.c
@@ -25,6 +25,24 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 
+/* boot cpu pda */
+static struct x8664_pda _boot_cpu_pda __read_mostly;
+
+#ifdef CONFIG_SMP
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+/*
+ * We install an empty cpu_pda pointer table to trap references before
+ * the actual cpu_pda pointer table is created in setup_cpu_pda_map().
+ */
+static struct x8664_pda *__cpu_pda[NR_CPUS] __initdata;
+#else
+static struct x8664_pda *__cpu_pda[1] __read_mostly;
+#endif
+
+#else /* !CONFIG_SMP (NR_CPUS will be 1) */
+static struct x8664_pda *__cpu_pda[NR_CPUS] __read_mostly;
+#endif
+
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
@@ -156,10 +174,12 @@ void __init x86_64_start_kernel(char * r
 
 	early_printk("Kernel alive\n");
 
- 	for (i = 0; i < NR_CPUS; i++)
- 		cpu_pda(i) = &boot_cpu_pda[i];
-
+	_cpu_pda = __cpu_pda;
+	cpu_pda(0) = &_boot_cpu_pda;
 	pda_init(0);
+
+	early_printk("Kernel really alive\n");
+
 	copy_bootdata(__va(real_mode_data));
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
--- linux-2.6.sched.orig/arch/x86/kernel/setup.c
+++ linux-2.6.sched/arch/x86/kernel/setup.c
@@ -100,6 +100,60 @@ static inline void setup_cpumask_of_cpu(
  */
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
+static inline void setup_cpu_pda_map(void) { }
+
+#elif !defined(CONFIG_SMP)
+static inline void setup_cpu_pda_map(void) { }
+
+#else /* CONFIG_SMP && CONFIG_X86_64 */
+
+/*
+ * Allocate cpu_pda pointer table via alloc_bootmem
+ * and if CONFIG_HOTPLUG_CPU also allocate a static cpu_pda array.
+ *
+ * Note that the boot cpu's pda is left in place.
+ * Note also that cpu_pda(0) may be the only valid reference.
+ */
+static void __init setup_cpu_pda_map(void)
+{
+	char *pda;
+	struct x8664_pda **new_cpu_pda;
+	unsigned long size;
+	int cpu;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	size = roundup(sizeof(struct x8664_pda), cache_line_size());
+#else
+	/* no need to preallocate the cpu_pda array */
+	size = 0;
+#endif
+
+	/* allocate cpu_pda array and pointer table */
+	{
+		unsigned long asize = size * (nr_cpu_ids - 1);
+		unsigned long tsize = nr_cpu_ids * sizeof(void *);
+
+		pda = alloc_bootmem(asize + tsize);
+		new_cpu_pda = (struct x8664_pda **)(pda + asize);
+	}
+
+#ifdef CONFIG_HOTPLUG_CPU
+	/* initialize pointer table to static pda's */
+	for_each_possible_cpu(cpu) {
+		if (cpu == 0) {
+			/* leave boot cpu pda in place */
+			new_cpu_pda[0] = cpu_pda(0);
+			continue;
+		}
+		new_cpu_pda[cpu] = (struct x8664_pda *)pda;
+		new_cpu_pda[cpu]->in_bootmem = 1;
+		pda += size;
+	}
+#endif
+
+	/* point to new pointer table */
+	_cpu_pda = new_cpu_pda;
+}
 #endif
 
 /*
@@ -109,46 +163,43 @@ EXPORT_SYMBOL(__per_cpu_offset);
  */
 void __init setup_per_cpu_areas(void)
 {
-	int i, highest_cpu = 0;
-	unsigned long size;
+	ssize_t size = PERCPU_ENOUGH_ROOM;
+	char *ptr;
+	int cpu;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	prefill_possible_map();
+#else
+	nr_cpu_ids = num_processors;
 #endif
 
+	/* Setup cpu_pda map */
+	setup_cpu_pda_map();
+
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
 	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
 			  size);
 
-	for_each_possible_cpu(i) {
-		char *ptr;
+	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 		ptr = alloc_bootmem_pages(size);
 #else
-		int node = early_cpu_to_node(i);
+		int node = early_cpu_to_node(cpu);
 		if (!node_online(node) || !NODE_DATA(node)) {
 			ptr = alloc_bootmem_pages(size);
 			printk(KERN_INFO
 			       "cpu %d has no node %d or node-local memory\n",
-				i, node);
+				cpu, node);
 		}
 		else
 			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
 #endif
-		if (!ptr)
-			panic("Cannot allocate cpu data for CPU %d\n", i);
-#ifdef CONFIG_X86_64
-		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
-#else
-		__per_cpu_offset[i] = ptr - __per_cpu_start;
-#endif
+		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
-		highest_cpu = i;
 	}
 
-	nr_cpu_ids = highest_cpu + 1;
 	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
 		NR_CPUS, nr_cpu_ids, nr_node_ids);
 
@@ -198,7 +249,7 @@ void __cpuinit numa_set_node(int cpu, in
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
-	if (node != NUMA_NO_NODE)
+	if (cpu_pda(cpu) && node != NUMA_NO_NODE)
 		cpu_pda(cpu)->nodenumber = node;
 
 	if (cpu_to_node_map)
--- linux-2.6.sched.orig/arch/x86/kernel/setup64.c
+++ linux-2.6.sched/arch/x86/kernel/setup64.c
@@ -12,6 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/kgdb.h>
+#include <linux/topology.h>
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -34,9 +35,8 @@ struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
+struct x8664_pda **_cpu_pda __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
-struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
@@ -114,8 +114,10 @@ void pda_init(int cpu)
 			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
 		if (!pda->irqstackptr)
 			panic("cannot allocate irqstack for cpu %d", cpu); 
-	}
 
+		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
+			pda->nodenumber = cpu_to_node(cpu);
+	}
 
 	pda->irqstackptr += IRQSTACKSIZE-64;
 } 
--- linux-2.6.sched.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.sched/arch/x86/kernel/smpboot.c
@@ -809,6 +809,39 @@ static void __cpuinit do_fork_idle(struc
 	complete(&c_idle->done);
 }
 
+/*
+ * Allocate node local memory for the AP pda.
+ *
+ * Must be called after the _cpu_pda pointer table is initialized.
+ */
+static int __cpuinit get_local_pda(int cpu)
+{
+	struct x8664_pda *newpda;
+	unsigned long size = sizeof(struct x8664_pda);
+	int node = cpu_to_node(cpu);
+
+	if (cpu_pda(cpu) && !cpu_pda(cpu)->in_bootmem)
+		return 0;
+
+	newpda = kmalloc_node(size, GFP_ATOMIC, node);
+	if (!newpda) {
+		printk(KERN_ERR "Could not allocate node local PDA "
+			"for CPU %d on node %d\n", cpu, node);
+
+		if (cpu_pda(cpu))
+			return 0;	/* have a usable pda */
+		else
+			return -1;
+	}
+
+	if (cpu_pda(cpu))
+		memcpy(newpda, cpu_pda(cpu), size);
+
+	cpu_pda(cpu) = newpda;
+	cpu_pda(cpu)->in_bootmem = 0;
+	return 0;
+}
+
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -834,19 +867,10 @@ static int __cpuinit do_boot_cpu(int api
 	}
 
 	/* Allocate node local memory for AP pdas */
-	if (cpu_pda(cpu) == &boot_cpu_pda[cpu]) {
-		struct x8664_pda *newpda, *pda;
-		int node = cpu_to_node(cpu);
-		pda = cpu_pda(cpu);
-		newpda = kmalloc_node(sizeof(struct x8664_pda), GFP_ATOMIC,
-				      node);
-		if (newpda) {
-			memcpy(newpda, pda, sizeof(struct x8664_pda));
-			cpu_pda(cpu) = newpda;
-		} else
-			printk(KERN_ERR
-		"Could not allocate node local PDA for CPU %d on node %d\n",
-				cpu, node);
+	if (cpu > 0 ) {
+		boot_error = get_local_pda(cpu);
+		if (boot_error)
+			goto restore_state; /* can't get memory, can't start cpu */
 	}
 #endif
 
@@ -965,6 +989,8 @@ do_rest:
 		}
 	}
 
+restore_state:
+
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		unmap_cpu_to_logical_apicid(cpu);
@@ -1338,6 +1364,8 @@ __init void prefill_possible_map(void)
 
 	for (i = 0; i < possible; i++)
 		cpu_set(i, cpu_possible_map);
+
+	nr_cpu_ids = possible;
 }
 
 static void __ref remove_cpu_from_maps(int cpu)
--- linux-2.6.sched.orig/include/asm-x86/pda.h
+++ linux-2.6.sched/include/asm-x86/pda.h
@@ -20,7 +20,8 @@ struct x8664_pda {
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 	char *irqstackptr;
-	int nodenumber;			/* number of current node */
+	short nodenumber;		/* number of current node (32k max) */
+	short in_bootmem;		/* pda lives in bootmem */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
@@ -36,8 +37,7 @@ struct x8664_pda {
 	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
-extern struct x8664_pda *_cpu_pda[];
-extern struct x8664_pda boot_cpu_pda[];
+extern struct x8664_pda **_cpu_pda;
 extern void pda_init(int);
 
 #define cpu_pda(i) (_cpu_pda[i])

-- 
