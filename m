Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbYBLKZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbYBLKZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761088AbYBLKYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:24:51 -0500
Received: from sacred.ru ([62.205.161.221]:59365 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761019AbYBLKYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:24:50 -0500
Message-ID: <47B17366.4020605@openvz.org>
Date: Tue, 12 Feb 2008 13:22:30 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 2/3] Turn LEGACY_QUEUE macro into static inline function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 12 Feb 2008 13:22:19 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the code more readable, due to less brackets and
small letters in name.

I also move it above the send_signal() as a preparation for
the 3rd patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/signal.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 21d4751..384d188 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -657,6 +657,11 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 	}
 }
 
+static inline int legacy_queue(struct sigpending *signals, int sig)
+{
+	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
+}
+
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
@@ -721,9 +726,6 @@ out_set:
 	return 0;
 }
 
-#define LEGACY_QUEUE(sigptr, sig) \
-	(((sig) < SIGRTMIN) && sigismember(&(sigptr)->signal, (sig)))
-
 int print_fatal_signals;
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
@@ -771,7 +773,7 @@ specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	/* Support queueing exactly one non-rt signal, so that we
 	   can get more detailed information about the cause of
 	   the signal. */
-	if (LEGACY_QUEUE(&t->pending, sig))
+	if (legacy_queue(&t->pending, sig))
 		goto out;
 
 	ret = send_signal(sig, info, t, &t->pending);
@@ -932,7 +934,7 @@ __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 	if (sig_ignored(p, sig))
 		return ret;
 
-	if (LEGACY_QUEUE(&p->signal->shared_pending, sig))
+	if (legacy_queue(&p->signal->shared_pending, sig))
 		/* This is a non-RT signal and we already have one queued.  */
 		return ret;
 
-- 
1.5.3.4


