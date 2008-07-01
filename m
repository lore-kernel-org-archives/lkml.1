Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYGAH2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYGAH2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYGAH2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:28:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:59838 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbYGAH2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:28:11 -0400
Subject: Re: [PATCH 14/20] powerpc: use generic show_mem()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080627120049.883374735@saeurebad.de>
References: <20080627115349.743368154@saeurebad.de>
	 <20080627120049.883374735@saeurebad.de>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 17:27:27 +1000
Message-Id: <1214897247.20711.115.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 13:54 +0200, Johannes Weiner wrote:
> plain text document attachment
> (0015-powerpc-use-generic-show_mem.patch)
> Remove arch-specific show_mem() in favor of the generic version.
> 
> This also removes the following redundant information display:
> 
> 	- pages in swapcache, printed by show_swap_cache_info()
> 
> where show_mem() calls show_free_areas(), which calls
> show_swap_cache_info().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Paul Mackerras <paulus@samba.org>

Looks good to me. Paul, do you know of any userland thingy that might be
unhappy by the change from "%d pages of XXX" to "%d pages RAM" and "%d
reserved pages" to "%s pages reserved" ?

Cheers,
Ben.

> ---
>  arch/powerpc/Kconfig  |    1 +
>  arch/powerpc/mm/mem.c |   39 ---------------------------------------
>  2 files changed, 1 insertion(+), 39 deletions(-)
> 
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -114,6 +114,7 @@ config PPC
>  	select HAVE_KRETPROBES
>  	select HAVE_LMB
>  	select HAVE_OPROFILE
> +	select HAVE_GENERIC_SHOW_MEM
>  	select USE_GENERIC_SMP_HELPERS if SMP
>  
>  config EARLY_PRINTK
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -185,45 +185,6 @@ walk_memory_resource(unsigned long start
>  }
>  EXPORT_SYMBOL_GPL(walk_memory_resource);
>  
> -void show_mem(void)
> -{
> -	unsigned long total = 0, reserved = 0;
> -	unsigned long shared = 0, cached = 0;
> -	unsigned long highmem = 0;
> -	struct page *page;
> -	pg_data_t *pgdat;
> -	unsigned long i;
> -
> -	printk("Mem-info:\n");
> -	show_free_areas();
> -	for_each_online_pgdat(pgdat) {
> -		unsigned long flags;
> -		pgdat_resize_lock(pgdat, &flags);
> -		for (i = 0; i < pgdat->node_spanned_pages; i++) {
> -			if (!pfn_valid(pgdat->node_start_pfn + i))
> -				continue;
> -			page = pgdat_page_nr(pgdat, i);
> -			total++;
> -			if (PageHighMem(page))
> -				highmem++;
> -			if (PageReserved(page))
> -				reserved++;
> -			else if (PageSwapCache(page))
> -				cached++;
> -			else if (page_count(page))
> -				shared += page_count(page) - 1;
> -		}
> -		pgdat_resize_unlock(pgdat, &flags);
> -	}
> -	printk("%ld pages of RAM\n", total);
> -#ifdef CONFIG_HIGHMEM
> -	printk("%ld pages of HIGHMEM\n", highmem);
> -#endif
> -	printk("%ld reserved pages\n", reserved);
> -	printk("%ld pages shared\n", shared);
> -	printk("%ld pages swap cached\n", cached);
> -}
> -
>  /*
>   * Initialize the bootmem system and give it all the memory we
>   * have available.  If we are using highmem, we only put the
> 

