Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZK0MKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZK0MKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZK0MKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:10:06 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:59099 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZK0MKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:10:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eQmJBlDhOmuAIacKG88sw7dcC57E3NIt5AUssjZ3jEjNWoPikhPob8pYoKf0pvbzyz
         CH+xB4gQ+TfyUMmCt1oUPgL0niaSS6F6g6JPFpEiK9FOpgUr0RWeWEz5H5E8hHSszKDE
         2G4JPhq4GxRtc/4hXcRCXue0YY312Qrxf0VP0=
MIME-Version: 1.0
In-Reply-To: <353ce7c5-23be-4fcc-9bed-96792c3d5cd6@w19g2000pre.googlegroups.com>
References: <fa.KsFh5TyrbQsJFfr+ZG/B2XUIl64@ifi.uio.no>
	 <fa.VvrbWjrI+B/wni3lCHPP3szBuO8@ifi.uio.no>
	 <fa.Nf5tUBtLntQXqlJGJxXNN4M8u4o@ifi.uio.no>
	 <fa.Hqdoss5lzrLWp+lFEJqZ/ujkI+s@ifi.uio.no>
	 <353ce7c5-23be-4fcc-9bed-96792c3d5cd6@w19g2000pre.googlegroups.com>
Date: Fri, 27 Nov 2009 13:10:09 +0100
Message-ID: <c76f371a0911270410t2290c071l6ef702819803be3a@mail.gmail.com>
Subject: Re: observe and act upon workload parallelism: PERF_TYPE_PARALLELISM 
	(Was: [RFC][PATCH] sched_wait_block: wait for blocked threads)
From: Stijn Devriendt <highguy@gmail.com>
To: Buck <charles.krasic@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Buck,

Thanks for taking the time to inform me about your research.
I've just read up on it, but as far as I can tell there's still
quite some difference between our goals. My goal was to utilize the
CPU to it's fullest, regardless of blocking calls, in the context of a
threadpool. Your approach seems to try and do away with scheduling
latency and is better suited when timing information is available.

A generic threadpool doesn't have timing information about the work-items
it is processing, so it cannot take part in this type of cooperative scheduling.

Secondly you're using coop_poll() to wait for timeout and/or fds. In my case
I'm trying to let every blocking syscall cause the wake-up of the next
thread. This means that the threadpool should make no assumptions
about work-items and threadpool users can write any code they want.

Regards,
Stijn

On Thu, Nov 26, 2009 at 10:08 PM, Buck <charles.krasic@gmail.com> wrote:
> Hi,
>
> I think our research on scheduling is somewhat related to this topic.
>
> I posted to the kernel list a while back, but I'm not sure anyone
> noticed.   Here is a link to
> that post, which contains links to slides and our paper.
>
> http://lwn.net/Articles/358295/
>
> -- Buck
>
> On Nov 21, 3:27 am, Stijn Devriendt <high...@gmail.com> wrote:
>> > Think of it like a classic user-level threading package, where one process
>> > implements multiple threads entirely in user space, and switches between
>> > them. Except we'd do the exact reverse: create multiple threads in the
>> > kernel, but only run _one_ of them at a time. So as far as the scheduler
>> > is concerned, it acts as just a single thread - except it's a single
>> > thread that has multiple instances associated with it.
>>
>> > And every time the "currently active" thread in that group runs out of CPU
>> > time - or any time it sleeps - we'd just go on to the next thread in the
>> > group.
>>
>> Without trying to sound selfish: after some thinking I can't see how this
>> solves my problem. This is fine for the case you mentioned later on,
>> like UI threads, but it's not powerful enough for what I'm trying to achieve.
>>
>> Let's make the round-trip for the thread pool case and start with an empty
>> thread pool queue:
>> - All threads are blocked on the queue condition variable untill new work
>> is queued.
>> - Thread 1 happily wakes up and runs the work item untill it's blocked.
>> - A new work item arrives and Thread 2 is woken to handle the new work
>>   item.
>> - As long as new work arrives and Thread 2 is not blocked (regardless
>>   of preemption because the deal was that they will not preempt each
>>   other) Thread 2 keeps running this work.
>>   Even when Thread 1 is woken, it will not preempt Thread 1.
>>
>> One solution would be to let Thread 2 call sched_yield, but the
>> question then is "when" and "how much". Every time a lightweight
>> thread yields, you'll incur context switches. Because you don't
>> know when or how much, you'll be penalized for context switching
>> even when not needed. (Consider 1 blocked thread and 4 extra threads
>> sched_yield'ing every 5 work items)
>>
>> Another option is to have a group-leader. Non-leader threads will call
>> sched_yield once in a while in order to try and jump back to the group-leader.
>> The group-leader will always continue work without sched_yield'ing.
>> There's no preemption between these threads.
>> The down-side is that in case multiple of these threads are waiting for
>> an event, wake-ups must wake the group leader rather than the other
>> coop-scheduled threads for this model to work.
>> Another down-side is that when a non-leader thread is blocked and the
>> group-leader is run, the non-leader thread is treated unfair.
>>
>> Either solution's end-result is a very unfair threadpool where one cannot
>> guarantee even a loose FIFO-model where items are handled more or
>> less in the order they are queued and a library that needs to make
>> trade-offs in performance to get this behaviour back.
>>
>> The solution is great when the threads are blocked most of the time
>> and have little CPU processing to do (like UI threads), but doesn't
>> scale beyond that.
>>
>> As ever, enlighten me when you have a great solution to this problem.
>>
>> Stijn
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majord...@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
