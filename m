Return-Path: <linux-kernel-owner+w=401wt.eu-S1764320AbZFQDww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764320AbZFQDww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZFQDwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:52:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:49469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbZFQDwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:52:39 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, JBeulich@novell.com, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] x86: rename remap percpu first chunk allocator to lpage
Date: Wed, 17 Jun 2009 12:52:14 +0900
Message-Id: <1245210739-25699-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245210739-25699-1-git-send-email-tj@kernel.org>
References: <1245210739-25699-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 03:52:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "remap" allocator remaps large pages to build the first chunk;
however, the name isn't very good because 4k allocator remaps too and
the whole point of the remap allocator is using large page mapping.
The allocator will be generalized and exported outside of x86, rename
it to lpage before that happens.

percpu_alloc kernel parameter is updated to accept both "remap" and
"lpage" for lpage allocator.

[ Impact: code cleanup, kernel parameter argument updated ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |   50 ++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index dfbc7e6..8794c0c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -124,7 +124,7 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 }
 
 /*
- * Remap allocator
+ * Large page remap allocator
  *
  * This allocator uses PMD page as unit.  A PMD page is allocated for
  * each cpu and each is remapped into vmalloc area using PMD mapping.
@@ -137,20 +137,20 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
  * better than only using 4k mappings while still being NUMA friendly.
  */
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-static size_t pcpur_size __initdata;
-static void **pcpur_ptrs __initdata;
+static size_t pcpul_size __initdata;
+static void **pcpul_ptrs __initdata;
 
-static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
+static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
 {
 	size_t off = (size_t)pageno << PAGE_SHIFT;
 
-	if (off >= pcpur_size)
+	if (off >= pcpul_size)
 		return NULL;
 
-	return virt_to_page(pcpur_ptrs[cpu] + off);
+	return virt_to_page(pcpul_ptrs[cpu] + off);
 }
 
-static ssize_t __init setup_pcpu_remap(size_t static_size)
+static ssize_t __init setup_pcpu_lpage(size_t static_size)
 {
 	static struct vm_struct vm;
 	size_t ptrs_size, dyn_size;
@@ -170,36 +170,36 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	 * Currently supports only single page.  Supporting multiple
 	 * pages won't be too difficult if it ever becomes necessary.
 	 */
-	pcpur_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
+	pcpul_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
 			       PERCPU_DYNAMIC_RESERVE);
-	if (pcpur_size > PMD_SIZE) {
+	if (pcpul_size > PMD_SIZE) {
 		pr_warning("PERCPU: static data is larger than large page, "
 			   "can't use large page\n");
 		return -EINVAL;
 	}
-	dyn_size = pcpur_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
+	dyn_size = pcpul_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
 
 	/* allocate pointer array and alloc large pages */
-	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpur_ptrs[0]));
-	pcpur_ptrs = alloc_bootmem(ptrs_size);
+	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_ptrs[0]));
+	pcpul_ptrs = alloc_bootmem(ptrs_size);
 
 	for_each_possible_cpu(cpu) {
-		pcpur_ptrs[cpu] = pcpu_alloc_bootmem(cpu, PMD_SIZE, PMD_SIZE);
-		if (!pcpur_ptrs[cpu])
+		pcpul_ptrs[cpu] = pcpu_alloc_bootmem(cpu, PMD_SIZE, PMD_SIZE);
+		if (!pcpul_ptrs[cpu])
 			goto enomem;
 
 		/*
-		 * Only use pcpur_size bytes and give back the rest.
+		 * Only use pcpul_size bytes and give back the rest.
 		 *
 		 * Ingo: The 2MB up-rounding bootmem is needed to make
 		 * sure the partial 2MB page is still fully RAM - it's
 		 * not well-specified to have a PAT-incompatible area
 		 * (unmapped RAM, device memory, etc.) in that hole.
 		 */
-		free_bootmem(__pa(pcpur_ptrs[cpu] + pcpur_size),
-			     PMD_SIZE - pcpur_size);
+		free_bootmem(__pa(pcpul_ptrs[cpu] + pcpul_size),
+			     PMD_SIZE - pcpul_size);
 
-		memcpy(pcpur_ptrs[cpu], __per_cpu_load, static_size);
+		memcpy(pcpul_ptrs[cpu], __per_cpu_load, static_size);
 	}
 
 	/* allocate address and map */
@@ -212,7 +212,7 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 
 		pmd = populate_extra_pmd((unsigned long)vm.addr
 					 + cpu * PMD_SIZE);
-		set_pmd(pmd, pfn_pmd(page_to_pfn(virt_to_page(pcpur_ptrs[cpu])),
+		set_pmd(pmd, pfn_pmd(page_to_pfn(virt_to_page(pcpul_ptrs[cpu])),
 				     PAGE_KERNEL_LARGE));
 	}
 
@@ -220,22 +220,22 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	pr_info("PERCPU: Remapped at %p with large pages, static data "
 		"%zu bytes\n", vm.addr, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size,
+	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
 				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
 				     PMD_SIZE, vm.addr, NULL);
 	goto out_free_ar;
 
 enomem:
 	for_each_possible_cpu(cpu)
-		if (pcpur_ptrs[cpu])
-			free_bootmem(__pa(pcpur_ptrs[cpu]), pcpur_size);
+		if (pcpul_ptrs[cpu])
+			free_bootmem(__pa(pcpul_ptrs[cpu]), pcpul_size);
 	ret = -ENOMEM;
 out_free_ar:
-	free_bootmem(__pa(pcpur_ptrs), ptrs_size);
+	free_bootmem(__pa(pcpul_ptrs), ptrs_size);
 	return ret;
 }
 #else
-static ssize_t __init setup_pcpu_remap(size_t static_size)
+static ssize_t __init setup_pcpu_lpage(size_t static_size)
 {
 	return -EINVAL;
 }
@@ -367,7 +367,7 @@ void __init setup_per_cpu_areas(void)
 	 * of large page mappings.  Please read comments on top of
 	 * each allocator for details.
 	 */
-	ret = setup_pcpu_remap(static_size);
+	ret = setup_pcpu_lpage(static_size);
 	if (ret < 0)
 		ret = setup_pcpu_embed(static_size);
 	if (ret < 0)
-- 
1.6.0.2

