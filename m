Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZKJMFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZKJMFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZKJMFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:05:52 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:36034 "EHLO cmpxchg.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZKJMFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:05:51 -0500
Date: Tue, 10 Nov 2009 13:00:53 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, chrisw@sous-sol.org,
       wmw2@infradead.org, joerg.roedel@amd.com, muli@il.ibm.com,
       akpm@linux-foundation.org, tj@kernel.org
Subject: Re: [PATCH -v2 6/9] bootmem: add free_bootmem_late
Message-ID: <20091110120053.GA14940@cmpxchg.org>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 07:46:17PM +0900, FUJITA Tomonori wrote:
> Add a new function for freeing bootmem after the bootmem allocator has
> been released and the unreserved pages given to the page allocator.
> This allows us to reserve bootmem and then release it if we later
> discover it was not needed.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: hannes@cmpxchg.org
> Cc: akpm@linux-foundation.org
> Cc: tj@kernel.org
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  include/linux/bootmem.h |    1 +
>  mm/bootmem.c            |   24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
> index dd97fb8..b10ec49 100644
> --- a/include/linux/bootmem.h
> +++ b/include/linux/bootmem.h
> @@ -53,6 +53,7 @@ extern void free_bootmem_node(pg_data_t *pgdat,
>  			      unsigned long addr,
>  			      unsigned long size);
>  extern void free_bootmem(unsigned long addr, unsigned long size);
> +extern void free_bootmem_late(unsigned long addr, unsigned long size);
>  
>  /*
>   * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index ca92991..30f1702 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -143,6 +143,30 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
>  	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
>  }
>  
> +/*
> + * free_bootmem_late - free bootmem pages directly to page allocator
> + * @addr: starting address of the range
> + * @size: size of the range in bytes
> + *
> + * This is only useful when the bootmem allocator has already been torn
> + * down, but we are still initializing the system.  Pages are given directly
> + * to the page allocator, no bootmem metadata is updated because it is gone.
> + */
> +void __init free_bootmem_late(unsigned long addr, unsigned long size)
> +{
> +	unsigned long cursor, end;
> +
> +	kmemleak_free_part(__va(addr), size);
> +
> +	cursor = PFN_UP(addr);
> +	end = PFN_DOWN(addr + size);
> +
> +	for (; cursor < end; cursor++) {
> +		__free_pages_bootmem(pfn_to_page(cursor), 0);
> +		totalram_pages++;
> +	}
> +}

I find it a bit weird that free_all_bootmem() callers have to take
care of totalram_pages while this function does the accounting on its
own.

And I think the function is more logically placed right below
free_bootmem(), like you did in the header.

These are no show-stoppers for me, though, and otherwise the patch
looks simple and straight-forward.  Feel free to add

	Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!
