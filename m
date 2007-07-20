Return-Path: <linux-kernel-owner+w=401wt.eu-S1765496AbXGTOOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765496AbXGTOOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764083AbXGTOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:14:06 -0400
Received: from mail.screens.ru ([213.234.233.54]:37464 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbXGTOOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:14:04 -0400
Date: Fri, 20 Jul 2007 18:15:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jeremy Katz <jeremy.katz@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
Message-ID: <20070720141529.GA218@tv-sign.ru>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> <1184662429.12353.426.camel@chaos> <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain> <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain> <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain> <20070718161156.GA761@tv-sign.ru> <Pine.LNX.4.63.0707181203110.3157@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0707181203110.3157@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Jeremy Katz wrote:
>
> On Wed, 18 Jul 2007, Oleg Nesterov wrote:
> 
> >Jeremy, I agree with Thomas that your patch should not be right, but it
> >does make a difference. Perhaps this is just the timing, but who knows.
> >Could you add some printk's to be sure that lock_timer() actually fails
> >while it never should?
> 
> Agreed.
> 
> Unfortunately, adding any significant output appears to alter the 
> situation to the point where the issue either does not occur, or takes 
> significantly longer to surface.

No, no, I didn't mean any significant output. You changed itimer_delete()

	>  -       spin_lock_irqsave(&timer->it_lock, flags);
	>  +       /* timer already deleted? */
	>  +       if (lock_timer(timer->it_id, &flags) == NULL)
	>  +               return;

This change should not help, lock_timer() should always succeed here.
But since it makes a difference, we can make something like

	if (lock_timer(timer->it_id, &flags) == NULL) {
		printk("Impossible! but it happened.\n");
		return;
	}

The same for posix_timer_fn().


I still can't believe we have a double-free problem, this looks imposiible.
Do you see the

	"idr_remove called for id=%d which is not allocated.\n"

in syslog?


Could you try the patch below? Perhaps we have some wierd problem with
->sigq corruption.

Oleg.

--- t/kernel/posix-timers.c~	2007-06-29 14:45:04.000000000 +0400
+++ t/kernel/posix-timers.c	2007-07-20 18:07:59.000000000 +0400
@@ -443,13 +443,16 @@ static struct k_itimer * alloc_posix_tim
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
+	sigqueue_free(tmr->sigq);
+	tmr->sigq = NULL;
+
 	if (it_id_set) {
 		unsigned long flags;
 		spin_lock_irqsave(&idr_lock, flags);
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
-	sigqueue_free(tmr->sigq);
+
 	if (unlikely(tmr->it_process) &&
 	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
 		put_task_struct(tmr->it_process);
@@ -615,6 +618,7 @@ static struct k_itimer * lock_timer(time
 	} else
 		spin_unlock_irqrestore(&idr_lock, *flags);
 
+	BUG_ON(timr && !timr->sigq);
 	return timr;
 }
 

