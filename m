Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYKLXYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYKLXYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbYKLXUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:1030 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbYKLXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="462383881"
Message-Id: <20081112212900.009132000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:48 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/8] x86 PAT: store vm_pgoff for all linear_over_vma_region mappings
Content-Disposition: inline; filename=mm_vm_pgoff_changes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers use mmap followed by pgprot_* and remap_pfn_range or vm_insert_pfn,
in order to export reserved memory to userspace. Currently, such mappings are
not tracked and hence not kept consistent with other mappings (/dev/mem,
pci resource, ioremap) for the sme memory, that may exist in the system.

The following patchset adds x86 PAT attribute tracking and untracking for
pfnmap related APIs.

First four patches in the patchset are changing the generic mm code to fit
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

Index: tip/mm/memory.c
===================================================================
--- tip.orig/mm/memory.c	2008-11-06 09:44:18.000000000 -0800
+++ tip/mm/memory.c	2008-11-10 09:44:49.000000000 -0800
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
 
Index: tip/include/linux/mm.h
===================================================================
--- tip.orig/include/linux/mm.h	2008-11-06 09:44:18.000000000 -0800
+++ tip/include/linux/mm.h	2008-11-10 09:44:47.000000000 -0800
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

