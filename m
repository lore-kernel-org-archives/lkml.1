Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZHNExZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZHNExZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZHNExY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:53:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:33372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZHNExX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:53:23 -0400
Message-ID: <4A84ED76.2050107@kernel.org>
Date: Fri, 14 Aug 2009 13:52:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Amerigo Wang <amwang@redhat.com>
Subject: [GIT PULL] percpu fixes for 2.6.31-rc6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 14 Aug 2009 04:52:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from the following percpu fixes tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

This branch contains three patches fixing the following two bugs.

* percpu code assumed num_possible_cpus() == nr_cpu_ids.  This is okay
  for x86 and other archs which don't have holes in cpu_possible_map
  but certain configurations on sparc64 have holes and this wrong
  assumption leads to boot failures or other mysterious problems.

  To fix this, nr_cpu_ids initialization which used to be done right
  after setup_per_cpu_areas() is moved so that it's done right before.
  setup_per_cpu_areas() already depends on cpu_possible_map which
  nr_cpu_ids also is initialized from, so this should be safe.

  Then, num_possible_cpus() usages are substituted with nr_cpu_ids.
  For x86 and other archs with contiguous cpu_possible_map, this is
  noop.  The only non-trivial code change is in
  pcpu_embed_first_chunk() where the code is changed to free whole
  areas for impossible cpus.

* percpu was calling get_vm_area() with the wrong GFP_ flags instead
  of the expected VM_ flags.  The only VM_ flag which can change
  behavior is VM_IOREMAP which is bit 0 which is __GFP_DMA which is
  not included in GFP_KERNEL, so the bug nor the fix won't cause any
  actual behavior difference.

Thanks.
---
Amerigo Wang (1):
      percpu: use the right flag for get_vm_area()

Tejun Heo (2):
      init: set nr_cpu_ids before setup_per_cpu_areas()
      percpu, sparc64: fix sparse possible cpu map handling

 arch/sparc/kernel/smp_64.c     |    4 ++--
 arch/x86/kernel/setup_percpu.c |   14 +++++++-------
 init/main.c                    |    2 +-
 mm/percpu.c                    |   35 +++++++++++++++++++----------------
 4 files changed, 29 insertions(+), 26 deletions(-)

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
 
diff --git a/init/main.c b/init/main.c
index 2c5ade7..2d9d6bd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -584,8 +584,8 @@ asmlinkage void __init start_kernel(void)
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
-	setup_per_cpu_areas();
 	setup_nr_cpu_ids();
+	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
 	build_all_zonelists();
diff --git a/mm/percpu.c b/mm/percpu.c
index b70f2ac..5fe3784 100644
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
 
@@ -749,7 +749,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
 	chunk->page = chunk->page_ar;
 
-	chunk->vm = get_vm_area(pcpu_chunk_size, GFP_KERNEL);
+	chunk->vm = get_vm_area(pcpu_chunk_size, VM_ALLOC);
 	if (!chunk->vm) {
 		free_pcpu_chunk(chunk);
 		return NULL;
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
@@ -1259,12 +1259,15 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	}
 
 	/* return the leftover and copy */
-	for_each_possible_cpu(cpu) {
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
 		void *ptr = pcpue_ptr + cpu * pcpue_unit_size;
 
-		free_bootmem(__pa(ptr + pcpue_size),
-			     pcpue_unit_size - pcpue_size);
-		memcpy(ptr, __per_cpu_load, static_size);
+		if (cpu_possible(cpu)) {
+			free_bootmem(__pa(ptr + pcpue_size),
+				     pcpue_unit_size - pcpue_size);
+			memcpy(ptr, __per_cpu_load, static_size);
+		} else
+			free_bootmem(__pa(ptr), pcpue_unit_size);
 	}
 
 	/* we're ready, commit */
