Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbZFQEHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbZFQEHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZFQEHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:07:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:41889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZFQEH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:07:28 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] x86,percpu: generalize lpage first chunk allocator
Date: Wed, 17 Jun 2009 13:04:35 +0900
Message-Id: <1245211476-27015-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245211476-27015-1-git-send-email-tj@kernel.org>
References: <1245211476-27015-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:04:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize and move x86 setup_pcpu_lpage() into
pcpu_lpage_first_chunk().  setup_pcpu_lpage() now is a simple wrapper
around the generalized version.  Other than taking size parameters and
using arch supplied callbacks to allocate/free/map memory,
pcpu_lpage_first_chunk() is identical to the original implementation.

This simplifies arch code and will help converting more archs to
dynamic percpu allocator.

While at it, factor out pcpu_calc_fc_sizes() which is common to
pcpu_embed_first_chunk() and pcpu_lpage_first_chunk().

[ Impact: code reorganization and generalization ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h  |    9 --
 arch/x86/kernel/setup_percpu.c |  169 ++------------------------------
 arch/x86/mm/pageattr.c         |    1 +
 include/linux/percpu.h         |   27 +++++
 mm/percpu.c                    |  209 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 244 insertions(+), 171 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 7e4111f..02ecb30 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -155,15 +155,6 @@ do {							\
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-void *pcpu_lpage_remapped(void *kaddr);
-#else
-static inline void *pcpu_lpage_remapped(void *kaddr)
-{
-	return NULL;
-}
-#endif
-
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ab896b3..4f2e0ac 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -137,44 +137,21 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
 }
 
 /*
- * Large page remap allocator
- *
- * This allocator uses PMD page as unit.  A PMD page is allocated for
- * each cpu and each is remapped into vmalloc area using PMD mapping.
- * As PMD page is quite large, only part of it is used for the first
- * chunk.  Unused part is returned to the bootmem allocator.
- *
- * So, the PMD pages are mapped twice - once to the physical mapping
- * and to the vmalloc area for the first percpu chunk.  The double
- * mapping does add one more PMD TLB entry pressure but still is much
- * better than only using 4k mappings while still being NUMA friendly.
+ * Large page remapping allocator
  */
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-struct pcpul_ent {
-	unsigned int	cpu;
-	void		*ptr;
-};
-
-static size_t pcpul_size;
-static struct pcpul_ent *pcpul_map;
-static struct vm_struct pcpul_vm;
-
-static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
+static void __init pcpul_map(void *ptr, size_t size, void *addr)
 {
-	size_t off = (size_t)pageno << PAGE_SHIFT;
+	pmd_t *pmd, pmd_v;
 
-	if (off >= pcpul_size)
-		return NULL;
-
-	return virt_to_page(pcpul_map[cpu].ptr + off);
+	pmd = populate_extra_pmd((unsigned long)addr);
+	pmd_v = pfn_pmd(page_to_pfn(virt_to_page(ptr)), PAGE_KERNEL_LARGE);
+	set_pmd(pmd, pmd_v);
 }
 
 static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 {
-	size_t map_size, dyn_size;
-	unsigned int cpu;
-	int i, j;
-	ssize_t ret;
+	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 
 	if (!chosen) {
 		size_t vm_size = VMALLOC_END - VMALLOC_START;
@@ -198,134 +175,10 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 		return -EINVAL;
 	}
 
-	/*
-	 * Currently supports only single page.  Supporting multiple
-	 * pages won't be too difficult if it ever becomes necessary.
-	 */
-	pcpul_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
-			       PERCPU_DYNAMIC_RESERVE);
-	if (pcpul_size > PMD_SIZE) {
-		pr_warning("PERCPU: static data is larger than large page, "
-			   "can't use large page\n");
-		return -EINVAL;
-	}
-	dyn_size = pcpul_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
-
-	/* allocate pointer array and alloc large pages */
-	map_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_map[0]));
-	pcpul_map = alloc_bootmem(map_size);
-
-	for_each_possible_cpu(cpu) {
-		pcpul_map[cpu].cpu = cpu;
-		pcpul_map[cpu].ptr = pcpu_alloc_bootmem(cpu, PMD_SIZE,
-							PMD_SIZE);
-		if (!pcpul_map[cpu].ptr) {
-			pr_warning("PERCPU: failed to allocate large page "
-				   "for cpu%u\n", cpu);
-			goto enomem;
-		}
-
-		/*
-		 * Only use pcpul_size bytes and give back the rest.
-		 *
-		 * Ingo: The 2MB up-rounding bootmem is needed to make
-		 * sure the partial 2MB page is still fully RAM - it's
-		 * not well-specified to have a PAT-incompatible area
-		 * (unmapped RAM, device memory, etc.) in that hole.
-		 */
-		free_bootmem(__pa(pcpul_map[cpu].ptr + pcpul_size),
-			     PMD_SIZE - pcpul_size);
-
-		memcpy(pcpul_map[cpu].ptr, __per_cpu_load, static_size);
-	}
-
-	/* allocate address and map */
-	pcpul_vm.flags = VM_ALLOC;
-	pcpul_vm.size = num_possible_cpus() * PMD_SIZE;
-	vm_area_register_early(&pcpul_vm, PMD_SIZE);
-
-	for_each_possible_cpu(cpu) {
-		pmd_t *pmd, pmd_v;
-
-		pmd = populate_extra_pmd((unsigned long)pcpul_vm.addr +
-					 cpu * PMD_SIZE);
-		pmd_v = pfn_pmd(page_to_pfn(virt_to_page(pcpul_map[cpu].ptr)),
-				PAGE_KERNEL_LARGE);
-		set_pmd(pmd, pmd_v);
-	}
-
-	/* we're ready, commit */
-	pr_info("PERCPU: Remapped at %p with large pages, static data "
-		"%zu bytes\n", pcpul_vm.addr, static_size);
-
-	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
-				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
-				     PMD_SIZE, pcpul_vm.addr, NULL);
-
-	/* sort pcpul_map array for pcpu_lpage_remapped() */
-	for (i = 0; i < num_possible_cpus() - 1; i++)
-		for (j = i + 1; j < num_possible_cpus(); j++)
-			if (pcpul_map[i].ptr > pcpul_map[j].ptr) {
-				struct pcpul_ent tmp = pcpul_map[i];
-				pcpul_map[i] = pcpul_map[j];
-				pcpul_map[j] = tmp;
-			}
-
-	return ret;
-
-enomem:
-	for_each_possible_cpu(cpu)
-		if (pcpul_map[cpu].ptr)
-			free_bootmem(__pa(pcpul_map[cpu].ptr), pcpul_size);
-	free_bootmem(__pa(pcpul_map), map_size);
-	return -ENOMEM;
-}
-
-/**
- * pcpu_lpage_remapped - determine whether a kaddr is in pcpul recycled area
- * @kaddr: the kernel address in question
- *
- * Determine whether @kaddr falls in the pcpul recycled area.  This is
- * used by pageattr to detect VM aliases and break up the pcpu PMD
- * mapping such that the same physical page is not mapped under
- * different attributes.
- *
- * The recycled area is always at the tail of a partially used PMD
- * page.
- *
- * RETURNS:
- * Address of corresponding remapped pcpu address if match is found;
- * otherwise, NULL.
- */
-void *pcpu_lpage_remapped(void *kaddr)
-{
-	void *pmd_addr = (void *)((unsigned long)kaddr & PMD_MASK);
-	unsigned long offset = (unsigned long)kaddr & ~PMD_MASK;
-	int left = 0, right = num_possible_cpus() - 1;
-	int pos;
-
-	/* pcpul in use at all? */
-	if (!pcpul_map)
-		return NULL;
-
-	/* okay, perform binary search */
-	while (left <= right) {
-		pos = (left + right) / 2;
-
-		if (pcpul_map[pos].ptr < pmd_addr)
-			left = pos + 1;
-		else if (pcpul_map[pos].ptr > pmd_addr)
-			right = pos - 1;
-		else {
-			/* it shouldn't be in the area for the first chunk */
-			WARN_ON(offset < pcpul_size);
-
-			return pcpul_vm.addr +
-				pcpul_map[pos].cpu * PMD_SIZE + offset;
-		}
-	}
-
-	return NULL;
+	return pcpu_lpage_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
+				      reserve - PERCPU_FIRST_CHUNK_RESERVE,
+				      PMD_SIZE,
+				      pcpu_fc_alloc, pcpu_fc_free, pcpul_map);
 }
 #else
 static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 9f9b8c2..29ce49d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -12,6 +12,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/pfn.h>
