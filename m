Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbXLONFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbXLONFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 08:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXLONFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 08:05:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52446 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXLONFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 08:05:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 15 Dec 2007 14:04:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 06/18] ieee1394: nopage
To: Nick Piggin <npiggin@suse.de>
cc: akpm@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071205235149.GD5617@wotan.suse.de>
Message-ID: <tkrat.5bb86dc963ffef29@s5r6.in-berlin.de>
References: <20071205071547.701344000@nick.local0.net>
 <20071205071627.360419000@nick.local0.net>
 <4756A31C.5060405@s5r6.in-berlin.de> <20071205235149.GD5617@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  6 Dec, Nick Piggin wrote:
> On Wed, Dec 05, 2007 at 02:09:48PM +0100, Stefan Richter wrote:
>> npiggin@suse.de wrote:
>> > +	if (vmf->pgoff >= dma->n_pages)
>> > +		goto error;
>> > +
>> > +	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
>> > +	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
>> > +	get_page(vmf->page);
>> > +	return 0;
>> > +
>> > +      error:
>> > +	return VM_FAULT_SIGBUS;
>> >  }
>> 
>> Why not replacing the two 'goto error' by 'return VM_FAULT_SIGBUS'?  If
>> there is no cleanup after that error jump, I find it sensible to return
>> early.
> 
> Fair enough, I just didn't want to gamut of reactions from maintainers
> to my cleanups ;)


Subject: ieee1394: small cleanup after "nopage"

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dma.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: linux/drivers/ieee1394/dma.c
===================================================================
--- linux.orig/drivers/ieee1394/dma.c
+++ linux/drivers/ieee1394/dma.c
@@ -231,28 +231,20 @@ void dma_region_sync_for_device(struct d
 
 #ifdef CONFIG_MMU
 
-/* fault() handler for mmap access */
-
 static int dma_region_pagefault(struct vm_area_struct *vma,
-					struct vm_fault *vmf)
+				struct vm_fault *vmf)
 {
-	unsigned long kernel_virt_addr;
-
 	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
 
 	if (!dma->kvirt)
-		goto error;
+		return VM_FAULT_SIGBUS;
 
 	if (vmf->pgoff >= dma->n_pages)
-		goto error;
+		return VM_FAULT_SIGBUS;
 
-	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
-	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
+	vmf->page = vmalloc_to_page(dma->kvirt + (vmf->pgoff << PAGE_SHIFT));
 	get_page(vmf->page);
 	return 0;
-
-      error:
-	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct dma_region_vm_ops = {


-- 
Stefan Richter
-=====-=-=== ==-- -====
http://arcgraph.de/sr/

