Return-Path: <linux-kernel-owner+w=401wt.eu-S935718AbXHLRC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935718AbXHLRC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbXHLRCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:02:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52860 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760129AbXHLRCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:02:51 -0400
Date: Sun, 12 Aug 2007 21:05:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 1/4] posix-timers: fix deletion race
Message-ID: <20070812170505.GA4295@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

timer_delete does:
lock_timer();
timer->it_process = NULL;
unlock_timer();
release_posix_timer();

timer->it_process is checked in lock_timer() to prevent access to a
timer, which is on the way to be deleted, but the check happens after
idr_lock is dropped. This allows release_posix_timer() to delete the
timer before the lock code can check the timer:

CPU 0				CPU 1
lock_timer();			
timer->it_process = NULL;
unlock_timer();
				lock_timer()
					spin_lock(idr_lock);
					timer = idr_find();
					spin_lock(timer->lock);
					spin_unlock(idr_lock);
release_posix_timer();
	spin_lock(idr_lock);
	idr_remove(timer);
	spin_unlock(idr_lock);
	free_timer(timer);
					if (timer->......)

Change the locking to prevent this.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

--- t/kernel/posix-timers.c~1_THOMAS	2007-07-28 16:58:17.000000000 +0400
+++ t/kernel/posix-timers.c	2007-08-12 17:59:17.000000000 +0400
@@ -605,13 +605,14 @@ static struct k_itimer * lock_timer(time
 	timr = (struct k_itimer *) idr_find(&posix_timers_id, (int) timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		spin_unlock(&idr_lock);
 
 		if ((timr->it_id != timer_id) || !(timr->it_process) ||
 				timr->it_process->tgid != current->tgid) {
-			unlock_timer(timr, *flags);
+			spin_unlock(&timr->it_lock);
+			spin_unlock_irqrestore(&idr_lock, *flags);
 			timr = NULL;
-		}
+		} else
+			spin_unlock(&idr_lock);
 	} else
 		spin_unlock_irqrestore(&idr_lock, *flags);
 

