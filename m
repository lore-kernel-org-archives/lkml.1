Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbZHTDpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbZHTDpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZHTDpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:45:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49964 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZHTDpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:45:41 -0400
Date: Wed, 19 Aug 2009 20:45:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       josht@linux.vnet.ibm.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu] Fix rcu_migrate_callback() to allow for
	multiple waiters
Message-ID: <20090820034539.GA6847@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090820013153.GA19944@linux.vnet.ibm.com> <4A8CC365.8040007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8CC365.8040007@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 11:30:45AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > The current interaction between rcu_barrier() and CPU hotplug can result
> > in multiple tasks waiting on rcu_migrate_wq: there can be one CPU-hotplug
> > notifier, and, because rcu_barrier() invokes wait_migrated_callbacks()
> > outside of rcu_barrier_mutex, an arbitrarily large number of tasks
> > executing in _rcu_barrier().  This situation could result in hangs,
> > because rcu_migrate_callback() would wake up but one task.
> > 
> > This patch addresses this problem by awakening all sleepers.
> > 
> > Located-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  rcupdate.c |    9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> > index bd5d5c8..6c59e1b 100644
> > --- a/kernel/rcupdate.c
> > +++ b/kernel/rcupdate.c
> > @@ -211,10 +211,17 @@ void rcu_barrier_sched(void)
> >  }
> >  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> >  
> > +/*
> > + * Wake up anyone waiting on migration of RCU callbacks from a CPU
> > + * going offline.  There can be only one CPU-hotplug notifier waiting,
> > + * but there can be any number of rcu_barrier() invocations waiting,
> > + * due to the fact that rcu_barrier() does its wait outside of the
> > + * rcu_barrier_mutex.
> > + */
> >  static void rcu_migrate_callback(struct rcu_head *notused)
> >  {
> >  	if (atomic_dec_and_test(&rcu_migrate_type_count))
> > -		wake_up(&rcu_migrate_wq);
> > +		wake_up_all(&rcu_migrate_wq);
> >  }
> >  
> >  extern int rcu_cpu_notify(struct notifier_block *self,
> > 
> 
> Maybe wake_up_all() is good for readability. But wake_up()
> is enough for the logic.
> 
> In wait_migrated_callbacks(), we use wait_event(), The current
> thread is queued as a non-exclusive waiter. And wake_up()
> wakes up all non-exclusive waiter. (We only have
> non-exclusive waiters in the rcu_migrate_wq)

And we even discussed this very point on March 18th!!!

OK, never mind, this patch has no effect.

							Thanx, Paul
