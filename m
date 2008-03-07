Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbYCGHrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbYCGHrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbYCGHqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:46:40 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46084 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759099AbYCGHqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:46:39 -0500
Date: Fri, 7 Mar 2008 10:45:43 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: move handle_stop_signal() into send_signal()
Message-ID: <20080307074543.GA6020@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move handle_stop_signal() into send_signal(). This factors out a couple of
callsites and allows us to do further unifications.

Also, with this change specific_send_sig_info() does handle_stop_signal().
Not that this is really important, we never send STOP/CONT via send_sig()
and friends, but still this looks more consistent.

The only (afaics) special case is get_signal_to_deliver(). If the traced
task dequeues SIGCONT, it can re-send it to itself after ptrace_stop() if
the signal was blocked by debugger. In that case handle_stop_signal() is
unnecessary, but hopefully not a problem.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~1_SS_TAKE_HSS	2008-03-06 02:54:27.000000000 +0300
+++ 25/kernel/signal.c	2008-03-07 08:24:35.000000000 +0300
@@ -660,8 +660,10 @@ static inline int legacy_queue(struct si
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
-	struct sigqueue * q = NULL;
+	struct sigqueue *q;
 
+	assert_spin_locked(&t->sighand->siglock);
+	handle_stop_signal(sig, t);
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
@@ -766,9 +768,6 @@ specific_send_sig_info(int sig, struct s
 {
 	int ret;
 
-	BUG_ON(!irqs_disabled());
-	assert_spin_locked(&t->sighand->siglock);
-
 	ret = send_signal(sig, info, t, &t->pending);
 	if (ret <= 0)
 		return ret;
@@ -924,9 +923,6 @@ __group_send_sig_info(int sig, struct si
 {
 	int ret;
 
-	assert_spin_locked(&p->sighand->siglock);
-	handle_stop_signal(sig, p);
-
 	/*
 	 * Put this signal on the shared-pending queue, or fail with EAGAIN.
 	 * We always use the shared queue for process-wide signals,
@@ -2217,7 +2213,6 @@ static int do_tkill(int tgid, int pid, i
 		 */
 		if (!error && sig && p->sighand) {
 			spin_lock_irq(&p->sighand->siglock);
-			handle_stop_signal(sig, p);
 			error = specific_send_sig_info(sig, &info, p);
 			spin_unlock_irq(&p->sighand->siglock);
 		}

