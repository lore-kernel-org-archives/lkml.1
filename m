Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZHCIaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZHCIaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZHCIaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:30:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34133 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbZHCI37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:29:59 -0400
Date: Mon, 3 Aug 2009 09:29:59 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Hellstrom <thellstrom@vmware.com>,
       Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] x86: Fix CPA memtype reserving in the set_pages_array
 cases
In-Reply-To: <20090803081110.GB32258@elte.hu>
Message-ID: <alpine.DEB.2.00.0908030928280.496@skynet.skynet.ie>
References: <1249284345-7654-1-git-send-email-thellstrom@vmware.com> <20090803081110.GB32258@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> hm, i'm missing a description about how this bug was 
> triggered. How did you end up getting highmem pages to a cpa 
> call?

GEM and TTM both allocate page arrays and just pass them to cpa,
we don't know what type of pages the allocator gives us back and we really 
shouldn't have to, so having cpa ignore highmem pages is certainly the 
right option.

GEM just uses shmem code to alloc the pages and TTM has its own allocator.

Dave.

 > 
> >  	else
> >  		address = *cpa->vaddr;
> > @@ -696,9 +699,12 @@ static int cpa_process_alias(struct cpa_data *cpa)
> >  	 * No need to redo, when the primary call touched the direct
> >  	 * mapping already:
> >  	 */
> > -	if (cpa->flags & CPA_PAGES_ARRAY)
> > -		vaddr = (unsigned long)page_address(cpa->pages[cpa->curpage]);
> > -	else if (cpa->flags & CPA_ARRAY)
> > +	if (cpa->flags & CPA_PAGES_ARRAY) {
> > +		struct page *page = cpa->pages[cpa->curpage];
> > +		if (unlikely(PageHighMem(page)))
> > +			return 0;
> > +		vaddr = (unsigned long)page_address(page);
> > +	} else if (cpa->flags & CPA_ARRAY)
> >  		vaddr = cpa->vaddr[cpa->curpage];
> >  	else
> >  		vaddr = *cpa->vaddr;
> > @@ -1118,7 +1124,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
> >  	int free_idx;
> >  
> >  	for (i = 0; i < addrinarray; i++) {
> > -		start = (unsigned long)page_address(pages[i]);
> > +		if (PageHighMem(pages[i]))
> > +			continue;
> > +		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
> >  		end = start + PAGE_SIZE;
> >  		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
> >  			goto err_out;
> 
> ok, that's a bug introduced in .29 but which was latent until now: 
> drivers/char/agp/generic.c now uses it plus (indirectly) a number of 
> AGP drivers, since:
> 
>  commit 07613ba2f464f59949266f4337b75b91eb610795
>  Author: Dave Airlie <airlied@redhat.com>
>  Date:   Fri Jun 12 14:11:41 2009 +1000
> 
>      agp: switch AGP to use page array instead of unsigned long array
> 
> I dont see how it can end up with highmem pages though. All 
> the graphics apperture allocations happen to lowmem AFAICS. 
> Did GEM add the possibility for user pages (highmem amongst 
> them) ending up in that pool? Which code does that?
> 
> > @@ -1131,7 +1139,9 @@ int set_pages_array_uc(struct page **pages, int addrinarray)
> >  err_out:
> >  	free_idx = i;
> >  	for (i = 0; i < free_idx; i++) {
> > -		start = (unsigned long)page_address(pages[i]);
> > +		if (PageHighMem(pages[i]))
> > +			continue;
> > +		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
> >  		end = start + PAGE_SIZE;
> >  		free_memtype(start, end);
> >  	}
> > @@ -1160,7 +1170,9 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
> >  		return retval;
> >  
> >  	for (i = 0; i < addrinarray; i++) {
> > -		start = (unsigned long)page_address(pages[i]);
> > +		if (PageHighMem(pages[i]))
> > +			continue;
> > +		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
> >  		end = start + PAGE_SIZE;
> >  		free_memtype(start, end);
> 
> In any case it's a must-have fix for .31. Possibly even a backport 
> tag is needed, in case a distro does a .30 kernel with more recent 
> graphics bits.
> 
> 	Ingo
> 
> ------------------------------------------------------------------------------
> Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day 
> trial. Simplify your report design, integration and deployment - and focus on 
> what you do best, core application coding. Discover what's new with 
> Crystal Reports now.  http://p.sf.net/sfu/bobj-july
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 
