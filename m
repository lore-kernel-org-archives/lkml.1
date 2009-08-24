Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZHXJBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZHXJBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZHXJBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:01:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbZHXJBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:01:33 -0400
Date: Mon, 24 Aug 2009 11:00:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH -tip] v3 Consolidate sparse and lockdep declarations in
	include/linux/rcupdate.h
Message-ID: <20090824090058.GC29804@elte.hu>
References: <20090727181401.GA14120@linux.vnet.ibm.com> <4A924296.3070308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A924296.3070308@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/rcupdate.h   |   46 ++++++++++++++++++++++++++++++++++++++++---
> >  include/linux/rcupreempt.h |    4 +-
> >  include/linux/rcutree.h    |   18 -----------------
> >  3 files changed, 44 insertions(+), 24 deletions(-)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index e920f0f..9d85ee1 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -80,6 +80,16 @@ extern int rcu_scheduler_active;
> >         (ptr)->next = NULL; (ptr)->func = NULL; \
> >  } while (0)
> >  
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +extern struct lockdep_map rcu_lock_map;
> > +# define rcu_read_acquire()	\
> > +			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
> > +# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
> > +#else
> > +# define rcu_read_acquire()	do { } while (0)
> > +# define rcu_read_release()	do { } while (0)
> > +#endif
> > +
> >  /**
> >   * rcu_read_lock - mark the beginning of an RCU read-side critical section.
> >   *
> > @@ -109,7 +119,12 @@ extern int rcu_scheduler_active;
> >   *
> >   * It is illegal to block while in an RCU read-side critical section.
> >   */
> > -#define rcu_read_lock() __rcu_read_lock()
> > +static inline void rcu_read_lock(void)
> > +{
> > +	__rcu_read_lock();
> > +	__acquire(RCU);
> > +	rcu_read_acquire();
> > +}
> >  
> >  /**
> >   * rcu_read_unlock - marks the end of an RCU read-side critical section.
> > @@ -126,7 +141,12 @@ extern int rcu_scheduler_active;
> >   * used as well.  RCU does not care how the writers keep out of each
> >   * others' way, as long as they do so.
> >   */
> > -#define rcu_read_unlock() __rcu_read_unlock()
> > +static inline void rcu_read_unlock(void)
> > +{
> > +	rcu_read_release();
> > +	__release(RCU);
> > +	__rcu_read_unlock();
> > +}
> >  
> >  /**
> >   * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
> > @@ -139,14 +159,24 @@ extern int rcu_scheduler_active;
> >   * can use just rcu_read_lock().
> >   *
> >   */
> > -#define rcu_read_lock_bh() __rcu_read_lock_bh()
> > +static inline void rcu_read_lock_bh(void)
> > +{
> > +	__rcu_read_lock_bh();
> > +	__acquire(RCU_BH);
> > +	rcu_read_acquire();
> > +}
> >  
> >  /*
> >   * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
> >   *
> >   * See rcu_read_lock_bh() for more information.
> >   */
> > -#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
> > +static inline void rcu_read_unlock_bh(void)
> > +{
> > +	rcu_read_release();
> > +	__release(RCU_BH);
> > +	__rcu_read_unlock_bh();
> > +}
> >  
> >  /**
> >   * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
> > @@ -160,10 +190,14 @@ extern int rcu_scheduler_active;
> >  static inline void rcu_read_lock_sched(void)
> >  {
> >  	preempt_disable();
> > +	__acquire(RCU_SCHED);
> > +	rcu_read_acquire();
> >  }
> >  static inline void rcu_read_lock_sched_notrace(void)
> 
> It need be marked "notrace" too.
> 
> >  {
> >  	preempt_disable_notrace();
> > +	__acquire(RCU_SCHED);
> > +	rcu_read_acquire();
> >  }
> >  
> 
> It may cause infinity recursion.
> rcu_read_acquire() calls rcu_read_lock_sched_notrace()
> before current->lockdep_recursion is set to 1 when tracing in on,
> thus infinity recursion occurs.

ah, this would explain the crash i reported in:

    http://lkml.org/lkml/2009/8/23/170

	Ingo
