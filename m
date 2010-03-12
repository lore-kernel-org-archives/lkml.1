Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0CLGjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 01:39:40 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:36549 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0CLGjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 01:39:39 -0500
Message-ID: <4B99E19E.6070301@linux.vnet.ibm.com>
Date: Fri, 12 Mar 2010 07:39:26 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <20100311154124.e1e23900.akpm@linux-foundation.org>
In-Reply-To: <20100311154124.e1e23900.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Mon,  8 Mar 2010 11:48:20 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
>> Under memory pressure, the page allocator and kswapd can go to sleep using
>> congestion_wait(). In two of these cases, it may not be the appropriate
>> action as congestion may not be the problem.
> 
> clear_bdi_congested() is called each time a write completes and the
> queue is below the congestion threshold.
> 
> So if the page allocator or kswapd call congestion_wait() against a
> non-congested queue, they'll wake up on the very next write completion.

Well the issue came up in all kind of loads where you don't have any 
writes at all that can wake up congestion_wait.
Thats true for several benchmarks, but also real workload as well e.g. A 
backup job reading almost all files sequentially and pumping out stuff 
via network.

> Hence the above-quoted claim seems to me to be a significant mis-analysis and
> perhaps explains why the patchset didn't seem to help anything?

While I might have misunderstood you and it is a mis-analysis in your 
opinion, it fixes a -80% Throughput regression on sequential read 
workloads, thats not nothing - its more like absolutely required :-)

You might check out the discussion with the subject "Performance 
regression in scsi sequential throughput (iozone)	due to "e084b - 
page-allocator: preserve PFN ordering when	__GFP_COLD is set"".
While the original subject is misleading from todays point of view, it 
contains a lengthy discussion about exactly when/why/where time is lost 
due to congestion wait with a lot of traces, counters, data attachments 
and such stuff.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
