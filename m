Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZGUK1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZGUK1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZGUK1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:27:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:36973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbZGUK1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/20] percpu: update embedding first chunk allocator to handle sparse units
Date: Tue, 21 Jul 2009 19:26:15 +0900
Message-Id: <1248171979-29166-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that percpu core can handle very sparse units, given that vmalloc
space is large enough, embedding first chunk allocator can use any
memory to build the first chunk.  This patch teaches
pcpu_embed_first_chunk() about distances between cpus and to use
alloc/free callbacks to allocate node specific areas for each group
and use them for the first chunk.

This brings the benefits of embedding allocator to NUMA configurations
- no extra TLB pressure with the flexibility of unified dynamic
allocator and no need to restructure arch code to build memory layout
suitable for percpu.  With units put into atom_size aligned groups
according to cpu distances, using large page for dynamic chunks is
also easily possible with falling back to reuglar pages if large
allocation fails.

Embedding allocator users are converted to specify NULL
cpu_distance_fn, so this patch doesn't cause any visible behavior
difference.  Following patches will convert them.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |    4 +-
 include/linux/percpu.h         |    7 ++-
 mm/percpu.c                    |  113 ++++++++++++++++++++++++++++++----------
 3 files changed, 93 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 477d2de..5b03d7e 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -234,7 +234,9 @@ static int __init setup_pcpu_embed(bool chosen)
 		return -EINVAL;
 
 	return pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
