Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZCITzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZCITzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZCITzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:55:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43817 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZCITzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:55:33 -0400
Message-ID: <49B5741F.6070005@us.ibm.com>
Date: Mon, 09 Mar 2009 12:55:11 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
References: <49AC73A9.4040804@us.ibm.com> <49AC77D1.6090106@us.ibm.com> <49AE3386.1070604@us.ibm.com> <49B00302.5000607@us.ibm.com> <49B07F87.2020808@us.ibm.com> <alpine.DEB.2.00.0903052119300.14535@gandalf.stny.rr.com> <49B0B43D.2030907@us.ibm.com> <alpine.LFD.2.00.0903071645480.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903071645480.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 5 Mar 2009, Darren Hart wrote:
>> int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
>> 			      struct rt_mutex_waiter *waiter,
>> 			      struct task_struct *task, int detect_deadlock)
>> {
>> 	int ret;
>>
>> 	spin_lock(&lock->wait_lock);
>> 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
>>
>>
>> I add the following line to fix the bug.  Question is, should I use this
>> atomic
>> optimization here (under the lock->wait_lock) or should I just do "lock->owner
>> |= RT_MUTEX_HAS_WAITERS" ?
>>
>> =====>	mark_rt_mutex_waiters(lock);
> 
> This is still not enough as I explained in the review of the original
> patch. What you need to do is:
> 
> 	if (try_to_take_rt_mutex(lock, task)) {
> 	   	spin_unlock(&lock->wait_lock);
> 		/* The caller needs to wake up task, as it is now the owner */
> 		return WAKEIT;
> 	}
> 
> 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
> 

Right, so I'm testing this out:

	mark_rt_mutex_waiters(lock);

	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
		/* We got the lock for task. */
		debug_rt_mutex_lock(lock);

		rt_mutex_set_owner(lock, task, 0);

		rt_mutex_deadlock_account_lock(lock, task);
		return 1;
	}

Steven, is this the proper use of the debug* routines?  I copied them 
from try_to_take_rt_mutex(), but they are empty routines without 
comments so I wasn't sure exactly how they were intended to be used. 
Does the usage of debug_rt_mutex_lock() assume task=current (the other 
has the task_struct passed int).

Thanks,

Darren


>> 	if (ret && !waiter->task) {
>> 		/*
>> 		 * Reset the return value. We might have
>> 		 * returned with -EDEADLK and the owner
>> 		 * released the lock while we were walking the
>> 		 * pi chain.  Let the waiter sort it out.
>> 		 */
>> 		ret = 0;
>> 	}
>> 	spin_unlock(&lock->wait_lock);
>>
>> 	debug_rt_mutex_print_deadlock(waiter);
>>
>> 	return ret;
>> }
> 
> Thanks,
> 
> 	tglx


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
