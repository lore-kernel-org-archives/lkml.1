Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZDRJIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZDRJIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZDRJI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:08:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbZDRJIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:08:25 -0400
Date: Sat, 18 Apr 2009 11:08:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David John <davidjon@xenontk.org>, stable@kernel.org
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [for stable] x86, PAT: Remove page granularity tracking for
	vm_insert_pfn maps
Message-ID: <20090418090804.GL7678@elte.hu>
References: <49E6D8FE.80908@xenontk.org> <86802c440904160018j5c4842d8t92742b6a1b2e4514@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC46587A0784@orsmsx505.amr.corp.intel.com> <49E967E7.5070800@xenontk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E967E7.5070800@xenontk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David John <davidjon@xenontk.org> wrote:

> On 04/16/2009 11:08 PM, Pallipadi, Venkatesh wrote:
> > 
> > Specifically the patch here will help (not sure whether it cleanly applies over 29.1.
> > 
> > http://marc.info/?l=linux-kernel&m=123923026401648&w=2
> > 
> > Thanks,
> > Venki
> >  
> 
> Thanks Venkatesh, that patch fixes the problem. This should be 
> submitted to -stable as I know at least one other person who has 
> this regression and the latest Fedora kernels have the problem as 
> well.

It's now upstream via:

4b06504: x86, PAT: Remove page granularity tracking for vm_insert_pfn maps

also attached below. It cherry-picks fine on top of v2.6.29.

	Ingo

----------->
>From 4b065046273afa01ec8e3de7da407e8d3599251d Mon Sep 17 00:00:00 2001
From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date: Wed, 8 Apr 2009 15:37:16 -0700
Subject: [PATCH] x86, PAT: Remove page granularity tracking for vm_insert_pfn maps

This change resolves the problem of too many single page entries
in pat_memtype_list and "freeing invalid memtype" errors with i915,
reported here:

  http://marc.info/?l=linux-kernel&m=123845244713183&w=2

Remove page level granularity track and untrack of vm_insert_pfn.
memtype tracking at page granularity does not scale and cleaner
approach would be for the driver to request a type for a bigger
IO address range or PCI io memory range for that device, either at
mmap time or driver init time and just use that type during
vm_insert_pfn.

This patch just removes the track/untrack of vm_insert_pfn. That
means we will be in same state as 2.6.28, with respect to these APIs.

Newer APIs for the drivers to request a memtype for a bigger region
is coming soon.

[ Impact: fix Xorg startup warnings and hangs ]

Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Tested-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <20090408223716.GC3493@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pat.c |   98 ++++++++++------------------------------------------
 1 files changed, 19 insertions(+), 79 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index cc5e0e2..41c8057 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -669,29 +669,28 @@ static void free_pfn_range(u64 paddr, unsigned long size)
  *
  * If the vma has a linear pfn mapping for the entire range, we get the prot
  * from pte and reserve the entire vma range with single reserve_pfn_range call.
- * Otherwise, we reserve the entire vma range, my ging through the PTEs page
- * by page to get physical address and protection.
  */
 int track_pfn_vma_copy(struct vm_area_struct *vma)
 {
-	int retval = 0;
-	unsigned long i, j;
 	resource_size_t paddr;
 	unsigned long prot;
-	unsigned long vma_start = vma->vm_start;
-	unsigned long vma_end = vma->vm_end;
-	unsigned long vma_size = vma_end - vma_start;
+	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
 
+	/*
+	 * For now, only handle remap_pfn_range() vmas where
+	 * is_linear_pfn_mapping() == TRUE. Handling of
+	 * vm_insert_pfn() is TBD.
+	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/*
 		 * reserve the whole chunk covered by vma. We need the
 		 * starting address and protection from pte.
 		 */
-		if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
+		if (follow_phys(vma, vma->vm_start, 0, &prot, &paddr)) {
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
@@ -699,28 +698,7 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
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
 	return 0;
-
-cleanup_ret:
-	/* Reserve error: Cleanup partial reservation and return error */
-	for (j = 0; j < i; j += PAGE_SIZE) {
-		if (follow_phys(vma, vma_start + j, 0, &prot, &paddr))
-			continue;
-
-		free_pfn_range(paddr, PAGE_SIZE);
-	}
-
-	return retval;
 }
 
 /*
@@ -730,50 +708,28 @@ cleanup_ret:
  * prot is passed in as a parameter for the new mapping. If the vma has a
  * linear pfn mapping for the entire range reserve the entire vma range with
  * single reserve_pfn_range call.
- * Otherwise, we look t the pfn and size and reserve only the specified range
- * page by page.
- *
- * Note that this function can be called with caller trying to map only a
- * subrange/page inside the vma.
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
+	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
 	if (!pat_enabled)
 		return 0;
 
+	/*
+	 * For now, only handle remap_pfn_range() vmas where
+	 * is_linear_pfn_mapping() == TRUE. Handling of
+	 * vm_insert_pfn() is TBD.
+	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
 		return reserve_pfn_range(paddr, vma_size, prot, 0);
 	}
 
-	/* reserve page by page using pfn and size */
-	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
-	for (i = 0; i < size; i += PAGE_SIZE) {
-		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
-		if (retval)
-			goto cleanup_ret;
-	}
 	return 0;
-
-cleanup_ret:
-	/* Reserve error: Cleanup partial reservation and return error */
-	for (j = 0; j < i; j += PAGE_SIZE) {
-		paddr = base_paddr + j;
-		free_pfn_range(paddr, PAGE_SIZE);
-	}
-
-	return retval;
 }
 
 /*
@@ -784,39 +740,23 @@ cleanup_ret:
 void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size)
 {
-	unsigned long i;
 	resource_size_t paddr;
-	unsigned long prot;
-	unsigned long vma_start = vma->vm_start;
-	unsigned long vma_end = vma->vm_end;
-	unsigned long vma_size = vma_end - vma_start;
+	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
 	if (!pat_enabled)
 		return;
 
+	/*
+	 * For now, only handle remap_pfn_range() vmas where
+	 * is_linear_pfn_mapping() == TRUE. Handling of
+	 * vm_insert_pfn() is TBD.
+	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/* free the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
 		free_pfn_range(paddr, vma_size);
 		return;
 	}
-
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
-	}
 }
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
