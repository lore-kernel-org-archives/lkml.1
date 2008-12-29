Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYL2KV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYL2KV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYL2KVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:21:07 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45452 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbYL2KVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:21:02 -0500
Date: Mon, 29 Dec 2008 12:20:59 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       akinobu.mita@gmail.com, catalin.marinas@arm.com,
       cl@linux-foundation.org, gorcunov@gmail.com, rientjes@google.com,
       eduard.munteanu@linux360.ro, mpm@selenic.com, miklos@szeredi.hu,
       nick@nick-andrew.net, hirofumi@mail.parknet.co.jp, pterjan@mandriva.com,
       roel.kluin@gmail.com
Subject: [GIT PULL] SLAB updates for 2.6.29
Message-ID: <Pine.LNX.4.64.0812291219310.18415@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The branch contains small fixes and cleanups to both SLAB and SLUB from various
people. The only new feature is the fault injection support for SLUB from
Akinobu Mita.

                Pekka

Akinobu Mita (1):
      SLUB: failslab support

Catalin Marinas (1):
      slab: Update the kmem_cache_create documentation regarding the name parameter

Cyrill Gorcunov (2):
      SLUB: cleanup - define macros instead of hardcoded numbers
      slub - fix get_object_page comment

David Rientjes (2):
      slub: make early_kmem_cache_node_alloc void
      slub: avoid leaking caches or refcounts on sysfs error

Eduard - Gabriel Munteanu (1):
      SLUB: Replace __builtin_return_address(0) with _RET_IP_.

Nick Andrew (1):
      slub: Fix incorrect use of loose

OGAWA Hirofumi (1):
      slub: Add might_sleep_if() to slab_alloc()

Pascal Terjan (1):
      slab: Fix comment on #endif

Pekka Enberg (3):
      slab: remove GFP_THISNODE clearing from alloc_slabmgmt()
      Merge branches 'topic/fixes', 'topic/cleanups' and 'topic/documentation' into for-linus
      Merge branch 'topic/failslab' into for-linus

roel kluin (1):
      slab: unsigned slabp->inuse cannot be less than 0

 include/linux/fault-inject.h |    9 ++++
 include/linux/slab.h         |   10 ++--
 lib/Kconfig.debug            |    1 +
 mm/Makefile                  |    1 +
 mm/failslab.c                |   59 +++++++++++++++++++++++++
 mm/slab.c                    |   89 ++++++--------------------------------
 mm/slub.c                    |   98 ++++++++++++++++++++++++-----------------
 7 files changed, 145 insertions(+), 122 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 32368c4..06ca9b2 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -81,4 +81,13 @@ static inline void cleanup_fault_attr_dentries(struct fault_attr *attr)
 
 #endif /* CONFIG_FAULT_INJECTION */
 
+#ifdef CONFIG_FAILSLAB
+extern bool should_failslab(size_t size, gfp_t gfpflags);
+#else
+static inline bool should_failslab(size_t size, gfp_t gfpflags)
+{
+	return false;
+}
+#endif /* CONFIG_FAILSLAB */
+
 #endif /* _LINUX_FAULT_INJECT_H */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 000da12..f96d13c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -253,9 +253,9 @@ static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
  * request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
-extern void *__kmalloc_track_caller(size_t, gfp_t, void*);
+extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
 #define kmalloc_track_caller(size, flags) \
-	__kmalloc_track_caller(size, flags, __builtin_return_address(0))
+	__kmalloc_track_caller(size, flags, _RET_IP_)
 #else
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc(size, flags)
@@ -271,10 +271,10 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, void*);
  * allocation request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
-extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, void *);
+extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
-			__builtin_return_address(0))
+			_RET_IP_)
 #else
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node(size, flags, node)
@@ -285,7 +285,7 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, void *);
 #define kmalloc_node_track_caller(size, flags, node) \
 	kmalloc_track_caller(size, flags)
 
