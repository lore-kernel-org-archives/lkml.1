Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYHVQTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYHVQTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYHVQTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:19:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55966 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYHVQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:19:23 -0400
Subject: Re: [PATCH] Skip memory holes in FLATMEM when reading
	/proc/pagetypeinfo (resend)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       hsweeten@visionengravers.com, akpm@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20080821132804.GA6206@csn.ul.ie>
References: <20080821132804.GA6206@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 09:19:14 -0700
Message-Id: <1219421954.20559.73.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 14:28 +0100, Mel Gorman wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 4b8acd2..70dba16 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -810,6 +810,11 @@ config OABI_COMPAT
>  	  UNPREDICTABLE (in fact it can be predicted that it won't work
>  	  at all). If in doubt say Y.
>  
> +config ARCH_FLATMEM_HAS_HOLES
> +	bool
> +	default y
> +	depends on FLATMEM
> +
>  config ARCH_DISCONTIGMEM_ENABLE
>  	bool
>  	default (ARCH_LH7A40X && !LH7A40X_CONTIGMEM)
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index b0d08e6..98aa882 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -516,9 +516,26 @@ static void pagetypeinfo_showblockcount_print(struct seq_file *m,
>  			continue;
>  
>  		page = pfn_to_page(pfn);
> +#ifdef CONFIG_ARCH_FLATMEM_HAS_HOLES
> +		/*
> +		 * Ordinarily, memory holes in flatmem still have a valid
> +		 * memmap for the PFN range. However, an architecture for
> +		 * embedded systems (e.g. ARM) can free up the memmap backing
> +		 * holes to save memory on the assumption the memmap is
> +		 * never used.

I'm not sure where this assumption is coming from.  Have you taken a
look at the ARM code?

> 		               The page_zone linkages are then broken even
> +		 * though pfn_valid() returns true. Skip the page if the
> +		 * linkages are broken. Even if this test passed, the impact
> +		 * is that the counters for the movable type are off but
> +		 * fragmentation monitoring is likely meaningless on small
> +		 * systems.
> +		 */
> +		if (page_zone(page) != zone)
> +			continue;
> +#endif
>  		mtype = get_pageblock_migratetype(page);
>  
> -		count[mtype]++;
> +		if (mtype < MIGRATE_TYPES)
> +			count[mtype]++;
>  	}

Is that really worth an #ifdef?  It is in code that isn't in a hot path,
and the page_zone() should be a repetitive operation on a structure that
is already (or will soon be) in the cpu cache.  

Ugh, but as I think about it, this is going to be a much more widespread
problem.  Looking at the arm code, the memory for the mem_map[]e *does*
get freed back into the bootmem allocator:

free_memmap(int node, unsigned long start_pfn, unsigned long end_pfn)
{
...
        if (pg < pgend)
                free_bootmem_node(NODE_DATA(node), pg, pgend - pg);
}

Doesn't that mean that we can get random gunk in the middle of the
mem_map[] when someone else allocates and uses this memory?

We have quite a few things across the kernel that iterate over pfn
ranges and require pfn_valid() to be working. 

Can we talk ARM into converting over to sparsemem?  A plain sparsemem
port for MIPS that got coded up recently was ~25 lines of arch code.  A
bit more if they decide to do vmemmap.  There's even a nice bit for
Documentation/ about what was done:

http://article.gmane.org/gmane.linux.ports.mips.general/21248/match=mips+sparsemem

-- Dave

