Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYL0JCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYL0JCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYL0JC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:02:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbYL0JC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:02:27 -0500
Date: Sat, 27 Dec 2008 10:02:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] 2.6.28, vmalloc.c, vmap_page_range
Message-ID: <20081227090221.GD16077@elte.hu>
References: <20081225210235.GC5431@os.inf.tu-dresden.de> <20081226163946.6d38e919.akpm@linux-foundation.org> <20081227033610.GA1750@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227033610.GA1750@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Dec 26, 2008 at 04:39:46PM -0800, Andrew Morton wrote:
> > On Thu, 25 Dec 2008 22:02:35 +0100 Adam Lackorzynski <adam@os.inf.tu-dresden.de> wrote:
> > 
> > > Hi,
> > > 
> > > in 2.6.28, the flush_cache_vmap in vmap_page_range() is called with the end of
> > > the range twice. The following patch fixes this for me.
> > > 
> > 
> > Did this bug have any observeable runtime effects?  If so, what were
> > they?
> > 
> > > ---
> > >  vmalloc.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > --- linux-2.6.28/mm/vmalloc.c	2008-12-25 00:26:37.000000000 +0100
> > > +++ linux-2.6.28.a/mm/vmalloc.c	2008-12-25 21:45:43.118725744 +0100
> > > @@ -155,7 +155,7 @@
> > >  				pgprot_t prot, struct page **pages)
> > >  {
> > >  	pgd_t *pgd;
> > > -	unsigned long next;
> > > +	unsigned long next, start = addr;
> > >  	int err = 0;
> > >  	int nr = 0;
> > >  
> > > @@ -167,7 +167,7 @@
> > >  		if (err)
> > >  			break;
> > >  	} while (pgd++, addr = next, addr != end);
> > > -	flush_cache_vmap(addr, end);
> > > +	flush_cache_vmap(start, end);
> > >  
> > >  	if (unlikely(err))
> > >  		return err;
> > 
> > Well yeah.  This is what happens when functions modify their incoming
> > arguments.  It's a bad programming practice which leads directly to
> > exactly this sort of bug.
> > 
> > How about we fix that?
> > 
> > 
> > --- a/mm/vmalloc.c~vmallocc-fix-flushing-in-vmap_page_range
> > +++ a/mm/vmalloc.c
> > @@ -151,11 +151,12 @@ static int vmap_pud_range(pgd_t *pgd, un
> >   *
> >   * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
> >   */
> > -static int vmap_page_range(unsigned long addr, unsigned long end,
> > +static int vmap_page_range(unsigned long start_addr, unsigned long end,
> >  				pgprot_t prot, struct page **pages)
> >  {
> >  	pgd_t *pgd;
> >  	unsigned long next;
> > +	unsigned long addr = start_addr;
> 
> Ugh, start_addr is an awful name.  How about start?  I know it doesn't 
> hold the same amount of information but it's a local API, the 
> pgd_offset_k() should make the unit unambiguous, it goes better with the 
> end parameter and it's unique enough for this short function.

i'd like to observe that there's 449 start_addr instances in the kernel 
source, 17 of them in mm/*.c alone. So if it's 'ugly' (it isnt to me), 
this patch is not the place to start worrying about it. If you feel 
strongly about it then prepare a cleanup patch that eradicates them all, 
put your justification for why it's bad into the changelog and post it to 
lkml.

Anyway, happy bikeshed painting,

	Ingo
