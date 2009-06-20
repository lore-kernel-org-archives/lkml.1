Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbZFTDXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbZFTDXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 23:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZFTDUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 23:20:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:21837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbZFTDUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 23:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,257,1243839600"; 
   d="scan'208";a="156644174"
Message-Id: <20090620031625.714076917@intel.com>
References: <20090620031608.624240019@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 20 Jun 2009 11:16:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lee.Schermerhorn@hp.com,
       npiggin@suse.de, Andi Kleen <ak@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan.kim@gmail.com>
cc: Mel Gorman <mel@csn.ul.ie>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 08/15] HWPOISON: Use bitmask/action code for try_to_unmap behaviour
Content-Disposition: inline; filename=try-to-unmap-flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

try_to_unmap currently has multiple modi (migration, munlock, normal unmap)
which are selected by magic flag variables. The logic is not very straight
forward, because each of these flag change multiple behaviours (e.g.
migration turns off aging, not only sets up migration ptes etc.)
Also the different flags interact in magic ways.

A later patch in this series adds another mode to try_to_unmap, so
this becomes quickly unmanageable.

Replace the different flags with a action code (migration, munlock, munmap)
and some additional flags as modifiers (ignore mlock, ignore aging).
This makes the logic more straight forward and allows easier extension
to new behaviours. Change all the caller to declare what they want to
do.

This patch is supposed to be a nop in behaviour. If anyone can prove
it is not that would be a bug.

Cc: Lee.Schermerhorn@hp.com
Cc: npiggin@suse.de
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/rmap.h |   14 +++++++++++++-
 mm/migrate.c         |    2 +-
 mm/rmap.c            |   40 ++++++++++++++++++++++------------------
 mm/vmscan.c          |    2 +-
 4 files changed, 37 insertions(+), 21 deletions(-)

--- sound-2.6.orig/include/linux/rmap.h
+++ sound-2.6/include/linux/rmap.h
@@ -85,7 +85,19 @@ static inline void page_dup_rmap(struct 
  */
 int page_referenced(struct page *, int is_locked,
 			struct mem_cgroup *cnt, unsigned long *vm_flags);
-int try_to_unmap(struct page *, int ignore_refs);
+
+enum ttu_flags {
+	TTU_UNMAP = 0,			/* unmap mode */
+	TTU_MIGRATION = 1,		/* migration mode */
+	TTU_MUNLOCK = 2,		/* munlock mode */
+	TTU_ACTION_MASK = 0xff,
+
+	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
+	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
+};
+#define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
+
+int try_to_unmap(struct page *, enum ttu_flags flags);
 
 /*
  * Called from mm/filemap_xip.c to unmap empty zero page
--- sound-2.6.orig/mm/rmap.c
+++ sound-2.6/mm/rmap.c
@@ -912,7 +912,7 @@ void page_remove_rmap(struct page *page)
  * repeatedly from either try_to_unmap_anon or try_to_unmap_file.
  */
 static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
-				int migration)
+				enum ttu_flags flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -934,11 +934,13 @@ static int try_to_unmap_one(struct page 
 	 * If it's recently referenced (perhaps page_referenced
 	 * skipped over this mm) then we should reactivate it.
 	 */
