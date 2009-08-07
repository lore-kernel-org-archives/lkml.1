Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZHGK5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZHGK5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbZHGK5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:57:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39534 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbZHGK5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:57:32 -0400
Date: Fri, 7 Aug 2009 11:57:33 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] tracing, page-allocator: Add trace events for
	anti-fragmentation falling back to other migratetypes
Message-ID: <20090807105732.GB18134@csn.ul.ie>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-3-git-send-email-mel@csn.ul.ie> <20090807080249.GA21821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090807080249.GA21821@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:02:49AM +0200, Ingo Molnar wrote:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > +++ b/mm/page_alloc.c
> > @@ -839,6 +839,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
> >  							start_migratetype);
> >  
> >  			expand(zone, page, order, current_order, area, migratetype);
> > +
> > +			trace_mm_page_alloc_extfrag(page, order, current_order,
> > +				start_migratetype, migratetype,
> > +				current_order < pageblock_order,
> > +				migratetype == start_migratetype);
> 
> This tracepoint too should be optimized some more:
> 
>  - pageblock_order can be passed down verbatim instead of the 
>    'current_order < pageblock_order': it means one comparison less 
>    in the fast-path, plus it gives more trace information as well.
> 
>  - migratetype == start_migratetype check is superfluous as both 
>    values are already traced. This property can be added to the 
>    TP_printk() post-processing stage instead, if the pretty-printing 
>    is desired.
> 

I think what you're saying that it's better to handle additional information
like this in TP_printk always. That's what I've changed both of these into
at least. I didn't even need to pass down pageblock_order because it should
be available in the post-processing context from a header.

The additional parameters are not being passed down any more and the
TP_printk looks like

        TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
                __entry->page,
                page_to_pfn(__entry->page),
                __entry->alloc_order,
                __entry->fallback_order,
                pageblock_order,
                __entry->alloc_migratetype,
                __entry->fallback_migratetype,
                __entry->fallback_order < pageblock_order,
                __entry->alloc_migratetype == __entry->fallback_migratetype)

Is that what you meant?


-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
