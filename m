Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0CLKHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:07:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238Ab0CLKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:07:04 -0500
Date: Fri, 12 Mar 2010 02:05:26 -0500
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone
 pressure
Message-Id: <20100312020526.d424f2a8.akpm@linux-foundation.org>
In-Reply-To: <4B99E19E.6070301@linux.vnet.ibm.com>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie>
	<20100311154124.e1e23900.akpm@linux-foundation.org>
	<4B99E19E.6070301@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 07:39:26 +0100 Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com> wrote:

> 
> 
> Andrew Morton wrote:
> > On Mon,  8 Mar 2010 11:48:20 +0000
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> >> Under memory pressure, the page allocator and kswapd can go to sleep using
> >> congestion_wait(). In two of these cases, it may not be the appropriate
> >> action as congestion may not be the problem.
> > 
> > clear_bdi_congested() is called each time a write completes and the
> > queue is below the congestion threshold.
> > 
> > So if the page allocator or kswapd call congestion_wait() against a
> > non-congested queue, they'll wake up on the very next write completion.
> 
> Well the issue came up in all kind of loads where you don't have any 
> writes at all that can wake up congestion_wait.
> Thats true for several benchmarks, but also real workload as well e.g. A 
> backup job reading almost all files sequentially and pumping out stuff 
> via network.

Why is reclaim going into congestion_wait() at all if there's heaps of
clean reclaimable pagecache lying around?

(I don't thing the read side of the congestion_wqh[] has ever been used, btw)

> > Hence the above-quoted claim seems to me to be a significant mis-analysis and
> > perhaps explains why the patchset didn't seem to help anything?
> 
> While I might have misunderstood you and it is a mis-analysis in your 
> opinion, it fixes a -80% Throughput regression on sequential read 
> workloads, thats not nothing - its more like absolutely required :-)
> 
> You might check out the discussion with the subject "Performance 
> regression in scsi sequential throughput (iozone)	due to "e084b - 
> page-allocator: preserve PFN ordering when	__GFP_COLD is set"".
> While the original subject is misleading from todays point of view, it 
> contains a lengthy discussion about exactly when/why/where time is lost 
> due to congestion wait with a lot of traces, counters, data attachments 
> and such stuff.

Well if we're not encountering lots of dirty pages in reclaim then we
shouldn't be waiting for writes to retire, of course.

But if we're not encountering lots of dirty pages in reclaim, we should
be reclaiming pages, normally.

I could understand reclaim accidentally going into congestion_wait() if
it hit a large pile of pages which are unreclaimable for reasons other
than being dirty, but is that happening in this case?

If not, we broke it again.
