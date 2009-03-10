Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZCJBkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZCJBkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZCJBj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:39:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:19779 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZCJBjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,332,1233561600"; 
   d="scan'208";a="671607197"
Date: Mon, 9 Mar 2009 18:39:54 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.29 pat issue
Message-ID: <20090310013953.GA11312@linux-os.sc.intel.com>
References: <498ADFE3.9020907@vmware.com> <1233856988.4286.83.camel@localhost.localdomain> <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org> <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com> <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 03:44:07PM -0800, Thomas Hellstrom wrote:
> 
> We get the warning when we insert RAM pages using vm_insert_pfn().
> Having normal RAM pages backing a PFN papping is a valid thing.
> 

OK. Below is the updated patch that should fix this fully. Can you confirm?

Thanks,
Venki

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH] VM, x86 PAT: Change implementation of is_linear_pfn_mapping

Use of vma->vm_pgoff to identify the pfnmaps that are fully mapped at
mmap time is broken, as vm_pgoff can also be set when full mapping is
not setup at mmap time.
http://marc.info/?l=linux-kernel&m=123383810628583&w=2

Change the logic to overload VM_NONLINEAR flag along with VM_PFNMAP to
mean full mapping setup at mmap time. This distinction is needed by
x86 PAT code.

Regression reported at
http://bugzilla.kernel.org/show_bug.cgi?id=12800

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c  |    5 +++--
 include/linux/mm.h |    8 +++++++-
 mm/memory.c        |    6 ++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2ed3715..640339e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -677,10 +677,11 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
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
index 065cdf8..6c3fc3a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -127,6 +127,12 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)
 
 /*
+ * pfnmap vmas that are fully mapped at mmap time (not mapped on fault).
+ * Used by x86 PAT to identify such PFNMAP mappings and optimize their handling.
+ */
+#define VM_PFNMAP_AT_MMAP (VM_NONLINEAR | VM_PFNMAP)
+
+/*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
@@ -145,7 +151,7 @@ extern pgprot_t protection_map[16];
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



