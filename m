Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZCFGtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZCFGtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbZCFGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:56798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZCFGrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:07 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] percpu: cosmetic renames in pcpu_setup_first_chunk()
Date: Fri,  6 Mar 2009 15:46:22 +0900
Message-Id: <1236321988-19457-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cosmetic, preparation for future changes

Make the following renames in pcpur_setup_first_chunk() in preparation
for future changes.

* s/free_size/dyn_size/
* s/static_vm/first_vm/
* s/static_chunk/schunk/

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |    2 +-
 mm/percpu.c            |   58 ++++++++++++++++++++++++------------------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 2d34b03..a0b4ea2 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -118,7 +118,7 @@ typedef void (*pcpu_populate_pte_fn_t)(unsigned long addr);
 
 extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 					size_t static_size, size_t unit_size,
-					size_t free_size, void *base_addr,
+					size_t dyn_size, void *base_addr,
 					pcpu_populate_pte_fn_t populate_pte_fn);
 
 /*
diff --git a/mm/percpu.c b/mm/percpu.c
index 3d0f545..9531590 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -831,7 +831,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * @get_page_fn: callback to fetch page pointer
  * @static_size: the size of static percpu area in bytes
  * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, 0 for auto
- * @free_size: free size in bytes, 0 for auto
+ * @dyn_size: free size for dynamic allocation in bytes, 0 for auto
  * @base_addr: mapped address, NULL for auto
  * @populate_pte_fn: callback to allocate pagetable, NULL if unnecessary
  *
@@ -849,12 +849,12 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * return the same number of pages for all cpus.
  *
  * @unit_size, if non-zero, determines unit size and must be aligned
- * to PAGE_SIZE and equal to or larger than @static_size + @free_size.
+ * to PAGE_SIZE and equal to or larger than @static_size + @dyn_size.
  *
- * @free_size determines the number of free bytes after the static
+ * @dyn_size determines the number of free bytes after the static
  * area in the first chunk.  If zero, whatever left is available.
  * Specifying non-zero value make percpu leave the area after
- * @static_size + @free_size alone.
+ * @static_size + @dyn_size alone.
  *
  * Non-null @base_addr means that the caller already allocated virtual
  * region for the first chunk and mapped it.  percpu must not mess
@@ -870,19 +870,19 @@ EXPORT_SYMBOL_GPL(free_percpu);
  */
 size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				     size_t static_size, size_t unit_size,
-				     size_t free_size, void *base_addr,
+				     size_t dyn_size, void *base_addr,
 				     pcpu_populate_pte_fn_t populate_pte_fn)
 {
-	static struct vm_struct static_vm;
-	struct pcpu_chunk *static_chunk;
+	static struct vm_struct first_vm;
+	struct pcpu_chunk *schunk;
 	unsigned int cpu;
 	int nr_pages;
 	int err, i;
 
 	/* santiy checks */
 	BUG_ON(!static_size);
-	BUG_ON(!unit_size && free_size);
-	BUG_ON(unit_size && unit_size < static_size + free_size);
+	BUG_ON(!unit_size && dyn_size);
+	BUG_ON(unit_size && unit_size < static_size + dyn_size);
 	BUG_ON(unit_size & ~PAGE_MASK);
 	BUG_ON(base_addr && !unit_size);
 	BUG_ON(base_addr && populate_pte_fn);
@@ -908,24 +908,24 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	for (i = 0; i < pcpu_nr_slots; i++)
 		INIT_LIST_HEAD(&pcpu_slot[i]);
 
-	/* init static_chunk */
-	static_chunk = alloc_bootmem(pcpu_chunk_struct_size);
-	INIT_LIST_HEAD(&static_chunk->list);
-	static_chunk->vm = &static_vm;
+	/* init static chunk */
+	schunk = alloc_bootmem(pcpu_chunk_struct_size);
+	INIT_LIST_HEAD(&schunk->list);
+	schunk->vm = &first_vm;
 
-	if (free_size)
-		static_chunk->free_size = free_size;
+	if (dyn_size)
+		schunk->free_size = dyn_size;
 	else
-		static_chunk->free_size = pcpu_unit_size - pcpu_static_size;
+		schunk->free_size = pcpu_unit_size - pcpu_static_size;
 
-	static_chunk->contig_hint = static_chunk->free_size;
+	schunk->contig_hint = schunk->free_size;
 
 	/* allocate vm address */
-	static_vm.flags = VM_ALLOC;
-	static_vm.size = pcpu_chunk_size;
+	first_vm.flags = VM_ALLOC;
+	first_vm.size = pcpu_chunk_size;
 
 	if (!base_addr)
-		vm_area_register_early(&static_vm, PAGE_SIZE);
+		vm_area_register_early(&first_vm, PAGE_SIZE);
 	else {
 		/*
 		 * Pages already mapped.  No need to remap into
@@ -933,8 +933,8 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 		 * be mapped or unmapped by percpu and is marked
 		 * immutable.
 		 */
-		static_vm.addr = base_addr;
-		static_chunk->immutable = true;
+		first_vm.addr = base_addr;
+		schunk->immutable = true;
 	}
 
 	/* assign pages */
@@ -945,7 +945,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 
 			if (!page)
 				break;
-			*pcpu_chunk_pagep(static_chunk, cpu, i) = page;
+			*pcpu_chunk_pagep(schunk, cpu, i) = page;
 		}
 
 		BUG_ON(i < PFN_UP(pcpu_static_size));
@@ -960,20 +960,20 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	if (populate_pte_fn) {
 		for_each_possible_cpu(cpu)
 			for (i = 0; i < nr_pages; i++)
-				populate_pte_fn(pcpu_chunk_addr(static_chunk,
+				populate_pte_fn(pcpu_chunk_addr(schunk,
 								cpu, i));
 
-		err = pcpu_map(static_chunk, 0, nr_pages);
+		err = pcpu_map(schunk, 0, nr_pages);
 		if (err)
 			panic("failed to setup static percpu area, err=%d\n",
 			      err);
 	}
 
-	/* link static_chunk in */
-	pcpu_chunk_relocate(static_chunk, -1);
-	pcpu_chunk_addr_insert(static_chunk);
+	/* link the first chunk in */
+	pcpu_chunk_relocate(schunk, -1);
+	pcpu_chunk_addr_insert(schunk);
 
 	/* we're done */
-	pcpu_base_addr = (void *)pcpu_chunk_addr(static_chunk, 0, 0);
+	pcpu_base_addr = (void *)pcpu_chunk_addr(schunk, 0, 0);
 	return pcpu_unit_size;
 }
-- 
1.6.0.2

