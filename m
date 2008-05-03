Return-Path: <linux-kernel-owner+w=401wt.eu-S1763890AbYECRh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763890AbYECRh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763870AbYECRgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:36:15 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47531 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763655AbYECRgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:36:14 -0400
Date: Sat, 3 May 2008 21:35:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);
Message-ID: <20080503173554.GA8112@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_posix_timer() can't be called with ->it_process != NULL. Once
sys_timer_create() sets ->it_process it must not call release_posix_timer(),
otherwise we can race with another thread doing sys_timer_delete(), this timer
is visible to idr_find() and unlocked.

The same is true for two other callers (actually, for any possible caller),
sys_timer_delete() and itimer_delete(). They must clear ->it_process before
unlock_timer() + release_posix_timer().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/posix-timers.c~4_RPT_NO_CHECK	2008-05-03 19:55:27.000000000 +0400
+++ 25/kernel/posix-timers.c	2008-05-03 20:13:36.000000000 +0400
@@ -450,9 +450,6 @@ static void release_posix_timer(struct k
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
 	sigqueue_free(tmr->sigq);
-	if (unlikely(tmr->it_process) &&
-	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(tmr->it_process);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 

