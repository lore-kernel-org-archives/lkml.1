Return-Path: <linux-kernel-owner+w=401wt.eu-S1763018AbZFKLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763018AbZFKLRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761355AbZFKLRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:17:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55162 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZFKLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:17:06 -0400
Date: Thu, 11 Jun 2009 14:17:05 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mingo@elte.hu,
       mpm@selenic.com, npiggin@suse.de, yinghai@kernel.org
Subject: [GIT PULL v2] Early boot SLAB for 2.6.31
In-Reply-To: <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 991ec02cdca33b03a132a0cacfe6f0aa0be9aa8d:
  Linus Torvalds (1):
        Merge branch 'tracing-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 for-linus

Pekka Enberg (9):
      bootmem: use slab if bootmem is no longer available
      slab: setup allocators earlier in the boot sequence
      vmalloc: use kzalloc() instead of alloc_bootmem()
      sched: use kzalloc() instead of the bootmem allocator
      vt: use kzalloc() instead of the bootmem allocator
      Merge commit 'linus/master' into topic/slab/earlyboot
      bootmem: fix slab fallback on numa
      sched: use alloc_cpumask_var() instead of alloc_bootmem_cpumask_var()
      sched: use slab in cpupri_init()

Yinghai Lu (3):
      x86: remove some alloc_bootmem_cpumask_var calling
      irq/cpumask: make memoryless node zero happy
      memcg: don't use bootmem allocator in setup code

 arch/x86/kernel/apic/io_apic.c |    6 ++-
 drivers/char/vt.c              |    8 +---
 include/linux/irq.h            |   18 +++-----
 init/main.c                    |   32 +++++++++------
 kernel/cpuset.c                |    2 +-
 kernel/irq/handle.c            |    9 ++--
 kernel/profile.c               |    6 ---
 kernel/sched.c                 |   30 ++++++--------
 kernel/sched_cpupri.c          |    8 ++-
 lib/cpumask.c                  |   11 +----
 mm/bootmem.c                   |   12 ++++++
 mm/page_cgroup.c               |   12 ++++--
 mm/slab.c                      |   85 +++++++++++++++++++++-------------------
 mm/slub.c                      |   17 +++++---
 mm/vmalloc.c                   |    3 +-
 15 files changed, 135 insertions(+), 124 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1946fac..94605e7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -177,16 +177,18 @@ int __init arch_early_irq_init(void)
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 	int count;
+	int node;
 	int i;
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
+	node= cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
-		alloc_bootmem_cpumask_var(&cfg[i].domain);
-		alloc_bootmem_cpumask_var(&cfg[i].old_domain);
+		alloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
+		alloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
 		if (i < NR_IRQS_LEGACY)
 			cpumask_setall(cfg[i].domain);
 	}
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 08151d4..c796a86 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -95,7 +95,6 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
-#include <linux/bootmem.h>
 #include <linux/pm.h>
 #include <linux/font.h>
 #include <linux/bitops.h>
@@ -2875,14 +2874,11 @@ static int __init con_init(void)
 		mod_timer(&console_timer, jiffies + blankinterval);
 	}
 
-	/*
-	 * kmalloc is not running yet - we use the bootmem allocator.
-	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
-		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
-		vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
+		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc->vc_kmalloced = 0;
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index eedbb8e..1e50c34 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -430,23 +430,19 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
  * Returns true if successful (or not required).
  */
 static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
