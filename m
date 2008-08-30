Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbYH3Oev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbYH3Oev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYH3Oem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:34:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51318 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYH3Oel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:34:41 -0400
Date: Sat, 30 Aug 2008 07:34:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, rostedt@goodmis.org,
       peterz@infradead.org
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU
	implementation
Message-ID: <20080830143438.GF7107@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <48B919C2.1040809@cn.fujitsu.com> <48B94BF4.9090103@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B94BF4.9090103@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 03:32:36PM +0200, Manfred Spraul wrote:
> Lai Jiangshan wrote:
>> I just had a fast review. so my comments is nothing but cleanup.
>>
>>           Thanks, Lai.
>>
>> Paul E. McKenney wrote:
>>   
>>> Hello!
>>>     
>>
>>   
>>> +rcu_start_gp(struct rcu_state *rsp, unsigned long iflg)
>>> +	__releases(rsp->rda[smp_processor_id()]->lock)
>>> +{
>>> +	unsigned long flags = iflg;
>>> +	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
>>> +	struct rcu_node *rnp = rcu_get_root(rsp);
>>> +	struct rcu_node *rnp_cur;
>>> +	struct rcu_node *rnp_end;
>>> +
>>> +	if (!cpu_needs_another_gp(rsp, rdp)) {
>>>   		/*
>>> -		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
>>> -		 * Barrier  Otherwise it can cause tickless idle CPUs to be
>>> -		 * included in rcp->cpumask, which will extend graceperiods
>>> -		 * unnecessarily.
>>> +		 * Either there is no need to detect any more grace periods
>>> +		 * at the moment, or we are already in the process of
>>> +		 * detecting one.  Either way, we should not start a new
>>> +		 * RCU grace period, so drop the lock and return.
>>>  		 */
>>> -		smp_mb();
>>> -		cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
>>> +		spin_unlock_irqrestore(&rnp->lock, flags);
>>> +		return;
>>> +	}
>>> +
>>> +	/* Advance to a new grace period and initialize state. */
>>> +
>>> +	rsp->gpnum++;
>>> +	rsp->signaled = RCU_SIGNAL_INIT;
>>> +	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
>>> +	record_gp_stall_check_time();
>>> +	dyntick_save_completed(rsp, rsp->completed - 1);
>>> +	note_new_gpnum(rsp, rdp);
>>> +
>>> +	/*
>>> +	 * Because we are first, we know that all our callbacks will
>>> +	 * be covered by this upcoming grace period, even the ones
>>> +	 * that were registered arbitrarily recently.
>>> +	 */
>>> +
>>> +	rcu_next_callbacks_are_ready(rdp);
>>> +	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
>>>  -		rcp->signaled = 0;
>>> +	/* Special-case the common single-level case. */
>>> +
>>> +	if (NUM_RCU_NODES == 1) {
>>> +		rnp->qsmask = rnp->qsmaskinit;
>>>     
>>
>> I tried a mask like qsmaskinit before. The system came to deadlock
>> when I did on/offline cpus.
>> I didn't find out the whys for I bethought of these two problem:
>>
>> problem 1:
>> ----race condition 1:
>> <cpu_down>
>> synchronize_rcu <called from offline handler in other subsystem>
>> rcu_offline_cpu
>>
>>
>> -----race condition 2:
>> rcu_online_cpu
>> synchronize_rcu <called from online handler in other subsystem>
>> <cpu_up>
>>
>> in these two condition, synchronize_rcu isblocked for ever for
>> synchronize_rcu have to wait a cpu in rnp->qsmask, but this
>> cpu don't run.
>>
>>   
> Can we disallow synchronize_rcu() from the cpu notifiers? Are there any 
> users that do a synchronize_rcu() from within the notifiers?
> I don't see any other solution.

I made force_quiescent_state() check for offline CPUs.  (Well, actually
it is rcu_implicit_offline_qs(), which is indirectly called from
force_quiescent_state().

> Something like qsmaskinit is needed - always enumerating all cpus just 
> doesn't scale.

Agreed!!!

> Perhaps it's possible to rely on CPU_DYING, but I haven't figured out yet 
> how to handle read-side critical sections in CPU_DYING handlers.
> Interrupts after CPU_DYING could be handled by rcu_irq_enter(), 
> rcu_irq_exit() [yes, they exist on x86: the arch code enables the local 
> interrupts in order to process the currently queued interrupts]

My feeling is that CPU online/offline will be quite rare, so it should
be OK to clean up after the races in force_quiescent_state(), which in
this version is called every three ticks in a given grace period.

Yes, I did worry about the possibility of all CPUs being in dyntick-idle
mode, and the solution for that is (1) don't let a CPU that has RCU
callbacks pending go into dyntick-idle mode via rcu_needs_cpu() and
(2) don't let a grace period start unless there is at least one callback
that is not yet in the done state.  But no, I am not certain that I have
gotten this completely correct yet.

							Thanx, Paul
