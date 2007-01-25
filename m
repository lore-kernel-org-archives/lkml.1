Return-Path: <linux-kernel-owner+w=401wt.eu-S965480AbXAYSDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbXAYSDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965459AbXAYSDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:03:31 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47219 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965383AbXAYSDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:03:30 -0500
Date: Thu, 25 Jan 2007 10:01:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to rcutorture
Message-ID: <20070125180158.GC1705@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com> <20070125022338.GB22540@linux.vnet.ibm.com> <45B86E88.6020209@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B86E88.6020209@kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 12:47:04AM -0800, Josh Triplett wrote:
> Paul E. McKenney wrote:
> > This patch adds an optional preemption kernel thread to the rcutorture
> > tests.  This thread sets itself to a low RT priority and chews up
> > CPU in 10-second bursts, verifying that grace periods progress during
> > this 10-second interval.  This has thus far passed about 30 hours of
> > RCU torture testing on a 4-CPU (a pair of 2-CPU dies) 64-bit Xeon 
> > system.
> > 
> > I am experimenting with more-vicious tests, but extra viciousness thus
> > far comes at the expense of grotesque code.
> 
> Overall, the new feature seems like a good idea, and it should exercise the
> new RCU boosting code.  Some comments below.

Thank you for the review!!!

> One major item: this new test feature really needs a new module parameter to
> enable or disable it.

CONFIG_PREEMPT_RCU_BOOST is the parameter -- if not set, then no test.
This parameter is provided by the accompanying RCU-boost patch.

> > diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rcutorture.c linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c
> > --- linux-2.6.20-rc4-rt1/kernel/rcutorture.c	2007-01-09 10:59:54.000000000 -0800
> > +++ linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c	2007-01-23 11:27:49.000000000 -0800
> > @@ -194,6 +194,8 @@ struct rcu_torture_ops {
> >  	int (*completed)(void);
> >  	void (*deferredfree)(struct rcu_torture *p);
> >  	void (*sync)(void);
> > +	void (*preemptstart)(void);
> > +	void (*preemptend)(void);
> >  	int (*stats)(char *page);
> >  	char *name;
> >  };
> > @@ -258,6 +260,71 @@ static void rcu_torture_deferred_free(st
> >  	call_rcu(&p->rtort_rcu, rcu_torture_cb);
> >  }
> >  
> > +#ifndef CONFIG_PREEMPT_RCU_BOOST
> > +static void rcu_preempt_start(void) { }
> > +static void rcu_preempt_end(void) { }
> > +static int rcu_preempt_stats(char *page) { return 0; }
> > +#else /* #ifndef CONFIG_PREEMPT_RCU_BOOST */
> > +
> > +static struct task_struct *rcu_preeempt_task;
> > +static long rcu_torture_preempt_errors = 0;
> 
> Might as well make this an unsigned long; negative values wouldn't make sense.

Good point, fixed.

> > +static int rcu_torture_preempt(void *arg)
> > +{
> > +	int completedstart;
> > +	time_t gcstart;
> > +	struct sched_param sp;
> > +
> > +	sp.sched_priority = MAX_RT_PRIO - 1;
> > +	sched_setscheduler(current, SCHED_RR, &sp);
> > +	current->flags |= PF_NOFREEZE;
> > +
> > +	do {
> > +		completedstart = rcu_torture_completed();
> > +		gcstart = xtime.tv_sec;
> > +		while ((xtime.tv_sec - gcstart < 10) &&
> > +		       (rcu_torture_completed() == completedstart))
> > +			cond_resched();
> > +		if (rcu_torture_completed() == completedstart)
> > +			rcu_torture_preempt_errors++;
> > +		schedule_timeout_interruptible(shuffle_interval * HZ);
> 
> Why call schedule_timeout_interruptible here without actually handling
> interruptions?  So that you can send it a signal to cause the shuffle early?

It allows you to kill the process in order to get the module unload to
happen more quickly in case someone specified an overly long interval.
But now that you mention this, a simple one-second sleep is probably
appropriate here.

> > +	} while (!kthread_should_stop());
> > +	return NULL;
> > +}
> > +
> > +static void rcu_preempt_start(void)
> > +{
> > +	rcu_preeempt_task = kthread_run(rcu_torture_preempt, NULL,
> > +					"rcu_torture_preempt");
> > +	if (IS_ERR(rcu_preeempt_task)) {
> > +		VERBOSE_PRINTK_ERRSTRING("Failed to create preempter");
> 
> This ought to include the errno value, PTR_ERR(rcu_preempt_task).

Good point -- what I should do is return this value so that
rcu_torture_init() can return it, failing the module-load process
and unwinding.

> > +		rcu_preeempt_task = NULL;
> > +	}
> > +}
> > +
> > +static void rcu_preempt_end(void)
> > +{
> > +	if (rcu_preeempt_task != NULL) {
> 
> if (rcu_preempt_task) would work just as well here.

True, but was being consistent with usage elsewhere in this file.

> > +		VERBOSE_PRINTK_STRING("Stopping rcu_preempt task");
> > +		kthread_stop(rcu_preeempt_task);
> > +	}
> > +	rcu_preeempt_task = NULL;
> > +}
> > +
> > +static int rcu_preempt_stats(char *page) {
> > +	int cnt = 0;
> > +
> > +	cnt += sprintf(&page[cnt],
> > +		       "Preemption stalls: %ld\n", rcu_torture_preempt_errors);
> > +	return (cnt);
> > +}
> 
> How about just:
> return sprintf(page, ...);
> ?

