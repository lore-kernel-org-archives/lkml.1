Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYCLMd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYCLMd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYCLMdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:33:50 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39752 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYCLMdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:33:49 -0400
Date: Wed, 12 Mar 2008 15:33:11 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] signals: fold sig_ignored() into handle_stop_signal()
Message-ID: <20080312123311.GA13478@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename handle_stop_signal() to prepare_signal(), make it return a boolean, and
move the callsites of sig_ignored() into it.

No functional changes for now. But it would be nice to factor out the "should
we drop this signal" checks as much as possible, before we try to fix the bugs
with the sub-namespace init's signals (actually the global /sbin/init has some
problems with signals too).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~1_HSS_PREPARE_SIGNAL	2008-03-12 11:42:31.000000000 +0300
+++ 25/kernel/signal.c	2008-03-12 12:58:39.000000000 +0300
@@ -564,18 +564,16 @@ static void do_notify_parent_cldstop(str
  * actual continuing for SIGCONT, but not the actual stopping for stop
  * signals.  The process stop is done as a signal action for SIG_DFL.
  */
-static void handle_stop_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (signal->flags & SIGNAL_GROUP_EXIT)
+	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT)) {
 		/*
-		 * The process is in the middle of dying already.
+		 * The process is in the middle of dying, nothing to do.
 		 */
-		return;
-
-	if (sig_kernel_stop(sig)) {
+	} else if (sig_kernel_stop(sig)) {
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
@@ -644,6 +642,8 @@ static void handle_stop_signal(int sig, 
 			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	}
+
+	return !sig_ignored(p, sig);
 }
 
 /*
@@ -753,7 +753,8 @@ static int send_signal(int sig, struct s
 	struct sigqueue *q;
 
 	assert_spin_locked(&t->sighand->siglock);
-	handle_stop_signal(sig, t);
+	if (!prepare_signal(sig, t))
+		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
@@ -761,7 +762,7 @@ static int send_signal(int sig, struct s
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (sig_ignored(t, sig) || legacy_queue(pending, sig))
+	if (legacy_queue(pending, sig))
 		return 0;
 
 	/*
@@ -1247,10 +1248,8 @@ int send_sigqueue(struct sigqueue *q, st
 	if (!likely(lock_task_sighand(t, &flags)))
 		goto ret;
 
-	handle_stop_signal(sig, t);
-
-	ret = 1;
-	if (sig_ignored(t, sig))
+	ret = 1; /* the signal is ignored */
+	if (!prepare_signal(sig, t))
 		goto out;
 
 	ret = 0;

