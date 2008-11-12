Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYKLA3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYKLA3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYKLA0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:12 -0500
Received: from kroah.org ([198.145.64.141]:42140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753154AbYKLA0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:10 -0500
Date: Tue, 11 Nov 2008 16:23:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andy Whitcroft <apw@shadowen.org>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [patch 09/49] hugetlbfs: handle pages higher order than MAX_ORDER
Message-ID: <20081112002309.GJ10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hugetlbfs-handle-pages-higher-order-than-max_order.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Whitcroft <apw@shadowen.org>

commit 69d177c2fc702d402b17fdca2190d5a7e3ca55c5 upstream

When working with hugepages, hugetlbfs assumes that those hugepages are
smaller than MAX_ORDER.  Specifically it assumes that the mem_map is
contigious and uses that to optimise access to the elements of the mem_map
that represent the hugepage.  Gigantic pages (such as 16GB pages on
powerpc) by definition are of greater order than MAX_ORDER (larger than
MAX_ORDER_NR_PAGES in size).  This means that we can no longer make use of
the buddy alloctor guarentees for the contiguity of the mem_map, which
ensures that the mem_map is at least contigious for maximmally aligned
areas of MAX_ORDER_NR_PAGES pages.

This patch adds new mem_map accessors and iterator helpers which handle
any discontiguity at MAX_ORDER_NR_PAGES boundaries.  It then uses these to
implement gigantic page versions of copy_huge_page and clear_huge_page,
and to allow follow_hugetlb_page handle gigantic pages.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 mm/hugetlb.c  |   37 ++++++++++++++++++++++++++++++++++++-
 mm/internal.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -353,11 +353,26 @@ static int vma_has_reserves(struct vm_ar
 	return 0;
 }
 
+static void clear_gigantic_page(struct page *page,
+			unsigned long addr, unsigned long sz)
+{
+	int i;
+	struct page *p = page;
+
+	might_sleep();
+	for (i = 0; i < sz/PAGE_SIZE; i++, p = mem_map_next(p, page, i)) {
+		cond_resched();
+		clear_user_highpage(p, addr + i * PAGE_SIZE);
+	}
+}
 static void clear_huge_page(struct page *page,
 			unsigned long addr, unsigned long sz)
 {
 	int i;
 
+	if (unlikely(sz > MAX_ORDER_NR_PAGES))
+		return clear_gigantic_page(page, addr, sz);
+
 	might_sleep();
 	for (i = 0; i < sz/PAGE_SIZE; i++) {
 		cond_resched();
@@ -365,12 +380,32 @@ static void clear_huge_page(struct page 
 	}
 }
 
+static void copy_gigantic_page(struct page *dst, struct page *src,
+			   unsigned long addr, struct vm_area_struct *vma)
+{
+	int i;
+	struct hstate *h = hstate_vma(vma);
+	struct page *dst_base = dst;
+	struct page *src_base = src;
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page(h); ) {
+		cond_resched();
+		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
+
+		i++;
+		dst = mem_map_next(dst, dst_base, i);
+		src = mem_map_next(src, src_base, i);
+	}
+}
 static void copy_huge_page(struct page *dst, struct page *src,
 			   unsigned long addr, struct vm_area_struct *vma)
 {
 	int i;
 	struct hstate *h = hstate_vma(vma);
 
+	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES))
+		return copy_gigantic_page(dst, src, addr, vma);
+
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page(h); i++) {
 		cond_resched();
@@ -2113,7 +2148,7 @@ int follow_hugetlb_page(struct mm_struct
 same_page:
 		if (pages) {
 			get_page(page);
-			pages[i] = page + pfn_offset;
+			pages[i] = mem_map_offset(page, pfn_offset);
 		}
 
 		if (vmas)
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -54,6 +54,34 @@ static inline unsigned long page_order(s
 }
 
 /*
+ * Return the mem_map entry representing the 'offset' subpage within
+ * the maximally aligned gigantic page 'base'.  Handle any discontiguity
+ * in the mem_map at MAX_ORDER_NR_PAGES boundaries.
+ */
+static inline struct page *mem_map_offset(struct page *base, int offset)
+{
+	if (unlikely(offset >= MAX_ORDER_NR_PAGES))
+		return pfn_to_page(page_to_pfn(base) + offset);
+	return base + offset;
+}
+
+/*
+ * Iterator over all subpages withing the maximally aligned gigantic
+ * page 'base'.  Handle any discontiguity in the mem_map.
+ */
+static inline struct page *mem_map_next(struct page *iter,
+						struct page *base, int offset)
+{
+	if (unlikely((offset & (MAX_ORDER_NR_PAGES - 1)) == 0)) {
+		unsigned long pfn = page_to_pfn(base) + offset;
+		if (!pfn_valid(pfn))
+			return NULL;
+		return pfn_to_page(pfn);
+	}
+	return iter + 1;
+}
+
+/*
  * FLATMEM and DISCONTIGMEM configurations use alloc_bootmem_node,
  * so all functions starting at paging_init should be marked __init
  * in those cases. SPARSEMEM, however, allows for memory hotplug,

-- 
