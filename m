Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYHAVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYHAVQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760696AbYHAVKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:35 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47621 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760678AbYHAVKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:33 -0400
Date: Fri, 1 Aug 2008 14:10:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] RCU: implement rcu_read_[un]lock_preempt()
Message-ID: <20080801211029.GS14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <487AEAC6.60307@kernel.org> <1216188469.5232.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216188469.5232.0.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 08:07:49AM +0200, Peter Zijlstra wrote:
> On Mon, 2008-07-14 at 14:57 +0900, Tejun Heo wrote:
> > With the introduction of preemptible RCU, RCU doesn't gurantee that
> > its critical section runs on the CPU it started to run.  As there are
> > cases where non-preemptible RCU critical section makes sense, create
> > new RCU read lock variants which turns of preemption -
> > rcu_read_[un]lock_preempt() which are identical to rcu_read_[un]lock()
> > for classic implementation and have enclosing preempt disable/enable
> > for preemptible RCU.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Sorry, NAK.
> 
> If you need preempt off you need it for other reasons than RCU, so
> mixing it in the interface doesn't make sense to me.

What Peter said.

For example, you could simply use preempt_disable() and preempt_enable()
to guard the read side (or wrapper these as Mathieu suggests in
http://lkml.org/lkml/2008/7/15/605, though Mathieu has not yet
convinced me that these wrappers are a good idea), and then use either
call_rcu_sched() or synchronize_sched() for the update side.

To summarize:

o	Replace your rcu_read_lock_preempt() with preempt_disable().

o	Replace your rcu_read_unlock_preempt() with preempt_enable().

o	Replace your use of call_rcu() with call_rcu_sched().

o	Replace your use of synchronize_rcu() with synchronize_sched().

And then you don't need these new primitives.

However!!!  This must be done carefully, as long sections of code
with preemption disabled are really bad for realtime response.

So, what are you really trying to do, Tejun?

							Thanx, Paul

> > ---
> > This will be used by following block layer updates.  If this and the
> > block changes get acked, it'll be best to push this through block
> > tree.
> > 
> > Thanks.
> > 
> >  include/linux/rcuclassic.h |    2 ++
> >  include/linux/rcupdate.h   |   18 ++++++++++++++++++
> >  include/linux/rcupreempt.h |    6 ++++--
> >  3 files changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> > index b3aa05b..08c6153 100644
> > --- a/include/linux/rcuclassic.h
> > +++ b/include/linux/rcuclassic.h
> > @@ -136,6 +136,8 @@ extern struct lockdep_map rcu_lock_map;
> >  		__release(RCU); \
> >  		preempt_enable(); \
> >  	} while (0)
> > +#define __rcu_read_lock_preempt()	__rcu_read_lock()
> > +#define __rcu_read_unlock_preempt()	__rcu_read_unlock()
> >  #define __rcu_read_lock_bh() \
> >  	do { \
> >  		local_bh_disable(); \
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index d42dbec..e0e3486 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -112,6 +112,24 @@ struct rcu_head {
> >  #define rcu_read_unlock() __rcu_read_unlock()
> >  
> >  /**
> > + * rcu_read_lock_preempt - mark the beginning of non-preemptible RCU
> > + *			   critical section
> > + *
> > + * Identical to rcu_read_lock() but the critical section is guaranteed
> > + * to be non-preemptible.  Note that this is identical to
> > + * rcu_read_lock() on classic RCU implementation.
> > + */
> > +#define rcu_read_lock_preempt() __rcu_read_lock_preempt()
> > +
> > +/**
> > + * rcu_read_unlock_preempt - mark the end of of non-preemptible RCU
> > + *			     critical section
> > + *
> > + * See rcu_read_lock_preempt() for more information.
> > + */
> > +#define rcu_read_unlock_preempt() __rcu_read_unlock_preempt()
> > +
> > +/**
> >   * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
> >   *
> >   * This is equivalent of rcu_read_lock(), but to be used when updates
> > diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> > index 8a05c7e..b263ceb 100644
> > --- a/include/linux/rcupreempt.h
> > +++ b/include/linux/rcupreempt.h
> > @@ -49,8 +49,10 @@ extern void __rcu_read_unlock(void)	__releases(RCU);
> >  extern int rcu_pending(int cpu);
> >  extern int rcu_needs_cpu(int cpu);
> >  
> > -#define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
> > -#define __rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
> > +#define __rcu_read_lock_preempt()	{ rcu_read_lock(); preempt_disable(); }
> > +#define __rcu_read_unlock_preempt()	{ preempt_enable(); rcu_read_unlock(); }
> > +#define __rcu_read_lock_bh()		{ rcu_read_lock(); local_bh_disable(); }
> > +#define __rcu_read_unlock_bh()		{ local_bh_enable(); rcu_read_unlock(); }
> >  
> >  extern void __synchronize_sched(void);
> >  
> 
