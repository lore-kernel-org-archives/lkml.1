Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYARAGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYARAGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYARAGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:06:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYARAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:06:07 -0500
Date: Thu, 17 Jan 2008 16:05:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
Message-Id: <20080117160513.3456b4eb.akpm@linux-foundation.org>
In-Reply-To: <1200613194.3839.22.camel@cinder.waste.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<200801172315.28129.m.kozlowski@tuxland.pl>
	<20080117145105.ad968ea6.akpm@linux-foundation.org>
	<1200613194.3839.22.camel@cinder.waste.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 17:39:54 -0600
Matt Mackall <mpm@selenic.com> wrote:

> 
> On Thu, 2008-01-17 at 14:51 -0800, Andrew Morton wrote:
> > > proc_loop: /proc/3731/task/3731/pagemap
> > > kernel: BUG: sleeping function called from invalid context at fs/proc/task_mmu.c:554
> > > kernel: in_atomic():1, irqs_disabled():0
> > > kernel: Call Trace:
> > > kernel: [cf1cddf0] [c000840c] show_stack+0x3c/0x194 (unreliable)
> > > kernel: [cf1cde20] [c002b2ec] __might_sleep+0xf4/0x108
> > > kernel: [cf1cde30] [c00d2d54] add_to_pagemap+0x40/0x11c
> > > kernel: [cf1cde50] [c00d2f44] pagemap_pte_range+0xa8/0x10c
> > > kernel: [cf1cde70] [c0081b30] walk_page_range+0x148/0x23c
> > > kernel: [cf1cdeb0] [c00d3104] pagemap_read+0x15c/0x244
> > > kernel: [cf1cdef0] [c0092144] vfs_read+0xc4/0x16c
> > > kernel: [cf1cdf10] [c009261c] sys_read+0x4c/0x90
> > > kernel: [cf1cdf40] [c001328c] ret_from_syscall+0x0/0x40
> > 
> > It's not really an oops - it's a warning.  add_to_pagemap() is doing a
> > put_user() inside pagemap_pte_range->pte_offset_map->kmap_atomic.
> > 
> > A known bug, I'm afraid.
> > 
> > How to fix?
> > 
> > - double-buffer the data to be copied to userspace or
> > 
> > - take a local copy of the pte page then work on that instead or
> > 
> > - play copy_to_user_inatomic() tricks.
> 
> Hmm, this fell off my radar. How about something like this as a minimal
> fix (untested as -mm is a complete doorstop for me at the moment)?
> 
> diff -r 5595adaea70f fs/proc/task_mmu.c
> --- a/fs/proc/task_mmu.c	Thu Jan 17 13:26:54 2008 -0600
> +++ b/fs/proc/task_mmu.c	Thu Jan 17 17:29:21 2008 -0600
> @@ -582,20 +583,26 @@
>  {
>  	struct pagemapread *pm = private;
>  	pte_t *pte;
> -	int err = 0;
> +	int offset = 0, err = 0;
>  
>  	pte = pte_offset_map(pmd, addr);
> -	for (; addr != end; pte++, addr += PAGE_SIZE) {
> +	for (; addr != end; offset++, addr += PAGE_SIZE) {
>  		u64 pfn = PM_NOT_PRESENT;
> -		if (is_swap_pte(*pte))
> -			pfn = swap_pte_to_pagemap_entry(*pte);
> -		else if (pte_present(*pte))
> -			pfn = pte_pfn(*pte);
> +		if (is_swap_pte(pte[offset]))
> +			pfn = swap_pte_to_pagemap_entry(pte[offset]);
> +		else if (pte_present(pte[offset]))
> +			pfn = pte_pfn(pte[offset]);
> +#ifdef CONFIG_HIGHPTE
> +		pte_unmap(pte);
>  		err = add_to_pagemap(addr, pfn, pm);
> +		pte = pte_offset_map(pmd, addr);
> +#else
> +		err = add_to_pagemap(addr, pfn, pm);
> +#endif
>  		if (err)
>  			return err;
>  	}
> -	pte_unmap(pte - 1);
> +	pte_unmap(pte);
>  
>  	cond_resched();
>  

Good point, it really can be taht simple.

Do we need the ifdef?  pte_offset_map/pte_unmap should be super-cheap on
!CONFIG_HIGHPTE builds.

