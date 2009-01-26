Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZAZWdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZAZWdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZAZWdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:33:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbZAZWdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:33:05 -0500
Date: Mon, 26 Jan 2009 14:32:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-input@vger.kernel.org
Subject: Re: [PATCH] psmouse: run kpsmoused only while needed
Message-Id: <20090126143210.ce6a4503.akpm@linux-foundation.org>
In-Reply-To: <496fd1d3.0d135e0a.171b.43ea@mx.google.com>
References: <496fd1d3.0d135e0a.171b.43ea@mx.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 16:16:19 -0800 (PST)
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> While looking at the workqueue tracer, I noticed that kpsmoused receives
> rarely (if not never) events.
> 
> Currently, when a mouse has to resync, it uses the kpsmoused singlethreaded
> workqueue. But recync are rare. While reading an old discussion, it seems
> that usual workqueue events can't be used for that purpose because resync
> can take too much time and could delay the other works in queue.
> 
> But if you have built psmouse driver, this workqueue will always be present
> whether you have a ps/2 port or not. And its events are rare.
> 
> To avoid this pointless task, this patch makes the kpsmoused a kernel
> thread only created on the fly when a recync is needed. Once the recync is done,
> this thread will die. So you will almost never see it, and it will not be
> an inactive task anymore.
> 
> This thread is created through a usual workqueue event (because we can't create
> it from interrupt).
> 

Seems like a reasonable objective.

>
> ...
>
>  /*
>   * __psmouse_set_state() sets new psmouse state and resets all flags.
> @@ -313,7 +307,8 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
>  		       psmouse->name, psmouse->phys, psmouse->pktcnt);
>  		psmouse->badbyte = psmouse->packet[0];
>  		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
> -		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
> +		atomic_inc(&psmouse->nb_recync_pending);

The patch and the changelog consistently misspell "sync".

A code comment (in psmouse.h) which clearly spells out the role of
nb_recync_pending would be useful.

> +		schedule_work(&psmouse->resync_work);
>  		goto out;
>  	}
>  
>
> ...
>
> @@ -1131,7 +1155,13 @@ static void psmouse_disconnect(struct serio *serio)
>  
>  	/* make sure we don't have a resync in progress */
>  	mutex_unlock(&psmouse_mutex);
> -	flush_workqueue(kpsmoused_wq);
> +
> +	prepare_to_wait(&psmouse->recync_pending_queue, &wait,
> +				TASK_UNINTERRUPTIBLE);
> +	if (atomic_read(&psmouse->nb_recync_pending))
> +		schedule();
> +	finish_wait(&psmouse->recync_pending_queue, &wait);

So... we're requiring that nb_recync_pending is zero at this stage?

I wonder if the code manages to do that.  A little WARN_ON(), maybe?

>  	mutex_lock(&psmouse_mutex);
>  

