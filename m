Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZIUGjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZIUGjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 02:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZIUGjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 02:39:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48639 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZIUGjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 02:39:18 -0400
Message-ID: <4AB71F95.1030008@us.ibm.com>
Date: Sun, 20 Sep 2009 23:39:17 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: futex: wakeup race and futex_q woken state definition
References: <4AB17A08.50008@us.ibm.com> <alpine.LFD.2.00.0909170939080.2889@localhost.localdomain> <4AB25076.8020406@us.ibm.com> <alpine.LFD.2.00.0909171719260.2889@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0909171719260.2889@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 17 Sep 2009, Darren Hart wrote:
>>> 	/*
>>> 	 * !plist_node_empty() is safe here without any lock.
>>> 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
>>> 	 */
>>> 	if (likely(!plist_node_empty(&q->list))) {
>>>
>>> If we move set_current_state() before the queue_me() this check is
>>> still an optimization to avoid the schedule call in case we have been
>>> woken up already. But the comment is still wrong as the wakeup code
>>> has changed:
>>>
>>> The old version did:
>>>
>>>      plist_del(&q->list);
>>>      wake_up_all(&q->waiters);
>>>      q->lock_ptr = NULL;
>>>
>>> Today we do:
>>>
>>>      p = q->task;
>>>      get_task_struct(p);
>>>      plist_del(&q->list);
>>>      q->lock_ptr = NULL;
>>>      wake_up_state(p);
>>>      put_task_struct(p);
>>>
>>> We changed this because it makes no sense to use a waitqueue for a
>>> single task.
>> Right.
>>
>>
>> However, my bigger concern still remains.  If the above is only an
>> optimization, we appear to have a race with wakeup where we can see a
>> non-empty list here and decide to schedule and have the wakeup code remove us
>> from the list, hiding it from all future futex related wakeups (signal and
>> timeout would still work).
> 
> No.
> 
> Sleeper does:
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	
> 	if (!plist_empty())
> 	   schedule();
> 
> So when the list removal happened before set_current_state() we don't
> schedule. If the wakeup happens _after_ set_current_state() then the
> wake_up_state() call will bring us back to running.
> 
>> We have also been seeing a race with the requeue_pi code with a JVM benchmark
>> where the apparent owner of the pi mutex remains blocked on the condvar - this
>> can be explained by the race I'm suspecting.  Also, futex_requeue_pi() is
>> using futex_wait_queue_me() which expects the waker to remove the futex_q from
>> the list, which isn't how things work for PI mutexes.  In an experiment, I
>> moved the spin_unlock() out of queueme() and right before the call to
>> schedule() to narrow the race window, and the hang we were experiencing
>> appears to have gone away.
> 
> The correct thing to do is to move set_current_state() before queue_me().
> 

Ah yes, you are correct of course.  Since PI futexes do not use 
plist_node_empty() to test for wakeup, the setting of TASK_ITNERRUPTIBLE 
after the queue_me() sets the stage to call schedule() with the wrong 
task state and lose the task forever.  I have included this in my 
current patch queue.  We are running our tests to confirm the fix and 
I'll submit the series for inclusion by tomorrow.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
