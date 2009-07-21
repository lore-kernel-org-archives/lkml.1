Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZGUK2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZGUK2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZGUK2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:37000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbZGUK1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:53 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/20] percpu: drop @static_size from first chunk allocators
Date: Tue, 21 Jul 2009 19:26:05 +0900
Message-Id: <1248171979-29166-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First chunk allocators assume percpu areas have been linked using one
of PERCPU_*() macros and depend on __per_cpu_load symbol defined by
those macros, so there isn't much point in passing in static area size
explicitly when it can be easily calculated from __per_cpu_start and
__per_cpu_end.  Drop @static_size from all percpu first chunk
allocators and helpers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   34 +++++++++++++++-------------------
 include/linux/percpu.h         |   18 ++++++++----------
 mm/percpu.c                    |   29 +++++++++++++----------------
 3 files changed, 36 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 7f1e09b..b0e7ac4 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -157,7 +157,7 @@ static int pcpu_lpage_cpu_distance(unsigned int from, unsigned int to)
 		return REMOTE_DISTANCE;
 }
 
-static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
+static ssize_t __init setup_pcpu_lpage(bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 	size_t dyn_size = reserve - PERCPU_FIRST_CHUNK_RESERVE;
@@ -184,8 +184,7 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 		return -ENOMEM;
 	}
 
-	ret = pcpu_lpage_build_unit_map(static_size,
-					PERCPU_FIRST_CHUNK_RESERVE,
+	ret = pcpu_lpage_build_unit_map(PERCPU_FIRST_CHUNK_RESERVE,
 					&dyn_size, &unit_size, PMD_SIZE,
 					unit_map, pcpu_lpage_cpu_distance);
 	if (ret < 0) {
@@ -208,9 +207,8 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 		}
 	}
 
-	ret = pcpu_lpage_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
-				     dyn_size, unit_size, PMD_SIZE,
-				     unit_map, nr_units,
+	ret = pcpu_lpage_first_chunk(PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
+				     unit_size, PMD_SIZE, unit_map, nr_units,
 				     pcpu_fc_alloc, pcpu_fc_free, pcpul_map);
 out_free:
 	if (ret < 0)
@@ -218,7 +216,7 @@ out_free:
 	return ret;
 }
 #else
-static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
+static ssize_t __init setup_pcpu_lpage(bool chosen)
 {
 	return -EINVAL;
 }
@@ -232,7 +230,7 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
  * mapping so that it can use PMD mapping without additional TLB
  * pressure.
  */
-static ssize_t __init setup_pcpu_embed(size_t static_size, bool chosen)
+static ssize_t __init setup_pcpu_embed(bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 
@@ -244,7 +242,7 @@ static ssize_t __init setup_pcpu_embed(size_t static_size, bool chosen)
 	if (!chosen && (!cpu_has_pse || pcpu_need_numa()))
 		return -EINVAL;
 
-	return pcpu_embed_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
+	return pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 				      reserve - PERCPU_FIRST_CHUNK_RESERVE);
 }
 
@@ -260,9 +258,9 @@ static void __init pcpup_populate_pte(unsigned long addr)
 	populate_extra_pte(addr);
 }
 
-static ssize_t __init setup_pcpu_page(size_t static_size)
+static ssize_t __init setup_pcpu_page(void)
 {
-	return pcpu_page_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
+	return pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 				     pcpu_fc_alloc, pcpu_fc_free,
 				     pcpup_populate_pte);
 }
