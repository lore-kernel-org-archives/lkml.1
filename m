Return-Path: <linux-kernel-owner+w=401wt.eu-S1764144AbZDIFng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764144AbZDIFng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZDIFiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:38:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58089
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761394AbZDIFiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:38:08 -0400
Date: Wed, 08 Apr 2009 22:37:58 -0700 (PDT)
Message-Id: <20090408.223758.81953207.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12]: sparc64: Use new dynamic per-cpu allocator.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kconfig         |    3 +
 arch/sparc/kernel/smp_64.c |  165 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 159 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index cc12cd4..2185cf9 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -93,6 +93,9 @@ config AUDIT_ARCH
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y if SPARC64
 
+config HAVE_DYNAMIC_PER_CPU_AREA
+	def_bool y if SPARC64
+
 config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y if SPARC64
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 168025f..f1c8208 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -21,6 +21,7 @@
 #include <linux/jiffies.h>
 #include <linux/profile.h>
 #include <linux/bootmem.h>
+#include <linux/vmalloc.h>
 #include <linux/cpu.h>
 
 #include <asm/head.h>
@@ -1371,19 +1372,165 @@ void smp_send_stop(void)
 {
 }
 
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
+	int node = cpu_to_node(cpu);
+	void *ptr;
+
+	if (!node_online(node) || !NODE_DATA(node)) {
+		ptr = __alloc_bootmem(size, align, goal);
+		pr_info("cpu %d has no node %d or node-local memory\n",
+			cpu, node);
+		pr_debug("per cpu data for cpu%d %lu bytes at %016lx\n",
+			 cpu, size, __pa(ptr));
+	} else {
+		ptr = __alloc_bootmem_node(NODE_DATA(node),
+					   size, align, goal);
+		pr_debug("per cpu data for cpu%d %lu bytes on node%d at "
+			 "%016lx\n", cpu, size, node, __pa(ptr));
+	}
+	return ptr;
+#else
+	return __alloc_bootmem(size, align, goal);
+#endif
+}
+
+static size_t pcpur_size __initdata;
+static void **pcpur_ptrs __initdata;
+
+static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
+{
+	size_t off = (size_t)pageno << PAGE_SHIFT;
+
+	if (off >= pcpur_size)
+		return NULL;
+
+	return virt_to_page(pcpur_ptrs[cpu] + off);
+}
+
+#define PCPU_CHUNK_SIZE (4UL * 1024UL * 1024UL)
+
+static void __init pcpu_map_range(unsigned long start, unsigned long end,
+				  struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long pte_base;
+
+	BUG_ON((pfn<<PAGE_SHIFT)&(PCPU_CHUNK_SIZE - 1UL));
+
+	pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4U |
+		    _PAGE_CP_4U | _PAGE_CV_4U |
+		    _PAGE_P_4U | _PAGE_W_4U);
+	if (tlb_type == hypervisor)
+		pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
+			    _PAGE_CP_4V | _PAGE_CV_4V |
+			    _PAGE_P_4V | _PAGE_W_4V);
+
+	while (start < end) {
+		pgd_t *pgd = pgd_offset_k(start);
+		unsigned long this_end;
+		pud_t *pud;
+		pmd_t *pmd;
+		pte_t *pte;
+
+		pud = pud_offset(pgd, start);
+		if (pud_none(*pud)) {
+			pmd_t *new;
+
+			new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
+			pud_populate(&init_mm, pud, new);
+		}
+
+		pmd = pmd_offset(pud, start);
+		if (!pmd_present(*pmd)) {
+			pte_t *new;
+
+			new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
+			pmd_populate_kernel(&init_mm, pmd, new);
+		}
+
+		pte = pte_offset_kernel(pmd, start);
+		this_end = (start + PMD_SIZE) & PMD_MASK;
+		if (this_end > end)
+			this_end = end;
+
+		while (start < this_end) {
+			unsigned long paddr = pfn << PAGE_SHIFT;
+
+			pte_val(*pte) = (paddr | pte_base);
+
+			start += PAGE_SIZE;
+			pte++;
+			pfn++;
+		}
+	}
+}
+
 void __init setup_per_cpu_areas(void)
 {
-	unsigned long size, i, nr_possible_cpus = num_possible_cpus();
-	char *ptr;
+	size_t dyn_size, static_size = __per_cpu_end - __per_cpu_start;
+	static struct vm_struct vm;
+	unsigned long delta, cpu;
+	size_t pcpu_unit_size;
+	size_t ptrs_size;
+
+	pcpur_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
+			       PERCPU_DYNAMIC_RESERVE);
+	dyn_size = pcpur_size - static_size - PERCPU_MODULE_RESERVE;
+
+
+	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpur_ptrs[0]));
+	pcpur_ptrs = alloc_bootmem(ptrs_size);
+
+	for_each_possible_cpu(cpu) {
+		pcpur_ptrs[cpu] = pcpu_alloc_bootmem(cpu, PCPU_CHUNK_SIZE,
+						     PCPU_CHUNK_SIZE);
+
+		free_bootmem(__pa(pcpur_ptrs[cpu] + pcpur_size),
+			     PCPU_CHUNK_SIZE - pcpur_size);
+
+		memcpy(pcpur_ptrs[cpu], __per_cpu_load, static_size);
+	}
+
+	/* allocate address and map */
+	vm.flags = VM_ALLOC;
+	vm.size = num_possible_cpus() * PCPU_CHUNK_SIZE;
+	vm_area_register_early(&vm, PCPU_CHUNK_SIZE);
+
+	for_each_possible_cpu(cpu) {
+		unsigned long start = (unsigned long) vm.addr;
+		unsigned long end;
+
+		start += cpu * PCPU_CHUNK_SIZE;
+		end = start + PCPU_CHUNK_SIZE;
+		pcpu_map_range(start, end, virt_to_page(pcpur_ptrs[cpu]));
+	}
+
+	pcpu_unit_size = pcpu_setup_first_chunk(pcpur_get_page, static_size,
+						PERCPU_MODULE_RESERVE, dyn_size,
+						PCPU_CHUNK_SIZE, vm.addr, NULL);
 
-	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
-	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
+	free_bootmem(__pa(pcpur_ptrs), ptrs_size);
 
-	for_each_possible_cpu(i) {
-		__per_cpu_offset(i) = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-		ptr += size;
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu) {
+		__per_cpu_offset(cpu) = delta + cpu * pcpu_unit_size;
 	}
 
 	/* Setup %g5 for the boot cpu.  */
-- 
1.6.2.2

