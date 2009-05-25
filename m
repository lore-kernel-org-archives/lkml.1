Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZEYLob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZEYLob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZEYLoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:44:23 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41059 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZEYLoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:44:22 -0400
Date: Mon, 25 May 2009 14:44:22 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <20090525114127.GE24071@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI>
References: <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org>
 <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org>
 <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
 <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com>
 <20090525114127.GE24071@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
> > > The bootmem allocations of course are required because some hashes may
> > > need to be larger than MAX_ORDER without using vmalloc.
> > >
> > > kmem_cache_init (and mem_init, partially) sets up the kernel memory
> > > allocators...
> > 

On Mon, May 25, 2009 at 02:37:59PM +0300, Pekka Enberg wrote:
> > Which comment are you talking about? The "setup kernel memory
> > allocators" one? Yeah, I should probably move it couple of lines down.

On Mon, 25 May 2009, Nick Piggin wrote:
> Yes, just that one.

Here's an updated patch that does that. Thanks!

			Pekka

>From fbd1061276b607d6eca65d4bc50d7d5c0d2e27ce Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 25 May 2009 09:44:39 +0300
Subject: [PATCH] slab: setup allocators earlier in the boot sequence

This patch makes kmalloc() available earlier in the boot sequence so we can get
rid of some bootmem allocations. The bulk of the changes are due to
kmem_cache_init() being called with interrupts disabled which requires some
changes to allocator boostrap code.

[ yinghai@kernel.org: rebase to tip ]
Cc: Nick Piggin <npiggin@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <cl@linux-foundation.com>
Cc: Linus Torvalds <torvals@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 init/main.c           |   28 +++++++++-------
 kernel/irq/handle.c   |   23 +++++---------
 kernel/sched.c        |   34 +++++++------------
 kernel/sched_cpupri.c |    9 +++--
 mm/slab.c             |   85 ++++++++++++++++++++++++++-----------------------
 mm/slub.c             |   17 ++++++----
 6 files changed, 98 insertions(+), 98 deletions(-)

diff --git a/init/main.c b/init/main.c
index 33ce929..fb0e004 100644
--- a/init/main.c
+++ b/init/main.c
@@ -576,6 +576,22 @@ asmlinkage void __init start_kernel(void)
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
+	pidhash_init();
+	vmalloc_init();
+	vfs_caches_init_early();
+	/*
+	 * Set up kernel memory allocators
+	 */
+	mem_init();
+	kmem_cache_init();
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
@@ -587,13 +603,6 @@ asmlinkage void __init start_kernel(void)
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
@@ -605,7 +614,6 @@ asmlinkage void __init start_kernel(void)
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
-	pidhash_init();
 	init_timers();
 	hrtimers_init();
 	softirq_init();
@@ -647,14 +655,10 @@ asmlinkage void __init start_kernel(void)
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
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index a600184..6cc19a9 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -18,7 +18,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
-#include <linux/bootmem.h>
+#include <linux/slab.h>
 #include <trace/events/irq.h>
 
 #include "internals.h"
@@ -45,7 +45,7 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 static void __init init_irq_default_affinity(void)
 {
-	alloc_bootmem_cpumask_var(&irq_default_affinity);
+	alloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
 	cpumask_setall(irq_default_affinity);
 }
 #else
@@ -86,12 +86,8 @@ void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 {
 	void *ptr;
 
-	if (slab_is_available())
-		ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
-				   GFP_ATOMIC, node);
-	else
-		ptr = alloc_bootmem_node(NODE_DATA(node),
-				nr * sizeof(*desc->kstat_irqs));
+	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
+			   GFP_ATOMIC, node);
 
 	/*
 	 * don't overwite if can not get new one
@@ -162,12 +158,12 @@ int __init early_irq_init(void)
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
-	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
+	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
 
 	/* allocate based on nr_cpu_ids */
 	/* FIXME: invert kstat_irgs, and it'd be a per_cpu_alloc'd thing */
-	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
-					  sizeof(int));
+	kstat_irqs_legacy = kzalloc(NR_IRQS_LEGACY * nr_cpu_ids *
+					  sizeof(int), GFP_NOWAIT);
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
@@ -214,10 +210,7 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 	if (desc)
 		goto out_unlock;
 
-	if (slab_is_available())
-		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	else
-		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 
 	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
diff --git a/kernel/sched.c b/kernel/sched.c
index f93305b..645280c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -69,7 +69,6 @@
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
-#include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
@@ -7821,24 +7820,21 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 
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
 
