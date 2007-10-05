Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbXJEOHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbXJEOHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXJEOHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:07:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34937 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbXJEOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:07:33 -0400
Date: Fri, 5 Oct 2007 07:07:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       a.p.zijlstra@chello.nl, bunk@kernel.org, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 6/9] RCU priority boosting for preemptible RCU
Message-ID: <20071005140725.GD22034@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183901.GF3819@linux.vnet.ibm.com> <20071005114657.GA17788@in.ibm.com> <Pine.LNX.4.58.0710050822330.20859@gandalf.stny.rr.com> <20071005132114.GA28755@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005132114.GA28755@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 06:51:14PM +0530, Gautham R Shenoy wrote:
> On Fri, Oct 05, 2007 at 08:24:21AM -0400, Steven Rostedt wrote:
> > On Fri, 5 Oct 2007, Gautham R Shenoy wrote:
> > > On Mon, Sep 10, 2007 at 11:39:01AM -0700, Paul E. McKenney wrote:
> > >
> > > [snip]
> > >
> > > > +
> > > > +/*
> > > > + * Return the list from which to boost target tasks.
> > > > + * May only be invoked by the booster task, so guaranteed to
> > > > + * already be initialized.  Use rcu_boost_dat element least recently
> > > > + * the destination for task blocking in RCU read-side critical sections.
> > > > + */
> > > > +static inline struct rcu_boost_dat *rcu_rbd_boosting(int cpu)
> > > > +{
> > > > +	int idx = (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);
> > >
> > > Why is this masking required? When we increment
> > > the rcu_boost_idx in rcu_booster, we do perform a modulo operation
> > > to ensure that it wraps around RCU_BOOST_ELEMENTS.
> > 
> > Because we are not masking rcu_boost_idx, we are masking
> >  (rcu_boost_idx + 1) which may extend the bounderies of
> > RCU_BOOST_ELEMENTS.
> 
> Thanks! 
> 
> But I'm still trying to understand why the (increment + masking)
> is required at all.
> 
> The thread(producer) that requires boosting is added to the element
> with index rcu_boost_idx.
> 
> The booster thread(consumer) increments the rcu_boost_idx to 
> (rcu_boost_idx + 1) % RCU_BOOST_ELEMENTS, before it fetches the least
> recently used rcu_boot_dat elements and boost the eligible tasks queued
> in that element.
> 
> So, can't we just return per_cpu(rcu_boost_dat, cpu)[rcu_boost_idx] from
> rcu_rbd_boosting(cpu) ? Isn't that already the least recently used
> element?

Good catch -- we need to advance the index -after- boosting, so that
new sleeping tasks are not immediately dropped on the to-be-boosted
list.  Will fix!

(Non-fatal -- but means that the algorithm is effectively only using
three elements of the four-element array, so does need to be fixed.)

						Thanx, Paul
