Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbZCPQrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbZCPQrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZCPQrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:47:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40367 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZCPQri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:47:38 -0400
Date: Mon, 16 Mar 2009 16:47:36 +0000
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
Subject: Re: [PATCH 26/35] Use the per-cpu allocator for orders up to
	PAGE_ALLOC_COSTLY_ORDER
Message-ID: <20090316164735.GM24293@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-27-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161222070.32577@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903161222070.32577@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:26:07PM -0400, Christoph Lameter wrote:
> On Mon, 16 Mar 2009, Mel Gorman wrote:
> 
> > -static void free_hot_cold_page(struct page *page, int cold)
> > +static void free_hot_cold_page(struct page *page, int order, int cold)
> >  {
> >  	struct zone *zone = page_zone(page);
> >  	struct per_cpu_pages *pcp;
> >  	unsigned long flags;
> >  	int clearMlocked = PageMlocked(page);
> >
> > +	/* SLUB can return lowish-order compound pages that need handling */
> > +	if (order > 0 && unlikely(PageCompound(page)))
> > +		if (unlikely(destroy_compound_page(page, order)))
> > +			return;
> > +
> 
> Isnt that also true for stacks and generic network objects ==- 8k?
> 

I think they are vanilla high-order pages, not compound pages.

> >  again:
> >  	cpu  = get_cpu();
> > -	if (likely(order == 0)) {
> > +	if (likely(order <= PAGE_ALLOC_COSTLY_ORDER)) {
> >  		struct per_cpu_pages *pcp;
> > +		int batch;
> > +		int delta;
> >
> >  		pcp = &zone_pcp(zone, cpu)->pcp;
> > +		batch = max(1, pcp->batch >> order);
> >  		local_irq_save(flags);
> >  		if (!pcp->count) {
> > -			pcp->count = rmqueue_bulk(zone, 0,
> > -					pcp->batch, &pcp->list, migratetype);
> > +			delta = rmqueue_bulk(zone, order, batch,
> > +					&pcp->list, migratetype);
> > +			bulk_add_pcp_page(pcp, order, delta);
> >  			if (unlikely(!pcp->count))
> >  				goto failed;
> 
> The pcp adds a series of order N pages if an order N alloc occurs and the
> queue is empty?
> 

Nope, that would be bad. The calculation of batch is made above and is

batch = max(1, pcp->batch >> order);

so order is taken into account when deciding how many pages to allocate.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
