Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZIJUZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZIJUZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZIJUZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:25:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:1209 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZIJUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ORgzlsdwj0LOCuc1y/NOlVKrkKoRqursret/dVVKQlji3zYKfW69R2vuvWno4DLzlB
         +bGI/14pW8AzeP3/L79GVtH40AGJJD6xoGs9N87p2VgMsWlWBlMbpwpa3FJTwniIaLxX
         jRYMfiRC++1IisoXUbz0uogCncIFWcpaJy8Og=
Date: Thu, 10 Sep 2009 22:25:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910202543.GG6421@nowhere>
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org> <20090907110146.GB6393@nowhere> <4AA69F3A.4090600@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA69F3A.4090600@arcor.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 09:15:22PM +0300, Nikos Chantziaras wrote:
> On 09/07/2009 02:01 PM, Frederic Weisbecker wrote:
>> That looks eventually benchmarkable. This is about latency.
>> For example, you could try to run high load tasks in the
>> background and then launch a task that wakes up in middle/large
>> periods to do something. You could measure the time it takes to wake
>> it up to perform what it wants.
>>
>> We have some events tracing infrastructure in the kernel that can
>> snapshot the wake up and sched switch events.
>>
>> Having CONFIG_EVENT_TRACING=y should be sufficient for that.
>>
>> You just need to mount a debugfs point, say in /debug.
>>
>> Then you can activate these sched events by doing:
>>
>> echo 0>  /debug/tracing/tracing_on
>> echo 1>  /debug/tracing/events/sched/sched_switch/enable
>> echo 1>  /debug/tracing/events/sched/sched_wake_up/enable
>>
>> #Launch your tasks
>>
>> echo 1>  /debug/tracing/tracing_on
>>
>> #Wait for some time
>>
>> echo 0>  /debug/tracing/tracing_off
>>
>> That will require some parsing of the result in /debug/tracing/trace
>> to get the delays between wake_up events and switch in events
>> for the task that periodically wakes up and then produce some
>> statistics such as the average or the maximum latency.
>>
>> That's a bit of a rough approach to measure such latencies but that
>> should work.
>
> I've tried this with 2.6.31-rc9 while running mplayer and alt+tabbing  
> repeatedly to the point where mplayer starts to stall and drop frames.  
> This produced a 4.1MB trace file (132k bzip2'ed):
>
>     http://foss.math.aegean.gr/~realnc/kernel/trace1.bz2
>
> Uncompressed for online viewing:
>
>     http://foss.math.aegean.gr/~realnc/kernel/trace1
>
> I must admit that I don't know what it is I'm looking at :P


Hehe :-)

Basically you have samples of two kind of events:

- wake up (when thread A wakes up B)

The format is as follows:


	task-pid
	(the waker A)
	   |
	   |     cpu     timestamp   event-name        wakee(B)    prio    status
	   |      |          |           |               |          |        |
	X-11482 [001]  1023.219246: sched_wakeup: task kwin:11571 [120] success=1

Here X is awakening kwin.


- sched switch (when the scheduler stops A and launches B)

	                                            A, task                  B, task
	                                            that gets                that gets
	                                            sched                    sched
                                                     out                      in
	  A      cpu    timestamp     event-name       |       A prio          |        B prio
	  |       |         |             |            |         |             |          |
	X-11482 [001]  1023.219247: sched_switch: task X:11482 [120] (R) ==> kwin:11571 [120]
	                                                              |
	                                                              |
                                                                    State of A
For A state we can have either:

R: TASK_RUNNING, the task is not sleeping but it is rescheduled for later
   to let another task run

S: TASK_INTERRUPTIBLE, the task is sleeping, waiting for an event that may
   wake it up. The task can be waked by a signal

D: TASK_UNINTERRUPTIBLE, same as above but can't be waked by a signal.


Now what could be interesting interesting is to measure the time between
such pair of events:

	- t0: A wakes up B
	- t1: B is sched in

t1 - t0 would then be the scheduler latency, or at least part of it:

The scheduler latency may be an addition of several factors:

	- the time it takes for the actual wake up to perform (re-insert
	  the task into a runqueue, which can be subject to the runqueue(s)
	  design, the rebalancing if needed, etc..

	- the time between a task is waked up and the scheduler eventually
	  decide to schedule it in.

	- the time it takes to perform the task switch, which is not only
	  in the scheduler scope. But the time it takes may depend of a
	  rebalancing decision (cache cold, etc..)

Unfortunately we can only measure the second part with the above ftrace
events. But that's still an interesting scheduler abstract that is a
large part of the scheduler latency.

We could write a tiny parser that could walk through such ftrace traces
and produce some average, maximum, standard deviation numbers.

But we have userspace tools that can parse ftrace events (through perf
counter), so I'm trying to write something there, hopefully I could get
a relevant end result.

Thanks.
                                                                    

