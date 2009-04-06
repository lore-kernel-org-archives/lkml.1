Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZDFAxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZDFAxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 20:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZDFAwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 20:52:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDFAwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 20:52:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=AmzhuTY6CIPOnRBH8FArHbJ5thSQ1fCES1U4A3ESuGKLjqYGzbX5u+V+9PprhIAFd
	En+n4nei2+x+xtWff7/hA==
Date: Sun, 5 Apr 2009 17:52:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] slub: default min_partial to at least highest cpus per
 node
Message-ID: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pre-defined MIN_PARTIAL value may not be suitable for machines with a
large number of cpus per node.  To avoid excessively allocating new slabs
because there is not at least the same number of slabs on a node's
partial list as cpus, this will default a cache's min_partial value to be
at least the highest number of cpus per node on the system.

This default will never exceed MAX_PARTIAL, however, so very large
systems don't waste an excessive amount of memory.

When remote_node_defrag_ratio allows defragmenting remote nodes, it
ensures that nr_partial exceeds min_partial so there will always be a
local reserve when a cpu slab is filled to avoid allocating new slabs
locally as a result of a remote cpu stealing a partial slab.

The cache's min_partial setting may still be changed by writing to
/sys/kernel/slab/cache/min_partial.  The only restriction when doing so
is that the value be within MIN_PARTIAL and MAX_PARTIAL.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |   50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1941,6 +1941,15 @@ static unsigned long calculate_alignment(unsigned long flags,
 	return ALIGN(align, sizeof(void *));
 }
 
+static void set_min_partial(struct kmem_cache *s, unsigned long min)
+{
+	if (min < MIN_PARTIAL)
+		min = MIN_PARTIAL;
+	else if (min > MAX_PARTIAL)
+		min = MAX_PARTIAL;
+	s->min_partial = min;
+}
+
 static void init_kmem_cache_cpu(struct kmem_cache *s,
 			struct kmem_cache_cpu *c)
 {
@@ -2093,6 +2102,8 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
 #endif
 
 #ifdef CONFIG_NUMA
+static unsigned long min_partial_per_node;
+
 /*
  * No kmalloc_node yet so do it by hand. We know that this is the first
  * slab on the node for this slabcache. There are no concurrent accesses
@@ -2188,6 +2199,26 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 	}
 	return 1;
 }
+
+static void __cpuinit set_min_partial_per_node(int node)
+{
+	unsigned int nr_cpus;
+
+	/*
+	 * Add one cpu since this is called for CPU_UP_PREPARE and this cpu is
+	 * not online yet.  CPU_ONLINE would require taking slub_lock.
+	 */
+	nr_cpus = nr_cpus_node(node) + 1;
+	if (nr_cpus > min_partial_per_node)
+		min_partial_per_node = min_t(unsigned long,
+					     nr_cpus, MAX_PARTIAL);
+}
+
+static void set_cache_min_partial_per_node(struct kmem_cache *s)
+{
+	if (s->min_partial < min_partial_per_node)
+		set_min_partial(s, min_partial_per_node);
+}
 #else
 static void free_kmem_cache_nodes(struct kmem_cache *s)
 {
@@ -2198,16 +2229,15 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 	init_kmem_cache_node(&s->local_node, s);
 	return 1;
 }
-#endif
 
-static void set_min_partial(struct kmem_cache *s, unsigned long min)
+static inline void set_min_partial_per_node(int node)
+{
+}
+
+static inline void set_cache_min_partial_per_node(const struct kmem_cache *s)
 {
-	if (min < MIN_PARTIAL)
-		min = MIN_PARTIAL;
-	else if (min > MAX_PARTIAL)
-		min = MAX_PARTIAL;
-	s->min_partial = min;
 }
+#endif
 
 /*
  * calculate_sizes() determines the order and the distribution of data within
@@ -2352,6 +2382,7 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	 * list to avoid pounding the page allocator excessively.
 	 */
 	set_min_partial(s, ilog2(s->size));
+	set_cache_min_partial_per_node(s);
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -3239,10 +3270,13 @@ static int __cpuinit slab_cpuup_callback(struct notifier_block *nfb,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		init_alloc_cpu_cpu(cpu);
+		set_min_partial_per_node(cpu_to_node(cpu));
 		down_read(&slub_lock);
-		list_for_each_entry(s, &slab_caches, list)
+		list_for_each_entry(s, &slab_caches, list) {
 			s->cpu_slab[cpu] = alloc_kmem_cache_cpu(s, cpu,
 							GFP_KERNEL);
+			set_cache_min_partial_per_node(s);
+		}
 		up_read(&slub_lock);
 		break;
 
