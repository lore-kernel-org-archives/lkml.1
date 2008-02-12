Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbYBLK2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbYBLK2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbYBLK2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:28:34 -0500
Received: from sacred.ru ([62.205.161.221]:48853 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbYBLK2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:28:33 -0500
Message-ID: <47B17419.4080303@openvz.org>
Date: Tue, 12 Feb 2008 13:25:29 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 3/3] Consolidate checking for ignored/legacy signals
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 12 Feb 2008 13:25:18 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two callers for send_signal() - the specific_send_sig_info and 
the __group_send_sig_info - both check for sig to be ignored or
already queued.

Move these checks into send_signal() and make it return 1 to
indicate that the signal is dropped, but there's no error in
this.

Besides, merge comments and spell-check them.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/signal.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 384d188..f98ec5f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -668,6 +668,14 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	struct sigqueue * q = NULL;
 
 	/*
+	 * Short-circuit ignored signals and support queuing
+	 * exactly one non-rt signal, so that we can get more
+	 * detailed information about the cause of the signal.
+	 */
+	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
+		return 1;
+
+	/*
 	 * Deliver the signal to listening signalfds. This must be called
 	 * with the sighand lock held.
 	 */
@@ -766,21 +774,13 @@ specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	BUG_ON(!irqs_disabled());
 	assert_spin_locked(&t->sighand->siglock);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(t, sig))
-		goto out;
-
-	/* Support queueing exactly one non-rt signal, so that we
-	   can get more detailed information about the cause of
-	   the signal. */
-	if (legacy_queue(&t->pending, sig))
-		goto out;
-
 	ret = send_signal(sig, info, t, &t->pending);
+	if (ret < 0)
+		return ret;
+
 	if (!ret && !sigismember(&t->blocked, sig))
 		signal_wake_up(t, sig == SIGKILL);
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -930,24 +930,17 @@ __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 	assert_spin_locked(&p->sighand->siglock);
 	handle_stop_signal(sig, p);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(p, sig))
-		return ret;
-
-	if (legacy_queue(&p->signal->shared_pending, sig))
-		/* This is a non-RT signal and we already have one queued.  */
-		return ret;
-
 	/*
 	 * Put this signal on the shared-pending queue, or fail with EAGAIN.
 	 * We always use the shared queue for process-wide signals,
 	 * to avoid several races.
 	 */
 	ret = send_signal(sig, info, p, &p->signal->shared_pending);
-	if (unlikely(ret))
+	if (unlikely(ret < 0))
 		return ret;
 
-	__group_complete_signal(sig, p);
+	if (!ret)
+		__group_complete_signal(sig, p);
 	return 0;
 }
 
-- 
1.5.3.4