@@ -282,7 +280,6 @@ static inline void setup_percpu_segment(int cpu)
 
 void __init setup_per_cpu_areas(void)
 {
-	size_t static_size = __per_cpu_end - __per_cpu_start;
 	unsigned int cpu;
 	unsigned long delta;
 	size_t pcpu_unit_size;
@@ -300,9 +297,9 @@ void __init setup_per_cpu_areas(void)
 	if (pcpu_chosen_fc != PCPU_FC_AUTO) {
 		if (pcpu_chosen_fc != PCPU_FC_PAGE) {
 			if (pcpu_chosen_fc == PCPU_FC_LPAGE)
-				ret = setup_pcpu_lpage(static_size, true);
+				ret = setup_pcpu_lpage(true);
 			else
-				ret = setup_pcpu_embed(static_size, true);
+				ret = setup_pcpu_embed(true);
 
 			if (ret < 0)
 				pr_warning("PERCPU: %s allocator failed (%zd), "
@@ -310,15 +307,14 @@ void __init setup_per_cpu_areas(void)
 					   pcpu_fc_names[pcpu_chosen_fc], ret);
 		}
 	} else {
-		ret = setup_pcpu_lpage(static_size, false);
+		ret = setup_pcpu_lpage(false);
 		if (ret < 0)
-			ret = setup_pcpu_embed(static_size, false);
+			ret = setup_pcpu_embed(false);
 	}
 	if (ret < 0)
-		ret = setup_pcpu_page(static_size);
+		ret = setup_pcpu_page();
 	if (ret < 0)
-		panic("cannot allocate static percpu area (%zu bytes, err=%zd)",
-		      static_size, ret);
+		panic("cannot initialize percpu area (err=%zd)", ret);
 
 	pcpu_unit_size = ret;
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9be05cb..be2fc8f 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -84,13 +84,12 @@ extern size_t __init pcpu_setup_first_chunk(
 
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
 extern ssize_t __init pcpu_embed_first_chunk(
-				size_t static_size, size_t reserved_size,
-				ssize_t dyn_size);
+				size_t reserved_size, ssize_t dyn_size);
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 extern ssize_t __init pcpu_page_first_chunk(
-				size_t static_size, size_t reserved_size,
+				size_t reserved_size,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
@@ -98,16 +97,15 @@ extern ssize_t __init pcpu_page_first_chunk(
 
 #ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
 extern int __init pcpu_lpage_build_unit_map(
-				size_t static_size, size_t reserved_size,
-				ssize_t *dyn_sizep, size_t *unit_sizep,
-				size_t lpage_size, int *unit_map,
+				size_t reserved_size, ssize_t *dyn_sizep,
+				size_t *unit_sizep, size_t lpage_size,
+				int *unit_map,
 				pcpu_fc_cpu_distance_fn_t cpu_distance_fn);
 
 extern ssize_t __init pcpu_lpage_first_chunk(
-				size_t static_size, size_t reserved_size,
-				size_t dyn_size, size_t unit_size,
-				size_t lpage_size, const int *unit_map,
-				int nr_units,
+				size_t reserved_size, size_t dyn_size,
+				size_t unit_size, size_t lpage_size,
+				const int *unit_map, int nr_units,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_map_fn_t map_fn);
diff --git a/mm/percpu.c b/mm/percpu.c
index 6617020..e9f45ab 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1464,7 +1464,6 @@ static inline size_t pcpu_calc_fc_sizes(size_t static_size,
 	!defined(CONFIG_HAVE_SETUP_PER_CPU_AREA)
 /**
  * pcpu_embed_first_chunk - embed the first percpu chunk into bootmem
- * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
  *
@@ -1489,9 +1488,9 @@ static inline size_t pcpu_calc_fc_sizes(size_t static_size,
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access on success, -errno on failure.
  */
-ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
-				      ssize_t dyn_size)
+ssize_t __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size)
 {
+	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	size_t size_sum, unit_size, chunk_size;
 	void *base;
 	unsigned int cpu;
@@ -1536,7 +1535,6 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 /**
  * pcpu_page_first_chunk - map the first chunk using PAGE_SIZE pages
- * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
  * @alloc_fn: function to allocate percpu page, always called with PAGE_SIZE
  * @free_fn: funtion to free percpu page, always called with PAGE_SIZE
@@ -1552,12 +1550,13 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access on success, -errno on failure.
  */
-ssize_t __init pcpu_page_first_chunk(size_t static_size, size_t reserved_size,
+ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 				     pcpu_fc_alloc_fn_t alloc_fn,
 				     pcpu_fc_free_fn_t free_fn,
 				     pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct vm;
+	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	char psize_str[16];
 	int unit_pages;
 	size_t pages_size;
@@ -1641,7 +1640,6 @@ out_free_ar:
 #ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
 /**
  * pcpu_lpage_build_unit_map - build unit_map for large page remapping
- * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
  * @dyn_sizep: in/out parameter for dynamic size, -1 for auto
  * @unit_sizep: out parameter for unit size
@@ -1661,13 +1659,14 @@ out_free_ar:
  * On success, fills in @unit_map, sets *@dyn_sizep, *@unit_sizep and
  * returns the number of units to be allocated.  -errno on failure.
  */
-int __init pcpu_lpage_build_unit_map(size_t static_size, size_t reserved_size,
-				     ssize_t *dyn_sizep, size_t *unit_sizep,
-				     size_t lpage_size, int *unit_map,
+int __init pcpu_lpage_build_unit_map(size_t reserved_size, ssize_t *dyn_sizep,
+				     size_t *unit_sizep, size_t lpage_size,
+				     int *unit_map,
 				     pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
 {
 	static int group_map[NR_CPUS] __initdata;
 	static int group_cnt[NR_CPUS] __initdata;
+	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	int group_cnt_max = 0;
 	size_t size_sum, min_unit_size, alloc_size;
 	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
@@ -1819,7 +1818,6 @@ static void __init pcpul_lpage_dump_cfg(const char *lvl, size_t static_size,
 
 /**
  * pcpu_lpage_first_chunk - remap the first percpu chunk using large page
- * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
  * @dyn_size: free size for dynamic allocation in bytes
  * @unit_size: unit size in bytes
@@ -1850,15 +1848,15 @@ static void __init pcpul_lpage_dump_cfg(const char *lvl, size_t static_size,
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access on success, -errno on failure.
  */
-ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
-				      size_t dyn_size, size_t unit_size,
-				      size_t lpage_size, const int *unit_map,
-				      int nr_units,
+ssize_t __init pcpu_lpage_first_chunk(size_t reserved_size, size_t dyn_size,
+				      size_t unit_size, size_t lpage_size,
+				      const int *unit_map, int nr_units,
 				      pcpu_fc_alloc_fn_t alloc_fn,
 				      pcpu_fc_free_fn_t free_fn,
 				      pcpu_fc_map_fn_t map_fn)
 {
 	static struct vm_struct vm;
+	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	size_t chunk_size = unit_size * nr_units;
 	size_t map_size;
 	unsigned int cpu;
@@ -2037,7 +2035,6 @@ EXPORT_SYMBOL(__per_cpu_offset);
 
 void __init setup_per_cpu_areas(void)
 {
-	size_t static_size = __per_cpu_end - __per_cpu_start;
 	ssize_t unit_size;
 	unsigned long delta;
 	unsigned int cpu;
@@ -2046,7 +2043,7 @@ void __init setup_per_cpu_areas(void)
 	 * Always reserve area for module percpu variables.  That's
 	 * what the legacy allocator did.
 	 */
-	unit_size = pcpu_embed_first_chunk(static_size, PERCPU_MODULE_RESERVE,
+	unit_size = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
 					   PERCPU_DYNAMIC_RESERVE);
 	if (unit_size < 0)
 		panic("Failed to initialized percpu areas.");
-- 
1.6.0.2

