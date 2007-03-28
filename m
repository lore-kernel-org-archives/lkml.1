Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbXC1W1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbXC1W1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXC1W1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:27:48 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45465 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbXC1W1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:27:47 -0400
Date: Wed, 28 Mar 2007 15:26:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, William Lee Irwin III <wli@holomorphy.com>,
       akpm@linux-foundation.org, jeremy@goop.org, zach@vmware.com
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328222656.GS6602@sequoia.sous-sol.org>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> +#ifdef CONFIG_HIGHMEM64G
> +#define __pgd_alloc()		kmem_cache_alloc(pgd_cache, GFP_KERNEL|__GFP_REPEAT)
> +#define __pgd_free(pgd)		kmem_cache_free(pgd_cache, pgd)

I must've glazed over something, I thought this was removal of slabs?

BTW, this will interact shared_kernel_pmd patch that Jeremy's posted a
few times (I know at least wli has looked over that one).  We need to
make sure that PAE under at least Xen hypervisor has a page-sized pgd,
although the mmlist chaining looks nice to me.

> +static struct kmem_cache *pgd_cache;
> +
> +void __init pgtable_cache_init(void)
> +{
> +	pgd_cache = kmem_cache_create("pgd",
> +				PTRS_PER_PGD*sizeof(pgd_t),
> +				PTRS_PER_PGD*sizeof(pgd_t),
> +				SLAB_PANIC,
> +				NULL,
> +				NULL);
> +}
> +#else /* !CONFIG_HIGHMEM64G */
> +#define __pgd_alloc()		((pgd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT))
> +#define __pgd_free(pgd)		free_page((unsigned long)(pgd))
> +#endif /* !CONFIG_HIGHMEM64G */
>  
>  pgd_t *pgd_alloc(struct mm_struct *mm)
>  {
>  	int i;
> -	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
> +	pgd_t *pgd = __pgd_alloc();
>  
> -	if (PTRS_PER_PMD == 1 || !pgd)
> +	if (!pgd)
> +		return NULL;
> +	memcpy(&pgd[USER_PTRS_PER_PGD], &swapper_pg_dir[USER_PTRS_PER_PGD],
> +						KERNEL_PGD_PTRS*sizeof(pgd_t));

clone_pgd_range() for consistency?  and it seems we lost a paravirt_alloc_pd_clone()
in there somewhere.

> +	if (PTRS_PER_PMD == 1)
>  		return pgd;
