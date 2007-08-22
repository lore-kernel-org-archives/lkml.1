Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXHVUYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXHVUYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763204AbXHVUYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:24:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36475 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762043AbXHVUYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:24:30 -0400
Subject: Re: [PATCH RFC] Priority boosting for preemptible RCU
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de
In-Reply-To: <20070822124340.16a891f2.akpm@linux-foundation.org>
References: <20070822190254.GA1135@linux.vnet.ibm.com>
	 <20070822124340.16a891f2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 13:23:55 -0700
Message-Id: <1187814235.3223.43.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 12:43 -0700, Andrew Morton wrote:
> On Wed, 22 Aug 2007 12:02:54 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > This patch is a forward-port of RCU priority boosting (described in
> > http://lwn.net/Articles/220677/).  It applies to 2.6.22 on top of
> > the patches sent in the http://lkml.org/lkml/2007/8/7/276 series and
> > the hotplug patch (http://lkml.org/lkml/2007/8/17/262).  Passes several
> > hours of rcutorture on x86_64 and POWER, so OK for experimentation but
> > not ready for inclusion.
> 
> It'd be nice to have a brief summary of why we might want this code in Linux.

RCU reclamation callbacks have to wait for all current RCU readers to
finish.  With preemptible RCU read-side critical sections, other tasks
may block an RCU reader for an arbitrarily long time, and thus
indirectly block the execution of memory reclamation callbacks
(including anything using synchronize_rcu), leading to an OOM situation.
This patch adds priority boosting of RCU readers to avoid this scenario.

> > +#ifdef CONFIG_PREEMPT_RCU_BOOST
> 
> Do we really need this?  Why not just enable the feature all the time?

It involves both space and computation overhead, which you might want to
avoid if you don't need it.  That said, it might make sense to turn it
on by default.

> > +config PREEMPT_RCU_BOOST_STATS_INTERVAL
> 
> Four new config options?  Sob.  Zero would be preferable.

I only saw three new options.

At a minimum, having the debug toggle as a config option would make
debugging this significantly simpler.

> > +	struct list_head rbs_toboost;
> > +	struct list_head rbs_boosted;
> > +	unsigned long rbs_blocked;
> > +	unsigned long rbs_boost_attempt;
> > +	unsigned long rbs_boost;
> > +	unsigned long rbs_unlock;
> > +	unsigned long rbs_unboosted;
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> > +	unsigned long rbs_stats[N_RCU_BOOST_DAT_EVENTS][N_RCU_BOOST_STATE];
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> > +};
> > +#define RCU_BOOST_ELEMENTS 4
> > +
> > +int rcu_boost_idx = -1; /* invalid value in case someone uses RCU early. */
> > +DEFINE_PER_CPU(struct rcu_boost_dat, rcu_boost_dat[RCU_BOOST_ELEMENTS]);
> 
> Do these need global scope?

No, neither one does.  They should both become static.

> > +void init_rcu_boost_late(void)
> > +{
> > +
> > +	/* Spawn RCU-boost task. */
> > +
> > +	printk(KERN_INFO "Starting RCU priority booster\n");
> > +	rcu_boost_task = kthread_run(rcu_booster, NULL, "RCU Prio Booster");
> > +	if (IS_ERR(rcu_boost_task)) {
> > +		printk(KERN_ALERT
> > +		       "Unable to create RCU Priority Booster, errno %ld\n",
> > +		       -PTR_ERR(rcu_boost_task));
> > +
> > +		/*
> > +		 * Continue running, but tasks permanently blocked
> > +		 * in RCU read-side critical sections will be able
> > +		 * to stall grace-period processing, potentially
> > +		 * OOMing the machine.
> > +		 */
> 
> I don't think we want to try to struggle along like that.  This thread is a
> piece of core infrastructure: if we couldn't start it then just panic
> rather than trying to run the kernel in unknown and untested regions of
> operation.

In this situation, the kernel would behave precisely as it would with
CONFIG_RCU_BOOST=n.  However, I agree that with CONFIG_RCU_BOOST=y you
would expect to always have priority boosting available, so I think
panic() makes sense here.

- Josh Triplett


