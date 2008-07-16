Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYGPA0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYGPA0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbYGPAY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:24:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210AbYGPAYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=YY86aw5Q4YzLVOHuXLDbpMZhdMHZzOf4nYw8hTRTF0qsY2IwaaxGojvPVqKvApvSgE
         mm3cSZMrU2JaGq51RRuPTl1a0un+X0kECpw+Wk72YrTta3kLRrp0F2Mm/G2y1BgC3RuH
         0beXkuaiKCBsgt0o7zN8C5GnELWXhvPa+3RAA=
Date: Wed, 16 Jul 2008 02:24:10 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] kmemcheck: add mm functions
Message-ID: <20080716002410.GK12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 11a1cb6127eb25c827468fe7c83dd92748d405b1 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 31 May 2008 15:56:17 +0200
Subject: [PATCH 10/13] kmemcheck: add mm functions

With kmemcheck enabled, the slab allocator needs to do this:

1. Tell kmemcheck to allocate the shadow memory which stores the status of
   each byte in the allocation proper, e.g. whether it is initialized or
   uninitialized.
2. Tell kmemcheck which parts of memory that should be marked uninitialized.
   There are actually a few more states, such as "not yet allocated" and
   "recently freed".

If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
memory that can take page faults because of kmemcheck.

If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can still
request memory with the __GFP_NOTRACK flag. This does not prevent the page
faults from occuring, however, but marks the object in question as being
initialized so that no warnings will ever be produced for this object.

Parts of this patch were contributed by Pekka Enberg but merged for
atomicity.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/process.c |    2 +-
 include/linux/gfp.h       |    3 +-
 include/linux/kmemcheck.h |   48 ++++++++++++++++++++++
 include/linux/slab.h      |    7 +++
 kernel/fork.c             |   16 ++++----
 mm/Makefile               |    2 +-
 mm/kmemcheck.c            |   97 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 164 insertions(+), 11 deletions(-)
 create mode 100644 mm/kmemcheck.c

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ba370dc..d61d452 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -42,7 +42,7 @@ void arch_task_cache_init(void)
         task_xstate_cachep =
         	kmem_cache_create("task_xstate", xstate_size,
 				  __alignof__(union thread_xstate),
-				  SLAB_PANIC, NULL);
+				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
 static void do_nothing(void *unused)
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b414be3..7c1db87 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -50,8 +50,9 @@ struct vm_area_struct;
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
 #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+#define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */
 
-#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index 266edbf..b2d83ef 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -9,6 +9,27 @@ extern int kmemcheck_enabled;
 
 void kmemcheck_init(void);
 
+/* The slab-related functions. */
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			    struct page *page, int order);
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order);
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size);
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size);
+
+void kmemcheck_show_pages(struct page *p, unsigned int n);
+void kmemcheck_hide_pages(struct page *p, unsigned int n);
+
+bool kmemcheck_page_is_tracked(struct page *p);
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n);
+void kmemcheck_mark_uninitialized(void *address, unsigned int n);
+void kmemcheck_mark_initialized(void *address, unsigned int n);
+void kmemcheck_mark_freed(void *address, unsigned int n);
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
+
 int kmemcheck_show_addr(unsigned long address);
 int kmemcheck_hide_addr(unsigned long address);
 #else
@@ -17,6 +38,33 @@ int kmemcheck_hide_addr(unsigned long address);
 static inline void kmemcheck_init(void)
 {
 }
+
+static inline void
+kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+		       struct page *page, int order)
+{
+}
+
+static inline void
+kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+{
+}
+
+static inline void
+kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+		     size_t size)
+{
+}
+
+static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object,
+				       size_t size)
+{
+}
+
+static inline bool kmemcheck_page_is_tracked(struct page *p)
+{
+	return false;
+}
 #endif /* CONFIG_KMEMCHECK */
 
 #endif /* LINUX_KMEMCHECK_H */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9aa90a6..faff12b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -34,6 +34,13 @@
 # define SLAB_DEBUG_OBJECTS	0x00000000UL
 #endif
 
