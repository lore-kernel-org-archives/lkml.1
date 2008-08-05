Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYHEP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYHEP3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYHEP2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:28:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54658 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103AbYHEP2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:28:36 -0400
Date: Tue, 5 Aug 2008 19:32:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] posix-timers: lock_timer: make it readable
Message-ID: <20080805153213.GA9754@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Imho makes the code much more understandable. At least this
patch lessens both the source and compiled code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~10_LOCK_TIMER	2008-08-05 17:56:33.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-05 18:53:19.000000000 +0400
@@ -557,7 +557,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer * lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 	/*
@@ -565,23 +565,20 @@ static struct k_itimer * lock_timer(time
 	 * flags part over to the timer lock.  Must not let interrupts in
 	 * while we are moving the lock.
 	 */
-
 	spin_lock_irqsave(&idr_lock, *flags);
-	timr = idr_find(&posix_timers_id, (int) timer_id);
+	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-
-		if (!timr->it_process ||
-		    !same_thread_group(timr->it_process, current)) {
-			spin_unlock(&timr->it_lock);
-			spin_unlock_irqrestore(&idr_lock, *flags);
-			timr = NULL;
-		} else
+		if (timr->it_process &&
+		    same_thread_group(timr->it_process, current)) {
 			spin_unlock(&idr_lock);
-	} else
-		spin_unlock_irqrestore(&idr_lock, *flags);
+			return timr;
+		}
+		spin_unlock(&timr->it_lock);
+	}
+	spin_unlock_irqrestore(&idr_lock, *flags);
 
-	return timr;
+	return NULL;
 }
 
 /*

