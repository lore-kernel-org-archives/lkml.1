Return-Path: <linux-kernel-owner+w=401wt.eu-S2992778AbXBITgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992778AbXBITgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992776AbXBITgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:36:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16873 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992778AbXBITgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:36:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=Uqk2LPZliy7wYh2jg/duyY92MBhOuOTYclFoKHZBRXsklGJrKF5T00DuyZ1PDTEml
	KMQfa6rujTONnaMDscSwA==
Date: Fri, 9 Feb 2007 11:35:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/3] smaps: extract pmd walker from smaps code
Message-ID: <Pine.LNX.4.64.0702082208270.10206@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extracts the pmd walker from smaps-specific code in fs/proc/task_mmu.c.

The new struct pmd_walker includes the struct vm_area_struct of the memory
to walk over.  Iteration begins at the vma->vm_start and completes at
vma->vm_end.  A pointer to another data structure may be stored in the
private field such as struct mem_size_stats, which acts as the smaps
accumulator.  For each pmd in the VMA, the action function is called with
a pointer to its struct vm_area_struct, a pointer to the pmd_t, its
start and end addresses, and the private field.

The interface for walking pmd's in a VMA for fs/proc/task_mmu.c is now:

	void for_each_pmd(struct vm_area_struct *vma,
			  void (*action)(struct vm_area_struct *vma,
					 pmd_t *pmd, unsigned long addr,
					 unsigned long end,
					 void *private),
			  void *private);

Since the pmd walker is now extracted from the smaps code, smaps_one_pmd()
is invoked for each pmd in the VMA.  Its behavior and efficiency is
identical to the existing implementation.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/task_mmu.c |   69 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -122,6 +122,13 @@ struct mem_size_stats
 	unsigned long private_dirty;
 };
 
+struct pmd_walker {
+	struct vm_area_struct *vma;
+	void *private;
+	void (*action)(struct vm_area_struct *, pmd_t *, unsigned long,
+		       unsigned long, void *);
+};
+
 static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
 {
 	struct proc_maps_private *priv = m->private;
@@ -204,16 +211,17 @@ static int show_map(struct seq_file *m, void *v)
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static void smaps_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			  unsigned long addr, unsigned long end,
+			  void *private)
 {
+	struct mem_size_stats *mss = private;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	do {
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
 		if (!pte_present(ptent))
 			continue;
@@ -235,57 +243,64 @@ static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 			else
 				mss->private_clean += PAGE_SIZE;
 		}
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 }
 
-static inline void smaps_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void for_each_pmd_in_pud(struct pmd_walker *walker, pud_t *pud,
+				       unsigned long addr, unsigned long end)
 {
 	pmd_t *pmd;
 	unsigned long next;
 
-	pmd = pmd_offset(pud, addr);
-	do {
+	for (pmd = pmd_offset(pud, addr); addr != end;
+	     pmd++, addr = next) {
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		smaps_pte_range(vma, pmd, addr, next, mss);
-	} while (pmd++, addr = next, addr != end);
+		walker->action(walker->vma, pmd, addr, next, walker->private);
+	}
 }
 
-static inline void smaps_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void for_each_pud_in_pgd(struct pmd_walker *walker, pgd_t *pgd,
+				       unsigned long addr, unsigned long end)
 {
 	pud_t *pud;
 	unsigned long next;
 
-	pud = pud_offset(pgd, addr);
-	do {
+	for (pud = pud_offset(pgd, addr); addr != end;
+	     pud++, addr = next) {
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		smaps_pmd_range(vma, pud, addr, next, mss);
-	} while (pud++, addr = next, addr != end);
+		for_each_pmd_in_pud(walker, pud, addr, next);
+	}
 }
 
-static inline void smaps_pgd_range(struct vm_area_struct *vma,
-				unsigned long addr, unsigned long end,
-				struct mem_size_stats *mss)
+static inline void for_each_pmd(struct vm_area_struct *vma,
+				void (*action)(struct vm_area_struct *, pmd_t *,
+					       unsigned long, unsigned long,
+					       void *),
+				void *private)
 {
+	unsigned long addr = vma->vm_start;
+	unsigned long end = vma->vm_end;
+	struct pmd_walker walker = {
+		.vma		= vma,
+		.private	= private,
+		.action		= action,
+	};
 	pgd_t *pgd;
 	unsigned long next;
 
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
+	for (pgd = pgd_offset(vma->vm_mm, addr); addr != end;
+	     pgd++, addr = next) {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		smaps_pud_range(vma, pgd, addr, next, mss);
-	} while (pgd++, addr = next, addr != end);
+		for_each_pud_in_pgd(&walker, pgd, addr, next);
+	}
 }
 
 static int show_smap(struct seq_file *m, void *v)
@@ -295,7 +310,7 @@ static int show_smap(struct seq_file *m, void *v)
 
 	memset(&mss, 0, sizeof mss);
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		smaps_pgd_range(vma, vma->vm_start, vma->vm_end, &mss);
+		for_each_pmd(vma, smaps_one_pmd, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
