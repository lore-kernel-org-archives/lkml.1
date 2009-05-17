Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbZEQCJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbZEQCJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 22:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZEQCIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 22:08:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:50088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZEQCIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 22:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,206,1241420400"; 
   d="scan'208";a="143636680"
Date: Sun, 17 May 2009 10:08:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090517020829.GB6809@localhost>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com> <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com> <alpine.DEB.1.10.0905151533070.13433@qirst.com> <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com> <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost> <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 17, 2009 at 09:27:03AM +0800, Satish Eerpini wrote:
> > Yes, better to apply Rik and mine patches together to get the best
> > cache behavior. Rik's patch is crucial. They are both small patches,
> > so can be backported trivially. Satish, what's your kernel version
> > (or, do you want to try a newer kernel)? And the content of
> > /proc/meminfo?
> 
> I am running 2.6.29.1 right now , just tell me which kernel to try, or
> to which kernel I have to apply the patches and try them, I will test
> the patches and let you know if the situation improves.
> and the contents of /proc/meminfo are :

Satish, so you have 2.5GB memory and 80MB mapped pages, 33MB active
desktop files to protect. 

I've prepared a rolled up patch for you, run time tested.  It should
protect all of the above pages from being evicted by large file copies.

The attached patch is for 2.6.29.

Thanks,
Fengguang

> MemTotal:        2585724 kB
> MemFree:          900524 kB
> Buffers:          197504 kB
> Cached:          1080332 kB
> SwapCached:            0 kB
> Active:           639544 kB
> Inactive:         933068 kB
> Active(anon):     307100 kB
> Inactive(anon):        0 kB
> Active(file):     332444 kB
> Inactive(file):   933068 kB
> Unevictable:          16 kB
> Mlocked:              16 kB
> HighTotal:       1707848 kB
> HighFree:         321868 kB
> LowTotal:         877876 kB
> LowFree:          578656 kB
> SwapTotal:       3526256 kB
> SwapFree:        3526256 kB
> Dirty:              1000 kB
> Writeback:             0 kB
> AnonPages:        294788 kB
> Mapped:            80084 kB
> Slab:              89692 kB
> SReclaimable:      71436 kB
> SUnreclaim:        18256 kB
> PageTables:         6008 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     4819116 kB
> Committed_AS:     796332 kB
> VmallocTotal:     122880 kB
> VmallocUsed:        8240 kB
> VmallocChunk:      96952 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       4096 kB
> DirectMap4k:       20472 kB
> DirectMap4M:      884736 kB
> 
> Cheers
> Satish
> -- 
> http://satish.playdrupal.com

--IS0zKkzwUGydFO0o
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="vmscan-working-set-protections.patch"

--- linux.orig/mm/vmscan.c
+++ linux/mm/vmscan.c
@@ -581,6 +581,7 @@ static unsigned long shrink_page_list(st
 	struct pagevec freed_pvec;
 	int pgactivate = 0;
 	unsigned long nr_reclaimed = 0;
+	unsigned long vm_flags;
 
 	cond_resched();
 
@@ -631,7 +632,8 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 		}
 
-		referenced = page_referenced(page, 1, sc->mem_cgroup);
+		referenced = page_referenced(page, 1,
+						sc->mem_cgroup, &vm_flags);
 		/* In active use or really unfreeable?  Activate it. */
 		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
 					referenced && page_mapping_inuse(page))
@@ -1210,9 +1212,10 @@ static void shrink_active_list(unsigned 
 			struct scan_control *sc, int priority, int file)
 {
 	unsigned long pgmoved;
-	int pgdeactivate = 0;
 	unsigned long pgscanned;
+	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
+	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct pagevec pvec;
@@ -1239,7 +1242,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
-	pgmoved = 0;
+	pgmoved = 0;  /* count referenced (mapping) mapped pages */
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
@@ -1252,28 +1255,41 @@ static void shrink_active_list(unsigned 
 
 		/* page_referenced clears PageReferenced */
 		if (page_mapping_inuse(page) &&
-		    page_referenced(page, 0, sc->mem_cgroup))
+		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			pgmoved++;
+			/*
+			 * Identify referenced, file-backed active pages and
+			 * give them one more trip around the active list. So
+			 * that executable code get better chances to stay in
+			 * memory under moderate memory pressure.  Anon pages
+			 * are ignored, since JVM can create lots of anon
+			 * VM_EXEC pages.
+			 */
+			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
+				list_add(&page->lru, &l_active);
+				continue;
+			}
+		}
 
 		list_add(&page->lru, &l_inactive);
 	}
 
 	/*
-	 * Move the pages to the [file or anon] inactive list.
+	 * Move pages back to the lru list.
 	 */
 	pagevec_init(&pvec, 1);
