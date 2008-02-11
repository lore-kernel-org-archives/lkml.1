Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYBKMpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYBKMpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYBKMp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:45:28 -0500
Received: from mail.suse.de ([195.135.220.2]:54751 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbYBKMp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:45:28 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>, ying.huang@intel.com
Subject: Re: [PATCH] [4/8] CPA: Fix set_memory_x for ioremap
Date: Mon, 11 Feb 2008 13:45:23 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <20080211093432.DA4331B41CE@basil.firstfloor.org> <20080211122705.GA23733@elte.hu>
In-Reply-To: <20080211122705.GA23733@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111345.23372.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Wrong. We do call __pa() on vmalloc ranges (which is a known 
> uncleanliness that we intend to fix),

AFAIK nobody does actually currently. Although I expect sooner
or later someone will try since __ioremap() lost its pgprot argument
that made it so powerful. Best would be probably to stick
in some bugs just to catch that.

> but contrary to your claim the  
> result is not "random result". On 64-bit it's guaranteed to have a value 
> above ~66 TB on 64-bit and hence fails all the filters later on so it 
> has zero practical relevance at the moment.

Note that 64bit EFI passes in a fixmap address (they just call
it efi_ioremap). Fixmaps are in the kernel mapping which __pa() handles
and then this gives a low number likely somewhere in memory
and might well trigger.

> On 32-bit we transform it  
> down to somewhere around 1GB - where we check it against the BIOS range 
> filters - which again cannot trigger. But I do agree that it's unclean 
> and needs fixing up.

Are you sure about this for all possible __PAGE_OFFSET values? e.g. consider
1:3 split. Also there is always relocated kernels where kernels might be loaded 
quite high.

> 
> static int change_page_attr_addr(struct cpa_data *cpa)
> ...
>         unsigned long phys_addr = __pa(address);
> 
> which for vmalloc area virtual addresses will indeed yield some really 
> high (and invalid) physical address. That address will never trigger 
> this check:
> 
>         if (within(address, HIGH_MAP_START, HIGH_MAP_END))
>                 address = (unsigned long) __va(phys_addr);

That doesn't check phys_addr at all?
 
> or this check:
> 
>         if (within(phys_addr, 0, KERNEL_TEXT_SIZE)) {
> 
> so we'll never actuall _use_ that phys_addr.



> and it's on our clean-up  
> list. But your patch is not a good cleanup because it just hides the 
> underlying weakness.

I never claimed it was a cleanup. It's a fix and a optimization 
(don't do unnecessary coherency between direct mapping and other 
mappings for clearing X -- this means some innocent pages in the
direct mapping won't get split) 

Anyways even if you don't want to fix this clear bug I would ask
to still consider the optimization independently.

-Andi


