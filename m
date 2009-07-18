Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbZGRAle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbZGRAle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 20:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZGRAld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 20:41:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbZGRAld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 20:41:33 -0400
Date: Fri, 17 Jul 2009 17:41:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add gfp mask checking for __get_free_pages()
Message-Id: <20090717174128.36d00972.akpm@linux-foundation.org>
In-Reply-To: <20090704020949.GA3047@localhost.localdomain>
References: <20090704020949.GA3047@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jul 2009 11:09:50 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> __get_free_pages() with __GFP_HIGHMEM is not safe because the return
> address cannot represent a highmem page. get_zeroed_page() already has
> such a debug checking.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  mm/page_alloc.c |   24 +++++++++---------------
>  1 files changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e0f2cdf..4a1a374 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1903,31 +1903,25 @@ EXPORT_SYMBOL(__alloc_pages_nodemask);
>   */
>  unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
>  {
> -	struct page * page;
> +	struct page *page;
> +
> +	/*
> +	 * __get_free_pages() returns a 32-bit address, which cannot represent
> +	 * a highmem page
> +	 */
> +	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
> +
>  	page = alloc_pages(gfp_mask, order);
>  	if (!page)
>  		return 0;
>  	return (unsigned long) page_address(page);
>  }
> -
>  EXPORT_SYMBOL(__get_free_pages);
>  
>  unsigned long get_zeroed_page(gfp_t gfp_mask)
>  {
> -	struct page * page;
> -
> -	/*
> -	 * get_zeroed_page() returns a 32-bit address, which cannot represent
> -	 * a highmem page
> -	 */
> -	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
> -
> -	page = alloc_pages(gfp_mask | __GFP_ZERO, 0);
> -	if (page)
> -		return (unsigned long) page_address(page);
> -	return 0;
> +	return __get_free_pages(gfp_mask | __GFP_ZERO, 0);
>  }
> -
>  EXPORT_SYMBOL(get_zeroed_page);
>  
>  void __pagevec_free(struct pagevec *pvec)

Fair enough.

I suspect we could just delete that VM_BUG_ON() - we can't go and do
runtime checking for every darn programmer error, and this would be a
pretty dumb one.


Your patch turns get_zeroed_page() into a simple one-liner wrapper
around __get_free_pages().  We could perhaps save some .text, some
kernel stack and some CPU cycles by inlining get_zeroed_page().

