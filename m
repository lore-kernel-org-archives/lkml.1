Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZHCIL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZHCIL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZHCIL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:11:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbZHCIL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:11:27 -0400
Date: Mon, 3 Aug 2009 10:11:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Hellstrom <thellstrom@vmware.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       hpa@zytor.com, tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] x86: Fix CPA memtype reserving in the set_pages_array
	cases
Message-ID: <20090803081110.GB32258@elte.hu>
References: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249284345-7654-1-git-send-email-thellstrom@vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Hellstrom <thellstrom@vmware.com> wrote:

> Bug #13884
> The code was incorrectly reserving memtypes using the page
> virtual address instead of the physical address. Furthermore,
> the code was not ignoring highmem pages as it ought to.
> 
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> ---
>  arch/x86/mm/pageattr.c |   30 +++++++++++++++++++++---------
>  1 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index d4327db..96dd4f6 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -590,9 +590,12 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
>  	unsigned int level;
>  	pte_t *kpte, old_pte;
>  
> -	if (cpa->flags & CPA_PAGES_ARRAY)
> -		address = (unsigned long)page_address(cpa->pages[cpa->curpage]);
> -	else if (cpa->flags & CPA_ARRAY)
> +	if (cpa->flags & CPA_PAGES_ARRAY) {
> +		struct page *page = cpa->pages[cpa->curpage];
> +		if (unlikely(PageHighMem(page)))
> +			return 0;
> +		address = (unsigned long)page_address(page);
> +	} else if (cpa->flags & CPA_ARRAY)
>  		address = cpa->vaddr[cpa->curpage];

hm, i'm missing a description about how this bug was 
triggered. How did you end up getting highmem pages to a cpa 
call?

>  	else
>  		address = *cpa->vaddr;
> @@ -696,9 +699,12 @@ static int cpa_process_alias(struct cpa_data *cpa)
>  	 * No need to redo, when the primary call touched the direct
>  	 * mapping already:
>  	 */
> -	if (cpa->flags & CPA_PAGES_ARRAY)
> -		vaddr = (unsigned long)page_address(cpa->pages[cpa->curpage]);
> -	else if (cpa->flags & CPA_ARRAY)
> +	if (cpa->flags & CPA_PAGES_ARRAY) {
> +		struct page *page = cpa->pages[cpa->curpage];
> +		if (unlikely(PageHighMem(page)))
> +			return 0;
> +		vaddr = (unsigned long)page_address(page);
> +	} else if (cpa->flags & CPA_ARRAY)
>  		vaddr = cpa->vaddr[cpa->curpage];
>  	else
>  		vaddr = *cpa->vaddr;
> @@ -1118,7 +1124,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
>  	int free_idx;
>  
>  	for (i = 0; i < addrinarray; i++) {
> -		start = (unsigned long)page_address(pages[i]);
> +		if (PageHighMem(pages[i]))
> +			continue;
> +		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
>  		end = start + PAGE_SIZE;
>  		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
>  			goto err_out;

ok, that's a bug introduced in .29 but which was latent until now: 
drivers/char/agp/generic.c now uses it plus (indirectly) a number of 
AGP drivers, since:

 commit 07613ba2f464f59949266f4337b75b91eb610795
 Author: Dave Airlie <airlied@redhat.com>
 Date:   Fri Jun 12 14:11:41 2009 +1000

     agp: switch AGP to use page array instead of unsigned long array

I dont see how it can end up with highmem pages though. All 
the graphics apperture allocations happen to lowmem AFAICS. 
Did GEM add the possibility for user pages (highmem amongst 
them) ending up in that pool? Which code does that?

> @@ -1131,7 +1139,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
>  err_out:
>  	free_idx = i;
>  	for (i = 0; i < free_idx; i++) {
> -		start = (unsigned long)page_address(pages[i]);
> +		if (PageHighMem(pages[i]))
> +			continue;
> +		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
>  		end = start + PAGE_SIZE;
>  		free_memtype(start, end);
>  	}
> @@ -1160,7 +1170,9 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
>  		return retval;
>  
>  	for (i = 0; i < addrinarray; i++) {
> -		start = (unsigned long)page_address(pages[i]);
> +		if (PageHighMem(pages[i]))
> +			continue;
> +		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
>  		end = start + PAGE_SIZE;
>  		free_memtype(start, end);

In any case it's a must-have fix for .31. Possibly even a backport 
tag is needed, in case a distro does a .30 kernel with more recent 
graphics bits.

	Ingo
