Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZAVJhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZAVJhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbZAVJhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:37:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbZAVJhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:37:14 -0500
Date: Thu, 22 Jan 2009 10:36:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090122093649.GD24758@elte.hu>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122093046.GC5891@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Jan 22, 2009 at 05:14:24PM +0800, Lai Jiangshan wrote:
> > 1) lockdep will complain when recursion run_workqueue
> > 2) works is not run orderly when recursion run_workqueue
> > 
> > 3) BUG!
> >    We use recursion run_workqueue to hidden deadlock when
> >    keventd trying to flush its own queue.
> > 
> >    It's bug. When flush_workqueue()(nested in a work callback)returns,
> >    the workqueue is not really flushed, the sequence statement of
> >    this work callback will do some thing bad.
> > 
> >    So we should not allow workqueue trying to flush its own queue.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 2f44583..1129cde 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -48,8 +48,6 @@ struct cpu_workqueue_struct {
> >  
> >  	struct workqueue_struct *wq;
> >  	struct task_struct *thread;
> > -
> > -	int run_depth;		/* Detect run_workqueue() recursion depth */
> >  } ____cacheline_aligned;
> >  
> >  /*
> > @@ -262,13 +260,6 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
> >  static void run_workqueue(struct cpu_workqueue_struct *cwq)
> >  {
> >  	spin_lock_irq(&cwq->lock);
> > -	cwq->run_depth++;
> > -	if (cwq->run_depth > 3) {
> > -		/* morton gets to eat his hat */
> > -		printk("%s: recursion depth exceeded: %d\n",
> > -			__func__, cwq->run_depth);
> > -		dump_stack();
> > -	}
> >  	while (!list_empty(&cwq->worklist)) {
> >  		struct work_struct *work = list_entry(cwq->worklist.next,
> >  						struct work_struct, entry);
> > @@ -311,7 +302,6 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
> >  		spin_lock_irq(&cwq->lock);
> >  		cwq->current_work = NULL;
> >  	}
> > -	cwq->run_depth--;
> >  	spin_unlock_irq(&cwq->lock);
> >  }
> >  
> > @@ -368,29 +358,20 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
> >  
> >  static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
> >  {
> > -	int active;
> > +	int active = 0;
> > +	struct wq_barrier barr;
> >  
> > -	if (cwq->thread == current) {
> > -		/*
> > -		 * Probably keventd trying to flush its own queue. So simply run
> > -		 * it by hand rather than deadlocking.
> > -		 */
> > -		run_workqueue(cwq);
> > -		active = 1;
> > -	} else {
> > -		struct wq_barrier barr;
> > +	BUG_ON(cwq->thread == current);
> 
> Hi Lai,
> 
> BUG_ON seems perhaps a bit too much for such case. The system
> will run in an endless loop because of a mistake that will not have
> necessarily a fatal end.
> WARN_ON should be enough (plus the warn that lockdep will raise
> too in this case).

WARN_ONCE() is the best method usually - we want a one-time and expressive 
warning, not just a stack dump. (i.e. not WARN_ON and not WARN_ON_ONCE)

Plus some thinking needs to be put into exiting from that function in a way 
that the system will still be usable enough to report the bug.

	Ingo
