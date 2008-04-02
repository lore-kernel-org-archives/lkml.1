Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbYDBVum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbYDBVum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761146AbYDBVpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:34 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33621
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763309AbYDBVpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 8] Move the tlb flushing into free_pgtables. The
	conversion of the locks
X-Mercurial-Node: d880c227ddf345f5d577839d36d150c37b653bfd
Message-Id: <d880c227ddf345f5d577.1207171804@duo.random>
In-Reply-To: <patchbomb.1207171801@duo.random>
Date: Wed, 02 Apr 2008 23:30:04 +0200
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
# Date 1207159010 -7200
# Node ID d880c227ddf345f5d577839d36d150c37b653bfd
# Parent  fe00cb9deeb31467396370c835cb808f4b85209a
Move the tlb flushing into free_pgtables. The conversion of the locks
taken for reverse map scanning would require taking sleeping locks
in free_pgtables(). Moving the tlb flushing into free_pgtables allows
sleeping in parts of free_pgtables().

This means that we do a tlb_finish_mmu() before freeing the page tables.
Strictly speaking there may not be the need to do another tlb flush after
freeing the tables. But its the only way to free a series of page table
pages from the tlb list. And we do not want to call into the page allocator
for performance reasons. Aim9 numbers look okay after this patch.

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
@@ -286,8 +288,10 @@
 		unlink_file_vma(vma);
 
 		if (is_vm_hugetlb_page(vma)) {
-			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
+			tlb = tlb_gather_mmu(vma->vm_mm, 0);
+			hugetlb_free_pgd_range(&tlb, addr, vma->vm_end,
 				floor, next? next->vm_start: ceiling);
+			tlb_finish_mmu(tlb, addr, vma->vm_end);
 		} else {
 			/*
 			 * Optimization: gather nearby vmas into one call down
@@ -299,8 +303,10 @@
 				anon_vma_unlink(vma);
 				unlink_file_vma(vma);
 			}
-			free_pgd_range(tlb, addr, vma->vm_end,
+			tlb = tlb_gather_mmu(vma->vm_mm, 0);
+			free_pgd_range(&tlb, addr, vma->vm_end,
 				floor, next? next->vm_start: ceiling);
+			tlb_finish_mmu(tlb, addr, vma->vm_end);
 		}
 		vma = next;
 	}
diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1751,9 +1751,9 @@
 	mmu_notifier_invalidate_range_start(mm, start, end);
 	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
+	tlb_finish_mmu(tlb, start, end);
+	free_pgtables(vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
-	tlb_finish_mmu(tlb, start, end);
 	mmu_notifier_invalidate_range_end(mm, start, end);
 }
 
@@ -2050,8 +2050,8 @@
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
+	free_pgtables(vma, FIRST_USER_ADDRESS, 0);
 
 	/*
 	 * Walk the list again, actually closing and freeing it,
