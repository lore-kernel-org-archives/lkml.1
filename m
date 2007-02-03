Return-Path: <linux-kernel-owner+w=401wt.eu-S1946363AbXBCGU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946363AbXBCGU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 01:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946358AbXBCGU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 01:20:29 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:59597 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946363AbXBCGU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 01:20:28 -0500
Date: Fri, 2 Feb 2007 22:20:12 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [RFC] Tracking mlocked pages and moving them off the LRU
Message-ID: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new variation on the earlier RFC for tracking mlocked pages.
We now mark a mlocked page with a bit in the page flags and remove
them from the LRU. Pages get moved back when no vma that references
the page has VM_LOCKED set anymore.

This means that vmscan no longer uselessly cycles over large amounts
of mlocked memory should someone attempt to mlock large amounts of
memory (may even result in a livelock on large systems).

Synchronization is build around state changes of the PageMlocked bit.
The NR_MLOCK counter is incremented and decremented based on
state transitions of PageMlocked. So the count is accurate.

There is still some unfinished business:

1. We use the 21st page flag and we only have 20 on 32 bit NUMA platforms.

2. Since mlocked pages are now off the LRU page migration will no longer
   move them.

3. Use NR_MLOCK to tune various VM behaviors so that the VM does not 
   longer fall due to too many mlocked pages in certain areas.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: current/include/linux/mmzone.h
