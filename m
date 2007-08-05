Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbXHEPY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbXHEPY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXHEPYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:24:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:49232 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbXHEPYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:24:50 -0400
Date: Sun, 5 Aug 2007 19:27:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] exit_notify: don't take tasklist for TIF_SIGPENDING re-targeting
Message-ID: <20070805152709.GA2528@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

->siglock provides enough protection to iterate over the thread group.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~3_SIGPEND	2007-08-05 18:54:09.000000000 +0400
+++ t/kernel/exit.c	2007-08-05 19:16:38.000000000 +0400
@@ -756,13 +756,11 @@ static void exit_notify(struct task_stru
 		 * Now we'll wake all the threads in the group just to make
 		 * sure someone gets all the pending signals.
 		 */
-		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		for (t = next_thread(tsk); t != tsk; t = next_thread(t))
 			if (!signal_pending(t) && !(t->flags & PF_EXITING))
 				recalc_sigpending_and_wake(t);
 		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
 	}
 
 	write_lock_irq(&tasklist_lock);
@@ -790,9 +788,8 @@ static void exit_notify(struct task_stru
 	 * and we were the only connection outside, so our pgrp
 	 * is about to become orphaned.
 	 */
-	 
 	t = tsk->real_parent;
-	
+
 	pgrp = task_pgrp(tsk);
 	if ((task_pgrp(t) != pgrp) &&
 	    (task_session(t) == task_session(tsk)) &&

