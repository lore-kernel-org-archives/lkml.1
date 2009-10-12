Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZJLVWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZJLVWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758281AbZJLVWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:22:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbZJLVWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:22:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=i290W65Y5U8dXc2ozb/Oh3Ia7cctY4jXapJdGBmOKYi19UxXkWjfieR04kYCvip2c
	Nkrk0MrHKV0EQrH+s1KRQ==
MIME-Version: 1.0
In-Reply-To: <1255156660.7866.4.camel@twins>
References: <alpine.DEB.2.00.0910091849070.22548@kitami.corp.google.com>
	 <1255156660.7866.4.camel@twins>
Date: Mon, 12 Oct 2009 14:20:53 -0700
Message-ID: <ed628a920910121420k5f01892dsc9cfe0b56eb2c29e@mail.gmail.com>
Subject: Re: sched: race between deactivate and switch sched_info accounting?
From: Paul Turner <pjt@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 9, 2009 at 11:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2009-10-09 at 19:40 -0700, Paul Turner wrote:
>
> This looks very funny, I would expect that whoever does activate() on
> that task to do the sched_info*() muck?

They do their part, the problem stems from there being 2 halves of
sched_info muck to deal with:

then enqeue/dequeue tracking (which is called out of the activate path)

then the arrive/depart (which is hinged off the task switch in schedule())

These steps share state in last_queued; we are accounting the
enqeue/dequeue properly but because prev==next we skip the second half
of the accounting and end up out of sync.

>
> The below patch looks very asymmetric in that regard.
>

the idea below is to fix things up by 'inserting' the task->idle->task
switch we'd have had if we didn't race in wake-up

this approach might look more natural if the first info_switch was
just pulled above the actual switch logic with this check; another
option might be to force a last_queued reset on depart (since it's
really only the run_delay skew that's significant)

>> It's possible for our previously de-activated task to be re-activated by a
>> remote cpu during lock balancing.  We have to account for this manually
>> since prev == next, yet the task just went through dequeue accounting.
>>
>>  Signed-off-by: Paul Turner <pjt@google.com>
>> ---
>>  kernel/sched.c |   15 ++++++++++++---
>>  1 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index ee61f45..6445d9d 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -5381,7 +5381,7 @@ asmlinkage void __sched schedule(void)
>>       struct task_struct *prev, *next;
>>       unsigned long *switch_count;
>>       struct rq *rq;
>> -     int cpu;
>> +     int cpu, deactivated_prev = 0;
>>
>>  need_resched:
>>       preempt_disable();
>> @@ -5406,8 +5406,10 @@ need_resched_nonpreemptible:
>>       if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>>               if (unlikely(signal_pending_state(prev->state, prev)))
>>                       prev->state = TASK_RUNNING;
>> -             else
>> +             else {
>>                       deactivate_task(rq, prev, 1);
>> +                     deactivated_prev = 1;
>> +             }
>>               switch_count = &prev->nvcsw;
>>       }
>>
>> @@ -5434,8 +5436,15 @@ need_resched_nonpreemptible:
>>                */
>>               cpu = smp_processor_id();
>>               rq = cpu_rq(cpu);
>> -     } else
>> +     } else {
>> +             /*
>> +              * account for our previous task being re-activated by a
>> +              * remote cpu.
>> +              */
>> +             if (unlikely(deactivated_prev))
>> +                     sched_info_switch(prev, prev);
>>               spin_unlock_irq(&rq->lock);
>> +     }
>>
>>       post_schedule(rq);
>>
>
