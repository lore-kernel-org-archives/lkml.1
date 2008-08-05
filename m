Return-Path: <linux-kernel-owner+w=401wt.eu-S1764374AbYHEUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764374AbYHEUkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762319AbYHEUjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:39:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757222AbYHEUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:39:51 -0400
Date: Tue, 5 Aug 2008 13:32:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, nacc@us.ibm.com, agl@us.ibm.com
Subject: Re: [PATCH] hugetlb: call arch_prepare_hugepage() for surplus pages
Message-Id: <20080805133216.cc5c14cf.akpm@linux-foundation.org>
In-Reply-To: <1217950147.5032.15.camel@localhost.localdomain>
References: <1217950147.5032.15.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008 17:29:07 +0200
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> The s390 software large page emulation implements shared page tables
> by using page->index of the first tail page from a compound large page
> to store page table information. This is set up in arch_prepare_hugepage(),
> which is called from alloc_fresh_huge_page_node().
> 
> A similar call to arch_prepare_hugepage() is missing for surplus large
> pages that are allocated in alloc_buddy_huge_page(), which breaks the
> software emulation mode for (surplus) large pages on s390. This patch
> adds the missing call to arch_prepare_hugepage(). It will have no effect
> on other architectures where arch_prepare_hugepage() is a nop.
> 
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> ---
> 
>  mm/hugetlb.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux/mm/hugetlb.c
> ===================================================================
> --- linux.orig/mm/hugetlb.c
> +++ linux/mm/hugetlb.c
> @@ -565,7 +565,7 @@ static struct page *alloc_fresh_huge_pag
>  		huge_page_order(h));
>  	if (page) {
>  		if (arch_prepare_hugepage(page)) {
> -			__free_pages(page, HUGETLB_PAGE_ORDER);
> +			__free_pages(page, huge_page_order(h));

As Nick pointed out, this is an unrelated bugfix.  I changelogged it. 
Really it should have been two patches.

>  			return NULL;
>  		}
>  		prep_new_huge_page(h, page, nid);
> @@ -665,6 +665,11 @@ static struct page *alloc_buddy_huge_pag
>  					__GFP_REPEAT|__GFP_NOWARN,
>  					huge_page_order(h));
>  
> +	if (page && arch_prepare_hugepage(page)) {
> +		__free_pages(page, huge_page_order(h));
> +		return NULL;
> +	}
> +
>  	spin_lock(&hugetlb_lock);
>  	if (page) {
>  		/*

afaict the second fix is needed in 2.6.26.x (but not 2.6.25.x), but
this patch is not applicable to 2.6.26.x.

So if you want this fix to be backported into 2.6.26.x, please send a
suitable version of it to stable@kernel.org.

