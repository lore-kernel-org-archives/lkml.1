Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZBUDna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZBUDna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZBUDnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:43:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:51963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZBUDnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:43:20 -0500
Message-ID: <499F7836.5090608@kernel.org>
Date: Sat, 21 Feb 2009 12:42:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: [PATCH tj-percpu] percpu: s/size/bytes/g in new percpu allocator
 and interface
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	<1234958676-27618-10-git-send-email-tj@kernel.org>	<499E5BF9.1060806@kernel.org> <20090220003743.d787107b.akpm@linux-foundation.org> <499F73BD.4030105@kernel.org>
In-Reply-To: <499F73BD.4030105@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Feb 2009 03:42:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do s/size/bytes/g as per Andrew Morton's suggestion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Okay, here's the patch.  I also merged it to #tj-percpu.  Having done
the conversion, I'm not too thrilled tho.  size was consistently used
to represent bytes and it's very customary especially if it's a memory
allocator and I can't really see how s/size/bytes/g makes things
better for percpu allocator.  Clear naming is good but not being able
to use size in favor of bytes seems a bit extreme to me.  After all,
it's size_t and sizeof() not bytes_t and bytesof().  That said, I have
nothing against bytes either, so...

Thanks.

 include/linux/percpu.h |    8 +-
 mm/percpu.c            |  154 ++++++++++++++++++++++++------------------------
 2 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1808099..7b61606 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -83,7 +83,7 @@ extern void *pcpu_base_addr;
 typedef void (*pcpu_populate_pte_fn_t)(unsigned long addr);
 
 extern size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
