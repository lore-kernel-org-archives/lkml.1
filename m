Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbYECKjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbYECKjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYECKiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:38:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45538 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbYECKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:38:53 -0400
Date: Sat, 3 May 2008 13:38:51 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, clameter@sgi.com
Subject: [GIT PULL] SLUB cleanups for 2.6.26
Message-ID: <Pine.LNX.4.64.0805031338070.18785@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

It has some SLUB cleanups from Christoph accumulated over the past few days.

                Pekka

Christoph Lameter (3):
      slub: Whitespace cleanup and use of strict_strtoul
      slabinfo: Support printout of the number of fallbacks
      slub: #ifdef simplification

 Documentation/vm/slabinfo.c |   10 +++++---
 init/Kconfig                |    2 +-
 mm/slub.c                   |   44 ++++++++++++++++++++++++++----------------
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/Documentation/vm/slabinfo.c b/Documentation/vm/slabinfo.c
index d3ce295..e4230ed 100644
--- a/Documentation/vm/slabinfo.c
+++ b/Documentation/vm/slabinfo.c
@@ -38,7 +38,7 @@ struct slabinfo {
 	unsigned long alloc_from_partial, alloc_slab, free_slab, alloc_refill;
 	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
 	unsigned long deactivate_to_head, deactivate_to_tail;
-	unsigned long deactivate_remote_frees;
+	unsigned long deactivate_remote_frees, order_fallback;
 	int numa[MAX_NODES];
 	int numa_partial[MAX_NODES];
 } slabinfo[MAX_SLABS];
@@ -293,7 +293,7 @@ int line = 0;
 void first_line(void)
 {
 	if (show_activity)
-		printf("Name                   Objects    Alloc     Free   %%Fast\n");
+		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O\n");
 	else
 		printf("Name                   Objects Objsize    Space "
 			"Slabs/Part/Cpu  O/S O %%Fr %%Ef Flg\n");
@@ -573,11 +573,12 @@ void slabcache(struct slabinfo *s)
 		total_alloc = s->alloc_fastpath + s->alloc_slowpath;
 		total_free = s->free_fastpath + s->free_slowpath;
 
-		printf("%-21s %8ld %8ld %8ld %3ld %3ld \n",
+		printf("%-21s %8ld %10ld %10ld %3ld %3ld %5ld %1d\n",
 			s->name, s->objects,
 			total_alloc, total_free,
 			total_alloc ? (s->alloc_fastpath * 100 / total_alloc) : 0,
-			total_free ? (s->free_fastpath * 100 / total_free) : 0);
+			total_free ? (s->free_fastpath * 100 / total_free) : 0,
+			s->order_fallback, s->order);
 	}
 	else
 		printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
@@ -1188,6 +1189,7 @@ void read_slab_dir(void)
 			slab->deactivate_to_head = get_obj("deactivate_to_head");
 			slab->deactivate_to_tail = get_obj("deactivate_to_tail");
 			slab->deactivate_remote_frees = get_obj("deactivate_remote_frees");
+			slab->order_fallback = get_obj("order_fallback");
 			chdir("..");
 			if (slab->name[0] == ':')
 				alias_targets++;
diff --git a/init/Kconfig b/init/Kconfig
index 3e7b257..6a44def 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -720,7 +720,7 @@ config VM_EVENT_COUNTERS
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EMBEDDED
-	depends on SLUB
+	depends on SLUB && SYSFS
 	help
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables
diff --git a/mm/slub.c b/mm/slub.c
index 32b6262..d379b78 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -217,7 +217,7 @@ struct track {
 
 enum track_item { TRACK_ALLOC, TRACK_FREE };
 
-#if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
+#ifdef CONFIG_SLUB_DEBUG
 static int sysfs_slab_add(struct kmem_cache *);
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
 static void sysfs_slab_remove(struct kmem_cache *);
@@ -814,7 +814,8 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 	return search == NULL;
 }
 
-static void trace(struct kmem_cache *s, struct page *page, void *object, int alloc)
+static void trace(struct kmem_cache *s, struct page *page, void *object,
+								int alloc)
 {
 	if (s->flags & SLAB_TRACE) {
 		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
@@ -1267,8 +1268,7 @@ static void add_partial(struct kmem_cache_node *n,
 	spin_unlock(&n->list_lock);
 }
 
-static void remove_partial(struct kmem_cache *s,
-						struct page *page)
+static void remove_partial(struct kmem_cache *s, struct page *page)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
@@ -1283,7 +1283,8 @@ static void remove_partial(struct kmem_cache *s,
  *
  * Must hold list_lock.
  */
-static inline int lock_and_freeze_slab(struct kmem_cache_node *n, struct page *page)
+static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
+							struct page *page)
 {
 	if (slab_trylock(page)) {
 		list_del(&page->lru);
@@ -1420,8 +1421,8 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 			 * so that the others get filled first. That way the
 			 * size of the partial list stays small.
 			 *
-			 * kmem_cache_shrink can reclaim any empty slabs from the
-			 * partial list.
+			 * kmem_cache_shrink can reclaim any empty slabs from
+			 * the partial list.
 			 */
 			add_partial(n, page, 1);
 			slab_unlock(page);
@@ -2909,7 +2910,7 @@ static int slab_mem_going_online_callback(void *arg)
 		return 0;
 
 	/*
-	 * We are bringing a node online. No memory is availabe yet. We must
+	 * We are bringing a node online. No memory is available yet. We must
 	 * allocate a kmem_cache_node structure in order to bring the node
 	 * online.
 	 */
@@ -3246,7 +3247,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	return slab_alloc(s, gfpflags, node, caller);
 }
 
-#if (defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)) || defined(CONFIG_SLABINFO)
+#ifdef CONFIG_SLUB_DEBUG
 static unsigned long count_partial(struct kmem_cache_node *n,
 					int (*get_count)(struct page *))
 {
@@ -3275,9 +3276,7 @@ static int count_free(struct page *page)
 {
 	return page->objects - page->inuse;
 }
-#endif
 
-#if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
 static int validate_slab(struct kmem_cache *s, struct page *page,
 						unsigned long *map)
 {
@@ -3812,7 +3811,12 @@ SLAB_ATTR_RO(objs_per_slab);
 static ssize_t order_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	int order = simple_strtoul(buf, NULL, 10);
+	unsigned long order;
+	int err;
+
+	err = strict_strtoul(buf, 10, &order);
+	if (err)
+		return err;
 
 	if (order > slub_max_order || order < slub_min_order)
 		return -EINVAL;
@@ -4065,10 +4069,16 @@ static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	int n = simple_strtoul(buf, NULL, 10);
+	unsigned long ratio;
+	int err;
+
+	err = strict_strtoul(buf, 10, &ratio);
+	if (err)
+		return err;
+
+	if (ratio < 100)
+		s->remote_node_defrag_ratio = ratio * 10;
 
-	if (n < 100)
-		s->remote_node_defrag_ratio = n * 10;
 	return length;
 }
 SLAB_ATTR(remote_node_defrag_ratio);
@@ -4425,8 +4435,8 @@ __initcall(slab_sysfs_init);
  */
 #ifdef CONFIG_SLABINFO
 
-ssize_t slabinfo_write(struct file *file, const char __user * buffer,
-                       size_t count, loff_t *ppos)
+ssize_t slabinfo_write(struct file *file, const char __user *buffer,
+		       size_t count, loff_t *ppos)
 {
 	return -EINVAL;
 }
