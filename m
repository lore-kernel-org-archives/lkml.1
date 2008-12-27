Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYL0Dg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYL0Dg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 22:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYL0DgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 22:36:21 -0500
Received: from cmpxchg.org ([85.214.51.133]:33500 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYL0DgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 22:36:21 -0500
Date: Sat, 27 Dec 2008 04:36:10 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] 2.6.28, vmalloc.c, vmap_page_range
Message-ID: <20081227033610.GA1750@cmpxchg.org>
References: <20081225210235.GC5431@os.inf.tu-dresden.de> <20081226163946.6d38e919.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226163946.6d38e919.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 04:39:46PM -0800, Andrew Morton wrote:
> On Thu, 25 Dec 2008 22:02:35 +0100 Adam Lackorzynski <adam@os.inf.tu-dresden.de> wrote:
> 
> > Hi,
> > 
> > in 2.6.28, the flush_cache_vmap in vmap_page_range() is called with the end of
> > the range twice. The following patch fixes this for me.
> > 
> 
> Did this bug have any observeable runtime effects?  If so, what were
> they?
> 
> > ---
> >  vmalloc.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-2.6.28/mm/vmalloc.c	2008-12-25 00:26:37.000000000 +0100
> > +++ linux-2.6.28.a/mm/vmalloc.c	2008-12-25 21:45:43.118725744 +0100
> > @@ -155,7 +155,7 @@
> >  				pgprot_t prot, struct page **pages)
> >  {
> >  	pgd_t *pgd;
> > -	unsigned long next;
> > +	unsigned long next, start = addr;
> >  	int err = 0;
> >  	int nr = 0;
> >  
> > @@ -167,7 +167,7 @@
> >  		if (err)
> >  			break;
> >  	} while (pgd++, addr = next, addr != end);
> > -	flush_cache_vmap(addr, end);
> > +	flush_cache_vmap(start, end);
> >  
> >  	if (unlikely(err))
> >  		return err;
> 
> Well yeah.  This is what happens when functions modify their incoming
> arguments.  It's a bad programming practice which leads directly to
> exactly this sort of bug.
> 
> How about we fix that?
> 
> 
> --- a/mm/vmalloc.c~vmallocc-fix-flushing-in-vmap_page_range
> +++ a/mm/vmalloc.c
> @@ -151,11 +151,12 @@ static int vmap_pud_range(pgd_t *pgd, un
>   *
>   * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
>   */
> -static int vmap_page_range(unsigned long addr, unsigned long end,
> +static int vmap_page_range(unsigned long start_addr, unsigned long end,
>  				pgprot_t prot, struct page **pages)
>  {
>  	pgd_t *pgd;
>  	unsigned long next;
> +	unsigned long addr = start_addr;

Ugh, start_addr is an awful name.  How about start?  I know it doesn't
hold the same amount of information but it's a local API, the
pgd_offset_k() should make the unit unambiguous, it goes better with
the end parameter and it's unique enough for this short function.

	Hannes
