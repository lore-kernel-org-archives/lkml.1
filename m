Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZI2BDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZI2BDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZI2BDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:03:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:35460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbZI2BDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:03:46 -0400
Message-ID: <4AC15CE9.3030607@kernel.org>
Date: Tue, 29 Sep 2009 10:03:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Tony Vroon <tony@linx.net>,
       David Miller <davem@davemloft.net>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu fixes for 2.6.32-rc1
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 29 Sep 2009 01:03:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following percpu fix branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

Changes are

* pcpu_setup_first_chunk() bug which triggered spurious BUG_ON() on
  systems with non-power-of-two number of cpus fixed.

* pcpu_build_alloc_info() updated to clear static buffers so that it
  can be called multiple times in case it's called for fallbacks.
  This fixes falling back to page size first chunk allocator on x86.

* sparc64 page size first chunk allocator and auto-fallback
  implemented.  This fixes percpu allocation on systems where NUMA
  nodes are too far apart for the distance to be replicated in vmalloc
  area.  David Miller is working on proper fix to extend vmalloc area
  on sparc64.  Checking for the distance, warning and falling back
  should make percpu allocator more robust and proplems easier to
  track down.

* Init and alloc failures are made more verbose to help debugging.

Thanks.
---
Tejun Heo (6):
      percpu: fix unit_map[] verification in pcpu_setup_first_chunk()
      percpu: make pcpu_build_alloc_info() clear static buffers
      sparc64: implement page mapping percpu first chunk allocator
      percpu: make embedding first chunk allocator check vmalloc space size
      percpu: make pcpu_setup_first_chunk() failures more verbose
      percpu: make allocation failures more verbose

 arch/sparc/Kconfig         |    3 ++
 arch/sparc/kernel/smp_64.c |   53 +++++++++++++++++++++++-----
 mm/percpu.c                |   83 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 114 insertions(+), 25 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 97fca46..ac45aab 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -102,6 +102,9 @@ config HAVE_SETUP_PER_CPU_AREA
 config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool y if SPARC64

+config NEED_PER_CPU_PAGE_FIRST_CHUNK
+	def_bool y if SPARC64
+
 config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y if SPARC64
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index ff68373..aa36223 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1420,7 +1420,7 @@ static void __init pcpu_free_bootmem(void *ptr, size_t size)
 	free_bootmem(__pa(ptr), size);
 }

-static int pcpu_cpu_distance(unsigned int from, unsigned int to)
+static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
 	if (cpu_to_node(from) == cpu_to_node(to))
 		return LOCAL_DISTANCE;
@@ -1428,18 +1428,53 @@ static int pcpu_cpu_distance(unsigned int from, unsigned int to)
 		return REMOTE_DISTANCE;
 }

+static void __init pcpu_populate_pte(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud;
+	pmd_t *pmd;
+
+	pud = pud_offset(pgd, addr);
+	if (pud_none(*pud)) {
+		pmd_t *new;
+
+		new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
+		pud_populate(&init_mm, pud, new);
+	}
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd)) {
+		pte_t *new;
+
+		new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
+		pmd_populate_kernel(&init_mm, pmd, new);
+	}
+}
+
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
 	unsigned int cpu;
-	int rc;
-
-	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-				    PERCPU_DYNAMIC_RESERVE, 4 << 20,
-				    pcpu_cpu_distance, pcpu_alloc_bootmem,
-				    pcpu_free_bootmem);
-	if (rc)
-		panic("failed to initialize first chunk (%d)", rc);
+	int rc = -EINVAL;
+
+	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+					    PERCPU_DYNAMIC_RESERVE, 4 << 20,
+					    pcpu_cpu_distance,
+					    pcpu_alloc_bootmem,
+					    pcpu_free_bootmem);
+		if (rc)
+			pr_warning("PERCPU: %s allocator failed (%d), "
+				   "falling back to page size\n",
+				   pcpu_fc_names[pcpu_chosen_fc], rc);
+	}
+	if (rc < 0)
+		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
+					   pcpu_alloc_bootmem,
+					   pcpu_free_bootmem,
+					   pcpu_populate_pte);
+	if (rc < 0)
+		panic("cannot initialize percpu area (err=%d)", rc);

 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu)
