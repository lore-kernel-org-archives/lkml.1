Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZKUL0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZKUL0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZKUL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:26:42 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48059 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZKUL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=apJpG+AwAf4m6cY4ln3yRoBjM4Qpv4hWy54RjBilm+iSj8rCmdQ/QUkN4eMwGP3E4i
         Ex0NukJvT2ov2AiS2DvwsyhV7LxqWkmFB0CJjBxfHB/MibiOot1lVCTJhPb99IH3gT0M
         7ABsJTvAMj9TKNZmmY3rRXrcKl8wa/SSKxNjg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
	 <20091116083521.GC20672@elte.hu>
	 <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
Date: Sat, 21 Nov 2009 12:26:47 +0100
Message-ID: <c76f371a0911210326p35d69ff7q1f275a7b393c2922@mail.gmail.com>
Subject: Re: [RFC] observe and act upon workload parallelism: 
	PERF_TYPE_PARALLELISM (Was: [RFC][PATCH] sched_wait_block: wait for blocked 
	threads)
From: Stijn Devriendt <highguy@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Think of it like a classic user-level threading package, where one process
> implements multiple threads entirely in user space, and switches between
> them. Except we'd do the exact reverse: create multiple threads in the
> kernel, but only run _one_ of them at a time. So as far as the scheduler
> is concerned, it acts as just a single thread - except it's a single
> thread that has multiple instances associated with it.
>
> And every time the "currently active" thread in that group runs out of CPU
> time - or any time it sleeps - we'd just go on to the next thread in the
> group.

Without trying to sound selfish: after some thinking I can't see how this
solves my problem. This is fine for the case you mentioned later on,
like UI threads, but it's not powerful enough for what I'm trying to achieve.

Let's make the round-trip for the thread pool case and start with an empty
thread pool queue:
- All threads are blocked on the queue condition variable untill new work
is queued.
- Thread 1 happily wakes up and runs the work item untill it's blocked.
- A new work item arrives and Thread 2 is woken to handle the new work
  item.
- As long as new work arrives and Thread 2 is not blocked (regardless
  of preemption because the deal was that they will not preempt each
  other) Thread 2 keeps running this work.
  Even when Thread 1 is woken, it will not preempt Thread 1.

One solution would be to let Thread 2 call sched_yield, but the
question then is "when" and "how much". Every time a lightweight
thread yields, you'll incur context switches. Because you don't
know when or how much, you'll be penalized for context switching
even when not needed. (Consider 1 blocked thread and 4 extra threads
sched_yield'ing every 5 work items)

Another option is to have a group-leader. Non-leader threads will call
sched_yield once in a while in order to try and jump back to the group-leader.
The group-leader will always continue work without sched_yield'ing.
There's no preemption between these threads.
The down-side is that in case multiple of these threads are waiting for
an event, wake-ups must wake the group leader rather than the other
coop-scheduled threads for this model to work.
Another down-side is that when a non-leader thread is blocked and the
group-leader is run, the non-leader thread is treated unfair.

Either solution's end-result is a very unfair threadpool where one cannot
guarantee even a loose FIFO-model where items are handled more or
less in the order they are queued and a library that needs to make
trade-offs in performance to get this behaviour back.

The solution is great when the threads are blocked most of the time
and have little CPU processing to do (like UI threads), but doesn't
scale beyond that.

As ever, enlighten me when you have a great solution to this problem.

Stijn
