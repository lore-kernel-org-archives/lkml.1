Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYJWWJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYJWWJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYJWWJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:09:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:61243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbYJWWJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:09:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,472,1220252400"; 
   d="scan'208";a="395397291"
Date: Thu, 23 Oct 2008 15:09:14 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: npiggin@suse.de, hugh@veritas.com
Cc: apkm@linux-os.sc.intel.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC] remap_pfn_range: store vm_pgoff for all linear_over_vma_region mappings
Message-ID: <20081023220913.GA20300@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While working on x86 PAT, we are having some hurdles with tracking
remap_pfn_range() regions, as later we do not have any information to say
whether that PFNMAP mapping is linear for the entire vma range or
it is smaller granularity regions within the vma.

A simple solution to this is to use vm_pgoff as an indicator for
linear mapping over the vma region. Currently, remap_pfn_range
only sets vm_pgoff only for COW mappings. Below patch changes the
logic and sets the vm_pgoff irrespective of COW.

>From our understanding of the code, this should not break anyone.
Just sending it as an RFC to get feedback on whether it is OK to do
something like this or are there any corner cases that we may
break or watch out for.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-10-21 09:58:47.000000000 -0700
+++ linux-2.6/mm/memory.c	2008-10-23 13:38:26.000000000 -0700
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
 
