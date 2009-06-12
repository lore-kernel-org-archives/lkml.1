Return-Path: <linux-kernel-owner+w=401wt.eu-S1764762AbZFLQQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764762AbZFLQQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZFLQQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:16:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46150 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbZFLQQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:16:30 -0400
Date: Fri, 12 Jun 2009 19:16:30 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I dropped the GFP_WAIT conversion patch and added the gfp masking patch 
you liked. I tested this on x86-64 with both SLAB and SLUB.

			Pekka

The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 topic/slab/earlyboot-v2

KAMEZAWA Hiroyuki (1):
      memcg: fix page_cgroup fatal error in FLATMEM

Pekka Enberg (3):
      slab: fix gfp flag in setup_cpu_cache()
      slab,slub: don't enable interrupts during early boot
      slab: setup cpu caches later on when interrupts are enabled

Yinghai Lu (2):
      irq: slab alloc for default irq_affinity
      x86: make zap_low_mapping could be used early

 arch/x86/include/asm/tlbflush.h |    2 +-
 arch/x86/kernel/smpboot.c       |    2 +-
 arch/x86/mm/init_32.c           |   10 ++++++--
 include/linux/gfp.h             |    3 ++
 include/linux/page_cgroup.h     |   18 ++++++++++++++++-
 include/linux/slab.h            |    2 +
 include/linux/slob_def.h        |    5 ++++
 include/linux/slub_def.h        |    2 +
 init/main.c                     |    6 +++++
 kernel/irq/handle.c             |    2 +-
 mm/page_cgroup.c                |   29 +++++++++------------------
 mm/slab.c                       |   41 ++++++++++++++++++++++++++++----------
 mm/slub.c                       |   16 +++++++++++++++
 13 files changed, 101 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index a5ecc9c..7f3eba0 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -172,6 +172,6 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 	flush_tlb_all();
 }
 
-extern void zap_low_mappings(void);
+extern void zap_low_mappings(bool early);
 
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7c80007..2fecda6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -873,7 +873,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	err = do_boot_cpu(apicid, cpu);
 
-	zap_low_mappings();
+	zap_low_mappings(false);
 	low_mappings = 0;
 #else
 	err = do_boot_cpu(apicid, cpu);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 949708d..9ff3c08 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -564,7 +564,7 @@ static inline void save_pg_dir(void)
 }
 #endif /* !CONFIG_ACPI_SLEEP */
 
-void zap_low_mappings(void)
+void zap_low_mappings(bool early)
 {
 	int i;
 
@@ -581,7 +581,11 @@ void zap_low_mappings(void)
 		set_pgd(swapper_pg_dir+i, __pgd(0));
 #endif
 	}
-	flush_tlb_all();
+
+	if (early)
+		__flush_tlb();
+	else
+		flush_tlb_all();
 }
 
 pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
@@ -956,7 +960,7 @@ void __init mem_init(void)
 		test_wp_bit();
 
 	save_pg_dir();
-	zap_low_mappings();
+	zap_low_mappings(true);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0bbc15f..3760e7c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -85,6 +85,9 @@ struct vm_area_struct;
 			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
 			__GFP_NORETRY|__GFP_NOMEMALLOC)
 
+/* Control slab gfp mask during early boot */
+#define SLAB_GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS)
+
 /* Control allocation constraints */
 #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
 
diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 7339c7b..13f126c 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -18,7 +18,19 @@ struct page_cgroup {
 };
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
-void __init page_cgroup_init(void);
+
+#ifdef CONFIG_SPARSEMEM
+static inline void __init page_cgroup_init_flatmem(void)
+{
+}
+extern void __init page_cgroup_init(void);
+#else
+void __init page_cgroup_init_flatmem(void);
+static inline void __init page_cgroup_init(void)
+{
+}
+#endif
+
 struct page_cgroup *lookup_page_cgroup(struct page *page);
 
 enum {
@@ -87,6 +99,10 @@ static inline void page_cgroup_init(void)
 {
 }
 
+static inline void __init page_cgroup_init_flatmem(void)
+{
+}
+
 #endif
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 4880306..219b8fb 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -319,4 +319,6 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
+void __init kmem_cache_init_late(void);
+
 #endif	/* _LINUX_SLAB_H */
diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index 0ec00b3..bb5368d 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -34,4 +34,9 @@ static __always_inline void *__kmalloc(size_t size, gfp_t flags)
 	return kmalloc(size, flags);
 }
 
