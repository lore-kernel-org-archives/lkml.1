Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYCCHWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYCCHWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYCCHVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:21:53 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46528 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYCCHVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:21:53 -0500
Date: Mon, 3 Mar 2008 10:21:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] introduce ptrace_reparented() helper
Message-ID: <20080303072123.GA25282@tv-sign.ru>
References: <20080303041751.GA18914@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303041751.GA18914@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow the patch I sent misses the change in ptrace.c, it can use the
new helper too.


[PATCH 2/2] introduce ptrace_reparented() helper

Add another trivial helper for the sake of grep. It also auto-documents the
fact that ->parent != real_parent implies ->ptrace.

No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/ptrace.h~5_PR	2008-02-17 23:40:09.000000000 +0300
+++ 25/include/linux/ptrace.h	2008-03-03 06:22:15.000000000 +0300
@@ -98,6 +98,10 @@ extern void ptrace_untrace(struct task_s
 extern int ptrace_may_attach(struct task_struct *task);
 extern int __ptrace_may_attach(struct task_struct *task);
 
+static inline int ptrace_reparented(struct task_struct *child)
+{
+	return child->real_parent != child->parent;
+}
 static inline void ptrace_link(struct task_struct *child,
 			       struct task_struct *new_parent)
 {
--- 25/kernel/exit.c~5_PR	2008-03-03 05:43:17.000000000 +0300
+++ 25/kernel/exit.c	2008-03-03 06:24:56.000000000 +0300
@@ -629,7 +629,7 @@ reparent_thread(struct task_struct *p, s
 	if (unlikely(traced)) {
 		/* Preserve ptrace links if someone else is tracing this child.  */
 		list_del_init(&p->ptrace_list);
-		if (p->parent != p->real_parent)
+		if (ptrace_reparented(p))
 			list_add(&p->ptrace_list, &p->real_parent->ptrace_children);
 	} else {
 		/* If this child is being traced, then we're the one tracing it
@@ -796,8 +796,8 @@ static void exit_notify(struct task_stru
 	 * only has special meaning to our real parent.
 	 */
 	if (!task_detached(tsk) && thread_group_empty(tsk)) {
-		int signal = (tsk->parent == tsk->real_parent)
-				? tsk->exit_signal : SIGCHLD;
+		int signal = ptrace_reparented(tsk) ?
+				SIGCHLD : tsk->exit_signal;
 		do_notify_parent(tsk, signal);
 	} else if (tsk->ptrace) {
 		do_notify_parent(tsk, SIGCHLD);
@@ -1198,8 +1198,7 @@ static int wait_task_zombie(struct task_
 		return 0;
 	}
 
-	/* traced means p->ptrace, but not vice versa */
-	traced = (p->real_parent != p->parent);
+	traced = ptrace_reparented(p);
 
 	if (likely(!traced)) {
 		struct signal_struct *psig;
--- 25/kernel/ptrace.c~5_PR	2008-02-17 23:40:09.000000000 +0300
+++ 25/kernel/ptrace.c	2008-03-03 06:23:43.000000000 +0300
@@ -73,7 +73,7 @@ void __ptrace_unlink(struct task_struct 
 	BUG_ON(!child->ptrace);
 
 	child->ptrace = 0;
-	if (!list_empty(&child->ptrace_list)) {
+	if (ptrace_reparented(child)) {
 		list_del_init(&child->ptrace_list);
 		remove_parent(child);
 		child->parent = child->real_parent;

