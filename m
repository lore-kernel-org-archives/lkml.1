Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbYBLUEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbYBLUEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYBLUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:04:28 -0500
Received: from www.tglx.de ([62.245.132.106]:56388 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbYBLUE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:04:27 -0500
Date: Tue, 12 Feb 2008 21:04:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/8] RFC: Fix some EFI problems
In-Reply-To: <20080211093436.EAFB11B41CE@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802122043460.12988@apollo.tec.linutronix.de>
References: <200802111034.764275766@suse.de> <20080211093436.EAFB11B41CE@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:

> >From code review the EFI memory map handling has a couple of problems:
> 
> - The test for _WB memory was reversed so it would set cache able memory
> to uncached
> - It would always set a wrong uninitialized zero address to uncached
> (so I suspect it always set the first few pages in phys memory to uncached,
> that is why it may have gone unnoticed) 
> - It would call set_memory_x() on a fixmap address that it doesn't
> handle correct.
> - Some other problems I commented in the code (but was unable to solve
> for now) 
> 
> I changed the ioremaps to set the correct caching attributes
> and also corrected the ordering so it looks roughly correct now.

The only effective change is:

-               if (md->attribute & EFI_MEMORY_WB)
+               if (!(md->attribute & EFI_MEMORY_WB))

I appreciate that you noticed the reverse logic, which I messed up
when I fixed up rejects.

I pulled this out as it is a real fix. The rest of this patch is just
turning code in circles for nothing, simply because it is functionally
completely irrelevant whether does simply:

        if ((end >> PAGE_SHIFT) <= max_pfn_mapped)
                va = __va(md->phys_addr);
        else
                va = efi_ioremap(md->phys_addr, size);

       if (!(md->attribute & EFI_MEMORY_WB))
                set_memory_uc(md->virt_addr, size);
or

       if ((end >> PAGE_SHIFT) <= max_pfn_mapped) {
                va = __va(md->phys_addr);

                if (!(md->attribute & EFI_MEMORY_WB))
                        set_memory_uc(md->virt_addr, size);
       } else
                va = efi_ioremap(md->phys_addr, size,
                                 !!(md->attribute & EFI_MEMORY_WB));

And you just copied the real bug in that logic as well:

          set_memory_uc(md->virt_addr, size);
------------------------^^^^^^^^

which is initialized a couple of lines down.

	md->virt_addr = (u64) (unsigned long) va;

The reordering/optimizing needs to be a separate patch.

Please keep bugfixes and other changes separate.
 
> +		/* RED-PEN does not handle overlapped areas */

Can you please use CHECKME/FIXME which is used everywhere else. No need to
invent an extra marker.

Thanks,

	tglx
