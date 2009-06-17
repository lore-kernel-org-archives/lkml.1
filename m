Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbZFQE1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbZFQE1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758965AbZFQE0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:26:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763391AbZFQE0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:26:40 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       JBeulich@novell.com, cl@linux-foundation.org, davem@davemloft.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] percpu: drop pcpu_chunk->page[]
Date: Wed, 17 Jun 2009 13:26:07 +0900
Message-Id: <1245212769-29134-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245212769-29134-1-git-send-email-tj@kernel.org>
References: <1245212769-29134-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:26:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu core doesn't need to tack all the allocated pages.  It needs to
know whether certain pages are populated and a way to reverse map
address to page when freeing.  This patch drops pcpu_chunk->page[] and
use populated bitmap and vmalloc_to_page() lookup instead.  Using
vmalloc_to_page() exclusively is also possible but complicates first
chunk handling, inflates cache footprint and prevents non-standard
memory allocation for percpu memory.

pcpu_chunk->page[] was used to track each page's allocation and
allowed asymmetric population which happens during failure path;
however, with single bitmap for all units, this is no longer possible.
Bite the bullet and rewrite (de)populate functions so that things are
done in clearly separated steps such that asymmetric population
doesn't happen.  This makes the (de)population process much more
modular and will also ease implementing non-standard memory usage in
the future (e.g. large pages).

This makes @get_page_fn parameter to pcpu_setup_first_chunk()
unnecessary.  The parameter is dropped and all first chunk helpers are
updated accordingly.  Please note that despite the volume most changes
to first chunk helpers are symbol renames for variables which don't
need to be referenced outside of the helper anymore.

This change reduces memory usage and cache footprint of pcpu_chunk.
Now only #unit_pages bits are necessary per chunk.

[ Impact: reduced memory usage and cache footprint for bookkeeping ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/percpu.h |    3 +-
 mm/percpu.c            |  604 ++++++++++++++++++++++++++++++------------------
 2 files changed, 385 insertions(+), 222 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ec64357..63c8b7a 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -58,13 +58,12 @@
 
 extern void *pcpu_base_addr;
 
-typedef struct page * (*pcpu_get_page_fn_t)(unsigned int cpu, int pageno);
 typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size);
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
-extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
+extern size_t __init pcpu_setup_first_chunk(
 				size_t static_size, size_t reserved_size,
 				ssize_t dyn_size, size_t unit_size,
 				void *base_addr);
diff --git a/mm/percpu.c b/mm/percpu.c
index 770db98..5ee712e 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -94,8 +94,7 @@ struct pcpu_chunk {
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
 	bool			immutable;	/* no [de]population allowed */
-	struct page		**page;		/* points to page array */
-	struct page		*page_ar[];	/* #cpus * UNIT_PAGES */
+	unsigned long		populated[];	/* populated bitmap */
 };
 
 static int pcpu_unit_pages __read_mostly;
@@ -129,9 +128,9 @@ static int pcpu_reserved_chunk_limit;
  * Synchronization rules.
  *
  * There are two locks - pcpu_alloc_mutex and pcpu_lock.  The former
- * protects allocation/reclaim paths, chunks and chunk->page arrays.
- * The latter is a spinlock and protects the index data structures -
- * chunk slots, chunks and area maps in chunks.
+ * protects allocation/reclaim paths, chunks, populated bitmap and
+ * vmalloc mapping.  The latter is a spinlock and protects the index
+ * data structures - chunk slots, chunks and area maps in chunks.
  *
  * During allocation, pcpu_alloc_mutex is kept locked all the time and
  * pcpu_lock is grabbed and released as necessary.  All actual memory
@@ -188,16 +187,13 @@ static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 		(pcpu_page_idx(cpu, page_idx) << PAGE_SHIFT);
 }
 
-static struct page **pcpu_chunk_pagep(struct pcpu_chunk *chunk,
-				      unsigned int cpu, int page_idx)
+static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
+				    unsigned int cpu, int page_idx)
 {
-	return &chunk->page[pcpu_page_idx(cpu, page_idx)];
-}
+	/* must not be used on pre-mapped chunk */
+	WARN_ON(chunk->immutable);
 
-static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
-				     int page_idx)
-{
-	return *pcpu_chunk_pagep(chunk, 0, page_idx) != NULL;
+	return vmalloc_to_page((void *)pcpu_chunk_addr(chunk, cpu, page_idx));
 }
 
 /* set the pointer to a chunk in a page struct */