+#include <linux/percpu.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 41b5bfa..9f6bfd7 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -62,6 +62,7 @@ typedef struct page * (*pcpu_get_page_fn_t)(unsigned int cpu, int pageno);
 typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size);
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
+typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
 extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				size_t static_size, size_t reserved_size,
@@ -79,6 +80,32 @@ extern ssize_t __init pcpu_4k_first_chunk(
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+extern ssize_t __init pcpu_lpage_first_chunk(
+				size_t static_size, size_t reserved_size,
+				ssize_t dyn_size, size_t lpage_size,
+				pcpu_fc_alloc_fn_t alloc_fn,
+				pcpu_fc_free_fn_t free_fn,
+				pcpu_fc_map_fn_t map_fn);
+
+extern void *pcpu_lpage_remapped(void *kaddr);
+#else
+static inline ssize_t __init pcpu_lpage_first_chunk(
+				size_t static_size, size_t reserved_size,
+				ssize_t dyn_size, size_t lpage_size,
+				pcpu_fc_alloc_fn_t alloc_fn,
+				pcpu_fc_free_fn_t free_fn,
+				pcpu_fc_map_fn_t map_fn)
+{
+	return -EINVAL;
+}
+
+static inline void *pcpu_lpage_remapped(void *kaddr)
+{
+	return NULL;
+}
+#endif
+
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
diff --git a/mm/percpu.c b/mm/percpu.c
index c173763..17dfb7c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1190,6 +1190,19 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	return pcpu_unit_size;
 }
 
