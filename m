Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZCFGuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZCFGuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbZCFGrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:56808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392AbZCFGrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:09 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] percpu, module: implement reserved allocation and use it for module percpu variables
Date: Fri,  6 Mar 2009 15:46:27 +0900
Message-Id: <1236321988-19457-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add reserved allocation functionality and use it for module
	percpu variables

This patch implements reserved allocation from the first chunk.  When
setting up the first chunk, arch can ask to set aside certain number
of bytes right after the core static area which is available only
through a separate reserved allocator.  This will be used primarily
for module static percpu variables on architectures with limited
relocation range to ensure that the module perpcu symbols are inside
the relocatable range.

If reserved area is requested, the first chunk becomes reserved and
isn't available for regular allocation.  If the first chunk also
includes piggy-back dynamic allocation area, a separate chunk mapping
the same region is created to serve dynamic allocation.  The first one
is called static first chunk and the second dynamic first chunk.
Although they share the page map, their different area map
initializations guarantee they serve disjoint areas according to their
purposes.

If arch doesn't setup reserved area, reserved allocation is handled
like any other allocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |    8 +-
 include/linux/percpu.h         |   10 ++-
 kernel/module.c                |    2 +-
 mm/percpu.c                    |  153 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 144 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 38e2b2a..dd4eabc 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -217,7 +217,7 @@ proceed:
 	pr_info("PERCPU: Remapped at %p with large pages, static data "
 		"%zu bytes\n", vm.addr, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size, PMD_SIZE,
+	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size, 0, PMD_SIZE,
 				     pcpur_size - static_size, vm.addr, NULL);
 	goto out_free_ar;
 
@@ -297,7 +297,7 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
 		pcpue_size >> PAGE_SHIFT, pcpue_ptr, static_size);
 
-	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
+	return pcpu_setup_first_chunk(pcpue_get_page, static_size, 0,
 				      pcpue_unit_size, dyn_size,
 				      pcpue_ptr, NULL);
 }
@@ -356,8 +356,8 @@ static ssize_t __init setup_pcpu_4k(size_t static_size)
 	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
 		pcpu4k_nr_static_pages, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size, -1, -1, NULL,
-				     pcpu4k_populate_pte);
+	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size, 0, -1, -1,
+				     NULL, pcpu4k_populate_pte);
 	goto out_free_ar;
 
 enomem:
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a96fc53..8ff1515 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -117,10 +117,10 @@ typedef struct page * (*pcpu_get_page_fn_t)(unsigned int cpu, int pageno);
 typedef void (*pcpu_populate_pte_fn_t)(unsigned long addr);
 
 extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
-					size_t static_size,
-					ssize_t unit_size, ssize_t dyn_size,
-					void *base_addr,
-					pcpu_populate_pte_fn_t populate_pte_fn);
+				size_t static_size, size_t reserved_size,
+				ssize_t unit_size, ssize_t dyn_size,
+				void *base_addr,
+				pcpu_populate_pte_fn_t populate_pte_fn);
 
 /*
  * Use this to get to a cpu's version of the per-cpu object
@@ -129,6 +129,8 @@ extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
  */
 #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
 
+extern void *__alloc_reserved_percpu(size_t size, size_t align);
+
 #else /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
 
 struct percpu_data {
diff --git a/kernel/module.c b/kernel/module.c
index 1f0657a..f0e04d6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -381,7 +381,7 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 		align = PAGE_SIZE;
 	}
 
-	ptr = __alloc_percpu(size, align);
+	ptr = __alloc_reserved_percpu(size, align);
 	if (!ptr)
 		printk(KERN_WARNING
 		       "Could not allocate %lu bytes percpu data\n", size);
diff --git a/mm/percpu.c b/mm/percpu.c
index 5b47d9f..ef8e169 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -94,6 +94,11 @@ static size_t pcpu_chunk_struct_size __read_mostly;
 void *pcpu_base_addr __read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
