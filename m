Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXJEMW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXJEMW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXJEMWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:22:19 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:45889 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbXJEMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:22:18 -0400
Date: Fri, 5 Oct 2007 08:21:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] RCU torture update for preemption
In-Reply-To: <20071005033458.GA23372@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0710050813580.20859@gandalf.stny.rr.com>
References: <1191445191.11881.33.camel@localhost.localdomain>
 <20071005033458.GA23372@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Thu, 4 Oct 2007, Paul E. McKenney wrote:

> On Wed, Oct 03, 2007 at 04:59:51PM -0400, Steven Rostedt wrote:
> >
> > PS. I got rid of your rcu_preeempt_task for rcu_preempt_tasks ;-)
> >
> > (No the above is _not_ a typo)
>
> :-/

I thought it was some mind bender thing ;-)

>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >
> > Index: linux-2.6.23-rc9-rt1/kernel/rcutorture.c
> > ===================================================================
> > --- linux-2.6.23-rc9-rt1.orig/kernel/rcutorture.c
> > +++ linux-2.6.23-rc9-rt1/kernel/rcutorture.c
> > @@ -54,6 +54,7 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck
> >
> >  static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
> >  static int nfakewriters = 4;	/* # fake writer threads */
> > +static int npreempthogs = -1; 	/* # preempt hogs to run (defaults to ncpus-1) or 1 */
> >  static int stat_interval;	/* Interval between stats, in seconds. */
> >  				/*  Defaults to "only at end of test". */
> >  static int verbose;		/* Print more debug info. */
> > @@ -90,9 +91,11 @@ MODULE_PARM_DESC(torture_type, "Type of
> >  static char printk_buf[4096];
> >
> >  static int nrealreaders;
> > +static int nrealpreempthogs;
>
> I made the above be a module parameter.  This OK?

That is definitely OK. I simply forgot to do it myself.

> >  static int rcu_preempt_stats(char *page)
> > @@ -613,10 +634,20 @@ rcu_torture_writer(void *arg)
> >  static int
> >  rcu_torture_fakewriter(void *arg)
> >  {
> > +	struct sched_param sp;
> > +	long id = (long) arg;
> > +	int err;
> >  	DEFINE_RCU_RANDOM(rand);
> >
> >  	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
> > -	set_user_nice(current, 19);
> > +	/*
> > +	 * Set up at a higher prio than the readers.
> > +	 */
> > +	sp.sched_priority = 1 + id;
> > +	err = sched_setscheduler(current, SCHED_RR, &sp);
> > +	if (err != 0)
> > +		printk(KERN_ALERT "rcu_torture_writer() priority err: %d\n",
> > +		       err);
>
> The idea here is to force inheritance, to force the writer to continue
> pushing grace periods even when the hogs are running, or both?

The idea is to push inheritance. As my method of RCU priority boosting
has the readers inherit the priority of synchronize_rcu caller. If the
caller is of lower priority than the hog, then it doesn't make much sense,
since nothing will happen. I'm assuming that RT system designers know what
they are doing when setting up high priority tasks. If they starve RCU
grace periods, it's their own fault.

>
> >  	do {
> >  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> > @@ -849,9 +880,11 @@ rcu_torture_print_module_parms(char *tag
> >  {
> >  	printk(KERN_ALERT "%s" TORTURE_FLAG
> >  		"--- %s: nreaders=%d nfakewriters=%d "
> > +	        "npreempthogs=%d "
> >  		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
> >  		"shuffle_interval=%d preempt_torture=%d\n",
> >  		torture_type, tag, nrealreaders, nfakewriters,
> > +		nrealpreempthogs,
> >  		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
> >  		preempt_torture);
> >  }
> > @@ -925,7 +958,7 @@ rcu_torture_cleanup(void)
> >  static int __init
> >  rcu_torture_init(void)
> >  {
> > -	int i;
> > +	long i;
> >  	int cpu;
> >  	int firsterr = 0;
> >  	static struct rcu_torture_ops *torture_ops[] =
> > @@ -953,6 +986,12 @@ rcu_torture_init(void)
> >  	rcu_torture_print_module_parms("Start of test");
> >  	fullstop = 0;
> >
> > +	if (npreempthogs >= 0)
> > +		nrealpreempthogs = npreempthogs;
> > +	else
> > +		nrealpreempthogs = num_online_cpus() == 1 ? 1 :
> > +			num_online_cpus() - 1;
>
> OK -- the idea here is to leave at least one CPU to respond to keyboard
> and mouse?  I end up with all the readers getting shoved to the left-over

Yeah, I was nervious about locking up the test, and being able to do
anything.

> CPU.  I am experimenting with ways of synchronizing the hogs and also
> allowing synchronized idle time...

Thanks, I'd like to have a semi hog on each CPU.


PS. I've incorporated this and my version of the RCU Preempt Boost into
the latest -rt patch. It's labeled as experimental so we can always pull
it. Have you had a chance to look at some of my changes.

I'll be going out of town today so I wont be answering emails till Monday.

-- Steve

