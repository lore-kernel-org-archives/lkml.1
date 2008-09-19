Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYISCds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYISCds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 22:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYISCdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 22:33:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbYISCdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 22:33:38 -0400
Message-ID: <48D30F09.1030601@cn.fujitsu.com>
Date: Fri, 19 Sep 2008 10:31:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, manfred@colorfullife.com
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
References: <48D1D694.9010802@cn.fujitsu.com> <20080917213748.7571fbdf.akpm@linux-foundation.org>
In-Reply-To: <20080917213748.7571fbdf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

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
> 
> All the above could do with some comments explaining what it does.
> 
> Please use checkpatch.
> 
> Surely it cannot be resirable to have a "function" which can call kfree
> either synchronously or asynchronously depending upon the size of the
> object which was passed to it?  If the caller wants rcu treatment of
> the freeing then that is what the caller must be given.  I mean, if the
> caller can tolerate a synchrnous call to kfree() then the caller should
> have directly called kfree?
> 
> I think (and pray) that the above could have been implemented as an
> out-of-line C function?
> 

__rcu_reclaim(head) is called when @head 's grace period had completed.

__rcu_reclaim(head) uses "if (__offset <= __KFREE_RCU_MAX_OFFSET)" to
check whether @head is queued by kfree_rcu() or normal call_rcu().

if @head is queued by kfree_rcu(), ((void *)head - sizeof(void *) * __offset)
is the pointer that the memory chunk need to be freed.

otherwise call head->func(head) as original code.

__rcu_reclaim has __prefix, will not be used by user, it is a helper
for rcu-machine. it is always called asynchronously. sorry for not comments
for it.

>> +
>> +/**
>> + * kfree_rcu - free previously allocated memory after a grace period.
>> + * @ptr:  pointer returned by kmalloc.
>> + * @head: structure to be used for queueing the RCU updates. This structure
>> + *        is a part of previously allocated memory @ptr.
>> + */
>> +extern void kfree_rcu(const void *ptr, struct rcu_head *head);
> 
> rcu kerneldoc is implemented in the .c file, not in the .h file.

Good, Thanks.

> 
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
>> +	BUG_ON(offset > KFREE_RCU_MAX_OFFSET);
>> +
>> +	call_rcu(head, (rcu_callback)(offset / sizeof(void *)));
> 
> How can this work?  We take the difference between two pointers, divide
> that by 4 or 8, then treat the resulting number as the address of an
> RCU callback function.
> 
> I think I'm missing something here.

We will use __rcu_reclaim(head) sort it out when it's grace period has
completed.

> 
>> +}
>> +EXPORT_SYMBOL_GPL(kfree_rcu);
>> +
>>  void __init rcu_init(void)
>>  {
>>  	__rcu_init();
>> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
>> index 2782793..62a9e54 100644
>> --- a/kernel/rcupreempt.c
>> +++ b/kernel/rcupreempt.c
>> @@ -1108,7 +1108,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>>  	spin_unlock_irqrestore(&rdp->lock, flags);
>>  	while (list) {
>>  		next = list->next;
>> -		list->func(list);
>> +		__rcu_reclaim(list);
>>  		list = next;
>>  		RCU_TRACE_ME(rcupreempt_trace_invoke);
>>  	}
> 
> 
> 