+static inline void kmem_cache_init_late(void)
+{
+	/* Nothing to do */
+}
+
 #endif /* __LINUX_SLOB_DEF_H */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index be5d40c..4dcbc2c 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -302,4 +302,6 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 }
 #endif
 
+void __init kmem_cache_init_late(void);
+
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/init/main.c b/init/main.c
index 5616661..f6204f7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,6 +539,11 @@ void __init __weak thread_info_cache_init(void)
  */
 static void __init mm_init(void)
 {
+	/*
+	 * page_cgroup requires countinous pages as memmap
+	 * and it's bigger than MAX_ORDER unless SPARSEMEM.
+	 */
+	page_cgroup_init_flatmem();
 	mem_init();
 	kmem_cache_init();
 	vmalloc_init();
@@ -635,6 +640,7 @@ asmlinkage void __init start_kernel(void)
 				 "enabled early\n");
 	early_boot_irqs_on();
 	local_irq_enable();
+	kmem_cache_init_late();
 
 	/*
 	 * HACK ALERT! This is early. We're enabling the console before
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 1045785..065205b 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -45,7 +45,7 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 static void __init init_irq_default_affinity(void)
 {
-	alloc_bootmem_cpumask_var(&irq_default_affinity);
+	alloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
 	cpumask_setall(irq_default_affinity);
 }
 #else
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 3dd4a90..11a8a10 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -47,8 +47,6 @@ static int __init alloc_node_page_cgroup(int nid)
 	struct page_cgroup *base, *pc;
 	unsigned long table_size;
 	unsigned long start_pfn, nr_pages, index;
-	struct page *page;
-	unsigned int order;
 
 	start_pfn = NODE_DATA(nid)->node_start_pfn;
 	nr_pages = NODE_DATA(nid)->node_spanned_pages;
@@ -57,13 +55,11 @@ static int __init alloc_node_page_cgroup(int nid)
 		return 0;
 
 	table_size = sizeof(struct page_cgroup) * nr_pages;
-	order = get_order(table_size);
-	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
-	if (!page)
-		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);
-	if (!page)
+
+	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
+			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	if (!base)
 		return -ENOMEM;
-	base = page_address(page);
 	for (index = 0; index < nr_pages; index++) {
 		pc = base + index;
 		__init_page_cgroup(pc, start_pfn + index);
@@ -73,7 +69,7 @@ static int __init alloc_node_page_cgroup(int nid)
 	return 0;
 }
 
-void __init page_cgroup_init(void)
+void __init page_cgroup_init_flatmem(void)
 {
 
 	int nid, fail;
@@ -117,16 +113,11 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
 	if (!section->page_cgroup) {
 		nid = page_to_nid(pfn_to_page(pfn));
 		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-		if (slab_is_available()) {
-			base = kmalloc_node(table_size,
-					GFP_KERNEL | __GFP_NOWARN, nid);
-			if (!base)
-				base = vmalloc_node(table_size, nid);
-		} else {
-			base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
-				table_size,
-				PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
-		}
+		VM_BUG_ON(!slab_is_available());
+		base = kmalloc_node(table_size,
+				GFP_KERNEL | __GFP_NOWARN, nid);
+		if (!base)
+			base = vmalloc_node(table_size, nid);
 	} else {
 		/*
  		 * We don't have to allocate page_cgroup again, but
diff --git a/mm/slab.c b/mm/slab.c
index f46b65d..18e3164 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -304,6 +304,12 @@ struct kmem_list3 {
 };
 
 /*
+ * The slab allocator is initialized with interrupts disabled. Therefore, make
+ * sure early boot allocations don't accidentally enable interrupts.
+ */
+static gfp_t slab_gfp_mask __read_mostly = SLAB_GFP_BOOT_MASK;
+
+/*
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (3 * MAX_NUMNODES)
@@ -753,6 +759,7 @@ static enum {
 	NONE,
 	PARTIAL_AC,
 	PARTIAL_L3,
+	EARLY,
 	FULL
 } g_cpucache_up;
 
@@ -761,7 +768,7 @@ static enum {
  */
 int slab_is_available(void)
 {
-	return g_cpucache_up == FULL;
+	return g_cpucache_up >= EARLY;
 }
 
 static DEFINE_PER_CPU(struct delayed_work, reap_work);
