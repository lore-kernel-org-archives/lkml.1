Return-Path: <linux-kernel-owner+w=401wt.eu-S934775AbXGQSkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775AbXGQSkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbXGQSkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:40:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:58504 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbXGQSkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:40:40 -0400
Date: Tue, 17 Jul 2007 11:39:43 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <1184662429.12353.426.camel@chaos>
Message-ID: <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
 <1184662429.12353.426.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 17 Jul 2007 18:39:43.0126 (UTC) FILETIME=[D7543B60:01C7C8A1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Jul 2007, Thomas Gleixner wrote:

> Jeremy Katz experienced a posix-timer related bug on 2.6.14. This is
> caused by a subtle race, which is there since the original posix timer
> commit and persists until today.
>
> timer_delete does:
> lock_timer();
> timer->it_process = NULL;
> unlock_timer();
> release_posix_timer();
>
> timer->it_process is checked in lock_timer() to prevent access to a
> timer, which is on the way to be deleted, but the check happens after
> idr_lock is dropped. This allows release_posix_timer() to delete the
> timer before the lock code can check the timer:
>
> CPU 0				CPU 1
> lock_timer();
> timer->it_process = NULL;
> unlock_timer();
> 				lock_timer()
> 					spin_lock(idr_lock);
> 					timer = idr_find();
> 					spin_lock(timer->lock);
> 					spin_unlock(idr_lock);
> release_posix_timer();
> 	spin_lock(idr_lock);
> 	idr_remove(timer);
> 	spin_unlock(idr_lock);
> 	free_timer(timer);
> 					if (timer->......)
>
> Change the locking to prevent this.

I tried the patch with my test case, but still see the issue.
Here's my explanation of the double free race:
CPU 0					CPU 1
sys_timer_delete():
 	lock_timer();
 	...
 	unlock_timer();			itimer_delete()
 	release_posix_timer():			spin_lock_irqsave(timer...)
 		...				...
 		sigqueue_free()			unlock_timer()
 		...				sigqueue_free()
 							BUG_ON(!(q->flags...


the timer fires during deletion:
CPU 0					CPU 1
sys_timer_delete():
 	lock_timer();
 	...
 	unlock_timer();			posix_timer_fn()
 	release_posix_timer():			spin_lock_irqsave(timer...)
 		...				...
 		sigqueue_free()			posix_timer_event()
 		...					...
 							send_sigqueue()
 								BUG_ON(!(q->flags

Currently, this appears to fix the problem.  The system survived 19 hours 
before I rebooted to try other things, while the I usually see at least 
one of the BUGs within 15 minutes.


--- linux-2.6.14-cgl.original/kernel/posix-timers.c	2007-07-11 16:06:47.000000000 -0700
+++ linux-2.6.14-cgl/kernel/posix-timers.c	2007-07-16 15:25:43.000000000 -0700
@@ -339,7 +339,9 @@ static int posix_timer_fn(void *data)
  	int si_private = 0;
  	int ret = HRTIMER_NORESTART;

-	spin_lock_irqsave(&timr->it_lock, flags);
+	if(lock_timer(timr->it_id, &flags) == NULL) {
+		return ret;
+	}

  	if (timr->it.real.interval.tv64 != 0)
  		si_private = ++timr->it_requeue_pending;
@@ -411,8 +413,10 @@ static void release_posix_timer(struct k
  {
  	if (it_id_set) {
  		unsigned long flags;
+		/* unmangle timer id */
+		int it_id = tmr->it_id & INT_MAX;
  		spin_lock_irqsave(&idr_lock, flags);
-		idr_remove(&posix_timers_id, tmr->it_id);
+		idr_remove(&posix_timers_id, it_id);
  		spin_unlock_irqrestore(&idr_lock, flags);
  	}
  	sigqueue_free(tmr->sigq);
@@ -545,8 +549,11 @@ sys_timer_create(const clockid_t which_c
  	 */

  out:
-	if (error)
+	if (error) {
+		/* mangle the timer id for the release */
+		new_timer->it_id |= ~INT_MAX;
  		release_posix_timer(new_timer, it_id_set);
+	}

  	return error;
  }
@@ -822,6 +829,8 @@ retry_delete:
  			put_task_struct(timer->it_process);
  		timer->it_process = NULL;
  	}
+	/* mangle the timer ID to prevent anyone else from finding it */
+	timer->it_id |= ~INT_MAX;
  	unlock_timer(timer, flags);
  	release_posix_timer(timer, IT_ID_SET);
  	return 0;
@@ -835,7 +844,9 @@ static inline void itimer_delete(struct
  	unsigned long flags;

  retry_delete:
-	spin_lock_irqsave(&timer->it_lock, flags);
+	/* timer already deleted? */
+	if (lock_timer(timer->it_id, &flags) == NULL)
+		return;

  	if (timer_delete_hook(timer) == TIMER_RETRY) {
  		unlock_timer(timer, flags);
@@ -851,6 +862,8 @@ retry_delete:
  			put_task_struct(timer->it_process);
  		timer->it_process = NULL;
  	}
+	/* mangle the timer ID to prevent anyone else from finding it */
+	timer->it_id |= ~INT_MAX;
  	unlock_timer(timer, flags);
  	release_posix_timer(timer, IT_ID_SET);
  }
