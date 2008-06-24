Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbYFXB7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbYFXB7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYFXB7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:59:31 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:19825 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbYFXB7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:59:18 -0400
Message-Id: <48602ACD.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 23 Jun 2008 20:59:25 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <peterz@infradead.org>,
       <tglx@linutronix.de>, "David Bahi" <DBahi@novell.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at
	least one task has moved over
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
 <200806241050.12028.nickpiggin@yahoo.com.au>
 <4860261A.BA47.005A.0@novell.com>
 <200806241146.35112.nickpiggin@yahoo.com.au>
In-Reply-To: <200806241146.35112.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Jun 23, 2008 at  9:46 PM, in message
<200806241146.35112.nickpiggin@yahoo.com.au>, Nick Piggin
<nickpiggin@yahoo.com.au> wrote: 
> On Tuesday 24 June 2008 12:39, Gregory Haskins wrote:
>> Hi Nick,
>>
>> >>> On Mon, Jun 23, 2008 at  8:50 PM, in message
>>
>> <200806241050.12028.nickpiggin@yahoo.com.au>, Nick Piggin
>>
>> <nickpiggin@yahoo.com.au> wrote:
>> > On Tuesday 24 June 2008 09:04, Gregory Haskins wrote:
>> >> Inspired by Peter Zijlstra.
>> >
>> > Is this really getting tested well?   Because at least for SCHED_OTHER
>> > tasks,
>>
>> Note that this only affects SCHED_OTHER.  RT tasks are handled with a
>> different algorithm.
>>
>> > the newidle balancer is still supposed to be relatively
>> > conservative and not over balance too much.
>>
>> In our testing, newidle is degrading the system (at least for certain
>> workloads).  Oprofile was showing that newidle can account for 60-80% of
>> the CPU during our benchmark runs. Turning off newidle *completely* by
>> commenting out idle_balance() boosts netperf performance by 200% for our
>> 8-core to 8-core UDP transaction test. Obviously neutering it is not
>> sustainable as a general solution, so we are trying to reduce its negative
>> impact.
> 
> Hmm. I'd like to see an attempt to be made to tuning the algorithm
> so that newidle actually won't cause any tasks to be balanced in
> this case. That seems like the right thing to do, doesn't it?

Agreed.  I'm working on it, but its not quite ready yet :)

> 
> Of course... tuning the whole balancer on the basis of a crazy
> netperf benchmark is... dangerous :)

Agreed.  I am working on a general algorithm to make the
RT and CFS tasks "play nice" with each other.  This netperf test
was chosen because it is particularly hard-hit by the current
problems in this space.  But I agree we cant tune it just for
that one benchmark.  I am hoping when completed this work will
help the entire system :)

I will add you to the CC list when I send these patches out.

> 
> 
>> It is not clear whether the problem is that newidle is over-balancing the
>> system, or that newidle is simply running too frequently as a symptom of a
>> system that has a high frequency of context switching (such as -rt).  I 
>> suspected the latter, so I was attracted to Peter's idea based on the
>> concept of shortening the time we execute this function.  But I have to
>> admit, unlike 1/3 and 2/3 which I have carefully benchmarked individually
>> and know make a positive performance impact, I pulled this in more on
>> theory.  I will try to benchmark this individually as well.
>>
>> > By the time you have
>> > done all this calculation and reached here, it will be a loss to only
>> > move one task if you could have moved two and halved your newidle
>> > balance rate...
>>
>> Thats an interesting point that I did not consider, but note that a very
>> significant chunk of the overhead I believe comes from the
>> double_lock/move_tasks code after the algorithmic complexity is completed.
> 
> And that double lock will be amortized if you can move 2 tasks at once,
> rather than 1 task each 2 times.

Thats a good point.

> 
> 
>> I believe the primary motivation of this patch is related to reducing the
>> overall latency in the schedule() critical section.  Currently this
>> operation can perform an unbounded move_task operation in a
>> preempt-disabled region (which, as an aside, is always SCHED_OTHER
>> related).
> 
> Maybe putting some upper cap on it, I could live with. Cutting off at
> one task I think needs a lot more thought and testing.

Perhaps we could reuse the sched_nr_migrations as the threshold?

-Greg


