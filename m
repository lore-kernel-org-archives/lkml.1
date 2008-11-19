Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYKSO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYKSO7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYKSO7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:59:07 -0500
Received: from ms01.sssup.it ([193.205.80.99]:54862 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753039AbYKSO7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:59:06 -0500
Date: Wed, 19 Nov 2008 16:02:26 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exiting queue and task might race to free cic
Message-ID: <20081119150226.GD20915@gandalf.sssup.it>
References: <200811191527.18539.knikanth@suse.de> <20081119141531.GG26308@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119141531.GG26308@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, Nov 19, 2008 03:15:31PM +0100
>
> On Wed, Nov 19 2008, Nikanth Karthikesan wrote:
> > Hi Jens
> > 
> > Looking at the bug reported here
> > http://thread.gmane.org/gmane.linux.kernel/722539
> > it looks like an exiting queue can race with an exiting task.
> > 
> > When a queue exits the queue lock is taken and cfq_exit_queue() would free all 
> > the cic's associated with the queue.
> > 
> > But when a task exits, cfq_exit_io_context() gets cic one by one and then 
> > locks the associated queue to call __cfq_exit_single_io_context. It looks like 
> > between getting a cic from the ioc and locking the queue, the queue might have 
> > exited on another cpu. Isn't this possible?
> > 
> > If possible, either verifying whether cic->key is still not null or q->flags 
> > does not have QUEUE_FLAG_DEAD set would fix this.
> > 
> > Thanks
> > Nikanth Karthikesan
> > 
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> > 
> > ---
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 6a062ee..b9b627a 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -1318,7 +1318,12 @@ static void cfq_exit_single_io_context(struct 
> > io_context *ioc,
> >  		unsigned long flags;
> >  
> >  		spin_lock_irqsave(q->queue_lock, flags);
> > -		__cfq_exit_single_io_context(cfqd, cic);
> > +		/*
> > +		 * cic might have been already exited when an exiting task
> > +		 * races with an exiting queue.
> > +		 */
> > +		if (likely(cic->key))
> > +			__cfq_exit_single_io_context(cfqd, cic);
> >  		spin_unlock_irqrestore(q->queue_lock, flags);
> >  	}
> >  }
> 
> Not sure this is enough, we probably need to copy the key to ensure that
> we get a fresh value. How does this look?
> 
> Did you actually trigger this, or is it just from code inspection?
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 6a062ee..560cd1c 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1318,7 +1318,14 @@ static void cfq_exit_single_io_context(struct io_context *ioc,
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(q->queue_lock, flags);
> -		__cfq_exit_single_io_context(cfqd, cic);
> +
> +		/*
> +		 * Ensure we get a fresh copy of the ->key to prevent
> +		 * race between exiting task and queue
> +		 */
> +		smp_read_barrier_depends();
> +		if (cic->key)
> +			__cfq_exit_single_io_context(cfqd, cic);
>  		spin_unlock_irqrestore(q->queue_lock, flags);
>  	}
>  }
> 

I've seen once the oops reported (the BUG() now @ line 1247), but I've
never been able to reproduce it afterwards.  I think that there still
is a window open for a race here:

1314 struct cfq_data *cfqd = cic->key;
1315

=====> here cfq_exit_queue() can free cfqd and assign cic->key = NULL,
       and accessing cfqd->queue is not safe.  [ If I'm not wrong :) ]

1316 if (cfqd) {
1317         struct request_queue *q = cfqd->queue;
