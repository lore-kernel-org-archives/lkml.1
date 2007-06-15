Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbXFOX7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbXFOX7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbXFOX7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:59:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:46660 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbXFOX7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:59:14 -0400
Date: Sat, 16 Jun 2007 03:59:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] Fix TASKLET_STATE_SCHED WARN_ON()
Message-ID: <20070615235912.GA103@tv-sign.ru>
References: <20070615155231.GA345@tv-sign.ru> <1181944271.5998.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181944271.5998.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, john stultz wrote:
>
> On Fri, 2007-06-15 at 19:52 +0400, Oleg Nesterov wrote:
> > 
> > Could you please look at the message below? I sent it privately near a month
> > ago, but I think these problems are not fixed yet.
> 
> Hmm. Maybe you sent it to others on the cc list, as I can't find it in
> my box. But apologies anyway.

checking my mbox... Oops, you are right, sorry!

> > > +		if (unlikely(atomic_read(&t->count))) {
> > > +out_disabled:
> > > +			/* implicit unlock: */
> > > +			wmb();
> > > +			t->state = TASKLET_STATEF_PENDING;
> > 
> > What if tasklet_enable() happens just before this line ?
> > 
> > After the next schedule_tasklet() we have all bits set: SCHED, RUN, PENDING.
> > The next invocation of __tasklet_action() clears SCHED, but tasklet_tryunlock()
> > below can never succeed because of PENDING.
> 
> Yep. I've only been focusing on races in schedule/action, as I've been
> hunting issues w/ rcu. But I'll agree that the other state changes look
> problematic. I know Paul McKenney was looking at some of the other state
> changes and was seeing some potential problems as well.

OK, thanks. But doesn't this mean your 2-nd patch is questionable?

> +               } else {
> +                       /* This is subtle. If we hit the corner case above
> +                        * It is possible that we get preempted right here,
> +                        * and another task has successfully called
> +                        * tasklet_schedule(), then this function, and
> +                        * failed on the trylock. Thus we must be sure
> +                        * before releasing the tasklet lock, that the
> +                        * SCHED_BIT is clear. Otherwise the tasklet
> +                        * may get its SCHED_BIT set, but not added to the
> +                        * list
> +                        */
> +                       if (!tasklet_tryunlock(t))
> +                               goto again;

Again, tasklet_tryunlock() can fail because _PENDING was set by __tasklet_action().
In that case __tasklet_common_schedule() goes to the endless loop, no?

Oleg.

