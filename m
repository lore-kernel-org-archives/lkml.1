Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYCSUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYCSUbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbYCSTjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:16661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002AbYCSTiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="263474490"
Message-Id: <20080319000059.205657000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:17 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 05/13] x86: PAT use reserve free memtype in ioremap and iounmap
Content-Disposition: inline; filename=use_reserve_free_memtype_ioremap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use reserve_memtype and free_memtype interfaces in ioremap/iounmap to avoid
aliasing.

If there is an existing alias for the region, inherit the memory type from
the alias. If there are conflicting aliases for the entire region, then fail
ioremap.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/ioremap.c	2008-03-18 03:14:09.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/ioremap.c	2008-03-18 09:20:36.000000000 -0700
@@ -20,6 +20,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
+#include <asm/pat.h>
 
 #ifdef CONFIG_X86_64
 
@@ -119,6 +120,7 @@
 {
 	unsigned long pfn, offset, last_addr, vaddr;
 	struct vm_struct *area;
+	unsigned long new_prot_val;
 	pgprot_t prot;
 	void __iomem *ret_addr;
 
@@ -153,6 +155,28 @@
 		WARN_ON_ONCE(is_ram);
 	}
 
+	/*
+	 * Mappings have to be page-aligned
+	 */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr+1) - phys_addr;
+
+	if (reserve_memtype(phys_addr, phys_addr + size,
+	                    prot_val, &new_prot_val)) {
+		/*
+		 * Do not fallback to certain memory types with certain
+		 * requested type:
+		 * - request is uncached, return cannot be write-back
+		 */
+		if ((prot_val == _PAGE_CACHE_UC &&
+		     new_prot_val == _PAGE_CACHE_WB)) {
+			free_memtype(phys_addr, phys_addr + size);
+			return NULL;
+		}
+		prot_val = new_prot_val;
+	}
+
 	switch (prot_val) {
 	case _PAGE_CACHE_UC:
 	default:
@@ -164,13 +188,6 @@
 	}
 
 	/*
-	 * Mappings have to be page-aligned
-	 */
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr+1) - phys_addr;
-
-	/*
 	 * Ok, go for it..
 	 */
 	area = get_vm_area(size, VM_IOREMAP);
@@ -179,11 +196,13 @@
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
 	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
+		free_memtype(phys_addr, phys_addr + size);
 		free_vm_area(area);
 		return NULL;
 	}
 
 	if (ioremap_change_attr(vaddr, size, prot_val) < 0) {
+		free_memtype(phys_addr, phys_addr + size);
 		vunmap(area->addr);
 		return NULL;
 	}
@@ -272,6 +291,8 @@
 		return;
 	}
 
+	free_memtype(p->phys_addr, p->phys_addr + get_vm_area_size(p));
+
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
 	BUG_ON(p != o || o == NULL);

-- 