-#endif /* DEBUG_SLAB */
+#endif /* CONFIG_NUMA */
 
 /*
  * Shortcuts
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..af65ae7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -699,6 +699,7 @@ config FAULT_INJECTION
 config FAILSLAB
 	bool "Fault-injection capability for kmalloc"
 	depends on FAULT_INJECTION
+	depends on SLAB || SLUB
 	help
 	  Provide fault-injection capability for kmalloc.
 
diff --git a/mm/Makefile b/mm/Makefile
index c06b45a..51c2770 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
diff --git a/mm/failslab.c b/mm/failslab.c
new file mode 100644
index 0000000..7c6ea64
--- /dev/null
+++ b/mm/failslab.c
@@ -0,0 +1,59 @@
+#include <linux/fault-inject.h>
+
+static struct {
+	struct fault_attr attr;
+	u32 ignore_gfp_wait;
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+	struct dentry *ignore_gfp_wait_file;
+#endif
+} failslab = {
+	.attr = FAULT_ATTR_INITIALIZER,
+	.ignore_gfp_wait = 1,
+};
+
+bool should_failslab(size_t size, gfp_t gfpflags)
+{
+	if (gfpflags & __GFP_NOFAIL)
+		return false;
+
+        if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
+		return false;
+
+	return should_fail(&failslab.attr, size);
+}
+
+static int __init setup_failslab(char *str)
+{
+	return setup_fault_attr(&failslab.attr, str);
+}
+__setup("failslab=", setup_failslab);
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static int __init failslab_debugfs_init(void)
+{
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dir;
+	int err;
+
+	err = init_fault_attr_dentries(&failslab.attr, "failslab");
+	if (err)
+		return err;
+	dir = failslab.attr.dentries.dir;
+
+	failslab.ignore_gfp_wait_file =
+		debugfs_create_bool("ignore-gfp-wait", mode, dir,
+				      &failslab.ignore_gfp_wait);
+
+	if (!failslab.ignore_gfp_wait_file) {
+		err = -ENOMEM;
+		debugfs_remove(failslab.ignore_gfp_wait_file);
+		cleanup_fault_attr_dentries(&failslab.attr);
+	}
+
+	return err;
+}
+
+late_initcall(failslab_debugfs_init);
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
diff --git a/mm/slab.c b/mm/slab.c
index 0918751..f97e564 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2123,6 +2123,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
  *
  * @name must be valid until the cache is destroyed. This implies that
  * the module calling this has to destroy the cache before getting unloaded.
+ * Note that kmem_cache_name() is not guaranteed to return the same pointer,
+ * therefore applications must manage it themselves.
  *
  * The flags are
  *
@@ -2609,7 +2611,7 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 	if (OFF_SLAB(cachep)) {
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
-					      local_flags & ~GFP_THISNODE, nodeid);
+					      local_flags, nodeid);
 		if (!slabp)
 			return NULL;
 	} else {
@@ -2997,7 +2999,7 @@ retry:
 		 * there must be at least one object available for
 		 * allocation.
 		 */
