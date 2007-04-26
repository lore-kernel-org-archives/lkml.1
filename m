Return-Path: <linux-kernel-owner+w=401wt.eu-S1031209AbXDZMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031209AbXDZMhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031210AbXDZMhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:37:46 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1688 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031209AbXDZMhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:37:45 -0400
Message-ID: <46309D16.70109@shadowen.org>
Date: Thu, 26 Apr 2007 13:37:42 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au>
In-Reply-To: <463057D9.9030804@yahoo.com.au>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Christoph Lameter wrote:
>> On Thu, 26 Apr 2007, Nick Piggin wrote:
>>
>>
>>>> mapping through the radix tree. You just need to change the way the
>>>> filesystem looks up pages.
>>>
>>> You didn't think any of the criticisms of higher order page cache size
>>> were valid?
>>
>>
>> They are all known points that have been discussed to death.
> 
> I missed the part where you showed that it was a better solution than
> the alternatives.
> 
> 
>>>> What are the exact requirement you are trying to address?
>>>
>>> Block size > page cache size.
>>
>>
>> But what do you mean with it? A block is no longer a contiguous
>> section of memory. So you have redefined the term.
> 
> I don't understand what you mean at all. A block has always been a
> contiguous area of disk.

Lets take Nick's definition of block being a disk based unit for the
moment.  That does not change the key contention here, that even with
hardware specifically designed to handle 4k pages that hardware handles
larger contigious areas more efficiently.  David Chinner gives us
figures showing major overall throughput improvements from (I assume)
shorter scatter gather lists and better tag utilisation.  I am loath to
say we can just blame the hardware vendors for poor design.

>>> You guys have a couple of problems, firstly you need to have ia64
>>> filesystems accessable to x86_64. And secondly you have these
>>> controllers
>>> without enough sg entries for nice sized IOs.
>>
>>
>> This is not sgi specific sorry.
>>
>>
>>> I sympathise, and higher order pagecache might solve these in a way, but
>>> I don't think it is the right way to go, mainly because of the
>>> fragmentation
>>> issues.
>>
>>
>> And you dont care about Mel's work on that level?
> 
> I actually don't like it too much because it can't provide a robust
> solution. What do you do on systems with small memories, or those that
> eventually do get fragmented?
> 
> Actually, I don't know why people are so excited about being able to
> use higher order allocations (I would rather be more excited about
> never having to use them). But for those few places that really need
> it, I'd rather see them use a virtually mapped kernel with proper
> defragmentation rather than putting hacks all through the core code.

Virtually mapping the kernel was considered pretty seriously around the
time SPARSEMEM was being developed.  However, that leads to a
non-constant relation for converting kernel virtual addresses to
physical ones which leads to significant complexity, not to mention
runtime overhead.

As a solution to the problem of supplying large pages from the allocator
it seems somewhat unsatisfactory.  If no significant other changes are
made in support of large allocations, the process of defragmenting
becomes very expensive.  Requiring a stop_machine style hiatus while the
physical copy and replace occurs for any kernel backed memory.

To put it a different way, even with such a full defragmentation scheme
available some sort of avoidance scheme would be highly desirable to
avoid using the very expensive deframentation underlying it.

>>> Increasing PAGE_SIZE, support for block size > page cache size, and
>>> getting
>>> io controllers matched to a 4K page size IMO would be some good ways to
>>> solve these problems. I know they are probably harder...
>>
>>
>> No this has been tried before and does not work. Why should we loose
>> the capability to work with 4k pages just because there is some data
>> that has to be thrown around in quantity? I'd like to have flexibility
>> here.
> 
> Is that a big problem? Really? You use 16K pages on your IPF systems,
> don't you?

To my knowledge, moving to a higher base page size has its advantages in
TLB reach, but brings with it some pretty serious downsides.  Especially
in caching small files.  Internal fragmentation in the page cache
significantly affecting system performance.  So much so that development
is ongoing to see if supporting sub-base-page objects in the buffer
cache could be beneficial.

>> The fragmentation problem is solvable and we already have a solution
>> in mm. So I do not really see a problem there?
> 
> I don't think that it is solved, and I think the heuristics that are
> there would be put under more stress if they become widely used. And
> it isn't only about whether we can get the page or not, but also about
> the cost. Look up Linus's arguments about page colouring, which are
> similar and  I also think are pretty valid.

-apw

