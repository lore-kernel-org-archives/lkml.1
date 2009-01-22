Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZAVJj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZAVJj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZAVJjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:39:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:38377 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbZAVJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vd5/XVgIqIuY4tFpTtP8RQJPP9Lw1VXHEGdioFUBrRfw4OXJcbZLbBk9jA/MxpV8aX
         SWkPuf/9/4Rl6JzdfQENjN/g6pL85O+/AqyUJrN2ijAIEVn/sKkxfJ5a/Wt4Ysj5cHyW
         gJ403KruaXLKYJrSMm1EnaY+9LHz1Ff/uQgB0=
Date: Thu, 22 Jan 2009 10:39:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090122093937.GA6009@nowhere>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122093046.GC5891@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 10:30:46AM +0100, Frederic Weisbecker wrote:
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
> 
> Thanks.
> Frederic.


And perhaps add a comment for the developers who will encounter such a warn,
and then fall down in this call site while searching which warned.
To easily find the reason of the WARN. cwq->thread == current is perhaps not
verbose enough to help the developer finding the source of the problem.

They could solve the issue and say "Doh!" more quickly if they find
in a one shot sight: /* Never flush a workqueue from a work */

:-)

 
>  
> > -		active = 0;
> > -		spin_lock_irq(&cwq->lock);
> > -		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> > -			insert_wq_barrier(cwq, &barr, &cwq->worklist);
> > -			active = 1;
> > -		}
> > -		spin_unlock_irq(&cwq->lock);
> > -
> > -		if (active)
> > -			wait_for_completion(&barr.done);
> > +	spin_lock_irq(&cwq->lock);
> > +	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> > +		insert_wq_barrier(cwq, &barr, &cwq->worklist);
> > +		active = 1;
> >  	}
> > +	spin_unlock_irq(&cwq->lock);
> > +
> > +	if (active)
> > +		wait_for_completion(&barr.done);
> >  
> >  	return active;
> >  }
> > 

