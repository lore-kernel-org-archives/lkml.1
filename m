Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZCFGsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZCFGsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbZCFGrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:56782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbZCFGrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:05 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] percpu: improve first chunk initial area map handling
Date: Fri,  6 Mar 2009 15:46:23 +0900
Message-Id: <1236321988-19457-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: no functional change

When the first chunk is created, its initial area map is not allocated
because kmalloc isn't online yet.  The map is allocated and
initialized on the first allocation request on the chunk.  This works
fine but the scattering of initialization logic between the init
function and allocation path is a bit confusing.

This patch makes the first chunk initialize and use minimal statically
allocated map from pcpu_setpu_first_chunk().  The map resizing path
still needs to handle this specially but it's more straight-forward
and gives more latitude to the init path.  This will ease future
changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |   53 +++++++++++++++++++++++++++--------------------------
 1 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 9531590..503ccad 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -93,9 +93,6 @@ static size_t pcpu_chunk_struct_size __read_mostly;
 void *pcpu_base_addr __read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
-/* the size of kernel static area */
-static int pcpu_static_size __read_mostly;
-
 /*
  * One mutex to rule them all.
  *
@@ -316,15 +313,28 @@ static int pcpu_split_block(struct pcpu_chunk *chunk, int i, int head, int tail)
 
 	/* reallocation required? */
 	if (chunk->map_alloc < target) {
-		int new_alloc = chunk->map_alloc;
+		int new_alloc;
 		int *new;
 
+		new_alloc = PCPU_DFL_MAP_ALLOC;
 		while (new_alloc < target)
 			new_alloc *= 2;
 
-		new = pcpu_realloc(chunk->map,
-				   chunk->map_alloc * sizeof(new[0]),
-				   new_alloc * sizeof(new[0]));
+		if (chunk->map_alloc < PCPU_DFL_MAP_ALLOC) {
+			/*
+			 * map_alloc smaller than the default size
+			 * indicates that the chunk is one of the
+			 * first chunks and still using static map.
+			 * Allocate a dynamic one and copy.
+			 */
+			new = pcpu_realloc(NULL, 0, new_alloc * sizeof(new[0]));
+			if (new)
+				memcpy(new, chunk->map,
+				       chunk->map_alloc * sizeof(new[0]));
+		} else
+			new = pcpu_realloc(chunk->map,
+					   chunk->map_alloc * sizeof(new[0]),
+					   new_alloc * sizeof(new[0]));
 		if (!new)
 			return -ENOMEM;
 
@@ -367,22 +377,6 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 	int max_contig = 0;
 	int i, off;
 
-	/*
-	 * The static chunk initially doesn't have map attached
-	 * because kmalloc wasn't available during init.  Give it one.
-	 */
-	if (unlikely(!chunk->map)) {
-		chunk->map = pcpu_realloc(NULL, 0,
-				PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
-		if (!chunk->map)
-			return -ENOMEM;
-
-		chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
-		chunk->map[chunk->map_used++] = -pcpu_static_size;
-		if (chunk->free_size)
-			chunk->map[chunk->map_used++] = chunk->free_size;
-	}
-
 	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++])) {
 		bool is_last = i + 1 == chunk->map_used;
 		int head, tail;
@@ -874,12 +868,14 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				     pcpu_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct first_vm;
+	static int smap[2];
 	struct pcpu_chunk *schunk;
 	unsigned int cpu;
 	int nr_pages;
 	int err, i;
 
 	/* santiy checks */
+	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC);
 	BUG_ON(!static_size);
 	BUG_ON(!unit_size && dyn_size);
 	BUG_ON(unit_size && unit_size < static_size + dyn_size);
@@ -893,7 +889,6 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 		pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_SIZE >> PAGE_SHIFT,
 					PFN_UP(static_size));
 
-	pcpu_static_size = static_size;
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
@@ -912,14 +907,20 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	schunk = alloc_bootmem(pcpu_chunk_struct_size);
 	INIT_LIST_HEAD(&schunk->list);
 	schunk->vm = &first_vm;
+	schunk->map = smap;
+	schunk->map_alloc = ARRAY_SIZE(smap);
 
 	if (dyn_size)
 		schunk->free_size = dyn_size;
 	else
-		schunk->free_size = pcpu_unit_size - pcpu_static_size;
+		schunk->free_size = pcpu_unit_size - static_size;
 
 	schunk->contig_hint = schunk->free_size;
 
+	schunk->map[schunk->map_used++] = -static_size;
+	if (schunk->free_size)
+		schunk->map[schunk->map_used++] = schunk->free_size;
+
 	/* allocate vm address */
 	first_vm.flags = VM_ALLOC;
 	first_vm.size = pcpu_chunk_size;
@@ -948,7 +949,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 			*pcpu_chunk_pagep(schunk, cpu, i) = page;
 		}
 
-		BUG_ON(i < PFN_UP(pcpu_static_size));
+		BUG_ON(i < PFN_UP(static_size));
 
 		if (nr_pages < 0)
 			nr_pages = i;
-- 
1.6.0.2

