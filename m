Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYEQPOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYEQPOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbYEQPNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:13:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47506 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbYEQPNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:13:36 -0400
Date: Sat, 17 May 2008 19:14:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);
Message-ID: <20080517151420.GA9493@tv-sign.ru>
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
Acked-by: Roland McGrath <roland@redhat.com>

--- 25/kernel/posix-timers.c~3_RPT_NO_CHECK	2008-05-17 16:31:26.000000000 +0400
+++ 25/kernel/posix-timers.c	2008-05-17 16:38:07.000000000 +0400
@@ -450,9 +450,6 @@ static void release_posix_timer(struct k
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
 	sigqueue_free(tmr->sigq);
-	if (unlikely(tmr->it_process) &&
-	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(tmr->it_process);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 

