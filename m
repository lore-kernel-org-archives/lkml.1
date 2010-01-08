Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068Ab0AHUue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0AHUue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047Ab0AHUua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:50:30 -0500
Received: from lo.gmane.org ([80.91.229.12]:43590 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab0AHUuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:50:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Subject: Re: [RFC v5 PATCH 0/8] CFS Hard limits - v5
Date: Fri, 8 Jan 2010 20:45:27 +0000 (UTC)
Message-ID: <loom.20100108T214459-933@post.gmane.org>
References: <20100105075703.GE27899@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 216.239.45.4 (Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/532.8 (KHTML, like Gecko) Chrome/4.0.288.1 Safari/532.8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bharata,

Thanks for the updated patchset.  As discussed the other day briefly I have some
concerns with the usage of the current RT bandwidth rate-limiting code as there
are some assumptions made that I feel don't fit the general case well.

The reason for this is that the borrowing logic in bandwidth rebalance appears
to make the assumption that we wil will be able to converge rapidly to the
period.  Indeed, in each iteration of redistribution we take only
1/weight(nrcpus) [assuming no cpuset partitions] of the time remaining.  This is
a decreasing series, and if we can't exceed the period our convergence looks
pretty slow [geometric series].

In general it appears the following relation be satisfied for efficient
execution:  (weight(nr_cpus) * runtime) >> period

This assumption is well satisfied in the RT case since the available bandwidth
is very high.  However I fear for the general case of user limits on tg usage
lie at the other end of the spectrum.  Especially for those trying to partition
large machines into many smaller well provisioned fractions, e.g. 0-2 cores out
of a total 64.  The lock and re-distribution cost for each iteration is also
going to be quite high in this case which will potentially compound on the
number of iterations required above.

What are your thoughts on using a separate mechanism for the general case.  A 
draft proposal follows:

- Maintain a global run-time pool for each tg.  The runtime specified by the
  user represents the value that this pool will be refilled to each period.
- We continue to maintain the local notion of runtime/period in each cfs_rq,
  continue to accumulate locally here.

Upon locally exceeding the period acquire new credit from the global pool
(either under lock or more likely using atomic ops).  This can either be in
fixed steppings (e.g. 10ms, could be tunable) or following some quasi-curve
variant with historical demand.

One caveat here is that there is some over-commit in the system, the local
differences of runtime vs period represent additional over the global pool.
However it should not be possible to consistently exceed limits since the rate
of refill is gated by the runtime being input into the system via the per-tg
pool.

This would also naturally associate with an interface change that would mean the
runtime limit for a group would be the effective cpurate within the period.

e.g. by setting a runtime of 200000us on a 100000us period it would effectively
allow you to use 2 cpus worth of wall-time on a multicore system.

I feel this is slightly more natural than the current definition which due to
being local means that values set will not result in consistent behavior across
machines of different core counts.  It also has the benefit of being consistent
with observed exports of time consumed, e.g. rusage, (indirectly) time, etc.

For future scalability as machine size grows this could potentially be
partitioned below the tg level along the boundaries of sched_domains (or
something similar).  However for an initial draft given current machine sizes
the contention on the global pool should hopefully be fairly low.

- Paul


