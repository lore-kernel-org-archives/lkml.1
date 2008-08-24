Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYHXQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYHXQcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 12:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYHXQcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 12:32:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44333 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYHXQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 12:31:59 -0400
Date: Sun, 24 Aug 2008 09:32:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080824163200.GE6851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <48B1170C.4050706@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B1170C.4050706@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 10:08:44AM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:

Thank you for looking this over!

>> + * Definition for node within the RCU grace-period-detection hierarchy.
>> + */
>> +struct rcu_node {
>> +	spinlock_t lock;
>> +	unsigned long	qsmask;	/* CPUs or groups that need to switch in      */
>> +				/*  order for current grace period to proceed.*/
>> +	unsigned long	qsmaskinit;
>> +				/* Per-GP initialization for qsmask.	      */
>>   
> I'm not sure if a bitmap is the right storage. If I understand the code 
> correctly, it contains two information:
> 1) If the bitmap is clear, then all cpus have completed whatever they need 
> to do.
> A counter is more efficient than a bitmap. Especially: It would allow to 
> choose the optimal fan-out, independent from 32/64 bits.
> 2) The information if the current cpu must do something to complete the 
> current period.non
> This is a local information, usually (always?) only the current cpu needs 
> to know if it must do something.
> But this doesn't need to be stored in a shared structure, the information 
> could be stored in a per-cpu structure.

I am using the bitmap in force_quiescent_state() to work out who to
check dynticks and who to send reschedule IPIs to.  I could scan all
of the per-CPU rcu_data structures, but am assuming that after a few
jiffies there would typically be relatively few CPUs still needing to do
a quiescent state.  Given this assumption, on systems with large numbers
of CPUs, scanning the bitmask greatly reduces the number of cache misses
compared to scanning the rcu_data structures.

>> +	/*
>> +	 * Extract the list of ready callbacks, disabling to prevent
>> +	 * races with call_rcu() from interrupt handlers.
>> +	 */
>> +	local_irq_save(flags);
>> +	list = rdp->nxtlist;
>> +	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
>> +	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
>> +	tail = rdp->nxttail[RCU_DONE_TAIL];
>> +	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
>> +		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
>> +			rdp->nxttail[count] = &rdp->nxtlist;
>> +	local_irq_restore(flags);
>>   
> Do you have a description of the events between call_rcu() and the rcu 
> callback?
> Is the following description correct?
>
> __call_rcu() queues in RCU_NEXT_TAIL.
> In the middle of the current grace period: rcu_check_quiescent_state() 
> calls rcu_next_callbacks_are_ready().
> Entry now in RCU_NEXT_READY_TAIL
> ** 0.5 cycles: wait until all cpus have completed the current cycle.
> rcu_process_gp_end() moves from NEXT_READY_TAIL to WAIT_TAIL
>
> ** full grace period
> rcu_process_gp_end() moves from WAIT_TAIL to DONE_TAIL
> rcu_do_batch() finds the entries in DONE_TAIL and calls the callback.

Yes, that is the sequence of events if grace periods are happening back to
back and if the current CPU has not yet passed through a quiescent state.
If RCU is idle, then there is no need to wait for a previous grace
period to complete.  If this CPU already passed through its quiescent
state for the first grace period, and is not the CPU that starts the next
grace period, then there will be an additional grace period to move from
RCU_NEXT_TAIL to RCU_NEXT_READY_TAIL.  If this CPU is the one starting
the next grace period, then all of its callbacks get advanced.

>> +/*
>> + * Do softirq processing for the current CPU.
>> + */
>>  static void rcu_process_callbacks(struct softirq_action *unused)
>>  {
>>  	/*
>>  	 * Memory references from any prior RCU read-side critical sections
>> -	 * executed by the interrupted code must be see before any RCU
>> +	 * executed by the interrupted code must be seen before any RCU
>>  	 * grace-period manupulations below.
>>  	 */
>>   	smp_mb(); /* See above block comment. */
>>   
> Why this mb()? There was a grace period between the last read side critical 
> section that might have accessed the pointer.
> The rcu internal code already does spin_lock()+spin_unlock(). Isn't that 
> sufficient?

The combination of spin_lock()+spin_unlock()+spin_lock()+spin_unlock()
would suffice.  But the pair of smp_mb()s suffice regardless of fast
paths through the rest of the mechanism.  Because rcu_process_callbacks()
is on the slow path, the trival proof of ordering is more important than
the slight reduction in overhead.

>>  -	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
>> -	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
>> +	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
>> +	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
>>   
> Have you considered merging RCU_DONE_TAIL for rcu_data and rcu_bh_data?

I have (and am) considering this.  It would require an additional per-CPU
data structure, would require an additional check in rcu_pending(), and
require a bit more manipulation when callbacks become "done".  However,
but would simplify the requeuing code in rcu_do_batch() a bit.

One interesting side effect would be that blimit would apply globally
to both rcu and rcu_bh, and that a burst of (say) rcu callbacks could
delay rcu_bh callbacks.  I am not yet sure whether this is good or bad.

>> +
>> +/**
>> + * call_rcu - Queue an RCU callback for invocation after a grace period.
>> + * @head: structure to be used for queueing the RCU updates.
>> + * @func: actual update function to be invoked after the grace period
>> + *
>> + * The update function will be invoked some time after a full grace
>> + * period elapses, in other words after all currently executing RCU
>> + * read-side critical sections have completed.  RCU read-side critical
>> + * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
>> + * and may be nested.
>> + */
>>   
> The docbook entry is duplicated: They are in include/linux/rcupdate.h and 
> here.
> What about removing one of them?

Good point, done!

> I would go one step further:
> Even add call_rcu_sched() into rcupdate.h. Add a Kconfig bool 
> "RCU_NEEDS_SCHED" and automatically define either the extern or the 
> #define.

Another approach would be to have an rcupdate.h definition that
was a wrapper around __call_rcu_sched(), and put the docbook stuff in
rcupdate.h.  It would appear that docbook was not created with the idea
of alternative implementations in mind.  ;-)

							Thanx, Paul
