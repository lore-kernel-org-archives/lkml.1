Return-Path: <linux-kernel-owner+w=401wt.eu-S1760381AbZBFRyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbZBFRyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZBFRya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:54:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZBFRy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:54:28 -0500
Date: Fri, 6 Feb 2009 18:54:14 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Izik Eidus <ieidus@redhat.com>, Hugh Dickins <hugh@veritas.com>
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090206175414.GQ14011@random.random>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com> <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090130061714.GC31209@kroah.com> <20090202220856.GY20323@random.random> <20090204234153.GA32244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204234153.GA32244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 03:41:53PM -0800, Greg KH wrote:
> On Mon, Feb 02, 2009 at 11:08:56PM +0100, Andrea Arcangeli wrote:
> > Hi Greg!
> > 
> > > Thanks for the pointers, I'll go read the thread and follow up there.
> > 
> > If you also run into this final fix is attached below. Porting to
> > mainline is a bit hard because of gup-fast... Perhaps we can use mmu
> > notifiers to fix gup-fast... need to think more about it then I'll
> > post something.
> > 
> > Please help testing the below on pre-gup-fast kernels, thanks!
> 
> What kernel version was this patch against?  I can't seem to apply it to
> anything close to mainline :(
> 
> I tried 2.6.29-rc3, 2.6.28-stable and 2.6.27-stable.

Ah patch is against 2.6.18, it's a "production" targeted patch as this
race is hitting production systems. So this is the final update
addressing hugetlb too. Kame was totally right hugetlb has the same
bug and I reproduced it trivially with:

LD_PRELOAD=/usr/lib64/libhugetlbfs.so HUGETLB_MORECORE=yes
HUGETLB_PATH=/mnt/huge/ ./dma_thread -a 512 -w 40
LD_PRELOAD=/usr/lib64/libhugetlbfs.so HUGETLB_MORECORE=yes
HUGETLB_PATH=/mnt/huge/ ./forkscrew 

I verfied hugetlb pages were allocated in grep Huge /proc/meminfo and
as well through printk in the hugetlb 'forcecow' path to be sure it
run and fixed the race. With new patch the bug goes away for both
largepages and regular anon pages.

I also exercised the -EAGAIN path and verfied it rollbacks and restart
on the prev pte just fine, it only happens during very heavy paging
activity.  I unlock/relock around the page-copy to be more lowlatency
schedule friendly and to move the page allocation out of the fork fast
path.

Here the latest patch. Now that I consider the 'production' trouble
closed I'll be porting it to mainline while addressing gup-fast too
which is an additional complication I didn't have to take care of
yet. So expect a patch that works for you in the next few days, either
that or complains about an unfixable gup-fast ;). But frankly I've
been thinking it should be possible in a much simpler way that I
ever thought before, by entirely relaying on the tlb flush.

In short if I simply do the page-count vs page-mapcount check _after_
ptep_set_wrprotect (which implies a tlb flush and after that any
gup-fast running in other cpus should be forced through the slow path
and block) I think I'm done. The code now does:

    check mapcount
    ptep_set_wrprotect

I think to make the thing working with gup-fast I've only to
ptep_set_wrprotect before the mapcount check.

The reason why the normal pagetable walking of the cpu is ok with
current code is that ptep_set_wrprotect done later will block any
access to the page from the other cpus. Not so if it was gup-fast
taking reference on the page. So we need to stop with
ptep_set_wrprotect any subsequential gup-fast _before_ we check count
vs mapcount and the fact the get_page is run inside the critical
section with local irq disabled in gup-fast should close the race for
gup-fast too. Will try that ASAP...

With Hugh I'm also reviewing the old 2.4 bug where a thread was doing
cow on swapcache while another thread was starting O_DIRECT, as I
recall to be 100% safe I wanted ptes pointing to pages under O_DIRECT
not to be unmapped by rmap, did that in 2.4 with a PG_pinned to tell
vmscan.c to bailout on the page. In 2.6 I wanted to do it with
mapcount but I think some alternate fix went in, so given I'm at it
I'll review the correctness of that too, just in case ;).

--------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: fork-o_direct-race

Think a thread writing constantly to the last 512bytes of a page, while another
thread read and writes to/from the first 512bytes of the page. We can lose
O_DIRECT reads (or any other get_user_pages write=1 I/O not just bio/O_DIRECT),
the very moment we mark any pte wrprotected because a third unrelated thread
forks off a child.

