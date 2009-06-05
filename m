Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZFEBav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZFEBav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZFEBam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:30:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56765 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZFEBam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:30:42 -0400
Message-ID: <4A28759D.4040602@cn.fujitsu.com>
Date: Fri, 05 Jun 2009 09:32:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpuhotplug: introduce try_get_online_cpus() take 2
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com> <4A27708C.6030703@cn.fujitsu.com> <20090604204958.GA5071@redhat.com>
In-Reply-To: <20090604204958.GA5071@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 06/04, Lai Jiangshan wrote:
>> - Lockless for get_online_cpus()'s fast path
>> - Introduce try_get_online_cpus()
> 
> I think this can work...
> 
>> @@ -50,10 +57,20 @@ void get_online_cpus(void)
>>  	might_sleep();
>>  	if (cpu_hotplug.active_writer == current)
>>  		return;
>> -	mutex_lock(&cpu_hotplug.lock);
>> -	cpu_hotplug.refcount++;
>> -	mutex_unlock(&cpu_hotplug.lock);
>>
>> +	if (unlikely(!atomic_inc_not_zero(&cpu_hotplug.refcount))) {
>> +		DEFINE_WAIT(wait);
>> +
>> +		for (;;) {
>> +			prepare_to_wait(&cpu_hotplug.sleeping_readers, &wait,
>> +					TASK_UNINTERRUPTIBLE);
>> +			if (atomic_inc_not_zero(&cpu_hotplug.refcount))
>> +				break;
>> +			schedule();
>> +		}
>> +
>> +		finish_wait(&cpu_hotplug.sleeping_readers, &wait);
>> +	}
>>  }
> 
> Looks like the code above can be replaced with
> 
> 	wait_event(atomic_inc_not_zero(&cpu_hotplug.refcount));

You are right, but with the atomic_inc_not_zero() has side-effect,
I'm afraid that wait_event() will be changed in future, and it may
increases the cpu_hotplug.refcount twice.

#define wait_event(wq, condition) ......

I consider that @condition should not have side-effect, it should be
some thing like this:

some_number == 2, !some_condition, some_thing_has_done,
......

> 
>>  static void cpu_hotplug_done(void)
>>  {
>>  	cpu_hotplug.active_writer = NULL;
>> -	mutex_unlock(&cpu_hotplug.lock);
>> +	atomic_inc(&cpu_hotplug.refcount);
>> +
>> +	if (waitqueue_active(&cpu_hotplug.sleeping_readers))
>> +		wake_up(&cpu_hotplug.sleeping_readers);
>>  }
> 
> This looks racy.
> 
> Suppose that the new reader comes right before atomic_inc(). The first
> inc_not_zero() fails, the readear does prepare_to_wait(), the 2nd
> inc_not_zero() fails too.
> 
> cpu_hotplug_done() does atomic_inc().
> 
> What guarantees we must see waitqueue_active() == T?
> 
> I think cpu_hotplug_done() should do unconditional wake_up(). This path
> is slow anyway, "if (waitqueue_active())" does not buy too much. In this
> case .sleeping_readers->lock closes the race.
> 
> Unless I missed something, of course.

You are definitely right, cpu_hotplug_done() should do unconditional
wake_up(). waitqueue_active() has no synchronization codes.

> 
> 
> Minor, but I'd suggest to use wake_up_all(). This does not make any
> difference because we do not have WQ_FLAG_EXCLUSIVE waiters, but imho
> looks a bit cleaner.
> 
> 
> Hmm. It seems to me that cpu_hotplug_done() needs mb__before_atomic_inc()
> before atomic_inc. Otherwise, "active_writer = NULL" can be re-ordered with
> atomic_inc(). If the new reader does get_online_cpus() + put_online_cpus()
> quicky, it can see active_writer != NULL.
> 
> 

The lines "active_writer = NULL" and "atomic_inc()" can exchange,
there is no code need to synchronize to them.
get_online_cpus()/put_online_cpus() will see "active_writer != current",
it just what get_online_cpus()/put_online_cpus() needs.

Lai

