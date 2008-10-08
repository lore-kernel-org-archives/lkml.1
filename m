Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYJHMcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYJHMcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 08:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYJHMb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 08:31:56 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:43473 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753775AbYJHMbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:31:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NK9aCn3ZRZwmxomC2ab6HEn2b1/qAcntUMtPG83F7GpLnS+DMKu4WkCYYXoeNjeWJcC/77u+KJTxO1hLUYLckn/JIMXlyFBe/ZWEOKQtlPV8p9m1AwyX6Cto0IJ6jFqT59vvQ23I4yxAGa9xRocfQn8NHWbGe/WiylvHNi/I5QY=  ;
X-YMail-OSG: GCG9NtwVM1m63g9Hljx7wlVlb7HLqFx5Tf.dI6mYkNWP8W3i7lSGravZwmAHexSbmnVM.xwX15HcOlXsXYj0ekdusdRnR9jvzw3gbLDLyuQHhOc8oqTTuRtXIGqlZ_Nlo2v9d8Op.Im6DsBUi5jVXEj0ywIM6SnDHcdyEur9qTTbhq1Gdc8CdGBMVQXb
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/1] hugetlb: pull gigantic page initialisation out of the default path
Date: Wed, 8 Oct 2008 23:31:45 +1100
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
References: <1223458499-12752-1-git-send-email-apw@shadowen.org>
In-Reply-To: <1223458499-12752-1-git-send-email-apw@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810082331.45359.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 20:34, Andy Whitcroft wrote:
> As we can determine exactly when a gigantic page is in use we can optimise
> the common regular page cases by pulling out gigantic page initialisation
> into its own function.  As gigantic pages are never released to buddy we
> do not need a destructor.  This effectivly reverts the previous change
> to the main buddy allocator.  It also adds a paranoid check to ensure we
> never release gigantic pages from hugetlbfs to the main buddy.

Thanks for doing this. Can prep_compound_gigantic_page be #ifdef HUGETLB?


> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> ---
>  mm/hugetlb.c    |    4 +++-
>  mm/internal.h   |    1 +
>  mm/page_alloc.c |   26 +++++++++++++++++++-------
>  3 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bb5cf81..716b151 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -460,6 +460,8 @@ static void update_and_free_page(struct hstate *h,
> struct page *page) {
>  	int i;
>
> +	BUG_ON(h->order >= MAX_ORDER);
> +
>  	h->nr_huge_pages--;
>  	h->nr_huge_pages_node[page_to_nid(page)]--;
>  	for (i = 0; i < pages_per_huge_page(h); i++) {
> @@ -984,7 +986,7 @@ static void __init gather_bootmem_prealloc(void)
>  		struct hstate *h = m->hstate;
>  		__ClearPageReserved(page);
>  		WARN_ON(page_count(page) != 1);
> -		prep_compound_page(page, h->order);
> +		prep_compound_gigantic_page(page, h->order);
>  		prep_new_huge_page(h, page, page_to_nid(page));
>  	}
>  }
> diff --git a/mm/internal.h b/mm/internal.h
> index 08b8dea..92729ea 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -17,6 +17,7 @@ void free_pgtables(struct mmu_gather *tlb, struct
> vm_area_struct *start_vma, unsigned long floor, unsigned long ceiling);
>
>  extern void prep_compound_page(struct page *page, unsigned long order);
> +extern void prep_compound_gigantic_page(struct page *page, unsigned long
> order);
>
>  static inline void set_page_count(struct page *page, int v)
>  {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 27b8681..dbeb3f8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -268,14 +268,28 @@ void prep_compound_page(struct page *page, unsigned
> long order) {
>  	int i;
>  	int nr_pages = 1 << order;
> +
> +	set_compound_page_dtor(page, free_compound_page);
> +	set_compound_order(page, order);
> +	__SetPageHead(page);
> +	for (i = 1; i < nr_pages; i++) {
> +		struct page *p = page + i;
> +
> +		__SetPageTail(p);
> +		p->first_page = page;
> +	}
> +}
> +
> +void prep_compound_gigantic_page(struct page *page, unsigned long order)
> +{
> +	int i;
> +	int nr_pages = 1 << order;
>  	struct page *p = page + 1;
>
>  	set_compound_page_dtor(page, free_compound_page);
>  	set_compound_order(page, order);
>  	__SetPageHead(page);
> -	for (i = 1; i < nr_pages; i++, p++) {
> -		if (unlikely((i & (MAX_ORDER_NR_PAGES - 1)) == 0))
> -			p = pfn_to_page(page_to_pfn(page) + i);
> +	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
>  		__SetPageTail(p);
>  		p->first_page = page;
>  	}
> @@ -285,7 +299,6 @@ static void destroy_compound_page(struct page *page,
> unsigned long order) {
>  	int i;
>  	int nr_pages = 1 << order;
> -	struct page *p = page + 1;
>
>  	if (unlikely(compound_order(page) != order))
>  		bad_page(page);
> @@ -293,9 +306,8 @@ static void destroy_compound_page(struct page *page,
> unsigned long order) if (unlikely(!PageHead(page)))
>  			bad_page(page);
>  	__ClearPageHead(page);
> -	for (i = 1; i < nr_pages; i++, p++) {
> -		if (unlikely((i & (MAX_ORDER_NR_PAGES - 1)) == 0))
> -			p = pfn_to_page(page_to_pfn(page) + i);
> +	for (i = 1; i < nr_pages; i++) {
> +		struct page *p = page + i;
>
>  		if (unlikely(!PageTail(p) |
>  				(p->first_page != page)))
