Return-Path: <linux-kernel-owner+w=401wt.eu-S965218AbXG1H1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218AbXG1H1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbXG1H1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:27:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXG1H1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:27:05 -0400
Message-ID: <46AAEFC4.8000006@redhat.com>
Date: Sat, 28 Jul 2007 03:27:00 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: How can we make page replacement smarter (was: swap-prefetch)
References: <200707272243.02336.a1426z@gawab.com> <46AAA25E.7040301@redhat.com> <200707280717.41250.a1426z@gawab.com>
In-Reply-To: <200707280717.41250.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Chris Snook wrote:
>> Resource size has been outpacing processing latency since the dawn of
>> time. Disks get bigger much faster than seek times shrink.  Main memory
>> and cache keep growing, while single-threaded processing speed has nearly
>> ground to a halt.
>>
>> In the old days, it made lots of sense to manage resource allocation in
>> pages and blocks.  In the past few years, we started reserving blocks in
>> ext3 automatically because it saves more in seek time than it costs in
>> disk space. Now we're taking preallocation and antifragmentation to the
>> next level with extent-based allocation in ext4.
>>
>> Well, we're still using bitmap-style allocation for pages, and the
>> prefetch-less swap mechanism adheres to this design as well.  Maybe it's
>> time to start thinking about memory in a somewhat more extent-like
>> fashion.
>>
>> With swap prefetch, we're only optimizing the case when the box isn't
>> loaded and there's RAM free, but we're not optimizing the case when the
>> box is heavily loaded and we need for RAM to be free.  This is a complete
>> reversal of sane development priorities.  If swap batching is an
>> optimization at all (and we have empirical evidence that it is) then it
>> should also be an optimization to swap out chunks of pages when we need to
>> free memory.
>>
>> So, how do we go about this grouping?  I suggest that if we keep per-VMA
>> reference/fault/dirty statistics, we can tell which logically distinct
>> chunks of memory are being regularly used.  This would also us to apply
>> different page replacement policies to chunks of memory that are being
>> used in different fashions.
>>
>> With such statistics, we could then page out VMAs in 2MB chunks when we're
>> under memory pressure, also giving us the option of transparently paging
>> them back in to hugepages when we have the memory free, once anonymous
>> hugepage support is in place.
>>
>> I'm inclined to view swap prefetch as a successful scientific experiment,
>> and use that data to inform a more reasoned engineering effort.  If we can
>> design something intelligent which happens to behave more or less like
>> swap prefetch does under the circumstances where swap prefetch helps, and
>> does something else smart under the circumstances where swap prefetch
>> makes no discernable difference, it'll be a much bigger improvement.
>>
>> Because we cannot prove why the existing patch helps, we cannot say what
>> impact it will have when things like virtualization and solid state drives
>> radically change the coefficients of the equation we have not solved. 
>> Providing a sysctl to turn off a misbehaving feature is a poor substitute
>> for doing it right the first time, and leaving it off by default will
>> ensure that it only gets used by the handful of people who know enough to
>> rebuild with the patch anyway.
>>
>> Let's talk about how we can make page replacement smarter, so it naturally
>> accomplishes what swap prefetch accomplishes, as part of a design we can
>> reason about.
>>
>> CC-ing linux-mm, since that's where I think we should take this next.
> 
> Good idea, but unless we understand the problems involved, we are bound to 
> repeat it.  So my first question would be:  Why is swap-in so slow?
> 
> As I have posted in other threads, swap-in of consecutive pages suffers a 2x 
> slowdown wrt swap-out, whereas swap-in of random pages suffers over 6x 
> slowdown.
> 
> Because it is hard to quantify the expected swap-in speed for random pages, 
> let's first tackle the swap-in of consecutive pages, which should be at 
> least as fast as swap-out.  So again, why is swap-in so slow?

If I'm writing 20 pages to swap, I can find a suitable chunk of swap and 
write them all in one place.  If I'm reading 20 pages from swap, they 
could be anywhere.  Also, writes get buffered at one or more layers of 
hardware.  At best, reads can be read-ahead and cached, which is why 
sequential swap-in sucks less.  On-demand reads are as expensive as I/O 
can get.

> Once we understand this problem, we may be able to suggest a smart 
> improvement.

There are lots of page replacement schemes that optimize for different 
access patterns, and they all suck at certain other access patterns.  We 
tweak our behavior slightly based on fadvise and madvise hints, but most 
of the memory we're managing is an opaque mass.  With more statistics, 
we could do a better job of managing chunks of unhinted memory with 
disparate access patterns.  Of course, this imposes overhead.  I 
suggested VMA granularity because a VMA represents a logically distinct 
piece of address space, though this may not be suitable for shared mappings.

	-- Chris
