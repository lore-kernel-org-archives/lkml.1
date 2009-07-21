Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZGUIRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZGUIRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZGUIRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:17:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:51084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbZGUIRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:17:07 -0400
Message-ID: <4A65796B.2070101@kernel.org>
Date: Tue, 21 Jul 2009 17:16:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] percpu: fix sparse possible cpu map handling
References: <4A657949.6030003@kernel.org>
In-Reply-To: <4A657949.6030003@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 08:16:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu code has been assuming num_possible_cpus() == nr_cpu_ids which
is incorrect if cpu_possible_map contains holes.  This causes percpu
code to access beyond allocated memories and vmalloc areas.  On a
sparc64 machine with cpus 0 and 2 (u60), this triggers the following
warning or fails boot.

 WARNING: at /devel/tj/os/work/mm/vmalloc.c:106 vmap_page_range_noflush+0x1f0/0x240()
 Modules linked in:
 Call Trace:
  [00000000004b17d0] vmap_page_range_noflush+0x1f0/0x240
  [00000000004b1840] map_vm_area+0x20/0x60
  [00000000004b1950] __vmalloc_area_node+0xd0/0x160
  [0000000000593434] deflate_init+0x14/0xe0
  [0000000000583b94] __crypto_alloc_tfm+0xd4/0x1e0
  [00000000005844f0] crypto_alloc_base+0x50/0xa0
  [000000000058b898] alg_test_comp+0x18/0x80
  [000000000058dad4] alg_test+0x54/0x180
  [000000000058af00] cryptomgr_test+0x40/0x60
  [0000000000473098] kthread+0x58/0x80
  [000000000042b590] kernel_thread+0x30/0x60
  [0000000000472fd0] kthreadd+0xf0/0x160
 ---[ end trace 429b268a213317ba ]---

This patch fixes generic percpu functions and sparc64
setup_per_cpu_areas() so that they handle sparse cpu_possible_map
properly.

Please note that on x86, cpu_possible_map() doesn't contain holes and
thus num_possible_cpus() == nr_cpu_ids and this patch doesn't cause
any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/sparc/kernel/smp_64.c     |    4 ++--
 arch/x86/kernel/setup_percpu.c |   14 +++++++-------
 mm/percpu.c                    |   31 +++++++++++++++++++------------
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index fa44eaf..3691907 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1499,7 +1499,7 @@ void __init setup_per_cpu_areas(void)
 	dyn_size = pcpur_size - static_size - PERCPU_MODULE_RESERVE;


-	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpur_ptrs[0]));
+	ptrs_size = PFN_ALIGN(nr_cpu_ids * sizeof(pcpur_ptrs[0]));
 	pcpur_ptrs = alloc_bootmem(ptrs_size);

 	for_each_possible_cpu(cpu) {
@@ -1514,7 +1514,7 @@ void __init setup_per_cpu_areas(void)

 	/* allocate address and map */
 	vm.flags = VM_ALLOC;
-	vm.size = num_possible_cpus() * PCPU_CHUNK_SIZE;
+	vm.size = nr_cpu_ids * PCPU_CHUNK_SIZE;
 	vm_area_register_early(&vm, PCPU_CHUNK_SIZE);

 	for_each_possible_cpu(cpu) {
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 29a3eef..07d8191 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -165,7 +165,7 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)

 	if (!chosen) {
 		size_t vm_size = VMALLOC_END - VMALLOC_START;
-		size_t tot_size = num_possible_cpus() * PMD_SIZE;
+		size_t tot_size = nr_cpu_ids * PMD_SIZE;

 		/* on non-NUMA, embedding is better */
 		if (!pcpu_need_numa())
@@ -199,7 +199,7 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 	dyn_size = pcpul_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;

 	/* allocate pointer array and alloc large pages */
-	map_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_map[0]));
+	map_size = PFN_ALIGN(nr_cpu_ids * sizeof(pcpul_map[0]));
 	pcpul_map = alloc_bootmem(map_size);

 	for_each_possible_cpu(cpu) {
@@ -228,7 +228,7 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)

 	/* allocate address and map */
 	pcpul_vm.flags = VM_ALLOC;
-	pcpul_vm.size = num_possible_cpus() * PMD_SIZE;
+	pcpul_vm.size = nr_cpu_ids * PMD_SIZE;
 	vm_area_register_early(&pcpul_vm, PMD_SIZE);

 	for_each_possible_cpu(cpu) {
@@ -250,8 +250,8 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 				     PMD_SIZE, pcpul_vm.addr, NULL);

 	/* sort pcpul_map array for pcpu_lpage_remapped() */
