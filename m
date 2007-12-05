Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbXLEH4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbXLEH4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbXLEHzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:14 -0500
Received: from ns2.suse.de ([195.135.220.15]:42666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071627.469118000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:54 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: [patch 07/18] v4l: nopage
Content-Disposition: inline; filename=v4l-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert v4l from nopage to fault.
Remove redundant vma range checks.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/video/videobuf-dma-sg.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/media/video/videobuf-dma-sg.c
===================================================================
--- linux-2.6.orig/drivers/media/video/videobuf-dma-sg.c
+++ linux-2.6/drivers/media/video/videobuf-dma-sg.c
@@ -385,30 +385,26 @@ videobuf_vm_close(struct vm_area_struct 
  * now ...).  Bounce buffers don't work very well for the data rates
  * video capture has.
  */
-static struct page*
-videobuf_vm_nopage(struct vm_area_struct *vma, unsigned long vaddr,
-		   int *type)
+static int
+videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page;
 
-	dprintk(3,"nopage: fault @ %08lx [vma %08lx-%08lx]\n",
-		vaddr,vma->vm_start,vma->vm_end);
-	if (vaddr > vma->vm_end)
-		return NOPAGE_SIGBUS;
+	dprintk(3,"fault: fault @ %08lx [vma %08lx-%08lx]\n",
+		(unsigned long)vmf->virtual_address,vma->vm_start,vma->vm_end);
 	page = alloc_page(GFP_USER | __GFP_DMA32);
 	if (!page)
-		return NOPAGE_OOM;
+		return VM_FAULT_OOM;
 	clear_user_page(page_address(page), vaddr, page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct videobuf_vm_ops =
 {
 	.open     = videobuf_vm_open,
 	.close    = videobuf_vm_close,
-	.nopage   = videobuf_vm_nopage,
+	.fault    = videobuf_vm_fault,
 };
 
 /* ---------------------------------------------------------------------

-- 

