Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbYCEWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbYCEWn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYCEWns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:43:48 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:54931 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbYCEWnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:43:47 -0500
Date: Thu, 6 Mar 2008 01:43:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] __group_complete_signal: cache the value of p->signal
Message-ID: <20080305224320.GA6342@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic, cache p->signal to make the code a bit more readable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~3_GCS_CLEANUP	2008-03-06 00:43:50.000000000 +0300
+++ 25/kernel/signal.c	2008-03-06 01:07:55.000000000 +0300
@@ -842,6 +842,7 @@ static inline int wants_signal(int sig, 
 static void
 __group_complete_signal(int sig, struct task_struct *p)
 {
+	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
 	/*
@@ -862,14 +863,14 @@ __group_complete_signal(int sig, struct 
 		/*
 		 * Otherwise try to find a suitable thread.
 		 */
-		t = p->signal->curr_target;
+		t = signal->curr_target;
 		if (t == NULL)
 			/* restart balancing at this thread */
-			t = p->signal->curr_target = p;
+			t = signal->curr_target = p;
 
 		while (!wants_signal(sig, t)) {
 			t = next_thread(t);
-			if (t == p->signal->curr_target)
+			if (t == signal->curr_target)
 				/*
 				 * No thread needs to be woken.
 				 * Any eligible threads will see
@@ -877,14 +878,14 @@ __group_complete_signal(int sig, struct 
 				 */
 				return;
 		}
-		p->signal->curr_target = t;
+		signal->curr_target = t;
 	}
 
 	/*
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) && !(p->signal->flags & SIGNAL_GROUP_EXIT) &&
+	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
 		/*
@@ -897,9 +898,9 @@ __group_complete_signal(int sig, struct 
 			 * running and doing things after a slower
 			 * thread has the fatal signal pending.
 			 */
-			p->signal->flags = SIGNAL_GROUP_EXIT;
-			p->signal->group_exit_code = sig;
-			p->signal->group_stop_count = 0;
+			signal->flags = SIGNAL_GROUP_EXIT;
+			signal->group_exit_code = sig;
+			signal->group_stop_count = 0;
 			t = p;
 			do {
 				sigaddset(&t->pending.signal, SIGKILL);

