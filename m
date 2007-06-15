Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbXFOVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbXFOVv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbXFOVvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:51:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58619 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426AbXFOVvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:51:41 -0400
Subject: Re: [PATCH -rt] Fix TASKLET_STATE_SCHED WARN_ON()
From: john stultz <johnstul@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070615155231.GA345@tv-sign.ru>
References: <20070615155231.GA345@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 14:51:11 -0700
Message-Id: <1181944271.5998.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 19:52 +0400, Oleg Nesterov wrote:
> john stultz wrote:
> >
> > The following additional patch should correct this issue. Although since
> > we weren't actually hitting it, the issue is a bit theoretical, so I've
> > not been able to prove it really fixes anything.
> 
> Could you please look at the message below? I sent it privately near a month
> ago, but I think these problems are not fixed yet.

Hmm. Maybe you sent it to others on the cc list, as I can't find it in
my box. But apologies anyway.


> ---------------------------------------------------------------------------
> 
> > +__tasklet_action(struct softirq_action *a, struct tasklet_struct *list)
> > +{
> > +	int loops = 1000000;
> >  
> >  	while (list) {
> >  		struct tasklet_struct *t = list;
> >  
> >  		list = list->next;
> > +		/*
> > +		 * Should always succeed - after a tasklist got on the
> > +		 * list (after getting the SCHED bit set from 0 to 1),
> > +		 * nothing but the tasklet softirq it got queued to can
> > +		 * lock it:
> > +		 */
> > +		if (!tasklet_trylock(t)) {
> > +			WARN_ON(1);
> > +			continue;
> > +		}
> > +
> > +		t->next = NULL;
> > +
> > +		/*
> > +		 * If we cannot handle the tasklet because it's disabled,
> > +		 * mark it as pending. tasklet_enable() will later
> > +		 * re-schedule the tasklet.
> > +		 */
> > +		if (unlikely(atomic_read(&t->count))) {
> > +out_disabled:
> > +			/* implicit unlock: */
> > +			wmb();
> > +			t->state = TASKLET_STATEF_PENDING;
> 
> What if tasklet_enable() happens just before this line ?
> 
> After the next schedule_tasklet() we have all bits set: SCHED, RUN, PENDING.
> The next invocation of __tasklet_action() clears SCHED, but tasklet_tryunlock()
> below can never succeed because of PENDING.

Yep. I've only been focusing on races in schedule/action, as I've been
hunting issues w/ rcu. But I'll agree that the other state changes look
problematic. I know Paul McKenney was looking at some of the other state
changes and was seeing some potential problems as well.

thanks
-john