-								bool boot)
+							bool boot)
 {
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	if (boot) {
-		alloc_bootmem_cpumask_var(&desc->affinity);
+	gfp_t gfp = GFP_ATOMIC;
 
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-		alloc_bootmem_cpumask_var(&desc->pending_mask);
-#endif
-		return true;
-	}
+	if (boot)
+		gfp = GFP_NOWAIT;
 
-	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
 		return false;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (!alloc_cpumask_var_node(&desc->pending_mask, GFP_ATOMIC, node)) {
+	if (!alloc_cpumask_var_node(&desc->pending_mask, gfp, node)) {
 		free_cpumask_var(desc->affinity);
 		return false;
 	}
diff --git a/init/main.c b/init/main.c
index bb7dc57..859af21 100644
--- a/init/main.c
+++ b/init/main.c
@@ -574,6 +574,26 @@ asmlinkage void __init start_kernel(void)
 	setup_nr_cpu_ids();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
+	build_all_zonelists();
+	page_alloc_init();
+
+	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
+	parse_early_param();
+	parse_args("Booting kernel", static_command_line, __start___param,
+		   __stop___param - __start___param,
+		   &unknown_bootoption);
+	/*
+	 * These use large bootmem allocations and must precede
+	 * kmem_cache_init()
+	 */
+	pidhash_init();
+	vfs_caches_init_early();
+	/*
+	 * Set up kernel memory allocators
+	 */
+	mem_init();
+	kmem_cache_init();
+	vmalloc_init();
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
@@ -585,13 +605,6 @@ asmlinkage void __init start_kernel(void)
 	 * fragile until we cpu_idle() for the first time.
 	 */
 	preempt_disable();
-	build_all_zonelists();
-	page_alloc_init();
-	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
-	parse_early_param();
-	parse_args("Booting kernel", static_command_line, __start___param,
-		   __stop___param - __start___param,
-		   &unknown_bootoption);
 	if (!irqs_disabled()) {
 		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
 				"enabled *very* early, fixing it\n");
@@ -603,7 +616,6 @@ asmlinkage void __init start_kernel(void)
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
-	pidhash_init();
 	init_timers();
 	hrtimers_init();
 	softirq_init();
@@ -645,14 +657,10 @@ asmlinkage void __init start_kernel(void)
 		initrd_start = 0;
 	}
 #endif
-	vmalloc_init();
-	vfs_caches_init_early();
 	cpuset_init_early();
 	page_cgroup_init();
-	mem_init();
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
-	kmem_cache_init();
 	kmemtrace_init();
 	debug_objects_mem_init();
 	idr_init_cache();
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 026facc..d5a7e17 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1857,7 +1857,7 @@ struct cgroup_subsys cpuset_subsys = {
 
 int __init cpuset_init_early(void)
 {
-	alloc_bootmem_cpumask_var(&top_cpuset.cpus_allowed);
+	alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_NOWAIT);
 
 	top_cpuset.mems_generation = cpuset_mems_generation++;
 	return 0;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index a600184..e161999 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -150,6 +150,7 @@ int __init early_irq_init(void)
 {
 	struct irq_desc *desc;
 	int legacy_count;
+	int node;
 	int i;
 
 	init_irq_default_affinity();
@@ -160,20 +161,20 @@ int __init early_irq_init(void)
 
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
+ 	node = first_online_node;
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
 
 	/* allocate based on nr_cpu_ids */
-	/* FIXME: invert kstat_irgs, and it'd be a per_cpu_alloc'd thing */
-	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
-					  sizeof(int));
+	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
+					  sizeof(int), GFP_NOWAIT, node);
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], node, true);
 		init_desc_masks(&desc[i]);
 		irq_desc_ptrs[i] = desc + i;
 	}
diff --git a/kernel/profile.c b/kernel/profile.c
index 7724e04..28cf26a 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -111,12 +111,6 @@ int __ref profile_init(void)
 	/* only text is profiled */
 	prof_len = (_etext - _stext) >> prof_shift;
 	buffer_bytes = prof_len*sizeof(atomic_t);
-	if (!slab_is_available()) {
-		prof_buffer = alloc_bootmem(buffer_bytes);
-		alloc_bootmem_cpumask_var(&prof_cpu_mask);
-		cpumask_copy(prof_cpu_mask, cpu_possible_mask);
-		return 0;
-	}
 
 	if (!alloc_cpumask_var(&prof_cpu_mask, GFP_KERNEL))
 		return -ENOMEM;
diff --git a/kernel/sched.c b/kernel/sched.c
index 14c447a..dcf2dc2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -68,7 +68,6 @@
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
-#include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
@@ -7782,24 +7781,21 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 
 static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
 {
+	gfp_t gfp = GFP_KERNEL;
+
 	memset(rd, 0, sizeof(*rd));
 
-	if (bootmem) {
-		alloc_bootmem_cpumask_var(&def_root_domain.span);
-		alloc_bootmem_cpumask_var(&def_root_domain.online);
-		alloc_bootmem_cpumask_var(&def_root_domain.rto_mask);
-		cpupri_init(&rd->cpupri, true);
-		return 0;
-	}
+	if (bootmem)
+		gfp = GFP_NOWAIT;
 
-	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->span, gfp))
 		goto out;
-	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->online, gfp))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->rto_mask, gfp))
 		goto free_online;
 
-	if (cpupri_init(&rd->cpupri, false) != 0)
+	if (cpupri_init(&rd->cpupri, bootmem) != 0)
 		goto free_rto_mask;
 	return 0;
 
