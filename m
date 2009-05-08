Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbZEHMVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbZEHMVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZEHMVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:21:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:61248 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbZEHMVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,317,1239001200"; 
   d="scan'208";a="140682169"
Date: Fri, 8 May 2009 20:21:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/8] mm: introduce PageHuge() for testing huge/gigantic
	pages
Message-ID: <20090508122115.GA15949@localhost>
References: <20090508105320.316173813@intel.com> <20090508111030.264063904@intel.com> <20090508114018.GA17129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508114018.GA17129@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 07:40:18PM +0800, Ingo Molnar wrote:
> 
> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Introduce PageHuge(), which identifies huge/gigantic pages
> > by their dedicated compound destructor functions.
[snip]
> > +#ifdef CONFIG_HUGETLBFS
> > +void free_huge_page(struct page *page);
> > +void free_gigantic_page(struct page *page);
> > +
> > +static inline int PageHuge(struct page *page)
> > +{
> > +	compound_page_dtor *dtor;
> > +
> > +	if (!PageCompound(page))
> > +		return 0;
> > +
> > +	page = compound_head(page);
> > +	dtor = get_compound_page_dtor(page);
> > +
> > +	return  dtor == free_huge_page ||
> > +		dtor == free_gigantic_page;
> > +}
> 
> Hm, this function is _way_ too large to be inlined.

Thanks, updated patch as follows.

---
Subject: mm: introduce PageHuge() for testing huge/gigantic pages

Introduce PageHuge(), which identifies huge/gigantic pages
by their dedicated compound destructor functions.

Also move prep_compound_gigantic_page() to hugetlb.c and
make __free_pages_ok() non-static.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/mm.h |    9 +++
 mm/hugetlb.c       |   98 ++++++++++++++++++++++++++++---------------
 mm/internal.h      |    6 +-
 mm/page_alloc.c    |   21 ---------
 4 files changed, 79 insertions(+), 55 deletions(-)

--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -77,8 +77,6 @@ int percpu_pagelist_fraction;
 int pageblock_order __read_mostly;
 #endif
 
-static void __free_pages_ok(struct page *page, unsigned int order);
-
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -298,23 +296,6 @@ void prep_compound_page(struct page *pag
 	}
 }
 
-#ifdef CONFIG_HUGETLBFS
-void prep_compound_gigantic_page(struct page *page, unsigned long order)
-{
-	int i;
-	int nr_pages = 1 << order;
-	struct page *p = page + 1;
-
-	set_compound_page_dtor(page, free_compound_page);
-	set_compound_order(page, order);
-	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
-		__SetPageTail(p);
-		p->first_page = page;
-	}
-}
-#endif
-
 static int destroy_compound_page(struct page *page, unsigned long order)
 {
 	int i;
@@ -544,7 +525,7 @@ static void free_one_page(struct zone *z
 	spin_unlock(&zone->lock);
 }
 
-static void __free_pages_ok(struct page *page, unsigned int order)
+void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	int i;
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -578,39 +578,9 @@ static void free_huge_page(struct page *
 		hugetlb_put_quota(mapping, 1);
 }
 
-/*
- * Increment or decrement surplus_huge_pages.  Keep node-specific counters
- * balanced by operating on them in a round-robin fashion.
- * Returns 1 if an adjustment was made.
- */
-static int adjust_pool_surplus(struct hstate *h, int delta)
+static void free_gigantic_page(struct page *page)
 {
-	static int prev_nid;
-	int nid = prev_nid;
-	int ret = 0;
-
-	VM_BUG_ON(delta != -1 && delta != 1);
-	do {
-		nid = next_node(nid, node_online_map);
-		if (nid == MAX_NUMNODES)
-			nid = first_node(node_online_map);
-
-		/* To shrink on this node, there must be a surplus page */
-		if (delta < 0 && !h->surplus_huge_pages_node[nid])
-			continue;
-		/* Surplus cannot exceed the total number of pages */
-		if (delta > 0 && h->surplus_huge_pages_node[nid] >=
-						h->nr_huge_pages_node[nid])
-			continue;
-
-		h->surplus_huge_pages += delta;
-		h->surplus_huge_pages_node[nid] += delta;
-		ret = 1;
-		break;
-	} while (nid != prev_nid);
-
-	prev_nid = nid;
-	return ret;
+	__free_pages_ok(page, compound_order(page));
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -623,6 +593,35 @@ static void prep_new_huge_page(struct hs
 	put_page(page); /* free it into the hugepage allocator */
 }
 
+static void prep_compound_gigantic_page(struct page *page, unsigned long order)
+{
+	int i;
+	int nr_pages = 1 << order;
+	struct page *p = page + 1;
+
+	set_compound_page_dtor(page, free_gigantic_page);
+	set_compound_order(page, order);
+	__SetPageHead(page);
+	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		__SetPageTail(p);
+		p->first_page = page;
+	}
+}
+
+int PageHuge(struct page *page)
+{
+	compound_page_dtor *dtor;
+
+	if (!PageCompound(page))
+		return 0;
+
+	page = compound_head(page);
+	dtor = get_compound_page_dtor(page);
+
+	return  dtor == free_huge_page ||
+		dtor == free_gigantic_page;
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
@@ -1140,6 +1139,41 @@ static inline void try_to_free_low(struc
 }
 #endif
 
+/*
+ * Increment or decrement surplus_huge_pages.  Keep node-specific counters
+ * balanced by operating on them in a round-robin fashion.
+ * Returns 1 if an adjustment was made.
+ */
+static int adjust_pool_surplus(struct hstate *h, int delta)
+{
+	static int prev_nid;
+	int nid = prev_nid;
+	int ret = 0;
+
+	VM_BUG_ON(delta != -1 && delta != 1);
+	do {
+		nid = next_node(nid, node_online_map);
+		if (nid == MAX_NUMNODES)
+			nid = first_node(node_online_map);
+
+		/* To shrink on this node, there must be a surplus page */
+		if (delta < 0 && !h->surplus_huge_pages_node[nid])
+			continue;
+		/* Surplus cannot exceed the total number of pages */
+		if (delta > 0 && h->surplus_huge_pages_node[nid] >=
+						h->nr_huge_pages_node[nid])
+			continue;
+
+		h->surplus_huge_pages += delta;
+		h->surplus_huge_pages_node[nid] += delta;
+		ret = 1;
+		break;
+	} while (nid != prev_nid);
+
+	prev_nid = nid;
+	return ret;
+}
+
 #define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)
 static unsigned long set_max_huge_pages(struct hstate *h, unsigned long count)
 {
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -355,6 +355,15 @@ static inline void set_compound_order(st
 	page[1].lru.prev = (void *)order;
 }
 
+#ifdef CONFIG_HUGETLBFS
+int PageHuge(struct page *page);
+#else
+static inline int PageHuge(struct page *page)
+{
+	return 0;
+}
+#endif
+
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
--- linux.orig/mm/internal.h
+++ linux/mm/internal.h
@@ -16,9 +16,6 @@
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
 
-extern void prep_compound_page(struct page *page, unsigned long order);
-extern void prep_compound_gigantic_page(struct page *page, unsigned long order);
-
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_count, v);
@@ -51,6 +48,9 @@ extern void putback_lru_page(struct page
  */
 extern unsigned long highest_memmap_pfn;
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
+extern void __free_pages_ok(struct page *page, unsigned int order);
+extern void prep_compound_page(struct page *page, unsigned long order);
+
 
 /*
  * function for dealing with page's order in buddy system.
