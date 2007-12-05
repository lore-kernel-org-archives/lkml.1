Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbXLEH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbXLEH4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXLEHzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:38649 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071628.007537000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:59 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: zaitcev@redhat.com, paolo.abeni@email.it, linux-kernel@vger.kernel.org
Subject: [patch 12/18] usb: mon nopage
Content-Disposition: inline; filename=usb-mon-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert USB mon driver from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: zaitcev@redhat.com
Cc: paolo.abeni@email.it
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/mon/mon_bin.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/usb/mon/mon_bin.c
===================================================================
--- linux-2.6.orig/drivers/usb/mon/mon_bin.c
+++ linux-2.6/drivers/usb/mon/mon_bin.c
@@ -1045,33 +1045,31 @@ static void mon_bin_vma_close(struct vm_
 /*
  * Map ring pages to user space.
  */
-struct page *mon_bin_vma_nopage(struct vm_area_struct *vma,
-                                unsigned long address, int *type)
+static int mon_bin_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
 	unsigned long offset, chunk_idx;
 	struct page *pageptr;
 
-	offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	chunk_idx = offset / CHUNK_SIZE;
 	pageptr = rp->b_vec[chunk_idx].pg;
 	get_page(pageptr);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return pageptr;
+	vmf->page = pageptr;
+	return 0;
 }
 
 struct vm_operations_struct mon_bin_vm_ops = {
 	.open =     mon_bin_vma_open,
 	.close =    mon_bin_vma_close,
-	.nopage =   mon_bin_vma_nopage,
+	.fault =    mon_bin_vma_fault,
 };
 
 int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	/* don't do anything here: "nopage" will set up page table entries */
+	/* don't do anything here: "fault" will set up page table entries */
 	vma->vm_ops = &mon_bin_vm_ops;
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_private_data = filp->private_data;

-- 

