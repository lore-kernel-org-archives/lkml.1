Return-Path: <linux-kernel-owner+w=401wt.eu-S936923AbZDIWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936923AbZDIWLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761207AbZDIWLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:11:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:36773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZDIWLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,163,1239001200"; 
   d="scan'208";a="446627395"
Message-Id: <20090409212708.373330000@intel.com>
References: <20090409212646.511925000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 14:26:47 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/6] x86, CPA: Change idmap attribute before ioremap attribute setup
Content-Disposition: inline; filename=0001-x86-CPA-Change-idmap-attribute-before-ioremap-attr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/6] x86, CPA: Change idmap attribute before ioremap attribute setup

Change the identity mapping with the requested attribute first, before
we setup the virtual memory mapping with the new requested attribute.
This makes sure that there is no window when identity map'ed attribute
may disagree with ioremap range on the attribute type.
This also avoids doing cpa on the ioremap'ed address twice (first in
ioremap_page_range and then in ioremap_change_attr using vaddr), and
should improve ioremap performance a bit.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/ioremap.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0dfa09d..329387e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -280,15 +280,16 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return NULL;
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
-	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
+
+	if (kernel_map_sync_memtype(phys_addr, size, prot_val)) {
 		free_memtype(phys_addr, phys_addr + size);
 		free_vm_area(area);
 		return NULL;
 	}
 
-	if (ioremap_change_attr(vaddr, size, prot_val) < 0) {
+	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
 		free_memtype(phys_addr, phys_addr + size);
-		vunmap(area->addr);
+		free_vm_area(area);
 		return NULL;
 	}
 
-- 
1.6.0.6

-- 

