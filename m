Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZCNI43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZCNI43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZCNI4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:56:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:50489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbZCNI4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:56:05 -0400
Date: Sat, 14 Mar 2009 08:54:34 GMT
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, hpa@zytor.com,
       mingo@redhat.com, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313233543.GA19909@linux-os.sc.intel.com>
References: <20090313233543.GA19909@linux-os.sc.intel.com>
Subject: [tip:x86/urgent] VM, x86, PAT: add a new vm flag to track full pfnmap at mmap
Message-ID: <tip-895791dac6946d535991edd11341046f8e85ea77@git.kernel.org>
Git-Commit-ID: 895791dac6946d535991edd11341046f8e85ea77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 08:54:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  895791dac6946d535991edd11341046f8e85ea77
Gitweb:     http://git.kernel.org/tip/895791dac6946d535991edd11341046f8e85ea77
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Fri, 13 Mar 2009 16:35:44 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 09:47:44 +0100

VM, x86, PAT: add a new vm flag to track full pfnmap at mmap

Impact: cleanup

Add a new vm flag VM_PFN_AT_MMAP to identify a PFNMAP that is
fully mapped with remap_pfn_range. Patch removes the overloading
of VM_INSERTPAGE from the earlier patch.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Nick Piggin <npiggin@suse.de>
LKML-Reference: <20090313233543.GA19909@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index d7df5ba..2032ad2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1667,7 +1667,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 	 */
 	if (addr == vma->vm_start && end == vma->vm_end) {
 		vma->vm_pgoff = pfn;
-		vma->vm_flags |= VM_PFNMAP_AT_MMAP;
+		vma->vm_flags |= VM_PFN_AT_MMAP;
 	} else if (is_cow_mapping(vma->vm_flags))
 		return -EINVAL;
 
@@ -1680,7 +1680,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		 * needed from higher level routine calling unmap_vmas
 		 */
 		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
-		vma->vm_flags &= ~VM_PFNMAP_AT_MMAP;
+		vma->vm_flags &= ~VM_PFN_AT_MMAP;
 		return -EINVAL;
 	}
 