@@ -1625,19 +1632,27 @@ void __init kmem_cache_init(void)
 		}
 	}
 
-	/* 6) resize the head arrays to their final sizes */
-	{
-		struct kmem_cache *cachep;
-		mutex_lock(&cache_chain_mutex);
-		list_for_each_entry(cachep, &cache_chain, next)
-			if (enable_cpucache(cachep, GFP_NOWAIT))
-				BUG();
-		mutex_unlock(&cache_chain_mutex);
-	}
+	g_cpucache_up = EARLY;
 
 	/* Annotate slab for lockdep -- annotate the malloc caches */
 	init_lock_keys();
+}
+
+void __init kmem_cache_init_late(void)
+{
+	struct kmem_cache *cachep;
+
+	/*
+	 * Interrupts are enabled now so all GFP allocations are safe.
+	 */
+	slab_gfp_mask = __GFP_BITS_MASK;
 
+	/* 6) resize the head arrays to their final sizes */
+	mutex_lock(&cache_chain_mutex);
+	list_for_each_entry(cachep, &cache_chain, next)
+		if (enable_cpucache(cachep, GFP_NOWAIT))
+			BUG();
+	mutex_unlock(&cache_chain_mutex);
 
 	/* Done! */
 	g_cpucache_up = FULL;
@@ -2102,7 +2117,7 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 			for_each_online_node(node) {
 				cachep->nodelists[node] =
 				    kmalloc_node(sizeof(struct kmem_list3),
-						GFP_KERNEL, node);
+						gfp, node);
 				BUG_ON(!cachep->nodelists[node]);
 				kmem_list3_init(cachep->nodelists[node]);
 			}
@@ -3354,6 +3369,8 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	unsigned long save_flags;
 	void *ptr;
 
+	flags &= slab_gfp_mask;
+
 	lockdep_trace_alloc(flags);
 
 	if (slab_should_failslab(cachep, flags))
@@ -3434,6 +3451,8 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	unsigned long save_flags;
 	void *objp;
 
+	flags &= slab_gfp_mask;
+
 	lockdep_trace_alloc(flags);
 
 	if (slab_should_failslab(cachep, flags))
diff --git a/mm/slub.c b/mm/slub.c
index 3964d3c..30354bf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -178,6 +178,12 @@ static enum {
 	SYSFS		/* Sysfs up */
 } slab_state = DOWN;
 
+/*
+ * The slab allocator is initialized with interrupts disabled. Therefore, make
+ * sure early boot allocations don't accidentally enable interrupts.
+ */
+static gfp_t slab_gfp_mask __read_mostly = SLAB_GFP_BOOT_MASK;
+
 /* A list of all slab caches on the system */
 static DECLARE_RWSEM(slub_lock);
 static LIST_HEAD(slab_caches);
@@ -1595,6 +1601,8 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	unsigned long flags;
 	unsigned int objsize;
 
+	gfpflags &= slab_gfp_mask;
+
 	lockdep_trace_alloc(gfpflags);
 	might_sleep_if(gfpflags & __GFP_WAIT);
 
@@ -3104,6 +3112,14 @@ void __init kmem_cache_init(void)
 		nr_cpu_ids, nr_node_ids);
 }
 
+void __init kmem_cache_init_late(void)
+{
+	/*
+	 * Interrupts are enabled now so all GFP allocations are safe.
+	 */
+	slab_gfp_mask = __GFP_BITS_MASK;
+}
+
 /*
  * Find a mergeable slab cache
  */
