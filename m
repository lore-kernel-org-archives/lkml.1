Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZAVJsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZAVJsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZAVJr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:47:56 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35187 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZAVJry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:47:54 -0500
Subject: Re: Mainline kernel OLTP performance update
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       sfr@canb.auug.org.au, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
In-Reply-To: <1232616517.11429.129.camel@ymzhang>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <200901161503.13730.nickpiggin@yahoo.com.au>
	 <20090115201210.ca1a9542.akpm@linux-foundation.org>
	 <200901161746.25205.nickpiggin@yahoo.com.au>
	 <20090116065546.GJ31013@parisc-linux.org>
	 <1232092430.11429.52.camel@ymzhang>  <87sknjeemn.fsf@basil.nowhere.org>
	 <1232428583.11429.83.camel@ymzhang>
	 <alpine.DEB.1.10.0901211852060.18367@qirst.com>
	 <1232613395.11429.122.camel@ymzhang>
	 <1232615707.14549.6.camel@penberg-laptop>
	 <1232616517.11429.129.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Jan 2009 11:47:52 +0200
Message-Id: <1232617672.14549.25.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 17:28 +0800, Zhang, Yanmin wrote:
> On Thu, 2009-01-22 at 11:15 +0200, Pekka Enberg wrote:
> > On Thu, 2009-01-22 at 16:36 +0800, Zhang, Yanmin wrote:
> > > On Wed, 2009-01-21 at 18:58 -0500, Christoph Lameter wrote:
> > > > On Tue, 20 Jan 2009, Zhang, Yanmin wrote:
> > > > 
> > > > > kmem_cache ﻿skbuff_head_cache's object size is just 256, so it shares the kmem_cache
> > > > > with ﻿:0000256. Their order is 1 which means every slab consists of 2 physical pages.
> > > > 
> > > > That order can be changed. Try specifying slub_max_order=0 on the kernel
> > > > command line to force an order 0 alloc.
> > > I tried ﻿slub_max_order=0 and there is no improvement on this UDP-U-4k issue.
> > > Both get_page_from_freelist and __free_pages_ok's cpu time are still very high.
> > > 
> > > I checked my instrumentation in kernel and found it's caused by large object allocation/free
> > > whose size is more than PAGE_SIZE. Here its order is 1.
> > > 
> > > The right free callchain is __kfree_skb => skb_release_all => skb_release_data.
> > > 
> > > So this case isn't the issue that batch of allocation/free might erase partial page
> > > functionality.
> > 
> > So is this the kfree(skb->head) in skb_release_data() or the put_page()
> > calls in the same function in a loop?
> It's ﻿kfree(skb->head).
> 
> > 
> > If it's the former, with big enough size passed to __alloc_skb(), the
> > networking code might be taking a hit from the SLUB page allocator
> > pass-through.

Do we know what kind of size is being passed to __alloc_skb() in this
case? Maybe we want to do something like this.

		Pekka

SLUB: revert page allocator pass-through

This is a revert of commit aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB:
direct pass through of page size or higher kmalloc requests").
---

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 2f5c16b..3bd3662 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -124,7 +124,7 @@ struct kmem_cache {
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
  */
-extern struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1];
+extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
 
 /*
  * Sorry that the following has to be that ugly but some versions of GCC
@@ -135,6 +135,9 @@ static __always_inline int kmalloc_index(size_t size)
 	if (!size)
 		return 0;
 
+	if (size > KMALLOC_MAX_SIZE)
+		return -1;
+
 	if (size <= KMALLOC_MIN_SIZE)
 		return KMALLOC_SHIFT_LOW;
 
@@ -154,10 +157,6 @@ static __always_inline int kmalloc_index(size_t size)
 	if (size <=       1024) return 10;
 	if (size <=   2 * 1024) return 11;
 	if (size <=   4 * 1024) return 12;
-/*
- * The following is only needed to support architectures with a larger page
- * size than 4k.
- */
 	if (size <=   8 * 1024) return 13;
 	if (size <=  16 * 1024) return 14;
 	if (size <=  32 * 1024) return 15;