-	if (!migration) {
+	if (!(flags & TTU_IGNORE_MLOCK)) {
 		if (vma->vm_flags & VM_LOCKED) {
 			ret = SWAP_MLOCK;
 			goto out_unmap;
 		}
+	}
+	if (!(flags & TTU_IGNORE_ACCESS)) {
 		if (ptep_clear_flush_young_notify(vma, address, pte)) {
 			ret = SWAP_FAIL;
 			goto out_unmap;
@@ -978,12 +980,12 @@ static int try_to_unmap_one(struct page 
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			BUG_ON(!migration);
+			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATION);
 			entry = make_migration_entry(page, pte_write(pteval));
 		}
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 		BUG_ON(pte_file(*pte));
-	} else if (PAGE_MIGRATION && migration) {
+	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
@@ -1152,12 +1154,13 @@ static int try_to_mlock_page(struct page
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * 'LOCKED.
  */
-static int try_to_unmap_anon(struct page *page, int unlock, int migration)
+static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 {
 	struct anon_vma *anon_vma;
 	struct vm_area_struct *vma;
 	unsigned int mlocked = 0;
 	int ret = SWAP_AGAIN;
+	int unlock = TTU_ACTION(flags) == TTU_MUNLOCK;
 
 	if (MLOCK_PAGES && unlikely(unlock))
 		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
@@ -1173,7 +1176,7 @@ static int try_to_unmap_anon(struct page
 				continue;  /* must visit all unlocked vmas */
 			ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
 		} else {
-			ret = try_to_unmap_one(page, vma, migration);
+			ret = try_to_unmap_one(page, vma, flags);
 			if (ret == SWAP_FAIL || !page_mapped(page))
 				break;
 		}
@@ -1197,8 +1200,7 @@ static int try_to_unmap_anon(struct page
 /**
  * try_to_unmap_file - unmap/unlock file page using the object-based rmap method
  * @page: the page to unmap/unlock
- * @unlock:  request for unlock rather than unmap [unlikely]
- * @migration:  unmapping for migration - ignored if @unlock
+ * @flags: action and flags
  *
  * Find all the mappings of a page using the mapping pointer and the vma chains
  * contained in the address_space struct it points to.
@@ -1210,7 +1212,7 @@ static int try_to_unmap_anon(struct page
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * 'LOCKED.
  */
-static int try_to_unmap_file(struct page *page, int unlock, int migration)
+static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
 {
 	struct address_space *mapping = page->mapping;
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
@@ -1222,6 +1224,7 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 	unsigned int mlocked = 0;
+	int unlock = TTU_ACTION(flags) == TTU_MUNLOCK;
 
 	if (MLOCK_PAGES && unlikely(unlock))
 		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
@@ -1234,7 +1237,7 @@ static int try_to_unmap_file(struct page
 				continue;	/* must visit all vmas */
 			ret = SWAP_MLOCK;
 		} else {
-			ret = try_to_unmap_one(page, vma, migration);
+			ret = try_to_unmap_one(page, vma, flags);
 			if (ret == SWAP_FAIL || !page_mapped(page))
 				goto out;
 		}
@@ -1259,7 +1262,8 @@ static int try_to_unmap_file(struct page
 			ret = SWAP_MLOCK;	/* leave mlocked == 0 */
 			goto out;		/* no need to look further */
 		}
-		if (!MLOCK_PAGES && !migration && (vma->vm_flags & VM_LOCKED))
+		if (!MLOCK_PAGES && !(flags & TTU_IGNORE_MLOCK) &&
+			(vma->vm_flags & VM_LOCKED))
 			continue;
 		cursor = (unsigned long) vma->vm_private_data;
 		if (cursor > max_nl_cursor)
@@ -1293,7 +1297,7 @@ static int try_to_unmap_file(struct page
 	do {
 		list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
 						shared.vm_set.list) {
-			if (!MLOCK_PAGES && !migration &&
+			if (!MLOCK_PAGES && !(flags & TTU_IGNORE_MLOCK) &&
 			    (vma->vm_flags & VM_LOCKED))
 				continue;
 			cursor = (unsigned long) vma->vm_private_data;
@@ -1333,7 +1337,7 @@ out:
 /**
  * try_to_unmap - try to remove all page table mappings to a page
  * @page: the page to get unmapped
- * @migration: migration flag
+ * @flags: action and flags
  *
  * Tries to remove all the page table entries which are mapping this
  * page, used in the pageout path.  Caller must hold the page lock.
@@ -1344,16 +1348,16 @@ out:
  * SWAP_FAIL	- the page is unswappable
  * SWAP_MLOCK	- page is mlocked.
  */
-int try_to_unmap(struct page *page, int migration)
+int try_to_unmap(struct page *page, enum ttu_flags flags)
 {
 	int ret;
 
 	BUG_ON(!PageLocked(page));
 
 	if (PageAnon(page))
-		ret = try_to_unmap_anon(page, 0, migration);
+		ret = try_to_unmap_anon(page, flags);
 	else
-		ret = try_to_unmap_file(page, 0, migration);
+		ret = try_to_unmap_file(page, flags);
 	if (ret != SWAP_MLOCK && !page_mapped(page))
 		ret = SWAP_SUCCESS;
 	return ret;
@@ -1378,8 +1382,8 @@ int try_to_munlock(struct page *page)
 	VM_BUG_ON(!PageLocked(page) || PageLRU(page));
 
 	if (PageAnon(page))
-		return try_to_unmap_anon(page, 1, 0);
+		return try_to_unmap_anon(page, TTU_MUNLOCK);
 	else
-		return try_to_unmap_file(page, 1, 0);
+		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
 
--- sound-2.6.orig/mm/vmscan.c
+++ sound-2.6/mm/vmscan.c
@@ -661,7 +661,7 @@ static unsigned long shrink_page_list(st
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page) && mapping) {
-			switch (try_to_unmap(page, 0)) {
+			switch (try_to_unmap(page, TTU_UNMAP)) {
 			case SWAP_FAIL:
 				goto activate_locked;
 			case SWAP_AGAIN:
--- sound-2.6.orig/mm/migrate.c
+++ sound-2.6/mm/migrate.c
@@ -669,7 +669,7 @@ static int unmap_and_move(new_page_t get
 	}
 
 	/* Establish migration ptes or remove ptes */
-	try_to_unmap(page, 1);
+	try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 
 	if (!page_mapped(page))
 		rc = move_to_new_page(newpage, page);

-- 