-				       struct page **pages, size_t cpu_size);
+				       struct page **pages, size_t cpu_bytes);
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
@@ -107,14 +107,14 @@ struct percpu_data {
 
 #endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
 
-extern void *__alloc_percpu(size_t size, size_t align);
+extern void *__alloc_percpu(size_t bytes, size_t align);
 extern void free_percpu(void *__pdata);
 
 #else /* CONFIG_SMP */
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void *__alloc_percpu(size_t size, size_t align)
+static inline void *__alloc_percpu(size_t bytes, size_t align)
 {
 	/*
 	 * Can't easily make larger alignment work with kmalloc.  WARN
@@ -122,7 +122,7 @@ static inline void *__alloc_percpu(size_t size, size_t align)
 	 * percpu sections on SMP for which this path isn't used.
 	 */
 	WARN_ON_ONCE(align > __alignof__(unsigned long long));
-	return kzalloc(size, gfp);
+	return kzalloc(bytes, gfp);
 }
 
 static inline void free_percpu(void *p)
diff --git a/mm/percpu.c b/mm/percpu.c
index 4617d97..8d6725a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -20,15 +20,15 @@
  * | u0 | u1 | u2 | u3 |        | u0 | u1 | u2 | u3 |      | u0 | u1 | u
  *  -------------------  ......  -------------------  ....  ------------
  *
- * Allocation is done in offset-size areas of single unit space.  Ie,
+ * Allocation is done in offset-bytes areas of single unit space.  Ie,
  * an area of 512 bytes at 6k in c1 occupies 512 bytes at 6k of c1:u0,
  * c1:u1, c1:u2 and c1:u3.  Percpu access can be done by configuring
- * percpu base registers UNIT_SIZE apart.
+ * percpu base registers pcpu_unit_bytes apart.
  *
  * There are usually many small percpu allocations many of them as
  * small as 4 bytes.  The allocator organizes chunks into lists
- * according to free size and tries to allocate from the fullest one.
- * Each chunk keeps the maximum contiguous area size hint which is
+ * according to free bytes and tries to allocate from the fullest one.
+ * Each chunk keeps the maximum contiguous area bytes hint which is
  * guaranteed to be eqaul to or larger than the maximum contiguous
  * area in the chunk.  This helps the allocator not to iterate the
  * chunk maps unnecessarily.
@@ -67,15 +67,15 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-#define PCPU_MIN_UNIT_PAGES_SHIFT	4	/* also max alloc size */
+#define PCPU_MIN_UNIT_PAGES_SHIFT	4	/* also max alloc bytes */
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
 
 struct pcpu_chunk {
 	struct list_head	list;		/* linked to pcpu_slot lists */
 	struct rb_node		rb_node;	/* key is chunk->vm->addr */
-	int			free_size;	/* free bytes in the chunk */
-	int			contig_hint;	/* max contiguous size hint */
+	int			free_bytes;	/* free bytes in the chunk */
+	int			contig_hint;	/* max contiguous bytes hint */
 	struct vm_struct	*vm;		/* mapped vmalloc region */
 	int			map_used;	/* # of map entries used */
 	int			map_alloc;	/* # of map entries allocated */
@@ -86,8 +86,8 @@ struct pcpu_chunk {
 static int pcpu_unit_pages_shift;
 static int pcpu_unit_pages;
 static int pcpu_unit_shift;
-static int pcpu_unit_size;
-static int pcpu_chunk_size;
+static int pcpu_unit_bytes;
+static int pcpu_chunk_bytes;
 static int pcpu_nr_slots;
 static size_t pcpu_chunk_struct_size;
 
@@ -96,7 +96,7 @@ void *pcpu_base_addr;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
 /* the size of kernel static area */
-static int pcpu_static_size;
+static int pcpu_static_bytes;
 
 /*
  * One mutex to rule them all.
@@ -117,18 +117,18 @@ static DEFINE_MUTEX(pcpu_mutex);
 static struct list_head *pcpu_slot;		/* chunk list slots */
 static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
-static int pcpu_size_to_slot(int size)
+static int pcpu_bytes_to_slot(int bytes)
 {
-	int highbit = fls(size);
+	int highbit = fls(bytes);
 	return max(highbit - PCPU_SLOT_BASE_SHIFT + 2, 1);
 }
 
 static int pcpu_chunk_slot(const struct pcpu_chunk *chunk)
 {
-	if (chunk->free_size < sizeof(int) || chunk->contig_hint < sizeof(int))
+	if (chunk->free_bytes < sizeof(int) || chunk->contig_hint < sizeof(int))
 		return 0;
 
-	return pcpu_size_to_slot(chunk->free_size);
+	return pcpu_bytes_to_slot(chunk->free_bytes);
 }
 
 static int pcpu_page_idx(unsigned int cpu, int page_idx)
@@ -158,8 +158,8 @@ static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 /**
  * pcpu_realloc - versatile realloc
  * @p: the current pointer (can be NULL for new allocations)
- * @size: the current size (can be 0 for new allocations)
- * @new_size: the wanted new size (can be 0 for free)
+ * @bytes: the current size (can be 0 for new allocations)
+ * @new_bytes: the wanted new size (can be 0 for free)
  *
  * More robust realloc which can be used to allocate, resize or free a
  * memory area of arbitrary size.  If the needed size goes over
@@ -168,22 +168,22 @@ static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
  * RETURNS:
  * The new pointer on success, NULL on failure.
  */
-static void *pcpu_realloc(void *p, size_t size, size_t new_size)
+static void *pcpu_realloc(void *p, size_t bytes, size_t new_bytes)
 {
 	void *new;
 
-	if (new_size <= PAGE_SIZE)
-		new = kmalloc(new_size, GFP_KERNEL);
+	if (new_bytes <= PAGE_SIZE)
+		new = kmalloc(new_bytes, GFP_KERNEL);
 	else
-		new = vmalloc(new_size);
-	if (new_size && !new)
+		new = vmalloc(new_bytes);
+	if (new_bytes && !new)
 		return NULL;
 
-	memcpy(new, p, min(size, new_size));
-	if (new_size > size)
-		memset(new + size, 0, new_size - size);
+	memcpy(new, p, min(bytes, new_bytes));
+	if (new_bytes > bytes)
+		memset(new + bytes, 0, new_bytes - bytes);
 
-	if (size <= PAGE_SIZE)
+	if (bytes <= PAGE_SIZE)
 		kfree(p);
 	else
 		vfree(p);
@@ -346,17 +346,17 @@ static int pcpu_split_block(struct pcpu_chunk *chunk, int i, int head, int tail)
 /**
  * pcpu_alloc_area - allocate area from a pcpu_chunk
  * @chunk: chunk of interest
- * @size: wanted size
+ * @bytes: wanted size
  * @align: wanted align
  *
- * Try to allocate @size bytes area aligned at @align from @chunk.
- * Note that this function only allocates the offset.  It doesn't
- * populate or map the area.
+ * Try to allocate @bytes area aligned at @align from @chunk.  Note
+ * that this function only allocates the offset.  It doesn't populate
+ * or map the area.
  *
  * RETURNS:
  * Allocated offset in @chunk on success, -errno on failure.
  */
-static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
+static int pcpu_alloc_area(struct pcpu_chunk *chunk, int bytes, int align)
 {
 	int oslot = pcpu_chunk_slot(chunk);
 	int max_contig = 0;
@@ -373,9 +373,9 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 			return -ENOMEM;
 
 		chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
-		chunk->map[chunk->map_used++] = -pcpu_static_size;
-		if (chunk->free_size)
-			chunk->map[chunk->map_used++] = chunk->free_size;
+		chunk->map[chunk->map_used++] = -pcpu_static_bytes;
+		if (chunk->free_bytes)
+			chunk->map[chunk->map_used++] = chunk->free_bytes;
 	}
 
 	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++])) {
@@ -388,7 +388,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 
 		if (chunk->map[i] < 0)
 			continue;
-		if (chunk->map[i] < head + size) {
+		if (chunk->map[i] < head + bytes) {
 			max_contig = max(chunk->map[i], max_contig);
 			continue;
 		}
@@ -404,7 +404,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 				chunk->map[i - 1] += head;
 			else {
 				chunk->map[i - 1] -= head;
-				chunk->free_size -= head;
+				chunk->free_bytes -= head;
 			}
 			chunk->map[i] -= head;
 			off += head;
@@ -412,7 +412,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 		}
 
 		/* if tail is small, just keep it around */
-		tail = chunk->map[i] - head - size;
+		tail = chunk->map[i] - head - bytes;
 		if (tail < sizeof(int))
 			tail = 0;
 
@@ -436,7 +436,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 			chunk->contig_hint = max(chunk->contig_hint,
 						 max_contig);
 
-		chunk->free_size -= chunk->map[i];
+		chunk->free_bytes -= chunk->map[i];
 		chunk->map[i] = -chunk->map[i];
 
 		pcpu_chunk_relocate(chunk, oslot);
@@ -477,7 +477,7 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 	BUG_ON(chunk->map[i] > 0);
 
 	chunk->map[i] = -chunk->map[i];
-	chunk->free_size += chunk->map[i];
+	chunk->free_bytes += chunk->map[i];
 
 	/* merge with previous? */
 	if (i > 0 && chunk->map[i - 1] >= 0) {
@@ -540,18 +540,18 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
  * pcpu_depopulate_chunk - depopulate and unmap an area of a pcpu_chunk
  * @chunk: chunk to depopulate
  * @off: offset to the area to depopulate
- * @size: size of the area to depopulate
+ * @bytes: size of the area to depopulate
  * @flush: whether to flush cache and tlb or not
  *
  * For each cpu, depopulate and unmap pages [@page_start,@page_end)
  * from @chunk.  If @flush is true, vcache is flushed before unmapping
  * and tlb after.
  */
-static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, size_t off,
-				  size_t size, bool flush)
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int bytes,
+				  bool flush)
 {
 	int page_start = PFN_DOWN(off);
-	int page_end = PFN_UP(off + size);
+	int page_end = PFN_UP(off + bytes);
 	int unmap_start = -1;
 	int uninitialized_var(unmap_end);
 	unsigned int cpu;
@@ -617,16 +617,16 @@ static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
  * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
  * @chunk: chunk of interest
  * @off: offset to the area to populate
- * @size: size of the area to populate
+ * @bytes: size of the area to populate
  *
  * For each cpu, populate and map pages [@page_start,@page_end) into
  * @chunk.  The area is cleared on return.
  */
-static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int bytes)
 {
 	const gfp_t alloc_mask = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
 	int page_start = PFN_DOWN(off);
-	int page_end = PFN_UP(off + size);
+	int page_end = PFN_UP(off + bytes);
 	int map_start = -1;
 	int map_end;
 	unsigned int cpu;
@@ -660,12 +660,12 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 
 	for_each_possible_cpu(cpu)
 		memset(chunk->vm->addr + (cpu << pcpu_unit_shift) + off, 0,
-		       size);
+		       bytes);
 
 	return 0;
 err:
 	/* likely under heavy memory pressure, give memory back */
-	pcpu_depopulate_chunk(chunk, off, size, true);
+	pcpu_depopulate_chunk(chunk, off, bytes, true);
 	return -ENOMEM;
 }
 
