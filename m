Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZCISbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZCISbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZCISbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:31:39 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36868 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZCISbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:31:38 -0400
Message-ID: <49B5607F.8050100@us.ibm.com>
Date: Mon, 09 Mar 2009 11:31:27 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 5/7] rt_mutex: add proxy lock routines
References: <49AC73A9.4040804@us.ibm.com> <49AC76EF.4030402@us.ibm.com> <alpine.LFD.2.00.0903071631060.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903071631060.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 2 Mar 2009, Darren Hart wrote:
>> /**
>> + * rt_mutex_start_proxy_lock - prepare another task to take the lock
> 
> Hmm. _start_ sounds weird. 

I thought on this for a while... but these names still seem the most 
appropriate to me, here's why:

rt_mutex - because it is
start - because this is the first half of a two part action
proxy - because it is initiated by one thread on behalf of another
lock - because we are trying to take the lock

This seems the most consistent with the naming scheme used throughout 
rtmutex.c as well.  If you have a pair of names for these two functions 
that you think would make more sense, please let me know.

> Also we do not prepare another task to take
> the lock. We either take the lock on behalf on another task or block
> that task on the lock.

Agreed:

" * rt_mutex_start_proxy_lock - Start lock acquisition for another task"

> 
>> + * @lock:		the rt_mutex to take
>> + * @waiter:		the rt_mutex_waiter initialized by the waiter
> 
>   initialized by the caller perhaps ?

Actually the rt_mutex_waiter is created on the stack of the waiter in 
futex_wait_requeue_pi() and added to the futex_q structure for the waker 
to access.  So it should be the waiter... if the comment is confusing I 
can either elaborate on multiple lines or just say something like:

"* @waiter:		the pre-initialized rt_mutex_waiter"

Since this call shouldn't care who initialized it, nor where, so long as 
it IS initialized.  I'll take this approach unless I hear otherwise.


> 
>> + * @task:		the task to prepare
>> + * @detext_deadlock:	passed to task_blocks_on_rt_mutex

"* @detect_deadlock:	perform deadlock detection (1) or not (0)"

> 
> That's not interesting where it is passed to. The argument tells us,
> whether deadlock detection needs to be done or not.
> 
>> + * The lock should have an owner, and it should not be task.
> 
> Why ? The lock can have no owner, if the previous owner released it
> before we took lock->wait_lock.

Hrm... I was considering moving the spin_lock(wait_lock) out of this 
routine, but we would still need to ensure the lock was still held. 
I'll look at making this safe without that condition.

> 
>> + * Special API call for FUTEX_REQUEUE_PI support.
>> + */
>> +int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
>> +			      struct rt_mutex_waiter *waiter,
>> +			      struct task_struct *task, int detect_deadlock)
>> +{
>> +	int ret;
>> +
>> +	spin_lock(&lock->wait_lock);
> 
> You need to try to take the lock on behalf of task here under
> lock->wait_lock to avoid an enqueue on an ownerless rtmutex.
> 

Will do.

>> +
>> +/**
>> + * rt_mutex_finish_proxy_lock - Complete the taking of the lock initialized
>> on
>> + *                              our behalf by another thread.
> 
> IIRC this needs to be a single line. Or does kerneldoc support this now ?

You are correct.  V6 will correct all the kernel-doc screw-ups.

> 
>> + * @lock: the rt_mutex we were woken on
>> + * @to: the timeout, null if none. hrtimer should already have been started.
>> + * @waiter: the pre-initialized rt_mutex_waiter
>> + * @detect_deadlock: for use by __rt_mutex_slowlock
> 
> See above.

Check.

Thanks for the review,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
