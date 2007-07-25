Return-Path: <linux-kernel-owner+w=401wt.eu-S933066AbXGYQZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbXGYQZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXGYQZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:25:38 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1626 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbXGYQZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:25:37 -0400
Message-ID: <46A7797A.6070908@shadowen.org>
Date: Wed, 25 Jul 2007 17:25:30 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, bob.picco@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of memmap on IA64 SPARSEMEM when mem_section
 is not a power of 2
References: <20070313104201.GA16842@skynet.ie> <20070724220116.0d9fb8b5.akpm@linux-foundation.org> <20070725144944.GD32445@skynet.ie>
In-Reply-To: <20070725144944.GD32445@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (24/07/07 22:01), Andrew Morton didst pronounce:
>> On Tue, 13 Mar 2007 10:42:02 +0000 mel@skynet.ie (Mel Gorman) wrote:
>>
>>> There are problems in the use of SPARSEMEM and pageblock flags that causes
>>> problems on ia64.
>>>
>>> <SNIP>
>> SuperH allmodconfig blew up:
>>
>> mm/sparse.c: In function `sparse_init':
>> mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
>> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
>> mm/sparse.c: In function `sparse_add_one_section':
>> mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
>> mm/sparse.c:553: warning: assignment makes pointer from integer without a cast
> 
> This error is due to a bad interaction between
> generic-virtual-memmap-support-for-sparsemem.patch and
> fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
> . Functions that are needed whether CONFIG_SPARSEMEM_VMEMMAP is set are
> not are depending on CONFIG_SPARSEMEM_VMEMMAP . This breaks on arch/sh
> for example where SPARSEMEM may be set but not NUMA.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> ---
>  sparse.c |   58 +++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
> 
> 
> diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc1-mm1-clean/mm/sparse.c linux-2.6.23-rc1-mm1-005-sh-sparsemem-fix/mm/sparse.c
> --- linux-2.6.23-rc1-mm1-clean/mm/sparse.c	2007-07-25 13:43:30.000000000 +0100
> +++ linux-2.6.23-rc1-mm1-005-sh-sparsemem-fix/mm/sparse.c	2007-07-25 14:27:58.000000000 +0100
> @@ -220,6 +220,35 @@ void *alloc_bootmem_high_node(pg_data_t 
>  	return NULL;
>  }
>  
> +static unsigned long usemap_size(void)
> +{
> +	unsigned long size_bytes;
> +	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
> +	size_bytes = roundup(size_bytes, sizeof(unsigned long));
> +	return size_bytes;
> +}
> +
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +static unsigned long *__kmalloc_section_usemap(void)
> +{
> +	return kmalloc(usemap_size(), GFP_KERNEL);
> +}
> +#endif /* CONFIG_MEMORY_HOTPLUG */
> +
> +static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
> +{
> +	unsigned long *usemap;
> +	struct mem_section *ms = __nr_to_section(pnum);
> +	int nid = sparse_early_nid(ms);
> +
> +	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
> +	if (usemap)
> +		return usemap;
> +
> +	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
> +	return NULL;
> +}
> +
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>  /*
>   * Virtual Memory Map support
> @@ -254,35 +283,6 @@ void *alloc_bootmem_high_node(pg_data_t 
>   * 	require one PTE/TLB per PAGE_SIZE chunk of the virtual memory map.
>   */
>  
> -static unsigned long usemap_size(void)
> -{
> -	unsigned long size_bytes;
> - 	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
> -	size_bytes = roundup(size_bytes, sizeof(unsigned long));
> -	return size_bytes;
> -}
> -
> -#ifdef CONFIG_MEMORY_HOTPLUG
> -static unsigned long *__kmalloc_section_usemap(void)
> -{
> -	return kmalloc(usemap_size(), GFP_KERNEL);
> -}
> -#endif /* CONFIG_MEMORY_HOTPLUG */
> -
> -static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
> -{
> -	unsigned long *usemap;
> -	struct mem_section *ms = __nr_to_section(pnum);
> -	int nid = sparse_early_nid(ms);
> -
> -	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
> -	if (usemap)
> -		return usemap;
> -
> -	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
> -	return NULL;
> -}
> -
>  /*
>   * Allocate a block of memory to be used to back the virtual memory map
>   * or to back the page tables that are used to create the mapping.

This also affects NUMA-Q in some SPARSEMEM configurations.  Applying
this fixes it up.

Looks very much like diff has dropped the stuff within my #ifdef
'incorrectly' and as such is a merge error.  This should probabally be
considered a fix to this patch:

fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch

Acked-by: Andy Whitcroft <apw@shadowen.org>

-apw
