Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752567AbYLRUDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbYLRUDw (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYLRUBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:27028 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYLRUBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="91793681"
Message-Id: <20081218194617.091839000@intel.com>
References: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:27 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/7] x86 PAT: store vm_pgoff for all linear_over_vma_region mappings - v3
Content-Disposition: inline; filename=mm_rfc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers use mmap followed by pgprot_* and remap_pfn_range or vm_insert_pfn,
in order to export reserved memory to userspace. Currently, such mappings are
not tracked and hence not kept consistent with other mappings (/dev/mem,
pci resource, ioremap) for the sme memory, that may exist in the system.

The following patchset adds x86 PAT attribute tracking and untracking for
pfnmap related APIs.

First three patches in the patchset are changing the generic mm code to fit
in this tracking. Last four patches are x86 specific to make things work
with x86 PAT code. The patchset aso introduces pgprot_writecombine interface,
which gives writecombine mapping when enabled, falling back to
pgprot_noncached otherwise.

This patch:

While working on x86 PAT, we faced some hurdles with trackking
remap_pfn_range() regions, as we do not have any information to say
whether that PFNMAP mapping is linear for the entire vma range or
it is smaller granularity regions within the vma.

A simple solution to this is to use vm_pgoff as an indicator for
linear mapping over the vma region. Currently, remap_pfn_range
only sets vm_pgoff for COW mappings. Below patch changes the
logic and sets the vm_pgoff irrespective of COW. This will still not
be enough for the case where pfn is zero (vma region mapped to
physical address zero). But, for all the other cases, we can look at
pfnmap VMAs and say whether the mappng is for the entire vma region
or not.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 include/linux/mm.h |    9 +++++++++
 mm/memory.c        |    7 +++----
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-12-17 17:24:31.000000000 -0800
+++ linux-2.6/mm/memory.c	2008-12-18 10:10:46.000000000 -0800
@@ -1575,11 +1575,10 @@ int remap_pfn_range(struct vm_area_struc
 	 * behaviour that some programs depend on. We mark the "original"
 	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
 	 */
-	if (is_cow_mapping(vma->vm_flags)) {
-		if (addr != vma->vm_start || end != vma->vm_end)
-			return -EINVAL;
+	if (addr == vma->vm_start && end == vma->vm_end)
 		vma->vm_pgoff = pfn;
-	}
+	else if (is_cow_mapping(vma->vm_flags))
+		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-12-17 17:24:31.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-12-18 10:10:46.000000000 -0800
@@ -145,6 +145,15 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
 
+static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
+{
+	return ((vma->vm_flags & VM_PFNMAP) && vma->vm_pgoff);
+}
+
+static inline int is_pfn_mapping(struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & VM_PFNMAP);
+}
 
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's

-- 

