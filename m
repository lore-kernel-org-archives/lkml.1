Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYGVEuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYGVEuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYGVEt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:49:58 -0400
Received: from gw.goop.org ([64.81.55.164]:46598 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYGVEt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:49:57 -0400
Message-ID: <488566EA.5040805@goop.org>
Date: Mon, 21 Jul 2008 21:49:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix pte_flags() to only return flags, fix lguest.
References: <200807221431.58991.rusty@rustcorp.com.au>
In-Reply-To: <200807221431.58991.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Change a15af1c9ea2750a9ff01e51615c45950bad8221b 'x86/paravirt: add
> pte_flags to just get pte flags' removed lguest's private pte_flags()
> in favor of a generic one.
>
> Unfortunately, the generic one doesn't filter out the non-flags bits:
> this results in lguest creating corrupt shadow page tables and blowing
> up host memory.
>
> Since noone is supposed to use the pfn part of pte_flags(), it seems
> safest to always do the filtering.
>   

Thinking about this, I wonder if it needs to be a pv_op at all.  
Generality says "yes", but there are no users which set it to anything 
other than native_pte_flags.  The point of it is to return the flags 
as-is, without needing more complex stuff (like Xen's mfn to pfn 
conversion).

In most cases, the surrounding code will be applying its own mask 
anyway, so making it a simple inline will allow all the masks to get 
folded together.

If a user which wants to do something other than return the bare flags, 
it would be easy enough to put the pv_op back.

> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff -r ee1a6adad3d2 arch/x86/kernel/paravirt.c
> --- a/arch/x86/kernel/paravirt.c	Mon Jul 21 12:49:25 2008 +1000
> +++ b/arch/x86/kernel/paravirt.c	Tue Jul 22 14:09:33 2008 +1000
> @@ -428,7 +428,7 @@ struct pv_mmu_ops pv_mmu_ops = {
>  #endif /* PAGETABLE_LEVELS >= 3 */
>  
>  	.pte_val = native_pte_val,
> -	.pte_flags = native_pte_val,
> +	.pte_flags = native_pte_flags,
>  	.pgd_val = native_pgd_val,
>  
>  	.make_pte = native_make_pte,
> diff -r ee1a6adad3d2 include/asm-x86/page.h
> --- a/include/asm-x86/page.h	Mon Jul 21 12:49:25 2008 +1000
> +++ b/include/asm-x86/page.h	Tue Jul 22 14:09:33 2008 +1000
> @@ -144,6 +144,18 @@ static inline pteval_t native_pte_val(pt
>  	return pte.pte;
>  }
>  
> +/* This belongs in pgtable.h, but our includes are too much of a mess. */
> +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> +#define PTE_FLAGS	_AC(0x8000000000000FFF, ULL)
> +#else
> +#define PTE_FLAGS	0x00000FFF
> +#endif
>   
We already have this, it's called PTE_MASK.

    J