diff --git a/mm/percpu.c b/mm/percpu.c
index 43d8cac..4a048ab 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1043,7 +1043,9 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
  */
 static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 {
+	static int warn_limit = 10;
 	struct pcpu_chunk *chunk;
+	const char *err;
 	int slot, off;

 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
@@ -1059,11 +1061,14 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
 		if (size > chunk->contig_hint ||
-		    pcpu_extend_area_map(chunk) < 0)
+		    pcpu_extend_area_map(chunk) < 0) {
+			err = "failed to extend area map of reserved chunk";
 			goto fail_unlock;
+		}
 		off = pcpu_alloc_area(chunk, size, align);
 		if (off >= 0)
 			goto area_found;
+		err = "alloc from reserved chunk failed";
 		goto fail_unlock;
 	}

@@ -1080,6 +1085,7 @@ restart:
 			case 1:
 				goto restart;	/* pcpu_lock dropped, restart */
 			default:
+				err = "failed to extend area map";
 				goto fail_unlock;
 			}

@@ -1093,8 +1099,10 @@ restart:
 	spin_unlock_irq(&pcpu_lock);

 	chunk = alloc_pcpu_chunk();
-	if (!chunk)
+	if (!chunk) {
+		err = "failed to allocate new chunk";
 		goto fail_unlock_mutex;
+	}

 	spin_lock_irq(&pcpu_lock);
 	pcpu_chunk_relocate(chunk, -1);
@@ -1107,6 +1115,7 @@ area_found:
 	if (pcpu_populate_chunk(chunk, off, size)) {
 		spin_lock_irq(&pcpu_lock);
 		pcpu_free_area(chunk, off);
+		err = "failed to populate";
 		goto fail_unlock;
 	}

@@ -1119,6 +1128,13 @@ fail_unlock:
 	spin_unlock_irq(&pcpu_lock);
 fail_unlock_mutex:
 	mutex_unlock(&pcpu_alloc_mutex);
+	if (warn_limit) {
+		pr_warning("PERCPU: allocation failed, size=%zu align=%zu, "
+			   "%s\n", size, align, err);
+		dump_stack();
+		if (!--warn_limit)
+			pr_info("PERCPU: limit reached, disable warning\n");
+	}
 	return NULL;
 }

@@ -1347,6 +1363,10 @@ struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 	struct pcpu_alloc_info *ai;
 	unsigned int *cpu_map;

+	/* this function may be called multiple times */
+	memset(group_map, 0, sizeof(group_map));
+	memset(group_cnt, 0, sizeof(group_map));
+
 	/*
 	 * Determine min_unit_size, alloc_size and max_upa such that
 	 * alloc_size is multiple of atom_size and is the smallest
@@ -1574,6 +1594,7 @@ static void pcpu_dump_alloc_info(const char *lvl,
 int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 				  void *base_addr)
 {
+	static char cpus_buf[4096] __initdata;
 	static int smap[2], dmap[2];
 	size_t dyn_size = ai->dyn_size;
 	size_t size_sum = ai->static_size + ai->reserved_size + dyn_size;
@@ -1585,17 +1606,26 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	int *unit_map;
 	int group, unit, i;

+	cpumask_scnprintf(cpus_buf, sizeof(cpus_buf), cpu_possible_mask);
+
+#define PCPU_SETUP_BUG_ON(cond)	do {					\
+	if (unlikely(cond)) {						\
+		pr_emerg("PERCPU: failed to initialize, %s", #cond);	\
+		pr_emerg("PERCPU: cpu_possible_mask=%s\n", cpus_buf);	\
+		pcpu_dump_alloc_info(KERN_EMERG, ai);			\
+		BUG();							\
+	}								\
+} while (0)
+
 	/* sanity checks */
 	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC ||
 		     ARRAY_SIZE(dmap) >= PCPU_DFL_MAP_ALLOC);
