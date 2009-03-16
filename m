Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZCPQwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZCPQwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZCPQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:52:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50793 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZCPQwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:52:23 -0400
Date: Mon, 16 Mar 2009 16:52:20 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 31/35] Optimistically check the first page on the PCP
	free list is suitable
Message-ID: <20090316165220.GO24293@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-32-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161232130.32577@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903161232130.32577@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:33:44PM -0400, Christoph Lameter wrote:
> On Mon, 16 Mar 2009, Mel Gorman wrote:
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index bb5bd5e..8568284 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1212,6 +1212,12 @@ again:
> >  				if (pcp_page_suit(page, order))
> >  					break;
> >  		} else {
> > +			/* Optimistic before we start a list search */
> > +			page = list_entry(list->next, struct page, lru);
> > +			if (pcp_page_suit(page, order))
> > +				goto found;
> > +
> > +			/* Do the search */
> >  			list_for_each_entry(page, list, lru)
> >  				if (pcp_page_suit(page, order))
> >  					break;
> 
> I am not convinced that this is beneficial. If it would then the compiler
> would unroll the loop.
> 

It hit a large number of times when I checked (although I don't have the
figures any more) and the list_for_each_entry() does a prefetch
possibly fetching in a line we don't need.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
