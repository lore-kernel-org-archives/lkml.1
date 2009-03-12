Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZCLS7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZCLS7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZCLS7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:59:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:47432 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZCLS7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:59:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,352,1233561600"; 
   d="scan'208";a="497321049"
Date: Thu, 12 Mar 2009 11:59:19 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [PATCH] VM, x86, PAT: Change implementation of is_linear_pfn_mapping
Message-ID: <20090312185918.GA22421@linux-os.sc.intel.com>
References: <498B5ADE.3090602@vmware.com> <200903112309.40145.elendil@planet.nl> <1236817912.4529.76.camel@localhost.localdomain> <200903120645.44515.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903120645.44515.elendil@planet.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:45:42PM -0700, Frans Pop wrote:
> On Thursday 12 March 2009, Pallipadi, Venkatesh wrote:
> > Thanks for testing this. I don't seem to reproduce this on any of my
> > test systems with this patch on either tip or latest git. Do you see
> > the hang on every boot or once in a while? 
> 
> The problem only occurs after some time. In the case shown in the log the 
> system ran fine for 15 minutes and then triggered the oops.
> 
> In another case I was running VirtualBox. It ran fine for some time but 
> the system hung when I tried to close the guest system.
> 
> > Are things stable with nopat?
> 
> Yes. Seen no problems since booting with 'nopat' and done a successful 
> suspend/resume. With 'pat' I saw the problem 3 times after a short period 
> of use.
> 
> On Thursday 12 March 2009, you wrote:
> > Thinking about it a bit more, the usage of VM_NONLINEAR flag in
> > this patch may be conflicting with some expectation in
> > mm code, that may be resulting in above oops. Let me
> > spend some more time on this and get back to you.
> 

OK, Looking more at the code, I now understand how the patch from
yday resulted in the oops you saw. Here goes my nth attempt at solving
this problem. Can you please test this patch.

Thanks,
Venki

Use of vma->vm_pgoff to identify the pfnmaps that are fully
mapped at mmap time is broken. vm_pgoff is set by generic mmap
code even for cases where drivers are setting up the mappings
at the fault time.

The problem was originally reported here.
http://marc.info/?l=linux-kernel&m=123383810628583&w=2

Change is_linear_pfn_mapping logic to overload VM_INSERTPAGE
flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
time.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha>@intel.com>
---
 arch/x86/mm/pat.c  |    5 +++--
 include/linux/mm.h |   15 +++++++++++++--
 mm/memory.c        |    6 ++++--
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e0ab173..21bc1f7 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -641,10 +641,11 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 
 	/*
-	 * reserve_pfn_range() doesn't support RAM pages.
+	 * reserve_pfn_range() doesn't support RAM pages. Maintain the current
+	 * behavior with RAM pages by returning success.
 	 */
 	if (is_ram != 0)
-		return -EINVAL;
+		return 0;
 
 	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
 	if (ret)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 065cdf8..3daa05f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -98,7 +98,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
-#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
+#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it. Refer note in VM_PFNMAP_AT_MMAP below */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
@@ -127,6 +127,17 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)
 
 /*
+ * pfnmap vmas that are fully mapped at mmap time (not mapped on fault).
+ * Used by x86 PAT to identify such PFNMAP mappings and optimize their handling.
+ * Note VM_INSERTPAGE flag is overloaded here. i.e,
+ * VM_INSERTPAGE && !VM_PFNMAP implies
+ *     The vma has had "vm_insert_page()" done on it
+ * VM_INSERTPAGE && VM_PFNMAP implies
+ *     The vma is PFNMAP with full mapping at mmap time
+ */
+#define VM_PFNMAP_AT_MMAP (VM_INSERTPAGE | VM_PFNMAP)
+
+/*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
@@ -145,7 +156,7 @@ extern pgprot_t protection_map[16];
  */
 static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
 {
-	return ((vma->vm_flags & VM_PFNMAP) && vma->vm_pgoff);
+	return ((vma->vm_flags & VM_PFNMAP_AT_MMAP) == VM_PFNMAP_AT_MMAP);
 }
 
 static inline int is_pfn_mapping(struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index baa999e..d7df5ba 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1665,9 +1665,10 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 	 * behaviour that some programs depend on. We mark the "original"
 	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
 	 */
-	if (addr == vma->vm_start && end == vma->vm_end)
+	if (addr == vma->vm_start && end == vma->vm_end) {
 		vma->vm_pgoff = pfn;
-	else if (is_cow_mapping(vma->vm_flags))
+		vma->vm_flags |= VM_PFNMAP_AT_MMAP;
+	} else if (is_cow_mapping(vma->vm_flags))
 		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
@@ -1679,6 +1680,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		 * needed from higher level routine calling unmap_vmas
 		 */
 		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
+		vma->vm_flags &= ~VM_PFNMAP_AT_MMAP;
 		return -EINVAL;
 	}
 
-- 
1.6.0.6

