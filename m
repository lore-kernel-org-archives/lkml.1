Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXJVMBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXJVMBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXJVMBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:01:13 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:50193 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXJVMBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:01:12 -0400
Date: Mon, 22 Oct 2007 08:00:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC/PATCH 2/3] rt: PI-workqueue support
In-Reply-To: <20071022095658.745030000@chello.nl>
Message-ID: <Pine.LNX.4.58.0710220754440.10836@gandalf.stny.rr.com>
References: <20071022095054.393085000@chello.nl> <20071022095658.745030000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Mon, 22 Oct 2007, Peter Zijlstra wrote:
5B>
> Index: linux-2.6/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.orig/kernel/workqueue.c
> +++ linux-2.6/kernel/workqueue.c
> @@ -44,7 +44,7 @@ struct cpu_workqueue_struct {
>
>  	spinlock_t lock;
>
> -	struct list_head worklist;
> +	struct plist_head worklist;
>  	wait_queue_head_t more_work;
>  	struct work_struct *current_work;
>
> @@ -127,16 +127,19 @@ struct cpu_workqueue_struct *get_wq_data
>  static void insert_work(struct cpu_workqueue_struct *cwq,
>  				struct work_struct *work, int tail)
>  {
> +	int prio = current->normal_prio;
> +

I'm curious to why you use normal_prio here? If the task has been boosted
by some other PI method, and this task is about to sleep, why not use the
actualy current->prio?

-- Steve


>  	set_wq_data(work, cwq);
>  	/*
>  	 * Ensure that we get the right work->data if we see the
>  	 * result of list_add() below, see try_to_grab_pending().
>  	 */
>  	smp_wmb();
> -	if (tail)
> -		list_add_tail(&work->entry, &cwq->worklist);
> -	else
> -		list_add(&work->entry, &cwq->worklist);
> +	plist_node_init(&work->entry, prio);
> +	plist_add(&work->entry, &cwq->worklist);
> +
> +	if (prio < cwq->thread->prio)
> +		task_setprio(cwq->thread, prio);
>  	wake_up(&cwq->more_work);
>  }
>