+static size_t pcpu_calc_fc_sizes(size_t static_size, size_t reserved_size,
+				 ssize_t *dyn_sizep)
+{
+	size_t size_sum;
+
+	size_sum = PFN_ALIGN(static_size + reserved_size +
+			     (*dyn_sizep >= 0 ? *dyn_sizep : 0));
+	if (*dyn_sizep != 0)
+		*dyn_sizep = size_sum - static_size - reserved_size;
+
+	return size_sum;
+}
+
 /*
  * Embedding first chunk setup helper.
  */
@@ -1241,10 +1254,7 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	unsigned int cpu;
 
 	/* determine parameters and allocate */
-	pcpue_size = PFN_ALIGN(static_size + reserved_size +
-			       (dyn_size >= 0 ? dyn_size : 0));
-	if (dyn_size != 0)
-		dyn_size = pcpue_size - static_size - reserved_size;
+	pcpue_size = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
 
 	pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
 	chunk_size = pcpue_unit_size * num_possible_cpus();
@@ -1391,6 +1401,197 @@ out_free_ar:
 }
 
 /*
+ * Large page remapping first chunk setup helper
+ */
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+struct pcpul_ent {
+	unsigned int	cpu;
+	void		*ptr;
+};
+
+static size_t pcpul_size;
+static size_t pcpul_unit_size;
+static struct pcpul_ent *pcpul_map;
+static struct vm_struct pcpul_vm;
+
+static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
+{
+	size_t off = (size_t)pageno << PAGE_SHIFT;
+
+	if (off >= pcpul_size)
+		return NULL;
+
+	return virt_to_page(pcpul_map[cpu].ptr + off);
+}
+
+/**
+ * pcpu_lpage_first_chunk - remap the first percpu chunk using large page
+ * @static_size: the size of static percpu area in bytes
+ * @reserved_size: the size of reserved percpu area in bytes
+ * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
+ * @lpage_size: the size of a large page
+ * @alloc_fn: function to allocate percpu lpage, always called with lpage_size
+ * @free_fn: function to free percpu memory, @size <= lpage_size
+ * @map_fn: function to map percpu lpage, always called with lpage_size
+ *
+ * This allocator uses large page as unit.  A large page is allocated
+ * for each cpu and each is remapped into vmalloc area using large
+ * page mapping.  As large page can be quite large, only part of it is
+ * used for the first chunk.  Unused part is returned to the bootmem
+ * allocator.
+ *
+ * So, the large pages are mapped twice - once to the physical mapping
+ * and to the vmalloc area for the first percpu chunk.  The double
+ * mapping does add one more large TLB entry pressure but still is
+ * much better than only using 4k mappings while still being NUMA
+ * friendly.
+ *
+ * RETURNS:
+ * The determined pcpu_unit_size which can be used to initialize
+ * percpu access on success, -errno on failure.
+ */
+ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
+				      ssize_t dyn_size, size_t lpage_size,
+				      pcpu_fc_alloc_fn_t alloc_fn,
+				      pcpu_fc_free_fn_t free_fn,
+				      pcpu_fc_map_fn_t map_fn)
+{
+	size_t size_sum;
+	size_t map_size;
+	unsigned int cpu;
+	int i, j;
+	ssize_t ret;
+
+	/*
+	 * Currently supports only single page.  Supporting multiple
+	 * pages won't be too difficult if it ever becomes necessary.
+	 */
+	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
+
+	pcpul_unit_size = lpage_size;
+	pcpul_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
+	if (pcpul_size > pcpul_unit_size) {
+		pr_warning("PERCPU: static data is larger than large page, "
+			   "can't use large page\n");
+		return -EINVAL;
+	}
+
+	/* allocate pointer array and alloc large pages */
+	map_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_map[0]));
+	pcpul_map = alloc_bootmem(map_size);
+
+	for_each_possible_cpu(cpu) {
+		void *ptr;
+
+		ptr = alloc_fn(cpu, lpage_size);
+		if (!ptr) {
+			pr_warning("PERCPU: failed to allocate large page "
+				   "for cpu%u\n", cpu);
+			goto enomem;
+		}
+
+		/*
+		 * Only use pcpul_size bytes and give back the rest.
+		 *
+		 * Ingo: The lpage_size up-rounding bootmem is needed
+		 * to make sure the partial lpage is still fully RAM -
+		 * it's not well-specified to have a incompatible area
+		 * (unmapped RAM, device memory, etc.) in that hole.
+		 */
+		free_fn(ptr + pcpul_size, lpage_size - pcpul_size);
+
+		pcpul_map[cpu].cpu = cpu;
+		pcpul_map[cpu].ptr = ptr;
+
+		memcpy(ptr, __per_cpu_load, static_size);
+	}
+
+	/* allocate address and map */
+	pcpul_vm.flags = VM_ALLOC;
+	pcpul_vm.size = num_possible_cpus() * pcpul_unit_size;
+	vm_area_register_early(&pcpul_vm, pcpul_unit_size);
+
+	for_each_possible_cpu(cpu)
+		map_fn(pcpul_map[cpu].ptr, pcpul_unit_size,
+		       pcpul_vm.addr + cpu * pcpul_unit_size);
+
+	/* we're ready, commit */
+	pr_info("PERCPU: Remapped at %p with large pages, static data "
+		"%zu bytes\n", pcpul_vm.addr, static_size);
+
+	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
+				     reserved_size, dyn_size, pcpul_unit_size,
+				     pcpul_vm.addr, NULL);
+
+	/* sort pcpul_map array for pcpu_lpage_remapped() */
+	for (i = 0; i < num_possible_cpus() - 1; i++)
+		for (j = i + 1; j < num_possible_cpus(); j++)
+			if (pcpul_map[i].ptr > pcpul_map[j].ptr) {
+				struct pcpul_ent tmp = pcpul_map[i];
+				pcpul_map[i] = pcpul_map[j];
+				pcpul_map[j] = tmp;
+			}
+
+	return ret;
+
+enomem:
+	for_each_possible_cpu(cpu)
+		if (pcpul_map[cpu].ptr)
+			free_fn(pcpul_map[cpu].ptr, pcpul_size);
+	free_bootmem(__pa(pcpul_map), map_size);
+	return -ENOMEM;
+}
+
+/**
+ * pcpu_lpage_remapped - determine whether a kaddr is in pcpul recycled area
+ * @kaddr: the kernel address in question
+ *
+ * Determine whether @kaddr falls in the pcpul recycled area.  This is
+ * used by pageattr to detect VM aliases and break up the pcpu large
+ * page mapping such that the same physical page is not mapped under
+ * different attributes.
+ *
+ * The recycled area is always at the tail of a partially used large
+ * page.
+ *
+ * RETURNS:
+ * Address of corresponding remapped pcpu address if match is found;
+ * otherwise, NULL.
+ */
+void *pcpu_lpage_remapped(void *kaddr)
+{
+	unsigned long unit_mask = pcpul_unit_size - 1;
+	void *lpage_addr = (void *)((unsigned long)kaddr & ~unit_mask);
+	unsigned long offset = (unsigned long)kaddr & unit_mask;
+	int left = 0, right = num_possible_cpus() - 1;
+	int pos;
+
+	/* pcpul in use at all? */
+	if (!pcpul_map)
+		return NULL;
+
+	/* okay, perform binary search */
+	while (left <= right) {
+		pos = (left + right) / 2;
+
+		if (pcpul_map[pos].ptr < lpage_addr)
+			left = pos + 1;
+		else if (pcpul_map[pos].ptr > lpage_addr)
+			right = pos - 1;
+		else {
+			/* it shouldn't be in the area for the first chunk */
+			WARN_ON(offset < pcpul_size);
+
+			return pcpul_vm.addr +
+				pcpul_map[pos].cpu * pcpul_unit_size + offset;
+		}
+	}
+
+	return NULL;
+}
+#endif
+
+/*
  * Generic percpu area setup.
  *
  * The embedding helper is used because its behavior closely resembles
-- 
1.6.0.2

