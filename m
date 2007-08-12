Return-Path: <linux-kernel-owner+w=401wt.eu-S936115AbXHLRES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936115AbXHLRES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936337AbXHLRD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:03:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52892 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763303AbXHLRD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:03:26 -0400
Date: Sun, 12 Aug 2007 21:05:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 4/4] signalfd: make it group-wide, fix posix-timers scheduling
Message-ID: <20070812170533.GA4305@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Untested, user visible change.

With this patch any thread can dequeue its own private signals via signalfd,
even if it was created by another sub-thread.

To do so, we pass "current" to dequeue_signal() if the caller is from the same
thread group. This also fixes the scheduling of posix timers broken by the
previous patch.

If the caller doesn't belong to this thread group, we can't handle __SI_TIMER
case properly anyway. Perhaps we should forbid the cross-process signalfd usage
and convert ctx->tsk to ctx->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/fs/signalfd.c~4_GROUP	2007-08-09 19:59:27.000000000 +0400
+++ t/fs/signalfd.c	2007-08-12 20:21:23.000000000 +0400
@@ -209,6 +209,15 @@ static int signalfd_copyinfo(struct sign
 	return err ? -EFAULT: sizeof(*uinfo);
 }
 
+static int
+__signalfd_dequeue(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+{
+	if (tsk->tgid == current->tgid)
+		tsk = current;
+
+	return dequeue_signal(tsk, mask, info);
+}
+
 static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 				int nonblock)
 {
@@ -219,7 +228,7 @@ static ssize_t signalfd_dequeue(struct s
 	if (!signalfd_lock(ctx, &lk))
 		return 0;
 
-	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+	ret = __signalfd_dequeue(lk.tsk, &ctx->sigmask, info);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -233,7 +242,7 @@ static ssize_t signalfd_dequeue(struct s
 	add_wait_queue(&ctx->wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+		ret = __signalfd_dequeue(lk.tsk, &ctx->sigmask, info);
 		signalfd_unlock(&lk);
 		if (ret != 0)
 			break;
@@ -331,7 +340,7 @@ asmlinkage long sys_signalfd(int ufd, si
 
 		init_waitqueue_head(&ctx->wqh);
 		ctx->sigmask = sigmask;
-		ctx->tsk = current;
+		ctx->tsk = current->group_leader;
 
 		sighand = current->sighand;
 		/*