-		BUG_ON(slabp->inuse < 0 || slabp->inuse >= cachep->num);
+		BUG_ON(slabp->inuse >= cachep->num);
 
 		while (slabp->inuse < cachep->num && batchcount--) {
 			STATS_INC_ALLOCED(cachep);
@@ -3106,79 +3108,14 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 #define cache_alloc_debugcheck_after(a,b,objp,d) (objp)
 #endif
 
-#ifdef CONFIG_FAILSLAB
-
-static struct failslab_attr {
-
-	struct fault_attr attr;
-
-	u32 ignore_gfp_wait;
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-	struct dentry *ignore_gfp_wait_file;
-#endif
-
-} failslab = {
-	.attr = FAULT_ATTR_INITIALIZER,
-	.ignore_gfp_wait = 1,
-};
-
-static int __init setup_failslab(char *str)
-{
-	return setup_fault_attr(&failslab.attr, str);
-}
-__setup("failslab=", setup_failslab);
-
-static int should_failslab(struct kmem_cache *cachep, gfp_t flags)
+static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
 {
 	if (cachep == &cache_cache)
-		return 0;
-	if (flags & __GFP_NOFAIL)
-		return 0;
-	if (failslab.ignore_gfp_wait && (flags & __GFP_WAIT))
-		return 0;
+		return false;
 
-	return should_fail(&failslab.attr, obj_size(cachep));
+	return should_failslab(obj_size(cachep), flags);
 }
 
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-static int __init failslab_debugfs(void)
-{
-	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
-	struct dentry *dir;
-	int err;
-
-	err = init_fault_attr_dentries(&failslab.attr, "failslab");
-	if (err)
-		return err;
-	dir = failslab.attr.dentries.dir;
-
-	failslab.ignore_gfp_wait_file =
-		debugfs_create_bool("ignore-gfp-wait", mode, dir,
-				      &failslab.ignore_gfp_wait);
-
-	if (!failslab.ignore_gfp_wait_file) {
-		err = -ENOMEM;
-		debugfs_remove(failslab.ignore_gfp_wait_file);
-		cleanup_fault_attr_dentries(&failslab.attr);
-	}
-
-	return err;
-}
-
-late_initcall(failslab_debugfs);
-
-#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
-
-#else /* CONFIG_FAILSLAB */
-
-static inline int should_failslab(struct kmem_cache *cachep, gfp_t flags)
-{
-	return 0;
-}
-
-#endif /* CONFIG_FAILSLAB */
-
 static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *objp;
@@ -3381,7 +3318,7 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	unsigned long save_flags;
 	void *ptr;
 
-	if (should_failslab(cachep, flags))
+	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
 	cache_alloc_debugcheck_before(cachep, flags);
@@ -3457,7 +3394,7 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	unsigned long save_flags;
 	void *objp;
 
-	if (should_failslab(cachep, flags))
+	if (slab_should_failslab(cachep, flags))
 		return NULL;
 
 	cache_alloc_debugcheck_before(cachep, flags);
@@ -3686,9 +3623,9 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 EXPORT_SYMBOL(__kmalloc_node);
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t flags,
-		int node, void *caller)
+		int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, flags, node, caller);
+	return __do_kmalloc_node(size, flags, node, (void *)caller);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #else
@@ -3730,9 +3667,9 @@ void *__kmalloc(size_t size, gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc);
 
