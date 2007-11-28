Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbXK1KPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbXK1KPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbXK1KPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:15:40 -0500
Received: from rex.snapgear.com ([203.143.235.140]:36771 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755345AbXK1KPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:15:38 -0500
Date: Wed, 28 Nov 2007 20:18:45 +1000
From: David McCullough <David_Mccullough@securecomputing.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       linux-kernel@vger.kernel.org
Subject: Re: nommu: Add new vmalloc_user() and remap_vmalloc_range() interfaces.
Message-ID: <20071128101845.GA20728@securecomputing.com>
References: <20071128084914.GA28486@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128084914.GA28486@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Paul Mundt lays it down ...
> This builds on top of the earlier vmalloc_32_user() work introduced by
> b50731732f926d6c49fd0724616a7344c31cd5cf, as we now have places in the
> nommu allmodconfig that hit up against these missing APIs.
> 
> As vmalloc_32_user() is already implemented, this is moved over to
> vmalloc_user() and simply made a wrapper. As all current nommu platforms
> are 32-bit addressable, there's no special casing we have to do for
> ZONE_DMA and things of that nature as per GFP_VMALLOC32.
> 
> remap_vmalloc_range() needs to check VM_USERMAP in order to figure out
> whether we permit the remap or not, which means that we also have to
> rework the vmalloc_user() code to grovel for the VMA and set the flag.

Seems fine to me,

Cheers,
Davidm

Acked-by: David McCullough <david_mccullough@securecomputing.com>

> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> ---
> 
>  mm/nommu.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 35622c5..c4768d0 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -10,6 +10,7 @@
>   *  Copyright (c) 2000-2003 David McCullough <davidm@snapgear.com>
>   *  Copyright (c) 2000-2001 D Jeff Dionne <jeff@uClinux.org>
>   *  Copyright (c) 2002      Greg Ungerer <gerg@snapgear.com>
> + *  Copyright (c) 2007      Paul Mundt <lethal@linux-sh.org>
>   */
>  
>  #include <linux/module.h>
> @@ -183,6 +184,26 @@ void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
>  }
>  EXPORT_SYMBOL(__vmalloc);
>  
> +void *vmalloc_user(unsigned long size)
> +{
> +	void *ret;
> +
> +	ret = __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
> +			PAGE_KERNEL);
> +	if (ret) {
> +		struct vm_area_struct *vma;
> +
> +		down_write(&current->mm->mmap_sem);
> +		vma = find_vma(current->mm, (unsigned long)ret);
> +		if (vma)
> +			vma->vm_flags |= VM_USERMAP;
> +		up_write(&current->mm->mmap_sem);
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(vmalloc_user);
> +
>  struct page * vmalloc_to_page(void *addr)
>  {
>  	return virt_to_page(addr);
> @@ -253,10 +274,17 @@ EXPORT_SYMBOL(vmalloc_32);
>   *
>   * The resulting memory area is 32bit addressable and zeroed so it can be
>   * mapped to userspace without leaking data.
> + *
> + * VM_USERMAP is set on the corresponding VMA so that subsequent calls to
> + * remap_vmalloc_range() are permissible.
>   */
>  void *vmalloc_32_user(unsigned long size)
>  {
> -	return __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
> +	/*
> +	 * We'll have to sort out the ZONE_DMA bits for 64-bit,
> +	 * but for now this can simply use vmalloc_user() directly.
> +	 */
> +	return vmalloc_user(size);
>  }
>  EXPORT_SYMBOL(vmalloc_32_user);
>  
> @@ -1213,6 +1241,21 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long from,
>  }
>  EXPORT_SYMBOL(remap_pfn_range);
>  
> +int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
> +			unsigned long pgoff)
> +{
> +	unsigned int size = vma->vm_end - vma->vm_start;
> +
> +	if (!(vma->vm_flags & VM_USERMAP))
> +		return -EINVAL;
> +
> +	vma->vm_start = (unsigned long)(addr + (pgoff << PAGE_SHIFT));
> +	vma->vm_end = vma->vm_start + size;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(remap_vmalloc_range);
> +
>  void swap_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
>  {
>  }

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
