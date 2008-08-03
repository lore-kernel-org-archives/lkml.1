Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYHCIDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYHCIDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 04:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYHCIDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 04:03:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62581 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbYHCIDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 04:03:12 -0400
Message-ID: <489565BC.3000408@cn.fujitsu.com>
Date: Sun, 03 Aug 2008 16:01:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for	callbacks-processing(v2)
References: <48708F2F.2060406@cn.fujitsu.com> <20080718140930.GT6875@elte.hu> <20080721100433.GC8384@linux.vnet.ibm.com> <20080801211053.GZ14851@linux.vnet.ibm.com>
In-Reply-To: <20080801211053.GZ14851@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:

[...]

>>  /**
>>   * call_rcu - Queue an RCU callback for invocation after a grace period.
>>   * @head: structure to be used for queueing the RCU updates.
>> @@ -133,18 +172,11 @@ void call_rcu(struct rcu_head *head,
>>  				void (*func)(struct rcu_head *rcu))
>>  {
>>  	unsigned long flags;
>> -	struct rcu_data *rdp;
>>  
>>  	head->func = func;
>>  	head->next = NULL;
>>  	local_irq_save(flags);
> 
> I very much like the gathering of common code from call_rcu() and
> call_rcu_bh() into __call_rcu().  But why not also move the
> local_irq_save() and local_irq_restore() to __call_rcu(), perhaps
> along with the initialization of head->next?

We should put __get_cpu_var into preempt_disable critical section.
So I didn't move the local_irq_save() and local_irq_restore()
to __call_rcu().

I greed your changes except the changes here.
percpu_ptr() may help for us.

> 
> (I understand the motivation for keeping the initialization of the
> fields of "head" at this level -- otherwise, you must add another
> argument to __call_rcu().  But might be worth considering...)
> 
>> -	rdp = &__get_cpu_var(rcu_data);
>> -	*rdp->nxttail = head;
>> -	rdp->nxttail = &head->next;
>> -	if (unlikely(++rdp->qlen > qhimark)) {
>> -		rdp->blimit = INT_MAX;
>> -		force_quiescent_state(rdp, &rcu_ctrlblk);
>> -	}
>> +	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
>>  	local_irq_restore(flags);
>>  }
>>  EXPORT_SYMBOL_GPL(call_rcu);
>> @@ -169,20 +201,11 @@ void call_rcu_bh(struct rcu_head *head,
>>  				void (*func)(struct rcu_head *rcu))
>>  {
>>  	unsigned long flags;
>> -	struct rcu_data *rdp;
>>  
>>  	head->func = func;
>>  	head->next = NULL;
>>  	local_irq_save(flags);
>> -	rdp = &__get_cpu_var(rcu_bh_data);
>> -	*rdp->nxttail = head;
>> -	rdp->nxttail = &head->next;
>> -
>> -	if (unlikely(++rdp->qlen > qhimark)) {
>> -		rdp->blimit = INT_MAX;
>> -		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
>> -	}
>> -
>> +	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
>>  	local_irq_restore(flags);
>>  }
>>  EXPORT_SYMBOL_GPL(call_rcu_bh);
>> @@ -211,12 +234,6 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_
>>  static inline void raise_rcu_softirq(void)
>>  {
>>  	raise_softirq(RCU_SOFTIRQ);
>> -	/*
>> -	 * The smp_mb() here is required to ensure that this cpu's
>> -	 * __rcu_process_callbacks() reads the most recently updated
>> -	 * value of rcu->cur.
>> -	 */
>> -	smp_mb();
> 
> I have not yet convinced myself that it is OK to get rid of this memory
> barrier.  This memory barrier was intended order to handle the following
> sequence of events:
> 
> 	rcu_read_lock_bh();  /* no memory barrier. */
> 	p = rcu_dereference(some_global_pointer);
> 	do_something_with(p);
> 	rcu_read_unlock_bh();  /* no memory barrier. */
> 
> 	---- scheduling-clock interrupt occurs, eventually invoking
> 	---- rcu_check_callbacks()
> 
> 	---- And the access to "p" above could potentially be reordered
> 	---- into the grace-period computation
> 
> Such reordering is of course quite unlikely to be harmful, due to the
> long duration of RCU grace periods.  But I am paranoid.
> 
> If this memory barrier turns out to be necessary, one approach would
> to be to place it at the beginning of rcu_check_callbacks(), which is
> a better place for it in any case.
> 
> Thoughts?

I hasn't thought it before. I thought that smp_mb is used for
rcu->cur as the original comment had told.

I prefer to add memory barrier to rcu_process_callbacks as your patch.

But I has a question here:

In this case, p->rcu_head is not in donelist. So __rcu_process_callbacks
is only access to p->rcu_head(p->rcu_head.next). And other cpus don't
access to p->rcu_head which has been queued on this cpu' rcu_data.

Is this reordering harmful(How this reordering make other
cpus' access wrong)?

[...]


