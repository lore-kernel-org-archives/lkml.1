Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYG1TRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYG1TRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYG1TRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:17:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55445 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbYG1TRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:17:23 -0400
From: Eric Munson <ebmunson@us.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net,
       Eric Munson <ebmunson@us.ibm.com>
Subject: [PATCH 5/5 V2] [PPC] Setup stack memory segment for hugetlb pages
Date: Mon, 28 Jul 2008 12:17:15 -0700
Message-Id: <d73cf131d1a8db8fcce1200634d2975fb552b575.1216928613.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <cover.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
In-Reply-To: <cover.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the memory slice that holds the process stack is always initialized
to hold small pages.  This patch defines the weak function that is declared
in the previos patch to convert the stack slice to hugetlb pages.

Signed-off-by: Eric Munson <ebmunson@us.ibm.com>

---
Based on 2.6.26-rc8-mm1

Changes from V1:
Instead of setting the mm-wide page size to huge pages, set only the relavent
 slice psize using an arch defined weak function.

 arch/powerpc/mm/hugetlbpage.c |    6 ++++++
 arch/powerpc/mm/slice.c       |   11 +++++++++++
 include/asm-powerpc/hugetlb.h |    3 +++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index fb42c4d..bd7f777 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -152,6 +152,12 @@ pmd_t *hpmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long addr,
 }
 #endif
 
+void hugetlb_mm_setup(struct mm_struct *mm, unsigned long addr,
+			unsigned long len)
+{
+	slice_convert_address(mm, addr, len, shift_to_mmu_psize(HPAGE_SHIFT));
+}
+
 /* Build list of addresses of gigantic pages.  This function is used in early
  * boot before the buddy or bootmem allocator is setup.
  */
diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index 583be67..d984733 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -30,6 +30,7 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
+#include <linux/hugetlb.h>
 #include <asm/mman.h>
 #include <asm/mmu.h>
 #include <asm/spu.h>
@@ -397,6 +398,16 @@ static unsigned long slice_find_area(struct mm_struct *mm, unsigned long len,
 #define MMU_PAGE_BASE	MMU_PAGE_4K
 #endif
 
+void slice_convert_address(struct mm_struct *mm, unsigned long addr,
+				unsigned long len, unsigned int psize)
+{
+	struct slice_mask mask;
+
+	mask = slice_range_to_mask(addr, len);
+	slice_convert(mm, mask, psize);
+	slice_flush_segments(mm);
+}
+
 unsigned long slice_get_unmapped_area(unsigned long addr, unsigned long len,
 				      unsigned long flags, unsigned int psize,
 				      int topdown, int use_cache)
diff --git a/include/asm-powerpc/hugetlb.h b/include/asm-powerpc/hugetlb.h
index 26f0d0a..10ef089 100644
--- a/include/asm-powerpc/hugetlb.h
+++ b/include/asm-powerpc/hugetlb.h
@@ -17,6 +17,9 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep);
 
+void slice_convert_address(struct mm_struct *mm, unsigned long addr,
+				unsigned long len, unsigned int psize);
+
 /*
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
-- 
1.5.6.1

