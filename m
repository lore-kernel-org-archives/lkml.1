Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbYAaQWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbYAaQWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbYAaQWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:22:23 -0500
Received: from ns2.suse.de ([195.135.220.15]:40790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599AbYAaQWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:22:22 -0500
Date: Thu, 31 Jan 2008 17:22:20 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, ebiederm@xmission.com, vgoyal@redhat.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/9] Handle kernel near memory hole in
	clear_kernel_mapping
Message-ID: <20080131162220.GA25989@bingen.suse.de>
References: <20080129606.610336873@suse.de> <20080129050629.9D3DA1B416E@basil.firstfloor.org> <alpine.LFD.1.00.0801311514060.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801311514060.9204@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#define overlaps(as, ae, bs, be) ((ae) >= (bs) && (as) <= (be))
> 
> inline function please and a bit more intuituive arrangement of
> arguments.

Which one do you prefer? (to be honest the current one is "intuitive"
to me) 


> 
> > +void __init clear_kernel_mapping(unsigned long address, unsigned long size)
> > +{
> > +	int sh = PMD_SHIFT;
> > +	unsigned long kernel = __pa(__START_KERNEL_map);
> > +
> > +	/*
> > +	 * Note that we cannot unmap the kernel itself because the unmapped
> > +	 * holes here are always at least 2MB aligned.
> 
> That's not enforced. The unmap code just does not split pages.

It is -- there are BUG_ONs for this in __clear_kernel_mapping

> 
> > +	 * This just applies to the trailing areas of the 40MB kernel mapping.
> 
> How is this ensured, that it only affects the end of the 40MB mapping ?

It is enforced in the callers (actually there is only a single caller -- 
the GART code ) by not calling it overlapping for the kernel itself.
Given that could be checked too, but that would be probably overkill
for an internal function.

> 
> > +	 */
> > +	if (overlaps(kernel >> sh, (kernel + KERNEL_TEXT_SIZE) >> sh,
> > +			__pa(address) >> sh, __pa(address + size) >> sh)) {
> 
> This checks:
> 
>      (kernel_end + 1) >= gart_start && kernel_start <= gart_end
> 
> One off error:  kernel + KERNEL_TEXT_SIZE 
> needs to be:    kernel + KERNEL_TEXT_SIZE - 1

Ok.

> 
> Also there is no sanity check, whether the area is inside real kernel text.

Hmm I can add one, but if that happens the caller is likely seriously
confused and will likely cause other problems anyways. 

I don't think it can happen for the GART code which is currently
the only caller.

> 
> > +		printk(KERN_WARNING
> > +			"Kernel mapping at %lx within 2MB of memory hole\n",
> > +				kernel);
> 
> 
> > +		__clear_kernel_mapping(__START_KERNEL_map+__pa(address), size);
> 
> Doh! This is unmapping the wrong place. According to __phys_addr():
> 
>      paddr = vaddr - __START_KERNEL_map + phys_base;

Hmm true -- that will only affect relocatable kernels, but for those
it's wrong. Given that the patch was supposed to fix a case 
that only happens relocatable kernels that's quite ironic :)

Actually thinking about it again you can just drop it for now.
It is orthogonal to gbpages. I think I added it to the series
when I was planning to do kernel mapping as GB pages, but that
turned out to be a bad idea anyways.

Thanks for the review,

-Andi
