Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXGBBNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXGBBNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 21:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXGBBNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 21:13:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:13314 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXGBBNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 21:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=jN3FAU7iADfeLJcFKxU42/yGXAmaqSY8u0+h/umXhGaLg4weIRbuw6oV0JGYqm+dnwzQj/a8Gp7aToaJOZ6dzJ37c9zPJTgkyU8pe/mODJbxRWqoY5IatZg5+hRmjyDR7m48mubLGKmWopqdFqyqZqbq/kNG7QFBLEKvGp/rwKQ=
Date: Mon, 2 Jul 2007 04:13:33 +0300
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
Message-ID: <20070702011332.GA3503@Ahmed>
References: <20070701203833.GA3498@Ahmed> <46882872.7040005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46882872.7040005@goop.org>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Sun, Jul 01, 2007 at 03:19:30PM -0700, Jeremy Fitzhardinge wrote:
> Ahmed S. Darwish wrote:
> >Hi list,
> >
> >AFAIK, in the initializaion phase, kernel builds pages tables with two
> >mappings, identity and PAGE_OFFSET + C mapping. The provisional _global
> >directory_ is contained in swapper_pg_dir variable. while the provisional 
> >_page tables_ are stored starting from pg0, right after _end.
> >
> >There're some stuff that confused me for a full day about the code (head.S)
> >that  accomplishes the above words:
> >
> >	movl $(pg0 - __PAGE_OFFSET), %edi
> >	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx	
> >	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
> >10:
> >	leal $0x007(%edi),%ecx			/* Create PDE entry */
> >
> >What does the address of 7 bytes displacement after %edi - the physical 
> >address
> >of pg0 - represent ?. Why not just putting the address of %edi (the 
> >address of
> >pagetable cell to be mapped by swapper_pg_dir) in %ecx without 
> >displacement?
> >  
> 
> The pte format contains the pfn in the top 20 bits, and flags in the 
> lower 12 bits.  As the comment says "0x007 = PRESENT+RW+USER".
> 

yes, but isn't the displacement here (0x007) a _bytes_ displacement ?. so
effectively, %ecx now contains physical address of pg0 + 7bytes. Is it A 
meaningful place/address ?.

> >        page_pde_offset = (__PAGE_OFFSET >> 20)
> >	movl %ecx,(%edx)			/* Store identity PDE entry 
> >	*/
> >	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
> >
> >Why the pde_offset is PAGE_OFFSET >> 20 instead of PAGE_OFFSET >> 22 ?
> >* 22 to right shift the whole page_shift (12) and pgdir_shift (10) bits.
> >  
> 
> As Andreas said, its (PAGE_OFFSET >> 22) << 2.
> 

Great!, Thanks a lot.

> >        [...]
> >	/* Initialize the 1024 _page table_ cells with %eax (0x007) */
> >	movl $1024, %ecx
> >11:
> >	stosl
> >	addl $0x1000,%eax
> >	loop 11b
> >
> >The page table entries beginning from pg0 (pointed by %edi) and following 
> >pages are initialized with  the series 7 + 8 + 8 + ... for each cell. This 
> >series has
> >the property of setting the PRESENT+RW+USER bits in the whole entries to 1 
> >but it
> >sets lots of the entries BASE address to 0 too. Why is this done ?
> >  
> 
> I don't follow you.  Are you overlooking the 'L' on stosl?
> 

Sorry for not making the question clear. my question was that the first entry in
the page table pointed by (%edi) is initialize with %eax = 0x007, a reasonable
value (setting the 3 pte flags). Beginning from entry 2, they got initialized
with a value = "new %eax = old %eax + 8", generating a table of entries
initialized with 7, 15, 31, .. . While this scheme makes the 3 PRESENT, RW 
and USER flags set, it makes alot of "pte"s with equivalent "pfn"s. Here comes 
my wonder, why initializing pg0 that way ?.

Thanks,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
