Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZCFF1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZCFF1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZCFF1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:27:32 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36426 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZCFF1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:27:31 -0500
Message-ID: <49B0B43D.2030907@us.ibm.com>
Date: Thu, 05 Mar 2009 21:27:25 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
References: <49AC73A9.4040804@us.ibm.com> <49AC77D1.6090106@us.ibm.com> <49AE3386.1070604@us.ibm.com> <49B00302.5000607@us.ibm.com> <49B07F87.2020808@us.ibm.com> <alpine.DEB.2.00.0903052119300.14535@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903052119300.14535@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 5 Mar 2009, Darren Hart wrote:
>> As it turns out I missed setting RT_MUTEX_HAS_WAITERS on the rt_mutex in
>> rt_mutex_start_proxy_lock() - seems awfully silly in retrospect - but a
>> little non-obvious while writing it.  I added mark_rt_mutex_waiters()
>> after the call to task_blocks_on_rt_mutex() and the test has completed
>> more than 400 iterations successfully (it would fail after no more than
>> 2 most of the time before).
>>
>> Steven, there are several ways to set RT_MUTEX_HAS_WAITERS - but this
>> seemed like a reasonable approach, would you agree?  Since I'm holding
>> the wait_lock I don't technically need the atomic cmpxchg and could
>> probably just set it explicity - do you have a preference?
>>
> 
>> +
>> +/**
>> + * rt_mutex_finish_proxy_lock - Complete the taking of the lock initialized
>> on
>> + *                              our behalf by another thread.
>> + * @lock: the rt_mutex we were woken on
>> + * @to: the timeout, null if none. hrtimer should already have been started.
>> + * @waiter: the pre-initialized rt_mutex_waiter
>> + * @detect_deadlock: for use by __rt_mutex_slowlock
>> + *
>> + * Special API call for PI-futex requeue support
>> + */
>> +int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
>> +			       struct hrtimer_sleeper *to,
>> +			       struct rt_mutex_waiter *waiter,
>> +			       int detect_deadlock)
>> +{
>> +	int ret;
>> +
>> +	if (waiter->task)
>> +		schedule_rt_mutex(lock);
>> +
>> +	spin_lock(&lock->wait_lock);
>> +
>> +	set_current_state(TASK_INTERRUPTIBLE);
>> +
>> +	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
>> +				  detect_deadlock);
>> +
>> +	set_current_state(TASK_RUNNING);
>> +
>> +	if (unlikely(waiter->task))
>> +		remove_waiter(lock, waiter);
>> +
>> +	/*
>> +	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We
>> might
>> +	 * have to fix that up.
>> +	 */
>> +	fixup_rt_mutex_waiters(lock);
> 
> Darren,
> 
> I take it you are talking about the above.

Actually no, I was talking about rt_mutex_START_proxy_lock():

/**
 * rt_mutex_start_proxy_lock - prepare another task to take the lock
 *
 * @lock:		the rt_mutex to take
 * @waiter:		the rt_mutex_waiter initialized by the waiter
 * @task:		the task to prepare
 * @detext_deadlock:	passed to task_blocks_on_rt_mutex
 *
 * The lock should have an owner, and it should not be task.
 * Special API call for FUTEX_REQUEUE_PI support.
 */
int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
			      struct rt_mutex_waiter *waiter,
			      struct task_struct *task, int detect_deadlock)
{
	int ret;

	spin_lock(&lock->wait_lock);
	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);


I add the following line to fix the bug.  Question is, should I use this atomic
optimization here (under the lock->wait_lock) or should I just do 
"lock->owner |= RT_MUTEX_HAS_WAITERS" ?

=====>	mark_rt_mutex_waiters(lock);

	if (ret && !waiter->task) {
		/*
		 * Reset the return value. We might have
		 * returned with -EDEADLK and the owner
		 * released the lock while we were walking the
		 * pi chain.  Let the waiter sort it out.
		 */
		ret = 0;
	}
	spin_unlock(&lock->wait_lock);

	debug_rt_mutex_print_deadlock(waiter);

	return ret;
}



-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
