Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab0BNREK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:04:10 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60706 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0BNREJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:04:09 -0500
Date: Sun, 14 Feb 2010 09:04:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rcu_dereference() without protection in select_task_rq_fair()
Message-ID: <20100214170409.GK7084@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100211165246.GA8329@linux.vnet.ibm.com> <1266142358.5273.420.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266142358.5273.420.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:12:38AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-02-11 at 08:52 -0800, Paul E. McKenney wrote:
> > Hello, Peter,
> > 
> > My lockdep-ified RCU complains about the for_each_domain() in
> > select_task_rq_fair(), see below for the lockdep complaint.  I added
> > rcu_dereference_check() annotations as follows:
> > 
> > #define for_each_domain_rd(p) \
> >         rcu_dereference_check((p), \
> >                               rcu_read_lock_sched_held() || \
> >                               lockdep_is_held(&sched_domains_mutex))
> > 
> > #define for_each_domain(cpu, __sd) \
> >         for (__sd = for_each_domain_rd(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
> > 
> > In other words, I believe (perhaps incorrectly) that for_each_domain()
> > can be called either within an RCU-sched read-side critical section or
> > with sched_domains_mutex held.  Lockdep claims that no locks of any
> > kind, RCU or otherwise, were held.  I considered the possibility that
> > this was an initialization-time thing, but the code traverses CPU
> > structures rather than task structures.
> > 
> > One other possibility is that this is safe due to the fact that we are
> > booting up, before the second CPU has come online.  Are you relying on
> > this?
> > 
> > For reference, here is the definition of rcu_read_lock_sched_held():
> > 
> > static inline int rcu_read_lock_sched_held(void)
> > {
> >         int lockdep_opinion = 0;
> > 
> >         if (debug_locks)
> >                 lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> >         return lockdep_opinion || preempt_count() != 0;
> > }
> > 
> > Help? 
> 
> We use synchronize_sched() and preempt_disable() for the sched domain
> stuff. The comment above for_each_domain():
> 
> /*
>  * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
>  * See detach_destroy_domains: synchronize_sched for details.
>  *
>  * The domain tree of any CPU may only be accessed from within
>  * preempt-disabled sections.
>  */
> #define for_each_domain(cpu, __sd) \
>         for (__sd = rcu_dereference(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
> 
> explains this usage, also see detach_destroy_domains().
> 
> So one thing you can do is add (preempt_count() & ~PREEMPT_ACTIVE) to
> the rcu_read_lock_sched_held() function to catch all those cases that
> rely on preemption without having to add annotations to everything that
> disables preemption.

OK, but doesn't the "preempt_count() != 0" that is in the current version
of rcu_read_lock_sched_held() already cover this check?

In other words, I believe that I have located a usage of for_each_domain()
that violates the rule that it may only be called within preempt-disabled
sections.

							Thanx, Paul
