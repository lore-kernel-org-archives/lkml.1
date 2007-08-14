Return-Path: <linux-kernel-owner+w=401wt.eu-S934526AbXHNS51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbXHNS51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbXHNS47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:56:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35387 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbXHNS45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:56:57 -0400
Date: Tue, 14 Aug 2007 22:56:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 4/4] signalfd: make it group-wide, fix posix-timers scheduling
Message-ID: <20070814185605.GA136@tv-sign.ru>
References: <20070812170533.GA4305@tv-sign.ru> <20070813191407.GA816@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813191407.GA816@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Oleg Nesterov wrote:
>
> Sorry, the patch is not complete. I forgot about signalfd_poll() and somehow I
> forgot to actually tweak de_thread(). I'll send a new one tomorrow.
> 
> Something should be done for 2.6.23, imho.

Slightly tested. This all needs furher cleanups (for example,
__exit_signal()->signalfd_detach_locked() is not needed unless we are
group_leader), but this code be done later.



[PATCH 4/4] signalfd: make it group-wide, fix posix-timers scheduling

With this patch any thread can dequeue its own private signals via signalfd,
even if it was created by another sub-thread.

To do so, we use "current" instead of ctx->tsk if the caller is from the same
thread group. This also fixes the scheduling of posix timers broken by the
previous patch.

If the caller doesn't belong to this thread group, we can't handle __SI_TIMER
case properly anyway. Perhaps we should forbid the cross-process signalfd usage
and convert ctx->tsk to ctx->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/fs/signalfd.c~4_GROUP	2007-08-09 19:59:27.000000000 +0400
+++ t/fs/signalfd.c	2007-08-14 21:26:31.000000000 +0400
@@ -56,12 +56,18 @@ static int signalfd_lock(struct signalfd
 		sighand = lock_task_sighand(lk->tsk, &lk->flags);
 	rcu_read_unlock();
 
-	if (sighand && !ctx->tsk) {
+	if (!sighand)
+		return 0;
+
+	if (!ctx->tsk) {
 		unlock_task_sighand(lk->tsk, &lk->flags);
-		sighand = NULL;
+		return 0;
 	}
 
-	return sighand != NULL;
+	if (lk->tsk->tgid == current->tgid)
+		lk->tsk = current;
+
+	return 1;
 }
 
 static void signalfd_unlock(struct signalfd_lockctx *lk)
@@ -331,7 +337,7 @@ asmlinkage long sys_signalfd(int ufd, si
 
 		init_waitqueue_head(&ctx->wqh);
 		ctx->sigmask = sigmask;
-		ctx->tsk = current;
+		ctx->tsk = current->group_leader;
 
 		sighand = current->sighand;
 		/*
--- t/fs/exec.c~4_GROUP	2007-07-28 16:58:16.000000000 +0400
+++ t/fs/exec.c	2007-08-13 21:05:34.000000000 +0400
@@ -780,18 +780,12 @@ static int de_thread(struct task_struct 
 	int count;
 
 	/*
-	 * Tell all the sighand listeners that this sighand has
-	 * been detached. The signalfd_detach() function grabs the
-	 * sighand lock, if signal listeners are present on the sighand.
-	 */
-	signalfd_detach(tsk);
-
-	/*
 	 * If we don't share sighandlers, then we aren't sharing anything
 	 * and we can just re-use it all.
 	 */
 	if (atomic_read(&oldsighand->count) <= 1) {
 		BUG_ON(atomic_read(&sig->count) != 1);
+		signalfd_detach(tsk);
 		exit_itimers(sig);
 		return 0;
 	}
@@ -930,6 +924,7 @@ static int de_thread(struct task_struct 
 	sig->flags = 0;
 
 no_thread_group:
+	signalfd_detach(tsk);
 	exit_itimers(sig);
 	if (leader)
 		release_task(leader);

