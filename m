Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXHWWa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXHWWa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932593AbXHWW2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50691 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbXHWW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:17 -0400
Date: Thu, 23 Aug 2007 15:26:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtk-manpages@gmx.net,
       benh@kernel.crashing.org, oleg@tv-sign.ru, tglx@linutronix.de,
       davidel@xmailserver.org, mingo@elte.hu, roland@redhat.com
Subject: [patch 07/28] signalfd: make it group-wide, fix posix-timers
	scheduling
Message-ID: <20070823222623.GH18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@tv-sign.ru>

With this patch any thread can dequeue its own private signals via signalfd,
even if it was created by another sub-thread.

To do so, we pass "current" to dequeue_signal() if the caller is from the same
thread group. This also fixes the scheduling of posix timers broken by the
previous patch.

If the caller doesn't belong to this thread group, we can't handle __SI_TIMER
case properly anyway. Perhaps we should forbid the cross-process signalfd usage
and convert ctx->tsk to ctx->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c     |    9 ++-------
 fs/signalfd.c |   14 ++++++++++----
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -586,18 +586,12 @@ static int de_thread(struct task_struct 
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
@@ -736,6 +730,7 @@ static int de_thread(struct task_struct 
 	sig->flags = 0;
 
 no_thread_group:
+	signalfd_detach(tsk);
 	exit_itimers(sig);
 	if (leader)
 		release_task(leader);
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
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

-- 