@@ -9123,7 +9119,7 @@ void __init sched_init(void)
 	 * we use alloc_bootmem().
 	 */
 	if (alloc_size) {
-		ptr = (unsigned long)alloc_bootmem(alloc_size);
+		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.se = (struct sched_entity **)ptr;
@@ -9314,13 +9310,13 @@ void __init sched_init(void)
 	current->sched_class = &fair_sched_class;
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	alloc_bootmem_cpumask_var(&nohz_cpu_mask);
+	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
-	alloc_bootmem_cpumask_var(&nohz.ilb_grp_nohz_mask);
+	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	alloc_bootmem_cpumask_var(&cpu_isolated_map);
+	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	scheduler_running = 1;
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 344712a..7deffc9 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -154,8 +154,12 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  */
 int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 {
+	gfp_t gfp = GFP_KERNEL;
 	int i;
 
+	if (bootmem)
+		gfp = GFP_NOWAIT;
+
 	memset(cp, 0, sizeof(*cp));
 
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
@@ -163,9 +167,7 @@ int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 
 		spin_lock_init(&vec->lock);
 		vec->count = 0;
-		if (bootmem)
-			alloc_bootmem_cpumask_var(&vec->mask);
-		else if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
+		if (!zalloc_cpumask_var(&vec->mask, gfp))
 			goto cleanup;
 	}
 
diff --git a/lib/cpumask.c b/lib/cpumask.c
index eb23aaa..7bb4142 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -92,15 +92,8 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
  */
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
 {
-	if (likely(slab_is_available()))
-		*mask = kmalloc_node(cpumask_size(), flags, node);
-	else {
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-		printk(KERN_ERR
-			"=> alloc_cpumask_var: kmalloc not available!\n");
-#endif
-		*mask = NULL;
-	}
+	*mask = kmalloc_node(cpumask_size(), flags, node);
+
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 	if (!*mask) {
 		printk(KERN_ERR "=> alloc_cpumask_var: failed!\n");
diff --git a/mm/bootmem.c b/mm/bootmem.c
index daf9271..282df0a 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -532,6 +532,9 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 					unsigned long size, unsigned long align,
 					unsigned long goal, unsigned long limit)
 {
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
+
 #ifdef CONFIG_HAVE_ARCH_BOOTMEM
 	bootmem_data_t *p_bdata;
 
@@ -662,6 +665,9 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
 	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
 }
 
@@ -693,6 +699,9 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 {
 	void *ptr;
 
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
 	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
@@ -745,6 +754,9 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
 	return ___alloc_bootmem_node(pgdat->bdata, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
 }
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 791905c..3dd4a90 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -47,6 +47,8 @@ static int __init alloc_node_page_cgroup(int nid)
 	struct page_cgroup *base, *pc;
 	unsigned long table_size;
 	unsigned long start_pfn, nr_pages, index;
+	struct page *page;
+	unsigned int order;
 
 	start_pfn = NODE_DATA(nid)->node_start_pfn;
 	nr_pages = NODE_DATA(nid)->node_spanned_pages;
@@ -55,11 +57,13 @@ static int __init alloc_node_page_cgroup(int nid)
 		return 0;
 
 	table_size = sizeof(struct page_cgroup) * nr_pages;
-
-	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
-			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
-	if (!base)
+	order = get_order(table_size);
+	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
+	if (!page)
+		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);
+	if (!page)
 		return -ENOMEM;
+	base = page_address(page);
 	for (index = 0; index < nr_pages; index++) {
 		pc = base + index;
 		__init_page_cgroup(pc, start_pfn + index);
diff --git a/mm/slab.c b/mm/slab.c
index f85831d..2bd611f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -315,7 +315,7 @@ static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_list3 *l3, int tofree);
 static void free_block(struct kmem_cache *cachep, void **objpp, int len,
 			int node);
-static int enable_cpucache(struct kmem_cache *cachep);
+static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp);
 static void cache_reap(struct work_struct *unused);
 
 /*
@@ -958,12 +958,12 @@ static void __cpuinit start_cpu_timer(int cpu)
 }
 
 static struct array_cache *alloc_arraycache(int node, int entries,
-					    int batchcount)
+					    int batchcount, gfp_t gfp)
 {
 	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
 	struct array_cache *nc = NULL;
 
-	nc = kmalloc_node(memsize, GFP_KERNEL, node);
+	nc = kmalloc_node(memsize, gfp, node);
 	if (nc) {
 		nc->avail = 0;
 		nc->limit = entries;
@@ -1003,7 +1003,7 @@ static int transfer_objects(struct array_cache *to,
 #define drain_alien_cache(cachep, alien) do { } while (0)
 #define reap_alien(cachep, l3) do { } while (0)
 
-static inline struct array_cache **alloc_alien_cache(int node, int limit)
+static inline struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
 {
 	return (struct array_cache **)BAD_ALIEN_MAGIC;
 }
@@ -1034,7 +1034,7 @@ static inline void *____cache_alloc_node(struct kmem_cache *cachep,
 static void *____cache_alloc_node(struct kmem_cache *, gfp_t, int);
 static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
 
-static struct array_cache **alloc_alien_cache(int node, int limit)
+static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
 {
 	struct array_cache **ac_ptr;
 	int memsize = sizeof(void *) * nr_node_ids;
@@ -1042,14 +1042,14 @@ static struct array_cache **alloc_alien_cache(int node, int limit)
 
 	if (limit > 1)
 		limit = 12;
-	ac_ptr = kmalloc_node(memsize, GFP_KERNEL, node);
+	ac_ptr = kmalloc_node(memsize, gfp, node);
 	if (ac_ptr) {
 		for_each_node(i) {
 			if (i == node || !node_online(i)) {
 				ac_ptr[i] = NULL;
 				continue;
 			}
-			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d);
+			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
 			if (!ac_ptr[i]) {
 				for (i--; i >= 0; i--)
 					kfree(ac_ptr[i]);
@@ -1282,20 +1282,20 @@ static int __cpuinit cpuup_prepare(long cpu)
 		struct array_cache **alien = NULL;
 
 		nc = alloc_arraycache(node, cachep->limit,
-					cachep->batchcount);
+					cachep->batchcount, GFP_KERNEL);
 		if (!nc)
 			goto bad;
 		if (cachep->shared) {
 			shared = alloc_arraycache(node,
 				cachep->shared * cachep->batchcount,
-				0xbaadf00d);
+				0xbaadf00d, GFP_KERNEL);
 			if (!shared) {
 				kfree(nc);
 				goto bad;
 			}
 		}
 		if (use_alien_caches) {
-			alien = alloc_alien_cache(node, cachep->limit);
+			alien = alloc_alien_cache(node, cachep->limit, GFP_KERNEL);
 			if (!alien) {
 				kfree(shared);
 				kfree(nc);
@@ -1399,10 +1399,9 @@ static void init_list(struct kmem_cache *cachep, struct kmem_list3 *list,
 {
 	struct kmem_list3 *ptr;
 
-	ptr = kmalloc_node(sizeof(struct kmem_list3), GFP_KERNEL, nodeid);
+	ptr = kmalloc_node(sizeof(struct kmem_list3), GFP_NOWAIT, nodeid);
 	BUG_ON(!ptr);
 
-	local_irq_disable();
 	memcpy(ptr, list, sizeof(struct kmem_list3));
 	/*
 	 * Do not assume that spinlocks can be initialized via memcpy:
@@ -1411,7 +1410,6 @@ static void init_list(struct kmem_cache *cachep, struct kmem_list3 *list,
 
 	MAKE_ALL_LISTS(cachep, ptr, nodeid);
 	cachep->nodelists[nodeid] = ptr;
-	local_irq_enable();
 }
 
 /*
@@ -1575,9 +1573,8 @@ void __init kmem_cache_init(void)
 	{
 		struct array_cache *ptr;
 
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
 
-		local_irq_disable();
 		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
 		memcpy(ptr, cpu_cache_get(&cache_cache),
 		       sizeof(struct arraycache_init));
@@ -1587,11 +1584,9 @@ void __init kmem_cache_init(void)
 		spin_lock_init(&ptr->lock);
 
 		cache_cache.array[smp_processor_id()] = ptr;
-		local_irq_enable();
 
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
 
-		local_irq_disable();
 		BUG_ON(cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep)
 		       != &initarray_generic.cache);
 		memcpy(ptr, cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep),
@@ -1603,7 +1598,6 @@ void __init kmem_cache_init(void)
 
 		malloc_sizes[INDEX_AC].cs_cachep->array[smp_processor_id()] =
 		    ptr;
-		local_irq_enable();
 	}
 	/* 5) Replace the bootstrap kmem_list3's */
 	{
@@ -1627,7 +1621,7 @@ void __init kmem_cache_init(void)
 		struct kmem_cache *cachep;
 		mutex_lock(&cache_chain_mutex);
 		list_for_each_entry(cachep, &cache_chain, next)
-			if (enable_cpucache(cachep))
+			if (enable_cpucache(cachep, GFP_NOWAIT))
 				BUG();
 		mutex_unlock(&cache_chain_mutex);
 	}
@@ -2064,10 +2058,10 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 	return left_over;
 }
 
