Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZFANKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZFANKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbZFANKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:10:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:45608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZFANKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:10:34 -0400
Date: Mon, 1 Jun 2009 15:10:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       cl@linux-foundation.com, torvals@linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] slab: remove bootmem calling
Message-ID: <20090601131035.GB1422@wotan.suse.de>
References: <1243517365.11533.65.camel@penberg-laptop> <4A1F35ED.4000405@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1F35ED.4000405@kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 06:10:05PM -0700, Yinghai Lu wrote:
> mem_init/kmem_cache_init is moved up

Is there a way we could start documenting/improving these
dependencies of bootup stuff? A comment with depends/provides
lines?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  mm/page_cgroup.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/mm/page_cgroup.c
> ===================================================================
> --- linux-2.6.orig/mm/page_cgroup.c
> +++ linux-2.6/mm/page_cgroup.c
> @@ -47,6 +47,8 @@ static int __init alloc_node_page_cgroup
>  	struct page_cgroup *base, *pc;
>  	unsigned long table_size;
>  	unsigned long start_pfn, nr_pages, index;
> +	struct page *page;
> +	unsigned int order;
>  
>  	start_pfn = NODE_DATA(nid)->node_start_pfn;
>  	nr_pages = NODE_DATA(nid)->node_spanned_pages;
> @@ -55,11 +57,13 @@ static int __init alloc_node_page_cgroup
>  		return 0;
>  
>  	table_size = sizeof(struct page_cgroup) * nr_pages;
> -
> -	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
> -			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
> -	if (!base)
> +	order = get_order(table_size);
> +	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
> +	if (!page)
> +		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);
> +	if (!page)
>  		return -ENOMEM;
> +	base = page_address(page);
>  	for (index = 0; index < nr_pages; index++) {
>  		pc = base + index;
>  		__init_page_cgroup(pc, start_pfn + index);
