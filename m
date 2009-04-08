Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbZDHBa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbZDHBa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbZDHBaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:30:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:4772 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417AbZDHBaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:30:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,340,1235980800"; 
   d="scan'208";a="401277880"
Date: Tue, 7 Apr 2009 18:30:08 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.29 git master and PAT problems
Message-ID: <20090408013008.GA6696@linux-os.sc.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200904020912.23071.a.miskiewicz@gmail.com> <1239058353.4529.7124.camel@localhost.localdomain> <200904071112.28949.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904071112.28949.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 02:12:28AM -0700, Arkadiusz Miskiewicz wrote:
> On Tuesday 07 of April 2009, Pallipadi, Venkatesh wrote:
> > On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz Miskiewicz wrote:
> >
> > I was finally able to reproduce the problem of "freeing invalid memtype"
> > with upstream git kernel (commit 0221c81b1b) + latest xf86 intel driver.
> > But, with upstream + the patch I had sent you earlier in this thread
> > (http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I don't see
> > those freeing invalid memtype errors anymore.
> >
> > Can you please double check with current git and that patch and let me
> > know if you are still seeing the problem.
> 
> Latest linus tree + that patch (it's really applied here), xserver 1.6, libdrm 
> from git master, intel driver from git master, previously mesa 7.4 (and 7.5 
> snap currently), tremolous.net 1.1.0 game (tremolous-smp binary), GM45 gpu.
> 
> To reproduce I just need to run tremolous-smp and connect to some map. When 
> map finishes loading I instantly get:
> 
>       1 [  132.341378] tremulous-smp:5554 freeing invalid memtype d570d000-
> d570e000
>       1 [  132.341394] tremulous-smp:5554 freeing invalid memtype d570e000-
> d570f000
>       1 [  132.341409] tremulous-smp:5554 freeing invalid memtype d570f000-
> d5710000
>       1 [  139.323677] X:5238 freeing invalid memtype d6168000-d6169000            
>       1 [  139.323698] X:5238 freeing invalid memtype d6169000-d616a000            
>       1 [  139.323722] X:5238 freeing invalid memtype d616a000-d616b000            
>       1 [  139.323742] X:5238 freeing invalid memtype d616b000-d616c000       
> 
> $ dmesg|grep "freeing invalid" | wc -l
> 6643
> 

OK. One more test patch below, applies over linus's git and you can ignore
the earlier patch. The patch below should get rid of the problem and
as it removes the track/untrack of vm_insert_pfn completely. This will
also eliminate the overhead of hundreds or thousands of entries in
pat_memtype_list. Can you please test it.

Thanks,
Venki

---
 arch/x86/mm/pat.c |  124 +++++++++++------------------------------------------
 mm/memory.c       |   14 +-----
 2 files changed, 29 insertions(+), 109 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..5992af2 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -732,15 +732,11 @@ static void free_pfn_range(u64 paddr, unsigned long size)
  * track_pfn_vma_copy is called when vma that is covering the pfnmap gets
  * copied through copy_page_range().
  *
- * If the vma has a linear pfn mapping for the entire range, we get the prot
- * from pte and reserve the entire vma range with single reserve_pfn_range call.
- * Otherwise, we reserve the entire vma range, my ging through the PTEs page
- * by page to get physical address and protection.
+ * We get the prot from pte and reserve the entire vma range with single
+ * reserve_pfn_range call.
  */
 int track_pfn_vma_copy(struct vm_area_struct *vma)
 {
-	int retval = 0;
-	unsigned long i, j;
 	resource_size_t paddr;
 	unsigned long prot;
 	unsigned long vma_start = vma->vm_start;
@@ -751,94 +747,35 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 	if (!pat_enabled)
 		return 0;
 
-	if (is_linear_pfn_mapping(vma)) {
-		/*
-		 * reserve the whole chunk covered by vma. We need the
-		 * starting address and protection from pte.
-		 */
-		if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
-			WARN_ON_ONCE(1);
-			return -EINVAL;
-		}
-		pgprot = __pgprot(prot);
-		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
-	}
-
-	/* reserve entire vma page by page, using pfn and prot from pte */
-	for (i = 0; i < vma_size; i += PAGE_SIZE) {
-		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
-			continue;
-
-		pgprot = __pgprot(prot);
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
-		if (retval)
-			goto cleanup_ret;
-	}
-	return 0;
-
-cleanup_ret:
-	/* Reserve error: Cleanup partial reservation and return error */
-	for (j = 0; j < i; j += PAGE_SIZE) {
-		if (follow_phys(vma, vma_start + j, 0, &prot, &paddr))
-			continue;
-
-		free_pfn_range(paddr, PAGE_SIZE);
+	/*
+	 * reserve the whole chunk covered by vma. We need the
+	 * starting address and protection from pte.
+	 */
+	if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
 	}
-
-	return retval;
+	pgprot = __pgprot(prot);
+	return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 }
 
 /*
  * track_pfn_vma_new is called when a _new_ pfn mapping is being established
  * for physical range indicated by pfn and size.
  *
- * prot is passed in as a parameter for the new mapping. If the vma has a
- * linear pfn mapping for the entire range reserve the entire vma range with
- * single reserve_pfn_range call.
- * Otherwise, we look t the pfn and size and reserve only the specified range
- * page by page.
- *
- * Note that this function can be called with caller trying to map only a
- * subrange/page inside the vma.
+ * prot is passed in as a parameter for the new mapping.
  */
 int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
-	int retval = 0;
-	unsigned long i, j;
-	resource_size_t base_paddr;
 	resource_size_t paddr;
-	unsigned long vma_start = vma->vm_start;
-	unsigned long vma_end = vma->vm_end;
-	unsigned long vma_size = vma_end - vma_start;
 
 	if (!pat_enabled)
 		return 0;
 
-	if (is_linear_pfn_mapping(vma)) {
-		/* reserve the whole chunk starting from vm_pgoff */
-		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot, 0);
-	}
-
-	/* reserve page by page using pfn and size */
-	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
-	for (i = 0; i < size; i += PAGE_SIZE) {
-		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
-		if (retval)
-			goto cleanup_ret;
-	}
-	return 0;
-
-cleanup_ret:
-	/* Reserve error: Cleanup partial reservation and return error */
-	for (j = 0; j < i; j += PAGE_SIZE) {
-		paddr = base_paddr + j;
-		free_pfn_range(paddr, PAGE_SIZE);
-	}
-
-	return retval;
+	/* reserve the whole chunk starting from pfn */
+	paddr = (resource_size_t)pfn << PAGE_SHIFT;
+	return reserve_pfn_range(paddr, vma->vm_end - vma->vm_start, prot, 0);
 }
 
 /*
@@ -849,7 +786,6 @@ cleanup_ret:
 void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size)
 {
-	unsigned long i;
 	resource_size_t paddr;
 	unsigned long prot;
 	unsigned long vma_start = vma->vm_start;
@@ -859,29 +795,21 @@ void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 	if (!pat_enabled)
 		return;
 
-	if (is_linear_pfn_mapping(vma)) {
-		/* free the whole chunk starting from vm_pgoff */
-		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		free_pfn_range(paddr, vma_size);
+	if (pfn) {
+		paddr = (resource_size_t)pfn << PAGE_SHIFT;
+		free_pfn_range(paddr, size);
 		return;
 	}
 
