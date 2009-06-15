Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZFODRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZFODRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZFODPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:15:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:4375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZFODOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154267340"
Message-Id: <20090615031254.434000201@intel.com>
References: <20090615024520.786814520@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 10:45:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>
cc: Mel Gorman <mel@csn.ul.ie>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 15/22] HWPOISON: early kill cleanups and fixes
Content-Disposition: inline; filename=hwpoison-check-address.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- check for page_mapped_in_vma() on anon pages
- test and use page->mapping instead of page_mapping()
- cleanup some comments

If no objections, this patch will be folded into the big high-level patch.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/rmap.h |    1 +
 mm/memory-failure.c  |   20 +++++++++++---------
 mm/rmap.c            |    2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

--- sound-2.6.orig/mm/memory-failure.c
+++ sound-2.6/mm/memory-failure.c
@@ -122,8 +122,6 @@ struct to_kill {
 
 /*
  * Schedule a process for later kill.
- * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
- * TBD would GFP_NOIO be enough?
  */
 static void add_to_kill(struct task_struct *tsk, struct page *p,
 			struct vm_area_struct *vma,
@@ -227,6 +225,9 @@ static void collect_procs_anon(struct pa
 		if (!tsk->mm)
 			continue;
 		list_for_each_entry (vma, &av->head, anon_vma_node) {
+			if (!page_mapped_in_vma(page, vma))
+				continue;
+
 			if (vma->vm_mm == tsk->mm)
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
@@ -245,7 +246,7 @@ static void collect_procs_file(struct pa
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct prio_tree_iter iter;
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping = page->mapping;
 
 	/*
 	 * A note on the locking order between the two locks.
@@ -275,16 +276,17 @@ static void collect_procs_file(struct pa
 
 /*
  * Collect the processes who have the corrupted page mapped to kill.
- * This is done in two steps for locking reasons.
- * First preallocate one tokill structure outside the spin locks,
- * so that we can kill at least one process reasonably reliable.
  */
 static void collect_procs(struct page *page, struct list_head *tokill)
 {
 	struct to_kill *tk;
 
-	tk = kmalloc(sizeof(struct to_kill), GFP_KERNEL);
-	/* memory allocation failure is implicitly handled */
+	/*
+	 * First preallocate one to_kill structure outside the spin locks,
+	 * so that we can kill at least one process reasonably reliable.
+	 */
+	tk = kmalloc(sizeof(struct to_kill), GFP_NOIO);
+
 	if (PageAnon(page))
 		collect_procs_anon(page, tokill, &tk);
 	else
@@ -657,7 +659,7 @@ static void hwpoison_user_mappings(struc
 	 * Error handling: We ignore errors here because
 	 * there's nothing that can be done.
 	 */
-	if (kill)
+	if (kill && p->mapping)
 		collect_procs(p, &tokill);
 
 	/*
--- sound-2.6.orig/include/linux/rmap.h
+++ sound-2.6/include/linux/rmap.h
@@ -134,6 +134,7 @@ int page_wrprotect(struct page *page, in
  */
 struct anon_vma *page_lock_anon_vma(struct page *page);
 void page_unlock_anon_vma(struct anon_vma *anon_vma);
+int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
 #else	/* !CONFIG_MMU */
 
--- sound-2.6.orig/mm/rmap.c
+++ sound-2.6/mm/rmap.c
@@ -315,7 +315,7 @@ pte_t *page_check_address(struct page *p
  * if the page is not mapped into the page tables of this VMA.  Only
  * valid for normal file or anonymous VMAs.
  */
-static int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
+int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	unsigned long address;
 	pte_t *pte;

-- 

