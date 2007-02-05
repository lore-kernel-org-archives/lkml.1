Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbXBEH5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbXBEH5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 02:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXBEH5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 02:57:30 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:41557 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752766AbXBEH53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 02:57:29 -0500
Date: Sun, 4 Feb 2007 23:57:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <1170576977.3073.1100.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702042351040.23790@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> 
 <20070203005316.eb0b4042.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com> 
 <1170525860.3073.1054.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com> 
 <20070203172242.e5bf2534.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
 <1170576977.3073.1100.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm.. I have had no time to test this one yet but I think this should 
work. It uses the delayed method and a new page flag PageMlocked() with 
different semantics. Fix for page migration is also included.

Patch avoids to put new anonymous mlocked pages on the LRU. Maybe the same 
could be done for new pagecache pages?

I still need a solution for the problem of not having enough page flag 
bits on i386 NUMA.


Index: current/mm/vmscan.c
===================================================================
--- current.orig/mm/vmscan.c	2007-02-03 10:53:15.000000000 -0800
+++ current/mm/vmscan.c	2007-02-04 22:59:01.000000000 -0800
@@ -516,10 +516,11 @@ static unsigned long shrink_page_list(st
 		if (page_mapped(page) && mapping) {
 			switch (try_to_unmap(page, 0)) {
 			case SWAP_FAIL:
-			case SWAP_MLOCK:
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
+			case SWAP_MLOCK:
+				goto mlocked;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
@@ -594,6 +595,14 @@ free_it:
 			__pagevec_release_nonlru(&freed_pvec);
 		continue;
 
+mlocked:
+		ClearPageActive(page);
+		unlock_page(page);
+		__inc_zone_page_state(page, NR_MLOCK);
+		smp_wmb();
+		SetPageMlocked(page);
+		continue;
+
 activate_locked:
 		SetPageActive(page);
 		pgactivate++;
Index: current/mm/memory.c
===================================================================
--- current.orig/mm/memory.c	2007-02-03 10:52:37.000000000 -0800
+++ current/mm/memory.c	2007-02-04 23:48:36.000000000 -0800
@@ -682,6 +682,8 @@ static unsigned long zap_pte_range(struc
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
+			if (PageMlocked(page) && vma->vm_flags & VM_LOCKED)
+				lru_cache_add_mlock(page);
 			tlb_remove_page(tlb, page);
 			continue;
 		}
@@ -898,6 +900,25 @@ unsigned long zap_page_range(struct vm_a
 }
 
 /*
+ * Add a new anonymous page
+ */
+void anon_add(struct vm_area_struct *vma, struct page *page,
+				unsigned long address)
+{
+	inc_mm_counter(vma->vm_mm, anon_rss);
+	if (vma->vm_flags & VM_LOCKED) {
+		/*
+		 * Page is new and therefore not on the LRU
+		 * so we can directly mark it as mlocked
+		 */
+		SetPageMlocked(page);
+		inc_zone_page_state(page, NR_MLOCK);
+	} else
+		lru_cache_add_active(page);
+	page_add_new_anon_rmap(page, vma, address);
+}
+
+/*
  * Do a quick page-table lookup for a single page.
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
@@ -2101,9 +2122,7 @@ static int do_anonymous_page(struct mm_s
 		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto release;
-		inc_mm_counter(mm, anon_rss);
-		lru_cache_add_active(page);
-		page_add_new_anon_rmap(page, vma, address);
+		anon_add(vma, page, address);
 	} else {
 		/* Map the ZERO_PAGE - vm_page_prot is readonly */
 		page = ZERO_PAGE(address);
@@ -2247,11 +2266,9 @@ retry:
 		if (write_access)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		set_pte_at(mm, address, page_table, entry);
-		if (anon) {
-			inc_mm_counter(mm, anon_rss);
-			lru_cache_add_active(new_page);
-			page_add_new_anon_rmap(new_page, vma, address);
-		} else {
+		if (anon)
+			anon_add(vma, new_page, address);
+		else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(new_page);
 			if (write_access) {
Index: current/drivers/base/node.c
===================================================================
--- current.orig/drivers/base/node.c	2007-02-03 10:52:35.000000000 -0800
+++ current/drivers/base/node.c	2007-02-03 10:53:25.000000000 -0800
@@ -60,6 +60,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d FilePages:    %8lu kB\n"
 		       "Node %d Mapped:       %8lu kB\n"
 		       "Node %d AnonPages:    %8lu kB\n"
+		       "Node %d Mlock:        %8lu KB\n"
 		       "Node %d PageTables:   %8lu kB\n"
 		       "Node %d NFS_Unstable: %8lu kB\n"
 		       "Node %d Bounce:       %8lu kB\n"
@@ -82,6 +83,7 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, K(node_page_state(nid, NR_MLOCK)),
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(nid, NR_UNSTABLE_NFS)),
 		       nid, K(node_page_state(nid, NR_BOUNCE)),
Index: current/fs/proc/proc_misc.c
===================================================================
--- current.orig/fs/proc/proc_misc.c	2007-02-03 10:52:36.000000000 -0800
+++ current/fs/proc/proc_misc.c	2007-02-03 10:53:25.000000000 -0800
@@ -166,6 +166,7 @@ static int meminfo_read_proc(char *page,
 		"Writeback:    %8lu kB\n"
 		"AnonPages:    %8lu kB\n"
 		"Mapped:       %8lu kB\n"
+		"Mlock:        %8lu KB\n"
 		"Slab:         %8lu kB\n"
 		"SReclaimable: %8lu kB\n"
 		"SUnreclaim:   %8lu kB\n"
@@ -196,6 +197,7 @@ static int meminfo_read_proc(char *page,
 		K(global_page_state(NR_WRITEBACK)),
 		K(global_page_state(NR_ANON_PAGES)),
 		K(global_page_state(NR_FILE_MAPPED)),
+		K(global_page_state(NR_MLOCK)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
Index: current/include/linux/mmzone.h
===================================================================
--- current.orig/include/linux/mmzone.h	2007-02-03 10:52:35.000000000 -0800
+++ current/include/linux/mmzone.h	2007-02-03 10:53:25.000000000 -0800
@@ -58,6 +58,7 @@ enum zone_stat_item {
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
 	/* Second 128 byte cacheline */
+	NR_MLOCK,		/* Mlocked pages */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
Index: current/mm/vmstat.c
===================================================================
--- current.orig/mm/vmstat.c	2007-02-03 10:52:36.000000000 -0800
+++ current/mm/vmstat.c	2007-02-03 10:53:25.000000000 -0800
@@ -439,6 +439,7 @@ static const char * const vmstat_text[] 
 	"nr_file_pages",
 	"nr_dirty",
 	"nr_writeback",
+	"nr_mlock",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
 	"nr_page_table_pages",
Index: current/include/linux/page-flags.h
===================================================================
--- current.orig/include/linux/page-flags.h	2007-02-03 17:56:36.000000000 -0800
+++ current/include/linux/page-flags.h	2007-02-04 23:14:47.000000000 -0800
@@ -93,6 +93,7 @@
 
 #define PG_readahead		20	/* Reminder to do read-ahead */
 
+#define PG_mlocked		21	/* Page is mlocked */
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -235,6 +236,16 @@ static inline void SetPageUptodate(struc
 #define SetPageReadahead(page)	set_bit(PG_readahead, &(page)->flags)
 #define ClearPageReadahead(page) clear_bit(PG_readahead, &(page)->flags)
 
+/*
+ * PageMlocked set means that the page was taken off the LRU because
+ * a VM_LOCKED vma does exist. PageMlocked must be cleared before a
+ * page is put back onto the LRU. PageMlocked is only modified
+ * under the zone->lru_lock like PageLRU.
+ */
+#define PageMlocked(page)	test_bit(PG_mlocked, &(page)->flags)
+#define SetPageMlocked(page)	set_bit(PG_mlocked, &(page)->flags)
+#define ClearPageMlocked(page)	clear_bit(PG_mlocked, &(page)->flags)
+
 struct page;	/* forward declaration */
 
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
Index: current/include/linux/pagevec.h
===================================================================
--- current.orig/include/linux/pagevec.h	2007-02-04 22:55:38.000000000 -0800
+++ current/include/linux/pagevec.h	2007-02-04 23:17:34.000000000 -0800
@@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
 void __pagevec_free(struct pagevec *pvec);
 void __pagevec_lru_add(struct pagevec *pvec);
 void __pagevec_lru_add_active(struct pagevec *pvec);
+void __pagevec_lru_add_mlock(struct pagevec *pvec);
 void pagevec_strip(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
Index: current/include/linux/swap.h
===================================================================
--- current.orig/include/linux/swap.h	2007-02-04 22:55:38.000000000 -0800
+++ current/include/linux/swap.h	2007-02-04 23:17:34.000000000 -0800
@@ -181,6 +181,7 @@ extern unsigned int nr_free_pagecache_pa
 extern void FASTCALL(lru_cache_add(struct page *));
 extern void FASTCALL(lru_cache_add_active(struct page *));
 extern void FASTCALL(lru_cache_add_tail(struct page *));
+extern void FASTCALL(lru_cache_add_mlock(struct page *));
 extern void FASTCALL(activate_page(struct page *));
 extern void FASTCALL(mark_page_accessed(struct page *));
 extern void lru_add_drain(void);
Index: current/mm/mlock.c
===================================================================
--- current.orig/mm/mlock.c	2007-02-04 22:55:38.000000000 -0800
+++ current/mm/mlock.c	2007-02-04 23:28:51.000000000 -0800
@@ -10,7 +10,7 @@
 #include <linux/mm.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
-
+#include <linux/swap.h>
 
 static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 	unsigned long start, unsigned long end, unsigned int newflags)
@@ -63,6 +63,24 @@ success:
 		pages = -pages;
 		if (!(newflags & VM_IO))
 			ret = make_pages_present(start, end);
+	} else {
+		unsigned long addr;
+
+		/*
+		 * We are clearing VM_LOCKED. Feed all pages back via
+		 * to the LRU via lru_cache_add_mlock()
+		 */
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
+			/*
+			 * No need to get a page reference. mmap_sem
+			 * writelock is held.
+			 */
+			struct page *page = follow_page(vma, start, 0);
+
+			if (PageMlocked(page))
+				lru_cache_add_mlock(page);
+			cond_resched();
+		}
 	}
 
 	mm->locked_vm -= pages;
Index: current/mm/swap.c
===================================================================
--- current.orig/mm/swap.c	2007-02-03 17:57:20.000000000 -0800
+++ current/mm/swap.c	2007-02-04 23:25:50.000000000 -0800
@@ -178,6 +178,7 @@ EXPORT_SYMBOL(mark_page_accessed);
 static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
 static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
 static DEFINE_PER_CPU(struct pagevec, lru_add_tail_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_add_mlock_pvecs) = { 0, };
 
 void fastcall lru_cache_add(struct page *page)
 {
@@ -199,6 +200,16 @@ void fastcall lru_cache_add_active(struc
 	put_cpu_var(lru_add_active_pvecs);
 }
 
+void fastcall lru_cache_add_mlock(struct page *page)
+{
+	struct pagevec *pvec = &get_cpu_var(lru_add_mlock_pvecs);
+
+	page_cache_get(page);
+	if (!pagevec_add(pvec, page))
+		__pagevec_lru_add_mlock(pvec);
+	put_cpu_var(lru_add_mlock_pvecs);
+}
+
 static void __pagevec_lru_add_tail(struct pagevec *pvec)
 {
 	int i;
@@ -237,6 +248,9 @@ static void __lru_add_drain(int cpu)
 	pvec = &per_cpu(lru_add_tail_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add_tail(pvec);
+	pvec = &per_cpu(lru_add_mlock_pvecs, cpu);
+	if (pagevec_count(pvec))
+		__pagevec_lru_add_mlock(pvec);
 }
 
 void lru_add_drain(void)
@@ -394,6 +408,7 @@ void __pagevec_lru_add(struct pagevec *p
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageLRU(page));
+		VM_BUG_ON(PageMlocked(page));
 		SetPageLRU(page);
 		add_page_to_inactive_list(zone, page);
 	}
@@ -423,6 +438,7 @@ void __pagevec_lru_add_active(struct pag
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		VM_BUG_ON(PageActive(page));
+		VM_BUG_ON(PageMlocked(page));
 		SetPageActive(page);
 		add_page_to_active_list(zone, page);
 	}
@@ -432,6 +448,36 @@ void __pagevec_lru_add_active(struct pag
 	pagevec_reinit(pvec);
 }
 
+void __pagevec_lru_add_mlock(struct pagevec *pvec)
+{
+	int i;
+	struct zone *zone = NULL;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irq(&zone->lru_lock);
+			zone = pagezone;
+			spin_lock_irq(&zone->lru_lock);
+		}
+		BUG_ON(PageLRU(page));
+		if (!PageMlocked(page))
+			continue;
+		ClearPageMlocked(page);
+		smp_wmb();
+		__dec_zone_state(zone, NR_MLOCK);
+		SetPageLRU(page);
+		add_page_to_active_list(zone, page);
+	}
+	if (zone)
+		spin_unlock_irq(&zone->lru_lock);
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
 /*
  * Function used uniquely to put pages back to the lru at the end of the
  * inactive list to preserve the lru order. Currently only used by swap
Index: current/mm/migrate.c
===================================================================
--- current.orig/mm/migrate.c	2007-02-04 23:37:27.000000000 -0800
+++ current/mm/migrate.c	2007-02-04 23:39:55.000000000 -0800
@@ -58,6 +58,11 @@ int isolate_lru_page(struct page *page, 
 			else
 				del_page_from_inactive_list(zone, page);
 			list_add_tail(&page->lru, pagelist);
+		} else
+		if (PageMlocked(page)) {
+			get_page(page);
+			ClearPageMlocked(page);
+			list_add_tail(&page->lru, pagelist);
 		}
 		spin_unlock_irq(&zone->lru_lock);
 	}

