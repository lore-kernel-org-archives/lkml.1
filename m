Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZGWK3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZGWK3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZGWK3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:29:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36390 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZGWK3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:29:39 -0400
Date: Thu, 23 Jul 2009 11:29:39 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee.Schermerhorn@hp.com, penberg@cs.helsinki.fi, hannes@cmpxchg.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
	V2
Message-ID: <20090723102938.GA27731@csn.ul.ie>
References: <20090715125822.GB29749@csn.ul.ie> <alpine.DEB.1.10.0907151027410.23643@gentwo.org> <20090722160649.61176c61.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090722160649.61176c61.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 04:06:49PM -0700, Andrew Morton wrote:
> On Wed, 15 Jul 2009 10:31:54 -0400 (EDT)
> Christoph Lameter <cl@linux-foundation.org> wrote:
> 
> > On Wed, 15 Jul 2009, Mel Gorman wrote:
> > 
> > > -static inline int free_pages_check(struct page *page)
> > > +static inline int free_pages_check(struct page *page, int wasMlocked)
> > >  {
> > > +	WARN_ONCE(wasMlocked, KERN_WARNING
> > > +		"Page flag mlocked set for process %s at pfn:%05lx\n"
> > > +		"page:%p flags:0x%lX\n",
> > > +		current->comm, page_to_pfn(page),
> > > +		page, page->flags|__PG_MLOCKED);
> > > +
> > >  	if (unlikely(page_mapcount(page) |
> > 
> > There is already a free_page_mlocked() that is only called if the mlock
> > bit is set. Move it into there to avoid having to run two checks in the
> > hot codee path?
> 
> Agreed.
> 
> This patch gratuitously adds hotpath overhead.  Moving the change to be
> inside those preexisting wasMlocked tests will reduce its overhead a lot.
> 

It adds code duplication then, one of which is in a fast path.

> As it stands, I'm really doubting that the patch's utility is worth its
> cost.
> 

I'm happy to let this one drop. It seemed like it would be nice for debugging
while there are still corner cases where mlocked pages are getting freed
instead of torn down but we already account for that situation occuring. While
I think it'll be tricky to spot, it's probably preferable to having warnings
spew out onto dmesg.

> Also, it's a bit of a figleaf, but please consider making more use of
> CONFIG_DEBUG_VM (see VM_BUG_ON()).
> 

In this particular case, I doubted that DEBUG_VM would be set on
machines that were triggering the mlock corner case but yeah, this does
look more like a DEBUG_VM than a production thing.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
