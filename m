Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbXLEKEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbXLEKEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXLEKE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:04:27 -0500
Received: from www.tglx.de ([62.245.132.106]:52101 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbXLEKE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:04:26 -0500
Date: Wed, 5 Dec 2007 11:04:08 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: npiggin@suse.de
Cc: akpm@linux-foundation.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/18] uio: nopage
Message-ID: <20071205110408.3eab9340@dilbert.local>
In-Reply-To: <20071205071627.143603000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
	<20071205071627.143603000@nick.local0.net>
Organization: Linutronix
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 05 Dec 2007 18:15:51 +1100
schrieb npiggin@suse.de:

> Convert uio from nopage to fault.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> Cc: greg@kroah.com

Hi Nick,
could you please add me to Cc: for UIO stuff:

Cc: hjk@linutronix.de

The patch itself looks alright to me, but I didn't test with a real
driver.

Acked-by: Hans J Koch <hjk@linutronix.de>

Thanks,
Hans


> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/uio/uio.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/drivers/uio/uio.c
> ===================================================================
> --- linux-2.6.orig/drivers/uio/uio.c
> +++ linux-2.6/drivers/uio/uio.c
> @@ -412,30 +412,28 @@ static void uio_vma_close(struct vm_area
>  	idev->vma_count--;
>  }
>  
> -static struct page *uio_vma_nopage(struct vm_area_struct *vma,
> -				   unsigned long address, int *type)
> +static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault
> *vmf) {
>  	struct uio_device *idev = vma->vm_private_data;
> -	struct page* page = NOPAGE_SIGBUS;
> +	struct page *page;
>  
>  	int mi = uio_find_mem_index(vma);
>  	if (mi < 0)
> -		return page;
> +		return VM_FAULT_SIGBUS;
>  
>  	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
>  		page = virt_to_page(idev->info->mem[mi].addr);
>  	else
>  		page =
> vmalloc_to_page((void*)idev->info->mem[mi].addr); get_page(page);
> -	if (type)
> -		*type = VM_FAULT_MINOR;
> -	return page;
> +	vmf->page = page;
> +	return 0;
>  }
>  
>  static struct vm_operations_struct uio_vm_ops = {
>  	.open = uio_vma_open,
>  	.close = uio_vma_close,
> -	.nopage = uio_vma_nopage,
> +	.fault = uio_vma_fault,
>  };
>  
>  static int uio_mmap_physical(struct vm_area_struct *vma)
> 
