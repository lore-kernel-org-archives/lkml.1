Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbZBXDOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbZBXDOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbZBXDNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:58468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZBXDNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:12 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] percpu: give more latitude to arch specific first chunk initialization
Date: Tue, 24 Feb 2009 12:11:38 +0900
Message-Id: <1235445101-7882-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: more latitude for first percpu chunk allocation

The first percpu chunk serves the kernel static percpu area and may or
may not contain extra room for further dynamic allocation.
Initialization of the first chunk needs to be done before normal
memory allocation service is up, so it has its own init path -
pcpu_setup_static().

It seems archs need more latitude while initializing the first chunk
for example to take advantage of large page mapping.  This patch makes
the following changes to allow this.

* Define PERCPU_DYNAMIC_RESERVE to give arch hint about how much space
  to reserve in the first chunk for further dynamic allocation.

* Rename pcpu_setup_static() to pcpu_setup_first_chunk().

* Make pcpu_setup_first_chunk() much more flexible by fetching page
  pointer by callback and adding optional @unit_size, @free_size and
  @base_addr arguments which allow archs to selectively part of chunk
  initialization to their likings.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   15 ++++-
 include/linux/percpu.h         |   39 ++++++++++-
 mm/percpu.c                    |  149 +++++++++++++++++++++++++++++++---------
 3 files changed, 167 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 671e652..d928e88 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -41,6 +41,16 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 };
 EXPORT_SYMBOL(__per_cpu_offset);
 
+static struct page **pcpu4k_pages __initdata;
+static int pcpu4k_nr_static_pages __initdata;
+
+static struct page * __init pcpu4k_get_page(unsigned int cpu, int pageno)
+{
+	if (pageno < pcpu4k_nr_static_pages)
+		return pcpu4k_pages[cpu * pcpu4k_nr_static_pages + pageno];
+	return NULL;
+}
+
 static void __init pcpu4k_populate_pte(unsigned long addr)
 {
 	populate_extra_pte(addr);
@@ -109,7 +119,10 @@ void __init setup_per_cpu_areas(void)
 		}
 	}
 
-	pcpu_unit_size = pcpu_setup_static(pcpu4k_populate_pte, pages, size);
+	pcpu4k_pages = pages;
+	pcpu4k_nr_static_pages = nr_cpu_pages;
+	pcpu_unit_size = pcpu_setup_first_chunk(pcpu4k_get_page, size, 0, 0,
+						NULL, pcpu4k_populate_pte);
 
 	free_bootmem(__pa(pages), pages_size);
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1808099..910beb0 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -78,12 +78,47 @@
 
 #ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
 
+/* minimum unit size, also is the maximum supported allocation size */
+#define PCPU_MIN_UNIT_SIZE		(16UL << PAGE_SHIFT)
+
+/*
+ * PERCPU_DYNAMIC_RESERVE indicates the amount of free area to piggy
+ * back on the first chunk if arch is manually allocating and mapping
+ * it for faster access (as a part of large page mapping for example).
+ * Note that dynamic percpu allocator covers both static and dynamic
+ * areas, so these values are bigger than PERCPU_MODULE_RESERVE.
+ *
+ * On typical configuration with modules, the following values leave
+ * about 8k of free space on the first chunk after boot on both x86_32
+ * and 64 when module support is enabled.  When module support is
+ * disabled, it's much tighter.
+ */
+#ifndef PERCPU_DYNAMIC_RESERVE
+#  if BITS_PER_LONG > 32
+#    ifdef CONFIG_MODULES
+#      define PERCPU_DYNAMIC_RESERVE	(6 << PAGE_SHIFT)
+#    else
+#      define PERCPU_DYNAMIC_RESERVE	(4 << PAGE_SHIFT)
+#    endif
+#  else
+#    ifdef CONFIG_MODULES
+#      define PERCPU_DYNAMIC_RESERVE	(4 << PAGE_SHIFT)
+#    else
+#      define PERCPU_DYNAMIC_RESERVE	(2 << PAGE_SHIFT)
+#    endif
+#  endif
+#endif	/* PERCPU_DYNAMIC_RESERVE */
+
 extern void *pcpu_base_addr;
 
+typedef struct page * (*pcpu_get_page_fn_t)(unsigned int cpu, int pageno);
 typedef void (*pcpu_populate_pte_fn_t)(unsigned long addr);
 
