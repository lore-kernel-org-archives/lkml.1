Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZLLITW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZLLITW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 03:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZLLITV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 03:19:21 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58179 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZLLITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 03:19:20 -0500
Date: Sat, 12 Dec 2009 10:19:25 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, a.p.zijlstra@chello.nl,
       catalin.marinas@arm.com, cl@linux-foundation.org, hooanon05@yahoo.co.jp,
       paulmck@linux.vnet.ibm.com, rientjes@google.com, tim@klingt.org
Subject: [GIT PULL] SLAB updates for 2.6.33
Message-ID: <alpine.DEB.2.00.0912121015400.15396@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It's been rather quiet on the SLAB front. Here's the usual batch of minor 
bug fixes accumulated over the past release cycle.

 			Pekka

The following changes since commit 053fe57ac249a9531c396175778160d9e9509399:
   Linus Torvalds (1):
         Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 for-linus

David Rientjes (1):
       slub: allow stats to be cleared

J. R. Okajima (2):
       slab, kmemleak: stop calling kmemleak_erase() unconditionally
       slab, kmemleak: pass the correct pointer to kmemleak_erase()

Pekka Enberg (3):
       SLUB: Fix __GFP_ZERO unlikely() annotation
       SLAB: Fix lockdep annotations for CPU hotplug
       Merge branches 'slab/fixes', 'slab/kmemleak', 'slub/perf' and 'slub/stats' into for-linus

Tim Blechmann (1):
       SLAB: Fix unlikely() annotation in __cache_alloc_node()

  Documentation/ABI/testing/sysfs-kernel-slab |  109 +++++++++++++------------
  mm/slab.c                                   |  118 ++++++++++++++++-----------
  mm/slub.c                                   |   20 ++++-
  3 files changed, 145 insertions(+), 102 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-slab b/Documentation/ABI/testing/sysfs-kernel-slab
index 6dcf75e..8b093f8 100644
--- a/Documentation/ABI/testing/sysfs-kernel-slab
+++ b/Documentation/ABI/testing/sysfs-kernel-slab
@@ -45,8 +45,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The alloc_fastpath file is read-only and specifies how many
-		objects have been allocated using the fast path.
+		The alloc_fastpath file shows how many objects have been
+		allocated using the fast path.  It can be written to clear the
+		current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/alloc_from_partial
@@ -55,9 +56,10 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The alloc_from_partial file is read-only and specifies how
-		many times a cpu slab has been full and it has been refilled
-		by using a slab from the list of partially used slabs.
+		The alloc_from_partial file shows how many times a cpu slab has
+		been full and it has been refilled by using a slab from the list
+		of partially used slabs.  It can be written to clear the current
+		count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/alloc_refill
@@ -66,9 +68,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The alloc_refill file is read-only and specifies how many
-		times the per-cpu freelist was empty but there were objects
-		available as the result of remote cpu frees.
+		The alloc_refill file shows how many times the per-cpu freelist
+		was empty but there were objects available as the result of
+		remote cpu frees.  It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/alloc_slab
@@ -77,8 +79,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The alloc_slab file is read-only and specifies how many times
-		a new slab had to be allocated from the page allocator.
+		The alloc_slab file is shows how many times a new slab had to
+		be allocated from the page allocator.  It can be written to
+		clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/alloc_slowpath
@@ -87,9 +90,10 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The alloc_slowpath file is read-only and specifies how many
-		objects have been allocated using the slow path because of a
-		refill or allocation from a partial or new slab.
+		The alloc_slowpath file shows how many objects have been
+		allocated using the slow path because of a refill or
+		allocation from a partial or new slab.  It can be written to
+		clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/cache_dma
@@ -117,10 +121,11 @@ KernelVersion:	2.6.31
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file cpuslab_flush is read-only and specifies how many
-		times a cache's cpu slabs have been flushed as the result of
-		destroying or shrinking a cache, a cpu going offline, or as
-		the result of forcing an allocation from a certain node.
+		The file cpuslab_flush shows how many times a cache's cpu slabs
+		have been flushed as the result of destroying or shrinking a
+		cache, a cpu going offline, or as the result of forcing an
+		allocation from a certain node.  It can be written to clear the
+		current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/ctor
@@ -139,8 +144,8 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file deactivate_empty is read-only and specifies how many
-		times an empty cpu slab was deactivated.
+		The deactivate_empty file shows how many times an empty cpu slab
+		was deactivated.  It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/deactivate_full
@@ -149,8 +154,8 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file deactivate_full is read-only and specifies how many
-		times a full cpu slab was deactivated.
+		The deactivate_full file shows how many times a full cpu slab
+		was deactivated.  It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/deactivate_remote_frees
@@ -159,9 +164,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file deactivate_remote_frees is read-only and specifies how
-		many times a cpu slab has been deactivated and contained free
-		objects that were freed remotely.
+		The deactivate_remote_frees file shows how many times a cpu slab
+		has been deactivated and contained free objects that were freed
+		remotely.  It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/deactivate_to_head
@@ -170,9 +175,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file deactivate_to_head is read-only and specifies how
-		many times a partial cpu slab was deactivated and added to the
-		head of its node's partial list.
+		The deactivate_to_head file shows how many times a partial cpu
+		slab was deactivated and added to the head of its node's partial
+		list.  It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/deactivate_to_tail
@@ -181,9 +186,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file deactivate_to_tail is read-only and specifies how
-		many times a partial cpu slab was deactivated and added to the
-		tail of its node's partial list.
+		The deactivate_to_tail file shows how many times a partial cpu
+		slab was deactivated and added to the tail of its node's partial
+		list.  It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/destroy_by_rcu
@@ -201,9 +206,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file free_add_partial is read-only and specifies how many
-		times an object has been freed in a full slab so that it had to
-		added to its node's partial list.
+		The free_add_partial file shows how many times an object has
+		been freed in a full slab so that it had to added to its node's
+		partial list.  It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/free_calls
@@ -222,9 +227,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The free_fastpath file is read-only and specifies how many
-		objects have been freed using the fast path because it was an
-		object from the cpu slab.
+		The free_fastpath file shows how many objects have been freed
+		using the fast path because it was an object from the cpu slab.
+		It can be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/free_frozen
@@ -233,9 +238,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The free_frozen file is read-only and specifies how many
-		objects have been freed to a frozen slab (i.e. a remote cpu
-		slab).
+		The free_frozen file shows how many objects have been freed to
+		a frozen slab (i.e. a remote cpu slab).  It can be written to
+		clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/free_remove_partial
@@ -244,9 +249,10 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file free_remove_partial is read-only and specifies how
-		many times an object has been freed to a now-empty slab so
-		that it had to be removed from its node's partial list.
+		The free_remove_partial file shows how many times an object has
+		been freed to a now-empty slab so that it had to be removed from
+		its node's partial list.  It can be written to clear the current
+		count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/free_slab
@@ -255,8 +261,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The free_slab file is read-only and specifies how many times an
-		empty slab has been freed back to the page allocator.
+		The free_slab file shows how many times an empty slab has been
+		freed back to the page allocator.  It can be written to clear
+		the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/free_slowpath
@@ -265,9 +272,9 @@ KernelVersion:	2.6.25
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The free_slowpath file is read-only and specifies how many
-		objects have been freed using the slow path (i.e. to a full or
-		partial slab).
+		The free_slowpath file shows how many objects have been freed
+		using the slow path (i.e. to a full or partial slab).  It can
+		be written to clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/hwcache_align
@@ -346,10 +353,10 @@ KernelVersion:	2.6.26
  Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
  		Christoph Lameter <cl@linux-foundation.org>
  Description:
