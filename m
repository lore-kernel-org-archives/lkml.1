Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbYCDSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbYCDSzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932648AbYCDSyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:54:03 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40640 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639AbYCDSx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:53:59 -0500
Date: Tue, 4 Mar 2008 21:57:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] handle_stop_signal: unify partial/full stop handling
Message-ID: <20080304185746.GA8485@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of "[RFC,PATCH 1/2] signals: re-assign CLD_CONTINUED notification from the sender to reciever")

Now that handle_stop_signal() doesn't drop ->siglock, we can't see both
->group_stop_count && SIGNAL_STOP_STOPPED. Merge two "if" branches.

As Roland pointed out, we never actually needed 2 do_notify_parent_cldstop()
calls.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~2_HSS_SIMPLIFY	2008-03-03 17:06:53.000000000 +0300
+++ 25/kernel/signal.c	2008-03-03 17:08:31.000000000 +0300
@@ -578,33 +578,16 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 	} else if (sig == SIGCONT) {
+		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		if (unlikely(p->signal->group_stop_count > 0)) {
-			/*
-			 * There was a group stop in progress.  We'll
-			 * pretend it finished before we got here.  We are
-			 * obliged to report it to the parent: if the
-			 * SIGSTOP happened "after" this SIGCONT, then it
-			 * would have cleared this pending SIGCONT.  If it
-			 * happened "before" this SIGCONT, then the parent
-			 * got the SIGCHLD about the stop finishing before
-			 * the continue happened.  We do the notification
-			 * now, and it's as if the stop had finished and
-			 * the SIGCHLD was pending on entry to this kill.
-			 */
-			p->signal->group_stop_count = 0;
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_STOPPED;
-		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			
 			/*
 			 * If there is a handler for SIGCONT, we must make
 			 * sure that no thread returns to user mode before
@@ -614,7 +597,7 @@ static void handle_stop_signal(int sig, 
 			 * running the handler.  With the TIF_SIGPENDING
 			 * flag set, the thread will pause and acquire the
 			 * siglock that we hold now and until we've queued
-			 * the pending signal. 
+			 * the pending signal.
 			 *
 			 * Wake up the stopped thread _after_ setting
 			 * TIF_SIGPENDING
@@ -629,13 +612,23 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 
-		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
-			/*
-			 * We were in fact stopped, and are now continued.
-			 * Notify the parent with CLD_CONTINUED.
-			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_CONTINUED;
+		/*
+		 * Notify the parent with CLD_CONTINUED if we were stopped.
+		 *
+		 * If we were in the middle of a group stop, we pretend it
+		 * was already finished, and then continued. Since SIGCHLD
+		 * doesn't queue we report only CLD_STOPPED, as if the next
+		 * CLD_CONTINUED was dropped.
+		 */
+		why = 0;
+		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+			why |= SIGNAL_CLD_CONTINUED;
+		else if (p->signal->group_stop_count)
+			why |= SIGNAL_CLD_STOPPED;
+
+		if (why) {
+			p->signal->flags = why | SIGNAL_STOP_CONTINUED;
+			p->signal->group_stop_count = 0;
 			p->signal->group_exit_code = 0;
 		} else {
 			/*