@@ -212,6 +208,34 @@ static struct pcpu_chunk *pcpu_get_page_chunk(struct page *page)
 	return (struct pcpu_chunk *)page->index;
 }
 
+static void pcpu_next_unpop(struct pcpu_chunk *chunk, int *rs, int *re, int end)
+{
+	*rs = find_next_zero_bit(chunk->populated, end, *rs);
+	*re = find_next_bit(chunk->populated, end, *rs + 1);
+}
+
+static void pcpu_next_pop(struct pcpu_chunk *chunk, int *rs, int *re, int end)
+{
+	*rs = find_next_bit(chunk->populated, end, *rs);
+	*re = find_next_zero_bit(chunk->populated, end, *rs + 1);
+}
+
+/*
+ * (Un)populated page region iterators.  Iterate over (un)populated
+ * page regions betwen @start and @end in @chunk.  @rs and @re should
+ * be integer variables and will be set to start and end page index of
+ * the current region.
+ */
+#define pcpu_for_each_unpop_region(chunk, rs, re, start, end)		    \
+	for ((rs) = (start), pcpu_next_unpop((chunk), &(rs), &(re), (end)); \
+	     (rs) < (re);						    \
+	     (rs) = (re) + 1, pcpu_next_unpop((chunk), &(rs), &(re), (end)))
+
+#define pcpu_for_each_pop_region(chunk, rs, re, start, end)		    \
+	for ((rs) = (start), pcpu_next_pop((chunk), &(rs), &(re), (end));   \
+	     (rs) < (re);						    \
+	     (rs) = (re) + 1, pcpu_next_pop((chunk), &(rs), &(re), (end)))
+
 /**
  * pcpu_mem_alloc - allocate memory
  * @size: bytes to allocate
@@ -545,42 +569,197 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 }
 
 /**
- * pcpu_unmap - unmap pages out of a pcpu_chunk
+ * pcpu_get_pages_and_bitmap - get temp pages array and bitmap
+ * @chunk: chunk of interest
+ * @bitmapp: output parameter for bitmap
+ * @may_alloc: may allocate the array
+ *
+ * Returns pointer to array of pointers to struct page and bitmap,
+ * both of which can be indexed with pcpu_page_idx().  The returned
+ * array is cleared to zero and *@bitmapp is copied from
+ * @chunk->populated.  Note that there is only one array and bitmap
+ * and access exclusion is the caller's responsibility.
+ *
+ * CONTEXT:
+ * pcpu_alloc_mutex and does GFP_KERNEL allocation if @may_alloc.
+ * Otherwise, don't care.
+ *
+ * RETURNS:
+ * Pointer to temp pages array on success, NULL on failure.
+ */
+static struct page **pcpu_get_pages_and_bitmap(struct pcpu_chunk *chunk,
+					       unsigned long **bitmapp,
+					       bool may_alloc)
+{
+	static struct page **pages;
+	static unsigned long *bitmap;
+	size_t pages_size = num_possible_cpus() * pcpu_unit_pages *
+			    sizeof(pages[0]);
+	size_t bitmap_size = BITS_TO_LONGS(pcpu_unit_pages) *
+			     sizeof(unsigned long);
+
+	if (!pages || !bitmap) {
+		if (may_alloc && !pages)
+			pages = pcpu_mem_alloc(pages_size);
+		if (may_alloc && !bitmap)
+			bitmap = pcpu_mem_alloc(bitmap_size);
+		if (!pages || !bitmap)
+			return NULL;
+	}
+
+	memset(pages, 0, pages_size);
+	bitmap_copy(bitmap, chunk->populated, pcpu_unit_pages);
+
+	*bitmapp = bitmap;
+	return pages;
+}
+
+/**
+ * pcpu_free_pages - free pages which were allocated for @chunk
+ * @chunk: chunk pages were allocated for
+ * @pages: array of pages to be freed, indexed by pcpu_page_idx()
+ * @populated: populated bitmap
+ * @page_start: page index of the first page to be freed
+ * @page_end: page index of the last page to be freed + 1
+ *
+ * Free pages [@page_start and @page_end) in @pages for all units.
+ * The pages were allocated for @chunk.
+ */
+static void pcpu_free_pages(struct pcpu_chunk *chunk,
+			    struct page **pages, unsigned long *populated,
+			    int page_start, int page_end)
+{
+	unsigned int cpu;
+	int i;
+
+	for_each_possible_cpu(cpu) {
+		for (i = page_start; i < page_end; i++) {
+			struct page *page = pages[pcpu_page_idx(cpu, i)];
+
+			if (page)
+				__free_page(page);
+		}
+	}
+}
+
+/**
+ * pcpu_alloc_pages - allocates pages for @chunk
+ * @chunk: target chunk
+ * @pages: array to put the allocated pages into, indexed by pcpu_page_idx()
+ * @populated: populated bitmap
+ * @page_start: page index of the first page to be allocated
+ * @page_end: page index of the last page to be allocated + 1
+ *
+ * Allocate pages [@page_start,@page_end) into @pages for all units.
+ * The allocation is for @chunk.  Percpu core doesn't care about the
+ * content of @pages and will pass it verbatim to pcpu_map_pages().
+ */
+static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
+			    struct page **pages, unsigned long *populated,
+			    int page_start, int page_end)
+{
+	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
+	unsigned int cpu;
+	int i;
+
+	for_each_possible_cpu(cpu) {
+		for (i = page_start; i < page_end; i++) {
+			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
+
+			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+			if (!*pagep) {
+				pcpu_free_pages(chunk, pages, populated,
+						page_start, page_end);
+				return -ENOMEM;
+			}
+		}
+	}
+	return 0;
+}
+
+/**
+ * pcpu_pre_unmap_flush - flush cache prior to unmapping
+ * @chunk: chunk the regions to be flushed belongs to
+ * @page_start: page index of the first page to be flushed
+ * @page_end: page index of the last page to be flushed + 1
+ *
+ * Pages in [@page_start,@page_end) of @chunk are about to be
+ * unmapped.  Flush cache.  As each flushing trial can be very
+ * expensive, issue flush on the whole region at once rather than
+ * doing it for each cpu.  This could be an overkill but is more
+ * scalable.
+ */
+static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
+				 int page_start, int page_end)
+{
+	unsigned int last = num_possible_cpus() - 1;
+
+	flush_cache_vunmap(pcpu_chunk_addr(chunk, 0, page_start),
+			   pcpu_chunk_addr(chunk, last, page_end));
+}
+
+static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
+{
+	unmap_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT);
+}
+
+/**
+ * pcpu_unmap_pages - unmap pages out of a pcpu_chunk
  * @chunk: chunk of interest
+ * @pages: pages array which can be used to pass information to free
+ * @populated: populated bitmap
  * @page_start: page index of the first page to unmap
  * @page_end: page index of the last page to unmap + 1
- * @flush_tlb: whether to flush tlb or not
  *
  * For each cpu, unmap pages [@page_start,@page_end) out of @chunk.
- * If @flush is true, vcache is flushed before unmapping and tlb
- * after.
+ * Corresponding elements in @pages were cleared by the caller and can
+ * be used to carry information to pcpu_free_pages() which will be
+ * called after all unmaps are finished.  The caller should call
+ * proper pre/post flush functions.
  */
