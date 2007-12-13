Return-Path: <linux-kernel-owner+w=401wt.eu-S933390AbXLMX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbXLMX5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761016AbXLMX5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:57:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:62004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759404AbXLMX5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:57:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="295508599"
Message-Id: <20071213235712.123682000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:48 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 05/12] PAT 64b: pci mmap conlfict patch
Content-Disposition: inline; filename=pci-mmap-conflict.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward port of pci-mmap-conflict.patch to x86 tree.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc4/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/pci/i386.c	2007-12-11 15:08:12.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/pci/i386.c	2007-12-11 15:43:14.000000000 -0800
@@ -30,6 +30,8 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/errno.h>
+#include <asm/pat.h>
+#include <asm/cacheflush.h>
 
 #include "pci.h"
 
@@ -297,9 +299,25 @@
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 
+static void pci_unmap_page_range(struct vm_area_struct *vma)
+{
+	u64 adr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	free_mattr(adr, adr + vma->vm_end - vma->vm_start,
+		pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK);
+}
+
+static struct vm_operations_struct pci_mmap_ops = {
+	.close = pci_unmap_page_range
+};
+
 int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			enum pci_mmap_state mmap_state, int write_combine)
 {
+	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long len = vma->vm_end - vma->vm_start;
+	unsigned long attr;
+	int err;
+
 	/* I/O space cannot be accessed via normal processor loads and
 	 * stores on this platform.
 	 */
@@ -314,10 +332,24 @@
 	else
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
+	attr = pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK;
+	err = reserve_mattr(addr, addr+len, attr, NULL);
+	if (err)
+		return -EBUSY;
+
+	err = change_page_attr_addr(addr, len >> PAGE_SHIFT,
+				__pgprot(__PAGE_KERNEL | attr));
+	if (err) {
+		free_mattr(addr, addr+len, attr);
+		return err;
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
