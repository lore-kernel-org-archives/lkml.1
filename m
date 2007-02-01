Return-Path: <linux-kernel-owner+w=401wt.eu-S964806AbXBACcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbXBACcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXBACcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:32:01 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50615 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbXBACcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:32:01 -0500
Date: Wed, 31 Jan 2007 18:31:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, josh@freedesktop.org,
       billh@gnuppy.monkey.org, nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to rcutorture
Message-ID: <20070201023149.GV2574@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070201012136.GA21770@linux.vnet.ibm.com> <20070201012653.GB22922@linux.vnet.ibm.com> <1170295936.32500.1.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170295936.32500.1.camel@nigel.suspend2.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:12:16PM +1100, Nigel Cunningham wrote:
> Hi Paul.
> 
> On Wed, 2007-01-31 at 17:26 -0800, Paul E. McKenney wrote:
> > This patch adds an optional preemption kernel thread to the rcutorture
> > tests.  This thread sets itself to a low RT priority and chews up CPU
> > in 10-second bursts, verifying that grace periods progress during this
> > 10-second interval.  Passes RCU torture testing on a 4-CPU (a pair of
> > 2-CPU dies) 64-bit Xeon system.
> 
> [...]
> 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > +static int rcu_torture_preempt(void *arg)
> > +{
> > +	int completedstart;
> > +	int err;
> > +	time_t gcstart;
> > +	struct sched_param sp;
> > +
> > +	sp.sched_priority = MAX_RT_PRIO - 1;
> > +	err = sched_setscheduler(current, SCHED_RR, &sp);
> > +	if (err != 0)
> > +		printk(KERN_ALERT "rcu_torture_preempt() priority err: %d\n",
> > +		       err);
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
> > +		schedule_timeout_interruptible(HZ);
> > +	} while (!kthread_should_stop());
> > +	return 0;
> > +}
> 
> Does it need to be NOFREEZE? I would think that it should be frozen
> during a suspend/hibernate.

Good to hear from you, Nigel!

Should indeed be OK to freeze during suspend/hibernate.  Will my
schedule_timeout_interruptible() be sufficient to allow the freeze
to happen, or do I need to add an explicit try_to_freeze()?

Ah, and I probably need to use the same trick that mtd_blktrans_thread()
does to avoid having all my sleeps killed of by an errant signal:

	spin_lock_irq(&current->sighand->siglock);
	sigfillset(&current->blocked);
	recalc_sigpending();
	spin_unlock_irq(&current->sighand->siglock);

Or is such paranoia unnecessary?

							Thanx, Paul
