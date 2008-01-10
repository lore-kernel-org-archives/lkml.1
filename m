Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbYAJSun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbYAJSun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbYAJSuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:50:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:41805 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbYAJSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:50:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="493433336"
Message-Id: <20080110184856.139099000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:48 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 08/11] PAT x86: pci mmap conlfict patch
Content-Disposition: inline; filename=pci-mmap-conflict.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward port of pci-mmap-conflict.patch to x86 tree.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Index: linux-2.6.git/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.git.orig/arch/x86/pci/i386.c	2008-01-08 04:30:53.000000000 -0800
+++ linux-2.6.git/arch/x86/pci/i386.c	2008-01-08 05:15:09.000000000 -0800
@@ -30,6 +30,8 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/errno.h>
+#include <asm/pat.h>
+#include <asm/cacheflush.h>
 
 #include "pci.h"
 
@@ -297,10 +299,37 @@
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 
+static void pci_unmap_page_range(struct vm_area_struct *vma)
+{
+	u64 adr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long flags = pgprot_val(vma->vm_page_prot)
+				& _PAGE_CACHE_MASK;
+	free_mattr(adr, adr + vma->vm_end - vma->vm_start, flags);
+}
+
+static void pci_track_mmap_page_range(struct vm_area_struct *vma)
+{
+	u64 adr = (u64)vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long flags = pgprot_val(vma->vm_page_prot)
+				& _PAGE_CACHE_MASK;
+
+	reserve_mattr(adr, adr + vma->vm_end - vma->vm_start, flags, NULL);
+}
+
+static struct vm_operations_struct pci_mmap_ops = {
+	.open  = pci_track_mmap_page_range,
+	.close = pci_unmap_page_range
+};
+
 int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			enum pci_mmap_state mmap_state, int write_combine)
 {
 	unsigned long prot;
+	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long len = vma->vm_end - vma->vm_start;
+	unsigned long attr;
+	int err;
+
 	/* I/O space cannot be accessed via normal processor loads and
 	 * stores on this platform.
 	 */
@@ -329,10 +358,25 @@
 		vma->vm_page_prot = __pgprot(prot);
 	}
 
+	attr = pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK;
+	err = reserve_mattr(addr, addr+len, attr, NULL);
+	if (err)
+		return -EBUSY;
+
+	err = change_page_attr_addr((unsigned long)__va(addr),
+	                            len >> PAGE_SHIFT,
+	                            __pgprot(__PAGE_KERNEL | attr));
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
