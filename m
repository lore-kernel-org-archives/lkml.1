Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZCKRzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZCKRzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZCKRy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:54:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:33363 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZCKRy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:54:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,344,1233561600"; 
   d="scan'208";a="496981739"
Date: Wed, 11 Mar 2009 10:54:53 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH] VM, x86, PAT: Change implementation of is_linear_pfn_mapping
Message-ID: <20090311175452.GA1702@linux-os.sc.intel.com>
References: <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org> <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com> <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com> <20090310013953.GA11312@linux-os.sc.intel.com> <49B6232B.4050503@vmware.com> <1236706959.4529.56.camel@localhost.localdomain> <49B781B6.3060704@vmware.com> <20090311093338.GC12814@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311093338.GC12814@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use of vma->vm_pgoff to identify the pfnmaps that are fully
mapped at mmap time is broke. vm_pgoff is set by generic mmap
code even for cases where drivers are setting up the mappings
at the fault time.

The problem was originally reported here.
http://marc.info/?l=linux-kernel&m=123383810628583&w=2

Change is_linear_pfn_mapping logic to overload VM_NONLINEAR
flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
time.

Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha>@intel.com>
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
index 05fab3b..e6aced9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1675,9 +1675,10 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
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
@@ -1689,6 +1690,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		 * needed from higher level routine calling unmap_vmas
 		 */
 		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
+		vma->vm_flags &= ~VM_PFNMAP_AT_MMAP;
 		return -EINVAL;
 	}
 
-- 
1.6.0.6

