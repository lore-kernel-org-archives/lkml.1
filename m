Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXDTHc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXDTHc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXDTHc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:32:58 -0400
Received: from omta02ps.mx.bigpond.com ([144.140.83.154]:61152 "EHLO
	omta02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbXDTHc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:32:57 -0400
Message-ID: <46286CA0.2050409@bigpond.net.au>
Date: Fri, 20 Apr 2007 17:32:48 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420064600.GA24614@elte.hu>
In-Reply-To: <20070420064600.GA24614@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Fri, 20 Apr 2007 07:32:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>>> - bugfix: use constant offset factor for nice levels instead of
>>>   sched_granularity_ns. Thus nice levels work even if someone sets 
>>>   sched_granularity_ns to 0. NOTE: nice support is still naive, i'll 
>>>   address the many nice level related suggestions in -v4.
>> I have a suggestion I'd like to make that addresses both nice and 
>> fairness at the same time.  As I understand the basic principle behind 
>> this scheduler it to work out a time by which a task should make it 
>> onto the CPU and then place it into an ordered list (based on this 
>> value) of tasks waiting for the CPU. I think that this is a great idea 
>> [...]
> 
> yes, that's exactly the main idea behind CFS, and thanks for the 
> compliment :)
> 
> Under this concept the scheduler never really has to guess: every 
> scheduler decision derives straight from the relatively simple 
> one-sentence (!) scheduling concept outlined above. Everything that 
> tasks 'get' is something they 'earned' before and all the scheduler does 
> are micro-decisions based on math with the nanosec-granularity values. 
> Both the rbtree and nanosec accounting are a straight consequence of 
> this too: they are the tools that allow the implementation of this 
> concept in the highest-quality way. It's certainly a very exciting 
> experiment to me and the feedback 'from the field' is very promising so 
> far.
> 
>> [...] and my suggestion is with regard to a method for working out 
>> this time that takes into account both fairness and nice.
>>
>> First suppose we have the following metrics available in addition to 
>> what's already provided.
>>
>> rq->avg_weight_load /* a running average of the weighted load on the 
>> CPU */ p->avg_cpu_per_cycle /* the average time in nsecs that p spends 
>> on the CPU each scheduling cycle */
> 
> yes. rq->nr_running is really just a first-level approximation of 
> rq->raw_weighted_load. I concentrated on the 'nice 0' case initially.
> 
>> I appreciate that the notion of basing the expected wait on the task's 
>> average cpu use per scheduling cycle is counter intuitive but I 
>> believe that (if you think about it) you'll see that it actually makes 
>> sense.
> 
> hm. So far i tried to not do any statistical approach anywhere: the 
> p->wait_runtime metric (which drives the task ordering) is in essence an 
> absolutely precise 'integral' of the 'expected runtimes' that the task 
> observes and hence is a precise "load-average as observed by the task"

To me this is statistics :-)

> in itself. Every time we base some metric on an average value we 
> introduce noise into the system.
> 
> i definitely agree with your suggestion that CFS should use a 
> nice-scaled metric for 'load' instead of the current rq->nr_running, but 
> regarding the basic calculations i'd rather lean towards using 
> rq->raw_weighted_load. Hm?

This can result in jerkiness (in my experience) but using the smoothed 
version is certainly something that can be tried later rather than 
sooner.  Perhaps just something to bear in mind as a solution to 
"jerkiness" if it manifests.

> 
> your suggestion concentrates on the following scenario: if a task 
> happens to schedule in an 'unlucky' way and happens to hit a busy period 
> while there are many idle periods. Unless i misunderstood your 
> suggestion, that is the main intention behind it, correct?

You misunderstand (that's one of my other schedulers :-)).  This one's 
based on the premise that if everything happens as the task expects it 
will get the amount of CPU bandwidth (over this short period) that it's 
entitled to.  In reality, sometimes it will get more and sometimes less 
but on average it should get what it deserves. E.g. If you had two tasks 
with equal nice and both had demands of 90% of a CPU you'd expect them 
each to get about half of the CPU bandwidth.  Now suppose that one of 
them uses 5ms of CPU each time it got onto the CPU and the other uses 
10ms.  If these two tasks just round robin with each other the likely 
outcome is that the one with the 10ms bursts will get twice as much CPU 
as the other but my proposed method should prevent and cause them to get 
roughly the same amount of CPU.  (I believe this was a scenario that 
caused problems with O(1) and required a fix at some stage?)

BTW this has the advantage that the decay rate used in calculating the 
task's statistics can be used to control how quickly the scheduler 
reacts to changes in the task's behaviour.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