-	if (size != 0 && size != vma_size) {
-		/* free page by page, using pfn and size */
-		paddr = (resource_size_t)pfn << PAGE_SHIFT;
-		for (i = 0; i < size; i += PAGE_SIZE) {
-			paddr = paddr + i;
-			free_pfn_range(paddr, PAGE_SIZE);
-		}
-	} else {
-		/* free entire vma, page by page, using the pfn from pte */
-		for (i = 0; i < vma_size; i += PAGE_SIZE) {
-			if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
-				continue;
-
-			free_pfn_range(paddr, PAGE_SIZE);
-		}
+	/*
+	 * reserve the whole chunk covered by vma. We need the
+	 * starting address pte.
+	 */
+	if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
+		WARN_ON_ONCE(1);
+		return;
 	}
+	free_pfn_range(paddr, vma_size);
 }
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
diff --git a/mm/memory.c b/mm/memory.c
index cf6873e..4cae7e0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -719,7 +719,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (is_vm_hugetlb_page(vma))
 		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
 
-	if (unlikely(is_pfn_mapping(vma))) {
+	if (unlikely(is_linear_pfn_mapping(vma))) {
 		/*
 		 * We do not free on error cases below as remove_vma
 		 * gets called on error from higher level routine
@@ -982,7 +982,7 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 		if (vma->vm_flags & VM_ACCOUNT)
 			*nr_accounted += (end - start) >> PAGE_SHIFT;
 
-		if (unlikely(is_pfn_mapping(vma)))
+		if (unlikely(is_linear_pfn_mapping(vma)))
 			untrack_pfn_vma(vma, 0, 0);
 
 		while (start != end) {
@@ -1515,7 +1515,6 @@ out:
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn)
 {
-	int ret;
 	pgprot_t pgprot = vma->vm_page_prot;
 	/*
 	 * Technically, architectures with pte_special can avoid all these
@@ -1531,15 +1530,8 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_vma_new(vma, &pgprot, pfn, PAGE_SIZE))
-		return -EINVAL;
-
-	ret = insert_pfn(vma, addr, pfn, pgprot);
 
-	if (ret)
-		untrack_pfn_vma(vma, pfn, PAGE_SIZE);
-
-	return ret;
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vm_insert_pfn);
 
-- 
1.6.0.6

