Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZGUKaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZGUKaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZGUKaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:30:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:37107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbZGUK2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:10 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/20] sparc64: use embedding percpu first chunk allocator
Date: Tue, 21 Jul 2009 19:26:18 +0900
Message-Id: <1248171979-29166-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc64 currently allocates a large page for each cpu and partially
remap them into vmalloc area much like what lpage first chunk
allocator did.  As a 4M page is used for each cpu, this results in
very large unit size and also adds TLB pressure due to the double
mapping of pages in the first chunk.

This patch converts sparc64 to use the embedding percpu first chunk
allocator which now knows how to handle NUMA configurations.  This
simplifies the code a lot, doesn't incur any extra TLB pressure and
results in better utilization of address space.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kconfig         |    3 +
 arch/sparc/kernel/smp_64.c |  128 ++++++-------------------------------------
 2 files changed, 21 insertions(+), 110 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4f6ed0f..fbd1233 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -95,6 +95,9 @@ config AUDIT_ARCH
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y if SPARC64
 
+config NEED_PER_CPU_EMBED_FIRST_CHUNK
+	def_bool y if SPARC64
+
 config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y if SPARC64
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index b03fd36..ff68373 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1389,8 +1389,8 @@ void smp_send_stop(void)
  * RETURNS:
  * Pointer to the allocated area on success, NULL on failure.
  */
-static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
-					unsigned long align)
+static void * __init pcpu_alloc_bootmem(unsigned int cpu, size_t size,
+					size_t align)
 {
 	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
 #ifdef CONFIG_NEED_MULTIPLE_NODES
@@ -1415,123 +1415,31 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 #endif
 }
 
-#define PCPU_CHUNK_SIZE (4UL * 1024UL * 1024UL)
-
-static void __init pcpu_map_range(unsigned long start, unsigned long end,
-				  struct page *page)
+static void __init pcpu_free_bootmem(void *ptr, size_t size)
 {
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long pte_base;
-
-	BUG_ON((pfn<<PAGE_SHIFT)&(PCPU_CHUNK_SIZE - 1UL));
-
-	pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4U |
-		    _PAGE_CP_4U | _PAGE_CV_4U |
-		    _PAGE_P_4U | _PAGE_W_4U);
-	if (tlb_type == hypervisor)
-		pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
-			    _PAGE_CP_4V | _PAGE_CV_4V |
-			    _PAGE_P_4V | _PAGE_W_4V);
-
-	while (start < end) {
-		pgd_t *pgd = pgd_offset_k(start);
-		unsigned long this_end;
-		pud_t *pud;
-		pmd_t *pmd;
-		pte_t *pte;
-
-		pud = pud_offset(pgd, start);
-		if (pud_none(*pud)) {
-			pmd_t *new;
-
-			new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-			pud_populate(&init_mm, pud, new);
-		}
-
-		pmd = pmd_offset(pud, start);
-		if (!pmd_present(*pmd)) {
-			pte_t *new;
-
-			new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-			pmd_populate_kernel(&init_mm, pmd, new);
-		}
-
-		pte = pte_offset_kernel(pmd, start);
-		this_end = (start + PMD_SIZE) & PMD_MASK;
-		if (this_end > end)
-			this_end = end;
-
-		while (start < this_end) {
-			unsigned long paddr = pfn << PAGE_SHIFT;
-
-			pte_val(*pte) = (paddr | pte_base);
+	free_bootmem(__pa(ptr), size);
+}
 
-			start += PAGE_SIZE;
-			pte++;
-			pfn++;
-		}
-	}
+static int pcpu_cpu_distance(unsigned int from, unsigned int to)
+{
+	if (cpu_to_node(from) == cpu_to_node(to))
+		return LOCAL_DISTANCE;
+	else
+		return REMOTE_DISTANCE;
 }
 
 void __init setup_per_cpu_areas(void)
 {
-	static struct vm_struct vm;
-	struct pcpu_alloc_info *ai;
-	unsigned long delta, cpu;
-	size_t size_sum;
-	size_t ptrs_size;
-	void **ptrs;
+	unsigned long delta;
+	unsigned int cpu;
 	int rc;
 
-	ai = pcpu_alloc_alloc_info(1, nr_cpu_ids);
-
-	ai->static_size = __per_cpu_end - __per_cpu_start;
-	ai->reserved_size = PERCPU_MODULE_RESERVE;
-
-	size_sum = PFN_ALIGN(ai->static_size + ai->reserved_size +
-			     PERCPU_DYNAMIC_RESERVE);
-
-	ai->dyn_size = size_sum - ai->static_size - ai->reserved_size;
-	ai->unit_size = PCPU_CHUNK_SIZE;
-	ai->atom_size = PCPU_CHUNK_SIZE;
-	ai->alloc_size = PCPU_CHUNK_SIZE;
-	ai->groups[0].nr_units = nr_cpu_ids;
-
-	for_each_possible_cpu(cpu)
-		ai->groups[0].cpu_map[cpu] = cpu;
-
-	ptrs_size = PFN_ALIGN(nr_cpu_ids * sizeof(ptrs[0]));
-	ptrs = alloc_bootmem(ptrs_size);
-
-	for_each_possible_cpu(cpu) {
-		ptrs[cpu] = pcpu_alloc_bootmem(cpu, PCPU_CHUNK_SIZE,
-					       PCPU_CHUNK_SIZE);
-
-		free_bootmem(__pa(ptrs[cpu] + size_sum),
-			     PCPU_CHUNK_SIZE - size_sum);
-
-		memcpy(ptrs[cpu], __per_cpu_load, ai->static_size);
-	}
-
-	/* allocate address and map */
-	vm.flags = VM_ALLOC;
-	vm.size = nr_cpu_ids * PCPU_CHUNK_SIZE;
-	vm_area_register_early(&vm, PCPU_CHUNK_SIZE);
-
-	for_each_possible_cpu(cpu) {
-		unsigned long start = (unsigned long) vm.addr;
-		unsigned long end;
-
-		start += cpu * PCPU_CHUNK_SIZE;
-		end = start + PCPU_CHUNK_SIZE;
-		pcpu_map_range(start, end, virt_to_page(ptrs[cpu]));
-	}
-
-	rc = pcpu_setup_first_chunk(ai, vm.addr);
+	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+				    PERCPU_DYNAMIC_RESERVE, 4 << 20,
+				    pcpu_cpu_distance, pcpu_alloc_bootmem,
+				    pcpu_free_bootmem);
 	if (rc)
-		panic("failed to setup percpu first chunk (%d)", rc);
-
-	free_bootmem(__pa(ptrs), ptrs_size);
+		panic("failed to initialize first chunk (%d)", rc);
 
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu)
-- 
1.6.0.2

