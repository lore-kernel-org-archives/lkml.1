Return-Path: <linux-kernel-owner+w=401wt.eu-S1764735AbZFQE1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764735AbZFQE1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZFQE0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:26:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:41155 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbZFQE0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:26:36 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       JBeulich@novell.com, cl@linux-foundation.org, davem@davemloft.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] percpu: allow non-linear / sparse cpu -> unit mapping
Date: Wed, 17 Jun 2009 13:26:08 +0900
Message-Id: <1245212769-29134-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245212769-29134-1-git-send-email-tj@kernel.org>
References: <1245212769-29134-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:26:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cpu and unit are always identity mapped.  To allow more
efficient large page support on NUMA and lazy allocation for possible
but offline cpus, cpu -> unit mapping needs to be non-linear and/or
sparse.  This can be easily implemented by adding a cpu -> unit
mapping array and using it whenever looking up the matching unit for a
cpu.

The only unusal conversion is in pcpu_chunk_addr_search().  The passed
in address is unit0 based and unit0 might not be in use so it needs to
be converted to address of an in-use unit.  This is easily done by
adding the unit offset for the current processor.

[ Impact: allows non-linear/sparse cpu -> unit mapping, no visible change yet ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/percpu.h |    3 +-
 mm/percpu.c            |  129 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 96 insertions(+), 36 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 63c8b7a..1e0e887 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -57,6 +57,7 @@
 #endif
 
 extern void *pcpu_base_addr;
+extern const int *pcpu_unit_map;
 
 typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size);
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
@@ -66,7 +67,7 @@ typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 extern size_t __init pcpu_setup_first_chunk(
 				size_t static_size, size_t reserved_size,
 				ssize_t dyn_size, size_t unit_size,
-				void *base_addr);
+				void *base_addr, const int *unit_map);
 
 extern ssize_t __init pcpu_embed_first_chunk(
 				size_t static_size, size_t reserved_size,
diff --git a/mm/percpu.c b/mm/percpu.c
index 5ee712e..f0fce38 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -8,12 +8,13 @@
  *
  * This is percpu allocator which can handle both static and dynamic
  * areas.  Percpu areas are allocated in chunks in vmalloc area.  Each
- * chunk is consisted of num_possible_cpus() units and the first chunk
- * is used for static percpu variables in the kernel image (special
- * boot time alloc/init handling necessary as these areas need to be
- * brought up before allocation services are running).  Unit grows as
- * necessary and all units grow or shrink in unison.  When a chunk is
- * filled up, another chunk is allocated.  ie. in vmalloc area
+ * chunk is consisted of boot-time determined number of units and the
+ * first chunk is used for static percpu variables in the kernel image
+ * (special boot time alloc/init handling necessary as these areas
+ * need to be brought up before allocation services are running).
+ * Unit grows as necessary and all units grow or shrink in unison.
+ * When a chunk is filled up, another chunk is allocated.  ie. in
+ * vmalloc area
  *
  *  c0                           c1                         c2
  *  -------------------          -------------------        ------------
@@ -22,11 +23,13 @@
  *
  * Allocation is done in offset-size areas of single unit space.  Ie,
  * an area of 512 bytes at 6k in c1 occupies 512 bytes at 6k of c1:u0,
- * c1:u1, c1:u2 and c1:u3.  Percpu access can be done by configuring
- * percpu base registers pcpu_unit_size apart.
+ * c1:u1, c1:u2 and c1:u3.  On UMA, units corresponds directly to
+ * cpus.  On NUMA, the mapping can be non-linear and even sparse.
+ * Percpu access can be done by configuring percpu base registers
+ * according to cpu to unit mapping and pcpu_unit_size.
  *
- * There are usually many small percpu allocations many of them as
- * small as 4 bytes.  The allocator organizes chunks into lists
+ * There are usually many small percpu allocations many of them being
+ * as small as 4 bytes.  The allocator organizes chunks into lists
  * according to free size and tries to allocate from the fullest one.
  * Each chunk keeps the maximum contiguous area size hint which is
  * guaranteed to be eqaul to or larger than the maximum contiguous
@@ -99,14 +102,22 @@ struct pcpu_chunk {
 
 static int pcpu_unit_pages __read_mostly;
 static int pcpu_unit_size __read_mostly;
+static int pcpu_nr_units __read_mostly;
 static int pcpu_chunk_size __read_mostly;
 static int pcpu_nr_slots __read_mostly;
 static size_t pcpu_chunk_struct_size __read_mostly;
 
+/* cpus with the lowest and highest unit numbers */
+static unsigned int pcpu_first_unit_cpu __read_mostly;
+static unsigned int pcpu_last_unit_cpu __read_mostly;
+
 /* the address of the first chunk which starts with the kernel static area */
 void *pcpu_base_addr __read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
+/* cpu -> unit map */
+const int *pcpu_unit_map __read_mostly;
+
 /*
  * The first chunk which always exists.  Note that unlike other
  * chunks, this one can be allocated and mapped in several different
@@ -177,7 +188,7 @@ static int pcpu_chunk_slot(const struct pcpu_chunk *chunk)
 
 static int pcpu_page_idx(unsigned int cpu, int page_idx)
 {
-	return cpu * pcpu_unit_pages + page_idx;
+	return pcpu_unit_map[cpu] * pcpu_unit_pages + page_idx;
 }
 
 static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
@@ -321,6 +332,14 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 		return pcpu_first_chunk;
 	}
 
+	/*
+	 * The address is relative to unit0 which might be unused and
+	 * thus unmapped.  Offset the address to the unit space of the
+	 * current processor before looking it up in the vmalloc
+	 * space.  Note that any possible cpu id can be used here, so
+	 * there's no need to worry about preemption or cpu hotplug.
+	 */
+	addr += pcpu_unit_map[smp_processor_id()] * pcpu_unit_size;
 	return pcpu_get_page_chunk(vmalloc_to_page(addr));
 }
 
@@ -593,8 +612,7 @@ static struct page **pcpu_get_pages_and_bitmap(struct pcpu_chunk *chunk,
 {
 	static struct page **pages;
 	static unsigned long *bitmap;
-	size_t pages_size = num_possible_cpus() * pcpu_unit_pages *
-			    sizeof(pages[0]);
+	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
 	size_t bitmap_size = BITS_TO_LONGS(pcpu_unit_pages) *
 			     sizeof(unsigned long);
 
@@ -692,10 +710,9 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
 				 int page_start, int page_end)
 {
-	unsigned int last = num_possible_cpus() - 1;
-
-	flush_cache_vunmap(pcpu_chunk_addr(chunk, 0, page_start),
-			   pcpu_chunk_addr(chunk, last, page_end));
+	flush_cache_vunmap(
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
 }
 
 static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
@@ -756,10 +773,9 @@ static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
 				      int page_start, int page_end)
 {
-	unsigned int last = num_possible_cpus() - 1;
-
-	flush_tlb_kernel_range(pcpu_chunk_addr(chunk, 0, page_start),
-			       pcpu_chunk_addr(chunk, last, page_end));
+	flush_tlb_kernel_range(
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
 }
 
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
@@ -835,11 +851,9 @@ err:
 static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
 				int page_start, int page_end)
 {
-	unsigned int last = num_possible_cpus() - 1;
-
-	/* flush at once, please read comments in pcpu_unmap() */
-	flush_cache_vmap(pcpu_chunk_addr(chunk, 0, page_start),
-			 pcpu_chunk_addr(chunk, last, page_end));
+	flush_cache_vmap(
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
 }
 
 /**
@@ -953,8 +967,7 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	bitmap_copy(chunk->populated, populated, pcpu_unit_pages);
 clear:
 	for_each_possible_cpu(cpu)
-		memset(chunk->vm->addr + cpu * pcpu_unit_size + off, 0,
-		       size);
+		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
 	return 0;
 
 err_unmap:
@@ -1088,6 +1101,7 @@ area_found:
 
 	mutex_unlock(&pcpu_alloc_mutex);
 
+	/* return address relative to unit0 */
 	return __addr_to_pcpu_ptr(chunk->vm->addr + off);
 
 fail_unlock:
@@ -1222,6 +1236,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
  * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE
  * @base_addr: mapped address
+ * @unit_map: cpu -> unit map, NULL for sequential mapping
  *
  * Initialize the first percpu chunk which contains the kernel static
  * perpcu area.  This function is to be called from arch percpu area
@@ -1260,16 +1275,17 @@ EXPORT_SYMBOL_GPL(free_percpu);
  */
 size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 				     ssize_t dyn_size, size_t unit_size,
-				     void *base_addr)
+				     void *base_addr, const int *unit_map)
 {
 	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
 	size_t size_sum = static_size + reserved_size +
 			  (dyn_size >= 0 ? dyn_size : 0);
 	struct pcpu_chunk *schunk, *dchunk = NULL;
+	unsigned int cpu, tcpu;
 	int i;
 
-	/* santiy checks */
+	/* sanity checks */
 	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC ||
 		     ARRAY_SIZE(dmap) >= PCPU_DFL_MAP_ALLOC);
 	BUG_ON(!static_size);
@@ -1278,9 +1294,52 @@ size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 	BUG_ON(unit_size & ~PAGE_MASK);
 	BUG_ON(unit_size < PCPU_MIN_UNIT_SIZE);
 
+	/* determine number of units and verify and initialize pcpu_unit_map */
+	if (unit_map) {
+		int first_unit = INT_MAX, last_unit = INT_MIN;
+
+		for_each_possible_cpu(cpu) {
+			int unit = unit_map[cpu];
+
+			BUG_ON(unit < 0);
+			for_each_possible_cpu(tcpu) {
+				if (tcpu == cpu)
+					break;
+				/* the mapping should be one-to-one */
+				BUG_ON(unit_map[tcpu] == unit);
+			}
+
+			if (unit < first_unit) {
+				pcpu_first_unit_cpu = cpu;
+				first_unit = unit;
+			}
+			if (unit > last_unit) {
+				pcpu_last_unit_cpu = cpu;
+				last_unit = unit;
+			}
+		}
+		pcpu_nr_units = last_unit + 1;
+		pcpu_unit_map = unit_map;
+	} else {
+		int *identity_map;
+
+		/* #units == #cpus, identity mapped */
+		identity_map = alloc_bootmem(num_possible_cpus() *
+					     sizeof(identity_map[0]));
+
+		for_each_possible_cpu(cpu)
+			identity_map[cpu] = cpu;
+
+		pcpu_first_unit_cpu = 0;
+		pcpu_last_unit_cpu = pcpu_nr_units - 1;
+		pcpu_nr_units = num_possible_cpus();
+		pcpu_unit_map = identity_map;
+	}
+
+	/* determine basic parameters */
 	pcpu_unit_pages = unit_size >> PAGE_SHIFT;
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
-	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
+	pcpu_chunk_size = pcpu_nr_units * pcpu_unit_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
 		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
 
@@ -1349,7 +1408,7 @@ size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
 
 	/* we're done */
-	pcpu_base_addr = (void *)pcpu_chunk_addr(schunk, 0, 0);
+	pcpu_base_addr = schunk->vm->addr;
 	return pcpu_unit_size;
 }
 
@@ -1427,7 +1486,7 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 		size_sum >> PAGE_SHIFT, base, static_size);
 
 	return pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
-				      unit_size, base);
+				      unit_size, base, NULL);
 }
 
 /**
@@ -1519,7 +1578,7 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 		unit_pages, static_size);
 
 	ret = pcpu_setup_first_chunk(static_size, reserved_size, -1,
-				     unit_pages << PAGE_SHIFT, vm.addr);
+				     unit_pages << PAGE_SHIFT, vm.addr, NULL);
 	goto out_free_ar;
 
 enomem:
@@ -1641,7 +1700,7 @@ ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
 		"%zu bytes\n", pcpul_vm.addr, static_size);
 
 	ret = pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
-				     pcpul_unit_size, pcpul_vm.addr);
+				     pcpul_unit_size, pcpul_vm.addr, NULL);
 
 	/* sort pcpul_map array for pcpu_lpage_remapped() */
 	for (i = 0; i < num_possible_cpus() - 1; i++)
-- 
1.6.0.2

