Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYHIVFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYHIVFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbYHIVEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:04:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41305 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYHIVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:04:52 -0400
Date: Sun, 10 Aug 2008 00:04:50 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, bunk@kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, matthew@wil.cx
Subject: [GIT PULL] SLUB/SLAB/SLOB updates for 2.6.27
Message-ID: <Pine.LNX.4.64.0808100004250.28671@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The changes include unexporting of the ksize() API and addition of per-cache
sizing of partial lists for SLUB that nail down a ~1% regression wrt. SLAB for
a syntentic "netio" fio benchmark.

                Pekka

Adrian Bunk (1):
      mm: unexport ksize

Pekka Enberg (1):
      SLUB: dynamic per-cache MIN_PARTIAL

 include/linux/slub_def.h |    1 +
 mm/slab.c                |    1 -
 mm/slob.c                |    1 -
 mm/slub.c                |   27 +++++++++++++++++++--------
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 5bad61a..2f5c16b 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -46,6 +46,7 @@ struct kmem_cache_cpu {
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
+	unsigned long min_partial;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_t nr_slabs;
diff --git a/mm/slab.c b/mm/slab.c
index 918f04f..e76eee4 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4472,4 +4472,3 @@ size_t ksize(const void *objp)
 
 	return obj_size(virt_to_cache(objp));
 }
-EXPORT_SYMBOL(ksize);
diff --git a/mm/slob.c b/mm/slob.c
index d8fbd4d..4c82dd4 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -519,7 +519,6 @@ size_t ksize(const void *block)
 	else
 		return sp->page.private;
 }
-EXPORT_SYMBOL(ksize);
 
 struct kmem_cache {
 	unsigned int size, align;
diff --git a/mm/slub.c b/mm/slub.c
index b7e2cd5..4f5b961 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1329,7 +1329,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
 		n = get_node(s, zone_to_nid(zone));
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
-				n->nr_partial > MIN_PARTIAL) {
+				n->nr_partial > n->min_partial) {
 			page = get_partial_node(n);
 			if (page)
 				return page;
@@ -1381,7 +1381,7 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 		slab_unlock(page);
 	} else {
 		stat(c, DEACTIVATE_EMPTY);
-		if (n->nr_partial < MIN_PARTIAL) {
+		if (n->nr_partial < n->min_partial) {
 			/*
 			 * Adding an empty slab to the partial slabs in order
 			 * to avoid page allocator overhead. This slab needs
@@ -1913,9 +1913,21 @@ static void init_kmem_cache_cpu(struct kmem_cache *s,
 #endif
 }
 
-static void init_kmem_cache_node(struct kmem_cache_node *n)
+static void
+init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 {
 	n->nr_partial = 0;
+
+	/*
+	 * The larger the object size is, the more pages we want on the partial
+	 * list to avoid pounding the page allocator excessively.
+	 */
+	n->min_partial = ilog2(s->size);
+	if (n->min_partial < MIN_PARTIAL)
+		n->min_partial = MIN_PARTIAL;
+	else if (n->min_partial > MAX_PARTIAL)
+		n->min_partial = MAX_PARTIAL;
+
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
@@ -2087,7 +2099,7 @@ static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
 	init_object(kmalloc_caches, n, 1);
 	init_tracking(kmalloc_caches, n);
 #endif
-	init_kmem_cache_node(n);
+	init_kmem_cache_node(n, kmalloc_caches);
 	inc_slabs_node(kmalloc_caches, node, page->objects);
 
 	/*
@@ -2144,7 +2156,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 
 		}
 		s->node[node] = n;
-		init_kmem_cache_node(n);
+		init_kmem_cache_node(n, s);
 	}
 	return 1;
 }
@@ -2155,7 +2167,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
 
 static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 {
-	init_kmem_cache_node(&s->local_node);
+	init_kmem_cache_node(&s->local_node, s);
 	return 1;
 }
 #endif
@@ -2715,7 +2727,6 @@ size_t ksize(const void *object)
 	 */
 	return s->size;
 }
-EXPORT_SYMBOL(ksize);
 
 void kfree(const void *x)
 {
@@ -2890,7 +2901,7 @@ static int slab_mem_going_online_callback(void *arg)
 			ret = -ENOMEM;
 			goto out;
 		}
-		init_kmem_cache_node(n);
+		init_kmem_cache_node(n, s);
 		s->node[nid] = n;
 	}
 out:
