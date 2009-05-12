Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZELLs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZELLs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZELLsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:48:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:41082 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbZELLsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:48:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,182,1241420400"; 
   d="scan'208";a="141848664"
Date: Tue, 12 May 2009 19:48:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: merge duplicate code in
	shrink_active_list()
Message-ID: <20090512114807.GC5926@localhost>
References: <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025319.GD7518@localhost> <20090512162633.352313d6.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512162633.352313d6.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 03:26:33PM +0800, Minchan Kim wrote:
> On Tue, 12 May 2009 10:53:19 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > The "move pages to active list" and "move pages to inactive list"
> > code blocks are mostly identical and can be served by a function.
> > 
> > Thanks to Andrew Morton for pointing this out.
> > 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/vmscan.c |   84 ++++++++++++++++++++------------------------------
> >  1 file changed, 35 insertions(+), 49 deletions(-)
> > 
> > --- linux.orig/mm/vmscan.c
> > +++ linux/mm/vmscan.c
> > @@ -1225,6 +1225,36 @@ static inline void note_zone_scanning_pr
> >   * But we had to alter page->flags anyway.
> >   */
> >  
> > +void move_active_pages_to_lru(enum lru_list lru, struct list_head *list)
> > +{
> > +	unsigned long pgmoved = 0;
> > +
> > +	while (!list_empty(&list)) {
> > +		page = lru_to_page(&list);
> > +		prefetchw_prev_lru_page(page, &list, flags);
> > +
> > +		VM_BUG_ON(PageLRU(page));
> > +		SetPageLRU(page);
> > +
> > +		VM_BUG_ON(!PageActive(page));
> > +		if (lru < LRU_ACTIVE)
> > +			ClearPageActive(page);
> 
> Arithmetic on the LRU list is not good code for redability, I think. 
> How about adding comment? 
> 
> if (lru < LRU_ACTIVE) /* In case of moving from active list to inactive */
> 
> Ignore me if you think this is trivial. 

Good suggestion. Or this simple one: "we are de-activating"?

Thanks,
Fengguang
