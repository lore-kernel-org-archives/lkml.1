Return-Path: <linux-kernel-owner+w=401wt.eu-S1764371AbYCDSy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764371AbYCDSy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbYCDSyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:54:01 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40641 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932637AbYCDSx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:53:59 -0500
Date: Tue, 4 Mar 2008 21:57:47 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] handle_stop_signal: use the cached p->signal value
Message-ID: <20080304185747.GA8488@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the value of p->signal, and change the code to use while_each_thread()
helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~3_HSS_CACHE_SIGNAL	2008-03-03 17:08:31.000000000 +0300
+++ 25/kernel/signal.c	2008-03-04 21:10:22.000000000 +0300
@@ -559,9 +559,10 @@ static void do_notify_parent_cldstop(str
  */
 static void handle_stop_signal(int sig, struct task_struct *p)
 {
+	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (p->signal->flags & SIGNAL_GROUP_EXIT)
+	if (signal->flags & SIGNAL_GROUP_EXIT)
 		/*
 		 * The process is in the middle of dying already.
 		 */
@@ -571,19 +572,18 @@ static void handle_stop_signal(int sig, 
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
-		rm_from_queue(sigmask(SIGCONT), &p->signal->shared_pending);
+		rm_from_queue(sigmask(SIGCONT), &signal->shared_pending);
 		t = p;
 		do {
 			rm_from_queue(sigmask(SIGCONT), &t->pending);
-			t = next_thread(t);
-		} while (t != p);
+		} while_each_thread(p, t);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
+		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
@@ -608,9 +608,7 @@ static void handle_stop_signal(int sig, 
 				state |= TASK_INTERRUPTIBLE;
 			}
 			wake_up_state(t, state);
-
-			t = next_thread(t);
-		} while (t != p);
+		} while_each_thread(p, t);
 
 		/*
 		 * Notify the parent with CLD_CONTINUED if we were stopped.
@@ -621,29 +619,29 @@ static void handle_stop_signal(int sig, 
 		 * CLD_CONTINUED was dropped.
 		 */
 		why = 0;
-		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+		if (signal->flags & SIGNAL_STOP_STOPPED)
 			why |= SIGNAL_CLD_CONTINUED;
-		else if (p->signal->group_stop_count)
+		else if (signal->group_stop_count)
 			why |= SIGNAL_CLD_STOPPED;
 
 		if (why) {
-			p->signal->flags = why | SIGNAL_STOP_CONTINUED;
-			p->signal->group_stop_count = 0;
-			p->signal->group_exit_code = 0;
+			signal->flags = why | SIGNAL_STOP_CONTINUED;
+			signal->group_stop_count = 0;
+			signal->group_exit_code = 0;
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
 			 * signal in the middle of being processed after
 			 * being removed from the queue.  Clear that too.
 			 */
-			p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
+			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	} else if (sig == SIGKILL) {
 		/*
 		 * Make sure that any pending stop signal already dequeued
 		 * is undone by the wakeup for SIGKILL.
 		 */
-		p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
+		signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 	}
 }
 

