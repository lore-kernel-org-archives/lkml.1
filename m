Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbZAJAZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbZAJAZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZAJAYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:24:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:1095 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724AbZAJAYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="98437557"
Message-Id: <20090110001404.429595000@intel.com>
References: <20090110001308.403550000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 Jan 2009 16:13:09 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       kjwinchester@gmail.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/6] x86 PAT: remove PFNMAP type on track_pfn_vma_new() error
Content-Disposition: inline; filename=pfn_cleaup_fix_02.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On track_pfn_vma_new() failure, reset the vm_flags so that there will be
no second cleanup happening when upper level routines call unmap_vmas().

This patch fixes part of the bug reported here
http://marc.info/?l=linux-kernel&m=123108883716357&w=2

Specifically the error message
X:5010 freeing invalid memtype d0000000-d0101000
Is due to multiple frees on error path, will not happen with the patch below.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 mm/memory.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: tip/mm/memory.c
===================================================================
--- tip.orig/mm/memory.c	2009-01-06 11:14:35.000000000 -0800
+++ tip/mm/memory.c	2009-01-06 13:44:57.000000000 -0800
@@ -1605,8 +1605,14 @@ int remap_pfn_range(struct vm_area_struc
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
 	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
-	if (err)
+	if (err) {
+		/*
+		 * To indicate that track_pfn related cleanup is not
+		 * needed from higher level routine calling unmap_vmas
+		 */
+		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
 		return -EINVAL;
+	}
 
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;

-- 

