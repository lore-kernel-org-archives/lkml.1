Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZFPOzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZFPOzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZFPOze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:55:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZFPOzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:55:33 -0400
Date: Tue, 16 Jun 2009 17:55:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based
	notifier interface
Message-ID: <20090616145502.GA1102@redhat.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37B0BB.3020005@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:48:27AM -0400, Gregory Haskins wrote:
> >>>> +static void _eventfd_notify(struct eventfd_ctx *ctx)
> >>>> +{
> >>>> +	struct eventfd_notifier *en;
> >>>> +	int idx;
> >>>> +
> >>>> +	idx = srcu_read_lock(&ctx->srcu);
> >>>> +
> >>>> +	/*
> >>>> +	 * The goal here is to allow the notification to be preemptible
> >>>> +	 * as often as possible.  We cannot achieve this with the basic
> >>>> +	 * wqh mechanism because it requires the wqh->lock.  Therefore
> >>>> +	 * we have an internal srcu list mechanism of which the wqh is
> >>>> +	 * a client.
> >>>> +	 *
> >>>> +	 * Not all paths will invoke this function in process context.
> >>>> +	 * Callers should check for suitable state before assuming they
> >>>> +	 * can sleep (such as with preemptible()).  Paul McKenney assures
> >>>> +	 * me that srcu_read_lock is compatible with in-atomic, as long as
> >>>> +	 * the code within the critical section is also compatible.
> >>>> +	 */
> >>>> +	list_for_each_entry_rcu(en, &ctx->nh, list)
> >>>> +		en->ops->signal(en);
> >>>> +
> >>>> +	srcu_read_unlock(&ctx->srcu, idx);
> >>>> +}
> >>>> +
> >>>>  /*
> >>>>   * Adds "n" to the eventfd counter "count". Returns "n" in case of
> >>>>   * success, or a value lower then "n" in case of coutner overflow.
> >>>>     
> >>>>         
> >>> This is ugly, isn't it? With CONFIG_PREEMPT=no preemptible() is always false.
> >>>
> >>> Further, to do useful things it might not be enough that you can sleep:
> >>> with iofd you also want to access current task with e.g. copy from user.
> >>>
> >>> Here's an idea: let's pass a flag to ->signal, along the lines of
> >>> signal_is_task, that tells us that it is safe to use current, and add
> >>> eventfd_signal_task() which is the same as eventfd_signal but lets everyone
> >>> know that it's safe to both sleep and use current->mm.
> >>>
> >>> Makes sense?
> >>>   
> >>>       
> >> It does make sense, yes.  What I am not clear on is how would eventfd
> >> detect this state such as to populate such flags, and why cant the
> >> ->signal() CB do the same?
> >>
> >> Thanks Michael,
> >> -Greg
> >>
> >>     
> >
> > eventfd can't detect this state. But the callers know in what context they are.
> > So the *caller* of eventfd_signal_task makes sure of this: if you are in a task,
> > you can call eventfd_signal_task() if not, you must call eventfd_signal.
> >
> >
> >   
> Hmm, this is an interesting idea, but I think it would be problematic in
> real-world applications for the long-term.  For instance, the -rt tree
> and irq-threads .config option in the process of merging into mainline
> changes context types for established code.  Therefore, what might be
> "hardirq/softirq" logic today may execute in a kthread tomorrow.

That's OK, it's always safe to call eventfd_signal: eventfd_signal_task is just
an optimization. I think everyone not in the context of a system call or vmexit
can just call eventfd_signal_task.

>  I
> think its dangerous to try to solve the problem with caller provided
> info:  the caller may be ignorant of its true state.

I assume this wasn't clear enough: the idea is that you only
calls eventfd_signal_task if you know you are on a systemcall path.
If you are ignorant of the state, call eventfd_signal.

>  IMO, the ideal
> solution needs to be something we can detect at run-time.
> 
> Thanks Michael,
> -Greg
> 


-- 
MST
