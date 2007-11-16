Return-Path: <linux-kernel-owner+w=401wt.eu-S1764881AbXKPSbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764881AbXKPSbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXKPSaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:30:52 -0500
Received: from gw.goop.org ([64.81.55.164]:45074 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXKPSav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:30:51 -0500
Message-ID: <473DE1C4.1050601@goop.org>
Date: Fri, 16 Nov 2007 10:30:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473DCF73.4070401@goop.org> <alpine.LFD.0.9999.0711160921510.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711160921510.4260@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 16 Nov 2007, Jeremy Fitzhardinge wrote:
>   
>>> IIRC, the present bit is ignored in the magic 4-entry PGD.  All entries 
>>> have to be present.
>>>       
>> Hm, do you recall what processors that might affect?  As far as I know,
>> current processors will ignore non-present top-level entries.
>>     
>
> Are you sure?
>   

3.8.5 in vol 3a "Page-Directory and Page-Table Entries With Extended
Addressing Enabled":

    The present flag (bit 0) in the page-directory-pointer-table entries
    can be set to 0 or 1. If the present flag is clear, the remaining
    bits in the page-directory-pointer-table entry are available to the
    operating system. If the present flag is set, the fields of the
    page-directory-pointer-table entry are defined in Figures 3-20 for
    4-KByte pages and Figures 3-21 for 2-MByte pages.

So I would assume this works on all current CPUs, but I can imagine that
some older/off-brand processors might get it wrong.

> Anyway, this is not worth making a distinction for. Just pre-allocate all 
> of them. There really is just 4 PGD entries, and it really *is* different 
> from having a full three-level page table, and of the four PGD entries:
>
>  - one is used for the kernel mapping (assuming the regular 1:3 layout)
>  - AT LEAST two are required by user space anyway
>
> so pre-allocating is never going to waste more than one page.
>   

Yeah, I'm not so concerned about memory saving; I don't think there
would be any in practice.

> And you may feel that pre-allocating is a special case, but it's an 
> *easier* special case than the one that you are apparently thinking about 
> (which is to special-case according to CPU version).
>   

I'm hoping to avoid special-casing anything, if I can help it, aside
from the normal 32/64-bit 2/3/4-level parameterising of the various
pagetable accessors.

> So don't do it. Just preallocate for the magic 4-entry PGD. You can make 
> the special case just be something like
>
> 	/* Preallocate for small PGD's */
> 	#if PTRS_PER_PGD == 4
> 		for (i = 0; i < USER_PTRS_PER_PGD; i++) {
> 			pmd_t *pmd = pmd_alloc();
> 			set_pgd(pgd+i, __pgd(PAGE_PRESENT | __pa(pmd));
> 		}	
> 	#endif
>
> or similar. 
>
> There is absolutely *zero* reason not to do this, and there is also zero 
> reason to make this be a "32-bit vs 64-bit" issue. The code can be there 
> in both, and the #if could even be all in C code (ie there may be reasons 
> to prefer writing it as
>
> 	/* The old-style PAE PGD needs to be preallocated */
> 	if (USER_PTRS_PER_PGD <= 4) {
> 		...
> 	}
>
> and the compiler should even compile it away entirely for all practical 
> cases even without using the preprocessor.
>   

Perhaps.  And there's the corresponding difference between 32 and 64 bit
on freeing a pagetable; 32-bit assumes the pgd destructor will free the
pmd, whereas 64-bit does it separately.  Even in the current 32-bit
code, there's separate handling for PAE and non-PAE.  I think it can all
be collapsed down in a reasonable way.

>> That just means we need to reload cr3 after populating the pgd with a
>> new pmd, right?
>>     
>
> BUT ONLY FOR THIS CASE!
>
> And if you preallocate it, you make *that* special case go away. 
>   

Yes, that is a bit awkward; it means that 32-bit PAE would need a
speparate pgd_populate.  But that seems like a smaller change than 1)
making 32-bit PAE pgd-alloc preallocate the pmd, and 2) making pmd_free
noop on 32-bit PAE, and 3) making pgd_free free the preallocated pmd. 
Perhaps 2 & 3 aren't necessary and can be the same as 64-bit.

I'll need to look into it more carefully.

> So you're going to have special cases regardless. Do the simple and 
> really straightforward one, please! Nothing subtle.
>   

Yep, absolutely.

    J
