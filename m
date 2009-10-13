Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZJMRBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZJMRBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760566AbZJMRBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:01:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36236 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZJMRBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:01:12 -0400
Date: Tue, 13 Oct 2009 10:00:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
Message-ID: <20091013170022.GA6782@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091009224954.GA26516@linux.vnet.ibm.com> <4AD42FF5.2080109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD42FF5.2080109@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:44:53PM +0800, Lai Jiangshan wrote:
> Again. trivial code-beautifying except the last one.
> 
> Paul E. McKenney wrote:
> 
> [...]
> 
> > +
> > +/* Global control variables for rcupdate callback mechanism. */
> > +struct rcu_ctrlblk {
> > +	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
> > +	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
> > +	struct rcu_head **curtail;	/* ->next pointer of last CB. */
> > +};
> > +
> > +extern struct rcu_ctrlblk rcu_ctrlblk;
> > +extern struct rcu_ctrlblk rcu_bh_ctrlblk;
> 
> Since rcu_batches_completed() returns a constant, this piece of
> code is not needed here. We can move it to rcutiny.c.

Good point, moved.  And removed the "extern" declarations.

> and remove "EXPORT_SYMBOL_GPL(rcu_ctrlblk);" &
> "EXPORT_SYMBOL_GPL(rcu_bh_ctrlblk);".

Fixed, thank you!  And marked them "static".

> [...]
> 
> > +/* extern void rcu_restart_cpu(int cpu); */
> > +
> 
> redundant comments.

Good eyes!  I believe I have long since proven to myself that
rcu_restart_cpu() is no longer used.  :-)

> [...]
> 
> > +
> > +static inline int rcu_pending(int cpu)
> > +{
> > +	return 1;
> > +}
> 
> It seems that no one use it.

Indeed!  Removed.

> [...]
> 
> > +/* Definition for rcupdate control block. */
> > +struct rcu_ctrlblk rcu_ctrlblk = {
> > +	.rcucblist = NULL,
> > +	.donetail = &rcu_ctrlblk.rcucblist,
> > +	.curtail = &rcu_ctrlblk.rcucblist,
> > +};
> > +EXPORT_SYMBOL_GPL(rcu_ctrlblk);
> 
> remove "EXPORT_SYMBOL_GPL(rcu_ctrlblk);"

Done, above.

> > +struct rcu_ctrlblk rcu_bh_ctrlblk = {
> > +	.rcucblist = NULL,
> > +	.donetail = &rcu_bh_ctrlblk.rcucblist,
> > +	.curtail = &rcu_bh_ctrlblk.rcucblist,
> > +};
> > +EXPORT_SYMBOL_GPL(rcu_bh_ctrlblk);
> 
> remove "EXPORT_SYMBOL_GPL(rcu_bh_ctrlblk);"

Done, above.

> > +
> > +#ifdef CONFIG_NO_HZ
> > +
> > +static long rcu_dynticks_nesting = 1;
> > +
> > +/*
> > + * Enter dynticks-idle mode, which is an extended quiescent state
> > + * if we have fully entered that mode (i.e., if the new value of
> > + * dynticks_nesting is zero).
> > + */
> > +void rcu_enter_nohz(void)
> > +{
> > +	if (--rcu_dynticks_nesting == 0)
> > +		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
> > +}
> > +
> > +/*
> > + * Exit dynticks-idle mode, so that we are no longer in an extended
> > + * quiescent state.
> > + */
> > +void rcu_exit_nohz(void)
> > +{
> > +	rcu_dynticks_nesting++;
> > +}
> > +
> > +#endif /* #ifdef CONFIG_NO_HZ */
> 
> It's an old issue.
> It's not only about RCUTINY, it's also about other rcu implementations:
> 
> rcu_enter_nohz()/rcu_exit_nohz() are not called in pairs.
> 
> irq_exit() calls tick_nohz_stop_sched_tick() which calls rcu_enter_nohz(),
> where is the corresponding rcu_exit_nohz()?
> (or tick_nohz_restart_sched_tick())?

The tick_nohz_restart_sched_tick() function is called from the various
per-architecture cpu_idle() functions (or default_idle() or whatever
name that the architecture uses).  For example, in:

	arch/x86/kernel/process_64.c

the cpu_idle() function invokes tick_nohz_restart_sched_tick() just
before invoking schedule() to exit the idle loop.

And, as you say, tick_nohz_restart_sched_tick() invokes rcu_exit_nohz().

							Thanx, Paul
