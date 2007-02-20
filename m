Return-Path: <linux-kernel-owner+w=401wt.eu-S965058AbXBTTGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058AbXBTTGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964788AbXBTTGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:06:05 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:59018 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092AbXBTTGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:06:04 -0500
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 14:06:03 EST
Message-ID: <45DB404C.4070305@qualcomm.com>
Date: Tue, 20 Feb 2007 10:39:08 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru>
In-Reply-To: <20070129182742.GA158@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Oleg Nesterov wrote:
>>> Even if smp_processor_id() was stable during the execution of cache_reap(),
>>> this work_struct can be moved to another CPU if CPU_DEAD happens. We can't
>>> avoid this, and this is correct.
>> Uhh.... This may not be correct in terms of how the slab operates.
> 
> But this is practically impossible to avoid. We can't delay CPU_DOWN until all
> workqueues flush their cwq->worklist. This is livelockable, the work can re-queue
> itself, and new works can be added since the dying CPU is still on cpu_online_map.
> This means that some pending works will be processed on another CPU.
> 
> delayed_work is even worse, the timer can migrate as well.
> 
> The first problem (smp_processor_id() is not stable) could be solved if we
> use freezer or with the help of not-yet-implemented scalable lock_cpu_hotplug.
> 
>>> This means that __get_cpu_var(reap_work) returns a "wrong" struct delayed_work.
>>> This is absolutely harmless right now, but may be it's better to use
>>> container_of(unused, struct delayed_work, work).
>> Well seems that we have a set of unresolved issues with workqueues and cpu 
>> hotplug.

How about storing 'cpu' explicitly in the work queue instead of relying on the
smp_processor_id() and friends ? That way there is no ambiguity when threads/timers get
moved around.
I'm cooking a set of patches to extend cpu isolation concept a bit. In which case I'd
like one CPU to run cache_reap timer on behalf of another cpu. See the patch below.

diff --git a/mm/slab.c b/mm/slab.c
index c610062..0f46d11 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -766,7 +766,17 @@ int slab_is_available(void)
  	return g_cpucache_up == FULL;
  }

-static DEFINE_PER_CPU(struct delayed_work, reap_work);
+struct slab_work {
+	struct delayed_work dw;
+	unsigned int       cpu;
+};
+
+static DEFINE_PER_CPU(struct slab_work, reap_work);
+
+static inline struct array_cache *cpu_cache_get_on(struct kmem_cache *cachep, unsigned int cpu)
+{
+	return cachep->array[cpu];
+}

  static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
  {
@@ -915,9 +925,9 @@ static void init_reap_node(int cpu)
  	per_cpu(reap_node, cpu) = node;
  }

-static void next_reap_node(void)
+static void next_reap_node(unsigned int cpu)
  {
-	int node = __get_cpu_var(reap_node);
+	int node = per_cpu(reap_node, cpu);

  	/*
  	 * Also drain per cpu pages on remote zones
@@ -928,12 +938,12 @@ static void next_reap_node(void)
  	node = next_node(node, node_online_map);
  	if (unlikely(node >= MAX_NUMNODES))
  		node = first_node(node_online_map);
-	__get_cpu_var(reap_node) = node;
+	per_cpu(reap_node, cpu) = node;
  }

  #else
  #define init_reap_node(cpu) do { } while (0)
-#define next_reap_node(void) do { } while (0)
+#define next_reap_node(cpu) do { } while (0)
  #endif

  /*
@@ -945,17 +955,18 @@ static void next_reap_node(void)
   */
  static void __devinit start_cpu_timer(int cpu)
  {
-	struct delayed_work *reap_work = &per_cpu(reap_work, cpu);
+	struct slab_work *reap_work = &per_cpu(reap_work, cpu);

  	/*
  	 * When this gets called from do_initcalls via cpucache_init(),
  	 * init_workqueues() has already run, so keventd will be setup
  	 * at that time.
  	 */
-	if (keventd_up() && reap_work->work.func == NULL) {
+	if (keventd_up() && reap_work->dw.work.func == NULL) {
  		init_reap_node(cpu);
-		INIT_DELAYED_WORK(reap_work, cache_reap);
-		schedule_delayed_work_on(cpu, reap_work,
+		INIT_DELAYED_WORK(&reap_work->dw, cache_reap);
+		reap_work->cpu = cpu;
+		schedule_delayed_work_on(cpu, &reap_work->dw,
  					__round_jiffies_relative(HZ, cpu));
  	}
  }
@@ -1004,7 +1015,7 @@ static int transfer_objects(struct array_cache *to,
  #ifndef CONFIG_NUMA

  #define drain_alien_cache(cachep, alien) do { } while (0)
-#define reap_alien(cachep, l3) do { } while (0)
+#define reap_alien(cachep, l3, cpu) do { } while (0)

  static inline struct array_cache **alloc_alien_cache(int node, int limit)
  {
@@ -1099,9 +1110,9 @@ static void __drain_alien_cache(struct kmem_cache *cachep,
  /*
   * Called from cache_reap() to regularly drain alien caches round robin.
   */
-static void reap_alien(struct kmem_cache *cachep, struct kmem_list3 *l3)
+static void reap_alien(struct kmem_cache *cachep, struct kmem_list3 *l3, unsigned int cpu)
  {
-	int node = __get_cpu_var(reap_node);
+	int node = per_cpu(reap_node, cpu);

  	if (l3->alien) {
  		struct array_cache *ac = l3->alien[node];
@@ -4017,16 +4028,17 @@ void drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
   * If we cannot acquire the cache chain mutex then just give up - we'll try
   * again on the next iteration.
   */
-static void cache_reap(struct work_struct *unused)
+static void cache_reap(struct work_struct *_work)
  {
  	struct kmem_cache *searchp;
  	struct kmem_list3 *l3;
  	int node = numa_node_id();

+	struct slab_work *work = (struct slab_work *) _work;
+
  	if (!mutex_trylock(&cache_chain_mutex)) {
  		/* Give up. Setup the next iteration. */
-		schedule_delayed_work(&__get_cpu_var(reap_work),
-				      round_jiffies_relative(REAPTIMEOUT_CPUC));
+		schedule_delayed_work(&work->dw, round_jiffies_relative(REAPTIMEOUT_CPUC));
  		return;
  	}

@@ -4040,9 +4052,9 @@ static void cache_reap(struct work_struct *unused)
  		 */
  		l3 = searchp->nodelists[node];

-		reap_alien(searchp, l3);
+		reap_alien(searchp, l3, work->cpu);

-		drain_array(searchp, l3, cpu_cache_get(searchp), 0, node);
+		drain_array(searchp, l3, cpu_cache_get_on(searchp, work->cpu), 0, node);

  		/*
  		 * These are racy checks but it does not matter
@@ -4069,11 +4081,11 @@ next:
  	}
  	check_irq_on();
  	mutex_unlock(&cache_chain_mutex);
-	next_reap_node();
-	refresh_cpu_vm_stats(smp_processor_id());
+	next_reap_node(work->cpu);
+	refresh_cpu_vm_stats(work->cpu);
+
  	/* Set up the next iteration */
-	schedule_delayed_work(&__get_cpu_var(reap_work),
-		round_jiffies_relative(REAPTIMEOUT_CPUC));
+	schedule_delayed_work(&work->dw, round_jiffies_relative(REAPTIMEOUT_CPUC));
  }

  #ifdef CONFIG_PROC_FS


Max



