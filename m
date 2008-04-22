Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbYDVOMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbYDVOMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763595AbYDVOKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:10:41 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41283
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762622AbYDVOKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:10:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 12] Move the tlb flushing into free_pgtables. The
	conversion of the locks
X-Mercurial-Node: ee8c0644d5f67c1ef59142cce91b0bb6f34a53e0
Message-Id: <ee8c0644d5f67c1ef591.1208872281@duo.random>
In-Reply-To: <patchbomb.1208872276@duo.random>
Date: Tue, 22 Apr 2008 15:51:21 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1208872186 -7200
# Node ID ee8c0644d5f67c1ef59142cce91b0bb6f34a53e0
# Parent  ac9bb1fb3de2aa5d27210a28edf24f6577094076
Move the tlb flushing into free_pgtables. The conversion of the locks
taken for reverse map scanning would require taking sleeping locks
in free_pgtables() and we cannot sleep while gathering pages for a tlb
flush.

Move the tlb_gather/tlb_finish call to free_pgtables() to be done
for each vma. This may add a number of tlb flushes depending on the
number of vmas that cannot be coalesced into one.

The first pointer argument to free_pgtables() can then be dropped.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

diff --git a/include/linux/mm.h b/include/linux/mm.h
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -751,8 +751,8 @@
 		    void *private);
 void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
-void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
-		unsigned long floor, unsigned long ceiling);
+void free_pgtables(struct vm_area_struct *start_vma, unsigned long floor,
+						unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -272,9 +272,11 @@
 	} while (pgd++, addr = next, addr != end);
 }
 
-void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *vma,
-		unsigned long floor, unsigned long ceiling)
+void free_pgtables(struct vm_area_struct *vma, unsigned long floor,
+							unsigned long ceiling)
 {
+	struct mmu_gather *tlb;
+
 	while (vma) {
 		struct vm_area_struct *next = vma->vm_next;
 		unsigned long addr = vma->vm_start;
@@ -286,7 +288,8 @@
 		unlink_file_vma(vma);
 
 		if (is_vm_hugetlb_page(vma)) {
-			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
+			tlb = tlb_gather_mmu(vma->vm_mm, 0);
+			hugetlb_free_pgd_range(&tlb, addr, vma->vm_end,
 				floor, next? next->vm_start: ceiling);
 		} else {
 			/*
@@ -299,9 +302,11 @@
 				anon_vma_unlink(vma);
 				unlink_file_vma(vma);
 			}
-			free_pgd_range(tlb, addr, vma->vm_end,
+			tlb = tlb_gather_mmu(vma->vm_mm, 0);
+			free_pgd_range(&tlb, addr, vma->vm_end,
 				floor, next? next->vm_start: ceiling);
 		}
+		tlb_finish_mmu(tlb, addr, vma->vm_end);
 		vma = next;
 	}
 }
diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1752,9 +1752,9 @@
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
+	tlb_finish_mmu(tlb, start, end);
+	free_pgtables(vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
-	tlb_finish_mmu(tlb, start, end);
 }
 
 /*
@@ -2050,8 +2050,8 @@
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
+	free_pgtables(vma, FIRST_USER_ADDRESS, 0);
 
 	/*
 	 * Walk the list again, actually closing and freeing it,
