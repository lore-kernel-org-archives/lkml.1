Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZESIyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZESIyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZESIy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:54:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:17308 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZESIy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="144395940"
Date: Tue, 19 May 2009 16:53:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090519085354.GB2121@localhost>
References: <20090519161756.4EE4.A69D9226@jp.fujitsu.com> <20090519074925.GA690@localhost> <20090519170208.742C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519170208.742C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 04:06:35PM +0800, KOSAKI Motohiro wrote:
> > > > Like the console mode, the absolute nr_mapped drops considerably - to 1/13 of
> > > > the original size - during the streaming IO.
> > > > 
> > > > The delta of pgmajfault is 3 vs 107 during IO, or 236 vs 393 during the whole
> > > > process.
> > > 
> > > hmmm.
> > > 
> > > about 100 page fault don't match Elladan's problem, I think.
> > > perhaps We missed any addional reproduce condition?
> > 
> > Elladan's case is not the point of this test.
> > Elladan's IO is use-once, so probably not a caching problem at all.
> > 
> > This test case is specifically devised to confirm whether this patch
> > works as expected. Conclusion: it is.
> 
> Dejection ;-)
> 
> The number should address the patch is useful or not. confirming as expected
> is not so great.

OK, let's make the conclusion in this way:

The changelog analyzed the possible beneficial situation, and this
test backs that theory with real numbers, ie: it successfully stops
major faults when the active file list is slowly scanned when there
are partially cache hot streaming IO.

Another (amazing) finding of the test is, only around 1/10 mapped pages
are actively referenced in the absence of user activities.

Shall we protect the remaining 9/10 inactive ones? This is a question ;-)

Or, shall we take the "protect active VM_EXEC mapped pages" approach,
or Christoph's "protect all mapped pages all time, unless they grow
too large" attitude?  I still prefer the best effort VM_EXEC heuristics.

1) the partially cache hot streaming IO is far more likely to happen
   on (file) servers. For them, evicting the 9/10 inactive mapped
   pages over night should be acceptable for sysadms.

2) for use-once IO on desktop, we have Rik's active file list
   protection heuristics, so nothing to worry at all.

3) for big working set small memory desktop, the active list will
   still be scanned, in this situation, why not evict some of the
   inactive mapped pages? If they have not been accessed for 1 minute,
   they are not likely be the user focus, and the tight memory
   constraint can only afford to cache the user focused working set.

Does that make sense?
