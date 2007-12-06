Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXLFVhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXLFVhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXLFVg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:36:59 -0500
Received: from mail.tmr.com ([64.65.253.246]:43940 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbXLFVg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:36:58 -0500
Message-ID: <47586F59.5090507@tmr.com>
Date: Thu, 06 Dec 2007 16:53:29 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
References: <200712051603.02183.phillips@phunq.net> <20071205172446.ea54e4d3.akpm@linux-foundation.org> <200712052221.45409.phillips@phunq.net>
In-Reply-To: <200712052221.45409.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Wednesday 05 December 2007 17:24, Andrew Morton wrote:
>> On Wed, 5 Dec 2007 16:03:01 -0800 Daniel Phillips <phillips@phunq.net> wrote:
>>> ...a block device these days may not be just a single 
>>> device, but may be a stack of devices connected together by a generic 
>>> mechanism such as device mapper, or a hardcoded stack such as 
>>> multi-disk or network block device.  It is necessary to consider the 
>>> resource requirements of the stack as a whole _before_ letting a 
>>> transfer proceed into any layer of the stack, otherwise deadlock on 
>>> many partially completed transfers becomes a possibility.  For this 
>>> reason, the bio throttling is only implemented at the initial, highest 
>>> level submission of the bio to the block layer and not for any recursive 
>>> submission of the same bio to a lower level block device in a stack.
>>>
>>> This in turn has rather far reaching implications: the top level device 
>>> in a stack must take care of inspecting the entire stack in order to 
>>> determine how to calculate its resource requirements, thus becoming
>>> the boss device for the entire stack.  Though this intriguing idea could 
>>> easily become the cause of endless design work and many thousands of 
>>> lines of fancy code, today I sidestep the question entirely using 
>>> the "just provide lots of reserve" strategy.  Horrifying as it may seem 
>>> to some, this is precisely the strategy that Linux has used in the 
>>> context of resource management in general, from the very beginning and 
>>> likely continuing for quite some time into the future  My strongly held 
>>> opinion in this matter is that we need to solve the real, underlying 
>>> problems definitively with nice code before declaring the opening of 
>>> fancy patch season.  So I am leaving further discussion of automatic 
>>> resource discovery algorithms and the like out of this post.
>> Rather than asking the stack "how much memory will this request consume"
>> you could instead ask "how much memory are you currently using".
>>
>> ie: on entry to the stack, do 
>>
>> 	current->account_block_allocations = 1;
>> 	make_request(...);
>> 	rq->used_memory += current->pages_used_for_block_allocations;
>>
>> and in the page allocator do
>>
>> 	if (!in_interrupt() && current->account_block_allocations)
>> 		current->pages_used_for_block_allocations++;
>>
>> and then somehow handle deallocation too ;)
> 
> Ah, and how do you ensure that you do not deadlock while making this
> inquiry?  Perhaps send a dummy transaction down the pipe?  Even so,
> deadlock is possible, quite evidently so in the real life example I have
> at hand.
> 
> Yours is essentially one of the strategies I had in mind, the other major
> one being simply to examine the whole stack, which presupposes some
> as-yet-nonexistant kernel wide method of representing block device
> stacks in all there glorious possible topology variations.
> 
>> The basic idea being to know in real time how much memory a particular
>> block stack is presently using.  Then, on entry to that stack, if the
>> stack's current usage is too high, wait for it to subside.
> 
> We do not wait for high block device resource usage to subside before
> submitting more requests.  The improvement you suggest is aimed at
> automatically determining resource requirements by sampling a
> running system, rather than requiring a programmer to determine them
> arduously by hand.  Something like automatically determining a
> workable locking strategy by analyzing running code, wouldn't that be
> a treat?  I will hope for one of those under my tree at Christmas.
> 
The problem is that you (a) may or may not know just how bad a worst 
case can be, and (b) may block unnecessarily by being pessimistic.

The dummy transaction would be nice, but it would be perfect if you 
could send the real transaction down with a max memory limit and a flag, 
have each level check and decrement the max by what's actually needed, 
and then return some pass/fail status for that particular transaction. 
Clearly every level in the stack would have to know how to do that. It 
would seem that once excess memory use was detected the transaction 
could be failed without deadlock.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
