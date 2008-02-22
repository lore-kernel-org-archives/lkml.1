Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbYBVMva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbYBVMva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYBVMvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:51:17 -0500
Received: from sacred.ru ([62.205.161.221]:45858 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbYBVMvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:51:15 -0500
Message-ID: <47BEC537.3020103@openvz.org>
Date: Fri, 22 Feb 2008 15:51:03 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 2/3] Clean dequeue_signal from excess checks and assignments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 22 Feb 2008 15:50:51 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The signr variable may be declared without initialization - 
it is set ro the return value from __dequeue_signal() right 
at the function beginning.

Besides, after recalc_sigpending() two checks for signr to
be not 0 may be merged into one. Both if-s become easier
to read.

Thanks to Oleg for pointing out mistakes in the first version
of this patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/signal.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c32f990..8b1b404 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -377,7 +377,7 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
  */
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
-	int signr = 0;
+	int signr;
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
@@ -410,8 +410,12 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 			}
 		}
 	}
+
 	recalc_sigpending();
-	if (signr && unlikely(sig_kernel_stop(signr))) {
+	if (!signr)
+		return 0;
+
+	if (unlikely(sig_kernel_stop(signr))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our
 		 * caller might release the siglock and then the pending
@@ -427,9 +431,7 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
 			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
-	if (signr &&
-	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
-	     info->si_sys_private){
+	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
 		 * Release the siglock to ensure proper locking order
 		 * of timer locks outside of siglocks.  Note, we leave
-- 
1.5.3.4

