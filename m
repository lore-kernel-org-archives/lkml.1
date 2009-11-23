Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZKWWsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZKWWsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZKWWsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:48:39 -0500
Received: from ozlabs.org ([203.10.76.45]:49197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbZKWWsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:48:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] cpumask: truncate task_struct.cpus_allowed for CONFIG_CPUMASK_OFFSTACK
Date: Tue, 24 Nov 2009 09:18:39 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200911191930.59400.rusty@rustcorp.com.au> <20091123182307.GA9123@elte.hu>
In-Reply-To: <20091123182307.GA9123@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911240918.40418.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 04:53:07 am Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Turns cpus_allowed into a bitmap, and truncate it to nr_cpu_ids if
> > CONFIG_CPUMASK_OFFSTACK is set.
> > 
> > I do this rather than the classic [0] dangling array trick, because of
> > INIT_TASK and references to sizeof(struct task_struct).
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  include/linux/init_task.h |    2 +-
> >  include/linux/sched.h     |    7 +++++--
> >  kernel/fork.c             |   19 ++++++++++++++++++-
> >  3 files changed, 24 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> > --- a/include/linux/init_task.h
> > +++ b/include/linux/init_task.h
> > @@ -130,7 +130,7 @@ extern struct cred init_cred;
> >  	.static_prio	= MAX_PRIO-20,					\
> >  	.normal_prio	= MAX_PRIO-20,					\
> >  	.policy		= SCHED_NORMAL,					\
> > -	.cpus_allowed	= CPU_MASK_ALL,					\
> > +	.cpus_allowed	= CPU_BITS_ALL,					\
> >  	.mm		= NULL,						\
> >  	.active_mm	= &init_mm,					\
> >  	.se		= {						\
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1256,7 +1256,6 @@ struct task_struct {
> >  #endif
> >  
> >  	unsigned int policy;
> > -	cpumask_t cpus_allowed;
> >  
> >  #ifdef CONFIG_TREE_PREEMPT_RCU
> >  	int rcu_read_lock_nesting;
> > @@ -1544,10 +1543,14 @@ struct task_struct {
> >  	unsigned long trace_recursion;
> >  #endif /* CONFIG_TRACING */
> >  	unsigned long stack_start;
> > +
> > +	/* This has to go at the end: if CONFIG_CPUMASK_OFFSTACK=y, only
> > +	 * nr_cpu_ids bits will actually be allocated. */
> > +	DECLARE_BITMAP(cpus_allowed, CONFIG_NR_CPUS);
> 
> (nit: please use the comment style you see elsewhere in the file.)

Sure, my mistake.

> >  };
> >  
> >  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> > -#define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
> > +#define tsk_cpumask(tsk) (to_cpumask((tsk)->cpus_allowed))
> 
> Please use tsk_cpus_allowed() throughout - so that people who knew what 
> p->cpus_allowed did know what this new thing does.

OK.  I chose this because it's shorter and consistent with other uses
(esp. mm_cpumask).  It's been in Linus' tree for a while, but noone uses
it so it's easy to rename.
 
> Also, i'm still having second thoughts about it all - could we somehow 
> avoid all this wrappery of commonly used fields? (My main and pretty 
> much only worry is that struct field members look so much cleaner than 
> some wrapper intermediary.)

I'm not a fan either, but it does avoid a flag-day transition.  And I was
pleasantly surprised how few places access ->cpus_allowed.

If we use a cpumask_var_t, we still need to change all the callers
(since it'll now look like a ptr), but we get a gratuitous ptr deref
for CONFIG_CPUMASK_OFFSTACK=y.

INIT_TASK needs some tweaking, but it's not a showstopper AFAICT.

Want me to create a cpumask_var_t version for comparison?

Thanks,
Rusty.
