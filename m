Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXF2RJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXF2RJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXF2RJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:09:14 -0400
Received: from mail.screens.ru ([213.234.233.54]:35826 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXF2RJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:09:13 -0400
Date: Fri, 29 Jun 2007 21:09:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew@wil.cx
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629170957.GA467@tv-sign.ru>
References: <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <20070629155116.GA422@tv-sign.ru> <20070629162144.GA17709@ms2.inr.ac.ru> <20070629165247.GA457@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629165247.GA457@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(the email address of Matthew Wilcox looks wrong, changed to matthew@wil.cx)

On 06/29, Oleg Nesterov wrote:
>
> Steven, unless you have some objections, could you change tasklet_kill() ?
> 
> > +static inline void tasklet_kill(struct tasklet_struct *t)
> >  {
> > -       return test_bit(TASKLET_STATE_SCHED, &t->state);
> > +       flush_workqueue(ktaskletd_wq);
> >  }
> 
> Just change flush_workqueue(ktaskletd_wq) to cancel_work_sync(t-work).

Ugh, tasklet_disable() should be changed as well.

> @@ -84,35 +50,35 @@ static inline void tasklet_disable_nosyn
>  static inline void tasklet_disable(struct tasklet_struct *t)
>  {
>         tasklet_disable_nosync(t);
> -       tasklet_unlock_wait(t);
> -       smp_mb();
> -}
> -
> -static inline void tasklet_enable(struct tasklet_struct *t)
> -{
> -       smp_mb__before_atomic_dec();
> -       atomic_dec(&t->count);
> +       flush_workqueue(ktaskletd_wq);
> +       /* flush_workqueue should provide us a barrier */
>  }

Suppose we have the tasklets T1 and T2, both are scheduled on the
same CPU. T1 takes some spinlock LOCK.

Currently it is possible to do

	spin_lock(LOCK);
	disable_tasklet(T2);

With this patch, the above code hangs.


The most simple fix is to use wait_on_work(t->work) instead of
flush_workqueue(). Currently it is static, but we can export it.
This change will speedup tasklet_disable), btw.

A better fix imho is to use cancel_work_sync() again, but this
needs some complications to preserve TASKLET_STATE_PENDING.

This in turn means that cancel_work_sync() should return "int", but
not "void". This change makes sense regardless, I'll try to make a
patch on Sunday.

Oleg.

