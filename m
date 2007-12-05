Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbXLEH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbXLEH5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbXLEHz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:26 -0500
Received: from mail.suse.de ([195.135.220.2]:38645 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071627.360419000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:53 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: krh@redhat.com, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [patch 06/18] ieee1394: nopage
Content-Disposition: inline; filename=ieee1394-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ieee1394 from nopage to fault.
Remove redundant vma range checks (correct resource range check is retained).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: krh@redhat.com
Cc: stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/ieee1394/dma.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/ieee1394/dma.c
===================================================================
--- linux-2.6.orig/drivers/ieee1394/dma.c
+++ linux-2.6/drivers/ieee1394/dma.c
@@ -231,37 +231,32 @@ void dma_region_sync_for_device(struct d
 
 #ifdef CONFIG_MMU
 
-/* nopage() handler for mmap access */
+/* fault() handler for mmap access */
 
-static struct page *dma_region_pagefault(struct vm_area_struct *area,
-					 unsigned long address, int *type)
+static int dma_region_pagefault(struct vm_area_struct *vma,
+					struct vm_fault *vmf)
 {
-	unsigned long offset;
 	unsigned long kernel_virt_addr;
-	struct page *ret = NOPAGE_SIGBUS;
 
-	struct dma_region *dma = (struct dma_region *)area->vm_private_data;
+	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
 
 	if (!dma->kvirt)
-		goto out;
+		goto error;
 
-	if ((address < (unsigned long)area->vm_start) ||
-	    (address >
-	     (unsigned long)area->vm_start + (dma->n_pages << PAGE_SHIFT)))
-		goto out;
-
-	if (type)
-		*type = VM_FAULT_MINOR;
-	offset = address - area->vm_start;
-	kernel_virt_addr = (unsigned long)dma->kvirt + offset;
-	ret = vmalloc_to_page((void *)kernel_virt_addr);
-	get_page(ret);
-      out:
-	return ret;
+	if (vmf->pgoff >= dma->n_pages)
+		goto error;
+
+	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
+	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
+	get_page(vmf->page);
+	return 0;
+
+      error:
+	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct dma_region_vm_ops = {
-	.nopage = dma_region_pagefault,
+	.fault = dma_region_pagefault,
 };
 
 /**
@@ -275,7 +270,7 @@ int dma_region_mmap(struct dma_region *d
 	if (!dma->kvirt)
 		return -EINVAL;
 
-	/* must be page-aligned */
+	/* must be page-aligned (XXX: comment is wrong, we could allow pgoff) */
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
 

-- 

