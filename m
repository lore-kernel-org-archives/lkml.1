Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYFJQR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYFJQR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYFJQRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:17:48 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34655 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYFJQRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:17:47 -0400
Date: Tue, 10 Jun 2008 09:17:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH -rt 5/5] cpu-hotplug: cpu_down vs preempt-rt
Message-ID: <20080610161741.GG15481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080610111259.766940257@chello.nl> <20080610111832.969119014@chello.nl> <20080610153301.GD15481@linux.vnet.ibm.com> <1213113078.31518.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213113078.31518.16.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 05:51:18PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-06-10 at 08:33 -0700, Paul E. McKenney wrote:
> > On Tue, Jun 10, 2008 at 01:13:04PM +0200, Peter Zijlstra wrote:
> > > idle_task_exit() calls mmdrop() from the idle thread, but in PREEMPT_RT all the
> > > allocator locks are sleeping locks - for obvious reasons scheduling away the
> > > idle thread gives some curious problems.
> > > 
> > > Solve this by pushing the mmdrop() into an RCU callback, however we can't use
> > > RCU because the CPU is already down and all the local RCU state has been
> > > destroyed.
> > > 
> > > Therefore create a new call_rcu() variant that enqueues the callback on an
> > > online cpu.
> > 
> > I am a bit nervous about the non-determinism, but on the other hand
> > CPU online/offline events can only happen so often due to the locking.
> > 
> > So...
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Thanks!
> 
> Yesterday you suggested using rcu_cpu_online_map and fliplock to avoid
> the loop here:
> 
> > > +void fastcall call_rcu_preempt_online(struct rcu_head *head,
> > > +		void (*func)(struct rcu_head *rcu))
> > > +{
> > > +	struct rcu_data *rdp;
> > > +	unsigned long flags;
> > > +	int cpu;
> > > +
> > > +	head->func = func;
> > > +	head->next = NULL;
> > > +again:
> > > +	cpu = first_cpu(cpu_online_map);
> > > +	rdp = RCU_DATA_CPU(cpu);
> > > +
> > > +	spin_lock_irqsave(&rdp->lock, flags);
> > > +	if (unlikely(!cpu_online(cpu))) {
> > > +		/*
> > > +		 * cpu is removed from the online map before rcu_offline_cpu
> > > +		 * is called.
> > > +		 */
> > > +		spin_unlock_irqrestore(&rdp->lock, flags);
> > > +		goto again;
> > > +	}
> > > +
> > > +	*rdp->nexttail = head;
> > > +	rdp->nexttail = &head->next;
> > > +	spin_unlock_irqrestore(&rdp->lock, flags);
> > > +
> > > +}
> 
> But then the code would look like:
> 
>   spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
>   cpu = first_cpu(rcu_cpu_online_map);
>   rdp = RCU_DATA_CPU(cpu);
>   spin_lock(&rdp->lock);
> 
> creating a nesting between these two locks, where I could not find one.
> 
> Do you still prefer I look into changing it into such a form, or are you
> sufficiently non-caring that the current code can stand? :-)

I am equally bothered by the non-determinism and by the nesting, hence
the current code can stand, at least until it causes a real problem.

							Thanx, Paul
