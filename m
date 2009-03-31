Return-Path: <linux-kernel-owner+w=401wt.eu-S1765517AbZCaXk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765517AbZCaXk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764357AbZCaXXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:23:04 -0400
Received: from sous-sol.org ([216.99.217.87]:52983 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764296AbZCaXXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:23:01 -0400
Message-Id: <20090331231756.244863897@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 41/45] VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=vm-x86-pat-change-is_linear_pfn_mapping-to-not-use-vm_pgoff.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

upstream commit: 4bb9c5c02153dfc89a6c73a6f32091413805ad7d

Impact: fix false positive PAT warnings - also fix VirtalBox hang

Use of vma->vm_pgoff to identify the pfnmaps that are fully
mapped at mmap time is broken. vm_pgoff is set by generic mmap
code even for cases where drivers are setting up the mappings
at the fault time.

The problem was originally reported here:

 http://marc.info/?l=linux-kernel&m=123383810628583&w=2

Change is_linear_pfn_mapping logic to overload VM_INSERTPAGE
flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
time.

Problem also tracked at:

 http://bugzilla.kernel.org/show_bug.cgi?id=12800

Reported-by: Thomas Hellstrom <thellstrom@vmware.com>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: "ebiederm@xmission.com" <ebiederm@xmission.com>
Cc: <stable@kernel.org>
LKML-Reference: <20090313004527.GA7176@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/mm/pat.c  |    5 +++--
 include/linux/mm.h |   15 +++++++++++++--
 mm/memory.c        |    6 ++++--
 3 files changed, 20 insertions(+), 6 deletions(-)

--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -641,10 +641,11 @@ static int reserve_pfn_range(u64 paddr, 
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
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -98,7 +98,7 @@ extern unsigned int kobjsize(const void 
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
-#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
+#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it. Refer note in VM_PFNMAP_AT_MMAP below */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
@@ -127,6 +127,17 @@ extern unsigned int kobjsize(const void 
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
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1665,9 +1665,10 @@ int remap_pfn_range(struct vm_area_struc
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
@@ -1679,6 +1680,7 @@ int remap_pfn_range(struct vm_area_struc
 		 * needed from higher level routine calling unmap_vmas
 		 */
 		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
+		vma->vm_flags &= ~VM_PFNMAP_AT_MMAP;
 		return -EINVAL;
 	}
 

