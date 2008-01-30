Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbYA3R3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbYA3R3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbYA3R3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:29:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55543 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbYA3R3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:29:11 -0500
Subject: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <npiggin@suse.de>,
       riel <riel@redhat.com>, Lennart Poettering <mztabzr@0pointer.de>,
       Matt Mackall <mpm@selenic.com>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 18:28:59 +0100
Message-Id: <1201714139.28547.237.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mm: MADV_WILLNEED implementation for anonymous memory

Implement MADV_WILLNEED for anonymous pages by walking the page tables and
starting asynchonous swap cache reads for all encountered swap pages.

Doing so required a modification to the page table walking library functions.
Previously ->pte_entry() could be called while holding a kmap_atomic, to
overcome this problem the pte walker is changed to copy batches of the pmd
and iterate them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/madvise.c  |   48 +++++++++++++++++++++++++++++++++++++++++-------
 mm/pagewalk.c |   33 +++++++++++++++++++++++++++------
 2 files changed, 68 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/madvise.c
===================================================================
--- linux-2.6.orig/mm/madvise.c
+++ linux-2.6/mm/madvise.c
@@ -11,6 +11,8 @@
 #include <linux/mempolicy.h>
 #include <linux/hugetlb.h>
 #include <linux/sched.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -100,17 +102,51 @@ out:
 	return error;
 }
 
+static int madvise_willneed_anon_pte(pte_t *ptep, unsigned long addr,
+		unsigned long end, void *arg)
+{
+	struct vm_area_struct *vma = arg;
+	struct page *page;
+
+	if (is_swap_pte(*ptep)) {
+		page = read_swap_cache_async(pte_to_swp_entry(*ptep),
+					GFP_KERNEL, vma, addr);
+		if (page)
+			page_cache_release(page);
+	}
+
+	return 0;
+}
+
+static long madvise_willneed_anon(struct vm_area_struct *vma,
+				  struct vm_area_struct **prev,
+				  unsigned long start, unsigned long end)
+{
+	unsigned long len;
+	struct mm_walk walk = {
+		.pte_entry = madvise_willneed_anon_pte,
+	};
+
+	len = max_sane_readahead((end - start) >> PAGE_SHIFT);
+	end = start + (len << PAGE_SHIFT);
+
+	walk_page_range(vma->vm_mm, start, end, &walk, vma);
+	*prev = vma;
+
+	return 0;
+}
+
 /*
  * Schedule all required I/O operations.  Do not wait for completion.
  */
-static long madvise_willneed(struct vm_area_struct * vma,
-			     struct vm_area_struct ** prev,
+static long madvise_willneed(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
 			     unsigned long start, unsigned long end)
 {
 	struct file *file = vma->vm_file;
 
 	if (!file)
-		return -EBADF;
+		return madvise_willneed_anon(vma, prev, start, end);
 
 	if (file->f_mapping->a_ops->get_xip_page) {
 		/* no bad return value, but ignore advice */
@@ -119,8 +155,6 @@ static long madvise_willneed(struct vm_a
 
 	*prev = vma;
 	start = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	if (end > vma->vm_end)
-		end = vma->vm_end;
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
 	force_page_cache_readahead(file->f_mapping,
@@ -147,8 +181,8 @@ static long madvise_willneed(struct vm_a
  * An interface that causes the system to free clean pages and flush
  * dirty pages is already available as msync(MS_INVALIDATE).
  */
-static long madvise_dontneed(struct vm_area_struct * vma,
-			     struct vm_area_struct ** prev,
+static long madvise_dontneed(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
 			     unsigned long start, unsigned long end)
 {
 	*prev = vma;
Index: linux-2.6/mm/pagewalk.c
===================================================================
--- linux-2.6.orig/mm/pagewalk.c
+++ linux-2.6/mm/pagewalk.c
@@ -2,20 +2,41 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 
+/*
+ * Much of the complication here is to work around CONFIG_HIGHPTE which needs
+ * to kmap the pmd. So copy batches of ptes from the pmd and iterate over
+ * those.
+ */
+#define WALK_BATCH_SIZE	32
+
 static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			  const struct mm_walk *walk, void *private)
 {
 	pte_t *pte;
+	pte_t ptes[WALK_BATCH_SIZE];
+	unsigned long start;
+	unsigned int i;
 	int err = 0;
 
-	pte = pte_offset_map(pmd, addr);
 	do {
-		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
-		if (err)
-		       break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		start = addr;
 
-	pte_unmap(pte);
+		pte = pte_offset_map(pmd, addr);
+		for (i = 0; i < WALK_BATCH_SIZE && addr != end;
+				i++, pte++, addr += PAGE_SIZE)
+			ptes[i] = *pte;
+		pte_unmap(pte);
+
+		for (i = 0, pte = ptes, addr = start;
+				i < WALK_BATCH_SIZE && addr != end;
+				i++, pte++, addr += PAGE_SIZE) {
+			err = walk->pte_entry(pte, addr, addr + PAGE_SIZE,
+					private);
+			if (err)
+				goto out;
+		}
+	} while (addr != end);
+out:
 	return err;
 }
 