+/* Don't track use of uninitialized memory */
+#ifdef CONFIG_KMEMCHECK
+# define SLAB_NOTRACK		0x00800000UL
+#else
+# define SLAB_NOTRACK		0x00000000UL
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/kernel/fork.c b/kernel/fork.c
index 19908b2..25c2aa3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -150,7 +150,7 @@ void __init fork_init(unsigned long mempages)
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep =
 		kmem_cache_create("task_struct", sizeof(struct task_struct),
-			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
+			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
 #endif
 
 	/* do the arch specific task caches init */
@@ -1415,23 +1415,23 @@ void __init proc_caches_init(void)
 {
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
-			sighand_ctor);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU|
+			SLAB_NOTRACK, sighand_ctor);
 	signal_cachep = kmem_cache_create("signal_cache",
 			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	files_cachep = kmem_cache_create("files_cache",
 			sizeof(struct files_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	fs_cachep = kmem_cache_create("fs_cache",
 			sizeof(struct fs_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	vm_area_cachep = kmem_cache_create("vm_area_struct",
 			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
+			SLAB_PANIC|SLAB_NOTRACK, NULL);
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 }
 
 /*
diff --git a/mm/Makefile b/mm/Makefile
index 18c143b..4801918 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -27,10 +27,10 @@ obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
-
diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
new file mode 100644
index 0000000..4efdf1e
--- /dev/null
+++ b/mm/kmemcheck.c
@@ -0,0 +1,97 @@
+#include <linux/mm_types.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/kmemcheck.h>
+
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			   struct page *page, int order)
+{
+	struct page *shadow;
+	int pages;
+	int i;
+
+	pages = 1 << order;
+
+	/*
+	 * With kmemcheck enabled, we need to allocate a memory area for the
+	 * shadow bits as well.
+	 */
+	shadow = alloc_pages_node(node, flags, order);
+	if (!shadow) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "kmemcheck: failed to allocate "
+				"shadow bitmap\n");
+		return;
+	}
+
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = page_address(&shadow[i]);
+
+	/*
+	 * Mark it as non-present for the MMU so that our accesses to
+	 * this memory will trigger a page fault and let us analyze
+	 * the memory accesses.
+	 */
+	kmemcheck_hide_pages(page, pages);
+
+	/*
+	 * Objects from caches that have a constructor don't get
+	 * cleared when they're allocated, so we need to do it here.
+	 */
+	if (s->ctor)
+		kmemcheck_mark_uninitialized_pages(page, pages);
+	else
+		kmemcheck_mark_unallocated_pages(page, pages);
+}
+
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+{
+	struct page *shadow;
+	int pages;
+	int i;
+
+	pages = 1 << order;
+
+	kmemcheck_show_pages(page, pages);
+
+	shadow = virt_to_page(page[0].shadow);
+
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = NULL;
+
+	__free_pages(shadow, order);
+}
+
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size)
+{
+	if (gfpflags & __GFP_ZERO)
+		return;
+	if (s->flags & SLAB_NOTRACK)
+		return;
+
+	if (!kmemcheck_enabled || gfpflags & __GFP_NOTRACK) {
+		/*
+		 * Allow notracked objects to be allocated from
+		 * tracked caches. Note however that these objects
+		 * will still get page faults on access, they just
+		 * won't ever be flagged as uninitialized. If page
+		 * faults are not acceptable, the slab cache itself
+		 * should be marked NOTRACK.
+		 */
+		kmemcheck_mark_initialized(object, size);
+	} else if (!s->ctor) {
+		/*
+		 * New objects should be marked uninitialized before
+		 * they're returned to the called.
+		 */
+		kmemcheck_mark_uninitialized(object, size);
+	}
+}
+
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size)
+{
+	/* TODO: RCU freeing is unsupported for now; hide false positives. */
+	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
+		kmemcheck_mark_freed(object, size);
+}
-- 
1.5.5.1

