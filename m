Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZA1LYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZA1LYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZA1LY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:24:27 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:36039 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZA1LYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:24:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TlnogxU/1AoS3t7juijchq8H6lQnT4e+RT123sXLhY9xIfpaHBdDlaJS7q22fXTaEJ
         Hov0eO301cmZnmQ5IlYJpu29qSq61ijaPzW/w3oE7zdwLbyMQVG74XdfFMKSVFtgjmxY
         +6+Ij7JwyI7kSqQl9Ciyz6EDjnIn0PdVwJhcw=
MIME-Version: 1.0
In-Reply-To: <20090128030224.GA4867@redhat.com>
References: <20090128002714.GA5086@nowhere> <20090128030224.GA4867@redhat.com>
Date: Wed, 28 Jan 2009 12:24:23 +0100
Message-ID: <c62985530901280324p15f2fbedkf96a4c5b5dd2ea52@mail.gmail.com>
Subject: Re: [RFC v2][PATCH] create workqueue threads only when needed
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Oleg Nesterov <oleg@redhat.com>:
> On 01/28, Frederic Weisbecker wrote:
>>
>> +static void workqueue_unshadow(struct cpu_workqueue_struct *cwq)
>> +{
>> +     struct workqueue_shadow *ws;
>> +
>> +     /* Prevent from concurrent unshadowing */
>> +     if (unlikely(atomic_inc_return(&cwq->unshadowed) != 1))
>> +             goto already_unshadowed;
>> +
>> +     /*
>> +      * The work can be inserted whatever is the context.
>> +      * But such atomic allocation will be rare and freed soon.
>> +      */
>> +     ws = kmalloc(sizeof(*ws), GFP_ATOMIC);
>> +     if (!ws) {
>> +             WARN_ON_ONCE(1);
>> +             goto already_unshadowed;
>> +     }
>> +     INIT_DELAYED_WORK(&ws->work, workqueue_unshadow_work);
>> +     ws->cwq = cwq;
>> +     schedule_delayed_work(&ws->work, 0);
>> +
>> +     return;
>> +
>> +already_unshadowed:
>> +     atomic_dec(&cwq->unshadowed);
>> +}
>
> Can't understand why do you use delayed work...


Because if it fails to create the thread, we want to requeue the work
within a delay.


> I must admit, I don't like this patch. Perhaps I am wrong, mostly I
> dislike the complications it adds.
>
> Anybody else please vote for this change?
>
> Hmm. We never reset cwq->unshadowed, so cwq->thread becomes "non-lazy"
> after cpu_down() + cpu_up().


No need to reset it. If it is unshadowed, then the thread was created
and we want to recreate
it on cpu_up(). And if it is shadowed, then we don't need to create it yet.


> And. Of course it is not good that queue_work() can silently fail just
> because GFP_ATOMIC fails. This is not acceptable, imho. But fixable.


In my opinion too. I just didn't find a proper way to handler it yet.


> What is not fixable is that this patch adds a subtle lock-ordering
> problem. With this patch any flush_work() or flush_workqueue() or
> destroy_workqueue() depend on keventd, and can deadlock if the caller
> shares the lock with any work_struct on keventd.
>
> Or. let's suppose keventd has a sleeping work_struct which waits
> for the event. Now we queue the work which should "implement"
> this event on !unshadowed wq - deadlock.


I didn't thought about such deadlocks.... :-/


> Another problem. workqueue_unshadow_work() populates cwq->thread and
> binds it to smp_processor_id(). This is not safe, CPU can go away
> after smp_processor_id() but before wake_up_process().


So it should use get_cpu/put_cpu, right?


> Oh, and schedule_delayed_work() is not right, think about queue_work_on().
>
>>  static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
>>  {
>> +     DEFINE_WAIT(wait);
>> +     long timeout = 0;
>> +     int unshadowed = atomic_read(&cwq->unshadowed);
>> +
>> +     /* Shadowed => no thread has been created */
>> +     if (!unshadowed)
>> +             return;
>
> This is not right, if the previous workqueue_unshadow() failed, we
> can return with the pending works.


Yeah, looks like this bit is not a good synchronization solution. Only
a spinlock
can solve this, to synchronize the access to cwq->unshadowed and block it
while we are trying to allocate the work.


>> +
>>       /*
>> -      * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
>> -      * cpu_add_remove_lock protects cwq->thread.
>> +      * If it's unshadowed, we want to ensure the thread creation
>> +      * has been completed.
>>        */
>> -     if (cwq->thread == NULL)
>> -             return;
>> +     prepare_to_wait(&cwq->thread_creation, &wait, TASK_UNINTERRUPTIBLE);
>> +     if (!cwq->thread)
>> +             timeout = schedule_timeout_interruptible(HZ * 3);
>> +     finish_wait(&cwq->thread_creation, &wait);
>> +
>> +     /* We waited for 3 seconds, this is likely a soft lockup */
>> +     WARN_ON(timeout);
>
> Can't understand... If timeout != 0, then we were woken by
> workqueue_unshadow_work() ?


Oops, I was confused with the return value of schedule_timeout()


> Anyway. We should not proceed if we failed to create cwq->thread.
> The kernel can crash. And of course this is not good too. Yes,
> you modified flush_cpu_workqueue() to call workqueue_unshadow(),
> but this can fail too. And if another thread cancels the pending
> works, flush_cpu_workqueue() just returns, and we crash. Or we
> can hang forever.


Right.


> Also. Please note that cleanup_workqueue_thread() can also be
> called by CPU_UP_CANCELED when cwq->thread == NULL because it
> was never created. We should do nothing in this case, but we
> will hang if cwq->unshadowed != 0.


Not sure I understand your point here...unless...if it hasn't been
created yet, the keventd
which was about to do it can have been cleanup... Is that what you are
talking about?
Anyway, yes, this is a race condition.


>>               switch (action) {
>>               case CPU_UP_PREPARE:
>> +                     /* Will be created during the first work insertion */
>> +                     if (!atomic_read(&cwq->unshadowed))
>> +                             break;
>>                       if (!create_workqueue_thread(cwq, cpu))
>>                               break;
>>                       printk(KERN_ERR "workqueue [%s] for %i failed\n",
>> @@ -964,6 +1086,8 @@ undo:
>>                       goto undo;
>>
>>               case CPU_ONLINE:
>> +                     if (!atomic_read(&cwq->unshadowed))
>> +                             break;
>>                       start_workqueue_thread(cwq, cpu);
>>                       break;
>
> Suppose that we have some strange cpu_callback(action, cpu)
> which does:
>
>                case CPU_UP_PREPARE:
>                        queue_work_on(cpu, my_wq, percpu_work);
>                        break;
>                case CPU_UP_CANCELED:
>                        cancel_work_sync(percpu_work);
>
> Currently this works. But with this patch, queue_work_on() above
> can leak workqueue_shadow.


But the work of task creation is pending on kevent, which works are
not cancelled here.

Anyway you are right, the approach is not good. Even if the races are
fixed, when the caller of a
workqueue holds a lock needed by a work queued before the task
creation on kevent, we have an unfixable
deadlock.

The only solution would be to have a dedicated thread on workqueue to
unshadow the other workqueues. But isn't
it solving the problem of random tasks by creating another one?
Yes and no: create one task to avoid creating several pointless other
one can be a solution.

Hm?

Thanks for your review Oleg!