-static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
-		       bool flush_tlb)
+static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
+			     struct page **pages, unsigned long *populated,
+			     int page_start, int page_end)
 {
-	unsigned int last = num_possible_cpus() - 1;
 	unsigned int cpu;
+	int i;
 
-	/* unmap must not be done on immutable chunk */
-	WARN_ON(chunk->immutable);
+	for_each_possible_cpu(cpu) {
+		for (i = page_start; i < page_end; i++) {
+			struct page *page;
 
-	/*
-	 * Each flushing trial can be very expensive, issue flush on
-	 * the whole region at once rather than doing it for each cpu.
-	 * This could be an overkill but is more scalable.
-	 */
-	flush_cache_vunmap(pcpu_chunk_addr(chunk, 0, page_start),
-			   pcpu_chunk_addr(chunk, last, page_end));
+			page = pcpu_chunk_page(chunk, cpu, i);
+			WARN_ON(!page);
+			pages[pcpu_page_idx(cpu, i)] = page;
+		}
+		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, cpu, page_start),
+				   page_end - page_start);
+	}
 
-	for_each_possible_cpu(cpu)
-		unmap_kernel_range_noflush(
-				pcpu_chunk_addr(chunk, cpu, page_start),
-				(page_end - page_start) << PAGE_SHIFT);
-
-	/* ditto as flush_cache_vunmap() */
-	if (flush_tlb)
-		flush_tlb_kernel_range(pcpu_chunk_addr(chunk, 0, page_start),
-				       pcpu_chunk_addr(chunk, last, page_end));
+	for (i = page_start; i < page_end; i++)
+		__clear_bit(i, populated);
+}
+
+/**
+ * pcpu_post_unmap_tlb_flush - flush TLB after unmapping
+ * @chunk: pcpu_chunk the regions to be flushed belong to
+ * @page_start: page index of the first page to be flushed
+ * @page_end: page index of the last page to be flushed + 1
+ *
+ * Pages [@page_start,@page_end) of @chunk have been unmapped.  Flush
+ * TLB for the regions.  This can be skipped if the area is to be
+ * returned to vmalloc as vmalloc will handle TLB flushing lazily.
+ *
+ * As with pcpu_pre_unmap_flush(), TLB flushing also is done at once
+ * for the whole region.
+ */
+static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
+				      int page_start, int page_end)
+{
+	unsigned int last = num_possible_cpus() - 1;
+
+	flush_tlb_kernel_range(pcpu_chunk_addr(chunk, 0, page_start),
+			       pcpu_chunk_addr(chunk, last, page_end));
 }
 
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
@@ -591,35 +770,76 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
 }
 
 /**
- * pcpu_map - map pages into a pcpu_chunk
+ * pcpu_map_pages - map pages into a pcpu_chunk
  * @chunk: chunk of interest
+ * @pages: pages array containing pages to be mapped
+ * @populated: populated bitmap
  * @page_start: page index of the first page to map
  * @page_end: page index of the last page to map + 1
  *
- * For each cpu, map pages [@page_start,@page_end) into @chunk.
- * vcache is flushed afterwards.
+ * For each cpu, map pages [@page_start,@page_end) into @chunk.  The
+ * caller is responsible for calling pcpu_post_map_flush() after all
+ * mappings are complete.
+ *
+ * This function is responsible for setting corresponding bits in
+ * @chunk->populated bitmap and whatever is necessary for reverse
+ * lookup (addr -> chunk).
  */
