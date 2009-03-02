Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZCBW2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZCBW2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZCBW2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:28:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590AbZCBW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:28:43 -0500
Date: Mon, 2 Mar 2009 14:27:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmtom :  add VM_BUG_ON in __get_free_pages
Message-Id: <20090302142757.1cc014aa.akpm@linux-foundation.org>
In-Reply-To: <20090302183148.a4dfcc22.minchan.kim@barrios-desktop>
References: <20090302183148.a4dfcc22.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 18:31:48 +0900
MinChan Kim <minchan.kim@gmail.com> wrote:

> 
> The __get_free_pages is used in many place. 
> Also, driver developers can use it freely due to export function.
> Some developers might use it to allocate high pages by mistake. 
> 
> The __get_free_pages can allocate high page using alloc_pages, 
> but it can't return linear address for high page.
> 
> Even worse, in this csse, caller can't free page which are there in high zone. 
> So, It would be better to add VM_BUG_ON. 
> 
> It's based on mmtom 2009-02-27-13-54.
>  
> Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
> ---
>  mm/page_alloc.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8294107..381056b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1681,6 +1681,13 @@ EXPORT_SYMBOL(__alloc_pages_internal);
>  unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
>  {
>  	struct page * page;
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

If someone calls __get_free_pages(__GFP_HIGHMEM) then page_address()
will reliably return NULL and the caller's code will oops.

Yes, there's a decent (and increasing) risk that the developer won't be
testing the code on a highmem machine, but there are enough highmem
machines out there that the bug should be discovered pretty quickly.

So I'm not sure that this test is worth the additional overhead to a
fairly frequently called function?

