Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbXHARMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbXHARMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXHARMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:12:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14153 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbXHARMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:12:23 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1185987663.12034.99.camel@twins>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185987663.12034.99.camel@twins>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 10:10:43 -0700
Message-Id: <1185988243.2636.126.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 19:01 +0200, Peter Zijlstra wrote:
> (you guys forgot to CC Ingo, Oleg and me)
> 
> On Tue, 2007-07-31 at 20:52 -0700, Daniel Walker wrote:
> 
> > Here's a simpler version .. uses the plist data structure instead of the
> > 100 queues, which makes for a cleaner patch ..
> > 
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> looks good, assuming you actually ran the code:

No faith huh? I boot tested a few times, but it could be tested more.

> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> small nit below though..
> 
> > ---
> >  include/linux/workqueue.h |    7 ++++---
> >  kernel/power/poweroff.c   |    1 +
> >  kernel/sched.c            |    4 ----
> >  kernel/workqueue.c        |   40 +++++++++++++++++++++++++---------------
> >  4 files changed, 30 insertions(+), 22 deletions(-)
> > 
> > Index: linux-2.6.22/include/linux/workqueue.h
> > ===================================================================
> > --- linux-2.6.22.orig/include/linux/workqueue.h
> > +++ linux-2.6.22/include/linux/workqueue.h
> > @@ -8,6 +8,7 @@
> >  #include <linux/timer.h>
> >  #include <linux/linkage.h>
> >  #include <linux/bitops.h>
> > +#include <linux/plist.h>
> >  #include <asm/atomic.h>
> >  
> >  struct workqueue_struct;
> > @@ -26,7 +27,7 @@ struct work_struct {
> >  #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
> >  #define WORK_STRUCT_FLAG_MASK (3UL)
> >  #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
> > -	struct list_head entry;
> > +	struct plist_node entry;
> >  	work_func_t func;
> >  };
> >  
> > @@ -43,7 +44,7 @@ struct execute_work {
> >  
> >  #define __WORK_INITIALIZER(n, f) {				\
> >  	.data = WORK_DATA_INIT(),				\
> > -	.entry	= { &(n).entry, &(n).entry },			\
> > +	.entry	= PLIST_NODE_INIT(n.entry, MAX_PRIO),		\
> >  	.func = (f),						\
> >  	}
> >  
> > @@ -79,7 +80,7 @@ struct execute_work {
> >  #define INIT_WORK(_work, _func)						\
> >  	do {								\
> >  		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
> > -		INIT_LIST_HEAD(&(_work)->entry);			\
> > +		plist_node_init(&(_work)->entry, -1);			\
> >  		PREPARE_WORK((_work), (_func));				\
> >  	} while (0)
> >  
> > Index: linux-2.6.22/kernel/power/poweroff.c
> > ===================================================================
> > --- linux-2.6.22.orig/kernel/power/poweroff.c
> > +++ linux-2.6.22/kernel/power/poweroff.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/sysrq.h>
> >  #include <linux/init.h>
> >  #include <linux/pm.h>
> > +#include <linux/sched.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/reboot.h>
> >  
> > Index: linux-2.6.22/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.22.orig/kernel/sched.c
> > +++ linux-2.6.22/kernel/sched.c
> > @@ -4379,8 +4379,6 @@ long __sched sleep_on_timeout(wait_queue
> >  }
> >  EXPORT_SYMBOL(sleep_on_timeout);
> >  
> > -#ifdef CONFIG_RT_MUTEXES
> > -
> >  /*
> >   * rt_mutex_setprio - set the current priority of a task
> >   * @p: task
> > @@ -4457,8 +4455,6 @@ out_unlock:
> >  	task_rq_unlock(rq, &flags);
> >  }
> >  
> > -#endif
> > -
> >  void set_user_nice(struct task_struct *p, long nice)
> >  {
> >  	int old_prio, delta, on_rq;
> > Index: linux-2.6.22/kernel/workqueue.c
> > ===================================================================
> > --- linux-2.6.22.orig/kernel/workqueue.c
> > +++ linux-2.6.22/kernel/workqueue.c
> > @@ -44,7 +44,7 @@ struct cpu_workqueue_struct {
> >  
> >  	spinlock_t lock;
> >  
> > -	struct list_head worklist;
> > +	struct plist_head worklist;
> >  	wait_queue_head_t more_work;
> >  	struct work_struct *current_work;
> >  
> > @@ -127,16 +127,19 @@ struct cpu_workqueue_struct *get_wq_data
> >  static void insert_work(struct cpu_workqueue_struct *cwq,
> >  				struct work_struct *work, int tail)
> >  {
> > +	int prio = current->normal_prio;
> > +
> >  	set_wq_data(work, cwq);
> >  	/*
> >  	 * Ensure that we get the right work->data if we see the
> >  	 * result of list_add() below, see try_to_grab_pending().
> >  	 */
> >  	smp_wmb();
> > -	if (tail)
> > -		list_add_tail(&work->entry, &cwq->worklist);
> > -	else
> > -		list_add(&work->entry, &cwq->worklist);
> > +	plist_node_init(&work->entry, prio);
> > +	plist_add(&work->entry, &cwq->worklist);
> 
> perhaps we ought to handle tail, perhaps not, not sure what the
> consequences are.

The plist doesn't distinguish since it's a sorted list. There is no way
to force something to the back of the list ..

It seems like the "tail" option was the old way to prioritize..  I think
It could be removed since we're always priority ordering now anyway..

Daniel

