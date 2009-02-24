Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbZBXDPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbZBXDPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbZBXDNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:58489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877AbZBXDN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:28 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] x86: separate out setup_pcpu_4k() from setup_per_cpu_areas()
Date: Tue, 24 Feb 2009 12:11:39 +0900
Message-Id: <1235445101-7882-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: modularize percpu first chunk allocation

x86 is gonna have a few different strategies for the first chunk
allocation.  Modularize it by separating out the current allocation
mechanism into pcpu_alloc_bootmem() and setup_pcpu_4k().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |  144 ++++++++++++++++++++++++++++------------
 1 files changed, 102 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index d928e88..4a17c96 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -7,6 +7,7 @@
 #include <linux/crash_dump.h>
 #include <linux/smp.h>
 #include <linux/topology.h>
+#include <linux/pfn.h>
 #include <asm/sections.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
@@ -41,6 +42,52 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 };
 EXPORT_SYMBOL(__per_cpu_offset);
 
+/**
+ * pcpu_alloc_bootmem - NUMA friendly alloc_bootmem wrapper for percpu
+ * @cpu: cpu to allocate for
+ * @size: size allocation in bytes
+ * @align: alignment
+ *
+ * Allocate @size bytes aligned at @align for cpu @cpu.  This wrapper
+ * does the right thing for NUMA regardless of the current
+ * configuration.
+ *
+ * RETURNS:
+ * Pointer to the allocated area on success, NULL on failure.
+ */
+static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
+					unsigned long align)
+{
+	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	int node = early_cpu_to_node(cpu);
+	void *ptr;
+
+	if (!node_online(node) || !NODE_DATA(node)) {
+		ptr = __alloc_bootmem_nopanic(size, align, goal);
+		pr_info("cpu %d has no node %d or node-local memory\n",
+			cpu, node);
+		pr_debug("per cpu data for cpu%d %lu bytes at %016lx\n",
+			 cpu, size, __pa(ptr));
+	} else {
+		ptr = __alloc_bootmem_node_nopanic(NODE_DATA(node),
+						   size, align, goal);
+		pr_debug("per cpu data for cpu%d %lu bytes on node%d at "
+			 "%016lx\n", cpu, size, node, __pa(ptr));
+	}
+	return ptr;
+#else
+	return __alloc_bootmem_nopanic(size, align, goal);
+#endif
+}
+
+/*
+ * 4k page allocator
+ *
+ * This is the basic allocator.  Static percpu area is allocated
+ * page-by-page and most of initialization is done by the generic
+ * setup function.
+ */
 static struct page **pcpu4k_pages __initdata;
 static int pcpu4k_nr_static_pages __initdata;
 
@@ -56,6 +103,51 @@ static void __init pcpu4k_populate_pte(unsigned long addr)
 	populate_extra_pte(addr);
 }
 
+static ssize_t __init setup_pcpu_4k(size_t static_size)
+{
+	size_t pages_size;
+	unsigned int cpu;
+	int i, j;
+	ssize_t ret;
+
+	pcpu4k_nr_static_pages = PFN_UP(static_size);
+
+	/* unaligned allocations can't be freed, round up to page size */
+	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * num_possible_cpus()
+			       * sizeof(pcpu4k_pages[0]));
+	pcpu4k_pages = alloc_bootmem(pages_size);
+
+	/* allocate and copy */
+	j = 0;
+	for_each_possible_cpu(cpu)
+		for (i = 0; i < pcpu4k_nr_static_pages; i++) {
+			void *ptr;
+
+			ptr = pcpu_alloc_bootmem(cpu, PAGE_SIZE, PAGE_SIZE);
+			if (!ptr)
+				goto enomem;
+
+			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
+			pcpu4k_pages[j++] = virt_to_page(ptr);
+		}
+
+	/* we're ready, commit */
+	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
+		pcpu4k_nr_static_pages, static_size);
+
+	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size, 0, 0, NULL,
+				     pcpu4k_populate_pte);
+	goto out_free_ar;
+
+enomem:
+	while (--j >= 0)
+		free_bootmem(__pa(page_address(pcpu4k_pages[j])), PAGE_SIZE);
+	ret = -ENOMEM;
+out_free_ar:
+	free_bootmem(__pa(pcpu4k_pages), pages_size);
+	return ret;
+}
+
 static inline void setup_percpu_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
@@ -76,56 +168,24 @@ static inline void setup_percpu_segment(int cpu)
  */
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t size = __per_cpu_end - __per_cpu_start;
-	unsigned int nr_cpu_pages = DIV_ROUND_UP(size, PAGE_SIZE);
-	static struct page **pages;
-	size_t pages_size;
-	unsigned int cpu, i, j;
+	size_t static_size = __per_cpu_end - __per_cpu_start;
+	unsigned int cpu;
 	unsigned long delta;
 	size_t pcpu_unit_size;
+	ssize_t ret;
 
 	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
-	pr_info("PERCPU: Allocating %zd bytes for static per cpu data\n", size);
-
-	pages_size = nr_cpu_pages * num_possible_cpus() * sizeof(pages[0]);
-	pages = alloc_bootmem(pages_size);
-
-	j = 0;
-	for_each_possible_cpu(cpu) {
-		void *ptr;
-
-		for (i = 0; i < nr_cpu_pages; i++) {
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-			ptr = alloc_bootmem_pages(PAGE_SIZE);
-#else
-			int node = early_cpu_to_node(cpu);
-
-			if (!node_online(node) || !NODE_DATA(node)) {
-				ptr = alloc_bootmem_pages(PAGE_SIZE);
-				pr_info("cpu %d has no node %d or node-local "
-					"memory\n", cpu, node);
-				pr_debug("per cpu data for cpu%d at %016lx\n",
-					 cpu, __pa(ptr));
-			} else {
-				ptr = alloc_bootmem_pages_node(NODE_DATA(node),
-							       PAGE_SIZE);
-				pr_debug("per cpu data for cpu%d on node%d "
-					 "at %016lx\n", cpu, node, __pa(ptr));
-			}
-#endif
-			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
-			pages[j++] = virt_to_page(ptr);
-		}
-	}
 
-	pcpu4k_pages = pages;
-	pcpu4k_nr_static_pages = nr_cpu_pages;
-	pcpu_unit_size = pcpu_setup_first_chunk(pcpu4k_get_page, size, 0, 0,
-						NULL, pcpu4k_populate_pte);
+	/* allocate percpu area */
+	ret = setup_pcpu_4k(static_size);
+	if (ret < 0)
+		panic("cannot allocate static percpu area (%zu bytes, err=%zd)",
+		      static_size, ret);
 
-	free_bootmem(__pa(pages), pages_size);
+	pcpu_unit_size = ret;
 
+	/* alrighty, percpu areas up and running */
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu) {
 		per_cpu_offset(cpu) = delta + cpu * pcpu_unit_size;
-- 
1.6.0.2