@@ -167,6 +166,10 @@ static __always_inline int kmalloc_index(size_t size)
 	if (size <= 512 * 1024) return 19;
 	if (size <= 1024 * 1024) return 20;
 	if (size <=  2 * 1024 * 1024) return 21;
+	if (size <=  4 * 1024 * 1024) return 22;
+	if (size <=  8 * 1024 * 1024) return 23;
+	if (size <= 16 * 1024 * 1024) return 24;
+	if (size <= 32 * 1024 * 1024) return 25;
 	return -1;
 
 /*
@@ -191,6 +194,19 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 	if (index == 0)
 		return NULL;
 
+	/*
+	 * This function only gets expanded if __builtin_constant_p(size), so
+	 * testing it here shouldn't be needed.  But some versions of gcc need
+	 * help.
+	 */
+	if (__builtin_constant_p(size) && index < 0) {
+		/*
+		 * Generate a link failure. Would be great if we could
+		 * do something to stop the compile here.
+		 */
+		extern void __kmalloc_size_too_large(void);
+		__kmalloc_size_too_large();
+	}
 	return &kmalloc_caches[index];
 }
 
@@ -204,17 +220,9 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
-{
-	return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
-}
-
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
-		if (size > PAGE_SIZE)
-			return kmalloc_large(size, flags);
-
 		if (!(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
 
diff --git a/mm/slub.c b/mm/slub.c
index 6392ae5..8fad23f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2475,7 +2475,7 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  *		Kmalloc subsystem
  *******************************************************************/
 
-struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1] __cacheline_aligned;
+struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
 static int __init setup_slub_min_order(char *str)
@@ -2537,7 +2537,7 @@ panic:
 }
 
 #ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT + 1];
+static struct kmem_cache *kmalloc_caches_dma[KMALLOC_SHIFT_HIGH + 1];
 
 static void sysfs_add_func(struct work_struct *w)
 {
@@ -2643,8 +2643,12 @@ static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 			return ZERO_SIZE_PTR;
 
 		index = size_index[(size - 1) / 8];
-	} else
+	} else {
+		if (size > KMALLOC_MAX_SIZE)
+			return NULL;
+
 		index = fls(size - 1);
+	}
 
 #ifdef CONFIG_ZONE_DMA
 	if (unlikely((flags & SLUB_DMA)))
@@ -2658,9 +2662,6 @@ void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large(size, flags);
-
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
@@ -2670,25 +2671,11 @@ void *__kmalloc(size_t size, gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc);
 
-static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
-{
-	struct page *page = alloc_pages_node(node, flags | __GFP_COMP,
-						get_order(size));
-
-	if (page)
-		return page_address(page);
-	else
-		return NULL;
-}
-
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large_node(size, flags, node);
-
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
@@ -2746,11 +2733,8 @@ void kfree(const void *x)
 		return;
 
 	page = virt_to_head_page(x);
-	if (unlikely(!PageSlab(page))) {
-		BUG_ON(!PageCompound(page));
-		put_page(page);
+	if (unlikely(WARN_ON(!PageSlab(page)))) /* XXX */
 		return;
-	}
 	slab_free(page->slab, page, object, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
@@ -2985,7 +2969,7 @@ void __init kmem_cache_init(void)
 		caches++;
 	}
 
-	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++) {
+	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 		create_kmalloc_cache(&kmalloc_caches[i],
 			"kmalloc", 1 << i, GFP_KERNEL);
 		caches++;
@@ -3022,7 +3006,7 @@ void __init kmem_cache_init(void)
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
-	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++)
+	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
 		kmalloc_caches[i]. name =
 			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
 
@@ -3222,9 +3206,6 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large(size, gfpflags);
-
 	s = get_slab(size, gfpflags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
@@ -3238,9 +3219,6 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large_node(size, gfpflags, node);
-
 	s = get_slab(size, gfpflags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))


