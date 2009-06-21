Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbZFUQYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbZFUQYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 12:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZFUQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 12:23:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:45793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZFUQXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 12:23:53 -0400
Subject: Re: [PATCH -tip] x86: mm/hugetlbpage.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rohit Seth <rohitseth@google.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090621112201.GA13435@elte.hu>
References: <1245582881.3052.3.camel@localhost.localdomain>
	 <20090621112201.GA13435@elte.hu>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 21:50:45 +0530
Message-Id: <1245601245.15619.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 13:22 +0200, Ingo Molnar wrote:

> Plus at a first glance that file has a couple of other problems as 
> well beyond trivial style issue:
> 
>  - dead code which should be removed
> 
>  - a 64-bit only boot option that should probably be extended to 
>    32-bit as well
> 
>  - insanely long function names with local scope, causing ugly 
>    linebreaks
> 
> and more style issues as well:
> 
>  - various inconsistent capitalizations in comment blocks
> 
>  - some other small details as well
> 
> Lets try to do a genuinely big and comprehensive forward step that 
> addresses all these issues (and any other issues that are in that 
> file), ok?

[PATCH] x86: mm/hugetlbpage.c cleanups with no code change

Impact : cleanup

Fix followings with no code changed:

A. trivial style issues
  WARNING: Use #include <linux/mman.h> instead of <asm/mman.h>
  WARNING: line over 80 characters
  ERROR: code indent should use tabs where possible X 10
  ERROR: do not use assignment in if condition
  ERROR: return is not a function, parentheses are not required

  total: 12 errors, 2 warnings

B. removal of dead code

C. setup_hugepagesz extends to 32 bit

D. Inverse Xmas tree for header includes

E. rename long local function names to avoid linebreaks

F. use pr_err to avoid linebreaks

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/mm/hugetlbpage.c |  119 +++++++++++++--------------------------------
 1 files changed, 34 insertions(+), 85 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index f46c340..d022f09 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -4,18 +4,19 @@
  * Copyright (C) 2002, Rohit Seth <rohit.seth@intel.com>
  */
 
-#include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
+#include <linux/sysctl.h>
+#include <linux/init.h>
+#include <linux/mman.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/sysctl.h>
-#include <asm/mman.h>
-#include <asm/tlb.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
+#include <asm/tlb.h>
 
 static unsigned long page_table_shareable(struct vm_area_struct *svma,
 				struct vm_area_struct *vma,
@@ -93,7 +94,8 @@ static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 
 	spin_lock(&mm->page_table_lock);
 	if (pud_none(*pud))
-		pud_populate(mm, pud, (pmd_t *)((unsigned long)spte & PAGE_MASK));
+		pud_populate(mm, pud,
+			     (pmd_t *)((unsigned long)spte & PAGE_MASK));
 	else
 		put_page(virt_to_page(spte));
 	spin_unlock(&mm->page_table_lock);
@@ -170,51 +172,6 @@ pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
 	return (pte_t *) pmd;
 }
 
-#if 0	/* This is just for testing */
-struct page *
-follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
-{
-	unsigned long start = address;
-	int length = 1;
-	int nr;
-	struct page *page;
-	struct vm_area_struct *vma;
-
-	vma = find_vma(mm, addr);
-	if (!vma || !is_vm_hugetlb_page(vma))
-		return ERR_PTR(-EINVAL);
-
-	pte = huge_pte_offset(mm, address);
-
-	/* hugetlb should be locked, and hence, prefaulted */
-	WARN_ON(!pte || pte_none(*pte));
-
-	page = &pte_page(*pte)[vpfn % (HPAGE_SIZE/PAGE_SIZE)];
-
-	WARN_ON(!PageHead(page));
-
-	return page;
-}
-
-int pmd_huge(pmd_t pmd)
-{
-	return 0;
-}
-
-int pud_huge(pud_t pud)
-{
-	return 0;
-}
-
-struct page *
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
-{
-	return NULL;
-}
-
-#else
-
 struct page *
 follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
 {
@@ -255,25 +212,21 @@ follow_huge_pud(struct mm_struct *mm, unsigned long address,
 	return page;
 }
 
-#endif
-
-/* x86_64 also uses this file */
-
 #ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
-		unsigned long addr, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
+static unsigned long
+unmapped_bottomup(struct file *file, unsigned long addr, unsigned long len,
+		  unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
 
-	if (len > mm->cached_hole_size) {
-	        start_addr = mm->free_area_cache;
-	} else {
-	        start_addr = TASK_UNMAPPED_BASE;
-	        mm->cached_hole_size = 0;
+	if (len > mm->cached_hole_size)
+		start_addr = mm->free_area_cache;
+	else {
+		start_addr = TASK_UNMAPPED_BASE;
+		mm->cached_hole_size = 0;
 	}
 
 full_search:
@@ -298,14 +251,14 @@ full_search:
 			return addr;
 		}
 		if (addr + mm->cached_hole_size < vma->vm_start)
-		        mm->cached_hole_size = vma->vm_start - addr;
+			mm->cached_hole_size = vma->vm_start - addr;
 		addr = ALIGN(vma->vm_end, huge_page_size(h));
 	}
 }
 