This fixes it by never wprotecting anon ptes if there can be any direct I/O in
flight to the page, and by instantiating a readonly pte and triggering a COW in
the child. The only trouble here are O_DIRECT reads (writes to memory, read
from disk). Checking the page_count under the PT lock guarantees no
get_user_pages could be running under us because if somebody wants to write to
the page, it has to break any cow first and that requires taking the PT lock in
follow_page before increasing the page count. We are guaranteed mapcount is 1 if
fork is writeprotecting the pte so the PT lock is enough to serialize against
get_user_pages->get_page.

The COW triggered inside fork will run while the parent pte is readonly to
provide as usual the per-page atomic copy from parent to child during fork.
However timings will be altered by having to copy the pages that might be under
O_DIRECT.

The pagevec code calls get_page while the page is sitting in the pagevec
(before it becomes PageLRU) and doing so it can generate false positives, so to
avoid slowing down fork all the time even for pages that could never possibly
be under O_DIRECT write=1, the PG_gup bitflag is added, this eliminates
most overhead of the fix in fork.

Patch doesn't break kABI despite introducing a new page flag.

Fixed version of original patch from Nick Piggin.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 63c8e4c..6105cad 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -86,6 +86,7 @@
 #define PG_reclaim		17	/* To be reclaimed asap */
 #define PG_nosave_free		18	/* Free, should not be written */
 #define PG_buddy		19	/* Page is free, on buddy lists */
+#define PG_gup			20	/* Page pin may be because of gup */
 #define PG_xpmem		27	/* Testing for xpmem. */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
@@ -239,6 +240,10 @@
 #define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
 
+#define SetPageGUP(page)	set_bit(PG_gup, &(page)->flags)
+#define PageGUP(page)		test_bit(PG_gup, &(page)->flags)
+#define __ClearPageGUP(page)	__clear_bit(PG_gup, &(page)->flags)
+
 /*
  * PG_reclaim is used in combination with PG_compound to mark the
  * head and tail of a compound page
diff --git a/kernel/fork.c b/kernel/fork.c
index f038aff..c29da4d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -384,7 +384,7 @@ static inline int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		rb_parent = &tmp->vm_rb;
 
 		mm->map_count++;
-		retval = copy_page_range(mm, oldmm, mpnt);
+		retval = copy_page_range(mm, oldmm, tmp);
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e80a916..f196ec8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -357,13 +357,17 @@ static void set_huge_ptep_writable(struct vm_area_struct *vma,
 }
 
 
+static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
+		       unsigned long address, pte_t *ptep, pte_t pte,
+		       int cannot_race);
+
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
 {
-	pte_t *src_pte, *dst_pte, entry;
+	pte_t *src_pte, *dst_pte, entry, orig_entry;
 	struct page *ptepage;
 	unsigned long addr;
-	int cow;
+	int cow, forcecow, oom;
 
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
@@ -377,18 +381,46 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 		/* if the page table is shared dont copy or take references */
 		if (dst_pte == src_pte)
 			continue;
+		oom = 0;
 		spin_lock(&dst->page_table_lock);
 		spin_lock(&src->page_table_lock);
-		if (!huge_pte_none(huge_ptep_get(src_pte))) {
-			if (cow)
-				huge_ptep_set_wrprotect(src, addr, src_pte);
-			entry = huge_ptep_get(src_pte);
+		orig_entry = entry = huge_ptep_get(src_pte);
+		if (!huge_pte_none(entry)) {
+			forcecow = 0;
 			ptepage = pte_page(entry);
 			get_page(ptepage);
+			if (cow && pte_write(entry)) {
+				if (PageGUP(ptepage))
+					forcecow = 1;
+				huge_ptep_set_wrprotect(src, addr,
+							src_pte);
+				entry = huge_ptep_get(src_pte);
+			}
 			set_huge_pte_at(dst, addr, dst_pte, entry);
+			if (forcecow) {
+				int cow_ret;
+				/*
+				 * We hold mmap_sem in write mode and
+				 * the VM doesn't know about hugepages
+				 * so the src_pte/dst_pte can't change
+				 * from under us even if hugetlb_cow
+				 * will release the lock.
+				 */
+				cow_ret = hugetlb_cow(dst, vma, addr,
+						      dst_pte, entry, 1);
+				BUG_ON(!pte_same(huge_ptep_get(src_pte),
+						 entry));
+				set_huge_pte_at(src, addr,
+						src_pte,
+						orig_entry);
+				if (cow_ret != VM_FAULT_MINOR)
+					oom = 1;
+			}
 		}
 		spin_unlock(&src->page_table_lock);
 		spin_unlock(&dst->page_table_lock);
+		if (oom)
+			goto nomem;
 	}
 	return 0;
 