-static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
+static int pcpu_map_pages(struct pcpu_chunk *chunk,
+			  struct page **pages, unsigned long *populated,
+			  int page_start, int page_end)
 {
-	unsigned int last = num_possible_cpus() - 1;
-	unsigned int cpu;
-	int err;
-
-	/* map must not be done on immutable chunk */
-	WARN_ON(chunk->immutable);
+	unsigned int cpu, tcpu;
+	int i, err;
 
 	for_each_possible_cpu(cpu) {
 		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
-				       pcpu_chunk_pagep(chunk, cpu, page_start),
+				       &pages[pcpu_page_idx(cpu, page_start)],
 				       page_end - page_start);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
+	/* mapping successful, link chunk and mark populated */
+	for (i = page_start; i < page_end; i++) {
+		for_each_possible_cpu(cpu)
+			pcpu_set_page_chunk(pages[pcpu_page_idx(cpu, i)],
+					    chunk);
+		__set_bit(i, populated);
+	}
+
+	return 0;
+
+err:
+	for_each_possible_cpu(tcpu) {
+		if (tcpu == cpu)
+			break;
+		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
+				   page_end - page_start);
+	}
+	return err;
+}
+
+/**
+ * pcpu_post_map_flush - flush cache after mapping
+ * @chunk: pcpu_chunk the regions to be flushed belong to
+ * @page_start: page index of the first page to be flushed
+ * @page_end: page index of the last page to be flushed + 1
+ *
+ * Pages [@page_start,@page_end) of @chunk have been mapped.  Flush
+ * cache.
+ *
+ * As with pcpu_pre_unmap_flush(), TLB flushing also is done at once
+ * for the whole region.
+ */
+static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
+				int page_start, int page_end)
+{
+	unsigned int last = num_possible_cpus() - 1;
+
 	/* flush at once, please read comments in pcpu_unmap() */
 	flush_cache_vmap(pcpu_chunk_addr(chunk, 0, page_start),
 			 pcpu_chunk_addr(chunk, last, page_end));
-	return 0;
 }
 
 /**
@@ -636,39 +856,45 @@ static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
  * CONTEXT:
  * pcpu_alloc_mutex.
  */