-static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
-		unsigned long addr0, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
+static unsigned long
+unmapped_topdown(struct file *file, unsigned long addr0, unsigned long len,
+		 unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
@@ -319,7 +272,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 		mm->free_area_cache = base;
 
 	if (len <= largest_hole) {
-	        largest_hole = 0;
+		largest_hole = 0;
 		mm->free_area_cache  = base;
 	}
 try_again:
@@ -334,7 +287,8 @@ try_again:
 		 * Lookup failure means no vma is above this address,
 		 * i.e. return with success:
 		 */
-		if (!(vma = find_vma_prev(mm, addr, &prev_vma)))
+		vma = find_vma_prev(mm, addr, &prev_vma);
+		if (!vma)
 			return addr;
 
 		/*
@@ -342,13 +296,14 @@ try_again:
 		 * vma->vm_start, use it:
 		 */
 		if (addr + len <= vma->vm_start &&
-		            (!prev_vma || (addr >= prev_vma->vm_end))) {
+		    (!prev_vma || (addr >= prev_vma->vm_end))) {
 			/* remember the address as a hint for next time */
-		        mm->cached_hole_size = largest_hole;
-		        return (mm->free_area_cache = addr);
+			mm->cached_hole_size = largest_hole;
+			mm->free_area_cache = addr;
+			return addr;
 		} else {
 			/* pull free_area_cache down to the first hole */
-		        if (mm->free_area_cache == vma->vm_end) {
+			if (mm->free_area_cache == vma->vm_end) {
 				mm->free_area_cache = vma->vm_start;
 				mm->cached_hole_size = largest_hole;
 			}
@@ -356,7 +311,7 @@ try_again:
 
 		/* remember the largest hole we saw so far */
 		if (addr + largest_hole < vma->vm_start)
-		        largest_hole = vma->vm_start - addr;
+			largest_hole = vma->vm_start - addr;
 
 		/* try just below the current vma->vm_start */
 		addr = (vma->vm_start - len) & huge_page_mask(h);
@@ -381,8 +336,7 @@ fail:
 	 */
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
-	addr = hugetlb_get_unmapped_area_bottomup(file, addr0,
-			len, pgoff, flags);
+	addr = unmapped_bottomup(file, addr0, len, pgoff, flags);
 
 	/*
 	 * Restore the topdown base:
@@ -420,16 +374,13 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 			return addr;
 	}
 	if (mm->get_unmapped_area == arch_get_unmapped_area)
-		return hugetlb_get_unmapped_area_bottomup(file, addr, len,
-				pgoff, flags);
+		return unmapped_bottomup(file, addr, len, pgoff, flags);
 	else
-		return hugetlb_get_unmapped_area_topdown(file, addr, len,
-				pgoff, flags);
+		return unmapped_topdown(file, addr, len, pgoff, flags);
 }
 
 #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
 
-#ifdef CONFIG_X86_64
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
@@ -438,11 +389,9 @@ static __init int setup_hugepagesz(char *opt)
 	} else if (ps == PUD_SIZE && cpu_has_gbpages) {
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	} else {
-		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
-			ps >> 20);
+		pr_err("hugepagesz: Unsupported page size %lu M\n", ps >> 20);
 		return 0;
 	}
 	return 1;
 }
 __setup("hugepagesz=", setup_hugepagesz);
-#endif
-- 
1.6.0.6