@@ -448,7 +480,8 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 }
 
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long address, pte_t *ptep, pte_t pte)
+		       unsigned long address, pte_t *ptep, pte_t pte,
+		       int cannot_race)
 {
 	struct page *old_page, *new_page;
 	int avoidcopy;
@@ -483,7 +516,8 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 				make_huge_pte(vma, new_page, 1));
 		/* Make the old page be freed below */
 		new_page = old_page;
-	}
+	} else
+		BUG_ON(cannot_race);
 	page_cache_release(new_page);
 	page_cache_release(old_page);
 	return VM_FAULT_MINOR;
@@ -553,7 +587,7 @@ retry:
 
 	if (write_access && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_cow(mm, vma, address, ptep, new_pte);
+		ret = hugetlb_cow(mm, vma, address, ptep, new_pte, 0);
 	}
 
 	spin_unlock(&mm->page_table_lock);
@@ -600,7 +634,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	/* Check for a racing update before calling hugetlb_cow */
 	if (likely(pte_same(entry, huge_ptep_get(ptep))))
 		if (write_access && !pte_write(entry))
-			ret = hugetlb_cow(mm, vma, address, ptep, entry);
+			ret = hugetlb_cow(mm, vma, address, ptep, entry, 0);
 	spin_unlock(&mm->page_table_lock);
 	mutex_unlock(&hugetlb_instantiation_mutex);
 
@@ -649,6 +683,8 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 same_page:
 		if (pages) {
 			get_page(page);
+			if (write && !PageGUP(page))
+				SetPageGUP(page);
 			pages[i] = page + pfn_offset;
 		}
 
diff --git a/mm/memory.c b/mm/memory.c
index 12c2d9f..c85c854 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -426,7 +426,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr, pte_
  * covered by this vma.
  */
 
-static inline void
+static inline int
 copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *vma,
 		unsigned long addr, int *rss)
@@ -434,6 +434,7 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	unsigned long vm_flags = vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
+	int forcecow = 0;
 
 	/* pte contains position in swap or file, so copy. */
 	if (unlikely(!pte_present(pte))) {
@@ -464,15 +465,6 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	}
 
 	/*
-	 * If it's a COW mapping, write protect it both
-	 * in the parent and the child
-	 */
-	if (is_cow_mapping(vm_flags)) {
-		ptep_set_wrprotect(src_mm, addr, src_pte);
-		pte = *src_pte;
-	}
-
-	/*
 	 * If it's a shared mapping, mark it clean in
 	 * the child
 	 */
@@ -484,13 +476,44 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (page) {
 		get_page(page);
 		page_dup_rmap(page);
+		if (is_cow_mapping(vm_flags) && pte_write(pte) &&
+		    PageAnon(page) && PageGUP(page)) {
+			if (unlikely(TestSetPageLocked(page)))
+				forcecow = 1;
+			else {
+				BUG_ON(page_mapcount(page) != 2);
+				if (unlikely(page_count(page) !=
+					     page_mapcount(page)
+					     + !!PageSwapCache(page)))
+					forcecow = 1;
+				unlock_page(page);
+			}
+		}
 		rss[!!PageAnon(page)]++;
 	}
 
+	/*
+	 * If it's a COW mapping, write protect it both
+	 * in the parent and the child.
+	 */
+	if (is_cow_mapping(vm_flags)) {
+		if (pte_write(pte)) {
+			ptep_set_wrprotect(src_mm, addr, src_pte);
+			pte = pte_wrprotect(pte);
+		}
+	}
+
 out_set_pte:
 	set_pte_at(dst_mm, addr, dst_pte, pte);
+
+	return forcecow;
 }
 
+static int fork_pre_cow(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address,
+			pte_t *src_pte, pte_t *dst_pte,
+			spinlock_t *src_ptl, spinlock_t *dst_ptl);
+
 static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end)
@@ -499,8 +522,10 @@ static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	spinlock_t *src_ptl, *dst_ptl;
 	int progress = 0;
 	int rss[2];
+	int forcecow;
 
 again:
+	forcecow = 0;
 	rss[1] = rss[0] = 0;
 	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
 	if (!dst_pte)
