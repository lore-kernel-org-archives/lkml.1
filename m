Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbXBGGQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbXBGGQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933218AbXBGGQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:16:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:4933 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbXBGGQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:16:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=ciqNmZ7xos/nc5GXlQ22gja+9WBMbAHST6tydYchqewTU7J+lbHOvfrsnvAaTfOxR
	Mi2VI9/sB9cu5YEFqR5RA==
Date: Tue, 6 Feb 2007 22:15:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@osdl.org>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/3 take2] smaps: extract pte walker from smaps code
Message-ID: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extracts the page table entry walker from the smaps-specific code in
fs/proc/task_mmu.c.  This will be used later for clearing the reference
bits on pages to measure the number of pages accessed over a time period
through /proc/pid/smaps.

The new struct pte_walker includes the struct vm_area_struct of the memory
to walk over.  Iteration begins at the start address and completes at the
the end address.  A pointer to another data structure may be stored in the
private field such as the struct mem_size_stats, which acts as the smaps
accumulator.  For each page table entry in the VMA, the func function is
called with the corresponding struct pte_walker, the pte_t, and its
address.

Since the PTE walker is now extracted from the smaps code,
smaps_pte_func() is invoked for each PTE in the VMA.  Its behavior is
identical to the existing implementation, except it is slightly slower
because each PTE now invokes a function call.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/task_mmu.c |  126 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 82 insertions(+), 44 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 55ade0d..e87824b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -122,6 +122,15 @@ struct mem_size_stats
 	unsigned long private_dirty;
 };
 
+struct pte_walker {
+	struct vm_area_struct *vma;	/* VMA */
+	unsigned long start;		/* start address */
+	unsigned long end;		/* end address */
+	void *private;			/* private data */
+	/* function to invoke for each pte in the above range */
+	void (*func)(struct pte_walker*, pte_t*, unsigned long);
+};
+
 static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
 {
 	struct proc_maps_private *priv = m->private;
@@ -204,98 +213,127 @@ static int show_map(struct seq_file *m, void *v)
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+/*
+ * Walks each PTE in the struct pte_walker address range and calls
+ * walker->func() for each entry.
+ */
+static void walk_ptes(struct pte_walker *walker, pmd_t *pmd)
 {
-	pte_t *pte, ptent;
+	struct vm_area_struct *vma = walker->vma;
+	unsigned long addr = walker->start;
 	spinlock_t *ptl;
-	struct page *page;
+	pte_t *pte;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	do {
-		ptent = *pte;
-		if (!pte_present(ptent))
-			continue;
-
-		mss->resident += PAGE_SIZE;
-
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
-			continue;
-
-		if (page_mapcount(page) >= 2) {
-			if (pte_dirty(ptent))
-				mss->shared_dirty += PAGE_SIZE;
-			else
-				mss->shared_clean += PAGE_SIZE;
-		} else {
-			if (pte_dirty(ptent))
-				mss->private_dirty += PAGE_SIZE;
-			else
-				mss->private_clean += PAGE_SIZE;
-		}
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		walker->func(walker, pte, addr);
+	} while (pte++, addr += PAGE_SIZE, addr != walker->end);
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 }
 
-static inline void smaps_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void walk_pmds(struct pte_walker *walker, pud_t *pud)
 {
-	pmd_t *pmd;
+	unsigned long addr = walker->start;
+	unsigned long end = walker->end;
 	unsigned long next;
+	pmd_t *pmd;
 
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		smaps_pte_range(vma, pmd, addr, next, mss);
+		walk_ptes(walker, pmd);
 	} while (pmd++, addr = next, addr != end);
 }
 
-static inline void smaps_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void walk_puds(struct pte_walker *walker, pgd_t *pgd)
 {
-	pud_t *pud;
+	unsigned long addr = walker->start;
+	unsigned long end = walker->end;
 	unsigned long next;
+	pud_t *pud;
 
 	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		smaps_pmd_range(vma, pud, addr, next, mss);
+		walk_pmds(walker, pud);
 	} while (pud++, addr = next, addr != end);
 }
 
-static inline void smaps_pgd_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void walk_pgds(struct pte_walker *walker)
 {
-	pgd_t *pgd;
+	unsigned long addr = walker->start;
+	unsigned long end = walker->end;
 	unsigned long next;
+	pgd_t *pgd;
 
-	pgd = pgd_offset(vma->vm_mm, addr);
+	pgd = pgd_offset(walker->vma->vm_mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		smaps_pud_range(vma, pgd, addr, next, mss);
+		walk_puds(walker, pgd);
 	} while (pgd++, addr = next, addr != end);
 }
 
+/*
+ * Called for each PTE in the struct pte_walker address range.  For all normal,
+ * present pages, we accumulate the size (in pages) grouped by shared and
+ * private attributes and dirty bits.
+ */
+static void smaps_pte_func(struct pte_walker *walker, pte_t *pte,
+			   unsigned long addr)
+{
+	struct mem_size_stats *mss = walker->private;
+	struct page *page;
+	pte_t ptent;
+
+	ptent = *pte;
+	if (!pte_present(ptent))
+		return;
+
+	mss->resident += PAGE_SIZE;
+
+	page = vm_normal_page(walker->vma, addr, ptent);
+	if (!page)
+		return;
+
+	if (page_mapcount(page) >= 2) {
+		if (pte_dirty(ptent))
+			mss->shared_dirty += PAGE_SIZE;
+		else
+			mss->shared_clean += PAGE_SIZE;
+	} else {
+		if (pte_dirty(ptent))
+			mss->private_dirty += PAGE_SIZE;
+		else
+			mss->private_clean += PAGE_SIZE;
+	}
+}
+
+/*
+ * Displays the smap for the process.  smaps_pte_func() is called for each PTE
+ * in the range from vma->vm_start to vma->vm_end.
+ */
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
+	struct pte_walker walker = {
+		.vma		= vma,
+		.start		= vma->vm_start,
+		.end		= vma->vm_end,
+		.private	= &mss,
+		.func		= smaps_pte_func,
+	};
 
 	memset(&mss, 0, sizeof mss);
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		smaps_pgd_range(vma, vma->vm_start, vma->vm_end, &mss);
+		walk_pgds(&walker);
 	return show_map_internal(m, v, &mss);
 }
 
