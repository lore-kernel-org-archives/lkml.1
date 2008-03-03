Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYCCFMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYCCFMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 00:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYCCFMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 00:12:37 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:41383 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYCCFMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 00:12:37 -0500
Date: Mon, 3 Mar 2008 08:11:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] introduce task_detached() helper
Message-ID: <20080303051138.GA23635@tv-sign.ru>
References: <20080303041749.GA18911@tv-sign.ru> <20080303043749.GA13040@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303043749.GA13040@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Christoph Hellwig wrote:
>
> On Mon, Mar 03, 2008 at 07:17:49AM +0300, Oleg Nesterov wrote:
> > +#define	task_detached(p) ((p)->exit_signal == -1)
>
> Why is this a macro, no inline?

Well, it is so trivial... OK, let it be inline. exit.o is not the same,
but hopefully it is still correct ;)


[PATCH 1/2] introduce task_detached() helper

exit.c has numerous "->exit_signal == -1" comparisons, this check is subtle and
deserves a helper. Imho makes the code more parseable for humans. At least it's
surely more greppable.

Also, a couple of whitespace cleanups. No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~4_TD_INLINE	2008-03-03 07:54:23.000000000 +0300
+++ 25/kernel/exit.c	2008-03-03 08:02:50.000000000 +0300
@@ -52,6 +52,11 @@
 
 static void exit_mm(struct task_struct * tsk);
 
+static inline int task_detached(struct task_struct *p)
+{
+	return p->exit_signal == -1;
+}
+
 static void __unhash_process(struct task_struct *p)
 {
 	nr_threads--;
@@ -160,7 +165,7 @@ repeat:
 	zap_leader = 0;
 	leader = p->group_leader;
 	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
-		BUG_ON(leader->exit_signal == -1);
+		BUG_ON(task_detached(leader));
 		do_notify_parent(leader, leader->exit_signal);
 		/*
 		 * If we were the last child thread and the leader has
@@ -170,7 +175,7 @@ repeat:
 		 * do_notify_parent() will have marked it self-reaping in
 		 * that case.
 		 */
-		zap_leader = (leader->exit_signal == -1);
+		zap_leader = task_detached(leader);
 	}
 
 	write_unlock_irq(&tasklist_lock);
@@ -655,14 +660,14 @@ reparent_thread(struct task_struct *p, s
 		return;
 
 	/* We don't want people slaying init.  */
-	if (p->exit_signal != -1)
+	if (!task_detached(p))
 		p->exit_signal = SIGCHLD;
 
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
 	if (!traced && p->exit_state == EXIT_ZOMBIE &&
-	    p->exit_signal != -1 && thread_group_empty(p))
+	    !task_detached(p) && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
 	kill_orphaned_pgrp(p, father);
@@ -715,18 +720,18 @@ static void forget_original_parent(struc
 		} else {
 			/* reparent ptraced task to its real parent */
 			__ptrace_unlink (p);
-			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
+			if (p->exit_state == EXIT_ZOMBIE && !task_detached(p) &&
 			    thread_group_empty(p))
 				do_notify_parent(p, p->exit_signal);
 		}
 
 		/*
-		 * if the ptraced child is a zombie with exit_signal == -1
-		 * we must collect it before we exit, or it will remain
-		 * zombie forever since we prevented it from self-reap itself
-		 * while it was being traced by us, to be able to see it in wait4.
+		 * if the ptraced child is a detached zombie we must collect
+		 * it before we exit, or it will remain zombie forever since
+		 * we prevented it from self-reap itself while it was being
+		 * traced by us, to be able to see it in wait4.
 		 */
-		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
+		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && task_detached(p)))
 			list_add(&p->ptrace_list, &ptrace_dead);
 	}
 
@@ -783,26 +788,26 @@ static void exit_notify(struct task_stru
 	 * we have changed execution domain as these two values started
 	 * the same after a fork.
 	 */
-	if (tsk->exit_signal != SIGCHLD && tsk->exit_signal != -1 &&
+	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
 	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
-	     tsk->self_exec_id != tsk->parent_exec_id)
-	    && !capable(CAP_KILL))
+	     tsk->self_exec_id != tsk->parent_exec_id) &&
+	    !capable(CAP_KILL))
 		tsk->exit_signal = SIGCHLD;
 
-
 	/* If something other than our normal parent is ptracing us, then
 	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
 	 * only has special meaning to our real parent.
 	 */
-	if (tsk->exit_signal != -1 && thread_group_empty(tsk)) {
-		int signal = tsk->parent == tsk->real_parent ? tsk->exit_signal : SIGCHLD;
+	if (!task_detached(tsk) && thread_group_empty(tsk)) {
+		int signal = (tsk->parent == tsk->real_parent)
+				? tsk->exit_signal : SIGCHLD;
 		do_notify_parent(tsk, signal);
 	} else if (tsk->ptrace) {
 		do_notify_parent(tsk, SIGCHLD);
 	}
 
 	state = EXIT_ZOMBIE;
-	if (tsk->exit_signal == -1 && likely(!tsk->ptrace))
+	if (task_detached(tsk) && likely(!tsk->ptrace))
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
@@ -1106,7 +1111,7 @@ static int eligible_child(enum pid_type 
 	 * Do not consider detached threads that are
 	 * not ptraced:
 	 */
-	if (p->exit_signal == -1 && !p->ptrace)
+	if (task_detached(p) && !p->ptrace)
 		return 0;
 
 	/* Wait for all children (clone and not) if __WALL is set;
@@ -1298,9 +1303,9 @@ static int wait_task_zombie(struct task_
 		 * If it's still not detached after that, don't release
 		 * it now.
 		 */
-		if (p->exit_signal != -1) {
+		if (!task_detached(p)) {
 			do_notify_parent(p, p->exit_signal);
-			if (p->exit_signal != -1) {
+			if (!task_detached(p)) {
 				p->exit_state = EXIT_ZOMBIE;
 				p = NULL;
 			}

