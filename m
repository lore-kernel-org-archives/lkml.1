Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYCISze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYCISze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYCISz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:55:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50565 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYCISz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:55:26 -0400
Date: Sun, 9 Mar 2008 21:59:26 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/6] signals: send_signal: factor out SIGNAL_GROUP_EXIT checks
Message-ID: <20080309185926.GA5649@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The signal has no effect (but can provoke the unnecessary wakeup) if the
thread group is dying. Let's make this explicit and check SIGNAL_GROUP_EXIT
only once in handle_stop_signal() renamed to prepare_signal().

>From now the actual signal-delivery path doesn't need to take the special
SIGNAL_GROUP_EXIT case into account.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~8_SS_CK_SGE	2008-03-09 20:21:02.000000000 +0300
+++ 25/kernel/signal.c	2008-03-09 21:18:19.000000000 +0300
@@ -564,16 +564,16 @@ static void do_notify_parent_cldstop(str
  * actual continuing for SIGCONT, but not the actual stopping for stop
  * signals.  The process stop is done as a signal action for SIG_DFL.
  */
-static void handle_stop_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (signal->flags & SIGNAL_GROUP_EXIT)
+	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT))
 		/*
 		 * The process is in the middle of dying already.
 		 */
-		return;
+		return 0;
 
 	if (sig_kernel_stop(sig)) {
 		/*
@@ -644,6 +644,8 @@ static void handle_stop_signal(int sig, 
 			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	}
+
+	return 1;
 }
 
 /*
@@ -708,8 +710,7 @@ static void complete_signal(int sig, str
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
-	    !sigismember(&t->real_blocked, sig) &&
+	if (sig_fatal(p, sig) && !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
 		/*
 		 * This signal will be fatal to the whole group.
@@ -753,7 +754,8 @@ static int send_signal(int sig, struct s
 	struct sigqueue *q;
 
 	assert_spin_locked(&t->sighand->siglock);
-	handle_stop_signal(sig, t);
+	if (!likely(prepare_signal(sig, t)))
+		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
@@ -1247,9 +1249,10 @@ int send_sigqueue(struct sigqueue *q, st
 	if (!likely(lock_task_sighand(t, &flags)))
 		goto ret;
 
-	handle_stop_signal(sig, t);
-
 	ret = 1;
+	if (!likely(prepare_signal(sig, t)))
+		goto out;
+
 	if (sig_ignored(t, sig))
 		goto out;
 

