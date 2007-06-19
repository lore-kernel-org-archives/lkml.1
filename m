Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbXFSXR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbXFSXR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbXFSXRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:17:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48193 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754622AbXFSXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:17:19 -0400
Date: Tue, 19 Jun 2007 16:17:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 26/26] SLUB: Place kmem_cache_cpu structures in a NUMA
 aware way.
In-Reply-To: <20070618095919.579023320@sgi.com>
Message-ID: <Pine.LNX.4.64.0706191615490.15951@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com> <20070618095919.579023320@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some fixups to this patch:


Fix issues with per cpu kmem_cache_cpu arrays.

1. During cpu bootstrap we also need to bootstrap the per cpu array
   for the cpu in SLUB.
   kmem_cache_init is called while only a single cpu is marked online.

2. The size determination of the kmem_cache array is wrong for UP.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-19 15:38:22.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-19 16:13:17.000000000 -0700
@@ -2016,21 +2016,28 @@ static int alloc_kmem_cache_cpus(struct 
 	return 1;
 }
 
+/*
+ * Initialize the per cpu array.
+ */
+static void init_alloc_cpu_cpu(int cpu)
+{
+	int i;
+
+	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
+		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
+}
+
 static void __init init_alloc_cpu(void)
 {
 	int cpu;
-	int i;
 
-	for_each_online_cpu(cpu) {
-		for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
-			free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i],
-								cpu);
-	}
+	for_each_online_cpu(cpu)
+		init_alloc_cpu_cpu(cpu);
 }
 
 #else
 static inline void free_kmem_cache_cpus(struct kmem_cache *s) {}
-static inline void init_alloc_cpu(struct kmem_cache *s) {}
+static inline void init_alloc_cpu(void) {}
 
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
 {
@@ -3094,10 +3101,12 @@ void __init kmem_cache_init(void)
 
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
-#endif
-
 	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
 				nr_cpu_ids * sizeof(struct kmem_cache_cpu *);
+#else
+	kmem_size = sizeof(struct kmem_cache);
+#endif
+
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d,"
 		" MinObjects=%d, CPUs=%d, Nodes=%d\n",
@@ -3244,6 +3253,7 @@ static int __cpuinit slab_cpuup_callback
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
+		init_alloc_cpu_cpu(cpu);
 		down_read(&slub_lock);
 		list_for_each_entry(s, &slab_caches, list)
 			s->cpu_slab[cpu] = alloc_kmem_cache_cpu(cpu,
