Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZCETMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZCETMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZCETM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:12:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:53595 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZCETMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:12:25 -0500
Message-ID: <49B023E8.7090309@kernel.org>
Date: Thu, 05 Mar 2009 11:11:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] x86: init_memory_mapping() trivial cleanups
References: <> <1236257708-27269-1-git-send-email-penberg@cs.helsinki.fi>
In-Reply-To: <1236257708-27269-1-git-send-email-penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Impact: cleanup
> 
> To reduce the diff between the 32-bit and 64-bit versions of
> init_memory_mapping(), fix up all trivial issues.
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/mm/init_32.c |   42 +++++++++++++++++++++++++-----------------
>  arch/x86/mm/init_64.c |   26 +++++++++++++++-----------
>  2 files changed, 40 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index c351456..ad4e03c 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -868,11 +868,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
>  
>  	table_start >>= PAGE_SHIFT;
>  	table_end = table_start;
> -	table_top = table_start + (tables>>PAGE_SHIFT);
> +	table_top = table_start + (tables >> PAGE_SHIFT);
>  
>  	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
> -		end, table_start << PAGE_SHIFT,
> -		(table_start << PAGE_SHIFT) + tables);
> +		end, table_start << PAGE_SHIFT, table_top << PAGE_SHIFT);
>  }
>  
>  struct map_range {
> @@ -899,8 +898,13 @@ static int save_mr(struct map_range *mr, int nr_range,
>  	return nr_range;
>  }
>  
> +/*
> + * Setup the direct mapping of the physical memory at PAGE_OFFSET.
> + * This runs before bootmem is initialized and gets pages directly from
> + * the physical memory. To access them they are temporarily mapped.
> + */
>  unsigned long __init_refok init_memory_mapping(unsigned long start,
> -						unsigned long end)
> +					       unsigned long end)
>  {
>  	pgd_t *pgd_base = swapper_pg_dir;
>  	unsigned long page_size_mask = 0;
> @@ -911,7 +915,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	int nr_range, i;
>  	int use_pse;
>  
> -	printk(KERN_INFO "init_memory_mapping: %08lx-%08lx\n", start, end);
> +	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
>  
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  	/*
> @@ -940,19 +944,19 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  		__supported_pte_mask |= _PAGE_GLOBAL;
>  	}
>  
> -	memset(mr, 0, sizeof(mr));
> -	nr_range = 0;
> -
>  	if (use_pse)
>  		page_size_mask |= 1 << PG_LEVEL_2M;
>  
> +	memset(mr, 0, sizeof(mr));
> +	nr_range = 0;
> +
>  	/*
>  	 * Don't use a large page for the first 2/4MB of memory
>  	 * because there are often fixed size MTRRs in there
>  	 * and overlapping MTRRs into large pages can cause
>  	 * slowdowns.
>  	 */
> -	/* head could not be big page alignment ? */
> +	/* head if not big page alignment ? */
>  	start_pfn = start >> PAGE_SHIFT;
>  	pos = start_pfn << PAGE_SHIFT;
>  	if (pos == 0)
> @@ -960,14 +964,14 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	else
>  		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
>  				 << (PMD_SHIFT - PAGE_SHIFT);
> -	if (end_pfn > (end>>PAGE_SHIFT))
> -		end_pfn = end>>PAGE_SHIFT;
> +	if (end_pfn > (end >> PAGE_SHIFT))
> +		end_pfn = end >> PAGE_SHIFT;
>  	if (start_pfn < end_pfn) {
>  		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
>  		pos = end_pfn << PAGE_SHIFT;
>  	}
>  
> -	/* big page range */
> +	/* big page (2M) range */
>  	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
>  			 << (PMD_SHIFT - PAGE_SHIFT);
>  	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
> @@ -977,7 +981,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  		pos = end_pfn << PAGE_SHIFT;
>  	}
>  
> -	/* tail is not big page alignment ? */
> +	/* tail is not big page (2M) alignment */
>  	start_pfn = pos>>PAGE_SHIFT;
>  	end_pfn = end>>PAGE_SHIFT;
>  	if (start_pfn < end_pfn)
> @@ -998,13 +1002,17 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  	}
>  
>  	for (i = 0; i < nr_range; i++)
> -		printk(KERN_DEBUG " %08lx - %08lx page %s\n",
> -			mr[i].start, mr[i].end,
> -			(mr[i].page_size_mask & (1<<PG_LEVEL_2M)) ?
> -				  "big page" : "4k");
> +		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
> +				mr[i].start, mr[i].end,
> +			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
> +			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));

sometime big page on 32bit could be 4M?

YH
