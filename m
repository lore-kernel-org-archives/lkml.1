Return-Path: <linux-kernel-owner+w=401wt.eu-S1764930AbZFQDyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764930AbZFQDyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764470AbZFQDxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:53:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:49520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764352AbZFQDw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:52:59 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, JBeulich@novell.com, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] x86: prepare setup_pcpu_lpage() for pageattr fix
Date: Wed, 17 Jun 2009 12:52:15 +0900
Message-Id: <1245210739-25699-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245210739-25699-1-git-send-email-tj@kernel.org>
References: <1245210739-25699-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 03:52:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following changes in preparation of coming pageattr updates.

* Define and use array of struct pcpul_ent instead of array of
  pointers.  The only difference is ->cpu field which is set but
  unused yet.

* Rename variables according to the above change.

* Rename local variable vm to pcpul_vm and move it out of the
  function.

[ Impact: no functional difference ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |   58 ++++++++++++++++++++++-----------------
 1 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 8794c0c..7d38941 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -137,8 +137,14 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
  * better than only using 4k mappings while still being NUMA friendly.
  */
 #ifdef CONFIG_NEED_MULTIPLE_NODES
+struct pcpul_ent {
+	unsigned int	cpu;
+	void		*ptr;
+};
+
 static size_t pcpul_size __initdata;
-static void **pcpul_ptrs __initdata;
+static struct pcpul_ent *pcpul_map __initdata;
+static struct vm_struct pcpul_vm;
 
 static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
 {
@@ -147,13 +153,12 @@ static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
 	if (off >= pcpul_size)
 		return NULL;
 
-	return virt_to_page(pcpul_ptrs[cpu] + off);
+	return virt_to_page(pcpul_map[cpu].ptr + off);
 }
 
 static ssize_t __init setup_pcpu_lpage(size_t static_size)
 {
-	static struct vm_struct vm;
-	size_t ptrs_size, dyn_size;
+	size_t map_size, dyn_size;
 	unsigned int cpu;
 	ssize_t ret;
 
@@ -180,12 +185,14 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size)
 	dyn_size = pcpul_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
 
 	/* allocate pointer array and alloc large pages */
-	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_ptrs[0]));
-	pcpul_ptrs = alloc_bootmem(ptrs_size);
+	map_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_map[0]));
+	pcpul_map = alloc_bootmem(map_size);
 
 	for_each_possible_cpu(cpu) {
-		pcpul_ptrs[cpu] = pcpu_alloc_bootmem(cpu, PMD_SIZE, PMD_SIZE);
-		if (!pcpul_ptrs[cpu])
+		pcpul_map[cpu].cpu = cpu;
+		pcpul_map[cpu].ptr = pcpu_alloc_bootmem(cpu, PMD_SIZE,
+							PMD_SIZE);
+		if (!pcpul_map[cpu].ptr)
 			goto enomem;
 
 		/*
@@ -196,42 +203,43 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size)
 		 * not well-specified to have a PAT-incompatible area
 		 * (unmapped RAM, device memory, etc.) in that hole.
 		 */
-		free_bootmem(__pa(pcpul_ptrs[cpu] + pcpul_size),
+		free_bootmem(__pa(pcpul_map[cpu].ptr + pcpul_size),
 			     PMD_SIZE - pcpul_size);
 
-		memcpy(pcpul_ptrs[cpu], __per_cpu_load, static_size);
+		memcpy(pcpul_map[cpu].ptr, __per_cpu_load, static_size);
 	}
 
 	/* allocate address and map */
-	vm.flags = VM_ALLOC;
-	vm.size = num_possible_cpus() * PMD_SIZE;
-	vm_area_register_early(&vm, PMD_SIZE);
+	pcpul_vm.flags = VM_ALLOC;
+	pcpul_vm.size = num_possible_cpus() * PMD_SIZE;
+	vm_area_register_early(&pcpul_vm, PMD_SIZE);
 
 	for_each_possible_cpu(cpu) {
-		pmd_t *pmd;
+		pmd_t *pmd, pmd_v;
 
-		pmd = populate_extra_pmd((unsigned long)vm.addr
-					 + cpu * PMD_SIZE);
-		set_pmd(pmd, pfn_pmd(page_to_pfn(virt_to_page(pcpul_ptrs[cpu])),
-				     PAGE_KERNEL_LARGE));
+		pmd = populate_extra_pmd((unsigned long)pcpul_vm.addr +
+					 cpu * PMD_SIZE);
+		pmd_v = pfn_pmd(page_to_pfn(virt_to_page(pcpul_map[cpu].ptr)),
+				PAGE_KERNEL_LARGE);
+		set_pmd(pmd, pmd_v);
 	}
 
 	/* we're ready, commit */
 	pr_info("PERCPU: Remapped at %p with large pages, static data "
-		"%zu bytes\n", vm.addr, static_size);
+		"%zu bytes\n", pcpul_vm.addr, static_size);
 
 	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
 				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
-				     PMD_SIZE, vm.addr, NULL);
-	goto out_free_ar;
+				     PMD_SIZE, pcpul_vm.addr, NULL);
+	goto out_free_map;
 
 enomem:
 	for_each_possible_cpu(cpu)
-		if (pcpul_ptrs[cpu])
-			free_bootmem(__pa(pcpul_ptrs[cpu]), pcpul_size);
+		if (pcpul_map[cpu].ptr)
+			free_bootmem(__pa(pcpul_map[cpu].ptr), pcpul_size);
 	ret = -ENOMEM;
-out_free_ar:
-	free_bootmem(__pa(pcpul_ptrs), ptrs_size);
+out_free_map:
+	free_bootmem(__pa(pcpul_map), map_size);
 	return ret;
 }
 #else
-- 
1.6.0.2

