Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbXJVR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbXJVR35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXJVR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:29:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55453 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbXJVR3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:29:46 -0400
Date: Mon, 22 Oct 2007 21:34:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC/PATCH 3/3] rt: PI-workqueue: fix barriers
Message-ID: <20071022173454.GA924@tv-sign.ru>
References: <20071022095054.393085000@chello.nl> <20071022095659.005996000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022095659.005996000@chello.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, Peter Zijlstra wrote:
>
> --- linux-2.6.orig/lib/plist.c
> +++ linux-2.6/lib/plist.c
> @@ -72,7 +72,7 @@ static void plist_check_head(struct plis
>   * @node:	&struct plist_node pointer
>   * @head:	&struct plist_head pointer
>   */
> -void plist_add(struct plist_node *node, struct plist_head *head)
> +void __plist_add(struct plist_node *node, struct plist_head *head, int tail)
>  {
>  	struct plist_node *iter;
>  
> @@ -92,7 +92,13 @@ void plist_add(struct plist_node *node, 
>  lt_prio:
>  	list_add_tail(&node->plist.prio_list, &iter->plist.prio_list);
>  eq_prio:
> -	list_add_tail(&node->plist.node_list, &iter->plist.node_list);
> +	if (likely(tail))
> +		list_add_tail(&node->plist.node_list, &iter->plist.node_list);

Ugh, I think this change is wrong in many ways. Just one example. Suppose
we have plist with 2 nodes X1 and X2, both with ->prio == 10. Now we insert
the new node N, N->prio = 5.

at this point iter == &X1

> +	else {
> +		iter = list_entry(iter->plist.prio_list.prev,
> +				struct plist_node, plist.prio_list);

iter is _still_ &X1, its ->plist.prio_list is empty.

> +		list_add(&node->plist.node_list, &iter->plist.node_list);

Now, from the plist_for_each's pov, the nodes in the plist are ordered as
X1, N, X2 - bug.

There are other problems. For example the "eq_prio:" case needs additional
attention if tail == 0, we must remove the old node from the prio_list and
insert the new one.

>  static void insert_work(struct cpu_workqueue_struct *cwq,
> -				struct work_struct *work, int tail)
> +		struct work_struct *work, int prio, int boost_prio, int tail)
>  {
> -	int prio = current->normal_prio;
> -
>  	set_wq_data(work, cwq);
>  	/*
>  	 * Ensure that we get the right work->data if we see the
> @@ -136,10 +138,10 @@ static void insert_work(struct cpu_workq
>  	 */
>  	smp_wmb();
>  	plist_node_init(&work->entry, prio);
> -	plist_add(&work->entry, &cwq->worklist);
> +	__plist_add(&work->entry, &cwq->worklist, tail);

Hmm. Not sure we really need __plist_add() here. If tail == 0, we must
insert this work (barrier) at the head of the list. Can't we do

	work->entry->prio = tail ? prio : -1;
	plist_add(&work->entry, &cwq->worklist);

instead?

>  static void run_workqueue(struct cpu_workqueue_struct *cwq)
>  {
> +	struct plist_head *worklist = &cwq->worklist;
> +
>  	spin_lock_irq(&cwq->lock);
>  	cwq->run_depth++;
>  	if (cwq->run_depth > 3) {
> @@ -267,16 +280,25 @@ static void run_workqueue(struct cpu_wor
>  			__FUNCTION__, cwq->run_depth);
>  		dump_stack();
>  	}
> -	while (!plist_head_empty(&cwq->worklist)) {
> -		struct work_struct *work = plist_first_entry(&cwq->worklist,
> +
> +again:
> +	while (!plist_head_empty(worklist)) {
> +		int prio;
> +		struct work_struct *work = plist_first_entry(worklist,
>  						struct work_struct, entry);
>  		work_func_t f = work->func;
>  
> -		if (likely(cwq->thread->prio != work->entry.prio))
> -			task_setprio(cwq->thread, work->entry.prio);
> +		prio = work->entry.prio;
> +		if (unlikely(worklist != &cwq->worklist)) {
> +			prio = min(prio, cwq->barrier->prev_prio);
> +			prio = min(prio, plist_first(&cwq->worklist)->prio);
> +		}
> +
> +		if (likely(cwq->thread->prio != prio))
> +			task_setprio(cwq->thread, prio);
>  
>  		cwq->current_work = work;
> -		plist_del(&work->entry, &cwq->worklist);
> +		plist_del(&work->entry, worklist);
>  		plist_node_init(&work->entry, MAX_PRIO);
>  		spin_unlock_irq(&cwq->lock);
>  
> @@ -289,7 +311,27 @@ static void run_workqueue(struct cpu_wor
>  
>  		spin_lock_irq(&cwq->lock);
>  		cwq->current_work = NULL;
> +
> +		if (unlikely(cwq->barrier))
> +			worklist = &cwq->barrier->worklist;
> +	}

At first glance this looks wrong, but I am not sure I get it right...

So, now we iterate the local worklist, not cwq->worklist. Suppose it has
the works w1 and w2.

run_workqueue() starts w1->func().

Another thread does cancel_work_sync(w1) under some LOCK. We insert the
barrier at cwq->worklist and sleep.

w1 completes, run_workqueue() fires w2, w2->func does lock(LOCK) ...

Deadlock.

(I'll try to read this patch carefully tomorrow, but it is a bit hard to
 read this series, and the very first patch has rejects. Could you make
 a single patch?)

Oleg.

