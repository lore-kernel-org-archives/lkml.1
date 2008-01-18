Return-Path: <linux-kernel-owner+w=401wt.eu-S1763576AbYARRXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763576AbYARRXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761699AbYARRXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:23:15 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3237 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761637AbYARRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:23:14 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
Date: Fri, 18 Jan 2008 18:23:06 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117162913.0323c517.akpm@linux-foundation.org> <1200617237.3839.32.camel@cinder.waste.org>
In-Reply-To: <1200617237.3839.32.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181823.07718.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

I patched the ppc32 kernel with this and run tests on /proc.
This patch helps. No more BUGs and oopses :)

Thanks,

	Mariusz

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