-				      reserve - PERCPU_FIRST_CHUNK_RESERVE);
+				      reserve - PERCPU_FIRST_CHUNK_RESERVE,
+				      PAGE_SIZE, NULL, pcpu_fc_alloc,
+				      pcpu_fc_free);
 }
 
 /*
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a7ec840..2535993 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -110,8 +110,11 @@ extern int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 					 void *base_addr);
 
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
-extern int __init pcpu_embed_first_chunk(size_t reserved_size,
-					 ssize_t dyn_size);
+extern int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
+				size_t atom_size,
+				pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
+				pcpu_fc_alloc_fn_t alloc_fn,
+				pcpu_fc_free_fn_t free_fn);
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
diff --git a/mm/percpu.c b/mm/percpu.c
index cc9c4c6..c2826d0 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1747,15 +1747,25 @@ early_param("percpu_alloc", percpu_alloc_setup);
  * pcpu_embed_first_chunk - embed the first percpu chunk into bootmem
  * @reserved_size: the size of reserved percpu area in bytes
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
+ * @atom_size: allocation atom size
+ * @cpu_distance_fn: callback to determine distance between cpus, optional
+ * @alloc_fn: function to allocate percpu page
+ * @free_fn: funtion to free percpu page
  *
  * This is a helper to ease setting up embedded first percpu chunk and
  * can be called where pcpu_setup_first_chunk() is expected.
  *
  * If this function is used to setup the first chunk, it is allocated
- * as a contiguous area using bootmem allocator and used as-is without
- * being mapped into vmalloc area.  This enables the first chunk to
- * piggy back on the linear physical mapping which often uses larger
- * page size.
+ * by calling @alloc_fn and used as-is without being mapped into
+ * vmalloc area.  Allocations are always whole multiples of @atom_size
+ * aligned to @atom_size.
+ *
+ * This enables the first chunk to piggy back on the linear physical
+ * mapping which often uses larger page size.  Please note that this
+ * can result in very sparse cpu->unit mapping on NUMA machines thus
+ * requiring large vmalloc address space.  Don't use this allocator if
+ * vmalloc space is not orders of magnitude larger than distances
+ * between node memory addresses (ie. 32bit NUMA machines).
  *
  * When @dyn_size is positive, dynamic area might be larger than
  * specified to fill page alignment.  When @dyn_size is auto,
@@ -1763,53 +1773,88 @@ early_param("percpu_alloc", percpu_alloc_setup);
  * and reserved areas.
  *
  * If the needed size is smaller than the minimum or specified unit
- * size, the leftover is returned to the bootmem allocator.
+ * size, the leftover is returned using @free_fn.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size)
+int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
+				  size_t atom_size,
+				  pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
+				  pcpu_fc_alloc_fn_t alloc_fn,
+				  pcpu_fc_free_fn_t free_fn)
 {
+	void *base = (void *)ULONG_MAX;
+	void **areas = NULL;
 	struct pcpu_alloc_info *ai;
-	size_t size_sum, chunk_size;
-	void *base;
-	int unit;
-	int rc;
+	size_t size_sum, areas_size;
+	int group, i, rc;
 
-	ai = pcpu_build_alloc_info(reserved_size, dyn_size, PAGE_SIZE, NULL);
+	ai = pcpu_build_alloc_info(reserved_size, dyn_size, atom_size,
+				   cpu_distance_fn);
 	if (IS_ERR(ai))
 		return PTR_ERR(ai);
-	BUG_ON(ai->nr_groups != 1);
-	BUG_ON(ai->groups[0].nr_units != num_possible_cpus());
 
 	size_sum = ai->static_size + ai->reserved_size + ai->dyn_size;
-	chunk_size = ai->unit_size * num_possible_cpus();
+	areas_size = PFN_ALIGN(ai->nr_groups * sizeof(void *));
 
-	base = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
-				       __pa(MAX_DMA_ADDRESS));
-	if (!base) {
-		pr_warning("PERCPU: failed to allocate %zu bytes for "
-			   "embedding\n", chunk_size);
+	areas = alloc_bootmem_nopanic(areas_size);
+	if (!areas) {
 		rc = -ENOMEM;
-		goto out_free_ai;
+		goto out_free;
 	}
 
-	/* return the leftover and copy */
-	for (unit = 0; unit < num_possible_cpus(); unit++) {
-		void *ptr = base + unit * ai->unit_size;
+	/* allocate, copy and determine base address */
+	for (group = 0; group < ai->nr_groups; group++) {
+		struct pcpu_group_info *gi = &ai->groups[group];
+		unsigned int cpu = NR_CPUS;
+		void *ptr;
+
+		for (i = 0; i < gi->nr_units && cpu == NR_CPUS; i++)
+			cpu = gi->cpu_map[i];
+		BUG_ON(cpu == NR_CPUS);
+
+		/* allocate space for the whole group */
+		ptr = alloc_fn(cpu, gi->nr_units * ai->unit_size, atom_size);
+		if (!ptr) {
+			rc = -ENOMEM;
+			goto out_free_areas;
+		}
+		areas[group] = ptr;
 
-		free_bootmem(__pa(ptr + size_sum), ai->unit_size - size_sum);
-		memcpy(ptr, __per_cpu_load, ai->static_size);
+		base = min(ptr, base);
+
+		for (i = 0; i < gi->nr_units; i++, ptr += ai->unit_size) {
+			if (gi->cpu_map[i] == NR_CPUS) {
+				/* unused unit, free whole */
+				free_fn(ptr, ai->unit_size);
+				continue;
+			}
+			/* copy and return the unused part */
+			memcpy(ptr, __per_cpu_load, ai->static_size);
+			free_fn(ptr + size_sum, ai->unit_size - size_sum);
+		}
 	}
 
-	/* we're ready, commit */
+	/* base address is now known, determine group base offsets */
+	for (group = 0; group < ai->nr_groups; group++)
+		ai->groups[group].base_offset = areas[group] - base;
+
 	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
 		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
 
 	rc = pcpu_setup_first_chunk(ai, base);
-out_free_ai:
+	goto out_free;
+
+out_free_areas:
+	for (group = 0; group < ai->nr_groups; group++)
+		free_fn(areas[group],
+			ai->groups[group].nr_units * ai->unit_size);
+out_free:
 	pcpu_free_alloc_info(ai);
+	if (areas)
+		free_bootmem(__pa(areas), areas_size);
 	return rc;
 }
 #endif /* CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK ||
@@ -2177,6 +2222,17 @@ void *pcpu_lpage_remapped(void *kaddr)
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
 
+static void * __init pcpu_dfl_fc_alloc(unsigned int cpu, size_t size,
+				       size_t align)
+{
+	return __alloc_bootmem_nopanic(size, align, __pa(MAX_DMA_ADDRESS));
+}
+
+static void __init pcpu_dfl_fc_free(void *ptr, size_t size)
+{
+	free_bootmem(__pa(ptr), size);
+}
+
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
@@ -2188,7 +2244,8 @@ void __init setup_per_cpu_areas(void)
 	 * what the legacy allocator did.
 	 */
 	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-				    PERCPU_DYNAMIC_RESERVE);
+				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE, NULL,
+				    pcpu_dfl_fc_alloc, pcpu_dfl_fc_free);
 	if (rc < 0)
 		panic("Failed to initialized percpu areas.");
 
-- 
1.6.0.2

