Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbXLASiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbXLASiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXLASiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:38:46 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46541 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXLASip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:38:45 -0500
Date: Sat, 1 Dec 2007 21:39:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] __group_complete_signal: fix coredump with group stop race
Message-ID: <20071201183902.GA19210@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __group_complete_signal() sees sig_kernel_coredump() signal, it starts
the group stop, but sets ->group_exit_task = t in a hope that "t" will actually
dequeue this signal and invoke do_coredump(). However, by the time "t" enters
get_signal_to_deliver() it is possible that the signal was blocked/ignored or
we have another pending !SIG_KERNEL_COREDUMP_MASK signal which will be dequeued
first. This means the task could be stopped but not killed.

Remove this code from __group_complete_signal(). Note also this patch removes
the bogus signal_wake_up(t, 1). This thread can't be STOPPED/TRACED, note the
corresponding check in wants_signal().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/signal.c~1_CDUMP_STOP	2007-11-22 20:29:11.000000000 +0300
+++ PT/kernel/signal.c	2007-12-01 20:50:27.000000000 +0300
@@ -911,27 +911,6 @@ __group_complete_signal(int sig, struct 
 			} while_each_thread(p, t);
 			return;
 		}
-
-		/*
-		 * There will be a core dump.  We make all threads other
-		 * than the chosen one go into a group stop so that nothing
-		 * happens until it gets scheduled, takes the signal off
-		 * the shared queue, and does the core dump.  This is a
-		 * little more complicated than strictly necessary, but it
-		 * keeps the signal state that winds up in the core dump
-		 * unchanged from the death state, e.g. which thread had
-		 * the core-dump signal unblocked.
-		 */
-		rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
-		p->signal->group_stop_count = 0;
-		p->signal->group_exit_task = t;
-		p = t;
-		do {
-			p->signal->group_stop_count++;
-			signal_wake_up(t, t == p);
-		} while_each_thread(p, t);
-		return;
 	}
 
 	/*
@@ -1757,15 +1736,6 @@ static int handle_group_stop(void)
 {
 	int stop_count;
 
-	if (current->signal->group_exit_task == current) {
-		/*
-		 * Group stop is so we can do a core dump,
-		 * We are the initiating thread, so get on with it.
-		 */
-		current->signal->group_exit_task = NULL;
-		return 0;
-	}
-
 	if (current->signal->flags & SIGNAL_GROUP_EXIT)
 		/*
 		 * Group stop is so another thread can do a core dump,

