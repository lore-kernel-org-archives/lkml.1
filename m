Return-Path: <linux-kernel-owner+w=401wt.eu-S1030673AbXDUMWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030673AbXDUMWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 08:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXDUMWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 08:22:08 -0400
Received: from omta03sl.mx.bigpond.com ([144.140.92.155]:25285 "EHLO
	omta03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030673AbXDUMWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 08:22:07 -0400
Message-ID: <462A01E1.6040207@bigpond.net.au>
Date: Sat, 21 Apr 2007 22:21:53 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Williams <pwil3058@bigpond.net.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420131544.GG31925@holomorphy.com> <4629596B.6020403@bigpond.net.au> <20070421050734.GL31925@holomorphy.com> <4629A349.8060207@bigpond.net.au> <4629BE29.6010306@bigpond.net.au> <20070421075401.GA23410@elte.hu> <4629E952.4000508@bigpond.net.au>
In-Reply-To: <4629E952.4000508@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Sat, 21 Apr 2007 12:21:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Ingo Molnar wrote:
>> * Peter Williams <pwil3058@bigpond.net.au> wrote:
>>
>>> I retract this suggestion as it's a very bad idea.  It introduces the 
>>> possibility of starvation via the poor sods at the bottom of the 
>>> queue having their "on CPU" forever postponed and we all know that 
>>> even the smallest possibility of starvation will eventually cause 
>>> problems.
>>>
>>> I think there should be a rule: Once a task is on the queue its "on 
>>> CPU" time is immutable.
>>
>> Yeah, fully agreed. Currently i'm using the simple method of 
>> p->nice_offset, which plainly just moves the per nice level areas of 
>> the tree far enough apart (by a constant offset) so that lower nice 
>> levels rarely interact with higher nice levels. Lower nice levels 
>> never truly starve because rq->fair_clock increases deterministically 
>> and currently the fair_key values are indeed 'immutable' as you suggest.
>>
>> In practice they can starve a bit when one renices thousands of tasks, 
>> so i was thinking about the following special-case: to at least make 
>> them easily killable: if a nice 0 task sends a SIGKILL to a nice 19 
>> task then we could 'share' its p->wait_runtime with that nice 19 task 
>> and copy the signal sender's nice_offset. This would in essence pass 
>> the right to execute over to the killed task, so that it can tear 
>> itself down.
>>
>> This cannot be used to gain an 'unfair advantage' because the signal 
>> sender spends its own 'right to execute on the CPU', and because the 
>> target task cannot execute any user code anymore when it gets a SIGKILL.
>>
>> In any case, it is clear that rq->raw_cpu_load should be used instead 
>> of rq->nr_running, when calculating the fair clock, but i begin to 
>> like the nice_offset solution too in addition of this: it's effective 
>> in practice and starvation-free in theory, and most importantly, it's 
>> very simple. We could even make the nice offset granularity tunable, 
>> just in case anyone wants to weaken (or strengthen) the effectivity of 
>> nice levels. What do you think, can you see any obvious (or less 
>> obvious) showstoppers with this approach?
> 
> I haven't had a close look at it but from the above description it 
> sounds an order of magnitude more complex than I thought it would be. 
> The idea of different nice levels sounds like a recipe for starvation to 
> me (if it works the way it sounds like it works).
> 
> I guess I'll have to spend more time reading the code because I don't 
> seem to be able to make sense of the above description in any way that 
> doesn't say "starvation here we come".

I'm finding it hard to figure out what the underling principle for the 
way you're queuing things by reading the code (that's the trouble with 
reading the code it just tells you what's being done not why -- and 
sometimes it's even hard to figure out what's being done when there's a 
lot of indirection).  sched-design-CFS.txt isn't much help in this area 
either.

Any chance of a brief description of how it's supposed to work?

Key questions are:

How do you decide the key value for a task's position in the queue?

Is it an absolute time or an offset from the current time?

How do you decide when to boot the current task of the queue?  Both at 
wake up of another task and in general play?

Peter
PS I think that you're trying to do too much in one patch.
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
