Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYIDLDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYIDLDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYIDLDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:03:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:12541 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYIDLDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RTcmVo5/WS62DvQP4meiQM2616cgITWk3grNV4Ei5hBnbawDJ5n0zg9tJorJYO8Hsj
         QYV0MtLvwVjOOoA7iw3hrUk9vTuZeEzlwcfWj1QMgUhukr8i8VgKN4XEfChJQHAZPUY3
         33BokxyLoM/RpMhmTNyKg16/4xgW5Gm8navSU=
Message-ID: <48BFCECE.90103@gmail.com>
Date: Thu, 04 Sep 2008 15:34:30 +0330
From: "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>
Reply-To: hamid.jahanjou@gmail.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] VM: Implements the swap-out page-clustering technique
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hamid R. Jahanjou

Implements the idea of swap-out page clustering from *BSD for
Linux. Each time a candidate page is to be swapped out,
virtually-nearby pages are scanned to find eligible pages to be
swapped out too as a cluster. This technique increases the likelihood of
bringing in related data on a page fault and decreases swap space
fragmentation in the long run. Currently, Linux searches only
physically-nearby pages which is not optimal since, over time, physically-
adjacent pages may become unrelated.

The code can be statically tuned. No benchmarks. I'm not sure whether
the added complexity is acceptable.

Signed-off-by: Hamid R. Jahanjou <hamid.jahanjou@gmail.com>
---

