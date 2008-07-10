Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYGJHNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYGJHNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYGJHNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:13:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49326 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYGJHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:13:06 -0400
Subject: Re: SL*B: drop kmem cache argument from constructor
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, mpm@selenic.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <20080710011132.GA8327@martell.zuzino.mipt.ru>
References: <20080710011132.GA8327@martell.zuzino.mipt.ru>
Date: Thu, 10 Jul 2008 10:13:04 +0300
Message-Id: <1215673985.6165.72.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

[Fixing up Andrew's email address.]

On Thu, 2008-07-10 at 05:11 +0400, Alexey Dobriyan wrote:
> Kmem cache passed to constructor is only needed for constructors that are
> themselves multiplexeres. Nobody uses this "feature", nor does anybody uses
> passed kmem cache in non-trivial way, so pass only pointer to object.
> 
> Non-trivial places are:
> 	arch/powerpc/mm/init_64.c
> 	arch/powerpc/mm/hugetlbpage.c
> 
> This is flag day, yes.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

However...

> --- a/arch/powerpc/mm/hugetlbpage.c
> +++ b/arch/powerpc/mm/hugetlbpage.c
> @@ -595,9 +595,9 @@ static int __init hugepage_setup_sz(char *str)
>  }
>  __setup("hugepagesz=", hugepage_setup_sz);
>  
> -static void zero_ctor(struct kmem_cache *cache, void *addr)
> +static void zero_ctor(void *addr)
>  {
> -	memset(addr, 0, kmem_cache_size(cache));
> +	memset(addr, 0, HUGEPTE_TABLE_SIZE);
>  }
>  
>  static int __init hugetlbpage_init(void)
> --- a/arch/powerpc/mm/init_64.c
> +++ b/arch/powerpc/mm/init_64.c
> @@ -136,9 +136,14 @@ static int __init setup_kcore(void)
>  module_init(setup_kcore);
>  #endif
>  
> -static void zero_ctor(struct kmem_cache *cache, void *addr)
> +static void pgd_ctor(void *addr)
>  {
> -	memset(addr, 0, kmem_cache_size(cache));
> +	memset(addr, 0, PGD_TABLE_SIZE);
> +}
> +
> +static void pmd_ctor(void *addr)
> +{
> +	memset(addr, 0, PMD_TABLE_SIZE);
>  }
>  
>  static const unsigned int pgtable_cache_size[2] = {
> @@ -163,19 +168,8 @@ struct kmem_cache *pgtable_cache[ARRAY_SIZE(pgtable_cache_size)];
>  
>  void pgtable_cache_init(void)
>  {
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(pgtable_cache_size); i++) {
> -		int size = pgtable_cache_size[i];
> -		const char *name = pgtable_cache_name[i];
> -
> -		pr_debug("Allocating page table cache %s (#%d) "
> -			"for size: %08x...\n", name, i, size);
> -		pgtable_cache[i] = kmem_cache_create(name,
> -						     size, size,
> -						     SLAB_PANIC,
> -						     zero_ctor);
> -	}
> +	pgtable_cache[0] = kmem_cache_create(pgtable_cache_name[0], PGD_TABLE_SIZE, PGD_TABLE_SIZE, SLAB_PANIC, pgd_ctor);
> +	pgtable_cache[1] = kmem_cache_create(pgtable_cache_name[1], PMD_TABLE_SIZE, PMD_TABLE_SIZE, SLAB_PANIC, pmd_ctor);
>  }

Can we please have these hunks merged first so that the final patch
which removes the 'cache' argument from the function signature has no
functional changes?

		Pekka

