Return-Path: <linux-kernel-owner+w=401wt.eu-S1764533AbZFQEIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764533AbZFQEIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764965AbZFQEH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:07:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:41913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764995AbZFQEH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:07:56 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] percpu: simplify pcpu_setup_first_chunk()
Date: Wed, 17 Jun 2009 13:04:36 +0900
Message-Id: <1245211476-27015-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245211476-27015-1-git-send-email-tj@kernel.org>
References: <1245211476-27015-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:04:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all first chunk allocator helpers allocate and map the first
chunk themselves, there's no need to have optional default alloc/map
in pcpu_setup_first_chunk().  Drop @populate_pte_fn and only leave
@dyn_size optional and make all other params mandatory.

This makes it much easier to follow what pcpu_setup_first_chunk() is
doing and what actual differences tweaking each parameter results in.

[ Impact: drop unused code path ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/percpu.h |    5 +-
 mm/percpu.c            |  104 ++++++++++++++----------------------------------
 2 files changed, 32 insertions(+), 77 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9f6bfd7..ec64357 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -66,9 +66,8 @@ typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
 extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				size_t static_size, size_t reserved_size,
-				ssize_t dyn_size, ssize_t unit_size,
-				void *base_addr,
-				pcpu_fc_populate_pte_fn_t populate_pte_fn);
+				ssize_t dyn_size, size_t unit_size,
+				void *base_addr);
 
 extern ssize_t __init pcpu_embed_first_chunk(
 				size_t static_size, size_t reserved_size,
diff --git a/mm/percpu.c b/mm/percpu.c
index 17dfb7c..452d3f3 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -983,24 +983,22 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * pcpu_setup_first_chunk - initialize the first percpu chunk
  * @get_page_fn: callback to fetch page pointer
  * @static_size: the size of static percpu area in bytes
- * @reserved_size: the size of reserved percpu area in bytes
+ * @reserved_size: the size of reserved percpu area in bytes, 0 for none
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
- * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, -1 for auto
- * @base_addr: mapped address, NULL for auto
- * @populate_pte_fn: callback to allocate pagetable, NULL if unnecessary
+ * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE
+ * @base_addr: mapped address
  *
  * Initialize the first percpu chunk which contains the kernel static
  * perpcu area.  This function is to be called from arch percpu area
- * setup path.  The first two parameters are mandatory.  The rest are
- * optional.
+ * setup path.
  *
  * @get_page_fn() should return pointer to percpu page given cpu
  * number and page number.  It should at least return enough pages to
  * cover the static area.  The returned pages for static area should
- * have been initialized with valid data.  If @unit_size is specified,
- * it can also return pages after the static area.  NULL return
- * indicates end of pages for the cpu.  Note that @get_page_fn() must
- * return the same number of pages for all cpus.
+ * have been initialized with valid data.  It can also return pages
+ * after the static area.  NULL return indicates end of pages for the
+ * cpu.  Note that @get_page_fn() must return the same number of pages
+ * for all cpus.
  *
  * @reserved_size, if non-zero, specifies the amount of bytes to
  * reserve after the static area in the first chunk.  This reserves
@@ -1015,17 +1013,12 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * non-negative value makes percpu leave alone the area beyond
  * @static_size + @reserved_size + @dyn_size.
  *
- * @unit_size, if non-negative, specifies unit size and must be
- * aligned to PAGE_SIZE and equal to or larger than @static_size +
- * @reserved_size + if non-negative, @dyn_size.
- *
- * Non-null @base_addr means that the caller already allocated virtual
- * region for the first chunk and mapped it.  percpu must not mess
- * with the chunk.  Note that @base_addr with 0 @unit_size or non-NULL
- * @populate_pte_fn doesn't make any sense.
+ * @unit_size specifies unit size and must be aligned to PAGE_SIZE and
+ * equal to or larger than @static_size + @reserved_size + if
+ * non-negative, @dyn_size.
  *
- * @populate_pte_fn is used to populate the pagetable.  NULL means the
- * caller already populated the pagetable.
+ * The caller should have mapped the first chunk at @base_addr and
+ * copied static data to each unit.
  *
  * If the first chunk ends up with both reserved and dynamic areas, it
  * is served by two chunks - one to serve the core static and reserved
@@ -1040,9 +1033,8 @@ EXPORT_SYMBOL_GPL(free_percpu);
  */
 size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				     size_t static_size, size_t reserved_size,
-				     ssize_t dyn_size, ssize_t unit_size,
-				     void *base_addr,
-				     pcpu_fc_populate_pte_fn_t populate_pte_fn)
+				     ssize_t dyn_size, size_t unit_size,
+				     void *base_addr)
 {
 	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
@@ -1050,27 +1042,18 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 			  (dyn_size >= 0 ? dyn_size : 0);
 	struct pcpu_chunk *schunk, *dchunk = NULL;
 	unsigned int cpu;
-	int nr_pages;
-	int err, i;
+	int i, nr_pages;
 
 	/* santiy checks */
 	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC ||
 		     ARRAY_SIZE(dmap) >= PCPU_DFL_MAP_ALLOC);
 	BUG_ON(!static_size);
