Return-Path: <linux-kernel-owner+w=401wt.eu-S1763982AbXLMX6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763982AbXLMX6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764148AbXLMX5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:57:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:62004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763410AbXLMX5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:57:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="241552110"
Message-Id: <20071213235712.339088000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:49 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
Content-Disposition: inline; filename=ioremap_wc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward port of ioremap.patch to x86 tree.
 
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc4/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/mm/ioremap_64.c	2007-12-11 15:48:35.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/mm/ioremap_64.c	2007-12-11 15:49:52.000000000 -0800
@@ -147,7 +147,7 @@
 EXPORT_SYMBOL(__ioremap);
 
 /**
- * ioremap_nocache     -   map bus memory into CPU space
+ * ioremap_nocache     -   map bus memory into CPU space uncached
  * @offset:    bus address of the memory
  * @size:      size of the resource to map
  *
@@ -175,6 +175,30 @@
 EXPORT_SYMBOL(ioremap_nocache);
 
 /**
+ * ioremap_wc    -   map bus memory into CPU space write combined
+ * @offset:    bus address of the memory
+ * @size:      size of the resource to map
+ *
+ * ioremap_wc performs a platform specific sequence of operations to
+ * make bus memory CPU accessible via the readb/readw/readl/writeb/
+ * writew/writel functions and the other mmio helpers. The returned
+ * address is not guaranteed to be usable directly as a virtual
+ * address.
+ *
+ * This version of ioremap ensures that the memory is marked write combining.
+ * Write combining allows faster writes to some hardware devices.
+ * See also iounmap_nocache for more details.
+ *
+ * Must be freed with iounmap.
+ */
+void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
+{
+	return __ioremap(phys_addr, size, _PAGE_WC);
+}
+EXPORT_SYMBOL(ioremap_wc);
+
+
+/**
  * iounmap - Free a IO remapping
  * @addr: virtual address from ioremap_*
  *
Index: linux-2.6.24-rc4/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-x86/io_64.h	2007-12-11 14:24:56.000000000 -0800
+++ linux-2.6.24-rc4/include/asm-x86/io_64.h	2007-12-11 15:49:52.000000000 -0800
@@ -142,7 +142,8 @@
  * it's useful if some control registers are in such an area and write combining
  * or read caching is not desirable:
  */
-extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
+extern void __iomem * ioremap_nocache(unsigned long offset, unsigned long size);
+extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);
 extern void iounmap(volatile void __iomem *addr);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 

-- 