-static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size,
-				  bool flush)
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 {
 	int page_start = PFN_DOWN(off);
 	int page_end = PFN_UP(off + size);
-	int unmap_start = -1;
-	int uninitialized_var(unmap_end);
-	unsigned int cpu;
-	int i;
+	struct page **pages;
+	unsigned long *populated;
+	int rs, re;
+
+	/* quick path, check whether it's empty already */
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
+		if (rs == page_start && re == page_end)
+			return;
+		break;
+	}
 
-	for (i = page_start; i < page_end; i++) {
-		for_each_possible_cpu(cpu) {
-			struct page **pagep = pcpu_chunk_pagep(chunk, cpu, i);
+	/* immutable chunks can't be depopulated */
+	WARN_ON(chunk->immutable);
 
-			if (!*pagep)
-				continue;
+	/*
+	 * If control reaches here, there must have been at least one
+	 * successful population attempt so the temp pages array must
+	 * be available now.
+	 */
+	pages = pcpu_get_pages_and_bitmap(chunk, &populated, false);
+	BUG_ON(!pages);
 
-			__free_page(*pagep);
+	/* unmap and free */
+	pcpu_pre_unmap_flush(chunk, page_start, page_end);
 
-			/*
-			 * If it's partial depopulation, it might get
-			 * populated or depopulated again.  Mark the
-			 * page gone.
-			 */
-			*pagep = NULL;
+	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
+		pcpu_unmap_pages(chunk, pages, populated, rs, re);
 
-			unmap_start = unmap_start < 0 ? i : unmap_start;
-			unmap_end = i + 1;
-		}
-	}
+	/* no need to flush tlb, vmalloc will handle it lazily */
+
+	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end)
+		pcpu_free_pages(chunk, pages, populated, rs, re);
 
-	if (unmap_start >= 0)
-		pcpu_unmap(chunk, unmap_start, unmap_end, flush);
+	/* commit new bitmap */
+	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
 }
 
 /**
@@ -685,50 +911,61 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size,
  */
 static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 {
-	const gfp_t alloc_mask = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
 	int page_start = PFN_DOWN(off);
 	int page_end = PFN_UP(off + size);
-	int map_start = -1;
-	int uninitialized_var(map_end);
+	int free_end = page_start, unmap_end = page_start;
+	struct page **pages;
+	unsigned long *populated;
 	unsigned int cpu;
-	int i;
+	int rs, re, rc;
 
-	for (i = page_start; i < page_end; i++) {
-		if (pcpu_chunk_page_occupied(chunk, i)) {
-			if (map_start >= 0) {
-				if (pcpu_map(chunk, map_start, map_end))
-					goto err;
-				map_start = -1;
-			}
-			continue;
-		}
+	/* quick path, check whether all pages are already there */
+	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end) {
+		if (rs == page_start && re == page_end)
+			goto clear;
+		break;
+	}
 
-		map_start = map_start < 0 ? i : map_start;
-		map_end = i + 1;
+	/* need to allocate and map pages, this chunk can't be immutable */
+	WARN_ON(chunk->immutable);
 
-		for_each_possible_cpu(cpu) {
-			struct page **pagep = pcpu_chunk_pagep(chunk, cpu, i);
+	pages = pcpu_get_pages_and_bitmap(chunk, &populated, true);
+	if (!pages)
+		return -ENOMEM;
 
-			*pagep = alloc_pages_node(cpu_to_node(cpu),
-						  alloc_mask, 0);
-			if (!*pagep)
-				goto err;
-			pcpu_set_page_chunk(*pagep, chunk);
-		}
+	/* alloc and map */
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
+		rc = pcpu_alloc_pages(chunk, pages, populated, rs, re);
+		if (rc)
+			goto err_free;
+		free_end = re;
 	}
 
-	if (map_start >= 0 && pcpu_map(chunk, map_start, map_end))
-		goto err;
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
+		rc = pcpu_map_pages(chunk, pages, populated, rs, re);
+		if (rc)
+			goto err_unmap;
+		unmap_end = re;
+	}
+	pcpu_post_map_flush(chunk, page_start, page_end);
 
+	/* commit new bitmap */
+	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
+clear:
 	for_each_possible_cpu(cpu)
 		memset(chunk->vm->addr + cpu * pcpu_unit_size + off, 0,
 		       size);
-
 	return 0;