-	if (unit_size >= 0) {
-		BUG_ON(unit_size < size_sum);
-		BUG_ON(unit_size & ~PAGE_MASK);
-		BUG_ON(unit_size < PCPU_MIN_UNIT_SIZE);
-	} else
-		BUG_ON(base_addr);
-	BUG_ON(base_addr && populate_pte_fn);
-
-	if (unit_size >= 0)
-		pcpu_unit_pages = unit_size >> PAGE_SHIFT;
-	else
-		pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_SIZE >> PAGE_SHIFT,
-					PFN_UP(size_sum));
+	BUG_ON(!base_addr);
+	BUG_ON(unit_size < size_sum);
+	BUG_ON(unit_size & ~PAGE_MASK);
+	BUG_ON(unit_size < PCPU_MIN_UNIT_SIZE);
 
+	pcpu_unit_pages = unit_size >> PAGE_SHIFT;
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
@@ -1079,6 +1062,10 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	if (dyn_size < 0)
 		dyn_size = pcpu_unit_size - static_size - reserved_size;
 
+	first_vm.flags = VM_ALLOC;
+	first_vm.size = pcpu_chunk_size;
+	first_vm.addr = base_addr;
+
 	/*
 	 * Allocate chunk slots.  The additional last slot is for
 	 * empty chunks.
@@ -1101,6 +1088,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	schunk->map = smap;
 	schunk->map_alloc = ARRAY_SIZE(smap);
 	schunk->page = schunk->page_ar;
+	schunk->immutable = true;
 
 	if (reserved_size) {
 		schunk->free_size = reserved_size;
@@ -1124,31 +1112,13 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 		dchunk->map = dmap;
 		dchunk->map_alloc = ARRAY_SIZE(dmap);
 		dchunk->page = schunk->page_ar;	/* share page map with schunk */
+		dchunk->immutable = true;
 
 		dchunk->contig_hint = dchunk->free_size = dyn_size;
 		dchunk->map[dchunk->map_used++] = -pcpu_reserved_chunk_limit;
 		dchunk->map[dchunk->map_used++] = dchunk->free_size;
 	}
 
-	/* allocate vm address */
-	first_vm.flags = VM_ALLOC;
-	first_vm.size = pcpu_chunk_size;
-
-	if (!base_addr)
-		vm_area_register_early(&first_vm, PAGE_SIZE);
-	else {
-		/*
-		 * Pages already mapped.  No need to remap into
-		 * vmalloc area.  In this case the first chunks can't
-		 * be mapped or unmapped by percpu and are marked
-		 * immutable.
-		 */
-		first_vm.addr = base_addr;
-		schunk->immutable = true;
-		if (dchunk)
-			dchunk->immutable = true;
-	}
-
 	/* assign pages */
 	nr_pages = -1;
 	for_each_possible_cpu(cpu) {
@@ -1168,19 +1138,6 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 			BUG_ON(nr_pages != i);
 	}
 
-	/* map them */
-	if (populate_pte_fn) {
-		for_each_possible_cpu(cpu)
-			for (i = 0; i < nr_pages; i++)
-				populate_pte_fn(pcpu_chunk_addr(schunk,
-								cpu, i));
-
-		err = pcpu_map(schunk, 0, nr_pages);
-		if (err)
-			panic("failed to setup static percpu area, err=%d\n",
-			      err);
-	}
-
 	/* link the first chunk in */
 	pcpu_first_chunk = dchunk ?: schunk;
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
@@ -1282,7 +1239,7 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 
 	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
 				      reserved_size, dyn_size,
-				      pcpue_unit_size, pcpue_ptr, NULL);
+				      pcpue_unit_size, pcpue_ptr);
 }
 
 /*
@@ -1387,8 +1344,7 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 
 	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size,
 				     reserved_size, -1,
-				     pcpu4k_unit_pages << PAGE_SHIFT, vm.addr,
-				     NULL);
+				     pcpu4k_unit_pages << PAGE_SHIFT, vm.addr);
 	goto out_free_ar;
 
 enomem:
@@ -1521,7 +1477,7 @@ ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
 
 	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
 				     reserved_size, dyn_size, pcpul_unit_size,
-				     pcpul_vm.addr, NULL);
+				     pcpul_vm.addr);
 
 	/* sort pcpul_map array for pcpu_lpage_remapped() */
 	for (i = 0; i < num_possible_cpus() - 1; i++)
-- 
1.6.0.2

