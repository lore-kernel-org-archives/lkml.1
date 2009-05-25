Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZEYDDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZEYDDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZEYDDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:03:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:35993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZEYDDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:03:09 -0400
Message-ID: <4A1A0A27.4050301@kernel.org>
Date: Mon, 25 May 2009 12:01:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, suresh.b.siddha@intel.com
CC: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2.6.30-rc7] x86: remove remap percpu allocator for the time
 being
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 03:02:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remap percpu allocator has subtle bug when combined with page
attribute changing.  Remap percpu allocator aliases PMD pages for the
first chunk and as pageattr doesn't know about the alias it ends up
updating page attributes of the original mapping thus leaving the
alises in inconsistent state which might lead to subtle data
corruption.  Please read the following threads for more information.

  http://thread.gmane.org/gmane.linux.kernel/835783

The following is the proposed fix which teaches pageattr about percpu
aliases.

  http://thread.gmane.org/gmane.linux.kernel/837157

However, the above changes are deemed too pervasive for upstream
inclusion for 2.6.30 release, so this patch removes remap allocator
from upstream for the time being.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
Ingo, after this goes upstream, I'll prep a new tj-percpu for
core/percpu which includes all pending patches and is properly merged
with this one.

Thanks.

 arch/x86/kernel/setup_percpu.c |  120 -----------------------------------------
 1 file changed, 1 insertion(+), 119 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 3a97a4c..6c77b1c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -124,122 +124,6 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 }
 
 /*
- * Remap allocator
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
- */
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-static size_t pcpur_size __initdata;
-static void **pcpur_ptrs __initdata;
-
-static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
-{
-	size_t off = (size_t)pageno << PAGE_SHIFT;
-
-	if (off >= pcpur_size)
-		return NULL;
-
-	return virt_to_page(pcpur_ptrs[cpu] + off);
-}
-
-static ssize_t __init setup_pcpu_remap(size_t static_size)
-{
-	static struct vm_struct vm;
-	size_t ptrs_size, dyn_size;
-	unsigned int cpu;
-	ssize_t ret;
-
-	/*
-	 * If large page isn't supported, there's no benefit in doing
-	 * this.  Also, on non-NUMA, embedding is better.
-	 */
-	if (!cpu_has_pse || !pcpu_need_numa())
-		return -EINVAL;
-
-	/*
-	 * Currently supports only single page.  Supporting multiple
-	 * pages won't be too difficult if it ever becomes necessary.
-	 */
-	pcpur_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
-			       PERCPU_DYNAMIC_RESERVE);
-	if (pcpur_size > PMD_SIZE) {
-		pr_warning("PERCPU: static data is larger than large page, "
-			   "can't use large page\n");
-		return -EINVAL;
-	}
-	dyn_size = pcpur_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
-
-	/* allocate pointer array and alloc large pages */
-	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpur_ptrs[0]));
-	pcpur_ptrs = alloc_bootmem(ptrs_size);
-
-	for_each_possible_cpu(cpu) {
-		pcpur_ptrs[cpu] = pcpu_alloc_bootmem(cpu, PMD_SIZE, PMD_SIZE);
-		if (!pcpur_ptrs[cpu])
-			goto enomem;
-
-		/*
-		 * Only use pcpur_size bytes and give back the rest.
-		 *
-		 * Ingo: The 2MB up-rounding bootmem is needed to make
-		 * sure the partial 2MB page is still fully RAM - it's
-		 * not well-specified to have a PAT-incompatible area
-		 * (unmapped RAM, device memory, etc.) in that hole.
-		 */
-		free_bootmem(__pa(pcpur_ptrs[cpu] + pcpur_size),
-			     PMD_SIZE - pcpur_size);
-
-		memcpy(pcpur_ptrs[cpu], __per_cpu_load, static_size);
-	}
-
-	/* allocate address and map */
-	vm.flags = VM_ALLOC;
-	vm.size = num_possible_cpus() * PMD_SIZE;
-	vm_area_register_early(&vm, PMD_SIZE);
-
-	for_each_possible_cpu(cpu) {
-		pmd_t *pmd;
-
-		pmd = populate_extra_pmd((unsigned long)vm.addr
-					 + cpu * PMD_SIZE);
-		set_pmd(pmd, pfn_pmd(page_to_pfn(virt_to_page(pcpur_ptrs[cpu])),
-				     PAGE_KERNEL_LARGE));
-	}
-
-	/* we're ready, commit */
-	pr_info("PERCPU: Remapped at %p with large pages, static data "
-		"%zu bytes\n", vm.addr, static_size);
-
-	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size,
-				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
-				     PMD_SIZE, vm.addr, NULL);
-	goto out_free_ar;
-
-enomem:
-	for_each_possible_cpu(cpu)
-		if (pcpur_ptrs[cpu])
-			free_bootmem(__pa(pcpur_ptrs[cpu]), PMD_SIZE);
-	ret = -ENOMEM;
-out_free_ar:
-	free_bootmem(__pa(pcpur_ptrs), ptrs_size);
-	return ret;
-}
-#else
-static ssize_t __init setup_pcpu_remap(size_t static_size)
-{
-	return -EINVAL;
-}
-#endif
-
-/*
  * Embedding allocator
  *
  * The first chunk is sized to just contain the static area plus
@@ -365,9 +249,7 @@ void __init setup_per_cpu_areas(void)
 	 * of large page mappings.  Please read comments on top of
 	 * each allocator for details.
 	 */
-	ret = setup_pcpu_remap(static_size);
-	if (ret < 0)
-		ret = setup_pcpu_embed(static_size);
+	ret = setup_pcpu_embed(static_size);
 	if (ret < 0)
 		ret = setup_pcpu_4k(static_size);
 	if (ret < 0)
