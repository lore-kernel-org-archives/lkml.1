Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXJVTSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXJVTSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXJVTSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:18:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54065 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXJVTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:18:40 -0400
Subject: Re: [RFC/PATCH 3/3] rt: PI-workqueue: fix barriers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20071022173454.GA924@tv-sign.ru>
References: <20071022095054.393085000@chello.nl>
	 <20071022095659.005996000@chello.nl>  <20071022173454.GA924@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 21:17:39 +0200
Message-Id: <1193080659.5648.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-22 at 21:34 +0400, Oleg Nesterov wrote:
> On 10/22, Peter Zijlstra wrote:

> > @@ -136,10 +138,10 @@ static void insert_work(struct cpu_workq
> >  	 */
> >  	smp_wmb();
> >  	plist_node_init(&work->entry, prio);
> > -	plist_add(&work->entry, &cwq->worklist);
> > +	__plist_add(&work->entry, &cwq->worklist, tail);
> 
> Hmm. Not sure we really need __plist_add() here. If tail == 0, we must
> insert this work (barrier) at the head of the list. Can't we do
> 
> 	work->entry->prio = tail ? prio : -1;
> 	plist_add(&work->entry, &cwq->worklist);
> 
> instead?

Ah yes, that would work I guess. Very nice!

> >  static void run_workqueue(struct cpu_workqueue_struct *cwq)
> >  {
> > +	struct plist_head *worklist = &cwq->worklist;
> > +
> >  	spin_lock_irq(&cwq->lock);
> >  	cwq->run_depth++;
> >  	if (cwq->run_depth > 3) {
> > @@ -267,16 +280,25 @@ static void run_workqueue(struct cpu_wor
> >  			__FUNCTION__, cwq->run_depth);
> >  		dump_stack();
> >  	}
> > -	while (!plist_head_empty(&cwq->worklist)) {
> > -		struct work_struct *work = plist_first_entry(&cwq->worklist,
> > +
> > +again:
> > +	while (!plist_head_empty(worklist)) {
> > +		int prio;
> > +		struct work_struct *work = plist_first_entry(worklist,
> >  						struct work_struct, entry);
> >  		work_func_t f = work->func;
> >  
> > -		if (likely(cwq->thread->prio != work->entry.prio))
> > -			task_setprio(cwq->thread, work->entry.prio);
> > +		prio = work->entry.prio;
> > +		if (unlikely(worklist != &cwq->worklist)) {
> > +			prio = min(prio, cwq->barrier->prev_prio);
> > +			prio = min(prio, plist_first(&cwq->worklist)->prio);
> > +		}
> > +
> > +		if (likely(cwq->thread->prio != prio))
> > +			task_setprio(cwq->thread, prio);
> >  
> >  		cwq->current_work = work;
> > -		plist_del(&work->entry, &cwq->worklist);
> > +		plist_del(&work->entry, worklist);
> >  		plist_node_init(&work->entry, MAX_PRIO);
> >  		spin_unlock_irq(&cwq->lock);
> >  
> > @@ -289,7 +311,27 @@ static void run_workqueue(struct cpu_wor
> >  
> >  		spin_lock_irq(&cwq->lock);
> >  		cwq->current_work = NULL;
> > +
> > +		if (unlikely(cwq->barrier))
> > +			worklist = &cwq->barrier->worklist;
> > +	}
> 
> At first glance this looks wrong, but I am not sure I get it right...
> 
> So, now we iterate the local worklist, not cwq->worklist. Suppose it has
> the works w1 and w2.
> 
> run_workqueue() starts w1->func().
> 
> Another thread does cancel_work_sync(w1) under some LOCK. We insert the
> barrier at cwq->worklist and sleep.
> 
> w1 completes, run_workqueue() fires w2, w2->func does lock(LOCK) ...
> 
> Deadlock.

Ah, cancel_work_sync() will not use wq_full_barrier, but wq_barrier.

Its flush_cpu_workqueue() that will use this new nesting thing.

> (I'll try to read this patch carefully tomorrow, but it is a bit hard to
>  read this series, and the very first patch has rejects. Could you make
>  a single patch?)

Its against .23-rt1 and applies fine.

