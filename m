Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbYARBIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbYARBIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYARBI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:08:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbYARBI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:08:26 -0500
Date: Thu, 17 Jan 2008 17:07:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
Message-Id: <20080117170754.b5dd139b.akpm@linux-foundation.org>
In-Reply-To: <1200617237.3839.32.camel@cinder.waste.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<200801172315.28129.m.kozlowski@tuxland.pl>
	<20080117145105.ad968ea6.akpm@linux-foundation.org>
	<1200613194.3839.22.camel@cinder.waste.org>
	<20080117160513.3456b4eb.akpm@linux-foundation.org>
	<1200615168.3839.26.camel@cinder.waste.org>
	<20080117162913.0323c517.akpm@linux-foundation.org>
	<1200617237.3839.32.camel@cinder.waste.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 18:47:17 -0600
Matt Mackall <mpm@selenic.com> wrote:

> 
> On Thu, 2008-01-17 at 16:29 -0800, Andrew Morton wrote:
> > Do we need `offset' at all?
> 
> Looks like no.
> 
> I wonder if there's a good argument for adding a pte_offset_val() which
> would let us do:
> 
> pteval = pte_offset_val(pmd, addr);
> 
> and shrink the map/unmap window and overhead here and possibly
> elsewhere?
> 
> Anyway, updated but still untested patch now with revealing comment:
> 
> diff -r 5595adaea70f fs/proc/task_mmu.c
> --- a/fs/proc/task_mmu.c	Thu Jan 17 13:26:54 2008 -0600
> +++ b/fs/proc/task_mmu.c	Thu Jan 17 18:45:57 2008 -0600
> @@ -584,18 +585,19 @@
>  	pte_t *pte;
>  	int err = 0;
>  
> -	pte = pte_offset_map(pmd, addr);
> -	for (; addr != end; pte++, addr += PAGE_SIZE) {
> +	for (; addr != end; addr += PAGE_SIZE) {
>  		u64 pfn = PM_NOT_PRESENT;
> +		pte = pte_offset_map(pmd, addr);
>  		if (is_swap_pte(*pte))
>  			pfn = swap_pte_to_pagemap_entry(*pte);
>  		else if (pte_present(*pte))
>  			pfn = pte_pfn(*pte);
> +		/* unmap so we're not in atomic when we copy to userspace */
> +		pte_unmap(pte);
>  		err = add_to_pagemap(addr, pfn, pm);
>  		if (err)
>  			return err;
>  	}
> -	pte_unmap(pte - 1);
>  
>  	cond_resched();

That worked out nicely.

Wasn't the old code potentially pte_unmap()ping the wrong address?  If we
enter with addr==end?

