Return-Path: <linux-kernel-owner+w=401wt.eu-S932075AbZKWXOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbZKWXOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZKWXOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:14:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41885 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbZKWXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:14:46 -0500
Date: Tue, 24 Nov 2009 00:14:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/6] cpumask: truncate task_struct.cpus_allowed for
 CONFIG_CPUMASK_OFFSTACK
Message-ID: <20091123231440.GA13221@elte.hu>
References: <200911191930.59400.rusty@rustcorp.com.au>
 <20091123182307.GA9123@elte.hu>
 <200911240918.40418.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911240918.40418.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tue, 24 Nov 2009 04:53:07 am Ingo Molnar wrote:
> > 
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > Turns cpus_allowed into a bitmap, and truncate it to nr_cpu_ids if
> > > CONFIG_CPUMASK_OFFSTACK is set.
> > > 
> > > I do this rather than the classic [0] dangling array trick, because of
> > > INIT_TASK and references to sizeof(struct task_struct).
> > > 
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > ---
> > >  include/linux/init_task.h |    2 +-
> > >  include/linux/sched.h     |    7 +++++--
> > >  kernel/fork.c             |   19 ++++++++++++++++++-
> > >  3 files changed, 24 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> > > --- a/include/linux/init_task.h
> > > +++ b/include/linux/init_task.h
> > > @@ -130,7 +130,7 @@ extern struct cred init_cred;
> > >  	.static_prio	= MAX_PRIO-20,					\
> > >  	.normal_prio	= MAX_PRIO-20,					\
> > >  	.policy		= SCHED_NORMAL,					\
> > > -	.cpus_allowed	= CPU_MASK_ALL,					\
> > > +	.cpus_allowed	= CPU_BITS_ALL,					\
> > >  	.mm		= NULL,						\
> > >  	.active_mm	= &init_mm,					\
> > >  	.se		= {						\
> > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -1256,7 +1256,6 @@ struct task_struct {
> > >  #endif
> > >  
> > >  	unsigned int policy;
> > > -	cpumask_t cpus_allowed;
> > >  
> > >  #ifdef CONFIG_TREE_PREEMPT_RCU
> > >  	int rcu_read_lock_nesting;
> > > @@ -1544,10 +1543,14 @@ struct task_struct {
> > >  	unsigned long trace_recursion;
> > >  #endif /* CONFIG_TRACING */
> > >  	unsigned long stack_start;
> > > +
> > > +	/* This has to go at the end: if CONFIG_CPUMASK_OFFSTACK=y, only
> > > +	 * nr_cpu_ids bits will actually be allocated. */
> > > +	DECLARE_BITMAP(cpus_allowed, CONFIG_NR_CPUS);
> > 
> > (nit: please use the comment style you see elsewhere in the file.)
> 
> Sure, my mistake.
> 
> > >  };
> > >  
> > >  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> > > -#define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
> > > +#define tsk_cpumask(tsk) (to_cpumask((tsk)->cpus_allowed))
> > 
> > Please use tsk_cpus_allowed() throughout - so that people who knew what 
> > p->cpus_allowed did know what this new thing does.
> 
> OK.  I chose this because it's shorter and consistent with other uses
> (esp. mm_cpumask).  It's been in Linus' tree for a while, but noone uses
> it so it's easy to rename.

Thanks!

> > Also, i'm still having second thoughts about it all - could we somehow 
> > avoid all this wrappery of commonly used fields? (My main and pretty 
> > much only worry is that struct field members look so much cleaner than 
> > some wrapper intermediary.)
> 
> I'm not a fan either, but it does avoid a flag-day transition.  And I was
> pleasantly surprised how few places access ->cpus_allowed.
> 
> If we use a cpumask_var_t, we still need to change all the callers
> (since it'll now look like a ptr), but we get a gratuitous ptr deref
> for CONFIG_CPUMASK_OFFSTACK=y.
> 
> INIT_TASK needs some tweaking, but it's not a showstopper AFAICT.
> 
> Want me to create a cpumask_var_t version for comparison?

There's also the problem of cache footprint - we really want to freedom 
to place the masks (which are not off-stack in the regular case) 
anywhere in task struct - and task-struct is huge, so cache placement 
matters.

Is the ptr deref really a big problem for off-stack?

Changing all users isnt a problem as long as it still looks like a clean 
data structure with clean usage. Those end-of-struct tricks we play with 
cpumasks make me really a bit uneasy.

	Ingo