-static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
+static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	if (g_cpucache_up == FULL)
-		return enable_cpucache(cachep);
+		return enable_cpucache(cachep, gfp);
 
 	if (g_cpucache_up == NONE) {
 		/*
@@ -2089,7 +2083,7 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
 			g_cpucache_up = PARTIAL_AC;
 	} else {
 		cachep->array[smp_processor_id()] =
-			kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+			kmalloc(sizeof(struct arraycache_init), gfp);
 
 		if (g_cpucache_up == PARTIAL_AC) {
 			set_up_list3s(cachep, SIZE_L3);
@@ -2153,6 +2147,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 {
 	size_t left_over, slab_size, ralign;
 	struct kmem_cache *cachep = NULL, *pc;
+	gfp_t gfp;
 
 	/*
 	 * Sanity checks... these are all serious usage bugs.
@@ -2168,8 +2163,10 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	 * We use cache_chain_mutex to ensure a consistent view of
 	 * cpu_online_mask as well.  Please see cpuup_callback
 	 */
-	get_online_cpus();
-	mutex_lock(&cache_chain_mutex);
+	if (slab_is_available()) {
+		get_online_cpus();
+		mutex_lock(&cache_chain_mutex);
+	}
 
 	list_for_each_entry(pc, &cache_chain, next) {
 		char tmp;
@@ -2278,8 +2275,13 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	 */
 	align = ralign;
 
+	if (slab_is_available())
+		gfp = GFP_KERNEL;
+	else
+		gfp = GFP_NOWAIT;
+
 	/* Get cache's description obj. */
-	cachep = kmem_cache_zalloc(&cache_cache, GFP_KERNEL);
+	cachep = kmem_cache_zalloc(&cache_cache, gfp);
 	if (!cachep)
 		goto oops;
 
@@ -2382,7 +2384,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	cachep->ctor = ctor;
 	cachep->name = name;
 
-	if (setup_cpu_cache(cachep)) {
+	if (setup_cpu_cache(cachep, gfp)) {
 		__kmem_cache_destroy(cachep);
 		cachep = NULL;
 		goto oops;
@@ -2394,8 +2396,10 @@ oops:
 	if (!cachep && (flags & SLAB_PANIC))
 		panic("kmem_cache_create(): failed to create slab `%s'\n",
 		      name);
-	mutex_unlock(&cache_chain_mutex);
-	put_online_cpus();
+	if (slab_is_available()) {
+		mutex_unlock(&cache_chain_mutex);
+		put_online_cpus();
+	}
 	return cachep;
 }
 EXPORT_SYMBOL(kmem_cache_create);
@@ -3802,7 +3806,7 @@ EXPORT_SYMBOL_GPL(kmem_cache_name);
 /*
  * This initializes kmem_list3 or resizes various caches for all nodes.
  */
-static int alloc_kmemlist(struct kmem_cache *cachep)
+static int alloc_kmemlist(struct kmem_cache *cachep, gfp_t gfp)
 {
 	int node;
 	struct kmem_list3 *l3;
@@ -3812,7 +3816,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 	for_each_online_node(node) {
 
                 if (use_alien_caches) {
-                        new_alien = alloc_alien_cache(node, cachep->limit);
+                        new_alien = alloc_alien_cache(node, cachep->limit, gfp);
                         if (!new_alien)
                                 goto fail;
                 }
@@ -3821,7 +3825,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 		if (cachep->shared) {
 			new_shared = alloc_arraycache(node,
 				cachep->shared*cachep->batchcount,
-					0xbaadf00d);
+					0xbaadf00d, gfp);
 			if (!new_shared) {
 				free_alien_cache(new_alien);
 				goto fail;
@@ -3850,7 +3854,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 			free_alien_cache(new_alien);
 			continue;
 		}
-		l3 = kmalloc_node(sizeof(struct kmem_list3), GFP_KERNEL, node);
+		l3 = kmalloc_node(sizeof(struct kmem_list3), gfp, node);
 		if (!l3) {
 			free_alien_cache(new_alien);
 			kfree(new_shared);
@@ -3906,18 +3910,18 @@ static void do_ccupdate_local(void *info)
 
 /* Always called with the cache_chain_mutex held */
 static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
-				int batchcount, int shared)
+				int batchcount, int shared, gfp_t gfp)
 {
 	struct ccupdate_struct *new;
 	int i;
 
-	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	new = kzalloc(sizeof(*new), gfp);
 	if (!new)
 		return -ENOMEM;
 
 	for_each_online_cpu(i) {
 		new->new[i] = alloc_arraycache(cpu_to_node(i), limit,
-						batchcount);
+						batchcount, gfp);
 		if (!new->new[i]) {
 			for (i--; i >= 0; i--)
 				kfree(new->new[i]);
@@ -3944,11 +3948,11 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
 		kfree(ccold);
 	}
 	kfree(new);
-	return alloc_kmemlist(cachep);
+	return alloc_kmemlist(cachep, gfp);
 }
 
 /* Called with cache_chain_mutex held always */
-static int enable_cpucache(struct kmem_cache *cachep)
+static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	int err;
 	int limit, shared;
@@ -3994,7 +3998,7 @@ static int enable_cpucache(struct kmem_cache *cachep)
 	if (limit > 32)
 		limit = 32;
 #endif
-	err = do_tune_cpucache(cachep, limit, (limit + 1) / 2, shared);
+	err = do_tune_cpucache(cachep, limit, (limit + 1) / 2, shared, gfp);
 	if (err)
 		printk(KERN_ERR "enable_cpucache failed for %s, error %d.\n",
 		       cachep->name, -err);
@@ -4300,7 +4304,8 @@ ssize_t slabinfo_write(struct file *file, const char __user * buffer,
 				res = 0;
 			} else {
 				res = do_tune_cpucache(cachep, limit,
-						       batchcount, shared);
+						       batchcount, shared,
+						       GFP_KERNEL);
 			}
 			break;
 		}
diff --git a/mm/slub.c b/mm/slub.c
index 5e805a6..c1815a6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2557,13 +2557,16 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
 	if (gfp_flags & SLUB_DMA)
 		flags = SLAB_CACHE_DMA;
 
-	down_write(&slub_lock);
+	/*
+	 * This function is called with IRQs disabled during early-boot on
+	 * single CPU so there's no need to take slub_lock here.
+	 */
 	if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
 								flags, NULL))
 		goto panic;
 
 	list_add(&s->list, &slab_caches);
