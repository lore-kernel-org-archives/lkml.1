Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbYFYPpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbYFYPpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYFYPpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:45:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:12991 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYFYPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HjgjxD9/WWuSqHlpx2Rr41e5UttTKtrlhgGToJrzRiSyAJTluPf6yIwX8D+o9sSW8E
         Z94TmHrUBM7SjRgcvltUDJwc/ehISsA/EyVwIoiI4jA9L3GDl8iM2f5SBAHYTdUBEF16
         kk98MPEhuqmOQ/fe8joV3QTVjIOW/BWXIt2lc=
Message-ID: <86802c440806250844s51b50311va1c8e9c9fc1da510@mail.gmail.com>
Date: Wed, 25 Jun 2008 08:44:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: Merge setup_32/64.c into setup.c
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080625153614.GB18796@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806242213.15310.yhlu.kernel@gmail.com>
	 <200806242214.09503.yhlu.kernel@gmail.com>
	 <200806250114.09858.yhlu.kernel@gmail.com>
	 <20080625153614.GB18796@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 8:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  arch/x86/kernel/Makefile   |    2
>>  arch/x86/kernel/setup.c    |  676 ++++++++++++++++++++++++++++++++++++++++++++-
>>  arch/x86/kernel/setup_32.c |  543 ------------------------------------
>>  arch/x86/kernel/setup_64.c |  381 -------------------------
>>  include/asm-x86/setup.h    |    2
>>  5 files changed, 670 insertions(+), 934 deletions(-)
>
> very nice!
>
> could we please split this up into several, gradual steps that bring
> setup_32.c and setup_64.c to exactly the same content - where the final
> patch just renames arch/x86/kernel/setup_32.c to arch/x86/kernel/setup.c
> and deletes arch/x86/kernel/setup_64.c ?

OK,  someone (Mike Triavis) already stole setup.c for X86_NUMA.

You need to change that setup.c to other name. or split it away...

>
> it would still result in exactly the same end result - but is much more
> bisectable (and reviewable, etc.). A bit like how arch/x86/mm/ioremap.c
> or arch/x86/mm/pageattr.c was unified.
>
> maybe it can be done in less than 10 patches - but it guess it should be
> rather something in the neighborhood of 20 patches. Changes like this:
>
> -       /*
> -        * NOTE: before this point _nobody_ is allowed to allocate
> -        * any memory using the bootmem allocator.  Although the
> -        * allocator is now initialised only the first 8Mb of the kernel
> -        * virtual address space has been mapped.  All allocations before
> -        * paging_init() has completed must use the alloc_bootmem_low_pages()
> -        * variant (which allocates DMA'able memory) and care must be taken
> -        * not to exceed the 8Mb limit.
> -        */
>
> should be in a separate patch - you removed this restriction from the
> x86 architecture via your earlier patches, so the removal of the comment
> comes from that (and deserves a separate commit), not purely from the
> mechanic unification in the end.

OK.

>
> other changes like this:
>
> -#ifdef CONFIG_X86_FIND_SMP_CONFIG
> +#if defined(CONFIG_X86_FIND_SMP_CONFIG) && defined(CONFIG_X86_32) || \
> +    defined(CONFIG_X86_MPPARSE) && defined(CONFIG_X86_64)
>
> here you fix coding style:
>
> -        /*
> -         * Parse SRAT to discover nodes.
> -         */
> -        acpi_numa_init();
> +       /*
> +        * Parse SRAT to discover nodes.
> +        */
> +       acpi_numa_init();
>

OK

> etc. etc. You do a lot more very useful work than the plain single
> unification patch you sent tells us - all these changes should be split
> up.

YH
