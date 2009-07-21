Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZGUKaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZGUKaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZGUK2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbZGUK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:58 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 17/20] x86,percpu: use embedding for 64bit NUMA and page for 32bit NUMA
Date: Tue, 21 Jul 2009 19:26:16 +0900
Message-Id: <1248171979-29166-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:27:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Embedding percpu first chunk allocator can now handle very sparse unit
mapping.  Use embedding allocator instead of lpage for 64bit NUMA.
This removes extra TLB pressure and the need to do complex and fragile
dancing when changing page attributes.

For 32bit, using very sparse unit mapping isn't a good idea because
the vmalloc space is very constrained.  32bit NUMA machines aren't
exactly the focus of optimization and it isn't very clear whether
lpage performs better than page.  Use page first chunk allocator for
32bit NUMAs.

As this leaves setup_pcpu_*() functions pretty much empty, fold them
into setup_per_cpu_areas().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/Kconfig               |    4 -
 arch/x86/kernel/setup_percpu.c |  155 +++++++--------------------------------
 2 files changed, 28 insertions(+), 131 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5c0a3b4..96d2044 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -155,10 +155,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
 config NEED_PER_CPU_PAGE_FIRST_CHUNK
 	def_bool y
 
-config NEED_PER_CPU_LPAGE_FIRST_CHUNK
-	def_bool y
-	depends on NEED_MULTIPLE_NODES
-
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5b03d7e..4aff7a5 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -55,6 +55,7 @@ EXPORT_SYMBOL(__per_cpu_offset);
 #define PERCPU_FIRST_CHUNK_RESERVE	0
 #endif
 
+#ifdef CONFIG_X86_32
 /**
  * pcpu_need_numa - determine percpu allocation needs to consider NUMA
  *
@@ -83,6 +84,7 @@ static bool __init pcpu_need_numa(void)
 #endif
 	return false;
 }
+#endif
 
 /**
  * pcpu_alloc_bootmem - NUMA friendly alloc_bootmem wrapper for percpu
@@ -136,128 +138,23 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
 	free_bootmem(__pa(ptr), size);
 }
 
-/*
- * Large page remapping allocator
- */
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-static void __init pcpul_map(void *ptr, size_t size, void *addr)
-{
-	pmd_t *pmd, pmd_v;
-
-	pmd = populate_extra_pmd((unsigned long)addr);
-	pmd_v = pfn_pmd(page_to_pfn(virt_to_page(ptr)), PAGE_KERNEL_LARGE);
-	set_pmd(pmd, pmd_v);
-}
-
-static int pcpu_lpage_cpu_distance(unsigned int from, unsigned int to)
+static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 	if (early_cpu_to_node(from) == early_cpu_to_node(to))
 		return LOCAL_DISTANCE;
 	else
 		return REMOTE_DISTANCE;
-}
-
-static int __init setup_pcpu_lpage(bool chosen)
-{
-	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
-	size_t dyn_size = reserve - PERCPU_FIRST_CHUNK_RESERVE;
-	struct pcpu_alloc_info *ai;
-	int rc;
-
-	/* on non-NUMA, embedding is better */
-	if (!chosen && !pcpu_need_numa())
-		return -EINVAL;
-
-	/* need PSE */
-	if (!cpu_has_pse) {
-		pr_warning("PERCPU: lpage allocator requires PSE\n");
-		return -EINVAL;
-	}
-
-	/* allocate and build unit_map */
-	ai = pcpu_build_alloc_info(PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
-				   PMD_SIZE, pcpu_lpage_cpu_distance);
-	if (IS_ERR(ai)) {
-		pr_warning("PERCPU: failed to build unit_map (%ld)\n",
-			   PTR_ERR(ai));
-		return PTR_ERR(ai);
-	}
-
-	/* do the parameters look okay? */
-	if (!chosen) {
-		size_t vm_size = VMALLOC_END - VMALLOC_START;
-		size_t tot_size = 0;
-		int group;
-
-		for (group = 0; group < ai->nr_groups; group++)
-			tot_size += ai->unit_size * ai->groups[group].nr_units;
-
-		/* don't consume more than 20% of vmalloc area */
-		if (tot_size > vm_size / 5) {
-			pr_info("PERCPU: too large chunk size %zuMB for "
-				"large page remap\n", tot_size >> 20);
-			rc = -EINVAL;
-			goto out_free;
-		}
-	}
-
-	rc = pcpu_lpage_first_chunk(ai, pcpu_fc_alloc, pcpu_fc_free, pcpul_map);
-out_free:
-	pcpu_free_alloc_info(ai);
-	return rc;
-}
 #else
