Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYHCRps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYHCRps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYHCRpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:45:40 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33165 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYHCRpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:45:39 -0400
Date: Sun, 3 Aug 2008 21:49:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] posix-timers: simplify de_thread()->exit_itimers() path
Message-ID: <20080803174911.GA4919@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

de_thread() postpones release_task(leader) until after exit_itimers().
This was needed because !SIGEV_THREAD_ID timers could use ->group_leader
without get_task_struct(). With the recent changes we can release the
leader earlier and simplify the code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/fs/exec.c~3_DE_THREAD	2008-08-03 17:16:40.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-08-03 21:35:33.000000000 +0400
@@ -757,7 +757,6 @@ static int de_thread(struct task_struct 
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
-	struct task_struct *leader = NULL;
 	int count;
 
 	if (thread_group_empty(tsk))
@@ -795,7 +794,7 @@ static int de_thread(struct task_struct 
 	 * and to assume its PID:
 	 */
 	if (!thread_group_leader(tsk)) {
-		leader = tsk->group_leader;
+		struct task_struct *leader = tsk->group_leader;
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
@@ -849,8 +848,9 @@ static int de_thread(struct task_struct 
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
 		leader->exit_state = EXIT_DEAD;
-
 		write_unlock_irq(&tasklist_lock);
+
+		release_task(leader);
 	}
 
 	sig->group_exit_task = NULL;
@@ -859,8 +859,6 @@ static int de_thread(struct task_struct 
 no_thread_group:
 	exit_itimers(sig);
 	flush_itimer_signals();
-	if (leader)
-		release_task(leader);
 
 	if (atomic_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;

