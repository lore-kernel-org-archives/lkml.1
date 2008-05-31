Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYEaQOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYEaQOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYEaQN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:13:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38341 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbYEaQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:13:58 -0400
Date: Sat, 31 May 2008 20:15:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: dequeue_signal: don't check SIGNAL_GROUP_EXIT when setting SIGNAL_STOP_DEQUEUED
Message-ID: <20080531161529.GA5563@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dequeue_signal() checks SIGNAL_GROUP_EXIT before setting SIGNAL_STOP_DEQUEUED.
This was added by 788e05a67c343fa22f2ae1d3ca264e7f15c25eaf a long ago to avoid
the coredump/SIGSTOP race.

Since then the related code was changed, and now this subtle check is both
incomplete and unneeded at the same time. It is incomplete because nowadays
exec() doesn't set SIGNAL_GROUP_EXIT, so in fact we should check
signal_group_exit() to avoid a similar race. Fortunately, we doesn't need
the check at all. The only function which relies on SIGNAL_STOP_DEQUEUED
is do_signal_stop(), and it ignores this flag if signal_group_exit() == T,
this covers the SIGNAL_GROUP_EXIT case.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/signal.c~1_DS_KILL_EXIT_CHECK	2008-05-31 13:44:08.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-05-31 14:54:32.000000000 +0400
@@ -454,8 +454,7 @@ int dequeue_signal(struct task_struct *t
 		 * is to alert stop-signal processing code when another
 		 * processor has come along and cleared the flag.
 		 */
-		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
-			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
+		tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*

