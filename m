Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbZFSDa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbZFSDa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZFSDaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:30:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:59435 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbZFSDaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:30:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,248,1243839600"; 
   d="scan'208";a="156292230"
Date: Fri, 19 Jun 2009 11:30:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Barnes, Jesse" <jesse.barnes@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan.kim@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch v3] swap: virtual swap readahead
Message-ID: <20090619033004.GB5603@localhost>
References: <20090610095950.GA514@localhost> <1244628314.13761.11617.camel@twins> <20090610113214.GA5657@localhost> <20090610102516.08f7300f@jbarnes-x200> <20090611052228.GA20100@localhost> <20090611101741.GA1974@cmpxchg.org> <20090612015927.GA6804@localhost> <20090615182216.GA1661@cmpxchg.org> <20090618091949.GA711@localhost> <20090618130121.GA1817@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618130121.GA1817@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 09:01:21PM +0800, Johannes Weiner wrote:
> On Thu, Jun 18, 2009 at 05:19:49PM +0800, Wu Fengguang wrote:
> > On Tue, Jun 16, 2009 at 02:22:17AM +0800, Johannes Weiner wrote:
> > > On Fri, Jun 12, 2009 at 09:59:27AM +0800, Wu Fengguang wrote:
> > > > On Thu, Jun 11, 2009 at 06:17:42PM +0800, Johannes Weiner wrote:
> > > > > On Thu, Jun 11, 2009 at 01:22:28PM +0800, Wu Fengguang wrote:
> > > > > > Unfortunately, after fixing it up the swap readahead patch still performs slow
> > > > > > (even worse this time):
> > > > > 
> > > > > Thanks for doing the tests.  Do you know if the time difference comes
> > > > > from IO or CPU time?
> > > > > 
> > > > > Because one reason I could think of is that the original code walks
> > > > > the readaround window in two directions, starting from the target each
> > > > > time but immediately stops when it encounters a hole where the new
> > > > > code just skips holes but doesn't abort readaround and thus might
> > > > > indeed read more slots.
> > > > > 
> > > > > I have an old patch flying around that changed the physical ra code to
> > > > > use a bitmap that is able to represent holes.  If the increased time
> > > > > is waiting for IO, I would be interested if that patch has the same
> > > > > negative impact.
> > > > 
> > > > You can send me the patch :)
> > > 
> > > Okay, attached is a rebase against latest -mmotm.
> > > 
> > > > But for this patch it is IO bound. The CPU iowait field actually is
> > > > going up as the test goes on:
> > > 
> > > It's probably the larger ra window then which takes away the bandwidth
> > > needed to load the new executables.  This sucks.  Would be nice to
> > > have 'optional IO' for readahead that is dropped when normal-priority
> > > IO requests are coming in...  Oh, we have READA for bios.  But it
> > > doesn't seem to implement dropping requests on load (or I am blind).
> > 
> > Hi Hannes,
> > 
> > Sorry for the long delay! A bad news is that I get many oom with this patch:
> 
> Okay, evaluating this test-patch any further probably isn't worth it.
> It's too aggressive, I think readahead is stealing pages reclaimed by
> other allocations which in turn oom.

OK.

> Back to the original problem: you detected increased latency for
> launching new applications, so they get less share of the IO bandwidth

There are no "launch new app" phase. The test flow works like:

  for all apps {
        for all started apps {
                activate its GUI window
        }
        start one new app
  }
        
But yes, as time goes by, the test becomes more and more about
switching between existing windows under high memory pressure.

> than without the patch.
> 
> I can see two reasons for this:
> 
>   a) the new heuristics don't work out and we read more unrelated
>   pages than before
> 
>   b) we readahead more pages in total as the old code would stop at
>   holes, as described above
> 
> We can verify a) by comparing major fault numbers between the two

Plus pswpin numbers :) I found it significantly decreased when we do
pte swap readahead..  See another email.

> kernels with your testload.  If they increase with my patch, we
> anticipate the wrong slots and every fault has do the reading itself.
> 
> b) seems to be a trade-off.  After all, the IO resources you have less
> for new applications in your test is the bandwidth that is used by
> swapping applications.  My qsbench numbers are a sign for this as the
> only IO going on is swap.
> 
> Of course, the theory is not to improve swap performance by increasing
> the readahead window but to choose better readahead candidates.  So I
> will run your tests and qsbench with a smaller page cluster and see if
> this improves both loads.

The general principle is, any non sector number based readahead should
be really accurate in order to be a net gain. Because each readahead
page miss will lead to one disk seek, which is much more costly than
wasting a memory page.

Thanks,
Fengguang

