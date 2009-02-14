Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbZBNAGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbZBNAGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZBNAGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:06:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZBNAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:06:05 -0500
Date: Fri, 13 Feb 2009 16:05:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH v2] psmouse: run kpsmoused only while needed
Message-Id: <20090213160526.b5d619e6.akpm@linux-foundation.org>
In-Reply-To: <4984ec6a.0637560a.3217.4534@mx.google.com>
References: <4984ec6a.0637560a.3217.4534@mx.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 16:27:22 -0800 (PST)
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> While looking at the workqueue tracer, I noticed that kpsmoused receives
> rarely (if not never) events.
> 
> Currently, when a mouse has to resync, it uses the kpsmoused singlethreaded
> workqueue. But resync are rare. While reading an old discussion, it seems
> that usual workqueue events can't be used for that purpose because resync
> can take too much time and could delay the other works in queue.
> 
> But if you have built psmouse driver, this workqueue will always be present
> whether you have a ps/2 port or not. And its events are rare.
> 
> To avoid this pointless task, this patch makes the kpsmoused a kernel
> thread only created on the fly when a resync is needed. Once the resync is done,
> this thread will die. So you will almost never see it, and it will not be
> an inactive task anymore.
> 
> This thread is created through a usual workqueue event (because we can't create
> it from interrupt).
> 
> Changes in V2:
> 
> _ fix the "resync" mispelled in the patch and the changelog
> _ don't schedule more than one resync in case of concurrent interrupts
> _ if resync_pending is not cleared after a few time before disconnect, print a warning.
> 

This patch seems complicated.


> 
> diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
> index f8f86de..fc4490e 100644
> --- a/drivers/input/mouse/psmouse-base.c
> +++ b/drivers/input/mouse/psmouse-base.c
> @@ -20,6 +20,7 @@
>  #include <linux/init.h>
>  #include <linux/libps2.h>
>  #include <linux/mutex.h>
> +#include <linux/kthread.h>
>  
>  #include "psmouse.h"
>  #include "synaptics.h"
> @@ -104,8 +105,6 @@ static struct attribute_group psmouse_attribute_group = {
>   */
>  static DEFINE_MUTEX(psmouse_mutex);
>  
> -static struct workqueue_struct *kpsmoused_wq;
> -
>  struct psmouse_protocol {
>  	enum psmouse_type type;
>  	const char *name;
> @@ -203,11 +202,6 @@ static psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse)
>  	return PSMOUSE_FULL_PACKET;
>  }
>  
> -void psmouse_queue_work(struct psmouse *psmouse, struct delayed_work *work,
> -		unsigned long delay)
> -{
> -	queue_delayed_work(kpsmoused_wq, work, delay);
> -}
>  
>  /*
>   * __psmouse_set_state() sets new psmouse state and resets all flags.
> @@ -313,7 +307,10 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
>  		       psmouse->name, psmouse->phys, psmouse->pktcnt);
>  		psmouse->badbyte = psmouse->packet[0];
>  		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
> -		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
> +		if (atomic_inc_return(&psmouse->resync_pending) == 1)
> +			schedule_work(&psmouse->resync_work);
> +		else
> +			atomic_dec(&psmouse->resync_pending);
>  		goto out;
>  	}

This little trick looks inherently racy.  Suppose
psmouse_resync_thread_helper() is concurrently fiddling with
->resync_pending.

Dunno - maybe it isn't racy.  I can't really be bothered working it
out, because it should be obviosuly non-racy!

Can we remove ->resync_pending?  Just unconditionally do the
schedule_work()?  schedule_work() will take care of things
appropriately, won't it?

There is, I guess, a small possibility that we'll end up with two (or
more!) kernel threads running at the same time.  But the psmouse code
should be able to handle that appropriately.

> @@ -350,7 +347,11 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
>  	    time_after(jiffies, psmouse->last + psmouse->resync_time * HZ)) {
>  		psmouse->badbyte = psmouse->packet[0];
>  		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
> -		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
> +
> +		if (atomic_inc_return(&psmouse->resync_pending) == 1)
> +			schedule_work(&psmouse->resync_work);
> +		else
> +			atomic_dec(&psmouse->resync_pending);
>  		goto out;
>  	}
>  

etc.

>  
>  
>  /*
> - * psmouse_resync() attempts to re-validate current protocol.
> + * psmouse_resync_thread() attempts to re-validate current protocol.
> + * This thread is created on the fly when needed because its job can take too
> + * much time on events workqueues, and the resync is rare enough to avoid
> + * the need of a private workqueue.
>   */
>  
> -static void psmouse_resync(struct work_struct *work)
> +static int psmouse_resync_thread(void *v)
>  {
> -	struct psmouse *parent = NULL, *psmouse =
> -		container_of(work, struct psmouse, resync_work.work);
> +	struct psmouse *psmouse = v;
> +	struct psmouse *parent = NULL;
>  	struct serio *serio = psmouse->ps2dev.serio;
>  	psmouse_ret_t rc = PSMOUSE_GOOD_DATA;
>  	int failed = 0, enabled = 0;
> @@ -1072,6 +1076,30 @@ static void psmouse_resync(struct work_struct *work)
>  		psmouse_activate(parent);
>   out:
>  	mutex_unlock(&psmouse_mutex);
> +
> +	/*
> +	 * While disconnecting, the driver wants to be sure all resync are done
> +	 */
> +	atomic_dec(&psmouse->resync_pending);
> +	wake_up(&psmouse->resync_pending_queue);
> +	return 0;
> +}
> +
> +/* Launch the resync thread */
> +static void psmouse_resync_thread_helper(struct work_struct *work)
> +{
> +	struct task_struct *t;
> +	struct psmouse *psmouse;
> +
> +	psmouse = container_of(work, struct psmouse, resync_work);
> +
> +	t = kthread_run(psmouse_resync_thread, psmouse, "kpsmoused");
> +	if (t == ERR_PTR(-ENOMEM)) {
> +		printk(KERN_WARNING "psmouse.c: failed to create kpsmoused"
> +				    " thread\n");
> +		atomic_dec(&psmouse->resync_pending);
> +		wake_up(&psmouse->resync_pending_queue);
> +	}
>  }

I expect I asked before "can we use the kernel/async.c code for this".

It's such an obvious question that it should be covered in the
changelog.



