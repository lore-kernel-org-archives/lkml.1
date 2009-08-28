Return-Path: <linux-kernel-owner+w=401wt.eu-S1751171AbZH1Ng3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbZH1Ng3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZH1Ng2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:36:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33539 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZH1Ng2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:36:28 -0400
Date: Fri, 28 Aug 2009 14:36:31 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] page-allocator: Maintain rolling count of pages to
	free from the PCP
Message-ID: <20090828133631.GF5054@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie> <1251449067-3109-3-git-send-email-mel@csn.ul.ie> <84144f020908280516y6473a531n3f11f3e86251eba4@mail.gmail.com> <20090828125719.GE5054@csn.ul.ie> <1251464564.8514.3.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1251464564.8514.3.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 04:02:44PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Fri, 2009-08-28 at 13:57 +0100, Mel Gorman wrote:
> > On Fri, Aug 28, 2009 at 03:16:34PM +0300, Pekka Enberg wrote:
> > > Hi Mel,
> > > 
> > > On Fri, Aug 28, 2009 at 11:44 AM, Mel Gorman<mel@csn.ul.ie> wrote:
> > > > -               page = list_entry(list->prev, struct page, lru);
> > > > -               /* have to delete it as __free_one_page list manipulates */
> > > > -               list_del(&page->lru);
> > > > -               trace_mm_page_pcpu_drain(page, 0, migratetype);
> > > > -               __free_one_page(page, zone, 0, migratetype);
> > > > +               do {
> > > > +                       page = list_entry(list->prev, struct page, lru);
> > > > +                       /* must delete as __free_one_page list manipulates */
> > > > +                       list_del(&page->lru);
> > > > +                       __free_one_page(page, zone, 0, migratetype);
> > > > +                       trace_mm_page_pcpu_drain(page, 0, migratetype);
> > > 
> > > This calls trace_mm_page_pcpu_drain() *after* __free_one_page(). It's
> > > probably not a good idea as __free_one_page() can alter the struct
> > > page in various ways.
> > > 
> > 
> > While true, does it alter the struct page in any way that matters?
> 
> Page flags and order are probably interesting for tracing?
> 

This is PCPU draining. The flags are already clear of any values of interest
and the order is always 0. I can follow up a fix-patch that reverses it just
in case but I don't think it makes a major difference?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
