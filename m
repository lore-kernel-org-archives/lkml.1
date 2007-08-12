Return-Path: <linux-kernel-owner+w=401wt.eu-S936263AbXHLRDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936263AbXHLRDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935852AbXHLRDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:03:02 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52874 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935770AbXHLRDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:03:00 -0400
Date: Sun, 12 Aug 2007 21:05:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 2/4] posix-timers: fix creation race
Message-ID: <20070812170522.GA4299@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_timer_create() sets ->it_process and unlocks ->siglock, then checks
tmr->it_sigev_notify to define if get_task_struct() is needed.

We already passed ->it_id to the caller, another thread can delete this
timer and free its memory in between.

As a minimal fix, move this code under ->siglock, sys_timer_delete() takes
it too before calling release_posix_timer(). A proper serialization would
be to take ->it_lock, we add a partly initialized timer on posix_timers_id,
not good.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/posix-timers.c~2_CREATE	2007-08-12 17:59:17.000000000 +0400
+++ t/kernel/posix-timers.c	2007-08-12 18:11:33.000000000 +0400
@@ -547,13 +547,12 @@ sys_timer_create(const clockid_t which_c
 				new_timer->it_process = process;
 				list_add(&new_timer->list,
 					 &process->signal->posix_timers);
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
 					get_task_struct(process);
 			} else {
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 				process = NULL;
 			}
+			spin_unlock_irqrestore(&process->sighand->siglock, flags);
 		}
 		read_unlock(&tasklist_lock);
 		if (!process) {