-	up_write(&slub_lock);
+
 	if (sysfs_slab_add(s))
 		goto panic;
 	return s;
@@ -3021,7 +3024,7 @@ void __init kmem_cache_init(void)
 	 * kmem_cache_open for slab_state == DOWN.
 	 */
 	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
-		sizeof(struct kmem_cache_node), GFP_KERNEL);
+		sizeof(struct kmem_cache_node), GFP_NOWAIT);
 	kmalloc_caches[0].refcount = -1;
 	caches++;
 
@@ -3034,16 +3037,16 @@ void __init kmem_cache_init(void)
 	/* Caches that are not of the two-to-the-power-of size */
 	if (KMALLOC_MIN_SIZE <= 64) {
 		create_kmalloc_cache(&kmalloc_caches[1],
-				"kmalloc-96", 96, GFP_KERNEL);
+				"kmalloc-96", 96, GFP_NOWAIT);
 		caches++;
 		create_kmalloc_cache(&kmalloc_caches[2],
-				"kmalloc-192", 192, GFP_KERNEL);
+				"kmalloc-192", 192, GFP_NOWAIT);
 		caches++;
 	}
 
 	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
 		create_kmalloc_cache(&kmalloc_caches[i],
-			"kmalloc", 1 << i, GFP_KERNEL);
+			"kmalloc", 1 << i, GFP_NOWAIT);
 		caches++;
 	}
 
@@ -3080,7 +3083,7 @@ void __init kmem_cache_init(void)
 	/* Provide the correct kmalloc names now that the caches are up */
 	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++)
 		kmalloc_caches[i]. name =
-			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
+			kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
 
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 083716e..3235138 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,7 +23,6 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
-#include <linux/bootmem.h>
 #include <linux/pfn.h>
 
 #include <asm/atomic.h>
@@ -1032,7 +1031,7 @@ void __init vmalloc_init(void)
 
 	/* Import existing vmlist entries. */
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
-		va = alloc_bootmem(sizeof(struct vmap_area));
+		va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
 		va->flags = tmp->flags | VM_VM_AREA;
 		va->va_start = (unsigned long)tmp->addr;
 		va->va_end = va->va_start + tmp->size;
