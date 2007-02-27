Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXB0Inu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXB0Inu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161062AbXB0InX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:43:23 -0500
Received: from gw.goop.org ([64.81.55.164]:46841 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbXB0Iib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:31 -0500
Message-Id: <20070227081635.287578759@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       "Jan Beulich" <JBeulich@novell.com>
Subject: [patch 16/26] Xen-paravirt_ops: Allocate and free vmalloc areas
Content-Disposition: inline; filename=alloc-vm-area.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate/destroy a 'vmalloc' VM area: alloc_vm_area and free_vm_area
The alloc function ensures that page tables are constructed for the
region of kernel virtual address space and mapped into init_mm.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: "Andi Kleen" <ak@muc.de>

---
 arch/i386/mm/fault.c    |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/vmalloc.h |    4 ++++
 2 files changed, 47 insertions(+)

===================================================================
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -624,3 +625,45 @@ void _vmalloc_sync_all(void)
 			start = address + PGDIR_SIZE;
 	}
 }
+
+
+static int f(pte_t *pte, struct page *pmd_page, unsigned long addr, void *data)
+{
+	/* apply_to_page_range() does all the hard work. */
+	return 0;
+}
+
+struct vm_struct *alloc_vm_area(unsigned long size)
+{
+	struct vm_struct *area;
+
+	area = get_vm_area(size, VM_IOREMAP);
+	if (area == NULL)
+		return NULL;
+
+	/*
+	 * This ensures that page tables are constructed for this region
+	 * of kernel virtual address space and mapped into init_mm.
+	 */
+	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
+				area->size, f, NULL)) {
+		free_vm_area(area);
+		return NULL;
+	}
+
+	/* Make sure the pagetables are constructed in process kernel
+	   mappings */
+	vmalloc_sync_all();
+
+	return area;
+}
+EXPORT_SYMBOL_GPL(alloc_vm_area);
+
+void free_vm_area(struct vm_struct *area)
+{
+	struct vm_struct *ret;
+	ret = remove_vm_area(area->addr);
+	BUG_ON(ret != area);
+	kfree(area);
+}
+EXPORT_SYMBOL_GPL(free_vm_area);
===================================================================
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -68,6 +68,10 @@ extern int map_vm_area(struct vm_struct 
 			struct page ***pages);
 extern void unmap_vm_area(struct vm_struct *area);
 
+/* Allocate/destroy a 'vmalloc' VM area. */
+extern struct vm_struct *alloc_vm_area(unsigned long size);
+extern void free_vm_area(struct vm_struct *area);
+
 /*
  *	Internals.  Dont't use..
  */

-- 

