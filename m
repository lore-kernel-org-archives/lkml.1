Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbZCPLeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbZCPLeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZCPLeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:34:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:43053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZCPLeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:34:07 -0400
Date: Mon, 16 Mar 2009 12:33:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/35] Cleanup and optimise the page allocator V3
Message-ID: <20090316113358.GA30802@wotan.suse.de>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <20090316104054.GA23046@wotan.suse.de> <20090316111906.GA6382@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316111906.GA6382@csn.ul.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 11:19:06AM +0000, Mel Gorman wrote:
> On Mon, Mar 16, 2009 at 11:40:54AM +0100, Nick Piggin wrote:
> > That's wonderful, but it would
> > significantly increase the fragmentation problem, wouldn't it?
> 
> Not necessarily, anti-fragmentation groups movable pages within a
> hugepage-aligned block and high-order allocations will trigger a merge of
> buddies from PAGE_ALLOC_MERGE_ORDER (defined in the relevant patch) up to
> MAX_ORDER-1. Critically, a merge is also triggered when anti-fragmentation
> wants to fallback to another migratetype to satisfy an allocation. As
> long as the grouping works, it doesn't matter if they were only merged up
> to PAGE_ALLOC_MERGE_ORDER as a full merge will still free up hugepages.
> So two slow paths are made slower but the fast path should be faster and it
> should be causing fewer cache line bounces due to writes to struct page.

Oh, but the anti-fragmentation stuff is orthogonal to this. Movable
groups should always be defragmentable (at some cost)... the bane of
anti-frag is fragmentation of the non-movable groups.

And one reason why buddy is so good at avoiding fragmentation is
because it will pick up _any_ pages that go past the allocator if
they have any free buddies. And it hands out ones that don't have
free buddies. So in that way it is naturally continually filtering
out pages which can be merged.

Wheras if you defer this until the point you need a higher order
page, the only thing you have to work with are the pages that are
free *right now*.

It will almost definitely increase fragmentation of non movable zones,
and if you have a workload doing non-trivial, non movable higher order
allocations that are likely to cause fragmentation, it will result
in these allocations eating movable groups sooner I think.


> When I last checked (about 10 days) ago, I hadn't damaged anti-fragmentation
> but that was a lot of revisions ago. I'm redoing the tests to make sure
> anti-fragmentation is still ok.

Your anti-frag tests probably don't stress this long term fragmentation
problem.

Still, it's significant enough that I think it should be made
optional (and arguably default to on) even if it does harm higher
order allocations a bit.