-extern size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
-				       struct page **pages, size_t cpu_size);
+extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
+					size_t static_size, size_t unit_size,
+					size_t free_size, void *base_addr,
+					pcpu_populate_pte_fn_t populate_pte_fn);
+
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
diff --git a/mm/percpu.c b/mm/percpu.c
index d9e6e5d..9ac0198 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -48,8 +48,8 @@
  * - define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr() to translate
  *   regular address to percpu pointer and back
  *
- * - use pcpu_setup_static() during percpu area initialization to
- *   setup kernel static percpu area
+ * - use pcpu_setup_first_chunk() during percpu area initialization to
+ *   setup the first chunk containing the kernel static percpu area
  */
 
 #include <linux/bitmap.h>
@@ -67,7 +67,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-#define PCPU_MIN_UNIT_PAGES		16	/* max alloc size in pages */
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
 
@@ -80,6 +79,7 @@ struct pcpu_chunk {
 	int			map_used;	/* # of map entries used */
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
+	bool			immutable;	/* no [de]population allowed */
 	struct page		*page[];	/* #cpus * UNIT_PAGES */
 };
 
@@ -521,6 +521,9 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 	unsigned int last = num_possible_cpus() - 1;
 	unsigned int cpu;
 
+	/* unmap must not be done on immutable chunk */
+	WARN_ON(chunk->immutable);
+
 	/*
 	 * Each flushing trial can be very expensive, issue flush on
 	 * the whole region at once rather than doing it for each cpu.
@@ -602,6 +605,9 @@ static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
 	unsigned int cpu;
 	int err;
 
+	/* map must not be done on immutable chunk */
+	WARN_ON(chunk->immutable);
+
 	for_each_possible_cpu(cpu) {
 		err = map_kernel_range_noflush(
 				pcpu_chunk_addr(chunk, cpu, page_start),
@@ -727,8 +733,7 @@ void *__alloc_percpu(size_t size, size_t align)
 	struct pcpu_chunk *chunk;
 	int slot, off;
 
-	if (unlikely(!size || size > PCPU_MIN_UNIT_PAGES * PAGE_SIZE ||
-		     align > PAGE_SIZE)) {
+	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
 		     "percpu allocation\n", size, align);
 		return NULL;
@@ -776,6 +781,7 @@ EXPORT_SYMBOL_GPL(__alloc_percpu);
 
 static void pcpu_kill_chunk(struct pcpu_chunk *chunk)
 {
+	WARN_ON(chunk->immutable);
 	pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size, false);
 	list_del(&chunk->list);
 	rb_erase(&chunk->rb_node, &pcpu_addr_root);
@@ -821,33 +827,73 @@ void free_percpu(void *ptr)
 EXPORT_SYMBOL_GPL(free_percpu);
 
 /**
- * pcpu_setup_static - initialize kernel static percpu area
- * @populate_pte_fn: callback to allocate pagetable
- * @pages: num_possible_cpus() * PFN_UP(cpu_size) pages
- * @cpu_size: the size of static percpu area in bytes
- *
- * Initialize kernel static percpu area.  The caller should allocate
- * all the necessary pages and pass them in @pages.
- * @populate_pte_fn() is called on each page to be used for percpu
- * mapping and is responsible for making sure all the necessary page
- * tables for the page is allocated.
+ * pcpu_setup_first_chunk - initialize the first percpu chunk
+ * @get_page_fn: callback to fetch page pointer
+ * @static_size: the size of static percpu area in bytes
+ * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, 0 for auto
+ * @free_size: free size in bytes, 0 for auto
+ * @base_addr: mapped address, NULL for auto
+ * @populate_pte_fn: callback to allocate pagetable, NULL if unnecessary
+ *
+ * Initialize the first percpu chunk which contains the kernel static
+ * perpcu area.  This function is to be called from arch percpu area
+ * setup path.  The first two parameters are mandatory.  The rest are
+ * optional.
+ *
+ * @get_page_fn() should return pointer to percpu page given cpu
+ * number and page number.  It should at least return enough pages to
+ * cover the static area.  The returned pages for static area should
+ * have been initialized with valid data.  If @unit_size is specified,
+ * it can also return pages after the static area.  NULL return
+ * indicates end of pages for the cpu.  Note that @get_page_fn() must
+ * return the same number of pages for all cpus.
+ *
+ * @unit_size, if non-zero, determines unit size and must be aligned
+ * to PAGE_SIZE and equal to or larger than @static_size + @free_size.
+ *
+ * @free_size determines the number of free bytes after the static
+ * area in the first chunk.  If zero, whatever left is available.
+ * Specifying non-zero value make percpu leave the area after
+ * @static_size + @free_size alone.
+ *
+ * Non-null @base_addr means that the caller already allocated virtual
+ * region for the first chunk and mapped it.  percpu must not mess
+ * with the chunk.  Note that @base_addr with 0 @unit_size or non-NULL
+ * @populate_pte_fn doesn't make any sense.
+ *
+ * @populate_pte_fn is used to populate the pagetable.  NULL means the
+ * caller already populated the pagetable.
  *
  * RETURNS:
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access.
  */
-size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
-				struct page **pages, size_t cpu_size)
+size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
+				     size_t static_size, size_t unit_size,
+				     size_t free_size, void *base_addr,
+				     pcpu_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct static_vm;
 	struct pcpu_chunk *static_chunk;
-	int nr_cpu_pages = DIV_ROUND_UP(cpu_size, PAGE_SIZE);
 	unsigned int cpu;
+	int nr_pages;
 	int err, i;
 
-	pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_PAGES, PFN_UP(cpu_size));
+	/* santiy checks */
+	BUG_ON(!static_size);
+	BUG_ON(!unit_size && free_size);
+	BUG_ON(unit_size && unit_size < static_size + free_size);
+	BUG_ON(unit_size & ~PAGE_MASK);
+	BUG_ON(base_addr && !unit_size);
+	BUG_ON(base_addr && populate_pte_fn);
 
