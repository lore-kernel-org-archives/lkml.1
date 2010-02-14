Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0BNRsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:48:07 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37069 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab0BNRsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:48:02 -0500
Date: Sun, 14 Feb 2010 09:48:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 06/13] sched: use lockdep-based checking
	on rcu_dereference()
Message-ID: <20100214174803.GN7084@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100212000016.GA25781@linux.vnet.ibm.com> <1265932839-25899-6-git-send-email-paulmck@linux.vnet.ibm.com> <1266142332.5273.415.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266142332.5273.415.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:12:12AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-02-11 at 16:00 -0800, Paul E. McKenney wrote:
> > +               first = rcu_dereference_check(pid->tasks[type].first, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock));
> >                 if (first)
> >                         result = hlist_entry(first, struct task_struct, pids[(type)].node);
> >         }
> 
> I've seen that particular combination a few times in this patch, would
> it make sense to create rcu_dereference_task()?
> 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index c535cc4..ad419d9 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -645,6 +645,11 @@ static inline int cpu_of(struct rq *rq)
> >  #endif
> >  }
> >  
> > +#define for_each_domain_rd(p) \
> > +       rcu_dereference_check((p), \
> > +                             rcu_read_lock_sched_held() || \
> > +                             lockdep_is_held(&sched_domains_mutex))
> > + 
> 
> Would rcu_dereference_rd() not be a better name?

We are probably going to need per-subsystem name spaces, so how about
rcu_dereference_check_sched_domain()?  Again, if agreeable, will send
updated patch stack.

							Thanx, Paul

------------------------------------------------------------------------

sched: better name for for_each_domain_rd

As suggested by Peter Ziljstra, make better choice of name
for for_each_domain_rd(), containing "rcu_dereference", given
that it is but a wrapper for rcu_dereference_check().  The name
rcu_dereference_check_sched_domain() does that and provides a separate
per-subsystem name space.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index ad419d9..478fc7d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -645,7 +645,7 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-#define for_each_domain_rd(p) \
+#define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
 			      rcu_read_lock_sched_held() || \
 			      lockdep_is_held(&sched_domains_mutex))
@@ -658,7 +658,7 @@ static inline int cpu_of(struct rq *rq)
  * preempt-disabled sections.
  */
 #define for_each_domain(cpu, __sd) \
-	for (__sd = for_each_domain_rd(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
