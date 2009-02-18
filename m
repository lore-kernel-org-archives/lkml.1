Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZBRMHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZBRMHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZBRMFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:50741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbZBRMFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:38 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] x86: convert to the new dynamic percpu allocator
Date: Wed, 18 Feb 2009 21:04:36 +0900
Message-Id: <1234958676-27618-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:05:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use new dynamic allocator, unified access to static/dynamic
        percpu memory

Convert to the new dynamic percpu allocator.

* implement populate_extra_pte() for both 32 and 64
* update setup_per_cpu_areas() to use pcpu_setup_static()
* define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr()
* define config HAVE_DYNAMIC_PER_CPU_AREA

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/Kconfig               |    3 ++
 arch/x86/include/asm/percpu.h  |    8 +++++
 arch/x86/include/asm/pgtable.h |    1 +
 arch/x86/kernel/setup_percpu.c |   62 +++++++++++++++++++++++++--------------
 arch/x86/mm/init_32.c          |   10 ++++++
 arch/x86/mm/init_64.c          |   19 ++++++++++++
 6 files changed, 81 insertions(+), 22 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f760a22..d3f6ead 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -135,6 +135,9 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
+config HAVE_DYNAMIC_PER_CPU_AREA
+	def_bool y
+
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index aee103b..8f1d2fb 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -43,6 +43,14 @@
 #else /* ...!ASSEMBLY */
 
 #include <linux/stringify.h>
+#include <asm/sections.h>
+
+#define __addr_to_pcpu_ptr(addr)					\
+	(void *)((unsigned long)(addr) - (unsigned long)pcpu_base_addr	\
+		 + (unsigned long)__per_cpu_start)
+#define __pcpu_ptr_to_addr(ptr)						\
+	(void *)((unsigned long)(ptr) + (unsigned long)pcpu_base_addr	\
+		 - (unsigned long)__per_cpu_start)
 
 #ifdef CONFIG_SMP
 #define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 6f7c102..dd91c25 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -402,6 +402,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
+void populate_extra_pte(unsigned long vaddr);
 
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index d992e6c..2dce435 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -61,38 +61,56 @@ static inline void setup_percpu_segment(int cpu)
  */
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t size;
-	char *ptr;
-	int cpu;
-
-	/* Copy section for each CPU (we discard the original) */
-	size = roundup(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	ssize_t size = __per_cpu_end - __per_cpu_start;
+	unsigned int nr_cpu_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	static struct page **pages;
+	size_t pages_size;
+	unsigned int cpu, i, j;
+	unsigned long delta;
+	size_t pcpu_unit_size;
 
 	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
+	pr_info("PERCPU: Allocating %zd bytes for static per cpu data\n", size);
 
-	pr_info("PERCPU: Allocating %zd bytes of per cpu data\n", size);
+	pages_size = nr_cpu_pages * num_possible_cpus() * sizeof(pages[0]);
+	pages = alloc_bootmem(pages_size);
 
+	j = 0;
 	for_each_possible_cpu(cpu) {
+		void *ptr;
+
+		for (i = 0; i < nr_cpu_pages; i++) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-		ptr = alloc_bootmem_pages(size);
+			ptr = alloc_bootmem_pages(PAGE_SIZE);
 #else
-		int node = early_cpu_to_node(cpu);
-		if (!node_online(node) || !NODE_DATA(node)) {
-			ptr = alloc_bootmem_pages(size);
-			pr_info("cpu %d has no node %d or node-local memory\n",
-				cpu, node);
-			pr_debug("per cpu data for cpu%d at %016lx\n",
-				 cpu, __pa(ptr));
-		} else {
-			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
-			pr_debug("per cpu data for cpu%d on node%d at %016lx\n",
-				cpu, node, __pa(ptr));
-		}
+			int node = early_cpu_to_node(cpu);
+
+			if (!node_online(node) || !NODE_DATA(node)) {
+				ptr = alloc_bootmem_pages(PAGE_SIZE);
+				pr_info("cpu %d has no node %d or node-local "
+					"memory\n", cpu, node);
+				pr_debug("per cpu data for cpu%d at %016lx\n",
+					 cpu, __pa(ptr));
+			} else {
+				ptr = alloc_bootmem_pages_node(NODE_DATA(node),
+							       PAGE_SIZE);
+				pr_debug("per cpu data for cpu%d on node%d "
+					 "at %016lx\n", cpu, node, __pa(ptr));
+			}
 #endif
+			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
+			pages[j++] = virt_to_page(ptr);
+		}
+	}
+
+	pcpu_unit_size = pcpu_setup_static(populate_extra_pte, pages, size);
 
-		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
-		per_cpu_offset(cpu) = ptr - __per_cpu_start;
+	free_bootmem(__pa(pages), pages_size);
+
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu) {
+		per_cpu_offset(cpu) = delta + cpu * pcpu_unit_size;
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 		per_cpu(cpu_number, cpu) = cpu;
 		setup_percpu_segment(cpu);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 00263bf..8b1a0ef 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -137,6 +137,16 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	return pte_offset_kernel(pmd, 0);
 }
 
+void __init populate_extra_pte(unsigned long vaddr)
+{
+	int pgd_idx = pgd_index(vaddr);
+	int pmd_idx = pmd_index(vaddr);
+	pmd_t *pmd;
+
+	pmd = one_md_table_init(swapper_pg_dir + pgd_idx);
+	one_page_table_init(pmd + pmd_idx);
+}
+
 static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
 					   unsigned long vaddr, pte_t *lastpte)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e6d36b4..7f91e2c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -223,6 +223,25 @@ set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 	set_pte_vaddr_pud(pud_page, vaddr, pteval);
 }
 
+void __init populate_extra_pte(unsigned long vaddr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+
+	pgd = pgd_offset_k(vaddr);
+	if (pgd_none(*pgd)) {
+		pud = (pud_t *)spp_getpage();
+		pgd_populate(&init_mm, pgd, pud);
+		if (pud != pud_offset(pgd, 0)) {
+			printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
+			       pud, pud_offset(pgd, 0));
+			return;
+		}
+	}
+
+	set_pte_vaddr_pud((pud_t *)pgd_page_vaddr(*pgd), vaddr, __pte(0));
+}
+
 /*
  * Create large page table mappings for a range of physical addresses.
  */
-- 
1.6.0.2