-err:
-	/* likely under heavy memory pressure, give memory back */
-	pcpu_depopulate_chunk(chunk, off, size, true);
-	return -ENOMEM;
+
+err_unmap:
+	pcpu_pre_unmap_flush(chunk, page_start, unmap_end);
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, unmap_end)
+		pcpu_unmap_pages(chunk, pages, populated, rs, re);
+	pcpu_post_unmap_tlb_flush(chunk, page_start, unmap_end);
+err_free:
+	pcpu_for_each_unpop_region(chunk, rs, re, page_start, free_end)
+		pcpu_free_pages(chunk, pages, populated, rs, re);
+	return rc;
 }
 
 static void free_pcpu_chunk(struct pcpu_chunk *chunk)
@@ -752,7 +989,6 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	chunk->map = pcpu_mem_alloc(PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
-	chunk->page = chunk->page_ar;
 
 	chunk->vm = get_vm_area(pcpu_chunk_size, GFP_KERNEL);
 	if (!chunk->vm) {
@@ -933,7 +1169,7 @@ static void pcpu_reclaim(struct work_struct *work)
 	mutex_unlock(&pcpu_alloc_mutex);
 
 	list_for_each_entry_safe(chunk, next, &todo, list) {
-		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size, false);
+		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
 		free_pcpu_chunk(chunk);
 	}
 }
@@ -981,7 +1217,6 @@ EXPORT_SYMBOL_GPL(free_percpu);
 
 /**
  * pcpu_setup_first_chunk - initialize the first percpu chunk
- * @get_page_fn: callback to fetch page pointer
  * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes, 0 for none
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
@@ -992,14 +1227,6 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * perpcu area.  This function is to be called from arch percpu area
  * setup path.
  *
- * @get_page_fn() should return pointer to percpu page given cpu
- * number and page number.  It should at least return enough pages to
- * cover the static area.  The returned pages for static area should
- * have been initialized with valid data.  It can also return pages
- * after the static area.  NULL return indicates end of pages for the
- * cpu.  Note that @get_page_fn() must return the same number of pages
- * for all cpus.
- *
  * @reserved_size, if non-zero, specifies the amount of bytes to
  * reserve after the static area in the first chunk.  This reserves
  * the first chunk such that it's available only through reserved
@@ -1031,8 +1258,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access.
  */
