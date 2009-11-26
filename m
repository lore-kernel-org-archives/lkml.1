Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZKZV7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZKZV7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZKZV7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:59:14 -0500
Received: from smtp.cs.ubc.ca ([142.103.6.52]:50975 "EHLO smtp.cs.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZKZV7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:59:13 -0500
Message-ID: <4B0EFA34.3080802@cs.ubc.ca>
Date: Thu, 26 Nov 2009 13:59:16 -0800
From: "Charles 'Buck' Krasic" <krasic@cs.ubc.ca>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: observe and act upon workload parallelism:  PERF_TYPE_PARALLELISM
 (Was: [RFC][PATCH] sched_wait_block: wait for blocked  threads)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently posted to the kernel list about our research in linux 
scheduling, but I suspect few noticed the post:

http://lwn.net/Articles/358295/

Our work is very much focused on supporting efficient user-level 
scheduling (meaning event driven apps), and
augmenting a "poll" interface to that end, ours is call coop_poll().   
We are very much interested in the scaling in the cases where threads 
are busy most of the time, so I hope people on this thread might take a 
look.

The paper about it and slides from the talk I gave at Eurosys 2009 are 
at the above link.

-- Buck

On Nov 21, 3:30 am, Stijn Devriendt <high...@gmail.com> wrote:
 > > Think of it like a classic user-level threading package, where one 
process
 > > implements multiple threads entirely in user space, and switches 
between
 > > them. Except we'd do the exact reverse: create multiple threads in the
 > > kernel, but only run _one_ of them at a time. So as far as the 
scheduler
 > > is concerned, it acts as just a single thread - except it's a single
 > > thread that has multiple instances associated with it.
 >
 > > And every time the "currently active" thread in that group runs out 
of CPU
 > > time - or any time it sleeps - we'd just go on to the next thread 
in the
 > > group.
 >
 > Without trying to sound selfish: after some thinking I can't see how this
 > solves my problem. This is fine for the case you mentioned later on,
 > like UI threads, but it's not powerful enough for what I'm trying to 
achieve.
 >
 > Let's make the round-trip for the thread pool case and start with an 
empty
 > thread pool queue:
 > - All threads are blocked on the queue condition variable untill new work
 > is queued.
 > - Thread 1 happily wakes up and runs the work item untill it's blocked.
 > - A new work item arrives and Thread 2 is woken to handle the new work
 >   item.
 > - As long as new work arrives and Thread 2 is not blocked (regardless
 >   of preemption because the deal was that they will not preempt each
 >   other) Thread 2 keeps running this work.
 >   Even when Thread 1 is woken, it will not preempt Thread 1.
 >
 > One solution would be to let Thread 2 call sched_yield, but the
 > question then is "when" and "how much". Every time a lightweight
 > thread yields, you'll incur context switches. Because you don't
 > know when or how much, you'll be penalized for context switching
 > even when not needed. (Consider 1 blocked thread and 4 extra threads
 > sched_yield'ing every 5 work items)
 >
 > Another option is to have a group-leader. Non-leader threads will call
 > sched_yield once in a while in order to try and jump back to the 
group-leader.
 > The group-leader will always continue work without sched_yield'ing.
 > There's no preemption between these threads.
 > The down-side is that in case multiple of these threads are waiting for
 > an event, wake-ups must wake the group leader rather than the other
 > coop-scheduled threads for this model to work.
 > Another down-side is that when a non-leader thread is blocked and the
 > group-leader is run, the non-leader thread is treated unfair.
 >
 > Either solution's end-result is a very unfair threadpool where one cannot
 > guarantee even a loose FIFO-model where items are handled more or
 > less in the order they are queued and a library that needs to make
 > trade-offs in performance to get this behaviour back.
 >
 > The solution is great when the threads are blocked most of the time
 > and have little CPU processing to do (like UI threads), but doesn't
 > scale beyond that.
 >
 > As ever, enlighten me when you have a great solution to this problem.
 >
 > Stijn
 > --
 > To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in
 > the body of a message to majord...@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/