-		The file order_fallback is read-only and specifies how many
-		times an allocation of a new slab has not been possible at the
-		cache's order and instead fallen back to its minimum possible
-		order.
+		The order_fallback file shows how many times an allocation of a
+		new slab has not been possible at the cache's order and instead
+		fallen back to its minimum possible order.  It can be written to
+		clear the current count.
  		Available when CONFIG_SLUB_STATS is enabled.

  What:		/sys/kernel/slab/cache/partial
diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..a6c9166 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -604,6 +604,26 @@ static struct kmem_cache cache_cache = {

  #define BAD_ALIEN_MAGIC 0x01020304ul

+/*
+ * chicken and egg problem: delay the per-cpu array allocation
+ * until the general caches are up.
+ */
+static enum {
+	NONE,
+	PARTIAL_AC,
+	PARTIAL_L3,
+	EARLY,
+	FULL
+} g_cpucache_up;
+
+/*
+ * used by boot code to determine if it can use slab based allocator
+ */
+int slab_is_available(void)
+{
+	return g_cpucache_up >= EARLY;
+}
+
  #ifdef CONFIG_LOCKDEP

  /*
@@ -620,40 +640,52 @@ static struct kmem_cache cache_cache = {
  static struct lock_class_key on_slab_l3_key;
  static struct lock_class_key on_slab_alc_key;

-static inline void init_lock_keys(void)
-
+static void init_node_lock_keys(int q)
  {
-	int q;
  	struct cache_sizes *s = malloc_sizes;

-	while (s->cs_size != ULONG_MAX) {
-		for_each_node(q) {
-			struct array_cache **alc;
-			int r;
-			struct kmem_list3 *l3 = s->cs_cachep->nodelists[q];
-			if (!l3 || OFF_SLAB(s->cs_cachep))
-				continue;
-			lockdep_set_class(&l3->list_lock, &on_slab_l3_key);
-			alc = l3->alien;
-			/*
-			 * FIXME: This check for BAD_ALIEN_MAGIC
-			 * should go away when common slab code is taught to
-			 * work even without alien caches.
-			 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
-			 * for alloc_alien_cache,
-			 */
-			if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
-				continue;
-			for_each_node(r) {
-				if (alc[r])
-					lockdep_set_class(&alc[r]->lock,
-					     &on_slab_alc_key);
-			}
+	if (g_cpucache_up != FULL)
+		return;
+
+	for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
+		struct array_cache **alc;
+		struct kmem_list3 *l3;
+		int r;
+
+		l3 = s->cs_cachep->nodelists[q];
+		if (!l3 || OFF_SLAB(s->cs_cachep))
+			return;
+		lockdep_set_class(&l3->list_lock, &on_slab_l3_key);
+		alc = l3->alien;
+		/*
+		 * FIXME: This check for BAD_ALIEN_MAGIC
+		 * should go away when common slab code is taught to
+		 * work even without alien caches.
+		 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
+		 * for alloc_alien_cache,
+		 */
+		if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
+			return;
+		for_each_node(r) {
+			if (alc[r])
+				lockdep_set_class(&alc[r]->lock,
+					&on_slab_alc_key);
  		}
-		s++;
  	}
  }
