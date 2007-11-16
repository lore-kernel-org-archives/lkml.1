Return-Path: <linux-kernel-owner+w=401wt.eu-S934393AbXKPAx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393AbXKPAx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765600AbXKPAxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:53:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757658AbXKPAxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:53:46 -0500
Date: Thu, 15 Nov 2007 16:53:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       apw@shadowen.org, kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [2/3] fix
 section mismatch in vmammap_allock_block
Message-Id: <20071115165330.9448eab6.akpm@linux-foundation.org>
In-Reply-To: <20071115193544.eb0629e1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193544.eb0629e1.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 19:35:44 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Fixes section mismatch below.
> 
> WARNING: vmlinux.o(.text+0x946b5): Section mismatch: reference to .init.text:'
> __alloc_bootmem_node (between 'vmemmap_alloc_block' and 'vmemmap_pgd_populate')
> 
> Changelog
>  - changed bootmem alloc wrapper function's name to be
> 	__earlyonly_bootmem_alloc().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
>  mm/sparse-vmemmap.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.24-rc2-mm1/mm/sparse-vmemmap.c
> ===================================================================
> --- linux-2.6.24-rc2-mm1.orig/mm/sparse-vmemmap.c
> +++ linux-2.6.24-rc2-mm1/mm/sparse-vmemmap.c
> @@ -34,6 +34,16 @@
>   * or to back the page tables that are used to create the mapping.
>   * Uses the main allocators if they are available, else bootmem.
>   */
> +
> +static void * __init_refok __earlyonly_bootmem_alloc(int node,
> +				unsigned long size,
> +				unsigned long align,
> +				unsigned long goal)
> +{
> +	return __alloc_bootmem_node(NODE_DATA(node), size, align, goal);
> +}
> +
> +
>  void * __meminit vmemmap_alloc_block(unsigned long size, int node)
>  {
>  	/* If the main allocator is up use that, fallback to bootmem. */
> @@ -44,7 +54,7 @@ void * __meminit vmemmap_alloc_block(uns
>  			return page_address(page);
>  		return NULL;
>  	} else
> -		return __alloc_bootmem_node(NODE_DATA(node), size, size,
> +		return __earlyonly_bootmem_alloc(node, size, size,
>  				__pa(MAX_DMA_ADDRESS));
>  }
>  

AFACIT this is applicable to mainline?

