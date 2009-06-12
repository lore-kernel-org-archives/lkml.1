Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZFLPrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZFLPrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZFLPre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:47:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50587 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZFLPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:47:34 -0400
Date: Fri, 12 Jun 2009 18:47:35 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       cl@linux-foundation.org, akpm@linux-foundation.org, npiggin@suse.de,
       benh@kernel.crashing.org
Subject: [PATCH 2/3 v2] slab,slub: don't enable interrupts during early boot
In-Reply-To: <Pine.LNX.4.64.0906121840550.5491@melkki.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0906121846460.5670@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121840550.5491@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As explained by Benjamin Herrenschmidt:

  Oh and btw, your patch alone doesn't fix powerpc, because it's missing
  a whole bunch of GFP_KERNEL's in the arch code... You would have to
  grep the entire kernel for things that check slab_is_available() and
  even then you'll be missing some.

  For example, slab_is_available() didn't always exist, and so in the
  early days on powerpc, we used a mem_init_done global that is set form
  mem_init() (not perfect but works in practice). And we still have code
  using that to do the test.

Therefore, mask out __GFP_WAIT in the slab allocators in early boot code to
avoid enabling interrupts.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/gfp.h      |    3 +++
 include/linux/slab.h     |    2 ++
 include/linux/slob_def.h |    5 +++++
 include/linux/slub_def.h |    2 ++
 init/main.c              |    1 +
 mm/slab.c                |   18 ++++++++++++++++++
 mm/slub.c                |   16 ++++++++++++++++
 7 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0bbc15f..ec0fede 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -85,6 +85,9 @@ struct vm_area_struct;
 			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
 			__GFP_NORETRY|__GFP_NOMEMALLOC)
 
+/* Control slab gfp mask during early boot */
+#define SLAB_GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS);
+
 /* Control allocation constraints */
 #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
 
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
index b3e8f14..f6204f7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -640,6 +640,7 @@ asmlinkage void __init start_kernel(void)
 				 "enabled early\n");
 	early_boot_irqs_on();
 	local_irq_enable();
+	kmem_cache_init_late();
 
 	/*
 	 * HACK ALERT! This is early. We're enabling the console before
diff --git a/mm/slab.c b/mm/slab.c
index cd76964..453efcb 100644
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
@@ -1654,6 +1660,14 @@ void __init kmem_cache_init(void)
 	 */
 }
 
+void __init kmem_cache_init_late(void)
+{
+	/*
+	 * Interrupts are enabled now so all GFP allocations are safe.
+	 */
+	slab_gfp_mask = __GFP_BITS_MASK;
+}
+
 static int __init cpucache_init(void)
 {
 	int cpu;
@@ -3354,6 +3368,8 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	unsigned long save_flags;
 	void *ptr;
 
+	flags &= slab_gfp_mask;
+
 	lockdep_trace_alloc(flags);
 
 	if (slab_should_failslab(cachep, flags))
@@ -3434,6 +3450,8 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
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
-- 
1.6.0.4

