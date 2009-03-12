Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZCLWR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZCLWR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZCLWRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:17:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41187 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZCLWRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:17:48 -0400
Message-ID: <49B98A07.2000004@us.ibm.com>
Date: Thu, 12 Mar 2009 15:17:43 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 5/6] futex: unlock before returning -EFAULT
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075606.9856.88729.stgit@Aeon> <1236852816.5090.117.camel@laptop>
In-Reply-To: <1236852816.5090.117.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-03-12 at 00:56 -0700, Darren Hart wrote:
>> futex_lock_pi can potentially return -EFAULT with the rt_mutex held.  This
>> seems like the wrong thing to do as userspace should assume -EFAULT means the
>> lock was not taken.  Even if it could figure this out, we'd be leaving the
>> pi_state->owner in an inconsistent state.  This patch unlocks the rt_mutex
>> prior to returning -EFAULT to userspace.
> 
> lockdep would complain, one is not to leave the kernel with locks held.
> 
>> Build and boot tested on a 4 way Intel x86_64 workstation.  Passes basic
>> pthread_mutex and PI tests out of ltp/testcases/realtime.
> 
> You keep mentioning these tests.. makes me wonder how much of the futex
> code paths they actually test. Got any coverage info on them?

Right now these are tests I know the most about and I know they 
excercise the futex_wait, futex_wake, futex_(un)lock_pi, and 
futex_requeue paths via the pthread_mutex* and pthread_cond* APIs.  I 
doubt they test the fault logic very well, and I know they don't test 
shared futexes.

I'd really like to ramp up my efforts on the raw sys_futex tests I've 
been working on, but just haven't had the cycles.  I suspect they will 
become necessary for requeue_pi however.  I also think we should look at 
some kind of futex-debug.c infrastructure that also adds some 
fault-injection to test the various error paths.

--
Darren

> 
>> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> ---
>>
>>  kernel/futex.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index 6579912..c980a55 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -1567,6 +1567,13 @@ retry_locked:
>>  		}
>>  	}
>>  
>> +	/*
>> +	 * If fixup_pi_state_owner() faulted and was unable to handle the
>> +	 * fault, unlock it and return the fault to userspace.
>> +	 */
>> +	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
>> +		rt_mutex_unlock(&q.pi_state->pi_mutex);
>> +
>>  	/* Unqueue and drop the lock */
>>  	unqueue_me_pi(&q);
>>  
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
