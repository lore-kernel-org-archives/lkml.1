Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbXGQIyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbXGQIyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759547AbXGQIxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:53:53 -0400
Received: from www.osadl.org ([213.239.205.134]:55588 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758823AbXGQIxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:53:52 -0400
Subject: [PATCH] posix-timer: fix deletion race
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Katz <jeremy.katz@windriver.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
In-Reply-To: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 10:53:49 +0200
Message-Id: <1184662429.12353.426.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Katz experienced a posix-timer related bug on 2.6.14. This is
caused by a subtle race, which is there since the original posix timer
commit and persists until today.

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

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 329ce01..c2ac6fd 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -605,13 +605,14 @@ static struct k_itimer * lock_timer(timer_t timer_id, unsigned long *flags)
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
 


