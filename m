Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZCMApk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZCMApk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZCMApb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:45:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:28762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbZCMApa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:45:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,354,1233561600"; 
   d="scan'208";a="672557614"
Date: Thu, 12 Mar 2009 17:45:27 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Frans Pop <elendil@planet.nl>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: [PATCH] VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff
Message-ID: <20090313004527.GA7176@linux-os.sc.intel.com>
References: <498B5ADE.3090602@vmware.com> <200903120645.44515.elendil@planet.nl> <20090312185918.GA22421@linux-os.sc.intel.com> <200903122130.23860.elendil@planet.nl> <1236898090.4529.80.camel@localhost.localdomain> <20090313003654.GA19544@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313003654.GA19544@elte.hu>
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

Change is_linear_pfn_mapping logic to overload VM_INSERTPAGE
flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
time.

Problem also tracked at
http://bugzilla.kernel.org/show_bug.cgi?id=12800

Reported-by: Thomas Hellstrom <thellstrom@vmware.com>
Tested-by: Frans Pop <elendil@planet.nl>
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

