Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbZEHRas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbZEHRas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZEHRaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:30:35 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:42980 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbZEHRae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:30:34 -0400
Message-ID: <4A046BBF.9070400@cosmosbay.com>
Date: Fri, 08 May 2009 19:28:31 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       davem@davemloft.net, zbr@ioremap.net, jeff.chua.linux@gmail.com,
       paulus@samba.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v4 somewhat-expedited "big hammer" RCU grace periods
References: <20090508170815.GA9708@linux.vnet.ibm.com>
In-Reply-To: <20090508170815.GA9708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 08 May 2009 19:28:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney a écrit :
> Fourth cut of "big hammer" expedited RCU grace periods.  This uses
> a kthread that schedules itself on all online CPUs in turn, thus
> forcing a grace period.  The synchronize_sched(), synchronize_rcu(),
> and synchronize_bh() primitives wake this kthread up and then wait for
> it to force the grace period.
> 
> As before, this does nothing to expedite callbacks already registered
> with call_rcu() or call_rcu_bh(), but there is no need to.  Just maps
> to synchronize_rcu() and a new synchronize_rcu_bh() on preemptable RCU,
> which has more complex grace-period detection -- this can be fixed later.
> 
> Passes light rcutorture testing.  Grace periods take around 200
> microseconds on an 8-CPU Power machine.  This is a good order of magnitude
> better than v3, but an order of magnitude slower than v2.  Furthermore,
> it will get slower the more CPUs you have, and eight CPUs is not all
> that many these days.  So this implementation still does not cut it.
> 
> Once again, I am posting this on the off-chance that I made some stupid
> mistake that someone might spot.  Absent that, I am taking yet another
> different approach, namely setting up per-CPU threads that are awakened
> via smp_call_function(), permitting the quiescent states to be waited
> for in parallel.
> 

I dont know, dont we have possibility one cpu is dedicated for the use
of a cpu hungry real time thread ?

krcu_sched_expedited() would dead lock or something ?

> Shortcomings:
> 
> o	Too slow!!!  Thinking in terms of using per-CPU kthreads.
> 
> o	The wait_event() calls result in 120-second warnings, need
> 	to use something like wait_event_interruptible().  There are
> 	probably other corner cases that need attention.
> 
> o	Does not address preemptable RCU.
> 
> Changes since v3:
> 
> o	Use a kthread that schedules itself on each CPU in turn to
> 	force a grace period.  The synchronize_rcu() primitive
> 	wakes up the kthread in order to avoid messing with affinity
> 	masks on user tasks.
> 
> o	Tried a number of additional variations on the v3 approach, none
> 	of which helped much.
> 
> Changes since v2:
> 
> o	Use reschedule IPIs rather than a softirq.
> 
> Changes since v1:
> 
> o	Added rcutorture support, and added exports required by
> 	rcutorture.
> 
> o	Added comment stating that smp_call_function() implies a
> 	memory barrier, suggested by Mathieu.
> 
> o	Added #include for delay.h.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  include/linux/rcuclassic.h |   16 +++
>  include/linux/rcupdate.h   |   24 ++---
>  include/linux/rcupreempt.h |   10 ++
>  include/linux/rcutree.h    |   13 ++
>  kernel/rcupdate.c          |  103 +++++++++++++++++++++++
>  kernel/rcupreempt.c        |    1 
>  kernel/rcutorture.c        |  200 ++++++++++++++++++++++++---------------------
>  7 files changed, 261 insertions(+), 106 deletions(-)
> 

> +/*
> + * Kernel thread that processes synchronize_sched_expedited() requests.
> + * This is implemented as a separate kernel thread to avoid the need
> + * to mess with other tasks' cpumasks.
> + */
> +static int krcu_sched_expedited(void *arg)
> +{
> +	int cpu;
> +
> +	do {
> +		wait_event(need_sched_expedited_wq, need_sched_expedited);
> +		need_sched_expedited = 0;
> +		get_online_cpus();
> +		for_each_online_cpu(cpu) {
> +			sched_setaffinity(0, &cpumask_of_cpu(cpu));
> +			schedule();

<<no return>>

> +		}
> +		put_online_cpus();
> +		sched_expedited_done = 1;
> +		wake_up(&sched_expedited_done_wq);
> +	} while (!kthread_should_stop());
> +	return 0;
> +}


