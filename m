Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbYHAO6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbYHAO6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYHAO54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:57:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYHAO5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:57:55 -0400
Date: Fri, 1 Aug 2008 10:34:37 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josef Bacik <jbacik@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: high resolution timers, scheduling & sleep granularity
Message-ID: <20080801143437.GA31517@unused.rdu.redhat.com>
References: <4892FC11.4020105@redhat.com> <20080801132537.GB14001@unused.rdu.redhat.com> <1217602211.4684.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217602211.4684.9.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 04:50:11PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-08-01 at 09:25 -0400, Josef Bacik wrote:
> 
> > Index: linux-2.6/fs/jbd/transaction.c
> > ===================================================================
> > --- linux-2.6.orig/fs/jbd/transaction.c
> > +++ linux-2.6/fs/jbd/transaction.c
> 
> > @@ -63,6 +65,32 @@ get_transaction(journal_t *journal, tran
> >  	return transaction;
> >  }
> >  
> > +static void precision_sleep(unsigned long time)
> > +{
> > +	struct hrtimer_sleeper t;
> > +
> > +	hrtimer_init_on_stack(&t.timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
> > +	hrtimer_init_sleeper(&t, current);
> > +	t.timer.expires = ktime_add_ns(ktime_get_real(), time);
> > +
> > +	do {
> > +		set_current_state(TASK_UNINTERRUPTIBLE);
> > +
> > +		hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
> > +		if (!hrtimer_active(&t.timer))
> > +			t.task = NULL;
> > +
> > +		if (likely(t.task))
> > +			schedule();
> > +
> > +		hrtimer_cancel(&t.timer);
> > +	} while (t.task);
> > +
> > +	set_current_state(TASK_RUNNING);
> > +
> > +	destroy_hrtimer_on_stack(&t.timer);
> > +}
> > +
> >  /*
> >   * Handle management.
> >   *
> 
> I was convinced we already had such a creature,. but I guess I was wrong
> as I can't find it ;-)
> 
> Anyway, I'm thinking this function ought to live in kernel/hrtimer.c and
> possibly get renamed to something like hrtimer_sleep_ns() or some such
> (means you can also reuse the do_nanosleep helper in there).
> 
> Also, have you considered the impact on platforms that do not support
> hrtimers, or don't have high resolution clock events available?
>

Not yet :), this is just a proof of concept atm, eventually if I do use hrtimers
I would just fallback to using jiffies if the arch doesn't support hrtimers as
it still gets significantly better performance than what we currently have.
Thanks,

Josef

 
> > Index: linux-2.6/kernel/hrtimer.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/hrtimer.c
> > +++ linux-2.6/kernel/hrtimer.c
> > @@ -1458,6 +1458,7 @@ void hrtimer_init_sleeper(struct hrtimer
> >  	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
> >  #endif
> >  }
> > +EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
> >  
> >  static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
> >  {
> 
> That also gets rid of this export..
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
