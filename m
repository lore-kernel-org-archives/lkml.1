Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbZFOK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbZFOK2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZFOK21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:28:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:41682 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbZFOK20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:28:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="154400847"
Date: Mon, 15 Jun 2009 18:16:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 10/22] HWPOISON: check and isolate corrupted free pages
	v2
Message-ID: <20090615101620.GA7216@localhost>
References: <20090615024520.786814520@intel.com> <20090615031253.715406280@intel.com> <20090615184112.ed8e2f03.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615184112.ed8e2f03.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 05:41:12PM +0800, KAMEZAWA Hiroyuki wrote:
> On Mon, 15 Jun 2009 10:45:30 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > If memory corruption hits the free buddy pages, we can safely ignore them.
> > No one will access them until page allocation time, then prep_new_page()
> > will automatically check and isolate PG_hwpoison page for us (for 0-order
> > allocation).
> > 
> > This patch expands prep_new_page() to check every component page in a high
> > order page allocation, in order to completely stop PG_hwpoison pages from
> > being recirculated.
> > 
> > Note that the common case -- only allocating a single page, doesn't
> > do any more work than before. Allocating > order 0 does a bit more work,
> > but that's relatively uncommon.
> > 
> > This simple implementation may drop some innocent neighbor pages, hopefully
> > it is not a big problem because the event should be rare enough.
> > 
> > This patch adds some runtime costs to high order page users.
> > 
> > [AK: Improved description]
> > 
> > v2: Andi Kleen:
> > Port to -mm code
> > Move check into separate function.
> > Don't dump stack in bad_pages for hwpoisoned pages.
> > 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > ---
> >  mm/page_alloc.c |   20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> > 
> > --- sound-2.6.orig/mm/page_alloc.c
> > +++ sound-2.6/mm/page_alloc.c
> > @@ -233,6 +233,12 @@ static void bad_page(struct page *page)
> >  	static unsigned long nr_shown;
> >  	static unsigned long nr_unshown;
> >  
> > +	/* Don't complain about poisoned pages */
> > +	if (PageHWPoison(page)) {
> > +		__ClearPageBuddy(page);
> > +		return;
> > +	}
> 
> Hmm ? why __ClearPageBuddy() is necessary ?

Because this page is considered to be "allocated" out of the buddy
system, even though we fail the allocation here.

The page is now owned by no one, especially not owned by the buddy
allocator.

Thanks,
Fengguang
