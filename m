Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYCKRKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYCKRKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYCKRKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:10:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27641 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYCKRKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:10:40 -0400
Message-ID: <47D6BD0C.6070401@ct.jp.nec.com>
Date: Tue, 11 Mar 2008 10:10:36 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, hpj@urpla.net,
       stable <stable@kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: fix race in schedule
References: <47D57770.50909@ct.jp.nec.com> <1205174197.8514.159.camel@twins>	 <47D593A5.5060906@ct.jp.nec.com> <1205181256.6241.320.camel@lappy>	 <47D5EA9C.1040404@ct.jp.nec.com> <1205224835.8514.183.camel@twins>
In-Reply-To: <1205224835.8514.183.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-03-10 at 19:12 -0700, Hiroshi Shimamoto wrote:
>> Peter Zijlstra wrote:
>>> On Mon, 2008-03-10 at 13:01 -0700, Hiroshi Shimamoto wrote:
>>>
>>>> thanks, your patch looks nice to me.
>>>> I had focused setprio, on_rq=0 and running=1 situation, it makes me to
>>>> fix these functions.
>>>> But one point, I've just noticed. I'm not sure on same situation against
>>>> sched_rt. I think the pre_schedule() of rt has chance to drop rq lock.
>>>> Is it OK?
>>> Ah, you are quite right, that'll teach me to rush out a patch just
>>> because dinner is ready :-). 
>>>
>>> How about we submit the following patch for mainline and CC -stable to
>>> fix .23 and .24:
>>>
>> Unfortunately, I encountered similar panic with this patch on -rt.
>> I'll look into this, again. I might have missed something...
>>
>> Unable to handle kernel NULL pointer dereference at 0000000000000128 RIP:
>>  [<ffffffff802297f5>] pick_next_task_fair+0x2d/0x42
> 
> :-(
> 
> OK, so that means I'm not getting it.
> 
> So what does your patch do that mine doesn't?
> 
> It removes the dependency of running (=task_current()) from on_rq
> (p->se.on_rq).
> 
> So how can a current task not be on the runqueue?
> 
> Only sched.c:dequeue_task() and sched_fair.c:account_entity_dequeue()
> set on_rq to 0, the only one changing rq->curr is schedule().
> 
> So the only scheme I can come up with is that we did dequeue p (on_rq ==
> 0), but we didn't yet schedule so rq->curr == p.
> 
> Is this how you ended up with your previuos analysis that it must be due
> to a hole introduced by double_lock_balance()?
> 
> Because now we can seemingly call deactivate_task() and put_prev_task()
> in non-atomic fashion, but by placing the put_prev_task() before the
> load balance calls we should avoid doing that.
> 
> So what else is going on... /me puzzled

thanks for taking time.
I've tested it with debug tracer, it took several hours to half day to
reproduce it on my box. And I got the possible scenario.

Before begin, I can tell that se->on_rq is changed at enqueue_task() or
dequeue_task() in sched.c.

Here is the flow to panic which I got;
   CPU0                               CPU1
    |                              schedule()
    |                              ->deactivate_task()
    |                              -->dequeue_task()
    |                                  * on_rq=0
    |                              ->put_prev_task_fair()
    |                              ->idle_balance()
    |                              -->load_balance_newidle()
(a wakeup function)                    |
    |                              --->double_lock_balance()
    *get lock                          *rel lock
    * wake up target is CPU1's curr    |
->enqueue_task()                       |
    * on_rq=1                          |
->rt_mutex_setprio()                   |
    * on_rq=1, ruuning=1               |
-->dequeue_task()!!                    |
-->put_prev_task_fair()!!              |
    * sched_class is changed           |
-->set_curr_task_fair()!!              |
-->enqueue_task()!!                    |
    *rel lock                          *get lock again
    :                                  |
                                       :
                                   ->pick_next_task_fair()
                                       => panic

The difference from the previous scenario is;
some one enqueues CPU1,s current task before setprio,
it makes on_rq=1 and it causes set_curr_task_fair() called.
It means that the cfs_rq state of the current task is set to
before put_prev_task_fair(), I think.

Does this scenario help to solve this issue?
And I only test it on -rt because I can reproduce it on -rt only.

thanks,
Hiroshi Shimamoto
