Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYIPRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYIPRbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYIPRb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:31:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52490 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYIPRb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:31:28 -0400
Date: Tue, 16 Sep 2008 10:30:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
Message-ID: <20080916173012.GC6717@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <48CFE466.8010200@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CFE466.8010200@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 06:52:54PM +0200, Manfred Spraul wrote:
> Hi Paul,

Hello, Manfred!

Thank you for looking this over!

> Paul E. McKenney wrote:
>> +/*
>> + * Scan the leaf rcu_node structures, processing dyntick state for any 
>> that
>> + * have not yet encountered a quiescent state, using the function 
>> specified.
>> + * Returns 1 if the current grace period ends while scanning (possibly
>> + * because we made it end).
>> + */
>> +static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
>> +			       int (*f)(struct rcu_data *))
>> +{
>> +	unsigned long bit;
>> +	int cpu;
>> +	unsigned long flags;
>> +	unsigned long mask;
>> +	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
>> +	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
>> +
>> +	for (; rnp_cur < rnp_end; rnp_cur++) {
>> +		mask = 0;
>> +		spin_lock_irqsave(&rnp_cur->lock, flags);
>> +		if (rsp->completed != lastcomp) {
>> +			spin_unlock_irqrestore(&rnp_cur->lock, flags);
>> +			return 1;
>> +		}
>> +		if (rnp_cur->qsmask == 0) {
>> +			spin_unlock_irqrestore(&rnp_cur->lock, flags);
>> +			continue;
>> +		}
>> +		cpu = rnp_cur->grplo;
>> +		bit = 1;
>> +		mask = 0;
>> +		for (; cpu <= rnp_cur->grphi; cpu++, bit <<= 1) {
>> +			if ((rnp_cur->qsmask & bit) != 0 && f(rsp->rda[cpu]))
>> +				mask |= bit;
>> +		}
>>   
> I'm still comparing my implementation with your code:
> - f is called once for each cpu in the system, correct?

Not necessarily.  If all CPUs corresponding to this rcu_state struct
have checked in already, we don't even get to this loop -- see the
"continue" above.

> - if at least one cpu is in nohz mode, this loop will be needed for every 
> grace period.

The outer loop, yes.  The inner loop only for those rcu_state structs
that have at least one CPU in nohz mode.

> That means an O(NR_CPUS) loop with disabled local interrupts :-(
> Is that correct?

With the definition of "O()" being the worst-case execution time, yes.
But this worst case could only happen when the system was mostly idle,
in which case the added overhead should not be too horribly bad.  If the
system was busy enough that each CPU ran at least one process during each
grace period, then this function would not be invoked in the first place.

If this does prove to be a problem in practice, I will rework
force_quiescent_state() to run incrementally.  But I would rather
avoid both the added complexity and the resulting longer grace periods,
so someone needs to bring me a real-world problem before I take that
approach.

> Unfortunately, my solution is even worse:
> My rcu_irq_exit() acquires a global spinlock when called on a nohz cpus.
> A few cpus in cpu_idle, nohz, executing 50k network interrupts/sec would 
> cacheline-trash that spinlock.
> I'm considering counting interrupts: if a nohz cpu executes more than a few 
> interrupts/tick, then add a timer that check rcu_pending().

I tried putting a cpu_quiet() in my rcu_irq_exit() as well, and quickly
decided that this was counter-productive.  ;-)

> Perhaps even wouldn't be enough: I remember that the initial unhandled irq 
> detection code broke miserably on large SGI systems:
> An atomic_inc(&global_var) in the local timer interrupt (i.e.: NR_CPUS*HZ 
> calls/sec) caused so severe trashing that the system wouldn't boot. IIRC 
> that was with 512 cpus.

/me runs off and checks to make sure that all of my dyntick entry/exit
code restricts itself to per-CPU variables...

Yep!  (Whew!!!)

							Thanx, Paul
