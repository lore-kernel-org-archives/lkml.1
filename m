Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZI3VKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZI3VKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZI3VKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:10:35 -0400
Received: from cmpxchg.org ([85.214.51.133]:56401 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbZI3VKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:10:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [rfc patch 2/3] mm: serialize truncation unmap against try_to_unmap()
Date: Wed, 30 Sep 2009 23:09:23 +0200
Message-Id: <1254344964-8124-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254344964-8124-1-git-send-email-hannes@cmpxchg.org>
References: <1254344964-8124-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To munlock private COW pages on truncating unmap, we must serialize
against concurrent reclaimers doing try_to_unmap() so they don't
re-mlock the page before we free it.

Grabbing the page lock is not possible when zapping the page table
entries, so prevent lazy mlock in the reclaimer by holding onto the
anon_vma lock while unmapping a VMA.

The anon_vma can show up only after we tried locking it.  Pass it down
in zap_details so that the zapping loops can check for whether we
acquired the lock or not.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm.h |    1 +
 mm/memory.c        |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -999,6 +999,7 @@ unsigned long unmap_vmas(struct mmu_gath
 	int tlb_start_valid = 0;
 	unsigned long start = start_addr;
 	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
+	struct anon_vma *anon_vma = details? details->anon_vma: NULL;
 	int fullmm = (*tlbp)->fullmm;
 	struct mm_struct *mm = vma->vm_mm;
 
@@ -1056,8 +1057,9 @@ unsigned long unmap_vmas(struct mmu_gath
 			tlb_finish_mmu(*tlbp, tlb_start, start);
 
 			if (need_resched() ||
-				(i_mmap_lock && spin_needbreak(i_mmap_lock))) {
-				if (i_mmap_lock) {
+			    (i_mmap_lock && spin_needbreak(i_mmap_lock)) ||
+			    (anon_vma && spin_needbreak(&anon_vma->lock))) {
+				if (i_mmap_lock || anon_vma) {
 					*tlbp = NULL;
 					goto out;
 				}
@@ -2327,9 +2329,14 @@ again:
 		}
 	}
 
+	details->anon_vma = vma->anon_vma;
+	if (details->anon_vma)
+		spin_lock(&details->anon_vma->lock);
 	restart_addr = zap_page_range(vma, start_addr,
 					end_addr - start_addr, details);
 	need_break = need_resched() || spin_needbreak(details->i_mmap_lock);
+	if (details->anon_vma)
+		spin_unlock(&details->anon_vma->lock);
 
 	if (restart_addr >= end_addr) {
 		/* We have now completed this vma: mark it so */
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -733,6 +733,7 @@ extern void user_shm_unlock(size_t, stru
 struct zap_details {
 	struct vm_area_struct *nonlinear_vma;	/* Check page->index if set */
 	struct address_space *mapping;		/* Backing address space */
+	struct anon_vma *anon_vma;		/* Rmap for private COW pages */
 	bool keep_private;			/* Do not touch private pages */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
