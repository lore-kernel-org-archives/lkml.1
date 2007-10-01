Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXJARGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXJARGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXJARGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:06:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35938 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXJARGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:06:31 -0400
Date: Sun, 30 Sep 2007 18:41:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 5/9] RCU: CPU hotplug support for preemptible RCU
Message-ID: <20071001014142.GC12494@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183622.GE3819@linux.vnet.ibm.com> <20070930163849.GB374@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930163849.GB374@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 08:38:49PM +0400, Oleg Nesterov wrote:
> On 09/10, Paul E. McKenney wrote:
> >
> > --- linux-2.6.22-d-schedclassic/kernel/rcupreempt.c	2007-08-22 15:45:28.000000000 -0700
> > +++ linux-2.6.22-e-hotplugcpu/kernel/rcupreempt.c	2007-08-22 15:56:22.000000000 -0700
> > @@ -125,6 +125,8 @@ enum rcu_mb_flag_values {
> >  };
> >  static DEFINE_PER_CPU(enum rcu_mb_flag_values, rcu_mb_flag) = rcu_mb_done;
> >
> > +static cpumask_t rcu_cpu_online_map = CPU_MASK_NONE;
> 
> I'd suggest to append "__read_mostly"

Makes sense!

> > +void rcu_offline_cpu_rt(int cpu)
> > +{
> > [...snip...]
> > +	spin_lock_irqsave(&rcu_ctrlblk.fliplock, oldirq);
> > +	rcu_check_mb(cpu);
> > +	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
> > +		smp_mb();  /* Subsequent counter accesses must see new value */
> > +		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
> > +		smp_mb();  /* Subsequent RCU read-side critical sections */
> > +			   /*  seen -after- acknowledgement. */
> 
> Imho, all these barriers are unneeded and confusing, we can't do them on behalf
> of a dead CPU anyway. Can't we just do
> 
> 	per_cpu(rcu_mb_flag, cpu) = rcu_mb_done;
> 	per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
> ?

You are likely correct, but this is a slow path, extremely hard to
stress test, and I am freakin' paranoid about this sort of thing.

> Why can't we also do
> 
> 	__get_cpu_var(rcu_flipctr)[0] += per_cpu(rcu_flipctr, cpu)[0];
> 	per_cpu(rcu_flipctr, cpu)[0] = 0;	
> 	__get_cpu_var(rcu_flipctr)[1] += per_cpu(rcu_flipctr, cpu)[1];
> 	per_cpu(rcu_flipctr, cpu)[1] = 0;	
> 
> ? This way rcu_try_flip_waitzero() can also use rcu_cpu_online_map. This cpu
> is dead, nobody can modify per_cpu(rcu_flipctr, cpu). And we can't confuse
> rcu_try_flip_waitzero(), we are holding rcu_ctrlblk.fliplock.

Very good point!!!  This would reduce latencies on systems where
the number of possible CPUs greatly exceeds that of the number of
online CPUs, so seems quite worthwhile.

> > +void __devinit rcu_online_cpu_rt(int cpu)
> > +{
> > +	unsigned long oldirq;
> > +
> > +	spin_lock_irqsave(&rcu_ctrlblk.fliplock, oldirq);
> > +	cpu_set(cpu, rcu_cpu_online_map);
> 
> What if _cpu_up() fails? I think rcu_cpu_notify(CPU_UP_CANCELED) should call
> rcu_offline_cpu_rt() too.

Good catch, will fix!!!

							Thanx, Paul