@@ -9157,12 +9153,8 @@ void __init sched_init(void)
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
-	/*
-	 * As sched_init() is called before page_alloc is setup,
-	 * we use alloc_bootmem().
-	 */
 	if (alloc_size) {
-		ptr = (unsigned long)alloc_bootmem(alloc_size);
+		ptr = (unsigned long) kzalloc(alloc_size, GFP_NOWAIT);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.se = (struct sched_entity **)ptr;
@@ -9353,13 +9345,13 @@ void __init sched_init(void)
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
 
 	perf_counter_init();
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index cdd3c89..5ba8e32 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -156,16 +156,19 @@ int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	int i;
 
+	gfp_t gfp = GFP_KERNEL;
+
 	memset(cp, 0, sizeof(*cp));
 
+	if (bootmem)
+		gfp = GFP_NOWAIT;
+
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[i];
 
 		spin_lock_init(&vec->lock);
 		vec->count = 0;
-		if (bootmem)
-			alloc_bootmem_cpumask_var(&vec->mask);
-		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL))
+		if (!alloc_cpumask_var(&vec->mask, gfp))
 			goto cleanup;
 	}
 
diff --git a/mm/slab.c b/mm/slab.c
index 762acc2..ab5039a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -316,7 +316,7 @@ static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_list3 *l3, int tofree);
 static void free_block(struct kmem_cache *cachep, void **objpp, int len,
 			int node);
-static int enable_cpucache(struct kmem_cache *cachep);
+static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp);
 static void cache_reap(struct work_struct *unused);
 
 /*
@@ -878,12 +878,12 @@ static void __cpuinit start_cpu_timer(int cpu)
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
@@ -923,7 +923,7 @@ static int transfer_objects(struct array_cache *to,
 #define drain_alien_cache(cachep, alien) do { } while (0)
 #define reap_alien(cachep, l3) do { } while (0)
 
-static inline struct array_cache **alloc_alien_cache(int node, int limit)
+static inline struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
 {
 	return (struct array_cache **)BAD_ALIEN_MAGIC;
 }
@@ -954,7 +954,7 @@ static inline void *____cache_alloc_node(struct kmem_cache *cachep,
 static void *____cache_alloc_node(struct kmem_cache *, gfp_t, int);
 static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
 
-static struct array_cache **alloc_alien_cache(int node, int limit)
+static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
 {
 	struct array_cache **ac_ptr;
 	int memsize = sizeof(void *) * nr_node_ids;
@@ -962,14 +962,14 @@ static struct array_cache **alloc_alien_cache(int node, int limit)
 
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
@@ -1202,20 +1202,20 @@ static int __cpuinit cpuup_prepare(long cpu)
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
@@ -1319,10 +1319,9 @@ static void init_list(struct kmem_cache *cachep, struct kmem_list3 *list,
 {
 	struct kmem_list3 *ptr;
 
-	ptr = kmalloc_node(sizeof(struct kmem_list3), GFP_KERNEL, nodeid);
+	ptr = kmalloc_node(sizeof(struct kmem_list3), GFP_NOWAIT, nodeid);
 	BUG_ON(!ptr);
 
-	local_irq_disable();
 	memcpy(ptr, list, sizeof(struct kmem_list3));
 	/*
 	 * Do not assume that spinlocks can be initialized via memcpy:
@@ -1331,7 +1330,6 @@ static void init_list(struct kmem_cache *cachep, struct kmem_list3 *list,
 
 	MAKE_ALL_LISTS(cachep, ptr, nodeid);
 	cachep->nodelists[nodeid] = ptr;
-	local_irq_enable();
 }
 
 /*
@@ -1495,9 +1493,8 @@ void __init kmem_cache_init(void)
 	{
 		struct array_cache *ptr;
 
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
 
-		local_irq_disable();
 		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
 		memcpy(ptr, cpu_cache_get(&cache_cache),
 		       sizeof(struct arraycache_init));
@@ -1507,11 +1504,9 @@ void __init kmem_cache_init(void)
 		spin_lock_init(&ptr->lock);
 
 		cache_cache.array[smp_processor_id()] = ptr;
-		local_irq_enable();
 
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
 
-		local_irq_disable();
 		BUG_ON(cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep)
 		       != &initarray_generic.cache);
 		memcpy(ptr, cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep),
@@ -1523,7 +1518,6 @@ void __init kmem_cache_init(void)
 
 		malloc_sizes[INDEX_AC].cs_cachep->array[smp_processor_id()] =
 		    ptr;
-		local_irq_enable();
 	}
 	/* 5) Replace the bootstrap kmem_list3's */
 	{
@@ -1547,7 +1541,7 @@ void __init kmem_cache_init(void)
 		struct kmem_cache *cachep;
 		mutex_lock(&cache_chain_mutex);
 		list_for_each_entry(cachep, &cache_chain, next)
-			if (enable_cpucache(cachep))
+			if (enable_cpucache(cachep, GFP_NOWAIT))
 				BUG();
 		mutex_unlock(&cache_chain_mutex);
 	}