-size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
-				     size_t static_size, size_t reserved_size,
+size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 				     ssize_t dyn_size, size_t unit_size,
 				     void *base_addr)
 {
@@ -1041,8 +1267,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	size_t size_sum = static_size + reserved_size +
 			  (dyn_size >= 0 ? dyn_size : 0);
 	struct pcpu_chunk *schunk, *dchunk = NULL;
-	unsigned int cpu;
-	int i, nr_pages;
+	int i;
 
 	/* santiy checks */
 	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC ||
@@ -1056,8 +1281,8 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	pcpu_unit_pages = unit_size >> PAGE_SHIFT;
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
-	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
-		+ num_possible_cpus() * pcpu_unit_pages * sizeof(struct page *);
+	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
+		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
 
 	if (dyn_size < 0)
 		dyn_size = pcpu_unit_size - static_size - reserved_size;
@@ -1087,8 +1312,8 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	schunk->vm = &first_vm;
 	schunk->map = smap;
 	schunk->map_alloc = ARRAY_SIZE(smap);
-	schunk->page = schunk->page_ar;
 	schunk->immutable = true;
+	bitmap_fill(schunk->populated, pcpu_unit_pages);
 
 	if (reserved_size) {
 		schunk->free_size = reserved_size;
@@ -1106,38 +1331,19 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 
 	/* init dynamic chunk if necessary */
 	if (dyn_size) {
-		dchunk = alloc_bootmem(sizeof(struct pcpu_chunk));
+		dchunk = alloc_bootmem(pcpu_chunk_struct_size);
 		INIT_LIST_HEAD(&dchunk->list);
 		dchunk->vm = &first_vm;
 		dchunk->map = dmap;
 		dchunk->map_alloc = ARRAY_SIZE(dmap);
-		dchunk->page = schunk->page_ar;	/* share page map with schunk */
 		dchunk->immutable = true;
+		bitmap_fill(dchunk->populated, pcpu_unit_pages);
 
 		dchunk->contig_hint = dchunk->free_size = dyn_size;
 		dchunk->map[dchunk->map_used++] = -pcpu_reserved_chunk_limit;
 		dchunk->map[dchunk->map_used++] = dchunk->free_size;
 	}
 
-	/* assign pages */
-	nr_pages = -1;
-	for_each_possible_cpu(cpu) {
-		for (i = 0; i < pcpu_unit_pages; i++) {
-			struct page *page = get_page_fn(cpu, i);
-
-			if (!page)
-				break;
-			*pcpu_chunk_pagep(schunk, cpu, i) = page;
-		}
-
-		BUG_ON(i < PFN_UP(static_size));
-
-		if (nr_pages < 0)
-			nr_pages = i;
-		else
-			BUG_ON(nr_pages != i);
-	}
-
 	/* link the first chunk in */
 	pcpu_first_chunk = dchunk ?: schunk;
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
@@ -1160,23 +1366,6 @@ static size_t pcpu_calc_fc_sizes(size_t static_size, size_t reserved_size,
 	return size_sum;
 }
 
-/*
- * Embedding first chunk setup helper.
- */
-static void *pcpue_ptr __initdata;
-static size_t pcpue_size __initdata;
-static size_t pcpue_unit_size __initdata;
-
-static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
-{
-	size_t off = (size_t)pageno << PAGE_SHIFT;
-
-	if (off >= pcpue_size)
-		return NULL;
-
-	return virt_to_page(pcpue_ptr + cpu * pcpue_unit_size + off);
-}
-
 /**
  * pcpu_embed_first_chunk - embed the first percpu chunk into bootmem
  * @static_size: the size of static percpu area in bytes
@@ -1207,18 +1396,19 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
 ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 				      ssize_t dyn_size)
 {
-	size_t chunk_size;
+	size_t size_sum, unit_size, chunk_size;
+	void *base;
 	unsigned int cpu;
 
 	/* determine parameters and allocate */
-	pcpue_size = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
+	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
 
-	pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
-	chunk_size = pcpue_unit_size * num_possible_cpus();
+	unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
+	chunk_size = unit_size * num_possible_cpus();
 
-	pcpue_ptr = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
-					    __pa(MAX_DMA_ADDRESS));
-	if (!pcpue_ptr) {
+	base = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
+				       __pa(MAX_DMA_ADDRESS));
+	if (!base) {
 		pr_warning("PERCPU: failed to allocate %zu bytes for "
 			   "embedding\n", chunk_size);
 		return -ENOMEM;
@@ -1226,33 +1416,18 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 
 	/* return the leftover and copy */
 	for_each_possible_cpu(cpu) {
-		void *ptr = pcpue_ptr + cpu * pcpue_unit_size;
+		void *ptr = base + cpu * unit_size;
 
-		free_bootmem(__pa(ptr + pcpue_size),
-			     pcpue_unit_size - pcpue_size);
+		free_bootmem(__pa(ptr + size_sum), unit_size - size_sum);
 		memcpy(ptr, __per_cpu_load, static_size);
 	}
 
 	/* we're ready, commit */
 	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
-		pcpue_size >> PAGE_SHIFT, pcpue_ptr, static_size);
+		size_sum >> PAGE_SHIFT, base, static_size);
 
-	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
-				      reserved_size, dyn_size,
-				      pcpue_unit_size, pcpue_ptr);
-}
-
-/*
- * 4k page first chunk setup helper.
- */
-static struct page **pcpu4k_pages __initdata;
-static int pcpu4k_unit_pages __initdata;
-
-static struct page * __init pcpu4k_get_page(unsigned int cpu, int pageno)
-{
-	if (pageno < pcpu4k_unit_pages)
-		return pcpu4k_pages[cpu * pcpu4k_unit_pages + pageno];
-	return NULL;
+	return pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
+				      unit_size, base);
 }
 
 /**
@@ -1279,23 +1454,25 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 				   pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct vm;
+	int unit_pages;
 	size_t pages_size;
+	struct page **pages;
 	unsigned int cpu;
 	int i, j;
 	ssize_t ret;
 
-	pcpu4k_unit_pages = PFN_UP(max_t(size_t, static_size + reserved_size,
-					 PCPU_MIN_UNIT_SIZE));
+	unit_pages = PFN_UP(max_t(size_t, static_size + reserved_size,
+				  PCPU_MIN_UNIT_SIZE));
 
 	/* unaligned allocations can't be freed, round up to page size */
