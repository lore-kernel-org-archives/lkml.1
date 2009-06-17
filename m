Return-Path: <linux-kernel-owner+w=401wt.eu-S1764427AbZFQEGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764427AbZFQEGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbZFQEGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:06:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:42012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977AbZFQEGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:06:14 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] percpu: make 4k first chunk allocator map memory
Date: Wed, 17 Jun 2009 13:04:34 +0900
Message-Id: <1245211476-27015-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245211476-27015-1-git-send-email-tj@kernel.org>
References: <1245211476-27015-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:04:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At first, percpu first chunk was always setup page-by-page by the
generic code.  To add other allocators, different parts of the generic
initialization was made optional.  Now we have three allocators -
embed, remap and 4k.  embed and remap fully handle allocation and
mapping of the first chunk while 4k still depends on generic code for
those.  This makes the generic alloc/map paths specifci to 4k and
makes the code unnecessary complicated with optional generic
behaviors.

This patch makes the 4k allocator to allocate and map memory directly
instead of depending on the generic code.  The only outside visible
change is that now dynamic area in the first chunk is allocated
up-front instead of on-demand.  This doesn't make any meaningful
difference as the area is minimal (usually less than a page, just
enough to fill the alignment) on 4k allocator.  Plus, dynamic area in
the first chunk usually gets fully used anyway.

This will allow simplification of pcpu_setpu_first_chunk() and removal
of chunk->page array.

[ Impact: no outside visible change other than up-front allocation of dyn area ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 mm/percpu.c |   71 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 39f4022..c173763 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -632,6 +632,13 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size,
 		pcpu_unmap(chunk, unmap_start, unmap_end, flush);
 }
 
+static int __pcpu_map_pages(unsigned long addr, struct page **pages,
+			    int nr_pages)
+{
+	return map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
+					PAGE_KERNEL, pages);
+}
+
 /**
  * pcpu_map - map pages into a pcpu_chunk
  * @chunk: chunk of interest
@@ -651,11 +658,9 @@ static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
 	WARN_ON(chunk->immutable);
 
 	for_each_possible_cpu(cpu) {
-		err = map_kernel_range_noflush(
-				pcpu_chunk_addr(chunk, cpu, page_start),
-				(page_end - page_start) << PAGE_SHIFT,
-				PAGE_KERNEL,
-				pcpu_chunk_pagep(chunk, cpu, page_start));
+		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
+				       pcpu_chunk_pagep(chunk, cpu, page_start),
+				       page_end - page_start);
 		if (err < 0)
 			return err;
 	}
@@ -1274,12 +1279,12 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
  * 4k page first chunk setup helper.
  */
 static struct page **pcpu4k_pages __initdata;
-static int pcpu4k_nr_static_pages __initdata;
+static int pcpu4k_unit_pages __initdata;
 
 static struct page * __init pcpu4k_get_page(unsigned int cpu, int pageno)
 {
-	if (pageno < pcpu4k_nr_static_pages)
-		return pcpu4k_pages[cpu * pcpu4k_nr_static_pages + pageno];
+	if (pageno < pcpu4k_unit_pages)
+		return pcpu4k_pages[cpu * pcpu4k_unit_pages + pageno];
 	return NULL;
 }
 
@@ -1306,22 +1311,24 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 				   pcpu_fc_free_fn_t free_fn,
 				   pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
+	static struct vm_struct vm;
 	size_t pages_size;
 	unsigned int cpu;
 	int i, j;
 	ssize_t ret;
 
-	pcpu4k_nr_static_pages = PFN_UP(static_size);
+	pcpu4k_unit_pages = PFN_UP(max_t(size_t, static_size + reserved_size,
+					 PCPU_MIN_UNIT_SIZE));
 
 	/* unaligned allocations can't be freed, round up to page size */
-	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * num_possible_cpus() *
+	pages_size = PFN_ALIGN(pcpu4k_unit_pages * num_possible_cpus() *
 			       sizeof(pcpu4k_pages[0]));
 	pcpu4k_pages = alloc_bootmem(pages_size);
 
-	/* allocate and copy */
+	/* allocate pages */
 	j = 0;
 	for_each_possible_cpu(cpu)
-		for (i = 0; i < pcpu4k_nr_static_pages; i++) {
+		for (i = 0; i < pcpu4k_unit_pages; i++) {
 			void *ptr;
 
 			ptr = alloc_fn(cpu, PAGE_SIZE);
@@ -1330,18 +1337,48 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 					   "4k page for cpu%u\n", cpu);
 				goto enomem;
 			}
-
-			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
 			pcpu4k_pages[j++] = virt_to_page(ptr);
 		}
 
+	/* allocate vm area, map the pages and copy static data */
+	vm.flags = VM_ALLOC;
+	vm.size = num_possible_cpus() * pcpu4k_unit_pages << PAGE_SHIFT;
+	vm_area_register_early(&vm, PAGE_SIZE);
+
+	for_each_possible_cpu(cpu) {
+		unsigned long unit_addr = (unsigned long)vm.addr +
+			(cpu * pcpu4k_unit_pages << PAGE_SHIFT);
+
+		for (i = 0; i < pcpu4k_unit_pages; i++)
+			populate_pte_fn(unit_addr + (i << PAGE_SHIFT));
+
+		/* pte already populated, the following shouldn't fail */
+		ret = __pcpu_map_pages(unit_addr,
+				       &pcpu4k_pages[cpu * pcpu4k_unit_pages],
+				       pcpu4k_unit_pages);
+		if (ret < 0)
+			panic("failed to map percpu area, err=%zd\n", ret);
+
+		/*
+		 * FIXME: Archs with virtual cache should flush local
+		 * cache for the linear mapping here - something
+		 * equivalent to flush_cache_vmap() on the local cpu.
+		 * flush_cache_vmap() can't be used as most supporting
+		 * data structures are not set up yet.
+		 */
+
+		/* copy static data */
+		memcpy((void *)unit_addr, __per_cpu_load, static_size);
+	}
+
 	/* we're ready, commit */
-	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
-		pcpu4k_nr_static_pages, static_size);
+	pr_info("PERCPU: %d 4k pages per cpu, static data %zu bytes\n",
+		pcpu4k_unit_pages, static_size);
 
 	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size,
 				     reserved_size, -1,
-				     -1, NULL, populate_pte_fn);
+				     pcpu4k_unit_pages << PAGE_SHIFT, vm.addr,
+				     NULL);
 	goto out_free_ar;
 
 enomem:
-- 
1.6.0.2

