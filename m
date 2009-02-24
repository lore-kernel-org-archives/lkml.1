Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbZBXDQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbZBXDQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbZBXDNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:58506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004AbZBXDNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:43 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] x86: add remapping percpu first chunk allocator
Date: Tue, 24 Feb 2009 12:11:41 +0900
Message-Id: <1235445101-7882-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add better first percpu allocation for NUMA

On NUMA, embedding allocator can't be used as different units can't be
made to fall in the correct NUMA nodes.  To use large page mapping,
each unit needs to be remapped.  However, percpu areas are usually
much smaller than large page size and unused space hurts a lot as the
number of cpus grow.  This allocator remaps large pages for each chunk
but gives back unused part to the bootmem allocator making the large
pages mapped twice.

This adds slightly to the TLB pressure but is much better than using
4k mappings while still being NUMA-friendly.

Ingo suggested that this would be the correct approach for NUMA.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |  137 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 135 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index fd4c399..2d946a8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -111,6 +111,133 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 }
 
 /*
+ * Remap allocator
+ *
+ * This allocator uses PMD page as unit.  A PMD page is allocated for
+ * each cpu and each is remapped into vmalloc area using PMD mapping.
+ * As PMD page is quite large, only part of it is used for the first
+ * chunk.  Unused part is returned to the bootmem allocator.
+ *
+ * So, the PMD pages are mapped twice - once to the physical mapping
+ * and to the vmalloc area for the first percpu chunk.  The double
+ * mapping does add one more PMD TLB entry pressure but still is much
+ * better than only using 4k mappings while still being NUMA friendly.
+ */
+#ifdef CONFIG_NEED_MULTIPLE_NODES
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
+static ssize_t __init setup_pcpu_remap(size_t static_size)
+{
+	static struct vm_struct vm;
+	pg_data_t *last;
+	size_t ptrs_size;
+	unsigned int cpu;
+	ssize_t ret;
+
+	/*
+	 * If large page isn't supported, there's no benefit in doing
+	 * this.  Also, on non-NUMA, embedding is better.
+	 */
+	if (!cpu_has_pse || pcpu_need_numa())
+		return -EINVAL;
+
+	last = NULL;
+	for_each_possible_cpu(cpu) {
+		int node = early_cpu_to_node(cpu);
+
+		if (node_online(node) && NODE_DATA(node) &&
+		    last && last != NODE_DATA(node))
+			goto proceed;
+
+		last = NODE_DATA(node);
+	}
+	return -EINVAL;
+
+proceed:
+	/*
+	 * Currently supports only single page.  Supporting multiple
+	 * pages won't be too difficult if it ever becomes necessary.
+	 */
+	pcpur_size = PFN_ALIGN(static_size + PERCPU_DYNAMIC_RESERVE);
+	if (pcpur_size > PMD_SIZE) {
+		pr_warning("PERCPU: static data is larger than large page, "
+			   "can't use large page\n");
+		return -EINVAL;
+	}
+
+	/* allocate pointer array and alloc large pages */
+	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpur_ptrs[0]));
+	pcpur_ptrs = alloc_bootmem(ptrs_size);
+
+	for_each_possible_cpu(cpu) {
+		pcpur_ptrs[cpu] = pcpu_alloc_bootmem(cpu, PMD_SIZE, PMD_SIZE);
+		if (!pcpur_ptrs[cpu])
+			goto enomem;
+
+		/*
+		 * Only use pcpur_size bytes and give back the rest.
+		 *
+		 * Ingo: The 2MB up-rounding bootmem is needed to make
+		 * sure the partial 2MB page is still fully RAM - it's
+		 * not well-specified to have a PAT-incompatible area
+		 * (unmapped RAM, device memory, etc.) in that hole.
+		 */
+		free_bootmem(__pa(pcpur_ptrs[cpu] + pcpur_size),
+			     PMD_SIZE - pcpur_size);
+
+		memcpy(pcpur_ptrs[cpu], __per_cpu_load, static_size);
+	}
+
+	/* allocate address and map */
+	vm.flags = VM_ALLOC;
+	vm.size = num_possible_cpus() * PMD_SIZE;
+	vm_area_register_early(&vm, PMD_SIZE);
+
+	for_each_possible_cpu(cpu) {
+		pmd_t *pmd;
+
+		pmd = populate_extra_pmd((unsigned long)vm.addr
+					 + cpu * PMD_SIZE);
+		set_pmd(pmd, pfn_pmd(page_to_pfn(virt_to_page(pcpur_ptrs[cpu])),
+				     PAGE_KERNEL_LARGE));
+	}
+
+	/* we're ready, commit */
+	pr_info("PERCPU: Remapped at %p with large pages, static data "
+		"%zu bytes\n", vm.addr, static_size);
+
+	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size, PMD_SIZE,
+				     pcpur_size - static_size, vm.addr, NULL);
+	goto out_free_ar;
+
+enomem:
+	for_each_possible_cpu(cpu)
+		if (pcpur_ptrs[cpu])
+			free_bootmem(__pa(pcpur_ptrs[cpu]), PMD_SIZE);
+	ret = -ENOMEM;
+out_free_ar:
+	free_bootmem(__pa(pcpur_ptrs), ptrs_size);
+	return ret;
+}
+#else
+static ssize_t __init setup_pcpu_remap(size_t static_size)
+{
+	return -EINVAL;
+}
+#endif
+
+/*
  * Embedding allocator
  *
  * The first chunk is sized to just contain the static area plus
@@ -259,8 +386,14 @@ void __init setup_per_cpu_areas(void)
 	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
 
-	/* allocate percpu area */
-	ret = setup_pcpu_embed(static_size);
+	/*
+	 * Allocate percpu area.  If PSE is supported, try to make use
+	 * of large page mappings.  Please read comments on top of
+	 * each allocator for details.
+	 */
+	ret = setup_pcpu_remap(static_size);
+	if (ret < 0)
+		ret = setup_pcpu_embed(static_size);
 	if (ret < 0)
 		ret = setup_pcpu_4k(static_size);
 	if (ret < 0)
-- 
1.6.0.2

