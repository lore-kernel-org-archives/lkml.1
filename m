Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYG2BZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYG2BZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYG2BZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:25:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46242 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYG2BZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:25:31 -0400
Date: Tue, 29 Jul 2008 02:25:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linuxfoundation.org,
       torvalds@linuxfoundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do not overrun page table ranges in gup
In-Reply-To: <alpine.LFD.1.10.0807281737480.3486@nehalem.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0807290220290.29017@blonde.site>
References: <20080728184947.GA5041@martell.zuzino.mipt.ru>
 <20080728185316.GA19479@martell.zuzino.mipt.ru> <87y73l5zlj.fsf_-_@saeurebad.de>
 <87tze95yrk.fsf@saeurebad.de> <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0807281737480.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Linus Torvalds wrote:
> On Mon, 28 Jul 2008, Linus Torvalds wrote:
> > 
> > So no, the right fix would be to align 'start' first, which means that 
> > everything else (including 'end') will be page-aligned. Aligning just one 
> > or the other is very very wrong.
> 
> Does this work?
> 
> Not pretty, but it stands _some_ chance of being correct.
> 
> 		Linus

Acked-by: Hugh Dickins <hugh@veritas.com>

Seeing the bug report, I was working up a patch along the same lines
as this; but got the access_ok() issue backwards: yours looks right.
I see Alexey has tested it, confess I haven't.

> 
> 
> ---
>  arch/x86/mm/gup.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index 3085f25..007bb06 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -223,14 +223,17 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  			struct page **pages)
>  {
>  	struct mm_struct *mm = current->mm;
> -	unsigned long end = start + (nr_pages << PAGE_SHIFT);
> -	unsigned long addr = start;
> +	unsigned long addr, len, end;
>  	unsigned long next;
>  	pgd_t *pgdp;
>  	int nr = 0;
>  
> +	start &= PAGE_MASK;
> +	addr = start;
> +	len = (unsigned long) nr_pages << PAGE_SHIFT;
> +	end = start + len;
>  	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
> -					start, nr_pages*PAGE_SIZE)))
> +					start, len)))
>  		goto slow_irqon;
>  
>  	/*