@@ -1996,10 +1990,10 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
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
@@ -2021,7 +2015,7 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
 			g_cpucache_up = PARTIAL_AC;
 	} else {
 		cachep->array[smp_processor_id()] =
-			kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+			kmalloc(sizeof(struct arraycache_init), gfp);
 
 		if (g_cpucache_up == PARTIAL_AC) {
 			set_up_list3s(cachep, SIZE_L3);
@@ -2085,6 +2079,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 {
 	size_t left_over, slab_size, ralign;
 	struct kmem_cache *cachep = NULL, *pc;
+	gfp_t gfp;
 
 	/*
 	 * Sanity checks... these are all serious usage bugs.
@@ -2100,8 +2095,10 @@ kmem_cache_create (const char *name, size_t size, size_t align,
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
@@ -2210,8 +2207,13 @@ kmem_cache_create (const char *name, size_t size, size_t align,
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
 
@@ -2314,7 +2316,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	cachep->ctor = ctor;
 	cachep->name = name;
 
-	if (setup_cpu_cache(cachep)) {
+	if (setup_cpu_cache(cachep, gfp)) {
 		__kmem_cache_destroy(cachep);
 		cachep = NULL;
 		goto oops;
@@ -2326,8 +2328,10 @@ oops:
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
@@ -3742,7 +3746,7 @@ EXPORT_SYMBOL_GPL(kmem_cache_name);
 /*
  * This initializes kmem_list3 or resizes various caches for all nodes.
  */
-static int alloc_kmemlist(struct kmem_cache *cachep)
+static int alloc_kmemlist(struct kmem_cache *cachep, gfp_t gfp)
 {
 	int node;
 	struct kmem_list3 *l3;
@@ -3752,7 +3756,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 	for_each_online_node(node) {
 
                 if (use_alien_caches) {
-                        new_alien = alloc_alien_cache(node, cachep->limit);
+                        new_alien = alloc_alien_cache(node, cachep->limit, gfp);
                         if (!new_alien)
                                 goto fail;
                 }
@@ -3761,7 +3765,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 		if (cachep->shared) {
 			new_shared = alloc_arraycache(node,
 				cachep->shared*cachep->batchcount,
-					0xbaadf00d);
+					0xbaadf00d, gfp);
 			if (!new_shared) {
 				free_alien_cache(new_alien);
 				goto fail;
@@ -3790,7 +3794,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 			free_alien_cache(new_alien);
 			continue;
 		}
-		l3 = kmalloc_node(sizeof(struct kmem_list3), GFP_KERNEL, node);
+		l3 = kmalloc_node(sizeof(struct kmem_list3), gfp, node);
 		if (!l3) {
 			free_alien_cache(new_alien);
 			kfree(new_shared);
@@ -3846,18 +3850,18 @@ static void do_ccupdate_local(void *info)
 
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
@@ -3884,11 +3888,11 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
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
@@ -3934,7 +3938,7 @@ static int enable_cpucache(struct kmem_cache *cachep)
 	if (limit > 32)
 		limit = 32;
 #endif
-	err = do_tune_cpucache(cachep, limit, (limit + 1) / 2, shared);
+	err = do_tune_cpucache(cachep, limit, (limit + 1) / 2, shared, gfp);
 	if (err)
 		printk(KERN_ERR "enable_cpucache failed for %s, error %d.\n",
 		       cachep->name, -err);
@@ -4240,7 +4244,8 @@ ssize_t slabinfo_write(struct file *file, const char __user * buffer,
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
index 44bc77c..3cc5e98 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2582,13 +2582,16 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
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
@@ -3048,7 +3051,7 @@ void __init kmem_cache_init(void)
 	 * kmem_cache_open for slab_state == DOWN.
 	 */
 	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
-		sizeof(struct kmem_cache_node), GFP_KERNEL);
+		sizeof(struct kmem_cache_node), GFP_NOWAIT);
 	kmalloc_caches[0].refcount = -1;
 	caches++;
 
@@ -3061,16 +3064,16 @@ void __init kmem_cache_init(void)
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
 
@@ -3107,7 +3110,7 @@ void __init kmem_cache_init(void)
 	/* Provide the correct kmalloc names now that the caches are up */
 	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++)
 		kmalloc_caches[i]. name =
-			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
+			kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
 
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
-- 
1.6.0.4

 