Good point.

> Also, if you decide to make rcu_torture_preempt_errors an unsigned long as
> suggested above, this should use %lu.

Done.

> > +#endif /* #else #ifndef CONFIG_PREEMPT_RCU_BOOST */
> > +
> > +static void rcu_preemptstart(void)
> > +{
> > +	
> > +}
> > +
> 
> This looks like a bit of stray code.

Yep, good eyes!  Deleted.

> >  static struct rcu_torture_ops rcu_ops = {
> >  	.init = NULL,
> >  	.cleanup = NULL,
> > @@ -267,7 +334,9 @@ static struct rcu_torture_ops rcu_ops = 
> >  	.completed = rcu_torture_completed,
> >  	.deferredfree = rcu_torture_deferred_free,
> >  	.sync = synchronize_rcu,
> > -	.stats = NULL,
> > +	.preemptstart = rcu_preempt_start,
> > +	.preemptend = rcu_preempt_end,
> > +	.stats = rcu_preempt_stats,
> >  	.name = "rcu"
> >  };
> >  
> > @@ -306,6 +375,8 @@ static struct rcu_torture_ops rcu_sync_o
> >  	.completed = rcu_torture_completed,
> >  	.deferredfree = rcu_sync_torture_deferred_free,
> >  	.sync = synchronize_rcu,
> > +	.preemptstart = NULL,
> > +	.preemptend = NULL,
> >  	.stats = NULL,
> >  	.name = "rcu_sync"
> >  };
> 
> Much like other common structures such as struct file_operations, no need to
> explicitly specify members as NULL here; any member you don't specify will get
> a NULL value.  That avoids the need to update every use of this structure
> whenever you add a new member used by only some of them.

Untrusting, aren't I?  ;-) 

I removed all the "= NULL" entries.

> > @@ -370,6 +441,8 @@ static struct rcu_torture_ops rcu_bh_ops
> >  	.completed = rcu_bh_torture_completed,
> >  	.deferredfree = rcu_bh_torture_deferred_free,
> >  	.sync = rcu_bh_torture_synchronize,
> > +	.preemptstart = NULL,
> > +	.preemptend = NULL,
> >  	.stats = NULL,
> >  	.name = "rcu_bh"
> >  };
> 
> Likewise.
> 
> > @@ -383,6 +456,8 @@ static struct rcu_torture_ops rcu_bh_syn
> >  	.completed = rcu_bh_torture_completed,
> >  	.deferredfree = rcu_sync_torture_deferred_free,
> >  	.sync = rcu_bh_torture_synchronize,
> > +	.preemptstart = NULL,
> > +	.preemptend = NULL,
> >  	.stats = NULL,
> >  	.name = "rcu_bh_sync"
> >  };
> 
> Likewise.
> 
> > @@ -464,6 +539,8 @@ static struct rcu_torture_ops srcu_ops =
> >  	.completed = srcu_torture_completed,
> >  	.deferredfree = rcu_sync_torture_deferred_free,
> >  	.sync = srcu_torture_synchronize,
> > +	.preemptstart = NULL,
> > +	.preemptend = NULL,
> >  	.stats = srcu_torture_stats,
> >  	.name = "srcu"
> >  };
> 
> Likewise.
> 
> > @@ -502,6 +579,8 @@ static struct rcu_torture_ops sched_ops 
> >  	.completed = sched_torture_completed,
> >  	.deferredfree = rcu_sync_torture_deferred_free,
> >  	.sync = sched_torture_synchronize,
> > +	.preemptstart = NULL,
> > +	.preemptend = NULL,
> >  	.stats = NULL,
> >  	.name = "sched"
> 
> Likewise.
> 
> > @@ -856,6 +935,8 @@ rcu_torture_cleanup(void)
> >  		kthread_stop(stats_task);
> >  	}
> >  	stats_task = NULL;
> > +	if (cur_ops->preemptend != NULL)
> 
> if (cur_ops->preemptend) would work as well.

True, though again there is a lot of existing "!= NULL" in this file
and elsewhere.  Many thousands of them through the kernel.  ;-)

> > @@ -997,6 +1078,8 @@ rcu_torture_init(void)
> >  			goto unwind;
> >  		}
> >  	}
> > +	if (cur_ops->preemptstart != NULL)
> 
> Likewise.

I will run this through the mill and repost.

							Thanx, Paul
