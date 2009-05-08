Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbZEHLk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbZEHLk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZEHLku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:40:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57784 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZEHLkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:40:49 -0400
Date: Fri, 8 May 2009 13:40:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] mm: introduce PageHuge() for testing huge/gigantic
	pages
Message-ID: <20090508114018.GA17129@elte.hu>
References: <20090508105320.316173813@intel.com> <20090508111030.264063904@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508111030.264063904@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> Introduce PageHuge(), which identifies huge/gigantic pages
> by their dedicated compound destructor functions.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/mm.h |   24 ++++++++++++++++++++++++
>  mm/hugetlb.c       |    2 +-
>  mm/page_alloc.c    |   11 ++++++++++-
>  3 files changed, 35 insertions(+), 2 deletions(-)
> 
> --- linux.orig/mm/page_alloc.c
> +++ linux/mm/page_alloc.c
> @@ -299,13 +299,22 @@ void prep_compound_page(struct page *pag
>  }
>  
>  #ifdef CONFIG_HUGETLBFS
> +/*
> + * This (duplicated) destructor function distinguishes gigantic pages from
> + * normal compound pages.
> + */
> +void free_gigantic_page(struct page *page)
> +{
> +	__free_pages_ok(page, compound_order(page));
> +}
> +
>  void prep_compound_gigantic_page(struct page *page, unsigned long order)
>  {
>  	int i;
>  	int nr_pages = 1 << order;
>  	struct page *p = page + 1;
>  
> -	set_compound_page_dtor(page, free_compound_page);
> +	set_compound_page_dtor(page, free_gigantic_page);
>  	set_compound_order(page, order);
>  	__SetPageHead(page);
>  	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
> --- linux.orig/mm/hugetlb.c
> +++ linux/mm/hugetlb.c
> @@ -550,7 +550,7 @@ struct hstate *size_to_hstate(unsigned l
>  	return NULL;
>  }
>  
> -static void free_huge_page(struct page *page)
> +void free_huge_page(struct page *page)
>  {
>  	/*
>  	 * Can't pass hstate in here because it is called from the
> --- linux.orig/include/linux/mm.h
> +++ linux/include/linux/mm.h
> @@ -355,6 +355,30 @@ static inline void set_compound_order(st
>  	page[1].lru.prev = (void *)order;
>  }
>  
> +#ifdef CONFIG_HUGETLBFS
> +void free_huge_page(struct page *page);
> +void free_gigantic_page(struct page *page);
> +
> +static inline int PageHuge(struct page *page)
> +{
> +	compound_page_dtor *dtor;
> +
> +	if (!PageCompound(page))
> +		return 0;
> +
> +	page = compound_head(page);
> +	dtor = get_compound_page_dtor(page);
> +
> +	return  dtor == free_huge_page ||
> +		dtor == free_gigantic_page;
> +}

Hm, this function is _way_ too large to be inlined.

	Ingo
