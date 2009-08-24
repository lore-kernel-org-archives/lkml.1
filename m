Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbZHXIG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbZHXIG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbZHXIGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:06:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57399 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZHXIGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:06:25 -0400
Date: Mon, 24 Aug 2009 10:06:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/6] workqueue: add support for lazy workqueues
Message-ID: <20090824080626.GD12579@kernel.dk>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com> <1250763466-24282-2-git-send-email-jens.axboe@oracle.com> <1250763466-24282-3-git-send-email-jens.axboe@oracle.com> <1250763466-24282-4-git-send-email-jens.axboe@oracle.com> <1250763466-24282-5-git-send-email-jens.axboe@oracle.com> <20090820172027.cdc41d1e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820172027.cdc41d1e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20 2009, Andrew Morton wrote:
> On Thu, 20 Aug 2009 12:17:39 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Lazy workqueues are like normal workqueues, except they don't
> > start a thread per CPU by default. Instead threads are started
> > when they are needed, and exit when they have been idle for
> > some time.
> > 
> >
> > ...
> >
> > @@ -280,7 +309,34 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
> >  		trace_workqueue_execution(cwq->thread, work);
> >  		cwq->current_work = work;
> >  		list_del_init(cwq->worklist.next);
> > +		cpu = smp_processor_id();
> >  		spin_unlock_irq(&cwq->lock);
> > +		did_work = 1;
> > +
> > +		/*
> > +		 * If work->cpu isn't us, then we need to create the target
> > +		 * workqueue thread (if someone didn't already do that) and
> > +		 * move the work over there.
> > +		 */
> > +		if ((cwq->wq->flags & WQ_F_LAZY) && work->cpu != cpu) {
> > +			struct cpu_workqueue_struct *__cwq;
> > +			struct task_struct *p;
> > +			int err;
> > +
> > +			__cwq = wq_per_cpu(cwq->wq, work->cpu);
> > +			p = __cwq->thread;
> > +			if (!p)
> > +				err = create_workqueue_thread(__cwq, work->cpu);
> > +			p = __cwq->thread;
> > +			if (p) {
> > +				if (work->cpu >= 0)
> 
> It's an unsigned int.  This test is always true.
> 
> > +					kthread_bind(p, work->cpu);
> 
> I wonder what happens if work->cpu isn't online any more.

That's a good question. The workqueue "documentation" states that it is
the callers responsibility to ensure that the CPU stays online, but I
think that requirement is pretty much ignored. Probably since it'd be
costly to do.

So that bits needs looking into.

-- 
Jens Axboe

