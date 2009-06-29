Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZF2APe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZF2APe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZF2APZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:15:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38420 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZF2APY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:15:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Mon, 29 Jun 2009 02:15:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906281642500.7576-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906281642500.7576-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906290215.39517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009, Alan Stern wrote:
> On Sun, 28 Jun 2009, Rafael J. Wysocki wrote:
> 
> > It seems that if we do something like in the appended patch, then
> > cancel_work() and cancel_delayed_work_dequeue() can be used to simplify the
> > $subject patch slightly.
> 
> I merged your patch with my own work, leading to the patch below.
> 
> There were a bunch of things I didn't like about the existing code,
> particularly cancel_delayed_work.  To start with, it seems like a large
> enough routine that it shouldn't be inlined.

Agreed.

> More importantly, it foolishly calls del_timer_sync, resulting in the
> unnecessary restriction that it cannot be used in_interrupt.  Finally,
> although it will deactivate a delayed_work's timer, it doesn't even try to
> remove the item from the workqueue if the timer has already expired.
> 
> Your cancel_delayed_work_dequeue is better -- so much better that I
> don't see any reason to keep the original cancel_delayed_work at all.  
> I got rid of it and used your routine instead.
> 
> I also changed the comments you wrote for cancel_work.  You can see 
> that now they are much more explicit and complete.
> 
> The original version of __cancel_work_timer is not safe to use
> in_interrupt.  If it is called from a handler whose IRQ interrupted
> delayed_work_timer_fn, it can loop indefinitely.

Right, I overlooked that.

> Therefore I added a check; if it finds that the work_struct is currently
> being enqueued and it is running in_interrupt, it gives up right away.

Hmm, it doesn't do the work_clear_pending(work) in that case, so we allow
the work to be queued and run?  Out of couriosity, what the caller is supposed
to do then?

> There are a few other improvements too.
> 
> Consequently it is now safe to call cancel_work and cancel_delayed_work
> in_interrupt or while holding a spinlock.  This means you can use these
> functions to cancel the various PM runtime work items whenever needed.  
> As a result, you don't need two work_structs in dev_pm_info; a single
> delayed_work will be enough.

Yes, I'm going to rebase the framework patch on top of this one.

> Tell me what you think.

I like the patch. :-)

