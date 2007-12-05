Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXLEIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXLEIAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbXLEHzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:38672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXLEHzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:12 -0500
Message-Id: <20071205071627.900265000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:58 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: rolandd@cisco.com, mshefty@ichips.intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [patch 11/18] ib: nopage
Content-Disposition: inline; filename=ib-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert IB from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: rolandd@cisco.com
Cc: mshefty@ichips.intel.com
Cc: hal.rosenstock@gmail.com
Cc: general@lists.openfabrics.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/infiniband/hw/ipath/ipath_debug.h    |    4 +--
 drivers/infiniband/hw/ipath/ipath_file_ops.c |   29 +++++++++------------------
 2 files changed, 12 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_file_ops.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1120,33 +1120,24 @@ bail:
 }
 
 /*
- * ipath_file_vma_nopage - handle a VMA page fault.
+ * ipath_file_vma_fault - handle a VMA page fault.
  */
-static struct page *ipath_file_vma_nopage(struct vm_area_struct *vma,
-					  unsigned long address, int *type)
+static int ipath_file_vma_fault(struct vm_area_struct *vma,
+					struct vm_fault *vmf)
 {
-	unsigned long offset = address - vma->vm_start;
-	struct page *page = NOPAGE_SIGBUS;
-	void *pageptr;
+	struct page *page;
 
-	/*
-	 * Convert the vmalloc address into a struct page.
-	 */
-	pageptr = (void *)(offset + (vma->vm_pgoff << PAGE_SHIFT));
-	page = vmalloc_to_page(pageptr);
+	page = vmalloc_to_page((void *)(vmf->pgoff << PAGE_SHIFT));
 	if (!page)
-		goto out;
-
-	/* Increment the reference count. */
+		return VM_FAULT_SIGBUS;
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-out:
-	return page;
+	vmf->page = page;
+
+	return 0;
 }
 
 static struct vm_operations_struct ipath_file_vm_ops = {
-	.nopage = ipath_file_vma_nopage,
+	.fault = ipath_file_vma_fault,
 };
 
 static int mmap_kvaddr(struct vm_area_struct *vma, u64 pgaddr,
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_debug.h
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_debug.h
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_debug.h
@@ -55,7 +55,7 @@
 #define __IPATH_PKTDBG      0x80	/* print packet data */
 /* print process startup (init)/exit messages */
 #define __IPATH_PROCDBG     0x100
-/* print mmap/nopage stuff, not using VDBG any more */
+/* print mmap/fault stuff, not using VDBG any more */
 #define __IPATH_MMDBG       0x200
 #define __IPATH_ERRPKTDBG   0x400
 #define __IPATH_USER_SEND   0x1000	/* use user mode send */
@@ -81,7 +81,7 @@
 #define __IPATH_VERBDBG   0x0	/* very verbose debug */
 #define __IPATH_PKTDBG    0x0	/* print packet data */
 #define __IPATH_PROCDBG   0x0	/* process startup (init)/exit messages */
-/* print mmap/nopage stuff, not using VDBG any more */
+/* print mmap/fault stuff, not using VDBG any more */
 #define __IPATH_MMDBG     0x0
 #define __IPATH_EPKTDBG   0x0	/* print ethernet packet data */
 #define __IPATH_IPATHDBG  0x0	/* Ethernet (IPATH) table dump on */

-- 

