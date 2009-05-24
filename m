Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZEXQN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZEXQN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZEXQNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 12:13:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42038 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZEXQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 12:13:49 -0400
Date: Sun, 24 May 2009 19:13:49 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
 <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
 <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
 <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Linus Torvalds wrote:
> > > I hate that stupid bootmem allocator. I suspect we seriously 
> > > over-use it, and that we _should_ be able to do the SL*B init 
> > > earlier.
> > 
> > Hm, tempting thought - not sure how to pull it off though.
> 
> As far as I can recall, one of the things that historically made us want 
> to use the bootmem allocator even relatively late was that the real SLAB 
> allocator had to wait until all the node information etc was initialized. 
> 
> That's pretty damn late. And I wonder if SLUB (and SLOB) might not need a 
> lot less initialization, and work much earlier. Something like that might 
> be the final nail in the coffin for SLAB, and convince me to just say 
> 'we don't support it any more".

Ingo, here's a patch that boots UMA+SMP+SLUB x86-64 kernel on qemu all 
the way to userspace. It probably breaks bunch of things for now but 
something for you to play with if you want.

			Pekka

diff --git a/init/main.c b/init/main.c
index 3bbf93b..856afa9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -575,6 +575,22 @@ asmlinkage void __init start_kernel(void)
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
+	 * Setup kernel memory allocators
+	 */
+	pidhash_init();
+	vmalloc_init();
+	vfs_caches_init_early();
+	mem_init();
+	kmem_cache_init();
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
@@ -586,13 +602,6 @@ asmlinkage void __init start_kernel(void)
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
@@ -604,7 +613,6 @@ asmlinkage void __init start_kernel(void)
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
-	pidhash_init();
 	init_timers();
 	hrtimers_init();
 	softirq_init();
@@ -646,14 +654,10 @@ asmlinkage void __init start_kernel(void)
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
index 26e0875..702a696 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -18,7 +18,7 @@
 #include <linux/rculist.h>
 #include <linux/hash.h>
 #include <trace/irq.h>
-#include <linux/bootmem.h>
+#include <linux/slab.h>
 
 #include "internals.h"
 
@@ -44,7 +44,7 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 static void __init init_irq_default_affinity(void)
 {
-	alloc_bootmem_cpumask_var(&irq_default_affinity);
+	alloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
 	cpumask_setall(irq_default_affinity);
 }
 #else
@@ -158,12 +158,12 @@ int __init early_irq_init(void)
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..b403536 100644
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
@@ -7525,21 +7524,18 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 
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
 
 	if (cpupri_init(&rd->cpupri, false) != 0)
@@ -8860,12 +8856,8 @@ void __init sched_init(void)
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
@@ -9051,12 +9043,12 @@ void __init sched_init(void)
 	current->sched_class = &fair_sched_class;
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	alloc_bootmem_cpumask_var(&nohz_cpu_mask);
+	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
+	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 #endif
-	alloc_bootmem_cpumask_var(&cpu_isolated_map);
+	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	scheduler_running = 1;
diff --git a/mm/slub.c b/mm/slub.c
index 65ffda5..0ead807 100644
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