@@ -510,6 +535,9 @@ again:
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	do {
+		if (forcecow)
+			break;
+
 		/*
 		 * We are holding two locks at this point - either of them
 		 * could generate latencies in another task on another CPU.
@@ -525,15 +553,38 @@ again:
 			progress++;
 			continue;
 		}
-		copy_one_pte(dst_mm, src_mm, dst_pte, src_pte, vma, addr, rss);
+		forcecow = copy_one_pte(dst_mm, src_mm, dst_pte, src_pte, vma, addr, rss);
 		progress += 8;
 	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr != end);
 
+	if (unlikely(forcecow)) {
+		/*
+		 * Try to COW the child page as direct I/O is working
+		 * on the parent page, and so we've to mark the parent
+		 * pte read-write before dropping the PT lock to avoid
+		 * the page to be cowed in the parent and any direct
+		 * I/O to get lost.
+		 */
+		forcecow = fork_pre_cow(dst_mm, vma, addr-PAGE_SIZE,
+					src_pte-1, dst_pte-1,
+					src_ptl, dst_ptl);
+		/* after the page copy set the parent pte writeable again */
+		set_pte_at(src_mm, addr-PAGE_SIZE, src_pte-1,
+			   pte_mkwrite(*(src_pte-1)));
+		if (unlikely(forcecow == -EAGAIN)) {
+			dst_pte--;
+			src_pte--;
+			addr -= PAGE_SIZE;
+		}
+	}
+
 	spin_unlock(src_ptl);
 	pte_unmap_nested(src_pte - 1);
 	add_mm_rss(dst_mm, rss[0], rss[1]);
 	pte_unmap_unlock(dst_pte - 1, dst_ptl);
 	cond_resched();
+	if (unlikely(forcecow == -ENOMEM))
+		return -ENOMEM;
 	if (addr != end)
 		goto again;
 	return 0;
@@ -957,8 +1008,11 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 	if (unlikely(!page))
 		goto bad_page;
 
-	if (flags & FOLL_GET)
+	if (flags & FOLL_GET) {
 		get_page(page);
+		if (PageAnon(page) && !PageGUP(page))
+			SetPageGUP(page);
+	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
@@ -1638,6 +1692,66 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
 	copy_user_highpage(dst, src, va);
 }
 
+static int fork_pre_cow(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address,
+			pte_t *src_pte, pte_t *dst_pte,
+			spinlock_t *src_ptl, spinlock_t *dst_ptl)
+{
+	pte_t _src_pte, _dst_pte;
+	struct page *old_page, *new_page;
+
+	_src_pte = *src_pte;
+	_dst_pte = *dst_pte;
+	old_page = vm_normal_page(vma, address, *src_pte);
+	BUG_ON(!old_page);
+	get_page(old_page);
+	spin_unlock(src_ptl);
+	spin_unlock(dst_ptl);
+
+	new_page = alloc_page_vma(GFP_HIGHUSER, vma, address);
+	if (!new_page)
+		return -ENOMEM;
+	cow_user_page(new_page, old_page, address);
+
+	spin_lock(dst_ptl);
+	spin_lock(src_ptl);
+
+	/*
+	 * src pte can unmapped by the VM from under us after dropping
+	 * the src_ptl but it can't be cowed from under us as fork
+	 * holds the mmap_sem in write mode.
+	 */
+	if (!pte_same(*src_pte, _src_pte))
+		goto eagain;
+	if (!pte_same(*dst_pte, _dst_pte))
+		goto eagain;
+
+	page_remove_rmap(old_page);
+	page_cache_release(old_page);
+	page_cache_release(old_page);
+
+	flush_cache_page(vma, address, pte_pfn(*src_pte));
+	_dst_pte = mk_pte(new_page, vma->vm_page_prot);
+	_dst_pte = maybe_mkwrite(pte_mkdirty(_dst_pte), vma);
+	page_add_new_anon_rmap(new_page, vma, address);
+	lru_cache_add_active(new_page);
+	set_pte_at(mm, address, dst_pte, _dst_pte);
+	update_mmu_cache(vma, address, _dst_pte);
+	lazy_mmu_prot_update(_dst_pte);
+	return 0;
+
+eagain:
+	page_cache_release(old_page);
+	page_cache_release(new_page);
+	/*
+	 * Later we'll repeat the copy of this pte, so here we've to
+	 * undo the mapcount and page count taken in copy_one_pte.
+	 */
+	page_remove_rmap(old_page);
+	page_cache_release(old_page);
+	return -EAGAIN;
+}
+
 /*
  * This routine handles present pages, when users try to write
  * to a shared page. It is done by copying the page to a new address
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3eed821..5bd4b7f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -154,6 +154,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_gup |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -400,6 +401,8 @@ static inline int free_pages_check(struct page *page)
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageGUP(page))
+		__ClearPageGUP(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -546,6 +549,7 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_gup |
 			1 << PG_buddy ))))
 		bad_page(page);
 