@@ -690,53 +690,53 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	chunk->map = pcpu_realloc(NULL, 0,
 				  PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
-	chunk->map[chunk->map_used++] = pcpu_unit_size;
+	chunk->map[chunk->map_used++] = pcpu_unit_bytes;
 
-	chunk->vm = get_vm_area(pcpu_chunk_size, GFP_KERNEL);
+	chunk->vm = get_vm_area(pcpu_chunk_bytes, GFP_KERNEL);
 	if (!chunk->vm) {
 		free_pcpu_chunk(chunk);
 		return NULL;
 	}
 
 	INIT_LIST_HEAD(&chunk->list);
-	chunk->free_size = pcpu_unit_size;
-	chunk->contig_hint = pcpu_unit_size;
+	chunk->free_bytes = pcpu_unit_bytes;
+	chunk->contig_hint = pcpu_unit_bytes;
 
 	return chunk;
 }
 
 /**
  * __alloc_percpu - allocate percpu area
- * @size: size of area to allocate
+ * @bytes: size of area to allocate
  * @align: alignment of area (max PAGE_SIZE)
  *
- * Allocate percpu area of @size bytes aligned at @align.  Might
- * sleep.  Might trigger writeouts.
+ * Allocate percpu area of @bytes aligned at @align.  Might sleep.
+ * Might trigger writeouts.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
  */
