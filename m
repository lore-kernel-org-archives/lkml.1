Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbXLNQNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbXLNQNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933429AbXLNQNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:13:05 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57154 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187AbXLNQNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:13:01 -0500
Date: Fri, 14 Dec 2007 08:12:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 2/6] Preempt-RCU: Reorganize RCU code into rcuclassic.c and rcupdate.c
Message-ID: <20071214161214.GB14177@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071213170348.GA25981@in.ibm.com> <20071213171508.GC25981@in.ibm.com> <x7fxy572jh.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x7fxy572jh.fsf@saeurebad.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 03:51:14PM +0100, Johannes Weiner wrote:
> Hi,
> 
> Gautham R Shenoy <ego@in.ibm.com> writes:
> 
> > diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> > new file mode 100644
> > index 0000000..11c16aa
> > --- /dev/null
> > +++ b/kernel/rcuclassic.c
> > +/**
> > + * call_rcu - Queue an RCU callback for invocation after a grace period.
> > + * @head: structure to be used for queueing the RCU updates.
> > + * @func: actual update function to be invoked after the grace period
> > + *
> > + * The update function will be invoked some time after a full grace
> > + * period elapses, in other words after all currently executing RCU
> > + * read-side critical sections have completed.  RCU read-side critical
> > + * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
> > + * and may be nested.
> > + */
> > +void call_rcu(struct rcu_head *head,
> > +				void (*func)(struct rcu_head *rcu))
> > +{
> > +	unsigned long flags;
> > +	struct rcu_data *rdp;
> > +
> > +	head->func = func;
> > +	head->next = NULL;
> > +	local_irq_save(flags);
> > +	rdp = &__get_cpu_var(rcu_data);
> > +	*rdp->nxttail = head;
> > +	rdp->nxttail = &head->next;
> > +	if (unlikely(++rdp->qlen > qhimark)) {
> > +		rdp->blimit = INT_MAX;
> > +		force_quiescent_state(rdp, &rcu_ctrlblk);
> > +	}
> > +	local_irq_restore(flags);
> > +}
> > +EXPORT_SYMBOL_GPL(call_rcu);
> > +
> > +/**
> > + * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
> > + * @head: structure to be used for queueing the RCU updates.
> > + * @func: actual update function to be invoked after the grace period
> > + *
> > + * The update function will be invoked some time after a full grace
> > + * period elapses, in other words after all currently executing RCU
> > + * read-side critical sections have completed. call_rcu_bh() assumes
> > + * that the read-side critical sections end on completion of a softirq
> > + * handler. This means that read-side critical sections in process
> > + * context must not be interrupted by softirqs. This interface is to be
> > + * used when most of the read-side critical sections are in softirq context.
> > + * RCU read-side critical sections are delimited by rcu_read_lock() and
> > + * rcu_read_unlock(), * if in interrupt context or rcu_read_lock_bh()
> > + * and rcu_read_unlock_bh(), if in process context. These may be nested.
> > + */
> > +void call_rcu_bh(struct rcu_head *head,
> > +				void (*func)(struct rcu_head *rcu))
> > +{
> > +	unsigned long flags;
> > +	struct rcu_data *rdp;
> > +
> > +	head->func = func;
> > +	head->next = NULL;
> > +	local_irq_save(flags);
> > +	rdp = &__get_cpu_var(rcu_bh_data);
> > +	*rdp->nxttail = head;
> > +	rdp->nxttail = &head->next;
> > +
> > +	if (unlikely(++rdp->qlen > qhimark)) {
> > +		rdp->blimit = INT_MAX;
> > +		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
> > +	}
> > +
> > +	local_irq_restore(flags);
> > +}
> > +EXPORT_SYMBOL_GPL(call_rcu_bh);
> 
> Those two functions are identical beside the difference of `rcu_data'
> <-> `rcu_bh_data' and `rcu_ctrlblk' <-> `rcu_bh_ctrlblk'.
> 
> Is there a way to collapse the code into one helper function or would
> that effect performance too much?

This code is performance critical, but on the other hand, perhaps gcc
has gotten smarter in the years since this was written.  (This patch is
just moving this code from one file to another, rather than writing it
from scratch.)  Would current gcc implementations be able to do the
inlining required?

							Thanx, Paul
