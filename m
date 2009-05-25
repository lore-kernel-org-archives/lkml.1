Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZEYEqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZEYEqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 00:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZEYEqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 00:46:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:45494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZEYEqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 00:46:35 -0400
Message-ID: <4A1A2261.1000504@kernel.org>
Date: Sun, 24 May 2009 21:45:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
References: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu> <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain> <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu>
In-Reply-To: <20090525025353.GA2580@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Pekka J Enberg wrote:
>>> On Mon, 18 May 2009, Linus Torvalds wrote:
>>>>>> I hate that stupid bootmem allocator. I suspect we seriously 
>>>>>> over-use it, and that we _should_ be able to do the SL*B init 
>>>>>> earlier.
>>>>> Hm, tempting thought - not sure how to pull it off though.
>>>> As far as I can recall, one of the things that historically made us want 
>>>> to use the bootmem allocator even relatively late was that the real SLAB 
>>>> allocator had to wait until all the node information etc was initialized. 
>>>>
>>>> That's pretty damn late. And I wonder if SLUB (and SLOB) might not need a 
>>>> lot less initialization, and work much earlier. Something like that might 
>>>> be the final nail in the coffin for SLAB, and convince me to just say 
>>>> 'we don't support it any more".
>>> Ingo, here's a patch that boots UMA+SMP+SLUB x86-64 kernel on qemu all 
>>> the way to userspace. It probably breaks bunch of things for now but 
>>> something for you to play with if you want.
>>>
>> updated with tip/master. also add change to cpupri_init
>> otherwise will get 
>> [    0.000000] Memory: 523096612k/537526272k available (10461k kernel code, 656156k absent, 13773504k reserved, 7186k data, 2548k init)
>> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=8
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: at kernel/lockdep.c:2282 lockdep_trace_alloc+0xaf/0xee()
>> [    0.000000] Hardware name: Sun Fire X4600 M2
>> [    0.000000] Modules linked in:
>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-rc6-tip-01778-g0afdd0f-dirty #259
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff810a0274>] ? lockdep_trace_alloc+0xaf/0xee
>> [    0.000000]  [<ffffffff81075ab0>] warn_slowpath_common+0x88/0xcb
>> [    0.000000]  [<ffffffff81075b15>] warn_slowpath_null+0x22/0x38
>> [    0.000000]  [<ffffffff810a0274>] lockdep_trace_alloc+0xaf/0xee
>> [    0.000000]  [<ffffffff8110301b>] kmem_cache_alloc_node+0x38/0x14d
>> [    0.000000]  [<ffffffff813ec548>] ? alloc_cpumask_var_node+0x4a/0x10a
>> [    0.000000]  [<ffffffff8109eb61>] ? lockdep_init_map+0xb9/0x564
>> [    0.000000]  [<ffffffff813ec548>] alloc_cpumask_var_node+0x4a/0x10a
>> [    0.000000]  [<ffffffff813ec62c>] alloc_cpumask_var+0x24/0x3a
>> [    0.000000]  [<ffffffff819e6306>] cpupri_init+0x7f/0x112
>> [    0.000000]  [<ffffffff819e5a30>] init_rootdomain+0x72/0xb7
>> [    0.000000]  [<ffffffff821facce>] sched_init+0x109/0x660
>> [    0.000000]  [<ffffffff82203082>] ? kmem_cache_init+0x193/0x1b2
>> [    0.000000]  [<ffffffff821dfd7a>] start_kernel+0x218/0x3f3
>> [    0.000000]  [<ffffffff821df2a9>] x86_64_start_reservations+0xb9/0xd4
>> [    0.000000]  [<ffffffff821df3b2>] x86_64_start_kernel+0xee/0x109
>> [    0.000000] ---[ end trace a7919e7f17c0a725 ]---
>>
>> works with 8 sockets numa amd64 box.
>>
>> YH
>>
>> ---
>>  init/main.c           |   28 ++++++++++++++++------------
>>  kernel/irq/handle.c   |   23 ++++++++---------------
>>  kernel/sched.c        |   34 +++++++++++++---------------------
>>  kernel/sched_cpupri.c |    9 ++++++---
>>  mm/slub.c             |   17 ++++++++++-------
>>  5 files changed, 53 insertions(+), 58 deletions(-)
> 
> Very nice!
> 
> Would it be possible to restructure things to move kmalloc init to 
> before IRQ init as well? We have a couple of uglinesses there too.
> 
> Conceptually, memory should be the first thing set up in general, in 
> a kernel. It does not need IRQs, timers, the scheduler or any of the 
> IO facilities and abstractions. All of them need memory though - and 
> as Linux scales to more and more hardware via the same single image, 
> so will we get more and more dynamic concepts like cpumask_var_t and 
> sparse-irqs, which want to allocate very early.

Pekka's patch already made kmalloc before early_irq_init()/init_IRQ...

we can clean up alloc_desc_masks and
alloc_cpumask_var_node could be much simplified too.

[PATCH] x86: remove some alloc_bootmem_cpumask_var calling

except some is called from setup_percpu_area...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 include/linux/irq.h            |   18 +++++++-----------
 kernel/cpuset.c                |    2 +-
 kernel/profile.c               |    6 ------
 lib/cpumask.c                  |   11 ++---------
 5 files changed, 12 insertions(+), 29 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -430,23 +430,19 @@ extern int set_irq_msi(unsigned int irq,
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
Index: linux-2.6/lib/cpumask.c
===================================================================
--- linux-2.6.orig/lib/cpumask.c
+++ linux-2.6/lib/cpumask.c
@@ -92,15 +92,8 @@ int cpumask_any_but(const struct cpumask
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
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -185,8 +185,8 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
-		alloc_bootmem_cpumask_var(&cfg[i].domain);
-		alloc_bootmem_cpumask_var(&cfg[i].old_domain);
+		alloc_cpumask_var(&cfg[i].domain, GFP_NOWAIT);
+		alloc_cpumask_var(&cfg[i].old_domain, GFP_NOWAIT);
 		if (i < NR_IRQS_LEGACY)
 			cpumask_setall(cfg[i].domain);
 	}
Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -1857,7 +1857,7 @@ struct cgroup_subsys cpuset_subsys = {
 
 int __init cpuset_init_early(void)
 {
-	alloc_bootmem_cpumask_var(&top_cpuset.cpus_allowed);
+	alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_NOWAIT);
 
 	top_cpuset.mems_generation = cpuset_mems_generation++;
 	return 0;
Index: linux-2.6/kernel/profile.c
===================================================================
--- linux-2.6.orig/kernel/profile.c
+++ linux-2.6/kernel/profile.c
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


