Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZBVX70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZBVX70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZBVX7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:59:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49351 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZBVX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:59:17 -0500
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
From: Andi Kleen <andi@firstfloor.org>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Date: Mon, 23 Feb 2009 00:57:37 +0100
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> (Mel Gorman's message of "Sun, 22 Feb 2009 23:17:09 +0000")
Message-ID: <87prhauiry.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mel@csn.ul.ie> writes:

> The complexity of the page allocator has been increasing for some time
> and it has now reached the point where the SLUB allocator is doing strange
> tricks to avoid the page allocator. This is obviously bad as it may encourage
> other subsystems to try avoiding the page allocator as well.

Congratulations! That was long overdue. Haven't read the patches yet though.

> Patch 15 reduces the number of times interrupts are disabled by reworking
> what free_page_mlock() does. However, I notice that the cost of calling
> TestClearPageMlocked() is still quite high and I'm guessing it's because
> it's a locked bit operation. It's be nice if it could be established if
> it's safe to use an unlocked version here. Rik, can you comment?

What machine was that again?

> Patch 16 avoids using the zonelist cache on non-NUMA machines

My suspicion is that it can be even dropped on most small (all?) NUMA systems.

> Patch 20 gets rid of hot/cold freeing of pages because it incurs cost for
> what I believe to be very dubious gain. I'm not sure we currently gain
> anything by it but it's further discussed in the patch itself.

Yes the hot/cold thing was always quite dubious.

> Counters are surprising expensive, we spent a good chuck of our time in
> functions like __dec_zone_page_state and __dec_zone_state. In a profiled
> run of kernbench, the time spent in __dec_zone_state was roughly equal to
> the combined cost of the rest of the page free path. A quick check showed
> that almost half of the time in that function is spent on line 233 alone
> which for me is;
>
> 	(*p)--;
>
> That's worth a separate investigation but it might be a case that
> manipulating int8_t on the machine I was using for profiling is unusually
> expensive. 

What machine was that?

In general I wouldn't expect even on a system with slow char
operations to be that expensive. It sounds more like a cache miss or a
cache line bounce. You could possibly confirm by using appropiate
performance counters.

> Converting this to an int might be faster but the increased
> memory consumption and cache footprint might be a problem. Opinions?

One possibility would be to move the zone statistics to allocated
per cpu data. Or perhaps just stop counting per zone at all and
only count per cpu.

> The downside is that the patches do increase text size because of the
> splitting of the fast path into one inlined blob and the slow path into a
> number of other functions. On my test machine, text increased by 1.2K so
> I might revisit that again and see how much of a difference it really made.
>
> That all said, I'm seeing good results on actual benchmarks with these
> patches.
>
> o On many machines, I'm seeing a 0-2% improvement on kernbench. The dominant

Neat.

> So, by and large it's an improvement of some sort.

That seems like an understatement.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
