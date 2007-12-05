Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXLEHzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXLEHzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXLEHzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:38634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071627.143603000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:51 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [patch 04/18] uio: nopage
Content-Disposition: inline; filename=uio-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert uio from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/uio/uio.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/uio/uio.c
===================================================================
--- linux-2.6.orig/drivers/uio/uio.c
+++ linux-2.6/drivers/uio/uio.c
@@ -412,30 +412,28 @@ static void uio_vma_close(struct vm_area
 	idev->vma_count--;
 }
 
-static struct page *uio_vma_nopage(struct vm_area_struct *vma,
-				   unsigned long address, int *type)
+static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
-	struct page* page = NOPAGE_SIGBUS;
+	struct page *page;
 
 	int mi = uio_find_mem_index(vma);
 	if (mi < 0)
-		return page;
+		return VM_FAULT_SIGBUS;
 
 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
 		page = virt_to_page(idev->info->mem[mi].addr);
 	else
 		page = vmalloc_to_page((void*)idev->info->mem[mi].addr);
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct uio_vm_ops = {
 	.open = uio_vma_open,
 	.close = uio_vma_close,
-	.nopage = uio_vma_nopage,
+	.fault = uio_vma_fault,
 };
 
 static int uio_mmap_physical(struct vm_area_struct *vma)

-- 

