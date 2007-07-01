Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbXGAWTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbXGAWTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXGAWTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:19:32 -0400
Received: from gw.goop.org ([64.81.55.164]:37831 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbXGAWTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:19:32 -0400
Message-ID: <46882872.7040005@goop.org>
Date: Sun, 01 Jul 2007 15:19:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
References: <20070701203833.GA3498@Ahmed>
In-Reply-To: <20070701203833.GA3498@Ahmed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> Hi list,
>
> AFAIK, in the initializaion phase, kernel builds pages tables with two
> mappings, identity and PAGE_OFFSET + C mapping. The provisional _global
> directory_ is contained in swapper_pg_dir variable. while the provisional 
> _page tables_ are stored starting from pg0, right after _end.
>
> There're some stuff that confused me for a full day about the code (head.S)
> that  accomplishes the above words:
>
> 	movl $(pg0 - __PAGE_OFFSET), %edi
> 	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx	
> 	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
> 10:
> 	leal $0x007(%edi),%ecx			/* Create PDE entry */
>
> What does the address of 7 bytes displacement after %edi - the physical address
> of pg0 - represent ?. Why not just putting the address of %edi (the address of
> pagetable cell to be mapped by swapper_pg_dir) in %ecx without displacement?
>   

The pte format contains the pfn in the top 20 bits, and flags in the 
lower 12 bits.  As the comment says "0x007 = PRESENT+RW+USER".

>         page_pde_offset = (__PAGE_OFFSET >> 20)
> 	movl %ecx,(%edx)			/* Store identity PDE entry */
> 	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
>
> Why the pde_offset is PAGE_OFFSET >> 20 instead of PAGE_OFFSET >> 22 ?
> * 22 to right shift the whole page_shift (12) and pgdir_shift (10) bits.
>   

As Andreas said, its (PAGE_OFFSET >> 22) << 2.

>         [...]
> 	/* Initialize the 1024 _page table_ cells with %eax (0x007) */
> 	movl $1024, %ecx
> 11:
> 	stosl
> 	addl $0x1000,%eax
> 	loop 11b
>
> The page table entries beginning from pg0 (pointed by %edi) and following pages 
> are initialized with  the series 7 + 8 + 8 + ... for each cell. This series has
> the property of setting the PRESENT+RW+USER bits in the whole entries to 1 but it
> sets lots of the entries BASE address to 0 too. Why is this done ?
>   

I don't follow you.  Are you overlooking the 'L' on stosl?

    J
