Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYCSTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYCSTpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYCSTbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:31:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:26633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbYCSTaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="220204539"
Message-Id: <20080319000059.640728000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:19 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 07/13] x86: PAT use reserve free memtype in pci_mmap_page_range
Content-Disposition: inline; filename=use_reserve_free_memtype_pcimmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reserve_memtype and free_memtype wrapper for pci_mmap_page_range. Free
is called on unmap, but identity map continues to be mapped as per
pci_mmap_page_range request, until next request for the same region calls
ioremap_change_attr(), which will go through without conflict. This way of
mapping is identical to one used in ioremap/iounmap.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/pci/i386.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/pci/i386.c	2008-03-18 02:16:05.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/pci/i386.c	2008-03-18 03:29:39.000000000 -0700
@@ -30,6 +30,9 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/errno.h>
+#include <linux/bootmem.h>
+
+#include <asm/pat.h>
 
 #include "pci.h"
 
@@ -297,10 +300,34 @@
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 
+static void pci_unmap_page_range(struct vm_area_struct *vma)
+{
+	u64 addr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	free_memtype(addr, addr + vma->vm_end - vma->vm_start);
+}
+
+static void pci_track_mmap_page_range(struct vm_area_struct *vma)
+{
+	u64 addr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long flags = pgprot_val(vma->vm_page_prot)
+						& _PAGE_CACHE_MASK;
+
+	reserve_memtype(addr, addr + vma->vm_end - vma->vm_start, flags, NULL);
+}
+
+static struct vm_operations_struct pci_mmap_ops = {
+	.open  = pci_track_mmap_page_range,
+	.close = pci_unmap_page_range,
+};
+
 int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			enum pci_mmap_state mmap_state, int write_combine)
 {
 	unsigned long prot;
+	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long len = vma->vm_end - vma->vm_start;
+	unsigned long flags;
+	unsigned long new_flags;
 
 	/* I/O space cannot be accessed via normal processor loads and
 	 * stores on this platform.
@@ -308,21 +335,46 @@
 	if (mmap_state == pci_mmap_io)
 		return -EINVAL;
 
-	/* Leave vm_pgoff as-is, the PCI space address is the physical
-	 * address on this platform.
-	 */
 	prot = pgprot_val(vma->vm_page_prot);
-	if (boot_cpu_data.x86 > 3)
-		prot |= _PAGE_PCD | _PAGE_PWT;
+	if (pat_wc_enabled && write_combine)
+		prot |= _PAGE_CACHE_WC;
+	else if (boot_cpu_data.x86 > 3)
+		prot |= _PAGE_CACHE_UC;
+
 	vma->vm_page_prot = __pgprot(prot);
 
-	/* Write-combine setting is ignored, it is changed via the mtrr
-	 * interfaces on this platform.
-	 */
+	flags = pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK;
+	if (reserve_memtype(addr, addr + len, flags, &new_flags)) {
+		/*
+		 * Do not fallback to certain memory types with certain
+		 * requested type:
+		 * - request is uncached, return cannot be write-back
+		 * - request is uncached, return cannot be write-combine
+		 * - request is write-combine, return cannot be write-back
+		 */
+		if ((flags == _PAGE_CACHE_UC &&
+		     (new_flags == _PAGE_CACHE_WB ||
+		      new_flags == _PAGE_CACHE_WC)) ||
+		    (flags == _PAGE_CACHE_WC &&
+		     new_flags == _PAGE_CACHE_WB)) {
+			free_memtype(addr, addr+len);
+			return -EINVAL;
+		}
+		flags = new_flags;
+	}
+
+	if (vma->vm_pgoff <= max_pfn_mapped &&
+	    ioremap_change_attr((unsigned long)__va(addr), len, flags)) {
+		free_memtype(addr, addr + len);
+		return -EINVAL;
+	}
+
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot))
 		return -EAGAIN;
 
+	vma->vm_ops = &pci_mmap_ops;
+
 	return 0;
 }

-- 
