Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZBEIUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZBEIUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZBEIUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:20:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52660 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbZBEIUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:20:09 -0500
Message-ID: <498AA0F1.2030003@cn.fujitsu.com>
Date: Thu, 05 Feb 2009 16:18:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
References: <497838F0.7020408@cn.fujitsu.com>	 <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu>	 <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop>
In-Reply-To: <1232622615.4890.114.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-01-22 at 12:06 +0100, Frédéric Weisbecker wrote:
> 
>> Actually I don't understand when Lai says that it will actually not flush.
> 
> Yeah, his changelog is an utter mistery to many..
> 
> 

----
Suppose what I wanted to say is A, but sometimes I wrote B for my poor
English, and people got C when they read it. Thank you, Peter.
----

"if (cwq->thread == current)" is a narrowed checking. lockdep can perform
the proper checking. I think we could hardly write some code which can
perform the proper checking when lockdep is off.

Why "if (cwq->thread == current)" is a narrowed checking,
It hasn't tested "if (brother_cwq->thread == current)". (*brother* cwq)

DEADLOCK EXAMPLE for explain my above option:

(work_func0() and work_func1() are work callback, and they
calls flush_workqueue())

CPU#0					CPU#1
run_workqueue()                         run_workqueue()
  work_func0()                            work_func1()
    flush_workqueue()                       flush_workqueue()
      flush_cpu_workqueue(0)                  .
      flush_cpu_workqueue(cpu#1)              flush_cpu_workqueue(cpu#0)
        waiting work_func1() in cpu#1           waiting work_func0 in cpu#0

DEADLOCK!
So we do not allow recursion.
And "BUG_ON(cwq->thread == current)" is not enough(but it's better
than we don't have this line, I think). we should use lockdep to detect
recursion when we develop.

Answer other email-thread:

Peter Zijlstra wrote:
> On Thu, 2009-01-22 at 14:03 +0800, Lai Jiangshan wrote:
>> void do_some_cleanup(void)
>> {
>>         find_all_queued_work_struct_and_mark_it_old();
>>         flush_workqueue(workqueue);
>>         /* we can destroy old work_struct for we have flushed them */
>>         destroy_old_work_structs();
>> }
>>
>> if work->func() called do_some_cleanup(), it's very probably a bug.
> 
> Of course it is, if only because calling flush on the same workqueue is
> pretty dumb.

flush_workqueue() should ensure works are finished, but this example shows
the work hasn't finished, so flush_workqueue()'s code is not right.

See also flush_workqueue()'s doc:
 * We sleep until all works which were queued on entry have been handled,
 * but we are not livelocked by new incoming ones.

And this example show a bug(destroy the work which still be used)
for recursion. So in my changlog:

I said it hide deadlock:
   "We use recursion run_workqueue to hidden deadlock when
   keventd trying to flush its own queue."

I said it will be bug(for flush_workqueue() and it's doc is inconsistent):
   "It's bug. When flush_workqueue()(nested in a work callback)returns,
   the workqueue is not really flushed, the sequence statement of
   this work callback will do some thing bad."

And I concluded:
   "So we should not allow workqueue trying to flush its own queue."

If it still mistery, I will explain more.
I will change my changlog too, I sincerely hope you help me more.

Thanks, Lai

> 
> But I'm still not getting it, flush_workqueue() provides the guarantee
> that all work enqueued previous to the call will be finished thereafter.

In my example, flush_workqueue() can't guarantee.

> 
> The self-flush stuff you propose to rip out doesn't violate that
> guarantee afaict.
> 
> Suppose we have a workqueue Q, with pending work W1..Wn.
> 
> Suppose W5 will have the nested flush, it will then recursively complete
> W6..Wn+i, where i accounts for any concurrent worklet additions.
> 
> Therefore it will have completed (at least) those worklets that were
> enqueued at the time flush got called.
> 
> So, to get back at your changelog.
> 
>  1) yes lockdep will complain -- for good reasons, and I'm all for
> getting rid of this mis-feature.
> 
>  2) I've no clue what you're on about
> 
>  3) more mystery.