-	pages_size = PFN_ALIGN(pcpu4k_unit_pages * num_possible_cpus() *
-			       sizeof(pcpu4k_pages[0]));
-	pcpu4k_pages = alloc_bootmem(pages_size);
+	pages_size = PFN_ALIGN(unit_pages * num_possible_cpus() *
+			       sizeof(pages[0]));
+	pages = alloc_bootmem(pages_size);
 
 	/* allocate pages */
 	j = 0;
 	for_each_possible_cpu(cpu)
-		for (i = 0; i < pcpu4k_unit_pages; i++) {
+		for (i = 0; i < unit_pages; i++) {
 			void *ptr;
 
 			ptr = alloc_fn(cpu, PAGE_SIZE);
@@ -1304,25 +1481,24 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 					   "4k page for cpu%u\n", cpu);
 				goto enomem;
 			}
-			pcpu4k_pages[j++] = virt_to_page(ptr);
+			pages[j++] = virt_to_page(ptr);
 		}
 
 	/* allocate vm area, map the pages and copy static data */
 	vm.flags = VM_ALLOC;
-	vm.size = num_possible_cpus() * pcpu4k_unit_pages << PAGE_SHIFT;
+	vm.size = num_possible_cpus() * unit_pages << PAGE_SHIFT;
 	vm_area_register_early(&vm, PAGE_SIZE);
 
 	for_each_possible_cpu(cpu) {
 		unsigned long unit_addr = (unsigned long)vm.addr +
-			(cpu * pcpu4k_unit_pages << PAGE_SHIFT);
+			(cpu * unit_pages << PAGE_SHIFT);
 
-		for (i = 0; i < pcpu4k_unit_pages; i++)
+		for (i = 0; i < unit_pages; i++)
 			populate_pte_fn(unit_addr + (i << PAGE_SHIFT));
 
 		/* pte already populated, the following shouldn't fail */
-		ret = __pcpu_map_pages(unit_addr,
-				       &pcpu4k_pages[cpu * pcpu4k_unit_pages],
-				       pcpu4k_unit_pages);
+		ret = __pcpu_map_pages(unit_addr, &pages[cpu * unit_pages],
+				       unit_pages);
 		if (ret < 0)
 			panic("failed to map percpu area, err=%zd\n", ret);
 
@@ -1340,19 +1516,18 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 
 	/* we're ready, commit */
 	pr_info("PERCPU: %d 4k pages per cpu, static data %zu bytes\n",
-		pcpu4k_unit_pages, static_size);
+		unit_pages, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size,
-				     reserved_size, -1,
-				     pcpu4k_unit_pages << PAGE_SHIFT, vm.addr);
+	ret = pcpu_setup_first_chunk(static_size, reserved_size, -1,
+				     unit_pages << PAGE_SHIFT, vm.addr);
 	goto out_free_ar;
 
 enomem:
 	while (--j >= 0)
-		free_fn(page_address(pcpu4k_pages[j]), PAGE_SIZE);
+		free_fn(page_address(pages[j]), PAGE_SIZE);
 	ret = -ENOMEM;
 out_free_ar:
-	free_bootmem(__pa(pcpu4k_pages), pages_size);
+	free_bootmem(__pa(pages), pages_size);
 	return ret;
 }
 
@@ -1370,16 +1545,6 @@ static size_t pcpul_unit_size;
 static struct pcpul_ent *pcpul_map;
 static struct vm_struct pcpul_vm;
 
-static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
-{
-	size_t off = (size_t)pageno << PAGE_SHIFT;
-
-	if (off >= pcpul_size)
-		return NULL;
-
-	return virt_to_page(pcpul_map[cpu].ptr + off);
-}
-
 /**
  * pcpu_lpage_first_chunk - remap the first percpu chunk using large page
  * @static_size: the size of static percpu area in bytes
@@ -1475,9 +1640,8 @@ ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
 	pr_info("PERCPU: Remapped at %p with large pages, static data "
 		"%zu bytes\n", pcpul_vm.addr, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
-				     reserved_size, dyn_size, pcpul_unit_size,
-				     pcpul_vm.addr);
+	ret = pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
+				     pcpul_unit_size, pcpul_vm.addr);
 
 	/* sort pcpul_map array for pcpu_lpage_remapped() */
 	for (i = 0; i < num_possible_cpus() - 1; i++)
-- 
1.6.0.2

