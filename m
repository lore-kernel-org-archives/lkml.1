Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYARAaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYARAaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYARAaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:30:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809AbYARAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:30:00 -0500
Date: Thu, 17 Jan 2008 16:29:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
Message-Id: <20080117162913.0323c517.akpm@linux-foundation.org>
In-Reply-To: <1200615168.3839.26.camel@cinder.waste.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<200801172315.28129.m.kozlowski@tuxland.pl>
	<20080117145105.ad968ea6.akpm@linux-foundation.org>
	<1200613194.3839.22.camel@cinder.waste.org>
	<20080117160513.3456b4eb.akpm@linux-foundation.org>
	<1200615168.3839.26.camel@cinder.waste.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 18:12:48 -0600
Matt Mackall <mpm@selenic.com> wrote:

> 
> > Do we need the ifdef?  pte_offset_map/pte_unmap should be super-cheap on
> > !CONFIG_HIGHPTE builds.
> 
> In that case, pte_unmap is free, pte_offset_map is just a bit of math.
> So yeah, we can simplify this. How about:
> 
> diff -r 5595adaea70f fs/proc/task_mmu.c
> --- a/fs/proc/task_mmu.c	Thu Jan 17 13:26:54 2008 -0600
> +++ b/fs/proc/task_mmu.c	Thu Jan 17 18:11:13 2008 -0600
> @@ -582,20 +583,20 @@
>  {
>  	struct pagemapread *pm = private;
>  	pte_t *pte;
> -	int err = 0;
> +	int offset = 0, err = 0;
>  
> -	pte = pte_offset_map(pmd, addr);
> -	for (; addr != end; pte++, addr += PAGE_SIZE) {
> +	for (; addr != end; offset++, addr += PAGE_SIZE) {
>  		u64 pfn = PM_NOT_PRESENT;
> -		if (is_swap_pte(*pte))
> -			pfn = swap_pte_to_pagemap_entry(*pte);
> -		else if (pte_present(*pte))
> -			pfn = pte_pfn(*pte);
> +		pte = pte_offset_map(pmd, addr);
> +		if (is_swap_pte(pte[offset]))
> +			pfn = swap_pte_to_pagemap_entry(pte[offset]);
> +		else if (pte_present(pte[offset]))
> +			pfn = pte_pfn(pte[offset]);
> +		pte_unmap(pte);
>  		err = add_to_pagemap(addr, pfn, pm);
>  		if (err)
>  			return err;
>  	}
> -	pte_unmap(pte - 1);
>  
>  	cond_resched();
> 

Do we need `offset' at all?

You have

static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
			     void *private)
{
	struct pagemapread *pm = private;
	pte_t *pte;
	int offset = 0, err = 0;

	for (; addr != end; offset++, addr += PAGE_SIZE) {
		u64 pfn = PM_NOT_PRESENT;
		pte = pte_offset_map(pmd, addr);
		if (is_swap_pte(pte[offset]))
			pfn = swap_pte_to_pagemap_entry(pte[offset]);
		else if (pte_present(pte[offset]))
			pfn = pte_pfn(pte[offset]);
		pte_unmap(pte);
		err = add_to_pagemap(addr, pfn, pm);
		if (err)
			return err;
	}

	cond_resched();

	return err;
}

but I think we just do s/pte[offset]/*pte/.  The virtual address should be
the only thing we need to increment as we walk across the addresses here?


