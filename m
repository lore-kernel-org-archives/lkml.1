Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYIRQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYIRQw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYIRQwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:52:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:55977 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYIRQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:52:20 -0400
Message-ID: <48D2875E.3090300@colorfullife.com>
Date: Thu, 18 Sep 2008 18:52:46 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
References: <48D1D694.9010802@cn.fujitsu.com> <20080917213748.7571fbdf.akpm@linux-foundation.org>
In-Reply-To: <20080917213748.7571fbdf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 18 Sep 2008 12:18:28 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
>   
>> sometimes a rcu callback is just calling kfree() to free a struct's memory
>> (we say this callback is a trivial callback.).
>> this patch introduce kfree_rcu() to do these things directly, easily.
>>
>> There are 4 reasons that we need kfree_rcu():
>>
>> 1) unloadable modules:
>>    a module(rcu callback is defined in this module) using rcu must
>>    call rcu_barrier() when unload. rcu_barrier() will increase
>>    the system's overhead(the more cpus the worse) and
>>    rcu_barrier() is very time-consuming. if all rcu callback defined
>>    in this module are trivial callback, we can just call kfree_rcu()
>>    instead, save a rcu_barrier() when unload.
>>
>> 2) duplicate code:
>>    all trivial callback are duplicate code though the structs to be freed
>>    are different. it's just a container_of() and a kfree().
>>    There are about 50% callbacks are trivial callbacks for call_rcu() in
>>    current kernel code.
>>
>> 3) cache:
>>    the instructions of trivial callback is not in the cache supposedly.
>>    calling a trivial callback will let to cache missing very likely.
>>    the more trivial callback the more cache missing. OK, this is
>>    not a problem now or in a few days: Only less than 1% trivial callback
>>    are called in running kernel.
>>
>> 4) future:
>>    the number of user of rcu is increasing. new code for rcu is
>>    trivial callback very likely. it means more modules using rcu
>>    and more duplicate code(may come to 90% of callbacks is trivial
>>    callbacks) and more cache missing.
>>
>> Implementation:
>>    there were a lot of ideas came out when i implemented kfree_rcu().
>>    I chose the simplest one as this patch shows. but these implementation
>>    may cannot be used for to free a struct larger than 16KBytes.
>>
>> kfree_rcu_bh()? kfree_rcu_sched()?
>>    these two are not need current. call_rcu_bh() & call_rcu_sched()
>>    are hardly be called(and hardly be called for trivial callback).
>>
>> vfree_rcu()?
>>    No, vfree() is not atomic function, will not be called in softirq.
>>
>>     
>
> This is all rather mysterious.
>
>   
>> ---
>> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
>> index e8b4039..04c654f 100644
>> --- a/include/linux/rcupdate.h
>> +++ b/include/linux/rcupdate.h
>> @@ -253,4 +253,25 @@ extern void rcu_barrier_sched(void);
>>  extern void rcu_init(void);
>>  extern int rcu_needs_cpu(int cpu);
>>  
>> +#define __KFREE_RCU_MAX_OFFSET 4095
>> +#define KFREE_RCU_MAX_OFFSET (sizeof(void *) * __KFREE_RCU_MAX_OFFSET)
>> +
>> +#define __rcu_reclaim(head) \
>> +do { \
>> +	unsigned long __offset = (unsigned long)head->func; \
>> +	if (__offset <= __KFREE_RCU_MAX_OFFSET) \
>> +		kfree((void *)head - sizeof(void *) * __offset); \
>> +	else \
>> +		head->func(head); \
>> +} while(0)
>>     
>
> All the above could do with some comments explaining what it does.
>   
__rcu_reclaim either treats head->func as an offset for kfree or as a 
function pointer.


>>  #endif /* __LINUX_RCUPDATE_H */
>> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
>> index aad93cd..5a14190 100644
>> --- a/kernel/rcuclassic.c
>> +++ b/kernel/rcuclassic.c
>> @@ -232,7 +232,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
>>  	while (list) {
>>  		next = list->next;
>>  		prefetch(next);
>> -		list->func(list);
>> +		__rcu_reclaim(list);
>>     
Here it's used:
the softirq that is called after the grace period calls kfree directly 
instead of calling a wrapper function around kfree.

>>  		list = next;
>>  		if (++count >= rdp->blimit)
>>  			break;
>> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
>> index 467d594..aa9b56a 100644
>> --- a/kernel/rcupdate.c
>> +++ b/kernel/rcupdate.c
>> @@ -162,6 +162,18 @@ void rcu_barrier_sched(void)
>>  }
>>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
>>  
>> +void kfree_rcu(const void *ptr, struct rcu_head *head)
>> +{
>> +	unsigned long offset;
>> +	typedef void (*rcu_callback)(struct rcu_head *);
>> +
>> +	offset = (void *)head - (void *)ptr;
>>     
What about offset_of? the computation is known at compile time.
>> +	BUG_ON(offset > KFREE_RCU_MAX_OFFSET);
>> +
>>     
I'd try to make that a compile time error. Is that possible? perhaps 
with some __builtin_constant_p (head-ptr) or something like that. Or 
with offset_of.

>> +	call_rcu(head, (rcu_callback)(offset / sizeof(void *)));
>>     
>
> How can this work?  We take the difference between two pointers, divide
> that by 4 or 8, then treat the resulting number as the address of an
> RCU callback function.
>
> I think I'm missing something here.
>
>   
__rcu_reclaim() knows that function pointers < 4096 are actually offsets 
for kfree.


I like the idea:
- the call to list->func() is probably very difficult to predict for a 
branch target predictor.
- it's just a waste not to call kfree directly.
- I'm not sure about the implementation.

--
    Manfred
