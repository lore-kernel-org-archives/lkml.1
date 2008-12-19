Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbYLSQEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbYLSQEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYLSQBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:53 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59244 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751479AbYLSQBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:48 -0500
Message-Id: <20081219160145.535077000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:50 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 6/8] cpumask: convert kernel mm functions
Content-Disposition: inline; filename=cpumask:convert-mm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce stack usage, use new cpumask API.

Convert kernel mm functions to use struct cpumask.

We skip include/linux/percpu.h and mm/allocpercpu.c, which are in flux.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
---
 mm/pdflush.c |   16 +++++++++++++---
 mm/slab.c    |    2 +-
 mm/slub.c    |   20 +++++++++++---------
 mm/vmscan.c  |    2 +-
 mm/vmstat.c  |    4 ++--
 5 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/mm/pdflush.c b/mm/pdflush.c
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -172,7 +172,16 @@ static int pdflush(void *dummy)
 static int pdflush(void *dummy)
 {
 	struct pdflush_work my_work;
-	cpumask_t cpus_allowed;
+	cpumask_var_t cpus_allowed;
+
+	/*
+	 * Since the caller doesn't even check kthread_run() worked, let's not
+	 * freak out too much if this fails.
+	 */
+	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
+		printk(KERN_WARNING "pdflush failed to allocate cpumask\n");
+		return 0;
+	}
 
 	/*
 	 * pdflush can spend a lot of time doing encryption via dm-crypt.  We
@@ -187,8 +196,9 @@ static int pdflush(void *dummy)
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.
 	 */
-	cpuset_cpus_allowed(current, &cpus_allowed);
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	cpuset_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, cpus_allowed);
+	free_cpumask_var(cpus_allowed);
 
 	return __pdflush(&my_work);
 }
diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2155,7 +2155,7 @@ kmem_cache_create (const char *name, siz
 
 	/*
 	 * We use cache_chain_mutex to ensure a consistent view of
-	 * cpu_online_map as well.  Please see cpuup_callback
+	 * cpu_online_mask as well.  Please see cpuup_callback
 	 */
 	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1960,7 +1960,7 @@ static DEFINE_PER_CPU(struct kmem_cache_
 				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
 
 static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
-static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
+static DECLARE_BITMAP(kmem_cach_cpu_free_init_once, CONFIG_NR_CPUS);
 
 static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 							int cpu, gfp_t flags)
@@ -2035,13 +2035,13 @@ static void init_alloc_cpu_cpu(int cpu)
 {
 	int i;
 
-	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
+	if (cpumask_test_cpu(cpu, to_cpumask(kmem_cach_cpu_free_init_once)))
 		return;
 
 	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
 		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
 
-	cpu_set(cpu, kmem_cach_cpu_free_init_once);
+	cpumask_set_cpu(cpu, to_cpumask(kmem_cach_cpu_free_init_once));
 }
 
 static void __init init_alloc_cpu(void)
@@ -3433,7 +3433,7 @@ struct location {
 	long max_time;
 	long min_pid;
 	long max_pid;
-	cpumask_t cpus;
+	DECLARE_BITMAP(cpus, NR_CPUS);
 	nodemask_t nodes;
 };
 
@@ -3508,7 +3508,8 @@ static int add_location(struct loc_track
 				if (track->pid > l->max_pid)
 					l->max_pid = track->pid;
 
-				cpu_set(track->cpu, l->cpus);
+				cpumask_set_cpu(track->cpu,
+						to_cpumask(l->cpus));
 			}
 			node_set(page_to_nid(virt_to_page(track)), l->nodes);
 			return 1;
@@ -3538,8 +3539,8 @@ static int add_location(struct loc_track
 	l->max_time = age;
 	l->min_pid = track->pid;
 	l->max_pid = track->pid;
-	cpus_clear(l->cpus);
-	cpu_set(track->cpu, l->cpus);
+	cpumask_clear(to_cpumask(l->cpus));
+	cpumask_set_cpu(track->cpu, to_cpumask(l->cpus));
 	nodes_clear(l->nodes);
 	node_set(page_to_nid(virt_to_page(track)), l->nodes);
 	return 1;
@@ -3620,11 +3621,12 @@ static int list_locations(struct kmem_ca
 			len += sprintf(buf + len, " pid=%ld",
 				l->min_pid);
 
-		if (num_online_cpus() > 1 && !cpus_empty(l->cpus) &&
+		if (num_online_cpus() > 1 &&
+				!cpumask_empty(to_cpumask(l->cpus)) &&
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " cpus=");
 			len += cpulist_scnprintf(buf + len, PAGE_SIZE - len - 50,
-					&l->cpus);
+						 to_cpumask(l->cpus));
 		}
 
 		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1902,7 +1902,7 @@ static int kswapd(void *p)
 	};
 	node_to_cpumask_ptr(cpumask, pgdat->node_id);
 
-	if (!cpus_empty(*cpumask))
+	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(tsk, cpumask);
 	current->reclaim_state = &reclaim_state;
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -20,7 +20,7 @@ DEFINE_PER_CPU(struct vm_event_state, vm
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
-static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
+static void sum_vm_events(unsigned long *ret, const struct cpumask *cpumask)
 {
 	int cpu;
 	int i;
@@ -43,7 +43,7 @@ void all_vm_events(unsigned long *ret)
 void all_vm_events(unsigned long *ret)
 {
 	get_online_cpus();
-	sum_vm_events(ret, &cpu_online_map);
+	sum_vm_events(ret, cpu_online_mask);
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(all_vm_events);

-- 
