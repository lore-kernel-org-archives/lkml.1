Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbYDBVv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbYDBVv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763391AbYDBVpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:52 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33647
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763383AbYDBVpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 8] We no longer abort unmapping in unmap vmas because we
	can reschedule while
X-Mercurial-Node: 316e5b1e4bf388ef0198c91b3067ed1e4171d7f6
Message-Id: <316e5b1e4bf388ef0198.1207171806@duo.random>
In-Reply-To: <patchbomb.1207171801@duo.random>
Date: Wed, 02 Apr 2008 23:30:06 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: akpm@linux-foundation.org
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1207159055 -7200
# Node ID 316e5b1e4bf388ef0198c91b3067ed1e4171d7f6
# Parent  3c3787c496cab1fc590ba3f97e7904bdfaab5375
We no longer abort unmapping in unmap vmas because we can reschedule while
unmapping since we are holding a semaphore. This would allow moving more
of the tlb flusing into unmap_vmas reducing code in various places.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

diff --git a/include/linux/mm.h b/include/linux/mm.h
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -723,8 +723,7 @@
 struct page *vm_normal_page(struct vm_area_struct *, unsigned long, pte_t);
 unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *);
-unsigned long unmap_vmas(struct mmu_gather **tlb,
-		struct vm_area_struct *start_vma, unsigned long start_addr,
+unsigned long unmap_vmas(struct vm_area_struct *start_vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *);
 
diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -805,7 +805,6 @@
 
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
- * @tlbp: address of the caller's struct mmu_gather
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
@@ -817,20 +816,13 @@
  * Unmap all pages in the vma list.
  *
  * We aim to not hold locks for too long (for scheduling latency reasons).
- * So zap pages in ZAP_BLOCK_SIZE bytecounts.  This means we need to
- * return the ending mmu_gather to the caller.
+ * So zap pages in ZAP_BLOCK_SIZE bytecounts.
  *
  * Only addresses between `start' and `end' will be unmapped.
  *
  * The VMA list must be sorted in ascending virtual address order.
- *
- * unmap_vmas() assumes that the caller will flush the whole unmapped address
- * range after unmap_vmas() returns.  So the only responsibility here is to
- * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
- * drops the lock and schedules.
  */
-unsigned long unmap_vmas(struct mmu_gather **tlbp,
-		struct vm_area_struct *vma, unsigned long start_addr,
+unsigned long unmap_vmas(struct vm_area_struct *vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *details)
 {
@@ -838,7 +830,15 @@
 	unsigned long tlb_start = 0;	/* For tlb_finish_mmu */
 	int tlb_start_valid = 0;
 	unsigned long start = start_addr;
-	int fullmm = (*tlbp)->fullmm;
+	int fullmm;
+	struct mmu_gather *tlb;
+	struct mm_struct *mm = vma->vm_mm;
+
+	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
+	lru_add_drain();
+	tlb = tlb_gather_mmu(mm, 0);
+	update_hiwater_rss(mm);
+	fullmm = tlb->fullmm;
 
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
 		unsigned long end;
@@ -865,7 +865,7 @@
 						(HPAGE_SIZE / PAGE_SIZE);
 				start = end;
 			} else
-				start = unmap_page_range(*tlbp, vma,
+				start = unmap_page_range(tlb, vma,
 						start, end, &zap_work, details);
 
 			if (zap_work > 0) {
@@ -873,13 +873,15 @@
 				break;
 			}
 
-			tlb_finish_mmu(*tlbp, tlb_start, start);
+			tlb_finish_mmu(tlb, tlb_start, start);
 			cond_resched();
-			*tlbp = tlb_gather_mmu(vma->vm_mm, fullmm);
+			tlb = tlb_gather_mmu(vma->vm_mm, fullmm);
 			tlb_start_valid = 0;
 			zap_work = ZAP_BLOCK_SIZE;
 		}
 	}
+	tlb_finish_mmu(tlb, start_addr, end_addr);
+	mmu_notifier_invalidate_range_end(mm, start_addr, end_addr);
 	return start;	/* which is now the end (or restart) address */
 }
 
@@ -893,20 +895,10 @@
 unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	struct mmu_gather *tlb;
 	unsigned long end = address + size;
 	unsigned long nr_accounted = 0;
 
-	lru_add_drain();
-	tlb = tlb_gather_mmu(mm, 0);
-	update_hiwater_rss(mm);
-	mmu_notifier_invalidate_range_start(mm, address, end);
-	end = unmap_vmas(&tlb, vma, address, end, &nr_accounted, details);
-	mmu_notifier_invalidate_range_end(mm, address, end);
-	if (tlb)
-		tlb_finish_mmu(tlb, address, end);
-	return end;
+	return unmap_vmas(vma, address, end, &nr_accounted, details);
 }
 
 /*
diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1742,19 +1742,12 @@
 		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *next = prev? prev->vm_next: mm->mmap;
-	struct mmu_gather *tlb;
 	unsigned long nr_accounted = 0;
 
-	lru_add_drain();
-	tlb = tlb_gather_mmu(mm, 0);
-	update_hiwater_rss(mm);
-	mmu_notifier_invalidate_range_start(mm, start, end);
-	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
+	unmap_vmas(vma, start, end, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	tlb_finish_mmu(tlb, start, end);
 	free_pgtables(vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
-	mmu_notifier_invalidate_range_end(mm, start, end);
 }
 
 /*
@@ -2034,7 +2027,6 @@
 /* Release all mmaps. */
 void exit_mmap(struct mm_struct *mm)
 {
-	struct mmu_gather *tlb;
 	struct vm_area_struct *vma = mm->mmap;
 	unsigned long nr_accounted = 0;
 	unsigned long end;
@@ -2045,12 +2037,9 @@
 
 	lru_add_drain();
 	flush_cache_mm(mm);
-	tlb = tlb_gather_mmu(mm, 1);
-	/* Don't update_hiwater_rss(mm) here, do_exit already did */
-	/* Use -1 here to ensure all VMAs in the mm are unmapped */
-	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
+
+	end = unmap_vmas(vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	tlb_finish_mmu(tlb, 0, end);
 	free_pgtables(vma, FIRST_USER_ADDRESS, 0);
 
 	/*
