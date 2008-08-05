Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYHEPgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYHEPgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbYHEPg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:36:28 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:47421 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759137AbYHEPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:36:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kquGiu9pGwtIVs+xMCGi7YLJtZV/v20FJWi3sSaW2YG/QZv0e/A/Nxqqijzg8x7F+g9awI6uzRkwiUYxW8S2ids7eGKK/C8GNWaovHGx3lExGQryaMKSYtW6WXRVQqMX6bOkJZF0C3O318+CnDMgL/6rzB7Fv9/6j+oJNTZXe+E=  ;
X-YMail-OSG: AyGfOYUVM1nqv_mnNR0GqFsmsRUxi988aLNaLjplVfxBClCLBaN5UCRAkKAKAbMIhTySLIjC.qlOVt0u3DeiMKNDM2GPJolSB_O0yVJRwNUlRUMGWPuvmL8xOKgC2me9FI0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH] hugetlb: call arch_prepare_hugepage() for surplus pages
Date: Wed, 6 Aug 2008 01:36:16 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@us.ibm.com>
References: <1217950147.5032.15.camel@localhost.localdomain>
In-Reply-To: <1217950147.5032.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808060136.17277.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 01:29, Gerald Schaefer wrote:
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
>  			return NULL;
>  		}
>  		prep_new_huge_page(h, page, nid);

This looks like a seperate bugfix?


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

Acked-by: Nick Piggin <npiggin@suse.de>
