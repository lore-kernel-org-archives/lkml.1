Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZGPLF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZGPLF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 07:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZGPLF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 07:05:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41879 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZGPLF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:05:58 -0400
Date: Thu, 16 Jul 2009 12:05:57 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rientjes@google.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] page-allocator: Ensure that processes that have been
	OOM killed exit the page allocator (resend)
Message-ID: <20090716110557.GC22499@csn.ul.ie>
References: <20090715104944.GC9267@csn.ul.ie> <20090715133014.a3566bdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090715133014.a3566bdd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 01:30:14PM -0700, Andrew Morton wrote:
> On Wed, 15 Jul 2009 11:49:45 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Processes that have been OOM killed set the thread flag TIF_MEMDIE. A process
> > such as this is expected to exit the page allocator but potentially, it
> > loops forever. This patch checks TIF_MEMDIE when deciding whether to loop
> > again in the page allocator. If set, and __GFP_NOFAIL is not specified
> > then the loop will exit on the assumption it's no longer important for the
> > process to make forward progress. Note that a process that has just been
> > OOM-killed will still loop at least one more time retrying the allocation
> > before the thread flag is checked.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > --- 
> >  mm/page_alloc.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index f8902e7..5c98d02 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1547,6 +1547,14 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
> >  	if (gfp_mask & __GFP_NORETRY)
> >  		return 0;
> >  
> > +	/* Do not loop if OOM-killed unless __GFP_NOFAIL is specified */
> > +	if (test_thread_flag(TIF_MEMDIE)) {
> > +		if (gfp_mask & __GFP_NOFAIL)
> > +			WARN(1, "Potential infinite loop with __GFP_NOFAIL");
> > +		else
> > +			return 0;
> > +	}
> > +
> >  	/*
> >  	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
> >  	 * means __GFP_NOFAIL, but that may not be true in other
> 
> This fixes a post-2.6.30 regression, yes?
> 
> I dug out the commit ID a while back but lost it. Ho hum.
> 

You made a note at the time "Offending commit 341ce06 handled the PF_MEMALLOC
case but forgot about the TIF_MEMDIE case."

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