Best,
Rafael

 
> Index: usb-2.6/include/linux/workqueue.h
> ===================================================================
> --- usb-2.6.orig/include/linux/workqueue.h
> +++ usb-2.6/include/linux/workqueue.h
> @@ -223,24 +223,10 @@ int execute_in_process_context(work_func
>  extern int flush_work(struct work_struct *work);
>  
>  extern int cancel_work_sync(struct work_struct *work);
> -
> -/*
> - * Kill off a pending schedule_delayed_work().  Note that the work callback
> - * function may still be running on return from cancel_delayed_work(), unless
> - * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
> - * cancel_work_sync() to wait on it.
> - */
> -static inline int cancel_delayed_work(struct delayed_work *work)
> -{
> -	int ret;
> -
> -	ret = del_timer_sync(&work->timer);
> -	if (ret)
> -		work_clear_pending(&work->work);
> -	return ret;
> -}
> +extern int cancel_work(struct work_struct *work);
>  
>  extern int cancel_delayed_work_sync(struct delayed_work *work);
> +extern int cancel_delayed_work(struct delayed_work *dwork);
>  
>  /* Obsolete. use cancel_delayed_work_sync() */
>  static inline
> Index: usb-2.6/kernel/workqueue.c
> ===================================================================
> --- usb-2.6.orig/kernel/workqueue.c
> +++ usb-2.6/kernel/workqueue.c
> @@ -465,6 +465,7 @@ static int try_to_grab_pending(struct wo
>  {
>  	struct cpu_workqueue_struct *cwq;
>  	int ret = -1;
> +	unsigned long flags;
>  
>  	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
>  		return 0;
> @@ -478,7 +479,7 @@ static int try_to_grab_pending(struct wo
>  	if (!cwq)
>  		return ret;
>  
> -	spin_lock_irq(&cwq->lock);
> +	spin_lock_irqsave(&cwq->lock, flags);
>  	if (!list_empty(&work->entry)) {
>  		/*
>  		 * This work is queued, but perhaps we locked the wrong cwq.
> @@ -491,7 +492,7 @@ static int try_to_grab_pending(struct wo
>  			ret = 1;
>  		}
>  	}
> -	spin_unlock_irq(&cwq->lock);
> +	spin_unlock_irqrestore(&cwq->lock, flags);
>  
>  	return ret;
>  }
> @@ -536,18 +537,26 @@ static void wait_on_work(struct work_str
>  		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
>  }
>  
> -static int __cancel_work_timer(struct work_struct *work,
> +static int __cancel_work_timer(struct work_struct *work, bool wait,
>  				struct timer_list* timer)
>  {
>  	int ret;
>  
> -	do {
> -		ret = (timer && likely(del_timer(timer)));
> -		if (!ret)
> -			ret = try_to_grab_pending(work);
> -		wait_on_work(work);
> -	} while (unlikely(ret < 0));
> +	if (timer && likely(del_timer(timer))) {
> +		ret = 1;
> +		goto done;
> +	}
>  
> +	for (;;) {
> +		ret = try_to_grab_pending(work);
> +		if (likely(ret >= 0))
> +			break;
> +		if (in_interrupt())
> +			return ret;
> +	}
> +	if (ret == 0 && wait)
> +		wait_on_work(work);
> + done:
>  	work_clear_pending(work);
>  	return ret;
>  }
> @@ -575,11 +584,43 @@ static int __cancel_work_timer(struct wo
>   */
>  int cancel_work_sync(struct work_struct *work)
>  {
> -	return __cancel_work_timer(work, NULL);
> +	return __cancel_work_timer(work, true, NULL);
>  }
>  EXPORT_SYMBOL_GPL(cancel_work_sync);
>  
>  /**
> + * cancel_work - try to cancel a pending work_struct.
> + * @work: the work_struct to cancel
> + *
> + * Try to cancel a pending work_struct before it starts running.
> + * Upon return, @work may safely be reused if the return value
> + * is 1 or the return value is 0 and the work callback function
> + * doesn't resubmit @work.
> + *
> + * The callback function may be running upon return if the return value
> + * is <= 0; use cancel_work_sync() to wait for the callback function
> + * to finish.
> + *
> + * There's not much point using this routine unless you can guarantee
> + * that neither the callback function nor anything else is in the
> + * process of submitting @work (or is about to do so).  The only good
> + * reason might be that optimistically trying to cancel @work has less
> + * overhead than letting it go ahead and run.
> + *
> + * This routine may be called from interrupt context.
> + *
> + * Returns: 1 if @work was removed from its workqueue,
> + *	    0 if @work was not pending (may be running),
> + *	   -1 if @work was concurrently being enqueued and we were
> + *		called in_interrupt.
> + */
> +int cancel_work(struct work_struct *work)
> +{
> +	return __cancel_work_timer(work, false, NULL);
> +}
> +EXPORT_SYMBOL_GPL(cancel_work);
> +
> +/**
>   * cancel_delayed_work_sync - reliably kill off a delayed work.
>   * @dwork: the delayed work struct
>   *
> @@ -590,10 +631,24 @@ EXPORT_SYMBOL_GPL(cancel_work_sync);
>   */
>  int cancel_delayed_work_sync(struct delayed_work *dwork)
>  {
> -	return __cancel_work_timer(&dwork->work, &dwork->timer);
> +	return __cancel_work_timer(&dwork->work, true, &dwork->timer);
>  }
>  EXPORT_SYMBOL(cancel_delayed_work_sync);
>  
> +/**
> + * cancel_delayed_work - try to cancel a delayed_work_struct.
> + * @dwork: the delayed_work_struct to cancel
> + *
> + * Try to cancel a pending delayed_work, either by deactivating its
> + * timer or by removing it from its workqueue.  This routine is just
> + * like cancel_work() except that it handles a delayed_work.
> + */
> +int cancel_delayed_work(struct delayed_work *dwork)
> +{
> +	return __cancel_work_timer(&dwork->work, false, &dwork->timer);
> +}
> +EXPORT_SYMBOL(cancel_delayed_work);
> +
>  static struct workqueue_struct *keventd_wq __read_mostly;
>  
>  /**