-void *__alloc_percpu(size_t size, size_t align)
+void *__alloc_percpu(size_t bytes, size_t align)
 {
 	void *ptr = NULL;
 	struct pcpu_chunk *chunk;
 	int slot, off;
 
-	if (unlikely(!size || size > PAGE_SIZE << PCPU_MIN_UNIT_PAGES_SHIFT ||
+	if (unlikely(!bytes || bytes > PAGE_SIZE << PCPU_MIN_UNIT_PAGES_SHIFT ||
 		     align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
-		     "percpu allocation\n", size, align);
+		     "percpu allocation\n", bytes, align);
 		return NULL;
 	}
 
 	mutex_lock(&pcpu_mutex);
 
 	/* allocate area */
-	for (slot = pcpu_size_to_slot(size); slot < pcpu_nr_slots; slot++) {
+	for (slot = pcpu_bytes_to_slot(bytes); slot < pcpu_nr_slots; slot++) {
 		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
-			if (size > chunk->contig_hint)
+			if (bytes > chunk->contig_hint)
 				continue;
-			off = pcpu_alloc_area(chunk, size, align);
+			off = pcpu_alloc_area(chunk, bytes, align);
 			if (off >= 0)
 				goto area_found;
 			if (off != -ENOSPC)
@@ -751,13 +751,13 @@ void *__alloc_percpu(size_t size, size_t align)
 	pcpu_chunk_relocate(chunk, -1);
 	pcpu_chunk_addr_insert(chunk);
 
-	off = pcpu_alloc_area(chunk, size, align);
+	off = pcpu_alloc_area(chunk, bytes, align);
 	if (off < 0)
 		goto out_unlock;
 
 area_found:
 	/* populate, map and clear the area */
-	if (pcpu_populate_chunk(chunk, off, size)) {
+	if (pcpu_populate_chunk(chunk, off, bytes)) {
 		pcpu_free_area(chunk, off);
 		goto out_unlock;
 	}
@@ -771,7 +771,7 @@ EXPORT_SYMBOL_GPL(__alloc_percpu);
 
 static void pcpu_kill_chunk(struct pcpu_chunk *chunk)
 {
-	pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size, false);
+	pcpu_depopulate_chunk(chunk, 0, pcpu_unit_bytes, false);
 	list_del(&chunk->list);
 	rb_erase(&chunk->rb_node, &pcpu_addr_root);
 	free_pcpu_chunk(chunk);
@@ -800,7 +800,7 @@ void free_percpu(void *ptr)
 	pcpu_free_area(chunk, off);
 
 	/* the chunk became fully free, kill one if there are other free ones */
-	if (chunk->free_size == pcpu_unit_size) {
+	if (chunk->free_bytes == pcpu_unit_bytes) {
 		struct pcpu_chunk *pos;
 
 		list_for_each_entry(pos,
@@ -818,7 +818,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
 /**
  * pcpu_setup_static - initialize kernel static percpu area
  * @populate_pte_fn: callback to allocate pagetable
- * @pages: num_possible_cpus() * PFN_UP(cpu_size) pages
+ * @pages: num_possible_cpus() * PFN_UP(cpu_bytes) pages
  *
  * Initialize kernel static percpu area.  The caller should allocate
  * all the necessary pages and pass them in @pages.
@@ -827,27 +827,27 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * tables for the page is allocated.
  *
  * RETURNS:
- * The determined pcpu_unit_size which can be used to initialize
+ * The determined pcpu_unit_bytes which can be used to initialize
  * percpu access.
  */
 size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
-				struct page **pages, size_t cpu_size)
+				struct page **pages, size_t cpu_bytes)
 {
 	static struct vm_struct static_vm;
 	struct pcpu_chunk *static_chunk;
-	int nr_cpu_pages = DIV_ROUND_UP(cpu_size, PAGE_SIZE);
+	int nr_cpu_pages = DIV_ROUND_UP(cpu_bytes, PAGE_SIZE);
 	unsigned int cpu;
 	int err, i;
 
 	pcpu_unit_pages_shift = max_t(int, PCPU_MIN_UNIT_PAGES_SHIFT,
-				      order_base_2(cpu_size) - PAGE_SHIFT);
+				      order_base_2(cpu_bytes) - PAGE_SHIFT);
 
-	pcpu_static_size = cpu_size;
+	pcpu_static_bytes = cpu_bytes;
 	pcpu_unit_pages = 1 << pcpu_unit_pages_shift;
 	pcpu_unit_shift = PAGE_SHIFT + pcpu_unit_pages_shift;
-	pcpu_unit_size = 1 << pcpu_unit_shift;
-	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
-	pcpu_nr_slots = pcpu_size_to_slot(pcpu_unit_size) + 1;
+	pcpu_unit_bytes = 1 << pcpu_unit_shift;
+	pcpu_chunk_bytes = num_possible_cpus() * pcpu_unit_bytes;
+	pcpu_nr_slots = pcpu_bytes_to_slot(pcpu_unit_bytes) + 1;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
 		+ (1 << pcpu_unit_pages_shift) * sizeof(struct page *);
 
@@ -858,15 +858,15 @@ size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
 
 	/* init and register vm area */
 	static_vm.flags = VM_ALLOC;
-	static_vm.size = pcpu_chunk_size;
+	static_vm.size = pcpu_chunk_bytes;
 	vm_area_register_early(&static_vm);
 
 	/* init static_chunk */
 	static_chunk = alloc_bootmem(pcpu_chunk_struct_size);
 	INIT_LIST_HEAD(&static_chunk->list);
 	static_chunk->vm = &static_vm;
-	static_chunk->free_size = pcpu_unit_size - pcpu_static_size;
-	static_chunk->contig_hint = static_chunk->free_size;
+	static_chunk->free_bytes = pcpu_unit_bytes - pcpu_static_bytes;
+	static_chunk->contig_hint = static_chunk->free_bytes;
 
 	/* assign pages and map them */
 	for_each_possible_cpu(cpu) {
@@ -886,5 +886,5 @@ size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
 
 	/* we're done */
 	pcpu_base_addr = (void *)pcpu_chunk_addr(static_chunk, 0, 0);
-	return pcpu_unit_size;
+	return pcpu_unit_bytes;
 }
-- 
1.6.0.2

