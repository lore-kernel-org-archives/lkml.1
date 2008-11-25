Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYKYRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYKYRBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYKYRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:01:25 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:56967 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYKYRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=DOUX8beAeZpQQNJQWk2WGSbWNScMNHwwWf1dRoCYuuQs9o47DaimS1T9BQlSlNkGC5
         5ABk7d/Go2sc67FYFxnXk6aAD7pWJ2o7IrsRhCuT6h1xhSZ0gK5JdQdIix0k0Cv3soEg
         KOz8vT16rD69HuxGmRNxBZ7EeiOc8jCqBqRcA=
Date: Tue, 25 Nov 2008 18:02:31 +0100
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [RFC][PATCH -tip] kmemcheck: add hooks for the page allocator
Message-ID: <20081125170231.GA19260@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ad913cbefabedf41f021e6e9b64313644d5d479b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 25 Nov 2008 16:55:53 +0100
Subject: [PATCH] kmemcheck: add hooks for the page allocator

This adds support for tracking the initializedness of memory that
was allocated with the page allocator. Requests with the flags
__GFP_HIGHMEM or __GFP_IO are not tracked.

There seems to be a problem with bio mappings, which gives (among
others) this new warning:

WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (f6750408)
008000011f736d6955534220202020204449534b20322e302020202020202020
 u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
                 ^

Pid: 660, comm: usb-stor-scan Not tainted (2.6.28-rc2 #156) 945P-A
EIP: 0060:[<c12a0dc7>] EFLAGS: 00010246 CPU: 0
EIP is at scsi_probe_and_add_lun+0x2c7/0x9a0
EAX: f6750400 EBX: 00000000 ECX: f675040f EDX: f6750408
ESI: 00000024 EDI: f6750424 EBP: f66b3e74 ESP: c174b0e8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: f6c1e404 CR3: 01732000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c12a1aa3>] __scsi_scan_target+0xe3/0x5d0
 [<c12a1fe2>] scsi_scan_channel+0x52/0x90
 [<c12a20bb>] scsi_scan_host_selected+0x9b/0x120
 [<c12a21ae>] do_scsi_scan_host+0x6e/0x70
 [<c12a244e>] scsi_scan_host+0x13e/0x190
 [<c130fdbd>] usb_stor_scan_thread+0x16d/0x1b0
 [<c104543c>] kthread+0x3c/0x70
 [<c1004cc3>] kernel_thread_helper+0x7/0x14
 [<ffffffff>] 0xffffffff

It is this call: sanitize_inquiry_string(&inq_result[8], 8);

As can be seen in the memory dump, the memory is in fact
initialized with what seems to the correct (expected) data.

This can probably be fixed with an annotation in the bio code, but
I don't know if this would really be the correct solution, so I am
not doing it for now.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/include/asm/thread_info.h |    4 ++--
 arch/x86/mm/kmemcheck/shadow.c     |    8 ++++++++
 include/linux/gfp.h                |    5 +++++
 include/linux/kmemcheck.h          |   25 ++++++++++++++++++++-----
 mm/kmemcheck.c                     |   17 ++++-------------
 mm/page_alloc.c                    |   28 ++++++++++++++++++++++++++++
 mm/slab.c                          |   14 ++++++++++----
 mm/slub.c                          |   21 +++++++++++++++++----
 8 files changed, 94 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e44d379..1582b16 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -149,9 +149,9 @@ struct thread_info {
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 #else
-#define THREAD_FLAGS GFP_KERNEL
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
 #endif
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index 62a0f63..969cd4a 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -88,6 +88,14 @@ void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n)
 		kmemcheck_mark_uninitialized(page_address(&p[i]), PAGE_SIZE);
 }
 
+void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_initialized(page_address(&p[i]), PAGE_SIZE);
+}
+
 enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
 {
 	uint8_t *x;
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0d55e44..700db60 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -50,7 +50,12 @@ struct vm_area_struct;
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
 #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+
+#ifdef CONFIG_KMEMCHECK
 #define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */
+#else
+#define __GFP_NOTRACK	((__force gfp_t)0)
+#endif
 
 #define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index 7073121..04b2289 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -42,9 +42,8 @@ extern int kmemcheck_enabled;
 void kmemcheck_init(void);
 
 /* The slab-related functions. */
-void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
-			    struct page *page, int order);
-void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order);
+void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node);
+void kmemcheck_free_shadow(struct page *page, int order);
 void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
 			  size_t size);
 void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size);
@@ -61,6 +60,7 @@ void kmemcheck_mark_freed(void *address, unsigned int n);
 
 void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
 void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
+void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n);
 
 int kmemcheck_show_addr(unsigned long address);
 int kmemcheck_hide_addr(unsigned long address);
@@ -77,13 +77,13 @@ static inline void kmemcheck_init(void)
 }
 
 static inline void
-kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+kmemcheck_alloc_shadow(int ctor, gfp_t flags, int node,
 		       struct page *page, int order)
 {
 }
 
 static inline void
-kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+kmemcheck_free_shadow(struct page *page, int order)
 {
 }
 
@@ -119,6 +119,21 @@ static inline void kmemcheck_mark_freed(void *address, unsigned int n)
 {
 }
 
+static inline void kmemcheck_mark_unallocated_pages(struct page *p,
+						    unsigned int n)
+{
+}
+
+static inline void kmemcheck_mark_uninitialized_pages(struct page *p,
+						      unsigned int n)
+{
+}
+
+static inline void kmemcheck_mark_initialized_pages(struct page *p,
+						    unsigned int n)
+{
+}
+
 #define kmemcheck_annotate_bitfield(field) do { } while (0)
 #endif /* CONFIG_KMEMCHECK */
 
diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
index eaa41b8..72984c0 100644
--- a/mm/kmemcheck.c
+++ b/mm/kmemcheck.c
@@ -1,10 +1,10 @@
+#include <linux/gfp.h>
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/kmemcheck.h>
 
-void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
-			   struct page *page, int order)
+void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
 {
 	struct page *shadow;
 	int pages;
@@ -16,7 +16,7 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 	 * With kmemcheck enabled, we need to allocate a memory area for the
 	 * shadow bits as well.
 	 */
-	shadow = alloc_pages_node(node, flags, order);
+	shadow = alloc_pages_node(node, flags | __GFP_NOTRACK, order);
 	if (!shadow) {
 		if (printk_ratelimit())
 			printk(KERN_ERR "kmemcheck: failed to allocate "
@@ -33,18 +33,9 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 	 * the memory accesses.
 	 */
 	kmemcheck_hide_pages(page, pages);
-
-	/*
-	 * Objects from caches that have a constructor don't get
-	 * cleared when they're allocated, so we need to do it here.
-	 */
-	if (s->ctor)
-		kmemcheck_mark_uninitialized_pages(page, pages);
-	else
-		kmemcheck_mark_unallocated_pages(page, pages);
 }
 
-void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+void kmemcheck_free_shadow(struct page *page, int order)
 {
 	struct page *shadow;
 	int pages;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0a240f..1c2cbe2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -23,6 +23,7 @@
 #include <linux/bootmem.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <linux/kmemcheck.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
 #include <linux/pagevec.h>
@@ -511,6 +512,9 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	int i;
 	int reserved = 0;
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(page, order);
+
 	for (i = 0 ; i < (1 << order) ; ++i)
 		reserved += free_pages_check(page + i);
 	if (reserved)
@@ -974,6 +978,9 @@ static void free_hot_cold_page(struct page *page, int cold)
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(page, 0);
+
 	if (PageAnon(page))
 		page->mapping = NULL;
 	if (free_pages_check(page))
@@ -1637,7 +1644,28 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
+	return page;
 got_pg:
+	if (kmemcheck_enabled
+		&& !(gfp_mask & (__GFP_HIGHMEM | __GFP_IO | __GFP_NOTRACK)))
+	{
+		int nr_pages = 1 << order;
+
+		/*
+		 * NOTE: We choose to track GFP_ZERO pages too; in fact, they
+		 * can become uninitialized by copying uninitialized memory
+		 * into them.
+		 */
+
+		/* XXX: Can use zone->node for node? */
+		kmemcheck_alloc_shadow(page, order, gfp_mask, -1);
+
+		if (gfp_mask & __GFP_ZERO)
+			kmemcheck_mark_initialized_pages(page, nr_pages);
+		else
+			kmemcheck_mark_uninitialized_pages(page, nr_pages);
+	}
+
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_internal);
diff --git a/mm/slab.c b/mm/slab.c
index 37deade..286c6a6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1600,7 +1600,7 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
-	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
+	page = alloc_pages_node(nodeid, flags & ~__GFP_NOTRACK, cachep->gfporder);
 	if (!page)
 		return NULL;
 
@@ -1614,8 +1614,14 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	for (i = 0; i < nr_pages; i++)
 		__SetPageSlab(page + i);
 
-	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK))
-		kmemcheck_alloc_shadow(cachep, flags, nodeid, page, cachep->gfporder);
+	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
+		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
+
+		if (cachep->ctor)
+			kmemcheck_mark_uninitialized_pages(page, nr_pages);
+		else
+			kmemcheck_mark_unallocated_pages(page, nr_pages);
+	}
 
 	return page_address(page);
 }
@@ -1630,7 +1636,7 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 	const unsigned long nr_freed = i;
 
 	if (kmemcheck_page_is_tracked(page))
-		kmemcheck_free_shadow(cachep, page, cachep->gfporder);
+		kmemcheck_free_shadow(page, cachep->gfporder);
 
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		sub_zone_page_state(page_zone(page),
diff --git a/mm/slub.c b/mm/slub.c
index adcb5e3..eb9855f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1064,6 +1064,8 @@ static inline struct page *alloc_slab_page(gfp_t flags, int node,
 {
 	int order = oo_order(oo);
 
+	flags |= __GFP_NOTRACK;
+
 	if (node == -1)
 		return alloc_pages(flags, order);
 	else
@@ -1095,7 +1097,18 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (kmemcheck_enabled
 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS)))
 	{
-		kmemcheck_alloc_shadow(s, flags, node, page, compound_order(page));
+		int pages = 1 << oo_order(oo);
+
+		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
+
+		/*
+		 * Objects from caches that have a constructor don't get
+		 * cleared when they're allocated, so we need to do it here.
+		 */
+		if (s->ctor)
+			kmemcheck_mark_uninitialized_pages(page, pages);
+		else
+			kmemcheck_mark_unallocated_pages(page, pages);
 	}
 
 	page->objects = oo_objects(oo);
@@ -1172,7 +1185,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	}
 
 	if (kmemcheck_page_is_tracked(page))
-		kmemcheck_free_shadow(s, page, compound_order(page));
+		kmemcheck_free_shadow(page, compound_order(page));
 
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -2679,8 +2692,8 @@ EXPORT_SYMBOL(__kmalloc);
 
 static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct page *page = alloc_pages_node(node, flags | __GFP_COMP,
-						get_order(size));
+	struct page *page = alloc_pages_node(node,
+		flags | __GFP_COMP | __GFP_NOTRACK, get_order(size));
 
 	if (page)
 		return page_address(page);
-- 
1.5.6.5