-	lru = LRU_BASE + file * LRU_FILE;
 
 	spin_lock_irq(&zone->lru_lock);
 	/*
-	 * Count referenced pages from currently used mappings as
-	 * rotated, even though they are moved to the inactive list.
-	 * This helps balance scan pressure between file and anonymous
-	 * pages in get_scan_ratio.
+	 * Count referenced pages from currently used mappings as rotated,
+	 * even though only some of them are actually re-activated.  This
+	 * helps balance scan pressure between file and anonymous pages in
+	 * get_scan_ratio.
 	 */
 	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
-	pgmoved = 0;
+	pgmoved = 0;  /* count pages moved to inactive list */
+	lru = LRU_BASE + file * LRU_FILE;
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
 		prefetchw_prev_lru_page(page, &l_inactive, flags);
@@ -1286,10 +1302,7 @@ static void shrink_active_list(unsigned 
 		mem_cgroup_add_lru_list(page, lru);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
-			__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 			spin_unlock_irq(&zone->lru_lock);
-			pgdeactivate += pgmoved;
-			pgmoved = 0;
 			if (buffer_heads_over_limit)
 				pagevec_strip(&pvec);
 			__pagevec_release(&pvec);
@@ -1297,14 +1310,31 @@ static void shrink_active_list(unsigned 
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	pgdeactivate += pgmoved;
-	if (buffer_heads_over_limit) {
-		spin_unlock_irq(&zone->lru_lock);
-		pagevec_strip(&pvec);
-		spin_lock_irq(&zone->lru_lock);
-	}
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
-	__count_vm_events(PGDEACTIVATE, pgdeactivate);
+	__count_vm_events(PGDEACTIVATE, pgmoved);
+
+	pgmoved = 0;  /* count pages moved back to active list */
+	lru = LRU_ACTIVE + file * LRU_FILE;
+	while (!list_empty(&l_active)) {
+		page = lru_to_page(&l_active);
+		prefetchw_prev_lru_page(page, &l_active, flags);
+		VM_BUG_ON(PageLRU(page));
+		SetPageLRU(page);
+		VM_BUG_ON(!PageActive(page));
+
+		list_move(&page->lru, &zone->lru[lru].list);
+		mem_cgroup_add_lru_list(page, lru);
+		pgmoved++;
+		if (!pagevec_add(&pvec, page)) {
+			spin_unlock_irq(&zone->lru_lock);
+			if (buffer_heads_over_limit)
+				pagevec_strip(&pvec);
+			__pagevec_release(&pvec);
+			spin_lock_irq(&zone->lru_lock);
+		}
+	}
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+
 	spin_unlock_irq(&zone->lru_lock);
 	if (vm_swap_full())
 		pagevec_swap_free(&pvec);
@@ -1344,12 +1374,48 @@ static int inactive_anon_is_low(struct z
 	return low;
 }
 
+static int inactive_file_is_low_global(struct zone *zone)
+{
+	unsigned long active, inactive;
+
+	active = zone_page_state(zone, NR_ACTIVE_FILE);
+	inactive = zone_page_state(zone, NR_INACTIVE_FILE);
+
+	return (active > inactive);
+}
+
+/**
+ * inactive_file_is_low - check if file pages need to be deactivated
+ * @zone: zone to check
+ * @sc:   scan control of this context
+ *
+ * When the system is doing streaming IO, memory pressure here
+ * ensures that active file pages get deactivated, until more
+ * than half of the file pages are on the inactive list.
+ *
+ * Once we get to that situation, protect the system's working
+ * set from being evicted by disabling active file page aging.
+ *
+ * This uses a different ratio than the anonymous pages, because
+ * the page cache uses a use-once replacement algorithm.
+ */
+static int inactive_file_is_low(struct zone *zone, struct scan_control *sc)
+{
+	int low;
+
+	if (scanning_global_lru(sc))
+		low = inactive_file_is_low_global(zone);
+	else
+		low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup);
+	return low;
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_FILE) {
+	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
--- linux.orig/include/linux/memcontrol.h
+++ linux/include/linux/memcontrol.h
@@ -97,6 +97,7 @@ extern void mem_cgroup_note_reclaim_prio
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
+int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
@@ -250,6 +251,12 @@ mem_cgroup_inactive_anon_is_low(struct m
 	return 1;
 }
 
+static inline int
+mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
+{
+	return 1;
+}
+
 static inline unsigned long
 mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg, struct zone *zone,
 			 enum lru_list lru)
--- linux.orig/mm/memcontrol.c
+++ linux/mm/memcontrol.c
@@ -536,6 +536,17 @@ int mem_cgroup_inactive_anon_is_low(stru
 	return 0;
 }
 
+int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
+{
+	unsigned long active;
+	unsigned long inactive;
+
+	inactive = mem_cgroup_get_local_zonestat(memcg, LRU_INACTIVE_FILE);
+	active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_FILE);
+
+	return (active > inactive);
+}
+
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru)
--- linux.orig/include/linux/rmap.h
+++ linux/include/linux/rmap.h
@@ -83,7 +83,8 @@ static inline void page_dup_rmap(struct 
 /*
  * Called from mm/vmscan.c to handle paging out
  */
-int page_referenced(struct page *, int is_locked, struct mem_cgroup *cnt);
+int page_referenced(struct page *, int is_locked,
+			struct mem_cgroup *cnt, unsigned long *vm_flags);
 int try_to_unmap(struct page *, int ignore_refs);
 
 /*
@@ -124,7 +125,7 @@ static inline int try_to_munlock(struct 
 #define anon_vma_prepare(vma)	(0)
 #define anon_vma_link(vma)	do {} while (0)
 
-#define page_referenced(page,l,cnt) TestClearPageReferenced(page)
+#define page_referenced(page, locked, cnt, flags) TestClearPageReferenced(page)
 #define try_to_unmap(page, refs) SWAP_FAIL
 
 static inline int page_mkclean(struct page *page)
--- linux.orig/mm/rmap.c
+++ linux/mm/rmap.c
@@ -333,7 +333,9 @@ static int page_mapped_in_vma(struct pag
  * repeatedly from either page_referenced_anon or page_referenced_file.
  */
 static int page_referenced_one(struct page *page,
-	struct vm_area_struct *vma, unsigned int *mapcount)
+			       struct vm_area_struct *vma,
+			       unsigned int *mapcount,
+			       unsigned long *vm_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -381,11 +383,14 @@ out_unmap:
 	(*mapcount)--;
 	pte_unmap_unlock(pte, ptl);
 out:
+	if (referenced)
+		*vm_flags |= vma->vm_flags;
 	return referenced;
 }
 
 static int page_referenced_anon(struct page *page,
-				struct mem_cgroup *mem_cont)
+				struct mem_cgroup *mem_cont,
+				unsigned long *vm_flags)
 {
 	unsigned int mapcount;
 	struct anon_vma *anon_vma;
@@ -405,7 +410,8 @@ static int page_referenced_anon(struct p
 		 */
 		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
-		referenced += page_referenced_one(page, vma, &mapcount);
+		referenced += page_referenced_one(page, vma,
+						  &mapcount, vm_flags);
 		if (!mapcount)
 			break;
 	}
@@ -418,6 +424,7 @@ static int page_referenced_anon(struct p
  * page_referenced_file - referenced check for object-based rmap
  * @page: the page we're checking references on.
  * @mem_cont: target memory controller
+ * @vm_flags: collect encountered vma->vm_flags
  *
  * For an object-based mapped page, find all the places it is mapped and
  * check/clear the referenced flag.  This is done by following the page->mapping
@@ -427,7 +434,8 @@ static int page_referenced_anon(struct p
  * This function is only called from page_referenced for object-based pages.
  */
 static int page_referenced_file(struct page *page,
-				struct mem_cgroup *mem_cont)
+				struct mem_cgroup *mem_cont,
+				unsigned long *vm_flags)
 {
 	unsigned int mapcount;
 	struct address_space *mapping = page->mapping;
@@ -467,7 +475,8 @@ static int page_referenced_file(struct p
 		 */
 		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
-		referenced += page_referenced_one(page, vma, &mapcount);
+		referenced += page_referenced_one(page, vma,
+						  &mapcount, vm_flags);
 		if (!mapcount)
 			break;
 	}
@@ -481,29 +490,35 @@ static int page_referenced_file(struct p
  * @page: the page to test
  * @is_locked: caller holds lock on the page
  * @mem_cont: target memory controller
+ * @vm_flags: collect encountered vma->vm_flags
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
  */
-int page_referenced(struct page *page, int is_locked,
-			struct mem_cgroup *mem_cont)
+int page_referenced(struct page *page,
+		    int is_locked,
+		    struct mem_cgroup *mem_cont,
+		    unsigned long *vm_flags)
 {
 	int referenced = 0;
 
 	if (TestClearPageReferenced(page))
 		referenced++;
 
+	*vm_flags = 0;
 	if (page_mapped(page) && page->mapping) {
 		if (PageAnon(page))
-			referenced += page_referenced_anon(page, mem_cont);
+			referenced += page_referenced_anon(page, mem_cont,
+								vm_flags);
 		else if (is_locked)
-			referenced += page_referenced_file(page, mem_cont);
+			referenced += page_referenced_file(page, mem_cont,
+								vm_flags);
 		else if (!trylock_page(page))
 			referenced++;
 		else {
 			if (page->mapping)
-				referenced +=
-					page_referenced_file(page, mem_cont);
+				referenced += page_referenced_file(page,
+							mem_cont, vm_flags);
 			unlock_page(page);
 		}
 	}

--IS0zKkzwUGydFO0o--
