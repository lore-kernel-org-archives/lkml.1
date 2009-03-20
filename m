Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZCTPhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZCTPhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZCTPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:37:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60838 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZCTPhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:37:25 -0400
Date: Fri, 20 Mar 2009 15:37:23 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V5
Message-ID: <20090320153723.GO24586@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201059240.3740@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903201059240.3740@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:00:42AM -0400, Christoph Lameter wrote:
> On Fri, 20 Mar 2009, Mel Gorman wrote:
> 
> > The lock contention on some machines goes up for the the zone->lru_lock
> > and zone->lock locks which can regress some workloads even though others on
> > the same machine still go faster. For netperf, a lock called slock-AF_INET
> > seemed very important although I didn't look too closely other than noting
> > contention went up. The zone->lock gets hammered a lot by high order allocs
> > and frees coming from SLUB which are not covered by the PCP allocator in
> > this patchset. zone->lru_lock goes up is less clear but as it's page cache
> > releases but overall contention may be up because CPUs are spending less
> > time with interrupts disabled and more time trying to do real work but
> > contending on the locks.
> 
> We can tune SLUB to buffer more pages if the lru lock becomes too hot.
> 

hmm, I'm missing something in your reasoning. The contention I saw for
zone->lru_lock

&zone->lru_lock          37350 [<ffffffff8029d6fe>] ____pagevec_lru_add+0x9c/0x172
&zone->lru_lock          55423 [<ffffffff8029d377>] release_pages+0x10a/0x21b
&zone->lru_lock            402 [<ffffffff8029d9d9>] activate_page+0x4f/0x147
&zone->lru_lock              6 [<ffffffff8029dbbd>] put_page+0x94/0x122

So I just assumed it was LRU pages being taken off and freed that was
causing the contention. Can SLUB affect that?

Maybe you meant zone->lock and SLUB could tune buffers more to avoid
that if that lock was hot. That is one alternative but the later patches
proposed an alternative whereby high-order and compound pages could be
stored on the PCP lists. Compound only really helps SLUB but high-order
also helped stacks, signal handlers and the like so it seemed like a
good idea one way or the other. Course, this meant a search of the PCP
lists or increasing the size of the PCP structure - swings and
roundabouts :/

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
