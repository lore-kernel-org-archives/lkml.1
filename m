Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYFZBCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYFZBCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYFZBBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:38 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbYFZBBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JwFKw0md7EPqr9vT5p1ZcjK6tiZTf7Scy74uxwKTc55/CI+nV+/Lty+F8BHbU/JgAf
         YgjN0AJcq/UKmRYxQKTFIDrNoq1aC88KT04rHxwwIdZHnpX+8pIjsz89n5on9VyTd4gp
         txEeKYv4aj3EDR2rzzoqOxRvoz5sfKdrzTOZA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 01/16] x86: rename setup.c to setup_percpu.c
Date: Wed, 25 Jun 2008 17:48:14 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251744.02246.yhlu.kernel@gmail.com>
In-Reply-To: <200806251744.02246.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806251748.14730.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some functions need to be moved to setup_numa.c
after we merge setup32/64.c, some funcs need to be moved back to setup.c

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/Makefile       |    2 
 arch/x86/kernel/setup.c        |  525 -----------------------------------------
 arch/x86/kernel/setup_percpu.c |  525 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 526 insertions(+), 526 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ /dev/null
@@ -1,525 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/bootmem.h>
-#include <linux/percpu.h>
-#include <linux/kexec.h>
-#include <linux/crash_dump.h>
-#include <asm/smp.h>
-#include <asm/percpu.h>
-#include <asm/sections.h>
-#include <asm/processor.h>
-#include <asm/setup.h>
-#include <asm/topology.h>
-#include <asm/mpspec.h>
-#include <asm/apicdef.h>
-#include <asm/highmem.h>
-
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
-#else
-struct boot_params boot_params;
-#endif
-
-#ifdef CONFIG_X86_LOCAL_APIC
-unsigned int num_processors;
-unsigned disabled_cpus __cpuinitdata;
-/* Processor that is doing the boot up */
-unsigned int boot_cpu_physical_apicid = -1U;
-unsigned int max_physical_apicid;
-EXPORT_SYMBOL(boot_cpu_physical_apicid);
-
-/* Bitmask of physically existing CPUs */
-physid_mask_t phys_cpu_present_map;
-#endif
-
-/* map cpu index to physical APIC ID */
-DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
-DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
-#define	X86_64_NUMA	1
-
-/* map cpu index to node index */
-DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-
-/* which logical CPUs are on which nodes */
-cpumask_t *node_to_cpumask_map;
-EXPORT_SYMBOL(node_to_cpumask_map);
-
-/* setup node_to_cpumask_map */
-static void __init setup_node_to_cpumask_map(void);
-
-#else
-static inline void setup_node_to_cpumask_map(void) { }
-#endif
-
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
-/*
- * Copy data used in early init routines from the initial arrays to the
- * per cpu data areas.  These arrays then become expendable and the
- * *_early_ptr's are zeroed indicating that the static arrays are gone.
- */
-static void __init setup_per_cpu_maps(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		per_cpu(x86_cpu_to_apicid, cpu) =
-				early_per_cpu_map(x86_cpu_to_apicid, cpu);
-		per_cpu(x86_bios_cpu_apicid, cpu) =
-				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
-#ifdef X86_64_NUMA
-		per_cpu(x86_cpu_to_node_map, cpu) =
-				early_per_cpu_map(x86_cpu_to_node_map, cpu);
-#endif
-	}
-
-	/* indicate the early static arrays will soon be gone */
-	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
-	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
-#ifdef X86_64_NUMA
-	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
-#endif
-}
-
-#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-cpumask_t *cpumask_of_cpu_map __read_mostly;
-EXPORT_SYMBOL(cpumask_of_cpu_map);
-
-/* requires nr_cpu_ids to be initialized */
-static void __init setup_cpumask_of_cpu(void)
-{
-	int i;
-
-	/* alloc_bootmem zeroes memory */
-	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
-	for (i = 0; i < nr_cpu_ids; i++)
-		cpu_set(i, cpumask_of_cpu_map[i]);
-}
-#else
-static inline void setup_cpumask_of_cpu(void) { }
-#endif
-
-#ifdef CONFIG_X86_32
-/*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
- */
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(__per_cpu_offset);
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
-
-/*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
- */
-void __init setup_per_cpu_areas(void)
-{
-	ssize_t size = PERCPU_ENOUGH_ROOM;
-	char *ptr;
-	int cpu;
-
-	/* no processor from mptable or madt */
-	if (!num_processors)
-		num_processors = 1;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	prefill_possible_map();
-#else
-	nr_cpu_ids = num_processors;
-#endif
-
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
-	/* Copy section for each CPU (we discard the original) */
-	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
-			  size);
-
-	for_each_possible_cpu(cpu) {
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-		ptr = alloc_bootmem_pages(size);
-#else
-		int node = early_cpu_to_node(cpu);
-		if (!node_online(node) || !NODE_DATA(node)) {
-			ptr = alloc_bootmem_pages(size);
-			printk(KERN_INFO
-			       "cpu %d has no node %d or node-local memory\n",
-				cpu, node);
-		}
-		else
-			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
-#endif
-		per_cpu_offset(cpu) = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-
-	}
-
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
-		NR_CPUS, nr_cpu_ids, nr_node_ids);
-
-	/* Setup percpu data maps */
-	setup_per_cpu_maps();
-
-	/* Setup node to cpumask map */
-	setup_node_to_cpumask_map();
-
-	/* Setup cpumask_of_cpu map */
-	setup_cpumask_of_cpu();
-}
-
-#endif
-
-void __init parse_setup_data(void)
-{
-	struct setup_data *data;
-	u64 pa_data;
-
-	if (boot_params.hdr.version < 0x0209)
-		return;
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_ioremap(pa_data, PAGE_SIZE);
-		switch (data->type) {
-		case SETUP_E820_EXT:
-			parse_e820_ext(data, pa_data);
-			break;
-		default:
-			break;
-		}
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-		free_early(pa_data, pa_data+sizeof(*data)+data->len);
-#endif
-		pa_data = data->next;
-		early_iounmap(data, PAGE_SIZE);
-	}
-}
-
-#ifdef X86_64_NUMA
-
-/*
- * Allocate node_to_cpumask_map based on number of available nodes
- * Requires node_possible_map to be valid.
- *
- * Note: node_to_cpumask() is not valid until after this is done.
- */
-static void __init setup_node_to_cpumask_map(void)
-{
-	unsigned int node, num = 0;
-	cpumask_t *map;
-
-	/* setup nr_node_ids if not done yet */
-	if (nr_node_ids == MAX_NUMNODES) {
-		for_each_node_mask(node, node_possible_map)
-			num = node;
-		nr_node_ids = num + 1;
-	}
-
-	/* allocate the map */
-	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
-
-	Dprintk(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
-		map, nr_node_ids);
-
-	/* node_to_cpumask() will now work */
-	node_to_cpumask_map = map;
-}
-
-void __cpuinit numa_set_node(int cpu, int node)
-{
-	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
-
-	if (cpu_pda(cpu) && node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
-
-	if (cpu_to_node_map)
-		cpu_to_node_map[cpu] = node;
-
-	else if (per_cpu_offset(cpu))
-		per_cpu(x86_cpu_to_node_map, cpu) = node;
-
-	else
-		Dprintk(KERN_INFO "Setting node for non-present cpu %d\n", cpu);
-}
-
-void __cpuinit numa_clear_node(int cpu)
-{
-	numa_set_node(cpu, NUMA_NO_NODE);
-}
-
-#ifndef CONFIG_DEBUG_PER_CPU_MAPS
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
-}
-
-#else /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-/*
- * --------- debug versions of the numa functions ---------
- */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	int node = cpu_to_node(cpu);
-	cpumask_t *mask;
-	char buf[64];
-
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map NULL\n");
-		dump_stack();
-		return;
-	}
-
-	mask = &node_to_cpumask_map[node];
-	if (enable)
-		cpu_set(cpu, *mask);
-	else
-		cpu_clear(cpu, *mask);
-
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
- }
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 1);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 0);
-}
-
-int cpu_to_node(int cpu)
-{
-	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
-		printk(KERN_WARNING
-			"cpu_to_node(%d): usage too early!\n", cpu);
-		dump_stack();
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-EXPORT_SYMBOL(cpu_to_node);
-
-/*
- * Same function as cpu_to_node() but used if called before the
- * per_cpu areas are setup.
- */
-int early_cpu_to_node(int cpu)
-{
-	if (early_per_cpu_ptr(x86_cpu_to_node_map))
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-
-	if (!per_cpu_offset(cpu)) {
-		printk(KERN_WARNING
-			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
-		dump_stack();
-		return NUMA_NO_NODE;
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-
-/*
- * Returns a pointer to the bitmask of CPUs on Node 'node'.
- */
-cpumask_t *_node_to_cpumask_ptr(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
-			node);
-		dump_stack();
-		return &cpu_online_map;
-	}
-	BUG_ON(node >= nr_node_ids);
-	return &node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(_node_to_cpumask_ptr);
-
-/*
- * Returns a bitmask of CPUs on Node 'node'.
- */
-cpumask_t node_to_cpumask(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
-		dump_stack();
-		return cpu_online_map;
-	}
-	BUG_ON(node >= nr_node_ids);
-	return node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(node_to_cpumask);
-
-/*
- * --------- end of debug versions of the numa functions ---------
- */
-
-#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-#endif /* X86_64_NUMA */
-
-/*
- * --------- Crashkernel reservation ------------------------------
- */
-
-static inline unsigned long long get_total_mem(void)
-{
-	unsigned long long total;
-
-	total = max_low_pfn - min_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	total += highend_pfn - highstart_pfn;
-#endif
-
-	return total << PAGE_SHIFT;
-}
-
-#ifdef CONFIG_KEXEC
-void __init reserve_crashkernel(void)
-{
-	unsigned long long total_mem;
-	unsigned long long crash_size, crash_base;
-	int ret;
-
-	total_mem = get_total_mem();
-
-	ret = parse_crashkernel(boot_command_line, total_mem,
-			&crash_size, &crash_base);
-	if (ret == 0 && crash_size > 0) {
-		if (crash_base <= 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"you have to specify a base address\n");
-			return;
-		}
-
-		if (reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE) < 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"memory is in use\n");
-			return;
-		}
-
-		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-				"for crashkernel (System RAM: %ldMB)\n",
-				(unsigned long)(crash_size >> 20),
-				(unsigned long)(crash_base >> 20),
-				(unsigned long)(total_mem >> 20));
-
-		crashk_res.start = crash_base;
-		crashk_res.end   = crash_base + crash_size - 1;
-		insert_resource(&iomem_resource, &crashk_res);
-	}
-}
-#else
-void __init reserve_crashkernel(void)
-{}
-#endif
-
-static struct resource standard_io_resources[] = {
-	{ .name = "dma1", .start = 0x00, .end = 0x1f,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "pic1", .start = 0x20, .end = 0x21,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "timer0", .start = 0x40, .end = 0x43,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "timer1", .start = 0x50, .end = 0x53,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "keyboard", .start = 0x60, .end = 0x60,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "keyboard", .start = 0x64, .end = 0x64,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "dma page reg", .start = 0x80, .end = 0x8f,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "pic2", .start = 0xa0, .end = 0xa1,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "fpu", .start = 0xf0, .end = 0xff,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
-};
-
-void __init reserve_standard_io_resources(void)
-{
-	int i;
-
-	/* request I/O space for devices used on all i[345]86 PCs */
-	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
-		request_resource(&ioport_resource, &standard_io_resources[i]);
-
-}
-
-#ifdef CONFIG_PROC_VMCORE
-/* elfcorehdr= specifies the location of elf core header
- * stored by the crashed kernel. This option will be passed
- * by kexec loader to the capture kernel.
- */
-static int __init setup_elfcorehdr(char *arg)
-{
-	char *end;
-	if (!arg)
-		return -EINVAL;
-	elfcorehdr_addr = memparse(arg, &end);
-	return end > arg ? 0 : -EINVAL;
-}
-early_param("elfcorehdr", setup_elfcorehdr);
-#endif
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -0,0 +1,525 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/percpu.h>
+#include <linux/kexec.h>
+#include <linux/crash_dump.h>
+#include <asm/smp.h>
+#include <asm/percpu.h>
+#include <asm/sections.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/topology.h>
+#include <asm/mpspec.h>
+#include <asm/apicdef.h>
+#include <asm/highmem.h>
+
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+struct boot_params __initdata boot_params;
+#else
+struct boot_params boot_params;
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+unsigned int num_processors;
+unsigned disabled_cpus __cpuinitdata;
+/* Processor that is doing the boot up */
+unsigned int boot_cpu_physical_apicid = -1U;
+unsigned int max_physical_apicid;
+EXPORT_SYMBOL(boot_cpu_physical_apicid);
+
+/* Bitmask of physically existing CPUs */
+physid_mask_t phys_cpu_present_map;
+#endif
+
+/* map cpu index to physical APIC ID */
+DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
+DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#define	X86_64_NUMA	1
+
+/* map cpu index to node index */
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+
+/* which logical CPUs are on which nodes */
+cpumask_t *node_to_cpumask_map;
+EXPORT_SYMBOL(node_to_cpumask_map);
+
+/* setup node_to_cpumask_map */
+static void __init setup_node_to_cpumask_map(void);
+
+#else
+static inline void setup_node_to_cpumask_map(void) { }
+#endif
+
+#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+/*
+ * Copy data used in early init routines from the initial arrays to the
+ * per cpu data areas.  These arrays then become expendable and the
+ * *_early_ptr's are zeroed indicating that the static arrays are gone.
+ */
+static void __init setup_per_cpu_maps(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		per_cpu(x86_cpu_to_apicid, cpu) =
+				early_per_cpu_map(x86_cpu_to_apicid, cpu);
+		per_cpu(x86_bios_cpu_apicid, cpu) =
+				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
+#ifdef X86_64_NUMA
+		per_cpu(x86_cpu_to_node_map, cpu) =
+				early_per_cpu_map(x86_cpu_to_node_map, cpu);
+#endif
+	}
+
+	/* indicate the early static arrays will soon be gone */
+	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
+	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
+#ifdef X86_64_NUMA
+	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
+#endif
+}
+
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+cpumask_t *cpumask_of_cpu_map __read_mostly;
+EXPORT_SYMBOL(cpumask_of_cpu_map);
+
+/* requires nr_cpu_ids to be initialized */
+static void __init setup_cpumask_of_cpu(void)
+{
+	int i;
+
+	/* alloc_bootmem zeroes memory */
+	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
+	for (i = 0; i < nr_cpu_ids; i++)
+		cpu_set(i, cpumask_of_cpu_map[i]);
+}
+#else
+static inline void setup_cpumask_of_cpu(void) { }
+#endif
+
+#ifdef CONFIG_X86_32
+/*
+ * Great future not-so-futuristic plan: make i386 and x86_64 do it
+ * the same way
+ */
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+EXPORT_SYMBOL(__per_cpu_offset);
+static inline void setup_cpu_pda_map(void) { }
+
+#elif !defined(CONFIG_SMP)
+static inline void setup_cpu_pda_map(void) { }
+
+#else /* CONFIG_SMP && CONFIG_X86_64 */
+
+/*
+ * Allocate cpu_pda pointer table and array via alloc_bootmem.
+ */
+static void __init setup_cpu_pda_map(void)
+{
+	char *pda;
+	struct x8664_pda **new_cpu_pda;
+	unsigned long size;
+	int cpu;
+
+	size = roundup(sizeof(struct x8664_pda), cache_line_size());
+
+	/* allocate cpu_pda array and pointer table */
+	{
+		unsigned long tsize = nr_cpu_ids * sizeof(void *);
+		unsigned long asize = size * (nr_cpu_ids - 1);
+
+		tsize = roundup(tsize, cache_line_size());
+		new_cpu_pda = alloc_bootmem(tsize + asize);
+		pda = (char *)new_cpu_pda + tsize;
+	}
+
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
+
+	/* point to new pointer table */
+	_cpu_pda = new_cpu_pda;
+}
+#endif
+
+/*
+ * Great future plan:
+ * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
+ * Always point %gs to its beginning
+ */
+void __init setup_per_cpu_areas(void)
+{
+	ssize_t size = PERCPU_ENOUGH_ROOM;
+	char *ptr;
+	int cpu;
+
+	/* no processor from mptable or madt */
+	if (!num_processors)
+		num_processors = 1;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	prefill_possible_map();
+#else
+	nr_cpu_ids = num_processors;
+#endif
+
+	/* Setup cpu_pda map */
+	setup_cpu_pda_map();
+
+	/* Copy section for each CPU (we discard the original) */
+	size = PERCPU_ENOUGH_ROOM;
+	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
+			  size);
+
+	for_each_possible_cpu(cpu) {
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+		ptr = alloc_bootmem_pages(size);
+#else
+		int node = early_cpu_to_node(cpu);
+		if (!node_online(node) || !NODE_DATA(node)) {
+			ptr = alloc_bootmem_pages(size);
+			printk(KERN_INFO
+			       "cpu %d has no node %d or node-local memory\n",
+				cpu, node);
+		}
+		else
+			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
+#endif
+		per_cpu_offset(cpu) = ptr - __per_cpu_start;
+		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+
+	}
+
+	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
+		NR_CPUS, nr_cpu_ids, nr_node_ids);
+
+	/* Setup percpu data maps */
+	setup_per_cpu_maps();
+
+	/* Setup node to cpumask map */
+	setup_node_to_cpumask_map();
+
+	/* Setup cpumask_of_cpu map */
+	setup_cpumask_of_cpu();
+}
+
+#endif
+
+void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		case SETUP_E820_EXT:
+			parse_e820_ext(data, pa_data);
+			break;
+		default:
+			break;
+		}
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+		free_early(pa_data, pa_data+sizeof(*data)+data->len);
+#endif
+		pa_data = data->next;
+		early_iounmap(data, PAGE_SIZE);
+	}
+}
+
+#ifdef X86_64_NUMA
+
+/*
+ * Allocate node_to_cpumask_map based on number of available nodes
+ * Requires node_possible_map to be valid.
+ *
+ * Note: node_to_cpumask() is not valid until after this is done.
+ */
+static void __init setup_node_to_cpumask_map(void)
+{
+	unsigned int node, num = 0;
+	cpumask_t *map;
+
+	/* setup nr_node_ids if not done yet */
+	if (nr_node_ids == MAX_NUMNODES) {
+		for_each_node_mask(node, node_possible_map)
+			num = node;
+		nr_node_ids = num + 1;
+	}
+
+	/* allocate the map */
+	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
+
+	Dprintk(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
+		map, nr_node_ids);
+
+	/* node_to_cpumask() will now work */
+	node_to_cpumask_map = map;
+}
+
+void __cpuinit numa_set_node(int cpu, int node)
+{
+	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
+
+	if (cpu_pda(cpu) && node != NUMA_NO_NODE)
+		cpu_pda(cpu)->nodenumber = node;
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
+#ifndef CONFIG_DEBUG_PER_CPU_MAPS
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
+
+#else /* CONFIG_DEBUG_PER_CPU_MAPS */
+
+/*
+ * --------- debug versions of the numa functions ---------
+ */
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	int node = cpu_to_node(cpu);
+	cpumask_t *mask;
+	char buf[64];
+
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_ERR "node_to_cpumask_map NULL\n");
+		dump_stack();
+		return;
+	}
+
+	mask = &node_to_cpumask_map[node];
+	if (enable)
+		cpu_set(cpu, *mask);
+	else
+		cpu_clear(cpu, *mask);
+
+	cpulist_scnprintf(buf, sizeof(buf), *mask);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
+ }
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 1);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 0);
+}
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
+/*
+ * Same function as cpu_to_node() but used if called before the
+ * per_cpu areas are setup.
+ */
+int early_cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map))
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+
+	if (!per_cpu_offset(cpu)) {
+		printk(KERN_WARNING
+			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
+		dump_stack();
+		return NUMA_NO_NODE;
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+
+/*
+ * Returns a pointer to the bitmask of CPUs on Node 'node'.
+ */
+cpumask_t *_node_to_cpumask_ptr(int node)
+{
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_WARNING
+			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
+			node);
+		dump_stack();
+		return &cpu_online_map;
+	}
+	BUG_ON(node >= nr_node_ids);
+	return &node_to_cpumask_map[node];
+}
+EXPORT_SYMBOL(_node_to_cpumask_ptr);
+
+/*
+ * Returns a bitmask of CPUs on Node 'node'.
+ */
+cpumask_t node_to_cpumask(int node)
+{
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_WARNING
+			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
+		dump_stack();
+		return cpu_online_map;
+	}
+	BUG_ON(node >= nr_node_ids);
+	return node_to_cpumask_map[node];
+}
+EXPORT_SYMBOL(node_to_cpumask);
+
+/*
+ * --------- end of debug versions of the numa functions ---------
+ */
+
+#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
+
+#endif /* X86_64_NUMA */
+
+/*
+ * --------- Crashkernel reservation ------------------------------
+ */
+
+static inline unsigned long long get_total_mem(void)
+{
+	unsigned long long total;
+
+	total = max_low_pfn - min_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	total += highend_pfn - highstart_pfn;
+#endif
+
+	return total << PAGE_SHIFT;
+}
+
+#ifdef CONFIG_KEXEC
+void __init reserve_crashkernel(void)
+{
+	unsigned long long total_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
+
+	total_mem = get_total_mem();
+
+	ret = parse_crashkernel(boot_command_line, total_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0) {
+		if (crash_base <= 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem_generic(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
+		insert_resource(&iomem_resource, &crashk_res);
+	}
+}
+#else
+void __init reserve_crashkernel(void)
+{}
+#endif
+
+static struct resource standard_io_resources[] = {
+	{ .name = "dma1", .start = 0x00, .end = 0x1f,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "pic1", .start = 0x20, .end = 0x21,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "timer0", .start = 0x40, .end = 0x43,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "timer1", .start = 0x50, .end = 0x53,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "keyboard", .start = 0x60, .end = 0x60,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "keyboard", .start = 0x64, .end = 0x64,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "dma page reg", .start = 0x80, .end = 0x8f,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "pic2", .start = 0xa0, .end = 0xa1,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "fpu", .start = 0xf0, .end = 0xff,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
+};
+
+void __init reserve_standard_io_resources(void)
+{
+	int i;
+
+	/* request I/O space for devices used on all i[345]86 PCs */
+	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
+		request_resource(&ioport_resource, &standard_io_resources[i]);
+
+}
+
+#ifdef CONFIG_PROC_VMCORE
+/* elfcorehdr= specifies the location of elf core header
+ * stored by the crashed kernel. This option will be passed
+ * by kexec loader to the capture kernel.
+ */
+static int __init setup_elfcorehdr(char *arg)
+{
+	char *end;
+	if (!arg)
+		return -EINVAL;
+	elfcorehdr_addr = memparse(arg, &end);
+	return end > arg ? 0 : -EINVAL;
+}
+early_param("elfcorehdr", setup_elfcorehdr);
+#endif
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -26,7 +26,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
-obj-y			+= setup_$(BITS).o i8259.o irqinit_$(BITS).o setup.o
+obj-y			+= setup_$(BITS).o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
