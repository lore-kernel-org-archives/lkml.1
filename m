Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbZCMXfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbZCMXfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZCMXfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:35:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:15288 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZCMXfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,360,1233561600"; 
   d="scan'208";a="394405483"
Date: Fri, 13 Mar 2009 16:35:44 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "elendil@planet.nl" <elendil@planet.nl>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: [PATCH] Add a new vm flag to track full pfnmap at mmap
Message-ID: <20090313233543.GA19909@linux-os.sc.intel.com>
References: <20090313004527.GA7176@linux-os.sc.intel.com> <tip-4bb9c5c02153dfc89a6c73a6f32091413805ad7d@git.kernel.org> <20090313162530.GA7118@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313162530.GA7118@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new vm flag VM_PFN_AT_MMAP to identify a PFNMAP that is
fully mapped with remap_pfn_range. Patch removes the overloading
of VM_INSERTPAGE from the earlier patch.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/mm.h |   16 +++-------------
 mm/memory.c        |    4 ++--
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3daa05f..b1ea37f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -98,12 +98,13 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
-#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it. Refer note in VM_PFNMAP_AT_MMAP below */
+#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_SAO		0x20000000	/* Strong Access Ordering (powerpc) */
+#define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
@@ -127,17 +128,6 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)
 
 /*
- * pfnmap vmas that are fully mapped at mmap time (not mapped on fault).
- * Used by x86 PAT to identify such PFNMAP mappings and optimize their handling.
- * Note VM_INSERTPAGE flag is overloaded here. i.e,
- * VM_INSERTPAGE && !VM_PFNMAP implies
- *     The vma has had "vm_insert_page()" done on it
- * VM_INSERTPAGE && VM_PFNMAP implies
- *     The vma is PFNMAP with full mapping at mmap time
- */
-#define VM_PFNMAP_AT_MMAP (VM_INSERTPAGE | VM_PFNMAP)
-
-/*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
@@ -156,7 +146,7 @@ extern pgprot_t protection_map[16];
  */
 static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
 {
-	return ((vma->vm_flags & VM_PFNMAP_AT_MMAP) == VM_PFNMAP_AT_MMAP);
+	return (vma->vm_flags & VM_PFN_AT_MMAP);
 }
 
 static inline int is_pfn_mapping(struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index e6aced9..302591f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1677,7 +1677,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 	 */
 	if (addr == vma->vm_start && end == vma->vm_end) {
 		vma->vm_pgoff = pfn;
-		vma->vm_flags |= VM_PFNMAP_AT_MMAP;
+		vma->vm_flags |= VM_PFN_AT_MMAP;
 	} else if (is_cow_mapping(vma->vm_flags))
 		return -EINVAL;
 
@@ -1690,7 +1690,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		 * needed from higher level routine calling unmap_vmas
 		 */
 		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
-		vma->vm_flags &= ~VM_PFNMAP_AT_MMAP;
+		vma->vm_flags &= ~VM_PFN_AT_MMAP;
 		return -EINVAL;
 	}
 
-- 
1.6.0.6

