Return-Path: <linux-kernel-owner+w=401wt.eu-S1030701AbXAZBw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030701AbXAZBw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030702AbXAZBw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:52:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59616 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030701AbXAZBw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:52:26 -0500
Date: Thu, 25 Jan 2007 17:52:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to rcutorture
Message-ID: <20070126015212.GI1705@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com> <20070125022338.GB22540@linux.vnet.ibm.com> <45B86E88.6020209@kernel.org> <20070125180158.GC1705@linux.vnet.ibm.com> <45B8FFBB.4090307@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B8FFBB.4090307@kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 11:06:35AM -0800, Josh Triplett wrote:
> Paul E. McKenney wrote:
> > On Thu, Jan 25, 2007 at 12:47:04AM -0800, Josh Triplett wrote:
> >> One major item: this new test feature really needs a new module parameter to
> >> enable or disable it.
> > 
> > CONFIG_PREEMPT_RCU_BOOST is the parameter -- if not set, then no test.
> > This parameter is provided by the accompanying RCU-boost patch.
> 
> It seems useful for rcutorture to use or not use the preempting thread
> independently of CONFIG_PREEMPT_RCU_BOOST.  That would bring you from two
> cases to four, and the two new cases both make sense:
> 
> * CONFIG_PREEMPT_RCU_BOOST=n, but run rcutorture with the preempting thread.
>   This configuration allows you to demonstrate the need for
>   CONFIG_PREEMPT_RCU_BOOST, by showing what happens when you need it and don't
>   have it.
> 
> * CONFIG_PREEMPT_RCU_BOOST=y, but run rcutorture without the preempting
>   thread.  This configuration allows you to test with rcutorture while running
>   a *real* real-time workload rather than the simple preempting thread, or
>   just test basic RCU functionality.
> 
> A simple boolean module_param would work here.

OK, sold!  I will add this.  Perhaps CONFIG_PREEMPT_RCU_TORTURE.

> At some point, we may want to add the ability to run multiple preempting
> threads, but that doesn't need to happen for this patch.

I considered that for this initial round, but you only need to preempt
a single RCU reader to force the RCU booster to do something.  ;-)

> >> Paul E. McKenney wrote:
> >>> diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rcutorture.c linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c
> >>> --- linux-2.6.20-rc4-rt1/kernel/rcutorture.c	2007-01-09 10:59:54.000000000 -0800
> >>> +++ linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c	2007-01-23 11:27:49.000000000 -0800
> 
> >>> +static int rcu_torture_preempt(void *arg)
> >>> +{
> >>> +	int completedstart;
> >>> +	time_t gcstart;
> >>> +	struct sched_param sp;
> >>> +
> >>> +	sp.sched_priority = MAX_RT_PRIO - 1;
> >>> +	sched_setscheduler(current, SCHED_RR, &sp);
> >>> +	current->flags |= PF_NOFREEZE;
> >>> +
> >>> +	do {
> >>> +		completedstart = rcu_torture_completed();
> >>> +		gcstart = xtime.tv_sec;
> >>> +		while ((xtime.tv_sec - gcstart < 10) &&
> >>> +		       (rcu_torture_completed() == completedstart))
> >>> +			cond_resched();
> >>> +		if (rcu_torture_completed() == completedstart)
> >>> +			rcu_torture_preempt_errors++;
> >>> +		schedule_timeout_interruptible(shuffle_interval * HZ);
> >> Why call schedule_timeout_interruptible here without actually handling
> >> interruptions?  So that you can send it a signal to cause the shuffle early?
> > 
> > It allows you to kill the process in order to get the module unload to
> > happen more quickly in case someone specified an overly long interval.
> 
> I didn't actually know that you could kill a kthread from userspace. :)
> 
> That rationale makes sense.

It won't actually die, but if I understand correctly (a big "if") the
signal would cause schedule_timeout_interruptible() to return, allowing
the kthread_should_stop() check to happen.

> > But now that you mention this, a simple one-second sleep is probably
> > appropriate here.
> 
> OK.
> 
> >>> +	} while (!kthread_should_stop());
> >>> +	return NULL;
> >>> +}
> >>> +
> >>> +static void rcu_preempt_start(void)
> >>> +{
> >>> +	rcu_preeempt_task = kthread_run(rcu_torture_preempt, NULL,
> >>> +					"rcu_torture_preempt");
> >>> +	if (IS_ERR(rcu_preeempt_task)) {
> >>> +		VERBOSE_PRINTK_ERRSTRING("Failed to create preempter");
> >> This ought to include the errno value, PTR_ERR(rcu_preempt_task).
> > 
> > Good point -- what I should do is return this value so that
> > rcu_torture_init() can return it, failing the module-load process
> > and unwinding.
> 
> Even better, yes.
> 
> >>> +		rcu_preeempt_task = NULL;
> >>> +	}
> >>> +}
> >>> +
> >>> +static void rcu_preempt_end(void)
> >>> +{
> >>> +	if (rcu_preeempt_task != NULL) {
> >> if (rcu_preempt_task) would work just as well here.
> > 
> > True, but was being consistent with usage elsewhere in this file.
> 
> Fair enough; don't worry about it for this patch, then.  I'll deal with that
> particular style cleanup later, throughout rcutorture.

Sounds good to me!  ;-)

> >>>  static struct rcu_torture_ops rcu_ops = {
> >>>  	.init = NULL,
> >>>  	.cleanup = NULL,
> >>> @@ -267,7 +334,9 @@ static struct rcu_torture_ops rcu_ops = 
> >>>  	.completed = rcu_torture_completed,
> >>>  	.deferredfree = rcu_torture_deferred_free,
> >>>  	.sync = synchronize_rcu,
> >>> -	.stats = NULL,
> >>> +	.preemptstart = rcu_preempt_start,
> >>> +	.preemptend = rcu_preempt_end,
> >>> +	.stats = rcu_preempt_stats,
> >>>  	.name = "rcu"
> >>>  };
> >>>  
> >>> @@ -306,6 +375,8 @@ static struct rcu_torture_ops rcu_sync_o
> >>>  	.completed = rcu_torture_completed,
> >>>  	.deferredfree = rcu_sync_torture_deferred_free,
> >>>  	.sync = synchronize_rcu,
> >>> +	.preemptstart = NULL,
> >>> +	.preemptend = NULL,
> >>>  	.stats = NULL,
> >>>  	.name = "rcu_sync"
> >>>  };
> >> Much like other common structures such as struct file_operations, no need to
> >> explicitly specify members as NULL here; any member you don't specify will get
> >> a NULL value.  That avoids the need to update every use of this structure
> >> whenever you add a new member used by only some of them.
> > 
> > Untrusting, aren't I?  ;-) 
> 
> Heh.  I have that problem as well; I always hestitate to trust the compiler to
> initialize values.
> 
> > I removed all the "= NULL" entries.
> 
> Thanks.
> 
> >>> @@ -856,6 +935,8 @@ rcu_torture_cleanup(void)
> >>>  		kthread_stop(stats_task);
> >>>  	}
> >>>  	stats_task = NULL;
> >>> +	if (cur_ops->preemptend != NULL)
> >> if (cur_ops->preemptend) would work as well.
> > 
> > True, though again there is a lot of existing "!= NULL" in this file
> > and elsewhere.  Many thousands of them through the kernel.  ;-)
> 
> As before, don't worry about it for this patch then.
> 
> > I will run this through the mill and repost.

But with the new kernel parameter this time.  ;-)

							Thanx, Paul
