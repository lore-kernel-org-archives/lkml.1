Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYIPQwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYIPQwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbYIPQwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:52:36 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45222 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYIPQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:52:35 -0400
Message-ID: <48CFE466.8010200@colorfullife.com>
Date: Tue, 16 Sep 2008 18:52:54 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com>
In-Reply-To: <20080915160221.GA9660@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul E. McKenney wrote:
> +/*
> + * Scan the leaf rcu_node structures, processing dyntick state for any that
> + * have not yet encountered a quiescent state, using the function specified.
> + * Returns 1 if the current grace period ends while scanning (possibly
> + * because we made it end).
> + */
> +static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
> +			       int (*f)(struct rcu_data *))
> +{
> +	unsigned long bit;
> +	int cpu;
> +	unsigned long flags;
> +	unsigned long mask;
> +	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
> +	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
> +
> +	for (; rnp_cur < rnp_end; rnp_cur++) {
> +		mask = 0;
> +		spin_lock_irqsave(&rnp_cur->lock, flags);
> +		if (rsp->completed != lastcomp) {
> +			spin_unlock_irqrestore(&rnp_cur->lock, flags);
> +			return 1;
> +		}
> +		if (rnp_cur->qsmask == 0) {
> +			spin_unlock_irqrestore(&rnp_cur->lock, flags);
> +			continue;
> +		}
> +		cpu = rnp_cur->grplo;
> +		bit = 1;
> +		mask = 0;
> +		for (; cpu <= rnp_cur->grphi; cpu++, bit <<= 1) {
> +			if ((rnp_cur->qsmask & bit) != 0 && f(rsp->rda[cpu]))
> +				mask |= bit;
> +		}
>   
I'm still comparing my implementation with your code:
- f is called once for each cpu in the system, correct?
- if at least one cpu is in nohz mode, this loop will be needed for 
every grace period.

That means an O(NR_CPUS) loop with disabled local interrupts :-(
Is that correct?

Unfortunately, my solution is even worse:
My rcu_irq_exit() acquires a global spinlock when called on a nohz cpus.
A few cpus in cpu_idle, nohz, executing 50k network interrupts/sec would 
cacheline-trash that spinlock.
I'm considering counting interrupts: if a nohz cpu executes more than a 
few interrupts/tick, then add a timer that check rcu_pending().

Perhaps even wouldn't be enough: I remember that the initial unhandled 
irq detection code broke miserably on large SGI systems:
An atomic_inc(&global_var) in the local timer interrupt (i.e.: 
NR_CPUS*HZ calls/sec) caused so severe trashing that the system wouldn't 
boot. IIRC that was with 512 cpus.


--
    Manfred
