Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYHEHv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYHEHv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYHEHv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:51:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57693 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYHEHv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:51:28 -0400
Date: Tue, 5 Aug 2008 08:51:23 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [2.6 patch] fix mm/mm_init.c compilation
Message-ID: <20080805075122.GA20243@csn.ul.ie>
References: <20080804181915.GA12558@cs181140183.pp.htv.fi> <20080804140554.aa1ef2da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080804140554.aa1ef2da.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (04/08/08 14:05), Andrew Morton didst pronounce:
> On Mon, 4 Aug 2008 21:19:15 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch fixes the following compile error with gcc 3.2:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      mm/mm_init.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:77:1: directives may not be used inside a macro argument
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:76:47: unterminated argument list invoking macro "mminit_dprintk"
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c: In function `mminit_verify_pageflags_layout':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: `mminit_dprintk' undeclared (first use in this function)
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: (Each undeclared identifier is reported only once
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: for each function it appears in.)
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: syntax error before numeric constant
> > make[2]: *** [mm/mm_init.o] Error 1
> > 
> > <--  snip  -->
> > 
> > 
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -63,6 +63,13 @@ void __init mminit_verify_pageflags_layout(void)
> >  {
> >  	int shift, width;
> >  	unsigned long or_mask, add_mask;
> > +	int sections_shift;
> > +
> > +#ifdef SECTIONS_SHIFT
> > +	sections_shift = SECTIONS_SHIFT;
> > +#else
> > +	sections_shift = 0;
> > +#endif
> >  
> >  	shift = 8 * sizeof(unsigned long);
> >  	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH;
> > @@ -74,11 +81,7 @@ void __init mminit_verify_pageflags_layout(void)
> >  		NR_PAGEFLAGS);
> >  	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
> >  		"Section %d Node %d Zone %d\n",
> > -#ifdef SECTIONS_SHIFT
> > -		SECTIONS_SHIFT,
> > -#else
> > -		0,
> > -#endif
> > +		sections_shift,
> >  		NODES_SHIFT,
> >  		ZONES_SHIFT);
> >  	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",
> 
> OK, ifdefs inside macro expansion aren't a great idea.
> 
> Mel, is there any erason why we shouldn't do it this way?
> 

The only minor nit is SECTIONS_SHIFT is defined outside of SPARSEMEM even
though it has no meaning there. There is no problem with this as such but
someone being silly might use SECTIONS_SHIFT accidently. If this sort of
behaviour was considered a possibility, we could add something like this to
mm/mm_init.c instead?

#ifndef SECTIONS_SHIFT
#define SECTIONS_SHIFT 0
#endif /* SECTIONS_SHIFT */

>  include/linux/mmzone.h |    3 ++-
>  mm/mm_init.c           |    4 ----
> 
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff -puN include/linux/mmzone.h~a include/linux/mmzone.h
> --- a/include/linux/mmzone.h~a
> +++ a/include/linux/mmzone.h
> @@ -831,7 +831,7 @@ static inline unsigned long early_pfn_to
>  #ifdef CONFIG_SPARSEMEM
>  
>  /*
> - * SECTION_SHIFT    		#bits space required to store a section #
> + * SECTIONS_SHIFT    		#bits space required to store a section #
>   *
>   * PA_SECTION_SHIFT		physical address to/from section number
>   * PFN_SECTION_SHIFT		pfn to/from section number
> @@ -973,6 +973,7 @@ static inline int pfn_present(unsigned l
>  #define early_pfn_valid(pfn)	pfn_valid(pfn)
>  void sparse_init(void);
>  #else
> +#define SECTIONS_SHIFT		0
>  #define sparse_init()	do {} while (0)
>  #define sparse_index_init(_sec, _nid)  do {} while (0)
>  #endif /* CONFIG_SPARSEMEM */
> diff -puN mm/mm_init.c~a mm/mm_init.c
> --- a/mm/mm_init.c~a
> +++ a/mm/mm_init.c
> @@ -74,11 +74,7 @@ void __init mminit_verify_pageflags_layo
>  		NR_PAGEFLAGS);
>  	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
>  		"Section %d Node %d Zone %d\n",
> -#ifdef SECTIONS_SHIFT
>  		SECTIONS_SHIFT,
> -#else
> -		0,
> -#endif
>  		NODES_SHIFT,
>  		ZONES_SHIFT);
>  	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",
> _
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