-	pcpu_static_size = cpu_size;
+	if (unit_size)
+		pcpu_unit_pages = unit_size >> PAGE_SHIFT;
+	else
+		pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_SIZE >> PAGE_SHIFT,
+					PFN_UP(static_size));
+
+	pcpu_static_size = static_size;
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
@@ -862,29 +908,66 @@ size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
 	for (i = 0; i < pcpu_nr_slots; i++)
 		INIT_LIST_HEAD(&pcpu_slot[i]);
 
-	/* init and register vm area */
-	static_vm.flags = VM_ALLOC;
-	static_vm.size = pcpu_chunk_size;
-	vm_area_register_early(&static_vm, PAGE_SIZE);
-
 	/* init static_chunk */
 	static_chunk = alloc_bootmem(pcpu_chunk_struct_size);
 	INIT_LIST_HEAD(&static_chunk->list);
 	static_chunk->vm = &static_vm;
-	static_chunk->free_size = pcpu_unit_size - pcpu_static_size;
+
+	if (free_size)
+		static_chunk->free_size = free_size;
+	else
+		static_chunk->free_size = pcpu_unit_size - pcpu_static_size;
+
 	static_chunk->contig_hint = static_chunk->free_size;
 
-	/* assign pages and map them */
+	/* allocate vm address */
+	static_vm.flags = VM_ALLOC;
+	static_vm.size = pcpu_chunk_size;
+
+	if (!base_addr)
+		vm_area_register_early(&static_vm, PAGE_SIZE);
+	else {
+		/*
+		 * Pages already mapped.  No need to remap into
+		 * vmalloc area.  In this case the static chunk can't
+		 * be mapped or unmapped by percpu and is marked
+		 * immutable.
+		 */
+		static_vm.addr = base_addr;
+		static_chunk->immutable = true;
+	}
+
+	/* assign pages */
+	nr_pages = -1;
 	for_each_possible_cpu(cpu) {
-		for (i = 0; i < nr_cpu_pages; i++) {
-			*pcpu_chunk_pagep(static_chunk, cpu, i) = *pages++;
-			populate_pte_fn(pcpu_chunk_addr(static_chunk, cpu, i));
+		for (i = 0; i < pcpu_unit_pages; i++) {
+			struct page *page = get_page_fn(cpu, i);
+
+			if (!page)
+				break;
+			*pcpu_chunk_pagep(static_chunk, cpu, i) = page;
 		}
+
+		BUG_ON(i < PFN_UP(pcpu_static_size));
+
+		if (nr_pages < 0)
+			nr_pages = i;
+		else
+			BUG_ON(nr_pages != i);
 	}
 
-	err = pcpu_map(static_chunk, 0, nr_cpu_pages);
-	if (err)
-		panic("failed to setup static percpu area, err=%d\n", err);
+	/* map them */
+	if (populate_pte_fn) {
+		for_each_possible_cpu(cpu)
+			for (i = 0; i < nr_pages; i++)
+				populate_pte_fn(pcpu_chunk_addr(static_chunk,
+								cpu, i));
+
+		err = pcpu_map(static_chunk, 0, nr_pages);
+		if (err)
+			panic("failed to setup static percpu area, err=%d\n",
+			      err);
+	}
 
 	/* link static_chunk in */
 	pcpu_chunk_relocate(static_chunk, -1);
-- 
1.6.0.2