-void *__kmalloc_track_caller(size_t size, gfp_t flags, void *caller)
+void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
 {
-	return __do_kmalloc(size, flags, caller);
+	return __do_kmalloc(size, flags, (void *)caller);
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
diff --git a/mm/slub.c b/mm/slub.c
index a2cd47d..6cb7ad1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -24,6 +24,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/fault-inject.h>
 
 /*
  * Lock order:
@@ -153,6 +154,10 @@
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+#define OO_SHIFT	16
+#define OO_MASK		((1 << OO_SHIFT) - 1)
+#define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
+
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
 #define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
@@ -178,7 +183,7 @@ static LIST_HEAD(slab_caches);
  * Tracking user of a slab.
  */
 struct track {
-	void *addr;		/* Called from address */
+	unsigned long addr;	/* Called from address */
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
@@ -290,7 +295,7 @@ static inline struct kmem_cache_order_objects oo_make(int order,
 						unsigned long size)
 {
 	struct kmem_cache_order_objects x = {
-		(order << 16) + (PAGE_SIZE << order) / size
+		(order << OO_SHIFT) + (PAGE_SIZE << order) / size
 	};
 
 	return x;
@@ -298,12 +303,12 @@ static inline struct kmem_cache_order_objects oo_make(int order,
 
 static inline int oo_order(struct kmem_cache_order_objects x)
 {
-	return x.x >> 16;
+	return x.x >> OO_SHIFT;
 }
 
 static inline int oo_objects(struct kmem_cache_order_objects x)
 {
-	return x.x & ((1 << 16) - 1);
+	return x.x & OO_MASK;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -367,7 +372,7 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 }
 
 static void set_track(struct kmem_cache *s, void *object,
-				enum track_item alloc, void *addr)
+			enum track_item alloc, unsigned long addr)
 {
 	struct track *p;
 
@@ -391,8 +396,8 @@ static void init_tracking(struct kmem_cache *s, void *object)
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	set_track(s, object, TRACK_FREE, NULL);
-	set_track(s, object, TRACK_ALLOC, NULL);
+	set_track(s, object, TRACK_FREE, 0UL);
+	set_track(s, object, TRACK_ALLOC, 0UL);
 }
 
 static void print_track(const char *s, struct track *t)
@@ -401,7 +406,7 @@ static void print_track(const char *s, struct track *t)
 		return;
 
 	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
-		s, t->addr, jiffies - t->when, t->cpu, t->pid);
+		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
 }
 
 static void print_tracking(struct kmem_cache *s, void *object)
@@ -692,7 +697,7 @@ static int check_object(struct kmem_cache *s, struct page *page,
 	if (!check_valid_pointer(s, page, get_freepointer(s, p))) {
 		object_err(s, page, p, "Freepointer corrupt");
 		/*
-		 * No choice but to zap it and thus loose the remainder
+		 * No choice but to zap it and thus lose the remainder
 		 * of the free objects in this slab. May cause
 		 * another error because the object count is now wrong.
 		 */
@@ -764,8 +769,8 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 	}
 
 	max_objects = (PAGE_SIZE << compound_order(page)) / s->size;
-	if (max_objects > 65535)
-		max_objects = 65535;
+	if (max_objects > MAX_OBJS_PER_PAGE)
+		max_objects = MAX_OBJS_PER_PAGE;
 
 	if (page->objects != max_objects) {
 		slab_err(s, page, "Wrong number of objects. Found %d but "
@@ -866,7 +871,7 @@ static void setup_object_debug(struct kmem_cache *s, struct page *page,
 }
 
 static int alloc_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
 		goto bad;
@@ -906,7 +911,7 @@ bad:
 }
 
 static int free_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
 		goto fail;
@@ -1029,10 +1034,10 @@ static inline void setup_object_debug(struct kmem_cache *s,
 			struct page *page, void *object) {}
 
 static inline int alloc_debug_processing(struct kmem_cache *s,
-	struct page *page, void *object, void *addr) { return 0; }
+	struct page *page, void *object, unsigned long addr) { return 0; }
 
 static inline int free_debug_processing(struct kmem_cache *s,
-	struct page *page, void *object, void *addr) { return 0; }
+	struct page *page, void *object, unsigned long addr) { return 0; }
 
 static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
 			{ return 1; }
@@ -1499,8 +1504,8 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
  * we need to allocate a new slab. This is the slowest path since it involves
  * a call to the page allocator and the setup of a new slab.
  */
-static void *__slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr, struct kmem_cache_cpu *c)
+static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
+			  unsigned long addr, struct kmem_cache_cpu *c)
 {
 	void **object;
 	struct page *new;
@@ -1584,13 +1589,18 @@ debug:
  * Otherwise we can simply pick the next object from the lockless free list.
  */
 static __always_inline void *slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr)
+		gfp_t gfpflags, int node, unsigned long addr)
 {
 	void **object;
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 	unsigned int objsize;
 
+	might_sleep_if(gfpflags & __GFP_WAIT);
+
+	if (should_failslab(s->objsize, gfpflags))
+		return NULL;
+
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	objsize = c->objsize;
@@ -1613,14 +1623,14 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, -1, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, node, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -1634,7 +1644,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-				void *x, void *addr, unsigned int offset)
+			void *x, unsigned long addr, unsigned int offset)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1704,7 +1714,7 @@ debug:
  * with all sorts of special processing.
  */
 static __always_inline void slab_free(struct kmem_cache *s,
-			struct page *page, void *x, void *addr)
+			struct page *page, void *x, unsigned long addr)
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
@@ -1731,11 +1741,11 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	page = virt_to_head_page(x);
 
