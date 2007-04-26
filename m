Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXDZPI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXDZPI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXDZPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:08:28 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:47370 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752062AbXDZPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:08:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=3J0jFjldgIjISu+OGRnw5tepaa2LwoOGuSO9HQwwHl7qNjlZlLCRo2EmUBLtEpx3HTUXmgByhIrBFpJ7HLfIBPsQAvpuw4ptbPocYB59pxKQA6W2uCaQn50lb9miJIEzePd7Z5AFNGgngey4k4Ql6D2G6BizRfsOsGhNJLzzrsA=  ;
X-YMail-OSG: 9NMx7JYVM1kKHApmXy.LFayBWf8HwzO5QXPhWrXFm6nZb.dx
Message-ID: <4630C061.10309@yahoo.com.au>
Date: Fri, 27 Apr 2007 01:08:17 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <46309D16.70109@shadowen.org>
In-Reply-To: <46309D16.70109@shadowen.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Nick Piggin wrote:
> 

>>I don't understand what you mean at all. A block has always been a
>>contiguous area of disk.
> 
> 
> Lets take Nick's definition of block being a disk based unit for the
> moment.  That does not change the key contention here, that even with
> hardware specifically designed to handle 4k pages that hardware handles
> larger contigious areas more efficiently.  David Chinner gives us
> figures showing major overall throughput improvements from (I assume)
> shorter scatter gather lists and better tag utilisation.  I am loath to
> say we can just blame the hardware vendors for poor design.

So their controllers get double the throughput when going from 512K
(128x4K pages) to 2MB (128x16K pages) requests. Do you really think
it is to do with command processing overhead?


>>Actually, I don't know why people are so excited about being able to
>>use higher order allocations (I would rather be more excited about
>>never having to use them). But for those few places that really need
>>it, I'd rather see them use a virtually mapped kernel with proper
>>defragmentation rather than putting hacks all through the core code.
> 
> 
> Virtually mapping the kernel was considered pretty seriously around the
> time SPARSEMEM was being developed.  However, that leads to a
> non-constant relation for converting kernel virtual addresses to
> physical ones which leads to significant complexity, not to mention
> runtime overhead.

Yeah, a page table walk (or better, a TLB hit). And yeah it will cost
a bit of performance, it always does.


> As a solution to the problem of supplying large pages from the allocator
> it seems somewhat unsatisfactory.  If no significant other changes are
> made in support of large allocations, the process of defragmenting
> becomes very expensive.  Requiring a stop_machine style hiatus while the
> physical copy and replace occurs for any kernel backed memory.

That would be a stupid thing to do though. All you need to do (after
you keep DMA away) is to unmap the pages.


> To put it a different way, even with such a full defragmentation scheme
> available some sort of avoidance scheme would be highly desirable to
> avoid using the very expensive deframentation underlying it.

Maybe. That doesn't change the fact that avoidance isn't a complete
solution by itself.


>>Is that a big problem? Really? You use 16K pages on your IPF systems,
>>don't you?
> 
> 
> To my knowledge, moving to a higher base page size has its advantages in
> TLB reach, but brings with it some pretty serious downsides.  Especially
> in caching small files.  Internal fragmentation in the page cache
> significantly affecting system performance.  So much so that development
> is ongoing to see if supporting sub-base-page objects in the buffer
> cache could be beneficial.

I think 16K would be pretty reasonable (ia64 tends to use it). I guess
powerpc went to 64k either because that's what databases want or because
their TLB refills are too slow, so the internal fragmentation bites
them a lot harder.

But that was more of a side comment, because I still think io controllers
should be easily capable of operation on 4K pages. Graphics cards are,
aren't they?

-- 
SUSE Labs, Novell Inc.
