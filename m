Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXLENKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXLENKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 08:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXLENKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 08:10:09 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35642 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbXLENKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 08:10:08 -0500
Message-ID: <4756A31C.5060405@s5r6.in-berlin.de>
Date: Wed, 05 Dec 2007 14:09:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: npiggin@suse.de
CC: akpm@linux-foundation.org, krh@redhat.com,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/18] ieee1394: nopage
References: <20071205071547.701344000@nick.local0.net> <20071205071627.360419000@nick.local0.net>
In-Reply-To: <20071205071627.360419000@nick.local0.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de wrote:
> Convert ieee1394 from nopage to fault.
> Remove redundant vma range checks (correct resource range check is retained).

I never really looked into that part of the 1394 drivers and I'm too
lazy to figure this out myself, so I ask:  What would trip the .fault
handler?  Would be good if I could runtime-test it.

> Signed-off-by: Nick Piggin <npiggin@suse.de>
> Cc: krh@redhat.com

It's an obscure and unimportant detail but I mention it nevertheless:
It's not necessary to Cc krh on drivers/ieee1394 stuff.  He is more into
drivers/firewire. :-)

> Cc: stefanr@s5r6.in-berlin.de
> Cc: linux1394-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/ieee1394/dma.c |   39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/drivers/ieee1394/dma.c
> ===================================================================
> --- linux-2.6.orig/drivers/ieee1394/dma.c
> +++ linux-2.6/drivers/ieee1394/dma.c
> @@ -231,37 +231,32 @@ void dma_region_sync_for_device(struct d
>  
>  #ifdef CONFIG_MMU
>  
> -/* nopage() handler for mmap access */
> +/* fault() handler for mmap access */
>  
> -static struct page *dma_region_pagefault(struct vm_area_struct *area,
> -					 unsigned long address, int *type)
> +static int dma_region_pagefault(struct vm_area_struct *vma,
> +					struct vm_fault *vmf)
>  {
> -	unsigned long offset;
>  	unsigned long kernel_virt_addr;
> -	struct page *ret = NOPAGE_SIGBUS;
>  
> -	struct dma_region *dma = (struct dma_region *)area->vm_private_data;
> +	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
>  
>  	if (!dma->kvirt)
> -		goto out;
> +		goto error;
>  
> -	if ((address < (unsigned long)area->vm_start) ||
> -	    (address >
> -	     (unsigned long)area->vm_start + (dma->n_pages << PAGE_SHIFT)))
> -		goto out;
> -
> -	if (type)
> -		*type = VM_FAULT_MINOR;
> -	offset = address - area->vm_start;
> -	kernel_virt_addr = (unsigned long)dma->kvirt + offset;
> -	ret = vmalloc_to_page((void *)kernel_virt_addr);
> -	get_page(ret);
> -      out:
> -	return ret;
> +	if (vmf->pgoff >= dma->n_pages)
> +		goto error;
> +
> +	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
> +	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
> +	get_page(vmf->page);
> +	return 0;
> +
> +      error:
> +	return VM_FAULT_SIGBUS;
>  }

Why not replacing the two 'goto error' by 'return VM_FAULT_SIGBUS'?  If
there is no cleanup after that error jump, I find it sensible to return
early.

>  
>  static struct vm_operations_struct dma_region_vm_ops = {
> -	.nopage = dma_region_pagefault,
> +	.fault = dma_region_pagefault,
>  };
>  
>  /**
> @@ -275,7 +270,7 @@ int dma_region_mmap(struct dma_region *d
>  	if (!dma->kvirt)
>  		return -EINVAL;
>  
> -	/* must be page-aligned */
> +	/* must be page-aligned (XXX: comment is wrong, we could allow pgoff) */
>  	if (vma->vm_pgoff != 0)
>  		return -EINVAL;
>  

Are you sure that the comment is wrong?  Could it be that there are
assumptions elsewhere which require page alignment?  (I should be able
to answer that, but I'm not.)
-- 
Stefan Richter
-=====-=-=== ==-- --=-=
http://arcgraph.de/sr/
