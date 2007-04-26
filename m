Return-Path: <linux-kernel-owner+w=401wt.eu-S1031170AbXDZKz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031170AbXDZKz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031178AbXDZKz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:55:29 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48173 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031170AbXDZKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:55:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: mel@skynet.ie (Mel Gorman)
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<46303A98.9000605@yahoo.com.au>
	<20070426063830.GE32602149@melbourne.sgi.com>
	<46304B9E.5070604@yahoo.com.au> <20070426084012.GA26926@skynet.ie>
	<463068E5.6000402@yahoo.com.au> <20070426103014.GC27620@skynet.ie>
Date: Thu, 26 Apr 2007 04:54:04 -0600
In-Reply-To: <20070426103014.GC27620@skynet.ie> (Mel Gorman's message of "Thu,
	26 Apr 2007 11:30:16 +0100")
Message-ID: <m1y7kfl837.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mel@skynet.ie (Mel Gorman) writes:

> On (26/04/07 18:55), Nick Piggin didst pronounce:
>> Mel Gorman wrote:
>> >On (26/04/07 16:50), Nick Piggin didst pronounce:
>> 
>> >>Fragmentation is the problem. The anti-frag patches don't actually
>> >>guarantee anything about fragmentation, and even if they did, then
>> >
>> >
>> >The grouping pages by mobility do not guarantee anything but the memory
>> >partition (kernelcore= boot parameter) does give hard guarantees about
>> >the amount of memory that is "movable". Of course, the partition requires
>> >configuration at boot-time so it's less than ideal but it does give hard
>> >guarantees.
>> 
>> For the hugepages people, I can understand that's a solution.
>
> I think that's the closest you have ever come to saying fragmentation
> avoidance is not a terrible idea :)
>
>> But that's
>> the last thing you want to do on a system with a limited amount of memory,
>> or a regular Joe's desktop/server.
>> 
>
> Regular Joe is not going to be creating a filesystem with large blocks or
> overly concerned with saturating all the disks hanging off his RAID array.
> At most, he'll care about faster DVD writing and considering the number and
> duration of those allocations, the system will be able to handle it. So I
> don't think Regular Joe will generally care.

The practical question is if this a special purpose hack, or is
this general infrastructure that we expect filesystems to seriously
use.

If this is a special purpose hack then the larger pages and
fragmentation are minor issues, but it's very existence is a problem.

If this is not a special purpose hack and people do use this a lot
then the fragmentation is a problem. 

Your reply indicates that fragmentation is a concern, as does the
initial posting and the more positive threads.  Therefore either
this is a special purpose hack in which case it's existence is
questionable or it fails a general solution and it's existence
is questionable.


>> >Indeed but then you have to deal with internal fragmentation 
>> >for pages-larger-than-TLB-page. I'm not saying it's wrong but it does
>> >come with it's own set of issues.
>> 
>> None of them is perfect (the ways to increase the size of pagecache pages,
>> that is).
>> 
>> I think in the long term, TLB page sizes will probably increase a little
>> bit... but if a given page size is "good enough" for a CPU, they really
>> should be good enough for other hardware. I mean, come on, the CPU's TLB
>> has to have a good hit ratio and handle several lookups per cycle with a
>> 3-cycle latency on 3GHz+ hardware... surely a an IO controller's
>> scatter-gather engine or IOMMU that has to do a few lookups per disk IO
>> is nowhere near so critical as a CPU's datapath: just add a few more
>> entries to it, they've already got hundreds of megs of cache, so that
>> isn't an issue either.
>> 
>
> I cannot speak with authority on what IO controllers are really capable
> of so maybe someone else will comment on this more.

Well here is some reality.  Using an FPGA (slow by definition)
connected to a hypertransport interface I have exceeded a gigabyte a
second, without even setting up scatter gather.

All of the I/O on all of the peripheral busses happens in sub 
1 page chunks.

At the rates we are talking for disks the issue is really how to
bury the disk latency.  For fast arrays how do you submit enough
request to bury the latency. 

I can't possibly believe any of this is about the cost of processing
a request, but rather the problem that some devices don't have a large
enough pool of requests to keep them busy if you submit the requests
in a 4K page sizes.

This all sounds like a device design issue rather than anything more
significant, and it doesn't sound like a long term trend.  Market
pressure should fix the hardware.


Eric
