Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbYHHUa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbYHHUa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYHHUaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:30:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52915 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYHHUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:30:51 -0400
Date: Fri, 8 Aug 2008 13:30:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, rostedt@goodmis.org
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080808203049.GG6760@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1206382547.6437.131.camel@lappy> <20080324115738.85c72bb5.akpm@linux-foundation.org> <1218202249.8625.106.camel@twins> <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org> <1218215454.8625.133.camel@twins> <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808121428.646a8b3c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:14:28PM -0700, Andrew Morton wrote:
> On Fri, 08 Aug 2008 20:14:28 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> >  void wake_up_klogd(void)
> >  {
> > -	if (!oops_in_progress && waitqueue_active(&log_wait))
> > -		wake_up_interruptible(&log_wait);
> > +	unsigned long flags;
> > +	struct klogd_wakeup_state *kws;
> > +
> > +	if (!waitqueue_active(&log_wait))
> > +		return;
> > +
> > +	local_irq_save(flags);
> > +	kws = &__get_cpu_var(kws);
> > +	if (!kws->pending) {
> > +		kws->pending = 1;
> > +		call_rcu(&kws->head, __wake_up_klogd);
> > +	}
> > +	local_irq_restore(flags);
> >  }
> 
> Note that kernel/rcupreempt.c's flavour of call_rcu() takes
> RCU_DATA_ME().lock, so there are still code sites from which a printk
> can deadlock.  Only now, it is config-dependent.

The RCU callbacks are (and must be) invoked without holding any RCU
locks, so printk()s in RCU callbacks are perfectly permissible.  It would
not be -that- hard to eliminate the lock in call_rcu(), but yeccch...
It would be far easier to debug RCU without the benefit printk()s than
to deal with a preemptable RCU implementation that was based solely on
atomic instructions!!!

> >From a quick look it appears that large amounts of kernel/rcupreempt.c
> are now a printk-free zone.

The only printk() is in preemptable RCU's rcu_init() function, whose
only purpose is to mark the dmesg appropriately, and which should not
be a problem.

And that would be because I do a fair amount of prototyping and debugging
in user space, where one instead uses printf().  ;-)

							Thanx, Paul