-	BUG_ON(ai->nr_groups <= 0);
-	BUG_ON(!ai->static_size);
-	BUG_ON(!base_addr);
-	BUG_ON(ai->unit_size < size_sum);
-	BUG_ON(ai->unit_size & ~PAGE_MASK);
-	BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);
-
-	pcpu_dump_alloc_info(KERN_DEBUG, ai);
+	PCPU_SETUP_BUG_ON(ai->nr_groups <= 0);
+	PCPU_SETUP_BUG_ON(!ai->static_size);
+	PCPU_SETUP_BUG_ON(!base_addr);
+	PCPU_SETUP_BUG_ON(ai->unit_size < size_sum);
+	PCPU_SETUP_BUG_ON(ai->unit_size & ~PAGE_MASK);
+	PCPU_SETUP_BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);

 	/* process group information and build config tables accordingly */
 	group_offsets = alloc_bootmem(ai->nr_groups * sizeof(group_offsets[0]));
@@ -1604,7 +1634,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	unit_off = alloc_bootmem(nr_cpu_ids * sizeof(unit_off[0]));

 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
-		unit_map[cpu] = NR_CPUS;
+		unit_map[cpu] = UINT_MAX;
 	pcpu_first_unit_cpu = NR_CPUS;

 	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
@@ -1618,8 +1648,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 			if (cpu == NR_CPUS)
 				continue;

-			BUG_ON(cpu > nr_cpu_ids || !cpu_possible(cpu));
-			BUG_ON(unit_map[cpu] != NR_CPUS);
+			PCPU_SETUP_BUG_ON(cpu > nr_cpu_ids);
+			PCPU_SETUP_BUG_ON(!cpu_possible(cpu));
+			PCPU_SETUP_BUG_ON(unit_map[cpu] != UINT_MAX);

 			unit_map[cpu] = unit + i;
 			unit_off[cpu] = gi->base_offset + i * ai->unit_size;
@@ -1632,7 +1663,11 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_nr_units = unit;

 	for_each_possible_cpu(cpu)
-		BUG_ON(unit_map[cpu] == NR_CPUS);
+		PCPU_SETUP_BUG_ON(unit_map[cpu] == UINT_MAX);
+
+	/* we're done parsing the input, undefine BUG macro and dump config */
+#undef PCPU_SETUP_BUG_ON
+	pcpu_dump_alloc_info(KERN_INFO, ai);

 	pcpu_nr_groups = ai->nr_groups;
 	pcpu_group_offsets = group_offsets;
@@ -1782,7 +1817,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
 	void *base = (void *)ULONG_MAX;
 	void **areas = NULL;
 	struct pcpu_alloc_info *ai;
-	size_t size_sum, areas_size;
+	size_t size_sum, areas_size, max_distance;
 	int group, i, rc;

 	ai = pcpu_build_alloc_info(reserved_size, dyn_size, atom_size,
@@ -1832,8 +1867,24 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
 	}

 	/* base address is now known, determine group base offsets */
-	for (group = 0; group < ai->nr_groups; group++)
+	max_distance = 0;
+	for (group = 0; group < ai->nr_groups; group++) {
 		ai->groups[group].base_offset = areas[group] - base;
+		max_distance = max(max_distance, ai->groups[group].base_offset);
+	}
+	max_distance += ai->unit_size;
+
+	/* warn if maximum distance is further than 75% of vmalloc space */
+	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
+		pr_warning("PERCPU: max_distance=0x%lx too large for vmalloc "
+			   "space 0x%lx\n",
+			   max_distance, VMALLOC_END - VMALLOC_START);
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+		/* and fail if we have fallback */
+		rc = -EINVAL;
+		goto out_free;
+#endif
+	}

 	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
 		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
