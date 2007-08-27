Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXH0Egn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXH0Egn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 00:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbXH0Ege
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 00:36:34 -0400
Received: from ozlabs.org ([203.10.76.45]:45523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbXH0Egd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 00:36:33 -0400
Date: Mon, 27 Aug 2007 14:36:27 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Andrew Morton <akpm@osdl.org>
Cc: William Lee Irwin <wli@holomorphy.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
Subject: hugepage: Fix broken check for offset alignment in hugepage mappings
Message-ID: <20070827043627.GA7306@localhost.localdomain>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Andrew Morton <akpm@osdl.org>,
	William Lee Irwin <wli@holomorphy.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For hugepage mappings, the file offset, like the address and size,
needs to be aligned to the size of a hugepage.

In commit 68589bc353037f233fe510ad9ff432338c95db66, the check for this
was moved into prepare_hugepage_range() along with the address and
size checks.  But since BenH's rework of the get_unmapped_area() paths
leading up to commit 4b1d89290b62bb2db476c94c82cf7442aab440c8,
prepare_hugepage_range() is only called for MAP_FIXED mappings, not
for other mappings.  This means we're no longer ever checking for an
aligned offset - I've confirmed that mmap() will (apparently) succeed
with a misaligned offset on both powerpc and i386 at least.

This patch restores the check, removing it from
prepare_hugepage_range() and putting it back into
hugetlbfs_file_mmap().  I'm putting it there, rather than in the
get_unmapped_area() path so it only needs to go in one place, than
separately in the half-dozen or so arch-specific implementations of
hugetlb_get_unmapped_area().

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

---
 arch/i386/mm/hugetlbpage.c    |    2 +-
 arch/ia64/mm/hugetlbpage.c    |    6 ++----
 arch/sparc64/mm/hugetlbpage.c |    2 +-
 fs/hugetlbfs/inode.c          |   15 ++++++++++-----
 include/linux/hugetlb.h       |   10 +++-------
 5 files changed, 17 insertions(+), 18 deletions(-)

Andrew, please apply.  I think this bugfix should go into 2.6.23.

Index: working-2.6/fs/hugetlbfs/inode.c
===================================================================
--- working-2.6.orig/fs/hugetlbfs/inode.c	2007-08-27 13:37:02.000000000 +1000
+++ working-2.6/fs/hugetlbfs/inode.c	2007-08-27 13:37:11.000000000 +1000
@@ -82,14 +82,19 @@ static int hugetlbfs_file_mmap(struct fi
 	int ret;
 
 	/*
-	 * vma alignment has already been checked by prepare_hugepage_range.
-	 * If you add any error returns here, do so after setting VM_HUGETLB,
-	 * so is_vm_hugetlb_page tests below unmap_region go the right way
-	 * when do_mmap_pgoff unwinds (may be important on powerpc and ia64).
+	 * vma address alignment (but not the pgoff alignment) has
+	 * already been checked by prepare_hugepage_range.  If you add
+	 * any error returns here, do so after setting VM_HUGETLB, so
+	 * is_vm_hugetlb_page tests below unmap_region go the right
+	 * way when do_mmap_pgoff unwinds (may be important on powerpc
+	 * and ia64).
 	 */
 	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
 	vma->vm_ops = &hugetlb_vm_ops;
 
+	if (vma->vm_pgoff & ~(HPAGE_MASK >> PAGE_SHIFT))
+		return -EINVAL;
+
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
 
 	mutex_lock(&inode->i_mutex);
@@ -132,7 +137,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}
Index: working-2.6/include/linux/hugetlb.h
===================================================================
--- working-2.6.orig/include/linux/hugetlb.h	2007-08-27 13:37:02.000000000 +1000
+++ working-2.6/include/linux/hugetlb.h	2007-08-27 13:37:11.000000000 +1000
@@ -66,11 +66,8 @@ void hugetlb_free_pgd_range(struct mmu_g
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
-static inline int prepare_hugepage_range(unsigned long addr, unsigned long len,
-						pgoff_t pgoff)
+static inline int prepare_hugepage_range(unsigned long addr, unsigned long len)
 {
-	if (pgoff & (~HPAGE_MASK >> PAGE_SHIFT))
-		return -EINVAL;
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
 	if (addr & ~HPAGE_MASK)
@@ -78,8 +75,7 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 #else
-int prepare_hugepage_range(unsigned long addr, unsigned long len,
-						pgoff_t pgoff);
+int prepare_hugepage_range(unsigned long addr, unsigned long len);
 #endif
 
 #ifndef ARCH_HAS_SETCLEAR_HUGE_PTE
@@ -117,7 +113,7 @@ static inline unsigned long hugetlb_tota
 #define hugetlb_report_meminfo(buf)		0
 #define hugetlb_report_node_meminfo(n, buf)	0
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
-#define prepare_hugepage_range(addr,len,pgoff)	(-EINVAL)
+#define prepare_hugepage_range(addr,len)	(-EINVAL)
 #define pmd_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
Index: working-2.6/arch/i386/mm/hugetlbpage.c
===================================================================
--- working-2.6.orig/arch/i386/mm/hugetlbpage.c	2007-08-27 13:37:02.000000000 +1000
+++ working-2.6/arch/i386/mm/hugetlbpage.c	2007-08-27 13:37:11.000000000 +1000
@@ -367,7 +367,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}
Index: working-2.6/arch/ia64/mm/hugetlbpage.c
===================================================================
--- working-2.6.orig/arch/ia64/mm/hugetlbpage.c	2007-08-27 13:37:02.000000000 +1000
+++ working-2.6/arch/ia64/mm/hugetlbpage.c	2007-08-27 13:37:12.000000000 +1000
@@ -75,10 +75,8 @@ int huge_pmd_unshare(struct mm_struct *m
  * Don't actually need to do any preparation, but need to make sure
  * the address is in the right region.
  */
-int prepare_hugepage_range(unsigned long addr, unsigned long len, pgoff_t pgoff)
+int prepare_hugepage_range(unsigned long addr, unsigned long len)
 {
-	if (pgoff & (~HPAGE_MASK >> PAGE_SHIFT))
-		return -EINVAL;
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
 	if (addr & ~HPAGE_MASK)
@@ -151,7 +149,7 @@ unsigned long hugetlb_get_unmapped_area(
 
 	/* Handle MAP_FIXED */
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}
Index: working-2.6/arch/sparc64/mm/hugetlbpage.c
===================================================================
--- working-2.6.orig/arch/sparc64/mm/hugetlbpage.c	2007-08-27 13:37:02.000000000 +1000
+++ working-2.6/arch/sparc64/mm/hugetlbpage.c	2007-08-27 13:37:12.000000000 +1000
@@ -175,7 +175,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(addr, len, pgoff))
+		if (prepare_hugepage_range(addr, len))
 			return -EINVAL;
 		return addr;
 	}

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
