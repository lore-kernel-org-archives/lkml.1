Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXF2QwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXF2QwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXF2QwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:52:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:36554 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXF2QwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:52:16 -0400
Date: Fri, 29 Jun 2007 20:52:47 +0400
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
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629165247.GA457@tv-sign.ru>
References: <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <20070629155116.GA422@tv-sign.ru> <20070629162144.GA17709@ms2.inr.ac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629162144.GA17709@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Alexey Kuznetsov wrote:
> 
> > If I understand correctly, this is because tasklet_head.list is protected
> > by local_irq_save(), and t could be scheduled on another CPU, so we just
> > can't steal it, yes?
> 
> Yes. All that code is written to avoid synchronization as much as possible.

Thanks!

> 
> > If we use worqueues, we can change the semantics of tasklet_kill() so
> > that it really cancels an already scheduled tasklet.
> > 
> > The question is: would it be the wrong/good change?
> 
> If it does not add another usec to tasklet_schedule(), it would be good.

No, it won't slowdown tasklet_schedule(). Instead it will speedup tasklet_kill.


Steven, unless you have some objections, could you change tasklet_kill() ?

> +static inline void tasklet_kill(struct tasklet_struct *t)
>  {
> -       return test_bit(TASKLET_STATE_SCHED, &t->state);
> +       flush_workqueue(ktaskletd_wq);
>  }

Just change flush_workqueue(ktaskletd_wq) to cancel_work_sync(t-work).

Oleg.