-	for (i = 0; i < num_possible_cpus() - 1; i++)
-		for (j = i + 1; j < num_possible_cpus(); j++)
+	for (i = 0; i < nr_cpu_ids - 1; i++)
+		for (j = i + 1; j < nr_cpu_ids; j++)
 			if (pcpul_map[i].ptr > pcpul_map[j].ptr) {
 				struct pcpul_ent tmp = pcpul_map[i];
 				pcpul_map[i] = pcpul_map[j];
@@ -288,7 +288,7 @@ void *pcpu_lpage_remapped(void *kaddr)
 {
 	void *pmd_addr = (void *)((unsigned long)kaddr & PMD_MASK);
 	unsigned long offset = (unsigned long)kaddr & ~PMD_MASK;
-	int left = 0, right = num_possible_cpus() - 1;
+	int left = 0, right = nr_cpu_ids - 1;
 	int pos;

 	/* pcpul in use at all? */
@@ -377,7 +377,7 @@ static ssize_t __init setup_pcpu_4k(size_t static_size)
 	pcpu4k_nr_static_pages = PFN_UP(static_size);

 	/* unaligned allocations can't be freed, round up to page size */
-	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * num_possible_cpus()
+	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * nr_cpu_ids
 			       * sizeof(pcpu4k_pages[0]));
 	pcpu4k_pages = alloc_bootmem(pages_size);

diff --git a/mm/percpu.c b/mm/percpu.c
index b70f2ac..f772f02 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -8,12 +8,12 @@
  *
  * This is percpu allocator which can handle both static and dynamic
  * areas.  Percpu areas are allocated in chunks in vmalloc area.  Each
- * chunk is consisted of num_possible_cpus() units and the first chunk
- * is used for static percpu variables in the kernel image (special
- * boot time alloc/init handling necessary as these areas need to be
- * brought up before allocation services are running).  Unit grows as
- * necessary and all units grow or shrink in unison.  When a chunk is
- * filled up, another chunk is allocated.  ie. in vmalloc area
+ * chunk is consisted of nr_cpu_ids units and the first chunk is used
+ * for static percpu variables in the kernel image (special boot time
+ * alloc/init handling necessary as these areas need to be brought up
+ * before allocation services are running).  Unit grows as necessary
+ * and all units grow or shrink in unison.  When a chunk is filled up,
+ * another chunk is allocated.  ie. in vmalloc area
  *
  *  c0                           c1                         c2
  *  -------------------          -------------------        ------------
@@ -558,7 +558,7 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 		       bool flush_tlb)
 {
-	unsigned int last = num_possible_cpus() - 1;
+	unsigned int last = nr_cpu_ids - 1;
 	unsigned int cpu;

 	/* unmap must not be done on immutable chunk */
@@ -643,7 +643,7 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size,
  */
 static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
 {
-	unsigned int last = num_possible_cpus() - 1;
+	unsigned int last = nr_cpu_ids - 1;
 	unsigned int cpu;
 	int err;

@@ -1067,9 +1067,9 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 					PFN_UP(size_sum));

 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
-	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
+	pcpu_chunk_size = nr_cpu_ids * pcpu_unit_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
-		+ num_possible_cpus() * pcpu_unit_pages * sizeof(struct page *);
+		+ nr_cpu_ids * pcpu_unit_pages * sizeof(struct page *);

 	if (dyn_size < 0)
 		dyn_size = pcpu_unit_size - static_size - reserved_size;
@@ -1248,7 +1248,7 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	} else
 		pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);

-	chunk_size = pcpue_unit_size * num_possible_cpus();
+	chunk_size = pcpue_unit_size * nr_cpu_ids;

 	pcpue_ptr = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
 					    __pa(MAX_DMA_ADDRESS));
@@ -1259,9 +1259,16 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	}

 	/* return the leftover and copy */
-	for_each_possible_cpu(cpu) {
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
 		void *ptr = pcpue_ptr + cpu * pcpue_unit_size;

+		if (cpu_possible(cpu)) {
+			free_bootmem(__pa(ptr + pcpue_size),
+				     pcpue_unit_size - pcpue_size);
+			memcpy(ptr, __per_cpu_load, static_size);
+		} else
+			free_bootmem(__pa(ptr), pcpue_unit_size);
+
 		free_bootmem(__pa(ptr + pcpue_size),
 			     pcpue_unit_size - pcpue_size);
 		memcpy(ptr, __per_cpu_load, static_size);
-- 
1.6.0.2

