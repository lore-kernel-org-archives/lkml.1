Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZDHWhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZDHWhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZDHWhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:37:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:55286 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZDHWhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,157,1239001200"; 
   d="scan'208";a="129470883"
Date: Wed, 8 Apr 2009 15:37:16 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.29 git master and PAT problems
Message-ID: <20090408223716.GC3493@linux-os.sc.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200904071112.28949.a.miskiewicz@gmail.com> <20090408013008.GA6696@linux-os.sc.intel.com> <200904080928.34580.a.miskiewicz@gmail.com> <20090408081711.GA4938@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408081711.GA4938@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 01:17:11AM -0700, Ingo Molnar wrote:
> 
> * Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:
> 
> > On Wednesday 08 of April 2009, Pallipadi, Venkatesh wrote:
> > > On Tue, Apr 07, 2009 at 02:12:28AM -0700, Arkadiusz Miskiewicz wrote:
> > > > On Tuesday 07 of April 2009, Pallipadi, Venkatesh wrote:
> > > > > On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz Miskiewicz wrote:
> > > > >
> > > > > I was finally able to reproduce the problem of "freeing invalid
> > > > > memtype" with upstream git kernel (commit 0221c81b1b) + latest xf86
> > > > > intel driver. But, with upstream + the patch I had sent you earlier in
> > > > > this thread (http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I
> > > > > don't see those freeing invalid memtype errors anymore.
> > > > >
> > > > > Can you please double check with current git and that patch and let me
> > > > > know if you are still seeing the problem.
> > > >
> > > > Latest linus tree + that patch (it's really applied here), xserver 1.6,
> > > > libdrm from git master, intel driver from git master, previously mesa 7.4
> > > > (and 7.5 snap currently), tremolous.net 1.1.0 game (tremolous-smp
> > > > binary), GM45 gpu.
> > > >
> > > > To reproduce I just need to run tremolous-smp and connect to some map.
> > > > When map finishes loading I instantly get:
> > [...]
> > 
> > > OK. One more test patch below, applies over linus's git and you can ignore
> > > the earlier patch. The patch below should get rid of the problem and
> > > as it removes the track/untrack of vm_insert_pfn completely. This will
> > > also eliminate the overhead of hundreds or thousands of entries in
> > > pat_memtype_list. Can you please test it.
> > 
> > With this patch I'm no longer able to reproduce problem. Thanks!
> 
> Great, thanks!
> 
> Venki, mind sending a patch with a proper changelog, Reported-by, 
> Tested-by tags, with Nick and Andrew Cc:-ed for the memory.c bits, 
> etc.?

Ingo,

Below is the cleaner version of the patch. It does not have any changes in mm
as we are only removing the tracking inside the PAT code. I have left the
generic mm interface as is, until we fully resolve the issue in future.

Thanks,
Venki

Subject: [PATCH] x86, PAT: Remove page granularity tracking for vm_insert_pfn maps

Remove page level granularity track and untrack of vm_insert_pfn.
memtype tracking at page granularity does not scale and cleaner
approach would be for the driver to request a type for a bigger
IO address range or PCI io memory range for that device, either at
mmap time or driver init time and just use that type during
vm_insert_pfn.

This patch just removes the track/untrack of vm_insert_pfn. That
means we will be in same state as 2.6.28, with respect to these APIs.
Newer APIs for the drivers to request a memtype for a bigger region
is TBD and coming soon.

This change resolves the problem of too many single page entries
in pat_memtype_list and "freeing invalid memtype" errors with i915,
reported here.
http://marc.info/?l=linux-kernel&m=123845244713183&w=2

Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Tested-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c |   98 ++++++++++------------------------------------------
 1 files changed, 19 insertions(+), 79 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..a8365c8 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -734,29 +734,28 @@ static void free_pfn_range(u64 paddr, unsigned long size)
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
@@ -764,28 +763,7 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
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
@@ -795,50 +773,28 @@ cleanup_ret:
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
@@ -849,39 +805,23 @@ cleanup_ret:
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
-- 
1.6.0.6

