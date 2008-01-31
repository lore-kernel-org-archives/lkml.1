Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbYAaPtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbYAaPtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbYAaPs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:48:56 -0500
Received: from www.tglx.de ([62.245.132.106]:53391 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbYAaPsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:48:55 -0500
Date: Thu, 31 Jan 2008 16:48:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: ebiederm@xmission.com, vgoyal@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/9] Handle kernel near memory hole in
 clear_kernel_mapping
In-Reply-To: <20080129050629.9D3DA1B416E@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0801311514060.9204@apollo.tec.linutronix.de>
References: <20080129606.610336873@suse.de> <20080129050629.9D3DA1B416E@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andi Kleen wrote:
> This was a long standing obscure problem in the relocatable kernel. The
> AMD GART driver needs to unmap part of the GART in the kernel direct mapping to 
> prevent cache corruption. With the relocatable kernel it is in theory possible 
> that the separate kernel text mapping straddles that area too. 
> 
> Normally it should not happen because GART tends to be >= 2GB, and the kernel 
> is normally not loaded that high, but it is possible in theory. 

This smells fishy.

>
....
>
> +#define overlaps(as, ae, bs, be) ((ae) >= (bs) && (as) <= (be))

inline function please and a bit more intuituive arrangement of
arguments.

> +void __init clear_kernel_mapping(unsigned long address, unsigned long size)
> +{
> +	int sh = PMD_SHIFT;
> +	unsigned long kernel = __pa(__START_KERNEL_map);
> +
> +	/*
> +	 * Note that we cannot unmap the kernel itself because the unmapped
> +	 * holes here are always at least 2MB aligned.

That's not enforced. The unmap code just does not split pages.

> +	 * This just applies to the trailing areas of the 40MB kernel mapping.

How is this ensured, that it only affects the end of the 40MB mapping ?

> +	 */
> +	if (overlaps(kernel >> sh, (kernel + KERNEL_TEXT_SIZE) >> sh,
> +			__pa(address) >> sh, __pa(address + size) >> sh)) {

This checks:

     (kernel_end + 1) >= gart_start && kernel_start <= gart_end

One off error:  kernel + KERNEL_TEXT_SIZE 
needs to be:    kernel + KERNEL_TEXT_SIZE - 1

Also there is no sanity check, whether the area is inside real kernel text.

> +		printk(KERN_WARNING
> +			"Kernel mapping at %lx within 2MB of memory hole\n",
> +				kernel);


> +		__clear_kernel_mapping(__START_KERNEL_map+__pa(address), size);

Doh! This is unmapping the wrong place. According to __phys_addr():

     paddr = vaddr - __START_KERNEL_map + phys_base;

Transformation:

     vaddr = padd + __START_KERNEL_map - phys_base;

Sigh. The clear_kernel_mapping() functionality is just another wreckaged
implementation of CPA.

We really should use CPA and have a function to mark entries not
present. Actually the DEBUG_PAGEALLOC code has one already. There are
sanity checks in the CPA code as well, which can be extended to cover
the GART unmap in a safe way.

Thanks,
	tglx
