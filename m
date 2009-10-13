Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZJMEzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZJMEzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZJMEzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:55:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44475 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZJMEzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:55:18 -0400
Message-ID: <4AD4080C.20703@us.ibm.com>
Date: Mon, 12 Oct 2009 21:54:36 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Blaise Gassend <blaise@willowgarage.com>
CC: Jeremy Leibs <leibs@willowgarage.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: Re: ERESTARTSYS escaping from sem_wait with RTLinux patch
References: <1255165747.6385.117.camel@doodleydee> <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain> <92be2ef30910102248t70d5e683tc525580fbf902af1@mail.gmail.com> <4AD33A4D.4070006@us.ibm.com> <1255384010.10236.123.camel@lts.willowgarage.com> <4AD3BD57.6080703@us.ibm.com> <4AD3D6AE.2050609@us.ibm.com> <4AD3FFB0.5030405@us.ibm.com>
In-Reply-To: <4AD3FFB0.5030405@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Resending, hopefully with fixed whitespace mangling in the trace this
> time...
> 
> Darren Hart wrote:
>> Darren Hart wrote:
>>> Blaise Gassend wrote:
>>>> A few more questions you may have answers to:
>>>>
>>>> Do you have any idea what this comment in futex.c could be referring 
>>>> to?
>>>>
>>>> /*  * We expect signal_pending(current), but another thread may  * 
>>>> have handled it for us already.  */
>>>> As far as I have been able to understand, signals are thread-specific,
>>>> and hence it doesn't make sense to me that another thread could have
>>>> handled it.
>>>
>>> Signals are only thread specific when using something like
>>> pthread_kill() to send the signal, otherwise they are process wide.
>>>
>>>>
>>>>> OK, so I suspect one of two things.
>>>>>
>>>>> 1) Recent changes to futex.c have somehow created a wakeup race and
>>>>>     unqueue_me() doesn't detect it was woken with FUTEX_WAKE, then 
>>>>> falls
>>>>>     out through the ERESTARTSYS path.
>>>>>
>>>>> 2) Recent changes have exposed an existing race in unqueue_me().
>>>>
>>>> Is it possible that there aren't many people using PREEMPT RT on 8 CPU
>>>> machines, and hence this is a bug that just has't been observed yet?
>>>
>>> We actually do extensive testing on 8way systems with some large apps
>>> that beat on futexes pretty badly.  You've simply uncovered a nasty
>>> little race in the wakeup path.
>>>
>>> I believe I have identified the patch where this became possible (I
>>> don't say the cause of the bug, because it's possible this patch simply
>>> exposed an existing race):
>>>
>>> 928686b77ab275fd7f828ff24bd510baca995425 futex: Wake up waiter outside
>>> the hb->lock section
>>>
>>> I am currently instrumenting the futex code and trying to identify how
>>> the race occurs.
> 
> ...
> 
>>> Full output here:
> 
> ...
> 
>> http://dvhart.com/darren/files/futex_wake_function.trace.gz
>>
>> It's a tad difficult to navigate, but I believe I am seeing 
>> wake_futex_list() try and wake python-3490 without previously adding 
>> it to the wake-list.  If we are somehow not cleaning up our wake_list, 
>> this would explain why unqueue_me() sees the q->lock_ptr as non-null - 
>> wake_futex() wasn't called to clear it.
> 
> OK, I believe I can confirm this with this subset of the trace. It follows
> three futex_wait and wake-up cycles. The third wake-up occurs without the
> python-3490 thread ever having been added to the wake_list (at least, there
> is not record of it in the trace). Now to see why this might be the case...
> 
>         python-3490  [002]   259.041420: futex_wait <-do_futex
>         python-3490  [002]   259.041420: futex_wait_setup <-futex_wait
>         python-3490  [002]   259.043888: futex_wait_queue_me <-futex_wait
>         python-3490  [002]   259.043888: queue_me <-futex_wait_queue_me
>         python-3490  [002]   259.043920: schedule <-futex_wait_queue_me
>      python-3507  [004]   259.043929: wake_futex: adding python-3490 to 
> wake_list
>      python-3507  [004]   259.043957: wake_futex_list: wake_futex_list: 
> waking python-3490
>      python-3490  [002]   259.043981: futex_wait: normal futex wake-up 
> detected for python-3490
> 
>         python-3490  [002]   259.043987: futex_wait <-do_futex
>      python-3490  [002]   259.043987: futex_wait_setup <-futex_wait
>      python-3490  [002]   259.044323: futex_wait_queue_me <-futex_wait
>      python-3490  [002]   259.044323: queue_me <-futex_wait_queue_me
>      python-3495  [002]   259.044571: wake_futex: adding python-3490 to 
> wake_list

Interesting, here we never see a wake_futex_list: waking python-3490.
So the task wakes here and thinks it is a normal wakeup, when perhaps it is
not. If a timeout or a signal were to occur here, we would not detect them
as unqueue_me() would see the lock_ptr had been nulled by wake_futex(). The
task returns to userspace ignoring the timeout or signal.

>      python-3490  [002]   259.044843: futex_wait: normal futex wake-up 
> detected for python-3490
> 
>      python-3490  [002]   259.044848: futex_wait <-do_futex

The app then puts it back to sleep here.


>      python-3490  [002]   259.044848: futex_wait_setup <-futex_wait
>      python-3490  [002]   259.046648: futex_wait_queue_me <-futex_wait
>      python-3490  [002]   259.046648: queue_me <-futex_wait_queue_me
>      python-3490  [002]   259.046664: schedule <-futex_wait_queue_me
>           ********* python-3490 was never added to the wake_list !!!!!!! 
> *********
> 
>      python-3495  [002]   259.046680: wake_futex_list: wake_futex_list: 
> waking python-3490

When 3495 finally get's to run and complete it's futex_wake() call, the task
still needs to be woken, so we wake it - but now it's enqueued with a different
futex_q, which now has a valid lock_ptr, so upon wake-up we expect a signal!

OK, I believe this establishes root cause.  Now to come up with a fix...

>      python-3490  [002]   259.046816: futex_wait: returning 1, non-futex 
> wakeup for python-3490
>      python-3490  [002]   259.046817: futex_wait: p->futex_wakeup: (null)
>      python-3490  [002]   259.046819: futex_wait: error in wake-up 
> detection, no signal pending for python-3490

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
