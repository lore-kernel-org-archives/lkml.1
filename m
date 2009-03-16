Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZCPQ3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZCPQ3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZCPQ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:29:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53507 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZCPQ3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:29:38 -0400
Date: Mon, 16 Mar 2009 16:29:36 +0000
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
Subject: Re: [PATCH 18/35] Do not disable interrupts in free_page_mlock()
Message-ID: <20090316162936.GI24293@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-19-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161203230.32577@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903161203230.32577@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:05:53PM -0400, Christoph Lameter wrote:
> On Mon, 16 Mar 2009, Mel Gorman wrote:
> 
> > @@ -570,6 +570,8 @@ static void __free_pages_ok(struct page *page, unsigned int order)
> >  	kernel_map_pages(page, 1 << order, 0);
> >
> >  	local_irq_save(flags);
> > +	if (clearMlocked)
> > +		free_page_mlock(page);
> >  	__count_vm_events(PGFREE, 1 << order);
> >  	free_one_page(page_zone(page), page, order,
> >  					get_pageblock_migratetype(page));
> 
> Add an unlikely(clearMblocked) here?
> 

I wasn't sure at the time of writing how likely the case really is but it
makes sense that mlocked() pages are rarely freed. On reflection though,
it makes sense to mark this unlikely().

> > @@ -1036,6 +1039,9 @@ static void free_hot_cold_page(struct page *page, int cold)
> >  	pcp = &zone_pcp(zone, get_cpu())->pcp;
> >  	local_irq_save(flags);
> >  	__count_vm_event(PGFREE);
> > +	if (clearMlocked)
> > +		free_page_mlock(page);
> > +
> >  	if (cold)
> >  		list_add_tail(&page->lru, &pcp->list);
> >  	else
> >
> 
> Same here also make sure tha the __count_vm_events(PGFREE) comes after the
> free_pages_mlock() to preserve symmetry with __free_pages_ok() and maybe
> allow the compiler to do CSE between two invocations of
> __count_vm_events().
> 

Whatever about the latter reasoning about CSE, the symmetry makes sense.
I've made the change. Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