-static int __init setup_pcpu_lpage(bool chosen)
-{
-	return -EINVAL;
-}
+	return LOCAL_DISTANCE;
 #endif
-
-/*
- * Embedding allocator
- *
- * The first chunk is sized to just contain the static area plus
- * module and dynamic reserves and embedded into linear physical
- * mapping so that it can use PMD mapping without additional TLB
- * pressure.
- */
-static int __init setup_pcpu_embed(bool chosen)
-{
-	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
-
-	/*
-	 * If large page isn't supported, there's no benefit in doing
-	 * this.  Also, embedding allocation doesn't play well with
-	 * NUMA.
-	 */
-	if (!chosen && (!cpu_has_pse || pcpu_need_numa()))
-		return -EINVAL;
-
-	return pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
-				      reserve - PERCPU_FIRST_CHUNK_RESERVE,
-				      PAGE_SIZE, NULL, pcpu_fc_alloc,
-				      pcpu_fc_free);
 }
 
-/*
- * Page allocator
- *
- * Boring fallback 4k page allocator.  This allocator puts more
- * pressure on PTE TLBs but other than that behaves nicely on both UMA
- * and NUMA.
- */
 static void __init pcpup_populate_pte(unsigned long addr)
 {
 	populate_extra_pte(addr);
 }
 
-static int __init setup_pcpu_page(void)
-{
-	return pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
-				     pcpu_fc_alloc, pcpu_fc_free,
-				     pcpup_populate_pte);
-}
-
 static inline void setup_percpu_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
@@ -281,30 +178,34 @@ void __init setup_per_cpu_areas(void)
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
 
 	/*
-	 * Allocate percpu area.  If PSE is supported, try to make use
-	 * of large page mappings.  Please read comments on top of
-	 * each allocator for details.
+	 * Allocate percpu area.  Embedding allocator is our favorite;
+	 * however, on NUMA configurations, it can result in very
+	 * sparse unit mapping and vmalloc area isn't spacious enough
+	 * on 32bit.  Use page in that case.
 	 */
+#ifdef CONFIG_X86_32
+	if (pcpu_chosen_fc == PCPU_FC_AUTO && pcpu_need_numa())
+		pcpu_chosen_fc = PCPU_FC_PAGE;
+#endif
 	rc = -EINVAL;
-	if (pcpu_chosen_fc != PCPU_FC_AUTO) {
-		if (pcpu_chosen_fc != PCPU_FC_PAGE) {
-			if (pcpu_chosen_fc == PCPU_FC_LPAGE)
-				rc = setup_pcpu_lpage(true);
-			else
-				rc = setup_pcpu_embed(true);
-
-			if (rc < 0)
-				pr_warning("PERCPU: %s allocator failed (%d), "
-					   "falling back to page\n",
-					   pcpu_fc_names[pcpu_chosen_fc], rc);
-		}
-	} else {
-		rc = setup_pcpu_lpage(false);
+	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+		const size_t atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
+		const size_t dyn_size = PERCPU_MODULE_RESERVE +
+			PERCPU_DYNAMIC_RESERVE - PERCPU_FIRST_CHUNK_RESERVE;
+
+		rc = pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
+					    dyn_size, atom_size,
+					    pcpu_cpu_distance,
+					    pcpu_fc_alloc, pcpu_fc_free);
 		if (rc < 0)
-			rc = setup_pcpu_embed(false);
+			pr_warning("PERCPU: %s allocator failed (%d), "
+				   "falling back to page\n",
+				   pcpu_fc_names[pcpu_chosen_fc], rc);
 	}
 	if (rc < 0)
-		rc = setup_pcpu_page();
+		rc = pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
+					   pcpu_fc_alloc, pcpu_fc_free,
+					   pcpup_populate_pte);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
 
-- 
1.6.0.2