+
+static inline void init_lock_keys(void)
+{
+	int node;
+
+	for_each_node(node)
+		init_node_lock_keys(node);
+}
  #else
+static void init_node_lock_keys(int q)
+{
+}
+
  static inline void init_lock_keys(void)
  {
  }
@@ -665,26 +697,6 @@ static inline void init_lock_keys(void)
  static DEFINE_MUTEX(cache_chain_mutex);
  static struct list_head cache_chain;

-/*
- * chicken and egg problem: delay the per-cpu array allocation
- * until the general caches are up.
- */
-static enum {
-	NONE,
-	PARTIAL_AC,
-	PARTIAL_L3,
-	EARLY,
-	FULL
-} g_cpucache_up;
-
-/*
- * used by boot code to determine if it can use slab based allocator
- */
-int slab_is_available(void)
-{
-	return g_cpucache_up >= EARLY;
-}
-
  static DEFINE_PER_CPU(struct delayed_work, reap_work);

  static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -1254,6 +1266,8 @@ static int __cpuinit cpuup_prepare(long cpu)
  		kfree(shared);
  		free_alien_cache(alien);
  	}
+	init_node_lock_keys(node);
+
  	return 0;
  bad:
  	cpuup_canceled(cpu);
@@ -3103,13 +3117,19 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
  	} else {
  		STATS_INC_ALLOCMISS(cachep);
  		objp = cache_alloc_refill(cachep, flags);
+		/*
+		 * the 'ac' may be updated by cache_alloc_refill(),
+		 * and kmemleak_erase() requires its correct value.
+		 */
+		ac = cpu_cache_get(cachep);
  	}
  	/*
  	 * To avoid a false negative, if an object that is in one of the
  	 * per-CPU caches is leaked, we need to make sure kmemleak doesn't
  	 * treat the array pointers as a reference to the object.
  	 */
-	kmemleak_erase(&ac->entry[ac->avail]);
+	if (objp)
+		kmemleak_erase(&ac->entry[ac->avail]);
  	return objp;
  }

@@ -3306,7 +3326,7 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
  	cache_alloc_debugcheck_before(cachep, flags);
  	local_irq_save(save_flags);

-	if (unlikely(nodeid == -1))
+	if (nodeid == -1)
  		nodeid = numa_node_id();

  	if (unlikely(!cachep->nodelists[nodeid])) {
diff --git a/mm/slub.c b/mm/slub.c
index 4996fc7..da0ce55 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1735,7 +1735,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
  	}
  	local_irq_restore(flags);

-	if (unlikely((gfpflags & __GFP_ZERO) && object))
+	if (unlikely(gfpflags & __GFP_ZERO) && object)
  		memset(object, 0, objsize);

  	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
@@ -4371,12 +4371,28 @@ static int show_stat(struct kmem_cache *s, char *buf, enum stat_item si)
  	return len + sprintf(buf + len, "\n");
  }

+static void clear_stat(struct kmem_cache *s, enum stat_item si)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		get_cpu_slab(s, cpu)->stat[si] = 0;
+}
+
  #define STAT_ATTR(si, text) 					\
  static ssize_t text##_show(struct kmem_cache *s, char *buf)	\
  {								\
  	return show_stat(s, buf, si);				\
  }								\
-SLAB_ATTR_RO(text);						\
+static ssize_t text##_store(struct kmem_cache *s,		\
+				const char *buf, size_t length)	\
+{								\
+	if (buf[0] != '0')					\
+		return -EINVAL;					\
+	clear_stat(s, si);					\
+	return length;						\
+}								\
+SLAB_ATTR(text);						\

  STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
  STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