diff -uprN -X linux-2.6.26.1-vanilla/Documentation/dontdiff linux-2.6.26.1-vanilla/include/linux/pageout_clustering.h linux-2.6.26.1HJ/include/linux/pageout_clustering.h
--- linux-2.6.26.1-vanilla/include/linux/pageout_clustering.h	1970-01-01 03:30:00.000000000 +0330
+++ linux-2.6.26.1HJ/include/linux/pageout_clustering.h	2008-08-28 20:19:52.000000000 +0330
@@ -0,0 +1,12 @@
+#ifndef PAGEOUT_CLUSTERING_H_
+#define PAGEOUT_CLUSTERING_H_
+
+#include<linux/list.h>
+#define INITIAL_CLUSTER_SCAN_RANGE 4 
+#define HALF_PAGEOUT_CLUSTER_SIZE 8      /* default number of pages to be clustered 
+					  * on either side of a given page */
+
+int try_to_cluster(struct page *, struct list_head *, 
+		   struct list_head *, int, int);
+
+#endif 
diff -uprN -X linux-2.6.26.1-vanilla/Documentation/dontdiff linux-2.6.26.1-vanilla/include/linux/rmap.h linux-2.6.26.1HJ/include/linux/rmap.h
--- linux-2.6.26.1-vanilla/include/linux/rmap.h	2008-08-02 02:28:24.000000000 +0330
+++ linux-2.6.26.1HJ/include/linux/rmap.h	2008-08-28 20:19:52.000000000 +0330
@@ -102,6 +102,12 @@ pte_t *page_check_address(struct page *,
 unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
 
 /*
+ * Used by pageout clustering 
+ */
+struct anon_vma *page_lock_anon_vma(struct page *);
+void page_unlock_anon_vma(struct anon_vma *);
+
+/*
  * Cleans the PTEs of shared mappings.
  * (and since clean PTEs should also be readonly, write protects them too)
  *
diff -uprN -X linux-2.6.26.1-vanilla/Documentation/dontdiff linux-2.6.26.1-vanilla/mm/Makefile linux-2.6.26.1HJ/mm/Makefile
--- linux-2.6.26.1-vanilla/mm/Makefile	2008-08-02 02:28:24.000000000 +0330
+++ linux-2.6.26.1HJ/mm/Makefile	2008-08-28 20:19:52.000000000 +0330
@@ -9,9 +9,9 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o 
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o pdflush.o \
-			   readahead.o swap.o truncate.o vmscan.o \
-			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o $(mmu-y)
+			   readahead.o swap.o truncate.o pageout_clustering.o \
+			   vmscan.o prio_tree.o util.o mmzone.o vmstat.o \
+                           backing-dev.o page_isolation.o $(mmu-y)
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
diff -uprN -X linux-2.6.26.1-vanilla/Documentation/dontdiff linux-2.6.26.1-vanilla/mm/pageout_clustering.c linux-2.6.26.1HJ/mm/pageout_clustering.c
--- linux-2.6.26.1-vanilla/mm/pageout_clustering.c	1970-01-01 03:30:00.000000000 +0330
+++ linux-2.6.26.1HJ/mm/pageout_clustering.c	2008-09-04 09:26:40.000000000 +0330
@@ -0,0 +1,278 @@
+#include<linux/pageout_clustering.h>
+#include<linux/mm.h>
+#include<linux/pagemap.h>
+#include<linux/swap.h>
+#include<linux/swapops.h>
+#include<linux/slab.h>
+#include<linux/init.h>
+#include<linux/rmap.h>
+#include<linux/module.h>
+#include<linux/memcontrol.h>
+
+
+/*
+ * contains data related to pageout clustering
+ */
+struct clustering_info 
+{
+
+    struct page *page;                 /* page descriptor of a page used for sampling cluster pages */ 
+    struct vm_area_struct *vma;        /* VMA under consideration */
+    struct list_head *src;             /* source page list used by shrink_list and friends */
+    
+    union {
+	struct anon_vma *anon_vma;     /* anon_vma object we're using for reverse mapping */
+	struct address_space *mapping; /* address_space object we're using for reverse mapping */
+};
+    
+    struct page **cluster;             /* our page cluster */
+    unsigned int cluster_size;         /* cluster size */
+    unsigned int page_index;           /* index of the sampling page within the cluster */
+    unsigned int index;                /* slot in the cluster for the next page */
+    unsigned int range;                /* maximum number of VMA's to scan */
+    unsigned int nr_collected;         /* number of pages collected in the cluster */
+    unsigned int nr_sc;                /* current number of VMA's scanned */
+    int mode;                          /* page-isolation mode */
+    int anonym;                        /* indicates whether we are to collect mapped pages (0)
+					* or anonymous pages (1) */
+    int (*continue_search)
+	(struct clustering_info *);    /* returns true if the search can go on */
+};
+
+
+static inline int check_conditions(struct clustering_info *ci)
+{
+    return (ci->nr_sc < ci->range) && (ci->nr_collected < ci->cluster_size);
+}
+
+    
+/* embodies page-selection-for-clustering policy */
+static inline int page_allowed_in_cluster(struct page *page, struct clustering_info *ci)
+{
+    int zone_id = page_zone_id(ci->page);
+
+
+    /* scanning the original page ? */
+    if (unlikely(page == ci->page))
+	return 0;
+
+    /* skip pages belonging to other zones */
+    if (unlikely(page_zone_id(page) != zone_id))
+	return 0;
+
+    /* skip pages not in LRU lists */
+    if (!PageLRU(page))
+	return 0;
+
+    /* skip active pages */
+    if (page->flags & PG_active)
+	return 0;
+
+    /* skip non-dirty pages */
+    if (!(page->flags & PG_dirty))
+	return 0;
+        
+    return 1;
+}
+
+
+
+/* embodies vma-selection-for-clustering policy */ 
+static inline int vma_allowed_in_cluster(struct vm_area_struct *vma, struct clustering_info *ci)
+{
+    if ( (vma->vm_flags & VM_RESERVED) ||
+	 (vma->vm_flags & VM_LOCKED) ||
+	 (vma->vm_flags & VM_IO) ||
+	 (vma->vm_flags & VM_NONLINEAR) )
+	return 0;
+
+    /* we ignore mapped VMA's when doing anonym clustering; */
+    /* similarly, we ignore anonym VMA's when doing mapped clustering */
+    if ( ((ci->anonym) && (vma->vm_file != NULL)) ||
+	 (!(ci->anonym) && (vma->vm_file == NULL)) )
+	return 0;
+    
+    return 1;
+}
+
+
+
+/*
+ * scans a process's vma structures, to find pages eligible for being added to cluster
+ */
+static void try_to_cluster_vma(struct clustering_info *ci)
+{
+    struct vm_area_struct *cursor_vma = ci->vma;
+    struct page *cursor_page;
+    struct mm_struct *cursor_mm;
+    unsigned long vm_address;
+
+
+    cursor_mm = cursor_vma->vm_mm;
+    if (!down_read_trylock(&cursor_mm->mmap_sem))
+	return;
+
+    do
+    {
+	if (!vma_allowed_in_cluster(cursor_vma, ci))
+	    goto next_vma;
+
+	ci->nr_sc++;
+
+	for(vm_address = cursor_vma->vm_start; 
+	    vm_address < cursor_vma->vm_end && ci->nr_collected < ci->cluster_size; 
+	    vm_address += PAGE_SIZE)
+	{
+	    cursor_page = virt_to_page(vm_address);
+	    if (!page_allowed_in_cluster(cursor_page, ci))
+		continue;
+
+	    switch (__isolate_lru_page(cursor_page, ci->mode)) 
+	    {
+	    case 0:
+		ci->cluster[ci->index] = cursor_page;
+		ci->nr_collected++;
+		ci->index = (++ci->index) % (ci->cluster_size);
+		break;
+
+	    case -EBUSY:
+		/* it is being freed else where */
+		list_move(&cursor_page->lru, ci->src);
+		break;
+
+	    default:
+		break;
+	    };   
+	}
+
+next_vma: 
+	cursor_vma = cursor_vma->vm_next;
+	/* begin from the first VMA if the end of list is reached */
+	if (cursor_vma == NULL)
+	    cursor_vma = cursor_mm->mmap;
+
+    } while (cursor_vma != ci->vma && ci->continue_search(ci));
+
+    up_read(&cursor_mm->mmap_sem);
+    return;
+}
+
+
+
+/*
+ * helper function for try_to_cluster(); handles mapped pages
+ */
+static inline void try_to_cluster_mapped(struct clustering_info *ci)
+{
+    struct vm_area_struct *vma;
+    struct prio_tree_iter pst_itr;
+    const pgoff_t pgoff = ci->page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+
+    
+    vma_prio_tree_foreach(vma, &pst_itr, &ci->mapping->i_mmap, pgoff, pgoff) {
+	if (!ci->continue_search(ci))
+	    break;
+
+	ci->vma = vma;
+	try_to_cluster_vma(ci);
+    }
+    return;
+}
+
+
+
+/*
+ * helper function for try_to_cluster(); handles anonymous pages
+ */
+static inline void try_to_cluster_anon(struct clustering_info *ci)
+{
+    struct list_head *list_item;
+    struct vm_area_struct *vma;
+
+    
+    for (list_item = ci->anon_vma->head.next; 
+	 (list_item != &ci->anon_vma->head) && ci->continue_search(ci); 
+	 list_item = list_item->next)
+    {
+	vma = list_entry(list_item, struct vm_area_struct, anon_vma_node);
+	ci->vma = vma;
+	try_to_cluster_vma(ci);
+    }
+
+    return;
+}
+
+
+
+/*
+ * Searches in the virtual address space of the process possessing the page 
+ * to find other suitable pages to be swapped out as well. This is known as
+ * page clustering. Not to be confused with other usages of the word in Linux.
+ * 
+ * We adjust the range of our search by the value of the allocation order.
+ *
+ * @page: an originally-selected page
+ * @half_cluster_size: maximum number of pages to cluster on each side of the page
+ * @src: the list containing the page
+ * @dst: the list to insert pages to
+ * @order: allocation order
+ * @mode: page-isolation mode
+ *
+ * returns the number of pages added to the list, including the passed page.
+ */
+int try_to_cluster(struct page *page, struct list_head *src, 
+		   struct list_head *dst, int order, int mode)
+{
+    struct clustering_info cluster_info;
+    struct address_space *mapping;
+    struct anon_vma *anon_vma;
+    unsigned int range = INITIAL_CLUSTER_SCAN_RANGE << order;
+#define def_cluster_size (2 * HALF_PAGEOUT_CLUSTER_SIZE + 1)
+    struct page *cluster[def_cluster_size] = {NULL};
+    int i;
+
+
+    cluster[HALF_PAGEOUT_CLUSTER_SIZE] = page;
+    /* initialize commom fields only; other fields are
+     * set as we go on */
+    cluster_info.page = page;
+    cluster_info.vma = NULL;
+    cluster_info.src = src;
+    cluster_info.cluster = cluster;
+    cluster_info.cluster_size = def_cluster_size;
+    cluster_info.page_index = HALF_PAGEOUT_CLUSTER_SIZE;
+    cluster_info.index = HALF_PAGEOUT_CLUSTER_SIZE + 1;
+    cluster_info.range = range;
+    cluster_info.nr_collected = 1;
+    cluster_info.nr_sc = 0;
+    cluster_info.mode = mode;
+    cluster_info.continue_search = check_conditions;
+    
+    /* try to cluster anonymous pages ? */
+    anon_vma = page_lock_anon_vma(page);
+    if (anon_vma != NULL)
+    {
+	cluster_info.anon_vma = anon_vma;
+	cluster_info.anonym = 1;
+	try_to_cluster_anon(&cluster_info);
+	page_unlock_anon_vma(anon_vma);
+    }
+
+    /* try to cluster mapped pages ? */
+    else if (page_mapped(page))
+    {
+	mapping = page->mapping;
+	spin_lock(&mapping->i_mmap_lock);
+	cluster_info.mapping = mapping;
+	cluster_info.anonym = 0;
+	try_to_cluster_mapped(&cluster_info);
+	spin_unlock(&mapping->i_mmap_lock);
+    }
+
+    /* add to destination list */
+    for (i = 0; i < def_cluster_size; i++)
+	if (cluster[i] != NULL)
+	    list_move(&cluster[i]->lru, dst);
+
+    return cluster_info.nr_collected;
+}
diff -uprN -X linux-2.6.26.1-vanilla/Documentation/dontdiff linux-2.6.26.1-vanilla/mm/rmap.c linux-2.6.26.1HJ/mm/rmap.c
--- linux-2.6.26.1-vanilla/mm/rmap.c	2008-08-02 02:28:24.000000000 +0330
+++ linux-2.6.26.1HJ/mm/rmap.c	2008-08-28 20:19:52.000000000 +0330
@@ -156,7 +156,7 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-static struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
@@ -176,7 +176,7 @@ out:
 	return NULL;
 }
 