-	slab_free(s, page, x, __builtin_return_address(0));
+	slab_free(s, page, x, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-/* Figure out on which slab object the object resides */
+/* Figure out on which slab page the object resides */
 static struct page *get_object_page(const void *x)
 {
 	struct page *page = virt_to_head_page(x);
@@ -1807,8 +1817,8 @@ static inline int slab_order(int size, int min_objects,
 	int rem;
 	int min_order = slub_min_order;
 
-	if ((PAGE_SIZE << min_order) / size > 65535)
-		return get_order(size * 65535) - 1;
+	if ((PAGE_SIZE << min_order) / size > MAX_OBJS_PER_PAGE)
+		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
 
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
@@ -2073,8 +2083,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
  * when allocating for the kmalloc_node_cache. This is used for bootstrapping
  * memory on a fresh node that has no slab structures yet.
  */
-static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
-							   int node)
+static void early_kmem_cache_node_alloc(gfp_t gfpflags, int node)
 {
 	struct page *page;
 	struct kmem_cache_node *n;
@@ -2112,7 +2121,6 @@ static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
 	local_irq_save(flags);
 	add_partial(n, page, 0);
 	local_irq_restore(flags);
-	return n;
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -2144,8 +2152,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 			n = &s->local_node;
 		else {
 			if (slab_state == DOWN) {
-				n = early_kmem_cache_node_alloc(gfpflags,
-								node);
+				early_kmem_cache_node_alloc(gfpflags, node);
 				continue;
 			}
 			n = kmem_cache_alloc_node(kmalloc_caches,
@@ -2659,7 +2666,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	return slab_alloc(s, flags, -1, _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2687,7 +2694,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0));
+	return slab_alloc(s, flags, node, _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2744,7 +2751,7 @@ void kfree(const void *x)
 		put_page(page);
 		return;
 	}
-	slab_free(page->slab, page, object, __builtin_return_address(0));
+	slab_free(page->slab, page, object, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3123,8 +3130,12 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
 
-		if (sysfs_slab_alias(s, name))
+		if (sysfs_slab_alias(s, name)) {
+			down_write(&slub_lock);
+			s->refcount--;
+			up_write(&slub_lock);
 			goto err;
+		}
 		return s;
 	}
 
@@ -3134,8 +3145,13 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
 			up_write(&slub_lock);
-			if (sysfs_slab_add(s))
+			if (sysfs_slab_add(s)) {
+				down_write(&slub_lock);
+				list_del(&s->list);
+				up_write(&slub_lock);
+				kfree(s);
 				goto err;
+			}
 			return s;
 		}
 		kfree(s);
@@ -3202,7 +3218,7 @@ static struct notifier_block __cpuinitdata slab_notifier = {
 
 #endif
 
-void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
+void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 {
 	struct kmem_cache *s;
 
@@ -3218,7 +3234,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
-					int node, void *caller)
+					int node, unsigned long caller)
 {
 	struct kmem_cache *s;
 
@@ -3429,7 +3445,7 @@ static void resiliency_test(void) {};
 
 struct location {
 	unsigned long count;
-	void *addr;
+	unsigned long addr;
 	long long sum_time;
 	long min_time;
 	long max_time;
@@ -3477,7 +3493,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 {
 	long start, end, pos;
 	struct location *l;
-	void *caddr;
+	unsigned long caddr;
 	unsigned long age = jiffies - track->when;
 
 	start = -1;
@@ -4345,7 +4361,7 @@ static void sysfs_slab_remove(struct kmem_cache *s)
 
 /*
  * Need to buffer aliases during bootup until sysfs becomes
- * available lest we loose that information.
+ * available lest we lose that information.
  */
 struct saved_alias {
 	struct kmem_cache *s;