+/* optional reserved chunk, only accessible for reserved allocations */
+static struct pcpu_chunk *pcpu_reserved_chunk;
+/* offset limit of the reserved chunk */
+static int pcpu_reserved_chunk_limit;
+
 /*
  * One mutex to rule them all.
  *
@@ -201,13 +206,14 @@ static void *pcpu_realloc(void *p, size_t size, size_t new_size)
  *
  * This function is called after an allocation or free changed @chunk.
  * New slot according to the changed state is determined and @chunk is
- * moved to the slot.
+ * moved to the slot.  Note that the reserved chunk is never put on
+ * chunk slots.
  */
 static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
 {
 	int nslot = pcpu_chunk_slot(chunk);
 
-	if (oslot != nslot) {
+	if (chunk != pcpu_reserved_chunk && oslot != nslot) {
 		if (oslot < nslot)
 			list_move(&chunk->list, &pcpu_slot[nslot]);
 		else
@@ -255,6 +261,15 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 	struct rb_node *n, *parent;
 	struct pcpu_chunk *chunk;
 
+	/* is it in the reserved chunk? */
+	if (pcpu_reserved_chunk) {
+		void *start = pcpu_reserved_chunk->vm->addr;
+
+		if (addr >= start && addr < start + pcpu_reserved_chunk_limit)
+			return pcpu_reserved_chunk;
+	}
+
+	/* nah... search the regular ones */
 	n = *pcpu_chunk_rb_search(addr, &parent);
 	if (!n) {
 		/* no exactly matching chunk, the parent is the closest */
@@ -713,9 +728,10 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 }
 
 /**
- * __alloc_percpu - allocate percpu area
+ * pcpu_alloc - the percpu allocator
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
+ * @reserved: allocate from the reserved chunk if available
  *
  * Allocate percpu area of @size bytes aligned at @align.  Might
  * sleep.  Might trigger writeouts.
@@ -723,7 +739,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
  */
-void *__alloc_percpu(size_t size, size_t align)
+static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 {
 	void *ptr = NULL;
 	struct pcpu_chunk *chunk;
@@ -737,7 +753,18 @@ void *__alloc_percpu(size_t size, size_t align)
 
 	mutex_lock(&pcpu_mutex);
 
-	/* allocate area */
+	/* serve reserved allocations from the reserved chunk if available */
+	if (reserved && pcpu_reserved_chunk) {
+		chunk = pcpu_reserved_chunk;
+		if (size > chunk->contig_hint)
+			goto out_unlock;
+		off = pcpu_alloc_area(chunk, size, align);
+		if (off >= 0)
+			goto area_found;
+		goto out_unlock;
+	}
+
+	/* search through normal chunks */
 	for (slot = pcpu_size_to_slot(size); slot < pcpu_nr_slots; slot++) {
 		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
 			if (size > chunk->contig_hint)
@@ -773,8 +800,41 @@ out_unlock:
 	mutex_unlock(&pcpu_mutex);
 	return ptr;
 }
+
+/**
+ * __alloc_percpu - allocate dynamic percpu area
+ * @size: size of area to allocate in bytes
+ * @align: alignment of area (max PAGE_SIZE)
+ *
+ * Allocate percpu area of @size bytes aligned at @align.  Might
+ * sleep.  Might trigger writeouts.
+ *
+ * RETURNS:
+ * Percpu pointer to the allocated area on success, NULL on failure.
+ */
+void *__alloc_percpu(size_t size, size_t align)
+{
+	return pcpu_alloc(size, align, false);
+}
 EXPORT_SYMBOL_GPL(__alloc_percpu);
 
+/**
+ * __alloc_reserved_percpu - allocate reserved percpu area
+ * @size: size of area to allocate in bytes
+ * @align: alignment of area (max PAGE_SIZE)
+ *
+ * Allocate percpu area of @size bytes aligned at @align from reserved
+ * percpu area if arch has set it up; otherwise, allocation is served
+ * from the same dynamic area.  Might sleep.  Might trigger writeouts.
+ *
+ * RETURNS:
+ * Percpu pointer to the allocated area on success, NULL on failure.
+ */
+void *__alloc_reserved_percpu(size_t size, size_t align)
+{
+	return pcpu_alloc(size, align, true);
+}
+
 static void pcpu_kill_chunk(struct pcpu_chunk *chunk)
 {
 	WARN_ON(chunk->immutable);
@@ -826,6 +886,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * pcpu_setup_first_chunk - initialize the first percpu chunk
  * @get_page_fn: callback to fetch page pointer
  * @static_size: the size of static percpu area in bytes
+ * @reserved_size: the size of reserved percpu area in bytes
  * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, -1 for auto
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
  * @base_addr: mapped address, NULL for auto
@@ -844,14 +905,22 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * indicates end of pages for the cpu.  Note that @get_page_fn() must
  * return the same number of pages for all cpus.
  *
+ * @reserved_size, if non-zero, specifies the amount of bytes to
+ * reserve after the static area in the first chunk.  This reserves
+ * the first chunk such that it's available only through reserved
+ * percpu allocation.  This is primarily used to serve module percpu
+ * static areas on architectures where the addressing model has
+ * limited offset range for symbol relocations to guarantee module
+ * percpu symbols fall inside the relocatable range.
+ *
  * @unit_size, if non-negative, specifies unit size and must be
  * aligned to PAGE_SIZE and equal to or larger than @static_size +
- * @dyn_size.
+ * @reserved_size + @dyn_size.
  *
  * @dyn_size, if non-negative, limits the number of bytes available
  * for dynamic allocation in the first chunk.  Specifying non-negative
  * value make percpu leave alone the area beyond @static_size +
- * @dyn_size.
+ * @reserved_size + @dyn_size.
  *
  * Non-null @base_addr means that the caller already allocated virtual
  * region for the first chunk and mapped it.  percpu must not mess
@@ -861,28 +930,36 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * @populate_pte_fn is used to populate the pagetable.  NULL means the
  * caller already populated the pagetable.
  *
+ * If the first chunk ends up with both reserved and dynamic areas, it
+ * is served by two chunks - one to serve the core static and reserved
+ * areas and the other for the dynamic area.  They share the same vm
+ * and page map but uses different area allocation map to stay away
+ * from each other.  The latter chunk is circulated in the chunk slots
+ * and available for dynamic allocation like any other chunks.
+ *
  * RETURNS:
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access.
  */
 size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
-				     size_t static_size,
+				     size_t static_size, size_t reserved_size,
 				     ssize_t unit_size, ssize_t dyn_size,
 				     void *base_addr,
 				     pcpu_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct first_vm;
-	static int smap[2];
-	struct pcpu_chunk *schunk;
+	static int smap[2], dmap[2];
+	struct pcpu_chunk *schunk, *dchunk = NULL;
 	unsigned int cpu;
 	int nr_pages;
 	int err, i;
 
 	/* santiy checks */
-	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC);
+	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC ||
+		     ARRAY_SIZE(dmap) >= PCPU_DFL_MAP_ALLOC);
 	BUG_ON(!static_size);
 	if (unit_size >= 0) {
-		BUG_ON(unit_size < static_size +
+		BUG_ON(unit_size < static_size + reserved_size +
 				   (dyn_size >= 0 ? dyn_size : 0));
 		BUG_ON(unit_size & ~PAGE_MASK);
 	} else {
@@ -895,7 +972,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 		pcpu_unit_pages = unit_size >> PAGE_SHIFT;
 	else
 		pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_SIZE >> PAGE_SHIFT,
-					PFN_UP(static_size));
+					PFN_UP(static_size + reserved_size));
 
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
@@ -903,7 +980,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 		+ num_possible_cpus() * pcpu_unit_pages * sizeof(struct page *);
 
 	if (dyn_size < 0)
-		dyn_size = pcpu_unit_size - static_size;
+		dyn_size = pcpu_unit_size - static_size - reserved_size;
 
 	/*
 	 * Allocate chunk slots.  The additional last slot is for
@@ -914,20 +991,49 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	for (i = 0; i < pcpu_nr_slots; i++)
 		INIT_LIST_HEAD(&pcpu_slot[i]);
 
-	/* init static chunk */
+	/*
+	 * Initialize static chunk.  If reserved_size is zero, the
+	 * static chunk covers static area + dynamic allocation area
+	 * in the first chunk.  If reserved_size is not zero, it
+	 * covers static area + reserved area (mostly used for module
+	 * static percpu allocation).
+	 */
 	schunk = alloc_bootmem(pcpu_chunk_struct_size);
 	INIT_LIST_HEAD(&schunk->list);
 	schunk->vm = &first_vm;
 	schunk->map = smap;
 	schunk->map_alloc = ARRAY_SIZE(smap);
 	schunk->page = schunk->page_ar;
-	schunk->free_size = dyn_size;
+
+	if (reserved_size) {
+		schunk->free_size = reserved_size;
+		pcpu_reserved_chunk = schunk;	/* not for dynamic alloc */
+	} else {
+		schunk->free_size = dyn_size;
+		dyn_size = 0;			/* dynamic area covered */
+	}
 	schunk->contig_hint = schunk->free_size;
 
 	schunk->map[schunk->map_used++] = -static_size;
 	if (schunk->free_size)
 		schunk->map[schunk->map_used++] = schunk->free_size;
 
+	pcpu_reserved_chunk_limit = static_size + schunk->free_size;
+
+	/* init dynamic chunk if necessary */
+	if (dyn_size) {
+		dchunk = alloc_bootmem(sizeof(struct pcpu_chunk));
+		INIT_LIST_HEAD(&dchunk->list);
+		dchunk->vm = &first_vm;
+		dchunk->map = dmap;
+		dchunk->map_alloc = ARRAY_SIZE(dmap);
+		dchunk->page = schunk->page_ar;	/* share page map with schunk */
+
+		dchunk->contig_hint = dchunk->free_size = dyn_size;
+		dchunk->map[dchunk->map_used++] = -pcpu_reserved_chunk_limit;
+		dchunk->map[dchunk->map_used++] = dchunk->free_size;
+	}
+
 	/* allocate vm address */
 	first_vm.flags = VM_ALLOC;
 	first_vm.size = pcpu_chunk_size;
@@ -937,12 +1043,14 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	else {
 		/*
 		 * Pages already mapped.  No need to remap into
-		 * vmalloc area.  In this case the static chunk can't
-		 * be mapped or unmapped by percpu and is marked
+		 * vmalloc area.  In this case the first chunks can't
+		 * be mapped or unmapped by percpu and are marked
 		 * immutable.
 		 */
 		first_vm.addr = base_addr;
 		schunk->immutable = true;
+		if (dchunk)
+			dchunk->immutable = true;
 	}
 
 	/* assign pages */
@@ -978,8 +1086,13 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	}
 
 	/* link the first chunk in */
-	pcpu_chunk_relocate(schunk, -1);
-	pcpu_chunk_addr_insert(schunk);
+	if (!dchunk) {
+		pcpu_chunk_relocate(schunk, -1);
+		pcpu_chunk_addr_insert(schunk);
+	} else {
+		pcpu_chunk_relocate(dchunk, -1);
+		pcpu_chunk_addr_insert(dchunk);
+	}
 
 	/* we're done */
 	pcpu_base_addr = (void *)pcpu_chunk_addr(schunk, 0, 0);
-- 
1.6.0.2

