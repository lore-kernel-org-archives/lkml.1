Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYJBPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYJBPCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYJBPCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:02:40 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:38492 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYJBPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:02:39 -0400
Date: Thu, 2 Oct 2008 16:02:21 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for
	allocation by the reclaimer
Message-ID: <20081002150221.GF11089@brain>
References: <1222864261-22570-1-git-send-email-apw@shadowen.org> <1222864261-22570-5-git-send-email-apw@shadowen.org> <20081002162414.03470f46.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002162414.03470f46.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 04:24:14PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed,  1 Oct 2008 13:31:01 +0100
> Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > When a process enters direct reclaim it will expend effort identifying
> > and releasing pages in the hope of obtaining a page.  However as these
> > pages are released asynchronously there is every possibility that the
> > pages will have been consumed by other allocators before the reclaimer
> > gets a look in.  This is particularly problematic where the reclaimer is
> > attempting to allocate a higher order page.  It is highly likely that
> > a parallel allocation will consume lower order constituent pages as we
> > release them preventing them coelescing into the higher order page the
> > reclaimer desires.
> > 
> > This patch set attempts to address this for allocations above
> > ALLOC_COSTLY_ORDER by temporarily collecting the pages we are releasing
> > onto a local free list.  Instead of freeing them to the main buddy lists,
> > pages are collected and coelesced on this per direct reclaimer free list.
> > Pages which are freed by other processes are also considered, where they
> > coelesce with a page already under capture they will be moved to the
> > capture list.  When pressure has been applied to a zone we then consult
> > the capture list and if there is an appropriatly sized page available
> > it is taken immediatly and the remainder returned to the free pool.
> > Capture is only enabled when the reclaimer's allocation order exceeds
> > ALLOC_COSTLY_ORDER as free pages below this order should naturally occur
> > in large numbers following regular reclaim.
> > 
> > Thanks go to Mel Gorman for numerous discussions during the development
> > of this patch and for his repeated reviews.
> > 
> 
> Hmm.. is this routine better than
>   mm/memory_hotplug.c::do_migrate_range(start_pfn, end_pfn) ?

Are you suggesting that it might be more adventageous to try and migrate
things out of this area as part of reclaim?  If so then I tend to agree,
though that would be a good idea generally with or without capture.

/me adds it to his todo list to test that out.

-apw
