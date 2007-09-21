Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbXIUFvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbXIUFvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 01:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXIUFvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 01:51:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55694 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbXIUFu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 01:50:59 -0400
Date: Thu, 20 Sep 2007 22:50:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070921055056.GA8654@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070921041721.GB15697@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921041721.GB15697@goodmis.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 12:17:21AM -0400, Steven Rostedt wrote:
> [ continued here from comment on patch 1]
> 
> On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:
> >  /* softirq mask and active fields moved to irq_cpustat_t in
> > diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/include/linux/rcuclassic.h linux-2.6.22-c-preemptrcu/include/linux/rcuclassic.h
> > --- linux-2.6.22-b-fixbarriers/include/linux/rcuclassic.h	2007-08-22 14:42:23.000000000 -0700
> > +++ linux-2.6.22-c-preemptrcu/include/linux/rcuclassic.h	2007-08-22 15:21:06.000000000 -0700
> > @@ -142,8 +142,6 @@ extern int rcu_needs_cpu(int cpu);
> >  extern void __rcu_init(void);
> >  extern void rcu_check_callbacks(int cpu, int user);
> >  extern void rcu_restart_cpu(int cpu);
> > -extern long rcu_batches_completed(void);
> > -extern long rcu_batches_completed_bh(void);
> >  
> >  #endif /* __KERNEL__ */
> >  #endif /* __LINUX_RCUCLASSIC_H */
> > diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h
> > --- linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h	2007-07-19 14:02:36.000000000 -0700
> > +++ linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h	2007-08-22 15:21:06.000000000 -0700
> > @@ -52,7 +52,11 @@ struct rcu_head {
> >  	void (*func)(struct rcu_head *head);
> >  };
> >  
> > +#ifdef CONFIG_CLASSIC_RCU
> >  #include <linux/rcuclassic.h>
> > +#else /* #ifdef CONFIG_CLASSIC_RCU */
> > +#include <linux/rcupreempt.h>
> > +#endif /* #else #ifdef CONFIG_CLASSIC_RCU */
> >  
> >  #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
> >  #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> > @@ -218,10 +222,13 @@ extern void FASTCALL(call_rcu_bh(struct 
> >  /* Exported common interfaces */
> >  extern void synchronize_rcu(void);
> >  extern void rcu_barrier(void);
> > +extern long rcu_batches_completed(void);
> > +extern long rcu_batches_completed_bh(void);
> >
> 
> And here we put back rcu_batches_completed and rcu_batches_completed_bh
> from rcuclassic.h to rcupdate.h ;-)

Hmmm...  Good point!!!  I guess it would be OK to just leave them
in rcupdate.h throughout.  ;-)

Will fix.  And good eyes!

						Thanx, Paul
