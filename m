Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYACS3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYACS3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYACS3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:29:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYACS3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:29:37 -0500
Date: Thu, 3 Jan 2008 13:29:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/8] GBPAGES: Handle kernel near memory hole in
	clear_kernel_mapping
Message-ID: <20080103182928.GC3028@redhat.com>
References: <20080103626.635376000@suse.de> <20080103172657.B5CFA14DDD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103172657.B5CFA14DDD@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 06:26:57PM +0100, Andi Kleen wrote:
> 
> This was a long standing obscure problem in the relocatable kernel. The
> AMD GART driver needs to unmap part of the GART in the kernel direct mapping to 
> prevent cache corruption. With the relocatable kernel it is in theory possible 
> that the separate kernel text mapping straddles that area too. 
> 
> Normally it should not happen because GART tends to be >= 2GB, and the kernel 
> is normally not loaded that high, but it is possible in theory. 
> 
> Teach clear_kernel_mapping() about this case.
> 
> This will become more important once the kernel mapping uses 1GB pages.
> 
> Cc: ebiederm@xmission.com
> Cc: vgoyal@redhat.com
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/init_64.c |   20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/mm/init_64.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_64.c
> +++ linux/arch/x86/mm/init_64.c
> @@ -411,7 +411,8 @@ void __init paging_init(void)
>     from the CPU leading to inconsistent cache lines. address and size
>     must be aligned to 2MB boundaries. 
>     Does nothing when the mapping doesn't exist. */
> -void __init clear_kernel_mapping(unsigned long address, unsigned long size) 
> +static void __init
> +__clear_kernel_mapping(unsigned long address, unsigned long size)
>  {
>  	unsigned long end = address + size;
>  
> @@ -441,6 +442,23 @@ void __init clear_kernel_mapping(unsigne
>  	__flush_tlb_all();
>  } 
>  
> +#define overlaps(as,ae,bs,be) ((ae) >= (bs) && (as) <= (be))
> +
> +void __init clear_kernel_mapping(unsigned long address, unsigned long size)
> +{
> +	int sh = PMD_SHIFT;
> +	unsigned long kernel = __pa(__START_KERNEL_map);
> +
> +	if (overlaps(kernel>>sh, (kernel + KERNEL_TEXT_SIZE)>>sh,
> +			__pa(address)>>sh, __pa(address + size)>>sh)) {
> +		printk(KERN_INFO
> +			"Kernel at %lx overlaps memory hole at %lx-%lx\n",
> +				kernel, __pa(address), __pa(address+size));
> +		__clear_kernel_mapping(__START_KERNEL_map+__pa(address), size);

Hi Andi,

Got a question. How will kernel continue to run if we unmap the kernel
text/data region mappings?

Thanks
Vivek
