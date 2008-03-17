Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYCQU1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYCQU1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYCQU1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:27:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48826 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYCQU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:27:07 -0400
Subject: Re: [PATCH] [4/18] Add basic support for more than one hstate in
	hugetlbfs
From: Adam Litke <agl@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317015817.DE00E1B41E0@basil.firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
	 <20080317015817.DE00E1B41E0@basil.firstfloor.org>
Content-Type: text/plain
Organization: IBM
Date: Mon, 17 Mar 2008 15:28:52 -0500
Message-Id: <1205785732.10849.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch you will call try_to_free_low on all registered page
sizes.  As written, when a user reduces the number of one page size, all
page sizes could be affected.  I don't think that's what you want to do.
Perhaps just call do_try_to_free_low() on the hstate in question.

On Mon, 2008-03-17 at 02:58 +0100, Andi Kleen wrote:
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  mm/hugetlb.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> Index: linux/mm/hugetlb.c
> ===================================================================
> --- linux.orig/mm/hugetlb.c
> +++ linux/mm/hugetlb.c
> @@ -550,26 +550,33 @@ static unsigned int cpuset_mems_nr(unsig
> 
>  #ifdef CONFIG_SYSCTL
>  #ifdef CONFIG_HIGHMEM
> -static void try_to_free_low(unsigned long count)
> +static void do_try_to_free_low(struct hstate *h, unsigned long count)
>  {
> -	struct hstate *h = &global_hstate;
>  	int i;
> 
>  	for (i = 0; i < MAX_NUMNODES; ++i) {
>  		struct page *page, *next;
>  		struct list_head *freel = &h->hugepage_freelists[i];
>  		list_for_each_entry_safe(page, next, freel, lru) {
> -			if (count >= nr_huge_pages)
> +			if (count >= h->nr_huge_pages)
>  				return;
>  			if (PageHighMem(page))
>  				continue;
>  			list_del(&page->lru);
> -			update_and_free_page(page);
> +			update_and_free_page(h, page);
>  			h->free_huge_pages--;
>  			h->free_huge_pages_node[page_to_nid(page)]--;
>  		}
>  	}
>  }
> +
> +static void try_to_free_low(unsigned long count)
> +{
> +	struct hstate *h;
> +	for_each_hstate (h) {
> +		do_try_to_free_low(h, count);
> +	}
> +}
>  #else
>  static inline void try_to_free_low(unsigned long count)
>  {
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

