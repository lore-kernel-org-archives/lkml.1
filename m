Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYFMPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYFMPPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbYFMPPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:15:21 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34440 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYFMPPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:15:20 -0400
Date: Fri, 13 Jun 2008 19:17:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of "int tail"
Message-ID: <20080613151725.GA9194@tv-sign.ru>
References: <20080612165120.GA12177@tv-sign.ru> <20080612165550.GA12183@tv-sign.ru> <1213290074.31518.136.camel@twins> <20080612174433.GA12204@tv-sign.ru> <1213295939.31518.159.camel@twins> <20080613142658.GA9147@tv-sign.ru> <1213368184.16944.20.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213368184.16944.20.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Peter Zijlstra wrote:
>
> On Fri, 2008-06-13 at 18:26 +0400, Oleg Nesterov wrote:
> > 
> > Yes, we have a free bit... but afaics we can do better.
> > 
> > 	struct context_barrier {
> > 		struct work_struct   work;
> > 		struct flush_context *fc;
> > 		...
> > 	}
> > 
> > 	void context_barrier_barrier_func(struct work_struct *work)
> > 	{
> > 		struct flush_context *fc = container_of();
> > 		if (atomic_dec_and_test())
> > 			...
> > 	}
> > 
> > 	void insert_context_barrier(work, barr)
> > 	{
> > 		...insert barr after work, like flush_work() does...
> > 	}
> > 
> > 	queue_work_contex(struct workqueue_struct *wq,
> > 			  struct work_struct *work,
> > 			  struct flush_context *fc)
> > 	{
> > 		int ret = queue_work(wq, work);
> > 		if (ret)
> > 			insert_context_barrier(work, barr);
> > 		return ret;
> > 	}
> > 
> > this way we shouldn't change run_workqueue() and introduce a "parallel"
> > larger work_struct which needs its own INIT_()/etc.
> 
> Where does do the context_barrier instances come from, are they
> allocated in insert_context_barrier() ?

Ah, indeed. We have to kmalloc() or use a larger work_struct... And if we
use a larger work_struct, we can make

	struct work_struct_context
	{
		struct work_struct work;
		work_func_t real_func;
		struct flush_context *fc;
	};

	static void work_context_func(struct work_struct *work)
	{
		struct work_struct_context *wc = container_of();
		struct flush_context *fc = wc->context;

		wc->real_func(work);

		if (atomic_dec_and_test(fc->count))
			...
	}

to avoid changing run_workqueue(), but this is nasty. Perhaps flush_context
can be just array or list of queued work_structs, then we can do flush_work()
for each work_struct...

> > > making all this PI savvy for -rt is going to be fun though.. I guess we
> > > can just queue a normal barrier of the flusher's priority, and cancel it
> > > once we complete.. hey - that doesn't sound hard at all :-)
> >
> > Yes!!! I think this is much better (because _much_ simple) than re-ordering
> > the pending work_struct's, we can just boost the whole ->worklist. We can
> > implement flush_work_pi() in the same manner as queue_work_contex() above.
> > That is why I said previously that flush_() should govern the priority,
> > not queue.
> >
> > But we can also implement queue_work_pi(struct work_struct_pi *work).
>
> in -rt all the workqueue stuff is PI already, we replaced the list_head
> in work_struct with a plist_node and queue_work() enqueues worklets at
> the ->normal_prio of the calling task.

Oh well. IIRC, these patches really uglified^Wcompicated the code. Don't
get me wrong, if I knew how to make this better, I'd sent the patch ;)

> Hmm, the required barrier might still spoil - or at least complicate the
> matter.
>
> In order to boost the pending work, we'd need to enqueue a barrer before
> the high prio worklet - otherwise the high prio worklet will complete
> before the work we're waiting on.

flush_work_pi() can boost the priority, and then barrier restores it.
Can't this work?

> And we can cancel the high prio worklet once all our worklets of
> interrest are done, but we cannot cancel the barrier.

Yes, if we cancel the high prio worklet, this doesn't restore the prio
immediately.

Oleg.