-static void page_unlock_anon_vma(struct anon_vma *anon_vma)
+void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	spin_unlock(&anon_vma->lock);
 	rcu_read_unlock();
diff -uprN -X linux-2.6.26.1-vanilla/Documentation/dontdiff linux-2.6.26.1-vanilla/mm/vmscan.c linux-2.6.26.1HJ/mm/vmscan.c
--- linux-2.6.26.1-vanilla/mm/vmscan.c	2008-08-02 02:28:24.000000000 +0330
+++ linux-2.6.26.1HJ/mm/vmscan.c	2008-08-28 20:19:52.000000000 +0330
@@ -38,6 +38,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/memcontrol.h>
+#include <linux/pageout_clustering.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -700,10 +701,7 @@ static unsigned long isolate_lru_pages(u
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		struct page *page;
-		unsigned long pfn;
-		unsigned long end_pfn;
-		unsigned long page_pfn;
-		int zone_id;
+		int nr_clustered;
 
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
@@ -712,8 +710,7 @@ static unsigned long isolate_lru_pages(u
 
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
-			list_move(&page->lru, dst);
-			nr_taken++;
+		        /* counted and added to dst in try_to_cluster() */
 			break;
 
 		case -EBUSY:
@@ -725,51 +722,13 @@ static unsigned long isolate_lru_pages(u
 			BUG();
 		}
 
-		if (!order)
-			continue;
-
-		/*
-		 * Attempt to take all pages in the order aligned region
-		 * surrounding the tag page.  Only take those pages of
-		 * the same active state as that tag page.  We may safely
-		 * round the target page pfn down to the requested order
-		 * as the mem_map is guarenteed valid out to MAX_ORDER,
-		 * where that page is in a different zone we will detect
-		 * it from its zone id and abort this block scan.
-		 */
-		zone_id = page_zone_id(page);
-		page_pfn = page_to_pfn(page);
-		pfn = page_pfn & ~((1 << order) - 1);
-		end_pfn = pfn + (1 << order);
-		for (; pfn < end_pfn; pfn++) {
-			struct page *cursor_page;
-
-			/* The target page is in the block, ignore it. */
-			if (unlikely(pfn == page_pfn))
-				continue;
-
-			/* Avoid holes within the zone. */
-			if (unlikely(!pfn_valid_within(pfn)))
-				break;
-
-			cursor_page = pfn_to_page(pfn);
-			/* Check that we have not crossed a zone boundary. */
-			if (unlikely(page_zone_id(cursor_page) != zone_id))
-				continue;
-			switch (__isolate_lru_page(cursor_page, mode)) {
-			case 0:
-				list_move(&cursor_page->lru, dst);
-				nr_taken++;
-				scan++;
-				break;
-
-			case -EBUSY:
-				/* else it is being freed elsewhere */
-				list_move(&cursor_page->lru, src);
-			default:
-				break;
-			}
-		}
+		/* 
+		 * scan virtually-nearby pages in process address space
+		 * to find eligible pages to be swapped out as well
+		 */
+		nr_clustered = try_to_cluster(page, src, dst, order, mode);
+		nr_taken += nr_clustered;
+		scan += nr_clustered - 1;
 	}
 
 	*scanned = scan;


