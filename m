Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbYHEP3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbYHEP3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757718AbYHEP2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:28:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54649 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913AbYHEP2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:28:34 -0400
Date: Tue, 5 Aug 2008 19:32:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] posix-timers: lock_timer: kill the bogus ->it_id check
Message-ID: <20080805153213.GA9751@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_timer() checks that the timer found by idr_find(timer_id) has
->it_id == timer_id. This buys nothing. This check can fail only if
sys_timer_create() unlocked idr_lock after idr_get_new(), but didn't
set ->it_id = new_timer_id yet. But in that case ->it_process == NULL
so lock_timer() can't succeed anyway.

Also remove a couple of unneeded typecasts.

Note that with or without this patch we have a small problem.
sys_timer_create() doesn't ensure that the result of setting (say)
->it_sigev_notify must be visible if lock_timer() succeeds.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~9_IT_ID	2008-08-05 16:48:22.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-05 17:56:33.000000000 +0400
@@ -475,8 +475,7 @@ sys_timer_create(const clockid_t which_c
 		goto out;
 	}
 	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, (void *) new_timer,
-			    &new_timer_id);
+	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
 	spin_unlock_irq(&idr_lock);
 	if (error) {
 		if (error == -EAGAIN)
@@ -568,12 +567,12 @@ static struct k_itimer * lock_timer(time
 	 */
 
 	spin_lock_irqsave(&idr_lock, *flags);
-	timr = (struct k_itimer *) idr_find(&posix_timers_id, (int) timer_id);
+	timr = idr_find(&posix_timers_id, (int) timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
 
-		if ((timr->it_id != timer_id) || !(timr->it_process) ||
-				!same_thread_group(timr->it_process, current)) {
+		if (!timr->it_process ||
+		    !same_thread_group(timr->it_process, current)) {
 			spin_unlock(&timr->it_lock);
 			spin_unlock_irqrestore(&idr_lock, *flags);
 			timr = NULL;

