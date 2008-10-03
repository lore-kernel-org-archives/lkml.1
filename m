Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYJCGnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYJCGnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYJCGni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:43:38 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:42833 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753331AbYJCGnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:43:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M340TZeu4UWw79+EUTp+j5ZW7BHkQaeb2PoMmdyVjYhn6HYeoifIrKkCgkZEibXvyJy6fcIsBSSYjQGDvRQ3ys8hMra2/5L4jS6Hn50PKW8I5ctiZ/nrmiMJ/V7lgQIVKxLcOe3J00xkquJrc9QFBrkLySohjh5jjdsY1mV3wIg=  ;
X-YMail-OSG: CDcqPhkVM1mwBaNDgfPgEWSVHE2fmeALowU3_50QiGjnz97Bk8OV7x9KfZZmoJbF4m2HlI.8_Iu70y1Ui9o6SEQcUwnXzcMZXworpLFD9Qvj7cl9saXledrbukBr7ixb4zIrUAv6KNgDM2yvj_qbSwDMyYHZyC5Bguc_fsjmEkYzxepDuS0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] handle initialising compound pages at orders greater than MAX_ORDER
Date: Fri, 3 Oct 2008 16:43:28 +1000
User-Agent: KMail/1.9.5
Cc: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kniht@linux.vnet.ibm.com, mel@csn.ul.ie
References: <1222964396-25031-1-git-send-email-apw@shadowen.org> <20081002143004.5fec3952.akpm@linux-foundation.org>
In-Reply-To: <20081002143004.5fec3952.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031643.28731.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 07:30, Andrew Morton wrote:
> On Thu,  2 Oct 2008 17:19:56 +0100
>
> Andy Whitcroft <apw@shadowen.org> wrote:
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -268,13 +268,14 @@ void prep_compound_page(struct page *page, unsigned
> > long order) {
> >  	int i;
> >  	int nr_pages = 1 << order;
> > +	struct page *p = page + 1;
> >
> >  	set_compound_page_dtor(page, free_compound_page);
> >  	set_compound_order(page, order);
> >  	__SetPageHead(page);
> > -	for (i = 1; i < nr_pages; i++) {
> > -		struct page *p = page + i;
> > -
> > +	for (i = 1; i < nr_pages; i++, p++) {
> > +		if (unlikely((i & (MAX_ORDER_NR_PAGES - 1)) == 0))
> > +			p = pfn_to_page(page_to_pfn(page) + i);
> >  		__SetPageTail(p);
> >  		p->first_page = page;
> >  	}
>
> gad.  Wouldn't it be clearer to do
>
> 	for (i = 1; i < nr_pages; i++) {
> 		struct page *p = pfn_to_page(i);
> 		__SetPageTail(p);
> 		p->first_page = page;
> 	}
>
> Oh well, I guess we can go with the obfuscated, uncommented version for
> now :(
>
> This patch applies to 2.6.26 (and possibly earlier) but I don't think
> those kernels can trigger the bug?

I think the problem is that pfn_to_page isn't always trivial. I would
prefer to have seen a new function for hugetlb to use, and keep the
branch-less version for the page allocator itself.