===================================================================
--- current.orig/include/linux/mmzone.h	2007-02-02 16:42:51.000000000 -0800
+++ current/include/linux/mmzone.h	2007-02-02 16:43:28.000000000 -0800
@@ -58,6 +58,7 @@ enum zone_stat_item {
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
 	/* Second 128 byte cacheline */
+	NR_MLOCK,		/* Mlocked pages */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
Index: current/mm/memory.c
===================================================================
--- current.orig/mm/memory.c	2007-02-02 16:42:51.000000000 -0800
+++ current/mm/memory.c	2007-02-02 21:24:20.000000000 -0800
@@ -682,6 +682,8 @@ static unsigned long zap_pte_range(struc
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
+			if (PageMlocked(page) && (vma->vm_flags & VM_LOCKED))
+				mlock_remove(page, vma);
 			tlb_remove_page(tlb, page);
 			continue;
 		}
@@ -898,6 +900,21 @@ unsigned long zap_page_range(struct vm_a
 }
 
 /*
+ * Add a new anonymous page
+ */
+void anon_add(struct vm_area_struct *vma, struct page *page,
+				unsigned long address)
+{
+	inc_mm_counter(vma->vm_mm, anon_rss);
+	if (vma->vm_flags & VM_LOCKED) {
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
@@ -949,6 +966,10 @@ struct page *follow_page(struct vm_area_
 	if (unlikely(!page))
 		goto unlock;
 
+	if ((flags & FOLL_MLOCK) &&
+			!PageMlocked(page) &&
+			(vma->vm_flags & VM_LOCKED))
+		mlock_add(page, vma);
 	if (flags & FOLL_GET)
 		get_page(page);
 	if (flags & FOLL_TOUCH) {
@@ -1045,7 +1066,7 @@ int get_user_pages(struct task_struct *t
 			continue;
 		}
 
-		foll_flags = FOLL_TOUCH;
+		foll_flags = FOLL_TOUCH | FOLL_MLOCK;
 		if (pages)
 			foll_flags |= FOLL_GET;
 		if (!write && !(vma->vm_flags & VM_LOCKED) &&
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
@@ -2247,12 +2266,13 @@ retry:
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
+			if (!PageMlocked(new_page) &&
+					(vma->vm_flags & VM_LOCKED))
+				mlock_add(new_page, vma);
 			page_add_file_rmap(new_page);
 			if (write_access) {
 				dirty_page = new_page;
Index: current/drivers/base/node.c
===================================================================
--- current.orig/drivers/base/node.c	2007-02-02 16:42:51.000000000 -0800
+++ current/drivers/base/node.c	2007-02-02 16:43:28.000000000 -0800
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
--- current.orig/fs/proc/proc_misc.c	2007-02-02 16:42:51.000000000 -0800
+++ current/fs/proc/proc_misc.c	2007-02-02 16:43:28.000000000 -0800
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
Index: current/mm/vmstat.c
===================================================================
--- current.orig/mm/vmstat.c	2007-02-02 16:42:51.000000000 -0800
+++ current/mm/vmstat.c	2007-02-02 16:43:28.000000000 -0800
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
--- current.orig/include/linux/page-flags.h	2007-02-02 16:42:51.000000000 -0800
+++ current/include/linux/page-flags.h	2007-02-02 16:43:28.000000000 -0800
@@ -93,6 +93,7 @@
 
 #define PG_readahead		20	/* Reminder to do read-ahead */
 
+#define PG_mlocked		21	/* Page is mlocked */
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -235,6 +236,20 @@ static inline void SetPageUptodate(struc
 #define SetPageReadahead(page)	set_bit(PG_readahead, &(page)->flags)
 #define ClearPageReadahead(page) clear_bit(PG_readahead, &(page)->flags)
 
+#define PageMlocked(page)		\
+		test_bit(PG_mlocked, &(page)->flags)
+#define SetPageMlocked(page)		\
+		set_bit(PG_mlocked, &(page)->flags)
+#define TestSetPageMlocked(page)		\
+		test_and_set_bit(PG_mlocked, &(page)->flags)
+#define TestClearPageMlocked(page)		\
+		test_and_clear_bit(PG_mlocked, &(page)->flags)
+#define ClearPageMlocked(page)		\
+		clear_bit(PG_mlocked, &(page)->flags)
+#define TestClearPageMlocked(page)	\
+		test_and_clear_bit(PG_mlocked, &(page)->flags)
+
+
 struct page;	/* forward declaration */
 
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
Index: current/include/linux/swap.h
===================================================================
--- current.orig/include/linux/swap.h	2007-02-02 16:42:51.000000000 -0800
+++ current/include/linux/swap.h	2007-02-02 21:11:27.000000000 -0800
@@ -187,6 +187,9 @@ extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern int rotate_reclaimable_page(struct page *page);
 extern void swap_setup(void);
+extern void lru_release(struct page *page);
+extern void mlock_remove(struct page *page, struct vm_area_struct *vma);
+extern void mlock_add(struct page *page, struct vm_area_struct *vma);
 
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zone **zones, int order,
Index: current/mm/swap.c
===================================================================
--- current.orig/mm/swap.c	2007-02-02 16:42:51.000000000 -0800
+++ current/mm/swap.c	2007-02-02 16:43:28.000000000 -0800
@@ -36,10 +36,9 @@
 int page_cluster;
 
 /*
- * This path almost never happens for VM activity - pages are normally
- * freed via pagevecs.  But it gets used by networking.
+ * Release a page from the LRU. Needed by mlock.
  */
-static void fastcall __page_cache_release(struct page *page)
+void lru_release(struct page *page)
 {
 	if (PageLRU(page)) {
 		unsigned long flags;
@@ -51,6 +50,15 @@ static void fastcall __page_cache_releas
 		del_page_from_lru(zone, page);
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
+}
+
+/*
+ * This path almost never happens for VM activity - pages are normally
+ * freed via pagevecs.  But it gets used by networking.
+ */
+static void fastcall __page_cache_release(struct page *page)
+{
+	lru_release(page);
 	free_hot_page(page);
 }
 
Index: current/mm/mlock.c
===================================================================
--- current.orig/mm/mlock.c	2007-02-02 16:42:51.000000000 -0800
+++ current/mm/mlock.c	2007-02-02 21:22:15.000000000 -0800
@@ -10,7 +10,185 @@
 #include <linux/mm.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
+#include <linux/rmap.h>
+#include <linux/pagemap.h>
+#include <linux/swap.h>
 
+static int mlock_check_vmas(struct page *page, struct vm_area_struct *vma);
+
+/*
+ * Add a new mlocked reference to a page. If we are the first needing
+ * the page mlocked then update counters.
+ */
+static int __mlock_add(struct page *page)
+{
+	int rc = !TestSetPageMlocked(page);
+
+	if (rc)
+		inc_zone_page_state(page, NR_MLOCK);
+	return rc;
+}
+
+/*
+ * Remove a mlocked reference to a page.
+ */
+static int __mlock_remove(struct page *page, struct vm_area_struct *vma)
+{
+	int rc = TestClearPageMlocked(page);
+
+	if (rc) {
+		dec_zone_page_state(page, NR_MLOCK);
+
+		/*
+		 * Set the mlocked bit again if any vma still
+		 * has VM_LOCKED set
+		 */
+		mlock_check_vmas(page, vma);
+	}
+	return PageMlocked(page);
+}
+
+void mlock_add(struct page *page, struct vm_area_struct *vma)
+{
+	/*
+	 * Unconditionally move the page off the LRU.
+	 * Note that we may fail to remove the page from
+	 * the LRU if some other function already took off the page.
+	 * That function may return the page to the LRU again. At some
+	 * point isolate_lru_pages() will encounter the page
+	 * and take it off the LRU for good.
+	 */
+	lru_release(page);
+	__mlock_add(page);
+}
+
+/*
+ * Remove a mlocked reference to a page.
+ */
+void mlock_remove(struct page *page, struct vm_area_struct *vma)
+{
+	/*
+	 * Pin page so that the page cannot vanish from under us
+	 * via reclaim, page migration etc.
+	 */
+	get_page(page);
+
+	/*
+	 * Safe to drop PageMlocked since the page is pinned in a
+	 * different way.
+	 */
+	if (!__mlock_remove(page, vma))
+		lru_cache_add_active(page);
+	put_page(page);
+}
+
+/*
+ * Check if the page is mapped by a mlocked vma. If so set PageMlocked.
+ */
+static int page_in_mlocked_vma(struct vm_area_struct *vma, struct page *page)
+{
+	struct mm_struct *mm = vma->vm_mm;
+ 	pgd_t *pgd;
+ 	pud_t *pud;
+ 	pmd_t *pmd;
+	pte_t *ptep, pte;
+ 	spinlock_t *ptl;
+	unsigned long addr = page_address_in_vma(page, vma);
+	int rc = 0;
+
+	if (addr == -EFAULT ||
+			PageReserved(page) ||
+			!PageMlocked(page))
+		return 0;
+
+ 	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+                return 0;
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+                return 0;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		return 0;
+
+	ptep = pte_offset_map(pmd, addr);
+ 	ptl = pte_lockptr(mm, pmd);
+ 	spin_lock(ptl);
+	pte = *ptep;
+	if (!is_swap_pte(pte) &&
+		page == vm_normal_page(vma, addr, pte) &&
+		(vma->vm_flags & VM_LOCKED)) {
+			if (__mlock_add(page))
+				rc = 1;
+		}
+	pte_unmap_unlock(ptep, ptl);
+	return rc;
+}
+
+static int mlock_check_file(struct page *page, struct vm_area_struct *v)
+{
+	struct vm_area_struct *vma;
+	struct address_space *mapping = page_mapping(page);
+	struct prio_tree_iter iter;
+	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	int rc = 0;
+
+	if (!mapping)
+		return 0;
+
+	spin_lock(&mapping->i_mmap_lock);
+
+	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff)
+		if (v != vma && (vma->vm_flags & VM_LOCKED) &&
+				page_in_mlocked_vma(vma, page)) {
+					rc = 1;
+					break;
+				}
+
+	spin_unlock(&mapping->i_mmap_lock);
+	return rc;
+}
+
+static int mlock_check_anon(struct page *page, struct vm_area_struct *v)
+{
+	struct anon_vma *anon_vma;
+	struct vm_area_struct *vma;
+	unsigned long mapping;
+	int rc = 0;
+
+	mapping = (unsigned long)page->mapping;
+
+	if (!mapping || (mapping & PAGE_MAPPING_ANON) == 0)
+		return 0;
+
+	/*
+	 * We hold the mmap_sem lock. So no need to call page_lock_anon_vma.
+	 */
+	anon_vma = (struct anon_vma *) (mapping - PAGE_MAPPING_ANON);
+	spin_lock(&anon_vma->lock);
+
+	list_for_each_entry(vma, &anon_vma->head, anon_vma_node)
+		if (v != vma && (vma->vm_flags & VM_LOCKED) &&
+				page_in_mlocked_vma(vma, page)) {
+					rc = 1;
+					break;
+				}
+	spin_unlock(&anon_vma->lock);
+	return rc;
+}
+
+/*
+ * Check for remaining vmas with VM_LOCKED set
+ */
+int mlock_check_vmas(struct page *page, struct vm_area_struct *vma)
+{
+	if (PageAnon(page))
+		return mlock_check_anon(page, vma);
+	else
+		return mlock_check_file(page, vma);
+}
 
 static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 	unsigned long start, unsigned long end, unsigned int newflags)
@@ -19,6 +197,7 @@ static int mlock_fixup(struct vm_area_st
 	pgoff_t pgoff;
 	int pages;
 	int ret = 0;
+	unsigned long addr;
 
 	if (newflags == vma->vm_flags) {
 		*prev = vma;
@@ -63,8 +242,39 @@ success:
 		pages = -pages;
 		if (!(newflags & VM_IO))
 			ret = make_pages_present(start, end);
+	} else {
+		/*
+		 * We are clearing VM_LOCKED. Insure that all PageMlocked
+		 * is reset on all pages where we need it.
+		 */
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
+			/*
+			 * No need to get a page reference. mmap_sem writelock
+			 * is held and the pages of interest are not on
+			 * the LRU
+			 */
+			struct page *page = follow_page(vma, start, 0);
+
+			if (page && PageMlocked(page))
+				mlock_remove(page, vma);
+			cond_resched();
+		}
 	}
 
+#if 0	/* We may need this to only mlock current pages */
+		/*
+		 * We are setting VM_LOCKED for current pages.
+		 * are changed to !PageMlocked if necessary.
+		 */
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
+			struct page *page = follow_page(vma, start, 0);
+
+			if (page && !PageMlocked(page))
+				mlock_add(page, vma);
+			cond_resched();
+		}
+#endif
+
 	mm->locked_vm -= pages;
 out:
 	if (ret == -ENOMEM)
Index: current/include/linux/rmap.h
===================================================================
--- current.orig/include/linux/rmap.h	2007-02-02 16:42:51.000000000 -0800
+++ current/include/linux/rmap.h	2007-02-02 16:43:28.000000000 -0800
@@ -128,6 +128,11 @@ static inline int page_mkclean(struct pa
 
 #endif	/* CONFIG_MMU */
 
+static inline int is_swap_pte(pte_t pte)
+{
+	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
+}
+
 /*
  * Return values of try_to_unmap
  */
Index: current/mm/migrate.c
===================================================================
--- current.orig/mm/migrate.c	2007-02-02 16:42:51.000000000 -0800
+++ current/mm/migrate.c	2007-02-02 16:43:28.000000000 -0800
@@ -115,11 +115,6 @@ int putback_lru_pages(struct list_head *
 	return count;
 }
 
-static inline int is_swap_pte(pte_t pte)
-{
-	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
-}
-
 /*
  * Restore a potential migration pte to a working pte entry
  */
Index: current/include/linux/mm.h
===================================================================
--- current.orig/include/linux/mm.h	2007-02-02 16:42:51.000000000 -0800
+++ current/include/linux/mm.h	2007-02-02 16:43:28.000000000 -0800
@@ -1178,6 +1178,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
+#define FOLL_MLOCK	0x10	/* If vma is VM_LOCK make page PageMlocked */
 
 #ifdef CONFIG_PROC_FS
 void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
Index: current/mm/vmscan.c
===================================================================
--- current.orig/mm/vmscan.c	2007-02-02 16:42:51.000000000 -0800
+++ current/mm/vmscan.c	2007-02-02 17:02:48.000000000 -0800
@@ -693,6 +693,16 @@ static unsigned long isolate_lru_pages(u
 			BUG();
 		}
 
+		if (PageMlocked(page)) {
+			/*
+			 * May happen due to pages being off the LRU while they
+			 * were mlocked. Take them off now.
+			 */
+			printk(KERN_INFO "Found mlocked page on LRU\n");
+			list_del(&page->lru);
+			put_page(page);
+			continue;
+		}
 		if (!order)
 			continue;
 
